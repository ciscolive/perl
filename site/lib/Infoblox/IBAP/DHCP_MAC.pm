package Infoblox::DHCP::MAC;

use strict;

use Carp;
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_name_mappings %_reverse_name_mappings %_searchable_fields %_ibap_to_object %_object_to_ibap @_return_fields %_return_field_overrides %_capabilities);
@ISA = qw(Infoblox::IBAPBase);

BEGIN
{
    $_object_type = 'MacFilterAddress';
    register_wsdl_type('ib:MacFilterAddress','Infoblox::DHCP::MAC');

    %_capabilities = (
        depth                => 0,
        implicit_defaults    => 1,
        single_serialization => 1,
    );

    #
    #
    %_allowed_members = (
        authentication_time => 0,
        comment => 0,
        expiration_time => 0,
        expired => 0,
        extattrs              => 0,
        extensible_attributes => 0,
        filter => 0,
        mac => 0,
        reserved_for_infoblox => 0,
        username => 0,
        is_registered_user  => 0,
        guest_first_name    => 0,
        guest_middle_name   => 0,
        guest_last_name     => 0,
        guest_email         => 0,
        guest_phone         => 0,
        guest_custom_field1 => 0,
        guest_custom_field2 => 0,
        guest_custom_field3 => 0,
        guest_custom_field4 => 0,
        fingerprint         => -1,
    );

    %_name_mappings = (
        authentication_time => 'authenticate_time',
        expiration_time => 'expire_time',
        extattrs        => 'extensible_attributes',
        filter => 'parent',
        mac => 'mac_address',
        username => 'registered_user',
    );
    %_reverse_name_mappings = reverse %_name_mappings;                                

    %_searchable_fields = (
        filter => [\&__o2i_filter__, 'parent', 'SEARCHONLY_LIST_CONTAIN'],
        mac => [\&ibap_o2i_string, 'mac_address', 'REGEX'],
        username => [\&ibap_o2i_string, 'registered_user', 'REGEX'],
        comment  => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],
        fingerprint => [\&ibap_o2i_string, 'fingerprint', 'REGEX'],
        extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
    );

    %_ibap_to_object = (
        authenticate_time => \&ibap_i2o_datetime_to_unix_timestamp,
        expire_time => \&__i2o_expiration_time__,
        expired => \&ibap_i2o_boolean,
        extensible_attributes => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
        parent => \&__i2o_parent__,
        is_registered_user  => \&ibap_i2o_boolean,
    );

    %_object_to_ibap = (
        authentication_time => \&ibap_o2i_unix_timestamp_to_datetime,
        comment => \&ibap_o2i_string,
        expiration_time => \&__o2i_expiration_time__,
        expired => \&ibap_o2i_boolean,
        extattrs              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
        extensible_attributes => \&ibap_o2i_ignore,
        filter => \&__o2i_filter__,
        mac => \&ibap_o2i_string,
        reserved_for_infoblox => \&ibap_o2i_string,
        username => \&ibap_o2i_string,
        is_registered_user  => \&ibap_o2i_boolean,
        guest_first_name    => \&ibap_o2i_string,
        guest_middle_name   => \&ibap_o2i_string,
        guest_last_name     => \&ibap_o2i_string,
        guest_email         => \&ibap_o2i_string,
        guest_phone         => \&ibap_o2i_string,
        guest_custom_field1 => \&ibap_o2i_string,
        guest_custom_field2 => \&ibap_o2i_string,
        guest_custom_field3 => \&ibap_o2i_string,
        guest_custom_field4 => \&ibap_o2i_string,
        fingerprint         => \&ibap_o2i_ignore,
    );

    @_return_fields = (
        tField('authenticate_time'),
        tField('is_registered_user'),
        tField('guest_first_name'),
        tField('guest_middle_name'),
        tField('guest_last_name'),
        tField('guest_email'),
        tField('guest_phone'),
        tField('guest_custom_field1'),
        tField('guest_custom_field2'),
        tField('guest_custom_field3'),
        tField('guest_custom_field4'),
        tField('comment'),
        tField('expired'),
        tField('expire_time'),
        tField('mac_address'),
        tField('never_expires'),
        tField('parent', { sub_fields => [ tField('name') ]}),
        tField('registered_user'),
        tField('reserved_for_infoblox'),
        tField('fingerprint'),
        return_fields_extensible_attributes(),
    );

    %_return_field_overrides = (
                       'is_registered_user'  => [],
                       'guest_first_name'    => [],
                       'guest_middle_name'   => [],
                       'guest_last_name'     => [],
                       'guest_email'         => [],
                       'guest_phone'         => [],
                       'guest_custom_field1' => [],
                       'guest_custom_field2' => [],
                       'guest_custom_field3' => [],
                       'guest_custom_field4' => [],
        authentication_time => [],
        comment => [],
        expired => [],
        expiration_time => ['never_expires'],
        extattrs => [],
        extensible_attributes => [],
        mac => [],
        filter => [],
        username => [],
        reserved_for_infoblox => [],
        fingerprint => [],
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
    $self->expiration_time(0) unless defined $self->expiration_time();
}

