#
# Copyright (c) 2017 Infoblox Inc. All Rights Reserved.
#
#
#

package Infoblox::Serialize;

use warnings;
use Exporter 'import';
@EXPORT_OK = qw(serialize_request);

use Carp;
use vars qw ( @ISA );

use Infoblox::IBAPSchema qw(%typefuncs);
use Infoblox::IBAPTypeUtil qw(xo);

#
#
#
#
#
#
#
#
sub serialize_request {
    my ($type, $header, $data) = @_;

    my $r =
          xo('<SOAP-ENV:Envelope', +4)
        . xo('xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/"')
        . xo('xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"')
        . xo('xmlns:xsd="http://www.w3.org/2001/XMLSchema"')
        . xo('xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"')
        . xo('xmlns="urn:ibap.infoblox.com">') . xo('', -2);

    if ($header && %$header) {
        $r .= xo('<SOAP-ENV:Header>', +2)
              . serialize_header($header)
              . xo('</SOAP-ENV:Header>', -2);
    }
    
    return $r
        . xo('<SOAP-ENV:Body>', +2)
        . &{$typefuncs{$type}}($type, $data)
        . xo('</SOAP-ENV:Body>', -2)
        . xo('</SOAP-ENV:Envelope>', -2);
}


#
#
sub serialize_header {
    my ($headerdata) = @_;

    return &{$typefuncs{'IBAPHeader'}}('IBAPHeader', $headerdata);
}

1;
