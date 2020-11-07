package Infoblox::Grid::Member::Taxii;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            $_object_type
            $_return_fields_initialized
            %_allowed_members
            %_capabilities
            %_name_mappings
            %_object_to_ibap
            %_ibap_to_object
            %_return_field_overrides
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE );

BEGIN {

    $_object_type = 'MemberTaxii';
    register_wsdl_type('ib:MemberTaxii', 'Infoblox::Grid::Member::Taxii');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'enable_service'   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'ipv4addr'         => {simple => 'asis', readonly => 1},
                         'ipv6addr'         => {simple => 'asis', readonly => 1},
                         'name'             => {simple => 'asis', readonly => 1},
                         'taxii_rpz_config' => {array => 1, validator => {'Infoblox::Grid::Member::Taxii::RPZConfig' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           ipv4addr => [\&ibap_o2i_string, 'address', 'REGEX'],
                           ipv6addr => [\&ibap_o2i_string, 'ipv6_address', 'REGEX'],
                           name     => [\&ibap_o2i_string, 'host_name', 'REGEX'],
    );

    %_name_mappings = (
                       'enable_service'   => 'taxii_enabled',
                       'ipv4addr'         => 'address',
                       'ipv6addr'         => 'ipv6_address',
                       'name'             => 'host_name',
                       'taxii_rpz_config' => 'taxii_rpz',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'taxii_rpz' => \&ibap_i2o_generic_object_list_convert,
    );

    %_object_to_ibap = (
                        'enable_service'   => \&ibap_o2i_boolean,
                        'ipv4addr'         => \&ibap_o2i_ignore,
                        'ipv6addr'         => \&ibap_o2i_ignore,
                        'name'             => \&ibap_o2i_ignore,
                        'taxii_rpz_config' => \&ibap_o2i_generic_struct_list_convert,
    );

    @_return_fields = (
                       tField('taxii_enabled'),
                       tField('host_name'),
                       tField('address'),
                       tField('ipv6_address'),
    );

    %_return_field_overrides = (
                                'enable_service'   => [],
                                'ipv4addr'         => [],
                                'ipv6addr'         => [],
                                'name'             => [],
                                'taxii_rpz_config' => [],
    );

    $_return_fields_initialized = 0;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    $self->__init_instance_constants__();
    return $self;
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
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

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::Member::Taxii::RPZConfig->__new__();
        push @_return_fields, tField('taxii_rpz', {sub_fields => $t->__return_fields__()});
    }
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'taxii_enabled'} = 0 unless defined $$ibap_object_ref{'taxii_enabled'};
    $$self{'taxii_rpz_config'} = [];

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::Member::Taxii::RPZConfig;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            @ISA
            @_return_fields
            $_return_fields_initialized
            $_object_type
            %_allowed_members
            %_object_to_ibap
            %_ibap_to_object
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'taxii_rpz_config';
    register_wsdl_type('ib:taxii_rpz_config', 'Infoblox::Grid::Member::Taxii::RPZConfig');



    %_allowed_members = (
                         'collection_name' => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'zone'            => {mandatory => 1, validator => {'Infoblox::DNS::Zone' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'zone' => \&ibap_i2o_generic_object_convert_partial,
    );

    %_object_to_ibap = (
                        'collection_name' => \&ibap_o2i_string,
                        'zone'            => \&ibap_o2i_object_only_by_oid,
    );

    @_return_fields = (
                       tField('collection_name'),
                       tField('zone', {sub_fields => [
                           tField('fqdn'),
                           tField('view', {sub_fields => [tField('name')]}),
                        ]}),
    );

    $_return_fields_initialized = 0;

}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}


1;
