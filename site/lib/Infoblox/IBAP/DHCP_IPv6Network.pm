package Infoblox::DHCP::IPv6Network;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields @_optional_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object $_return_fields_initialized %_return_field_overrides %_capabilities $_return_fields_initialized %_lazy_return_fields);
@ISA = qw ( Infoblox::IBAPBase );

BEGIN {
	$_object_type = 'IPv6Network';
    register_wsdl_type('ib:IPv6Network', 'Infoblox::DHCP::IPv6Network');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members = (
                         auto_create_reversezone              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         comment                              => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         ddns_domainname                      => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_ddns_domainname', use_truefalse => 1},
                         ddns_enable_option_fqdn              => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_ddns_enable_option_fqdn', use_truefalse => 1},
                         ddns_generate_hostname               => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_ddns_generate_hostname', use_truefalse => 1},
                         ddns_server_always_updates           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         ddns_ttl                             => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_ddns_ttl', use_truefalse => 1},
                         disable                              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         domain_name                          => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_domain_name', use_truefalse => 1},
                         domain_name_servers                  => {validator => \&ibap_value_o2i_string, use => 'override_domain_name_servers', use_truefalse => 1},
                         enable_ddns                          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_enable_ddns', use_truefalse => 1},
                         enable_ifmap_publishing              => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_enable_ifmap_publishing', use_truefalse => 1},
                         extattrs                             => {special => 'extensible_attributes'},
                         extensible_attributes                => {special => 'extensible_attributes'},
                         members                              => {array => 1, validator => { 'Infoblox::DHCP::Member' => 1 }, nomixed => 1},
                         network                              => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_ipv6_network},
                         network_container                    => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         network_view                         => {validator => { 'Infoblox::DHCP::View' => 1 }},
                         options                              => {array => 1, validator => { 'Infoblox::DHCP::Option' => 1}, use => 'override_options', use_truefalse => 1},
                         override_ddns_domainname             => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_ddns_enable_option_fqdn     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_ddns_ttl                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_domain_name                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_domain_name_servers         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_enable_ddns                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_enable_ifmap_publishing     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_ddns_generate_hostname      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_options                     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_preferred_lifetime          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_recycle_leases              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_update_dns_on_lease_renewal => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_valid_lifetime              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         preferred_lifetime                   => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_preferred_lifetime', use_truefalse => 1},
                         recycle_leases                       => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_recycle_leases', use_truefalse => 1},
                         rir                                  => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         rir_organization                     => {validator => {'Infoblox::Grid::RIR::Organization' => 1}},
                         rir_registration_action              => {simple => 'asis', enum => ['NONE', 'CREATE', 'MODIFY', 'DELETE']}, # write-only
                         rir_registration_status              => {simple => 'asis', enum => ['NOT_REGISTERED', 'REGISTERED']},
                         last_rir_registration_update_sent    => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         last_rir_registration_update_status  => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         send_rir_request                     => {simple => 'bool', validator => \&ibap_value_o2i_boolean}, # write-only
                         delete_reason                        => {simple => 'asis', validator => \&ibap_value_o2i_string}, # write-only
                         shared_network_name                  => {simple => 'asis', readonly => 1},
                         template                             => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         update_dns_on_lease_renewal          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_update_dns_on_lease_renewal', use_truefalse => 1},
                         valid_lifetime                       => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_valid_lifetime', use_truefalse => 1},
                         zone_associations                    => 0,
                         enable_discovery                       => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_enable_discovery', use_members => ['enable_discovery', 'discovery_member'], use_truefalse => 1},
                         override_enable_discovery              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         discovery_member                       => {validator => \&ibap_value_o2i_string, use => 'override_enable_discovery', use_members => ['enable_discovery', 'discovery_member'], use_truefalse => 1},
                         discovery_basic_poll_settings          => {validator => {'Infoblox::Grid::Discovery::BasicPollSettings' => 1}, use => 'override_discovery_basic_poll_settings', use_truefalse => 1},
                         discovery_exclusion_range              => {array => 1, validator => {'Infoblox::DHCP::ExclusionRange' => 1}},
                         override_discovery_basic_poll_settings => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         enable_immediate_discovery             => {simple => 'bool', writeonly => 1, validator => \&ibap_value_o2i_boolean},
                         discover_now_status                    => {simple => 'asis', readonly => 1},
                         discovery_blackout_setting             => {validator => {'Infoblox::Grid::Discovery::Properties::BlackoutSetting' => 1}, use => 'override_blackout_setting', 'use_members' => ['discovery_blackout_setting', 'port_control_blackout_setting'], use_truefalse => 1},
                         port_control_blackout_setting          => {validator => {'Infoblox::Grid::Discovery::Properties::BlackoutSetting' => 1}, use => 'override_blackout_setting', 'use_members' => ['discovery_blackout_setting', 'port_control_blackout_setting'], use_truefalse => 1},
                         same_port_control_discovery_blackout   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_blackout_setting              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         ms_ad_user_data                        => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
                         cloud_info                             => {validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
                         restart_if_needed                      => {simple => 'bool', validator => \&ibap_value_o2i_boolean, writeonly => 1},
                         unmanaged                              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         endpoint_sources                       => {readonly => 1, array => 1, validator => {'Infoblox::CiscoISE::Endpoint' => 1}},
                         override_subscribe_settings            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         subscribe_settings                     => {use => 'override_subscribe_settings', use_truefalse => 1,
                                                                    validator => {'Infoblox::CiscoISE::SubscribeSetting' => 1}},
                         mgm_private                            => {skip_accessor => 1},
                         override_mgm_private                   => {skip_accessor => 1},
                         mgm_private_overridable                => {skip_accessor => 1},
                         discovery_engine_type                  => {simple => 'asis', readonly => 1},
                         discovered_bridge_domain               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         discovered_tenant                      => {simple => 'asis', validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
    Infoblox::IBAPBase::create_mgm_private_accessors();

    %_name_mappings = (
					   'ddns_enable_option_fqdn'              => 'enable_option81',
					   'ddns_generate_hostname'               => 'generate_hostname',
					   'ddns_server_always_updates'           => 'always_update_dns',
					   'disable'                              => 'disabled',
                       'extattrs'                             => 'extensible_attributes',
					   'members'                              => 'dhcp_members',
					   'network'                              => 'address',
                       'network_container'                    => 'parent_name',
                       'override_ddns_domainname'             => 'use_ddns_domainname',
                       'override_ddns_ttl'                    => 'use_ddns_ttl',
                       'override_domain_name'                 => 'use_domain_name',
                       'override_domain_name_servers'         => 'use_domain_name_servers',
                       'override_enable_ddns'                 => 'use_enable_ddns',
                       'override_enable_ifmap_publishing'     => 'use_enable_ifmap_publishing',
                       'override_ddns_generate_hostname'      => 'use_generate_hostname',
                       'override_options'                     => 'use_options',
                       'override_preferred_lifetime'          => 'use_preferred_lifetime',
                       'override_recycle_leases'              => 'use_recycle_leases',
                       'override_update_dns_on_lease_renewal' => 'use_update_dns_on_lease_renewal',
                       'override_ddns_enable_option_fqdn'     => 'use_enable_option81',
                       'override_valid_lifetime'              => 'use_lease_time',
                       'valid_lifetime'                       => 'lease_time',
                       'discovery_basic_poll_settings'          => 'basic_polling_settings',
                       'override_discovery_basic_poll_settings' => 'use_basic_polling_settings',
                       'override_enable_discovery'              => 'use_member_enable_discovery',
                       'override_blackout_setting'              => 'use_blackout_setting',
                       'override_subscribe_settings'            => 'use_subscribe_settings',
                       'override_mgm_private' => 'use_mgm_private',
                      );

    %_searchable_fields = (
                           comment               => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           member                => [\&ibap_o2i_member_search, '__DYNAMIC__', 'EXACT'],
                           network               => [\&ibap_o2i_network_string, 'address', 'REGEX'],
                           network_view          => [\&ibap_o2i_network_view , 'network_view', 'EXACT'],
                           extattrs              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           unmanaged             => [\&ibap_o2i_boolean, 'unmanaged', 'EXACT'],
                           discovery_engine_type => [\&ibap_o2i_string, 'discovery_engine_type', 'EXACT'],
                           discovered_bridge_domain => [\&ibap_o2i_string, 'discovered_bridge_domain', 'REGEX', 'IGNORE_CASE'],
                           discovered_tenant        => [\&ibap_o2i_string, 'discovered_tenant', 'REGEX', 'IGNORE_CASE'],
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'auto_create_reversezone'                 => \&ibap_i2o_boolean,
                        'enable_option81'                         => \&ibap_i2o_boolean,
						'dhcp_members'                            => \&ibap_i2o_members_list,
						'domain_name_servers'                     => \&ibap_i2o_domain_name_servers,
                        'extensible_attributes'                   => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'enable_ifmap_publishing'                 => \&ibap_i2o_boolean,
                        'generate_hostname'                       => \&ibap_i2o_boolean,
                        'network_view'                            => \&ibap_i2o_generic_object_convert,
                        'options'                                 => \&ibap_i2o_options,
                        'recycle_leases'                          => \&ibap_i2o_boolean,
                        'rir_organization'                        => \&ibap_i2o_generic_object_convert,
                        'use_ddns_domainname'                     => \&ibap_i2o_boolean,
                        'use_ddns_ttl'                            => \&ibap_i2o_boolean,
                        'use_domain_name'                         => \&ibap_i2o_boolean,
                        'use_domain_name_servers'                 => \&ibap_i2o_boolean,
                        'use_enable_ddns'                         => \&ibap_i2o_boolean,
                        'use_enable_ifmap_publishing'             => \&ibap_i2o_boolean,
                        'use_enable_option81'                     => \&ibap_i2o_boolean,
                        'use_generate_hostname'                   => \&ibap_i2o_boolean,
                        'use_lease_time'                          => \&ibap_i2o_boolean,
                        'use_options'                             => \&ibap_i2o_boolean,
                        'use_preferred_lifetime'                  => \&ibap_i2o_boolean,
                        'use_recycle_leases'                      => \&ibap_i2o_boolean,
                        'use_update_dns_on_lease_renewal'         => \&ibap_i2o_boolean,
                        'enable_discovery'                        => \&ibap_i2o_boolean,
                        'use_member_enable_discovery'             => \&ibap_i2o_boolean,
                        'basic_polling_settings'                  => \&ibap_i2o_generic_object_convert,
                        'use_basic_polling_settings'              => \&ibap_i2o_boolean,
                        'discovery_member'                        => \&ibap_i2o_member_byhostname,
                        'discovery_exclusion_range'               => \&ibap_i2o_exclusion,
                        'discovery_blackout_setting'              => \&ibap_i2o_generic_object_convert,
                        'port_control_blackout_setting'           => \&ibap_i2o_generic_object_convert,
                        'cloud_info'                              => \&ibap_i2o_generic_object_convert,
                        'unmanaged'                               => \&ibap_i2o_boolean,
                        'ms_ad_user_data'                         => \&ibap_i2o_generic_object_convert,
                        'use_option_logic_filters'                => \&ibap_i2o_boolean,
                        'subscribe_settings'                      => \&ibap_i2o_generic_object_convert,
                        'endpoint_sources'                        => \&ibap_i2o_generic_object_list_convert,
                       );

    %_object_to_ibap = (
                        'auto_create_reversezone'              => \&ibap_o2i_boolean,
                        'comment'                              => \&ibap_o2i_string,
                        'ddns_domainname'                      => \&ibap_o2i_string,
                        'ddns_enable_option_fqdn'              => \&ibap_o2i_boolean,
                        'ddns_generate_hostname'               => \&ibap_o2i_boolean,
                        'ddns_server_always_updates'           => \&ibap_o2i_boolean,
                        'ddns_ttl'                             => \&ibap_o2i_uint,
                        'disable'                              => \&ibap_o2i_boolean,
                        'domain_name'                          => \&ibap_o2i_string,
                        'domain_name_servers'                  => \&ibap_o2i_domain_name_servers,
                        'enable_ddns'                          => \&ibap_o2i_boolean,
                        'enable_ifmap_publishing'              => \&ibap_o2i_boolean,
                        'extattrs'                             => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'                => \&ibap_o2i_ignore,
                        'generate_hostname'                    => \&ibap_o2i_boolean,
                        'members'                              => \&ibap_o2i_members_list,
                        'network'                              => \&ibap_o2i_network_string,
                        'network_container'                    => \&ibap_o2i_ignore,
                        'network_view'                         => \&ibap_o2i_network_view,
                        'options'                              => \&ibap_o2i_options,
                        'override_ddns_domainname'             => \&ibap_o2i_boolean,
                        'override_ddns_ttl'                    => \&ibap_o2i_boolean,
                        'override_domain_name'                 => \&ibap_o2i_boolean,
                        'override_domain_name_servers'         => \&ibap_o2i_boolean,
                        'override_enable_ddns'                 => \&ibap_o2i_boolean,
                        'override_enable_ifmap_publishing'     => \&ibap_o2i_boolean,
                        'override_ddns_enable_option_fqdn'     => \&ibap_o2i_boolean,
                        'override_ddns_generate_hostname'      => \&ibap_o2i_boolean,
                        'override_options'                     => \&ibap_o2i_boolean,
                        'override_preferred_lifetime'          => \&ibap_o2i_boolean,
                        'override_recycle_leases'              => \&ibap_o2i_boolean,
                        'override_update_dns_on_lease_renewal' => \&ibap_o2i_boolean,
                        'override_valid_lifetime'              => \&ibap_o2i_boolean,
                        'preferred_lifetime'                   => \&ibap_o2i_uint,
                        'recycle_leases'                       => \&ibap_o2i_boolean,
                        'rir'                                  => \&ibap_o2i_ignore,
                        'rir_organization'                     => \&ibap_o2i_rir_organization,
                        'rir_registration_action'              => \&ibap_o2i_string,
                        'rir_registration_status'              => \&ibap_o2i_string,
                        'last_rir_registration_update_sent'    => \&ibap_o2i_ignore,
                        'last_rir_registration_update_status'  => \&ibap_o2i_ignore,
                        'send_rir_request'                     => \&ibap_o2i_boolean,
                        'delete_reason'                        => \&ibap_o2i_string,
                        'shared_network_name'                  => \&ibap_o2i_ignore,
                        'template'                             => \&__o2i_template__,
                        'update_dns_on_lease_renewal'          => \&ibap_o2i_boolean,
                        'use_zone_associations'                => \&ibap_o2i_boolean,
                        'zone_associations'                    => \&ibap_o2i_zone_associations,
                        'valid_lifetime'                       => \&ibap_o2i_uint_skip_undef,
                        'enable_discovery'                     => \&ibap_o2i_boolean,
                        'discovery_member'                     => \&ibap_o2i_member_byhostname,
                        'discovery_basic_poll_settings'        => \&ibap_o2i_generic_struct_convert,
                        'enable_immediate_discovery'           => \&ibap_o2i_boolean,
                        'discovery_exclusion_range'            => \&ibap_o2i_exclusion,
                        'override_enable_discovery'            => \&ibap_o2i_boolean,
                        'override_discovery_basic_poll_settings' => \&ibap_o2i_boolean,
                        'discover_now_status'                    => \&ibap_o2i_ignore,
                        'discovery_blackout_setting'             => \&ibap_o2i_generic_struct_convert,
                        'port_control_blackout_setting'          => \&ibap_o2i_generic_struct_convert,
                        'override_blackout_setting'              => \&ibap_o2i_boolean,
                        'same_port_control_discovery_blackout'   => \&ibap_o2i_boolean,
                        'cloud_info'                             => \&ibap_o2i_generic_struct_convert,
                        'restart_if_needed'                      => \&ibap_o2i_boolean,
                        'unmanaged'                              => \&ibap_o2i_boolean,
                        'ms_ad_user_data'                        => \&ibap_o2i_ignore,
                        'subscribe_settings'                     => \&ibap_o2i_generic_struct_convert,
                        'endpoint_sources'                       => \&ibap_o2i_ignore,
                        'override_subscribe_settings'            => \&ibap_o2i_boolean,
                        'mgm_private'                            => \&ibap_o2i_boolean,
                        'override_mgm_private'                   => \&ibap_o2i_boolean,
                        'mgm_private_overridable'                => \&ibap_o2i_ignore,
                        'discovery_engine_type'                  => \&ibap_o2i_ignore,
                        'discovered_bridge_domain'               => \&ibap_o2i_string,
                        'discovered_tenant'                      => \&ibap_o2i_string,
                       );

    %_return_field_overrides = (
                                'auto_create_reversezone'              => [],
                                'comment'                              => [],
                                'ddns_domainname'                      => ['use_ddns_domainname'],
                                'ddns_enable_option_fqdn'              => ['use_enable_option81'],
                                'ddns_generate_hostname'               => ['use_generate_hostname'],
                                'ddns_server_always_updates'           => [],
                                'ddns_ttl'                             => ['use_ddns_ttl'],
                                'domain_name'                          => ['use_domain_name'],
                                'domain_name_servers'                  => ['use_domain_name_servers'],
                                'disable'                              => [],
                                'enable_ddns'                          => ['use_enable_ddns'],
                                'enable_ifmap_publishing'              => ['use_enable_ifmap_publishing'],
                                'extattrs'                             => [],
                                'extensible_attributes'                => [],
                                'generate_hostname'                    => ['use_generate_hostname'],
                                'members'                              => [],
                                'network'                              => ['cidr'],
                                'network_container'                    => [],
                                'network_view'                         => [],
                                'options'                              => ['use_options'],
                                'override_ddns_domainname'             => [],
                                'override_ddns_ttl'                    => [],
                                'override_domain_name'                 => [],
                                'override_domain_name_servers'         => [],
                                'override_enable_ddns'                 => [],
                                'override_enable_ifmap_publishing'     => [],
                                'override_ddns_enable_option_fqdn'     => [],
                                'override_ddns_generate_hostname'      => [],
                                'override_options'                     => [],
                                'override_preferred_lifetime'          => [],
                                'override_recycle_leases'              => [],
                                'override_update_dns_on_lease_renewal' => [],
                                'override_valid_lifetime'              => [],
                                'preferred_lifetime'                   => ['use_preferred_lifetime'],
                                'recycle_leases'                       => ['use_recycle_leases'],
                                'rir'                                  => [],
                                'rir_organization'                     => [],
                                'rir_registration_status'              => [],
                                'last_rir_registration_update_sent'    => [],
                                'last_rir_registration_update_status'  => [],
                                'shared_network_name'                  => [],
                                'template'                             => [],
                                'update_dns_on_lease_renewal'          => ['use_update_dns_on_lease_renewal'],
                                'use_zone_associations'                => [],
                                'valid_lifetime'                       => ['use_lease_time'],
                                'zone_associations'                    => ['use_zone_associations'],
                                'enable_discovery'                     => ['discovery_member','use_member_enable_discovery'],
                                'override_enable_discovery'            => [],
                                'discovery_member'                     => ['enable_discovery','use_member_enable_discovery'],
                                'discovery_exclusion_range'            => [],
                                'discovery_basic_poll_settings'        => ['use_basic_polling_settings'],
                                'override_discovery_basic_poll_settings' => [],
                                'discover_now_status'                    => [],
                                'discovery_blackout_setting'             => ['port_control_blackout_setting', 'use_blackout_setting'],
                                'port_control_blackout_setting'          => ['discovery_blackout_setting', 'use_blackout_setting'],
                                'override_blackout_setting'              => [],
                                'same_port_control_discovery_blackout'   => [],
                                'cloud_info'                             => [],
                                'unmanaged'                              => [],
                                'ms_ad_user_data'                        => [],
                                'subscribe_settings'                     => ['use_subscribe_settings'],
                                'override_subscribe_settings'            => [],
                                'endpoint_sources'                       => [],
                                'discovery_engine_type'                  => [],
                                'discovered_bridge_domain'               => [],
                                'discovered_tenant'                      => [],
                                #
                                #
                                #
                                #
                               );



    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('address'),
                       tField('always_update_dns'),
                       tField('auto_create_reversezone'),
                       tField('cidr'),
                       tField('comment'),
                       tField('ddns_domainname'),
                       tField('ddns_ttl'),
                       tField('domain_name'),
                       tField('domain_name_servers', { sub_fields => [ tField('address')]}),
                       tField('dhcp_members',
                              {
                               sub_fields => [
                                              tField('grid_member', return_fields_member_basic_data()),
                                             ]
                              }),

                       tField('disabled'),
                       tField('discovery_engine_type'),
                       tField('discovered_bridge_domain'),
                       tField('discovered_tenant'),
                       tField('enable_ddns'),
                       tField('enable_ifmap_publishing'),
                       tField('enable_option81'),
                       return_fields_extensible_attributes(),
                       tField('generate_hostname'),
                       tField('lease_time'),
                       tField('options'),
                       tField('parent_name'),
                       tField('preferred_lifetime'),
                       tField('recycle_leases'),
                       tField('rir'),
                       tField('rir_registration_status'),
                       tField('last_rir_registration_update_sent'),
                       tField('last_rir_registration_update_status'),
                       tField('shared_network_name'),
                       tField('update_dns_on_lease_renewal'),
                       tField('use_ddns_domainname'),
                       tField('use_ddns_ttl'),
                       tField('use_domain_name'),
                       tField('use_domain_name_servers'),
                       tField('use_enable_ddns'),
                       tField('use_enable_ifmap_publishing'),
                       tField('use_enable_option81'),
                       tField('use_generate_hostname'),
                       tField('use_lease_time'),
                       tField('use_options'),
                       tField('use_preferred_lifetime'),
                       tField('use_recycle_leases'),
                       tField('use_update_dns_on_lease_renewal'),
                       tField('enable_discovery'),
                       tField('use_member_enable_discovery'),
                       tField('use_basic_polling_settings'),
                       tField('discovery_member', {'sub_fields' => [tField('host_name')]}),
                       tField('discovery_exclusion_range', {'depth' => 1}),
                       tField('use_blackout_setting'),
                       tField('same_port_control_discovery_blackout'),
                       tField('use_subscribe_settings'),
                       tField('unmanaged'),
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
        push @_return_fields,
          tField('network_view', {
                                  default_no_access_ok => 1,
                                  sub_fields => $tmp->__return_fields__(),
                                 }
                );

        $tmp = Infoblox::DNS::Zone->__new__();
        $_lazy_return_fields{'zone_associations'}=[
                                                   tField('zone_associations',
                                                          {
                                                           sub_fields =>
                                                           [
                                                            tField('is_default'),
                                                            tField('zone',
                                                                   {
                                                                    default_no_access_ok => 1,
                                                                    sub_fields => $tmp->__return_fields__()
                                                                   }
                                                                  )
                                                           ]
                                                          }
                                                         ),
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

    #
    $self->auto_create_reversezone('false') unless defined $self->auto_create_reversezone();
    $self->{'preferred_lifetime'} = 27000 unless defined $self->preferred_lifetime();
    $self->{'valid_lifetime'} = 43200 unless defined $self->valid_lifetime();
    $self->{'override_enable_ifmap_publishing'} = 'false' unless defined $self->override_enable_ifmap_publishing();
}

sub __ibap_object_type__
{
    return $_object_type;
}

sub __ibap_capabilities__
{
	my ($self,$what)=@_;
	return $_capabilities{$what};
}

#
#
#

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
        'apply_template_for_fixed_addresses_only',
        'apply_template_for_ranges_only',
        'auto_create_reversezone',
        'always_update_dns',
        'disabled',
        'enable_ddns',
        'enable_ifmap_publishing',
        'enable_option81',
        'generate_hostname',
        'recycle_leases',
        'update_dns_on_lease_renewal',
        'update_static_leases',
        'use_ddns_domainname',
        'use_ddns_ttl',
        'use_enable_option81',
        'use_domain_name',
        'use_domain_name_servers',
        'use_enable_ddns',
        'use_enable_ifmap_publishing',
        'use_generate_hostname',
        'use_lease_time',
        'use_options',
        'use_preferred_lifetime',
        'use_recycle_leases',
        'use_update_dns_on_lease_renewal',
        'use_update_static_leases',
        'enable_discovery',
        'use_member_enable_discovery',
        'use_basic_polling_settings',
        'use_blackout_setting',
        'same_port_control_discovery_blackout',
        'unmanaged',
        'use_subscribe_settings',
        #
        #
        #
        #
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    $self->{ '__internal_session_cache_ref__' } = \$session;

    #
    my $address = $$ibap_object_ref{'address'} ? $$ibap_object_ref{'address'} : '';
    my $netmask = $$ibap_object_ref{'cidr'} ? $$ibap_object_ref{'cidr'} : '';

    $self->network($address . '/' . $netmask);
    $self->network_container('/');

    $self->{endpoint_sources} = [];

    #
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref, {'address' => 1, 'cidr' => 1, });

    #
    $self->{'override_ddns_ttl'}                      = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_ttl'});
    $self->{'override_options'}                       = ibap_value_i2o_boolean($$ibap_object_ref{'use_options'});
    $self->{'override_preferred_lifetime'}            = ibap_value_i2o_boolean($$ibap_object_ref{'use_preferred_lifetime'});
    $self->{'override_enable_ddns'}                   = ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_ddns'});
    $self->{'override_enable_ifmap_publishing'}       = ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_ifmap_publishing'});
    $self->{'override_ddns_domainname'}               = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_domainname'});
    $self->{'override_ddns_generate_hostname'}        = ibap_value_i2o_boolean($$ibap_object_ref{'use_generate_hostname'});
    $self->{'override_ddns_enable_option_fqdn'}       = ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_option81'});
    $self->{'override_domain_name'}                   = ibap_value_i2o_boolean($$ibap_object_ref{'use_domain_name'});
    $self->{'override_domain_name_servers'}           = ibap_value_i2o_boolean($$ibap_object_ref{'use_domain_name_servers'});
    $self->{'override_update_dns_on_lease_renewal'}   = ibap_value_i2o_boolean($$ibap_object_ref{'use_update_dns_on_lease_renewal'});
    $self->{'override_valid_lifetime'}                = ibap_value_i2o_boolean($$ibap_object_ref{'use_lease_time'});
    $self->{'override_enable_discovery'}              = ibap_value_i2o_boolean($$ibap_object_ref{'use_member_enable_discovery'});
    $self->{'override_discovery_basic_poll_settings'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_basic_polling_settings'});
    $self->{'override_blackout_setting'}              = ibap_value_i2o_boolean($$ibap_object_ref{'use_blackout_setting'});
    $self->{'override_subscribe_settings'}            = ibap_value_i2o_boolean($$ibap_object_ref{'use_subscribe_settings'});
    #
    #

    $self->{'members'} = [] unless defined $self->{'members'};

    return;
}

#
#
#

sub __o2i_template__
{
	my ($self, $session, $current, $tempref) = @_;

	if (not defined $$tempref{$current}) {
		return (1,1,undef);
	} else {
        return (1,0,ibap_readfield_simple_string('IPv6NetworkTemplate','name',$$tempref{$current}, $current));
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

#
#
#

sub next_available_ip
{
    my $self  = shift;

    unless ($self->{ '__internal_session_cache_ref__' } && $self->__object_id__()) {
        set_error_codes(1001,'In order to get the next available ip the object must have been retrieved from the server first');
        return;
    }

    my $session = ${$self->{ '__internal_session_cache_ref__' }};
    return $session->__next_available_ip__($self->__object_id__(),@_);
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


1;
