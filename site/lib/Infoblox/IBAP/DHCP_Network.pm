package Infoblox::DHCP::Network;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA %_allowed_members @_return_fields @_optional_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object $_return_fields_initialized %_return_field_overrides %_capabilities %_lazy_return_fields);
@ISA = qw ( Infoblox::IBAPBase );

BEGIN {
    register_wsdl_type('ib:Network','Infoblox::DHCP::Network');

	#

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members = (
                         authority                       => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_is_authoritative'},
                         auto_create_reversezone         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         bootfile                        => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'use_boot_file'},
                         bootserver                      => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'use_boot_server'},
                         comment                         => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         ddns_domainname                 => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_ddns_domainname', use_truefalse => 1},
                         ddns_generate_hostname          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_generate_hostname'},
                         ddns_server_always_updates      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         ddns_ttl                        => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_ddns_ttl', use_truefalse => 1},
                         ddns_update_fixed_addresses     => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_update_static_leases'},
                         ddns_use_option81               => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_enable_option81'},
                         deny_bootp                      => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_deny_bootp'},
                         disable                         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         email_list                      => {array => 1, validator => { 'string' => \&ibap_value_o2i_string }, use => 'use_threshold_email_addresses'},
                         enable_ddns                     => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_enable_ddns'},
                         enable_ifmap_publishing         => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_enable_ifmap_publishing', use_truefalse => 1},
                         enable_dhcp_thresholds          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_enable_thresholds'},
                         enable_email_warnings           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         enable_snmp_warnings            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         high_water_mark                 => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         high_water_mark_reset           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         ignore_dhcp_option_list_request => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_ignore_client_requested_options'},
                         ipv4addr                        => {simple => 'asis', validator => \&ibap_value_o2i_ipv4addr},
                         lease_scavenge_time             => 0,
                         override_lease_scavenge_time    => 0,
                         low_water_mark                  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         low_water_mark_reset            => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         members                         => {array => 1, validator => { 'Infoblox::DHCP::Member' => 1, 'Infoblox::DHCP::MSServer' => 1, 'Infoblox::Grid::Member' => 1 }, nomixed => 1},
                         netmask                         => 0,
                         network                         => 0,
                         network_container               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         nextserver                      => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'use_next_server'},
                         options                         => 0,
                         pxe_lease_time                  => 0,
                         recycle_leases                  => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'use_recycle_leases'},
                         rir                             => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         rir_organization                => {validator => {'Infoblox::Grid::RIR::Organization' => 1}},
                         rir_registration_action         => {simple => 'asis', enum => ['NONE', 'CREATE', 'MODIFY', 'DELETE']}, # write-only
                         rir_registration_status         => {simple => 'asis', enum => ['NOT_REGISTERED', 'REGISTERED']},
                         last_rir_registration_update_sent   => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         last_rir_registration_update_status => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         send_rir_request                => {simple => 'bool', validator => \&ibap_value_o2i_boolean}, # write-only
                         delete_reason                   => {simple => 'asis', validator => \&ibap_value_o2i_string}, # write-only
                         template                        => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         network_view                    => {validator => { 'Infoblox::DHCP::View' => 1 }},
                         extattrs                        => {special => 'extensible_attributes'},
                         extensible_attributes           => {special => 'extensible_attributes'},
                         override_ddns_domainname        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_ddns_ttl               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_enable_ifmap_publishing     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         update_dns_on_lease_renewal     => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_update_dns_on_lease_renewal', use_truefalse => 1},
                         override_update_dns_on_lease_renewal => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         zone_associations               => 0,
                         ignore_client_identifier               => 0, # replaced by ignore_id
                         override_ignore_client_identifier      => 0, # replaced by override_ignore_id
                         ignore_id                              => {simple => 'asis', enum => ['NONE', 'CLIENT', 'MACADDR'], use => 'override_ignore_id', use_truefalse => 1},
                         ignore_mac_addresses                   => {array => 1, validator => \&ibap_value_o2i_string, use => 'override_ignore_id', use_truefalse => 1},
                         override_ignore_id                     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
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
                         ipam_trap_settings               => {'validator' => {'Infoblox::Grid::SNMP::IPAMTrap' => 1}, use => 'override_ipam_trap_settings', use_truefalse => 1},
                         override_ipam_trap_settings      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         ipam_threshold_settings               => {'validator' => {'Infoblox::Grid::SNMP::IPAMThreshold' => 1}, use => 'override_ipam_threshold_settings', use_truefalse => 1},
                         override_ipam_threshold_settings      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         ipam_email_addresses                   => {array => 1, validator => \&ibap_value_o2i_string, use => 'override_ipam_email_addresses', use_truefalse => 1},
                         override_ipam_email_addresses          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         ms_ad_user_data                        => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},

                         logic_filters                     => {array => 1, validator => {string => 1, 'Infoblox::DHCP::Filter::MAC' => 1,
                                                               'Infoblox::DHCP::Filter::NAC' => 1, 'Infoblox::DHCP::Filter::Option' => 1},
                                                               use => 'override_logic_filters', use_truefalse => 1},
                         override_logic_filters            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         discovery_engine_type             => {simple => 'asis', readonly => 1},
                         discovered_bridge_domain          => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         discovered_tenant                 => {simple => 'asis', validator => \&ibap_value_o2i_string},

                         #
                         cloud_info                             => {validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
                         restart_if_needed                      => {simple => 'bool', validator => \&ibap_value_o2i_boolean, writeonly => 1},
                         unmanaged                              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
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

    %_searchable_fields = (
						   mac    	=> [\&ibap_o2i_string       ,'mac_address' , 'REGEX'],
						   comment => [\&ibap_o2i_string       ,'comment'     , 'REGEX', 'IGNORE_CASE'],
						   contains_address => [\&ibap_o2i_string, 'contains_address', 'EXACT'],
						   ipv4addr => [\&ibap_o2i_string       ,'address'     , 'REGEX'],
						   member      => [\&__o2i_member_search__ ,'__DYNAMIC__'        , 'EXACT'],
						   network  => [\&ibap_o2i_network_string ,'address'     , 'REGEX'],
						   network_container  => [\&ibap_o2i_network_container_search ,'parent'     , 'LIST_CONTAIN'],
                           network_view => [\&ibap_o2i_network_view ,'network_view', 'EXACT'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes    => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           unmanaged                => [\&ibap_o2i_boolean, 'unmanaged', 'EXACT'],
                           discovery_engine_type    => [\&ibap_o2i_string, 'discovery_engine_type', 'EXACT'],
                           discovered_bridge_domain => [\&ibap_o2i_string, 'discovered_bridge_domain', 'REGEX', 'IGNORE_CASE'],
                           discovered_tenant        => [\&ibap_o2i_string, 'discovered_tenant', 'REGEX', 'IGNORE_CASE'],
						  );

    %_name_mappings = (
					   'authority' 					 => 'is_authoritative',
					   'ddns_generate_hostname' 	 => 'generate_hostname',
					   'ddns_server_always_updates'  => 'always_update_dns',
					   'ddns_update_fixed_addresses' => 'update_static_leases',
					   'ddns_use_option81' 			 => 'enable_option81',
					   'disable' 					 => 'disabled',
					   'email_list'                  => 'threshold_email_addresses',
					   'enable_dhcp_thresholds' 	 => 'enable_thresholds',
					   'enable_email_warnings' 		 => 'enable_threshold_email_warnings',
					   'enable_snmp_warnings' 		 => 'enable_threshold_snmp_warnings',
					   'high_water_mark' 			 => 'range_high_water_mark',
                       'high_water_mark_reset'        => 'range_high_water_mark_reset',
					   'ipv4addr' 					 => 'address',
					   'low_water_mark' 			 => 'range_low_water_mark',
                       'low_water_mark_reset'         => 'range_low_water_mark_reset',
                       'lease_scavenge_time'         => 'client_association_grace_period',
                       'override_lease_scavenge_time' => 'use_client_association_grace_period',
					   'members' 					 => 'dhcp_members',
					   'netmask' 					 => 'cidr',
					   'network' 					 => 'address',
                       'override_update_dns_on_lease_renewal' => 'use_update_dns_on_lease_renewal',
                       'override_ddns_ttl'            => 'use_ddns_ttl',
                       'override_ddns_domainname'     => 'use_ddns_domainname',
                       'override_enable_ifmap_publishing'     => 'use_enable_ifmap_publishing',
                       'override_ignore_id' => 'use_ignore_id',
                       'extattrs'                     => 'extensible_attributes',
                       'discovery_basic_poll_settings'          => 'basic_polling_settings',
                       'override_discovery_basic_poll_settings' => 'use_basic_polling_settings',
                       'override_enable_discovery'              => 'use_member_enable_discovery',
                       'override_blackout_setting'              => 'use_blackout_setting',
                       'override_ipam_trap_settings'            => 'use_ipam_trap_settings',
                       'override_ipam_threshold_settings'       => 'use_ipam_threshold_settings',
                       'override_ipam_email_addresses'          => 'use_ipam_email_addresses',
                       'logic_filters'          => 'option_logic_filters',
                       'override_logic_filters' => 'use_option_logic_filters',
                       'override_subscribe_settings' => 'use_subscribe_settings',
                       'override_mgm_private' => 'use_mgm_private',
				   );

	#

    %_reverse_name_mappings = (
							   'is_authoritative'                => 'authority',
							   'generate_hostname'               => 'ddns_generate_hostname',
							   'always_update_dns'               => 'ddns_server_always_updates',
							   'update_static_leases'            => 'ddns_update_fixed_addresses',
							   'enable_option81'                 => 'ddns_use_option81',
							   'disabled'                        => 'disable',
							   'threshold_email_addresses'       => 'email_list',
							   'enable_thresholds'               => 'enable_dhcp_thresholds',
							   'enable_threshold_email_warnings' => 'enable_email_warnings',
							   'enable_threshold_snmp_warnings'  => 'enable_snmp_warnings',
							   'range_high_water_mark'           => 'high_water_mark',
							   'range_high_water_mark_reset'     => 'high_water_mark_reset',
							   'range_low_water_mark'            => 'low_water_mark',
							   'range_low_water_mark_reset'      => 'low_water_mark_reset',
                               'client_association_grace_period' => 'lease_scavenge_time',
                               'use_client_association_grace_period' => 'override_lease_scavenge_time',
							   'dhcp_members'                    => 'members',
							   'ms_dhcp_servers'                 => 'members',
							   'address'                         => 'network',
							   'parent_name'                     => 'network_container',
                               'use_update_dns_on_lease_renewal' => 'override_update_dns_on_lease_renewal',
                               'use_ddns_ttl'                    => 'override_ddns_ttl',
                               'use_ddns_domainname'             => 'override_ddns_domainname',
                               'use_enable_ifmap_publishing'     => 'override_enable_ifmap_publishing',
                               'use_ignore_id'    => 'override_ignore_id',
                               'extensible_attributes'           => 'extattrs',
                               'basic_polling_settings'          => 'discovery_basic_poll_settings',
                               'use_basic_polling_settings'      => 'override_discovery_basic_poll_settings',
                               'use_member_enable_discovery'     => 'override_enable_discovery',
                               'use_blackout_setting'            => 'override_blackout_setting',
                               'use_ipam_trap_settings'          => 'override_ipam_trap_settings',
                               'use_ipam_threshold_settings'     => 'override_ipam_threshold_settings',
                               'use_ipam_email_addresses'        => 'override_ipam_email_addresses',
                               'option_logic_filters'     => 'logic_filters',
                               'use_option_logic_filters' => 'override_logic_filters',
                               'use_subscribe_settings' => 'override_subscribe_settings',
                               'use_mgm_private' => 'override_mgm_private',
						   );

    %_ibap_to_object = (
						'always_update_dns' 			  => \&ibap_i2o_boolean,
						'auto_create_reversezone' 		  => \&ibap_i2o_boolean,
						'dhcp_members' 				      => \&ibap_i2o_mixed_members_list,
						'ms_dhcp_servers' 			      => \&ibap_i2o_mixed_members_list,
						'disabled' 					   	  => \&ibap_i2o_boolean,
						'enable_ddns' 					  => \&ibap_i2o_boolean,
                        'enable_ifmap_publishing'         => \&ibap_i2o_boolean,
						'enable_option81' 				  => \&ibap_i2o_boolean,
						'enable_threshold_email_warnings' => \&ibap_i2o_boolean,
						'enable_threshold_snmp_warnings'  => \&ibap_i2o_boolean,
						'enable_thresholds' 			  => \&ibap_i2o_boolean,
						'generate_hostname' 			  => \&ibap_i2o_boolean,
						'is_authoritative' 			   	  => \&ibap_i2o_boolean,
						'network_view' 			   	      => \&ibap_i2o_generic_object_convert,
						'recycle_leases' 				  => \&ibap_i2o_boolean,
                        'rir_organization'                => \&ibap_i2o_generic_object_convert,
						'threshold_email_addresses'       => \&ibap_i2o_email_list,
						'update_static_leases' 		   	  => \&ibap_i2o_boolean,
                        'extensible_attributes'           => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'update_dns_on_lease_renewal'     => \&ibap_i2o_boolean,
                        'use_update_dns_on_lease_renewal' => \&ibap_i2o_boolean,
                        'use_ddns_ttl'                    => \&ibap_i2o_boolean,
                        'use_ddns_domainname'             => \&ibap_i2o_boolean,
                        'use_enable_ifmap_publishing'     => \&ibap_i2o_boolean,
                        'use_client_association_grace_period' => \&ibap_i2o_boolean,
                        'ignore_id'                       => \&ibap_i2o_enums_uc_or_undef,
                        'ignore_mac_addresses'            => \&ibap_i2o_mac_addresses,
                        'use_ignore_id'                   => \&ibap_i2o_boolean,
                        'enable_discovery'                => \&ibap_i2o_boolean,
                        'use_member_enable_discovery'     => \&ibap_i2o_boolean,
                        'basic_polling_settings'          => \&ibap_i2o_generic_object_convert,
                        'use_basic_polling_settings'      => \&ibap_i2o_boolean,
                        'discovery_member'                => \&ibap_i2o_member_byhostname,
                        'discovery_exclusion_range'       => \&ibap_i2o_exclusion,
                        'discovery_blackout_setting'      => \&ibap_i2o_generic_object_convert,
                        'port_control_blackout_setting'   => \&ibap_i2o_generic_object_convert,
                        'ipam_trap_settings'              => \&ibap_i2o_generic_object_convert,
                        'ipam_threshold_settings'         => \&ibap_i2o_generic_object_convert,
                        'ipam_email_addresses'            => \&ibap_i2o_email_list,
                        'ms_ad_user_data'                 => \&ibap_i2o_generic_object_convert,
                        'cloud_info'                      => \&ibap_i2o_generic_object_convert,
                        'unmanaged'                       => \&ibap_i2o_boolean,
                        'option_logic_filters'     => \&ibap_i2o_ordered_filters,
                        'use_option_logic_filters' => \&ibap_i2o_boolean,
                        'subscribe_settings' => \&ibap_i2o_generic_object_convert,
                        'endpoint_sources' => \&ibap_i2o_generic_object_list_convert,
					);

	%_return_field_overrides = (
								'authority'					   	  	  => ['use_is_authoritative'],
								'auto_create_reversezone'	   	  	  => [],
								'bootfile'						  	  => ['!bootp_properties'],
								'bootserver'					      => ['!bootp_properties'],
								'comment'					   	  	  => [],
								'ddns_domainname'                     => ['use_ddns_domainname'],
								'ddns_generate_hostname'		  	  => ['use_generate_hostname'],
								'ddns_server_always_updates'	  	  => [],
								'ddns_ttl'					   	  	  => ['use_ddns_ttl'],
								'ddns_update_fixed_addresses'     	  => ['use_update_static_leases'],
								'ddns_use_option81'			   	  	  => ['use_enable_option81'],
								'deny_bootp'					  	  => ['!bootp_properties'],
								'disable'					   	  	  => [],
								'email_list'					  	  => ['use_threshold_email_addresses'],
								'enable_ddns'				   	  	  => ['use_enable_ddns'],
                                'enable_ifmap_publishing'             => ['use_enable_ifmap_publishing'],
								'enable_dhcp_thresholds'		  	  => ['use_enable_thresholds'],
								'enable_email_warnings'		   	  	  => [],
								'enable_snmp_warnings'		   	  	  => [],
                                'extattrs'                            => [],
								'extensible_attributes'               => [],
								'high_water_mark'			   	  	  => [],
                                'high_water_mark_reset'               => [],
								'ignore_dhcp_option_list_request' 	  => ['!common_properties'],
								'ipv4addr'					   	  	  => [],
                                'lease_scavenge_time'                 => ['use_client_association_grace_period'],
								'low_water_mark'				  	  => [],
                                'low_water_mark_reset'                => [],
								'members'					   	  	  => ['ms_dhcp_servers'],
								'netmask'					   	  	  => [],
								'network'					   	  	  => ['netmask'],
								'network_container'			   	  	  => ['!parent_name'],
								'network_view'                    	  => [],
								'nextserver'					      => ['!bootp_properties'],
								'options'					   	  	  => ['!common_properties'],
								'pxe_lease_time'			   	  	  => ['!common_properties'],
								'recycle_leases'				  	  => ['use_recycle_leases'],
                                'rir'                                 => [],
                                'rir_organization'                    => [],
                                'rir_registration_status'             => [],
                                'last_rir_registration_update_sent'   => [],
                                'last_rir_registration_update_status' => [],
								'template'					   	  	  => [],
                                'zone_associations'                   => ['use_zone_associations'],
                                'update_dns_on_lease_renewal'         => ['use_update_dns_on_lease_renewal'],
                                'override_lease_scavenge_time'        => [],
                                'override_update_dns_on_lease_renewal' => [],
                                'override_ddns_ttl'                    => [],
                                'override_ddns_domainname'             => [],
                                'override_enable_ifmap_publishing'     => [],
                                'ignore_id'                            => ['use_ignore_id'],
                                'ignore_mac_addresses'                 => ['use_ignore_id'],
                                'override_ignore_id'                   => [],
                                'ignore_client_identifier'             => ['ignore_id','use_ignore_id'],
                                'override_ignore_client_identifier'    => ['use_ignore_id'],
                                'enable_discovery'                     => ['discovery_member','use_member_enable_discovery'],
                                'override_enable_discovery'            => [],
                                'discovery_member'                     => ['enable_discovery','use_member_enable_discovery'],
                                'discovery_exclusion_range'            => [],
                                'discovery_basic_poll_settings'        => ['use_basic_polling_settings'],
                                'override_discovery_basic_poll_settings' => [],
                                'discover_now_status'                    => [],
                                'discovery_blackout_setting'             => ['port_control_blackout_setting', 'use_blackout_setting'],
                                'port_control_blackout_setting'          => ['discovery_blackout_setting', 'use_blackout_setting'],
                                'same_port_control_discovery_blackout'   => [],
                                'override_blackout_setting'              => [],
                                'ipam_trap_settings'                   => ['use_ipam_trap_settings'],
                                'override_ipam_trap_settings'          => [],
                                'ipam_threshold_settings'              => ['use_ipam_threshold_settings'],
                                'override_ipam_threshold_settings'     => [],
                                'ipam_email_addresses'                 => ['use_ipam_email_addresses'],
                                'override_ipam_email_addresses'        => [],
                                'ms_ad_user_data'                      => [],
                                'logic_filters'                     => ['use_option_logic_filters'],
                                'override_logic_filters'            => [],

                                'cloud_info'                           => [],
                                'unmanaged'                            => [],
                                'subscribe_settings'          => ['use_subscribe_settings'],
                                'override_subscribe_settings' => [],
                                'endpoint_sources'            => [],
                                'discovery_engine_type'       => [],
                                'discovered_bridge_domain'    => [],
                                'discovered_tenant'           => [],
                                #
                                #
                                #
                                #
							   );

    %_object_to_ibap = (
						'authority'					   	  => \&ibap_o2i_boolean,
						'auto_create_reversezone'	   	  => \&ibap_o2i_boolean,
						'bootfile'						  => \&ibap_o2i_ignore,
						'bootserver'					  => \&ibap_o2i_ignore,
						'comment'					   	  => \&ibap_o2i_string,
						'deny_bootp'					  => \&ibap_o2i_ignore,
	                    'ddns_domainname'                 => \&ibap_o2i_string,
						'ddns_generate_hostname'		  => \&ibap_o2i_boolean,
						'ddns_server_always_updates'	  => \&ibap_o2i_boolean,
						'ddns_ttl'					   	  => \&ibap_o2i_uint,
						'ddns_update_fixed_addresses'     => \&ibap_o2i_boolean,
						'ddns_use_option81'			   	  => \&ibap_o2i_boolean,
						'disable'					   	  => \&ibap_o2i_boolean,
						'email_list'					  => \&ibap_o2i_email_list,
						'enable_ddns'				   	  => \&ibap_o2i_boolean,
                        'enable_ifmap_publishing'         => \&ibap_o2i_boolean,
						'enable_dhcp_thresholds'		  => \&ibap_o2i_boolean,
						'enable_email_warnings'		   	  => \&ibap_o2i_boolean,
						'enable_snmp_warnings'		   	  => \&ibap_o2i_boolean,
						'high_water_mark'			   	  => \&ibap_o2i_uint,
                        'high_water_mark_reset'           => \&ibap_o2i_uint,
						'ignore_dhcp_option_list_request' => \&ibap_o2i_ignore,
						'ipv4addr'					   	  => \&ibap_o2i_string,
                        'lease_scavenge_time'             => \&ibap_o2i_integer,
						'low_water_mark'				  => \&ibap_o2i_uint,
                        'low_water_mark_reset'            => \&ibap_o2i_uint,
						'members'          		          => \&ibap_o2i_mixed_members_list,
						'nextserver'					  => \&ibap_o2i_ignore,
						'netmask'					   	  => \&ibap_o2i_ignore,
						'network'					   	  => \&ibap_o2i_network_string,
						'network_container'			   	  => \&ibap_o2i_ignore,
                        'network_view'                    => \&ibap_o2i_network_view,
						'nextserver'					  => \&ibap_o2i_ignore,
						'options'					   	  => \&ibap_o2i_ignore,
						'pxe_lease_time'				  => \&ibap_o2i_ignore,
						'recycle_leases'				  => \&ibap_o2i_boolean,
                        'rir'                             => \&ibap_o2i_ignore,
                        'rir_organization'                => \&ibap_o2i_rir_organization,
                        'rir_registration_action'         => \&ibap_o2i_string,
                        'rir_registration_status'         => \&ibap_o2i_string,
                        'last_rir_registration_update_sent'   => \&ibap_o2i_ignore,
                        'last_rir_registration_update_status' => \&ibap_o2i_ignore,
                        'send_rir_request'                => \&ibap_o2i_boolean,
                        'delete_reason'                   => \&ibap_o2i_string,
						'template'					   	  => \&__o2i_template__,
                        'update_dns_on_lease_renewal'     => \&ibap_o2i_boolean,
                        'zone_associations'               => \&ibap_o2i_zone_associations,
                        'ignore_id'                       => \&ibap_o2i_string,
                        'ignore_mac_addresses'            => \&ibap_o2i_mac_addresses,
                        'enable_discovery'                => \&ibap_o2i_boolean,
                        'discovery_member'                => \&ibap_o2i_member_byhostname,
                        'discovery_basic_poll_settings'   => \&ibap_o2i_generic_struct_convert,
                        'enable_immediate_discovery'      => \&ibap_o2i_boolean,
                        'discovery_exclusion_range'       => \&ibap_o2i_exclusion,
                        'discover_now_status'             => \&ibap_o2i_ignore,
                        'discovery_blackout_setting'      => \&ibap_o2i_generic_struct_convert,
                        'port_control_blackout_setting'   => \&ibap_o2i_generic_struct_convert,
                        'same_port_control_discovery_blackout' => \&ibap_o2i_boolean,
                        'ipam_trap_settings'              => \&ibap_o2i_generic_struct_convert,
                        'ipam_threshold_settings'         => \&ibap_o2i_generic_struct_convert,
                        'ipam_email_addresses'            => \&ibap_o2i_email_list,
                        'ms_ad_user_data'                 => \&ibap_o2i_ignore,

                        'override_logic_filters'        => \&ibap_o2i_boolean,
                        'logic_filters'                 => \&ibap_o2i_ordered_filters,

                        'cloud_info'                      => \&ibap_o2i_generic_struct_convert,
                        'restart_if_needed'               => \&ibap_o2i_boolean,
                        'unmanaged'                       => \&ibap_o2i_boolean,

                        'subscribe_settings'          => \&ibap_o2i_generic_struct_convert,
                        'endpoint_sources'            => \&ibap_o2i_ignore,
                        'override_subscribe_settings' => \&ibap_o2i_boolean,
                        'discovery_engine_type'       => \&ibap_o2i_ignore,
                        'discovered_bridge_domain'    => \&ibap_o2i_string,
                        'discovered_tenant'           => \&ibap_o2i_string,

						#

						'use_enable_ddns' 			   	=> \&ibap_o2i_boolean,
						'use_enable_option81' 		   	=> \&ibap_o2i_boolean,
						'use_enable_thresholds' 		=> \&ibap_o2i_boolean,
						'use_generate_hostname' 		=> \&ibap_o2i_boolean,
						'use_is_authoritative' 		   	=> \&ibap_o2i_boolean,
						'use_recycle_leases'			=> \&ibap_o2i_boolean,
						'use_threshold_email_addresses' => \&ibap_o2i_boolean,
						'use_update_static_leases' 	   	=> \&ibap_o2i_boolean,
                        'use_zone_associations'         => \&ibap_o2i_boolean,
                        'override_update_dns_on_lease_renewal' => \&ibap_o2i_boolean,
                        'override_ddns_ttl'                    => \&ibap_o2i_boolean,
                        'override_ddns_domainname'             => \&ibap_o2i_boolean,
                        'override_enable_ifmap_publishing' => \&ibap_o2i_boolean,
                        'override_lease_scavenge_time'    => \&ibap_o2i_boolean,
                        'override_ignore_id'                     => \&ibap_o2i_boolean,
                        'override_enable_discovery'              => \&ibap_o2i_boolean,
                        'override_discovery_basic_poll_settings' => \&ibap_o2i_boolean,
                        'override_blackout_setting'              => \&ibap_o2i_boolean,
                        'override_ipam_trap_settings'            => \&ibap_o2i_boolean,
                        'override_ipam_threshold_settings'       => \&ibap_o2i_boolean,
                        'override_ipam_email_addresses'          => \&ibap_o2i_boolean,
                        'mgm_private' => \&ibap_o2i_boolean,
                        'override_mgm_private' => \&ibap_o2i_boolean,
                        'mgm_private_overridable' => \&ibap_o2i_ignore,

						#
						#
						#
						#

						'use_boot_file' 	   				  => \&ibap_o2i_ignore,
						'use_boot_server' 	   				  => \&ibap_o2i_ignore,
						'use_next_server' 	   				  => \&ibap_o2i_ignore,
						'use_broadcast_address' 	   		  => \&ibap_o2i_ignore,
						'use_deny_bootp' 	   				  => \&ibap_o2i_ignore,
						'use_domain_name' 	   				  => \&ibap_o2i_ignore,
						'use_domain_name_servers' 	   		  => \&ibap_o2i_ignore,
						'use_ignore_client_requested_options' => \&ibap_o2i_ignore,
						'use_lease_time' 	   				  => \&ibap_o2i_ignore,
						'use_options' 	   					  => \&ibap_o2i_ignore,
						'use_pxe_lease_time' 	   			  => \&ibap_o2i_ignore,
						'use_routers' 	   					  => \&ibap_o2i_ignore,
                        'extattrs'                            => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'               => \&ibap_o2i_ignore,
					   );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('address'),
                       tField('always_update_dns'),
                       tField('auto_create_reversezone'),
                       tField('comment'),
                       tField('client_association_grace_period'),
                       tField('ddns_domainname'),
                       tField('ddns_ttl'),
                       tField('disabled'),
                       tField('discovery_engine_type'),
                       tField('discovered_bridge_domain'),
                       tField('discovered_tenant'),
                       tField('enable_ddns'),
                       tField('enable_ifmap_publishing'),
                       tField('enable_option81'),
                       tField('enable_threshold_email_warnings'),
                       tField('enable_threshold_snmp_warnings'),
                       tField('enable_thresholds'),
                       tField('generate_hostname'),
                       tField('is_authoritative'),
                       tField('ignore_id'),
                       tField('ignore_mac_addresses',{ sub_fields => [ tField('mac_addr')]}),
                       tField('cidr'),
                       tField('range_high_water_mark'),
                       tField('range_high_water_mark_reset'),
                       tField('range_low_water_mark'),
                       tField('range_low_water_mark_reset'),
                       tField('recycle_leases'),
                       tField('rir'),
                       tField('rir_registration_status'),
                       tField('last_rir_registration_update_sent'),
                       tField('last_rir_registration_update_status'),
                       tField('update_static_leases'),
                       tField('update_dns_on_lease_renewal'),
                       tField('use_client_association_grace_period'),
                       tField('use_enable_ddns'),
                       tField('use_enable_ifmap_publishing'),
                       tField('use_enable_option81'),
                       tField('use_enable_thresholds'),
                       tField('use_generate_hostname'),
                       tField('use_is_authoritative'),
                       tField('use_threshold_email_addresses'),
                       tField('use_update_static_leases'),
                       tField('use_recycle_leases'),
                       tField('use_update_dns_on_lease_renewal'),
                       tField('use_ddns_ttl'),
                       tField('use_ddns_domainname'),
                       tField('use_ignore_id'),
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
                       tField('use_option_logic_filters'),
                       tField('option_logic_filters', return_fields_option_logic_filters()),
                       tField('use_subscribe_settings'),
                       #
                       #
                       #
                       #
                       );

    @_optional_return_fields = (
                                tField('discover_now_status'),
                               );


    #
    #

    push @_return_fields,
    (
     tField('parent_name'),
     tField('threshold_email_addresses',
        { sub_fields => [ tField('email_address') ]}),
     tField('dhcp_members',
            {
             sub_fields => [
                            tField('grid_member', return_fields_member_basic_data()),
                           ]
            }),
     tField('common_properties', { depth => 2 }),
     tField('bootp_properties', { depth => 1 }),
     );

    push @_return_fields, tField('ms_dhcp_servers', { sub_fields => [tField('ms_server',
                                                                            { sub_fields => [tField('address'),
                                                                                             tField('server_name')]})]});
    push @_return_fields, return_fields_extensible_attributes();
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
                                                                                        sub_fields => $t->__return_fields__()
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
                   'ipam_threshold_settings'       => 'Infoblox::Grid::SNMP::IPAMThreshold',
                   'ipam_trap_settings'            => 'Infoblox::Grid::SNMP::IPAMTrap',
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

	$self->{__object_id_cache__} = {};
    $self->{'override_enable_ifmap_publishing'} = 'false' unless defined $self->override_enable_ifmap_publishing();
}

