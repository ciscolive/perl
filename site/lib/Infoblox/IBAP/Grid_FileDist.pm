package Infoblox::Grid::Member::FileDistribution;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields $_return_fields_initialized %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_MODIFY_ONLY);

BEGIN {
    $_object_type = 'MemberFD';
    register_wsdl_type('ib:MemberFD','Infoblox::Grid::Member::FileDistribution');

    #
    #
    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                      'single_serialization' => 0,
                     );

    %_allowed_members =
      (
       allow_uploads           => 0,
       enable_ftp              => 0,
       enable_http             => 0,
       enable_http_acl         => 0,
       enable_tftp             => 0,
       ftp_allow_access        => 0,
       ftp_enable_file_listing => 0,
       ftp_enable_passive_mode => 0,
       ftp_login_banner        => 0,
       ftp_port                => 0,
       http_allow_access       => 0,
       name                    => 1,
       override_allow_uploads  => 0,
       tftp_allow_access       => 0,
       tftp_port               => 0,
      );

    %_searchable_fields = (
                           name => [\&ibap_o2i_string,'host_name' , 'REGEX'],
                          );

    %_return_field_overrides =
      (
       allow_uploads           => ['use_allow_uploads'],
       enable_ftp              => [],
       enable_http             => [],
       enable_http_acl         => [],
       enable_tftp             => [],
       ftp_allow_access        => [],
       ftp_enable_file_listing => [],
       ftp_enable_passive_mode => [],
       ftp_login_banner        => [],
       ftp_port                => [],
       http_allow_access       => [],
       name                    => [],
       override_allow_uploads  => [],
       tftp_allow_access       => [],
       tftp_port               => [],
      );

    %_name_mappings =
      (
       ftp_allow_access        => 'ftp_acls',
       ftp_enable_file_listing => 'enable_ftp_filelist',
       ftp_enable_passive_mode => 'enable_ftp_passive',
       ftp_login_banner        => 'ftp_banner',
       http_allow_access       => 'http_acls',
       name                    => 'grid_member',
       tftp_allow_access       => 'tftp_acls',
       override_allow_uploads  => 'use_allow_uploads',
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       'allow_uploads'       => \&ibap_i2o_boolean,
       'enable_ftp'          => \&ibap_i2o_boolean,
       'enable_ftp_filelist' => \&ibap_i2o_boolean,
       'enable_ftp_passive'  => \&ibap_i2o_boolean,
       'enable_http'         => \&ibap_i2o_boolean,
       'enable_http_acl'     => \&ibap_i2o_boolean,
       'enable_tftp'         => \&ibap_i2o_boolean,
       'ftp_acls'            => \&ibap_i2o_ac_setting,
       'grid_member'         => \&ibap_i2o_member_name,
       'http_acls'           => \&ibap_i2o_ac_setting,
       'tftp_acls'           => \&ibap_i2o_ac_setting,
       'override_allow_uploads' => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       allow_uploads           => \&ibap_o2i_boolean,
       enable_ftp              => \&ibap_o2i_boolean,
       enable_http             => \&ibap_o2i_boolean,
       enable_http_acl         => \&ibap_o2i_boolean,
       enable_tftp             => \&ibap_o2i_boolean,
       ftp_allow_access        => \&ibap_o2i_ac_setting_undef_to_empty_list,
       ftp_enable_file_listing => \&ibap_o2i_boolean,
       ftp_enable_passive_mode => \&ibap_o2i_boolean,
       ftp_login_banner        => \&ibap_o2i_string,
       ftp_port                => \&ibap_o2i_uint,
       http_allow_access       => \&ibap_o2i_ac_setting_undef_to_empty_list,
       name                    => \&ibap_o2i_member_name,
       override_allow_uploads  => \&ibap_o2i_boolean,
       tftp_allow_access       => \&ibap_o2i_ac_setting_undef_to_empty_list,
       tftp_port               => \&ibap_o2i_uint,
      );

    @_return_fields =
      (
       tField('grid_member',return_fields_member_basic_data()),
       tField('enable_tftp'),
       tField('tftp_port'),
       tField('enable_http'),
       tField('enable_http_acl'),
       tField('enable_ftp'),
       tField('ftp_port'),
       tField('enable_ftp_passive'),
       tField('enable_ftp_filelist'),
       tField('ftp_banner'),
       tField('allow_uploads'),
       tField('use_allow_uploads'),
      );

    $_return_fields_initialized = 0;
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    $self->__init_instance_constants__();

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    $self->__init_instance_constants__();

    return $self;
}

