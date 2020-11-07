# NOTE: Derived from blib/lib/Net/DNS/ToolKit.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit;

#line 410 "blib/lib/Net/DNS/ToolKit.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/get_nscount.al)"
sub get_nscount {
  my $bp = shift;
  @_ = ($bp,8);
  goto &get16;
}

# end of Net::DNS::ToolKit::get_nscount
1;
