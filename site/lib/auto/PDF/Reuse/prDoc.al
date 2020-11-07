# NOTE: Derived from blib/lib/PDF/Reuse.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package PDF::Reuse;

#line 3616 "blib/lib/PDF/Reuse.pm (autosplit into blib/lib/auto/PDF/Reuse/prDoc.al)"
########## Extrahera ett dokument ####################
sub prDoc
{ my ($infil, $first, $last);
  my $param = shift;
  if (ref($param) eq 'HASH')
  {  $infil = $param->{'file'};
     $first = $param->{'first'} || 1;
     $last  = $param->{'last'} || '';
  }
  else
  {  $infil = $param;
     $first = shift || 1;
     $last  = shift || '';
  }


  my ($sidor, $Names, $AARoot, $AcroForm) = analysera($infil, $first, $last);
  if (($Names) || ($AARoot) || ($AcroForm))
  { $NamesSaved     = $Names;
    $AARootSaved    = $AARoot;
    $AcroFormSaved  = $AcroForm;
    $interActive    = 1;
  }
  if ($runfil)
  {   $infil = prep($infil);
      $log .= "Doc~$infil~$first~$last\n";
  }
  if (! $pos)
  {  errLog("No output file, you have to call prFile first");
  }
  return $sidor;
}

# end of PDF::Reuse::prDoc
1;
