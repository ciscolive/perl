package Infoblox::DNS::MSServer;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    register_wsdl_type('ib:ms_dns_server','Infoblox::DNS::MSServer');
    %_allowed_members = (
                         address  => 1,
                         ipv4addr => 1,
                         name     => 1,
                         stealth  => 0,
                         ms_parent_delegated => -1,
                        );

    %_name_mappings = (
                       'address'  => 'ms_server',
                       'ipv4addr' => 'ns_ip',
                       'name'     => 'ns_name',
                       'ms_parent_delegated' => 'shared_with_ms_parent_delegation',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       ms_server => \&__i2o_msserver__,
       stealth   => \&ibap_i2o_boolean,
       shared_with_ms_parent_delegation => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       address  => \&__o2i_msserver__,
       stealth  => \&ibap_o2i_boolean,
       ipv4addr => \&ibap_o2i_string,
       name     => \&ibap_o2i_string,
       ms_parent_delegated => \&ibap_o2i_ignore,
      );

    @_return_fields =
      (
       tField('ms_server', { sub_fields => [ tField('address')]}),
       tField('ns_ip'),
       tField('ns_name'),
       tField('stealth'),
       tField('shared_with_ms_parent_delegation'),
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

#
#
#

sub __i2o_msserver__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return $ibap_object_ref->{$current}->{'address'};
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'stealth'} = 0 unless defined($$ibap_object_ref{'stealth'});
    $$ibap_object_ref{'shared_with_ms_parent_delegation'} = 0 unless defined($$ibap_object_ref{'shared_with_ms_parent_delegation'});

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

#
#
#

sub __o2i_msserver__
{
	my ($self, $session, $current, $tempref, $type) = @_;

    return (1, 0, ibap_readfield_simple_string('MsServer', 'address', $self->{$current}));
}

#
#
#

sub address
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'address', validator => \&ibap_value_o2i_string}, @_);
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub ipv4addr
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv4addr', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub stealth
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'stealth', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ms_parent_delegated
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_parent_delegated', validator => \&ibap_value_o2i_boolean}, @_);
}

1;
