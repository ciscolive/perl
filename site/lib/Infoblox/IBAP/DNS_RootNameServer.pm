package Infoblox::DNS::RootNameServer;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    #
    #
    #
    #

    %_allowed_members = (
                         ipv6addr               => 0,
                         ipv4addr               => 0,
                         host_name              => 1,
                        );
}

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

#
#
#
#
#
#
#
#

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

sub ipv6addr
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6addr', validator => \&ibap_value_o2i_ipv6addr}, @_);
}

sub ipv4addr
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv4addr', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub host_name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'host_name', validator => \&ibap_value_o2i_string}, @_);
}

1;
