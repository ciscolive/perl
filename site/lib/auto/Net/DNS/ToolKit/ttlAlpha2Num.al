# NOTE: Derived from blib/lib/Net/DNS/ToolKit.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit;

#line 848 "blib/lib/Net/DNS/ToolKit.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/ttlAlpha2Num.al)"
############################################################
# ttlAlpha2Num
# convert alpha TTL representation to numberic interger
#
# input:	ttl in form [numeric || alpha numeric]
# return:	ttl numeric
#
sub ttlAlpha2Num
{
  my $ttl;
  return 0 unless $_[0];
  ( $ttl = $_[0] ) =~ s/\s//g;
  return 0 unless $ttl;
  return $ttl if ( $ttl !~ /\D/ );	# OK as is
  $ttl = "\L$ttl";			# all lower case
  return $ttl if $ttl =~ /[^0-9smhdw]/;	# err if not allowed
  $ttl =~ s/(\D)/$1x/g;			# insert split character
  my @ttl = split ('x', $ttl);		# extract components
  $ttl = 0;
  foreach my $i ( @ttl ) {		# calculate seconds
    my $act = chop $i;			# get character
    $i *= $timeX{$act}
	if exists $timeX{$act};		# multiply by correct constant
    $ttl += $i;
  }
  $ttl;
}

# end of Net::DNS::ToolKit::ttlAlpha2Num
1;
