package Infoblox::Grid::Discovery::Data;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members
                 %_name_mappings %_reverse_name_mappings
                 %_enum_mappings %_reverse_enum_mappings
                 %_ibap_to_object %_object_to_ibap %_searchable_fields);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'discovered_data';
    register_wsdl_type('ib:discovered_data','Infoblox::Grid::Discovery::Data');

    %_allowed_members = (
                         'duid'                               => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'mac_address'                        => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'netbios'                            => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'os'                                 => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'device_model'                       => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'device_port_name'                   => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'device_port_type'                   => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'device_type'                        => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'device_vendor'                      => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'discovered_name'                    => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'discoverer'                         => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'first_discovered'                   => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string_to_datetime},
                         'last_discovered'                    => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string_to_datetime},
                         'mgmt_ip_address'                    => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_ipaddr},
                         'network_component_description'      => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'network_component_ip'               => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_ipaddr},
                         'network_component_model'            => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'network_component_name'             => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'network_component_port_description' => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'network_component_port_name'        => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'network_component_port_number'      => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'network_component_type'             => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'network_component_vendor'           => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'open_ports'                         => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'port_duplex'                        => {'simple' => 'asis', 'enum' => ['Full', 'Half']},
                         'port_link_status'                   => {'simple' => 'asis', 'enum' => ['Connected', 'Not Connected', 'Unknown']},
                         'port_speed'                         => {'simple' => 'asis', 'enum' => ['100G', '100M', '10G', '10M', '1G', 'Unknown']},
                         'port_status'                        => {'simple' => 'asis', 'enum' => ['Down', 'Unknown', 'Up']},
                         'port_type'                          => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'port_vlan_description'              => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'port_vlan_name'                     => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'port_vlan_number'                   => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'v_netadapter'                       => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'v_cluster'                          => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'v_datacenter'                       => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'v_name'                             => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'v_type'                             => {'enum' => ['VirtualCenter', 'HostSystem', 'VirtualMachine']},
                         'v_host'                             => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'v_os'                               => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'v_switch'                           => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'iprg_no'                            => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'iprg_type'                          => {'simple' => 'asis', 'enum' => ['HSRP', 'VRRP']},
                         'iprg_state'                         => {'simple' => 'asis', 'enum' => ['ACTIVE', 'NEGOTIATION', 'STANDBY', 'VIP']},
                         'cisco_ise_ssid'                      => {'simple' => 'asis', validator => \&ibap_value_o2i_string},
                         'cisco_ise_endpoint_profile'          => {'simple' => 'asis', validator => \&ibap_value_o2i_string},
                         'cisco_ise_session_state'             => {'simple' => 'asis', validator => \&ibap_value_o2i_string},
                         'cisco_ise_security_group'            => {'simple' => 'asis', validator => \&ibap_value_o2i_string},
                         'vmi_name'                           => {'simple' => 'asis'},
                         'vmi_id'                             => {'simple' => 'asis'},
                         'vmi_tenant_id'                      => {'simple' => 'asis'},
                         'vlan_port_group'                    => {'simple' => 'asis'},
                         'vswitch_name'                       => {'simple' => 'asis'},
                         'vswitch_id'                         => {'simple' => 'asis'},
                         'vswitch_type'                       => {'simple' => 'asis'},
                         'vswitch_ipv6_enabled'               => {'simple' => 'bool'},
                         'vport_name'                         => {'simple' => 'asis'},
                         'vport_mac_address'                  => {'simple' => 'asis'},
                         'vport_link_status'                  => {'simple' => 'asis'},
                         'vport_conf_speed'                   => {'simple' => 'asis'},
                         'vport_conf_mode'                    => {'simple' => 'asis'},
                         'vport_speed'                        => {'simple' => 'asis'},
                         'vport_mode'                         => {'simple' => 'asis'},
                         'vswitch_segment_type'               => {'simple' => 'asis'},
                         'vswitch_segment_name'               => {'simple' => 'asis'},
                         'vswitch_segment_id'                 => {'simple' => 'asis'},
                         'vswitch_segment_port_group'         => {'simple' => 'asis'},
                         'vswitch_available_ports_count'      => {'simple' => 'asis'},
                         'vswitch_tep_type'                   => {'simple' => 'asis'},
                         'vswitch_tep_ip'                     => {'simple' => 'asis'},
                         'vswitch_tep_port_group'             => {'simple' => 'asis'},
                         'vswitch_tep_vlan'                   => {'simple' => 'asis'},
                         'vswitch_tep_dhcp_server'            => {'simple' => 'asis'},
                         'vswitch_tep_multicast'              => {'simple' => 'asis'},
                         'vmhost_ip_address'                  => {'simple' => 'asis'},
                         'vmhost_name'                        => {'simple' => 'asis'},
                         'vmhost_mac_address'                 => {'simple' => 'asis'},
                         'vmhost_subnet_cidr'                 => {'simple' => 'asis'},
                         'vmhost_nic_names'                   => {'simple' => 'asis'},
                         'cmp_type'                           => {'simple' => 'asis'},
                         'vmi_ip_type'                        => {'simple' => 'asis'},
                         'vmi_private_address'                => {'simple' => 'asis'},
                         'vmi_is_public_address'              => {'simple' => 'bool'},
                         'task_name'                          => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'network_component_location'         => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'network_component_contact'          => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'device_location'                    => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'device_contact'                     => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'ap_name'                            => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'ap_ip_address'                      => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'ap_ssid'                            => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'bridge_domain'                      => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'endpoint_groups'                    => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'tenant'                             => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},

                         'cisco_ise_quarantine_status'         => {deprecated => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'netbios'      => 'netbios_name',
                       'v_name'       => 'v_entity_name',
                       'v_netadapter' => 'v_adapter',
                       'v_type'       => 'v_entity_type',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_enum_mappings = (
                       'VirtualCenter'  => 'VCENTER',
                       'HostSystem'     => 'VHOST',
                       'VirtualMachine' => 'VMACHINE',
                      );

    %_reverse_enum_mappings = reverse %_enum_mappings;

    %_ibap_to_object = (
                        'v_entity_type' => \&__i2o_v_type__,
                       );

    %_object_to_ibap = (
                        'duid'                               => \&ibap_o2i_ignore,
                        'mac_address'                        => \&ibap_o2i_ignore,
                        'netbios'                            => \&ibap_o2i_ignore,
                        'os'                                 => \&ibap_o2i_ignore,
                        'device_model'                       => \&ibap_o2i_ignore,
                        'device_port_name'                   => \&ibap_o2i_ignore,
                        'device_port_type'                   => \&ibap_o2i_ignore,
                        'device_type'                        => \&ibap_o2i_ignore,
                        'device_vendor'                      => \&ibap_o2i_ignore,
                        'discovered_name'                    => \&ibap_o2i_ignore,
                        'discoverer'                         => \&ibap_o2i_ignore,
                        'first_discovered'                   => \&ibap_o2i_ignore,
                        'last_discovered'                    => \&ibap_o2i_ignore,
                        'mgmt_ip_address'                    => \&ibap_o2i_ignore,
                        'network_component_description'      => \&ibap_o2i_ignore,
                        'network_component_ip'               => \&ibap_o2i_ignore,
                        'network_component_model'            => \&ibap_o2i_ignore,
                        'network_component_name'             => \&ibap_o2i_ignore,
                        'network_component_port_description' => \&ibap_o2i_ignore,
                        'network_component_port_name'        => \&ibap_o2i_ignore,
                        'network_component_port_number'      => \&ibap_o2i_ignore,
                        'network_component_type'             => \&ibap_o2i_ignore,
                        'network_component_vendor'           => \&ibap_o2i_ignore,
                        'open_ports'                         => \&ibap_o2i_ignore,
                        'port_duplex'                        => \&ibap_o2i_ignore,
                        'port_link_status'                   => \&ibap_o2i_ignore,
                        'port_speed'                         => \&ibap_o2i_ignore,
                        'port_status'                        => \&ibap_o2i_ignore,
                        'port_type'                          => \&ibap_o2i_ignore,
                        'port_vlan_description'              => \&ibap_o2i_ignore,
                        'port_vlan_name'                     => \&ibap_o2i_ignore,
                        'port_vlan_number'                   => \&ibap_o2i_ignore,
                        'v_netadapter'                       => \&ibap_o2i_ignore,
                        'v_cluster'                          => \&ibap_o2i_ignore,
                        'v_datacenter'                       => \&ibap_o2i_ignore,
                        'v_name'                             => \&ibap_o2i_ignore,
                        'v_type'                             => \&ibap_o2i_ignore,
                        'v_host'                             => \&ibap_o2i_ignore,
                        'v_os'                               => \&ibap_o2i_ignore,
                        'v_switch'                           => \&ibap_o2i_ignore,
                        'iprg_no'                            => \&ibap_o2i_ignore,
                        'iprg_type'                          => \&ibap_o2i_ignore,
                        'iprg_state'                         => \&ibap_o2i_ignore,
                        'vmi_name'                           => \&ibap_o2i_ignore,
                        'vmi_id'                             => \&ibap_o2i_ignore,
                        'vmi_tenant_id'                      => \&ibap_o2i_ignore,
                        'vlan_port_group'                    => \&ibap_o2i_ignore,
                        'vswitch_name'                       => \&ibap_o2i_ignore,
                        'vswitch_id'                         => \&ibap_o2i_ignore,
                        'vswitch_type'                       => \&ibap_o2i_ignore,
                        'vswitch_ipv6_enabled'               => \&ibap_o2i_ignore,
                        'vport_name'                         => \&ibap_o2i_ignore,
                        'vport_mac_address'                  => \&ibap_o2i_ignore,
                        'vport_link_status'                  => \&ibap_o2i_ignore,
                        'vport_conf_speed'                   => \&ibap_o2i_ignore,
                        'vport_conf_mode'                    => \&ibap_o2i_ignore,
                        'vport_speed'                        => \&ibap_o2i_ignore,
                        'vport_mode'                         => \&ibap_o2i_ignore,
                        'vswitch_segment_type'               => \&ibap_o2i_ignore,
                        'vswitch_segment_name'               => \&ibap_o2i_ignore,
                        'vswitch_segment_id'                 => \&ibap_o2i_ignore,
                        'vswitch_segment_port_group'         => \&ibap_o2i_ignore,
                        'vswitch_available_ports_count'      => \&ibap_o2i_ignore,
                        'vswitch_tep_type'                   => \&ibap_o2i_ignore,
                        'vswitch_tep_ip'                     => \&ibap_o2i_ignore,
                        'vswitch_tep_port_group'             => \&ibap_o2i_ignore,
                        'vswitch_tep_vlan'                   => \&ibap_o2i_ignore,
                        'vswitch_tep_dhcp_server'            => \&ibap_o2i_ignore,
                        'vswitch_tep_multicast'              => \&ibap_o2i_ignore,
                        'vmhost_ip_address'                  => \&ibap_o2i_ignore,
                        'vmhost_name'                        => \&ibap_o2i_ignore,
                        'vmhost_mac_address'                 => \&ibap_o2i_ignore,
                        'vmhost_subnet_cidr'                 => \&ibap_o2i_ignore,
                        'vmhost_nic_names'                   => \&ibap_o2i_ignore,
                        'cmp_type'                           => \&ibap_o2i_ignore,
                        'vmi_ip_type'                        => \&ibap_o2i_ignore,
                        'vmi_private_address'                => \&ibap_o2i_ignore,
                        'vmi_is_public_address'              => \&ibap_o2i_ignore,
                        'cisco_ise_ssid'                      => \&ibap_o2i_ignore,
                        'cisco_ise_endpoint_profile'          => \&ibap_o2i_ignore,
                        'cisco_ise_session_state'             => \&ibap_o2i_ignore,
                        'cisco_ise_security_group'            => \&ibap_o2i_ignore,
                        'cisco_ise_quarantine_status'         => \&ibap_o2i_ignore,
                        'task_name'                           => \&ibap_o2i_ignore,
                        'network_component_location'          => \&ibap_o2i_ignore,
                        'network_component_contact'           => \&ibap_o2i_ignore,
                        'device_location'                     => \&ibap_o2i_ignore,
                        'device_contact'                      => \&ibap_o2i_ignore,
                        'ap_name'                             => \&ibap_o2i_ignore,
                        'ap_ip_address'                       => \&ibap_o2i_ignore,
                        'ap_ssid'                             => \&ibap_o2i_ignore,
                        'bridge_domain'                       => \&ibap_o2i_ignore,
                        'endpoint_groups'                     => \&ibap_o2i_ignore,
                        'tenant'                              => \&ibap_o2i_ignore,
                       );

    %_searchable_fields = (
                           'duid'                               => [\&ibap_o2i_string, 'duid', 'REGEX'],
                           'mac_address'                        => [\&ibap_o2i_string, 'mac_address', 'REGEX'],
                           'netbios'                            => [\&ibap_o2i_string, 'netbios_name', 'REGEX'],
                           'os'                                 => [\&ibap_o2i_string, 'os', 'REGEX'],
                           'device_model'                       => [\&ibap_o2i_string, 'device_model', 'REGEX'],
                           'device_port_name'                   => [\&ibap_o2i_string, 'device_port_name', 'REGEX'],
                           'device_port_type'                   => [\&ibap_o2i_string, 'device_port_type', 'REGEX'],
                           'device_type'                        => [\&ibap_o2i_string, 'device_type', 'REGEX'],
                           'device_vendor'                      => [\&ibap_o2i_string, 'device_vendor', 'REGEX'],
                           'discovered_name'                    => [\&ibap_o2i_string, 'discovered_name', 'REGEX'],
                           'discoverer'                         => [\&ibap_o2i_string, 'discoverer', 'REGEX'],
                           'first_discovered'                   => [\&ibap_o2i_unix_timestamp_to_datetime, 'first_discovered', 'REGEX'],
                           'last_discovered'                    => [\&ibap_o2i_unix_timestamp_to_datetime, 'last_discovered', 'REGEX'],
                           'mgmt_ip_address'                    => [\&ibap_o2i_string, 'mgmt_ip_address', 'REGEX'],
                           'network_component_description'      => [\&ibap_o2i_string, 'network_component_description', 'REGEX'],
                           'network_component_ip'               => [\&ibap_o2i_string, 'network_component_ip', 'REGEX'],
                           'network_component_model'            => [\&ibap_o2i_string, 'network_component_model', 'REGEX'],
                           'network_component_name'             => [\&ibap_o2i_string, 'network_component_name', 'REGEX'],
                           'network_component_port_description' => [\&ibap_o2i_string, 'network_component_port_description', 'REGEX'],
                           'network_component_port_name'        => [\&ibap_o2i_string, 'network_component_port_name', 'REGEX'],
                           'network_component_port_number'      => [\&ibap_o2i_uint, 'network_component_port_number', 'EXACT'],
                           'network_component_type'             => [\&ibap_o2i_string, 'network_component_type', 'REGEX'],
                           'network_component_vendor'           => [\&ibap_o2i_string, 'network_component_vendor', 'REGEX'],
                           'open_ports'                         => [\&ibap_o2i_string, 'open_ports', 'REGEX'],
                           'port_duplex'                        => [\&ibap_o2i_string, 'port_duplex', 'EXACT'],
                           'port_link_status'                   => [\&ibap_o2i_string, 'port_link_status', 'EXACT'],
                           'port_speed'                         => [\&ibap_o2i_string, 'port_speed', 'EXACT'],
                           'port_status'                        => [\&ibap_o2i_string, 'port_status', 'EXACT'],
                           'port_type'                          => [\&ibap_o2i_string, 'port_type', 'REGEX'],
                           'port_vlan_description'              => [\&ibap_o2i_string, 'port_vlan_description', 'REGEX'],
                           'port_vlan_name'                     => [\&ibap_o2i_string, 'port_vlan_name', 'REGEX'],
                           'port_vlan_number'                   => [\&ibap_o2i_uint, 'port_vlan_number', 'EXACT'],
                           'v_netadapter'                       => [\&ibap_o2i_string, 'v_adapter', 'REGEX'],
                           'v_cluster'                          => [\&ibap_o2i_string, 'v_cluster', 'REGEX'],
                           'v_datacenter'                       => [\&ibap_o2i_string, 'v_datacenter', 'REGEX'],
                           'v_name'                             => [\&ibap_o2i_string, 'v_entity_name', 'REGEX'],
                           'v_type'                             => [\&__o2i_v_type__, 'v_entity_type', 'EXACT'],
                           'v_host'                             => [\&ibap_o2i_string, 'v_host', 'REGEX'],
                           'v_os'                               => [\&ibap_o2i_string, 'v_os', 'REGEX'],
                           'v_switch'                           => [\&ibap_o2i_string, 'v_switch', 'REGEX'],
                           'iprg_type'                          => [\&ibap_o2i_string, 'iprg_type', 'EXACT'],
                           'iprg_state'                         => [\&ibap_o2i_string, 'iprg_state', 'EXACT'],
                           'vmi_name'                           => [\&ibap_o2i_string, 'v_switch', 'REGEX'],
                           'vmi_id'                             => [\&ibap_o2i_string, 'vmi_id', 'REGEX'],
                           'vmi_tenant_id'                      => [\&ibap_o2i_string, 'vmi_tenant_id', 'REGEX'],
                           'vlan_port_group'                    => [\&ibap_o2i_string, 'vlan_port_group', 'REGEX'],
                           'vswitch_name'                       => [\&ibap_o2i_string, 'vswitch_name', 'REGEX'],
                           'vswitch_id'                         => [\&ibap_o2i_string, 'vswitch_id', 'REGEX'],
                           'vswitch_type'                       => [\&ibap_o2i_string, 'vswitch_type', 'EXACT'],
                           'vswitch_ipv6_enabled'               => [\&ibap_o2i_boolean, 'vswitch_ipv6_enabled', 'EXACT'],
                           'vport_name'                         => [\&ibap_o2i_string, 'vport_name', 'REGEX'],
                           'vport_mac_address'                  => [\&ibap_o2i_string, 'vport_mac_address', 'REGEX'],
                           'vport_link_status'                  => [\&ibap_o2i_string, 'vport_link_status', 'REGEX'],
                           'vport_conf_speed'                   => [\&ibap_o2i_string, 'vport_conf_speed', 'REGEX'],
                           'vport_conf_mode'                    => [\&ibap_o2i_string, 'vport_conf_mode', 'EXACT'],
                           'vport_speed'                        => [\&ibap_o2i_string, 'vport_speed', 'REGEX'],
                           'vport_mode'                         => [\&ibap_o2i_string, 'vport_mode', 'EXACT'],
                           'vswitch_segment_type'               => [\&ibap_o2i_string, 'vswitch_segment_type', 'REGEX'],
                           'vswitch_segment_name'               => [\&ibap_o2i_string, 'vswitch_segment_name', 'REGEX'],
                           'vswitch_segment_id'                 => [\&ibap_o2i_string, 'vswitch_segment_id', 'REGEX'],
                           'vswitch_segment_port_group'         => [\&ibap_o2i_string, 'vswitch_segment_port_group', 'REGEX'],
                           'vswitch_available_ports_count'      => [\&ibap_o2i_uint, 'vswitch_available_ports_count', 'EXACT'],
                           'vswitch_tep_type'                   => [\&ibap_o2i_string, 'vswitch_tep_type', 'REGEX'],
                           'vswitch_tep_ip'                     => [\&ibap_o2i_string, 'vswitch_tep_ip', 'REGEX'],
                           'vswitch_tep_port_group'             => [\&ibap_o2i_string, 'vswitch_tep_port_group', 'REGEX'],
                           'vswitch_tep_vlan'                   => [\&ibap_o2i_string, 'vswitch_tep_vlan', 'REGEX'],
                           'vswitch_tep_dhcp_server'            => [\&ibap_o2i_string, 'vswitch_tep_dhcp_server', 'REGEX'],
                           'vswitch_tep_multicast'              => [\&ibap_o2i_string, 'vswitch_tep_multicast', 'REGEX'],
                           'vmhost_ip_address'                  => [\&ibap_o2i_string, 'vmhost_ip_address', 'REGEX'],
                           'vmhost_name'                        => [\&ibap_o2i_string, 'vmhost_name', 'REGEX'],
                           'vmhost_mac_address'                 => [\&ibap_o2i_string, 'vmhost_mac_address', 'REGEX'],
                           'vmhost_subnet_cidr'                 => [\&ibap_o2i_uint, 'vmhost_subnet_cidr', 'EXACT'],
                           'vmhost_nic_names'                   => [\&ibap_o2i_string, 'vmhost_nic_names', 'REGEX'],
                           'cmp_type'                           => [\&ibap_o2i_string, 'cmp_type', 'REGEX'],
                           'vmi_ip_type'                        => [\&ibap_o2i_string, 'vmi_ip_type', 'REGEX'],
                           'vmi_private_address'                => [\&ibap_o2i_string, 'vmi_private_address', 'REGEX'],
                           'vmi_is_public_address'              => [\&ibap_o2i_boolean, 'vmi_is_public_address', 'EXACT'],
                           'cisco_ise_ssid'                      => [\&ibap_o2i_string, 'cisco_ise_ssid', 'REGEX'],
                           'cisco_ise_endpoint_profile'          => [\&ibap_o2i_string, 'cisco_ise_endpoint_profile', 'REGEX'],
                           'cisco_ise_security_group'            => [\&ibap_o2i_string, 'cisco_ise_security_group', 'REGEX'],
                           'cisco_ise_quarantine_status'         => [\&ibap_o2i_ignore, 'cisco_ise_quarantine_status', 'REGEX'],
                           'task_name'                           => [\&ibap_o2i_string, 'task_name', 'REGEX'],
                           'network_component_location'          => [\&ibap_o2i_string, 'network_component_location', 'REGEX'],
                           'network_component_contact'           => [\&ibap_o2i_string, 'network_component_contact', 'REGEX'],
                           'device_location'                     => [\&ibap_o2i_string, 'device_location', 'REGEX'],
                           'device_contact'                      => [\&ibap_o2i_string, 'device_contact', 'REGEX'],
                           'ap_name'                             => [\&ibap_o2i_string, 'ap_name', 'REGEX'],
                           'ap_ip_address'                       => [\&ibap_o2i_string, 'ap_ip_address', 'REGEX'],
                           'ap_ssid'                             => [\&ibap_o2i_string, 'ap_ssid', 'REGEX'],
                           'bridge_domain'                       => [\&ibap_o2i_string, 'bridge_domain', 'REGEX'],
                           'endpoint_groups'                     => [\&ibap_o2i_string, 'endpoint_groups', 'REGEX'],
                           'tenant'                              => [\&ibap_o2i_string, 'tenant', 'REGEX'],
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}

sub __i2o_v_type__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return $_reverse_enum_mappings{$ibap_object_ref->{$current}} ? $_reverse_enum_mappings{$ibap_object_ref->{$current}} : $ibap_object_ref->{$current};
}

