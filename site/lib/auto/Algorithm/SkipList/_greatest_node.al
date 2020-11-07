# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 571 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/_greatest_node.al)"
sub _greatest_node {
  my ($self) = @_;

  my $list = $self->{LIST_END} || $self->list;

  my $level = $list->level-1;
  do {
    while ($list->header()->[$level]) {
      $list = $list->header()->[$level];
    }
  } while (--$level >=0);

  $self->{LIST_END} = $list;
}

# end of Algorithm::SkipList::_greatest_node
1;
