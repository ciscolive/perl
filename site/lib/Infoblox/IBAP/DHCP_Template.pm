package Infoblox::DHCP::Template;

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
        name            => 1,
        offset          => 0,
        count           => 0,
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

sub name
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'name', validator => { 'string' => \&ibap_value_o2i_string }}, @_);
}

sub offset
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'offset', validator => \&ibap_value_o2i_uint}, @_);
}

sub count
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'count', validator => \&ibap_value_o2i_uint}, @_);
}

