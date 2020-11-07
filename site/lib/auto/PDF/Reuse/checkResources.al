# NOTE: Derived from blib/lib/PDF/Reuse.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package PDF::Reuse;

#line 6506 "blib/lib/PDF/Reuse.pm (autosplit into blib/lib/auto/PDF/Reuse/checkResources.al)"
sub checkResources
{   my $pObj  = shift;
    my $reStr = shift;
    my $to;

    my $p = index($pObj, '/Resources');
    if ( $p < 0)
    {  ;
    }
    elsif ($pObj =~ m'/Resources(\s+\d+\s{1,2}\d+\s{1,2}R)'os)
    {   $reStr = $1;
        $to = $p + 10 + length($reStr);
    }
    else
    {  my $t = length($pObj);
       my $i = $p + 10;
       my $j = $i;
       my $k = 0;
       my $c;
       while ($i < $t)
       {   $c = substr($pObj,$i,1);
           if (($c eq '<' )
           ||  ($c eq '>'))
           {   if ($c eq '<' )
               {  $k++;
               }
               else
               {  $k--;
               }
               last if ($k == 0);
           }
           $i++;
       }
       if ($i != $t)
       {  $i++;
          $reStr = substr($pObj, $j, ($i - $j));
          $to = $i;
       }
   }

   if (wantarray)
   {  return ($reStr, $p, $to);
   }
   else
   {  return $reStr;
   }
}

# end of PDF::Reuse::checkResources
1;