sub __o2i_v_type__
{
    my ($self, $session, $current, $tempref) = @_;
    return (1, 0, tString($_enum_mappings{$tempref->{$current}} ? $_enum_mappings{$tempref->{$current}} : $tempref->{$current}));
}

#
#
#

sub __init_discovered_members__
{
    my $object = shift;

    return unless defined $object->{'discovered_data'};

    my $object_reverse_name_mappings;

    {
        no strict 'refs';
        $object_reverse_name_mappings = \%{ref($object).'::_reverse_name_mappings'}
    }

    $object_reverse_name_mappings = {} unless defined $object_reverse_name_mappings;

    foreach my $key (keys(%{$object->{'discovered_data'}})) {
        next if $key eq '__object_id__';
        my $member = defined $_reverse_name_mappings{$key} ? defined $_reverse_name_mappings{$key} : $key;

        if (defined $object_reverse_name_mappings->{"_discovered_$member"}) {
            $member = $object_reverse_name_mappings->{"_discovered_$member"};
        } elsif (defined $object_reverse_name_mappings->{$member}) {
            $member = $object_reverse_name_mappings->{$member};
        }

        if ($object->can($member)) {
            $object->{$member} = $object->{'discovered_data'}->{$key};
        }
    }
}

sub __o2i_search_discovered_data__
{
    my ($self, $session, $current, $tempref, $type) = @_;

    unless (ref($tempref->{$current}) eq 'Infoblox::Grid::Discovery::Data') {
        set_error_codes(1004, 'Invalid data type for member discovered_data', $session);
        return (0);
    }

    my @search_fields = ();

    foreach my $member (keys(%{$tempref->{$current}})) {
        next unless defined $_searchable_fields{$member};

        my @data = $_searchable_fields{$member}->[0]($self, $session, $member, $tempref->{$current});

        return (0) if $data[0] == 0;
        next if $data[1] == 1;

        push @search_fields, {
                              'field' => $_searchable_fields{$member}->[1],
                              'search_type' => $type eq 'search' ? $_searchable_fields{$member}->[2] : 'EXACT',
                              'value' => $data[2]};
    }

    return (1, 0, return (1,0, tIBType('SubMatch', {'search_fields' => \@search_fields})));
}

