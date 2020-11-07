package Infoblox::DHCP::NetworkContainer;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw(@ISA $_object_type %_allowed_members %_return_field_overrides
            %_name_mappings %_reverse_name_mappings %_searchable_fields
            %_ibap_to_object %_object_to_ibap @_return_fields @_optional_return_fields %_capabilities
            $_return_fields_initialized %_lazy_return_fields);
@ISA = qw ( Infoblox::IBAPBase );

BEGIN
{
    $_object_type = 'NetworkContainer';
    register_wsdl_type('ib:NetworkContainer','Infoblox::DHCP::NetworkContainer');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    #
    #
    %_allowed_members = (
       'network'                    => 1,
       'network_view'               => 0,
       'comment'                    => 0,
       'auto_create_reversezone'    => 0,
       'extattrs'                   => {special => 'extensible_attributes'},
       'extensible_attributes'      => {special => 'extensible_attributes'},
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
       'ipam_trap_settings'                     => {'validator' => {'Infoblox::Grid::SNMP::IPAMTrap' => 1}, use => 'override_ipam_trap_settings', use_truefalse => 1},
       'override_ipam_trap_settings'            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'ipam_threshold_settings'                => {'validator' => {'Infoblox::Grid::SNMP::IPAMThreshold' => 1}, use => 'override_ipam_threshold_settings', use_truefalse => 1},
       'override_ipam_threshold_settings'       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'ipam_email_addresses'                   => {array => 1, validator => \&ibap_value_o2i_string, use => 'override_ipam_email_addresses', use_truefalse => 1},
       'override_ipam_email_addresses'          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'ms_ad_user_data'                        => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},

       logic_filters                   => {array => 1, validator => {string => 1, 'Infoblox::DHCP::Filter::MAC' => 1,
                                           'Infoblox::DHCP::Filter::NAC' => 1, 'Infoblox::DHCP::Filter::Option' => 1},
                                           use => 'override_logic_filters', use_truefalse => 1},
       override_logic_filters          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       discovery_engine_type             => {simple => 'asis', readonly => 1},
       
       #
       'cloud_info'                             => {validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
       'restart_if_needed'                      => {simple => 'bool', validator => \&ibap_value_o2i_boolean, writeonly => 1},
       'unmanaged'                              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       
       #
       options                         => 0,
       pxe_lease_time                  => 0,
       ignore_dhcp_option_list_request => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                           use => 'use_ignore_client_requested_options'},

       #
       bootfile   => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'use_boot_file'},
       bootserver => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'use_boot_server'},
       deny_bootp => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_deny_bootp'},
       nextserver => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'use_next_server'},

       #
       enable_ddns                          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_enable_ddns'},
       ddns_use_option81                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_enable_option81'},
       ddns_server_always_updates           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       ddns_generate_hostname               => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_generate_hostname'},
       ddns_update_fixed_addresses          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_update_static_leases'},
       ddns_ttl                             => {simple => 'asis', validator => \&ibap_value_o2i_uint,
                                                use => 'override_ddns_ttl', use_truefalse => 1},
       override_ddns_ttl                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       override_update_dns_on_lease_renewal => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       update_dns_on_lease_renewal          => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                use => 'override_update_dns_on_lease_renewal', use_truefalse => 1},
       #
       override_ddns_domainname        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       ddns_domainname                 => {simple => 'asis', validator => \&ibap_value_o2i_string,
                                           use => 'override_ddns_domainname', use_truefalse => 1},
       #
       enable_dhcp_thresholds          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_enable_thresholds'},
       high_water_mark                 => {simple => 'asis', validator => \&ibap_value_o2i_uint},
       high_water_mark_reset           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
       low_water_mark                  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
       low_water_mark_reset            => {simple => 'asis', validator => \&ibap_value_o2i_uint},
       enable_email_warnings           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       enable_snmp_warnings            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       email_list                      => {array => 1, validator => { 'string' => \&ibap_value_o2i_string },
                                           use => 'use_threshold_email_addresses'},
       #
       lease_scavenge_time             => {use => 'override_lease_scavenge_time',
                                           use_truefalse => 1, validator => \&ibap_value_o2i_int},
       override_lease_scavenge_time    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       authority                       => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_is_authoritative'},
       recycle_leases                  => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_recycle_leases'},

       #
       ignore_id                       => {simple => 'asis', enum => ['NONE', 'CLIENT', 'MACADDR'], use => 'override_ignore_id', use_truefalse => 1},
       ignore_mac_addresses            => {array => 1, validator => \&ibap_value_o2i_string, use => 'override_ignore_id', use_truefalse => 1},
       override_ignore_id              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},

       endpoint_sources            => {readonly => 1, array => 1, validator => {'Infoblox::CiscoISE::Endpoint' => 1}},
       override_subscribe_settings => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       subscribe_settings          => {use => 'override_subscribe_settings', use_truefalse => 1,
                                       validator => {'Infoblox::CiscoISE::SubscribeSetting' => 1}},
       mgm_private                 => {skip_accessor => 1},
       override_mgm_private        => {skip_accessor => 1},
       mgm_private_overridable     => {skip_accessor => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
    Infoblox::IBAPBase::create_mgm_private_accessors();

    %_return_field_overrides = (
       'network'                    => ['cidr'],
       'network_view'               => [],
       'comment'                    => [],
       'auto_create_reversezone'    => [],
       'extattrs'                   => [],
       'extensible_attributes'      => [],
       'network_container'          => [],
       'remove_subnets'             => [],
       'rir'                        => [],
       'rir_organization'           => [],
       'rir_registration_status'    => [],
       'last_rir_registration_update_sent'   => [],
       'last_rir_registration_update_status' => [],
       'zone_associations'          => ['use_zone_associations'],
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
       'ipam_trap_settings'                     => ['use_ipam_trap_settings'],
       'override_ipam_trap_settings'            => [],
       'ipam_threshold_settings'                => ['use_ipam_threshold_settings'],
       'override_ipam_threshold_settings'      => [],
       'ipam_email_addresses'                   => ['use_ipam_email_addresses'],
       'override_ipam_email_addresses'          => [],
       'discovery_engine_type'                  => [],

       'ms_ad_user_data'                        => [],

       'cloud_info'                             => [],
       'unmanaged'                              => [],

       'logic_filters'                          => ['use_option_logic_filters'],
       'override_logic_filters'                 => [],

       #
       'bootfile'                               => ['!bootp_properties'],
       'bootserver'                             => ['!bootp_properties'],
       'deny_bootp'                             => ['!bootp_properties'],
       'nextserver'                             => ['!bootp_properties'],

       #
       'ignore_dhcp_option_list_request'        => ['!common_properties'],
       'options'                                => ['!common_properties'],
       'pxe_lease_time'                         => ['!common_properties'],
    
       #
       'email_list'                             => ['use_threshold_email_addresses'],
       'enable_dhcp_thresholds'                 => ['use_enable_thresholds'],
       'enable_email_warnings'                  => [],
       'enable_snmp_warnings'                   => [],
       'high_water_mark'                        => [],
       'low_water_mark'                         => [],
       'high_water_mark_reset'                  => [],
       'low_water_mark_reset'                   => [],
    
       #
       'ddns_generate_hostname'                 => ['use_generate_hostname'],
       'ddns_server_always_updates'             => [],
       'ddns_ttl'                               => ['use_ddns_ttl'],
       'ddns_update_fixed_addresses'            => ['use_update_static_leases'],
       'ddns_use_option81'                      => ['use_enable_option81'],
       'enable_ddns'                            => ['use_enable_ddns'],
       'override_update_dns_on_lease_renewal'   => [],
       'update_dns_on_lease_renewal'            => ['use_update_dns_on_lease_renewal'],
    
       #
       'ddns_domainname'                        => ['use_ddns_domainname'],
       'override_ddns_domainname'               => [],
       'override_ddns_ttl'                      => [],
    
       #
       'authority'                              => ['use_is_authoritative'],
       'recycle_leases'                         => ['use_recycle_leases'],
       'lease_scavenge_time'                    => ['use_client_association_grace_period'],
       'override_lease_scavenge_time'           => [],

       #
       'ignore_id'                              => ['use_ignore_id'],
       'ignore_mac_addresses'                   => ['use_ignore_id'],
       'override_ignore_id'                     => [],

       'subscribe_settings'          => ['use_subscribe_settings'],
       'override_subscribe_settings' => [],
       'endpoint_sources'            => [],
       #
       #
       #
       #

    );

    #
    %_name_mappings = (
        network => 'address',
        network_container => 'parent_name',
       'extattrs'        => 'extensible_attributes',
       'discovery_basic_poll_settings'          => 'basic_polling_settings',
       'override_discovery_basic_poll_settings' => 'use_basic_polling_settings',
       'override_enable_discovery'              => 'use_member_enable_discovery',
       'override_blackout_setting'              => 'use_blackout_setting',
       'override_ipam_trap_settings'            => 'use_ipam_trap_settings',
       'override_ipam_threshold_settings'       => 'use_ipam_threshold_settings',
       'override_ipam_email_addresses'          => 'use_ipam_email_addresses',
       'logic_filters'          => 'option_logic_filters',
       'override_logic_filters' => 'use_option_logic_filters',
       #
       'ddns_server_always_updates'             => 'always_update_dns',
       'ddns_generate_hostname'                 => 'generate_hostname',
       'ddns_update_fixed_addresses'            => 'update_static_leases',
       'override_ddns_ttl'                      => 'use_ddns_ttl',
       'override_update_dns_on_lease_renewal'   => 'use_update_dns_on_lease_renewal',
       'ddns_use_option81'                      => 'enable_option81',
       
       #
       'override_ddns_domainname'               => 'use_ddns_domainname',
       
       #
       'enable_dhcp_thresholds'                 => 'enable_thresholds',
       'email_list'                             => 'threshold_email_addresses',
       'enable_email_warnings'                  => 'enable_threshold_email_warnings',
       'enable_snmp_warnings'                   => 'enable_threshold_snmp_warnings',
       'high_water_mark'                        => 'range_high_water_mark',
       'high_water_mark_reset'                  => 'range_high_water_mark_reset',
       'low_water_mark'                         => 'range_low_water_mark',
       'low_water_mark_reset'                   => 'range_low_water_mark_reset',
       
       #
       'authority'                              => 'is_authoritative',
       'lease_scavenge_time'                    => 'client_association_grace_period',
       'override_lease_scavenge_time'           => 'use_client_association_grace_period',

       #
       'override_ignore_id'                     => 'use_ignore_id',

       'override_subscribe_settings' => 'use_subscribe_settings',
       'override_mgm_private' => 'use_mgm_private',
    );
    %_reverse_name_mappings = reverse %_name_mappings;

    #
    %_searchable_fields = (
                              network => [\&ibap_o2i_network_string, 'address', 'REGEX'],
                              network_view => [\&ibap_o2i_network_view, 'network_view', 'EXACT'],
						      network_container  => [\&ibap_o2i_network_container_search ,'parent'     , 'LIST_CONTAIN'],
                              comment => [\&ibap_o2i_string, 'comment', 'REGEX'],
                              extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                              extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                              unmanaged             => [\&ibap_o2i_boolean, 'unmanaged', 'EXACT'],
                              discovery_engine_type => [\&ibap_o2i_string, 'discovery_engine_type', 'EXACT'],
                              );

    #
    %_ibap_to_object = (    network_view => \&ibap_i2o_generic_object_convert,
                            auto_create_reversezone => \&ibap_i2o_boolean,
                            extensible_attributes => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                            rir_organization      => \&ibap_i2o_generic_object_convert,
                            enable_discovery            => \&ibap_i2o_boolean,
                            use_member_enable_discovery => \&ibap_i2o_boolean,
                            basic_polling_settings      => \&ibap_i2o_generic_object_convert,
                            use_basic_polling_settings  => \&ibap_i2o_boolean,
                            discovery_member            => \&ibap_i2o_member_byhostname,
                            discovery_exclusion_range   => \&ibap_i2o_exclusion,
                            discovery_blackout_setting    => \&ibap_i2o_generic_object_convert,
                            port_control_blackout_setting => \&ibap_i2o_generic_object_convert,
                            ipam_trap_settings          => \&ibap_i2o_generic_object_convert,
                            ipam_threshold_settings     => \&ibap_i2o_generic_object_convert,
                            ipam_email_addresses        => \&ibap_i2o_email_list,

                            ms_ad_user_data             => \&ibap_i2o_generic_object_convert,

                            cloud_info                  => \&ibap_i2o_generic_object_convert,
                            unmanaged                   => \&ibap_i2o_boolean,

                            'option_logic_filters'     => \&ibap_i2o_ordered_filters,
                            'use_option_logic_filters' => \&ibap_i2o_boolean,

                            #
                            'enable_ddns'                         => \&ibap_i2o_boolean,
                            'enable_option81'                     => \&ibap_i2o_boolean,
                            'always_update_dns'                   => \&ibap_i2o_boolean,
                            'generate_hostname'                   => \&ibap_i2o_boolean,
                            'update_static_leases'                => \&ibap_i2o_boolean,
                            'update_dns_on_lease_renewal'         => \&ibap_i2o_boolean,
                            'use_update_dns_on_lease_renewal'     => \&ibap_i2o_boolean,
                            'use_ddns_ttl'                        => \&ibap_i2o_boolean,
                            
                            #
                            'use_ddns_domainname'                 => \&ibap_i2o_boolean,
                            
                            #
                            'enable_threshold_email_warnings'     => \&ibap_i2o_boolean,
                            'enable_threshold_snmp_warnings'      => \&ibap_i2o_boolean,
                            'enable_thresholds'                   => \&ibap_i2o_boolean,
                            'threshold_email_addresses'           => \&ibap_i2o_email_list,
                            
                            #
                            'is_authoritative'                    => \&ibap_i2o_boolean,
                            'recycle_leases'                      => \&ibap_i2o_boolean,
                            'use_client_association_grace_period' => \&ibap_i2o_boolean,

                            #
                            'ignore_id'                           => \&ibap_i2o_enums_uc_or_undef,
                            'ignore_mac_addresses'                => \&ibap_i2o_mac_addresses,
                            'use_ignore_id'                       => \&ibap_i2o_boolean,

                            'subscribe_settings'     => \&ibap_i2o_generic_object_convert,
                            'endpoint_sources'       => \&ibap_i2o_generic_object_list_convert,
                            'use_subscribe_settings' => \&ibap_i2o_boolean,
                        );

    #
    %_object_to_ibap = (    network => \&ibap_o2i_network_string,
                            network_view => \&ibap_o2i_network_view,
                            comment => \&ibap_o2i_string,
                            auto_create_reversezone => \&ibap_o2i_boolean,
                            network_container => \&ibap_o2i_ignore,
                            extattrs              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                            extensible_attributes => \&ibap_o2i_ignore,
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
                            enable_discovery              => \&ibap_o2i_boolean,
                            discovery_member              => \&ibap_o2i_member_byhostname,
                            discovery_basic_poll_settings => \&ibap_o2i_generic_struct_convert,
                            enable_immediate_discovery    => \&ibap_o2i_boolean,
                            discovery_exclusion_range     => \&ibap_o2i_exclusion,
                            override_enable_discovery     => \&ibap_o2i_boolean,
                            override_discovery_basic_poll_settings => \&ibap_o2i_boolean,
                            discover_now_status                    => \&ibap_o2i_ignore,
                            discovery_blackout_setting             => \&ibap_o2i_generic_struct_convert,
                            discovery_engine_type                  => \&ibap_o2i_ignore,
                            port_control_blackout_setting          => \&ibap_o2i_generic_struct_convert,
                            override_blackout_setting              => \&ibap_o2i_boolean,
                            same_port_control_discovery_blackout   => \&ibap_o2i_boolean,
                            ipam_trap_settings                     => \&ibap_o2i_generic_struct_convert,
                            ipam_threshold_settings                => \&ibap_o2i_generic_struct_convert,
                            ipam_email_addresses                   => \&ibap_o2i_email_list,
                            override_ipam_trap_settings            => \&ibap_o2i_boolean,
                            override_ipam_threshold_settings       => \&ibap_o2i_boolean,
                            override_ipam_email_addresses          => \&ibap_o2i_boolean,
                            ms_ad_user_data                        => \&ibap_i2o_generic_object_convert,

                            cloud_info                             => \&ibap_o2i_generic_struct_convert,
                            restart_if_needed                      => \&ibap_o2i_boolean,
                            unmanaged                              => \&ibap_o2i_boolean,

                            'override_logic_filters'               => \&ibap_o2i_boolean,
                            'logic_filters'                        => \&ibap_o2i_ordered_filters,
                            
                            #
                            #
                            #
                            #
                            #
                            
                            
                            #
                            'ignore_dhcp_option_list_request'     => \&ibap_o2i_ignore,
                            'options'                             => \&ibap_o2i_ignore,
                            'pxe_lease_time'                      => \&ibap_o2i_ignore,
                            'use_broadcast_address'               => \&ibap_o2i_ignore,
                            'use_domain_name'                     => \&ibap_o2i_ignore,
                            'use_domain_name_servers'             => \&ibap_o2i_ignore,
                            'use_ignore_client_requested_options' => \&ibap_o2i_ignore,
                            'use_lease_time'                      => \&ibap_o2i_ignore,
                            'use_options'                         => \&ibap_o2i_ignore,
                            'use_pxe_lease_time'                  => \&ibap_o2i_ignore,
                            'use_routers'                         => \&ibap_o2i_ignore,
                            
                            #
                            'bootfile'        => \&ibap_o2i_ignore,
                            'bootserver'      => \&ibap_o2i_ignore,
                            'deny_bootp'      => \&ibap_o2i_ignore,
                            'nextserver'      => \&ibap_o2i_ignore,
                            'use_boot_file'   => \&ibap_o2i_ignore,
                            'use_boot_server' => \&ibap_o2i_ignore,
                            'use_next_server' => \&ibap_o2i_ignore,
                            'use_deny_bootp'  => \&ibap_o2i_ignore,
                            
                            #
                            'ddns_generate_hostname'               => \&ibap_o2i_boolean,
                            'ddns_server_always_updates'           => \&ibap_o2i_boolean,
                            'ddns_ttl'                             => \&ibap_o2i_uint,
                            'ddns_update_fixed_addresses'          => \&ibap_o2i_boolean,
                            'ddns_use_option81'                    => \&ibap_o2i_boolean,
                            'enable_ddns'                          => \&ibap_o2i_boolean,
                            'update_dns_on_lease_renewal'          => \&ibap_o2i_boolean,
                            'override_update_dns_on_lease_renewal' => \&ibap_o2i_boolean,
                            'override_ddns_ttl'                    => \&ibap_o2i_boolean,
                            
                            #
                            'ddns_domainname'          => \&ibap_o2i_string,
                            'use_enable_ddns'          => \&ibap_o2i_boolean,
                            'use_enable_option81'      => \&ibap_o2i_boolean,
                            'use_generate_hostname'    => \&ibap_o2i_boolean,
                            'use_update_static_leases' => \&ibap_o2i_boolean,
                            'override_ddns_domainname' => \&ibap_o2i_boolean,
                            
                            #
                            'email_list'                    => \&ibap_o2i_email_list,
                            'enable_dhcp_thresholds'        => \&ibap_o2i_boolean,
                            'enable_email_warnings'         => \&ibap_o2i_boolean,
                            'enable_snmp_warnings'          => \&ibap_o2i_boolean,
                            'high_water_mark'               => \&ibap_o2i_uint,
                            'high_water_mark_reset'         => \&ibap_o2i_uint,
                            'low_water_mark'                => \&ibap_o2i_uint,
                            'low_water_mark_reset'          => \&ibap_o2i_uint,
                            'use_enable_thresholds'         => \&ibap_o2i_boolean,
                            'use_threshold_email_addresses' => \&ibap_o2i_boolean,
                            
                            #
                            'use_is_authoritative'         => \&ibap_o2i_boolean,
                            'authority'                    => \&ibap_o2i_boolean,
                            'lease_scavenge_time'          => \&ibap_o2i_integer,
                            'recycle_leases'               => \&ibap_o2i_boolean,
                            'use_recycle_leases'           => \&ibap_o2i_boolean,
                            'override_lease_scavenge_time' => \&ibap_o2i_boolean,

                            #
                            'ignore_id'            => \&ibap_o2i_string,
                            'ignore_mac_addresses' => \&ibap_o2i_mac_addresses,
                            'override_ignore_id'   => \&ibap_o2i_boolean,

                            'mgm_private' => \&ibap_o2i_boolean,
                            'override_mgm_private' => \&ibap_o2i_boolean,
                            'mgm_private_overridable' => \&ibap_o2i_ignore,

                            'subscribe_settings'          => \&ibap_o2i_generic_struct_convert,
                            'endpoint_sources'            => \&ibap_o2i_ignore,
                            'override_subscribe_settings' => \&ibap_o2i_boolean,
                          );


    #
    $_return_fields_initialized = 0;
    @_return_fields = (
                       tField('address'),
                       tField('cidr'),
                       tField('comment'),
                       tField('parent_name'),
                       tField('rir'),
                       tField('rir_registration_status'),
                       tField('last_rir_registration_update_sent'),
                       tField('last_rir_registration_update_status'),
                       tField('auto_create_reversezone'),
                       tField('enable_discovery'),
                       tField('use_member_enable_discovery'),
                       tField('use_basic_polling_settings'),
                       tField('discovery_member', {'sub_fields' => [tField('host_name')]}),
                       tField('discovery_exclusion_range', {'depth' => 1}),
                       tField('use_blackout_setting'),
                       tField('same_port_control_discovery_blackout'),
                       tField('use_ipam_trap_settings'),
                       tField('use_ipam_threshold_settings'),
                       tField('ipam_email_addresses', {'sub_fields' => [tField('email_address')]}),
                       tField('use_ipam_email_addresses'),
                       tField('unmanaged'),
                       tField('discovery_engine_type'),
                       return_fields_extensible_attributes(),

                       tField('use_option_logic_filters'),
                       tField('option_logic_filters', return_fields_option_logic_filters()),
                        
                       #
                       tField('common_properties', {depth => 2}),

                       #
                       tField('bootp_properties', {depth => 1}),

                       #
                       tField('always_update_dns'),
                       tField('ddns_ttl'),
                       tField('enable_ddns'),
                       tField('enable_option81'),
                       tField('generate_hostname'),
                       tField('update_dns_on_lease_renewal'),
                       tField('update_static_leases'),
                       tField('use_ddns_ttl'),
                       tField('use_update_dns_on_lease_renewal'),

                       #
                       tField('ddns_domainname'),
                       tField('use_ddns_domainname'),
                       tField('use_enable_ddns'),
                       tField('use_enable_option81'),
                       tField('use_generate_hostname'),
                       tField('use_update_static_leases'),

                       #
                       tField('enable_threshold_email_warnings'),
                       tField('enable_threshold_snmp_warnings'),
                       tField('enable_thresholds'),
                       tField('range_high_water_mark'),
                       tField('range_high_water_mark_reset'),
                       tField('range_low_water_mark'),
                       tField('range_low_water_mark_reset'),
                       tField('threshold_email_addresses', {sub_fields => [tField('email_address')]}),
                       tField('use_enable_thresholds'),
                       tField('use_threshold_email_addresses'),

                       #
                       tField('client_association_grace_period'),
                       tField('is_authoritative'),
                       tField('recycle_leases'),
                       tField('use_client_association_grace_period'),
                       tField('use_is_authoritative'),
                       tField('use_recycle_leases'),

                       #
                       tField('ignore_id'),
                       tField('ignore_mac_addresses', {sub_fields => [tField('mac_addr')]}),
                       tField('use_ignore_id'),

                       tField('use_subscribe_settings'),

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

        #
        my $t = Infoblox::DHCP::View->__new__();
        push @_return_fields, 
          tField('network_view', {
                                  default_no_access_ok => 1,
                                  sub_fields => $t->__return_fields__(),
                                 }
        );
        $t = Infoblox::DNS::Zone->__new__();
        $_lazy_return_fields{'zone_associations'}=[
        tField('zone_associations',{
            sub_fields => 
            [ 
            tField('is_default'),
            tField('zone',
              {
               default_no_access_ok => 1,
               sub_fields => $t->__return_fields__(),
              }
            )
            ]
          } ),
        tField('use_zone_associations')
        ];

        my %tmp = (
                   'rir_organization'              => 'Infoblox::Grid::RIR::Organization',
                   'basic_polling_settings'        => 'Infoblox::Grid::Discovery::BasicPollSettings',
                   'discovery_blackout_setting'    => 'Infoblox::Grid::Discovery::Properties::BlackoutSetting',
                   'port_control_blackout_setting' => 'Infoblox::Grid::Discovery::Properties::BlackoutSetting',
                   'ipam_trap_settings'            => 'Infoblox::Grid::SNMP::IPAMTrap',
                   'ipam_threshold_settings'       => 'Infoblox::Grid::SNMP::IPAMThreshold',
                   'cloud_info'                    => 'Infoblox::Grid::CloudAPI::Info',
                   'ms_ad_user_data'               => 'Infoblox::Grid::MSServer::AdUser::Data',
                   'subscribe_settings'            => 'Infoblox::CiscoISE::SubscribeSetting',
                   'endpoint_sources'              => 'Infoblox::CiscoISE::Endpoint',
        );

        foreach my $key (keys %tmp) {
            $t = $tmp{$key}->__new__();
            push @_return_fields, tField($key, {sub_fields => $t->__return_fields__()});
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
	if (defined $self->{'remove_subnets'} && $self->{ 'remove_subnets' } =~ m/false/i) {
		return 0;
	}
	else {
		return 1;
	}
}

sub __object_to_ibap__
{
    my ($self, $server, $session, $skipref) = @_;

    #
    $self->{ '__internal_session_cache_ref__' } = \$session;

    #
    #
    $self->{network_view} = 'is_default:=:=:boolean:=:=:1' unless $self->{network_view};

    #
    #
    #
    #

    if (not defined $self->{'ddns_server_always_updates'}) {
        $self->ddns_server_always_updates('true');
    }

    my @thrshld_use_members = (
        'email_list',
        'enable_dhcp_thresholds',  
        'enable_email_warnings',
        'enable_snmp_warnings',
    );

    if (scalar(grep {defined $self->{$_}} @thrshld_use_members) != 0) {
       $$self{'use_enable_thresholds'} = 1;
    } else {
        $$self{'use_enable_thresholds'} = 0;
    }

    my $write_fields_ref = $self->SUPER::__object_to_ibap__($server, $session, $skipref);

    my %_options_o2i = (
                        'bootp_properties'  => \&ibap_arg_bootp_props,
                        'common_properties' => \&ibap_o2i_common_dhcp_props,
    );

    foreach (keys %_options_o2i) {

        my ($success, $ignore, $value) =
             $_options_o2i{$_}->($self, $session,  '', $self);

        return undef unless $success;

        unless ($ignore) {
            unshift @{$write_fields_ref}, {
                'field' => $_,
                'value' => $value,
            }
        }
    }

        return $write_fields_ref;
}


sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    #
    $self->{ '__internal_session_cache_ref__' } = \$session;

    #
    $self->auto_create_reversezone('false');

    #
    foreach (
             'enable_discovery',
             'same_port_control_discovery_blackout',
             'unmanaged',
             'use_basic_polling_settings',
             'use_blackout_setting',
             'use_ipam_email_addresses',
             'use_ipam_threshold_settings',
             'use_ipam_trap_settings',
             'use_member_enable_discovery',
             'use_option_logic_filters',

             #
             'use_threshold_email_addresses',
             'enable_thresholds',
             'enable_threshold_email_warnings',
             'enable_threshold_snmp_warnings',

             #
             'use_update_dns_on_lease_renewal',
             'update_dns_on_lease_renewal',
             'use_ddns_ttl',
             'ddns_ttl',
             'always_update_dns',
             'generate_hostname',
             'update_statis_leases',
             'enable_option81',
             'enable_ddns',

             #
             'use_enable_ddns',
             'use_enable_option81',
             'use_generate_hostname',
             'use_update_static_leases',
             'use_ddns_domainname',

             #
             'use_client_association_grace_period',
             'use_recycle_leases',
             'use_is_authoritative',
             'is_authoritative',
             'recycle_leases',
             'use_recycle_leases',

             #
             'use_ignore_id',

             'use_subscribe_settings',

             #
             #
             #
             #
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }
    
    $$ibap_object_ref{'bootp_properties'} = {}
        unless defined $$ibap_object_ref{'bootp_properties'};

    foreach (
             'use_deny_bootp',
             'use_boot_file',
             'use_boot_server',
             'use_next_server',
             'deny_bootp',
    ) {

        $$ibap_object_ref{'bootp_properties'}{$_} = 0
            unless defined $$ibap_object_ref{'bootp_properties'}{$_};

    }

    foreach (
             'use_domain_name',
             'use_lease_time',
             'use_pxe_lease_time',
             'use_ignore_client_requested_options',
             'ignore_client_requested_options',
    ) {
        $$ibap_object_ref{'common_properties'}{$_} = 0
            unless defined $$ibap_object_ref{'common_properties'}{$_};
    }


    $$ibap_object_ref{'threshold_email_addresses'} = []
        unless defined $ibap_object_ref->{'threshold_email_addresses'};

    #
    my $address = $$ibap_object_ref{'address'} ? $$ibap_object_ref{'address'} : '';
    my $netmask = $$ibap_object_ref{'cidr'} ? $$ibap_object_ref{'cidr'} : '';

    $self->network($address . '/' . $netmask);
    $self->network_container('/');

    $self->{endpoint_sources} = [];

    #
    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref, {'address' => 1, 'cidr' => 1, });

    my %_properties_i2o = (
                           'bootp_properties'  => \&ibap_i2o_bootp_props,
                           'common_properties' => \&ibap_i2o_common_dhcp_props,
    );

    foreach (keys %_properties_i2o) {
        $_properties_i2o{$_}->($self, $session, $_, $ibap_object_ref);
    }

    my %_use_remove_fields = (
                              'use_enable_ddns'                     => 'enable_ddns',
                              'use_enable_option81'                 => 'ddns_use_option81',
                              'use_enable_thresholds'               => [
                                                                        'enable_dhcp_thresholds',
                                                                        'email_list',
                                                                        'enable_email_warnings',
                                                                        'enable_snmp_warnings',
                                                                       ],  
                              'use_generate_hostname'               => 'ddns_generate_hostname',
                              'use_is_authoritative'                => 'authority',
                              'use_update_static_leases'            => 'ddns_update_fixed_addresses',
                              'use_recycle_leases'                  => 'recycle_leases',
                              'use_threshold_email_addresses'       => 'email_list',
    );

    $self->__use_remove_fields__($ibap_object_ref, \%_use_remove_fields);

    my %_bootp_use_remove_fields = (
                                    'use_deny_bootp'  => 'deny_bootp',
                                    'use_boot_file'   => 'bootfile',
                                    'use_boot_server' => 'bootserver',
                                    'use_next_server' => 'nextserver',
    );

    $self->__use_remove_fields__($$ibap_object_ref{'bootp_properties'}, \%_bootp_use_remove_fields);

    my %_common_use_remove_fields = (
                                     'use_ignore_client_requested_options' => 'ignore_dhcp_option_list_request',
                                     'use_pxe_lease_time'                  => 'pxe_lease_time',
    );

    $self->__use_remove_fields__($$ibap_object_ref{'common_properties'}, \%_common_use_remove_fields);


    #
    my %_use_keys = (
                     'override_blackout_setting'              => 'use_blackout_setting',
                     'override_discovery_basic_poll_settings' => 'use_basic_polling_settings',
                     'override_enable_discovery'              => 'use_member_enable_discovery',
                     'override_ipam_email_addresses'          => 'use_ipam_email_addresses',
                     'override_ipam_threshold_settings'       => 'use_ipam_threshold_settings',
                     'override_ipam_trap_settings'            => 'use_ipam_trap_settings',
                     'override_logic_filters'                 => 'use_option_logic_filters',

                     #
                     'override_ddns_ttl'                      => 'use_ddns_ttl',
                     'override_ddns_domainname'               => 'use_ddns_domainname',
                     'override_update_dns_on_lease_renewal'   => 'use_update_dns_on_lease_renewal',
                     'override_lease_scavenge_time'           => 'use_client_association_grace_period',
                     'override_ignore_id'                     => 'use_ignore_id',
                     'override_subscribe_settings'            => 'use_subscribe_settings',
                     #
                     #
    );

    foreach (keys %_use_keys) {
        $$self{$_} = ibap_value_i2o_boolean($$ibap_object_ref{$_use_keys{$_}});
    }

    return $res;
}

