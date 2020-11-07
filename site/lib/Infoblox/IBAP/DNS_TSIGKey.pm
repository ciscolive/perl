package Infoblox::DNS::TSIGKey;

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
                         key  => 0,
                         name => 0,
                         algorithm => 0,
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

	$self->__init_instance_constants__();

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

	$self->__init_instance_constants__();

    return $self;
}

sub __init_instance_constants__
{
	my $self = shift;

    #
    $self->algorithm('HMAC-MD5') unless defined $self->algorithm();
}

#
#
#

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub key
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'key', validator => \&ibap_value_o2i_string}, @_);
}

sub algorithm
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'algorithm', enum => ['HMAC-SHA256', 'HMAC-MD5']}, @_);
}

1;