package Infoblox::Grid::Discovery::SNMP3Credential;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap @_return_fields);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'snmpv3_credential';
    register_wsdl_type('ib:snmpv3_credential','Infoblox::Grid::Discovery::SNMP3Credential');

    %_allowed_members = (
                         'user'                    => {'simple' => 'asis', 'mandatory' => 1, 'validator' => \&ibap_value_o2i_string},
                         'authentication_protocol' => {'simple' => 'asis', 'mandatory' => 1, 'enum' => ['MD5', 'NONE', 'SHA']},
                         'authentication_password' => {'writeonly' => 1, 'validator' => \&ibap_value_o2i_string},
                         'privacy_protocol'        => {'simple' => 'asis', 'mandatory' => 1, 'enum' => ['AES', 'DES', '3DES', 'NONE']},
                         'privacy_password'        => {'writeonly' => 1, 'validator' => \&ibap_value_o2i_string},
                         'comment'                 => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'user'                    => \&ibap_o2i_string,
                        'authentication_protocol' => \&ibap_o2i_string,
                        'authentication_password' => \&ibap_o2i_string_skip_undef,
                        'privacy_protocol'        => \&ibap_o2i_string,
                        'privacy_password'        => \&ibap_o2i_string_skip_undef,
                        'comment'                 => \&ibap_o2i_string,
                       );

    @_return_fields = (
                       tField('user'),
                       tField('authentication_protocol'),
                       tField('privacy_protocol'),
                       tField('comment'),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::Grid::Discovery::SNMPCredential;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'snmpv1v2_credential';
    register_wsdl_type('ib:snmpv1v2_credential','Infoblox::Grid::Discovery::SNMPCredential');

    %_allowed_members = (
                         'community_string' => {'simple' => 'asis', 'mandatory' => 1, 'validator' => \&ibap_value_o2i_string},
                         'comment'          => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'community_string' => \&ibap_o2i_string,
                        'comment'          => \&ibap_o2i_string,
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::Grid::Discovery::Port;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'discovery_port';
    register_wsdl_type('ib:discovery_port','Infoblox::Grid::Discovery::Port');

    %_allowed_members = (
                         'port'    => {'simple' => 'asis', 'mandatory' => 1, 'validator' => \&ibap_value_o2i_uint},
                         'type'    => {'simple' => 'asis', 'mandatory' => 1, 'enum' => ['TCP', 'UDP']},
                         'comment' => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'port'    => \&ibap_o2i_uint,
                        'type'    => \&ibap_o2i_string,
                        'comment' => \&ibap_o2i_string,
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}

package Infoblox::Grid::Discovery::BasicPollSettings;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_object_to_ibap
                 @_return_fields $_return_fields_initialized
                 %_name_mappings %_reverse_name_mappings);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'basic_polling_settings';
    register_wsdl_type('ib:basic_polling_settings','Infoblox::Grid::Discovery::BasicPollSettings');

    %_allowed_members = (
                         'auto_arp_refresh_before_switch_port_polling'  => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'device_profile'                               => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'complete_ping_sweep'                          => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'netbios_scanning'                             => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'port_scanning'                                => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'smart_subnet_ping_sweep'                      => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'snmp_collection'                              => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'cli_collection'                               => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'switch_port_data_collection_polling'          => {'simple' => 'asis', 'enum' => ['DISABLED', 'PERIODIC', 'SCHEDULED']},
                         'switch_port_data_collection_polling_interval' => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'switch_port_data_collection_polling_schedule' => {'validator' => {'Infoblox::Grid::ScheduleSetting' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'device_profile'      => 'finger_printing',
                       'complete_ping_sweep' => 'ipv4_ping_sweep',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'switch_port_data_collection_polling_schedule' => \&ibap_i2o_generic_object_convert,
                       );

    %_object_to_ibap = (
                        'auto_arp_refresh_before_switch_port_polling'  => \&ibap_o2i_boolean,
                        'device_profile'                               => \&ibap_o2i_boolean,
                        'complete_ping_sweep'                          => \&ibap_o2i_boolean,
                        'netbios_scanning'                             => \&ibap_o2i_boolean,
                        'port_scanning'                                => \&ibap_o2i_boolean,
                        'smart_subnet_ping_sweep'                      => \&ibap_o2i_boolean,
                        'snmp_collection'                              => \&ibap_o2i_boolean,
                        'cli_collection'                               => \&ibap_o2i_boolean,
                        'switch_port_data_collection_polling'          => \&ibap_o2i_string,
                        'switch_port_data_collection_polling_interval' => \&ibap_o2i_uint,
                        'switch_port_data_collection_polling_schedule' => \&ibap_o2i_generic_struct_convert,
                       );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('auto_arp_refresh_before_switch_port_polling'),
                       tField('finger_printing'),
                       tField('ipv4_ping_sweep'),
                       tField('netbios_scanning'),
                       tField('port_scanning'),
                       tField('smart_subnet_ping_sweep'),
                       tField('snmp_collection'),
                       tField('cli_collection'),
                       tField('switch_port_data_collection_polling'),
                       tField('switch_port_data_collection_polling_interval'),
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
        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::ScheduleSetting->__new__();
        push @_return_fields,
          tField('switch_port_data_collection_polling_schedule', {
                                sub_fields => $t->__return_fields__(),
                               },
                );
    }
}

sub __ibap_object_type__
{
    return $_object_type;
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach ('auto_arp_refresh_before_switch_port_polling',
             'finger_printing',
             'ipv4_ping_sweep',
             'netbios_scanning',
             'port_scanning',
             'smart_subnet_ping_sweep',
             'snmp_collection',
             'cli_collection')
    {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

package Infoblox::Grid::Discovery::AdvancedPollSettings;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap %_ibap_to_object
                 %_name_mappings %_reverse_name_mappings);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'advanced_polling_settings';
    register_wsdl_type('ib:advanced_polling_settings','Infoblox::Grid::Discovery::AdvancedPollSettings');

    %_allowed_members = (
                         'arp_aggregate_limit'               => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'arp_cache_refresh_interval'        => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'dhcp_router_as_seed'               => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'disable_discovery_outside_ipam'    => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'enable_purge_expired_endhost_data' => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'ping_retries'                      => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'ping_sweep_interval'               => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'ping_timeout'                      => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'polling_authenticate_snmpv2c_or_later_only'  => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'purge_expired_device_data'         => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'purge_expired_endhost_data'        => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'route_limit'                       => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'tcp_scan_technique'                => {'simple' => 'asis', 'enum' => ['CONNECT', 'SYN']},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'dhcp_router_as_seed' => 'use_dhcp_router_as_seed',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'disable_discovery_outside_ipam'    => \&ibap_i2o_boolean,
                        'enable_purge_expired_endhost_data' => \&ibap_i2o_boolean,
                        'polling_authenticate_snmpv2c_or_later_only'  => \&ibap_i2o_boolean,
                        'use_dhcp_router_as_seed'           => \&ibap_i2o_boolean,
                       );

    %_object_to_ibap = (
                        'arp_aggregate_limit'               => \&ibap_o2i_uint,
                        'arp_cache_refresh_interval'        => \&ibap_o2i_uint,
                        'dhcp_router_as_seed'               => \&ibap_o2i_boolean,
                        'disable_discovery_outside_ipam'    => \&ibap_o2i_boolean,
                        'enable_purge_expired_endhost_data' => \&ibap_o2i_boolean,
                        'ping_retries'                      => \&ibap_o2i_uint,
                        'ping_sweep_interval'               => \&ibap_o2i_uint,
                        'ping_timeout'                      => \&ibap_o2i_uint,
                        'polling_authenticate_snmpv2c_or_later_only'  => \&ibap_o2i_boolean,
                        'purge_expired_device_data'         => \&ibap_o2i_uint,
                        'purge_expired_endhost_data'        => \&ibap_o2i_uint,
                        'route_limit'                       => \&ibap_o2i_uint,
                        'tcp_scan_technique'                => \&ibap_o2i_string,
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach ('disable_discovery_outside_ipam',
             'enable_purge_expired_endhost_data',
             'polling_authenticate_snmpv2c_or_later_only',
             'use_dhcp_router_as_seed')
    {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::Discovery::VRFMappingRule;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members
                 %_object_to_ibap %_ibap_to_object
                 @_return_fields $_return_fields_initialized);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'vrf_mapping_rule';
    register_wsdl_type('ib:vrf_mapping_rule', 'Infoblox::Grid::Discovery::VRFMappingRule');

    %_allowed_members = (
        'network_view' => {'mandatory' => 1, 'validator' => \&ibap_value_o2i_string},
        'criteria' => {'simple' => 'asis', 'mandatory' => 1, 'validator' => \&ibap_value_o2i_string},
        'comment' => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
        'criteria' => \&ibap_o2i_string,
        'network_view' => \&ibap_o2i_network_view,
        'comment' => \&ibap_o2i_string,
    );

    %_ibap_to_object = (
        'network_view' => \&ibap_i2o_object_name,
    );

    $_return_fields_initialized = 0;

    @_return_fields = (
        tField('criteria'),
        tField('comment'),
        tField('network_view', {sub_fields => [tField('name')]}),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::Grid::Discovery::AutoConversionSetting;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members
                 %_object_to_ibap %_ibap_to_object
                 @_return_fields);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'auto_conversion_setting';
    register_wsdl_type('ib:auto_conversion_setting', 'Infoblox::Grid::Discovery::AutoConversionSetting');

    %_allowed_members = (
        'network_view' => {'mandatory' => 1, 'validator' => \&ibap_value_o2i_string},
        'format' => {'simple' => 'asis', 'mandatory' => 1, 'validator' => \&ibap_value_o2i_string},
        'type' => {'simple' => 'asis', 'mandatory' => 1, 'enum' => ['A_AND_PTR_RECORD', 'HOST_RECORD', 'FIXED_ADDRESS']},
        'comment' => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
        'condition' => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
        'format' => \&ibap_o2i_string,
        'type' => \&ibap_o2i_string,
        'network_view' => \&ibap_o2i_network_view,
        'comment' => \&ibap_o2i_string,
        'condition' => \&ibap_o2i_string,
    );

    %_ibap_to_object = (
        'network_view' => \&ibap_i2o_object_name,
    );

    @_return_fields = (
        tField('format'),
        tField('type'),
        tField('comment'),
        tField('network_view', {sub_fields => [tField('name')]}),
        tField('condition'),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::Grid::Discovery::Properties;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_capabilities
                 %_allowed_members %_ibap_to_object %_object_to_ibap
                 @_return_fields $_return_fields_initialized
                 %_name_mappings %_reverse_name_mappings
                 %_return_field_overrides);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_MODIFY_ONLY);

BEGIN {
    $_object_type = 'GridDiscoveryProperties';
    register_wsdl_type('ib:GridDiscoveryProperties','Infoblox::Grid::Discovery::Properties');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'advanced_polling_settings' => {'mandatory' => 1, 'validator' => {'Infoblox::Grid::Discovery::AdvancedPollSettings' => 1}},
                         'basic_polling_settings'    => {'mandatory' => 1, 'validator' => {'Infoblox::Grid::Discovery::BasicPollSettings' => 1}},
                         'snmp3_credentials'         => {'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::SNMP3Credential' => 1}},
                         'snmp_credentials'          => {'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::SNMPCredential' => 1}},
                         'cli_credentials'           => {'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::CLICredential' => 1}},
                         'discovery_blackout_setting'    => {'validator' => {'Infoblox::Grid::Discovery::Properties::BlackoutSetting' => 1}},
                         'port_control_blackout_setting' => {'validator' => {'Infoblox::Grid::Discovery::Properties::BlackoutSetting' => 1}},
                         'same_port_control_discovery_blackout' => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'ignore_conflict_duration'  => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'ports'                     => {'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::Port' => 1}},
                         'unmanaged_ips_limit'       => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'unmanaged_ips_timeout'     => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'vrf_mapping_rules'         => {'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::VRFMappingRule' => 1}},
                         'vrf_mapping_policy'        => {'simple' => 'asis', 'enum' => ['NONE', 'RULE_BASED', 'RULE_AND_INTERNAL_BASED']},
                         'auto_conversion_settings'  => {'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::AutoConversionSetting' => 1}},
                         'enable_auto_conversion'    => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'enable_auto_updates'       => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'snmp3_credentials' => 'snmpv3_credentials',
                       'snmp_credentials'  => 'snmpv1v2_credentials',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'advanced_polling_settings' => \&ibap_i2o_generic_object_convert,
                        'basic_polling_settings'    => \&ibap_i2o_generic_object_convert,
                        'snmpv3_credentials'        => \&ibap_i2o_generic_object_list_convert,
                        'snmpv1v2_credentials'      => \&ibap_i2o_generic_object_list_convert,
                        'cli_credentials'           => \&ibap_i2o_generic_object_list_convert,
                        'discovery_blackout_setting'    => \&ibap_i2o_generic_object_convert,
                        'port_control_blackout_setting' => \&ibap_i2o_generic_object_convert,
                        'ports'                     => \&ibap_i2o_generic_object_list_convert,
                        'vrf_mapping_rules'         => \&ibap_i2o_generic_object_list_convert,
                        'auto_conversion_settings'  => \&ibap_i2o_generic_object_list_convert,
                       );

    %_object_to_ibap = (
                        'advanced_polling_settings' => \&ibap_o2i_generic_struct_convert,
                        'basic_polling_settings'    => \&ibap_o2i_generic_struct_convert,
                        'snmp3_credentials'         => \&ibap_o2i_generic_struct_list_convert,
                        'snmp_credentials'          => \&ibap_o2i_generic_struct_list_convert,
                        'cli_credentials'           => \&ibap_o2i_generic_struct_list_convert,
                        'discovery_blackout_setting'    => \&ibap_o2i_generic_struct_convert,
                        'port_control_blackout_setting' => \&ibap_o2i_generic_struct_convert,
                        'same_port_control_discovery_blackout' => \&ibap_o2i_boolean,
                        'ports'                     => \&ibap_o2i_generic_struct_list_convert,
                        'ignore_conflict_duration'  => \&ibap_o2i_uint,
                        'unmanaged_ips_limit'       => \&ibap_o2i_uint,
                        'unmanaged_ips_timeout'     => \&ibap_o2i_uint,
                        'vrf_mapping_rules'         => \&ibap_o2i_generic_struct_list_convert,
                        'vrf_mapping_policy'        => \&ibap_o2i_string,
                        'auto_conversion_settings'  => \&ibap_o2i_generic_struct_list_convert,
                        'enable_auto_conversion'    => \&ibap_o2i_boolean,
                        'enable_auto_updates'    => \&ibap_o2i_boolean,
                       );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('advanced_polling_settings', {'depth' => 1}),
                       tField('snmpv1v2_credentials', {'depth' => 1}),
                       tField('cli_credentials', {'depth' => 1}),
                       tField('ports', {'depth' => 1}),
                       tField('same_port_control_discovery_blackout'),
                       tField('ignore_conflict_duration'),
                       tField('unmanaged_ips_limit'),
                       tField('unmanaged_ips_timeout'),
                       tField('vrf_mapping_policy'),
                       tField('enable_auto_conversion'),
                       tField('enable_auto_updates'),
                      );

    %_return_field_overrides = ();

    foreach (keys(%_allowed_members)) {
        $_return_field_overrides{$_} = [];
    }
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
        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::Discovery::BasicPollSettings->__new__();
        push @_return_fields,
          tField('basic_polling_settings', {
                                sub_fields => $t->__return_fields__(),
                               },
                );

        $t = Infoblox::Grid::Discovery::SNMP3Credential->__new__();
        push @_return_fields,
          tField('snmpv3_credentials', {
                                sub_fields => $t->__return_fields__(),
                               },
                );

        $t = Infoblox::Grid::Discovery::Properties::BlackoutSetting->__new__();
        push @_return_fields,
          tField('discovery_blackout_setting', {
                                sub_fields => $t->__return_fields__(),
                               },
                );
        push @_return_fields,
          tField('port_control_blackout_setting', {
                                sub_fields => $t->__return_fields__(),
                               },
                );

        $t = Infoblox::Grid::Discovery::VRFMappingRule->__new__();
        push @_return_fields,
          tField('vrf_mapping_rules', {
                                sub_fields => $t->__return_fields__(),
                               },
                );

        $t = Infoblox::Grid::Discovery::AutoConversionSetting->__new__();
        push @_return_fields,
          tField('auto_conversion_settings', {
                                sub_fields => $t->__return_fields__(),
                               },
                );
    }
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

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach ('same_port_control_discovery_blackout',
             'ignore_conflict_duration',
             'enable_auto_conversion',
             'enable_auto_updates') {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    $self->{ '__internal_session_cache_ref__' } = \$session;

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

#
#
#

sub test_credential {
    my $self  = shift;

    unless ($self->{ '__internal_session_cache_ref__' } and $self->__object_id__()) {
        return set_error_codes(1001, 'In order to test the credential the object must have been retrieved from the server first');
    }

    return ${$self->{ '__internal_session_cache_ref__' }}->__test_credential__($self->__object_id__(), @_);
}

package Infoblox::Grid::Discovery::SeedRouter;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap %_ibap_to_object @_return_fields);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'seed_router';
    register_wsdl_type('ib:seed_router','Infoblox::Grid::Discovery::SeedRouter');

    %_allowed_members = (
                         'address' => {'simple' => 'asis', 'mandatory' => 1, 'validator' => \&ibap_value_o2i_ipaddr},
                         'comment' => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'network_view' => {'validator' => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'address' => \&ibap_o2i_string,
                        'network_view' => \&ibap_o2i_network_view,
                        'comment' => \&ibap_o2i_string,
                       );

    %_ibap_to_object = (
                        'network_view' => \&ibap_i2o_object_name,
                       );

    @_return_fields = (
                       tField('address'),
                       tField('comment'),
                       tField('network_view', {sub_fields => [tField('name')]}),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::Grid::Member::DiscoveryProperties;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_capabilities
                 %_allowed_members %_ibap_to_object %_object_to_ibap
                 @_return_fields $_return_fields_initialized %_searchable_fields
                 %_name_mappings %_reverse_name_mappings
                 %_return_field_overrides);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE);

