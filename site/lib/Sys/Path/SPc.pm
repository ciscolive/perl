package Sys::Path::SPc;

use warnings;
use strict;

our $VERSION = '0.16';

use File::Spec;

sub _path_types {qw(
	prefix
	localstatedir
	sysconfdir
	datadir
	docdir
	cachedir
	logdir
	spooldir
	rundir
	lockdir
	localedir
	sharedstatedir
	webdir
	srvdir
)};

# sub names inspired by http://www.gnu.org/software/autoconf/manual/html_node/Installation-Directory-Variables.html#Installation-Directory-Variables

sub prefix {'/opt/perl'};
sub localstatedir {'/opt/perl/var'};

sub sysconfdir {'/opt/perl/etc'};
sub datadir {'/opt/perl/share'};
sub docdir {'/opt/perl/share/doc'};
sub localedir {'/opt/perl/share/locale'};
sub cachedir {'/opt/perl/var/cache'};
sub logdir {'/opt/perl/var/log'};
sub spooldir {'/opt/perl/var/spool'};
sub rundir {'/opt/perl/var/run'};
sub lockdir {'/opt/perl/var/lock'};
sub sharedstatedir {'/opt/perl/var/lib'};
sub webdir {'/opt/perl/var/www'};
sub srvdir {'/opt/perl/srv'};

1;


__END__

=head1 NAME

SPc - build-time system path configuration

=head1 PATHS

See L<Sys::Path/PATHS for details>

=head2 prefix

=head2 localstatedir

=head2 sysconfdir

=head2 datadir

=head2 docdir

=head2 localedir

=head2 cachedir

=head2 logdir

=head2 spooldir

=head2 rundir

=head2 lockdir

=head2 sharedstatedir

=head2 webdir

=head2 srvdir

=head1 AUTHOR

Jozef Kutej

=cut
