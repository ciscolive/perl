package Infoblox::DHCP::Filter::RelayAgent;

use strict;

use Carp;
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_name_mappings %_reverse_name_mappings %_searchable_fields %_ibap_to_object %_object_to_ibap @_return_fields %_return_field_overrides %_capabilities);
@ISA = qw(Infoblox::IBAPBase);

BEGIN
{
    $_object_type = 'RelayAgentFilter';
    register_wsdl_type('ib:RelayAgentFilter','Infoblox::DHCP::Filter::RelayAgent');

    %_capabilities = (
        depth 				 => 0,
        implicit_defaults 	 => 1,
        single_serialization => 1,
    );

    #
    #
    %_allowed_members = (
        name => 1,
        circuit_id_name => 0,
        extattrs              => 0,
        extensible_attributes => 0,
        is_circuit_id => 0,
        is_remote_id => 0,
        remote_id_name => 0,
        comment => 0,
        is_circuit_id_substring => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        circuit_id_substring_offset => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        circuit_id_substring_length => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        is_remote_id_substring => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        remote_id_substring_offset => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        remote_id_substring_length => {simple => 'asis', validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
        circuit_id_name => 'circuit_id',
        extattrs        => 'extensible_attributes',
        is_circuit_id => 'circuit_id_rule',
        is_remote_id => 'remote_id_rule',
        remote_id_name => 'remote_id',
        is_circuit_id_substring => 'circuit_id_is_substring',
        is_remote_id_substring => 'remote_id_is_substring',
    );

    %_reverse_name_mappings = reverse %_name_mappings;                                

    %_searchable_fields = (
        name => [\&ibap_o2i_string, 'name', 'REGEX'],
        extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        comment => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],
    );
 
    %_ibap_to_object = (
        circuit_id_rule => \&__i2o_id_rule__,
        remote_id_rule => \&__i2o_id_rule__,
        extensible_attributes => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
    );
                        
    %_object_to_ibap = (
        circuit_id_name => \&ibap_o2i_string,
        extattrs              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
        extensible_attributes => \&ibap_o2i_ignore,
        is_circuit_id => \&ibap_o2i_enums_lc_or_undef,
        is_remote_id => \&ibap_o2i_enums_lc_or_undef,
        name => \&ibap_o2i_string,
        comment => \&ibap_o2i_string,
        remote_id_name => \&ibap_o2i_string,
        is_circuit_id_substring => \&ibap_o2i_boolean,
        circuit_id_substring_offset => \&ibap_o2i_uint,
        circuit_id_substring_length => \&ibap_o2i_uint,
        is_remote_id_substring => \&ibap_o2i_boolean,
        remote_id_substring_offset => \&ibap_o2i_uint,
        remote_id_substring_length => \&ibap_o2i_uint,
    );
    
    @_return_fields = (
        tField('name'),
        tField('comment'),
        tField('circuit_id'),
        tField('circuit_id_rule'),
        tField('remote_id'),
        tField('remote_id_rule'),
        tField('circuit_id_is_substring'),
        tField('circuit_id_substring_offset'),
        tField('circuit_id_substring_length'),
        tField('remote_id_is_substring'),
        tField('remote_id_substring_offset'),
        tField('remote_id_substring_length'),
        return_fields_extensible_attributes(),
    );

    %_return_field_overrides = (
        name => [],
        comment => [],
        circuit_id_name => [],
        is_circuit_id => [],
        remote_id_name => [],
        is_remote_id => [],
        extattrs => [],
        extensible_attributes => [],
        is_circuit_id_substring => [],
        circuit_id_substring_offset => [],
        circuit_id_substring_length => [],
        is_remote_id_substring => [],
        remote_id_substring_offset => [],
        remote_id_substring_length => [],
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

sub __i2o_id_rule__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    return undef unless defined $ibap_object_ref->{$current};
    my %hash = (
        ANY =>'Any',
        MATCHES_VALUE=>'Matches_Value',
        NOT_SET=>'Not_Set',
    );
    return $hash{$ibap_object_ref->{$current}};
}

sub __object_to_ibap__
{
    my ($self, @rest) = @_;
    if (!defined($self->{'is_circuit_id'})) {
        if (defined($self->{'circuit_id_name'})) {
            $self->{'is_circuit_id'} = 'Matches_Value'
        } else {
            $self->{'is_circuit_id'} = 'Not_Set'
        }
    }
    if (!defined($self->{'is_remote_id'})) {
        if (defined($self->{'remote_id_name'})) {
            $self->{'is_remote_id'} = 'Matches_Value'
        } else {
            $self->{'is_remote_id'} = 'Not_Set'
        }
    }

    return $self->SUPER::__object_to_ibap__(@rest);
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
             'circuit_id_is_substring',
             'remote_id_is_substring',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub circuit_id_name { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'circuit_id_name', validator => \&ibap_value_o2i_string}, @_);
}

sub is_circuit_id { 
    my $self=shift;
    return $self->__accessor_scalar__({name => 'is_circuit_id', enum => [qw(Any Not_Set Matches_Value)] }, @_);
}

sub is_remote_id { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'is_remote_id', enum => [qw(Any Not_Set Matches_Value)] }, @_);
}

sub name { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub remote_id_name { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'remote_id_name', validator => \&ibap_value_o2i_string}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

1;
