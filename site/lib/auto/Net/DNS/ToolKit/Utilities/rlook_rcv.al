# NOTE: Derived from blib/lib/Net/DNS/ToolKit/Utilities.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit::Utilities;

#line 534 "blib/lib/Net/DNS/ToolKit/Utilities.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/Utilities/rlook_rcv.al)"
sub rlook_rcv {
  my $buffer = dns_udpresp(@_);
  return dns_ptr(\$buffer);
}

1;
1;
# end of Net::DNS::ToolKit::Utilities::rlook_rcv
