# NOTE: Derived from blib/lib/Net/DNS/ToolKit/Utilities.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit::Utilities;

#line 297 "blib/lib/Net/DNS/ToolKit/Utilities.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/Utilities/dns_udpresp.al)"
sub dns_udpresp {
  my($socket,$timeout) = @_;
  return undef unless $socket;
  $timeout = 30 unless $timeout && $timeout > 0;
  my $response = undef;
  eval {
      local $SIG{ALRM} = sub {die "connection timed out, no servers could be reached"};
      alarm $timeout;
      sysread($socket,$response,NS_PACKETSZ) or die "no message received";
  };
  alarm 0;
  close $socket;
  return $response;
}

# end of Net::DNS::ToolKit::Utilities::dns_udpresp
1;
