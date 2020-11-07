# NOTE: Derived from blib/lib/Net/DNS/ToolKit.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit;

#line 895 "blib/lib/Net/DNS/ToolKit.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/collapse.al)"
sub collapse {
  my($zone,$fqdn) = @_;
  return ($fqdn =~ /\.$zone$/i)
	? $`
	: $fqdn;
}

# end of Net::DNS::ToolKit::collapse
1;
