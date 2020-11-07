# NOTE: Derived from blib/lib/Net/DNS/ToolKit.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit;

#line 349 "blib/lib/Net/DNS/ToolKit.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/getflags.al)"
sub getflags {
  my $bp = shift;
  @_ = ($bp,2);
  goto &get16;
}

# end of Net::DNS::ToolKit::getflags
1;
