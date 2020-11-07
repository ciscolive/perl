# NOTE: Derived from blib/lib/Net/DNS/ToolKit.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit;

#line 799 "blib/lib/Net/DNS/ToolKit.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/sec2time.al)"
# deprecated, does not see to work
#	   2)	compression can be suppressed
#		for test purposes if the pointer
#		to $name is stored in a glob
#		reference rather than a scalar.
#
#	  i.e.	$name = 'hostname.com';
#		local *glob = \$name;
#
#  ($newoff,@dnptrs)=dn_comp(\$buffer,$offset,\*glob);
#		[use a pointer to *glob]
#


############################################################
# sec2time
# convert seconds to elapsed time notation
#
# input:	seconds
# returns:	elapsed time
#
sub sec2time
{
  my ( $s ) = @_;
  return $s unless $s;
  my $t = '';
  foreach ( 'w', 'd', 'h', 'm' ) {
    my $x = int ( $s / $timeX{$_} );
    $t .= "${x}$_" if $x;
    $s -= $x * $timeX{$_};
  }
  $t .= "${s}s" if $s;
  $t;
}

# end of Net::DNS::ToolKit::sec2time
1;
