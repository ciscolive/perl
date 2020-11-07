# NOTE: Derived from blib/lib/Net/DNS/ToolKit.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit;

#line 458 "blib/lib/Net/DNS/ToolKit.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/put_ancount.al)"
sub put_ancount {
  my ($bp,$val) = @_;
  @_ = ($bp,6,$val);
  goto &put16;
}

# end of Net::DNS::ToolKit::put_ancount
1;
