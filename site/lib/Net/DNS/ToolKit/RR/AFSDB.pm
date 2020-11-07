package Net::DNS::ToolKit::RR::AFSDB;

use strict;
#use warnings;

use Net::DNS::ToolKit qw(
	get16
	put16
	dn_comp
	dn_expand
);
use Net::DNS::Codes qw(:constants);
use vars qw($VERSION);

$VERSION = do { my @r = (q$Revision: 0.03 $ =~ /\d+/g); sprintf "%d."."%02d" x $#r, @r };

=head1 NAME

Net::DNS::ToolKit::RR::AFSDB - Resource Record Handler

=head1 SYNOPSIS

  DO NOT use Net::DNS::ToolKit::RR::AFSDB
  DO NOT require Net::DNS::ToolKit::RR::AFSDB

  Net::DNS::ToolKit::RR::AFSDB is autoloaded by 
  class Net::DNS::ToolKit::RR and its methods
  are instantiated in a 'special' manner.

  use Net::DNS::ToolKit::RR;
  ($get,$put,$parse) = new Net::DNS::ToolKit::RR;

  ($newoff,$name,$type,$class,$ttl,$rdlength,
        $subtype,$hostname) = $get->AFSDB(\$buffer,$offset);

  Note: the $get->AFSDB method is normally called
  via:  @stuff = $get->next(\$buffer,$offset);

  ($newoff,@dnptrs)=$put->AFSDB(\$buffer,$offset,\@dnptrs,
	$name,$type,$class,$ttl,$subtype,$hostname);

  $NAME,$TYPE,$CLASS,$TTL,$rdlength,$subtype,$AFSDBDNAME) 
    = $parse->AFSDB($name,$type,$class,$ttl,$rdlength,
        $subtype,$hostname);

=head1 DESCRIPTION

B<Net::DNS::ToolKit::RR:AFSDB> appends an AFSDB resource record to a DNS packet
under construction, recovers an AFSDB resource record from a packet being decoded, and
converts the numeric/binary portions of the resource record to human
readable form.

  Description from RFC1035.txt

  3.2.1. Format

  All RRs have the same top level format shown below:

                                    1  1  1  1  1  1
      0  1  2  3  4  5  6  7  8  9  0  1  2  3  4  5
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+  
    |                      NAME                     |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                      TYPE                     |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                     CLASS                     |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                      TTL                      |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                   RDLENGTH                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--|
    |                     RDATA                     |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

  NAME  an owner name, i.e., the name of the node to which this
	resource record pertains.

  TYPE  two octets containing one of the RR TYPE codes.

  CLASS two octets containing one of the RR CLASS codes.

  TTL   a 32 bit signed integer that specifies the time interval
	that the resource record may be cached before the source
	of the information should again be consulted.  Zero
	values are interpreted to mean that the RR can only be
	used for the transaction in progress, and should not be
	cached.  For example, SOA records are always distributed
	with a zero TTL to prohibit caching.  Zero values can
	also be used for extremely volatile data.

  RDLENGTH an unsigned 16 bit integer that specifies the length
	in octets of the RDATA field.

  RDATA a variable length string of octets that describes the
	resource.  The format of this information varies
	according to the TYPE and CLASS of the resource record.

  Description from RFC1183.txt

    1. AFSDB RDATA format

    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |                    SUBTYPE                    |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    /                   HOSTNAME                    /
    /                                               /
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+

    where:

   AFSDB has the following format:

   <owner> <ttl> <class> AFSDB <subtype> <hostname>

Both RDATA fields are required in all AFSDB RRs.  The <subtype> field
is a 16 bit integer.  The <hostname> field is a domain name of a host
that has a server for the cell named by the owner name of the RR.

The format of the AFSDB RR is class insensitive.  AFSDB records cause
type A additional section processing for <hostname>.  This, in fact,
is the rationale for using a new type code, rather than trying to
build the same functionality with TXT RRs.

Note that the format of AFSDB in a master file is identical to MX.
For purposes of the DNS itself, the subtype is merely an integer.
The present subtype semantics are discussed below, but changes are
possible and will be announced in subsequent RFCs.

=over 4

