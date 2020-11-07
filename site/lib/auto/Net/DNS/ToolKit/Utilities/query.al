# NOTE: Derived from blib/lib/Net/DNS/ToolKit/Utilities.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit::Utilities;

#line 193 "blib/lib/Net/DNS/ToolKit/Utilities.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/Utilities/query.al)"
sub query {
  my($bp,$timeout) = @_;
  $timeout = 30 unless $timeout && $timeout > 0;
  my @servers = get_ns();
  my $port = 53;
  my ($msglen,$response);
  my $len = length($$bp);
  foreach my $server (@servers) {
    $server = inet_ntoa($server);
    eval {
      local $SIG{ALRM} = sub {die "connection timed out, no servers could be reached"};
      alarm $timeout;
##### open socket
      my $socket = IO::Socket::INET->new(
	PeerAddr	=> $server,
	PeerPort	=> $port,
	Proto		=> 'udp',
	Type		=> SOCK_DGRAM,
      ) or die "connection timed out, no servers could be reached";

##### send UDP query
      syswrite $socket, $$bp, length($$bp);
##### read UDP answer
      unless ($msglen = sysread($socket,$response,NS_PACKETSZ)) {	# get response, size limited
	close $socket;

	$socket = IO::Socket::INET->new(
	  PeerAddr	=> $server,
	  PeerPort	=> $port,
	  Proto		=> 'tcp',
	  Type		=> SOCK_STREAM,
	) or die "connection timed out, no servers could be reached";

##### send TCP query
	put16(\$msglen,0,$len);
	syswrite $socket, $msglen, 2;
	syswrite $socket, $$bp, $len;

##### read TCP answer
	sysread $socket, $response, 2;

	$msglen = get16(\$response,0);
	$msglen = sysread $socket, $response, $msglen;
      } # using TCP
      close $socket;
      alarm 0;
    }; # end eval
    next if $@;
    next unless $msglen;
    return $response;
  } # end if foreach, no server found
  return undef;
}

# end of Net::DNS::ToolKit::Utilities::query
1;
