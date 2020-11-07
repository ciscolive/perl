# NOTE: Derived from blib/lib/PDF/Reuse.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package PDF::Reuse;

#line 3075 "blib/lib/PDF/Reuse.pm (autosplit into blib/lib/auto/PDF/Reuse/prLink.al)"
sub prLink
{ my %link;
  my $param = shift;
  if (ref($param) eq 'HASH')
  {  $link{page}   = $param->{'page'} || -1;
     $link{x}      = $param->{'x'}    || 100;
     $link{y}      = $param->{'y'}    || 100;
     $link{width}  = $param->{width}  || 75;
     $link{height} = $param->{height} || 15;
     $link{v}      = $param->{URI};
     $link{s}      = $param->{s} || "URI";
  }
  else
  {  $link{page}   = $param || -1;
     $link{x}      = shift  || 100;
     $link{y}      = shift  || 100;
     $link{width}  = shift  || 75;
     $link{height} = shift  || 15;
     $link{v}      = shift;
     $link{s}      = shift  || "URI";
  }

  if (! $pos)
  {  errLog("No output file, you have to call prFile first");
  }

  if ($runfil)
  {  $log .= "Link~$link{page}~$link{x}~$link{y}~$link{width}~"
          . "$link{height}~$link{v}~$link{s}\n";
  }

  if ($link{v})
  {  push @{$links{$link{page}}}, \%link;
  }
  1;
}

# end of PDF::Reuse::prLink
1;