BEGIN {
    $_object_type = 'MemberDiscoveryProperties';
    register_wsdl_type('ib:MemberDiscoveryProperties','Infoblox::Grid::Member::DiscoveryProperties');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'member'                     => {'validator' => \&ibap_value_o2i_string},
                         'enable_service'             => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'role'                       => {'simple' => 'asis', 'enum' => ['DNM', 'DNP', 'NONE']},
                         'seed_routers'               => {'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::SeedRouter' => 1}},
                         'snmp3_credentials'          => {'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::SNMP3Credential' => 1}, 'use' => 'override_snmp3_credentials', 'use_truefalse' => 1},
                         'override_snmp3_credentials' => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'snmp_credentials'           => {'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::SNMPCredential' => 1}, 'use' => 'override_snmp_credentials', 'use_truefalse' => 1},
                         'override_snmp_credentials'  => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'cli_credentials'            => {'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::CLICredential' => 1}, 'use' => 'override_cli_credentials', 'use_truefalse' => 1},
                         'override_cli_credentials'   => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'default_seed_routers'       => {'array' => 1, 'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::SeedRouter' => 1}},
                         'scan_interfaces'            => {'array' => 1, 'validator' => {'Infoblox::Grid::Member::Discovery::ScanInterface' => 1}},
                         'cisco_apic_configurations'  => {'array' => 1, 'validator' => {'Infoblox::Grid::Member::Discovery::CiscoAPICConfig' => 1}},
                         'interface'                  => 0,
                         'network_view'               => 0,
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'member'                     => 'virtual_node',
                       'snmp3_credentials'          => 'snmpv3_credentials',
                       'snmp_credentials'           => 'snmpv1v2_credentials',
                       'override_snmp3_credentials' => 'use_snmpv3_credentials',
                       'override_snmp_credentials'  => 'use_snmpv1v2_credentials',
                       'override_cli_credentials'   => 'use_cli_credentials',
                      );

    %_reverse_name_mappings = (
                               'interface'    => 'scan_interfaces',
                               'network_view' => 'scan_interfaces',
                               reverse %_name_mappings,
                              );

    %_ibap_to_object = (
                        'virtual_node'              => \&ibap_i2o_member_byhostname,
                        'enable_service'            => \&ibap_i2o_boolean,
                        'seed_routers'              => \&ibap_i2o_generic_object_list_convert,
                        'snmpv3_credentials'        => \&ibap_i2o_generic_object_list_convert,
                        'snmpv1v2_credentials'      => \&ibap_i2o_generic_object_list_convert,
                        'cli_credentials'           => \&ibap_i2o_generic_object_list_convert,
                        'default_seed_routers'      => \&ibap_i2o_generic_object_list_convert,
                        'cisco_apic_configurations' => \&ibap_i2o_generic_object_list_convert,

                        #
                        #
                        'scan_interfaces'          => \&__i2o_scan_interfaces__,
                       );

    %_object_to_ibap = (
                        'member'                     => \&ibap_o2i_member_byhostname,
                        'enable_service'             => \&ibap_o2i_boolean,
                        'role'                       => \&ibap_o2i_string,
                        'seed_routers'               => \&ibap_o2i_generic_struct_list_convert,
                        'snmp3_credentials'          => \&ibap_o2i_generic_struct_list_convert,
                        'override_snmp3_credentials' => \&ibap_o2i_boolean,
                        'snmp_credentials'           => \&ibap_o2i_generic_struct_list_convert,
                        'override_snmp_credentials'  => \&ibap_o2i_boolean,
                        'cli_credentials'            => \&ibap_o2i_generic_struct_list_convert,
                        'override_cli_credentials'   => \&ibap_o2i_boolean,
                        'default_seed_routers'       => \&ibap_o2i_ignore,
                        'cisco_apic_configurations'  => \&ibap_o2i_generic_struct_list_convert,

                        #
                        'scan_interfaces'            => \&__o2i_scan_interfaces__,
                        'network_view'               => \&ibap_o2i_ignore,
                        'interface'                  => \&ibap_o2i_ignore,
                       );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('virtual_node', {'sub_fields' => [tField('host_name')]}),
                       tField('enable_service'),
                       tField('role'),
                       tField('snmpv1v2_credentials', {'depth' => 1}),
                       tField('cli_credentials', {'depth' => 1}),
                       tField('use_snmpv1v2_credentials'),
                       tField('use_snmpv3_credentials'),
                       tField('use_cli_credentials'),
                      );

    %_return_field_overrides = ();

    foreach (keys(%_allowed_members)) {
        $_return_field_overrides{$_} = [];
    }

    %_searchable_fields = (
                           'member' => [\&ibap_o2i_member_byhostname, 'virtual_node', 'EXACT'],
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

sub __i2o_scan_interfaces__ {

    #

    #
    #
    #

    #
    #
    #
    #

    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $scan_ifs = $$ibap_object_ref{scan_interfaces};

    if (ref $scan_ifs eq 'ARRAY' and scalar @$scan_ifs == 1) {
        $self->{__network_view_old__} = $$self{network_view} = $$scan_ifs[0]{network_view}{name};
        $self->{__interface_old__} = $$self{interface} = $$scan_ifs[0]{scan_interface_type};
    }
    $self->{__scan_ifs_compatible__} = 1 if(scalar(@$scan_ifs) <= 1);

    #
    return ibap_i2o_generic_object_list_convert($self, $session, $current,
        $ibap_object_ref, $return_object_cache_ref);
}

sub __o2i_scan_interfaces__ {

    #

    #

    my ($self, $session, $current, $tempref) = @_;

    my $scan_ifs = $self->{scan_interfaces};

    if ($self->{__scan_ifs_compatible__} and
        ref $scan_ifs eq 'ARRAY'         and
        scalar @$scan_ifs <= 1
    ) {
        if ($$self{'network_view'} ne $$self{__network_view_old__} or
            $$self{'interface'}    ne $$self{__interface_old__}
        ) {
            #
            #
            $scan_ifs = $$self{scan_interfaces} = [Infoblox::Grid::Member::Discovery::ScanInterface->__new__()];
            $$self{__network_view_old__} = $$scan_ifs[0]{network_view} = $$self{network_view};
            $$self{__interface_old__} = $$scan_ifs[0]{scan_interface_type} = $$self{interface};
        } 
    }

    return ibap_o2i_generic_struct_list_convert($self, $session,
        $current, $tempref);
}

sub __init_instance_constants__
{
    my $self = shift;

    unless ($_return_fields_initialized) {
        $_return_fields_initialized = 1;

        my (%tmp, $tmp);

        %tmp = (
            'snmpv3_credentials' => 'Infoblox::Grid::Discovery::SNMP3Credential',
            'scan_interfaces'    => 'Infoblox::Grid::Member::Discovery::ScanInterface',
            'seed_routers' => 'Infoblox::Grid::Discovery::SeedRouter',
            'default_seed_routers' => 'Infoblox::Grid::Discovery::SeedRouter',
            'cisco_apic_configurations' => 'Infoblox::Grid::Member::Discovery::CiscoAPICConfig',
        );

        foreach (keys %tmp) {
            $tmp = $tmp{$_}->__new__();
            push @_return_fields, tField($_, {sub_fields => $tmp->__return_fields__()});
        }
    }
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

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->{ '__internal_session_cache_ref__' } = \$session;

    foreach ('enable_service', 'use_snmpv1v2_credentials', 'use_snmpv3_credentials', 'use_cli_credentials') {
        $ibap_object_ref->{$_} = 0 unless defined $ibap_object_ref->{$_};
    }

    $self->{'scan_interfaces'} = [];

    $self->{'cisco_apic_configurations'} = [];

    foreach (
        '__network_view_old__',
        '__interface_old__',
        '__scan_ifs_compatible__',
    ) {
        delete $$self{$_};
    }

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    $self->{'override_snmp_credentials'} = ibap_value_i2o_boolean($ibap_object_ref->{'use_snmpv1v2_credentials'});
    $self->{'override_snmp3_credentials'} = ibap_value_i2o_boolean($ibap_object_ref->{'use_snmpv3_credentials'});
    $self->{'override_cli_credentials'} = ibap_value_i2o_boolean($ibap_object_ref->{'use_cli_credentials'});

    return $res;
}

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;

    my $ref_write_fields = $self->SUPER::__object_to_ibap__($server, $session);

    return $ref_write_fields;
}

#
#
#

sub test_credential {
    my $self  = shift;

    unless ($self->{ '__internal_session_cache_ref__' } and $self->__object_id__()) {
        return set_error_codes(1001, 'In order to test the credential the object must have been retrieved from the server first');
    }

    return ${$self->{ '__internal_session_cache_ref__' }}->__test_credential__($self->__object_id__(), @_);
}

sub network_view {

    my $self = shift;

    unless (
        $self->{__scan_ifs_compatible__}       and
        ref $$self{scan_interfaces} eq 'ARRAY' and
        scalar @{$$self{scan_interfaces}} <= 1
    ) {
        return set_error_codes('1012', "'network_view' is deprecated. Use 'scan_interfaces' instead.");
    }

    return $self->__accessor_scalar__({name => 'network_view', validator => \&ibap_value_o2i_string}, @_);
}

sub interface {

    my $self = shift;

    unless (
        $self->{__scan_ifs_compatible__}       and
        ref $$self{scan_interfaces} eq 'ARRAY' and
        scalar @{$$self{scan_interfaces}} <= 1
    ) {
        return set_error_codes('1012', "'interface' is deprecated. Use 'scan_interfaces' instead.");
    }

    return $self->__accessor_scalar__({name => 'interface', enum => ['LAN1', 'LAN2', 'MGMT', 'VLAN']}, @_);
}


package Infoblox::Grid::Member::Discovery::ScanInterface;

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
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_reverse_name_mappings
            @ISA
            @_return_fields
            %_if_mapping
            %_reverse_if_mapping
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

        $_object_type = 'discovery_scan_interface';
        register_wsdl_type('ib:discovery_scan_interface', 'Infoblox::Grid::Member::Discovery::ScanInterface');



    %_allowed_members = (
                         'scan_interface_type' => {enum => ['LAN1', 'LAN2', 'MGMT']},
                         'network_view'        => {validator => \&ibap_value_o2i_string},
                         'vlan_id'             => {validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'vlan_id' => 'scan_virtual_ip',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'network_view'        => \&ibap_i2o_object_name,
                        'scan_virtual_ip'     => \&__i2o_vlan_id__,
                        'scan_interface_type' => \&__i2o_type__,
    );

    %_object_to_ibap = (
                        'scan_interface_type' => \&__o2i_type__,
                        'network_view'        => \&ibap_o2i_network_view,
                        'vlan_id'             => \&__o2i_vlan_id__,
    );

    @_return_fields = (
                       tField('scan_interface_type'),
                       tField('network_view', {sub_fields => [tField('name')]}),
                       tField('scan_virtual_ip', {
                            default_no_access_ok => 1,
                            sub_fields           => [
                                tField('ipv6_network_setting', {
                                    sub_fields => [tField('vlan_id')]}),
                                tField('ipv4_network_setting', {
                                    sub_fields => [tField('vlan_id')]}),
                                tField('interface_type'),
                            ],
                        }),
    );

    %_if_mapping = (
        'LAN1' => 'LAN_HA',
        'LAN2' => 'LAN2',
    );

    %_reverse_if_mapping = reverse %_if_mapping;

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


sub __i2o_vlan_id__ {

    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return ($$ibap_object_ref{$current}{ipv4_network_setting} ?
        $$ibap_object_ref{$current}{ipv4_network_setting}{'vlan_id'} :
        $$ibap_object_ref{$current}{ipv6_network_setting}{'vlan_id'}
    );

}

sub __o2i_vlan_id__ {

    my ($self, $session, $current, $tempref) = @_;

    return (1, 1, undef) unless $$tempref{$current};

    my $fields = [
        {
            'field'       => 'vlan_id',
            'search_type' => 'EXACT',
            'value'       => tUInteger($$tempref{$current}),
        },
        {
            'field'       => 'interface_type',
            'search_type' => 'EXACT',
            'value'       => tString($_if_mapping{$$self{scan_interface_type}}),
        },
    ];

    my $error_tag = "1012=vlan_id=$$tempref{$current}";
    return (1, 0, tIBType('BaseObject',
        ibap_readfieldlist_simple('MemberAdditionalIp', $fields,
        undef, 'EXACT', 'readfield_substitution', $error_tag)));
}

sub __i2o_type__ {

    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($$ibap_object_ref{$current} eq 'VLAN') {
        return $_reverse_if_mapping{$$ibap_object_ref{scan_virtual_ip}{interface_type}};
    }

    return $$ibap_object_ref{$current};
}

sub __o2i_type__ {

    my ($self, $session, $current, $tempref) = @_;

    if ($$self{vlan_id}) {
        return (1, 0, tString('VLAN'));
    } else {
        return (1, 0, ibap_value_o2i_string($$self{scan_interface_type}));
    }
}


package Infoblox::Grid::Discovery::IFAddrInfo;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_object_to_ibap
                 @_return_fields $_return_fields_initialized
                 %_name_mappings %_reverse_name_mappings);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'ifaddr_info';
    register_wsdl_type('ib:ifaddr_info','Infoblox::Grid::Discovery::IFAddrInfo');

    %_allowed_members = (
                         'address'        => {'simple' => 'asis', 'mandatory' => 1, 'validator' => \&ibap_value_o2i_ipaddr},
                         'address_object' => {'validator' => {'Infoblox::IPAM::Address' => 1}},
                         'network'        => {'validator' => {'Infoblox::DHCP::Network' => 1, 'Infoblox::DHCP::IPv6Network' => 1,}},
                         'network_str'    => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_network},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'address_object' => 'address_ref',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'address_ref' => \&ibap_i2o_generic_object_convert,
                        'network'     => \&ibap_i2o_generic_object_convert_partial,
                       );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('address'),
                       tField('network', return_fields_network_partial()),
                       tField('network_str'),
                      );

    %_object_to_ibap = (
                        'address'        => \&ibap_o2i_string,
                        'address_object' => \&ibap_o2i_ignore,
                        'network'        => \&ibap_o2i_network,
                        'network_str'    => \&ibap_o2i_string,
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
        $_return_fields_initialized = 1;

        my $t = Infoblox::IPAM::Address->__new__();
        push @_return_fields,
          tField('address_ref', {
                                sub_fields => $t->__return_fields__(),
                               },
                );
    }
}

