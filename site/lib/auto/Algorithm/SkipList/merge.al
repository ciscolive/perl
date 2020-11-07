# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 783 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/merge.al)"
sub merge {

  my $list1 = shift;

  my $list2 = shift;

  my ($finger1, $finger2);
  my ($node1) = $list1->_first_node;
  my ($node2) = $list2->_first_node;

  while ($node1 || $node2) {

    my $cmp = ($node1) ? (
      ($node2) ? $node1->key_cmp( $node2->key ) : 1 ) : -1;
    
    if ($cmp < 0) {                     # key1 < key2
      if ($node1) {
	$finger1 = $list1->insert( $node1->key, $node1->value, );
	$node1 = $node1->header()->[0];
      } else {
	$finger1 = $list1->insert( $node2->key, $node2->value, );
	$node2 = $node2->header()->[0];
      }
    } elsif ($cmp > 0) {                # key1 > key2
      if ($node2) {
	$finger1 = $list1->insert( $node2->key, $node2->value, );
	$node2 = $node2->header()->[0];
      } else {
	$finger1 = $list1->insert( $node1->key, $node1->value, );
	$node1 = $node1->header()->[0];
      }
    } else {                            # key1 = key2
      $node1 = $node1->header()->[0],
	if $node1;
      $node2 = $node2->header()->[0],
	if $node2;
    }
  }
}

# end of Algorithm::SkipList::merge
1;
