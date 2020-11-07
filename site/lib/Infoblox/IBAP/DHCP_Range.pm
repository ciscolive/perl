package Infoblox::DHCP::Range;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members %_return_field_overrides
             @_return_fields @_optional_return_fields %_searchable_fields %_object_to_ibap
             %_name_mappings %_reverse_name_mappings %_ibap_to_object
             $_return_fields_initialized %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'DhcpRange';
    register_wsdl_type('ib:DhcpRange', 'Infoblox::DHCP::Range');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    #
    #
    #
    #
    %_allowed_members = (
       authority                       => 0, #deprecated
       always_update_dns               => 0,
       bootfile                        => 0,
       bootserver                      => 0,
       comment                         => 0,
       ddns_domainname                 => 0,
       override_ddns_domainname             => 0,
       update_dns_on_lease_renewal         => 0,
       override_lease_scavenge_time    => 0,
       override_update_dns_on_lease_renewal => 0,
       ddns_generate_hostname          => 0,
       deny_all_clients                => 0,
       deny_bootp                      => 0,
       disable                         => 0,
       email_list                      => 0,
       enable_ddns                     => 0,
       enable_dhcp_thresholds          => 0,
       enable_ifmap_publishing         => 0,
       enable_known_clients_option     => 0,
       enable_email_warnings           => 0,
       enable_snmp_warnings            => 0,
       enable_unknown_clients_option   => 0,
       end_addr                        => 0,
       exclude                         => 0,
       failover_assoc                  => 0,
       filters                         => 0,
       ignore_dhcp_option_list_request => 0,
       is_split_scope                  => -1,
       known_clients_option            => 0,
       lease_scavenge_time             => 0,
       member                          => 0,
       ms_options                      => {validator => {'Infoblox::DHCP::MSOption' => 1}, skip_accessor => 1},
       name                            => 0,
       network                         => 0,
       network_view                    => 0,
       nextserver                      => 0,
       options                         => 0,
       override_enable_ifmap_publishing => 0,
       pxe_lease_time                  => 0,
       recycle_leases                  => 0,
       range_high_water_mark           => 0,
       range_high_water_mark_reset     => 0,
       range_low_water_mark            => 0,
       range_low_water_mark_reset      => 0,
       server_association_type         => 0,
       split_member                    => 0,
       split_scope_exclusion_percent   => 0,
       start_addr                      => 0,
       template                        => 0,
       unknown_clients_option          => 0,
       extattrs                        => 0,
       extensible_attributes           => 0,
       ignore_client_identifier        => 0, # replaced by ignore_id
       override_ignore_client_identifier => 0, # replaced by override_ignore_id
       ignore_id                       => {simple => 'asis', enum => ['NONE', 'CLIENT', 'MACADDR'], use => 'override_ignore_id', use_truefalse => 1},
       ignore_mac_addresses            => {array => 1, validator => \&ibap_value_o2i_string, use => 'override_ignore_id', use_truefalse => 1},
       override_ignore_id              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       enable_discovery                => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_enable_discovery', use_members => ['enable_discovery', 'discovery_member'], use_truefalse => 1},     
       override_enable_discovery       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       discovery_member                => {validator => \&ibap_value_o2i_string, use => 'override_enable_discovery', use_members => ['enable_discovery', 'discovery_member'], use_truefalse => 1},
       discovery_basic_poll_settings   => {validator => {'Infoblox::Grid::Discovery::BasicPollSettings' => 1}, use => 'override_discovery_basic_poll_settings', use_truefalse => 1},    
       enable_immediate_discovery      => {simple => 'bool', writeonly => 1, validator => \&ibap_value_o2i_boolean},
       override_discovery_basic_poll_settings => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       discover_now_status             => {simple => 'asis', readonly => 1},
       discovery_blackout_setting      => {validator => {'Infoblox::Grid::Discovery::Properties::BlackoutSetting' => 1}, use => 'override_blackout_setting', 'use_members' => ['discovery_blackout_setting', 'port_control_blackout_setting'], use_truefalse => 1},
       port_control_blackout_setting   => {validator => {'Infoblox::Grid::Discovery::Properties::BlackoutSetting' => 1}, use => 'override_blackout_setting', 'use_members' => ['discovery_blackout_setting', 'port_control_blackout_setting'], use_truefalse => 1},
       same_port_control_discovery_blackout   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       override_blackout_setting       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       ms_ad_user_data                 => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},

       logic_filters                 => {array => 1, validator => {string => 1, 'Infoblox::DHCP::Filter::MAC' => 1,
                                         'Infoblox::DHCP::Filter::NAC' => 1, 'Infoblox::DHCP::Filter::Option' => 1},
                                         use => 'override_logic_filters', use_truefalse => 1},
       override_logic_filters        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       
       #
       cloud_info                      => {validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
       restart_if_needed               => {simple => 'bool', validator => \&ibap_value_o2i_boolean, writeonly => 1},

       'endpoint_sources'            => {readonly => 1, array => 1, validator => {'Infoblox::CiscoISE::Endpoint' => 1}},
       'override_subscribe_settings' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       'subscribe_settings'          => {use => 'override_subscribe_settings', use_truefalse => 1,
                                         validator => {'Infoblox::CiscoISE::SubscribeSetting' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides =
        (always_update_dns                      => [],
         bootfile                               => ['bootp_properties'],
         bootserver                             => ['bootp_properties'],
         comment                                => [],
         ddns_domainname                        => ['use_ddns_domainname'],
         override_ddns_domainname               => [],
         update_dns_on_lease_renewal            => ['use_update_dns_on_lease_renewal'],
         override_update_dns_on_lease_renewal   => [],
         ddns_generate_hostname                 => ['use_generate_hostname'],
         deny_all_clients                       => [],
         deny_bootp                             => ['bootp_properties'],
         disable                                => [],
         email_list                             => ['use_threshold_email_addresses'],
         enable_ddns                            => ['use_enable_ddns'],
         enable_known_clients_option            => [],
         enable_email_warnings                  => [],
         enable_ifmap_publishing                => ['use_enable_ifmap_publishing'],
         enable_snmp_warnings                   => [],
         enable_dhcp_thresholds                 => ['use_enable_thresholds'],
         enable_unknown_clients_option          => [],
         end_addr                               => [],
         exclude                                => [],
         failover_assoc                         => ['server_association_type'],
         filters                                => [],
         ignore_dhcp_option_list_request        => ['common_properties'],
         known_clients_option                   => ['use_known_clients'],
         lease_scavenge_time                    => ['use_client_association_grace_period'],
         override_lease_scavenge_time           => [],
         member                                 => ['server_association_type','ms_server'],
         ms_options                             => ['use_ms_options'],
         is_split_scope                         => [],
         name                                   => [],
         network                                => [],
         network_view                           => [],
         nextserver                             => ['bootp_properties'],
         options                                => ['common_properties'],
         override_enable_ifmap_publishing       => [],
         pxe_lease_time                         => ['common_properties'],
         recycle_leases                         => ['use_recycle_leases'],
         range_high_water_mark                  => [],
         range_high_water_mark_reset            => [],
         range_low_water_mark                   => [],
         range_low_water_mark_reset             => [],
         server_association_type                => [],
         start_addr                             => [],
         template                               => [],
         unknown_clients_option                 => ['use_unknown_clients'],
         extattrs                               => [],
         extensible_attributes                  => [],
         ignore_id                              => ['use_ignore_id'],
         ignore_mac_addresses                   => ['use_ignore_id'],
         override_ignore_id                     => [],
         ignore_client_identifier               => ['ignore_id','use_ignore_id'],
         override_ignore_client_identifier      => ['use_ignore_id'],
         enable_discovery                       => ['discovery_member','use_member_enable_discovery'],
         override_enable_discovery              => [],
         discovery_member                       => ['enable_discovery','use_member_enable_discovery'],
         discovery_basic_poll_settings          => ['use_basic_polling_settings'],
         override_discovery_basic_poll_settings => [],
         discover_now_status                    => [],
         discovery_blackout_setting             => ['port_control_blackout_setting', 'use_blackout_setting'],
         port_control_blackout_setting          => ['discovery_blackout_setting', 'use_blackout_setting'],
         override_blackout_setting              => [],
         same_port_control_discovery_blackout   => [],
         cloud_info                             => [],
         ms_ad_user_data                        => [],
         logic_filters               => ['use_option_logic_filters'],
         override_logic_filters      => [],
         subscribe_settings          => ['use_subscribe_settings'],
         override_subscribe_settings => [],
         endpoint_sources            => [],

#
#
#
#
        );


    %_searchable_fields = (
						   network     => [\&ibap_o2i_network      ,'parent'        , 'SEARCHONLY_LIST_CONTAIN'],
						   network_view => [\&ibap_o2i_network_view ,'network_view' , 'EXACT'],
						   start_addr  => [\&ibap_o2i_string       ,'start_address' , 'REGEX'],
						   end_addr    => [\&ibap_o2i_string       ,'end_address'   , 'REGEX'],
						   failover_assoc => [\&ibap_o2i_range_failover  ,'failover_association'   , 'EXACT'],
						   comment     => [\&ibap_o2i_string       ,'comment'       , 'REGEX', 'IGNORE_CASE'],
						   name        => [\&ibap_o2i_string       ,'name'          , 'REGEX'],
						   server_association_type => [\&ibap_o2i_string     ,'server_association_type', 'EXACT'],
						   member      => [\&ibap_o2i_mixed_member_search ,'member'        , 'EXACT'],
						   ms_superscope => [\&__o2i_superscope_search__ ,'ms_superscope' , 'EXACT'],
                           extattrs    => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
					   );

    %_name_mappings = (
					   'ddns_generate_hostname'        => 'generate_hostname' ,
					   'disable' 				       => 'disabled',
                       'email_list'                    => 'threshold_email_addresses',
					   'enable_known_clients_option'   => 'use_known_clients' ,
                       'enable_email_warnings'         => 'enable_threshold_email_warnings' ,
                       'enable_dhcp_thresholds'        => 'enable_thresholds' ,
                       'enable_snmp_warnings'          => 'enable_threshold_snmp_warnings' ,
					   'enable_unknown_clients_option' => 'use_unknown_clients' ,
					   'end_addr'  			           => 'end_address' ,
					   'exclude'     			       => 'exclusion_ranges',
					   'failover_assoc'  		       => 'failover_association',
                       'lease_scavenge_time'                => 'client_association_grace_period',
					   'network' 				       => 'parent',
					   'start_addr'  			       => 'start_address' ,
                       'split_member'                  => 'split_scope_ms_server',
                       'override_update_dns_on_lease_renewal' => 'use_update_dns_on_lease_renewal',
                       'override_ddns_domainname'     => 'use_ddns_domainname',
                       'override_lease_scavenge_time'      => 'use_client_association_grace_period',
                       'override_enable_ifmap_publishing' => 'use_enable_ifmap_publishing',
                       'override_ignore_id' => 'use_ignore_id',
                       'extattrs'                      => 'extensible_attributes',
                       'discovery_basic_poll_settings'          => 'basic_polling_settings',
                       'override_discovery_basic_poll_settings' => 'use_basic_polling_settings',
                       'override_enable_discovery'              => 'use_member_enable_discovery',
                       'override_blackout_setting'              => 'use_blackout_setting',
 
                       'logic_filters'          => 'option_logic_filters',
                       'override_logic_filters' => 'use_option_logic_filters',

					   #
					   #
					   #
					   'filters' => 'mac_filter_rules' ,
                       'override_subscribe_settings' => 'use_subscribe_settings',
					  );

    %_reverse_name_mappings = (
							   'disabled'             	  => 'disable',
                               'threshold_email_addresses'=> 'email_list',
							   'end_address'          	  => 'end_addr',
							   'exclusion_ranges'     	  => 'exclude',
                               'enable_threshold_email_warnings'  => 'enable_email_warnings',
                               'enable_threshold_snmp_warnings'   => 'enable_snmp_warnings',
                               'enable_thresholds'        => 'enable_dhcp_thresholds',
                               'client_association_grace_period' => 'lease_scavenge_time',
							   'failover_association' 	  => 'failover_assoc',
							   'generate_hostname'    	  => 'ddns_generate_hostname',
							   'mac_filter_rules'     	  => 'filters',
							   'nac_filter_rules'     	  => 'filters',
							   'option_filter_rules'      => 'filters',
                               'fingerprint_filter_rules' => 'filters',
                               'ms_server'                => 'member',
							   'parent'               	  => 'network',
							   'relay_agent_filter_rules' => 'filters',
                               'split_scope_ms_server',        => 'split_member',
							   'start_address'        	  => 'start_addr',
                               'use_known_clients'        => 'enable_known_clients_option',
                               'use_unknown_clients'      => 'enable_unknown_clients_option',
                               'use_update_dns_on_lease_renewal' => 'override_update_dns_on_lease_renewal',
                               'use_ddns_domainname'             => 'override_ddns_domainname',
                               'use_enable_ifmap_publishing' => 'override_enable_ifmap_publishing',
                               'use_client_association_grace_period' => 'override_lease_scavenge_time',
                               'use_ignore_id' => 'override_ignore_id',
                               'extensible_attributes'    => 'extattrs',
                               'basic_polling_settings'          => 'discovery_basic_poll_settings',
                               'use_basic_polling_settings'      => 'override_discovery_basic_poll_settings',
                               'use_member_enable_discovery'     => 'override_enable_discovery',
                               'use_blackout_setting'            => 'override_blackout_setting',

                               'option_logic_filters'     => 'logic_filters',
                               'use_option_logic_filters' => 'override_logic_filters',
                               'use_subscribe_settings' => 'override_subscribe_settings',
                              );

    %_ibap_to_object = (
                        'always_update_dns'        => \&ibap_i2o_boolean,
						'deny_all_clients'  	   => \&ibap_i2o_boolean,
						'disabled' 				   => \&ibap_i2o_boolean,
						'enable_ddns' 			   => \&ibap_i2o_boolean,
                        'enable_ifmap_publishing'  => \&ibap_i2o_boolean,
                        'enable_thresholds'        => \&ibap_i2o_boolean,
                        'enable_threshold_email_warnings'   => \&ibap_i2o_boolean,
                        'enable_threshold_snmp_warnings'    => \&ibap_i2o_boolean,
						'exclusion_ranges' 		   => \&ibap_i2o_exclusion,
						'failover_association'     => \&ibap_i2o_range_failover,
						'generate_hostname'        => \&ibap_i2o_boolean,
                        'is_split_scope'           => \&ibap_i2o_boolean,
						'mac_filter_rules'         => \&ibap_i2o_range_filters,
						'member' 				   => \&ibap_i2o_mixed_member,
						'ms_server' 			   => \&ibap_i2o_mixed_member,
                        'ms_options'               => \&ibap_i2o_generic_object_list_convert,
						'nac_filter_rules'         => \&ibap_i2o_range_filters,
						'option_filter_rules'      => \&ibap_i2o_range_filters,
                        'fingerprint_filter_rules' => \&ibap_i2o_range_filters,
                        'network_view'             => \&ibap_i2o_generic_object_convert,
						'parent' 				   => \&__i2o_network__,
						'recycle_leases'           => \&ibap_i2o_boolean,
						'relay_agent_filter_rules' => \&ibap_i2o_range_filters,
                        'threshold_email_addresses'=> \&__i2o_email__,
                        'use_known_clients'        => \&ibap_i2o_boolean,
                        'use_unknown_clients'      => \&ibap_i2o_boolean,
                        'extensible_attributes'    => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'update_dns_on_lease_renewal'     => \&ibap_i2o_boolean,
                        'use_update_dns_on_lease_renewal' => \&ibap_i2o_boolean,
                        'use_ddns_domainname'             => \&ibap_i2o_boolean,
                        'use_client_association_grace_period' => \&ibap_i2o_boolean,
                        'use_enable_ifmap_publishing' => \&ibap_i2o_boolean,
                        'ignore_id'                    => \&ibap_i2o_enums_uc_or_undef,
                        'ignore_mac_addresses'         => \&ibap_i2o_mac_addresses,
                        'enable_discovery'             => \&ibap_i2o_boolean,
                        'use_member_enable_discovery'  => \&ibap_i2o_boolean,
                        'basic_polling_settings'       => \&ibap_i2o_generic_object_convert,
                        'use_basic_polling_settings'   => \&ibap_i2o_boolean,
                        'discovery_member'             => \&ibap_i2o_member_byhostname,
                        'discovery_blackout_setting'    => \&ibap_i2o_generic_object_convert,
                        'port_control_blackout_setting' => \&ibap_i2o_generic_object_convert,
                        'option_logic_filters'     => \&ibap_i2o_ordered_filters,
                        'use_option_logic_filters' => \&ibap_i2o_boolean,

                        'cloud_info'                    => \&ibap_i2o_generic_object_convert,
                        'ms_ad_user_data'               => \&ibap_i2o_generic_object_convert,
                        'subscribe_settings'            => \&ibap_i2o_generic_object_convert,
                        'endpoint_sources'              => \&ibap_i2o_generic_object_list_convert,
					   );


    %_object_to_ibap = (
                        'authority'                       => \&ibap_o2i_ignore,
                        'always_update_dns'			   	  => \&ibap_o2i_boolean,
						'bootfile'						  => \&ibap_o2i_ignore,
						'bootserver'					  => \&ibap_o2i_ignore,
						'comment'					   	  => \&ibap_o2i_string,
                        'ddns_domainname'                 => \&ibap_o2i_string,
						'ddns_generate_hostname'          => \&ibap_o2i_boolean,
						'deny_all_clients'                => \&ibap_o2i_boolean,
						'deny_bootp'					  => \&ibap_o2i_ignore,
						'email_list'                      => \&__o2i_email__,
						'enable_dhcp_thresholds'          => \&ibap_o2i_boolean,
						'enable_email_warnings'           => \&ibap_o2i_boolean,
                        'enable_ifmap_publishing'         => \&ibap_o2i_boolean,
						'enable_snmp_warnings'            => \&ibap_o2i_boolean,
						'enable_known_clients_option'     => \&ibap_o2i_boolean,
						'enable_unknown_clients_option'   => \&ibap_o2i_boolean,
						'server_association_type'         => \&ibap_o2i_enums_lc_or_undef,
						'exclude' 					      => \&ibap_o2i_exclusion,
						'filters' 					      => \&ibap_o2i_range_filters,
						'failover_assoc'  		          => \&ibap_o2i_range_failover,
						'member'          		          => \&ibap_o2i_mixed_member,
						'disable'					   	  => \&ibap_o2i_boolean,
						'recycle_leases'				  => \&ibap_o2i_boolean,
						'enable_ddns'				   	  => \&ibap_o2i_boolean,
						'is_split_scope'                  => \&ibap_o2i_ignore,
						'ignore_dhcp_option_list_request' => \&ibap_o2i_ignore,
                        'known_clients_option'            => \&ibap_o2i_string,
                        'lease_scavenge_time'                  => \&ibap_o2i_integer,
                        'ms_options'                      => \&ibap_o2i_generic_struct_list_convert,
                        'name'                            => \&ibap_o2i_string,
						'network'					   	  => \&ibap_o2i_network,
						'network_view'				   	  => \&ibap_o2i_network_view,
						'nextserver'					  => \&ibap_o2i_ignore,
						'options'					   	  => \&ibap_o2i_ignore,
						'pxe_lease_time'				  => \&ibap_o2i_ignore,
						'range_high_water_mark'           => \&ibap_o2i_uint,
						'range_high_water_mark_reset'     => \&ibap_o2i_uint,
						'range_low_water_mark'            => \&ibap_o2i_uint,
						'range_low_water_mark_reset'      => \&ibap_o2i_uint,
                        'split_member'                    => \&ibap_o2i_msserver,
                        'split_scope_exclusion_percent'   => \&ibap_o2i_uint,
						'start_addr'					  => \&ibap_o2i_string,
						'end_addr'					   	  => \&ibap_o2i_string,
                        'unknown_clients_option'          => \&ibap_o2i_string,
						'template'					   	  => \&ibap_o2i_range_template,
                        'update_dns_on_lease_renewal'         => \&ibap_o2i_boolean,
                        'ignore_id'                       => \&ibap_o2i_string,
                        'ignore_mac_addresses'            => \&ibap_o2i_mac_addresses,
                        'enable_discovery'                => \&ibap_o2i_boolean,
                        'discovery_member'                => \&ibap_o2i_member_byhostname,
                        'discovery_basic_poll_settings'   => \&ibap_o2i_generic_struct_convert,
                        'enable_immediate_discovery'      => \&ibap_o2i_boolean,
                        'discover_now_status'             => \&ibap_o2i_ignore,
                        'discovery_blackout_setting'      => \&ibap_o2i_generic_struct_convert,
                        'port_control_blackout_setting'   => \&ibap_o2i_generic_struct_convert,
                        'same_port_control_discovery_blackout' => \&ibap_o2i_boolean,
                        'ms_ad_user_data'                      => \&ibap_o2i_ignore,

                        'override_logic_filters'        => \&ibap_o2i_boolean,
                        'logic_filters'                 => \&ibap_o2i_ordered_filters,

                        'cloud_info'                           => \&ibap_o2i_generic_struct_convert,
                        'restart_if_needed'                    => \&ibap_o2i_boolean,

						#

                        'override_update_dns_on_lease_renewal' => \&ibap_o2i_boolean,
                        'override_ddns_domainname'             => \&ibap_o2i_boolean,
                        'override_enable_ifmap_publishing'     => \&ibap_o2i_boolean,
                        'override_lease_scavenge_time'              => \&ibap_o2i_boolean,
						'use_enable_ddns' 		=> \&ibap_o2i_boolean,
                        'use_enable_thresholds' => \&ibap_o2i_boolean,
						'use_generate_hostname'	=> \&ibap_o2i_boolean,
						'use_ms_options'        => \&ibap_o2i_boolean,
						'use_recycle_leases'	=> \&ibap_o2i_boolean,
                        'use_threshold_email_addresses'	=> \&ibap_o2i_boolean,
						'use_is_authoritative' 	=> \&ibap_o2i_ignore,
                        'override_ignore_id' => \&ibap_o2i_boolean,
                        'override_enable_discovery'              => \&ibap_o2i_boolean,
                        'override_discovery_basic_poll_settings' => \&ibap_o2i_boolean,
                        'override_blackout_setting'              => \&ibap_o2i_boolean,
                        'subscribe_settings'          => \&ibap_o2i_generic_struct_convert,
                        'endpoint_sources'            => \&ibap_o2i_ignore,
                        'override_subscribe_settings' => \&ibap_o2i_boolean,

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
    my @rlist = (
                 'always_update_dns',
                 'comment',
                 'client_association_grace_period',
                 'deny_all_clients',
                 'disabled',
                 'server_association_type',
                 'enable_ddns',
                 'end_address',
                 'enable_thresholds',
                 'ddns_domainname',
                 'enable_ifmap_publishing',
                 'enable_threshold_email_warnings',
                 'enable_threshold_snmp_warnings',
                 'generate_hostname',
                 'is_split_scope',
                 'known_clients_option',
                 'member',
                 'name',
                 'ms_options',
                 'recycle_leases',
                 'range_high_water_mark',
                 'range_high_water_mark_reset',
                 'range_low_water_mark',
                 'range_low_water_mark_reset',
                 'start_address',
                 'unknown_clients_option',
                 'use_client_association_grace_period',
                 'use_enable_ddns',
                 'use_known_clients',
                 'use_generate_hostname',
                 'use_threshold_email_addresses',
                 'use_recycle_leases',
                 'use_enable_thresholds',
                 'use_enable_ifmap_publishing',
                 'use_ms_options',
                 'use_unknown_clients',
                 'update_dns_on_lease_renewal',
                 'use_update_dns_on_lease_renewal',
                 'use_ddns_domainname',
                 'ignore_id',
                 'use_ignore_id',
                 'enable_discovery',
                 'use_member_enable_discovery',
                 'use_basic_polling_settings',
                 'use_blackout_setting',
                 'same_port_control_discovery_blackout',
                 'use_option_logic_filters',
                 'use_subscribe_settings',
                );

    foreach my $current (@rlist) {
        push @_return_fields, tField($current);
    }

    push @_return_fields, tField('ignore_mac_addresses',{ sub_fields => [ tField('mac_addr')]});

    @rlist = (
              'nac_filter_rules',
              'mac_filter_rules',
              'option_filter_rules',
              'relay_agent_filter_rules',
              'fingerprint_filter_rules',
             );

    foreach my $current (@rlist) {
        push @_return_fields, tField($current,
                                     {
                                      sub_fields =>
                                      [
                                       tField('filter',
                                               {
                                                sub_fields => [
                                                               tField('name')
                                                              ]
                                               }
                                              ),
                                        tField('permission')
                                      ]
                                     }
                                    );
    }

    push @_return_fields, tField('option_logic_filters', return_fields_option_logic_filters());


    @rlist = (
              'bootp_properties',
              'exclusion_ranges',
            );

    foreach my $current (@rlist) {
        push @_return_fields, tField($current,
                                     {
                                      depth => 1
                                     }
                                    );
    }

    push @_return_fields, tField('common_properties', { depth => 2 });
    push @_return_fields, tField('failover_association', { sub_fields => [ tField('name') ] });
    push @_return_fields, tField('member', return_fields_member_basic_data());
    push @_return_fields, tField('parent',
                          { sub_fields => [tField('address'),
                                           tField('cidr')] });
    push @_return_fields, tField('ms_server',
                          { sub_fields => [tField('address'),
                                           tField('server_name')] });
    push @_return_fields, tField('threshold_email_addresses',
                          { sub_fields => [ tField('email_address') ]});
    push @_return_fields, return_fields_extensible_attributes();
    push @_return_fields, tField('discovery_member', {'sub_fields' => [tField('host_name')]});

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

    if (defined $args{'server_association_type'}) {
        #
        #
        $self->server_association_type($args{'server_association_type'});
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
        push @_return_fields, tField('network_view', {
                                                      default_no_access_ok => 1,
                                                      sub_fields           => $tmp->__return_fields__(),
                                                     });

        my %tmp = (
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

	$self->{__object_id_cache__} = {};
    $self->{'override_enable_ifmap_publishing'} = 'false' unless defined $self->override_enable_ifmap_publishing();
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

#
#
#

sub __i2o_email__
{
        my ($self, $session, $current, $ibap_object_ref) = @_;
        my @newlist;

        if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
                my @list=@{$$ibap_object_ref{$current}};

                foreach my $email (@list) {
                        push @newlist, ${$email}{'email_address'};
                }

                return \@newlist;
        } else {
                return [];
        }
}

sub __i2o_network__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
	my @newlist;

	if ($$ibap_object_ref{$current}) {
		my $t=$$ibap_object_ref{$current};

		my $address = ${$t}{'address'} ? ${$t}{'address'} : '';
        my $cidr = ${$t}{'cidr'} ? ${$t}{'cidr'} : '';

		return $address . '/' . $cidr;
	} else {
		return;
	}
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

	$self->{ '__internal_session_cache_ref__' } = \$session;

	#
    $$ibap_object_ref{'always_update_dns'}    = 0 unless defined $$ibap_object_ref{'always_update_dns'};
    $$ibap_object_ref{'use_recycle_leases'}    = 0 unless defined $$ibap_object_ref{'use_recycle_leases'};
    $$ibap_object_ref{'use_enable_ddns'} 	   = 0 unless defined $$ibap_object_ref{'use_enable_ddns'};
    $$ibap_object_ref{'use_generate_hostname'} = 0 unless defined $$ibap_object_ref{'use_generate_hostname'};
    $$ibap_object_ref{'use_is_authoritative'}  = 0 unless defined $$ibap_object_ref{'use_is_authoritative'};
    $$ibap_object_ref{'use_known_clients'}     = 0 unless defined $$ibap_object_ref{'use_known_clients'};
    $$ibap_object_ref{'use_threshold_email_addresses'} = 0 unless defined $$ibap_object_ref{'use_threshold_email_addresses'};
    $$ibap_object_ref{'use_enable_thresholds'} = 0 unless defined $$ibap_object_ref{'use_enable_thresholds'};
    $$ibap_object_ref{'enable_dhcp_thresholds'} = 0 unless defined $$ibap_object_ref{'enable_dhcp_thresholds'};
    $$ibap_object_ref{'enable_ifmap_publishing'} = 0 unless defined $$ibap_object_ref{'enable_ifmap_publishing'};
    $$ibap_object_ref{'enable_threshold_snmp_warnings'} = 0 unless defined $$ibap_object_ref{'enable_threshold_snmp_warnings'};
    $$ibap_object_ref{'enable_threshold_email_warnings'} = 0 unless defined $$ibap_object_ref{'enable_threshold_email_warnings'};
    $$ibap_object_ref{'use_unknown_clients'}   = 0 unless defined $$ibap_object_ref{'use_unknown_clients'};
    $$ibap_object_ref{'use_ms_options'}        = 0 unless defined $$ibap_object_ref{'use_ms_options'};
    $$ibap_object_ref{'use_update_dns_on_lease_renewal'} = 0 unless defined $$ibap_object_ref{'use_update_dns_on_lease_renewal'};
    $$ibap_object_ref{'update_dns_on_lease_renewal'}  = 0 unless defined $$ibap_object_ref{'update_dns_on_lease_renewal'};
    $$ibap_object_ref{'use_ddns_domainname'}          = 0 unless defined $$ibap_object_ref{'use_ddns_domainname'};
    $$ibap_object_ref{'use_client_association_grace_period'}          = 0 unless defined $$ibap_object_ref{'use_client_association_grace_period'};
    $$ibap_object_ref{'use_enable_ifmap_publishing'}             = 0 unless defined $$ibap_object_ref{'use_enable_ifmap_publishing'};
    $$ibap_object_ref{'is_split_scope'}  = 0 unless defined $$ibap_object_ref{'is_split_scope'};
    $$ibap_object_ref{'use_ignore_id'} = 0 unless defined $$ibap_object_ref{'use_ignore_id'};
    $$ibap_object_ref{'enable_discovery'} = 0 unless defined $$ibap_object_ref{'enable_discovery'};
    $$ibap_object_ref{'use_member_enable_discovery'} = 0 unless defined $$ibap_object_ref{'use_member_enable_discovery'};
    $$ibap_object_ref{'use_basic_polling_settings'} = 0 unless defined $$ibap_object_ref{'use_basic_polling_settings'};
    $$ibap_object_ref{'use_blackout_setting'} = 0 unless defined $$ibap_object_ref{'use_blackout_setting'};
    $$ibap_object_ref{'same_port_control_discovery_blackout'} = 0 unless defined $$ibap_object_ref{'same_port_control_discovery_blackout'};
    $$ibap_object_ref{'use_option_logic_filters'} = 0 unless defined $$ibap_object_ref{'use_option_logic_filters'};
    $$ibap_object_ref{'use_subscribe_settings'} = 0 unless defined $$ibap_object_ref{'use_subscribe_settings'};

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
    $self->recycle_leases('false');
	$self->{ 'use_recycle_leases' } = 0;

	$self->enable_ddns('false');
	$self->{ 'use_enable_ddns' } = 0;

    $self->ddns_generate_hostname('false');
	$self->{ 'use_generate_hostname' } = 0;

	$self->{ 'use_is_authoritative' } = 0;
    $self->authority('false');

    $self->enable_dhcp_thresholds('false');
    $self->{'use_deny_bootp'} = 0;
    $self->deny_bootp('false');

    $self->deny_all_clients('false');
    $self->disable('false');
    $self->exclude([]);
    $self->enable_email_warnings('false');
    $self->enable_snmp_warnings('false');

    $self->{endpoint_sources} = [];

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

	if (defined $$ibap_object_ref{'bootp_properties'}) {
		ibap_i2o_bootp_props($self,$session,'bootp_properties',$ibap_object_ref);
	}

        ibap_i2o_common_dhcp_props($self,$session,'common_properties',$ibap_object_ref);

	#
	#
	#

	if (defined $$ibap_object_ref{'use_ms_options'}) {
		$self->{'use_ms_options'}=$$ibap_object_ref{'use_ms_options'};
		if ($$ibap_object_ref{'use_ms_options'} != 1) {
			delete $self->{'ms_options'};
		}
	}

	if (defined $$ibap_object_ref{'use_enable_ddns'}) {
		$self->{'use_enable_ddns'}=$$ibap_object_ref{'use_enable_ddns'};
		if ($$ibap_object_ref{'use_enable_ddns'} != 1) {
			delete $self->{'enable_ddns'};
		}
	}

	if (defined $$ibap_object_ref{'use_generate_hostname'}) {
		$self->{'use_generate_hostname'}=$$ibap_object_ref{'use_generate_hostname'};
		if ($$ibap_object_ref{'use_generate_hostname'} != 1) {
			delete $self->{'ddns_generate_hostname'};
		}
	}

	if (defined $$ibap_object_ref{'use_recycle_leases'}) {
		$self->{'use_recycle_leases'}=$$ibap_object_ref{'use_recycle_leases'};
		if ($$ibap_object_ref{'use_recycle_leases'} != 1) {
			delete $self->{'recycle_leases'};
		}
	}

	if (defined $$ibap_object_ref{'server_association_type'}) {
		$self->{'server_association_type'}=$$ibap_object_ref{'server_association_type'};
        #
        #
        #
        $self->{'failover_assoc'} = ibap_i2o_range_failover($self, $session, 'failover_association', $ibap_object_ref, $return_object_cache_ref) if $ibap_object_ref->{'failover_association'};
        $self->{'member'} = ibap_i2o_mixed_member($self, $session, 'member', $ibap_object_ref, $return_object_cache_ref) if $ibap_object_ref->{'member'};

		if ($$ibap_object_ref{'server_association_type'} ne 'FAILOVER' && $$ibap_object_ref{'server_association_type'} ne 'MS_FAILOVER') {
			delete $self->{'failover_assoc'};
		}
		if ($$ibap_object_ref{'server_association_type'} ne 'MEMBER' && $$ibap_object_ref{'server_association_type'} ne 'MS_SERVER') {
			delete $self->{'member'};
		}
	}

    if (defined $$ibap_object_ref{'use_enable_thresholds'}) {
        $self->{'use_enable_thresholds'}=$$ibap_object_ref{'use_enable_thresholds'};
        if ($$ibap_object_ref{'use_enable_thresholds'} != 1) {
            delete $self->{'enable_dhcp_thresholds'};
        }
    }

    if (defined $$ibap_object_ref{'use_threshold_email_addresses'}) {
        $self->{'use_threshold_email_addresses'}=$$ibap_object_ref{'use_threshold_email_addresses'};
        if ($$ibap_object_ref{'use_threshold_email_addresses'} != 1) {
            $self->email_list(undef);
        }
	}

	if (defined $$ibap_object_ref{'use_is_authoritative'}) {
		$self->{'use_is_authoritative'}=$$ibap_object_ref{'use_is_authoritative'};
		if ($$ibap_object_ref{'use_is_authoritative'} != 1) {
			delete $self->{'authority'};
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
    $self->{'override_ddns_domainname'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_domainname'});
    $self->{'override_enable_ifmap_publishing'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_ifmap_publishing'});
    $self->{'override_lease_scavenge_time'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_client_association_grace_period'});
    $self->{'override_update_dns_on_lease_renewal'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_update_dns_on_lease_renewal'});
    $self->{'override_ignore_id'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ignore_id'});
    $self->{'override_enable_discovery'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_member_enable_discovery'});
    $self->{'override_discovery_basic_poll_settings'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_basic_polling_settings'});
    $self->{'override_blackout_setting'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_blackout_setting'});
    $self->{'override_logic_filters'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_option_logic_filters'});
    $self->{'override_subscribe_settings'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_subscribe_settings'});

    return;
}

#
#
#

sub __o2i_email__
{
        my ($self, $session, $current, $tempref) = @_;
        my @return_args;

        if (defined $$tempref{$current}) {
                if (ref ($$tempref{$current}) eq 'ARRAY') {
                        my @emails;
                        my @list=@{$$tempref{$current}};

                        foreach (@list) {
                            return unless my $s = ibap_value_o2i_string($_,'email address',$session);
                            push @emails, tIBType('email_address',
                                              { email_address => $s });
                        }
                        push @return_args, 1;
                        push @return_args, 0;
                        push @return_args, tIBType('ib:ArrayOfemail_address', \@emails);
                } else {
                        push @return_args, 0;
                }
        }
        else {
                push @return_args, 1;
                push @return_args, 0;
                push @return_args, tIBType('ib:ArrayOfemail_address', []);
        }

        return @return_args;
}

sub __object_to_ibap__
{
	my ($self, $server, $session) = @_;
	$self->{ '__internal_session_cache_ref__' } = \$session;

	my @write_fields;

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
				return;
			}
		} else {
			return;
		}
		unshift @write_fields, \%write_arg;
	}

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

sub authority
{
    my $self  = shift;
    return $self->__accessor_scalar__({deprecated => 1}, @_);
}

sub always_update_dns
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'always_update_dns', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ignore_dhcp_option_list_request
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ignore_dhcp_option_list_request', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_ignore_client_requested_options'}}, @_);
}

sub deny_bootp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'deny_bootp', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_deny_bootp'}}, @_);
}

sub options
{
    my $self  = shift;
    return ibap_accessor_dhcp_options($self, 'options', @_);
}

sub email_list { 
    my $self=shift; 
    return $self->__accessor_array__({name => 'email_list', validator => { 'string' => \&ibap_value_o2i_string }, use => \$self->{'use_threshold_email_addresses'}}, @_);
}

sub enable_ifmap_publishing
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'enable_ifmap_publishing', validator => \&ibap_value_o2i_boolean, use => \$self->{'override_enable_ifmap_publishing'}, use_truefalse => 1}, @_);
}

sub override_enable_ifmap_publishing
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_enable_ifmap_publishing', validator => \&ibap_value_o2i_boolean}, @_);
}

sub is_split_scope
{
    my $self  = shift;
    return $self->__accessor_scalar__({readonly => 1, name => 'is_split_scope', validator => \&ibap_value_o2i_boolean}, @_);
}

sub bootfile
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'bootfile', validator => \&ibap_value_o2i_string, use => \$self->{'use_boot_file'}}, @_);
}

sub nextserver
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'nextserver', validator => \&ibap_value_o2i_string, use => \$self->{'use_next_server'}}, @_);
}