sub __ibap_object_type__
{
	my ($self, $function, $session, $args_ref) = @_;


	if ($function eq 'remove') {
		#
		#
		#
		#
		${$args_ref}{'network_view'} = 'is_default:=:=:boolean:=:=:1' unless $$args_ref{'network_view'};
		return 'AllNetwork';
	}
	else {
		return 'Network';
	}
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

	$self->{ '__internal_session_cache_ref__' } = \$session;

	#
    foreach (
        'use_enable_ifmap_publishing',
        'use_client_association_grace_period',
        'use_recycle_leases',
        'use_enable_ddns',
        'use_enable_option81',
        'use_generate_hostname',
        'use_is_authoritative',
        'use_threshold_email_addresses',
        'use_update_static_leases',
        'use_update_dns_on_lease_renewal',
        'update_dns_on_lease_renewal',
        'use_ddns_ttl',
        'use_ddns_domainname',
        'use_ignore_id',
        'enable_discovery',
        'use_member_enable_discovery',
        'use_basic_polling_settings',
        'use_blackout_setting',
        'same_port_control_discovery_blackout',
        'use_ipam_trap_settings',
        'use_ipam_threshold_settings',
        'use_ipam_email_addresses',
        'unmanaged',
        'use_option_logic_filters',
        'use_subscribe_settings',
        #
        #
        #
        #
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

	if (defined $$ibap_object_ref{'common_properties'}) {
		$$ibap_object_ref{'common_properties'}{'use_ignore_client_requested_options'} = 0 unless defined $$ibap_object_ref{'common_properties'}{'use_ignore_client_requested_options'};
		$$ibap_object_ref{'common_properties'}{'ignore_client_requested_options'} 	 = 0 unless defined $$ibap_object_ref{'common_properties'}{'ignore_client_requested_options'};
	}

	if (defined $$ibap_object_ref{'bootp_properties'}) {
		$$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'}  = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'};
		$$ibap_object_ref{'bootp_properties'}{'use_boot_file'}   = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_boot_file'};
		$$ibap_object_ref{'bootp_properties'}{'use_boot_server'} = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_boot_server'};
		$$ibap_object_ref{'bootp_properties'}{'use_next_server'} = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_next_server'};
	}

	#
    #
    #
    #
    #
    #

    $self->ddns_server_always_updates('false');
    $self->disable('false');
    $self->recycle_leases('false');
    $self->email_list(undef);

    #
    $self->{'authority'}                   = 'false';
    $self->{'enable_dhcp_thresholds'}      = 'false';
	$self->{'recycle_leases'}              = 'false';
    $self->{'ddns_generate_hostname'}      = 'false';
    $self->{'ddns_update_fixed_addresses'} = 'false';
    $self->{'ddns_use_option81'}           = 'false';
	$self->{'enable_ddns'}                 = 'false';
    $self->{'enable_ifmap_publishing'}     = 'false';
    $self->{'deny_bootp'}                  = 'false';

    $self->enable_email_warnings('false');
    $self->enable_snmp_warnings('false');
    $self->members([]);
    $self->network_container('/');

    $self->{endpoint_sources} = [];

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref, {
                                                                                                     'use_root_name_server' => 1,
                                                                                                     'address' => 1,
                                                                                                     'cidr' => 1,
                                                                                                    });

                                                                                                  
	if (defined $$ibap_object_ref{'bootp_properties'}) {
		ibap_i2o_bootp_props($self,$session,'bootp_properties',$ibap_object_ref);
	}

	if (defined $$ibap_object_ref{'common_properties'}) {
		ibap_i2o_common_dhcp_props($self,$session,'common_properties',$ibap_object_ref);
	}

	#
	#
	#

	if (defined $$ibap_object_ref{'use_enable_ddns'}) {
		$self->{'use_enable_ddns'}=$$ibap_object_ref{'use_enable_ddns'};
		if ($$ibap_object_ref{'use_enable_ddns'} != 1) {
			delete $self->{'enable_ddns'};
		}
	}

	if (defined $$ibap_object_ref{'use_enable_option81'}) {
		$self->{'use_enable_option81'}=$$ibap_object_ref{'use_enable_option81'};
		if ($$ibap_object_ref{'use_enable_option81'} != 1) {
			delete $self->{'ddns_use_option81'};
		}
	}

	if (defined $$ibap_object_ref{'use_enable_thresholds'}) {
		$self->{'use_enable_thresholds'}=$$ibap_object_ref{'use_enable_thresholds'};
		if ($$ibap_object_ref{'use_enable_thresholds'} != 1) {
			delete $self->{'enable_dhcp_thresholds'};
		}
	}

	if (defined $$ibap_object_ref{'use_generate_hostname'}) {
		$self->{'use_generate_hostname'}=$$ibap_object_ref{'use_generate_hostname'};
		if ($$ibap_object_ref{'use_generate_hostname'} != 1) {
			delete $self->{'ddns_generate_hostname'};
		}
	}

	if (defined $$ibap_object_ref{'use_is_authoritative'}) {
		$self->{'use_is_authoritative'}=$$ibap_object_ref{'use_is_authoritative'};
		if ($$ibap_object_ref{'use_is_authoritative'} != 1) {
			delete $self->{'authority'};
		}
	}

	if (defined $$ibap_object_ref{'use_update_static_leases'}) {
		$self->{'use_update_static_leases'}=$$ibap_object_ref{'use_update_static_leases'};
		if ($$ibap_object_ref{'use_update_static_leases'} != 1) {
			delete $self->{'ddns_update_fixed_addresses'};
		}
	}

	if (defined $$ibap_object_ref{'use_recycle_leases'}) {
		$self->{'use_recycle_leases'}=$$ibap_object_ref{'use_recycle_leases'};
		if ($$ibap_object_ref{'use_recycle_leases'} != 1) {
			delete $self->{'recycle_leases'};
		}
	}

	if (defined $$ibap_object_ref{'use_threshold_email_addresses'}) {
		$self->{'use_threshold_email_addresses'}=$$ibap_object_ref{'use_threshold_email_addresses'};
		if ($$ibap_object_ref{'use_threshold_email_addresses'} != 1) {
			$self->email_list(undef);
		}
	}

	if (defined $$ibap_object_ref{'bootp_properties'}) {
        if (defined $$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'}) {
            $self->{'use_deny_bootp'}=$$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'};
            if ($self->{'use_deny_bootp'} != 1) {
                delete $self->{'deny_bootp'};
            }
        }

        if (defined $$ibap_object_ref{'bootp_properties'}{'use_boot_file'}) {
            $self->{'use_boot_file'}=$$ibap_object_ref{'bootp_properties'}{'use_boot_file'};
            if ($self->{'use_boot_file'} != 1) {
                delete $self->{'bootfile'};
            }
        }

        if (defined $$ibap_object_ref{'bootp_properties'}{'use_boot_server'}) {
            $self->{'use_boot_server'}=$$ibap_object_ref{'bootp_properties'}{'use_boot_server'};
            if ($self->{'use_boot_server'} != 1) {
                delete $self->{'bootserver'};
            }
        }

        if (defined $$ibap_object_ref{'bootp_properties'}{'use_next_server'}) {
            $self->{'use_next_server'}=$$ibap_object_ref{'bootp_properties'}{'use_next_server'};
            if ($self->{'use_next_server'} != 1) {
                delete $self->{'nextserver'};
            }
        }
    }

    #
    $self->{'override_ddns_ttl'}                      = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_ttl'});
    $self->{'override_ddns_domainname'}               = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_domainname'});
    $self->{'override_enable_ifmap_publishing'}       = ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_ifmap_publishing'});
    $self->{'override_update_dns_on_lease_renewal'}   = ibap_value_i2o_boolean($$ibap_object_ref{'use_update_dns_on_lease_renewal'});
    $self->{'override_lease_scavenge_time'}           = ibap_value_i2o_boolean($$ibap_object_ref{'use_client_association_grace_period'});
    $self->{'override_ignore_id'}                     = ibap_value_i2o_boolean($$ibap_object_ref{'use_ignore_id'});
    $self->{'override_enable_discovery'}              = ibap_value_i2o_boolean($$ibap_object_ref{'use_member_enable_discovery'});
    $self->{'override_discovery_basic_poll_settings'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_basic_polling_settings'});
    $self->{'override_blackout_setting'}              = ibap_value_i2o_boolean($$ibap_object_ref{'use_blackout_setting'});
    $self->{'override_ipam_trap_settings'}            = ibap_value_i2o_boolean($$ibap_object_ref{'use_ipam_trap_settings'});
    $self->{'override_ipam_threshold_settings'}       = ibap_value_i2o_boolean($$ibap_object_ref{'use_ipam_threshold_settings'});
    $self->{'override_ipam_email_addresses'}          = ibap_value_i2o_boolean($$ibap_object_ref{'use_ipam_email_addresses'});
    $self->{'override_logic_filters'}                 = ibap_value_i2o_boolean($$ibap_object_ref{'use_option_logic_filters'});
    $self->{'override_subscribe_settings'}            = ibap_value_i2o_boolean($$ibap_object_ref{'use_subscribe_settings'});
    #
    #

	#
	my $network = $$ibap_object_ref{'address'} ? $$ibap_object_ref{'address'} : '';
    my $netmask = $$ibap_object_ref{'cidr'} ? $$ibap_object_ref{'cidr'} : '';

    $self->network($network . '/' . $netmask);
	$self->netmask(undef);

    return;
}