=item * @stuff = $get->AFSDB(\$buffer,$offset);

  Get the contents of the resource record.

  USE: @stuff = $get->next(\$buffer,$offset);

  where: @stuff = (
  $newoff $name,$type,$class,$ttl,$rdlength,
  $subtype,$hostname );

All except the last two items, B<$subtype, $hostname>, are provided by
the class loader, B<Net::DNS::ToolKit::RR>. The code in this method knows
how to retrieve B<$subtype, $hostname>.

  input:        pointer to buffer,
                offset into buffer
  returns:      offset to next resource,
                @common RR elements,
		subtype,
		host domain name

=cut

sub get {
  my($self,$bp,$offset) = @_;
  $offset += INT16SZ;	# don't need rdlength
  (my $subtype,$offset) = get16($bp,$offset);
  ($offset, my $hostname) = dn_expand($bp,$offset);
  return ($offset,$subtype,$hostname);
}

=item * ($newoff,@dnptrs)=$put->AFSDB(\$buffer,$offset,\@dnptrs,
	$name,$type,$class,$ttl,$subtype,$hostname);

Append an AFSDB record to $buffer.

  where @common = (
	$name,$type,$class,$ttl);

The method will insert the $rdlength, $subtype and $hostname, then
return the updated pointer to the array of compressed names            

The class loader, B<Net::DNS::ToolKit::RR>, inserts the @common elements and
returns updated @dnptrs. This module knows how to insert its RDATA and
calculate the $rdlength.

  input:        pointer to buffer,
                offset (normally end of buffer), 
                pointer to compressed name array,
                @common RR elements,
                subtype
                host domain name
  output:       offset to next RR,
                new compressed name pointer array,
           or   empty list () on error.

=cut

sub put {
  return () unless @_;	# always return on error
  my($self,$bp,$off,$dnp,$subtype,$hostname) = @_;
  my $rdlp = $off;	# save pointer to rdlength
  my $doff;		# data offset
  return () unless	# check for valid offset and get
	($doff = put16($bp,$off,0)) && # offset for subtype
	($off = put16($bp,$doff,$)) &&
	(@_ = dn_comp($bp,$off,\$hostname,$dnp));

  # new offset is first item in @_
  # rdlength = new offset - previous offset
  put16($bp,$rdlp, $_[0] - $doff);
  return(@_);
}

=item * (@COMMON,$subtype,$AFSDBDNAME) = $parse->AFSDB(@common,$subtype,$hostname);

Converts binary/numeric field data into human readable form. The common RR
elements are supplied by the class loader, B<Net::DNS::ToolKit::RR>.
For AFSDB RR's, this returns $hostname terminated with '.'

  input:	subtype,
		AFSDB Domain Name
  returns:	subtype
		AFSDB Domain Name.

=back

=cut

sub parse {
  my($self,$subtype,$hostname) = @_;
  return ($subtype,$hostname.'.');
}

=head1 DEPENDENCIES

	Net::DNS::ToolKit
	Net::DNS::Codes

=head1 EXPORT

	none

=head1 AUTHOR

Michael Robinton <michael@bizsystems.com>

=head1 COPYRIGHT

    Copyright 2003 - 2011, Michael Robinton <michael@bizsystems.com>
   
Michael Robinton <michael@bizsystems.com>

All rights reserved.

This program is free software; you can redistribute it and/or modify
it under the terms of either:

  a) the GNU General Public License as published by the Free
  Software Foundation; either version 2, or (at your option) any
  later version, or

  b) the "Artistic License" which comes with this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See either    
the GNU General Public License or the Artistic License for more details.

You should have received a copy of the Artistic License with this
distribution, in the file named "Artistic".  If not, I'll be glad to provide
one.

You should also have received a copy of the GNU General Public License
along with this program in the file named "Copying". If not, write to the

        Free Software Foundation, Inc.                        
        59 Temple Place, Suite 330
        Boston, MA  02111-1307, USA                                     

or visit their web page on the internet at:                      

        http://www.gnu.org/copyleft/gpl.html.

=head1 See also:

Net::DNS::Codes(3), Net::DNS::ToolKit(3)

=cut

1;
