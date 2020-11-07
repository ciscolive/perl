package Infoblox::DHCP::Filter::MAC;

use strict;

use Carp;
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_name_mappings %_reverse_name_mappings %_searchable_fields %_ibap_to_object %_object_to_ibap @_return_fields %_return_field_overrides %_capabilities);
@ISA = qw(Infoblox::IBAPBase);

BEGIN
{
    $_object_type = 'DhcpMacFilter';
    register_wsdl_type('ib:DhcpMacFilter','Infoblox::DHCP::Filter::MAC');

    %_capabilities = (
        depth                => 0,
        implicit_defaults    => 1,
        single_serialization => 1,
    );

    #
    #
    %_allowed_members = (
        name => 1,
        comment => 0,
        disable => 0,
        default_mac_address_expiration => 0,
        enforce_expiration_times => 0,
        extattrs              => 0,
        extensible_attributes => 0,
        option_list => 0,
        lease_time => 0,
        reserved_for_infoblox => 0,
        vendor_prefix => 0,
    );

    %_name_mappings = (
        enforce_expiration_times => 'enforce_expiration_time',
        default_mac_address_expiration => 'expiration_interval',
        disable => 'disabled',
        extattrs => 'extensible_attributes',
        option_list => 'options',
    );
    %_reverse_name_mappings = reverse %_name_mappings;                                

    %_searchable_fields = (
        name => [\&ibap_o2i_string, 'name', 'REGEX'],
        comment => [\&ibap_o2i_string, 'comment', 'REGEX'],
        extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
    );
 
    %_ibap_to_object = (
        disabled => \&ibap_i2o_boolean,
        enforce_expiration_time => \&ibap_i2o_boolean,
        extensible_attributes => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
        expiration_interval => \&__i2o_expiration_interval__,
        options             => \&ibap_i2o_options,
    );
                        
    %_object_to_ibap = (
        name => \&ibap_o2i_string,
        comment => \&ibap_o2i_string,
        disable => \&ibap_o2i_boolean,
        reserved_for_infoblox => \&ibap_o2i_string,
        enforce_expiration_times => \&ibap_o2i_boolean,
        default_mac_address_expiration => \&__o2i__default_mac_address_expiration__,
        extattrs              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
        extensible_attributes => \&ibap_o2i_ignore,
        option_list => \&ibap_o2i_options,
        lease_time  => \&ibap_o2i_integer,
    );
    
    @_return_fields = (
        tField('comment'),
        tField('enforce_expiration_time'),
        tField('expiration_interval'),
        tField('disabled'),
        tField('lease_time'),
        tField('name'),
        tField('never_expires'),
        tField('options'),
        tField('reserved_for_infoblox'),
        return_fields_extensible_attributes(),
    );

    %_return_field_overrides = (
        comment => [],
        default_mac_address_expiration => ['never_expires'],
        disabled => [],
        enforce_expiration_times => [],
        extattrs => [],
        extensible_attributes => [],
        lease_time            => [],
        name => [],
        option_list           => [],
        reserved_for_infoblox => [],
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

    return $self;
}

sub __new__
{
    my ( $proto, %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self, $class;

    return $self;
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

sub __i2o_expiration_interval__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    return ($ibap_object_ref->{'never_expires'})? 0 : $ibap_object_ref->{$current};
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'enforce_expiration_time'} = 0 unless defined($$ibap_object_ref{'enforce_expiration_time'});
    $$ibap_object_ref{'disabled'} = 0 unless defined($$ibap_object_ref{'disabled'});
    $$ibap_object_ref{'never_expires'}           = 0 unless defined($$ibap_object_ref{'never_expires'});

    $self->{'enforce_expiration_times'} = 'false';
    $self->{'default_mac_address_expiration'} = 0;
    $self->{'option_list'} = [];

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __o2i__default_mac_address_expiration__
{
    my ($self, $session, $current, $tempref) = @_;

    my @return_args;

    #
    #
    #
    #
    #
    if ($tempref->{$current} != 0) {
        @return_args = ibap_o2i_uint(@_);
        push @return_args, {
            field => 'never_expires',
            value => tBool(0),
        };
    } else {
        push @return_args, 1;
        push @return_args, 1; # skip the undef below
        push @return_args, undef;
        push @return_args, {
            field => 'never_expires',
            value => tBool(1),
        };
    }
    return @return_args;
}

sub reserved_for_infoblox
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'reserved_for_infoblox', validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enforce_expiration_times
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enforce_expiration_times', validator => \&ibap_value_o2i_boolean}, @_);
}

sub default_mac_address_expiration
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'default_mac_address_expiration', validator => \&ibap_value_o2i_uint}, @_);
}

sub vendor_prefix
{
    my $self=shift;
    return $self->__accessor_scalar__({deprecated => 1}, @_);
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
