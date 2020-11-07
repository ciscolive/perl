package Infoblox::DNS::Sortlist;

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
                         source_ipv6addr => 0,
                         source_ipv4addr => 0,
                         match_list      => 0,
                         comment         => 0,
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

sub source_ipv6addr
{
    my $self=shift;
    #
    return $self->__accessor_scalar__({name => 'source_ipv6addr', validator => \&ibap_value_o2i_string}, @_);
}

sub source_ipv4addr
{
    my $self=shift;
    #
    return $self->__accessor_scalar__({name => 'source_ipv4addr', validator => \&ibap_value_o2i_string}, @_);
}

sub match_list
{
    my $self=shift;
    #
    return $self->__accessor_array__({name => 'match_list', validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

1;
