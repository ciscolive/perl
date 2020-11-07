# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 823 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/append.al)"
sub append {
  my $list1 = shift;

  my $list2 = shift;

  unless (defined $list2) { return; }

  my $node = $list1->_greatest_node;
  if ($node) {

    my ($next) = $list2->_first_node;

    if ($list1->list->level > $list2->list->level) {

      if ($list1->list->level < $list1->max_level) {

	my $i = $list1->list->level;
	while (!defined $list1->list->header()->[$i]) { $i--; }
	$list1->list->header()->[$i+1] = $next;
      } else {
	my $i = $list1->list->level-1;
	my $x = $list1->list->header()->[$i];
	while (defined $x->header()->[$i]) {
	  $x = $x->header()->[$i];
	}
	$x->header()->[$i] = $next;
      }
      $node->header()->[0] = $next;

    } else {
      for (my $i=0; $i<$node->level; $i++) {
	$node->header()->[$i] = $next;
      }
      for (my $i=$list1->list->level; $i<$list2->list->level; $i++) {
	$list1->list->header()->[$i] = $next;
      }
    }

    $list1->{SIZE}    += $list2->size;
    $list1->{LIST_END} = $list2->{LIST_END};
  } else {
    $list1->{LIST}     = $list2->list;
    $list1->{SIZE}     = $list2->size;
    $list1->{LIST_END} = $list2->{LIST_END};
  }
  $list1->_adjust_level_threshold;
}

# end of Algorithm::SkipList::append
1;
