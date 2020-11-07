# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 599 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/greatest.al)"
sub greatest {
  my $self = shift;

  my $node = $self->_greatest_node;
  if ($node) {
    return ($node->key, $node->value);
  } else {
    carp "no _greatest_node", if (warnings::enabled);
    return;
  }
}

# end of Algorithm::SkipList::greatest
1;
