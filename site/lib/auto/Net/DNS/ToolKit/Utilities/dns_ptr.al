# NOTE: Derived from blib/lib/Net/DNS/ToolKit/Utilities.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit::Utilities;

#line 464 "blib/lib/Net/DNS/ToolKit/Utilities.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/Utilities/dns_ptr.al)"
sub dns_ptr {
  my $bp = shift;
  unless ($$bp) {
    return wantarray ? () : undef;
  }
  my ($off,$id,$qr,$opcode,$aa,$tc,$rd,$ra,$mbz,$ad,$cd,$rcode,
	$qdcount,$ancount,$nscount,$arcount)
	= gethead($bp);

  if (	$tc ||
	$opcode != QUERY ||
	$rcode != NOERROR ||
	$qdcount != 1 ||
	$ancount < 1 ) {
    return wantarray ? () : undef;
  }

  my ($get,$put,$parse) = new Net::DNS::ToolKit::RR;
  ($off,my($name,$type,$class)) = $get->Question($bp,$off);
  unless ($class == C_IN) {
    return wantarray ? () : undef;
  }

  my($ttl,$rdlength,$host,@hosts);
  foreach(0..$ancount -1) {
    ($off,$name,$type,$class,$ttl,$rdlength,$host) =
	$get->next($bp,$off);
    push @hosts, $host;
  }
#  ($name,$type,$class,@hosts) = $parse->PTR($name,$type,$class,@hosts);
  return wantarray ? @hosts : $hosts[0];
}

# end of Net::DNS::ToolKit::Utilities::dns_ptr
1;
