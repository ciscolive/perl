package Net::ACME::Constants;

#----------------------------------------------------------------------
# Please do NOT reference these from outside the Net::ACME namespace!
#----------------------------------------------------------------------

use strict;
use warnings;

our $VERSION;
BEGIN {
    $VERSION = '0.12';
}

our $HTTP_01_CHALLENGE_DCV_DIR_IN_DOCROOT = '.well-known/acme-challenge';

1;
