# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 633 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/_search_nodes.al)"
sub _search_nodes {
  my ($self, $low, $finger_low, $high ) = @_;
  my @nodes = ();

  $low  = $self->_first_node()->key(),  unless (defined $low);
  $high = $self->_greatest_node->key(), unless (defined $high);

  if ($self->_node_class->new($low)->key_cmp($high) > 0) {
    carp "low > high";
    return;
  }

  my ($node, $finger, $cmp) = $self->_search($low, $finger_low);
  if ($cmp) {
    return;
  } else {
    while ((defined $node) && ($node->key_cmp($high) <= 0)) {
      push @nodes, $node;
      $node = $node->header()->[0];
    }
  }
  return @nodes;
}

# end of Algorithm::SkipList::_search_nodes
1;
