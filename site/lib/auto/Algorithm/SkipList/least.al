# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 586 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/least.al)"
sub least {
  my $self = shift;

  my ($node) = $self->_first_node;

  if ($node) {
    return ($node->key, $node->value);
  } else {
    carp "no _first_node", if (warnings::enabled);
    return;
  }
}

# end of Algorithm::SkipList::least
1;