sub __init_instance_constants__
{
    my $self = shift;

    unless ($_return_fields_initialized) {
        $_return_fields_initialized = 1;

        my $tmp = Infoblox::Grid::NamedACL->__new__();
        foreach ('ftp_acls', 'http_acls', 'tftp_acls') {
            push @_return_fields, tField($_, return_fields_ac_setting($tmp->__return_fields__()));
        }
    }
}

sub __ibap_object_type__
{
    return $_object_type;
}

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'override_allow_uploads'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_allow_uploads'});
	return;
}

#
#
#

sub ftp_allow_access
{
    my $self=shift;
    return $self->ibap_accessor_ac_setting('ftp_allow_access', 0, {}, @_);
}

sub ftp_enable_file_listing
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ftp_enable_file_listing', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ftp_enable_passive_mode
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ftp_enable_passive_mode', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ftp_login_banner
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ftp_login_banner', validator => \&ibap_value_o2i_string}, @_);
}

sub ftp_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ftp_port', validator => \&ibap_value_o2i_uint}, @_);
}

sub enable_ftp
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_ftp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub allow_uploads
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_uploads', validator => \&ibap_value_o2i_boolean, use => 'override_allow_uploads', use_truefalse => 1}, @_);
}

sub http_allow_access
{
    my $self=shift;
    return $self->ibap_accessor_ac_setting('http_allow_access', 0, {}, @_);
}

sub enable_http_acl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_http_acl', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_http
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_http', validator => \&ibap_value_o2i_boolean}, @_);
}

sub tftp_allow_access
{
    my $self=shift;
    return $self->ibap_accessor_ac_setting('tftp_allow_access', 0, {}, @_);
}

sub tftp_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'tftp_port', validator => \&ibap_value_o2i_uint}, @_);
}

sub enable_tftp
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_tftp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub override_allow_uploads
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_allow_uploads', validator => \&ibap_value_o2i_boolean}, @_);
}

package Infoblox::Grid::FileDistributionDir;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields $_return_fields_initialized %_searchable_fields %_object_to_ibap %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities %_name_mappings);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'TFTPDirFile';
    register_wsdl_type('ib:TFTPDirFile','Infoblox::Grid::FileDistributionDir');

    #
    #
    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                      'single_serialization' => 0,
                     );


    %_allowed_members =
      (
       name                    => 1,
      );

    %_searchable_fields = (
                           name => [\&__o2i_name__,'directory' , 'EXACT'],
                          );

    %_name_mappings = (
					   'name' => 'directory',
					  );

    %_return_field_overrides =
      (
       name                    => ['#name'],
      );

    %_ibap_to_object =
      (
       name => \&__i2o_name__,
      );

    %_object_to_ibap =
      (
       name => \&__o2i_name__,
      );

    @_return_fields =
      (
       tField('name'),
       tField('directory'),
      );
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

#
#
#

sub __i2o_name__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if (defined $$ibap_object_ref{'directory'} && $$ibap_object_ref{'directory'}) {
        unless ($$ibap_object_ref{'directory'} =~ m/\/$/) {
            return $$ibap_object_ref{'directory'} . '/' . $$ibap_object_ref{$current};
        }
        else {
            return $$ibap_object_ref{'directory'} . $$ibap_object_ref{$current};
        }
    }
    else {
        return $$ibap_object_ref{$current};
    }
}