sub __ibap_object_type__
{
    return $_object_type;
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    if (defined $self->{'network'} and defined $self->{'network'}->{'network_view'}) {
        $self->{'network'}->{'network_view'}->{'__partial__'} = 1;
    }

    return $res;
}

package Infoblox::Grid::Discovery::VLANInfo;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap
                 %_name_mappings %_reverse_name_mappings);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'vlan_info';
    register_wsdl_type('ib:vlan_info','Infoblox::Grid::Discovery::VLANInfo');

    %_allowed_members = (
                         'id'   => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'name' => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'id'   => 'vlan_id',
                       'name' => 'vlan_name',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_object_to_ibap = (
                        'id'   => \&ibap_o2i_string,
                        'name' => \&ibap_o2i_string,
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}

package Infoblox::Grid::Discovery::Device;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_capabilities
                 %_allowed_members %_ibap_to_object %_object_to_ibap
                 @_return_fields @_optional_return_fields $_return_fields_initialized
                 %_searchable_fields %_name_mappings %_reverse_name_mappings
                 %_return_field_overrides);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE);

BEGIN {
    $_object_type = 'Device';
    register_wsdl_type('ib:Device','Infoblox::Grid::Discovery::Device');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'address'        => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_ipaddr},
                         'address_object' => {'readonly' => 1, 'validator' => {'Infoblox::IPAM::Address' => 1}},
                         'chassis_serial_number' => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'class'          => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'description'    => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'interfaces'     => {'readonly' => 1, 'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}},
                         'location'       => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'model'          => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'name'           => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'neighbors'      => {'readonly' => 1, 'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::DeviceNeighbor' => 1}},
                         'network'        => {'readonly' => 1, 'validator' => {'Infoblox::DHCP::Network' => 1, 'Infoblox::DHCP::IPv6Network' => 1}},
                         'network_view'   => {'readonly' => 1, 'validator' => \&ibap_value_o2i_string},
                         'networks'       => {'readonly' => 1, 'array' => 1, 'validator' => {'Infoblox::DHCP::Network' => 1, 'Infoblox::DHCP::IPv6Network' => 1}},
                         'os_version'     => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'vendor'         => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'vlan_infos'     => {'readonly' => 1, 'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::VLANInfo' => 1}},
                         'port_stats'     => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::Device::PortStatistics' => 1}},
                         'cap_admin_status_ind'                => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_admin_status_na_reason'          => {'readonly' => 1, 'simple' => 'asis'},
                         'cap_description_ind'                 => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_description_na_reason'           => {'readonly' => 1, 'simple' => 'asis'},
                         'cap_net_deprovisioning_ind'          => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_net_deprovisioning_na_reason'    => {'readonly' => 1, 'simple' => 'asis'},
                         'cap_net_provisioning_ind'            => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_net_provisioning_na_reason'      => {'readonly' => 1, 'simple' => 'asis'},
                         'cap_net_vlan_provisioning_ind'       => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_net_vlan_provisioning_na_reason' => {'readonly' => 1, 'simple' => 'asis'},
                         'cap_vlan_assignment_ind'             => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_vlan_assignment_na_reason'       => {'readonly' => 1, 'simple' => 'asis'},
                         'cap_voice_vlan_ind'                  => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_voice_vlan_na_reason'            => {'readonly' => 1, 'simple' => 'asis'},
                         'discover_now_status'                 => {'readonly' => 1, 'simple' => 'asis'},
                         'extattrs'                            => {special => 'extensible_attributes'},
                         'extensible_attributes'               => {special => 'extensible_attributes'},
                         'ms_ad_user_data'                     => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'address_object' => 'address_ref',
                       'networks'       => 'network_infos',
                       'extattrs'       => 'extensible_attributes',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'address_ref'           => \&ibap_i2o_generic_object_convert,
                        'interfaces'            => \&ibap_i2o_generic_object_list_convert,
                        'network'               => \&ibap_i2o_generic_object_convert_partial,
                        'network_view'          => \&ibap_i2o_object_name,
                        'network_infos'         => \&__i2o_network_infos__,
                        'neighbors'             => \&ibap_i2o_generic_object_list_convert,
                        'vlan_infos'            => \&ibap_i2o_generic_object_list_convert,
                        'port_stats'            => \&ibap_i2o_generic_object_convert,
                        'ms_ad_user_data'       => \&ibap_i2o_generic_object_convert,
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                       );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('address'),
                       tField('chassis_serial_number'),
                       tField('class'),
                       tField('description'),
                       tField('location'),
                       tField('model'),
                       tField('name'),
                       tField('network', return_fields_network_partial()),
                       tField('network_view', {'sub_fields' => [tField('name')]}),
                       tField('os_version'),
                       tField('vendor'),
                       tField('vlan_infos', {'depth' => 1}),
                       tField('discover_now_status'),
                       return_fields_extensible_attributes(),
                      );

    #
    @_optional_return_fields = (
                                tField('network_infos', {'sub_fields' => [
                                                                          tField('network', return_fields_network_partial()),
                                                                          tField('network_str'),
                                                                         ]}),
                                tField('port_stats', {'depth' => 1}),
                                tField('cap_admin_status_ind'),
                                tField('cap_admin_status_na_reason'),
                                tField('cap_description_ind'),
                                tField('cap_description_na_reason'),
                                tField('cap_net_deprovisioning_ind'),
                                tField('cap_net_deprovisioning_na_reason'),
                                tField('cap_net_provisioning_ind'),
                                tField('cap_net_provisioning_na_reason'),
                                tField('cap_net_vlan_provisioning_ind'),
                                tField('cap_net_vlan_provisioning_na_reason'),
                                tField('cap_vlan_assignment_ind'),
                                tField('cap_vlan_assignment_na_reason'),
                                tField('cap_voice_vlan_ind'),
                                tField('cap_voice_vlan_na_reason'),
                               );

    %_return_field_overrides = ();

    foreach (keys(%_allowed_members)) {
        $_return_field_overrides{$_} = [];
    }

    %_searchable_fields = (
                           'address'     => [\&ibap_o2i_string, 'address', 'REGEX'],
                           'chassis_serial_number' => [\&ibap_o2i_string, 'chassis_serial_number', 'REGEX'],
                           'name'        => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'model'       => [\&ibap_o2i_string, 'model', 'REGEX'],
                           'class'       => [\&ibap_o2i_string, 'class', 'REGEX'],
                           'location'    => [\&ibap_o2i_string, 'location', 'REGEX'],
                           'description' => [\&ibap_o2i_string, 'description', 'REGEX'],
                           'discovery_member' => [\&ibap_o2i_member_byhostname, 'discovery_member', 'EXACT'],
                           'extattrs'    => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                          );

    %_object_to_ibap = (
                         'address'        => \&ibap_o2i_ignore,
                         'address_object' => \&ibap_o2i_ignore,
                         'chassis_serial_number' => \&ibap_o2i_ignore,
                         'class'          => \&ibap_o2i_ignore,
                         'description'    => \&ibap_o2i_ignore,
                         'interfaces'     => \&ibap_o2i_ignore,
                         'location'       => \&ibap_o2i_ignore,
                         'model'          => \&ibap_o2i_ignore,
                         'name'           => \&ibap_o2i_ignore,
                         'neighbors'      => \&ibap_o2i_ignore,
                         'network'        => \&ibap_o2i_ignore,
                         'network_view'   => \&ibap_o2i_ignore,
                         'networks'       => \&ibap_o2i_ignore,
                         'os_version'     => \&ibap_o2i_ignore,
                         'vendor'         => \&ibap_o2i_ignore,
                         'vlan_infos'     => \&ibap_o2i_ignore,
                         'port_stats'     => \&ibap_o2i_ignore,
                         'cap_admin_status_ind'                => \&ibap_o2i_ignore,
                         'cap_admin_status_na_reason'          => \&ibap_o2i_ignore,
                         'cap_description_ind'                 => \&ibap_o2i_ignore,
                         'cap_description_na_reason'           => \&ibap_o2i_ignore,
                         'cap_net_deprovisioning_ind'          => \&ibap_o2i_ignore,
                         'cap_net_deprovisioning_na_reason'    => \&ibap_o2i_ignore,
                         'cap_net_provisioning_ind'            => \&ibap_o2i_ignore,
                         'cap_net_provisioning_na_reason'      => \&ibap_o2i_ignore,
                         'cap_net_vlan_provisioning_ind'       => \&ibap_o2i_ignore,
                         'cap_net_vlan_provisioning_na_reason' => \&ibap_o2i_ignore,
                         'cap_vlan_assignment_ind'             => \&ibap_o2i_ignore,
                         'cap_vlan_assignment_na_reason'       => \&ibap_o2i_ignore,
                         'cap_voice_vlan_ind'                  => \&ibap_o2i_ignore,
                         'cap_voice_vlan_na_reason'            => \&ibap_o2i_ignore,
                         'discover_now_status'                 => \&ibap_o2i_ignore,
                         'ms_ad_user_data'                     => \&ibap_o2i_ignore,
                         #
                         'extattrs'                            => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                         'extensible_attributes'               => \&ibap_o2i_ignore,
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
        $_return_fields_initialized = 1;

        my $t = Infoblox::IPAM::Address->__new__();
        push @_return_fields,
          tField('address_ref', {
                                sub_fields => $t->__return_fields__(),
                               },
                );

        $t = Infoblox::Grid::MSServer::AdUser::Data->__new__();
        push @_return_fields, tField('ms_ad_user_data', {sub_fields => $t->__return_fields__()});

        #
        $t = Infoblox::Grid::Discovery::DeviceInterface->__new__();
        push @_optional_return_fields,
          tField('interfaces', {
                                sub_fields => $t->__return_fields__(),
                               },
                );

        $t = Infoblox::Grid::Discovery::DeviceNeighbor->__new__();
        push @_optional_return_fields,
          tField('neighbors', {
                                sub_fields => $t->__return_fields__(),
                               },
                );
    }
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

sub __i2o_network_infos__
{
    my ($self, $session, $current, $tempref) = @_;

    my @data;

    if ($tempref->{$current} and ref($tempref->{$current}) eq 'ARRAY') {
        foreach my $item (@{$tempref->{$current}}) {
            my $obj;

            if ($item->{'network'}) {
                $obj = ibap_i2o_generic_object_convert_partial($self, $session, 'network', $item);
            }
 
            if ($item->{'network_str'}) {
                unless ($obj) {
                    $obj = is_ipv4_network($item->{'network_str'}) ? Infoblox::DHCP::Network->__new__() : Infoblox::DHCP::IPv6Network->__new__();
                }
                $obj->network($item->{'network_str'});
            }

            push @data, $obj if $obj;
        }
    }

    return \@data;
}