sub bootserver
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'bootserver', validator => \&ibap_value_o2i_string, use => \$self->{'use_boot_server'}}, @_);
}

sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub ms_options
{
    my $self=shift;
    return $self->__accessor_array__({name => 'ms_options', validator => { 'Infoblox::DHCP::MSOption' => 1 }, use => \$self->{'use_ms_options'}}, @_);
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub range_high_water_mark
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_high_water_mark', validator => \&ibap_value_o2i_uint}, @_);
}

sub range_high_water_mark_reset
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_high_water_mark_reset', validator => \&ibap_value_o2i_uint}, @_);
}

sub range_low_water_mark
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_low_water_mark', validator => \&ibap_value_o2i_uint}, @_);
}

sub range_low_water_mark_reset
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_low_water_mark_reset', validator => \&ibap_value_o2i_uint}, @_);
}

sub server_association_type
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'server_association_type', enum => ['NONE', 'MEMBER', 'FAILOVER', 'MS_SERVER', 'MS_FAILOVER'] }, @_);
}

sub pxe_lease_time
{
    my $self  = shift;
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

sub enable_ddns
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_ddns', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_enable_ddns'}}, @_);
}

sub ddns_domainname
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ddns_domainname', validator => \&ibap_value_o2i_string, use => \$self->{'override_ddns_domainname'}, use_truefalse => 1}, @_);
}

