# NOTE: Derived from blib/lib/Net/DNS/ToolKit/Utilities.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit::Utilities;

#line 404 "blib/lib/Net/DNS/ToolKit/Utilities.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/Utilities/dns_ns.al)"
sub dns_ns {
  my $bp = shift;
  my $nsptr = {};
  my @ns;
  my ($caller) = caller;
  my ($off,$id,$qr,$opcode,$aa,$tc,$rd,$ra,$mbz,$ad,$cd,$rcode,
	$qdcount,$ancount,$nscount,$arcount)
	= gethead($bp);

  DECODE:
  while(1) {
    last if
	$tc ||
	$opcode != QUERY ||
	$rcode != NOERROR ||
	$qdcount != 1 ||
	$ancount < 1 ||
	$arcount < 1;

    my ($get,$put,$parse) = new Net::DNS::ToolKit::RR;
    my ($off,$name,$type,$class) = $get->Question($bp,$off);
    last unless $class == C_IN;

    foreach(0..$ancount -1) {
      ($off,$name,$type,$class,my($ttl,$rdlength,@rdata)) =
	$get->next($bp,$off);
      if ($type == T_NS) {
	push @ns, @rdata;
      }
    }
    last unless @ns;		# end if there is no answer
    foreach(0..$nscount -1) {
      ($off,@_) = $get->next($bp,$off); # toss these
    }
    foreach(0..$arcount -1) {
      ($off,$name,$type,$class,my($ttl,$rdlength,@rdata)) =
	$get->next($bp,$off);
      if ($type == T_A && grep($name eq $_,@ns)) {
	$nsptr->{"$name"}->{addr} = $rdata[0];	# return first available ns address
	$nsptr->{"$name"}->{ttl} = $ttl;
      }
    }
    last;
  }
  return undef unless keys %$nsptr;
  bless $nsptr, $caller;
  return $nsptr;
}

# end of Net::DNS::ToolKit::Utilities::dns_ns
1;
