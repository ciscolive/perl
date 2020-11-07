package Mail::Milter::Authentication::HTDocs;
use 5.20.0;
use strict;
use warnings;
use Mail::Milter::Authentication::Pragmas;
# ABSTRACT: Load and serve static files via the in-built http server.
our $VERSION = '2.20200930.2'; # VERSION



sub new {
    my ( $class ) = @_;
    my $self = {};
    bless $self, $class;
    return $self;
}


sub get_whitelist {
    my ( $self, $path ) = @_;

    my @whitelist;

    if ( opendir( my $dh, join( '/', $self->get_basedir(), $path ) ) ) {
        while ( my $file = readdir( $dh ) ) {
            next if $file =~ /^\./;
            my $full_path = join( '/', $self->get_basedir(), $path, $file );
            if ( -f $full_path ) {
                push @whitelist, join( '/', $path, $file );
            }
            if ( -d $full_path ) {
                @whitelist = ( @whitelist, @{ $self->get_whitelist( join ( '/', $path, $file ) ) } );
            }
        }
    }

    return \@whitelist;
}


sub get_basedir {
    my ( $self ) = @_;
    my $basedir = __FILE__;
    $basedir =~ s/HTDocs\.pm$/htdocs/;
    return $basedir;
}


sub get_file {
    my ( $self, $file ) = @_;

    my $whitelisted = grep { $_ eq $file } @{ $self->get_whitelist( '' ) };
    return if ! $whitelisted;

    my $basefile = $self->get_basedir();
    $basefile .= $file;
    if ( ! -e $basefile ) {
        return;
    }
    open my $InF, '<', $basefile;
    my @Content = <$InF>;
    close $InF;
    return join( q{}, @Content );
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Mail::Milter::Authentication::HTDocs - Load and serve static files via the in-built http server.

=head1 VERSION

version 2.20200930.2

=head1 DESCRIPTION

Load and serve static files via the in-build http server.

=head1 CONSTRUCTOR

=head2 I<new()>

Return a new instance of this class

=head1 METHODS

=head2 I<get_whitelist()>

Return an arrayref of valid URLs/Filenames whih are allowed to be served.

=head2 I<get_basedir()>

Return the base directory for htdocs files

=head2 I<get_file( $file )>

Return a full HTTP response for the given filename, or null if it does not exist.

=head1 AUTHOR

Marc Bradshaw <marc@marcbradshaw.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Marc Bradshaw.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
