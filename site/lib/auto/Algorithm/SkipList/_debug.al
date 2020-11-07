# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 955 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/_debug.al)"
sub _debug {

  my $self = shift;

  my $list   = $self->list;

  while ($list) {
    print STDERR
      $list->key||'undef', "=", $list->value||'undef'," ", $list,"\n";

    for(my $i=0; $i<$list->level; $i++) {
      print STDERR " ", $i," ", $list->header()->[$i]
	|| 'undef', "\n";
    }
#     print STDERR " P ", $list->prev() || 'undef', "\n";
    print STDERR "\n";

    $list = $list->header()->[0];
  }

}

1;
# end of Algorithm::SkipList::_debug
