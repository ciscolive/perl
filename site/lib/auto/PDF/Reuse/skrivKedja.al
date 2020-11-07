# NOTE: Derived from blib/lib/PDF/Reuse.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package PDF::Reuse;

#line 6786 "blib/lib/PDF/Reuse.pm (autosplit into blib/lib/auto/PDF/Reuse/skrivKedja.al)"
sub skrivKedja
{  my $code = ' ';

   for (values %initScript)
   {   $code .= $_ . "\n";
   }
   $code .= "function Init() { ";
   $code .= 'if (typeof this.info.ModDate == "object")' . " { return true; }";
   for (@inits)
   {  $code .= $_ . "\n";
   }
   $code .= "} Init(); ";

   my $spar = skrivJS($code);
   undef @inits;
   undef %initScript;
   return $spar;
}

# end of PDF::Reuse::skrivKedja
1;