sub __use_remove_fields__ {

    my ($self, $ibap_object_ref, $use_remove_fields) = @_;

    foreach (keys %$use_remove_fields) {
        if (defined $$ibap_object_ref{$_}) {

            $self->{$_} = $$ibap_object_ref{$_};

            if ($$ibap_object_ref{$_} != 1) {
                if (ref $$self{$$use_remove_fields{$_}} eq 'ARRAY') {
                    foreach my $key (@{$$self{$$use_remove_fields{$_}}}) {
                        delete $$self{$key};
                    }
                } else {
                    delete $$self{$$use_remove_fields{$_}};
                }
            }
        }
    }
}

#
#
#

sub network
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'network', validator => \&ibap_value_o2i_string}, @_);
}

sub network_view
{
    my $self = shift;

    return $self->__accessor_scalar__({name => 'network_view', validator => { 'Infoblox::DHCP::View' => 1 }}, @_);
}

sub network_container
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'network_container', validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub auto_create_reversezone
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'auto_create_reversezone', validator => \&ibap_value_o2i_boolean}, @_);
}

sub resize
{
    my ($self, %args)  = @_;

    unless ($self->{ '__internal_session_cache_ref__' } &&
            $self->__object_id__()) {
        set_error_codes(1001,'In order to resize the network container, the object must have been retrieved from the server first');
        return;
    }

    my $session = ${$self->{ '__internal_session_cache_ref__' }};
    return $session->__resize_network_or_container__($self->__object_id__(), \%args);
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

sub options
{
    my $self  = shift;
    return ibap_accessor_dhcp_options($self, 'options', @_);
}

sub pxe_lease_time
{
    my $self = shift;

    my $res = return $self->__accessor_scalar__({name => 'pxe_lease_time', use => 'use_pxe_lease_time', validator => \&ibap_value_o2i_uint}, @_);

    if (@_ and not defined $_[0] and $self->{'enable_pxe_lease_time'}) {
        $self->{'use_pxe_lease_time'} = 1;
    }

    return $res;
}


1;