#
#
#
sub __o2i_name__
{
    my ($self, $session, $current, $tempref) = @_;

    my $t = $$tempref{$current};
    if ($t =~ m/\/$/) {
        #
        chop $t;
    }

    my ($last,$path);
    $t =~ s/^\/// if $t =~ m/^\//;

    my @components= split /\//, $t;

    $last = pop @components;
    $path = '/';
    if (scalar(@components) && $components[0]) {
        $path .= join ('/', @components);
    }

    my %extra_arg1;
    $extra_arg1{'field'} = 'type';
    $extra_arg1{'value'} = tString('DIRECTORY');

    my %extra_arg2;
    $extra_arg2{'field'} = 'name';
    $extra_arg2{'value'} = ibap_value_o2i_string_undef_to_empty($last);

    if ($$tempref{$current} eq '/') {
        #
        #

        $path='/';
        $extra_arg2{'value'} = ibap_value_o2i_string_undef_to_empty('.');
    }

    return (1,0,ibap_value_o2i_string_undef_to_empty($path),\%extra_arg1, \%extra_arg2);
}

#
#
#

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

package Infoblox::Grid::FileDistribution;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object %_return_field_overrides %_capabilities $_return_fields_initialized %_lazy_return_fields);
@ISA = qw ( Infoblox::IBAPBase );

BEGIN {
	$_object_type = 'GridFD';
    register_wsdl_type('ib:GridFD', 'Infoblox::Grid::FileDistribution');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members = (
                         allow_uploads        => {simple => 'bool', validator => \&ibap_value_o2i_boolean}, # Allow file uploads to Grid members 
                         backup_storage       => {simple => 'bool', validator => \&ibap_value_o2i_boolean}, # Controls whether distributed files are included in the backup (True) or not (False). Default is True.
                         current_usage        => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_uint}, # Gives the current usage in tenth of % of the allocated space. Value is an integer between 0 and 100 (or 0 - 1000 ? ) FIXME:
                         enable_anonymous_ftp => {simple => 'bool', validator => \&ibap_value_o2i_boolean}, # Enable 'anonymous' user login to FTP server 
                         global_status        => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string}, # Gives the overall status of all members. This gives the "worst" state among the status of each individual member. 
                         storage_limit        => {simple => 'asis', validator => \&ibap_value_o2i_uint}, # Maximum storage allowed on the grid, in MB (Megabytes). Valid values are [1; 10000]. Default is ???
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                      );

    %_searchable_fields = (
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                         allow_uploads        => \&ibap_i2o_boolean,
                         backup_storage       => \&ibap_i2o_boolean,
                         enable_anonymous_ftp => \&ibap_i2o_boolean,
                       );

    %_object_to_ibap = (
                         allow_uploads        => \&ibap_o2i_boolean,
                         backup_storage       => \&ibap_o2i_boolean,
                         current_usage        => \&ibap_o2i_ignore,
                         enable_anonymous_ftp => \&ibap_o2i_boolean,
                         global_status        => \&ibap_o2i_ignore,
                         storage_limit        => \&ibap_o2i_uint,
                       );

    %_return_field_overrides = (
                                allow_uploads        => [],
                                backup_storage       => [],
                                current_usage        => [],
                                enable_anonymous_ftp => [],
                                global_status        => [],
                                storage_limit        => [],
                               );



    @_return_fields = (
                       tField('allow_uploads'),
                       tField('backup_storage'),
                       tField('current_usage'),
                       tField('enable_anonymous_ftp'),
                       tField('global_status'),
                       tField('storage_limit'),
                      );
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}

sub __ibap_capabilities__
{
	my ($self,$what)=@_;
	return $_capabilities{$what};
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

	$$ibap_object_ref{'allow_uploads'} = 0 unless defined $$ibap_object_ref{'allow_uploads'};
	$$ibap_object_ref{'backup_storage'} = 0 unless defined $$ibap_object_ref{'backup_storage'};
	$$ibap_object_ref{'enable_anonymous_ftp'} = 0 unless defined $$ibap_object_ref{'enable_anonymous_ftp'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


1;

