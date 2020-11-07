# NOTE: Derived from lib/Algorithm/SkipList.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Algorithm::SkipList;

#line 673 "lib/Algorithm/SkipList.pm (autosplit into blib/lib/auto/Algorithm/SkipList/truncate.al)"
sub truncate {
  my $self = shift;

  my ($key, $finger) = @_;

  if (defined $key) {
    my ($node, $finger, $cmp) = $self->_search_with_finger( $key, $finger );
    if ($cmp == 0) {

      # This is the most braindead way to find the index of a node. We
      # could come up with more sophisticated way by saving the number
      # of "skips" in the forward pointers when we add nodes, but that
      # will significantly affect the speed.

      my $size = 1 + $self->index_by_key( $key );
#       {
# 	my $aux  = $self->list;
# 	while ($aux != $node) {
# 	  $size++;
# 	  $aux = $aux->header()->[0];
# 	}
#       }

      my $list = __PACKAGE__->new(
        max_level  => $self->max_level,
        p          => $self->p,
        node_class => $self->_node_class,
      );

      my $level   = $self->list->level;
      my $old_hdr = $self->list->header;
      my $new_hdr = $list->list->header;

      for (my $i=0; $i<$level; $i++) {

	if ($finger->[$i]) {
	  if ($finger->[$i] == $node) {
	    $new_hdr->[$i] = $finger->[$i];
	    $finger->[$i]  = undef;
	  }
	  else {
	    $new_hdr->[$i] = $finger->[$i]->header()->[$i];
	    $finger->[$i]->header()->[$i]  = undef;
	  }
	}
	elsif ($old_hdr->[$i]) {

	  if ($old_hdr->[$i] == $node) {
	    $new_hdr->[$i] = $old_hdr->[$i];
	    $old_hdr->[$i]  = undef;
	  }
	  else {
	    carp "unexpected situation",
	      if (warnings::enabled);
	    # If _search_with_finger does not stop on !$cmp but
	    # continues to remaining levels, then we should not
	    # need to worry about this.
	  }
	}


      }

      $list->{SIZE} = $self->size - $size;
      $self->{SIZE} = $size;

      $list->{LIST_END} = undef;
      $self->{LIST_END} = undef;

      $self->_adjust_level_threshold;
      $list->_adjust_level_threshold;

      return $list;
    }
    else {
    carp "key not found", if (warnings::enabled);
      return;
    }
  }
  else {
    croak "no key specified";
    return;
  }

}

# end of Algorithm::SkipList::truncate
1;
