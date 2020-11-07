# NOTE: Derived from blib/lib/Net/DNS/ToolKit/Utilities.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit::Utilities;

#line 508 "blib/lib/Net/DNS/ToolKit/Utilities.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/Utilities/rlook_send.al)"
sub rlook_send {
  my($IP,$timeout) = @_;
  my $buffer = undef;
  my $offset = newhead(\$buffer,
	&id(),
	BITS_QUERY | RD,	# query, recursion desired
	1,0,0,0,		# one question
  );
  my $dnsblIP = revIP($IP);
  my ($get,$put,$parse) = new Net::DNS::ToolKit::RR;
  $offset = $put->Question(\$buffer,$offset,$dnsblIP.'.in-addr.arpa',T_PTR,C_IN);
 return dns_udpsend(\$buffer,$timeout);
}

# end of Net::DNS::ToolKit::Utilities::rlook_send
1;
