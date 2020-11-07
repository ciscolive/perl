#!/usr/bin/perl

use strict;
use Getopt::Long;

my $src_dir;
my $dest_dir;
my $src_version;
my $dest_version;

GetOptions (
    "s|src=s" => \$src_dir ,
    "d|dest=s" => \$dest_dir ,
);

if ( not defined $src_dir or not defined $dest_dir ) {
    die "Usage: convert_modules --src <src_dir> --dest <dest_dir>";
}

=head1 NAME

 convert_modules.pl - A script for converting Infoblox Perl modules for DNSone 3.x 
                      prior to 3.2r5 into a new format to support dynamic 
                      module-loading capabilities

 This utility script converts an Infoblox Perl module set for DNSone 3.x 
 prior to 3.2r5 into a new format that provides dynamic module-loading support 
 for backwards compatability.

 Infoblox Perl modules for DNSone 3.x prior to 3.2r5 supported only one version of 
 modules in a Perl library directory. Now, DNSone 3.2r5 supports a runtime-based reloading 
 of Perl modules based on the version of code running on the contacted Infoblox appliance.
 
=head1 SYNOPSIS

 convert_modules.pl --src <src_dir> --dest <dest_dir>

 OPTIONS

   --src <dir>   
           The location of a set of installed Perl modules.  This is where 
           you unpacked the Infoblox.tar file containing Infoblox Perl modules 
           downloaded from an Infoblox appliance. 
           The contents of this directory are as follows:

                MANIFEST
                Makefile.PL
                README
                lib/
                t/

   --dest <dir>   
            The location of the converted set of Perl modules. All file names and 
            directories from the source directory remain the same. 
            Only the content of the files gets changed.

=cut

my $session_file = "$src_dir/lib/Infoblox/Session.pm";

# open the session.pm file and get the client version from it
open ( SESSION_FILE , "$session_file" ) || die "Cannot open $session_file\n";
while (<SESSION_FILE>) {
  if ( /\$client_version\s*=\s*"(\S+)"/ ) {
     $src_version = $1;
     last;
  }
}
close SESSION_FILE;

unless ( defined $src_version ) {
    die "Cannot retrieve version string from source dir $src_dir";
}

$dest_version = $src_version;

$dest_version =~ s/[^\w]/_/g;

#t directory
###########################
my $dest_t_dir = "$dest_dir/t";
mkdir ( $dest_t_dir , 0755 ) || die "Cannot create dir: $!";
&copy_file_with_version( "$src_dir/t/01_require.t" , "$dest_t_dir/01_require.t" , 1 );

#Makefile.PL
###########################
&copy_file_with_version( "$src_dir/Makefile.PL" , "$dest_dir/Makefile.PL" , 0 );

#MANIFEST
###########################
&copy_file_with_version( "$src_dir/MANIFEST" , "$dest_dir/MANIFEST" , 1 );

#README
###########################
&copy_file_with_version( "$src_dir/README" , "$dest_dir/README" , 0 );

#create lib and Infoblox directory
###########################
my $lib_dir = "$dest_dir/lib";
mkdir ( $lib_dir , 0755 ) || die "Cannot create dir: $!";

my $infoblox_dir = "$dest_dir/lib/Infoblox";
mkdir ( $infoblox_dir , 0755 ) || die "Cannot create dir: $!";

my $version_dir = "$dest_dir/lib/Infoblox/$dest_version";
mkdir ( $version_dir , 0755 ) || die "Cannot create dir: $!";

#Infoblox.pm
###########################
my $modules_to_load = '
# Modules need to be loaded
my @MODULES = qw (
          Session
          Result
          Util
          DNS
          DHCP
          RADIUS
          Cluster
          Internal
);';

my $session_overwrite = '

# we then overwrite the session handler with our own wrapper
# that can do version checking and auto reloads
package Infoblox::Session;

