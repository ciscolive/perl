# NOTE: Derived from blib/lib/PDF/Reuse.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package PDF::Reuse;

#line 3875 "blib/lib/PDF/Reuse.pm (autosplit into blib/lib/auto/PDF/Reuse/prAltJpeg.al)"
sub prAltJpeg
{  my ($iData, $iWidth, $iHeight, $iFormat,$aiData, $aiWidth, $aiHeight, $aiFormat) = @_;
   if (! $pos)                    # If no output is active, it is no use to continue
   {   return undef;
   }
   prJpeg($aiData, $aiWidth, $aiHeight, $aiFormat);
   my $altObjNr = $objNr;
   $imageNr++;
   $objNr++;
   $objekt[$objNr] = $pos;
   $utrad = "$objNr 0 obj\n" .
            "[ << /Image $altObjNr 0 R\n" .
            "/DefaultForPrinting true\n" .
            ">>\n" .
            "]\n" .
            "endobj\n";
   $pos += syswrite UTFIL, $utrad;
   if ($runfil)
   {  $log .= "Jpeg~AltImage\n";
   }
   $objRef{$namnet} = $objNr;
   my $namnet = prJpeg($iData, $iWidth, $iHeight, $iFormat, $objNr);
   if (! $pos)
   {  errLog("No output file, you have to call prFile first");
   }
   return $namnet;
}

# end of PDF::Reuse::prAltJpeg
1;
