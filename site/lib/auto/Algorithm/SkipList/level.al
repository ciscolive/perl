# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 566 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/level.al)"
sub level {
  my $self = shift;
  return $self->list->level;
}

# end of Algorithm::SkipList::level
1;