sub new { 

    # so try and create a session.
    my ($proto, %args) = @_;
    my $class = ref ($proto) || $proto;

    my $self = {};
	$self->{"master"} = undef;
	$self->{"username"} = undef;
	$self->{"password"} = undef;
	$self->{"timeout"} = "600";
	$self->{"statuscode"} = undef;
	$self->{"statusdetail"} = undef;
	$self->{"server_version"} = undef;
    
    my $ua = LWP::UserAgent->new( "timeout" => $self->{"timeout"} );
    if( defined $ua ) {
        $ua->conn_cache( LWP::ConnCache->new() );
        $self-> { "useragent" } = $ua;
    }
    else {
        return undef;
    }

    bless ($self, $class);
    $self->set_args (%args);
    $self->check_version();

    # now we need to get the version and check for a mismatch
    my $server_rev = $self->server_version();
    # convert the version string to something we can use
    $server_rev =~ s/[^\w]/_/g;

    if ( ! $server_rev ) {
       # we had a real problem, just return what we got so far
       return $self ;
    }

    # otherwise we can do something useful with that version
    if ( $self->status_code and $self->server_version )  {
       # we had a mismatch so we need to
       # reload the the right rev, and create a new session
       
       # the module loader will ignore anything already in @INC
       # SO undef @INC and assume everything is relative
       local %INC = ();

       # NOW we have a version string load /those/ modules
       foreach my $mname ( @MODULES ) {
          my $mod = "Infoblox/$server_rev/$mname.pm";
          require ( $mod ) ;
          my $ReturnVal = import $mod ;
       }

       # pass the original session params to a new session
       # no warnings "redefine";
       my $rev_session = Infoblox::Session->new ( %args ) ;

       # return the correct object
       return $rev_session ;

    }
    else {
       # the version is the same, 
       # we already loaded the right modules
       # everything was good, return it
       return $self
   }

   return $self ;

}

1;';

open ( INFOBLOX_PM_INFILE , "$src_dir/lib/Infoblox.pm" ) ;
open ( INFOBLOX_PM_OUTFILE, "> $dest_dir/lib/Infoblox.pm" ) ;

while ( <INFOBLOX_PM_INFILE> ) { 
    if ( /^use\s+Infoblox\:\:/ ) {
        s/use\s+Infoblox\:\:/use Infoblox\:\:$dest_version\:\:/;
    }
    elsif ( /^1;/ ){
        my $replace_string = "$modules_to_load" . "$session_overwrite";
        s/^1;/$replace_string/;
    }
    print INFOBLOX_PM_OUTFILE ;
}

close INFOBLOX_PM_INFILE ;
close INFOBLOX_PM_OUTFILE ;

# Unchanged modules:
# Result.pm, XmltBlob.pm, XmltError.pm, 
# XmltFunction.pm, XmltObject.pm, XmltParser.pm, 
# XmltRequest.pm XmltVector.pm
###########################
my @unchanged_files = ( "Result.pm" , "XmltBlob.pm", "XmltError.pm", "XmltFunction.pm",
                        "XmltObject.pm", "XmltParser.pm", "XmltRequest.pm" , "XmltVector.pm" );
foreach my $file (@unchanged_files ) {
    &copy_file_with_version( "$src_dir/lib/Infoblox/$file" , "$dest_dir/lib/Infoblox/$dest_version/$file" , 1 );
}

# Util.pm
##########################
my $version_string = "my \$client_version = \"$src_version\";";

my $util_version_string = "$version_string\nsub object_hander";

my $set_version_string = "                    
                   \$data_object->version (\$client_version);\n
                   push( \@result_array , \$data_object );";

open ( UTIL_PM_INFILE , "$src_dir/lib/Infoblox/Util.pm" ) ;
open ( UTIL_PM_OUTFILE, "> $dest_dir/lib/Infoblox/$dest_version/Util.pm" ) ;

while ( <UTIL_PM_INFILE> ) { 
    if ( /^require\s+Infoblox\:\:/ ) {
        s/require\s+Infoblox\:\:/require Infoblox\:\:$dest_version\:\:/;
    }
    elsif ( /^sub object_handler/ ){
        s/^sub object_handler/$util_version_string/;
    }
    elsif ( /push\( \@result_array , \$data_object \);/ ) {
        s/push\( \@result_array , \$data_object \);/$set_version_string/;
    }
    print UTIL_PM_OUTFILE ;
}

close UTIL_PM_INFILE ;
close UTIL_PM_OUTFILE ;

# Generated modules:
# Cluster.pm, DNS.pm, RADIUS.pm, DHCP.pm, Internal.pm
###########################
my @object_modules = ( "Cluster.pm" , "DNS.pm" , "RADIUS.pm" , "DHCP.pm" , "Internal.pm" );

my $version_function_string = '
sub __version
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ "__version" };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ "__version" } = undef;
        }
        else
        {
            $self->{ "__version" } = $value;
        }
    }
}

sub __view_function__';


