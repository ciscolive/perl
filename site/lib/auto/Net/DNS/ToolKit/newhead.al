# NOTE: Derived from blib/lib/Net/DNS/ToolKit.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit;

#line 674 "blib/lib/Net/DNS/ToolKit.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/newhead.al)"
sub newhead {
  my($bp,$id,$flags,$qdcount,$ancount,$nscount,$arcount) = @_;
  return undef unless ref $bp;
  return undef unless defined $id;
  $qdcount = 0 unless $qdcount;
  $ancount = 0 unless $ancount;
  $nscount = 0 unless $nscount;
  $arcount = 0 unless $arcount;
  $$bp = pack("n n n n n n",$id,$flags,$qdcount,$ancount,$nscount,$arcount);
  return NS_HFIXEDSZ;
}

# end of Net::DNS::ToolKit::newhead
1;