#
#
#

sub __o2i_member_search__
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
        my $member = $$tempref{$current};
        my $outkey = 'dhcp_members';

        if (ref($member) eq 'Infoblox::DHCP::Member' || ref($member) eq 'Infoblox::Grid::Member') {
            $member=ibap_value_o2i_member($member, $session, $self, 'member', 1);
        }
        else {
            $member=ibap_readfield_simple_string('MsServer','address',$member->address());
            $outkey='ms_dhcp_servers';
        }
        return ($outkey,1,0,$member);
	}
	else {
        return (undef,1,1,undef);
	}
}

sub __o2i_template__
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	push @return_args, 1;
	if (not defined $$tempref{$current}) {
		push @return_args, 1;
		push @return_args, $$tempref{$current};
	} else {
		push @return_args, 0;
		push @return_args, ibap_readfield_simple_string('NetworkTemplate','name',$$tempref{$current}, $current);
	}

	return @return_args;
}

sub __object_to_ibap__
{
	my ($self, $server, $session) = @_;
	$self->{ '__internal_session_cache_ref__' } = \$session;

	my @write_fields;

	my $saved_always_update=$self->{'ddns_server_always_updates'};
	my $saved_option81=$self->{'ddns_use_option81'};

	foreach my $current (keys %$self) {
		next if $current =~ m/^__/;

		my %write_arg;
		if (defined $_name_mappings{$current}) {
			$write_arg{'field'} = $_name_mappings{$current};
		}
		else {
			$write_arg{'field'} = $current;
		}

		my @converted_values = $_object_to_ibap{$current}($self, $session, $current,$self);
		if (@converted_values) {
			my $success=shift @converted_values;
			if ($success) {
				my $ignore_value=shift @converted_values;
				$write_arg{'value'} = shift @converted_values;

				foreach my $extra_args (@converted_values) {
					unshift @write_fields, $extra_args;
				}

				if ($ignore_value) {
					next;
				}
			} else {
				$self->{'ddns_server_always_updates'} = $saved_always_update;
				return;
			}
		} else {
			$self->{'ddns_server_always_updates'} = $saved_always_update;
			return;
		}
		unshift @write_fields, \%write_arg;
	}
    #
	$self->{'ddns_server_always_updates'} = $saved_always_update;
    $self->{'ddns_use_option81'} = $saved_option81;

	my @bootp_options = ibap_arg_bootp_props($self, $session, '',$self);
	if (@bootp_options) {
		my $success=shift @bootp_options;
		if ($success) {
			my $ignore_value=shift @bootp_options;
			unless ($ignore_value) {
				my %write_arg;
				$write_arg{'field'} = 'bootp_properties';
				$write_arg{'value'} = shift @bootp_options;
				unshift @write_fields, \%write_arg;
			}
		}
		else {
			return;
		}
	}

	my @common_options = ibap_o2i_common_dhcp_props($self, $session, '',$self);
	if (@common_options) {
		my $success=shift @common_options;
		if ($success) {
			my $ignore_value=shift @common_options;
			unless ($ignore_value) {
				my %write_arg;
				$write_arg{'field'} = 'common_properties';
				$write_arg{'value'} = shift @common_options;
				unshift @write_fields, \%write_arg;
			}
		}
		else {
			return;
		}
	}

	return \@write_fields;
}

