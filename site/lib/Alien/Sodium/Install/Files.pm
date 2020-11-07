package Alien::Sodium::Install::Files;
use strict;
use warnings;
require Alien::Sodium;
sub Inline { shift; Alien::Sodium->Inline(@_) }
1;

=begin Pod::Coverage

  Inline

=cut
