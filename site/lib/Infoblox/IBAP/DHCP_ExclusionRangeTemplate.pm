package Infoblox::DHCP::ExclusionRangeTemplate;

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
        comment                 => 0,
        number_of_addresses     => 1,
        offset                  => 1,
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

sub number_of_addresses
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'number_of_addresses', validator => \&ibap_value_o2i_uint}, @_);
}

sub offset
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'offset', validator => \&ibap_value_o2i_uint}, @_);
}

