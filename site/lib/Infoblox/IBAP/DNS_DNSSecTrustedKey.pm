package Infoblox::DNS::DnssecTrustedKey;

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
                         key                => 1,
                         algorithm          => 1,
                         secure_entry_point => 0,
                         fqdn               => 1,
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
    $self->secure_entry_point('true') unless defined $self->secure_entry_point();
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

sub secure_entry_point
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'secure_entry_point', validator => \&ibap_value_o2i_boolean}, @_);
}

sub key
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'key', validator => \&ibap_value_o2i_string}, @_);
}

sub fqdn
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'fqdn', validator => \&ibap_value_o2i_string}, @_);
}

sub algorithm
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'algorithm', enum => \@dnssec_algorithm_list }, @_);
}

1;