#
#
#

sub ignore_client_identifier
{
    my $self  = shift;
    if(@_ == 0) {
        return (defined $self->ignore_id() && $self->ignore_id() eq 'CLIENT') ? 'true' : 'false';
    } else {
      my $value = shift;
      if (!defined $value) {
            $self->ignore_id(undef);
      } elsif (($value =~ m/^false$/i) || ($value eq '0')) {
            if (defined $self->ignore_id() && $self->ignore_id() eq 'CLIENT') {
                $self->ignore_id('NONE');
            }
      } elsif (($value =~ m/^true$/i) || ($value eq '1')) {
            $self->ignore_id('CLIENT');
      } else {
            set_error_codes(1104,'Invalid boolean value (' . $value . ') for ignore_client_identifier');
            return undef;
      }
    }
    return 1;
}

sub override_ignore_client_identifier
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ignore_id', validator => \&ibap_value_o2i_boolean}, @_);
}

sub lease_scavenge_time
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'lease_scavenge_time', use => \$self->{'override_lease_scavenge_time'}, use_truefalse => 1, validator => \&ibap_value_o2i_int},@_);
}

sub override_lease_scavenge_time
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_lease_scavenge_time', validator => \&ibap_value_o2i_boolean}, @_);
}

sub netmask
{
	#

    my $self  = shift;
    if( @_ == 0 )
    {
        return undef;
    }
    else
    {
		return 1;
	}
}