foreach my $object_module ( @object_modules ) {
    open ( OBJECT_PM_INFILE , "$src_dir/lib/Infoblox/$object_module" ) ;
    open ( OBJECT_PM_OUTFILE, "> $dest_dir/lib/Infoblox/$dest_version/$object_module" ) ;

    while ( <OBJECT_PM_INFILE> ) { 
        if ( /^use\s+Infoblox\:\:/ ) {
            s/use\s+Infoblox\:\:/use Infoblox\:\:$dest_version\:\:/;
        }
        elsif ( /\$self->__type\( \".*\" \);/ ){
            s/\$self->__type\( \"(.*)\" \);/\$self->__type\( \"$1\" \);\n    \$self->__version( \"$src_version\" );\n/;
        }
        elsif( /sub __view_function__/ ) {
            s/sub __view_function__/$version_function_string/;
        }
        print OBJECT_PM_OUTFILE ;
    }

    close OBJECT_PM_INFILE ;
    close OBJECT_PM_OUTFILE ;
}


# Session.pm
###########################

my $version_check_string = '
        my $object_version = $object->__version();
        if( $client_version ne $object_version ) {
            $self->status_code( "1114" );
            $self->status_detail( "Object is incompatible with session object" );
            return 0;
        }';


my $server_version_function = '        
sub server_version
{
	my $self = shift;
	if( @_ == 0 ) {
		return $self->{ "server_version" };
	}
	else {
		my $server_version = shift;
		$self->{"server_version"} = $server_version;
	}
}
';

my $user_agent_string = '
    my $ua = LWP::UserAgent->new( "timeout" => $self->{"timeout"} );
    if( defined $ua ) {
        $ua->conn_cache( LWP::ConnCache->new() );
        $self-> { "useragent" } = $ua;
    }
    else {
        return undef;
    }
';

open ( SESSION_PM_INFILE , "$src_dir/lib/Infoblox/Session.pm" ) ;
open ( SESSION_PM_OUTFILE, "> $dest_dir/lib/Infoblox/$dest_version/Session.pm" ) ;

my $server_version_defined = 0;

while ( <SESSION_PM_INFILE> ) { 
    if ( /^use\s+LWP::UserAgent;/ ) {
        my $replace_string = "use LWP::UserAgent;\nuse LWP::ConnCache;\n";
        s/use\s+LWP::UserAgent;/$replace_string/;
    }
    if ( /^use\s+Infoblox\:\:/ ) {
        s/use\s+Infoblox\:\:/use Infoblox\:\:$dest_version\:\:/;
    }
    elsif ( /my \$xmlt_request = \$object->__add__\(\);/ ){
        my $replace_string = $version_check_string . "\n        my \$xmlt_request = \$object->__add__\(\)";
        s/my \$xmlt_request = \$object->__add__\(\)/$replace_string/;
    }
    elsif ( /my \$xmlt_request = \$object->__remove__\(\);/ ){
        my $replace_string = $version_check_string . "\n        my \$xmlt_request = \$object->__remove__\(\)";
        s/my \$xmlt_request = \$object->__remove__\(\)/$replace_string/;
    }
    elsif ( /my \$xmlt_request = \$object->__modify__\(\);/ ){
        my $replace_string = $version_check_string . "\n        my \$xmlt_request = \$object->__modify__\(\)";
        s/my \$xmlt_request = \$object->__modify__\(\)/$replace_string/;
    }
    elsif( /\$self->{\"server_version\"} = undef/ )
    {
        $server_version_defined = 1;
    }
    elsif ( /sub add/ )
    {
        if( $server_version_defined == 0 )
        {
            my $replace_string = $server_version_function . "\nsub add";
            s/sub add/$replace_string/;
        }
    }
    elsif( /\$server_version = \$feature_set_object->get_property\( \"nios_version\" \);/ )
    {
        if( $server_version_defined == 0 )
        {
            my $replace_string = '$server_version = $feature_set_object->get_property( "nios_version" );
                              $self->server_version( $server_version );
                             ';
            s/\$server_version = \$feature_set_object->get_property\( \"nios_version\" \);/$replace_string/;
        }
    }
       
    elsif( /bless \(\$self, \$class\);/ )
    {
        if( $server_version_defined == 0 )
        {
            my $replace_string = "\$self->{\"server_version\"} = undef;\n" . $user_agent_string . "\n    bless \(\$self, \$class\);";
            s/bless \(\$self, \$class\);/$replace_string/;
        }
        else
        {
            my $replace_string = $user_agent_string . "\n    bless \(\$self, \$class\);";
            s/bless \(\$self, \$class\);/$replace_string/;
        }
    } 
    print SESSION_PM_OUTFILE ;
}

close SESSION_PM_INFILE ;
close SESSION_PM_OUTFILE ;

# Platform independent copy
###########################

sub copy_file_with_version {
    my ( $src , $dst , $with_version) = @_ ;

    open ( INFILE , $src ) ;
    open ( OUTFILE, "> $dst" ) ;

    while ( <INFILE> ) { 
        if ( $with_version) {
            s/use\s+Infoblox\:\:/use Infoblox\:\:$dest_version\:\:/;
            s/require\s+Infoblox\:\:/require Infoblox\:\:$dest_version\:\:/;
            s/lib\/Infoblox\//lib\/Infoblox\/$dest_version\//;
        }
        print OUTFILE ;
    }

    close INFILE ;
    close OUTFILE ;
}
