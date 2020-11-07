package GeoIP2::Record::Postal;

use strict;
use warnings;

our $VERSION = '2.006002';

use Moo;

use GeoIP2::Types qw( NonNegativeInt Str );

use namespace::clean -except => 'meta';

has code => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_code',
);

has confidence => (
    is        => 'ro',
    isa       => NonNegativeInt,
    predicate => 'has_confidence',
);

1;

# ABSTRACT: Contains data for the postal code record associated with an IP address

__END__

=pod

=encoding UTF-8

=head1 NAME

GeoIP2::Record::Postal - Contains data for the postal code record associated with an IP address

=head1 VERSION

version 2.006002

=head1 SYNOPSIS

  use 5.008;

  use GeoIP2::WebService::Client;

  my $client = GeoIP2::WebService::Client->new(
      account_id  => 42,
      license_key => 'abcdef123456',
  );

  my $insights = $client->insights( ip => '24.24.24.24' );

  my $postal_rec = $insights->postal();
  print $postal_rec->code(), "\n";

=head1 DESCRIPTION

This class contains the postal code data associated with an IP address.

This record is returned by all the end points except the Country end point.

=head1 METHODS

This class provides the following methods:

=head2 $postal_rec->code()

This returns the postal code associated with the IP address. Postal codes are
not available for all countries. In some countries, this will only contain
part of the postal code.

This attribute is returned by all end points except the Country end point.

=head2 $postal_rec->confidence()

This returns a value from 0-100 indicating MaxMind's confidence that the
postal code is correct.

This attribute is only available from the Insights end point and the GeoIP2
Enterprise database.

=head1 SUPPORT

Bugs may be submitted through L<https://github.com/maxmind/GeoIP2-perl/issues>.

=head1 AUTHORS

=over 4

=item *

Dave Rolsky <drolsky@maxmind.com>

=item *

Greg Oschwald <goschwald@maxmind.com>

=item *

Mark Fowler <mfowler@maxmind.com>

=item *

Olaf Alders <oalders@maxmind.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 - 2019 by MaxMind, Inc.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