package Infoblox::Grid::Discovery::DeviceInterface;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_capabilities
                 %_allowed_members %_ibap_to_object %_object_to_ibap
                 @_return_fields $_return_fields_initialized
                 %_name_mappings %_reverse_name_mappings);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'DeviceInterface';
    register_wsdl_type('ib:DeviceInterface','Infoblox::Grid::Discovery::DeviceInterface');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'admin_status'     => {'readonly' => 1, 'simple' => 'asis', 'enum' => ['UP', 'DOWN']},
                         'description'      => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'duplex'           => {'readonly' => 1, 'simple' => 'asis', 'enum' => ['FULL', 'HALF', 'UNKNOWN', 'UNSUPPORTED']},
                         'ifaddr_infos'     => {'readonly' => 1, 'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::IFAddrInfo' => 1}},
                         'index'            => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'last_change'      => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string_to_datetime},
                         'link_aggregation' => {'readonly' => 1, 'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'mac'              => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'name'             => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'oper_status'      => {'readonly' => 1, 'simple' => 'asis', 'enum' => ['UP', 'DOWN']},
                         'device'           => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::Device' => 1}},
                         'port_fast'        => {'readonly' => 1, 'simple' => 'asis', 'enum' => ['ENABLED', 'DISABLED']},
                         'speed'            => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_ulong},
                         'trunk_status'     => {'readonly' => 1, 'simple' => 'asis', 'enum' => ['ON', 'OFF']},
                         'type'             => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'vlan_infos'       => {'readonly' => 1, 'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::VLANInfo' => 1}},
                         'reserved_object'  => {'readonly' => 1, 'validator' => {'Infoblox::DHCP::HostAddr' => 1, 'Infoblox::DHCP::IPv6HostAddr' => 1, 'Infoblox::DHCP::FixedAddr' => 1, 'Infoblox::DHCP::IPv6FixedAddr' => 1, 'Infoblox::Grid::Member' => 1}},
                         'admin_status_task_info' => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::Port::Config::AdminStatus' => 1}},
                         'description_task_info'  => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::Port::Config::Description' => 1}},
                         'vlan_info_task_info'    => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::Port::Config::VlanInfo' => 1}},
                         'cap_if_admin_status_ind'                => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_if_admin_status_na_reason'          => {'readonly' => 1, 'simple' => 'asis'},
                         'cap_if_description_ind'                 => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_if_description_na_reason'           => {'readonly' => 1, 'simple' => 'asis'},
                         'cap_if_net_deprovisioning_ipv4_ind'     => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_if_net_deprovisioning_ipv4_na_reason' => {'readonly' => 1, 'simple' => 'asis'},
                         'cap_if_net_provisioning_ipv4_ind'       => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_if_net_provisioning_ipv4_na_reason' => {'readonly' => 1, 'simple' => 'asis'},
                         'cap_if_net_deprovisioning_ipv6_ind'     => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_if_net_deprovisioning_ipv6_na_reason' => {'readonly' => 1, 'simple' => 'asis'},
                         'cap_if_net_provisioning_ipv6_ind'       => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_if_net_provisioning_ipv6_na_reason' => {'readonly' => 1, 'simple' => 'asis'},
                         'cap_if_vlan_assignment_ind'             => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_if_vlan_assignment_na_reason'       => {'readonly' => 1, 'simple' => 'asis'},
                         'cap_if_voice_vlan_ind'                  => {'readonly' => 1, 'simple' => 'bool'},
                         'cap_if_voice_vlan_na_reason'            => {'readonly' => 1, 'simple' => 'asis'},
                         'extattrs'                               => {special => 'extensible_attributes'},
                         'extensible_attributes'                  => {special => 'extensible_attributes'},
                         'vrf_description'                        => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'vrf_name'                               => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'vrf_route_distinguisher'                => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'ms_ad_user_data'                        => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
                         'network_view'                           => {'readonly' => 1, 'validator' => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'device' => 'parent',
                       'reserved_object'        => 'reserved_obj',
                       'admin_status_task_info' => 'target_admin_status_task_info',
                       'description_task_info'  => 'target_description_task_info',
                       'vlan_info_task_info'    => 'target_vlan_info_task_info',
                       'vrf_route_distinguisher' => 'vrf_rd',
                       'extattrs'               => 'extensible_attributes',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'ifaddr_infos'     => \&ibap_i2o_generic_object_list_convert,
                        'link_aggregation' => \&ibap_i2o_boolean,
                        'parent'           => \&ibap_i2o_generic_object_convert_partial,
                        'vlan_infos'       => \&ibap_i2o_generic_object_list_convert,
                        'reserved_obj'     => \&ibap_i2o_generic_object_convert_partial,
                        'ms_ad_user_data'  => \&ibap_i2o_generic_object_convert,
                        'target_admin_status_task_info' => \&ibap_i2o_generic_object_convert,
                        'target_description_task_info'  => \&ibap_i2o_generic_object_convert,
                        'target_vlan_info_task_info'    => \&ibap_i2o_generic_object_convert,
                        'extensible_attributes'         => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'network_view'                   => \&ibap_i2o_object_name,
                       );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('admin_status'),
                       tField('description'),
                       tField('duplex'),
                       tField('index'),
                       tField('last_change'),
                       tField('link_aggregation'),
                       tField('mac'),
                       tField('name'),
                       tField('network_view', {'sub_fields' => [tField('name')]}),
                       tField('oper_status'),
                       tField('parent', {'sub_fields' => [tField('name'), tField('address')]}),
                       tField('port_fast'),
                       tField('speed'),
                       tField('trunk_status'),
                       tField('type'),
                       tField('vlan_infos', {'depth' => 1}),
                       tField('vrf_description'),
                       tField('vrf_name'),
                       tField('vrf_rd'),
                       tField('reserved_obj', {'no_access_ok' => 1, 'depth' => 1}), # we cannot have tObjField due to recursion
                       tField('cap_if_admin_status_ind'),
                       tField('cap_if_admin_status_na_reason'),
                       tField('cap_if_description_ind'),
                       tField('cap_if_description_na_reason'),
                       tField('cap_if_net_deprovisioning_ipv4_ind'),
                       tField('cap_if_net_deprovisioning_ipv4_na_reason'),
                       tField('cap_if_net_provisioning_ipv4_ind'),
                       tField('cap_if_net_provisioning_ipv4_na_reason'),
                       tField('cap_if_net_deprovisioning_ipv6_ind'),
                       tField('cap_if_net_deprovisioning_ipv6_na_reason'),
                       tField('cap_if_net_provisioning_ipv6_ind'),
                       tField('cap_if_net_provisioning_ipv6_na_reason'),
                       tField('cap_if_vlan_assignment_ind'),
                       tField('cap_if_vlan_assignment_na_reason'),
                       tField('cap_if_voice_vlan_ind'),
                       tField('cap_if_voice_vlan_na_reason'),
                       return_fields_extensible_attributes(),
                      );

    %_object_to_ibap = (
                         'admin_status'     => \&ibap_o2i_ignore,
                         'description'      => \&ibap_o2i_ignore,
                         'duplex'           => \&ibap_o2i_ignore,
                         'ifaddr_infos'     => \&ibap_o2i_ignore,
                         'index'            => \&ibap_o2i_ignore,
                         'last_change'      => \&ibap_o2i_ignore,
                         'link_aggregation' => \&ibap_o2i_ignore,
                         'mac'              => \&ibap_o2i_ignore,
                         'name'             => \&ibap_o2i_ignore,
                         'oper_status'      => \&ibap_o2i_ignore,
                         'device'           => \&ibap_o2i_ignore,
                         'port_fast'        => \&ibap_o2i_ignore,
                         'speed'            => \&ibap_o2i_ignore,
                         'trunk_status'     => \&ibap_o2i_ignore,
                         'type'             => \&ibap_o2i_ignore,
                         'vlan_infos'       => \&ibap_o2i_ignore,
                         'reserved_object'  => \&ibap_o2i_ignore,
                         'admin_status_task_info' => \&ibap_o2i_ignore,
                         'description_task_info'  => \&ibap_o2i_ignore,
                         'vlan_info_task_info'    => \&ibap_o2i_ignore,
                         'cap_if_admin_status_ind'                => \&ibap_o2i_ignore,
                         'cap_if_admin_status_na_reason'          => \&ibap_o2i_ignore,
                         'cap_if_description_ind'                 => \&ibap_o2i_ignore,
                         'cap_if_description_na_reason'           => \&ibap_o2i_ignore,
                         'cap_if_net_deprovisioning_ipv4_ind'     => \&ibap_o2i_ignore,
                         'cap_if_net_deprovisioning_ipv4_na_reason' => \&ibap_o2i_ignore,
                         'cap_if_net_provisioning_ipv4_ind'       => \&ibap_o2i_ignore,
                         'cap_if_net_provisioning_ipv4_na_reason' => \&ibap_o2i_ignore,
                         'cap_if_net_deprovisioning_ipv6_ind'     => \&ibap_o2i_ignore,
                         'cap_if_net_deprovisioning_ipv6_na_reason' => \&ibap_o2i_ignore,
                         'cap_if_net_provisioning_ipv6_ind'       => \&ibap_o2i_ignore,
                         'cap_if_net_provisioning_ipv6_na_reason' => \&ibap_o2i_ignore,
                         'cap_if_vlan_assignment_ind'             => \&ibap_o2i_ignore,
                         'cap_if_vlan_assignment_na_reason'       => \&ibap_o2i_ignore,
                         'cap_if_voice_vlan_ind'                  => \&ibap_o2i_ignore,
                         'cap_if_voice_vlan_na_reason'            => \&ibap_o2i_ignore,
                         'ms_ad_user_data'                        => \&ibap_o2i_ignore,
                         #
                         'extattrs'                               => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                         'extensible_attributes'                  => \&ibap_o2i_ignore,
                         'network_view'                           => \&ibap_o2i_ignore,
                         'vrf_name'                               => \&ibap_o2i_ignore,
                         'vrf_description'                        => \&ibap_o2i_ignore,
                         'vrf_route_distinguisher'                => \&ibap_o2i_ignore,

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
        $_return_fields_initialized = 1;

        my (%tmp, $t);

        %tmp = (
                ifaddr_infos                  => 'Infoblox::Grid::Discovery::IFAddrInfo',
                target_admin_status_task_info => 'Infoblox::Grid::Discovery::Port::Config::AdminStatus',
                target_description_task_info  => 'Infoblox::Grid::Discovery::Port::Config::Description',
                target_vlan_info_task_info    => 'Infoblox::Grid::Discovery::Port::Config::VlanInfo',
                ms_ad_user_data               => 'Infoblox::Grid::MSServer::AdUser::Data',
        );

        foreach (keys %tmp) {
            $t = $tmp{$_}->__new__();
            push @_return_fields, tField($_, { sub_fields => $t->__return_fields__() });
        }

    }
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

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
             'link_aggregation',
             'cap_if_admin_status_ind',
             'cap_if_description_ind',
             'cap_if_net_deprovisioning_ipv4_ind',
             'cap_if_net_provisioning_ipv4_ind',
             'cap_if_net_deprovisioning_ipv6_ind',
             'cap_if_net_provisioning_ipv6_ind',
             'cap_if_vlan_assignment_ind',
             'cap_if_voice_vlan_ind',
            ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

package Infoblox::Grid::Discovery::StatusInfo;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'discovery_status_info';
    register_wsdl_type('ib:discovery_status_info','Infoblox::Grid::Discovery::StatusInfo');

    %_allowed_members = (
                         'message'   => {'simple' => 'asis', 'required' => 1, 'validator' => \&ibap_value_o2i_string},
                         'status'    => {'simple' => 'asis', 'required' => 1, 'enum' => ['OK', 'ERROR', 'NON_REACHABLE']},
                         'timestamp' => {'simple' => 'asis', 'required' => 1, 'validator' => \&ibap_value_o2i_string_to_datetime},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'message'   => \&ibap_o2i_string,
                        'status'    => \&ibap_o2i_string,
                        'timestamp' => \&ibap_o2i_string,
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::Grid::Discovery::Status;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_capabilities
                 %_allowed_members %_ibap_to_object %_object_to_ibap
                 @_return_fields %_searchable_fields %_return_field_overrides);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::RO);

BEGIN {
    $_object_type = 'DiscoveryStatus';
    register_wsdl_type('ib:DiscoveryStatus','Infoblox::Grid::Discovery::Status');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'address'                 => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_ipaddr},
                         'existence_info'          => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::StatusInfo' => 1}},
                         'fingerprint_enabled'     => {'readonly' => 1, 'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'fingerprint_info'        => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::StatusInfo' => 1}},
                         'first_seen'              => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string_to_datetime},
                         'last_action'             => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'last_seen'               => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string_to_datetime},
                         'last_timestamp'          => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string_to_datetime},
                         'name'                    => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'network_view'            => {'readonly' => 1, 'validator' => \&ibap_value_o2i_string},
                         'reachable_info'          => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::StatusInfo' => 1}},
                         'snmp_collection_enabled' => {'readonly' => 1, 'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'snmp_collection_info'    => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::StatusInfo' => 1}},
                         'snmp_credential_info'    => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::StatusInfo' => 1}},
                         'cli_credential_info'     => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::StatusInfo' => 1}},
                         'cli_collection_enabled'  => {'readonly' => 1, 'simple' => 'bool'},
                         'status'                  => {'readonly' => 1, 'simple' => 'asis', 'enum' => ['OK', 'ERROR', 'NON_REACHABLE']},
                         'type'                    => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'existence_info'          => \&ibap_i2o_generic_object_convert,
                        'fingerprint_info'        => \&ibap_i2o_generic_object_convert,
                        'network_view'            => \&ibap_i2o_object_name,
                        'reachable_info'          => \&ibap_i2o_generic_object_convert,
                        'snmp_collection_info'    => \&ibap_i2o_generic_object_convert,
                        'snmp_credential_info'    => \&ibap_i2o_generic_object_convert,
                        'cli_credential_info'     => \&ibap_i2o_generic_object_convert,
                       );

    @_return_fields = (
                       tField('address'),
                       tField('existence_info', {'depth' => 1}),
                       tField('fingerprint_enabled'),
                       tField('fingerprint_info', {'depth' => 1}),
                       tField('first_seen'),
                       tField('last_action'),
                       tField('last_seen'),
                       tField('last_timestamp'),
                       tField('name'),
                       tField('network_view', {'sub_fields' => [tField('name')]}),
                       tField('reachable_info', {'depth' => 1}),
                       tField('snmp_collection_enabled'),
                       tField('snmp_collection_info', {'depth' => 1}),
                       tField('snmp_credential_info', {'depth' => 1}),
                       tField('cli_credential_info', {'depth' => 1}),
                       tField('cli_collection_enabled'),
                       tField('status'),
                       tField('type'),
                      );

    %_return_field_overrides = ();

    foreach (keys(%_allowed_members)) {
        $_return_field_overrides{$_} = [];
    }

    %_searchable_fields = (
                           'address'      => [\&ibap_o2i_string, 'address', 'REGEX'],
                           'name'         => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'network_view' => [\&ibap_o2i_network_view, 'network_view', 'EXACT'],
                          );

    %_object_to_ibap = (
                        'address'                 => \&ibap_o2i_ignore,
                        'existence_info'          => \&ibap_o2i_ignore,
                        'fingerprint_enabled'     => \&ibap_o2i_ignore,
                        'fingerprint_info'        => \&ibap_o2i_ignore,
                        'first_seen'              => \&ibap_o2i_ignore,
                        'last_action'             => \&ibap_o2i_ignore,
                        'last_seen'               => \&ibap_o2i_ignore,
                        'last_timestamp'          => \&ibap_o2i_ignore,
                        'name'                    => \&ibap_o2i_ignore,
                        'network_view'            => \&ibap_o2i_ignore,
                        'reachable_info'          => \&ibap_o2i_ignore,
                        'snmp_collection_enabled' => \&ibap_o2i_ignore,
                        'snmp_collection_info'    => \&ibap_o2i_ignore,
                        'snmp_credential_info'    => \&ibap_o2i_ignore,
                        'cli_credential_info'     => \&ibap_o2i_ignore,
                        'cli_collection_enabled'  => \&ibap_o2i_ignore,
                        'status'                  => \&ibap_o2i_ignore,
                        'type'                    => \&ibap_o2i_ignore,
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
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

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach ('fingerprint_enabled', 'fingerprint_enabled', 'cli_collection_enabled') {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __get_override_hook__
{
    my ($object_type, $session, $args_ref) = @_;

    #
    $args_ref->{'network_view'} = 'is_default:=:=:boolean:=:=:1' unless defined $args_ref->{'network_view'};

    return set_error_codes(9999, 'continue', $session);
}

sub __search_override_hook__
{
    my ($object_type, $session, $args_ref) = @_;

    #
    $args_ref->{'network_view'} = 'is_default:=:=:boolean:=:=:1' unless defined $args_ref->{'network_view'};

    return set_error_codes(9999, 'continue', $session);
}

package Infoblox::Grid::Discovery::DeviceNeighbor;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_capabilities
                 $_return_fields_initialized
                 %_allowed_members %_ibap_to_object
                 %_name_mappings %_reverse_name_mappings
                 @_return_fields);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'DeviceEndHost';
    register_wsdl_type('ib:DeviceEndHost','Infoblox::Grid::Discovery::DeviceNeighbor');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'address'        => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_ipaddr},
                         'device'         => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::Device' => 1}},
                         'address_object' => {'readonly' => 1, 'validator' => {'Infoblox::IPAM::Address' => 1}},
                         'name'           => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'mac'            => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'interface'      => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}},
                         'vlan_infos'     => {'readonly' => 1, 'array' => 1, 'validator' => {'Infoblox::Grid::Discovery::VLANInfo' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'address_object' => 'address_ref',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'address_ref' => \&ibap_i2o_generic_object_convert,
                        'device'      => \&ibap_i2o_generic_object_convert,
                        'interface'   => \&ibap_i2o_generic_object_convert,
                        'vlan_infos'  => \&ibap_i2o_generic_object_list_convert,
                       );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('address'),
                       tField('name'),
                       tField('mac'),
                       tField('vlan_infos', {'depth' => 1}),
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
        $_return_fields_initialized = 1;

        my $t = Infoblox::IPAM::Address->__new__();
        push @_return_fields,
          tField('address_ref', {
                                 sub_fields => $t->__return_fields__(),
                                },
                );

        $t = Infoblox::Grid::Discovery::Device->__new__();
        push @_return_fields,
          tField('device', {
                            sub_fields => $t->__return_fields__(),
                           },
                );

        $t = Infoblox::Grid::Discovery::DeviceInterface->__new__();
        push @_return_fields,
          tField('interface', {
                               sub_fields => $t->__return_fields__(),
                              },
                );
    }
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


