package Infoblox::DHCP::IPv6FixedAddr;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields @_optional_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object $_return_fields_initialized @_sub_host_address_fields %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase);


BEGIN {
    $_object_type = 'IPv6FixedAddress';
    register_wsdl_type('ib:IPv6FixedAddress','Infoblox::DHCP::IPv6FixedAddr');

    %_capabilities = (
                      'depth'                  => 0,
                      'implicit_defaults'      => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         address_type                => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         comment                     => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         configure_for_dhcp          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         disable                     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         domain_name                 => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_domain_name', use_truefalse => 1},
                         domain_name_servers         => {validator => \&ibap_value_o2i_string, use => 'override_domain_name_servers', use_truefalse => 1},
                         duid                        => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         extattrs                    => {special => 'extensible_attributes'},
                         extensible_attributes       => {special => 'extensible_attributes'},
                         ipv6addr                    => {simple => 'asis', validator => \&ibap_value_o2i_ipv6addr},
                         ipv6prefix                  => {simple => 'asis', validator => \&ibap_value_o2i_ipv6_network_or_address},
                         ipv6prefix_bits             => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         match_client                => {simple => 'asis', enum => [ 'DUID' ]},
                         name                        => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         network                     => {validator => \&ibap_value_o2i_ipv6_network},
                         network_view                => {validator => { 'Infoblox::DHCP::View' => 1 }},
                         options                     => {array => 1, validator => { 'Infoblox::DHCP::Option' => 1}, use => 'override_options', use_truefalse => 1},
                         override_domain_name        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_domain_name_servers => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_options            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_preferred_lifetime => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_valid_lifetime     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         preferred_lifetime          => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_preferred_lifetime', use_truefalse => 1},
                         template                    => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         valid_lifetime              => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_valid_lifetime', use_truefalse => 1},
                         discovered_data             => {readonly => 1, validator => {'Infoblox::Grid::Discovery::Data' => 1}},
                         disable_discovery           => {validator => \&ibap_value_o2i_boolean},
                         enable_immediate_discovery  => {writeonly => 1, validator => \&ibap_value_o2i_boolean},
                         snmp_credential             => {validator => {'Infoblox::Grid::Discovery::SNMPCredential' => 1}, skip_accessor => 1}, # The method is defined in the package. This is necessary for ibap_o2i_generic_struct_convert.
                         snmp3_credential            => {validator => {'Infoblox::Grid::Discovery::SNMP3Credential' => 1}, skip_accessor => 1}, # The method is defined in the package. This is necesary for ibap_o2i_generic_struct_convert.
                         cli_credentials             => {'array' => 1, validator => {'Infoblox::Grid::Discovery::CLICredential' => 1}, 'use' => 'override_cli_credentials', 'use_truefalse' => 1},
                         override_credential         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_snmp3_credential   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_cli_credentials    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         reserved_interface          => {validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}},
                         device_type                 => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         device_vendor               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         device_location             => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         device_description          => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         allow_telnet                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         discover_now_status         => {simple => 'asis', readonly => 1},
                         cloud_info                  => {readonly => 1, validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
                         ms_ad_user_data             => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'disable'                     => 'disabled',
                       'extattrs'                    => 'extensible_attributes',
                       'ipv6addr'                    => 'ip_address',
                       'ipv6prefix'                  => 'v6_prefix',
                       'ipv6prefix_bits'             => 'v6_prefix_bits',
                       'match_client'                => 'match_option',
                       'network'                     => 'parent',
                       'override_domain_name'        => 'use_domain_name',
                       'override_domain_name_servers' => 'use_domain_name_servers',
                       'override_options'            => 'use_options',
                       'override_preferred_lifetime' => 'use_preferred_lifetime',
                       'override_valid_lifetime'     => 'use_lease_time',
                       'valid_lifetime'              => 'lease_time',
                       'disable_discovery'           => 'enable_discovery',
                       'snmp_credential'             => 'snmpv1v2_credential',
                       'snmp3_credential'            => 'snmpv3_credential',
                       'override_snmp3_credential'   => 'use_snmpv3_credential',
                      );
    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           comment               => [\&ibap_o2i_string ,'comment'      , 'REGEX', 'IGNORE_CASE'],
                           duid                  => [\&ibap_o2i_string ,'duid'         , 'REGEX'],
                           extattrs              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           ipv6addr              => [\&ibap_o2i_string ,'ip_address'   , 'REGEX'],
                           network               => [\&ibap_o2i_ipv6_network ,'parent'  , 'SEARCHONLY_LIST_CONTAIN'],
                           network_view          => [\&ibap_o2i_network_view ,'network_view', 'EXACT'],
                           discovered_data       => [\&Infoblox::Grid::Discovery::Data::__o2i_search_discovered_data__, 'discovered_data', 'EXACT'],
                          );

    %_ibap_to_object = (
                        'configure_for_dhcp'     => \&ibap_i2o_boolean,
                        'disabled'               => \&ibap_i2o_boolean,
                        'domain_name_servers'    => \&ibap_i2o_domain_name_servers,
                        'extensible_attributes'  => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'network_view'           => \&ibap_i2o_generic_object_convert,
                        'options'                => \&ibap_i2o_options,
                        'parent'                 => \&__i2o_network__,
                        #
                        'use_domain_name'        => \&ibap_i2o_boolean,
                        'use_domain_name_servers' => \&ibap_i2o_boolean,
                        'use_options'            => \&ibap_i2o_boolean,
                        'use_preferred_lifetime' => \&ibap_i2o_boolean,
                        'use_lease_time'         => \&ibap_i2o_boolean,
                        'discovered_data'        => \&ibap_i2o_generic_object_convert,
                        'enable_discovery'       => \&ibap_i2o_boolean_reverse,
                        'snmpv1v2_credential'    => \&ibap_i2o_generic_object_convert,
                        'snmpv3_credential'      => \&ibap_i2o_generic_object_convert,
                        'cli_credentials'        => \&ibap_i2o_generic_object_list_convert,
                        'override_credential'    => \&ibap_i2o_boolean,
                        'use_snmpv3_credential'  => \&ibap_i2o_boolean,
                        'reserved_interface'     => \&ibap_i2o_generic_object_convert,
                        'cloud_info'             => \&ibap_i2o_generic_object_convert,
                        'ms_ad_user_data'        => \&ibap_i2o_generic_object_convert,
                       );

    %_object_to_ibap = (
                        'address_type'                => \&ibap_o2i_string,
                        'comment'                     => \&ibap_o2i_string,
                        'configure_for_dhcp'          => \&ibap_o2i_ignore, # XXX: this is taken care of by DNS::Host
                        'domain_name'                 => \&ibap_o2i_string,
                        'domain_name_servers'         => \&ibap_o2i_domain_name_servers,
                        'disable'                     => \&ibap_o2i_boolean,
                        'duid'                        => \&ibap_o2i_string,
                        'extattrs'                    => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'       => \&ibap_o2i_ignore,
                        'ipv6addr'                    => \&ibap_o2i_string,
                        'ipv6prefix'                  => \&ibap_o2i_string,
                        'ipv6prefix_bits'             => \&ibap_o2i_uint,
                        'match_client'                => \&ibap_o2i_string,
                        'name'                        => \&ibap_o2i_string,
                        'network'                     => \&ibap_o2i_ipv6_network,
                        'network_view'                => \&ibap_o2i_network_view,
                        'options'                     => \&ibap_o2i_options,
                        'override_domain_name'        => \&ibap_o2i_boolean,
                        'override_domain_name_servers' => \&ibap_o2i_boolean,
                        'override_options'            => \&ibap_o2i_boolean,
                        'override_preferred_lifetime' => \&ibap_o2i_boolean,
                        'override_valid_lifetime'     => \&ibap_o2i_boolean,
                        'preferred_lifetime'          => \&ibap_o2i_uint,
                        'template'                    => \&ibap_o2i_ipv6_fixed_address_template,
                        'valid_lifetime'              => \&ibap_o2i_uint,
                        'discovered_data'             => \&ibap_o2i_ignore,
                        'disable_discovery'           => \&ibap_o2i_boolean_reverse,
                        'enable_immediate_discovery'  => \&ibap_o2i_boolean,
                        'snmp_credential'             => \&ibap_o2i_generic_struct_convert,
                        'snmp3_credential'            => \&ibap_o2i_generic_struct_convert,
                        'cli_credentials'             => \&ibap_o2i_generic_struct_list_convert,
                        'override_credential'         => \&ibap_o2i_boolean,
                        'override_snmp3_credential'   => \&ibap_o2i_boolean,
                        'override_cli_credentials'    => \&ibap_o2i_boolean,
                        'reserved_interface'          => \&ibap_o2i_object_only_by_oid_or_undef,
                        'device_type'                 => \&ibap_o2i_string,
                        'device_vendor'               => \&ibap_o2i_string,
                        'device_location'             => \&ibap_o2i_string,
                        'device_description'          => \&ibap_o2i_string,
                        'allow_telnet'                => \&ibap_o2i_boolean,
                        'discover_now_status'         => \&ibap_o2i_ignore,
                        'cloud_info'                  => \&ibap_o2i_ignore,
                        'ms_ad_user_data'             => \&ibap_o2i_ignore,

                        #
                        'use_snmp_credential'         => \&ibap_o2i_ignore,
                        'use_snmp3_credential'        => \&ibap_o2i_ignore,
                       );

    $_return_fields_initialized=0;
    %_return_field_overrides = (
                                'address_type'                => [],
                                'comment'                     => [],
                                'configure_for_dhcp'          => [],
                                'disable'                     => [],
                                'domain_name'                 => ['use_domain_name'],
                                'domain_name_servers'         => ['use_domain_name_servers'],
                                'duid'                        => [],
                                'extattrs'                    => [],
                                'extensible_attributes'       => [],
                                'ipv6addr'                    => [],
                                'ipv6prefix'                  => [],
                                'ipv6prefix_bits'             => [],
                                'match_client'                => [],
                                'name'                        => [],
                                'network'                     => [],
                                'network_view'                => [],
                                'options'                     => ['use_options'],
                                'override_domain_name'        => [],
                                'override_domain_name_servers' => [],
                                'override_options'            => [],
                                'override_preferred_lifetime' => [],
                                'override_valid_lifetime'     => [],
                                'preferred_lifetime'          => ['use_preferred_lifetime'],
                                #
                                'valid_lifetime'              => ['use_lease_time'],
                                'discovered_data'             => [],
                                'disable_discovery'           => [],
                                'snmp_credential'             => ['override_credential', 'snmp3_credential', 'use_snmpv3_credential'],
                                'snmp3_credential'            => ['override_credential', 'use_snmpv3_credential'],
                                'cli_credentials'             => ['override_cli_credentials'],
                                'override_credential'         => [],
                                'override_snmp3_credential'   => [],
                                'override_cli_credentials'    => [],
                                'reserved_interface'          => [],
                                'device_type'                 => [],
                                'device_vendor'               => [],
                                'device_location'             => [],
                                'device_description'          => [],
                                'allow_telnet'                => [],
                                'discover_now_status'         => [],
                                'cloud_info'                  => [],
                                'ms_ad_user_data'             => [],
                               );


    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('address_type'),
                       tField('comment', { not_exist_ok => 1 }), # This exists only for fixedaddr standalone
                       tField('configure_for_dhcp', { not_exist_ok => 1 }), # This exists only for fixedaddr as child of dns host
                       tField('disabled'),
                       tField('domain_name'),
                       tField('domain_name_servers', { sub_fields => [ tField('address')]}),
                       tField('duid'),
                       tField('ip_address'),
                       return_fields_extensible_attributes(),
                       tField('lease_time'),
                       tField('name'),
                       tField('match_option'),
                       tField('options'),
                       tField('parent', {
                                         default_no_access_ok => 1,
                                         sub_fields => [
                                                        tField('address'),
                                                        tField('cidr'),
                                                       ],
                                        }
                             ),
                       tField('preferred_lifetime'),
                       #
                       tField('use_domain_name'),
                       tField('use_domain_name_servers'),
                       tField('use_lease_time'),
                       tField('use_options'),
                       tField('use_preferred_lifetime'),
                       tField('v6_prefix'),
                       tField('v6_prefix_bits'),
                       tField('discovered_data', {depth => 1}),
                       tField('enable_discovery'),
                       tField('snmpv1v2_credential', {'depth' => 1}),
                       tField('cli_credentials', {'depth' => 1}),
                       tField('override_credential'),
                       tField('use_snmpv3_credential'),
                       tField('override_cli_credentials'),
                       tField('device_type'),
                       tField('device_vendor'),
                       tField('device_location'),
                       tField('device_description'),
                       tField('allow_telnet'),
                      );
    Infoblox::IBAPBase::create_discovered_data_fields(
                                @discovery_common_fields,
                                'discovered_duid',
                                'mac_address',
                            );

    @_optional_return_fields = (
                                tField('discover_now_status'),
                               );
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    #
    #
    #
    unless($args{'template'} || $args{'ipv6addr'} ||
        ($args {'ipv6prefix'} && $args { 'ipv6prefix_bits' }))
    {
        set_error_codes(1103,"At least one of ipv6addr and ipv6prefix/ipv6prefix_bits is required." );
        return;
    }

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

    unless ($_return_fields_initialized) {
        $_return_fields_initialized=1;


        my $tmp = Infoblox::DHCP::View->__new__();
        @_sub_host_address_fields = (
                                     tField('address'),
                                     tField('address_type'),
                                     tField('client_hostname'),
                                     tField('configure_for_dhcp'),
                                     tField('domain_name'),
                                     tField('domain_name_servers'),
                                     tField('duid'),
                                     tField('lease_time'),
                                     tField('match_option'),
                                     tField('options'),
                                     tField('preferred_lifetime'),
                                     tField('use_domain_name'),
                                     tField('use_domain_name_servers'),
                                     tField('use_lease_time'),
                                     tField('use_options'),
                                     tField('use_preferred_lifetime'),
                                     tField('v6_prefix'),
                                     tField('v6_prefix_bits'),
                                     tField('discovered_data', {depth => 1}),
                                    );

        push @_return_fields,tField('network_view', {
                                                     default_no_access_ok => 1,
                                                     sub_fields           => $tmp->__return_fields__(),
                                                    });

        $tmp = Infoblox::Grid::Discovery::SNMP3Credential->__new__();
        push @_return_fields,
          tField('snmpv3_credential', {
                                sub_fields => $tmp->__return_fields__(),
                               },
                );

        $tmp = Infoblox::Grid::Discovery::DeviceInterface->__new__();
        push @_return_fields, tField('reserved_interface', {no_access_ok => 1, sub_fields => $tmp->__return_fields__()});

        $tmp = Infoblox::Grid::CloudAPI::Info->__new__();
        push @_return_fields, tField('cloud_info', {sub_fields => $tmp->__return_fields__()});

        $tmp = Infoblox::Grid::MSServer::AdUser::Data->__new__();
        push @_return_fields, tField('ms_ad_user_data', {sub_fields => $tmp->__return_fields__()});
    }

    $self->{__object_id_cache__} = {};

    #
    $self->match_client('DUID') unless defined $self->match_client();
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