sub override_ddns_domainname
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_ddns_domainname', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_lease_scavenge_time
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_lease_scavenge_time', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_email_warnings
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_email_warnings', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_dhcp_thresholds
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_dhcp_thresholds', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_enable_thresholds'}}, @_);
}

sub enable_snmp_warnings
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_snmp_warnings', validator => \&ibap_value_o2i_boolean}, @_);
}

sub network
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'network', validator => {'string' => \&ibap_value_o2i_string, 'Infoblox::DHCP::Network' => 1 }}, @_);
}

sub network_view
{
    my $self = shift;

    return $self->__accessor_scalar__({name => 'network_view', validator => { 'Infoblox::DHCP::View' => 1 }}, @_);
}

sub template
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'template', validator => \&ibap_value_o2i_string}, @_);
}

sub ddns_generate_hostname
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ddns_generate_hostname', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_generate_hostname'}}, @_);
}

sub deny_all_clients
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'deny_all_clients', validator => \&ibap_value_o2i_boolean}, @_);
}

sub recycle_leases
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'recycle_leases', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_recycle_leases'}}, @_);
}

sub start_addr
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'start_addr', validator => \&ibap_value_o2i_string}, @_);
}

sub end_addr
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'end_addr', validator => \&ibap_value_o2i_string}, @_);
}

