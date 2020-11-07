package Infoblox::DHCP::Option60MatchRule;

use strict;

use Carp;
use Infoblox::IBAPBase;
use Infoblox::Util;
use Infoblox::PAPIOverrides;

use vars qw(@ISA %_allowed_members);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN
{   
    #
    #
    %_allowed_members = (
        is_substring => 0,
        match_value => 0,
        option_space => 0,
        substring_length => 0,
        substring_offset => 0,
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

sub is_substring 
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'is_substring', validator => \&ibap_value_o2i_boolean}, @_);
}
sub match_value 
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'match_value', validator => \&ibap_value_o2i_string}, @_);
}
sub option_space 
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'option_space', validator => \&ibap_value_o2i_string}, @_);
}
sub substring_length 
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'substring_length', validator => \&ibap_value_o2i_int}, @_);
}
sub substring_offset 
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'substring_offset', validator => \&ibap_value_o2i_int}, @_);
}

1;
