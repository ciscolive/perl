package #
Date::Manip::TZ::amphoe00;
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
        [ [1,1,2,0,0,0],[1,1,1,16,31,42],'-07:28:18',[-7,-28,-18],
          'LMT',0,[1883,11,18,18,59,59],[1883,11,18,11,31,41],
          '0001010200:00:00','0001010116:31:42','1883111818:59:59','1883111811:31:41' ],
     ],
   1883 =>
     [
        [ [1883,11,18,19,0,0],[1883,11,18,12,0,0],'-07:00:00',[-7,0,0],
          'MST',0,[1918,3,31,8,59,59],[1918,3,31,1,59,59],
          '1883111819:00:00','1883111812:00:00','1918033108:59:59','1918033101:59:59' ],
     ],
   1918 =>
     [
        [ [1918,3,31,9,0,0],[1918,3,31,3,0,0],'-06:00:00',[-6,0,0],
          'MDT',1,[1918,10,27,7,59,59],[1918,10,27,1,59,59],
          '1918033109:00:00','1918033103:00:00','1918102707:59:59','1918102701:59:59' ],
        [ [1918,10,27,8,0,0],[1918,10,27,1,0,0],'-07:00:00',[-7,0,0],
          'MST',0,[1919,3,30,8,59,59],[1919,3,30,1,59,59],
          '1918102708:00:00','1918102701:00:00','1919033008:59:59','1919033001:59:59' ],
     ],
   1919 =>
     [
        [ [1919,3,30,9,0,0],[1919,3,30,3,0,0],'-06:00:00',[-6,0,0],
          'MDT',1,[1919,10,26,7,59,59],[1919,10,26,1,59,59],
          '1919033009:00:00','1919033003:00:00','1919102607:59:59','1919102601:59:59' ],
        [ [1919,10,26,8,0,0],[1919,10,26,1,0,0],'-07:00:00',[-7,0,0],
          'MST',0,[1942,2,9,8,59,59],[1942,2,9,1,59,59],
          '1919102608:00:00','1919102601:00:00','1942020908:59:59','1942020901:59:59' ],
     ],
   1942 =>
     [
        [ [1942,2,9,9,0,0],[1942,2,9,3,0,0],'-06:00:00',[-6,0,0],
          'MWT',1,[1944,1,1,6,0,59],[1944,1,1,0,0,59],
          '1942020909:00:00','1942020903:00:00','1944010106:00:59','1944010100:00:59' ],
     ],
   1944 =>
     [
        [ [1944,1,1,6,1,0],[1943,12,31,23,1,0],'-07:00:00',[-7,0,0],
          'MST',0,[1944,4,1,7,0,59],[1944,4,1,0,0,59],
          '1944010106:01:00','1943123123:01:00','1944040107:00:59','1944040100:00:59' ],
        [ [1944,4,1,7,1,0],[1944,4,1,1,1,0],'-06:00:00',[-6,0,0],
          'MWT',1,[1944,10,1,6,0,59],[1944,10,1,0,0,59],
          '1944040107:01:00','1944040101:01:00','1944100106:00:59','1944100100:00:59' ],
        [ [1944,10,1,6,1,0],[1944,9,30,23,1,0],'-07:00:00',[-7,0,0],
          'MST',0,[1967,4,30,8,59,59],[1967,4,30,1,59,59],
          '1944100106:01:00','1944093023:01:00','1967043008:59:59','1967043001:59:59' ],
     ],
   1967 =>
     [
        [ [1967,4,30,9,0,0],[1967,4,30,3,0,0],'-06:00:00',[-6,0,0],
          'MDT',1,[1967,10,29,7,59,59],[1967,10,29,1,59,59],
          '1967043009:00:00','1967043003:00:00','1967102907:59:59','1967102901:59:59' ],
        [ [1967,10,29,8,0,0],[1967,10,29,1,0,0],'-07:00:00',[-7,0,0],
          'MST',0,[9999,12,31,0,0,0],[9999,12,30,17,0,0],
          '1967102908:00:00','1967102901:00:00','9999123100:00:00','9999123017:00:00' ],
     ],
);

%LastRule      = (
);

1;