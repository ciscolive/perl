package #
Date::Manip::TZ::ambarb00;
# Copyright (c) 2008-2020 Sullivan Beck.  All rights reserved.
# This program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

# This file was automatically generated.  Any changes to this file will
# be lost the next time 'tzdata' is run.
#    Generated on: Mon Jun  1 07:57:14 EDT 2020
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
        [ [1,1,2,0,0,0],[1,1,1,20,1,31],'-03:58:29',[-3,-58,-29],
          'LMT',0,[1924,1,1,3,58,28],[1923,12,31,23,59,59],
          '0001010200:00:00','0001010120:01:31','1924010103:58:28','1923123123:59:59' ],
     ],
   1924 =>
     [
        [ [1924,1,1,3,58,29],[1924,1,1,0,0,0],'-03:58:29',[-3,-58,-29],
          'BMT',0,[1932,1,1,3,58,28],[1931,12,31,23,59,59],
          '1924010103:58:29','1924010100:00:00','1932010103:58:28','1931123123:59:59' ],
     ],
   1932 =>
     [
        [ [1932,1,1,3,58,29],[1931,12,31,23,58,29],'-04:00:00',[-4,0,0],
          'AST',0,[1977,6,12,5,59,59],[1977,6,12,1,59,59],
          '1932010103:58:29','1931123123:58:29','1977061205:59:59','1977061201:59:59' ],
     ],
   1977 =>
     [
        [ [1977,6,12,6,0,0],[1977,6,12,3,0,0],'-03:00:00',[-3,0,0],
          'ADT',1,[1977,10,2,4,59,59],[1977,10,2,1,59,59],
          '1977061206:00:00','1977061203:00:00','1977100204:59:59','1977100201:59:59' ],
        [ [1977,10,2,5,0,0],[1977,10,2,1,0,0],'-04:00:00',[-4,0,0],
          'AST',0,[1978,4,16,5,59,59],[1978,4,16,1,59,59],
          '1977100205:00:00','1977100201:00:00','1978041605:59:59','1978041601:59:59' ],
     ],
   1978 =>
     [
        [ [1978,4,16,6,0,0],[1978,4,16,3,0,0],'-03:00:00',[-3,0,0],
          'ADT',1,[1978,10,1,4,59,59],[1978,10,1,1,59,59],
          '1978041606:00:00','1978041603:00:00','1978100104:59:59','1978100101:59:59' ],
        [ [1978,10,1,5,0,0],[1978,10,1,1,0,0],'-04:00:00',[-4,0,0],
          'AST',0,[1979,4,15,5,59,59],[1979,4,15,1,59,59],
          '1978100105:00:00','1978100101:00:00','1979041505:59:59','1979041501:59:59' ],
     ],
   1979 =>
     [
        [ [1979,4,15,6,0,0],[1979,4,15,3,0,0],'-03:00:00',[-3,0,0],
          'ADT',1,[1979,9,30,4,59,59],[1979,9,30,1,59,59],
          '1979041506:00:00','1979041503:00:00','1979093004:59:59','1979093001:59:59' ],
        [ [1979,9,30,5,0,0],[1979,9,30,1,0,0],'-04:00:00',[-4,0,0],
          'AST',0,[1980,4,20,5,59,59],[1980,4,20,1,59,59],
          '1979093005:00:00','1979093001:00:00','1980042005:59:59','1980042001:59:59' ],
     ],
   1980 =>
     [
        [ [1980,4,20,6,0,0],[1980,4,20,3,0,0],'-03:00:00',[-3,0,0],
          'ADT',1,[1980,9,25,4,59,59],[1980,9,25,1,59,59],
          '1980042006:00:00','1980042003:00:00','1980092504:59:59','1980092501:59:59' ],
        [ [1980,9,25,5,0,0],[1980,9,25,1,0,0],'-04:00:00',[-4,0,0],
          'AST',0,[9999,12,31,0,0,0],[9999,12,30,20,0,0],
          '1980092505:00:00','1980092501:00:00','9999123100:00:00','9999123020:00:00' ],
     ],
);

%LastRule      = (
);

1;
