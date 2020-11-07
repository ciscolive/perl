# NOTE: Derived from blib/lib/PDF/Reuse.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package PDF::Reuse;

#line 3509 "blib/lib/PDF/Reuse.pm (autosplit into blib/lib/auto/PDF/Reuse/prMbox.al)"
sub prMbox
{  my $lx = defined($_[0]) ? shift : 0;
   my $ly = defined($_[0]) ? shift : 0;
   my $ux = defined($_[0]) ? shift : 595;
   my $uy = defined($_[0]) ? shift : 842;

   if ((defined $lx) && ($lx =~ m'^[\d\-\.]+$'o))
   { $genLowerX = $lx; }
   if ((defined $ly) && ($ly =~ m'^[\d\-\.]+$'o))
   { $genLowerY = $ly; }
   if ((defined $ux) && ($ux =~ m'^[\d\-\.]+$'o))
   { $genUpperX = $ux; }
   if ((defined $uy) && ($uy =~ m'^[\d\-\.]+$'o))
   { $genUpperY = $uy; }
   if ($runfil)
   {  $log .= "Mbox~$lx~$ly~$ux~$uy\n";
   }
   if (! $pos)
   {  errLog("No output file, you have to call prFile first");
   }
   1;
}

# end of PDF::Reuse::prMbox
1;
