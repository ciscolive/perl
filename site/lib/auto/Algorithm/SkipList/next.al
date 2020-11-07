# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 611 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/next.al)"
sub next {
  my $self = shift;

  my ($key, $finger, $value) = $self->next_key;

  if (defined $key) {
    return ($key, $value)
  } else {
    return;
  }
}

# end of Algorithm::SkipList::next
1;