package Infoblox::Grid::Discovery::DSBundle;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_capabilities %_allowed_members
                 @_return_fields %_searchable_fields %_return_field_overrides);
@ISA = qw(Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'DeviceSupportBundle';
    register_wsdl_type('ib:DeviceSupportBundle','Infoblox::Grid::Discovery::DSBundle');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'author'  => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'name'    => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'version' => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'integrated_ind' => {'readonly' => 1, 'simple' => 'bool'},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('author'),
                       tField('name'),
                       tField('version'),
                       tField('integrated_ind'),
                      );

    %_searchable_fields = (
                           'name' => [\&ibap_o2i_string, 'name', 'REGEX'],
                          );

    %_return_field_overrides = ();

    foreach (keys(%_allowed_members)) {
        $_return_field_overrides{$_} = [];
    }
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
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

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach ('integrated_ind') {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

#
#
#

sub __add_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'add' not allowed for this object", $session);
    return;
}

sub __modify_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'modify' not allowed for this object", $session);
    return;
}

package Infoblox::Grid::Discovery::DiagnosticsStatus;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA %_allowed_members);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    %_allowed_members = (
                         'id'     => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'start'  => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'end'    => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'status' => {'readonly' => 1, 'simple' => 'asis', 'enum' => ['COMPLETED', 'FAILED', 'INPROGRESS']},
                         'text'   => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}


package Infoblox::Grid::Discovery::CLICredential;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap @_return_fields %_name_mappings %_reverse_name_mappings);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'cli_credential';
    register_wsdl_type('ib:cli_credential','Infoblox::Grid::Discovery::CLICredential');

    %_allowed_members = (
                         'id'       => {'simple' => 'asis', 'readonly' => 1, 'validator' => \&ibap_value_o2i_uint},
                         'user'     => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'password' => 0,
                         'comment'  => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'type'     => {'simple' => 'asis', 'mandatory' => 1, 'enum' => ['ENABLE_SSH', 'ENABLE_TELNET', 'SSH', 'TELNET']},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'type' => 'credential_type',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_object_to_ibap = (
                        'id'        => \&ibap_o2i_uint, # read-only but we should send it back to the server
                        'user'      => \&ibap_o2i_string,
                        'password'  => \&ibap_o2i_string_skip_undef,
                        'comment'   => \&ibap_o2i_string,
                        'type'      => \&ibap_o2i_string,
                       );

    @_return_fields = (
                       tField('id'),
                       tField('user'),
                       tField('comment'),
                       tField('credential_type'),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}

sub password
{
    my $self=shift;

    my $res = $self->__accessor_scalar__({'name' => 'password', 'writeonly' => 1, 'validator' => \&ibap_value_o2i_string}, @_);

    unless ($self->{'__initializing_from_ibap__'}) {
        delete $self->{'id'} if (@_ and defined $res); # remove id if password has been changed
    }

    return $res;
}

package Infoblox::Grid::Discovery::TestCredential;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA %_allowed_members);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    %_allowed_members = (
                         'id'     => {'readonly' => 1},
                         'end'    => {'readonly' => 1},
                         'text'   => {'readonly' => 1},
                         'status' => {'readonly' => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

package Infoblox::Grid::Discovery::Device::PortStatistics;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap @_return_fields);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'device_port_statistics';
    register_wsdl_type('ib:device_port_statistics','Infoblox::Grid::Discovery::Device::PortStatistics');

    %_allowed_members = (
                         'admin_down_oper_down_count' => {'readonly' => 1, 'simple' => 'asis'},
                         'admin_up_oper_down_count'   => {'readonly' => 1, 'simple' => 'asis'},
                         'admin_up_oper_up_count'     => {'readonly' => 1, 'simple' => 'asis'},
                         'interfaces_count'           => {'readonly' => 1, 'simple' => 'asis'},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'admin_down_oper_down_count' => \&ibap_o2i_ignore,
                        'admin_up_oper_down_count'   => \&ibap_o2i_ignore,
                        'admin_up_oper_up_count'     => \&ibap_o2i_ignore,
                        'interfaces_count'           => \&ibap_o2i_ignore,
                       );

    @_return_fields = (
                       tField('admin_down_oper_down_count'),
                       tField('admin_up_oper_down_count'),
                       tField('admin_up_oper_up_count'),
                       tField('interfaces_count'),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}

package Infoblox::Grid::Discovery::Port::Control::TaskDetails;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap @_return_fields %_name_mappings %_reverse_name_mappings);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'port_control_task_details';
    register_wsdl_type('ib:port_control_task_details','Infoblox::Grid::Discovery::Port::Control::TaskDetails');

    %_allowed_members = (
                         'id'              => {'simple' => 'asis', 'readonly' => 1},
                         'status'          => {'simple' => 'asis', 'readonly' => 1},
                         'is_synchronized' => {'simple' => 'bool', 'readonly' => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'id'     => 'task_id',
                       'status' => 'task_status',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_object_to_ibap = (
                        'id'              => \&ibap_o2i_ignore,
                        'status'          => \&ibap_o2i_ignore,
                        'is_synchronized' => \&ibap_o2i_ignore,
                       );

    @_return_fields = (
                       tField('task_id'),
                       tField('task_status'),
                       tField('is_synchronized'),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}

package Infoblox::Grid::Discovery::Port::Config::AdminStatus;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_object_to_ibap @_return_fields %_name_mappings %_reverse_name_mappings);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'port_config_admin_status';
    register_wsdl_type('ib:port_config_admin_status','Infoblox::Grid::Discovery::Port::Config::AdminStatus');

    %_allowed_members = (
                         'status'       => {'simple' => 'asis', 'readonly' => 1},
                         'task_details' => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::Port::Control::TaskDetails' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'status'  => 'target_status',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'task_details' => \&ibap_i2o_generic_object_convert,
                       );

    %_object_to_ibap = (
                        'status'       => \&ibap_o2i_ignore,
                        'task_details' => \&ibap_o2i_ignore,
                       );

    @_return_fields = (
                       tField('target_status'),
                       tField('task_details', {'depth' => 1}),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}

package Infoblox::Grid::Discovery::Port::Config::Description;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_object_to_ibap @_return_fields %_name_mappings %_reverse_name_mappings);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'port_config_description';
    register_wsdl_type('ib:port_config_description','Infoblox::Grid::Discovery::Port::Config::Description');

    %_allowed_members = (
                         'description'  => {'simple' => 'asis', 'readonly' => 1},
                         'task_details' => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::Port::Control::TaskDetails' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'description' => 'target_description',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'task_details' => \&ibap_i2o_generic_object_convert,
                       );

    %_object_to_ibap = (
                        'description'  => \&ibap_o2i_ignore,
                        'task_details' => \&ibap_o2i_ignore,
                       );

    @_return_fields = (
                       tField('target_description'),
                       tField('task_details', {'depth' => 1}),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}

package Infoblox::Grid::Discovery::Port::Config::VlanInfo;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_object_to_ibap @_return_fields %_name_mappings %_reverse_name_mappings);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'port_config_vlan_info';
    register_wsdl_type('ib:port_config_vlan_info','Infoblox::Grid::Discovery::Port::Config::VlanInfo');

    %_allowed_members = (
                         'data_vlan_info'  => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::VLANInfo' => 1}},
                         'voice_vlan_info' => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::VLANInfo' => 1}},
                         'task_details'    => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::Port::Control::TaskDetails' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'data_vlan_info'  => 'target_data_vlan_info',
                       'voice_vlan_info' => 'target_voice_vlan_info',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'target_data_vlan_info'  => \&ibap_i2o_generic_object_convert,
                        'target_voice_vlan_info' => \&ibap_i2o_generic_object_convert,
                        'task_details'           => \&ibap_i2o_generic_object_convert,
                       );

    %_object_to_ibap = (
                        'target_data_vlan_info'  => \&ibap_o2i_ignore,
                        'target_voice_vlan_info' => \&ibap_o2i_ignore,
                        'task_details'           => \&ibap_o2i_ignore,
                       );

    @_return_fields = (
                       tField('target_data_vlan_info', {'depth' => 1}),
                       tField('target_voice_vlan_info', {'depth' => 1}),
                       tField('task_details', {'depth' => 1}),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}

package Infoblox::Grid::Discovery::Port::Control::Info;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_object_to_ibap @_return_fields $_return_fields_initialized %_name_mappings %_reverse_name_mappings);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'port_control_info';
    register_wsdl_type('ib:port_control_info','Infoblox::Grid::Discovery::Port::Control::Info');

    %_allowed_members = (
                         'device'          => {'validator' => {'Infoblox::Grid::Discovery::Device' => 1}},
                         'interface'       => {'mandatory' => 1, 'validator' => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}},
                         'data_vlan_info'  => {'validator' => {'Infoblox::Grid::Discovery::VLANInfo' => 1}},
                         'voice_vlan_info' => {'validator' => {'Infoblox::Grid::Discovery::VLANInfo' => 1}},
                         'admin_status'    => {'simple' => 'asis', 'enum' => ['UP', 'DOWN']},
                         'description'     => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'parent'          => {'validator' => {'Infoblox::Grid::Discovery::DeviceInterface' => 1, 'Infoblox::DNS::Host' => 1, 'Infoblox::DHCP::FixedAddr' => 1, 'Infoblox::DHCP::IPv6FixedAddr' => 1, 'Infoblox::Grid::Member' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'parent' => 'parent_obj',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'device'          => \&ibap_i2o_generic_object_convert,
                        'interface'       => \&ibap_i2o_generic_object_convert,
                        'data_vlan_info'  => \&ibap_i2o_generic_object_convert,
                        'voice_vlan_info' => \&ibap_i2o_generic_object_convert,
                        'parent_obj'      => \&ibap_i2o_generic_object_convert,
                       );

    %_object_to_ibap = (
                        'device'          => \&ibap_o2i_object_only_by_oid_skip_undef,
                        'interface'       => \&ibap_o2i_object_only_by_oid,
                        'data_vlan_info'  => \&ibap_o2i_generic_struct_convert,
                        'voice_vlan_info' => \&ibap_o2i_generic_struct_convert,
                        'admin_status'    => \&ibap_o2i_string,
                        'description'     => \&ibap_o2i_string,
                        'parent'          => \&ibap_o2i_object_only_by_oid_skip_undef,
                       );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('admin_status'),
                       tField('description'),
                       tField('parent_obj', {'no_access_ok' => 1}),
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
        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::Discovery::Device->__new__();
        push @_return_fields,
          tField('device', {
                            'no_access_ok' => 1,
                            'sub_fields' => $t->__return_fields__(),
                           },
                );

        $t = Infoblox::Grid::Discovery::DeviceInterface->__new__();
        push @_return_fields,
          tField('interface', {
                               'no_access_ok' => 1,
                               'sub_fields' => $t->__return_fields__(),
                              },
                );
    }
}

sub __ibap_object_type__
{
    return $_object_type;
}

package Infoblox::Grid::Discovery::DeviceComponent;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_capabilities %_allowed_members %_ibap_to_object %_object_to_ibap @_return_fields $_return_fields_initialized %_name_mappings %_reverse_name_mappings %_searchable_fields);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::RO);

BEGIN {
    $_object_type = 'DeviceComponent';
    register_wsdl_type('ib:DeviceComponent','Infoblox::Grid::Discovery::DeviceComponent');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'class'          => {'readonly' => 1, 'simple' => 'asis'},
                         'component_name' => {'readonly' => 1, 'simple' => 'asis'},
                         'description'    => {'readonly' => 1, 'simple' => 'asis'},
                         'model'          => {'readonly' => 1, 'simple' => 'asis'},
                         'device'         => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Discovery::Device' => 1}},
                         'serial'         => {'readonly' => 1, 'simple' => 'asis'},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'device' => 'parent',
                       'serial' => 'serial_no',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'parent' => \&ibap_i2o_generic_object_convert,
                       );

    %_object_to_ibap = (
                        'class'          => \&ibap_o2i_ignore,
                        'component_name' => \&ibap_o2i_ignore,
                        'description'    => \&ibap_o2i_ignore,
                        'model'          => \&ibap_o2i_ignore,
                        'device'         => \&ibap_o2i_ignore,
                        'serial'         => \&ibap_o2i_ignore,
                       );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('class'),
                       tField('component_name'),
                       tField('description'),
                       tField('model'),
                       tField('serial_no'),
                      );

    %_searchable_fields = (
                           'device'      => [\&ibap_o2i_object_by_oid_or_name, 'parent', 'EXACT'],
                           'description' => [\&ibap_o2i_string, 'description', 'REGEX'],
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
        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::Discovery::Device->__new__();
        push @_return_fields,
          tField('parent', {
                            'no_access_ok' => 1,
                            'sub_fields' => $t->__return_fields__(),
                           },
                );
    }
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


