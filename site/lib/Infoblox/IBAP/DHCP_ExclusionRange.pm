package Infoblox::DHCP::ExclusionRange;

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
        comment         => 0,
        end_address     => 1,
        start_address   => 1,
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

sub comment
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub end_address
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'end_address', validator => \&ibap_value_o2i_string}, @_);
}

sub start_address
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'start_address', validator => \&ibap_value_o2i_string}, @_);
}

