package Devel::ebug::Plugin::Eval;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT = qw(eval yaml);

our $VERSION = '0.63'; # VERSION

# eval
sub eval {
  my($self, $eval) = @_;
  my $response = $self->talk({
    command => "eval",
    eval    => $eval,
  });
  return wantarray ? ( $response->{eval}, $response->{exception} ) :  ##  no critic (Freenode::Wantarray)
                     $response->{eval};
}

# yaml
sub yaml {
  my($self, $yaml) = @_;
  my $response = $self->talk({
    command => "yaml",
    yaml    => $yaml,
  });
  return $response->{yaml};
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Devel::ebug::Plugin::Eval

=head1 VERSION

version 0.63

=head1 AUTHOR

Original author: Leon Brocard E<lt>acme@astray.comE<gt>

Current maintainer: Graham Ollis E<lt>plicease@cpan.orgE<gt>

Contributors:

Brock Wilcox E<lt>awwaiid@thelackthereof.orgE<gt>

Taisuke Yamada

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2005-2020 by Leon Brocard.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
