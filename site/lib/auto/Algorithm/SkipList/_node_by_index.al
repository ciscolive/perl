# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 871 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/_node_by_index.al)"
sub _node_by_index {
  my ($self, $index) = @_;

  # Bug: for some reason, change $[ does not affect this module.

#   if ($index >= $[) {
#     $index -= $[;
#   }

  if ($index < 0) {
    $index += $self->size;
  }

  if (($index < 0) || ($index >= $self->size)) {
    carp "index out of range", if (warnings::enabled);
    return;
  }


  my ($node, $last_index) = @{ $self->{LASTKEY} || [ ] };

  if ((defined $last_index)  && ($last_index <= $index)) {
    ($last_index, $index) = ($index, $index - $last_index);
  }
  else {
    $last_index = $index;
    $node = undef;
  }

  $node ||= $self->_first_node;

  unless ($node) {
    return;
  }

  while ($node && $index--) {
    $node = $node->header()->[0];
  }

  $self->last_key( $node, $last_index );
  return $node;
}

# end of Algorithm::SkipList::_node_by_index
1;
