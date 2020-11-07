package Infoblox::DHCP::IPv6NetworkContainer;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members %_name_mappings %_reverse_name_mappings %_searchable_fields %_ibap_to_object %_object_to_ibap @_return_fields @_optional_return_fields %_return_field_overrides %_capabilities $_return_fields_initialized %_lazy_return_fields);
@ISA = qw ( Infoblox::IBAPBase );

BEGIN
{
	$_object_type = 'IPv6NetworkContainer';
    register_wsdl_type('ib:IPv6NetworkContainer', 'Infoblox::DHCP::IPv6NetworkContainer');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    #
    #
    %_allowed_members = (
       'auto_create_reversezone'    => 0,
	   'comment' 	                => 0,
       'extattrs'                   => {special => 'extensible_attributes'},
       'extensible_attributes'      => {special => 'extensible_attributes'},
       'network'                    => 1,
       'network_container'          => 0,
       'remove_subnets'             => 0,
       'rir'                        => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
       'rir_organization'           => {validator => {'Infoblox::Grid::RIR::Organization' => 1}},
       'rir_registration_action'    => {simple => 'asis', enum => ['NONE', 'CREATE', 'MODIFY', 'DELETE']}, # write-only
       'rir_registration_status'    => {simple => 'asis', enum => ['NOT_REGISTERED', 'REGISTERED']},
       'last_rir_registration_update_sent'   => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
       'last_rir_registration_update_status' => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
       'send_rir_request'           => {simple => 'bool', validator => \&ibap_value_o2i_boolean}, # write-only
       'delete_reason'              => {simple => 'asis', validator => \&ibap_value_o2i_string}, # write-only
       'network_view'               => 0,
       'zone_associations'          => 0,
       'use_zone_associations'      => 0,
       'enable_discovery'                       => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_enable_discovery', use_members => ['enable_discovery', 'discovery_member'], use_truefalse => 1},
       'override_enable_discovery'              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'discovery_member'                       => {validator => \&ibap_value_o2i_string, use => 'override_enable_discovery', use_members => ['enable_discovery', 'discovery_member'], use_truefalse => 1},
       'discovery_basic_poll_settings'          => {validator => {'Infoblox::Grid::Discovery::BasicPollSettings' => 1}, use => 'override_discovery_basic_poll_settings', use_truefalse => 1},
       'discovery_exclusion_range'              => {array => 1, validator => {'Infoblox::DHCP::ExclusionRange' => 1}},
       'override_discovery_basic_poll_settings' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'enable_immediate_discovery'             => {simple => 'bool', writeonly => 1, validator => \&ibap_value_o2i_boolean},
       'discover_now_status'                    => {simple => 'asis', readonly => 1},
       'discovery_blackout_setting'             => {validator => {'Infoblox::Grid::Discovery::Properties::BlackoutSetting' => 1}, use => 'override_blackout_setting', 'use_members' => ['discovery_blackout_setting', 'port_control_blackout_setting'], use_truefalse => 1},
       'port_control_blackout_setting'          => {validator => {'Infoblox::Grid::Discovery::Properties::BlackoutSetting' => 1}, use => 'override_blackout_setting', 'use_members' => ['discovery_blackout_setting', 'port_control_blackout_setting'], use_truefalse => 1},
       'same_port_control_discovery_blackout'   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'override_blackout_setting'              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'ms_ad_user_data'                        => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
       'discovery_engine_type'                  => {simple => 'asis', readonly => 1},
       
       #
       'cloud_info'                             => {validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
       'restart_if_needed'                      => {simple => 'bool', validator => \&ibap_value_o2i_boolean, writeonly => 1},
       'unmanaged'                              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},

       #

       'ddns_domainname'                         => {simple => 'asis', validator => \&ibap_value_o2i_string,
                                                     use => 'override_ddns_domainname', use_truefalse => 1},
       'ddns_enable_option_fqdn'                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                     use => 'override_ddns_enable_option_fqdn', use_truefalse => 1},
       'ddns_generate_hostname'                  => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                     use => 'override_ddns_generate_hostname', use_truefalse => 1},
       'ddns_server_always_updates'              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'ddns_ttl'                                => {simple => 'asis', validator => \&ibap_value_o2i_uint,
                                                     use => 'override_ddns_ttl', use_truefalse => 1},
       'domain_name'                             => {simple => 'asis', validator => \&ibap_value_o2i_string,
                                                     use => 'override_domain_name', use_truefalse => 1},
       'domain_name_servers'                     => {validator => \&ibap_value_o2i_string,
                                                     use => 'override_domain_name_servers', use_truefalse => 1},
       'enable_ddns'                             => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                     use => 'override_enable_ddns', use_truefalse => 1},
       'options'                                 => {array => 1, validator => { 'Infoblox::DHCP::Option' => 1},
                                                     use => 'override_options', use_truefalse => 1},
       'preferred_lifetime'                      => {simple => 'asis', validator => \&ibap_value_o2i_uint,
                                                     use => 'override_preferred_lifetime', use_truefalse => 1},
       'update_dns_on_lease_renewal'             => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                     use => 'override_update_dns_on_lease_renewal', use_truefalse => 1},
       'valid_lifetime'                          => {simple => 'asis', validator => \&ibap_value_o2i_uint,
                                                     use => 'override_valid_lifetime', use_truefalse => 1},
       'recycle_leases'                          => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                     use => 'override_recycle_leases', use_truefalse => 1},
       'override_ddns_domainname'                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'override_ddns_enable_option_fqdn'        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'override_ddns_generate_hostname'         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'override_ddns_ttl'                       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'override_domain_name'                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'override_domain_name_servers'            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'override_enable_ddns'                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'override_options'                        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'override_preferred_lifetime'             => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'override_update_dns_on_lease_renewal'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'override_valid_lifetime'                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'override_recycle_leases'                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'endpoint_sources'                        => {readonly => 1, array => 1, validator => {'Infoblox::CiscoISE::Endpoint' => 1}},
       'override_subscribe_settings'             => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'subscribe_settings'                      => {use => 'override_subscribe_settings', use_truefalse => 1,
                                                     validator => {'Infoblox::CiscoISE::SubscribeSetting' => 1}},
       mgm_private                 => {skip_accessor => 1},
       override_mgm_private        => {skip_accessor => 1},
       mgm_private_overridable     => {skip_accessor => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
    Infoblox::IBAPBase::create_mgm_private_accessors();

    #
    %_name_mappings = (
        network => 'address',
        network_container => 'parent_name',
        extattrs          => 'extensible_attributes',
        discovery_basic_poll_settings          => 'basic_polling_settings',
        override_discovery_basic_poll_settings => 'use_basic_polling_settings',
        override_enable_discovery              => 'use_member_enable_discovery',
        'override_blackout_setting'            => 'use_blackout_setting',

        'ddns_enable_option_fqdn'              => 'enable_option81',
        'ddns_generate_hostname'               => 'generate_hostname',
        'ddns_server_always_updates'           => 'always_update_dns',
        'override_ddns_domainname'             => 'use_ddns_domainname',
        'override_ddns_ttl'                    => 'use_ddns_ttl',
        'override_domain_name'                 => 'use_domain_name',
        'override_domain_name_servers'         => 'use_domain_name_servers',
        'override_enable_ddns'                 => 'use_enable_ddns',
        'override_ddns_enable_option_fqdn'     => 'use_enable_option81',
        'override_ddns_generate_hostname'      => 'use_generate_hostname',
        'override_options'                     => 'use_options',
        'override_preferred_lifetime'          => 'use_preferred_lifetime',
        'override_update_dns_on_lease_renewal' => 'use_update_dns_on_lease_renewal',
        'override_valid_lifetime'              => 'use_lease_time',
        'valid_lifetime'                       => 'lease_time',
        'override_recycle_leases'              => 'use_recycle_leases',
        'override_subscribe_settings'          => 'use_subscribe_settings',
        'override_mgm_private' => 'use_mgm_private',
    );
    %_reverse_name_mappings = reverse %_name_mappings;

    #
    %_searchable_fields = (
        comment => [\&ibap_o2i_string, 'comment', 'REGEX'],
        extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        network => [\&ibap_o2i_network_string, 'address', 'REGEX'],
        network_view => [\&ibap_o2i_network_view, 'network_view', 'EXACT'],
        unmanaged    => [\&ibap_o2i_boolean, 'unmanaged', 'EXACT'],
        discovery_engine_type => [\&ibap_o2i_string, 'discovery_engine_type', 'EXACT'],
    );

    #
    %_ibap_to_object = (
        auto_create_reversezone => \&ibap_i2o_boolean,
        extensible_attributes => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
        network_view => \&ibap_i2o_generic_object_convert,
        rir_organization      => \&ibap_i2o_generic_object_convert,
        enable_discovery            => \&ibap_i2o_boolean,
        use_member_enable_discovery => \&ibap_i2o_boolean,
        basic_polling_settings      => \&ibap_i2o_generic_object_convert,
        use_basic_polling_settings  => \&ibap_i2o_boolean,
        discovery_member            => \&ibap_i2o_member_byhostname,
        discovery_exclusion_range   => \&ibap_i2o_exclusion,
        discovery_blackout_setting    => \&ibap_i2o_generic_object_convert,
        port_control_blackout_setting => \&ibap_i2o_generic_object_convert,
        ms_ad_user_data               => \&ibap_i2o_generic_object_convert,

        cloud_info                    => \&ibap_i2o_generic_object_convert,
        unmanaged                     => \&ibap_i2o_boolean,

        enable_option81                 => \&ibap_i2o_boolean,
        domain_name_servers             => \&ibap_i2o_domain_name_servers,
        generate_hostname               => \&ibap_i2o_boolean,
        options                         => \&ibap_i2o_options,
        use_ddns_domainname             => \&ibap_i2o_boolean,
        use_ddns_ttl                    => \&ibap_i2o_boolean,
        use_domain_name                 => \&ibap_i2o_boolean,
        use_domain_name_servers         => \&ibap_i2o_boolean,
        use_enable_ddns                 => \&ibap_i2o_boolean,
        use_enable_option81             => \&ibap_i2o_boolean,
        use_generate_hostname           => \&ibap_i2o_boolean,
        use_options                     => \&ibap_i2o_boolean,
        use_preferred_lifetime          => \&ibap_i2o_boolean,
        use_update_dns_on_lease_renewal => \&ibap_i2o_boolean,
        recycle_leases                  => \&ibap_i2o_boolean,
        use_recycle_leases              => \&ibap_i2o_boolean,
        subscribe_settings              => \&ibap_i2o_generic_object_convert,
        endpoint_sources                => \&ibap_i2o_generic_object_list_convert,
    );

    #
    %_object_to_ibap = (
        auto_create_reversezone => \&ibap_o2i_boolean,
        comment => \&ibap_o2i_string,
        extattrs  => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
        extensible_attributes  => \&ibap_o2i_ignore,
        network => \&ibap_o2i_network_string,
        network_container => \&ibap_o2i_ignore,
        network_view => \&ibap_o2i_network_view,
        zone_associations => \&ibap_o2i_zone_associations,
        remove_subnets => \&ibap_o2i_ignore,
        rir                     => \&ibap_o2i_ignore,
        rir_organization        => \&ibap_o2i_rir_organization,
        rir_registration_action => \&ibap_o2i_string,
        rir_registration_status => \&ibap_o2i_string,
        last_rir_registration_update_sent   => \&ibap_o2i_ignore,
        last_rir_registration_update_status => \&ibap_o2i_ignore,
        send_rir_request        => \&ibap_o2i_boolean,
        delete_reason           => \&ibap_o2i_string,
        use_zone_associations => \&ibap_o2i_boolean,
        enable_discovery                     => \&ibap_o2i_boolean,
        discovery_member                     => \&ibap_o2i_member_byhostname,
        discovery_basic_poll_settings        => \&ibap_o2i_generic_struct_convert,
        enable_immediate_discovery           => \&ibap_o2i_boolean,
        discovery_exclusion_range            => \&ibap_o2i_exclusion,
        override_enable_discovery            => \&ibap_o2i_boolean,
        override_discovery_basic_poll_settings => \&ibap_o2i_boolean,
        discover_now_status                  => \&ibap_o2i_ignore,
        discovery_blackout_setting           => \&ibap_o2i_generic_struct_convert,
        port_control_blackout_setting        => \&ibap_o2i_generic_struct_convert,
        override_blackout_setting            => \&ibap_o2i_boolean,
        same_port_control_discovery_blackout => \&ibap_o2i_boolean,
        ms_ad_user_data                      => \&ibap_o2i_ignore,

        cloud_info                           => \&ibap_o2i_generic_struct_convert,
        restart_if_needed                    => \&ibap_o2i_boolean,
        unmanaged                            => \&ibap_o2i_boolean,

        ddns_domainname                      => \&ibap_o2i_string,
        ddns_enable_option_fqdn              => \&ibap_o2i_boolean,
        ddns_generate_hostname               => \&ibap_o2i_boolean,
        ddns_server_always_updates           => \&ibap_o2i_boolean,
        ddns_ttl                             => \&ibap_o2i_uint,
        domain_name                          => \&ibap_o2i_string,
        domain_name_servers                  => \&ibap_o2i_domain_name_servers,
        enable_ddns                          => \&ibap_o2i_boolean,
        options                              => \&ibap_o2i_options,
        override_ddns_domainname             => \&ibap_o2i_boolean,
        override_ddns_enable_option_fqdn     => \&ibap_o2i_boolean,
        override_ddns_generate_hostname      => \&ibap_o2i_boolean,
        override_ddns_ttl                    => \&ibap_o2i_boolean,
        override_domain_name                 => \&ibap_o2i_boolean,
        override_domain_name_servers         => \&ibap_o2i_boolean,
        override_enable_ddns                 => \&ibap_o2i_boolean,
        override_options                     => \&ibap_o2i_boolean,
        override_preferred_lifetime          => \&ibap_o2i_boolean,
        override_update_dns_on_lease_renewal => \&ibap_o2i_boolean,
        override_valid_lifetime              => \&ibap_o2i_boolean,
        preferred_lifetime                   => \&ibap_o2i_uint,
        update_dns_on_lease_renewal          => \&ibap_o2i_boolean,
        valid_lifetime                       => \&ibap_o2i_uint,
        override_recycle_leases              => \&ibap_o2i_boolean,
        recycle_leases                       => \&ibap_o2i_boolean,
        subscribe_settings                   => \&ibap_o2i_generic_struct_convert,
        endpoint_sources                     => \&ibap_o2i_ignore,
        override_subscribe_settings          => \&ibap_o2i_boolean,
        mgm_private => \&ibap_o2i_boolean,
        override_mgm_private => \&ibap_o2i_boolean,
        mgm_private_overridable => \&ibap_o2i_ignore,
        discovery_engine_type => \&ibap_o2i_ignore,
    );

    #
    %_return_field_overrides = (
        'auto_create_reversezone'   => [],
        'comment'                   => [],
        'extattrs'                  => [],
        'extensible_attributes'     => [],
        'network'                   => ['cidr'],
        'network_container'         => ['address', 'cidr'],
        'remove_subnets'            => [],
        'rir'                       => [],
        'rir_organization'          => [],
        'rir_registration_status'   => [],
        'last_rir_registration_update_sent'   => [],
        'last_rir_registration_update_status' => [],
        'network_view'              => [],
        'zone_associations'         => ['use_zone_associations'],
        'enable_discovery'              => ['discovery_member','use_member_enable_discovery'],
        'override_enable_discovery'     => [],
        'discovery_member'              => ['enable_discovery','use_member_enable_discovery'],
        'discovery_exclusion_range'     => [],
        'discovery_basic_poll_settings' => ['use_basic_polling_settings'],
        'override_discovery_basic_poll_settings' => [],
        'discover_now_status'           => [],
        'discovery_blackout_setting'    => ['port_control_blackout_setting', 'use_blackout_setting'],
        'port_control_blackout_setting' => ['discovery_blackout_setting', 'use_blackout_setting'],
        'override_blackout_setting'     => [],
        'same_port_control_discovery_blackout' => [],
        'ms_ad_user_data'                      => [],

       'cloud_info'                            => [],
       'unmanaged'                             => [],

        ddns_domainname                      => ['use_ddns_domainname'],
        ddns_enable_option_fqdn              => ['use_enable_option81'],
        ddns_generate_hostname               => ['use_generate_hostname'],
        ddns_server_always_updates           => [],
        ddns_ttl                             => ['use_ddns_ttl'],
        domain_name                          => ['use_domain_name'],
        domain_name_servers                  => ['use_domain_name_servers'],
        enable_ddns                          => ['use_enable_ddns'],
        options                              => ['use_options'],
        override_ddns_domainname             => [],
        override_ddns_enable_option_fqdn     => [],
        override_ddns_generate_hostname      => [],
        override_ddns_ttl                    => [],
        override_domain_name                 => [],
        override_domain_name_servers         => [],
        override_enable_ddns                 => [],
        override_options                     => [],
        override_preferred_lifetime          => [],
        override_update_dns_on_lease_renewal => [],
        override_valid_lifetime              => [],
        preferred_lifetime                   => ['use_preferred_lifetime'],
        update_dns_on_lease_renewal          => ['use_update_dns_on_lease_renewal'],
        valid_lifetime                       => ['use_lease_time'],
        override_recycle_leases              => [],
        recycle_leases                       => ['use_recycle_leases'],
        subscribe_settings                   => ['use_subscribe_settings'],
        override_subscribe_settings          => [],
        endpoint_sources                     => [],
        discovery_engine_type                => [],

        #
        #
        #
        #
    );

    #
    $_return_fields_initialized=0;
    @_return_fields =
    (
     tField('address'),
     tField('cidr'),
     tField('comment'),
     tField('parent_name'),
     tField('rir'),
     tField('rir_registration_status'),
     tField('last_rir_registration_update_sent'),
     tField('last_rir_registration_update_status'),
     tField('enable_discovery'),
     tField('use_member_enable_discovery'),
     tField('use_basic_polling_settings'),
     tField('discovery_member', {'sub_fields' => [tField('host_name')]}),
     tField('discovery_exclusion_range', {'depth' => 1}),
     tField('discovery_engine_type'),
     tField('use_blackout_setting'),
     tField('same_port_control_discovery_blackout'),
     tField('use_subscribe_settings'),
     tField('unmanaged'),
     return_fields_extensible_attributes(),
     tField('always_update_dns'),
     tField('ddns_domainname'),
     tField('ddns_ttl'),
     tField('domain_name'),
     tField('domain_name_servers', {sub_fields => [tField('address')]}),
     tField('enable_ddns'),
     tField('enable_option81'),
     tField('generate_hostname'),
     tField('lease_time'),
     tField('options'),
     tField('preferred_lifetime'),
     tField('update_dns_on_lease_renewal'),
     tField('use_ddns_domainname'),
     tField('use_ddns_ttl'),
     tField('use_domain_name'),
     tField('use_domain_name_servers'),
     tField('use_enable_ddns'),
     tField('use_enable_option81'),
     tField('use_generate_hostname'),
     tField('use_lease_time'),
     tField('use_options'),
     tField('use_preferred_lifetime'),
     tField('use_update_dns_on_lease_renewal'),
     tField('recycle_leases'),
     tField('use_recycle_leases'),
     #
     #
     #
     #
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

        my ($tmp, %tmp);

        $tmp = Infoblox::DHCP::View->__new__();
        push @_return_fields, tField('network_view', {
                                                      default_no_access_ok => 1,
                                                      sub_fields => $tmp->__return_fields__(),
                                                     });

        $tmp = Infoblox::DNS::Zone->__new__();
        $_lazy_return_fields{'zone_associations'}=[
                                                   tField('zone_associations',{
                                                                               sub_fields =>
                                                                               [
                                                                                tField('is_default'),
                                                                                tField('zone',
                                                                                       {
                                                                                        default_no_access_ok => 1,
                                                                                        sub_fields => $tmp->__return_fields__(),
                                                                                       }
                                                                                      )
                                                                               ]
                                                                              } ),
                                                   tField('use_zone_associations')
                                                  ];
        %tmp = (
                   'rir_organization'              => 'Infoblox::Grid::RIR::Organization',
                   'basic_polling_settings'        => 'Infoblox::Grid::Discovery::BasicPollSettings',
                   'discovery_blackout_setting'    => 'Infoblox::Grid::Discovery::Properties::BlackoutSetting',
                   'port_control_blackout_setting' => 'Infoblox::Grid::Discovery::Properties::BlackoutSetting',
                   'cloud_info'                    => 'Infoblox::Grid::CloudAPI::Info',
                   'ms_ad_user_data'               => 'Infoblox::Grid::MSServer::AdUser::Data',
                   'subscribe_settings'            => 'Infoblox::CiscoISE::SubscribeSetting',
                   'endpoint_sources'              => 'Infoblox::CiscoISE::Endpoint',
        );

        foreach my $key (keys %tmp) {
            $tmp = $tmp{$key}->__new__();
            push @_return_fields, tField($key, {sub_fields => $tmp->__return_fields__()});
        }
    }
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

sub __delete_sub_objects__
{
    my $self = shift;

    #
    if (defined $self->{'remove_subnets'} && $self->{ 'remove_subnets' } =~ m/false/i)
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;

	$self->{ '__internal_session_cache_ref__' } = \$session;

    #
    #
    $self->{network_view} = 'is_default:=:=:boolean:=:=:1' unless $self->{network_view};

    return $self->SUPER::__object_to_ibap__($server, $session);
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    #
    $self->{ '__internal_session_cache_ref__' } = \$session;

    #
    $self->auto_create_reversezone('false');

    foreach (
             'enable_discovery',
             'use_member_enable_discovery',
             'use_basic_polling_settings',
             'use_blackout_setting',
             'same_port_control_discovery_blackout',
             'unmanaged',

             'update_dns_on_lease_renewal',
             'enable_option81',
             'enable_ddns',
             'generate_hostname',
             'always_update_dns',
             'recycle_leases',
             'use_ddns_domainname',
             'use_ddns_ttl',
             'use_domain_name',
             'use_domain_name_servers',
             'use_enable_ddns',
             'use_enable_option81',
             'use_generate_hostname',
             'use_options',
             'use_preferred_lifetime',
             'use_update_dns_on_lease_renewal',
             'use_lease_time',
             'use_recycle_leases',
             'use_subscribe_settings',
             #
             #
             #
             #
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    #
    my $address = $$ibap_object_ref{'address'} ? $$ibap_object_ref{'address'} : '';
    my $netmask = $$ibap_object_ref{'cidr'} ? $$ibap_object_ref{'cidr'} : '';

    $self->network($address . '/' . $netmask);
    $self->network_container('/');

    $self->{endpoint_sources} = [];

    #
    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref, {'address' => 1, 'cidr' => 1, });

    my %_use_keys = (
                     'override_enable_discovery'              => 'use_member_enable_discovery',
                     'override_discovery_basic_poll_settings' => 'use_basic_polling_settings',
                     'override_blackout_setting'              => 'use_blackout_setting',

                     'override_ddns_domainname'               => 'use_ddns_domainname',
                     'override_ddns_ttl'                      => 'use_ddns_ttl',
                     'override_domain_name'                   => 'use_domain_name',
                     'override_domain_name_servers'           => 'use_domain_name_servers',
                     'override_enable_ddns'                   => 'use_enable_ddns',
                     'override_ddns_enable_option_fqdn'       => 'use_enable_option81',
                     'override_ddns_generate_hostname'        => 'use_generate_hostname',
                     'override_options'                       => 'use_options',
                     'override_preferred_lifetime'            => 'use_preferred_lifetime',
                     'override_update_dns_on_lease_renewal'   => 'use_update_dns_on_lease_renewal',
                     'override_valid_lifetime'                => 'use_lease_time',
                     'override_recycle_leases'                => 'use_recycle_leases',
                     'override_subscribe_settings'            => 'use_subscribe_settings',
                     #
                     #
    );

    foreach (keys %_use_keys) {
        $$self{$_} = ibap_value_i2o_boolean($$ibap_object_ref{$_use_keys{$_}});
    }

    return $res;
}

#
#
#

sub auto_create_reversezone
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'auto_create_reversezone', validator => \&ibap_value_o2i_boolean}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub network
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'network', validator => \&ibap_value_o2i_string}, @_);
}

sub network_container
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'network_container', validator => \&ibap_value_o2i_string}, @_);
}

sub network_view
{
    my $self = shift;

    return $self->__accessor_scalar__({name => 'network_view', validator => { 'Infoblox::DHCP::View' => 1 }}, @_);
}

sub zone_associations
{
    my $self = shift;
    return $self->__accessor_lazy_use_member_array_object__('zone_associations',\$self->{'use_zone_associations'},["Infoblox::DNS::Zone"],\&ibap_lazy_i2o_zone_associations_use_member,$_lazy_return_fields{'zone_associations'},@_);
}

sub remove_subnets
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'remove_subnets', validator => \&ibap_value_o2i_boolean}, @_);
}

sub next_available_network
{
    my $self  = shift;

	unless ($self->{ '__internal_session_cache_ref__' } && $self->__object_id__()) {
        set_error_codes(1001,'In order to get the next available network the object must have been retrieved from the server first');
		return;
	}

	my $session = ${$self->{ '__internal_session_cache_ref__' }};
	return $session->__next_available_network__($self->__object_id__(), $self, @_);
}


1;
