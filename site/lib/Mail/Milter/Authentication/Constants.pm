package Mail::Milter::Authentication::Constants;
# ABSTRACT: Define and export useful constants
use 5.20.0;
use strict;
use warnings;
##use Mail::Milter::Authentication::Pragmas;
# ABSTRACT: Common constants
our $VERSION = '2.20200930.2'; # VERSION
use base 'Exporter';


## no critic [Modules::ProhibitAutomaticExportation]

# Syslog Constants

use constant LOG_DEBUG   => 7;
use constant LOG_INFO    => 6;
use constant LOG_NOTICE  => 5;
use constant LOG_WARNING => 4;
use constant LOG_ERR     => 3;
use constant LOG_CRIT    => 2;
use constant LOG_ALERT   => 1;
use constant LOG_EMERG   => 0;
use constant LOG_MAIL    => 16;

# Sendmail Constants

use constant SMFIA_UNKNOWN      => 'U';
use constant SMFIA_UNIX         => 'L';
use constant SMFIA_INET         => '4';
use constant SMFIA_INET6        => '6';

use constant SMFIC_ABORT        => 'A';
use constant SMFIC_BODY         => 'B';
use constant SMFIC_CONNECT      => 'C';
use constant SMFIC_MACRO        => 'D';
use constant SMFIC_BODYEOB      => 'E';
use constant SMFIC_HELO         => 'H';
use constant SMFIC_HEADER       => 'L';
use constant SMFIC_MAIL         => 'M';
use constant SMFIC_EOH          => 'N';
use constant SMFIC_OPTNEG       => 'O';
use constant SMFIC_RCPT         => 'R';
use constant SMFIC_QUIT         => 'Q';
use constant SMFIC_DATA         => 'T';
use constant SMFIC_UNKNOWN      => 'U';

use constant SMFIR_ADDRCPT      => '+';
use constant SMFIR_DELRCPT      => '-';
use constant SMFIR_ACCEPT       => 'a';
use constant SMFIR_REPLBODY     => 'b';
use constant SMFIR_CONTINUE     => 'c';
use constant SMFIR_DISCARD      => 'd';
use constant SMFIR_ADDHEADER    => 'h';
use constant SMFIR_INSHEADER    => 'i';
use constant SMFIR_CHGHEADER    => 'm';
use constant SMFIR_PROGRESS     => 'p';
use constant SMFIR_QUARANTINE   => 'q';
use constant SMFIR_REJECT       => 'r';
use constant SMFIR_SETSENDER    => 's';
use constant SMFIR_TEMPFAIL     => 't';
use constant SMFIR_REPLYCODE    => 'y';

use constant SMFIP_NOCONNECT    => 0x01;
use constant SMFIP_NOHELO       => 0x02;
use constant SMFIP_NOMAIL       => 0x04;
use constant SMFIP_NORCPT       => 0x08;
use constant SMFIP_NOBODY       => 0x10;
use constant SMFIP_NOHDRS       => 0x20;
use constant SMFIP_NOEOH        => 0x40;
use constant SMFIP_NONE         => 0x7F;
use constant SMFIP_HDR_LEADSPC  => 0x100000;

use constant SMFIS_CONTINUE     => 100;
use constant SMFIS_REJECT       => 101;
use constant SMFIS_DISCARD      => 102;
use constant SMFIS_ACCEPT       => 103;
use constant SMFIS_TEMPFAIL     => 104;

use constant SMFIF_ADDHDRS      => 0x01;
use constant SMFIF_CHGBODY      => 0x02;
use constant SMFIF_ADDRCPT      => 0x04;
use constant SMFIF_DELRCPT      => 0x08;
use constant SMFIF_CHGHDRS      => 0x10;
use constant SMFIF_MODBODY      => SMFIF_CHGBODY;
use constant SMFIF_QUARANTINE   => 0x20;
use constant SMFIF_SETSENDER    => 0x40;

use constant SMFI_V1_ACTS       => SMFIF_ADDHDRS|SMFIF_CHGBODY|SMFIF_ADDRCPT|SMFIF_DELRCPT;
use constant SMFI_V2_ACTS       => SMFI_V1_ACTS|SMFIF_CHGHDRS;
use constant SMFI_CURR_ACTS     => SMFI_V2_ACTS;

our @EXPORT = qw(
    LOG_DEBUG
    LOG_INFO
    LOG_NOTICE
    LOG_WARNING
    LOG_ERR
    LOG_CRIT
    LOG_ALERT
    LOG_EMERG
    LOG_MAIL
    SMFIA_UNKNOWN
    SMFIA_UNIX
    SMFIA_INET
    SMFIA_INET6
    SMFIC_ABORT
    SMFIC_BODY
    SMFIC_CONNECT
    SMFIC_MACRO
    SMFIC_BODYEOB
    SMFIC_HELO
    SMFIC_HEADER
    SMFIC_MAIL
    SMFIC_EOH
    SMFIC_OPTNEG
    SMFIC_RCPT
    SMFIC_QUIT
    SMFIC_DATA
    SMFIC_UNKNOWN
    SMFIR_ADDRCPT
    SMFIR_DELRCPT
    SMFIR_ACCEPT
    SMFIR_REPLBODY
    SMFIR_CONTINUE
    SMFIR_DISCARD
    SMFIR_ADDHEADER
    SMFIR_INSHEADER
    SMFIR_CHGHEADER
    SMFIR_PROGRESS
    SMFIR_QUARANTINE
    SMFIR_REJECT
    SMFIR_SETSENDER
    SMFIR_TEMPFAIL
    SMFIR_REPLYCODE
    SMFIP_NOCONNECT
    SMFIP_NOHELO
    SMFIP_NOMAIL
    SMFIP_NORCPT
    SMFIP_NOBODY
    SMFIP_NOHDRS
    SMFIP_NOEOH
    SMFIP_NONE
    SMFIP_HDR_LEADSPC
    SMFIS_CONTINUE
    SMFIS_REJECT
    SMFIS_DISCARD
    SMFIS_ACCEPT
    SMFIS_TEMPFAIL
    SMFIF_ADDHDRS
    SMFIF_CHGBODY
    SMFIF_ADDRCPT
    SMFIF_DELRCPT
    SMFIF_CHGHDRS
    SMFIF_MODBODY
    SMFIF_QUARANTINE
    SMFIF_SETSENDER
    SMFI_V1_ACTS
    SMFI_V2_ACTS
    SMFI_CURR_ACTS
);
our @EXPORT_OK = ( @EXPORT );
our %EXPORT_TAGS = ( 'all' => [ @EXPORT_OK ] );

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Mail::Milter::Authentication::Constants - Define and export useful constants

=head1 VERSION

version 2.20200930.2

=head1 SYNOPSIS

Constants defined here are used in the sendmail milter protocol

=head1 DESCRIPTION

Exports useful constants.

=head1 AUTHOR

Marc Bradshaw <marc@marcbradshaw.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Marc Bradshaw.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
