# NOTE: Derived from blib/lib/Net/DNS/ToolKit/Debug.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit::Debug;

#line 77 "blib/lib/Net/DNS/ToolKit/Debug.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/Debug/print_head.al)"
sub print_head {
  my ($bp) = @_;
  my($offset,$ID,$QR,$OPCODE,$AA,$TC,$RD,$RA,$Z,$AD,$CD,$RCODE,
        $QDCOUNT,$ANCOUNT,$NSCOUNT,$ARCOUNT) = gethead($bp);
  print "
  ID      => $ID
  QR      => $QR
  OPCODE  => ",OpcodeTxt->{$OPCODE},"
  AA      => $AA
  TC      => $TC
  RD      => $RD
  RA      => $RA    
  Z       => $Z   
  AD      => $AD  
  CD      => $CD
  RCODE   => ",RcodeTxt->{$RCODE},"
  QDCOUNT => $QDCOUNT
  ANCOUNT => $ANCOUNT
  NSCOUNT => $NSCOUNT
  ARCOUNT => $ARCOUNT\n";
}

# end of Net::DNS::ToolKit::Debug::print_head
1;
