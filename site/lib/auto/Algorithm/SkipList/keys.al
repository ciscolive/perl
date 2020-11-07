# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 657 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/keys.al)"
sub keys {
  my ($self, $low, $finger_low, $high) = @_;

  my @keys = map { $_->key }
    $self->_search_nodes($low, $finger_low, $high);
  return @keys;
}

# end of Algorithm::SkipList::keys
1;
