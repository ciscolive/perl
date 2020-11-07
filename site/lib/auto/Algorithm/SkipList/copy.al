# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 760 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/copy.al)"
sub copy {
  my $self = shift;

  my ($key, $finger_or, $key_to) = @_;

  my $list = __PACKAGE__->new(
    max_level  => $self->max_level,
    p          => $self->p,
    node_class => $self->_node_class,
  );
  $list->{DUPLICATES} = $self->{DUPLICATES};

  my @nodes = $self->_search_nodes($key, $finger_or, $key_to);
  return, unless (@nodes);

  my $finger_cp;
  foreach my $node (@nodes) {
    $finger_cp = $list->insert($node->key, $node->value, $finger_cp);
  }

  return $list;
}

# end of Algorithm::SkipList::copy
1;
