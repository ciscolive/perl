# NOTE: Derived from blib/lib/Net/DNS/ToolKit.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit;

#line 425 "blib/lib/Net/DNS/ToolKit.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/get_arcount.al)"
sub get_arcount {
  my $bp = shift;
  @_ = ($bp,10);
  goto &get16;
}

# end of Net::DNS::ToolKit::get_arcount
1;
