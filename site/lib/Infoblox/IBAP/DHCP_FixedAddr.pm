package Infoblox::DHCP::FixedAddr;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields @_optional_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object $_return_fields_initialized @_sub_host_address_fields %_return_field_overrides %_capabilities $newhostaddress);
@ISA = qw (Infoblox::IBAPBase);


BEGIN {
    $_object_type = 'FixedAddress';
    register_wsdl_type('ib:FixedAddress','Infoblox::DHCP::FixedAddr');

    $newhostaddress = Infoblox::__options('hostaddress');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members = (
                         always_update_dns                  => 0,
                         agent_circuit_id                   => 0,
                         agent_remote_id                    => 0,
                         bootfile 					        => 0,
                         bootserver 					    => 0,
                         client_identifier_prepend_zero     => 0,
                         comment 						    => 0,
                         configure_for_dhcp				    => 0,
                         deny_bootp 					    => 0,
                         ddns_domainname                    => 0,
                         override_ddns_domainname           => 0,
                         ddns_hostname                      => 0,
                         dhcp_client_identifier 		    => 0,
                         disable 						    => 0,
                         enable_ddns 					    => 0,
                         ignore_dhcp_option_list_request    => 0,
                         ipv4addr 					        => 0,
                         last_discovered 					=> 0,
                         mac 						        => 0,
                         match_client 				        => 0,
                         member                             => 0,
                         ms_options                         => {validator => {'Infoblox::DHCP::MSOption' => 1}, skip_accessor => 1},
                         name                               => 0,
                         netbios 						    => -1,
                         network 						    => 0,
                         nextserver 					    => 0,
                         options 						    => 0,
                         os 						        => -1,
                         pxe_lease_time 				    => 0,
                         template 				            => 0,
                         network_view 				        => 0,
                         extattrs                           => 0,
                         extensible_attributes              => 0,
                         network_component_type             => -1,
                         network_component_name             => -1,
                         network_component_description      => -1,
                         network_component_ip               => -1,
                         network_component_port_number      => -1,
                         network_component_port_name        => -1,
                         network_component_port_description => -1,
                         port_vlan_name                     => -1,
                         port_vlan_description              => -1,
                         port_vlan_number                   => -1,
                         port_speed                         => -1,
                         port_duplex                        => -1,
                         port_status                        => -1,
                         port_link_status                   => -1,
                         first_discovered                   => -1,
                         discovered_name                    => -1,
                         discovered_mac                     => -1,
                         discoverer                         => -1,
                         v_cluster                          => -1,
                         v_datacenter                       => -1,
                         v_host                             => -1,
                         v_name                             => -1,
                         v_netadapter                       => -1,
                         v_switch                           => -1,
                         v_type                             => -1,
                         discovered_data                    => -1,
                         is_invalid_mac                     => -1,
                         disable_discovery                  => {validator => \&ibap_value_o2i_boolean},
                         enable_immediate_discovery         => {writeonly => 1, validator => \&ibap_value_o2i_boolean},
                         snmp_credential                    => {validator => {'Infoblox::Grid::Discovery::SNMPCredential' => 1}, skip_accessor => 1}, # The method is defined in the package. This is necessary for ibap_o2i_generic_struct_convert.
                         snmp3_credential                   => {validator => {'Infoblox::Grid::Discovery::SNMP3Credential' => 1}, skip_accessor => 1}, # The method is defined in the package. This is necessary for ibap_o2i_generic_struct_convert.
                         cli_credentials                    => {'array' => 1, validator => {'Infoblox::Grid::Discovery::CLICredential' => 1}, 'use' => 'override_cli_credentials', 'use_truefalse' => 1},
                         override_credential                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_snmp3_credential          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_cli_credentials           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         reserved_interface                 => {validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}},
                         device_type                        => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         device_vendor                      => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         device_location                    => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         device_description                 => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         allow_telnet                       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         discover_now_status                => {simple => 'asis', readonly => 1},
                         cloud_info                         => {readonly => 1, validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
                         ms_ad_user_data                    => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
                         logic_filters                 => {array => 1, validator => {string => 1, 'Infoblox::DHCP::Filter::MAC' => 1,
                                                           'Infoblox::DHCP::Filter::NAC' => 1, 'Infoblox::DHCP::Filter::Option' => 1},
                                                           use => 'override_logic_filters', use_truefalse => 1},
                         override_logic_filters        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
						   comment => [\&ibap_o2i_string       ,'comment'     , 'REGEX', 'IGNORE_CASE'],
						   mac      => [\&ibap_o2i_string ,'mac_address'   , 'REGEX'],
						   dhcp_client_identifier => [\&ibap_o2i_string ,'dhcp_client_identifier'   , 'REGEX'],
						   agent_circuit_id => [\&ibap_o2i_string ,'circuit_id'   , 'REGEX'],
						   agent_remote_id => [\&ibap_o2i_string ,'remote_id'   , 'REGEX'],
						   ipv4addr => [\&ibap_o2i_string ,'ip_address'   , 'REGEX'],
						   last_discovered => [\&ibap_o2i_substruct_exact_datetime_search ,'last_discovered', 'SUBMATCHSTRUCT_discovered_data'],
						   netbios => [\&ibap_o2i_substruct_search ,'netbios_name', 'SUBMATCHSTRUCT_discovered_data'],
						   name        => [\&ibap_o2i_string       ,'name'          , 'REGEX'],
						   network  => [\&ibap_o2i_network ,'parent'   , 'SEARCHONLY_LIST_CONTAIN'],
                           network_view => [\&ibap_o2i_network_view ,'network_view', 'EXACT'],
						   os => [\&ibap_o2i_substruct_search ,'os', 'SUBMATCHSTRUCT_discovered_data'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           network_component_type => [\&ibap_o2i_substruct_search ,'network_component_type', 'SUBMATCHSTRUCT_discovered_data'],
                           network_component_name => [\&ibap_o2i_substruct_search ,'network_component_name', 'SUBMATCHSTRUCT_discovered_data'],
                           network_component_description => [\&ibap_o2i_substruct_search ,'network_component_description', 'SUBMATCHSTRUCT_discovered_data'],
                           network_component_ip => [\&ibap_o2i_substruct_search ,'network_component_ip', 'SUBMATCHSTRUCT_discovered_data'],
                           network_component_port_number => [\&ibap_o2i_substruct_exact_int_search ,'network_component_port_number', 'SUBMATCHSTRUCT_discovered_data'],
                           network_component_port_name => [\&ibap_o2i_substruct_search ,'network_component_port_name', 'SUBMATCHSTRUCT_discovered_data'],
                           network_component_port_description => [\&ibap_o2i_substruct_search ,'network_component_port_description', 'SUBMATCHSTRUCT_discovered_data'],
                           port_vlan_name => [\&ibap_o2i_substruct_search ,'port_vlan_name', 'SUBMATCHSTRUCT_discovered_data'],
                           port_vlan_description => [\&ibap_o2i_substruct_search ,'port_vlan_description', 'SUBMATCHSTRUCT_discovered_data'],
                           port_vlan_number => [\&ibap_o2i_substruct_exact_int_search ,'port_vlan_number', 'SUBMATCHSTRUCT_discovered_data'],
                           port_speed => [\&ibap_o2i_substruct_exact_search ,'port_speed', 'SUBMATCHSTRUCT_discovered_data'],
                           port_duplex => [\&ibap_o2i_substruct_exact_search ,'port_duplex', 'SUBMATCHSTRUCT_discovered_data'],
                           port_status => [\&ibap_o2i_substruct_exact_search ,'port_status', 'SUBMATCHSTRUCT_discovered_data'],
                           port_link_status => [\&ibap_o2i_substruct_exact_search ,'port_link_status', 'SUBMATCHSTRUCT_discovered_data'],
                           v_cluster => [\&ibap_o2i_substruct_search, 'v_cluster', 'SUBMATCHSTRUCT_discovered_data'],
                           v_datacenter => [\&ibap_o2i_substruct_search, 'v_datacenter', 'SUBMATCHSTRUCT_discovered_data'],
                           v_host => [\&ibap_o2i_substruct_search, 'v_host', 'SUBMATCHSTRUCT_discovered_data'],
                           v_netadapter => [\&ibap_o2i_substruct_search, 'v_adapter', 'SUBMATCHSTRUCT_discovered_data'],
                           v_switch => [\&ibap_o2i_substruct_search, 'v_switch', 'SUBMATCHSTRUCT_discovered_data'],
                           v_name => [\&ibap_o2i_substruct_search, 'v_entity_name', 'SUBMATCHSTRUCT_discovered_data'],
                           v_type => [\&ibap_o2i_substruct_exact_v_type_search, 'v_entity_type', 'SUBMATCHSTRUCT_discovered_data'],
                           first_discovered => [\&ibap_o2i_substruct_exact_datetime_search ,'first_discovered', 'SUBMATCHSTRUCT_discovered_data'],
                           discovered_name => [\&ibap_o2i_substruct_search ,'discovered_name', 'SUBMATCHSTRUCT_discovered_data'],
                           discoverer => [\&ibap_o2i_substruct_search ,'discoverer', 'SUBMATCHSTRUCT_discovered_data'],
                           discovered_data => [\&Infoblox::Grid::Discovery::Data::__o2i_search_discovered_data__, 'discovered_data', 'EXACT'],

                           #
                           no_hostaddresses => [\&ibap_o2i_ignore, 'deprecated', 'DEPRECATED'],
                          );

    %_name_mappings = (
                       'agent_circuit_id'               => 'circuit_id',
                       'agent_remote_id'                => 'remote_id',
					   'client_identifier_prepend_zero' => 'prepend_zero',
					   'disable'                        => 'disabled',
                       'extattrs'                       => 'extensible_attributes',
					   'ipv4addr'                       => 'ip_address',
					   'mac'                            => 'mac_address',
					   'match_client'                   => 'match_option',
					   'netbios'                        => 'netbios_name',
					   'network'                        => 'parent',
                       'v_name'                         => 'v_entity_name',
                       'v_netadapter'                   => 'v_adapter',
                       'v_type'                         => 'v_entity_type',
                       'member'                         => 'ms_server',
                       'override_ddns_domainname'       => 'use_ddns_domainname',
                       'disable_discovery'              => 'enable_discovery',
                       'snmp_credential'                => 'snmpv1v2_credential',
                       'snmp3_credential'               => 'snmpv3_credential',
                       'override_snmp3_credential'      => 'use_snmpv3_credential',
                       'logic_filters'                  => 'option_logic_filters',
                       'override_logic_filters'         => 'use_option_logic_filters',
					  );

    %_reverse_name_mappings = reverse %_name_mappings;
    #
    $_reverse_name_mappings{'_discovered_mac_address'} = 'discovered_mac';

    %_ibap_to_object = (
                        'always_update_dns'     => \&ibap_i2o_boolean,
						'disabled' 	   			=> \&ibap_i2o_boolean,
						'enable_ddns'  			=> \&ibap_i2o_boolean,
						'match_option' 			=> \&ibap_i2o_match_options,
                        'ms_options'            => \&ibap_i2o_generic_object_list_convert,
						'ms_server' 			=> \&ibap_i2o_mixed_member,
                        'network_view'          => \&ibap_i2o_generic_object_convert,
						'parent' 	   			=> \&__i2o_network__,
						'prepend_zero' 			=> \&ibap_i2o_boolean,
                        'discovered_data'       => \&ibap_i2o_generic_object_convert,
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'use_ddns_domainname'   => \&ibap_i2o_boolean,
                        'enable_discovery'      => \&ibap_i2o_boolean_reverse,
                        'snmpv1v2_credential'   => \&ibap_i2o_generic_object_convert,
                        'snmpv3_credential'     => \&ibap_i2o_generic_object_convert,
                        'cli_credentials'       => \&ibap_i2o_generic_object_list_convert,
                        'override_credential'   => \&ibap_i2o_boolean,
                        'use_snmpv3_credential' => \&ibap_i2o_boolean,
                        'reserved_interface'    => \&ibap_i2o_generic_object_convert,
                        'is_invalid_mac'        => \&ibap_i2o_boolean,
                        'cloud_info'            => \&ibap_i2o_generic_object_convert,
                        'ms_ad_user_data'       => \&ibap_i2o_generic_object_convert,
                        'option_logic_filters'     => \&ibap_i2o_ordered_filters,
                        'use_option_logic_filters' => \&ibap_i2o_boolean,
					   );

	%_return_field_overrides = (
								'allow_query' => ['use_allow_query'],
                                'agent_circuit_id'                    => [],
                                'agent_remote_id'                     => [],
								'always_update_dns'                   => [],
								'bootfile'						  	  => ['!bootp_properties'],
								'bootserver'					      => ['!bootp_properties'],
								'client_identifier_prepend_zero'      => [],
								'comment'					   	  	  => [],
								'configure_for_dhcp' 				  => [],
                                'ddns_domainname'                     => ['use_ddns_domainname'],
                                'override_ddns_domainname'             => [],
								'ddns_hostname'                       => [],
								'deny_bootp'					      => ['!bootp_properties'],
								'dhcp_client_identifier'              => [],
								'disable'					   	  	  => [],
								'enable_ddns'				   	  	  => ['use_enable_ddns'],
                                'extattrs'                            => [],
								'extensible_attributes'               => [],
								'ignore_dhcp_option_list_request' 	  => ['use_ignore_client_requested_options'],
								'ipv4addr'					   	  	  => [],
								'last_discovered' 				   	  => ['!discovered_data'],
								'mac' 							  	  => [],
								'match_client' 				   	      => [],
                                'ms_options'                          => ['use_ms_options'],
                                'member'                              => [],
                                'name'                                => [],
								'netbios'					   	  	  => ['!discovered_data'],
								'network'					   	  	  => [],
								'network_view'                        => [],
								'nextserver'					      => ['!bootp_properties'],
								'options'					   	  	  => ['!common_properties'],
								'os'					   	          => ['!discovered_data'],
								'pxe_lease_time'				      => ['!common_properties'],
								'template'					   	  	  => [],
                                network_component_type => ['!discovered_data'],
                                network_component_name => ['!discovered_data'],
                                network_component_description => ['!discovered_data'],
                                network_component_ip => ['!discovered_data'],
                                network_component_port_number => ['!discovered_data'],
                                network_component_port_name => ['!discovered_data'],
                                network_component_port_description => ['!discovered_data'],
                                port_vlan_name => ['!discovered_data'],
                                port_vlan_description => ['!discovered_data'],
                                port_vlan_number => ['!discovered_data'],
                                port_speed => ['!discovered_data'],
                                port_duplex => ['!discovered_data'],
                                port_status => ['!discovered_data'],
                                port_link_status => ['!discovered_data'],
                                first_discovered => ['!discovered_data'],
                                discovered_name => ['!discovered_data'],
                                discoverer => ['!discovered_data'],
                                v_cluster => ['!discovered_data'],
                                v_datacenter => ['!discovered_data'],
                                v_host => ['!discovered_data'],
                                v_name => ['!discovered_data'],
                                v_netadapter => ['!discovered_data'],
                                v_switch => ['!discovered_data'],
                                v_type => ['!discovered_data'],
                                is_invalid_mac        => [],
								discovered_mac => ['!discovered_data'],
                                discovered_data => [],
                                disable_discovery          => [],
                                snmp_credential            => ['override_credential', 'snmp3_credential', 'use_snmpv3_credential'],
                                snmp3_credential           => ['override_credential', 'use_snmpv3_credential'],
                                cli_credentials            => ['override_cli_credentials'],
                                override_credential        => [],
                                override_snmp3_credential  => [],
                                override_cli_credentials   => [],
                                reserved_interface         => [],
                                device_type                => [],
                                device_vendor              => [],
                                device_location            => [],
                                device_description         => [],
                                allow_telnet               => [],
                                discover_now_status        => [],
                                cloud_info                 => [],
                                ms_ad_user_data            => [],
                                logic_filters              => ['use_option_logic_filters'],
                                override_logic_filters     => [],
							   );

    %_object_to_ibap = (
                        'always_update_dns'               => \&ibap_o2i_boolean,
                        'agent_circuit_id'                => \&ibap_o2i_string,
                        'agent_remote_id'                 => \&ibap_o2i_string,
						'bootfile'                        => \&ibap_o2i_ignore,
						'bootserver'                      => \&ibap_o2i_ignore,
						'client_identifier_prepend_zero'  => \&ibap_o2i_boolean,
						'comment'                         => \&ibap_o2i_string,
						'configure_for_dhcp'              => \&ibap_o2i_ignore,
						'deny_bootp'                      => \&ibap_o2i_ignore,
                        'ddns_domainname'                 => \&ibap_o2i_string,
                        'ddns_hostname'                   => \&ibap_o2i_string,
						'dhcp_client_identifier'          => \&ibap_o2i_string_undef_to_empty,
						'disable'                         => \&ibap_o2i_boolean,
						'enable_ddns'                     => \&ibap_o2i_boolean,
                        'extattrs'                        => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'           => \&ibap_o2i_ignore,
						'ignore_dhcp_option_list_request' => \&ibap_o2i_ignore,
						'ipv4addr'                        => \&ibap_o2i_string,
						'last_discovered'                 => \&ibap_o2i_ignore,
						'mac'                             => \&ibap_o2i_string_undef_to_empty,
						'match_client'                    => \&ibap_o2i_match_options,
                        'ms_options'                      => \&ibap_o2i_generic_struct_list_convert,
                        'member'                          => \&ibap_o2i_mixed_member,
                        'name'                            => \&ibap_o2i_string,
						'netbios'                         => \&ibap_o2i_ignore,
						'network'                         => \&ibap_o2i_network,
                        'network_view'                    => \&ibap_o2i_network_view,
						'nextserver'                      => \&ibap_o2i_ignore,
						'options'                         => \&ibap_o2i_ignore,
						'os'                              => \&ibap_o2i_ignore,
						'pxe_lease_time'                  => \&ibap_o2i_ignore,
						'template'                        => \&ibap_o2i_fixed_address_template,
                        'override_logic_filters'          => \&ibap_o2i_boolean,
                        'logic_filters'                   => \&ibap_o2i_ordered_filters,

						#

						'use_enable_ddns' => \&ibap_o2i_boolean,
						'use_ms_options'  => \&ibap_o2i_boolean,

						#
						#
						#
						#

                        'override_ddns_domainname'             => \&ibap_o2i_boolean,
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
                        network_component_type => \&ibap_o2i_ignore,
                        network_component_name => \&ibap_o2i_ignore,
                        network_component_description => \&ibap_o2i_ignore,
                        network_component_ip => \&ibap_o2i_ignore,
                        network_component_port_number => \&ibap_o2i_ignore,
                        network_component_port_name => \&ibap_o2i_ignore,
                        network_component_port_description => \&ibap_o2i_ignore,
                        port_vlan_name => \&ibap_o2i_ignore,
                        port_vlan_description => \&ibap_o2i_ignore,
                        port_vlan_number => \&ibap_o2i_ignore,
                        port_speed => \&ibap_o2i_ignore,
                        port_duplex => \&ibap_o2i_ignore,
                        port_status => \&ibap_o2i_ignore,
                        port_link_status => \&ibap_o2i_ignore,
                        first_discovered => \&ibap_o2i_ignore,
                        discovered_name => \&ibap_o2i_ignore,
                        discoverer => \&ibap_o2i_ignore,
                        v_cluster => \&ibap_o2i_ignore,
                        v_datacenter => \&ibap_o2i_ignore,
                        v_host => \&ibap_o2i_ignore,
                        v_name => \&ibap_o2i_ignore,
                        v_netadapter => \&ibap_o2i_ignore,
                        v_switch => \&ibap_o2i_ignore,
                        v_type => \&ibap_o2i_ignore,
                        discovered_mac => \&ibap_o2i_ignore,
                        discovered_data => \&ibap_o2i_ignore,
                        disable_discovery          => \&ibap_o2i_boolean_reverse,
                        enable_immediate_discovery => \&ibap_o2i_boolean,
                        snmp_credential            => \&ibap_o2i_generic_struct_convert,
                        snmp3_credential           => \&ibap_o2i_generic_struct_convert,
                        cli_credentials            => \&ibap_o2i_generic_struct_list_convert,
                        override_credential        => \&ibap_o2i_boolean,
                        override_snmp3_credential  => \&ibap_o2i_boolean,
                        override_cli_credentials   => \&ibap_o2i_boolean,
                        reserved_interface         => \&ibap_o2i_object_only_by_oid_or_undef,
                        device_type                => \&ibap_o2i_string,
                        device_vendor              => \&ibap_o2i_string,
                        device_location            => \&ibap_o2i_string,
                        device_description         => \&ibap_o2i_string,
                        allow_telnet               => \&ibap_o2i_boolean,
                        discover_now_status        => \&ibap_o2i_ignore,
                        is_invalid_mac             => \&ibap_o2i_ignore,
                        cloud_info                 => \&ibap_o2i_ignore,
                        ms_ad_user_data            => \&ibap_o2i_ignore,

                        #
                        'use_snmp_credential'      => \&ibap_o2i_ignore,
                        'use_snmp3_credential'     => \&ibap_o2i_ignore,
					   );

    $_return_fields_initialized=0;
    @_return_fields = (
					   tField('always_update_dns'),
                       tField('circuit_id'),
                       tField('remote_id'),
					   tField('comment'),
					   tField('dhcp_client_identifier'),
					   tField('disabled'),
					   tField('enable_ddns'),
					   tField('ip_address'),
					   tField('mac_address'),
					   tField('ms_options'),
					   tField('name'),
					   tField('match_option'),
					   tField('prepend_zero'),
					   tField('use_enable_ddns'),
					   tField('use_ms_options'),
                       tField('ddns_hostname'),
                       tField('ddns_domainname'),
                       tField('use_ddns_domainname'),
                       tField('enable_discovery'),
                       tField('snmpv1v2_credential', {'depth' => 1}),
                       tField('cli_credentials', {'depth' => 1}),
                       tField('override_credential'),
                       tField('use_snmpv3_credential'),
                       tField('override_cli_credentials'),
                       tField('ms_server',
                              { sub_fields => [tField('address'),
                                               tField('server_name')] }),
                       tField('device_type'),
                       tField('device_vendor'),
                       tField('device_location'),
                       tField('device_description'),
                       tField('allow_telnet'),
                       tField('is_invalid_mac'),
                       tField('use_option_logic_filters'),
                       tField('option_logic_filters', return_fields_option_logic_filters()),
                      );

    push @_return_fields, tField('discovered_data',
                                 {
                                  depth => 1
                                 }
                                );

    push @_return_fields, tField('common_properties',
                                 {
                                  depth => 2
                                 }
                                );

    push @_return_fields, tField('bootp_properties',
                                 {
                                  depth => 1
                                 }
                                );

    push @_return_fields, return_fields_extensible_attributes();

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

        my $tmp = Infoblox::DHCP::View->__new__();
        @_sub_host_address_fields = (
                                     tField('address'),
                                     tField('mac_address'),
                                     tField('network',
                                            {
                                             sub_fields => [
                                                            tField('address'),
                                                            tField('cidr'),
                                                            tField('network_view',
                                                                   {
                                                                    default_no_access_ok => 1,
                                                                    sub_fields           => $tmp->__return_fields__(),
                                                                   }
                                                                  )
                                                           ]
                                            }
                                           ),
                                     tField('use_pxe_lease_time'),
                                     tField('pxe_lease_time'),
                                     tField('use_custom_options'),
                                     tField('custom_options'),
                                     tField('use_ignore_dhcp_param_request_list'),
                                     tField('ignore_dhcp_param_request_list'),
                                     tField('use_deny_bootp'),
                                     tField('deny_bootp'),
                                     tField('use_boot_file'),
                                     tField('boot_file'),
                                     tField('use_boot_server'),
                                     tField('boot_server'),
                                     tField('use_next_server'),
                                     tField('next_server'),
                                     tField('use_broadcast_address'),
                                     tField('broadcast_address'),
                                     tField('use_lease_time'),
                                     tField('lease_time'),
                                     tField('use_domain_name_servers'),
                                     tField('domain_name_servers'),
                                     tField('use_routers'),
                                     tField('routers'),
                                     tField('use_domain_name'),
                                     tField('domain_name'),
                                     tField('configure_for_dhcp'),
                                     tField('match_option'),
                                    );

        push @_return_fields,tField('network_view', {
                                                     default_no_access_ok => 1,
                                                     sub_fields           => $tmp->__return_fields__(),
                                                    });

        #
        Infoblox::DHCP::Network->__new__();
        push @_return_fields, tField('parent', {
                                                sub_fields => [
                                                               tField('address', {no_access_ok => 1}),
                                                               tField('cidr', {no_access_ok => 1}),
                                                              ],
                                               }
                                    );

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
	my ($self, $session, $object, $search_query_ref, $ref_ref_array_results, $return_fields, $cursor, $original_searchargsref) = @_;

    #
    return 1 if $newhostaddress;

    if ($original_searchargsref && defined $original_searchargsref->{'no_hostaddresses'} && $original_searchargsref->{'no_hostaddresses'} eq 'true') {
        if ($cursor) {
            $cursor->{'has_more'} = 0;
            return 0;
        }
        else {
            return 1;
        }
    }
    return fixedaddress_get_search_callback_helper($self, $session, $object, $search_query_ref, $ref_ref_array_results, $return_fields, $cursor,\@_sub_host_address_fields);
}

sub __search_mapping_hook_pre__
{
    my ($self, $session, $type, $argsref, $out_search_fields_ref, $out_search_types_ref, $out_search_matches_ref) = @_;

    #
    #
    #
    if( defined $argsref->{'mac'} &&
        $argsref->{'mac'} eq '00:00:00:00:00:00') {
        delete $argsref->{'mac'};
        $out_search_fields_ref->{'match_option'} = ibap_value_o2i_string('RESERVED');
	    $out_search_types_ref->{'match_option'} = 'EXACT';
	}

    return 1;
}

#
#
#

sub __i2o_network__
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
	my @newlist;

	if ($$ibap_object_ref{$current}) {
		my ($address,$netmask);

        $address = $$ibap_object_ref{$current}{'address'};
		return $address.'/'.$$ibap_object_ref{$current}{'cidr'};
	} else {
		return;
	}
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

	#
    foreach (
             'use_enable_ddns',
             'always_update_dns',
             'use_ddns_domainname',
             'enable_discovery',
             'override_credential',
             'use_snmpv3_credential',
             'override_cli_credentials',
             'allow_telnet',
             'is_invalid_mac',
             'use_option_logic_filters',
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

    $$ibap_object_ref{'use_ms_options'} = 0 unless defined $$ibap_object_ref{'use_ms_options'};

	#
    $self->{'__initializing_from_ibap__'} = 1;
	$self->last_discovered('');
	$self->netbios('');
	$self->os('');
    $self->v_cluster('');
    $self->v_datacenter('');
    $self->v_host('');
    $self->v_name('');
    $self->v_netadapter('');
    $self->v_switch('');
    $self->v_type('');
    $self->client_identifier_prepend_zero('false');
    $self->disable('false');

    $self->deny_bootp('false');
	$self->{ 'use_deny_bootp' } = 0;

    $self->enable_ddns('false');
	$self->{ 'use_enable_ddns' } = 0;

    $self->ignore_dhcp_option_list_request('false');
	$self->{ 'use_ignore_client_requested_options' } = 0;
    delete $self->{'__initializing_from_ibap__'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    $self->{'__initializing_from_ibap__'} = 1;
	if (defined $$ibap_object_ref{'bootp_properties'}) {
		ibap_i2o_bootp_props($self,$session,'bootp_properties',$ibap_object_ref);
	}

	if (defined $$ibap_object_ref{'common_properties'}) {
        ibap_i2o_common_dhcp_props($self,$session,'common_properties',$ibap_object_ref);
    }

    delete $self->{'__initializing_from_ibap__'};

    Infoblox::Grid::Discovery::Data::__init_discovered_members__($self);

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
    $self->{'override_credential'}=ibap_value_i2o_boolean($$ibap_object_ref{'override_credential'});
    $self->{'override_snmp3_credential'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_snmpv3_credential'});
    $self->{'override_cli_credentials'}=ibap_value_i2o_boolean($$ibap_object_ref{'override_cli_credentials'});
    $self->{'override_logic_filters'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_option_logic_filters'});

    #
    if ($self->{'override_credential'} eq 'true') {
        $self->{'use_snmp_credential'} = $self->{'override_snmp3_credential'} eq 'true' ? 0 : 1;
        $self->{'use_snmp3_credential'} = $self->{'override_snmp3_credential'} eq 'true' ? 1 : 0;
    }

	return;
}

#
#
#

sub __object_to_ibap__
{
	my ($self, $server, $session) = @_;

    my $write_fields = $self->SUPER::__object_to_ibap__($server, $session);

	unless (defined $self->{'dhcp_client_identifier'}) {
		unshift @$write_fields, {
						 'field' => 'dhcp_client_identifier',
						 'value' => tString(''),
						};
	}

	unless (defined $self->{'ipv4addr'}) {
		unshift @$write_fields, {
						 'field' => 'ip_address',
						 'value' => tString(''),
						};
	}

	unless (defined $self->{'mac'}) {
		unshift @$write_fields, {
						 'field' => 'mac_address',
						 'value' => tString(''),
						};
	}

	my @bootp_options = ibap_arg_bootp_props($self, $session, '', $self);
	if (@bootp_options) {
		my $success=shift @bootp_options;
		if ($success) {
			my $ignore_value=shift @bootp_options;
			unless ($ignore_value) {
				my %write_arg;
				$write_arg{'field'} = 'bootp_properties';
				$write_arg{'value'} = shift @bootp_options;
				unshift @$write_fields, \%write_arg;
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
				unshift @$write_fields, \%write_arg;
			}
		}
		else {
			return;
		}
	}

	return $write_fields;
}

#
#
#

sub always_update_dns
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'always_update_dns', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ignore_dhcp_option_list_request
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ignore_dhcp_option_list_request', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_ignore_client_requested_options'}}, @_);
}