#
#
#

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

sub __i2o_parent__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    return $ibap_object_ref->{$current}{'name'};
}

sub __i2o_expiration_time__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if (defined($ibap_object_ref->{'never_expires'}) && ($ibap_object_ref->{'never_expires'} == 1))
    {
        return "0";
    }
    else
    {
        return iso8601_datetime_to_unix_timestamp($ibap_object_ref->{$current});
    }
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'expired'}            = 0 unless defined($$ibap_object_ref{'expired'});
    $$ibap_object_ref{'is_registered_user'} = 0 unless defined($$ibap_object_ref{'is_registered_user'});

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    return;
}

#
#
#

sub __o2i_expiration_time__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args = ();

    if ($tempref->{$current} eq "0")
    {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
        push @return_args, {
            field => 'never_expires',
            value => tBool(1)};
    }
    else
    {
        @return_args = ibap_o2i_unix_timestamp_to_datetime(@_);
        push @return_args, {
            field => 'never_expires',
            value => tBool(0)};
    }

    return @return_args;
}

sub __o2i_filter__
{
    my ($self, $session, $current, $tempref, $type) = @_;

    $type = 'get' unless defined $type;
    if ($type eq 'search') {
        return (1,0,ibap_readfieldlist_simple_string('DhcpMacFilter','name', $tempref->{$current}));
    }
    else {
        return (1,0,ibap_readfield_simple_string('DhcpMacFilter', 'name', $tempref->{$current}, 'filter', 'EXACT'));
    }
}


#
#
#

sub is_registered_user {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'is_registered_user', validator => \&ibap_value_o2i_boolean}, @_);
}

sub guest_first_name {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_first_name', validator => \&ibap_value_o2i_string}, @_);
}

sub guest_middle_name {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_middle_name', validator => \&ibap_value_o2i_string}, @_);
}

sub guest_last_name {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_last_name', validator => \&ibap_value_o2i_string}, @_);
}

sub guest_email {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_email', validator => \&ibap_value_o2i_string}, @_);
}

sub guest_phone {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_phone', validator => \&ibap_value_o2i_string}, @_);
}

sub guest_custom_field1 {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_custom_field1', validator => \&ibap_value_o2i_string}, @_);
}

sub guest_custom_field2 {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_custom_field2', validator => \&ibap_value_o2i_string}, @_);
}

sub guest_custom_field3 {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_custom_field3', validator => \&ibap_value_o2i_string}, @_);
}

sub guest_custom_field4 {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_custom_field4', validator => \&ibap_value_o2i_string}, @_);
}

sub authentication_time { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'authentication_time', validator => \&ibap_value_o2i_uint}, @_);
}

sub comment { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub expiration_time { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'expiration_time', validator => \&ibap_value_o2i_uint}, @_);
}

sub expired { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'expired', readonly => 1}, @_);
}

sub filter { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'filter', validator => \&ibap_value_o2i_string}, @_);
}

sub mac { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'mac', validator => \&ibap_value_o2i_string}, @_);
}

sub reserved_for_infoblox { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'reserved_for_infoblox', validator => \&ibap_value_o2i_string}, @_);
}

sub username { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'username', validator => \&ibap_value_o2i_string}, @_);
}

sub fingerprint
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'fingerprint', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
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
