# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 925 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/value_by_index.al)"
sub value_by_index {
  my ($self, $index) = @_;

  my $node = $self->_node_by_index($index);
  if ($node) {
    return $node->value;
  } else {
    return;
  }
}

# end of Algorithm::SkipList::value_by_index
1;
