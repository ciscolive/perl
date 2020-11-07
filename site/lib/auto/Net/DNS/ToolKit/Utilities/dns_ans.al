# NOTE: Derived from blib/lib/Net/DNS/ToolKit/Utilities.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit::Utilities;

#line 331 "blib/lib/Net/DNS/ToolKit/Utilities.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/Utilities/dns_ans.al)"
sub dns_ans {
  my $bp = shift;
  my $aptr = [];
  my $tptr = [];
  my $zone = '';
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
	$ancount < 1;

    my ($get,$put,$parse) = new Net::DNS::ToolKit::RR;
    my ($off,$name,$type,$class) = $get->Question($bp,$off);
    last unless $class == C_IN;

    foreach(0..$ancount -1) {
      ($off,$name,$type,$class,my($ttl,$rdlength,@rdata)) =
	$get->next($bp,$off);
      if ($type == T_A) {
	push @$aptr, @rdata;
      } elsif ($type == T_TXT) {
	if (@rdata > 1) {
	  push @$tptr, join(' ',@rdata);
	} else {
	  push @$tptr, @rdata;
	}
      }
    }
    last if $ancount && @$aptr;	# end, if there is an answer
    last unless $arcount;	# end if there is no authority
    foreach(0..$nscount -1) {
      ($off,@_) = $get->next($bp,$off);	# toss these
    }
    foreach(0..$arcount -1) {
      ($off,$name,$type,@_) =
	$get->next($bp,$off);
      if($type == T_SOA) {
	$zone = $name;
	last DECODE;
      }
    }
    last;
  }
  return () unless @$aptr;
  bless $aptr, $caller;
  bless $tptr, $caller;
  return($aptr,$tptr,$zone);
}

# end of Net::DNS::ToolKit::Utilities::dns_ans
1;
