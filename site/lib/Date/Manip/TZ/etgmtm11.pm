package #
Date::Manip::TZ::etgmtm11;
# Copyright (c) 2008-2020 Sullivan Beck.  All rights reserved.
# This program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

# This file was automatically generated.  Any changes to this file will
# be lost the next time 'tzdata' is run.
#    Generated on: Mon Jun  1 07:57:10 EDT 2020
#    Data version: tzdata2020a
#    Code version: tzcode2020a

# This module contains data from the zoneinfo time zone database.  The original
# data was obtained from the URL:
#    ftp://ftp.iana.org/tz

use strict;
use warnings;
require 5.010000;

our (%Dates,%LastRule);
END {
   undef %Dates;
   undef %LastRule;
}

our ($VERSION);
$VERSION='6.82';
END { undef $VERSION; }

%Dates         = (
   1    =>
     [
        [ [1,1,2,0,0,0],[1,1,1,17,0,0],'-07:00:00',[-7,0,0],
          'GMT-7',0,[9999,12,31,0,0,0],[9999,12,30,17,0,0],
          '0001010200:00:00','0001010117:00:00','9999123100:00:00','9999123017:00:00' ],
     ],
);

%LastRule      = (
);

1;