package Infoblox::Grid::Discovery::Properties::BlackoutSetting;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_object_to_ibap @_return_fields $_return_fields_initialized);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'blackout_setting';
    register_wsdl_type('ib:blackout_setting','Infoblox::Grid::Discovery::Properties::BlackoutSetting');

    %_allowed_members = (
                         'enable_blackout'   => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'blackout_duration' => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'blackout_schedule' => {'validator' => {'Infoblox::Grid::ScheduleSetting' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'blackout_schedule' => \&ibap_i2o_generic_object_convert,
                       );

    %_object_to_ibap = (
                        'enable_blackout'   => \&ibap_o2i_boolean,
                        'blackout_duration' => \&ibap_o2i_uint,
                        'blackout_schedule' => \&ibap_o2i_generic_struct_convert,
                       );

    $_return_fields_initialized = 0;
    @_return_fields = (
                       tField('enable_blackout'),
                       tField('blackout_duration'),
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
        $_return_fields_initialized = 1;
        my $t = Infoblox::Grid::ScheduleSetting->__new__();
        push @_return_fields, tField('blackout_schedule', { sub_fields => $t->__return_fields__() });
    }
}

sub __ibap_object_type__
{
    return $_object_type;
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'enable_blackout'} = 0 unless defined $$ibap_object_ref{'enable_blackout'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::VDiscoveryTask;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides %_capabilities
            $_return_fields_initialized);

@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'CDiscoveryTask';
    register_wsdl_type('ib:CDiscoveryTask', 'Infoblox::Grid::VDiscoveryTask');

    %_capabilities = (
        'depth'                => 0,
        'implicit_defaults'    => 1,
        'single_serialization' => 1,
    );

    %_allowed_members = (
        name => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
        member => {validator => \&ibap_value_o2i_string},
        scheduled_run => {validator => {'Infoblox::Grid::ScheduleSetting' => 1}},
        state => {simple => 'asis', readonly => 1},
        enabled => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        comment => {simple => 'asis', validator => \&ibap_value_o2i_string},
        public_network_view_mapping_policy => {simple => 'asis', mandatory => 1, enum => ['DIRECT', 'AUTO_CREATE']},
        public_network_view => {validator => \&ibap_value_o2i_string},
        private_network_view_mapping_policy => {simple => 'asis', mandatory => 1, enum => ['DIRECT', 'AUTO_CREATE']},
        private_network_view => {validator => \&ibap_value_o2i_string},
        driver_type => {simple => 'asis', enum => ['AWS', 'AZURE', 'OPENSTACK', 'VMWARE']},
        fqdn_or_ip => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
        protocol => {simple => 'asis', mandatory => 1, enum => ['HTTP', 'HTTPS']},
        port => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_uint},
        username => {simple => 'asis', validator => \&ibap_value_o2i_string},
        password => {writeonly => 1, validator => \&ibap_value_o2i_string},
        state_msg => {simple => 'asis', readonly => 1},
        last_run_time => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string_to_datetime},
        update_metadata => {mandatory => 1, simple => 'bool', validator => \&ibap_value_o2i_boolean},
        merge_data => {mandatory => 1, simple => 'bool', validator => \&ibap_value_o2i_boolean},
        auto_consolidate_managed_tenant => {mandatory => 1, simple => 'bool', validator => \&ibap_value_o2i_boolean},
        auto_consolidate_managed_vm => {mandatory => 1, simple => 'bool', validator => \&ibap_value_o2i_boolean},
        auto_consolidate_cloud_ea => {mandatory => 1, simple => 'bool', validator => \&ibap_value_o2i_boolean},
        auto_create_dns_record => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        auto_create_dns_record_type => {simple => 'asis', enum => ['HOST_RECORD', 'A_PTR_RECORD']},
        auto_create_dns_hostname_template => {simple => 'asis', validator => \&ibap_value_o2i_string},
        credentials_type => {simple => 'asis', enum => ['DIRECT', 'INDIRECT']},
        allow_unsecured_connection => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        update_dns_view_public_ip => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        dns_view_public_ip => {validator => \&ibap_value_o2i_string},
        update_dns_view_private_ip => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        dns_view_private_ip => {validator => \&ibap_value_o2i_string},
        identity_version => {simple => 'asis', enum => ['KEYSTONE_V2', 'KEYSTONE_V3']},
        domain_name => {simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
        member => \&ibap_i2o_member_byhostname,
        scheduled_run => \&ibap_i2o_generic_object_convert,
        public_network_view => \&ibap_i2o_object_name,
        private_network_view => \&ibap_i2o_object_name,
        dns_view_public_ip => \&ibap_i2o_object_name,
        dns_view_private_ip => \&ibap_i2o_object_name,
    );

    %_object_to_ibap = (
        name => \&ibap_o2i_string,
        member => \&ibap_o2i_member_byhostname,
        scheduled_run => \&ibap_o2i_generic_struct_convert,
        state => \&ibap_o2i_ignore,
        enabled => \&ibap_o2i_boolean,
        comment => \&ibap_o2i_string,
        public_network_view_mapping_policy => \&ibap_o2i_string,
        public_network_view => \&ibap_o2i_network_view,
        private_network_view_mapping_policy => \&ibap_o2i_string,
        private_network_view => \&ibap_o2i_network_view,
        driver_type   => \&ibap_o2i_string,
        fqdn_or_ip => \&ibap_o2i_string,
        protocol => \&ibap_o2i_string,
        port => \&ibap_o2i_uint,
        username => \&ibap_o2i_string,
        password => \&ibap_o2i_string,
        state_msg => \&ibap_o2i_ignore,
        last_run_time => \&ibap_o2i_ignore,
        update_metadata => \&ibap_o2i_boolean,
        merge_data => \&ibap_o2i_boolean,
        auto_consolidate_managed_tenant => \&ibap_o2i_boolean,
        auto_consolidate_managed_vm => \&ibap_o2i_boolean,
        auto_consolidate_cloud_ea => \&ibap_o2i_boolean,
        auto_create_dns_record => \&ibap_o2i_boolean,
        auto_create_dns_record_type => \&ibap_o2i_string,
        auto_create_dns_hostname_template => \&ibap_o2i_string,
        credentials_type => \&ibap_o2i_string,
        allow_unsecured_connection => \&ibap_o2i_boolean,
        update_dns_view_public_ip => \&ibap_o2i_boolean,
        dns_view_public_ip => \&ibap_o2i_view,
        update_dns_view_private_ip => \&ibap_o2i_boolean,
        dns_view_private_ip => \&ibap_o2i_view,
        identity_version => \&ibap_o2i_string,
        domain_name => \&ibap_o2i_string,
    );

    %_name_mappings = (
        last_run_time => 'last_run',
        state => 'task_state',
        state_msg => 'task_state_msg',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
        tField('name'),
        tField('member', {sub_fields => [tField('host_name')]}),
        tField('task_state'),
        tField('enabled'),
        tField('comment'),
        tField('public_network_view_mapping_policy'),
        tField('public_network_view', {sub_fields => [tField('name')], default_no_access_ok => 1}),
        tField('private_network_view_mapping_policy'),
        tField('private_network_view', {sub_fields => [tField('name')], default_no_access_ok => 1}),
        tField('driver_type'),
        tField('fqdn_or_ip'),
        tField('protocol'),
        tField('port'),
        tField('username'),
        tField('task_state_msg'),
        tField('last_run'),
        tField('update_metadata'),
        tField('merge_data'),
        tField('auto_consolidate_managed_tenant'),
        tField('auto_consolidate_managed_vm'),
        tField('auto_consolidate_cloud_ea'),
        tField('auto_create_dns_record'),
        tField('auto_create_dns_record_type'),
        tField('auto_create_dns_hostname_template'),
        tField('credentials_type'),
        tField('allow_unsecured_connection'),
        tField('update_dns_view_public_ip'),
        tField('dns_view_public_ip', {sub_fields => [tField('name')], default_no_access_ok => 1}),
        tField('update_dns_view_private_ip'),
        tField('dns_view_private_ip', {sub_fields => [tField('name')], default_no_access_ok => 1}),
        tField('identity_version'),
        tField('domain_name'),
    );

    %_searchable_fields = (
        name => [\&ibap_o2i_string, 'name', 'REGEX'],
        member => [\&ibap_o2i_member_byhostname, 'member', 'EXACT'],
        fqdn_or_ip => [\&ibap_o2i_string, 'fqdn_or_ip', 'REGEX'],
        protocol => [\&ibap_o2i_string, 'protocol', 'EXACT'],
        port => [\&ibap_o2i_uint, 'port', 'EXACT'],
        public_network_view => [\&ibap_o2i_network_view, 'public_network_view', 'EXACT'],
        private_network_view => [\&ibap_o2i_network_view, 'private_network_view', 'EXACT'],
    );
};

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach ('enabled',
             'update_metadata',
             'merge_data',
             'auto_consolidate_managed_tenant',
             'auto_consolidate_managed_vm',
             'auto_consolidate_cloud_ea',
             'auto_create_dns_record',
             'allow_unsecured_connection',
             'update_dns_view_public_ip',
             'update_dns_view_private_ip')
    {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    $self->{'__internal_session_cache_ref__'} = \$session;
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub new
{
    my ($proto, %args) = @_;
    my $class = ref ($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    if (defined $args{'credentials_type'} && $args{'credentials_type'} eq 'DIRECT') {
        if (!(defined $args{ 'username' } && defined $args{ 'password' })) {
            set_error_codes(1103,'username and password are required if credentials_type is set to DIRECT.' );
            return;
        }
    }

    $self->__init_instance_constants__();

    return $self;
}

sub __new__
{
    my ($proto, %args ) = @_;
    my $class = ref ($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self, $class;

    $self->__init_instance_constants__();

    return $self;
}

sub __init_instance_constants__
{
    my $self = shift;

    unless ($_return_fields_initialized) {
        $_return_fields_initialized = 1;
        my $t = Infoblox::Grid::ScheduleSetting->__new__();
        push @_return_fields, tField('scheduled_run', {sub_fields => $t->__return_fields__()});
    }
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

sub __verify_identity_version__ {
    my ($self, $session) = @_;
    if (defined $self->{'driver_type'} and $self->{'driver_type'} eq 'OPENSTACK') {
        if (defined $self->{'identity_version'}) {
            if ($self->{'identity_version'} eq 'KEYSTONE_V3' && ! defined $self->{'domain_name'}) {
                set_error_codes(1103,'domain_name is required if identity_version is set to KEYSTONE_V3.' );
                return;
            }
        } else {
            $self->{'identity_version'} = 'KEYSTONE_V2';
        }
    }
    set_error_codes(9999, 'continue', $session);
}

sub __add_override_hook__ {
    my ($object_type, $session, $object) = @_;
    $object->__verify_identity_version__($session);
}

sub __modify_override_hook__ {
    my ($object_type, $session, $object) = @_;
    $object->__verify_identity_version__($session);
}

sub vdiscovery_control
{
    my $self = shift;

    unless ($self->{'__internal_session_cache_ref__'}) {
        set_error_codes(1001,'In order to control vDiscovery task the object must have been retrieved from the server first');
        return;
    }

    my $session = ${$self->{'__internal_session_cache_ref__'}};

    return $session->__vdiscovery_control__($self->__object_id__(), @_);
}

package Infoblox::Grid::Discovery::DiagnosticTask;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            $_object_type
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_return_field_overrides
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    $_object_type = 'DiscoveryDiagTask';
    register_wsdl_type('ib:DiscoveryDiagTask', 'Infoblox::Grid::Discovery::DiagnosticTask');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'community_string' => {simple => 'asis', readonly => 1, },
                         'debug_snmp'       => {simple => 'bool', readonly => 1, },
                         'force_test'       => {simple => 'bool', readonly => 1, },
                         'ip_address'       => {simple => 'asis', readonly => 1, },
                         'network_view'     => {readonly => 1, },
                         'start_time'       => {readonly => 1, },
                         'task_id'          => {simple => 'asis', readonly => 1, },
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'task_id'      => [ \&ibap_o2i_string, 'task_id', 'EXACT' ],
                           'ip_address'   => [ \&ibap_o2i_string, 'ip_address', 'REGEX' ],
                           'network_view' => [ \&ibap_o2i_network_view ,'network_view', 'EXACT' ],
    );

    %_name_mappings = (
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'network_view' => \&ibap_i2o_object_name,
                        'start_time'   => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    %_object_to_ibap = (
                        'community_string' => \&ibap_o2i_ignore,
                        'debug_snmp'       => \&ibap_o2i_ignore,
                        'force_test'       => \&ibap_o2i_ignore,
                        'ip_address'       => \&ibap_o2i_ignore,
                        'network_view'     => \&ibap_o2i_ignore,
                        'start_time'       => \&ibap_o2i_ignore,
                        'task_id'          => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('community_string'),
                       tField('debug_snmp'),
                       tField('force_test'),
                       tField('ip_address'),
                       tField('network_view', {
                           'sub_fields' => [
                               tField('name'),
                           ],
                       }),
                       tField('start_time'),
                       tField('task_id'),
    );

    %_return_field_overrides = (
                                'community_string' => [],
                                'debug_snmp'       => [],
                                'force_test'       => [],
                                'ip_address'       => [],
                                'network_view'     => [],
                                'start_time'       => [],
                                'task_id'          => [],
    );

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

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

#
#
#

sub __ibap_to_object__ {

    my $self = shift;

    my ($ibap_object_ref, $server,
        $session, $return_object_cache_ref) = @_;

    foreach (
        'debug_snmp',
        'force_test',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    return $self->SUPER::__ibap_to_object__(@_);
}

package Infoblox::Grid::Member::Discovery::CiscoAPICConfig;

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
            %_ibap_to_object
            %_object_to_ibap
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'cisco_apic_configuration';
    register_wsdl_type('ib:cisco_apic_configuration', 'Infoblox::Grid::Member::Discovery::CiscoAPICConfig');


    %_allowed_members = (
                         'address'        => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string, },
                         'ca_certificate' => {validator => {'Infoblox::Grid::CACertificate' => 1}, },
                         'comment'        => {simple => 'asis', validator => \&ibap_value_o2i_string, },
                         'network_view'   => {mandatory => 1, 'validator' => \&ibap_value_o2i_string},
                         'password'       => {mandatory => 1, writeonly => 1, validator => \&ibap_value_o2i_string, },
                         'protocol'       => {mandatory => 1, simple => 'asis', enum => ['HTTP', 'HTTPS'], },
                         'username'       => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string, },
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'ca_certificate' => \&ibap_i2o_generic_object_convert,
                        'network_view'   => \&ibap_i2o_object_name,
    );

    %_object_to_ibap = (
                        'address'        => \&ibap_o2i_string,
                        'ca_certificate' => \&ibap_o2i_object_only_by_oid,
                        'comment'        => \&ibap_o2i_string,
                        'network_view'   => \&ibap_o2i_network_view,
                        'password'       => \&ibap_o2i_string,
                        'protocol'       => \&ibap_o2i_string,
                        'username'       => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('address'),
                       tField('comment'),
                       tField('network_view', {
                           'sub_fields' => [
                               tField('name'),
                           ],
                       }),
                       tField('protocol'),
                       tField('username'),
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

sub __ibap_object_type__ {

    return $_object_type;
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my ($tmp, %tmp);

        %tmp = (
                'ca_certificate' => 'Infoblox::Grid::CACertificate',
        );

        foreach my $key (keys %tmp) {
            $tmp = $tmp{$key}->__new__();
            push @_return_fields, tField($key, {sub_fields => $tmp->__return_fields__()});
        }
    }
}

1;