sub exclude
{
    my $self = shift;

    return $self->__accessor_array__({name => 'exclude', validator => { 'Infoblox::DHCP::ExclusionRange' => 1 }}, @_);
}

sub failover_assoc
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'failover_assoc' };
    }
    else
    {
        my $value = shift;
        #
        #
        if ((not defined $value) || $value eq '') {
            if (not defined $self->member()) {
                $self->{ 'server_association_type' } = 'NONE';
            }
        }
        else
        {
            $self->{ 'server_association_type' } = 'FAILOVER';
            $self->{ 'member' } = undef;
		}
        $self->{ 'failover_assoc' } = $value;
	}
	return 1;
}

sub lease_scavenge_time
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'lease_scavenge_time', use => \$self->{'override_lease_scavenge_time'}, use_truefalse => 1, validator => \&ibap_value_o2i_int},@_);
}

sub member
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'member' };
    }
    else
    {
        my $value = shift;
        #
        #
        if ((not defined $value) || $value eq '') {
            if (not defined $self->failover_assoc()) {
                $self->{ 'server_association_type' } = 'NONE';
            }
            $self->{ 'member' } = $value;
        }
        else
        {
            if( Infoblox::Util::check_object_type( $value , [ 'Infoblox::DHCP::Member', 'Infoblox::Grid::Member' ] ))
            {
                $self->{ 'member' } = $value;
				$self->{ 'server_association_type' } = 'MEMBER';
				$self->{ 'failover_assoc' } = undef;
            } elsif (Infoblox::Util::check_object_type( $value , [ 'Infoblox::DHCP::MSServer' ] )) {
                $self->{ 'member' } = $value;
				$self->{ 'server_association_type' } = 'MS_SERVER';
				$self->{ 'failover_assoc' } = undef;
            }
            else
            {
				set_error_codes(1104,'Invalid data type for member member.' );
                return;
            }
        }
    }
    return 1;
}

