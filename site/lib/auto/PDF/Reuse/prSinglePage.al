# NOTE: Derived from blib/lib/PDF/Reuse.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package PDF::Reuse;

#line 3042 "blib/lib/PDF/Reuse.pm (autosplit into blib/lib/auto/PDF/Reuse/prSinglePage.al)"
sub prSinglePage
{ my $infil      = shift;
  my $pageNumber = shift;

  if (! defined $pageNumber)
  {   $behandlad{$infil}->{pageNumber} = 0
        unless (defined $behandlad{$infil}->{pageNumber});
      $pageNumber = $behandlad{$infil}->{pageNumber} + 1;
  }

  my ($sida, $Names, $AARoot, $AcroForm) = analysera($infil, $pageNumber, $pageNumber, 1);
  if (($Names) || ($AARoot) || ($AcroForm))
  { $NamesSaved     = $Names;
    $AARootSaved    = $AARoot;
    $AcroFormSaved  = $AcroForm;
    $interActive    = 1;
  }
  if (defined $sida)
  {  $behandlad{$infil}->{pageNumber} = $pageNumber;
  }
  if ($runfil)
  {   $infil = prep($infil);
      $log .= "prSinglePage~$infil~$pageNumber\n";
  }
  if (! $pos)
  {  errLog("No output file, you have to call prFile first");
  }
  return $sida;

}

# end of PDF::Reuse::prSinglePage
1;
