# NOTE: Derived from blib/lib/Net/DNS/ToolKit.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit;

#line 365 "blib/lib/Net/DNS/ToolKit.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/putflags.al)"
sub putflags {
  my($bp,$flags) = @_;
  @_ = ($bp,2,$flags);
  goto &put16;
}

# end of Net::DNS::ToolKit::putflags
1;
