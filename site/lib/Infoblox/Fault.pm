#
# Copyright (c) 2017 Infoblox Inc. All Rights Reserved.
#
#
#

package Infoblox::Fault;

use Exporter 'import';
@EXPORT_OK = qw(new papi_error);

use Carp;
use vars qw ( @ISA );

use Infoblox::Util;

sub new {
    my $class = shift;

    my ($faultref, $op, $object, $code, $text) = @_;
    my $self = {};
    bless $self , $class;

    unless ($faultref) {
        #

        $self->{'code'} = $code;
        $self->{'text'} = $text;
    }
    else {
        my $faultcode = $faultref->{'faultcode'};
        my $faultstring = $faultref->{'faultstring'};

        #
        $self->{'_fault'} = $faultref;

        my $detail;
        if ($faultref->{'detail'} && $faultref->{'detail'}->{'ib:Fault'}) {
            $detail = $faultref->{'detail'}->{'ib:Fault'};
        }

        if ($faultcode =~ /DuplicateObject/ || ($detail && defined $detail->{'code'} && $detail->{'code'} eq 'DB.DuplicateObject')) {
            $self->{'code'} = 1005;
        } elsif ($detail && $faultcode =~ /\.ReadField\.NotFound/ &&
                 $detail->{'data'} =~ /^(\d+)=([^=]+)=(.*)/) {
            my ($code, $field, $value) = ($1, $2, $3);
            if ($field eq 'extensible_attribute') {
                #
                $faultstring = "The '$value' extensible attribute does not exist in the database.";
            } else {
                $faultstring = "Member value '$value' for field '$field' did not match any records.";
            }
            $self->{'code'} = $code;
        } elsif ($detail && $faultcode =~ /\.ReadField\.NotUnique/ &&
                 $detail->{'data'} =~ /^(\d+)=([^=]+)=(.*)/) {
            my ($code, $field, $value) = ($1, $2, $3);
            $faultstring = "Member value '$value' for field '$field' matched multiple records.";

            #
            $self->{'code'} = 1012;
        } else {
            #
            #
            $self->{'code'} = 1012;
        }

        $self->{'text'} = $faultstring;
        $self->{'detail'} = $detail if defined $detail;
    }

    return $self;
}


#
#
#
#
#
#
sub papi_error {
    my ($code, $text) = @_;
    
    return Infoblox::Fault->new(undef, undef, undef, $code, $text);
}


#
#
#
#
#
#
sub set_papi_error {
    my ($self, $session_obj, $typeobj, $error_override) = @_;

    $self->map_codes($typeobj) if ($typeobj);
    if ($error_override) {
        my ($old,$new) = split /=/, $error_override;
        if ($self->{'code'} eq $old) {
            $self->{'code'}=$new;
        }
    }
    Infoblox::Util::set_error_codes($self->code(), $self->text(), $session_obj);

    return undef;
}

#
sub map_codes
{
    my ($self, $obj) = @_;

    return unless ($obj && $self->{'_fault'});

    #
    #

    my $faultcode = $self->{'_fault'}->{'faultcode'};
    my $faultstring = $self->{'_fault'}->{'faultstring'};

    if ($faultcode =~ m/SOAP-ENV:Client.Ibap.Data/) {
        if ($faultstring eq "Action not allowed, parent object invalid."
            && ref($obj) eq "Infoblox::DNS::Host" ) {
            $self->{'text'} = 'No parent zone can be found';
            $self->{'code'} = 1012;
        }
        if (ref($obj) eq 'Infoblox::Grid::DNS::Nsgroup' or
            ref($obj) eq 'Infoblox::Cluster::DNS::Nsgroup' or
            ref($obj) eq 'Infoblox::DHCP::OptionDefinition')
        {
            #
            $self->{'code'} = 1001;
        }
    } elsif ($faultcode =~ m/ReadField.NotFound/) {
        (my $type = $object->{'__type'}) =~ s/^.*\.([^.]+)$/$1/;

        if ($type eq 'Permission') {
            #
            $self->{'text'} = 'Invalid search query: non-existent group or resource member.';
            $self->{'code'} = 1012;
        }
    }
}

sub code
{
    my $self = shift;
    return $self->{'code'};
}

sub text
{
    my $self = shift;
    return $self->{'text'};
}

sub detail
{
    my $self = shift;
    return $self->{'detail'};
}

1;
