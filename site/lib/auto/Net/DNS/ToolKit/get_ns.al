# NOTE: Derived from blib/lib/Net/DNS/ToolKit.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit;

#line 931 "blib/lib/Net/DNS/ToolKit.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/get_ns.al)"
sub get_ns {
  local *Rconf;
  my $path = get_path();
  my @ns;
  if ($path && open(Rconf,$path)) {
    my @lines = (<Rconf>);		# slurp lines
    close Rconf;
    foreach(@lines) {
      next if $_ =~ /^\s*#/;
      if ($_ =~ /nameserver\s*(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/ &&
		($_ = inet_aton($1))) {
	push @ns, $_;
      }
    }
  }
  unless (@ns || (@ns = lastchance())) {
    goto &get_default;
  }
  return wantarray ? @ns : $ns[0];
}

1;
1;
# end of Net::DNS::ToolKit::get_ns
