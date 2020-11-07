#
# (c) Jan Gehring <jan.gehring@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Rex::Inventory::DMIDecode::Bios;

use strict;
use warnings;

our $VERSION = '1.13.0'; # VERSION

use Rex::Inventory::DMIDecode::Section;
use base qw(Rex::Inventory::DMIDecode::Section);

__PACKAGE__->section("BIOS Information");

__PACKAGE__->has( [ 'Vendor', 'Version', 'Release Date', ] );

sub new {
  my $that  = shift;
  my $proto = ref($that) || $that;
  my $self  = $that->SUPER::new(@_);

  bless( $self, $proto );

  return $self;
}

1;

