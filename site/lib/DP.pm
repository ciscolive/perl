use Data::Peek;

use strict;
use warnings;

BEGIN { *DP:: = \%Data::Peek:: }
our $VERSION = "0.49";

1;

=head1 NAME

DP - Alias for Data::Peek

=head1 SYNOPSIS

  perl -MDP -wle'print DPeek for DDual ($?, 1)'

=head1 DESCRIPTION

See L<Data::Peek>.

=head1 AUTHOR

H.Merijn Brand <h.m.brand@xs4all.nl>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008-2020 H.Merijn Brand

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
