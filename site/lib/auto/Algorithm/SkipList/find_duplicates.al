# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 545 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/find_duplicates.al)"
sub find_duplicates {
  my ($self, $key, $finger) = @_;

  my ($node, $update_ref, $cmp) = $self->_search_with_finger($key, $finger);

  if ($cmp == 0) {
    my @values = ( $node->value );

    while ( ($node->header()->[0]) &&
	    ($node->header()->[0]->key_cmp($key) == 0) ) {
      $node = $node->header()->[0];
      push @values, $node->value;
    }

    return @values;
  }
  else {
    return;
  }
}

# end of Algorithm::SkipList::find_duplicates
1;