sub filters
{
    my $self = shift;

    return $self->__accessor_array__({name => 'filters', validator => { 'Infoblox::DHCP::FilterRule::MAC' => 1, 'Infoblox::DHCP::FilterRule::NAC' => 1, 'Infoblox::DHCP::FilterRule::RelayAgent' => 1, 'Infoblox::DHCP::FilterRule::Option' => 1, 'Infoblox::DHCP::FilterRule::Fingerprint' => 1 }}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
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

sub split_member
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'split_member', validator => {'Infoblox::DHCP::MSServer' => 1}}, @_);
}

sub split_scope_exclusion_percent
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'split_scope_exclusion_percent', validator => \&ibap_value_o2i_uint}, @_);
}

sub enable_known_clients_option
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_known_clients_option', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_unknown_clients_option
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_unknown_clients_option', validator => \&ibap_value_o2i_boolean}, @_);
}

sub known_clients_option
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'known_clients_option', enum => ['Allow','Deny'] }, @_);
}

sub unknown_clients_option
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'unknown_clients_option', enum => ['Allow','Deny'] }, @_);
}

sub update_dns_on_lease_renewal 
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'update_dns_on_lease_renewal', validator => \&ibap_value_o2i_boolean, use => \$self->{'override_update_dns_on_lease_renewal'}, use_truefalse => 1}, @_);
}

