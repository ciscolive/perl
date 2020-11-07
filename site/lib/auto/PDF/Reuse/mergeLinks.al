# NOTE: Derived from blib/lib/PDF/Reuse.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package PDF::Reuse;

#line 3112 "blib/lib/PDF/Reuse.pm (autosplit into blib/lib/auto/PDF/Reuse/mergeLinks.al)"
sub mergeLinks
{   my $tSida = $sida + 1;
    my $rad;
    my ($linkObject, $linkObjectNo);
    for my $link (@{$links{'-1'}}, @{$links{$tSida}} )
    {   my $x2 = $link->{x} + $link->{width};
        my $y2 = $link->{y} + $link->{height};
        if (exists $links{$link->{v}})
        {   $linkObjectNo = $links{$link->{v}};
        }
        else
        {   $objNr++;
            $objekt[$objNr] = $pos;
            my $v_n;
            my $v_v = '('.$link->{v}.')';
            if    ($link->{s} eq 'GoTo')
            {   $v_n = "D";
            }
            elsif ($link->{s} eq 'GoToA')
            {   $link->{s} = 'GoTo';
                $v_n       = 'D';
                $v_v       = $link->{v};
            }
            elsif ($link->{s} eq 'Launch')     {$v_n = 'F';}
            elsif ($link->{s} eq 'SubmitForm') {$v_n = 'F';}
            elsif ($link->{s} eq 'Named')
            {   $v_n = 'N';
                $v_v = $link->{v};
            }
            elsif ($link->{s} eq 'JavaScript') {$v_n = "JS";}
            else
            {   $v_n = $link->{s};
            }
            $rad = "$objNr 0 obj<</S/$link->{s}/$v_n$v_v>>endobj\n";
            $linkObjectNo = $objNr;
            $links{$link->{v}} = $objNr;
            $pos += syswrite UTFIL, $rad;
        }
        $rad = "/Subtype/Link/Rect[$link->{x} $link->{y} "
             . "$x2 $y2]/A $linkObjectNo 0 R/Border[0 0 0]";
        if (exists $links{$rad})
        {   push @annots, $links{$rad};
        }
        else
        {   $objNr++;
            $objekt[$objNr] = $pos;
            $links{$rad} = $objNr;
            $rad = "$objNr 0 obj<<$rad>>endobj\n";
            $pos += syswrite UTFIL, $rad;
            push @annots, $objNr;
        }
    }
    @{$links{'-1'}}   = ();
    @{$links{$tSida}} = ();
    $objNr++;
    $objekt[$objNr] = $pos;
    $rad = "$objNr 0 obj[\n";
    for (@annots)
    {  $rad .= "$_ 0 R\n";
    }
    $rad .= "]endobj\n";
    $pos += syswrite UTFIL, $rad;
    @annots = ();
    return $objNr;
}

# end of PDF::Reuse::mergeLinks
1;
