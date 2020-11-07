package Infoblox::DHCP::Filter::NAC;

use strict;

use Carp;
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_name_mappings %_reverse_name_mappings %_searchable_fields %_ibap_to_object %_object_to_ibap @_return_fields %_return_field_overrides %_capabilities);
@ISA = qw(Infoblox::IBAPBase);

BEGIN
{
    $_object_type = 'NacFilter';
    register_wsdl_type('ib:NacFilter','Infoblox::DHCP::Filter::NAC');

    %_capabilities = (
        depth                => 0,
        implicit_defaults    => 1,
        single_serialization => 1,
    );

    #
    #
    %_allowed_members = (
        name                  => 1,
        comment               => 0,
        extattrs              => 0,
        extensible_attributes => 0,
        expression            => 0,
        option_list           => 0,
        lease_time            => 0,
    );

    %_name_mappings = (
        extattrs    => 'extensible_attributes',
        option_list => 'options',
    );
    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
        name                  => [\&ibap_o2i_string, 'name', 'REGEX'],
        comment               => [\&ibap_o2i_string, 'comment', 'REGEX'],
        extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
    );

    %_ibap_to_object = (
                        extensible_attributes => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        options               => \&ibap_i2o_options,
                       );

    %_object_to_ibap = (
        name                  => \&ibap_o2i_string,
        comment               => \&ibap_o2i_string,
        expression            => \&ibap_o2i_string,
        extattrs              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
        extensible_attributes => \&ibap_o2i_ignore,
        option_list           => \&ibap_o2i_options,
        lease_time            => \&ibap_o2i_integer,
    );

    @_return_fields = (
        tField('comment'),
        tField('expression'),
        tField('lease_time'),
        tField('name'),
        tField('options'),
        return_fields_extensible_attributes(),
    );

    %_return_field_overrides = (
                                comment               => [],
                                expression            => [],
                                extattrs              => [],
                                extensible_attributes => [],
                                lease_time            => [],
                                name                  => [],
                                option_list           => [],
                               );
}

sub new
{
    my ( $proto, %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self, $class;

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
    my ( $proto, %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self, $class;

    $self->__init_instance_constants__();

    return $self;
}

sub __init_instance_constants__
{
    my $self = shift;

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                                \%_reverse_name_mappings,
                                                \%_searchable_fields,
                                                \%_ibap_to_object,
                                                \%_object_to_ibap,
                                                \@_return_fields,
                                                \%_return_field_overrides);

}

sub __ibap_object_type__
{
    #
    return $_object_type;
}

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

sub __ibap_to_object__
{
    my ($self,$ibap_object_ref, $server, $session, $return_object_cache_ref)=@_;
    $self->{'option_list'} = [];
 
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

#
#
#

sub expression
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'expression', validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub lease_time
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'lease_time', validator => \&ibap_value_o2i_int}, @_);
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub option_list
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'option_list', validator => {'Infoblox::DHCP::Option' => 1},}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

1;
