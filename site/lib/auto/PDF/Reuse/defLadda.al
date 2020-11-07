# NOTE: Derived from blib/lib/PDF/Reuse.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package PDF::Reuse;

#line 6859 "blib/lib/PDF/Reuse.pm (autosplit into blib/lib/auto/PDF/Reuse/defLadda.al)"
sub defLadda
{  my $code = "function Ladda() {";
   for (keys %fields)
   {  my $val = $fields{$_};
      if ($val =~ m'\s*js\s*\:(.+)'oi)
      {   $val = $1;
          $code .= "if (this.getField('$_')) this.getField('$_').value = $val; ";
      }
      else
      {  $val =~ s/([^A-Za-z0-9\-_.!* ])/sprintf("%%%02X", ord($1))/ge;
         $code .= "if (this.getField('$_')) this.getField('$_').value = unescape('$val'); ";
      }

   }
   $code .= " 1;} ";


   $initScript{'Ladda'} = $code;
   if ($duplicateInits)
   {  my $ny = skrivJS($code);
      return $ny;
   }
   else
   {  return 1;
   }
}

# end of PDF::Reuse::defLadda
1;
