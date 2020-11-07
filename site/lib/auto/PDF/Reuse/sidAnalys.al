# NOTE: Derived from blib/lib/PDF/Reuse.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package PDF::Reuse;

#line 6177 "blib/lib/PDF/Reuse.pm (autosplit into blib/lib/auto/PDF/Reuse/sidAnalys.al)"
sub sidAnalys
{  my ($oNr, $obj, $resources) = @_;
   my ($ny, $strPos, $spar, $closeProc, $del1, $del2, $utrad, $Annots,
   $resursObjekt, $streamObjekt, @extObj, $langd);

   if ((defined $stream) && (length($stream) > 0))
   {
       if ($checkCs)
       {  @extObj = ($stream =~ m'/(\S+)\s*'gso);
          checkContentStream(@extObj);
       }

       $objNr++;
       $objekt[$objNr] = $pos;

       if (( $compress ) && ( length($stream)  > 99 ))
       {   my $output = compress($stream);
           if ((length($output) > 25) && (length($output) < (length($stream))))
           {  $stream = $output;
           }
           $langd = length($stream);
           $stream = "\n" . $stream . "\n";
           $langd++;
           $streamObjekt  = "$objNr 0 obj<</Filter/FlateDecode"
                             . "/Length $langd>>stream" . $stream;
           $streamObjekt .= "endstream\nendobj\n";

       }
       else
       {  $langd = length($stream);
          $streamObjekt  = "$objNr 0 obj<</Length $langd>>stream\n" . $stream;
          $streamObjekt .= "\nendstream\nendobj\n";
       }
       $pos += syswrite UTFIL, $streamObjekt;
       $streamObjekt = "$objNr 0 R ";

       ########################################################################
       # Sometimes the contents reference is a ref to an object which
       # contains an array of content streams. Replace the ref with the array
       ########################################################################

       if ($obj =~ m'/Contents\s+(\d+)\s{1,2}\d+\s{1,2}R'os)
       {   my $cObj = getObject($1, 1, 1);
           if ($cObj =~ m'^\s*\[[^\]]+\]\s*$'os)
           {   $obj =~ s|/Contents\s+\d+\s{1,2}\d+\s{1,2}R|'/Contents ' . $cObj|oes;
           }
       }

       my ($from, $to);

       ($resources, $from, $to) = checkResources ($obj, $resources);
       if ($from && $to)
       {   $obj = substr($obj, 0, $from) . substr($obj, $to);
       }


       ##########################
       # Hitta resursdictionary
       ##########################
       my $i = 0;
       while (($resources !~ m'\/'os) && ($i < 10))
       {   $i++;
           if ($resources =~ m'\s+(\d+)\s{1,2}\d+\s{1,2}R'os)
           {   $resources = getObject($1, 1, 1);
           }
       }
       if ($i > 7)
       {  errLog("Couldn't find resources to merge");
       }
       if ($resources =~ m'\s*\<\<(.*)\>\>'os)
       {  $resources = $1;
       }

       if ($resources !~ m'/ProcSet')
       {  $resources =  '/ProcSet[/PDF/Text] ' . $resources;
       }

       ###############################################################
       # Läsa ev. referenser och skapa ett resursobjekt bestående av
       # dictionaries (för utvalda resurser)
       ###############################################################

       if (scalar %sidFont)
       {  if ($resources =~ m'/Font\s+(\d+)\s{1,2}\d+\s{1,2}R'os)
          {   my $dict = getObject($1, 1, 1);
              $resources =~ s"/Font\s+\d+\s{1,2}\d+\s{1,2}R"'/Font' . $dict"ose;
          }
       }

       if (scalar %sidXObject)
       {  if ($resources =~ m'/XObject\s+(\d+)\s{1,2}\d+\s{1,2}R'os)
          {   my $dict = getObject($1, 1, 1);
              $resources =~ s"/XObject\s+\d+\s{1,2}\d+\s{1,2}R"'/XObject' . $dict"ose;
          }
       }

       if (scalar %sidExtGState)
       {  if ($resources =~ m'/ExtGState\s+(\d+)\s{1,2}\d+\s{1,2}R'os)
          {   my $dict = getObject($1, 1, 1);
              $resources =~ s"/ExtGState\s+\d+\s{1,2}\d+\s{1,2}R"'/ExtGState' . $dict"ose;
          }
       }

       if (scalar %sidPattern)
       {  if ($resources =~ m'/Pattern\s+(\d+)\s{1,2}\d+\s{1,2}R'os)
          {   my $dict = getObject($1, 1, 1);
              $resources =~ s"/Pattern\s+\d+\s{1,2}\d+\s{1,2}R"'/Pattern' . $dict"ose;
          }
       }

       if (scalar %sidShading)
       {  if ($resources =~ m'/Shading\s+(\d+)\s{1,2}\d+\s{1,2}R'os)
          {   my $dict = getObject($1, 1, 1);
              $resources =~ s"/Shading\s+\d+\s{1,2}\d+\s{1,2}R"'/Shading' . $dict"ose;
          }
       }

       if (scalar %sidColorSpace)
       {  if ($resources =~ m'/ColorSpace\s+(\d+)\s{1,2}\d+\s{1,2}R'os)
          {   my $dict = getObject($1, 1, 1);
              $resources =~ s"/ColorSpace\s+\d+\s{1,2}\d+\s{1,2}R"'/ColorSpace' . $dict"ose;
          }
       }
       ####################################################
       # Nu är resurserna "normaliserade" med ursprungliga
       # värden. Spara värden för "översättning"
       ####################################################

       $resources =~ s/\b(\d+)\s{1,2}\d+\s{1,2}R\b/xform() . ' 0 R'/oegs;

       ###############################
       # Komplettera med nya resurser
       ###############################

       if (scalar %sidFont)
       {  my $str = '';
          for (sort keys %sidFont)
          {  $str .= "/$_ $sidFont{$_} 0 R";
          }
          if ($resources !~ m'\/Font'os)
          {   $resources =  "/Font << $str >> " . $resources;
          }
          else
          {   $resources =~ s"/Font\s*<<"'/Font<<' . $str"oges;
          }
       }

       if (scalar %sidXObject)
       {  my $str = '';
          for (sort keys %sidXObject)
          {  $str .= "/$_ $sidXObject{$_} 0 R";
          }
          if ($resources !~ m'\/XObject'os)
          {   $resources =  "/XObject << $str >> " . $resources;
          }
          else
          {   $resources =~ s"/XObject\s*<<"'/XObject<<' . $str"oges;
          }
       }

       if (scalar %sidExtGState)
       {  my $str = '';
          for (sort keys %sidExtGState)
          {  $str .= "/$_ $sidExtGState{$_} 0 R";
          }
          if ($resources !~ m'\/ExtGState'os)
          {   $resources =  "/ExtGState << $str >> " . $resources;
          }
          else
          {   $resources =~ s"/ExtGState\s*<<"'/ExtGState<<' . $str"oges;
          }
       }

       if (scalar %sidPattern)
       {  my $str = '';
          for (sort keys %sidPattern)
          {  $str .= "/$_ $sidPattern{$_} 0 R";
          }
          if ($resources !~ m'\/Pattern'os)
          {   $resources =  "/Pattern << $str >> " . $resources;
          }
          else
          {   $resources =~ s"/Pattern\s*<<"'/Pattern<<' . $str"oges;
          }
       }

       if (scalar %sidShading)
       {  my $str = '';
          for (sort keys %sidShading)
          {  $str .= "/$_ $sidShading{$_} 0 R";
          }
          if ($resources !~ m'\/Shading'os)
          {   $resources =  "/Shading << $str >> " . $resources;
          }
          else
          {   $resources =~ s"/Shading\s*<<"'/Shading<<' . $str"oges;
          }
       }

       if (scalar %sidColorSpace)
       {  my $str = '';
          for (sort keys %sidColorSpace)
          {  $str .= "/$_ $sidColorSpace{$_} 0 R";
          }
          if ($resources !~ m'\/ColorSpace'os)
          {   $resources =  "/ColorSpace << $str >> " . $resources;
          }
          else
          {   $resources =~ s"/ColorSpace\s*<<"'/ColorSpace<<' . $str"oges;
          }
       }

       if (exists $resurser{$resources})
       {  $resources = "$resurser{$resources} 0 R\n";  # Fanns ett identiskt,
       }                                               # använd det
       else
       {   $objNr++;
           if ( keys(%resurser) < 10)
           {  $resurser{$resources} = $objNr;     # Spara 10 första resursobjekten
           }
           $objekt[$objNr] = $pos;
           $resursObjekt   = "$objNr 0 obj<<$resources>>endobj\n";
           $pos += syswrite UTFIL, $resursObjekt ;
           $resources      = "$objNr 0 R\n";
       }

       %sidXObject    = ();
       %sidExtGState  = ();
       %sidFont       = ();
       %sidPattern    = ();
       %sidShading    = ();
       %sidColorSpace = ();
       undef $checkCs;

       $stream     = '';
   }

   if (! $parents[0])
   { $objNr++;
     $parents[0] = $objNr;
   }
   my $parent = $parents[0];

   if (($sidObjNr) && (! defined $objekt[$sidObjNr]))
   {  $ny = $sidObjNr;
   }
   else
   {  $objNr++;
      $ny = $objNr;
   }

   $old{$oNr} = $ny;

   if ($obj =~ m'/Parent\s+(\d+)\s{1,2}\d+\s{1,2}R\b'os)
   {  $old{$1} = $parent;
   }

   if ($obj =~ m'^\d+ \d+ obj\s*<<(.+)>>\s*endobj'os)
   {  $del1 = $1;
   }

   if (%links)
   {   my $tSida = $sida + 1;
       if ((%links && @{$links{'-1'}}) || (%links && @{$links{$tSida}}))
       {   if ($del1 =~ m'/Annots\s*([^\/\<\>]+)'os)
           {  $Annots  = $1;
              @annots = ();
              if ($Annots =~ m'\[([^\[\]]*)\]'os)
              {  ; }
              else
              {  if ($Annots =~ m'\b(\d+)\s{1,2}\d+\s{1,2}R\b'os)
                 {  $Annots = getObject($1);
                 }
              }
              while ($Annots =~ m'\b(\d+)\s{1,2}\d+\s{1,2}R\b'ogs)
              {   push @annots, xform();
              }
              $del1 =~ s?/Annots\s*([^\/\<\>]+)??os;
           }
           $Annots = '/Annots ' . mergeLinks() . ' 0 R';
       }
   }

   if (! $taInterAkt)
   {  $del1 =~ s?\s*/AA\s*<<[^>]*>>??os;
   }

   $del1 =~ s/\b(\d+)\s{1,2}\d+\s{1,2}R\b/xform() . ' 0 R'/oegs;

   if ($del1 !~ m'/Resources'o)
   {  $del1 .= "/Resources $resources";
   }

   if (defined $streamObjekt)     # En ny ström ska läggas till
   {  if ($del1 =~ m'/Contents\s+(\d+)\s{1,2}\d+\s{1,2}R'os)
      {  my $oldCont = $1;
         $del1 =~ s|/Contents\s+(\d+)\s{1,2}\d+\s{1,2}R|'/Contents [' . "$oldCont 0 R $streamObjekt" . ']'|oes;
      }
      elsif ($del1 =~ m'/Contents\s*\['os)
      {   $del1 =~ s|/Contents\s*\[([^\]]+)|'/Contents [' . $1 ." $streamObjekt"|oes;
      }
      else
      {   $del1 .= "/Contents $streamObjekt\n";
      }
   }

   if ($Annots)
   {  $del1 .= $Annots;
   }

   $utrad = "$ny 0 obj<<$del1>>";
   if (defined $del2)
   {   $utrad .= "stream\n$del2";
   }
   else
   {  $utrad .= "endobj\n";
   }

   $objekt[$ny] = $pos;
   $pos += syswrite UTFIL, $utrad;

   push @{$kids[0]}, $ny;
   $counts[0]++;
   if ($counts[0] > 9)
   {  ordnaNoder(8);
   }
}

# end of PDF::Reuse::sidAnalys
1;