sub __get_host_address_return_fields__
{
    return \@_sub_host_address_fields;
}

sub __get_search_callback__
{
	my ($self, $session, $object, $search_query_ref, $ref_ref_array_results, $return_fields, $cursor) = @_;
    return fixedaddress_get_search_callback_helper($self, $session, $object, $search_query_ref, $ref_ref_array_results, $return_fields, $cursor,\@_sub_host_address_fields);
}

#
#
#

sub __i2o_network__
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return $$ibap_object_ref{$current}{'address'} . '/' . $$ibap_object_ref{$current}{'cidr'};
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
             'configure_for_dhcp',
             'disabled',
             'use_domain_name',
             'use_domain_name_servers',
             'use_lease_time',
             'use_options',
             'use_preferred_lifetime',
             'enable_discovery',
             'override_credential',
             'use_snmpv3_credential',
             'override_cli_credentials',
             'allow_telnet',
            ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    #
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref, {'address' => 1, 'cidr' => 1, });

    #
    $self->{'override_domain_name'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_domain_name'});
    $self->{'override_domain_name_servers'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_domain_name_servers'});
    $self->{'override_options'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_options'});
    $self->{'override_preferred_lifetime'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_preferred_lifetime'});
    $self->{'override_valid_lifetime'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_lease_time'});
    $self->{'__initializing_from_ibap__'} = 1;
	$self->last_discovered('');
	$self->netbios('');
	$self->os('');
    delete $self->{'__initializing_from_ibap__'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    $self->{'override_credential'}=ibap_value_i2o_boolean($$ibap_object_ref{'override_credential'});
    $self->{'override_snmp3_credential'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_snmpv3_credential'});
    $self->{'override_cli_credentials'}=ibap_value_i2o_boolean($$ibap_object_ref{'override_cli_credentials'});

    #
    if ($self->{'override_credential'} eq 'true') {
        $self->{'use_snmp_credential'} = $self->{'override_snmp3_credential'} eq 'true' ? 0 : 1;
        $self->{'use_snmp3_credential'} = $self->{'override_snmp3_credential'} eq 'true' ? 1 : 0;
    }

    Infoblox::Grid::Discovery::Data::__init_discovered_members__($self);

    return;
}

#
#
#

#
#
#

sub __update_snmp_overrides__
{
    my ($self, $member) = @_;

    if ($member eq 'snmp_credential') {
        $self->{'use_snmp3_credential'} = $self->{'use_snmp_credential'} ? 0 : 1;

        if ($self->{'use_snmp3_credential'} and !defined $self->{'snmp3_credential'}) {
            $self->{'use_snmp3_credential'} = 0;
        }
    } else {
        $self->{'use_snmp_credential'} = $self->{'use_snmp3_credential'} ? 0 : 1;

        if ($self->{'use_snmp_credential'} and !defined $self->{'snmp_credential'}) {
            $self->{'use_snmp_credential'} = 0;
        }
    }

    $self->override_snmp3_credential($self->{'use_snmp3_credential'} ? 'true' : 'false');
    $self->override_credential(($self->{'use_snmp_credential'} or $self->{'use_snmp3_credential'}) ? 'true' : 'false');
}

sub snmp_credential
{
    my $self = shift;

    my $res = $self->__accessor_scalar__({name => 'snmp_credential', validator => {'Infoblox::Grid::Discovery::SNMPCredential' => 1}, use => 'use_snmp_credential'}, @_);
    $self->__update_snmp_overrides__('snmp_credential') if (@_ and $res);

    return $res;
}

sub snmp3_credential
{
    my $self = shift;

    my $res = $self->__accessor_scalar__({name => 'snmp3_credential', validator => {'Infoblox::Grid::Discovery::SNMP3Credential' => 1}, use => 'use_snmp3_credential'}, @_);
    $self->__update_snmp_overrides__('snmp3_credential') if (@_ and $res);

    return $res;
}

1;