sub override_update_dns_on_lease_renewal 
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_update_dns_on_lease_renewal', validator => \&ibap_value_o2i_boolean}, @_);
}

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

package Infoblox::DHCP::OrderedRanges;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members %_return_field_overrides
             @_return_fields %_searchable_fields %_object_to_ibap
             %_name_mappings %_reverse_name_mappings %_ibap_to_object
             $_return_fields_initialized %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'OrderedDhcpRanges';
    register_wsdl_type('ib:OrderedDhcpRanges', 'Infoblox::DHCP::OrderedRanges');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members = (
                         network => 1,
                         ranges  => 1,
                        );

    %_return_field_overrides = (
                                network => [],
                                ranges  => [],
                               );

    %_searchable_fields = (
						   network     => [\&ibap_o2i_network      ,'network'        , 'EXACT'],
                          );

    %_name_mappings = (
                      );

    %_reverse_name_mappings = (
                              );

    %_ibap_to_object = (
                        'network' => \&ibap_i2o_generic_object_convert,
                        'ranges'  => \&ibap_i2o_generic_object_list_convert,
                       );

    %_object_to_ibap = (
						'network' => \&ibap_o2i_network,
						'ranges'  => \&__o2i_ranges__,
                       );
    $_return_fields_initialized=0;
    @_return_fields = (
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

        my $tmp=Infoblox::DHCP::Network->__new__();
        push @_return_fields, tField('network', {
                                                 sub_fields => $tmp->__return_fields__(),
                                                }
                                    );

        $tmp=Infoblox::DHCP::Range->__new__();
        push @_return_fields, tField('ranges', {
                                                 sub_fields => $tmp->__return_fields__(),
                                               }
                                    );
    }

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                             \%_reverse_name_mappings,
                                             \%_searchable_fields,
                                             \%_ibap_to_object,
                                             \%_object_to_ibap,
                                             \@_return_fields,
                                             \%_return_field_overrides);

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

