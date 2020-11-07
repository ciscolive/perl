package Mail::Milter::Authentication::Handler::AddID;
use 5.20.0;
use strict;
use warnings;
use Mail::Milter::Authentication::Pragmas;
# ABSTRACT: Example handler class
our $VERSION = '2.20200930.2'; # VERSION
use base 'Mail::Milter::Authentication::Handler';

sub default_config {
    return {};
}

sub eom_callback {

    # On HELO
    my ( $self, $helo_host ) = @_;
    $self->append_header('X-Authentication-Milter','Header added by Authentication Milter');
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Mail::Milter::Authentication::Handler::AddID - Example handler class

=head1 VERSION

version 2.20200930.2

=head1 DESCRIPTION

Simple module which adds a header to all email processed.

This is meant as an example only.

=head1 CONFIGURATION

No configuration options exist for this handler.

=head1 AUTHOR

Marc Bradshaw <marc@marcbradshaw.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Marc Bradshaw.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
