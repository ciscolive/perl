package Mail::Milter::Authentication::Handler::TestTimeout;
use 5.20.0;
use strict;
use warnings;
use Mail::Milter::Authentication::Pragmas;
# ABSTRACT: Timeout Tester
our $VERSION = '2.20200930.2'; # VERSION
use base 'Mail::Milter::Authentication::Handler';

sub _timeout {
    alarm ( 1 );
    sleep 10;
    return;
}


sub connect_callback { return _timeout(); }
sub helo_callback { return  _timeout(); }
sub envfrom_callback { return _timeout(); }
sub envrcpt_callback { return _timeout(); }
sub header_callback { return _timeout(); }
sub eoh_callback { return _timeout(); }
sub body_callback { return _timeout(); }
sub eom_callback { return _timeout(); }
sub abort_callback { return _timeout(); }
sub close_callback { return _timeout(); }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Mail::Milter::Authentication::Handler::TestTimeout - Timeout Tester

=head1 VERSION

version 2.20200930.2

=head1 AUTHOR

Marc Bradshaw <marc@marcbradshaw.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Marc Bradshaw.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
