package Infoblox::DHCP::Member;

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
        ipv4addr => 0,
        ipv6addr => 0,
        name     => 0,
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

    if (! (defined $args{'ipv4addr'} || defined $args{'ipv6addr'})) {
        set_error_codes(1105, 'One of ipv4addr or ipv6addr is required.');
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

sub ipv4addr
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ipv4addr', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub ipv6addr
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ipv6addr', validator => \&ibap_value_o2i_ipv6addr}, @_);
}

sub name
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

