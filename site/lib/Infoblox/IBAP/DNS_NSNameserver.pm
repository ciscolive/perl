package Infoblox::DNS::Nameserver::Address;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields $_object_type);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    $_object_type = 'zone_name_server';
    register_wsdl_type('ib:zone_name_server','Infoblox::DNS::Nameserver::Address');
    %_allowed_members = (
                         address         => 1,
                         auto_create_ptr => 0,
                        );

    %_name_mappings = (
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       auto_create_ptr   => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       address         => \&ibap_o2i_string,
       auto_create_ptr => \&ibap_o2i_boolean,
      );

    @_return_fields =
      (
       tField('address'),
       tField('auto_create_ptr'),
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

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                             \%_reverse_name_mappings,
                                             undef,
                                             \%_ibap_to_object,
                                             \%_object_to_ibap,
                                             \@_return_fields,
                                            );
}

sub __ibap_object_type__ {

    return $_object_type;
}

#
#
#

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'auto_create_ptr'} = 0 unless defined($$ibap_object_ref{'auto_create_ptr'});

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

#
#
#

sub address
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'address', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub auto_create_ptr
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'auto_create_ptr', validator => \&ibap_value_o2i_boolean}, @_);
}

1;