sub agent_circuit_id
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'agent_circuit_id', validator => \&ibap_value_o2i_string}, @_);
}

sub agent_remote_id
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'agent_remote_id', validator => \&ibap_value_o2i_string}, @_);
}

sub deny_bootp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'deny_bootp', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_deny_bootp'}}, @_);
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

sub ddns_hostname{
   my $self  = shift;
    return $self->__accessor_scalar__({name => 'ddns_hostname', validator => \&ibap_value_o2i_string}, @_);
}


sub options
{
    my $self  = shift;
    return ibap_accessor_dhcp_options($self, 'options', @_);
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


sub configure_for_dhcp
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'configure_for_dhcp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub is_invalid_mac
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'is_invalid_mac', readonly => 1}, @_);
}

sub last_discovered
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'last_discovered', validator => \&ibap_value_o2i_string}, @_);
}

sub ms_options
{
    my $self=shift;
    return $self->__accessor_array__({name => 'ms_options', validator => { 'Infoblox::DHCP::MSOption' => 1 }, use => \$self->{'use_ms_options'}}, @_);
}

sub member
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'member', validator => { 'Infoblox::DHCP::MSServer' => 1 }}, @_);
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub netbios
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'netbios', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub os
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'os', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
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

sub match_client
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'match_client' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ 'match_client' } = undef;
        }
        else
        {
			if ($value !~ m/MAC|CLIENT_IDENTIFIER|RESERVED|CIRCUIT_ID|REMOTE_ID/i) {
				set_error_codes(1104,"Invalid value '$value' for member match_client." );
				return;
			}
			else {
				$self->{ 'match_client' } = $value;
			}
		}
	}
	return 1;
}