#
#
#

sub __search_override_hook__ {
    my ($object_type, $session, $args_ref) = @_;
    set_error_codes(1008, "'search' not allowed for this object", $session);
    return;
}

sub __remove_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'remove' not allowed for this object", $session);
    return;
}

#
#
#

sub __o2i_ranges__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
        if (ref ($$tempref{$current}) eq 'ARRAY') {
            my @ranges;
            my @list=@{$$tempref{$current}};

            foreach my $t (@list) {
                if ($t->__object_id__) {
                    push @ranges, tObjIdRef($t->__object_id__());
                }
                else {
                    my @fields = (
                                  {
                                   'search_type' => 'EXACT',
                                   'field'       => 'start_address',
                                   'value'       => ibap_value_o2i_string($t->start_addr()),
                                  },
                                  {
                                   'search_type' => 'EXACT',
                                   'field'       => 'end_address',
                                   'value'       => ibap_value_o2i_string($t->end_addr()),
                                  },
                                 );

                    if ($t->network_view()) {
                        push @fields,
                          {
                           'search_type' => 'EXACT',
                           'field'       => 'network_view',
                           'value'       => ibap_readfield_simple_string('NetworkView','name',$t->network_view()->name(),'network_view'),
                          };
                    } else {
                        push @fields,
                          {
                           'search_type' => 'EXACT',
                           'field'       => 'network_view',
                           'value'       => ibap_readfield_simple('NetworkView','is_default',tBool(1),'network_view=(default network view)'),
                          };
                    }

                    push @ranges, ibap_readfield_simple('DhcpRange', \@fields, undef, 'start_addr='.$t->start_addr().','.'end_addr='.$t->end_addr());
                }

            }
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType('ib:ArrayOfBaseObject', \@ranges);
        } else {
            push @return_args, 0;
        }
    } else {
        push @return_args, 1;
        push @return_args, 0;
        push @return_args, tIBType('ib:ArrayOfBaseObject', []);
    }

    return @return_args;
}

#
#
#

sub ranges
{
    my $self=shift;
    return $self->__accessor_array__({name => 'ranges', validator => { 'Infoblox::DHCP::Range' => 1 }}, @_);
}

sub network
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'network', validator => { 'Infoblox::DHCP::Network' => 1 }}, @_);
}

1;
