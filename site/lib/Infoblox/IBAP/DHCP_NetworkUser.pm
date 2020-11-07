package Infoblox::DHCP::NetworkUser;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( %_capabilities
             %_allowed_members
             %_searchable_fields
             %_name_mappings
             %_reverse_name_mappings
             @_return_fields
             $_object_type
             %_ibap_to_object
             %_object_to_ibap
             @ISA
             %_return_field_overrides
             $_return_fields_initialized
);

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'NetworkUser';
    register_wsdl_type('ib:NetworkUser', 'Infoblox::DHCP::NetworkUser');

    %_allowed_members = (
                         'address'           => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_ipaddr},
                         'guid'              => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'logon_id'          => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'address_object'    => {readonly => 1, validator => {'Infoblox::IPAM::Address' => 1}},
                         'domainname'        => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'last_seen_time'    => {validator => \&ibap_value_o2i_uint},
                         'last_updated_time' => {readonly => 1, validator => \&ibap_value_o2i_uint},
                         'first_seen_time'   => {mandatory => 1, validator => \&ibap_value_o2i_uint},
                         'logout_time'       => {validator => \&ibap_value_o2i_uint},
                         'name'              => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'network'           => {readonly => 1, validator => {'Infoblox::DHCP::Network' => 1, 'Infoblox::DHCP::IPv6Network' => 1}},
                         'network_view'      => {mandatory => 1, validator => \&ibap_value_o2i_string},
                         'user_status'       => {simple => 'asis', readonly => 1, enum => ['ACTIVE', 'LOGOUT', 'TIMEOUT']},
                         'data_source'       => {simple => 'asis', readonly => 1, enum => ['API', 'CISCO_ISE', 'MS_SERVER']},
                         'data_source_ip'    => {simple => 'asis', readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'address'      => [\&ibap_o2i_string, 'ipaddress', 'REGEX'],
                           'domainname'   => [\&ibap_o2i_string, 'domainname', 'REGEX'],
                           'name'         => [\&ibap_o2i_string, 'username', 'REGEX'],
                           'network_view' => [\&ibap_o2i_network_view, 'network_view', 'EXACT'],
                           'parent'       => [\&ibap_o2i_object_by_oid_or_name, 'parent', 'EXACT'],
                           'user_status'  => [\&ibap_o2i_string, 'user_status', 'EXACT'],
                           'guid'         => [\&ibap_o2i_string, 'guid', 'REGEX'],
                           'logon_id'     => [\&ibap_o2i_string, 'logon_id', 'REGEX'],
    );

    %_name_mappings = (
                       'address'           => 'ipaddress',
                       'address_object'    => 'address_ref',
                       'last_seen_time'    => 'last_seen_timestamp',
                       'last_updated_time' => 'last_updated_timestamp',
                       'first_seen_time'   => 'first_seen_timestamp',
                       'logout_time'       => 'logout_timestamp',
                       'name'              => 'username',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('data_source'),
                       tField('data_source_ip'),
                       tField('domainname'),
                       tField('first_seen_timestamp'),
                       tField('guid'),
                       tField('ipaddress'),
                       tField('last_seen_timestamp'),
                       tField('last_updated_timestamp'),
                       tField('logon_id'),
                       tField('logout_timestamp'),
                       tField('network', return_fields_network_partial()),
                       tField('network_view', {'sub_fields' => [tField('name')]}),
                       tField('user_status'),
                       tField('username'),
    );

    %_ibap_to_object = (
                        'address_ref'            => \&ibap_i2o_generic_object_convert,
                        'first_seen_timestamp'   => \&ibap_i2o_datetime_to_unix_timestamp,
                        'last_seen_timestamp'    => \&ibap_i2o_datetime_to_unix_timestamp,
                        'last_updated_timestamp' => \&ibap_i2o_datetime_to_unix_timestamp,
                        'logout_timestamp'       => \&ibap_i2o_datetime_to_unix_timestamp,
                        'network'                => \&ibap_i2o_generic_object_convert_partial,
                        'network_view'           => \&ibap_i2o_object_name,
    );

    %_object_to_ibap = (
                        'address'           => \&ibap_o2i_string,
                        'address_object'    => \&ibap_o2i_ignore,
                        'data_source'       => \&ibap_o2i_ignore,
                        'data_source_ip'    => \&ibap_o2i_ignore,
                        'domainname'        => \&ibap_o2i_string,
                        'first_seen_time'   => \&ibap_o2i_string,
                        'guid'              => \&ibap_o2i_string,
                        'last_seen_time'    => \&ibap_o2i_string,
                        'last_updated_time' => \&ibap_o2i_ignore,
                        'logon_id'          => \&ibap_o2i_string,
                        'logout_time'       => \&ibap_o2i_string,
                        'name'              => \&ibap_o2i_string,
                        'network'           => \&ibap_o2i_ignore,
                        'network_view'      => \&ibap_o2i_network_view,
                        'user_status'       => \&ibap_o2i_ignore,
    );

    foreach (keys(%_allowed_members)) {
        $_return_field_overrides{$_} = [];
    }

    $_return_fields_initialized = 0;
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members)) {

        return;
    }

    $self->__init_instance_constants__();
    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    $self->__init_instance_constants__();
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my ($t, @_objtype_return_fields);
        my %init_tfields = (
                            address_ref => 'Infoblox::IPAM::Address',
        );

        foreach (keys %init_tfields) {
            $t = $init_tfields{$_}->__new__();
            push @_return_fields,
                tField($_, {sub_fields => $t->__return_fields__()});
        }
    }
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __search_mapping_hook_pre__
{
    my ($self, $session, $type, $argsref, $out_search_fields_ref, $out_search_types_ref, $out_search_matches_ref) = @_;

    #
    unless (defined $$argsref{'network_view'} or defined $$argsref{'parent'}) {
        
        $$out_search_fields_ref{'network_view'} = ibap_readfield_simple(
            'NetworkView', 'is_default', tBool(1), 'network_view=default');
        
        $$out_search_types_ref{'network_view'} = 'EXACT';
        $$out_search_matches_ref{'network_view'} = undef;
	}

    return 1;
}

1;
