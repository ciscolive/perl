# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 936 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/index_by_key.al)"
sub index_by_key {
  my ($self, $key) = @_;

  my $node  = $self->_first_node;
  my $index = 0;
  while ($node && ($node->key_cmp($key) < 0)) {
    $node = $node->header()->[0];
    $index++;
  }

  if ($node->key_cmp($key) == 0) {
    $self->last_key( $node, $index );
    return $index;
  } else {
    return;
  }
}

# end of Algorithm::SkipList::index_by_key
1;
