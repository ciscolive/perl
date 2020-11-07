package File::Dir::Dumper::App;
$File::Dir::Dumper::App::VERSION = '0.6.1';
use warnings;
use strict;

use 5.012;

use parent 'File::Dir::Dumper::Base';

use Getopt::Long qw(GetOptionsFromArray);
use Pod::Usage qw( pod2usage );

use File::Dir::Dumper::Scanner              ();
use File::Dir::Dumper::Stream::JSON::Writer ();

use Class::XSAccessor accessors => {
    _digest_cache        => '_digest_cache',
    _digest_cache_params => '_digest_cache_params',
    _digests             => '_digests',
    _out_to_stdout       => '_out_to_stdout',
    _out_filename        => '_out_filename',
    _dir_to_dump         => '_dir_to_dump',
};


sub _init
{
    my $self = shift;
    my $args = shift;

    my $argv = $args->{'argv'};

    my $output_dest;
    my @digests;
    my ( $help, $man );
    my $digest_cache = 'Dummy';
    my %cache_params;

    GetOptionsFromArray(
        $argv,
        'digest-cache=s'       => \$digest_cache,
        'digest-cache-param=s' => \%cache_params,
        "digest=s"             => \@digests,
        "output|o=s"           => \$output_dest,
        'help|h'               => \$help,
        'man'                  => \$man,
    ) or die "parsing options failed - $!";

    pod2usage(1)                                 if $help;
    pod2usage( -exitstatus => 0, -verbose => 2 ) if $man;

    my $dir_to_dump = shift(@$argv);

    if ( defined($output_dest) )
    {
        $self->_out_to_stdout(0);
        $self->_out_filename($output_dest);
    }
    else
    {
        $self->_out_to_stdout(1);
    }
    $self->_digests( \@digests );
    $self->_dir_to_dump($dir_to_dump);
    $self->_digest_cache($digest_cache);
    $self->_digest_cache_params( \%cache_params );

    return;
}

sub run
{
    my $self = shift;

    my $out;
    if ( $self->_out_to_stdout() )
    {
        open $out, ">&STDOUT";
    }
    else
    {
        open $out, ">", $self->_out_filename();
    }

    my $digests = $self->_digests;

    my $scanner = File::Dir::Dumper::Scanner->new(
        {
            dir => $self->_dir_to_dump(),
            ( ( @$digests ? ( digests => $digests ) : () ), ),
            digest_cache        => $self->_digest_cache,
            digest_cache_params => $self->_digest_cache_params,
        }
    );
    my $writer = File::Dir::Dumper::Stream::JSON::Writer->new(
        {
            output => $out,
        }
    );

    while ( defined( my $token = $scanner->fetch() ) )
    {
        $writer->put($token);
    }

    $writer->close();

    return 0;
}


1;    # End of File::Dir::Dumper

__END__

=pod

=encoding UTF-8

=head1 NAME

File::Dir::Dumper::App - a command line app-implemented as a class to do the
dumping.

=head1 VERSION

version 0.6.1

=head1 SYNOPSIS

    use File::Dir::Dumper::App;

    my $app = File::Dir::Dumper::App->new({argv => \@ARGV});

    exit($app->run());

=head1 METHODS

=head2 $self->new({ argv => \@ARGV})

Scans using the @ARGV command line arguments.

=head2 $self->run()

Runs the application.

=head1 AUTHOR

Shlomi Fish, C<< <shlomif@cpan.org> >>

=for :stopwords cpan testmatrix url bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

=over 4

=item *

MetaCPAN

A modern, open-source CPAN search engine, useful to view POD in HTML format.

L<https://metacpan.org/release/File-Dir-Dumper>

=item *

RT: CPAN's Bug Tracker

The RT ( Request Tracker ) website is the default bug/issue tracking system for CPAN.

L<https://rt.cpan.org/Public/Dist/Display.html?Name=File-Dir-Dumper>

=item *

CPANTS

The CPANTS is a website that analyzes the Kwalitee ( code metrics ) of a distribution.

L<http://cpants.cpanauthors.org/dist/File-Dir-Dumper>

=item *

CPAN Testers

The CPAN Testers is a network of smoke testers who run automated tests on uploaded CPAN distributions.

L<http://www.cpantesters.org/distro/F/File-Dir-Dumper>

=item *

CPAN Testers Matrix

The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

L<http://matrix.cpantesters.org/?dist=File-Dir-Dumper>

=item *

CPAN Testers Dependencies

The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

L<http://deps.cpantesters.org/?module=File::Dir::Dumper>

=back

=head2 Bugs / Feature Requests

Please report any bugs or feature requests by email to C<bug-file-dir-dumper at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/Public/Bug/Report.html?Queue=File-Dir-Dumper>. You will be automatically notified of any
progress on the request by the system.

=head2 Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

L<https://github.com/shlomif/perl-File-Dir-Dumper>

  git clone https://github.com/shlomif/perl-File-Dir-Dumper

=head1 AUTHOR

Shlomi Fish <shlomif@cpan.org>

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
L<https://github.com/shlomif/file-dir-dumper/issues>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2008 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=cut
