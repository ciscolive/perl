package Infoblox::DNS::Nameserver;

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
                         gss_tsig_dns_principal => 0,
                         gss_tsig_domain        => 0,
                         stealth                => 0,
                         TSIGalgorithm          => 0,
                         TSIGkey                => 0,
                         TSIGname               => 0,
                         ipv6addr               => 0,
                         ipv4addr               => 0,
                         ddns_zone              => 0,
                         name                   => 0,
                         ms_parent_delegated    => -1,
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

    #
    $self->TSIGalgorithm('HMAC-MD5') unless defined $self->TSIGalgorithm();

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

sub gss_tsig_dns_principal
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'gss_tsig_dns_principal', validator => \&ibap_value_o2i_string}, @_);
}

sub gss_tsig_domain
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'gss_tsig_domain', validator => \&ibap_value_o2i_string}, @_);
}

sub stealth
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'stealth', validator => \&ibap_value_o2i_boolean}, @_);
}

sub TSIGkey
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'TSIGkey', validator => \&ibap_value_o2i_string}, @_);
}

sub TSIGname
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'TSIGname', validator => \&ibap_value_o2i_string}, @_);
}

sub TSIGalgorithm
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'TSIGalgorithm', enum => ['HMAC-SHA256', 'HMAC-MD5']}, @_);
}

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

sub ddns_zone
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ddns_zone', validator => \&ibap_value_o2i_string}, @_);
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub ms_parent_delegated
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_parent_delegated', validator => \&ibap_value_o2i_boolean}, @_);
}

1;