sub options
{
    my $self  = shift;
    return ibap_accessor_dhcp_options($self, 'options', @_);
}

sub pxe_lease_time
{
    my $self = shift;
    #
    if( @_ == 0 )
    {
        return $self->{ 'pxe_lease_time' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ 'pxe_lease_time' } = undef;
            $self->{ 'use_pxe_lease_time' } = 0 unless $self->{ 'enable_pxe_lease_time' };
        }
        else
        {
			if ($value !~ m/^[0-9]+$/) {
				set_error_codes(1104,"Invalid value '$value' for member pxe_lease_time." );
				return;
			}
			else {
				$self->{ 'pxe_lease_time' } = $value;
				$self->{ 'use_pxe_lease_time' } = 1;
			}
		}
	}
	return 1;
}

sub network
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'network' };
    }
    else
    {
        my $value = shift;
		delete $self->{ 'ipv4addr' };
        if( !defined $value )
        {
            $self->{ 'network' } = undef;
        }
        else
        {
			$self->{ 'network' } = $value;
		}
	}
	return 1;
}

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

sub resize
{
    my ($self, %args)  = @_;

    unless ($self->{ '__internal_session_cache_ref__' } &&
            $self->__object_id__()) {
        set_error_codes(1001,'In order to resize the network, the object must have been retrieved from the server first');
        return;
    }

    my $session = ${$self->{ '__internal_session_cache_ref__' }};
    return $session->__resize_network_or_container__($self->__object_id__(), \%args);
}

sub zone_associations
{
    my $self = shift;
    return $self->__accessor_lazy_use_member_array_object__('zone_associations',\$self->{'use_zone_associations'},["Infoblox::DNS::Zone"],\&ibap_lazy_i2o_zone_associations_use_member,$_lazy_return_fields{'zone_associations'},@_);
}


1;
