package Infoblox::DHCP::OptionDefinitionBase;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_return_field_overrides %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object %_TYPE_ENUM_MAPPINGS %_REVERSE_TYPE_ENUM_MAPPINGS %_capabilities);
@ISA = qw(Infoblox::IBAPBase);

BEGIN 
{
	$_object_type = 'NotUsable'; # we are a base class

    #
    register_wsdl_type('ib:OptionDefinition', 'Infoblox::DHCP::OptionDefinition');
    register_wsdl_type('ib:IPv6OptionDefinition', 'Infoblox::DHCP::IPv6OptionDefinition');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
        name    => 1,
        code    => 1,
        space   => 0,
        type    => 0,
    );

    %_name_mappings = (
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
        tField('name'),
        tField('code'),
        tField('type'),
    );

    push @_return_fields, (
                            tField('space',
                            {
                                sub_fields      => [ tField('name') ],
                            }));

    %_return_field_overrides = (
        name        => [],
        code        => [],
        space       => [],
        type        => [],
    );

    %_ibap_to_object = (
        space       => \&__i2o_space__,
        type        => \&__i2o_type__,        
    );

    %_object_to_ibap = (
        name        => \&ibap_o2i_string,
        code        => \&ibap_o2i_uint,
        space       => \&__o2i_space__,
        type        => \&__o2i_type__,
    );

    %_searchable_fields = (
        name        => [\&ibap_o2i_string ,'name', 'REGEX'],
        code        => [\&ibap_o2i_uint ,'code', 'EXACT'],
        space       => [\&__o2i_space__ ,'space', 'EXACT'],
        type        => [\&__o2i_type__ ,'type', 'REGEX'],
    );

    %_TYPE_ENUM_MAPPINGS = (
        'boolean'                           => 'T_FLAG',
        'ip-address'                        => 'T_IP_ADDRESS',
        'array of ip-address'               => 'T_ARRAY_IP_ADDRESS',
        'string'                            => 'T_STRING',
        'text'                              => 'T_TEXT',
        'domain-name'                       => 'T_DOMAIN',
        'domain-list'                       => 'T_ARRAY_DOMAIN',
        '8-bit unsigned integer'            => 'T_UINT8',
        '16-bit unsigned integer'           => 'T_UINT16',
        '32-bit unsigned integer'           => 'T_UINT32',
        '8-bit signed integer'              => 'T_INT8',
        '16-bit signed integer'             => 'T_INT16',
        '32-bit signed integer'             => 'T_INT32',
        'array of 8-bit unsigned integer'   => 'T_ARRAY_UINT8',
        'array of 16-bit unsigned integer'  => 'T_ARRAY_UINT16',
        'array of 32-bit unsigned integer'  => 'T_ARRAY_UINT32',
        'array of 8-bit integer'            => 'T_ARRAY_INT8',
        'array of 16-bit integer'           => 'T_ARRAY_INT16',
        'array of 32-bit integer'           => 'T_ARRAY_INT32',
        'array of ip-address pairs'         => 'T_ARRAY_IP_ADDRESS_PAIR',
        '<true/false> array of ip-address'  => 'T_FLAG_IP_ADDRESS',
        '<true/false/on/off> text'          => 'T_FLAG_TEXT',
        '8-bit unsigned integer (1,2,4,8)'  => 'T_UINT8_1_2_4_8',
    );

    %_REVERSE_TYPE_ENUM_MAPPINGS = reverse %_TYPE_ENUM_MAPPINGS;
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
    #
}

#
#
#
   
sub __ibap_object_type__
{
    #
    #
    return $_object_type;
}

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

#
#
sub __get_class_methods_class__
{
    return 'Infoblox::DHCP::OptionDefinitionBase';
}

#
#
#

sub __i2o_space__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($ibap_object_ref->{$current}) {
        my $space = $ibap_object_ref->{$current};
        return $space->{'name'};
    } else {
        return undef;
    }
}

sub __i2o_type__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    if ($ibap_object_ref->{$current}) {
        my $ret_val = $_REVERSE_TYPE_ENUM_MAPPINGS{$ibap_object_ref->{$current}};
        if (defined $ret_val) {
            return $ret_val;
        } else {
            return $ibap_object_ref->{$current};
        }
    } else {
        return undef;
    }
}

sub __o2i_space__
{
    my $self = shift;

    #
    return $self->__o2i_space__(@_);
}

sub __o2i_type__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    push @return_args, 1;
    if (not defined $tempref->{$current}) {
        push @return_args, 1;
        push @return_args, undef;
    } else {
        push @return_args, 0;
        my $ret_val = $_TYPE_ENUM_MAPPINGS{$tempref->{$current}};
        if (defined $ret_val) {
            push @return_args, ibap_value_o2i_string($ret_val, 'type', $session);
        } else {
            push @return_args, ibap_value_o2i_string($tempref->{$current}, 'type', $session);
        }
    }

    return @return_args;
}

#
#
#

sub name
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}


sub code
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'code', validator => \&ibap_value_o2i_string}, @_);
}

sub space
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'space', validator => \&ibap_value_o2i_string}, @_);
}

sub type
{
    my $self = shift;
    my @t=keys %_TYPE_ENUM_MAPPINGS;

    return $self->__accessor_scalar__({name => 'type', enum => \@t }, @_);
}

package Infoblox::DHCP::OptionDefinition;
use strict;
use Carp;
use Infoblox::Util;

use vars qw( @ISA );
@ISA = qw ( Infoblox::DHCP::OptionDefinitionBase );

sub __ibap_object_type__
{
    return 'OptionDefinition';
}

sub __init_instance_constants__
{
    my $self = shift;

    #
    $self->type('string') unless defined $self->type();
}

sub __o2i_space__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    push @return_args, 1;
    if (not defined $tempref->{$current}) {
        push @return_args, 1;
        push @return_args, undef;
    } else {
        push @return_args, 0;
        push @return_args, ibap_readfield_simple_string('OptionSpace', 'name', $tempref->{$current}, $current);
    }

    return @return_args;
}

package Infoblox::DHCP::IPv6OptionDefinition;
use strict;
use Carp;
use Infoblox::Util;

use vars qw( @ISA );
@ISA = qw ( Infoblox::DHCP::OptionDefinitionBase );

sub __ibap_object_type__
{
    return 'IPv6OptionDefinition';
}

sub __init_instance_constants__
{
    my $self = shift;

    #
    $self->type('string') unless defined $self->type();
}

sub __o2i_space__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    push @return_args, 1;
    if (not defined $tempref->{$current}) {
        push @return_args, 1;
        push @return_args, undef;
    } else {
        push @return_args, 0;
        push @return_args, ibap_readfield_simple_string('IPv6OptionSpace', 'name', $tempref->{$current}, $current);
    }

    return @return_args;
}

1;
