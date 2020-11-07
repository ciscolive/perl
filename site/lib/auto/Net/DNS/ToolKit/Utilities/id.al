# NOTE: Derived from blib/lib/Net/DNS/ToolKit/Utilities.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit::Utilities;

#line 121 "blib/lib/Net/DNS/ToolKit/Utilities.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/Utilities/id.al)"
sub id {
  my $seed = shift;
  $ID = ($seed % 65536) if $seed;
  $ID = 1 if ++$ID > 65535;
  return $ID;
}

# end of Net::DNS::ToolKit::Utilities::id
1;
