# NOTE: Derived from blib/lib/PDF/Reuse.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package PDF::Reuse;

#line 3903 "blib/lib/PDF/Reuse.pm (autosplit into blib/lib/auto/PDF/Reuse/prJpeg.al)"
sub prJpeg
{  my ($iData, $iWidth, $iHeight, $iFormat, $iColorType, $altArrayObjNr) = @_;
   if ($iColorType =~ /Gray/i)
   {  $iColorType = 'DeviceGray';
   }
   else
   {  $iColorType = 'DeviceRGB';
   }
   my ($iLangd, $namnet, $utrad);
   if (! $pos)                    # If no output is active, it is no use to continue
   {   return undef;
   }
   my $checkidOld = $checkId;
   if (!$iFormat)
   {   ($iFile, $checkId) = findGet($iData, $checkidOld);
       if ($iFile)
       {  $iLangd = (stat($iFile))[7];
          $imageNr++;
          $namnet = 'Ig' . $imageNr;
          $objNr++;
          $objekt[$objNr] = $pos;
          open (BILDFIL, "<$iFile") || errLog("Couldn't open $iFile, $!, aborts");
          binmode BILDFIL;
          my $iStream;
          sysread BILDFIL, $iStream, $iLangd;
          $utrad = "$objNr 0 obj\n<</Type/XObject/Subtype/Image/Name/$namnet" .
                    "/Width $iWidth /Height $iHeight /BitsPerComponent 8 " .
                    ($altArrayObjNr ? "/Alternates $altArrayObjNr 0 R " : "") .
                    "/Filter/DCTDecode/ColorSpace/$iColorType"
                    . "/Length $iLangd >>stream\n$iStream\nendstream\nendobj\n";
          close BILDFIL;
          $pos += syswrite UTFIL, $utrad;
          if ($runfil)
          {  $log .= "Cid~$checkId\n";
             $log .= "Jpeg~$iFile~$iWidth~$iHeight\n";
          }
          $objRef{$namnet} = $objNr;
       }
   }
   elsif ($iFormat == 1)
   {  my $iBlob = $iData;
      $iLangd = length($iBlob);
      $imageNr++;
      $namnet = 'Ig' . $imageNr;
      $objNr++;
      $objekt[$objNr] = $pos;
      $utrad = "$objNr 0 obj\n<</Type/XObject/Subtype/Image/Name/$namnet" .
                "/Width $iWidth /Height $iHeight /BitsPerComponent 8 " .
                ($altArrayObjNr ? "/Alternates $altArrayObjNr 0 R " : "") .
                "/Filter/DCTDecode/ColorSpace/$iColorType"
                . "/Length $iLangd >>stream\n$iBlob\nendstream\nendobj\n";
      $pos += syswrite UTFIL, $utrad;
      if ($runfil)
      {  $log .= "Cid~$checkId\n";
         $log .= "Jpeg~$iFile~$iWidth~$iHeight\n" if !$iFormat;
         $log .= "Jpeg~Blob~$iWidth~$iHeight\n" if $iFormat == 1;
      }
      $objRef{$namnet} = $objNr;
   }
   if (! $pos)
   {  errLog("No output file, you have to call prFile first");
   }
   undef $checkId;
   return $namnet;
}

# end of PDF::Reuse::prJpeg
1;
