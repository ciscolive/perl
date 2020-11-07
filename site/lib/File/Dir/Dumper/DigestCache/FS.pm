package File::Dir::Dumper::DigestCache::FS;
$File::Dir::Dumper::DigestCache::FS::VERSION = '0.6.1';
use warnings;
use strict;
use autodie;

use parent 'File::Dir::Dumper::Base';

use 5.012;

use Class::XSAccessor accessors => { _path => '_path', };

use File::Basename qw/ dirname /;
use File::Spec ();
use File::Path 2.00 qw/ make_path /;
use JSON::MaybeXS ();


sub _init
{
    my ( $self, $args ) = @_;

    my $basepath = $args->{params}->{path}
        or die "path not specified as a parameter!";
    $self->_path( File::Spec->catdir( $basepath, 'digests-cache-dir' ) );

    return;
}


sub _slurp
{
    my $filename = shift;

    open my $in, '<', $filename
        or die "Cannot open '$filename' for slurping - $!";

    local $/;
    my $contents = <$in>;

    close($in);

    return $contents;
}

sub get_digests
{
    my ( $self, $args ) = @_;
    my $mtime = $args->{mtime};
    my $path  = File::Spec->catfile( $self->_path, @{ $args->{path} } );
    my $cb    = $args->{calc_cb};

    my $update = sub {
        open my $out, '>', $path;
        $out->print( JSON::MaybeXS->new( canonical => 1 )
                ->encode( +{ mtime => $mtime, digests => scalar( $cb->() ) } )
        );
        close $out;

        return;
    };
    if ( !-f $path )
    {
        make_path( dirname($path) );
        $update->();
    }
    while (1)
    {
        my $json =
            JSON::MaybeXS->new( canonical => 1 )->decode( _slurp($path) );
        if ( $json->{mtime} == $mtime )
        {
            return $json->{digests};
        }
        else
        {
            $update->();
        }
    }
    die "Bug";
}

1;    # End of File::Dir::Dumper

__END__

=pod

=encoding UTF-8

=head1 NAME

File::Dir::Dumper::DigestCache::FS - digest cache for
L<File::Dir::Dumper> that uses the file system.

=head1 VERSION

version 0.6.1

=head1 SYNOPSIS

B<TODO> - see the tests.

=head1 METHODS

=head2 $cache->get_digests({calc_cb => sub { return +{...}}})

Returns whatever calc_cb returns. A passthrough.

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
