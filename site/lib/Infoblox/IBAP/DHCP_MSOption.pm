package Infoblox::DHCP::MSOption;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields %_TYPE_ENUM_MAPPINGS %_REVERSE_TYPE_ENUM_MAPPINGS @SPEED_TYPE_ENUM_MAPPINGS @_SPEED_TYPE_ENUM_MAPPINGS $_object_type);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    $_object_type = 'ms_custom_option';
    register_wsdl_type('ib:ms_custom_option','Infoblox::DHCP::MSOption');
    %_allowed_members = (
                         name         => 0,
                         code         => 1,
                         type         => 0,
                         value        => 1,
                         vendor_class => 0,
                         user_class   => 0,
                        );

    %_name_mappings = (
                       'type'  => 'optype',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       optype => \&__i2o_type__,
      );

    %_object_to_ibap =
      (
       name         => \&ibap_o2i_string,
       code         => \&ibap_o2i_uint,
       type         => \&__o2i_type__,
       value        => \&ibap_o2i_string,
       vendor_class => \&ibap_o2i_string,
       user_class   => \&ibap_o2i_string,
      );

    @_return_fields =
      (
       tField('name'),
       tField('code'),
       tField('optype'),
       tField('value'),
       tField('vendor_class'),
       tField('user_class'),
      );

    %_TYPE_ENUM_MAPPINGS = (
                            'string'                   => 'T_STRING',
                            'array of string'          => 'T_ARRAY_STRING',
                            'byte'                     => 'T_UINT8',
                            'array of byte'            => 'T_ARRAY_UINT8',
                            'word'                     => 'T_UINT16',
                            'array of word'            => 'T_ARRAY_UINT16',
                            'long'                     => 'T_UINT32',
                            'array of long'            => 'T_ARRAY_UINT32',
                            'long integer'             => 'T_UINT64',
                            'array of long integer'    => 'T_ARRAY_UINT64',
                            'ip address'               => 'T_IP_ADDRESS',
                            'array of ip address'      => 'T_ARRAY_IP_ADDRESS',
                            'array of ip address pair' => 'T_ARRAY_IP_ADDRESS_PAIR',
                            'binary'                   => 'T_BINARY',
                            'encapsulated'             => 'T_ENCAPSULATED',
                           );

    %_REVERSE_TYPE_ENUM_MAPPINGS = reverse %_TYPE_ENUM_MAPPINGS;

    @_SPEED_TYPE_ENUM_MAPPINGS = keys %_TYPE_ENUM_MAPPINGS;

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

sub __i2o_type__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return $_REVERSE_TYPE_ENUM_MAPPINGS{$ibap_object_ref->{$current}};
}

#
#
#

sub __o2i_type__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $tempref->{$current}) {
        return (1,0, $_TYPE_ENUM_MAPPINGS{$tempref->{$current}});
    } else {
        #
        #
        return (1,1,undef);
    }
}

#
#
#

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub code
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'code', validator => \&ibap_value_o2i_uint}, @_);
}

sub type
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'type', enum => \@_SPEED_TYPE_ENUM_MAPPINGS }, @_);
}

sub value
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'value', validator => \&ibap_value_o2i_string }, @_);
}

sub vendor_class
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'vendor_class', validator => \&ibap_value_o2i_string}, @_);
}

sub user_class
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'user_class', validator => \&ibap_value_o2i_string}, @_);
}

1;
