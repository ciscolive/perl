# NOTE: Derived from blib/lib/Net/DNS/ToolKit.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit;

#line 911 "blib/lib/Net/DNS/ToolKit.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/strip.al)"
sub strip {
  ($_ = $_[0]) =~ s/[A-Z]+_//;
  $_;
}

# end of Net::DNS::ToolKit::strip
1;
