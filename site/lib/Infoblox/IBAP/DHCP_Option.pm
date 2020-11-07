package Infoblox::DHCP::Option;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::PAPIOverrides;
use vars qw( @ISA %_allowed_members );
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN 
{
    %_allowed_members = (
        value           => 0, # XXX: leave it as 0 even though doc says it's required, we want to be able to undef it
        param           => 0,
        name            => 0,
        num             => 0,
        vendor_class    => 0,
        type            => 0,
        ipv4addrs       => 0,
        ipv4addr        => 0,
        seconds         => 0,
        offsets         => 0,
        offset          => 0,
    );
}

#
#
#

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

#
#
#

sub value
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'value', validator => \&ibap_value_o2i_string}, @_);
}

sub name
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub num
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'num', validator => \&ibap_value_o2i_string}, @_);
}

sub vendor_class
{
    my $self = shift;
    my $res = $self->__accessor_scalar__({name => 'vendor_class', validator => \&ibap_value_o2i_string}, @_);
    #
    if (scalar(@_) == 0 && not defined $res) {
        return 'DHCP';
    } elsif (scalar(@_) >= 1) {
        $self->{'vendor_class'} = 'DHCP' unless defined $self->{'vendor_class'};
    }
    return $res;
}

sub type
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'type', validator => \&ibap_value_o2i_string}, @_);
}

#
#
#
#
#
#
#
#
sub ipv4addr
{
    my $self = shift;    
    if (scalar(@_) != 0) {
        return ($self->__accessor_scalar__({name => 'value', validator => \&ibap_value_o2i_string}, @_) and $self->__accessor_scalar__({name => 'ipv4addr', validator => \&ibap_value_o2i_string}, @_));
    }
    return $self->__accessor_scalar__({name => 'ipv4addr', validator => \&ibap_value_o2i_string}, @_);
}

sub ipv4addrs
{
    my $self = shift;
    if (scalar(@_) != 0) {
        my $addrs_list = '';
        $addrs_list = join(',', @{$_[0]}) if defined $_[0];
        return ($self->__accessor_scalar__({name => 'value', validator => \&ibap_value_o2i_string}, $addrs_list) and $self->__accessor_array__({name => 'ipv4addrs', validator => { 'string' => \&ibap_value_o2i_string }}, @_));
    }
    return $self->__accessor_array__({name => 'ipv4addrs', validator => { 'string' => \&ibap_value_o2i_string }}, @_);
}

sub offset
{
    my $self = shift;
    if (scalar(@_) != 0) {
        return ($self->__accessor_scalar__({name => 'value', validator => \&ibap_value_o2i_string}, @_) and $self->__accessor_scalar__({name => 'offset', validator => \&ibap_value_o2i_uint}, @_));
    }
    return $self->__accessor_scalar__({name => 'offset', validator => \&ibap_value_o2i_uint}, @_);
}

sub offsets
{
    my $self = shift;
    if (scalar(@_) != 0) {
        my $offsets_list = '';
        $offsets_list = join(',', @{$_[0]}) if defined $_[0];
        return ($self->__accessor_scalar__({name => 'value', validator => \&ibap_value_o2i_string}, $offsets_list) and $self->__accessor_array__({name => 'offsets', validator => \&ibap_value_o2i_uint}, @_));
    }
    return $self->__accessor_array__({name => 'offsets', validator => \&ibap_value_o2i_uint}, @_);
}

sub seconds
{
    my $self = shift;
    if (scalar(@_) != 0) {
        return ($self->__accessor_scalar__({name => 'value', validator => \&ibap_value_o2i_string}, @_) and $self->__accessor_scalar__({name => 'seconds', validator => \&ibap_value_o2i_string}, @_));
    }
    return $self->__accessor_scalar__({name => 'seconds', validator => \&ibap_value_o2i_string}, @_);
}

sub param
{
    my $self = shift;
    if (scalar(@_) != 0) {
        return ($self->__accessor_scalar__({name => 'value', validator => \&ibap_value_o2i_string}, @_) and $self->__accessor_array__({name => 'param', validator => \&ibap_value_o2i_string}, @_));
    }
    return $self->__accessor_array__({name => 'param', validator => \&ibap_value_o2i_string}, @_);
}

