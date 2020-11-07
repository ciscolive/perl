# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 914 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/key_by_index.al)"
sub key_by_index {
  my ($self, $index) = @_;

  my $node = $self->_node_by_index($index);
  if ($node) {
    return $node->key;
  } else {
    return;
  }
}

# end of Algorithm::SkipList::key_by_index
1;
