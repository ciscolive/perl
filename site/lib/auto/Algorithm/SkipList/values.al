# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 665 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/values.al)"
sub values {
  my ($self, $low, $finger_low, $high) = @_;

  my @values = map { $_->value }
    $self->_search_nodes($low, $finger_low, $high);
  return @values;
}

# end of Algorithm::SkipList::values
1;