sub client_identifier_prepend_zero
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'client_identifier_prepend_zero', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dhcp_client_identifier
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'dhcp_client_identifier', validator => \&ibap_value_o2i_string}, @_);
}

sub mac
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'mac', validator => \&ibap_value_o2i_string}, @_);
}

sub ipv4addr
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv4addr', validator => \&ibap_value_o2i_string}, @_);
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
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'template', validator => \&ibap_value_o2i_string}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub network_component_type
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'network_component_type', readonly => 1}, @_);
}

sub network_component_name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'network_component_name', readonly => 1}, @_);
}

sub network_component_description
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'network_component_description', readonly => 1}, @_);
}

sub network_component_ip
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'network_component_ip', readonly => 1}, @_);
}

sub network_component_port_number
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'network_component_port_number', readonly => 1}, @_);
}

sub network_component_port_name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'network_component_port_name', readonly => 1}, @_);
}

sub network_component_port_description
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'network_component_port_description', readonly => 1}, @_);
}

sub port_vlan_name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'port_vlan_name', readonly => 1}, @_);
}

sub port_vlan_description
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'port_vlan_description', readonly => 1}, @_);
}

sub port_vlan_number
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'port_vlan_number', readonly => 1}, @_);
}

sub port_speed
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'port_speed', readonly => 1}, @_);
}

sub port_duplex
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'port_duplex', readonly => 1}, @_);
}

sub port_status
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'port_status', readonly => 1}, @_);
}

sub port_link_status
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'port_link_status', readonly => 1}, @_);
}

sub first_discovered
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'first_discovered', readonly => 1}, @_);
}

sub discovered_name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'discovered_name', readonly => 1}, @_);
}

sub discoverer
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'discoverer', readonly => 1}, @_);
}


sub v_cluster
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'v_cluster', readonly => 1}, @_);
}

sub v_datacenter
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'v_datacenter', readonly => 1}, @_);
}

sub v_host
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'v_host', readonly => 1}, @_);
}

sub v_name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'v_name', readonly => 1}, @_);
}

sub v_netadapter
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'v_netadapter', readonly => 1}, @_);
}

sub v_switch
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'v_switch', readonly => 1}, @_);
}

sub v_type
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'v_type', enum => ['VirtualCenter','HostSystem','VirtualMachine',''], readonly => 1}, @_);
}

sub discovered_mac
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'discovered_mac', readonly => 1}, @_);
}

sub discovered_data
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'discovered_data', readonly => 1, validator => {'Infoblox::Grid::Discovery::Data' => 1}}, @_);
}

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
