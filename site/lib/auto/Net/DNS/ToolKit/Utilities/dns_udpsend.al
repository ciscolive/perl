# NOTE: Derived from blib/lib/Net/DNS/ToolKit/Utilities.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit::Utilities;

#line 258 "blib/lib/Net/DNS/ToolKit/Utilities.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/Utilities/dns_udpsend.al)"
sub dns_udpsend {
  my($bp,$timeout) = @_;
  $timeout = 30 unless $timeout && $timeout > 0;
  my @servers = get_ns();
  my $port = 53;
  my $len = length($$bp);
  my $server = inet_ntoa($servers[0]);
  my $socket;
  eval {
      local $SIG{ALRM} = sub {die "connection timed out, no servers could be reached"};
      alarm $timeout;
##### open socket
      $socket = IO::Socket::INET->new(
	PeerAddr	=> $server,
	PeerPort	=> $port,
	Proto		=> 'udp',
	Type		=> SOCK_DGRAM,
      ) or die "connection timed out, no servers could be reached";

##### send UDP query, should not block
      syswrite $socket, $$bp, length($$bp);
      alarm 0;
  };
  return $socket;
}

# end of Net::DNS::ToolKit::Utilities::dns_udpsend
1;
