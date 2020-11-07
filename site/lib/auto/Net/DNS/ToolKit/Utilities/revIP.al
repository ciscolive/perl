# NOTE: Derived from blib/lib/Net/DNS/ToolKit/Utilities.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit::Utilities;

#line 175 "blib/lib/Net/DNS/ToolKit/Utilities.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/Utilities/revIP.al)"
sub revIP {
  my @ip = split(/\./, shift);
  @_ = reverse @ip;
  return join('.',@_);
}

# end of Net::DNS::ToolKit::Utilities::revIP
1;
