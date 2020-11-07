package Infoblox::Grid::Member::Communication;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields $_object_type);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN
{
    $_object_type = 'member_service_communication_config';
    register_wsdl_type('ib:member_service_communication_config', 'Infoblox::Grid::Member::Communication');

    %_allowed_members = (
                         option  => {simple => 'asis', readonly => 1, enum => ['FORCE', 'PREFER']},
                         type    => {'mandatory' => 1, enum => ['IPv4', 'IPv6']},
                         service => {simple => 'asis', 'mandatory' => 1, enum => ['AD',
                                                                                  'GRID',
                                                                                  'GRID_BACKUP',
                                                                                  'MAIL',
                                                                                  'NTP',
                                                                                  'OCSP',
                                                                                  'REPORTING',
                                                                                  'REPORTING_BACKUP',
                                                                              ]},
                     );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
        type => \&__i2o_type__,
    );

    @_return_fields = (
        tField('option'),
        tField('type'),
        tField('service'),
    );

    %_object_to_ibap = (
        'option'  => \&ibap_o2i_ignore,
        'type'    => \&ibap_o2i_enums_uc_or_undef,
        'service' => \&ibap_o2i_string,
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

sub __i2o_type__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my $mtype=$ibap_object_ref->{$current};

    if ($mtype eq 'IPV4') {
        return 'IPv4';
    }
    else {
        return 'IPv6';
    }
}

sub __ibap_object_type {

    return $_object_type;
}

package Infoblox::Grid::Member;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields $_return_fields_initialized %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities @_optional_return_fields );
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'Member';
    register_wsdl_type('ib:Member','Infoblox::Grid::Member');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members =
      (
       active_position                   => 0,
       additional_ip_list                => 0,
       allow_syslog_clients              => 0,
       alternate_resolver                => 0,
       bgp_as                            => {validator => {'Infoblox::Grid::Member::BGP::AS' => 1}, array => 1, skip_accessor => 1},
       cluster                           => 0,
       comment                           => 0,
       #
       dscp                              => 0,
       enable_authentication             => 0,
       enable_member_redirect            => 0,
       enable_ntp                        => 0,
       enable_snmpv3_query               => 0,
       enable_snmpv3_traps               => 0,
       enable_syslog_proxy               => 0,
       engine_id                         => -1,
       exclude_grid_master_as_ntp_server => 0,
       extattrs                          => 0,
       extensible_attributes             => 0,
       gateway                           => 0,
       grid                              => 0,
       enable_ha                         => 0,
       external_ntp_servers_enabled      => 0,
       ha_node2_port_duplex              => 0,
       ha_node2_port_speed               => 0,
       ha_port_duplex                    => 0,
       ha_port_speed                     => 0,
       ha_reserved_interface             => 0,
       hwplatform                        => -1,
       paid_nios                         => -1,
       hwid                              => 0,
       ipv4addr                          => 0,
       ipv6addr                          => 0,
       ipv6_cidr                         => 0,
       ipv6_gateway                      => 0,
       ipv6_enable_auto_config           => 0,
       ipv6_static_routes                => {validator => {'Infoblox::Grid::Member::IPv6StaticRoute' => 1}, array => 1, skip_accessor => 1},
       is_master                         => -1,
       is_dscp_capable                   => -1,
       lan2_gateway                      => 0,
       lan2_ipv4addr                     => 0,
       lan2_ipv6_cidr                    => 0,
       lan2_ipv6_enable                  => 0,
       lan2_ipv6_enable_auto_config      => 0,
       lan2_ipv6_gateway                 => 0,
       lan2_ipv6addr                     => 0,
       lan2_mask                         => 0,
       lan2_node2_port_duplex            => 0,
       lan2_node2_port_speed             => 0,
       lan2_port                         => 0,
       lan2_port_duplex                  => 0,
       lan2_port_speed                   => 0,
       lan2_router_id                    => 0,
       lan2_reserved_interface           => 0,
       lan_node2_port_duplex             => 0,
       lan_node2_port_speed              => 0,
       lan_port_duplex                   => 0,
       lan_port_speed                    => 0,
       lan_reserved_interface            => 0,
       lcd_input                         => 0,
       lcd_hwident                       => 0,
       lcd_autodim                       => 0,
       lcd_brightness                    => 0,
       lcd_version                       => -1,
       enable_lom                       => 0,
       lom_gateway                       => 0,
       lom_ipv4addr                      => 0,
       lom_is_capable                    => -1,
       lom_mask                          => 0,
       node1_lom_gateway                 => 0,
       node1_lom_ipv4addr                => 0,
       node1_lom_is_capable              => -1,
       node1_lom_mask                    => 0,
       node2_lom_gateway                 => 0,
       node2_lom_ipv4addr                => 0,
       node2_lom_is_capable              => -1,
       node2_lom_mask                    => 0,
       lom_users                         => {validator => {'Infoblox::Grid::LOM::User' => 1}, array => 1, skip_accessor => 1},
       override_enable_lom              => 0,
       override_lom_users                => 0,
       mask                              => 0,
       master_candidate                  => 0,
       mgmt_gateway                      => 0,
       mgmt_ipv6_cidr                    => 0,
       mgmt_ipv6_enable_auto_config      => 0,
       mgmt_ipv6_gateway                 => 0,
       mgmt_ipv6addr                     => 0,
       mgmt_lan                          => 0,
       mgmt_mask                         => 0,
       mgmt_node2_port_duplex            => 0,
       mgmt_node2_port_speed             => 0,
       mgmt_port                         => 0,
       mgmt_port_duplex                  => 0,
       mgmt_port_speed                   => 0,
       mgmt_reserved_interface           => 0,
       name                              => 1,
       nat_enabled                       => 0,
       nat_group                         => 0,
       nat_ip_address                    => 0,
       nic_failover_enabled              => 0,
       nic_failover_enable_primary       => 0,
       node1_ha                          => 0,
       node1_hwplatform                  => -1,
       node1_paid_nios                   => -1,
       node1_hwid                        => -1,
       node1_hwtype                      => 0,
       node1_lan_ipv6addr                => 0,
       node1_mgmt_ipv6_cidr              => 0,
       node1_mgmt_ipv6_enable_auto_config=> 0,
       node1_mgmt_ipv6_gateway           => 0,
       node1_mgmt_ipv6addr               => 0,
       node1_lan                         => 0,
       node1_licenses                    => -1,
       node1_mgmt_gateway                => 0,
       node1_mgmt_lan                    => 0,
       node1_mgmt_mask                   => 0,
       node1_mgmt_port                   => 0,
       node1_nat                         => 0,
       node1_physical_oid                => -1,
       node1_service_status              => -1,
       node1_vpn_on_mgmt                 => 0,
       node1_lcd_hwident                 => 0,
       node1_lcd_autodim                 => 0,
       node1_lcd_version                 => -1,
       node1_lcd_brightness              => 0,
       node1_lan_reserved_interface      => 0,
       node1_ha_reserved_interface       => 0,
       node1_mgmt_reserved_interface     => 0,
       node1_lan2_reserved_interface     => 0,
       node2_ha                          => 0,
       node2_hwplatform                  => -1,
       node2_paid_nios                   => -1,
       node2_hwid                        => -1,
       node2_hwtype                      => 0,
       node2_lan                         => 0,
       node2_lan_ipv6addr                => 0,
       node2_mgmt_ipv6_cidr              => 0,
       node2_mgmt_ipv6_enable_auto_config=> 0,
       node2_mgmt_ipv6_gateway           => 0,
       node2_mgmt_ipv6addr               => 0,
       node2_licenses                    => -1,
       node2_mgmt_gateway                => 0,
       node2_mgmt_lan                    => 0,
       node2_mgmt_mask                   => 0,
       node2_mgmt_port                   => 0,
       node2_physical_oid                => -1,
       node2_nat                         => 0,
       node2_service_status              => -1,
       node2_vpn_on_mgmt                 => 0,
       node2_lcd_hwident                 => 0,
       node2_lcd_autodim                 => 0,
       node2_lcd_version                 => -1,
       node2_lcd_brightness              => 0,
       node2_lan_reserved_interface      => 0,
       node2_ha_reserved_interface       => 0,
       node2_mgmt_reserved_interface     => 0,
       node2_lan2_reserved_interface     => 0,
       notification_email_addr           => 0,
       ntp_access_list                   => 0,
       ntp_service_type                  => 0,
       ntp_authentication_key            => 0,
       ntp_server                        => 0,
       ntp_kod                           => 0,
       override_ntp_kod                  => 0,
       ospf_list                         => {validator => {'Infoblox::Grid::Member::OSPF' => 1}, array => 1, skip_accessor => 1},
       override_dscp                     => 0,
       override_enable_member_redirect   => 0,
       override_threshold_traps          => 0,
       override_trap_notifications       => 0,
       platform                          => 0,
       prefer_resolver                   => 0,
       pre_provisioning                  => 0,
       query_comm_string                 => 0,
       remote_console_access             => 0,
       replication_info                  => -1,
       router_ID                         => 0,
       search_domains                    => 0,
       service_status                    => -1,
       snmpv3_query_users                => 0,
       snmp_admin                        => 0,
       static_routes                     => {validator => {'Infoblox::Grid::Member::StaticRoute' => 1}, array => 1, skip_accessor => 1},
       support_access                    => 0,
       support_access_info               => -1,
       syslog_proxy_tcp_port             => 0,
       syslog_proxy_udp_port             => 0,
       syslog_server                     => {validator => {'Infoblox::Grid::SyslogServer' => 1}, array => 1, skip_accessor => 1},
       syslog_size                       => 0,
       time_zone                         => 0,
       threshold_traps                   => {validator => {'Infoblox::Grid::SNMP::ThresholdTrap' => 1}, array => 1, skip_accessor => 1},
       trap_notifications                => {validator => {'Infoblox::Grid::SNMP::TrapNotification' => 1}, array => 1, skip_accessor => 1},
       trap_comm_string                  => 0,
       trap_receiver                     => 0,
       type                              => 0,
       upgrade_group                     => 0,
       virtual_oid                       => -1,
       vpn_mtu                           => 0,
       vpn_on_mgmt                       => 0,

       lan1_dscp                         => 0,
       vlan_id                           => 0,
       override_lan1_dscp                => 0,

       lan1_ipv6_dscp                    => 0,
       ipv6_vlan_id                      => 0,
       override_lan1_ipv6_dscp           => 0,

       lan2_dscp                         => 0,
       lan2_vlan_id                      => 0,
       override_lan2_dscp                => 0,

       lan2_ipv6_dscp                    => 0,
       lan2_ipv6_vlan_id                 => 0,
       override_lan2_ipv6_dscp           => 0,

       mgmt_dscp                         => 0,
       node1_mgmt_dscp                   => 0,
       node2_mgmt_dscp                   => 0,
       override_mgmt_dscp                => 0,
       override_node1_mgmt_dscp          => 0,
       override_node2_mgmt_dscp          => 0,

       mgmt_ipv6_dscp                    => 0,
       node1_mgmt_ipv6_dscp              => 0,
       node2_mgmt_ipv6_dscp              => 0,
       override_mgmt_ipv6_dscp           => 0,
       override_node1_mgmt_ipv6_dscp     => 0,
       override_node2_mgmt_ipv6_dscp     => 0,
       passive_ha_arp_enabled            => 0,

       use_v4_vrrp                       => 0,
       config_addr_type                  => 0,
       member_service_communication      => {validator => {'Infoblox::Grid::Member::Communication' => 1}, array => 1, skip_accessor => 1},
       service_type_configuration        => 0,
       enable_ro_api_access              => 0,
       preserve_if_owns_delegation       => 0,
       syslog_backup_servers => {array => 1, validator => {'Infoblox::Grid::SyslogBackupServer' => 1},
                                 use => 'override_syslog_backup_servers', use_truefalse => 1},
       override_syslog_backup_servers => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       mmdb_ea_build_time             => {readonly => 1},
       mmdb_geoip_build_time          => {readonly => 1},
    );

      Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings =
      (
       additional_ip_list                => 'virtual_ips',
       bgp_as                            => 'anycast_bgp_as_config',
       ipv6addr                          => 'ipv6_setting',
       lcd_input                         => 'lcd_input_enabled',
       master_candidate                  => 'master_candidate_enabled',
       enable_ha                         => 'ha_enabled',
       extattrs                          => 'extensible_attributes',
       ipv6_static_routes                => 'v6_static_routes',
       name                              => 'host_name',
       notification_email_addr           => 'email_setting',
       override_lom_users                => 'use_lom_users',
       enable_lom                        => 'lom_enabled',
       override_enable_lom               => 'use_lom_enabled',
       ospf_list                         => 'anycast_ospf_config',
       override_dscp                     => 'use_dscp',
       override_threshold_traps          => 'use_threshold_traps',
       override_trap_notifications       => 'use_ib_traps',
       remote_console_access             => 'remote_console_access_enabled',
       router_ID                         => 'virtual_router_identifier',
       support_access                    => 'support_access_enabled',
       syslog_server                     => 'syslog_servers',
       override_enable_member_redirect   => 'use_member_redirect',
       platform                          => 'member_type',
       service_status                    => 'protocol_service_status',
       trap_notifications                => 'ib_traps',
       pre_provisioning                  => 'pre_provision',
       override_ntp_kod                  => 'use_ntp_kod',
       override_syslog_backup_servers    => 'use_syslog_backup_servers',
       mmdb_ea_build_time                => 'mmdb_ea_build_epoch',
       mmdb_geoip_build_time             => 'mmdb_geoip_build_epoch',
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    $_reverse_name_mappings{'dns_resolver_setting'} = '__skip_handler__';
    $_reverse_name_mappings{'lan2_port_setting'}    = '__skip_handler__';
    $_reverse_name_mappings{'lom_network_config'}   = '__skip_handler__';
    $_reverse_name_mappings{'mgmt_port_setting'}    = '__skip_handler__';
    $_reverse_name_mappings{'nat_setting'}          = '__skip_handler__';
    $_reverse_name_mappings{'node_info'}            = '__skip_handler__';
    $_reverse_name_mappings{'ntp_setting'}          = '__skip_handler__';
    $_reverse_name_mappings{'snmp_setting'}         = '__skip_handler__';
    $_reverse_name_mappings{'syslog_proxy_setting'} = '__skip_handler__';
    $_reverse_name_mappings{'vip_setting'}          = '__skip_handler__';

    %_searchable_fields = (
                           name    => [\&ibap_o2i_string,'host_name' , 'REGEX', 'GET_IGNORE_CASE'],
                           comment => [\&ibap_o2i_string,'comment' , 'REGEX', 'IGNORE_CASE'],
                           is_master    => [\&ibap_o2i_boolean,'is_master' , 'EXACT'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           ipv4addr => [\&ibap_o2i_string,'ip_address' , 'EXACT'],
                           ipv6addr => [\&ibap_o2i_string,'ipv6_address' , 'EXACT'],
                           hwplatform => [\&ibap_o2i_string,'hardware_platform' , 'REGEX'],

                           #
                           cluster  => [\&ibap_o2i_ignore, 'deprecated', 'DEPRECATED'],
                          );

	%_return_field_overrides =
      (
       active_position                   => [],
       additional_ip_list                => [],
       allow_syslog_clients              => ['!syslog_proxy_setting', 'use_syslog_setting'],
       alternate_resolver                => ['!dns_resolver_setting','use_resolver_setting'],
       bgp_as                            => [],
       cluster                           => [],
       comment                           => [],
       #
       dscp                              => ['use_dscp'],
       enable_authentication             => [],
       enable_member_redirect            => ['use_member_redirect'],
       enable_ntp                        => ['!ntp_setting'],
       enable_snmpv3_query               => ['!snmp_setting', 'use_snmp_setting'],
       enable_snmpv3_traps               => ['!snmp_setting', 'use_snmp_setting'],
       enable_syslog_proxy               => ['!syslog_proxy_setting', 'use_syslog_setting'],
       engine_id                         => ['!snmp_setting', 'use_snmp_setting'],
       exclude_grid_master_as_ntp_server => ['!ntp_setting'],
       extattrs                          => [],
       extensible_attributes             => [],
       external_ntp_servers_enabled      => ['!ntp_setting'],
       gateway                           => ['!vip_setting'],
       grid                              => [],
       ha_node2_port_duplex              => ['!node_info'],
       ha_node2_port_speed               => ['!node_info'],
       ha_port_duplex                    => ['!node_info'],
       ha_port_speed                     => ['!node_info'],
       hwplatform                        => ['!node_info'],
       hwid                              => ['!node_info'],
       paid_nios                         => ['!node_info'],
       ipv4addr                          => ['!vip_setting'],
       ipv6addr                          => ['!ipv6_setting'],
       ipv6_cidr                         => ['!ipv6_setting'],
       ipv6_gateway                      => ['!ipv6_setting'],
       ipv6_enable_auto_config           => ['!ipv6_setting'],
       ipv6_static_routes                => [],
       is_dscp_capable                   => [],
       is_master                         => [],
       lan2_ipv6_cidr                    => ['!lan2_port_setting'],
       lan2_ipv6_enable                  => ['!lan2_port_setting'],
       lan2_ipv6_enable_auto_config      => ['!lan2_port_setting'],
       lan2_ipv6_gateway                 => ['!lan2_port_setting'],
       lan2_ipv6addr                     => ['!lan2_port_setting'],
       lan2_gateway                      => ['!lan2_port_setting'],
       lan2_ipv4addr                     => ['!lan2_port_setting'],
       lan2_mask                         => ['!lan2_port_setting'],
       lan2_node2_port_duplex            => ['!node_info'],
       lan2_node2_port_speed             => ['!node_info'],
       lan2_port                         => ['!lan2_port_setting'],
       lan2_port_duplex                  => ['!node_info'],
       lan2_port_speed                   => ['!node_info'],
       lan2_router_id                    => ['!lan2_port_setting'],
       lan_node2_port_duplex             => ['!node_info'],
       lan_node2_port_speed              => ['!node_info'],
       lan_port_duplex                   => ['!node_info'],
       lan_port_speed                    => ['!node_info'],
       lcd_input                         => ['use_lcd_input'],
       lcd_hwident                       => ['!node_info'],
       lcd_autodim                       => ['!node_info'],
       lcd_version                       => ['!node_info'],
       lcd_brightness                    => ['!node_info'],
       enable_lom                       => ['use_lom_enabled'],
       lom_gateway                       => ['!lom_network_config'],
       lom_ipv4addr                      => ['!lom_network_config'],
       lom_is_capable                    => ['!lom_network_config'],
       lom_mask                          => ['!lom_network_config'],
       lom_users                         => ['use_lom_users'],
       node1_lom_gateway                 => ['!lom_network_config'],
       node1_lom_ipv4addr                => ['!lom_network_config'],
       node1_lom_is_capable              => ['!lom_network_config'],
       node1_lom_mask                    => ['!lom_network_config'],
       node2_lom_gateway                 => ['!lom_network_config'],
       node2_lom_ipv4addr                => ['!lom_network_config'],
       node2_lom_is_capable              => ['!lom_network_config'],
       node2_lom_mask                    => ['!lom_network_config'],
       override_enable_lom              => [],
       override_lom_users                => [],
       mask                              => ['!vip_setting'],
       master_candidate                  => [],
       mgmt_gateway                      => ['!node_info'],
       mgmt_ipv6_cidr                    => ['!node_info'],
       mgmt_ipv6_enable_auto_config      => ['!node_info'],
       mgmt_ipv6_gateway                 => ['!node_info'],
       mgmt_ipv6addr                     => ['!node_info'],
       mgmt_lan                          => ['!node_info'],
       mgmt_mask                         => ['!node_info'],
       mgmt_node2_port_duplex            => ['!node_info'],
       mgmt_node2_port_speed             => ['!node_info'],
       mgmt_port                         => ['!mgmt_port_setting'],
       mgmt_port_duplex                  => ['!node_info'],
       mgmt_port_speed                   => ['!node_info'],
       name                              => [],
       nat_group                         => ['!nat_setting'],
       nat_ip_address                    => ['!nat_setting'],
       nic_failover_enabled              => ['!lan2_port_setting'],
       nic_failover_enable_primary       => ['!lan2_port_setting'],
       node1_ha                          => ['!node_info'],
       node1_hwplatform                  => ['!node_info'],
       node1_hwid                        => ['!node_info'],
       node1_hwtype                      => ['!node_info'],
       node1_paid_nios                   => ['!node_info'],
       node1_lan                         => ['!node_info'],
       node1_lan_ipv6addr                => ['!node_info'],
       node1_mgmt_ipv6_cidr              => ['!node_info'],
       node1_mgmt_ipv6_enable_auto_config => ['!node_info'],
       node1_mgmt_ipv6_gateway           => ['!node_info'],
       node1_mgmt_ipv6addr               => ['!node_info'],
       node1_mgmt_gateway                => ['!node_info'],
       node1_mgmt_lan                    => ['!node_info'],
       node1_mgmt_mask                   => ['!node_info'],
       node1_mgmt_port                   => ['!node_info'],
       node1_nat                         => ['!node_info'],
       node1_physical_oid                => ['!node_info'],
       node1_lcd_hwident                 => ['!node_info'],
       node1_lcd_autodim                 => ['!node_info'],
       node1_lcd_version                 => ['!node_info'],
       node1_lcd_brightness              => ['!node_info'],
       node1_service_status              => ['!node_info'],
       node1_vpn_on_mgmt                 => ['!node_info'],
       node2_ha                          => ['!node_info'],
       node2_hwplatform                  => ['!node_info'],
       node2_hwid                        => ['!node_info'],
       node2_hwtype                      => ['!node_info'],
       node2_paid_nios                   => ['!node_info'],
       node2_lan                         => ['!node_info'],
       node2_lan_ipv6addr                => ['!node_info'],
       node2_mgmt_ipv6_cidr              => ['!node_info'],
       node2_mgmt_ipv6_enable_auto_config => ['!node_info'],
       node2_mgmt_ipv6_gateway           => ['!node_info'],
       node2_mgmt_ipv6addr               => ['!node_info'],
       node2_mgmt_gateway                => ['!node_info'],
       node2_mgmt_lan                    => ['!node_info'],
       node2_mgmt_mask                   => ['!node_info'],
       node2_mgmt_port                   => ['!node_info'],
       node2_physical_oid                => ['!node_info'],
       node2_nat                         => ['!node_info'],
       node2_service_status              => ['!node_info'],
       node2_vpn_on_mgmt                 => ['!node_info'],
       node2_lcd_hwident                 => ['!node_info'],
       node2_lcd_autodim                 => ['!node_info'],
       node2_lcd_version                 => ['!node_info'],
       node2_lcd_brightness              => ['!node_info'],
       notification_email_addr           => ['use_email_setting'],
       ntp_access_list                   => ['!ntp_setting'],
       ntp_service_type                  => ['!ntp_setting'],
       ntp_authentication_key            => ['!ntp_setting'],
       ntp_server                        => ['!ntp_setting'],
       ntp_kod                           => ['!ntp_setting'],
       override_ntp_kod                  => ['!ntp_setting'],
       syslog_backup_servers             => ['use_syslog_backup_servers'],
       override_syslog_backup_servers    => [],
       mmdb_ea_build_time                => [],
       mmdb_geoip_build_time             => [],

       ospf_list                         => [],
       override_dscp                     => [],
       override_threshold_traps          => [],
       override_trap_notifications       => [],
       platform                          => ['!node_info'],
       prefer_resolver                   => ['!dns_resolver_setting','use_resolver_setting'],
       pre_provisioning                  => [],
       query_comm_string                 => ['!snmp_setting', 'use_snmp_setting'],
       remote_console_access             => [],
       replication_info                  => [],
       router_ID                         => [],
       search_domains                    => ['!dns_resolver_setting'],
       service_status                    => [],
       snmpv3_query_users                => ['!snmp_setting', 'use_snmp_setting'],
       snmp_admin                        => ['!snmp_setting', 'use_snmp_setting'],
       static_routes                     => [],
       support_access                    => ['use_support_access'],
       support_access_info               => [],
       syslog_proxy_tcp_port             => ['!syslog_proxy_setting', 'use_syslog_setting'],
       syslog_proxy_udp_port             => ['!syslog_proxy_setting', 'use_syslog_setting'],
       syslog_server                     => ['external_syslog_server_enabled','use_syslog_setting'],
       syslog_size                       => ['use_syslog_setting'],
       time_zone                         => [],
       threshold_traps                   => ['use_threshold_traps'],
       trap_notifications                => ['use_ib_traps'],
       trap_comm_string                  => ['!snmp_setting', 'use_snmp_setting'],
       trap_receiver                     => ['!snmp_setting', 'use_snmp_setting'],
       type                              => [],
       upgrade_group                     => [],
       enable_ha                         => [],
       virtual_oid                       => [],
       vpn_mtu                           => [],
       vpn_on_mgmt                       => ['!mgmt_port_setting'],

       lan1_dscp                         => ['!vip_setting'],
       vlan_id                           => ['!vip_setting'],
       override_lan1_dscp                => ['!vip_setting'],

       lan1_ipv6_dscp                    => ['!ipv6_setting'],
       ipv6_vlan_id                      => ['!ipv6_setting'],
       override_lan1_ipv6_dscp           => ['!ipv6_setting'],

       lan2_dscp                         => ['!lan2_port_setting'],
       lan2_vlan_id                      => ['!lan2_port_setting'],
       override_lan2_dscp                => ['!lan2_port_setting'],

       lan2_ipv6_dscp                    => ['!lan2_port_setting'],
       lan2_ipv6_vlan_id                 => ['!lan2_port_setting'],
       override_lan2_ipv6_dscp           => ['!lan2_port_setting'],

       mgmt_dscp                         => ['!node_info'],
       node1_mgmt_dscp                   => ['!node_info'],
       node2_mgmt_dscp                   => ['!node_info'],
       override_mgmt_dscp                => ['!node_info'],
       override_node1_mgmt_dscp          => ['!node_info'],
       override_node2_mgmt_dscp          => ['!node_info'],

       mgmt_ipv6_dscp                    => ['!node_info'],
       node1_mgmt_ipv6_dscp              => ['!node_info'],
       node2_mgmt_ipv6_dscp              => ['!node_info'],
       override_mgmt_ipv6_dscp           => ['!node_info'],
       override_node1_mgmt_ipv6_dscp     => ['!node_info'],
       override_node2_mgmt_ipv6_dscp     => ['!node_info'],
       passive_ha_arp_enabled            => [],

       lan_reserved_interface            => ['!node_info'],
       ha_reserved_interface             => ['!node_info'],
       mgmt_reserved_interface           => ['!node_info'],
       lan2_reserved_interface           => ['!node_info'],
       node1_lan_reserved_interface      => ['!node_info'],
       node1_ha_reserved_interface       => ['!node_info'],
       node1_mgmt_reserved_interface     => ['!node_info'],
       node1_lan2_reserved_interface     => ['!node_info'],
       node2_lan_reserved_interface      => ['!node_info'],
       node2_ha_reserved_interface       => ['!node_info'],
       node2_mgmt_reserved_interface     => ['!node_info'],
       node2_lan2_reserved_interface     => ['!node_info'],

       use_v4_vrrp                       => [],
       config_addr_type                  => [],
       member_service_communication      => [],
       service_type_configuration        => [],

       enable_ro_api_access              => [],
       preserve_if_owns_delegation       => [],

      );

    %_ibap_to_object =
      (
       'anycast_bgp_as_config'          => \&ibap_i2o_generic_object_list_convert,
       'anycast_ospf_config'            => \&ibap_i2o_generic_object_list_convert,
       'dns_resolver_setting'           => \&__i2o_dns_resolver__,
       #
       'email_setting'                  => \&__i2o_email__,
       'enable_member_redirect'         => \&ibap_i2o_boolean,
       'extensible_attributes'          => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
       'ha_enabled'                     => \&ibap_i2o_boolean,
       'ib_traps'                       => \&ibap_i2o_generic_object_list_convert,
       'v6_static_routes'               => \&__i2o_6sroutes__,
       'ipv6_setting'                   => \&__i2o_ipv6setting__,
       'is_master'                      => \&ibap_i2o_boolean,
       'lan2_port_setting'              => \&__i2o_lan2_port__,
       'lcd_input_enabled'              => \&ibap_i2o_boolean,
       'lom_users'                      => \&ibap_i2o_generic_object_list_convert,
       'lom_network_config'             => \&__i2o_lomconfig__,
       'lom_enabled'                    => \&ibap_i2o_boolean,
       'use_lom_enabled'                => \&ibap_i2o_boolean,
       'use_lom_users'                  => \&ibap_i2o_boolean,
       'master_candidate_enabled'       => \&ibap_i2o_boolean,
       'member_type'                    => \&__i2o_type__,
       'mgmt_port_setting'              => \&__i2o_mgmt_port__,
       'pre_provision'                  => \&ibap_i2o_generic_object_convert,
       'nat_setting'                    => \&__i2o_nat__,
       'node_info'                      => \&__i2o_node__,
       'ntp_setting'                    => \&__i2o_ntp__,
       'passive_ha_arp_enabled'         => \&ibap_i2o_boolean,
       'use_member_redirect'            => \&ibap_i2o_boolean,
       'use_threshold_traps'            => \&ibap_i2o_boolean,
       'use_ib_traps'                   => \&ibap_i2o_boolean,
       'remote_console_access_enabled'  => \&ibap_i2o_boolean,
       'protocol_service_status'        => \&ibap_i2o_generic_object_list_convert,
       'replication_info'               => \&ibap_i2o_generic_object_convert,
       'snmp_setting'                   => \&__i2o_snmp__,
       'static_routes'                  => \&__i2o_sroutes__,
       'support_access_enabled'         => \&ibap_i2o_boolean,
       'syslog_proxy_setting'           => \&__i2o_syslog_proxy__,
       'syslog_servers'                 => \&ibap_i2o_generic_object_list_convert,
       'threshold_traps'                => \&ibap_i2o_generic_object_list_convert,
       'upgrade_group'                  => \&ibap_i2o_upgrade_group_name,
       'is_dscp_capable'                => \&ibap_i2o_boolean,
       'use_dscp'                       => \&ibap_i2o_boolean,
       'vip_setting'                    => \&__i2o_vip__,
       'virtual_ips'                    => \&__i2o_virtuals__,
       'use_v4_vrrp'                    => \&ibap_i2o_boolean,
       'member_service_communication'   => \&ibap_i2o_generic_object_list_convert,

       'enable_ro_api_access'           => \&ibap_i2o_boolean,
       'preserve_if_owns_delegation'    => \&ibap_i2o_boolean,
       'syslog_backup_servers'          => \&ibap_i2o_generic_object_list_convert,
       'mmdb_ea_build_epoch'            => \&ibap_i2o_datetime_to_unix_timestamp,
       'mmdb_geoip_build_epoch'         => \&ibap_i2o_datetime_to_unix_timestamp,
      );

    %_object_to_ibap =
      (
       active_position                   => \&ibap_o2i_ignore,
       additional_ip_list                => \&__o2i_additionalip__,
       allow_syslog_clients              => \&ibap_o2i_ignore,
       alternate_resolver                => \&ibap_o2i_ignore,
       bgp_as                            => \&ibap_o2i_generic_struct_list_convert,
       cluster                           => \&ibap_o2i_ignore,
       comment                           => \&ibap_o2i_string,
       dscp                              => \&ibap_o2i_uint_skip_undef,
       #
       enable_authentication             => \&ibap_o2i_ignore,
       enable_member_redirect            => \&ibap_o2i_boolean,
       enable_ntp                        => \&ibap_o2i_ignore,
       enable_snmpv3_traps               => \&ibap_o2i_ignore,
       enable_snmpv3_query               => \&ibap_o2i_ignore,
       enable_syslog_proxy               => \&ibap_o2i_ignore,
       engine_id                         => \&ibap_o2i_ignore,
       exclude_grid_master_as_ntp_server => \&ibap_o2i_ignore,
       extattrs                          => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
       extensible_attributes             => \&ibap_o2i_ignore,
       external_ntp_servers_enabled      => \&ibap_o2i_ignore,
       gateway                           => \&ibap_o2i_ignore,
       grid                              => \&ibap_o2i_ignore,
       ha_node2_port_duplex              => \&ibap_o2i_ignore,
       ha_node2_port_speed               => \&ibap_o2i_ignore,
       ha_port_duplex                    => \&ibap_o2i_ignore,
       ha_port_speed                     => \&ibap_o2i_ignore,
       ha_reserved_interface             => \&ibap_o2i_ignore,
       hwplatform                        => \&ibap_o2i_ignore,
       hwid                              => \&ibap_o2i_ignore,
       paid_nios                         => \&ibap_o2i_ignore,
       ipv4addr                          => \&ibap_o2i_ignore,
       ipv6addr                          => \&__o2i_ipv6addr__,
       ipv6_cidr                         => \&ibap_o2i_ignore,
       ipv6_gateway                      => \&ibap_o2i_ignore,
       ipv6_enable_auto_config           => \&ibap_o2i_ignore,
       ipv6_static_routes                => \&ibap_o2i_generic_struct_list_convert,
       is_master                         => \&ibap_o2i_ignore,
       is_dscp_capable                   => \&ibap_o2i_ignore,
       lan2_gateway                      => \&ibap_o2i_ignore,
       lan2_ipv4addr                     => \&ibap_o2i_ignore,
       lan2_ipv6_cidr                    => \&ibap_o2i_ignore,
       lan2_ipv6_enable                  => \&ibap_o2i_ignore,
       lan2_ipv6_enable_auto_config      => \&ibap_o2i_ignore,
       lan2_ipv6_gateway                 => \&ibap_o2i_ignore,
       lan2_ipv6addr                     => \&ibap_o2i_ignore,
       lan2_mask                         => \&ibap_o2i_ignore,
       lan2_node2_port_duplex            => \&ibap_o2i_ignore,
       lan2_node2_port_speed             => \&ibap_o2i_ignore,
       lan2_port                         => \&ibap_o2i_ignore,
       lan2_port_duplex                  => \&ibap_o2i_ignore,
       lan2_port_speed                   => \&ibap_o2i_ignore,
       lan2_router_id                    => \&ibap_o2i_ignore,
       lan2_reserved_interface           => \&ibap_o2i_ignore,
       lan_node2_port_duplex             => \&ibap_o2i_ignore,
       lan_node2_port_speed              => \&ibap_o2i_ignore,
       lan_port_duplex                   => \&ibap_o2i_ignore,
       lan_port_speed                    => \&ibap_o2i_ignore,
       lan_reserved_interface            => \&ibap_o2i_ignore,
       lcd_input                         => \&ibap_o2i_boolean,
       lcd_hwident                       => \&ibap_o2i_ignore,
       lcd_autodim                       => \&ibap_o2i_ignore,
       lcd_version                       => \&ibap_o2i_ignore,
       lcd_brightness                    => \&ibap_o2i_ignore,
       enable_lom                       => \&ibap_o2i_boolean,
       lom_gateway                       => \&ibap_o2i_ignore,
       lom_ipv4addr                      => \&ibap_o2i_ignore,
       lom_is_capable                    => \&ibap_o2i_ignore,
       lom_mask                          => \&ibap_o2i_ignore,
       lom_users                         => \&ibap_o2i_generic_struct_list_convert,
       node1_lom_gateway                 => \&ibap_o2i_ignore,
       node1_lom_ipv4addr                => \&ibap_o2i_ignore,
       node1_lom_is_capable              => \&ibap_o2i_ignore,
       node1_lom_mask                    => \&ibap_o2i_ignore,
       node2_lom_gateway                 => \&ibap_o2i_ignore,
       node2_lom_ipv4addr                => \&ibap_o2i_ignore,
       node2_lom_is_capable              => \&ibap_o2i_ignore,
       node2_lom_mask                    => \&ibap_o2i_ignore,
       override_enable_lom              => \&ibap_o2i_boolean,
       override_lom_users                => \&ibap_o2i_boolean,
       mask                              => \&ibap_o2i_ignore,
       master_candidate                  => \&ibap_o2i_boolean,
       mgmt_gateway                      => \&ibap_o2i_ignore,
       mgmt_lan                          => \&ibap_o2i_ignore,
       mgmt_ipv6_cidr                    => \&ibap_o2i_ignore,
       mgmt_ipv6_enable_auto_config      => \&ibap_o2i_ignore,
       mgmt_ipv6_gateway                 => \&ibap_o2i_ignore,
       mgmt_ipv6addr                     => \&ibap_o2i_ignore,
       mgmt_mask                         => \&ibap_o2i_ignore,
       mgmt_node2_port_duplex            => \&ibap_o2i_ignore,
       mgmt_node2_port_speed             => \&ibap_o2i_ignore,
       mgmt_port                         => \&ibap_o2i_ignore,
       mgmt_port_duplex                  => \&ibap_o2i_ignore,
       mgmt_port_speed                   => \&ibap_o2i_ignore,
       mgmt_reserved_interface           => \&ibap_o2i_ignore,
       name                              => \&ibap_o2i_string,
       nat_group                         => \&ibap_o2i_ignore,
       nat_ip_address                    => \&ibap_o2i_ignore,
       nic_failover_enabled              => \&ibap_o2i_ignore,
       nic_failover_enable_primary       => \&ibap_o2i_ignore,
       node1_ha                          => \&ibap_o2i_ignore,
       node1_hwplatform                  => \&ibap_o2i_ignore,
       node1_hwid                        => \&ibap_o2i_ignore,
       node1_hwtype                      => \&ibap_o2i_ignore,
       node1_paid_nios                   => \&ibap_o2i_ignore,
       node1_lan                         => \&ibap_o2i_ignore,
       node1_lan_ipv6addr                => \&ibap_o2i_ignore,
       node1_mgmt_ipv6_cidr              => \&ibap_o2i_ignore,
       node1_mgmt_ipv6_enable_auto_config=> \&ibap_o2i_ignore,
       node1_mgmt_ipv6_gateway           => \&ibap_o2i_ignore,
       node1_mgmt_ipv6addr               => \&ibap_o2i_ignore,
       node1_mgmt_ipv6_enable            => \&ibap_o2i_ignore,
       node1_lcd_hwident                 => \&ibap_o2i_ignore,
       node1_lcd_autodim                 => \&ibap_o2i_ignore,
       node1_lcd_version                 => \&ibap_o2i_ignore,
       node1_lcd_brightness              => \&ibap_o2i_ignore,
       node1_licenses                    => \&ibap_o2i_ignore,
       node1_mgmt_gateway                => \&ibap_o2i_ignore,
       node1_mgmt_lan                    => \&ibap_o2i_ignore,
       node1_mgmt_mask                   => \&ibap_o2i_ignore,
       node1_mgmt_port                   => \&ibap_o2i_ignore,
       node1_nat                         => \&ibap_o2i_ignore,
       node1_physical_oid                => \&ibap_o2i_ignore,
       node1_service_status              => \&ibap_o2i_ignore,
       node1_vpn_on_mgmt                 => \&ibap_o2i_ignore,
       node1_lan_reserved_interface      => \&ibap_o2i_ignore,
       node1_ha_reserved_interface       => \&ibap_o2i_ignore,
       node1_mgmt_reserved_interface     => \&ibap_o2i_ignore,
       node1_lan2_reserved_interface     => \&ibap_o2i_ignore,
       node2_ha                          => \&ibap_o2i_ignore,
       node2_hwplatform                  => \&ibap_o2i_ignore,
       node2_hwid                        => \&ibap_o2i_ignore,
       node2_hwtype                      => \&ibap_o2i_ignore,
       node2_paid_nios                   => \&ibap_o2i_ignore,
       node2_lan                         => \&ibap_o2i_ignore,
       node2_lan_ipv6addr                => \&ibap_o2i_ignore,
       node2_mgmt_ipv6_cidr              => \&ibap_o2i_ignore,
       node2_mgmt_ipv6_enable_auto_config=> \&ibap_o2i_ignore,
       node2_mgmt_ipv6_gateway           => \&ibap_o2i_ignore,
       node2_mgmt_ipv6addr               => \&ibap_o2i_ignore,
       node2_mgmt_ipv6_enable            => \&ibap_o2i_ignore,
       node2_lcd_hwident                 => \&ibap_o2i_ignore,
       node2_lcd_autodim                 => \&ibap_o2i_ignore,
       node2_lcd_version                 => \&ibap_o2i_ignore,
       node2_lcd_brightness              => \&ibap_o2i_ignore,
       node2_licenses                    => \&ibap_o2i_ignore,
       node2_mgmt_gateway                => \&ibap_o2i_ignore,
       node2_mgmt_lan                    => \&ibap_o2i_ignore,
       node2_mgmt_mask                   => \&ibap_o2i_ignore,
       node2_mgmt_port                   => \&ibap_o2i_ignore,
       node2_nat                         => \&ibap_o2i_ignore,
       node2_physical_oid                => \&ibap_o2i_ignore,
       node2_service_status              => \&ibap_o2i_ignore,
       node2_vpn_on_mgmt                 => \&ibap_o2i_ignore,
       node2_lan_reserved_interface      => \&ibap_o2i_ignore,
       node2_ha_reserved_interface       => \&ibap_o2i_ignore,
       node2_mgmt_reserved_interface     => \&ibap_o2i_ignore,
       node2_lan2_reserved_interface     => \&ibap_o2i_ignore,
       notification_email_addr           => \&__o2i_email__,
       ntp_access_list                   => \&ibap_o2i_ignore,
       ntp_service_type                  => \&ibap_o2i_ignore,
       ntp_authentication_key            => \&ibap_o2i_ignore,
       ntp_server                        => \&ibap_o2i_ignore,
       ntp_kod                           => \&ibap_o2i_ignore,
       override_ntp_kod                  => \&ibap_o2i_ignore,
       ospf_list                         => \&ibap_o2i_generic_struct_list_convert,
       override_dscp                     => \&ibap_o2i_boolean,
       override_enable_member_redirect   => \&ibap_o2i_boolean,
       override_threshold_traps          => \&ibap_o2i_boolean,
       override_trap_notifications       => \&ibap_o2i_boolean,
       passive_ha_arp_enabled            => \&ibap_o2i_boolean,
       platform                          => \&ibap_o2i_enums_lc_or_undef,
       prefer_resolver                   => \&ibap_o2i_ignore,
       pre_provisioning                  => \&ibap_o2i_generic_struct_convert,
       query_comm_string                 => \&ibap_o2i_ignore,
       remote_console_access             => \&ibap_o2i_boolean,
       router_ID                         => \&ibap_o2i_uint,
       replication_info                  => \&ibap_o2i_ignore,
       search_domains                    => \&ibap_o2i_ignore,
       service_status                    => \&ibap_o2i_ignore,
       snmpv3_query_users                => \&ibap_o2i_ignore,
       snmp_admin                        => \&ibap_o2i_ignore,
       static_routes                     => \&ibap_o2i_generic_struct_list_convert,
       support_access                    => \&ibap_o2i_boolean,
       support_access_info               => \&ibap_o2i_ignore,
       syslog_proxy_tcp_port             => \&ibap_o2i_ignore,
       syslog_proxy_udp_port             => \&ibap_o2i_ignore,
       syslog_server                     => \&ibap_o2i_generic_struct_list_convert,
       syslog_size                       => \&ibap_o2i_uint,
       time_zone                         => \&ibap_o2i_string_undef_to_empty,
       threshold_traps                   => \&ibap_o2i_generic_struct_list_convert,
       trap_notifications                => \&ibap_o2i_generic_struct_list_convert,
       trap_comm_string                  => \&ibap_o2i_ignore,
       trap_receiver                     => \&ibap_o2i_ignore,
       type                              => \&ibap_o2i_ignore,
       upgrade_group                     => \&ibap_o2i_upgrade_group_as_object,
       enable_ha                         => \&ibap_o2i_boolean,
       virtual_oid                       => \&ibap_o2i_ignore,
       vpn_mtu                           => \&ibap_o2i_uint,
       vpn_on_mgmt                       => \&ibap_o2i_ignore,

       lan1_dscp                         => \&ibap_o2i_ignore,
       vlan_id                           => \&ibap_o2i_ignore,
       override_lan1_dscp                => \&ibap_o2i_ignore,

       lan1_ipv6_dscp                    => \&ibap_o2i_ignore,
       ipv6_vlan_id                      => \&ibap_o2i_ignore,
       override_lan1_ipv6_dscp           => \&ibap_o2i_ignore,

       lan2_dscp                         => \&ibap_o2i_ignore,
       lan2_vlan_id                      => \&ibap_o2i_ignore,
       override_lan2_dscp                => \&ibap_o2i_ignore,

       lan2_ipv6_dscp                    => \&ibap_o2i_ignore,
       lan2_ipv6_vlan_id                 => \&ibap_o2i_ignore,
       override_lan2_ipv6_dscp           => \&ibap_o2i_ignore,

       mgmt_dscp                         => \&ibap_o2i_ignore,
       node1_mgmt_dscp                   => \&ibap_o2i_ignore,
       node2_mgmt_dscp                   => \&ibap_o2i_ignore,
       override_mgmt_dscp                => \&ibap_o2i_ignore,
       override_node1_mgmt_dscp          => \&ibap_o2i_ignore,
       override_node2_mgmt_dscp          => \&ibap_o2i_ignore,

       mgmt_ipv6_dscp                    => \&ibap_o2i_ignore,
       node1_mgmt_ipv6_dscp              => \&ibap_o2i_ignore,
       node2_mgmt_ipv6_dscp              => \&ibap_o2i_ignore,
       override_mgmt_ipv6_dscp           => \&ibap_o2i_ignore,
       override_node1_mgmt_ipv6_dscp     => \&ibap_o2i_ignore,
       override_node2_mgmt_ipv6_dscp     => \&ibap_o2i_ignore,

       #
       external_syslog_server_enabled => \&ibap_o2i_boolean,
       use_email_setting              => \&ibap_o2i_boolean,
       use_lcd_input                  => \&ibap_o2i_boolean,
       use_remote_console_access      => \&ibap_o2i_boolean,
       use_resolver_setting           => \&ibap_o2i_boolean,
       use_snmp_setting               => \&ibap_o2i_boolean,
       use_support_access             => \&ibap_o2i_boolean,
       use_syslog_setting             => \&ibap_o2i_boolean,
       use_time_zone                  => \&ibap_o2i_boolean,

       #
       use_ntp_acl                  => \&ibap_o2i_ignore,
       use_ntp_keys                 => \&ibap_o2i_ignore,
       use_ntp_servers              => \&ibap_o2i_ignore,
       nat_enabled                  => \&ibap_o2i_ignore,

       use_prefer_resolver      => \&ibap_o2i_ignore,
       use_alternate_resolver   => \&ibap_o2i_ignore,
       use_query_string         => \&ibap_o2i_ignore,
       use_snmp_admin           => \&ibap_o2i_ignore,
       use_trap_receiver        => \&ibap_o2i_ignore,
       use_syslog_setting_allow => \&ibap_o2i_ignore,
       use_syslog_setting_proxy => \&ibap_o2i_ignore,
       use_syslog_setting_size  => \&ibap_o2i_ignore,
       use_syslog_setting_tcp   => \&ibap_o2i_ignore,
       use_syslog_setting_udp   => \&ibap_o2i_ignore,
       use_trap_string          => \&ibap_o2i_ignore,
       use_nat_ip_address_setting => \&ibap_o2i_ignore,
       use_node1_nat_setting      => \&ibap_o2i_ignore,
       use_node2_nat_setting      => \&ibap_o2i_ignore,
       use_nat_group_setting      => \&ibap_o2i_ignore,

       use_v4_vrrp                       => \&ibap_o2i_boolean,
       config_addr_type                  => \&ibap_o2i_enums_uc_or_undef,
       member_service_communication      => \&ibap_o2i_generic_struct_list_convert,
       service_type_configuration        => \&ibap_o2i_string,
       preserve_if_owns_delegation       => \&ibap_o2i_boolean,
       syslog_backup_servers             => \&ibap_o2i_generic_struct_list_convert,
       override_syslog_backup_servers    => \&ibap_o2i_boolean,
       mmdb_ea_build_time                => \&ibap_o2i_ignore,
       mmdb_geoip_build_time             => \&ibap_o2i_ignore,

       #
       __additional_mirror__ => \&ibap_o2i_ignore,

       enable_ro_api_access  => \&ibap_o2i_boolean,
      );

	$_return_fields_initialized=0;
    @_optional_return_fields =
      (
       tField('virtual_oid'),
      );

    @_return_fields =
      (
       tField('comment'),
       tField('dns_resolver_setting',
              {
               sub_fields => [
                              tField('enabled'),
                              tField('resolvers'),
                              tField('search_domains'),
                             ]
              }
             ),
       tField('email_setting',
              {
               sub_fields => [
                              tField('enabled'),
                              tField('address'),
                             ]
              }
             ),
       return_fields_extensible_attributes(),
       tField('external_syslog_server_enabled'),
       tField('ha_enabled'),
       tField('dscp'),
       #
       tField('is_dscp_capable'),
       tField('use_dscp'),
       tField('host_name'),
       tField('use_v4_vrrp'),
       tField('config_addr_type'),
#
#
#
       tField('is_master'),
       tField('lom_enabled'),
       tField('use_lom_enabled'),
       tField('use_lom_users'),
       tField('lom_network_config',
              {
               sub_fields => [
                              tField('address'),
                              tField('gateway'),
                              tField('is_lom_capable'),
                              tField('subnet_mask'),
                             ]
              }
             ),

       tField('ipv6_setting',
              {
                  sub_fields => [
                      tField('auto_router_config_enabled'),
                      tField('cidr_prefix'),
                      tField('dscp'),
                      tField('enabled'),
                      tField('gateway'),
                      tField('virtual_ip'),
                      tField('use_dscp'),
                      tField('vlan_id'),
                  ]
              }
          ),
       tField('lan2_port_setting',
              {
               sub_fields => [
                              tField('enabled'),
                              tField('nic_failover_enabled'),
                              tField('nic_failover_enable_primary'),
                              tField('virtual_router_id'),
                              tField('network_setting',
                                     {
                                      sub_fields => [
                                                     tField('gateway'),
                                                     tField('subnet_mask'),
                                                     tField('address'),
                                                     tField('dscp'),
                                                     tField('use_dscp'),
                                                     tField('vlan_id'),
                                                    ]
                                     }
                                    ),
                              tField('v6_network_setting',
                                     {
                                      sub_fields => [
                                                     tField('enabled'),
                                                     tField('virtual_ip'),
                                                     tField('cidr_prefix'),
                                                     tField('gateway'),
                                                     tField('auto_router_config_enabled'),
                                                     tField('dscp'),
                                                     tField('use_dscp'),
                                                     tField('vlan_id'),
                                                    ]
                                     }
                                    ),
                             ]
              }
             ),
       tField('enable_member_redirect'),
       tField('lcd_input_enabled'),
       tField('master_candidate_enabled'),
       tField('member_type'),
       tField('mgmt_port_setting',
              {
               sub_fields => [
                              tField('enabled'),
                              tField('vpn_enabled'),
                              tField('security_access_enabled'),
                             ]
              }
             ),
       tField('nat_setting',
              {
               sub_fields => [
                              tField('enabled'),
                              tField('external_virtual_ip'),
                              tField('group',
                                     {
                                      sub_fields => [
                                                     tField('name'),
                                                    ]
                                     }),
                             ]
              }
             ),
       tField('remote_console_access_enabled'),
       tField('protocol_service_status',
              {
               sub_fields => [
                              tField('service'),
                              tField('status'),
                              tField('description'),
                             ]
              }
             ),
       tField('static_routes',
              {
               sub_fields => [
                              tField('gateway'),
                              tField('subnet_mask'),
                              tField('address'),
                             ]
              }
             ),
       tField('v6_static_routes',
              {
               sub_fields => [
                              tField('address'),
                              tField('gateway'),
                              tField('cidr'),
                             ]
              }
             ),
       tField('service_type_configuration'),
       tField('support_access_enabled'),
       tField('support_access_info'),
       tField('syslog_size'),
       tField('time_zone'),
       tField('upgrade_group',
              {
               sub_fields => [
                              tField('upgrade_group',
                                     {
                                      sub_fields => [
                                                     tField('name'),
                                                    ]
                                     }
                                    ),
                             ]
              }
             ),
       tField('use_email_setting'),
       tField('use_lcd_input'),
       tField('use_member_redirect'),
       tField('use_remote_console_access'),
       tField('use_resolver_setting'),
       tField('use_snmp_setting'),
       tField('use_support_access'),
       tField('use_syslog_setting'),
       tField('use_time_zone'),
       tField('use_threshold_traps'),
       tField('use_ib_traps'),
       tField('vip_setting',
              {
               sub_fields => [
                              tField('gateway'),
                              tField('subnet_mask'),
                              tField('address'),
                              tField('dscp'),
                              tField('use_dscp'),
                              tField('vlan_id'),
                             ]
              }
             ),
       tField('virtual_router_identifier'),
       tField('vpn_mtu'),
       tField('passive_ha_arp_enabled'),
       tField('enable_ro_api_access'),
       tField('preserve_if_owns_delegation'),
       tField('use_syslog_backup_servers'),
       tField('mmdb_ea_build_epoch'),
       tField('mmdb_geoip_build_epoch'),
      );
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    $self->{'__initializing_from_new__'} = 1;
    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

	$self->__init_instance_constants__();
    delete $self->{'__initializing_from_new__'};

    #
    #
    #
    #
    #
    foreach my $t (
        #
        #
        #
        'additional_ip_list',
        'ipv6addr',
        'ipv6_cidr',

        #
        'ipv6_enable_auto_config',
        'ipv6_gateway',
        'lan1_ipv6_dscp',
        'override_lan1_ipv6_dscp',
        'ipv6_vlan_id',
    ) {
        if (defined $args{$t}) {
            $self->$t($args{$t});
        }
    }
    #
    #
    #
    #
    if (defined $args{'config_addr_type'}) {
        $self->config_addr_type($args{'config_addr_type'});
    } elsif (!defined $self->{'config_addr_type'}) {
        $self->config_addr_type('IPv4');
    }

    if (defined $args{'use_v4_vrrp'}) {
        $self->use_v4_vrrp($args{'use_v4_vrrp'});
    } elsif (!defined $self->{'use_v4_vrrp'}) {
        $self->use_v4_vrrp('true');
    }

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
        my $t=Infoblox::Grid::Member::Interface->__new__();
        push @_return_fields,
          tField('virtual_ips', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        $t=Infoblox::Grid::Member::OSPF->__new__();
        push @_return_fields,
          tField('anycast_ospf_config', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        $t=Infoblox::Grid::Member::Communication->__new__();
        push @_return_fields,
          tField('member_service_communication', {
              sub_fields => $t->__return_fields__(),
          });

        $t=Infoblox::Grid::Member::BGP::AS->__new__();
        push @_return_fields,
          tField('anycast_bgp_as_config', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        $t=Infoblox::Grid::LOM::User->__new__();
        push @_return_fields,
          tField('lom_users', {
                               sub_fields => $t->__return_fields__()
                              }
                );

        $t=Infoblox::Grid::SyslogServer->__new__();
        push @_return_fields,
          tField('syslog_servers', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        $t=Infoblox::Grid::Member::ReplicationInfo->__new__();
        push @_return_fields,
          tField('replication_info', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        $t = Infoblox::Grid::Member::PreProvisioning->__new__();
        push @_return_fields,
          tField('pre_provision', {
                                sub_fields => $t->__return_fields__(),
                               }
                );
        $t = Infoblox::Grid::SyslogBackupServer->__new__();
        push @_return_fields,
            tField('syslog_backup_servers', {sub_fields => $t->__return_fields__()});

        my $t1 = Infoblox::Grid::SNMP::TrapReceiver->__new__();
        my $t2 = Infoblox::Grid::SNMP::QueriesUser->__new__();
        my $t3 = Infoblox::Grid::SNMP::ThresholdTrap->__new__();
        my $t4 = Infoblox::Grid::SNMP::TrapNotification->__new__();
        push @_return_fields,
         tField('snmp_setting',
              {
               sub_fields => [
                              tField('engine_id'),
                              tField('queries_enabled'),
                              tField('queries_community_string'),
                              tField('traps_enabled'),
                              tField('traps_community_string'),
                              tField('snmpv3_queries_enabled'),
                              tField('snmpv3_traps_enabled'),
                              tField('snmpv3_queries_users',
                                  {
                                      sub_fields => $t2->__return_fields__(),
                                  }
                              ),
                              tField('trap_receivers',
                                  {
                                      sub_fields => $t1->__return_fields__(),
                                  }
                              ),
                              tField('syscontact'),
                              tField('syslocation'),
                              tField('sysname'),
                              tField('sysdescr'),
                             ]});
        push @_return_fields, tField('threshold_traps', {sub_fields => $t3->__return_fields__()});
        push @_return_fields, tField('ib_traps', {sub_fields => $t4->__return_fields__()});

        $t1 = Infoblox::Grid::NamedACL->__new__();
        push @_return_fields, tField('syslog_proxy_setting',
              {
               sub_fields => [
                              tField('enabled'),
                              tField('tcp_enabled'),
                              tField('tcp_port'),
                              tField('udp_enabled'),
                              tField('udp_port'),
                              tField('client_acls', return_fields_ac_setting($t1->__return_fields__())),
                             ]
              }
             );
        $t2 = Infoblox::Grid::NTPAccess->__new__();
        push @_return_fields, tField('ntp_setting', { sub_fields => [
                                tField('inherited_values', { sub_fields => [
                                  tField('ntp_keys', { sub_fields => [
                                    tField('values', { sub_fields => [
                                      tField('value', { sub_fields => [
                                        tField('number'),
                                        tField('type'),
                                        tField('string'),
                                      ]}),
                                    ]}),
                                  ]}),
                                ]}),
                                tField('grid_master_ntp_server_excluded'),
                                tField('use_ntp_keys'),
                                tField('use_ntp_acl'),
                                tField('ntp_keys', { sub_fields => [
                                  tField('number'),
                                  tField('type'),
                                  tField('string'),
                                ]}),
                                tField('ntp_acl', return_fields_ntp_ac_setting($t1->__return_fields__(), $t2->__return_fields__())),
                                tField('ntp_service_enabled'),
                                tField('external_ntp_servers_enabled'),
                                tField('use_ntp_servers'),
                                tField('ntp_servers', { sub_fields => [
                                  tField('address'),
                                  tField('authentication_enabled'),
                                  tField('ntp_key'),
                                  tField('burst'),
                                  tField('iburst'),
                                ]}),
                                tField('ntp_kod'),
                                tField('use_ntp_kod'),
                              ]});

        $t = Infoblox::Grid::Discovery::DeviceInterface->__new__();

        #
        push @_optional_return_fields, tField('node_info',
            {
               sub_fields => [
                              tField('lcd_hwident'),
                              tField('lcd_autodim'),
                              tField('lcd_version'),
                              tField('lcd_brightness'),
                              tField('physical_oid'),
                              tField('ha_status'),
                              tField('hardware_platform'),
                              tField('hardware_id'),
                              tField('hardware_type'),
                              tField('payg'),
                              tField('nat_external_ip'),
                              tField('serial_number'),
                              tField('node_service_status',
                                     {
                                      sub_fields => [
                                                     tField('service'),
                                                     tField('status'),
                                                     tField('description'),
                                                    ]
                                     }
                                    ),
                              tField('licenses',
                                     {
                                      sub_fields => [
                                                     tField('license_string'),
                                                     tField('type'),
                                                     tField('expiration'),
                                                     tField('kind'),
                                                     tField('hwid'),
                                                    ]
                                     }
                                    ),
                              tField('lan_ha_port_setting',
                                     {
                                      sub_fields => [
                                                     tField('public_ip_address'),
                                                     tField('v6_public_ip_address'),
                                                     tField('ha_ip_address'),
                                                     tField('lan_port_setting',
                                                            {
                                                             sub_fields => [
                                                                            tField('auto_port_setting_enabled'),
                                                                            tField('speed'),
                                                                            tField('duplex'),

                                                                            tField('reserved_interface', {
                                                                                    'no_access_ok' => 1,
                                                                                    'sub_fields' => $t->__return_fields__()
                                                                                }),
                                                                           ]
                                                            }
                                                           ),
                                                     tField('ha_port_setting',
                                                            {
                                                             sub_fields => [
                                                                            tField('auto_port_setting_enabled'),
                                                                            tField('speed'),
                                                                            tField('duplex'),
                                                                            tField('reserved_interface', {

                                                                                    'no_access_ok' => 1,
                                                                                    'sub_fields' => $t->__return_fields__()
                                                                                }),

                                                                           ]
                                                            }
                                                           ),
                                                    ]
                                     }
                                    ),
                              tField('mgmt_physical_setting',
                                     {
                                      sub_fields => [
                                                     tField('auto_port_setting_enabled'),
                                                     tField('speed'),
                                                     tField('duplex'),
                                                     tField('reserved_interface', {
                                                             'no_access_ok' => 1,
                                                             'sub_fields' => $t->__return_fields__()
                                                         }),

                                                    ]
                                     }
                                    ),
                              tField('mgmt_network_setting',
                                     {
                                      sub_fields => [
                                                     tField('address'),
                                                     tField('subnet_mask'),
                                                     tField('gateway'),
                                                     tField('dscp'),
                                                     tField('use_dscp'),
                                                    ]
                                     }
                                    ),
                              tField('v6_mgmt_network_setting',
                                     {
                                      sub_fields => [
                                                     tField('enabled'),
                                                     tField('virtual_ip'),
                                                     tField('cidr_prefix'),
                                                     tField('gateway'),
                                                     tField('auto_router_config_enabled'),
                                                     tField('dscp'),
                                                     tField('use_dscp'),
                                                    ]
                                     }
                                    ),
                              tField('lan2_physical_setting',
                                     {
                                      sub_fields => [
                                                     tField('auto_port_setting_enabled'),
                                                     tField('speed'),
                                                     tField('duplex'),
                                                     tField('reserved_interface', {
                                                             'no_access_ok' => 1,
                                                             'sub_fields' => $t->__return_fields__()
                                                         }),
                                                    ]
                                     }
                                    ),
                             ]
              }
        );

        push @_return_fields, tField('node_info',
              {
               sub_fields => [
                              tField('lcd_hwident'),
                              tField('lcd_autodim'),
                              tField('lcd_version'),
                              tField('lcd_brightness'),
                              tField('ha_status'),
                              tField('hardware_platform'),
                              tField('hardware_id'),
                              tField('hardware_type'),
                              tField('payg'),
                              tField('nat_external_ip'),
                              tField('serial_number'),
                              tField('node_service_status',
                                     {
                                      sub_fields => [
                                                     tField('service'),
                                                     tField('status'),
                                                     tField('description'),
                                                    ]
                                     }
                                    ),
                              tField('licenses',
                                     {
                                      sub_fields => [
                                                     tField('license_string'),
                                                     tField('type'),
                                                     tField('expiration'),
                                                     tField('kind'),
                                                     tField('hwid'),
                                                    ]
                                     }
                                    ),
                              tField('lan_ha_port_setting',
                                     {
                                      sub_fields => [
                                                     tField('public_ip_address'),
                                                     tField('v6_public_ip_address'),
                                                     tField('ha_ip_address'),
                                                     tField('lan_port_setting',
                                                            {
                                                             sub_fields => [
                                                                            tField('auto_port_setting_enabled'),
                                                                            tField('speed'),
                                                                            tField('duplex'),
                                                                            tField('reserved_interface', {
                                                                                    'no_access_ok' => 1,
                                                                                    'sub_fields' => $t->__return_fields__()
                                                                                }),
                                                                           ]
                                                            }
                                                           ),
                                                     tField('ha_port_setting',
                                                            {
                                                             sub_fields => [
                                                                            tField('auto_port_setting_enabled'),
                                                                            tField('speed'),
                                                                            tField('duplex'),
                                                                            tField('reserved_interface', {
                                                                                    'no_access_ok' => 1,
                                                                                    'sub_fields' => $t->__return_fields__()
                                                                                }),
                                                                           ]
                                                            }
                                                           ),
                                                    ]
                                     }
                                    ),
                              tField('mgmt_physical_setting',
                                     {
                                      sub_fields => [
                                                     tField('auto_port_setting_enabled'),
                                                     tField('speed'),
                                                     tField('duplex'),
                                                     tField('reserved_interface', {
                                                             'no_access_ok' => 1,
                                                             'sub_fields' => $t->__return_fields__()
                                                         }),
                                                    ]
                                     }
                                    ),
                              tField('mgmt_network_setting',
                                     {
                                      sub_fields => [
                                                     tField('address'),
                                                     tField('subnet_mask'),
                                                     tField('gateway'),
                                                     tField('dscp'),
                                                     tField('use_dscp'),
                                                    ]
                                     }
                                    ),
                              tField('v6_mgmt_network_setting',
                                     {
                                      sub_fields => [
                                                     tField('enabled'),
                                                     tField('virtual_ip'),
                                                     tField('cidr_prefix'),
                                                     tField('gateway'),
                                                     tField('auto_router_config_enabled'),
                                                     tField('dscp'),
                                                     tField('use_dscp'),
                                                    ]
                                     }
                                    ),
                              tField('lan2_physical_setting',
                                     {
                                      sub_fields => [
                                                     tField('auto_port_setting_enabled'),
                                                     tField('speed'),
                                                     tField('duplex'),
                                                     tField('reserved_interface', {
                                                             'no_access_ok' => 1,
                                                             'sub_fields' => $t->__return_fields__()
                                                         }),
                                                    ]
                                     }
                                    ),
                             ]
              }
        );
	}

    #
    $self->{'__initializing_from_ibap__'}=1;
    $self->exclude_grid_master_as_ntp_server('false') unless defined $self->exclude_grid_master_as_ntp_server();
    $self->active_position('0') unless defined $self->active_position();
    $self->type('IDnode') unless defined $self->type();
    $self->platform('Infoblox') unless defined $self->platform();
    $self->nat_enabled('false') unless defined $self->nat_enabled();
    delete $self->{'__initializing_from_ibap__'};
    $self->enable_snmpv3_query('false') unless defined $self->enable_snmpv3_query();

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

sub __i2o_email__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    return $$ibap_object_ref{$current}{'address'};
}

sub __i2o_lomconfig__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if ($$ibap_object_ref{$current} && ref($$ibap_object_ref{$current}) eq 'ARRAY') {
        my $node1 = @{$$ibap_object_ref{$current}}[0];
        my $node2 = @{$$ibap_object_ref{$current}}[1];

        $self->{'node1_lom_is_capable'} = ibap_value_i2o_boolean($node1->{'is_lom_capable'});
        $self->{'node1_lom_ipv4addr'} = $node1->{'address'};
        $self->{'node1_lom_mask'} = $node1->{'subnet_mask'};
        $self->{'node1_lom_gateway'} = $node1->{'gateway'};

        $self->{'node2_lom_is_capable'} = ibap_value_i2o_boolean($node2->{'is_lom_capable'});
        $self->{'node2_lom_ipv4addr'} = $node2->{'address'};
        $self->{'node2_lom_mask'} = $node2->{'subnet_mask'};
        $self->{'node2_lom_gateway'} = $node2->{'gateway'};
    }

    return;
}

sub __i2o_dns_resolver__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if ($$ibap_object_ref{'use_resolver_setting'} && $$ibap_object_ref{$current}{'enabled'}) {
        if ($$ibap_object_ref{$current}{'resolvers'} && ref($$ibap_object_ref{$current}{'resolvers'}) eq 'ARRAY') {
            if (defined @{$$ibap_object_ref{$current}{'resolvers'}}[0]) {
                #

                my $address = @{$$ibap_object_ref{$current}{'resolvers'}}[0];
                my $t;
                if ($address) {
                    if (is_ipv4_address($address)) {
                        $t=Infoblox::DNS::Member->new(ipv4addr => $address);
                    } else {
                        $t=Infoblox::DNS::Member->new(ipv6addr => $address);
                    }
                }
                $self->prefer_resolver($t);
            }

            if (defined @{$$ibap_object_ref{$current}{'resolvers'}}[1]) {
                my $address = @{$$ibap_object_ref{$current}{'resolvers'}}[1];
                my $t;
                if ($address) {
                    if (is_ipv4_address($address)) {
                        $t=Infoblox::DNS::Member->new(ipv4addr => $address);
                    } else {
                        $t=Infoblox::DNS::Member->new(ipv6addr => $address);
                    }
                }
                $self->alternate_resolver($t);
            }
            $self->search_domains($$ibap_object_ref{$current}{'search_domains'}) if defined $$ibap_object_ref{$current}{'search_domains'};
        }
    }

    $self->{'use_resolver_setting'} = $$ibap_object_ref{'use_resolver_setting'};

}

sub __i2o_grid__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    return $$ibap_object_ref{$current}{'name'};
}

sub __i2o_type__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my $mtype=$ibap_object_ref->{$current};

    #
    return ($mtype eq 'VNIOS') ? $mtype : capitalize_first_letter($mtype);
}

sub __i2o_lan2_port__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    $self->lan2_port(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'enabled'}));
    $self->lan2_router_id($$ibap_object_ref{$current}{'virtual_router_id'});
    $self->nic_failover_enabled(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'nic_failover_enabled'}));
    $self->nic_failover_enable_primary(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'nic_failover_enable_primary'}));

    #
    $self->{__nic_failover_enabled_internal} = $self->nic_failover_enabled();

    $self->lan2_gateway($$ibap_object_ref{$current}{'network_setting'}{'gateway'});
    $self->lan2_ipv4addr($$ibap_object_ref{$current}{'network_setting'}{'address'});
    $self->lan2_mask($$ibap_object_ref{$current}{'network_setting'}{'subnet_mask'});

    $self->lan2_dscp($$ibap_object_ref{$current}{'network_setting'}{'dscp'}) if defined $$ibap_object_ref{$current}{'network_setting'}{'dscp'};
    $self->override_lan2_dscp(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'network_setting'}{'use_dscp'}));
    $self->lan2_vlan_id($$ibap_object_ref{$current}{'network_setting'}{'vlan_id'}) if defined $$ibap_object_ref{$current}{'network_setting'}{'vlan_id'};

    $self->lan2_ipv6_cidr($$ibap_object_ref{$current}{'v6_network_setting'}{'cidr_prefix'});
    $self->lan2_ipv6_enable(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'v6_network_setting'}{'enabled'}));
    $self->lan2_ipv6_enable_auto_config(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'v6_network_setting'}{'auto_router_config_enabled'}));
    $self->lan2_ipv6_gateway($$ibap_object_ref{$current}{'v6_network_setting'}{'gateway'});
    $self->lan2_ipv6addr($$ibap_object_ref{$current}{'v6_network_setting'}{'virtual_ip'});

    $self->lan2_ipv6_dscp($$ibap_object_ref{$current}{'v6_network_setting'}{'dscp'}) if defined $$ibap_object_ref{$current}{'v6_network_setting'}{'dscp'};
    $self->override_lan2_ipv6_dscp(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'v6_network_setting'}{'use_dscp'}));
    $self->lan2_ipv6_vlan_id($$ibap_object_ref{$current}{'v6_network_setting'}{'vlan_id'}) if defined $$ibap_object_ref{$current}{'v6_network_setting'}{'vlan_id'};
}

sub __i2o_ipv6setting__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if ($$ibap_object_ref{$current}{'enabled'}) {
        $self->ipv6_cidr($$ibap_object_ref{$current}{'cidr_prefix'});
        $self->ipv6_enable_auto_config(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'auto_router_config_enabled'}));
        $self->ipv6_gateway($$ibap_object_ref{$current}{'gateway'});

        $self->lan1_ipv6_dscp($$ibap_object_ref{$current}{'dscp'}) if defined $$ibap_object_ref{$current}{'dscp'};
        $self->override_lan1_ipv6_dscp(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'use_dscp'}));
        $self->ipv6_vlan_id($$ibap_object_ref{$current}{'vlan_id'}) if defined $$ibap_object_ref{$current}{'vlan_id'};

        return $$ibap_object_ref{$current}{'virtual_ip'};
    }
    else {
        return undef;
    }
}

sub __i2o_mgmt_port__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    $self->vpn_on_mgmt(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'vpn_enabled'}));
    $self->mgmt_port(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'enabled'}));
}

sub __i2o_nat__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if ($$ibap_object_ref{$current}{'enabled'}) {
        if (defined $$ibap_object_ref{$current}{'group'}{'name'}) {
            $self->nat_group($$ibap_object_ref{$current}{'group'}{'name'});
        }

        $self->nat_ip_address($$ibap_object_ref{$current}{'external_virtual_ip'});
    }

    $self->nat_enabled(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'enabled'}));
}

sub __i2o_ntp__ {
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    $self->enable_ntp(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'ntp_service_enabled'}));
    $self->external_ntp_servers_enabled(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'external_ntp_servers_enabled'}));

    my %tkeys;
    #
    #
    #

    if (defined $$ibap_object_ref{$current}{'inherited_values'}{'ntp_keys'}{'values'} && @{$$ibap_object_ref{$current}{'inherited_values'}{'ntp_keys'}{'values'}}) {
        foreach my $t (@{$$ibap_object_ref{$current}{'inherited_values'}{'ntp_keys'}{'values'}}) {
            if (defined $$t{'value'} && @{$$t{'value'}}) {
                foreach my $objectref (@{$$t{'value'}}) {
                    my $return_object=Infoblox::Grid::NTPKey->__new__();
                    $return_object->__ibap_to_object__($objectref, $session->get_ibap_server(), $session, $return_object_cache_ref);
                    $tkeys{$return_object->key_number()} = $return_object;
                }
            }
        }
    }

    foreach (
             (
              ['ntp_servers', 'Infoblox::Grid::NTPServer', 'ntp_server', 'use_ntp_servers'],
              ['ntp_keys', 'Infoblox::Grid::NTPKey', 'ntp_authentication_key', 'use_ntp_keys'],
             )
            ) {
        my ($name, $type,$method,$use) = @{$_};

        if ($$ibap_object_ref{$current}{$use}) {
            my @list;

            if ($$ibap_object_ref{$current}{$name} && @{$$ibap_object_ref{$current}{$name}}) {
                foreach my $objectref (@{$$ibap_object_ref{$current}{$name}}) {
                    my $return_object=$type->__new__();
                    $return_object->__ibap_to_object__($objectref, $session->get_ibap_server(), $session, $return_object_cache_ref);
                    push @list,$return_object;

                    if ($name eq 'ntp_keys') {
                        $tkeys{$return_object->key_number()} = $return_object;
                    }
                }
            }
            $self->$method(\@list);
        }
    }

    #
    foreach my $tout (@{$self->{'ntp_server'}}) {
        if ($tout->ntp_key()) {
            if ($tkeys{$tout->ntp_key()->key_number()}) {
                $tout->ntp_key()->key_string($tkeys{$tout->ntp_key()->key_number()}->key_string());
                $tout->ntp_key()->key_type($tkeys{$tout->ntp_key()->key_number()}->key_type()) if $tkeys{$tout->ntp_key()->key_number()}->key_type();
            }
            else {
                #
                #
                #
            }
        }
    }

    foreach (
             (
              ['ntp_acl', 'ntp_access_list','use_ntp_acl'],
             )
            ) {
        my ($name, $method,$use) = @{$_};
        if ($$ibap_object_ref{$current}{$use}) {
            $self->$method(ibap_i2o_ntp_ac_setting($self, $session, $name, $$ibap_object_ref{$current}, $return_object_cache_ref));
        }
    }

    $self->exclude_grid_master_as_ntp_server(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'grid_master_ntp_server_excluded'}));
    $self->ntp_kod(ibap_value_i2o_boolean($$ibap_object_ref{$current}{ntp_kod}));
}

sub __i2o_node__ {
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my ($node1,$node2);

    $node1=@{$$ibap_object_ref{$current}}[0];
    $node2=@{$$ibap_object_ref{$current}}[1] if defined @{$$ibap_object_ref{$current}}[1];

    #
    #
    #
    if ($node2 && $$node2{'ha_status'} =~ m/active/i) {
        $self->{'active_position'} = 1;
    }

    if ($$node1{'licenses'}) {
        $self->node1_licenses(ibap_i2o_generic_object_list_convert($self,$session,'licenses',$node1,$return_object_cache_ref));
    }

    if ($$node1{'node_service_status'}) {
        $self->node1_service_status(ibap_i2o_generic_object_list_convert($self,$session,'node_service_status',$node1,$return_object_cache_ref));
    }

    #
    #
    #
    #
    #
    #
    #
    #
    #

    $self->node1_lcd_hwident(ibap_value_i2o_boolean($$node1{'lcd_hwident'}));
    $self->node1_lcd_autodim($$node1{'lcd_autodim'});
    $self->node1_lcd_version($$node1{'lcd_version'});
    $self->node1_lcd_brightness($$node1{'lcd_brightness'});
    $self->node1_physical_oid($$node1{'physical_oid'});
    $self->node1_hwplatform($$node1{'hardware_platform'});
    $self->node1_hwid($$node1{'hardware_id'});
    $self->node1_hwtype($$node1{'hardware_type'});
    $self->node1_paid_nios(ibap_value_i2o_boolean($$node1{'payg'}));
    $self->node1_nat($$node1{'nat_external_ip'});
    $self->node1_ha($$node1{'lan_ha_port_setting'}{'ha_ip_address'});
    $self->node1_lan($$node1{'lan_ha_port_setting'}{'public_ip_address'});

    $self->node1_mgmt_dscp($$node1{'mgmt_network_setting'}{'dscp'}) if defined $$node1{'mgmt_network_setting'}{'dscp'};
    $self->override_node1_mgmt_dscp(ibap_value_i2o_boolean($$node1{'mgmt_network_setting'}{'use_dscp'}));

    $self->node1_mgmt_gateway($$node1{'mgmt_network_setting'}{'gateway'});
    $self->node1_mgmt_lan($$node1{'mgmt_network_setting'}{'address'});
    $self->node1_mgmt_mask($$node1{'mgmt_network_setting'}{'subnet_mask'});
    $self->node1_lan_ipv6addr($$node1{'lan_ha_port_setting'}{'v6_public_ip_address'});
    $self->node1_mgmt_ipv6_cidr($$node1{'v6_mgmt_network_setting'}{'cidr_prefix'});

    $self->node1_mgmt_ipv6_dscp($$node1{'v6_mgmt_network_setting'}{'dscp'}) if defined $$node1{'v6_mgmt_network_setting'}{'dscp'};
    $self->override_node1_mgmt_ipv6_dscp(ibap_value_i2o_boolean($$node1{'v6_mgmt_network_setting'}{'use_dscp'}));

    $self->node1_mgmt_ipv6_enable_auto_config(ibap_value_i2o_boolean($$node1{'v6_mgmt_network_setting'}{'auto_router_config_enabled'}));
    $self->node1_mgmt_ipv6_gateway($$node1{'v6_mgmt_network_setting'}{'gateway'});
    $self->node1_mgmt_ipv6addr($$node1{'v6_mgmt_network_setting'}{'virtual_ip'});

    $self->{'node1_mgmt_ipv6_enable'} = $$node1{'v6_mgmt_network_setting'}{'enabled'} ? 1 : 0;

    $self->__i2o_physical_port_setting__($node1->{'lan_ha_port_setting'}->{'ha_port_setting'}, 'ha_port_duplex', 'ha_port_speed', 'ha_reserved_interface');
    $self->__i2o_physical_port_setting__($node1->{'lan_ha_port_setting'}->{'lan_port_setting'}, 'lan_port_duplex', 'lan_port_speed', 'lan_reserved_interface');
    $self->__i2o_physical_port_setting__($node1->{'lan2_physical_setting'}, 'lan2_port_duplex', 'lan2_port_speed', 'lan2_reserved_interface');
    $self->__i2o_physical_port_setting__($node1->{'mgmt_physical_setting'}, 'mgmt_port_duplex', 'mgmt_port_speed', 'mgmt_reserved_interface');

    if ($node2) {
        if ($$node2{'licenses'}) {
            $self->node2_licenses(ibap_i2o_generic_object_list_convert($self,$session,'licenses',$node2,$return_object_cache_ref));
        }

        if ($$node1{'node_service_status'}) {
            $self->node2_service_status(ibap_i2o_generic_object_list_convert($self,$session,'node_service_status',$node2,$return_object_cache_ref));
        }

        $self->node2_lcd_hwident(ibap_value_i2o_boolean($$node2{'lcd_hwident'}));
        $self->node2_lcd_autodim($$node2{'lcd_autodim'});
        $self->node2_lcd_version($$node2{'lcd_version'});
        $self->node2_lcd_brightness($$node2{'lcd_brightness'});
        $self->node2_physical_oid($$node2{'physical_oid'});
        $self->node2_hwplatform($$node2{'hardware_platform'});
        $self->node2_hwid($$node2{'hardware_id'});
        $self->node2_hwtype($$node2{'hardware_type'});
        $self->node2_paid_nios(ibap_value_i2o_boolean($$node2{'payg'}));
        $self->node2_nat($$node2{'nat_external_ip'});
        $self->node2_ha($$node2{'lan_ha_port_setting'}{'ha_ip_address'});
        $self->node2_lan($$node2{'lan_ha_port_setting'}{'public_ip_address'});

        $self->node2_mgmt_dscp($$node2{'mgmt_network_setting'}{'dscp'}) if defined $$node2{'mgmt_network_setting'}{'dscp'};
        $self->override_node2_mgmt_dscp(ibap_value_i2o_boolean($$node2{'mgmt_network_setting'}{'use_dscp'}));

        $self->node2_mgmt_gateway($$node2{'mgmt_network_setting'}{'gateway'});
        $self->node2_mgmt_lan($$node2{'mgmt_network_setting'}{'address'});
        $self->node2_mgmt_mask($$node2{'mgmt_network_setting'}{'subnet_mask'});
        $self->node2_lan_ipv6addr($$node2{'lan_ha_port_setting'}{'v6_public_ip_address'});
        $self->node2_mgmt_ipv6_cidr($$node2{'v6_mgmt_network_setting'}{'cidr_prefix'});

        $self->node2_mgmt_ipv6_dscp($$node2{'v6_mgmt_network_setting'}{'dscp'}) if defined $$node2{'v6_mgmt_network_setting'}{'dscp'};
        $self->override_node2_mgmt_ipv6_dscp(ibap_value_i2o_boolean($$node2{'v6_mgmt_network_setting'}{'use_dscp'}));

        $self->node2_mgmt_ipv6_enable_auto_config(ibap_value_i2o_boolean($$node2{'v6_mgmt_network_setting'}{'auto_router_config_enabled'}));
        $self->node2_mgmt_ipv6_gateway($$node2{'v6_mgmt_network_setting'}{'gateway'});
        $self->node2_mgmt_ipv6addr($$node2{'v6_mgmt_network_setting'}{'virtual_ip'});

        $self->{'node2_mgmt_ipv6_enable'} = $$node2{'v6_mgmt_network_setting'}{'enabled'} ? 1 : 0;

        $self->__i2o_physical_port_setting__($node2->{'lan_ha_port_setting'}->{'ha_port_setting'}, 'ha_node2_port_duplex', 'ha_node2_port_speed', 'node2_ha_reserved_interface');
        $self->__i2o_physical_port_setting__($node2->{'lan_ha_port_setting'}->{'lan_port_setting'}, 'lan_node2_port_duplex', 'lan_node2_port_speed', 'node2_lan_reserved_interface');
        $self->__i2o_physical_port_setting__($node2->{'lan2_physical_setting'}, 'lan2_node2_port_duplex', 'lan2_node2_port_speed', 'node2_lan2_reserved_interface');
        $self->__i2o_physical_port_setting__($node2->{'mgmt_physical_setting'}, 'mgmt_node2_port_duplex', 'mgmt_node2_port_speed', 'node2_mgmt_reserved_interface');
    }
}

sub __i2o_physical_port_setting__
{
    my ($self, $data, $duplex, $speed, $reserved_interface) = @_;

    unless ($data->{'auto_port_setting_enabled'}) {
        $self->$duplex(capitalize_first_letter($data->{'duplex'}));
        $self->$speed($data->{'speed'});
    }

    if ($data->{'reserved_interface'}) {
        $self->$reserved_interface(__i2o_reserved_interface__($data->{'reserved_interface'}));
    }
}

sub __i2o_reserved_interface__
{
    my $ibap_object_ref = shift;

    #
    delete $$ibap_object_ref{reserved_obj};

    my $obj = Infoblox::Grid::Discovery::DeviceInterface->__new__();
    $obj->__ibap_to_object__($ibap_object_ref);

    return $obj;
}

sub __i2o_snmp__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if ($$ibap_object_ref{'use_snmp_setting'}) {
        $self->query_comm_string($$ibap_object_ref{$current}{'queries_community_string'}) if $$ibap_object_ref{$current}{'queries_enabled'};
        $self->{'use_query_string'} = $$ibap_object_ref{$current}{'queries_enabled'};

        $self->trap_comm_string($$ibap_object_ref{$current}{'traps_community_string'}) if $$ibap_object_ref{$current}{'traps_enabled'};
        $self->{'use_trap_string'} = $$ibap_object_ref{$current}{'traps_enabled'};


        $self->snmpv3_query_users(ibap_i2o_snmpv3_query_users($self,$session,'snmpv3_queries_users',$$ibap_object_ref{$current}));
        $self->{'enable_snmpv3_query'}=ibap_value_i2o_boolean($$ibap_object_ref{$current}{'snmpv3_queries_enabled'});
        $self->{'enable_snmpv3_traps'} = ibap_value_i2o_boolean($$ibap_object_ref{$current}{'snmpv3_traps_enabled'});
        $self->trap_receiver(ibap_i2o_trap_receivers($self,$session,'trap_receivers',$$ibap_object_ref{$current}));
        $self->{'engine_id'} = $$ibap_object_ref{$current}{'engine_id'};


        my $t=Infoblox::Grid::SNMP::Admin->__new__();
        $t->__ibap_to_object__($$ibap_object_ref{$current}, $session->get_ibap_server(), $session);
        $self->snmp_admin($t);

        $self->{'use_snmp_admin'} = 1;

    }

    $self->{'use_snmp_setting'} = $$ibap_object_ref{'use_snmp_setting'};
}

sub __i2o_syslog_proxy__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if ($$ibap_object_ref{'use_syslog_setting'}) {
        $self->enable_syslog_proxy(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'enabled'}));
        $self->syslog_proxy_tcp_port($$ibap_object_ref{$current}{'tcp_port'}) if $$ibap_object_ref{$current}{'tcp_enabled'};
        $self->syslog_proxy_udp_port($$ibap_object_ref{$current}{'udp_port'}) if $$ibap_object_ref{$current}{'udp_enabled'};

        if ($$ibap_object_ref{$current}{'client_acls'}) {
            $self->allow_syslog_clients(ibap_i2o_ac_setting($self, $session, 'client_acls', $$ibap_object_ref{$current}));
        }
    }
}

sub __i2o_sroutes__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
		foreach my $objectref (@{$$ibap_object_ref{$current}}) {
            my $return_object=Infoblox::Grid::Member::StaticRoute->__new__();
            $return_object->__ibap_to_object__($objectref, $session->get_ibap_server(), $session, $return_object_cache_ref);
            push @newlist,$return_object;
        }
    }
    return \@newlist;
}

sub __i2o_6sroutes__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
		foreach my $objectref (@{$$ibap_object_ref{$current}}) {
            my $return_object=Infoblox::Grid::Member::IPv6StaticRoute->__new__();
            $return_object->__ibap_to_object__($objectref, $session->get_ibap_server(), $session, $return_object_cache_ref);
            push @newlist,$return_object;
        }
    }
    return \@newlist;
}

sub __i2o_vip__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    $self->gateway($$ibap_object_ref{$current}{'gateway'});
    $self->ipv4addr($$ibap_object_ref{$current}{'address'});
    $self->mask($$ibap_object_ref{$current}{'subnet_mask'});

    $self->lan1_dscp($$ibap_object_ref{$current}{'dscp'}) if defined $$ibap_object_ref{$current}{'dscp'};
    $self->override_lan1_dscp(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'use_dscp'}));
    $self->vlan_id($$ibap_object_ref{$current}{'vlan_id'}) if defined $$ibap_object_ref{$current}{'vlan_id'};
}

sub __i2o_virtuals__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    #
    #
    #
    #

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        my @objects = @{$$ibap_object_ref{$current}};

		foreach my $objectref (@objects) {
            my $return_object = Infoblox::Grid::Member::Interface->__new__();
            $return_object->__ibap_to_object__($objectref, $session->get_ibap_server(), $session, $return_object_cache_ref);
            push @newlist, $return_object;
        }

        return \@newlist;
    } else {
        return;
    }
}

#
#
sub __skip_handler__{};

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

	$self->{ '__internal_session_cache_ref__' } = \$session;

    $$ibap_object_ref{'nat_setting'}{'enabled'}                       = 0 unless defined($$ibap_object_ref{'nat_setting'}{'enabled'});
    $$ibap_object_ref{'lan2_port_setting'}{'enabled'}                 = 0 unless defined($$ibap_object_ref{'lan2_port_setting'}{'enabled'});
    $$ibap_object_ref{'lan2_port_setting'}{'v6_network_setting'}{'enabled'} = 0 unless defined($$ibap_object_ref{'lan2_port_setting'}{'v6_network_setting'}{'enabled'});
    $$ibap_object_ref{'lan2_port_setting'}{'v6_network_setting'}{'auto_router_config_enabled'} = 0 unless defined($$ibap_object_ref{'lan2_port_setting'}{'v6_network_setting'}{'auto_router_config_enabled'});
    $$ibap_object_ref{'lan2_port_setting'}{'nic_failover_enabled'}    = 0 unless defined($$ibap_object_ref{'lan2_port_setting'}{'nic_failover_enabled'});
    $$ibap_object_ref{'lan2_port_setting'}{'nic_failover_enable_primary'}    = 0 unless defined($$ibap_object_ref{'lan2_port_setting'}{'nic_failover_enable_primary'});
    $$ibap_object_ref{'mgmt_port_setting'}{'enabled'}                 = 0 unless defined($$ibap_object_ref{'mgmt_port_setting'}{'enabled'});
    $$ibap_object_ref{'mgmt_port_setting'}{'security_access_enabled'} = 0 unless defined($$ibap_object_ref{'mgmt_port_setting'}{'security_access_enabled'});
    $$ibap_object_ref{'mgmt_port_setting'}{'vpn_enabled'}             = 0 unless defined($$ibap_object_ref{'mgmt_port_setting'}{'vpn_enabled'});

    $$ibap_object_ref{'email_setting'}{'enabled'}                     = 0 unless defined($$ibap_object_ref{'email_setting'}{'enabled'});

    $$ibap_object_ref{'ntp_setting'}{'use_ntp_keys'}                    = 0 unless defined($$ibap_object_ref{'ntp_setting'}{'use_ntp_keys'});
    $$ibap_object_ref{'ntp_setting'}{'use_ntp_servers'}                 = 0 unless defined($$ibap_object_ref{'ntp_setting'}{'use_ntp_servers'});
    $$ibap_object_ref{'ntp_setting'}{'external_ntp_servers_enabled'}    = 0 unless defined($$ibap_object_ref{'ntp_setting'}{'external_ntp_servers_enabled'});
    $$ibap_object_ref{'ntp_setting'}{'grid_master_ntp_server_excluded'} = 0 unless defined($$ibap_object_ref{'ntp_setting'}{'grid_master_ntp_server_excluded'});
    $$ibap_object_ref{'ntp_setting'}{'ntp_service_enabled'}             = 0 unless defined($$ibap_object_ref{'ntp_setting'}{'ntp_service_enabled'});
    $$ibap_object_ref{'ntp_setting'}{'use_ntp_acl'}                     = 0 unless defined($$ibap_object_ref{'ntp_setting'}{'use_ntp_acl'});
    $$ibap_object_ref{'ntp_setting'}{'use_ntp_kod'}                     = 0 unless defined($$ibap_object_ref{'ntp_setting'}{'use_ntp_kod'});
    $$ibap_object_ref{'ntp_setting'}{'ntp_kod'}                         = 0 unless defined($$ibap_object_ref{'ntp_setting'}{'ntp_kod'});

    $$ibap_object_ref{'use_member_redirect'}            = 0 unless defined($$ibap_object_ref{'use_member_redirect'});
    $$ibap_object_ref{'enable_member_redirect'}         = 0 unless defined($$ibap_object_ref{'enable_member_redirect'});
    $$ibap_object_ref{'external_syslog_server_enabled'} = 0 unless defined($$ibap_object_ref{'external_syslog_server_enabled'});
    $$ibap_object_ref{'ha_enabled'}                     = 0 unless defined($$ibap_object_ref{'ha_enabled'});
#
    $$ibap_object_ref{'is_master'}                      = 0 unless defined($$ibap_object_ref{'is_master'});
    $$ibap_object_ref{'lcd_input_enabled'}              = 0 unless defined($$ibap_object_ref{'lcd_input_enabled'});
    $$ibap_object_ref{'master_candidate_enabled'}       = 0 unless defined($$ibap_object_ref{'master_candidate_enabled'});
    $$ibap_object_ref{'remote_console_access_enabled'}  = 0 unless defined($$ibap_object_ref{'remote_console_access_enabled'});
    $$ibap_object_ref{'support_access_enabled'}         = 0 unless defined($$ibap_object_ref{'support_access_enabled'});
    $$ibap_object_ref{'is_dscp_capable'}                = 0 unless defined($$ibap_object_ref{'is_dscp_capable'});
    $$ibap_object_ref{'use_dscp'}                       = 0 unless defined($$ibap_object_ref{'use_dscp'});
    $$ibap_object_ref{'use_lcd_input'}                  = 0 unless defined($$ibap_object_ref{'use_lcd_input'});
    $$ibap_object_ref{'use_remote_console_access'}      = 0 unless defined($$ibap_object_ref{'use_remote_console_access'});
    $$ibap_object_ref{'use_support_access'}             = 0 unless defined($$ibap_object_ref{'use_support_access'});
    $$ibap_object_ref{'use_syslog_setting'}             = 0 unless defined($$ibap_object_ref{'use_syslog_setting'});
    $$ibap_object_ref{'use_time_zone'}                  = 0 unless defined($$ibap_object_ref{'use_time_zone'});
    $$ibap_object_ref{'use_email_setting'}              = 0 unless defined($$ibap_object_ref{'use_email_setting'});
    $$ibap_object_ref{'use_threshold_traps'}            = 0 unless defined($$ibap_object_ref{'use_threshold_traps'});
    $$ibap_object_ref{'use_ib_traps'}                   = 0 unless defined($$ibap_object_ref{'use_ib_traps'});
    $$ibap_object_ref{'lom_enabled'}     = 0 unless defined($$ibap_object_ref{'lom_enabled'});
    $$ibap_object_ref{'use_lom_enabled'} = 0 unless defined($$ibap_object_ref{'use_lom_enabled'});
    $$ibap_object_ref{'use_lom_users'}   = 0 unless defined($$ibap_object_ref{'use_lom_users'});

    $$ibap_object_ref{'passive_ha_arp_enabled'}   = 0 unless defined($$ibap_object_ref{'passive_ha_arp_enabled'});
    $$ibap_object_ref{'use_v4_vrrp'}               = 0 unless defined($$ibap_object_ref{'use_v4_vrrp'});
    $$ibap_object_ref{'passive_ha_arp_enabled'}   = 0 unless defined($$ibap_object_ref{'passive_ha_arp_enabled'});
    $$ibap_object_ref{'use_v4_vrrp'}               = 0 unless defined($$ibap_object_ref{'use_v4_vrrp'});
    $$ibap_object_ref{'enable_ro_api_access'}      = 0 unless defined($$ibap_object_ref{'enable_ro_api_access'});
    $$ibap_object_ref{'passive_ha_arp_enabled'}      = 0 unless defined($$ibap_object_ref{'passive_ha_arp_enabled'});
    $$ibap_object_ref{'use_v4_vrrp'}                 = 0 unless defined($$ibap_object_ref{'use_v4_vrrp'});
    $$ibap_object_ref{'preserve_if_owns_delegation'} = 0 unless defined($$ibap_object_ref{'preserve_if_owns_delegation'});
    $$ibap_object_ref{'use_syslog_backup_servers'} = 0 unless defined $$ibap_object_ref{'use_syslog_backup_servers'};

    #
    $self->comment('');
    $self->nat_group('');
    $self->additional_ip_list([]);
    $self->bgp_as([]);
    $self->ospf_list([]);
    $self->static_routes([]);
    $self->ipv6_static_routes([]);

    #
    $self->{'ntp_server'} = [];
    $self->{'enable_syslog_proxy'} = 'false';

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->__fix_toplevel_additional_ip__(0);

    #
    #
    #

    #
    #
    #

    $self->{'external_ntp_servers_enabled'} = ibap_value_i2o_boolean($$ibap_object_ref{'ntp_setting'}{'external_ntp_servers_enabled'});
    $self->{'use_ntp_servers'} = $$ibap_object_ref{'ntp_setting'}{'use_ntp_servers'};
    delete $self->{'ntp_server'} unless $self->{'use_ntp_servers'};

    $self->{'use_ntp_acl'} = $$ibap_object_ref{'ntp_setting'}{'use_ntp_acl'};
    unless ($self->{'use_ntp_acl'}) {
        delete $self->{'ntp_access_list'};
        delete $self->{'ntp_service_type'};
    }

    $self->{'use_ntp_keys'} = $$ibap_object_ref{'ntp_setting'}{'use_ntp_keys'};
    delete $self->{'ntp_authentication_key'} unless $self->{'use_ntp_keys'};

    $self->{'use_email_setting'} = $$ibap_object_ref{'use_email_setting'};
    delete $self->{'notification_email_addr'} unless $self->{'use_email_setting'};
    delete $self->{'notification_email_addr'} unless $$ibap_object_ref{'email_setting'}{'enabled'};

    $self->{'use_lcd_input'} = $$ibap_object_ref{'use_lcd_input'};
    delete $self->{'lcd_input'} unless $self->{'use_lcd_input'};

    $self->{'use_time_zone'} = $$ibap_object_ref{'use_time_zone'};
    delete $self->{'time_zone'} unless $self->{'use_time_zone'};

    $self->{'use_remote_console_access'} = $$ibap_object_ref{'use_remote_console_access'};
    delete $self->{'remote_console_access'} unless $self->{'use_remote_console_access'};

    $self->{'use_support_access'} = $$ibap_object_ref{'use_support_access'};
    delete $self->{'support_access'} unless $self->{'use_support_access'};

    #
    #
    $self->{'external_syslog_server_enabled'} = $$ibap_object_ref{'external_syslog_server_enabled'};
    $self->{'use_syslog_setting'} = $$ibap_object_ref{'use_syslog_setting'};
    delete $self->{'syslog_server'} unless $self->{'external_syslog_server_enabled'};


    unless ($self->{'use_syslog_setting'}) {
        delete $self->{'syslog_server'};
        delete $self->{'syslog_size'};
        $self->{'use_syslog_setting_size'} = 0;
    }

    unless ($$ibap_object_ref{'nat_setting'}{'enabled'}) {
        $self->{'nat_enabled'} = 'false';

        #
        $self->{'use_node1_nat_setting'} = 0;
        $self->{'use_node2_nat_setting'} = 0;

        #
        #
        delete $self->{'node1_nat'};
        delete $self->{'node2_nat'};
    }

    #
    $self->{'override_enable_member_redirect'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_member_redirect'});
    $self->{'override_threshold_traps'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_threshold_traps'});
    $self->{'override_trap_notifications'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ib_traps'});
    $self->{'override_dscp'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_dscp'});
    $self->{'override_enable_lom'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_lom_enabled'});
    $self->{'override_lom_users'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_lom_users'});
    $self->{'override_ntp_kod'}=ibap_value_i2o_boolean($$ibap_object_ref{'ntp_setting'}{'use_ntp_kod'});
    $self->{'override_syslog_backup_servers'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_syslog_backup_servers'});

	return;
}

#
#
#

sub __o2i_lomconfig__
{
    my ($self, $session, $current, $tempref) = @_;
    my (%node1_lom, %node2_lom);

    %node1_lom = (
                  address     => tString(''),
                  subnet_mask => tString(''),
                  gateway     => tString(''),
                 );

    $node1_lom{'address'} = ibap_value_o2i_ipv4addr($self->{'node1_lom_ipv4addr'}, '', $session) if $self->{'node1_lom_ipv4addr'};
    $node1_lom{'gateway'} = ibap_value_o2i_ipv4addr($self->{'node1_lom_gateway'}, '', $session) if $self->{'node1_lom_gateway'};
    $node1_lom{'subnet_mask'} = ibap_value_o2i_ipv4addr($self->{'node1_lom_mask'}, '', $session) if $self->{'node1_lom_mask'};

    if ($self->type() eq 'HApair') {
        %node2_lom = (
                     address     => tString(''),
                     subnet_mask => tString(''),
                     gateway     => tString(''),
                    );

        $node2_lom{'address'} = ibap_value_o2i_ipv4addr($self->{'node2_lom_ipv4addr'}, '', $session) if $self->{'node2_lom_ipv4addr'};
        $node2_lom{'gateway'} = ibap_value_o2i_ipv4addr($self->{'node2_lom_gateway'}, '', $session) if $self->{'node2_lom_gateway'};
        $node2_lom{'subnet_mask'} = ibap_value_o2i_ipv4addr($self->{'node2_lom_mask'}, '', $session) if $self->{'node2_lom_mask'};

        return (1,0, tIBType('ArrayOflom_network_config', [\%node1_lom, \%node2_lom]));
    }
    else {
        return (1,0, tIBType('ArrayOflom_network_config', [\%node1_lom]));
    }
}

my @__copy_fields_toplevel_additional = (
    ['ipv6addr', 'ipv6addr'],
    ['dscp', 'lan1_ipv6_dscp'],
    ['cidr', 'ipv6_cidr'],
    ['gateway', 'ipv6_gateway'],
    ['vlan_id', 'ipv6_vlan_id'],
    ['enable_ipv6_auto_config', 'ipv6_enable_auto_config'],
    ['override_dscp', 'override_lan1_ipv6_dscp'],
);

my @__copy_fields_additional_toplevel = (
    ['ipv6addr', 'ipv6addr'],
    ['lan1_ipv6_dscp', 'dscp'],
    ['ipv6_cidr', 'cidr'],
    ['ipv6_gateway', 'gateway'],
    ['ipv6_vlan_id', 'vlan_id'],
    ['ipv6_enable_auto_config', 'enable_ipv6_auto_config'],
    ['override_lan1_ipv6_dscp', 'override_dscp'],
);

sub __mirror_additional__
{
    my ($left, $right, $what) = @_;

    foreach my $x (@$what) {
        my $t = $x->[0];
        if (defined $right->$t()) {
            $left->{$x->[1]} = $right->$t();
        } else {
            delete $left->{$x->[1]};
        }
    }
}

use Data::Dumper;
my $debug = 0;

sub __fix_toplevel_additional_ip__
{
    my ($self, $toplevel_from_additional, $listref) = @_;

    #
    #
    #
    return if $self->{'__initializing_from_ibap__'};

    #
    return if $self->{'__initializing_from_new__'};

    if ($toplevel_from_additional) {
        #
        my $found;
        $listref = $self->{'additional_ip_list'} unless $listref;

        if ($listref) {
            #
            #
            #
            #
            #
            #
            #

            my $foundvlan;
            foreach my $t (@$listref) {
                #
                if ($t == $self->{'__additional_mirror__'}) {
                    $found = $t;
                    last;
                }

                if ($t->interface() && $t->interface() eq 'LAN_HA' && $t->ipv6addr()) {
                    #
                    #
                    $foundvlan = $t;

                    #
                    $found = $t unless $t->{'vlan_id'};
                }
            }
            $found = $foundvlan unless $found;
        }

        if ($found) {
            #
            #
            #
            __mirror_additional__($self, $found, \@__copy_fields_toplevel_additional);
            $self->{'__additional_mirror__'} = $found;
        } else {
            #
            delete $self->{'ipv6_cidr'};
            delete $self->{'ipv6_enable_auto_config'};
            delete $self->{'ipv6_gateway'};
            delete $self->{'lan1_ipv6_dscp'};
            delete $self->{'override_lan1_ipv6_dscp'};
            delete $self->{'ipv6_vlan_id'};
            delete $self->{'__additional_mirror__'};

            #
            $self->{'ipv6addr'} = undef;
        }
    }
    else {
        #
        #
        #
        #
        #
        #
        #
        #
        $listref = $self->{'additional_ip_list'};

        my $docreate = ($self->{'ipv6addr'}) ? 1 : 0;
        if ($self->{'__additional_mirror__'}) {
            #
            #
            if ($docreate) {
                __mirror_additional__($self->{'__additional_mirror__'}, $self, \@__copy_fields_additional_toplevel);
            } else {
                my @newlist;
                foreach my $t (@$listref) {
                    if ($t != $self->{'__additional_mirror__'}) {
                        push @newlist, $t;
                    } else {
                        delete $t->{'__member_association__'};
                    }
                }
                $self->{'__additional_mirror__'} = undef;
                $self->{'additional_ip_list'} = \@newlist;
            }
        }
        else {
            if ($docreate) {
            #
                my $v6listobject = Infoblox::Grid::Member::Interface->__new__();
                $v6listobject->interface('LAN_HA');
                __mirror_additional__($v6listobject, $self, \@__copy_fields_additional_toplevel);
                $self->{'__additional_mirror__'} = $v6listobject;
                $v6listobject->{'__member_association__'} = $self;

                if ($listref) {
                    #
                    #
                    push @{$self->{'additional_ip_list'}}, $v6listobject;
                } else {
                    $self->{'additional_ip_list'} = [$v6listobject];
                }
            }
        }
    }

    if ($self->{'ipv4addr'} && $self->{'ipv6addr'}) {
        $self->{'config_addr_type'} = 'BOTH';
        #
    }
    elsif ($self->{'ipv6addr'}) {
        $self->{'config_addr_type'} = 'IPv6';
        $self->{'use_v4_vrrp'} = 'false';
    }
    else {
        $self->{'config_addr_type'} = 'IPv4';
        $self->{'use_v4_vrrp'} = 'true';
    }
}

sub __o2i_ipv6addr__
{
    my ($self, $session, $current, $tempref) = @_;

    if ($self->ipv6addr()) {
        my $write_fields = {
            'enabled'    => ibap_value_o2i_boolean('true'),
            'virtual_ip' => ibap_value_o2i_string($self->ipv6addr()),
        };
        $write_fields->{'cidr_prefix'} = ibap_value_o2i_uint($self->ipv6_cidr()) if $self->ipv6_cidr();
        $write_fields->{'gateway'} = ibap_value_o2i_string_undef_to_empty($self->ipv6_gateway()) if $self->ipv6_gateway();
        $write_fields->{'auto_router_config_enabled'} = ibap_value_o2i_boolean($self->ipv6_enable_auto_config()) if $self->ipv6_enable_auto_config();
        $write_fields->{'dscp'} = ibap_value_o2i_uint($self->lan1_ipv6_dscp()) if defined $self->lan1_ipv6_dscp();
        $write_fields->{'use_dscp'} = ibap_value_o2i_boolean($self->override_lan1_ipv6_dscp()) if defined $self->override_lan1_ipv6_dscp();
        $write_fields->{'vlan_id'} = ibap_value_o2i_uint($self->ipv6_vlan_id()) if defined $self->ipv6_vlan_id();
        $write_fields->{'primary'} = ibap_value_o2i_boolean('true'); # XXX: needed?

        return (1, 0, tIBType('ipv6_setting', $write_fields));
    }
    else {
        return (1, 0, tIBType('ipv6_setting', {'enabled' => ibap_value_o2i_boolean('false')}));
    }
}

sub __o2i_additionalip__
{
    my ($self, $session, $current, $tempref) = @_;
    my $orglist = $$tempref{$current};
    my $newlist = [];

    if ($self->{'__additional_mirror__'}) {
        #
        foreach my $t (@$orglist) {
            push @$newlist, $t if $t != $self->{'__additional_mirror__'};
        }
    }
    else {
        $newlist = $orglist;
    }

    #
    #
    my $t=ibap_serialize_subobject_list($session,$newlist,'MemberAdditionalIp',1);
    return (0) unless $t;

    #
    my @res = ibap_serialize_substruct_list($session, $newlist, 'member_additional_ip_struct');
    return (@res and $res[0] ? (1, 0, @res) : (0));
}

sub __o2i_email__
{
    my ($self, $session, $current, $tempref) = @_;

    #
    #
    #

    if ($$tempref{$current}) {
        return (1,0, tIBType('email_setting', {
                                               'enabled' => ibap_value_o2i_boolean(1),
                                               'address' => ibap_value_o2i_string_undef_to_empty($$tempref{$current}),
                                              }
                            ));
    } else {
        return (1,0, tIBType('email_setting', {
                                               'enabled' => ibap_value_o2i_boolean(0),
                                              }
                            ));
    }
}

sub __o2i_dns_resolver__
{
    my ($self, $session, $current, $tempref) = @_;

    if ($self->prefer_resolver() || $self->alternate_resolver() ) {
        my @list;

        #
        #
        if ($self->prefer_resolver() && ref($self->prefer_resolver())) {
            if ($self->prefer_resolver()->ipv4addr()) {
                push @list, ibap_value_o2i_string_undef_to_empty($self->prefer_resolver()->ipv4addr());
            }
            else {
                push @list, ibap_value_o2i_string_undef_to_empty($self->prefer_resolver()->ipv6addr());
            }
        }
        else {
            push @list, ibap_value_o2i_string_undef_to_empty($self->prefer_resolver());
        }

        if ($self->alternate_resolver() && ref($self->alternate_resolver())) {
            if ($self->alternate_resolver()->ipv4addr()) {
                push @list, ibap_value_o2i_string_undef_to_empty($self->alternate_resolver()->ipv4addr());
            }
            else {
                push @list, ibap_value_o2i_string_undef_to_empty($self->alternate_resolver()->ipv6addr());
            }
        }
        else {
            push @list, ibap_value_o2i_string_undef_to_empty($self->alternate_resolver());
        }
        my $search_domains_list = $self->search_domains() || [];

        return (1,0, tIBType('dns_resolver_setting', {
                                                      'enabled' => ibap_value_o2i_boolean(1),
                                                      'resolvers' => tIBType('ArrayOfIPAddress',\@list),
                                                      'search_domains' => tIBType('ArrayOfstring', $search_domains_list),
                                                     }));
    }
    else {
        return (1,0, tIBType('dns_resolver_setting', {'enabled' => ibap_value_o2i_boolean(0)}));
    }
}

sub __o2i_lan2_port__
{
    my ($self, $session, $current, $tempref) = @_;

    my $lan2 = {};
    my $nic_failover = ($self->nic_failover_enabled() and $self->nic_failover_enabled() eq 'true') ? 1 : 0;

    $lan2->{'nic_failover_enabled'} = ibap_value_o2i_boolean($nic_failover);
    $lan2->{'nic_failover_enable_primary'} = ibap_value_o2i_boolean($self->nic_failover_enable_primary() || 0);

    #
    #
    if ($nic_failover) {
        $lan2->{'enabled'} = ibap_value_o2i_boolean('true');
    } elsif ($self->lan2_port() and $self->lan2_port() eq 'true' and
             $self->{__nic_failover_enabled_internal} and $self->{__nic_failover_enabled_internal} eq 'true') {
        $lan2->{'enabled'} = ibap_value_o2i_boolean('false');
    } else {
        $lan2->{'enabled'} = ibap_value_o2i_boolean($self->lan2_port()) if $self->lan2_port();
    }

    #
    my $count = 0;
    foreach ('lan2_ipv4addr', 'lan2_mask', 'lan2_gateway') {
        $count++ if defined $self->{$_};
    }

    if ($count > 0 and $nic_failover) {
        set_error_codes('1108', 'Configuring LAN2 interface with NIC redundancy enabled is not allowed');
        return (0);
    }

    if ($count == 3) {
        my %write_fields = ();
        $write_fields{'dscp'} = ibap_value_o2i_uint($self->lan2_dscp()) if defined $self->lan2_dscp();
        $write_fields{'use_dscp'} = ibap_value_o2i_boolean($self->override_lan2_dscp()) if defined $self->override_lan2_dscp();
        $write_fields{'vlan_id'} = ibap_value_o2i_uint($self->lan2_vlan_id()) if defined $self->lan2_vlan_id();
        $write_fields{'primary'} = ibap_value_o2i_boolean('true'); # It should be marked as primary

        $lan2->{'network_setting'} = tIBType('network_setting',
                                                  {
                                                   'gateway' => ibap_value_o2i_string_undef_to_empty($self->lan2_gateway()),
                                                   'address' => ibap_value_o2i_string_undef_to_empty($self->lan2_ipv4addr()),
                                                   'subnet_mask' => ibap_value_o2i_string_undef_to_empty($self->lan2_mask()),
                                                   %write_fields,
                                                  });
    } elsif ($count > 0) {
        set_error_codes(1103,'lan2_ipv4addr, lan2_mask, lan2_gateway attributes are required if one of them is defined',$session);
        return (0);
    } else {
        $lan2->{'network_setting'} = tIBType('network_setting', {});
    }

    #
    $count = 0;
    foreach ('lan2_ipv6addr', 'lan2_ipv6_cidr', 'lan2_ipv6_gateway') {
        $count++ if defined $self->{$_};
    }

    #
    unless (defined $self->{'lan2_ipv6_gateway'}) {
        $count++ if (defined $self->{'lan2_ipv6_enable_auto_config'} and $self->{'lan2_ipv6_enable_auto_config'} eq 'true');
    }

    my $required_fields = (defined $self->{'lan2_ipv6_enable_auto_config'} and $self->{'lan2_ipv6_enable_auto_config'} eq 'true') ?
                          'lan2_ipv6addr, lan2_ipv6_cidr' : 'lan2_ipv6addr, lan2_ipv6_cidr, lan2_ipv6_gateway';

    if ($count > 0 and $nic_failover) {
        set_error_codes('1108', 'Configuring LAN2 IPv6 interface with NIC redundancy enabled is not allowed');
        return (0);
    }

    if ($count == 3) {
        my $write_fields = {
            'cidr_prefix' => ibap_value_o2i_uint($self->lan2_ipv6_cidr()),
            'gateway'     => ibap_value_o2i_string_undef_to_empty($self->lan2_ipv6_gateway()),
            'virtual_ip'  => ibap_value_o2i_string_undef_to_empty($self->lan2_ipv6addr()),
        };

        $write_fields->{'enabled'} = ibap_value_o2i_boolean($self->lan2_ipv6_enable()) if $self->lan2_ipv6_enable();
        $write_fields->{'auto_router_config_enabled'} = ibap_value_o2i_boolean($self->lan2_ipv6_enable_auto_config()) if $self->lan2_ipv6_enable_auto_config();
        $write_fields->{'dscp'} = ibap_value_o2i_uint($self->lan2_ipv6_dscp()) if defined $self->lan2_ipv6_dscp();
        $write_fields->{'use_dscp'} = ibap_value_o2i_boolean($self->override_lan2_ipv6_dscp()) if defined $self->override_lan2_ipv6_dscp();
        $write_fields->{'vlan_id'} = ibap_value_o2i_uint($self->lan2_ipv6_vlan_id()) if defined $self->lan2_ipv6_vlan_id();
        $write_fields->{'primary'} = ibap_value_o2i_boolean('true'); # It should be marked as primary

        $lan2->{'v6_network_setting'} = tIBType('ipv6_setting', $write_fields);
    } elsif (defined $self->{'lan2_ipv6_enable'} and $self->{'lan2_ipv6_enable'} eq 'true') {
        set_error_codes(1103,"$required_fields attributes are required if lan2_ipv6_enable is true",$session);
        return (0);
    } elsif ($count > 0) {
        set_error_codes(1103,"$required_fields attributes are required if one of them is defined",$session);
        return (0);
    } else {
        $lan2->{'v6_network_setting'} = tIBType('ipv6_setting', {});
    }

    if (defined $self->lan2_router_id()) {
        $lan2->{'virtual_router_id'} = ibap_value_o2i_int($self->lan2_router_id());
    }

    return (1,0, tIBType('lan2_port_setting', $lan2));
}

sub __o2i_mgmt_port__
{
    my ($self, $session, $current, $tempref) = @_;

    return (1,0, tIBType('mgmt_port_setting', {
                                               'vpn_enabled' => ibap_value_o2i_boolean($self->vpn_on_mgmt() || 0),
                                               'enabled'     => ibap_value_o2i_boolean($self->mgmt_port() || 0),
                                              }));
}

sub __o2i_nat__
{
    my ($self, $session, $current, $tempref) = @_;

    my %natsettings;

    $natsettings{'enabled'} = ibap_value_o2i_boolean($self->nat_enabled());
    $natsettings{'external_virtual_ip'} = ibap_value_o2i_string_undef_to_empty($self->nat_ip_address());
    if ($self->nat_group()) {
        $natsettings{'group'} = ibap_readfield_simple_string('NatGroup','name',$self->nat_group());
    }
    else {
        $natsettings{'group'} = undef;
    }

    return (1,0, tIBType('nat_setting', \%natsettings));
}

sub __o2i_ntp__
{
    my ($self, $session, $current, $tempref) = @_;

    my %substruct;

    $substruct{'ntp_service_enabled'} = ibap_value_o2i_boolean($self->enable_ntp()) if defined $self->enable_ntp();

    if ($$self{is_master} eq 'false' and defined $$self{'external_ntp_servers_enabled'}) {
        $substruct{'external_ntp_servers_enabled'} = ibap_value_o2i_boolean($self->{'external_ntp_servers_enabled'});
    }
    $substruct{'ntp_kod'}             = ibap_value_o2i_boolean($self->ntp_kod()) if defined $self->ntp_kod();
    $substruct{'use_ntp_kod'}         = ibap_value_o2i_boolean($self->override_ntp_kod()) if defined $self->override_ntp_kod();

    $substruct{'use_ntp_servers'} = ibap_value_o2i_boolean($self->{'use_ntp_servers'}) if defined $self->{'use_ntp_servers'};
    if ($self->{'use_ntp_servers'}) {
        $substruct{'ntp_servers'} = ibap_serialize_substruct_list($session,$$tempref{'ntp_server'},'ntp_server');
        return (0) unless $substruct{'ntp_servers'};
    }

    foreach (
             (
              ['ntp_access_list', 'ntp_acl', 'use_ntp_acl'],
             )
            ) {
        my ($name, $iname, $use) = @{$_};

        $substruct{$use} = ibap_value_o2i_boolean($self->{$use}) if defined $self->{$use};

        if ($self->{$use}) {
            my @data = ibap_o2i_ntp_ac_setting($self, $session, $name, $tempref);
            if ($data[0]) {
                $substruct{$iname} = $data[2];
            } else {
                return (0);
            }
        } else {
            $substruct{$iname} = tIBType('ntp_ac_setting', {'acl_type' => 'NONE'});
        }
    }

    $substruct{'use_ntp_keys'} = ibap_value_o2i_boolean($self->{'use_ntp_keys'}) if defined $self->{'use_ntp_keys'};
    if ($self->{'use_ntp_keys'}) {
        $substruct{'ntp_keys'} = ibap_serialize_substruct_list($session, $$tempref{'ntp_authentication_key'}, 'ntp_auth_key', 1);
        return (0) unless $substruct{'ntp_keys'}
    }


    $substruct{'grid_master_ntp_server_excluded'} = ibap_value_o2i_boolean($self->exclude_grid_master_as_ntp_server()) if defined $self->exclude_grid_master_as_ntp_server();

    return (1, 0, tIBType('member_ntp', \%substruct));
}

sub __o2i_physical_port_setting__
{
    my ($self, $duplex, $speed, $reserved_interface_member) = @_;

    my %tport = ();

    if (defined $duplex or defined $speed) {
        $tport{'auto_port_setting_enabled'} = ibap_value_o2i_boolean(0);
        $tport{'duplex'} = ibap_value_o2i_string_undef_to_empty(uc $duplex);
        $tport{'speed'} = ibap_value_o2i_uint_undef_ok($speed);
    } else {
        $tport{'auto_port_setting_enabled'} = ibap_value_o2i_boolean(1);
    }

    if (exists $self->{$reserved_interface_member}) {
        if (defined $self->{$reserved_interface_member}) {
            $tport{'reserved_interface'} = ibap_value_o2i_oid($self->{$reserved_interface_member});
            return unless $tport{'reserved_interface'};
        } else {
            $tport{'reserved_interface'} = undef; # is nillable
        }
    }

    return \%tport;
}

sub __o2i_node__
{
    my ($self, $session, $current, $tempref) = @_;

    my (%node1,%node2, %sub1ha, %sub2ha);

    #
    #
    #

#
#
    $node1{'nat_external_ip'} = ibap_value_o2i_string_undef_to_empty($self->{'node1_nat'});

    $sub1ha{'ha_ip_address'} = ibap_value_o2i_string_undef_to_empty($self->{'node1_ha'});
    $sub1ha{'public_ip_address'} = ibap_value_o2i_string_undef_to_empty($self->{'node1_lan'});
    $sub1ha{'v6_public_ip_address'} = ibap_value_o2i_string_undef_to_empty($self->{'node1_lan_ipv6addr'});

    #
    my $tport = $self->__o2i_physical_port_setting__($self->ha_port_duplex(), $self->ha_port_speed(), 'node1_ha_reserved_interface');
    return (0) unless $tport;
    $sub1ha{'ha_port_setting'} = tIBType('physical_port_setting', $tport);

    #
    $tport = $self->__o2i_physical_port_setting__($self->lan_port_duplex(), $self->lan_port_speed(), 'node1_lan_reserved_interface');
    return (0) unless $tport;
    $sub1ha{'lan_port_setting'} = tIBType('physical_port_setting', $tport);

    $node1{'lan_ha_port_setting'} = tIBType('lan_ha_port_setting', \%sub1ha);

    $node1{'lcd_hwident'} = ibap_value_o2i_boolean($self->{'node1_lcd_hwident'}) if defined $self->{'node1_lcd_hwident'};
    $node1{'lcd_autodim'} = ibap_value_o2i_uint($self->{'node1_lcd_autodim'}) if defined $self->{'node1_lcd_autodim'};
    $node1{'lcd_brightness'} = ibap_value_o2i_uint($self->{'node1_lcd_brightness'}) if defined $self->{'node1_lcd_brightness'};
    $node1{'payg'} = ibap_value_o2i_boolean($self->{'node1_paid_nios'}) if defined $self->{'node1_paid_nios'};

    #
    $tport = $self->__o2i_physical_port_setting__($self->lan2_port_duplex(), $self->lan2_port_speed(), 'node1_lan2_reserved_interface');
    return (0) unless $tport;
    $node1{'lan2_physical_setting'} = tIBType('physical_port_setting', $tport);

    #
    $tport = $self->__o2i_physical_port_setting__($self->mgmt_port_duplex(), $self->mgmt_port_speed(), 'node1_mgmt_reserved_interface');
    return (0) unless $tport;
    $node1{'mgmt_physical_setting'} = tIBType('physical_port_setting', $tport);

    my %write_fields = ();
    $write_fields{'dscp'} = ibap_value_o2i_uint($self->mgmt_dscp()) if defined $self->mgmt_dscp();
    $write_fields{'use_dscp'} = ibap_value_o2i_boolean($self->override_mgmt_dscp()) if defined $self->override_mgmt_dscp();
    $write_fields{'primary'} = ibap_value_o2i_boolean('true'); # It should be marked as primary

    $node1{'mgmt_network_setting'} = tIBType('network_setting',
                                           {
                                            'gateway' => ibap_value_o2i_string_undef_to_empty($self->mgmt_gateway()),
                                            'address' => ibap_value_o2i_string_undef_to_empty($self->mgmt_lan()),
                                            'subnet_mask' => ibap_value_o2i_string_undef_to_empty($self->mgmt_mask()),
                                            %write_fields,
                                           });

    %write_fields = ();
    $write_fields{'dscp'} = ibap_value_o2i_uint($self->mgmt_ipv6_dscp()) if defined $self->mgmt_ipv6_dscp();
    $write_fields{'use_dscp'} = ibap_value_o2i_boolean($self->override_mgmt_ipv6_dscp()) if defined $self->override_mgmt_ipv6_dscp();
    $write_fields{'primary'} = ibap_value_o2i_boolean('true'); # It should be marked as primary
    $write_fields{'enabled'} = ibap_value_o2i_boolean($self->{'node1_mgmt_ipv6_enable'})
        if defined $self->{'node1_mgmt_ipv6_enable'};

    $node1{'v6_mgmt_network_setting'} = tIBType('ipv6_setting',
                                                {
                                                 'cidr_prefix'                => ibap_value_o2i_uint($self->mgmt_ipv6_cidr()),
                                                 'auto_router_config_enabled' => ibap_value_o2i_boolean($self->mgmt_ipv6_enable_auto_config() ? $self->mgmt_ipv6_enable_auto_config() : 'false'),
                                                 'gateway'                    => ibap_value_o2i_string_undef_to_empty($self->mgmt_ipv6_gateway()),
                                                 'virtual_ip'                 => ibap_value_o2i_string_undef_to_empty($self->mgmt_ipv6addr()),
                                                 %write_fields,
                                                });

    #
    if ($self->type() eq 'HApair') {
#
#
        $node2{'nat_external_ip'} = ibap_value_o2i_string_undef_to_empty($self->{'node2_nat'});

        $node2{'lcd_hwident'} = ibap_value_o2i_boolean($self->{'node2_lcd_hwident'}) if defined $self->{'node2_lcd_hwident'};
        $node2{'lcd_autodim'} = ibap_value_o2i_uint($self->{'node2_lcd_autodim'}) if defined $self->{'node2_lcd_autodim'};
        $node2{'lcd_brightness'} = ibap_value_o2i_uint($self->{'node2_lcd_brightness'}) if defined $self->{'node2_lcd_brightness'};
        $node2{'payg'} = ibap_value_o2i_boolean($self->{'node2_paid_nios'}) if defined $self->{'node2_paid_nios'};

        $sub2ha{'ha_ip_address'} = ibap_value_o2i_string_undef_to_empty($self->{'node2_ha'});
        $sub2ha{'public_ip_address'} = ibap_value_o2i_string_undef_to_empty($self->{'node2_lan'});
        $sub2ha{'v6_public_ip_address'} = ibap_value_o2i_string_undef_to_empty($self->{'node2_lan_ipv6addr'});

        #
        $tport = $self->__o2i_physical_port_setting__($self->ha_node2_port_duplex(), $self->ha_node2_port_speed(), 'node2_ha_reserved_interface');
        return (0) unless $tport;
        $sub2ha{'ha_port_setting'} = tIBType('physical_port_setting', $tport);

        #
        $tport = $self->__o2i_physical_port_setting__($self->lan_node2_port_duplex(), $self->lan_node2_port_speed(), 'node2_lan_reserved_interface');
        return (0) unless $tport;
        $sub2ha{'lan_port_setting'} = tIBType('physical_port_setting', $tport);

        $node2{'lan_ha_port_setting'} = tIBType('lan_ha_port_setting', \%sub2ha);

        #
        $tport = $self->__o2i_physical_port_setting__($self->lan2_node2_port_duplex(), $self->lan2_node2_port_speed(), 'node2_lan2_reserved_interface');
        return (0) unless $tport;
        $node2{'lan2_physical_setting'} = tIBType('physical_port_setting', $tport);

        #
        $tport = $self->__o2i_physical_port_setting__($self->mgmt_node2_port_duplex(), $self->mgmt_node2_port_speed(), 'node2_mgmt_reserved_interface');
        return (0) unless $tport;
        $node2{'mgmt_physical_setting'} = tIBType('physical_port_setting', $tport);

        %write_fields = ();
        $write_fields{'dscp'} = ibap_value_o2i_uint($self->node2_mgmt_dscp()) if defined $self->node2_mgmt_dscp();
        $write_fields{'use_dscp'} = ibap_value_o2i_boolean($self->override_node2_mgmt_dscp()) if defined $self->override_node2_mgmt_dscp();
        $write_fields{'primary'} = ibap_value_o2i_boolean('true'); # It should be marked as primar

        $node2{'mgmt_network_setting'} = tIBType('network_setting',
                                                 {
                                                  'gateway' => ibap_value_o2i_string_undef_to_empty($self->node2_mgmt_gateway()),
                                                  'address' => ibap_value_o2i_string_undef_to_empty($self->node2_mgmt_lan()),
                                                  'subnet_mask' => ibap_value_o2i_string_undef_to_empty($self->node2_mgmt_mask()),
                                                  %write_fields,
                                                 });

        %write_fields = ();
        $write_fields{'dscp'} = ibap_value_o2i_uint($self->node2_mgmt_ipv6_dscp()) if defined $self->node2_mgmt_ipv6_dscp();
        $write_fields{'use_dscp'} = ibap_value_o2i_boolean($self->override_node2_mgmt_ipv6_dscp()) if defined $self->override_node2_mgmt_ipv6_dscp();
        $write_fields{'primary'} = ibap_value_o2i_boolean('true'); # It should be marked as primar
        $write_fields{'enabled'} = ibap_value_o2i_boolean($self->{'node2_mgmt_ipv6_enable'})
            if defined $self->{'node2_mgmt_ipv6_enable'};

        $node2{'v6_mgmt_network_setting'} = tIBType('ipv6_setting',
                                                    {
                                                     'cidr_prefix'                => ibap_value_o2i_uint($self->node2_mgmt_ipv6_cidr()),
                                                     'auto_router_config_enabled' => ibap_value_o2i_boolean($self->node2_mgmt_ipv6_enable_auto_config() ? $self->node2_mgmt_ipv6_enable_auto_config() : 'false'),
                                                     'gateway'                    => ibap_value_o2i_string_undef_to_empty($self->node2_mgmt_ipv6_gateway()),
                                                     'virtual_ip'                 => ibap_value_o2i_string_undef_to_empty($self->node2_mgmt_ipv6addr()),
                                                     %write_fields,
                                                    });

        return (1,0, tIBType('ArrayOfnode_info',[tIBType('node_info',\%node1),tIBType('node_info',\%node2)]))
    }
    else {
        return (1,0, tIBType('ArrayOfnode_info',[tIBType('node_info',\%node1)]))
    }
}

sub __o2i_snmp__
{
    my ($self, $session, $current, $tempref) = @_;


    my $values = {
                  'queries_enabled'          => ibap_value_o2i_boolean($self->{'use_query_string'} || 0),
                  'traps_enabled'            => ibap_value_o2i_boolean($self->{'use_trap_string'} || 0),
                  'snmpv3_queries_enabled'   => ibap_value_o2i_boolean($self->{'enable_snmpv3_query'} || 0),
                  'snmpv3_traps_enabled'     => ibap_value_o2i_boolean($self->{'enable_snmpv3_traps'} || 0),
                 };

    $$values{'traps_community_string'} = ibap_value_o2i_string($self->trap_comm_string())
        if $self->trap_comm_string();

    $$values{'queries_community_string'} = ibap_value_o2i_string($self->query_comm_string())
        if $self->query_comm_string();

    for  (
        ['snmpv3_query_users' , 'snmpv3_queries_users', \&ibap_o2i_snmpv3_query_users],
        ['trap_receiver', 'trap_receivers', \&ibap_o2i_trap_receivers]
    )
    {
        my ($cur, $ibap_current, $func) =@{$_};
        my @t = &$func($self, $session, $cur, $self);
        if (@t) {
            my $success=shift @t;
            if ($success) {
                my $ignore_value=shift @t;
                unless ($ignore_value) {
                    $$values{$ibap_current}= shift @t;
                }
            } else {
                return (0,);
            }
        }
    }

    #
    if ($self->snmp_admin()) {
        my $write_fields=$self->snmp_admin()->__object_to_ibap__($session->get_ibap_server(),$session);
        return (0) if(!$write_fields);

        my %substruct;
        foreach (@$write_fields) {
            $values->{$_->{'field'}} = $_->{'value'};
        }
    }

    return (1,0, tIBType('snmp_setting', $values));
}

sub __o2i_syslog_proxy__
{
    my ($self, $session, $current, $tempref) = @_;

    my %struct;
    $struct{'enabled'}     = ibap_value_o2i_boolean($self->enable_syslog_proxy() || 0);
    $struct{'tcp_port'}    = ibap_value_o2i_uint($self->syslog_proxy_tcp_port()) if $self->syslog_proxy_tcp_port();
    $struct{'tcp_enabled'} = ibap_value_o2i_boolean($self->{'use_syslog_setting_tcp'} || 0);
    $struct{'udp_port'}    = ibap_value_o2i_uint($self->syslog_proxy_udp_port()) if $self->syslog_proxy_udp_port();
    $struct{'udp_enabled'} = ibap_value_o2i_boolean($self->{'use_syslog_setting_udp'} || 0);

    my @data = ibap_o2i_ac_setting_undef_to_empty_list($self, $session, 'allow_syslog_clients', $self);
    return (0) unless $data[0];
    $struct{'client_acls'} = $data[2];

    return (1,0, tIBType('syslog_proxy_setting', \%struct));
}

sub __o2i_vip__
{
    my ($self, $session, $current, $tempref) = @_;

    my %write_fields = ();
    $write_fields{'dscp'} = ibap_value_o2i_uint($self->lan1_dscp()) if defined $self->lan1_dscp();
    $write_fields{'use_dscp'} = ibap_value_o2i_boolean($self->override_lan1_dscp()) if defined $self->override_lan1_dscp();
    $write_fields{'vlan_id'} = ibap_value_o2i_uint($self->vlan_id()) if defined $self->vlan_id();
    $write_fields{'primary'} = ibap_value_o2i_boolean('true');

    return (1,0, tIBType('network_setting', {
                                             'gateway' => ibap_value_o2i_string_undef_to_empty($self->gateway()),
                                             'address' => ibap_value_o2i_string_undef_to_empty($self->ipv4addr()),
                                             'subnet_mask' => ibap_value_o2i_string_undef_to_empty($self->mask()),
                                             %write_fields,
                                            }));
}

sub __object_to_ibap__
{
	my ($self, $server, $session) = @_;

	$self->{ '__internal_session_cache_ref__' } = \$session;

    #
    #
    #
    #
    $self->{'external_syslog_server_enabled'} = 0 unless defined $self->{'external_syslog_server_enabled'};
    $self->{'use_email_setting'}              = 0 unless defined $self->{'use_email_setting'};
    $self->{'use_lcd_input'}                  = 0 unless defined $self->{'use_lcd_input'};
    $self->{'use_remote_console_access'}      = 0 unless defined $self->{'use_remote_console_access'};
    $self->{'use_resolver_setting'}           = 0 unless defined $self->{'use_resolver_setting'};
    $self->{'use_snmp_setting'}               = 0 unless defined $self->{'use_snmp_setting'};
    $self->{'use_support_access'}             = 0 unless defined $self->{'use_support_access'};
    $self->{'use_syslog_setting'}             = 0 unless defined $self->{'use_syslog_setting'};
    $self->{'use_time_zone'}                  = 0 unless defined $self->{'use_time_zone'};

    my $ref_write_fields=$self->SUPER::__object_to_ibap__($server, $session);
    return unless $ref_write_fields;

    #
    foreach (
             (
              ['dns_resolver_setting' , \&__o2i_dns_resolver__],
              ['lom_network_config'   , \&__o2i_lomconfig__],
              ['lan2_port_setting'    , \&__o2i_lan2_port__],
              ['mgmt_port_setting'    , \&__o2i_mgmt_port__],
              ['nat_setting'          , \&__o2i_nat__],
              ['node_info'            , \&__o2i_node__],
              ['ntp_setting'          , \&__o2i_ntp__],
              ['snmp_setting'         , \&__o2i_snmp__],
              ['syslog_proxy_setting' , \&__o2i_syslog_proxy__],
              ['vip_setting'          , \&__o2i_vip__],
             )
            ) {
        my ($name, $func) = @{$_};

        my @t = &$func($self, $session, '', $self);
        if (@t) {
            my $success=shift @t;
            if ($success) {
                my $ignore_value=shift @t;
                unless ($ignore_value) {
                    my %write_arg;
                    $write_arg{'field'} = $name;
                    $write_arg{'value'} = shift @t;
                    unshift @$ref_write_fields, \%write_arg;
                }
            } else {
                return;
            }
        }
    }

	return $ref_write_fields;
}

#
#
#

sub enable_member_redirect
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_member_redirect', validator => \&ibap_value_o2i_boolean, use => \$self->{'override_enable_member_redirect'}, use_truefalse => 1}, @_);
}

sub override_enable_member_redirect
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_enable_member_redirect', validator => \&ibap_value_o2i_boolean}, @_);
}

sub bgp_as
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'bgp_as', validator => { 'Infoblox::Grid::Member::BGP::AS' => 1 }}, @_);
}

sub replication_info
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'replication_info', validator => { 'Infoblox::Grid::Member::ReplicationInfo' => 1 }, readonly => 1}, @_);
}

sub node1_licenses
{
    my $self=shift;
    return $self->__accessor_array__({name => 'node1_licenses', readonly => 1}, @_);
}

sub node2_licenses
{
    my $self=shift;
    return $self->__accessor_array__({name => 'node2_licenses', readonly => 1}, @_);
}

sub is_master
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'is_master', readonly => 1}, @_);
}

sub ntp_server
{
    my $self=shift;

    my $pre=$self->{'use_ntp_servers'} ? $self->{'use_ntp_servers'} : 0;
    my $t = $self->__accessor_array__({name => 'ntp_server', validator => { 'Infoblox::Grid::NTPServer' => 1 }, use => \$self->{'use_ntp_servers'}}, @_);
    my $post=$self->{'use_ntp_servers'} ? $self->{'use_ntp_servers'} : 0;

    if ($post != $pre) {
        #
        #

        if ($self->{'use_ntp_servers'}) {
            #
            $self->external_ntp_servers_enabled('true');

            if (ref($self->{'ntp_server'}) eq 'ARRAY' && scalar(@{$self->{'ntp_server'}}) == 0) {
                #
                #

                $self->external_ntp_servers_enabled('false');
            }
        }
        else {
            #
            #
            #
            #
            $self->external_ntp_servers_enabled('false');
        }
    }
    else {
        #
        #
        #

        if ($self->{'use_ntp_servers'} && ref($self->{'ntp_server'}) eq 'ARRAY' && scalar(@{$self->{'ntp_server'}}) > 0) {
            $self->external_ntp_servers_enabled('true');
        }
    }

    return $t;
}

sub ntp_authentication_key
{
    my $self=shift;
    return $self->__accessor_array__({name => 'ntp_authentication_key', validator => { 'Infoblox::Grid::NTPKey' => 1 }, use => \$self->{'use_ntp_keys'}}, @_);
}

sub ntp_access_list
{
    my $self=shift;

    if (@_) {
        if (ref($_[0]) eq 'Infoblox::Grid::NamedACL') {
            return $self->__accessor_scalar__({name => 'ntp_access_list', validator => { 'Infoblox::Grid::NamedACL' => 1 }, use => 'use_ntp_acl'}, @_);
        } else {
            return $self->__accessor_array__({name => 'ntp_access_list', validator => { 'Infoblox::Grid::NTPAccess' => 1 }, use => 'use_ntp_acl'}, @_);
        }
    } else {
        return $self->{'ntp_access_list'};
    }
}

sub ntp_service_type
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ntp_service_type', enum => ['Time', 'Time and NTP control']}, @_);
}

sub enable_ntp
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_ntp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ntp_kod
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ntp_kod', validator => \&ibap_value_o2i_boolean, use_truefalse => 1, use => 'override_ntp_kod'}, @_);
}

sub override_ntp_kod
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ntp_kod', validator => \&ibap_value_o2i_boolean}, @_);
}

sub external_ntp_servers_enabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'external_ntp_servers_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub exclude_grid_master_as_ntp_server
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'exclude_grid_master_as_ntp_server', validator => \&ibap_value_o2i_boolean}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub dscp
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dscp', validator => \&ibap_value_o2i_uint, use_truefalse => 1, use => 'override_dscp' }, @_);
}

sub is_dscp_capable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'is_dscp_capable', readonly => 1, validator => \&ibap_value_o2i_boolean }, @_);
}

sub override_dscp
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_dscp', validator => \&ibap_value_o2i_boolean }, @_);
}

sub override_enable_lom
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_enable_lom', validator => \&ibap_value_o2i_boolean }, @_);
}

sub enable_lom
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_lom', validator => \&ibap_value_o2i_boolean, use_truefalse => 1, use => 'override_enable_lom' }, @_);
}

sub override_lom_users
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_lom_users', validator => \&ibap_value_o2i_boolean }, @_);
}

sub lom_is_capable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'node1_lom_is_capable', readonly => 1, validator => \&ibap_value_o2i_boolean }, @_);
}

sub node1_lom_is_capable
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node1 fields.

    return $self->__accessor_scalar__({name => 'node1_lom_is_capable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub node2_lom_is_capable
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_lom_is_capable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub lom_ipv4addr
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'node1_lom_ipv4addr', validator => \&ibap_value_o2i_ipv4addr }, @_);
}

sub node1_lom_ipv4addr
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node1 fields.

    return $self->__accessor_scalar__({name => 'node1_lom_ipv4addr', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub node2_lom_ipv4addr
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_lom_ipv4addr', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub lom_mask
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'node1_lom_mask', validator => \&ibap_value_o2i_ipv4addr }, @_);
}

sub node1_lom_mask
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node1 fields.

    return $self->__accessor_scalar__({name => 'node1_lom_mask', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub node2_lom_mask
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_lom_mask', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub lom_gateway
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'node1_lom_gateway', validator => \&ibap_value_o2i_ipv4addr }, @_);
}

sub node1_lom_gateway
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node1 fields.

    return $self->__accessor_scalar__({name => 'node1_lom_gateway', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub node2_lom_gateway
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_lom_gateway', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub lom_users
{
    my $self=shift;
    return $self->__accessor_array__({name => 'lom_users', validator => { 'Infoblox::Grid::LOM::User' => 1 }, use_truefalse => 1, use => 'override_lom_users'}, @_);
}

sub lan2_ipv6_cidr
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan2_ipv6_cidr', validator => \&ibap_value_o2i_uint}, @_);
}

#
#
#
#
#

sub lan2_ipv6_enable
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan2_ipv6_enable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub lan2_ipv6_enable_auto_config
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan2_ipv6_enable_auto_config', validator => \&ibap_value_o2i_boolean}, @_);
}

sub lan2_ipv6_gateway
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan2_ipv6_gateway', validator => \&ibap_value_o2i_ipv6addr}, @_);
}

sub lan2_ipv6addr
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan2_ipv6addr', validator => \&ibap_value_o2i_ipv6addr}, @_);
}

sub mgmt_ipv6_cidr
{
    my $self  = shift;
    #
    return $self->__accessor_scalar__({name => 'node1_mgmt_ipv6_cidr', validator => \&ibap_value_o2i_uint}, @_);
}

sub mgmt_ipv6_enable_auto_config
{
    my $self  = shift;
    #
    return $self->__accessor_scalar__({name => 'node1_mgmt_ipv6_enable_auto_config', validator => \&ibap_value_o2i_boolean}, @_);
}

sub mgmt_ipv6_gateway
{
    my $self  = shift;
    #
    return $self->__accessor_scalar__({name => 'node1_mgmt_ipv6_gateway', validator => \&ibap_value_o2i_ipv6addr}, @_);
}

sub mgmt_ipv6addr
{
    my $self  = shift;
    #
    return $self->__accessor_scalar__({name => 'node1_mgmt_ipv6addr', validator => \&ibap_value_o2i_ipv6addr}, @_);
}

sub mgmt_node2_port_speed
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'mgmt_node2_port_duplex'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'mgmt_node2_port_speed', enum => ['10','100','1000'] }, @_);
}

sub mgmt_node2_port_duplex
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'mgmt_node2_port_speed'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'mgmt_node2_port_duplex', enum => ['Half','Full'] }, @_);
}

sub ha_node2_port_speed
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'ha_node2_port_duplex'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'ha_node2_port_speed', enum => ['10','100','1000'] }, @_);
}

sub ha_node2_port_duplex
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'ha_node2_port_speed'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'ha_node2_port_duplex', enum => ['Half','Full'] }, @_);
}

sub lan2_node2_port_speed
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'lan2_node2_port_duplex'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'lan2_node2_port_speed', enum => ['10','100','1000'] }, @_);
}

sub lan2_node2_port_duplex
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'lan2_node2_port_speed'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'lan2_node2_port_duplex', enum => ['Half','Full'] }, @_);
}

sub lan_node2_port_speed
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'lan_node2_port_duplex'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'lan_node2_port_speed', enum => ['10','100','1000'] }, @_);
}

sub lan_node2_port_duplex
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'lan_node2_port_speed'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'lan_node2_port_duplex', enum => ['Half','Full'] }, @_);
}

sub mgmt_port_speed
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'mgmt_port_duplex'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'mgmt_port_speed', enum => ['10','100','1000'] }, @_);
}

sub mgmt_port_duplex
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'mgmt_port_speed'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'mgmt_port_duplex', enum => ['Half','Full'] }, @_);
}

sub ha_port_speed
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'ha_port_duplex'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'ha_port_speed', enum => ['10','100','1000'] }, @_);
}

sub ha_port_duplex
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'ha_port_speed'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'ha_port_duplex', enum => ['Half','Full'] }, @_);
}

sub lan_port_speed
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'lan_port_duplex'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'lan_port_speed', enum => ['10','100','1000'] }, @_);
}

sub lan_port_duplex
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'lan_port_speed'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'lan_port_duplex', enum => ['Half','Full'] }, @_);
}

sub lan2_port_speed
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'lan2_port_duplex'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'lan2_port_speed', enum => ['10','100','1000'] }, @_);
}

sub lan2_port_duplex
{
    my $self=shift;

    #
    if( @_ != 0 )
    {
        $self->{'lan2_port_speed'} = undef if not defined $_[0];
    }

    return $self->__accessor_scalar__({name => 'lan2_port_duplex', enum => ['Half','Full'] }, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub notification_email_addr
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'notification_email_addr', validator => \&ibap_value_o2i_string, use => \$self->{'use_email_setting'}}, @_);
}

sub snmp_admin
{
    my $self = shift;

    #
    #
    #
    #
    my $t = $self->__accessor_scalar__({name => 'snmp_admin', validator => { 'Infoblox::Grid::SNMP::Admin' => 1 }, use => \$self->{'use_snmp_admin'}}, @_);
    $self->__use_snmp_helper__(@_);
    return $t;
}

sub trap_receiver
{
    my $self=shift;
    my $t = $self->__accessor_array__({name => 'trap_receiver', validator => { 'string' => \&ibap_value_o2i_string, 'Infoblox::Grid::SNMP::TrapReceiver' => 1 }, use => \$self->{'use_trap_receiver'}}, @_);

    $self->__use_snmp_helper__(@_);
    return $t;
}

sub trap_comm_string
{
    my $self=shift;
    my $t = $self->__accessor_scalar__({name => 'trap_comm_string', validator => \&ibap_value_o2i_string, use => \$self->{'use_trap_string'}}, @_);
    $self->__use_snmp_helper__(@_);
    return $t;
}

sub query_comm_string
{
    my $self=shift;
    my $t = $self->__accessor_scalar__({name => 'query_comm_string', validator => \&ibap_value_o2i_string, use => \$self->{'use_query_string'}}, @_);
    $self->__use_snmp_helper__(@_);
    return $t;
}

sub enable_snmpv3_query
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_snmpv3_query', validator => \&ibap_value_o2i_boolean},@_);
}

sub enable_snmpv3_traps
{
    my $self=shift;
    my $t= $self->__accessor_scalar__({name => 'enable_snmpv3_traps', validator => \&ibap_value_o2i_boolean},@_);
    return $t;
}

sub engine_id
{
    my $self=shift;
    return $self->__accessor_array__({name => 'engine_id', readonly => 1}, @_);
}

sub snmpv3_query_users
{
    my $self=shift;
    my $t=$self->__accessor_array__({name => 'snmpv3_query_users', validator =>{'Infoblox::Grid::SNMP::QueriesUser' => 1}, use => \$self->{'enable_snmpv3_query'}, use_truefalse => 1 }, @_);
    $self->__use_snmp_helper__(@_);
    return $t;
}

sub __use_snmp_helper__
{
    my $self = shift;
    if( @_ != 0 )
    {
        #
        $self->{'use_snmp_setting'}= ($self->{'enable_snmpv3_query'} && $self->{'enable_snmpv3_query'} eq 'true')|| $self->{'use_snmp_admin'} || $self->{'use_trap_receiver'} || $self->{'use_trap_string'} || $self->{'use_query_string'};
    }
}

sub __use_syslog_helper__
{
    my $self=shift;

    if( @_ != 0 )
    {
        #
        #
        #
        $self->{'use_syslog_setting'}= $self->{'use_syslog_setting_allow'} || $self->{'use_syslog_setting_tcp'} || $self->{'use_syslog_setting_udp'} || $self->{'use_syslog_setting_proxy'} || $self->{'use_syslog_setting_size'} || $self->{'external_syslog_server_enabled'};
    }
}
sub syslog_server
{
    my $self=shift;
    my $t=$self->__accessor_array__({name => 'syslog_server', validator => { 'Infoblox::Grid::SyslogServer' => 1 }, use => \$self->{'external_syslog_server_enabled'}}, @_);
    $self->__use_syslog_helper__(@_);
    return $t;
}

sub syslog_size
{
    my $self=shift;
    my $t=$self->__accessor_scalar__({name => 'syslog_size', validator => \&ibap_value_o2i_uint, use => \$self->{'use_syslog_setting_size'}}, @_);
    $self->__use_syslog_helper__(@_);
    return $t;
}

sub lcd_input
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'lcd_input', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_lcd_input'}}, @_);
}

sub lcd_hwident
{
    my $self=shift;
    #
    return $self->__accessor_scalar__({name => 'node1_lcd_hwident', validator => \&ibap_value_o2i_boolean}, @_);
}

sub lcd_autodim
{
    my $self=shift;
    #
    return $self->__accessor_scalar__({name => 'node1_lcd_autodim', validator => \&ibap_value_o2i_uint}, @_);
}

sub lcd_version
{
    my $self=shift;
    #
    return $self->__accessor_scalar__({name => 'node1_lcd_version', readonly => 1, validator => \&ibap_value_o2i_uint}, @_);
}

sub lcd_brightness
{
    my $self=shift;
    #
    return $self->__accessor_scalar__({name => 'node1_lcd_brightness', validator => \&ibap_value_o2i_uint}, @_);
}

sub node1_lcd_hwident
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_lcd_hwident', validator => \&ibap_value_o2i_boolean}, @_);
}

sub node1_lcd_autodim
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_lcd_autodim', validator => \&ibap_value_o2i_uint}, @_);
}

sub node1_lcd_version
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_lcd_version', readonly => 1, validator => \&ibap_value_o2i_uint}, @_);
}

sub node1_lcd_brightness
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_lcd_brightness', validator => \&ibap_value_o2i_uint}, @_);
}

sub node2_lcd_hwident
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_lcd_hwident', validator => \&ibap_value_o2i_boolean}, @_);
}

sub node2_lcd_autodim
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_lcd_autodim', validator => \&ibap_value_o2i_uint}, @_);
}

sub node2_lcd_version
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_lcd_version', readonly => 1, validator => \&ibap_value_o2i_uint}, @_);
}

sub node2_lcd_brightness
{
    my $self=shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_lcd_brightness', validator => \&ibap_value_o2i_uint}, @_);
}

sub remote_console_access
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'remote_console_access', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_remote_console_access'}}, @_);
}

sub support_access
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'support_access', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_support_access'}}, @_);
}

sub support_access_info
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'support_access_info', readonly => 1}, @_);
}

sub alternate_resolver
{
    my $self = shift;
    my $t = $self->__accessor_scalar__({name => 'alternate_resolver', validator => { 'Infoblox::DNS::Nameserver' => 1, 'Infoblox::DNS::Member' => 1, 'string' => \&ibap_value_o2i_string }, use => \$self->{'use_alternate_resolver'}}, @_);

    if( @_ != 0 )
    {
        #
        $self->{'use_resolver_setting'}= $self->{'use_prefer_resolver'} || $self->{'use_alternate_resolver'};
    }

    return $t;
}

sub prefer_resolver
{
    my $self = shift;
    my $t = $self->__accessor_scalar__({name => 'prefer_resolver', validator => { 'Infoblox::DNS::Nameserver' => 1, 'Infoblox::DNS::Member' => 1, 'string' => \&ibap_value_o2i_string }, use => \$self->{'use_prefer_resolver'}}, @_);

    if( @_ != 0 )
    {
        #
        $self->{'use_resolver_setting'}= $self->{'use_prefer_resolver'} || $self->{'use_alternate_resolver'};
    }

    return $t;
}

sub search_domains
{
    my $self = shift;
    return $self->__accessor_array__({name => 'search_domains', validator => \&ibap_value_o2i_string}, @_);
}

sub static_routes
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'static_routes', validator => { 'Infoblox::Grid::Member::StaticRoute' => 1 }}, @_);
}

sub ipv6_static_routes
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'ipv6_static_routes', validator => { 'Infoblox::Grid::Member::IPv6StaticRoute' => 1 }}, @_);
}

sub use_v4_vrrp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'use_v4_vrrp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub config_addr_type
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'config_addr_type', enum => ['IPv4', 'IPv6', 'BOTH']}, @_);
}

sub service_type_configuration
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'service_type_configuration', enum => ['ALL_V4', 'ALL_V6', 'CUSTOM']}, @_);
}

sub member_service_communication
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'member_service_communication', validator => { 'Infoblox::Grid::Member::Communication' => 1 }}, @_);
}

sub nat_enabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'nat_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub nat_group
{
    my $self=shift;
    my $t = $self->__accessor_scalar__({name => 'nat_group', validator => \&ibap_value_o2i_string, use => \$self->{'use_nat_group_setting'}}, @_);

    if( @_ != 0 )
    {
        #
        #
        $self->{'nat_enabled'} = ibap_value_i2o_boolean($self->{'use_nat_ip_address_setting'} || $self->{'use_node1_nat_setting'} || $self->{'use_node2_nat_setting'} || $self->{'use_nat_group_setting'});
    }

    return $t;
}

sub nat_ip_address
{
    my $self  = shift;
    my $t = $self->__accessor_scalar__({name => 'nat_ip_address', validator => \&ibap_value_o2i_ipv4addr, use => \$self->{'use_nat_ip_address_setting'}}, @_);

    if( @_ != 0 )
    {
        #
        #
        $self->{'nat_enabled'} = ibap_value_i2o_boolean($self->{'use_nat_ip_address_setting'} || $self->{'use_node1_nat_setting'} || $self->{'use_node2_nat_setting'} || $self->{'use_nat_group_setting'});
    }

    return $t;
}

sub enable_authentication
{
    my $self  = shift;
    return $self->__accessor_scalar__({deprecated => 1}, @_);
}

sub time_zone
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'time_zone', validator => \&ibap_value_o2i_tz, use => \$self->{'use_time_zone'}}, @_);
}

sub allow_syslog_clients
{
    my $self  = shift;
    my $t = $self->ibap_accessor_ac_setting('allow_syslog_clients', 0, {use => 'use_syslog_setting_allow'}, @_);
    $self->__use_syslog_helper__(@_);
    return $t;
}

sub syslog_proxy_udp_port
{
    my $self  = shift;
    my $t = $self->__accessor_scalar__({name => 'syslog_proxy_udp_port', validator => \&ibap_value_o2i_uint, use => \$self->{'use_syslog_setting_udp'}}, @_);
    $self->__use_syslog_helper__(@_);
    return $t;
}

sub syslog_proxy_tcp_port
{
    my $self  = shift;
    my $t = $self->__accessor_scalar__({name => 'syslog_proxy_tcp_port', validator => \&ibap_value_o2i_uint, use => \$self->{'use_syslog_setting_tcp'}}, @_);
    $self->__use_syslog_helper__(@_);
    return $t;
}

sub enable_syslog_proxy
{
    my $self  = shift;
    my $t = $self->__accessor_scalar__({name => 'enable_syslog_proxy', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_syslog_setting_proxy'}}, @_);
    $self->__use_syslog_helper__(@_);
    return $t;
}

sub ospf_list
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'ospf_list', validator => { 'Infoblox::Grid::Member::OSPF' => 1 }}, @_);
}

sub __verify_additional_ip_list__ {
    my ($value, $name) = @_;

    if (ref($value) eq 'Infoblox::Grid::Member::Interface') {
        if ($value->interface() eq 'MGMT') {
            return set_error_codes(1104, "MGMT interface is not supported in $name");
        }
    } else {
        return set_error_codes(1104, "Invalid data type ".ref($value)." for $name");
    }

    return 1;
}

sub additional_ip_list
{
    my $self  = shift;

    my @templist;
    if (@_ != 0 && $self->{'additional_ip_list'}) {
        foreach my $t (@{$self->{'additional_ip_list'}}) {
            push @templist, $t;
        }
    }

    my $t = $self->__accessor_array__({name => 'additional_ip_list', validator => \&__verify_additional_ip_list__}, @_);
    if (@_ != 0 && $t) {
        $self->__fix_toplevel_additional_ip__(1);

        foreach my $t (@templist) {
            #
            #
            delete $t->{'__member_association__'};
        }

        #
        #
        #
        #
        #
        #
        #
        #
        #
        if ($self->{'additional_ip_list'}) {
            foreach my $t (@{$self->{'additional_ip_list'}}) {
                $t->{'__member_association__'} = $self;
            }
        }
    }

    return $t;
}

sub service_status
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'service_status', readonly => 1}, @_);
}

sub node1_service_status
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'node1_service_status', readonly => 1}, @_);
}

sub node2_service_status
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'node2_service_status', readonly => 1}, @_);
}

sub master_candidate
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'master_candidate', validator => \&ibap_value_o2i_boolean}, @_);
}

sub router_ID
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'router_ID', validator => \&ibap_value_o2i_uint}, @_);
}

sub node2_hwid
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_hwid', readonly => 1}, @_);
}

sub node1_physical_oid
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'node1_physical_oid', readonly => 1}, @_);
}

sub node1_hwid
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_hwid', readonly => 1}, @_);
}

sub node2_hwtype
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_hwtype', readonly => 1}, @_);
}

sub node2_nat
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    my $t = $self->__accessor_scalar__({name => 'node2_nat', validator => \&ibap_value_o2i_ipv4addr, use => \$self->{'use_node2_nat_setting'}}, @_);

    if( @_ != 0 )
    {
        #
        #
        $self->{'nat_enabled'} = ibap_value_i2o_boolean($self->{'use_nat_ip_address_setting'} || $self->{'use_node1_nat_setting'} || $self->{'use_node2_nat_setting'} || $self->{'use_nat_group_setting'});
    }

    return $t;
}

sub node2_mgmt_gateway
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_mgmt_gateway', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub node2_mgmt_mask
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_mgmt_mask', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub node2_mgmt_lan
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_mgmt_lan', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub node2_vpn_on_mgmt
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    #
    return $self->__accessor_scalar__({name => 'node1_vpn_on_mgmt', validator => \&ibap_value_o2i_boolean}, @_);
}

sub node2_mgmt_port
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    #
    return $self->__accessor_scalar__({name => 'node1_mgmt_port', validator => \&ibap_value_o2i_boolean}, @_);
}

sub node2_ha
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_ha', validator => \&ibap_value_o2i_string}, @_);
}

sub node2_lan
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_lan', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub node2_lan_ipv6addr
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_lan_ipv6addr', validator => \&ibap_value_o2i_ipv6addr}, @_);
}

sub node2_mgmt_ipv6_cidr
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_mgmt_ipv6_cidr', validator => \&ibap_value_o2i_uint}, @_);
}

sub node2_mgmt_ipv6_enable_auto_config
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_mgmt_ipv6_enable_auto_config', validator => \&ibap_value_o2i_boolean}, @_);
}

sub node2_mgmt_ipv6_gateway
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_mgmt_ipv6_gateway', validator => \&ibap_value_o2i_ipv6addr}, @_);
}

sub node2_mgmt_ipv6addr
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_mgmt_ipv6addr', validator => \&ibap_value_o2i_ipv6addr}, @_);
}

sub node2_physical_oid
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'node2_physical_oid', readonly => 1}, @_);
}

sub node1_hwtype
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'node1_hwtype', readonly => 1}, @_);
}

sub node1_nat
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    my $t = $self->__accessor_scalar__({name => 'node1_nat', validator => \&ibap_value_o2i_ipv4addr, use => \$self->{'use_node1_nat_setting'}}, @_);

    if( @_ != 0 )
    {
        #
        #
        $self->{'nat_enabled'} = ibap_value_i2o_boolean($self->{'use_nat_ip_address_setting'} || $self->{'use_node1_nat_setting'} || $self->{'use_node2_nat_setting'} || $self->{'use_nat_group_setting'});
    }

    return $t;
}

sub node1_mgmt_gateway
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_mgmt_gateway', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub node1_mgmt_mask
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_mgmt_mask', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub node1_mgmt_lan
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_mgmt_lan', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub node1_vpn_on_mgmt
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_vpn_on_mgmt', validator => \&ibap_value_o2i_boolean}, @_);
}

sub node1_mgmt_port
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_mgmt_port', validator => \&ibap_value_o2i_boolean}, @_);
}

sub node1_ha
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_ha', validator => \&ibap_value_o2i_string}, @_);
}

sub node1_lan
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_lan', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub node1_lan_ipv6addr
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node1 fields.

    return $self->__accessor_scalar__({name => 'node1_lan_ipv6addr', validator => \&ibap_value_o2i_ipv6addr}, @_);
}

sub node1_mgmt_ipv6_cidr
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node1 fields.

    return $self->__accessor_scalar__({name => 'node1_mgmt_ipv6_cidr', validator => \&ibap_value_o2i_uint}, @_);
}

sub node1_mgmt_ipv6_enable_auto_config
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node1 fields.

    return $self->__accessor_scalar__({name => 'node1_mgmt_ipv6_enable_auto_config', validator => \&ibap_value_o2i_boolean}, @_);
}

sub node1_mgmt_ipv6_gateway
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node1 fields.

    return $self->__accessor_scalar__({name => 'node1_mgmt_ipv6_gateway', validator => \&ibap_value_o2i_ipv6addr}, @_);
}

sub node1_mgmt_ipv6addr
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # Previous behaviour, return undef if not an ha pair for all node1/node1 fields.

    return $self->__accessor_scalar__({name => 'node1_mgmt_ipv6addr', validator => \&ibap_value_o2i_ipv6addr}, @_);
}

sub hwplatform
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'node1_hwplatform', readonly => 1 }, @_);
}

sub node1_hwplatform
{
    my $self  = shift;

    return $self->__accessor_scalar__({name => 'node1_hwplatform', readonly => 1}, @_);
}

sub node2_hwplatform
{
    my $self  = shift;

    return $self->__accessor_scalar__({name => 'node2_hwplatform', readonly => 1}, @_);
}

sub hwid
{
    my $self  = shift;
#
    return $self->__accessor_scalar__({name => 'node1_hwid', readonly => 1}, @_);
}

sub paid_nios
{
    my $self  = shift;

    return $self->__accessor_scalar__({name => 'node1_paid_nios', readonly => 1, validator => \&ibap_value_o2i_boolean}, @_);
}

sub node1_paid_nios
{
    my $self  = shift;

    return $self->__accessor_scalar__({name => 'node1_paid_nios', readonly => 1, validator => \&ibap_value_o2i_boolean}, @_);
}

sub node2_paid_nios
{
    my $self  = shift;

    return $self->__accessor_scalar__({name => 'node2_paid_nios', readonly => 1, validator => \&ibap_value_o2i_boolean}, @_);
}

sub nic_failover_enabled
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'nic_failover_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub nic_failover_enable_primary
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'nic_failover_enable_primary', validator => \&ibap_value_o2i_boolean}, @_);
}

sub lan2_router_id
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan2_router_id', validator => \&ibap_value_o2i_uint}, @_);
}

sub lan2_gateway
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan2_gateway', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub lan2_mask
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan2_mask', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub lan2_ipv4addr
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan2_ipv4addr', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub lan2_port
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan2_port', validator => \&ibap_value_o2i_boolean}, @_);
}

sub virtual_oid
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'virtual_oid', readonly => 1}, @_);
}

sub mgmt_gateway
{
    my $self  = shift;
#
    return $self->__accessor_scalar__({name => 'node1_mgmt_gateway', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub mgmt_mask
{
    my $self  = shift;
#
    return $self->__accessor_scalar__({name => 'node1_mgmt_mask', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub mgmt_lan
{
    my $self  = shift;
#
    return $self->__accessor_scalar__({name => 'node1_mgmt_lan', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub vpn_mtu
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'vpn_mtu', validator => \&ibap_value_o2i_uint}, @_);
}

sub vpn_on_mgmt
{
    my $self  = shift;
#
    return $self->__accessor_scalar__({name => 'node1_vpn_on_mgmt', validator => \&ibap_value_o2i_boolean}, @_);
}

sub mgmt_port
{
    my $self  = shift;
#
    return $self->__accessor_scalar__({name => 'node1_mgmt_port', validator => \&ibap_value_o2i_boolean}, @_);
}

sub gateway
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'gateway', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub mask
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'mask', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub ipv4addr
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv4addr', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub ipv6addr
{
    my $self  = shift;
    my $oldvalue;

    my $t = $self->__accessor_scalar__({name => 'ipv6addr', validator => \&ibap_value_o2i_ipv6addr}, @_);
    if (@_ != 0 && $t) {
        $self->__fix_toplevel_additional_ip__(0);
    }
    return $t;
}

sub ipv6_cidr
{
    my $self  = shift;
    my $t = $self->__accessor_scalar__({name => 'ipv6_cidr', validator => \&ibap_value_o2i_uint}, @_);
    if (@_ != 0 && $t) {
        $self->__fix_toplevel_additional_ip__(0);
    }
    return $t;
}

sub ipv6_gateway
{
    my $self  = shift;
    my $t = $self->__accessor_scalar__({name => 'ipv6_gateway', validator => \&ibap_value_o2i_ipv6addr}, @_);
    if (@_ != 0 && $t) {
        $self->__fix_toplevel_additional_ip__(0);
    }
    return $t;
}

sub ipv6_enable_auto_config
{
    my $self  = shift;
    my $t = $self->__accessor_scalar__({name => 'ipv6_enable_auto_config', validator => \&ibap_value_o2i_boolean}, @_);
    if (@_ != 0 && $t) {
        $self->__fix_toplevel_additional_ip__(0);
    }
    return $t;
}


sub active_position
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'active_position', readonly => 1}, @_);
}

sub platform
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'platform', enum => ['Infoblox','Riverbed','Cisco','VNIOS'] }, @_);
}

sub enable_ha
{
    my $self  = shift;

    if( @_ != 0 )
    {
        return unless $self->__accessor_scalar__({name => 'enable_ha', validator => \&ibap_value_o2i_boolean}, @_);
        if ($_[0] =~ /true/i) {
            $self->{'type'} = 'HApair';
        }
        else {
            $self->{'type'} = 'IDnode';
        }
        return 1;
    }
    else {
    return $self->__accessor_scalar__({name => 'enable_ha', validator => \&ibap_value_o2i_boolean}, @_);
    }
}

#
sub type
{
    my $self  = shift;

    if( @_ != 0 )
    {
        return unless $self->__accessor_scalar__({name => 'type', enum => ['IDnode','HApair'] }, @_);
        if ($_[0] =~ /hapair/i) {
            $self->{'enable_ha'} = 'true';
        }
        else {
            $self->{'enable_ha'} = 'false';
        }
        return 1;
    }
    else {
    return $self->__accessor_scalar__({name => 'type', enum => ['IDnode','HApair'] }, @_);
    }
}

sub name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub upgrade_group
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'upgrade_group', validator => \&ibap_value_o2i_string}, @_);
}

sub grid
{
    my $self  = shift;

    #
    if( @_ == 0 )
    {
        return '0';
    }
    else
    {
    	return 1;
	}
}

sub cluster
{
    my $self  = shift;

    #
    if( @_ == 0 )
    {
        return '0';
    }
    else
    {
    	return 1;
	}
}

sub threshold_traps
{
    my $self=shift;
    return $self->__accessor_array__({name => 'threshold_traps', validator=> {'Infoblox::Grid::SNMP::ThresholdTrap' => 1},use => \$self->{'override_threshold_traps'}, use_truefalse => 1},@_);
}

sub override_threshold_traps
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_threshold_traps', validator => \&ibap_value_o2i_boolean},@_);
}

sub trap_notifications
{
    my $self=shift;
    return $self->__accessor_array__({name => 'trap_notifications', validator=> {'Infoblox::Grid::SNMP::TrapNotification' => 1},use => \$self->{'override_trap_notifications'}, use_truefalse => 1},@_);
}

sub override_trap_notifications
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_trap_notifications', validator => \&ibap_value_o2i_boolean},@_);
}

sub traffic_capture
{
    my $self  = shift;

	unless ($self->{ '__internal_session_cache_ref__' } && $self->__object_id__()) {
        set_error_codes(1001,'In order to control traffic capture the member object must have been retrieved from the server first');
		return;
	}

	my $session = ${$self->{ '__internal_session_cache_ref__' }};
	return $session->__traffic_capture__($self->__object_id__(),@_);
}

sub lan1_dscp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan1_dscp', validator => \&ibap_value_o2i_uint, use => 'override_lan1_dscp', use_truefalse => 1}, @_);
}

sub override_lan1_dscp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_lan1_dscp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub vlan_id
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'vlan_id', validator => \&ibap_value_o2i_uint}, @_);
}

sub lan1_ipv6_dscp
{
    my $self  = shift;
    my $t = $self->__accessor_scalar__({name => 'lan1_ipv6_dscp', validator => \&ibap_value_o2i_uint, use => 'override_lan1_ipv6_dscp', use_truefalse => 1}, @_);
    if (@_ && $t) {
        $self->__fix_toplevel_additional_ip__(0);
    }
    return $t;
}

sub override_lan1_ipv6_dscp
{
    my $self  = shift;
    my $t = $self->__accessor_scalar__({name => 'override_lan1_ipv6_dscp', validator => \&ibap_value_o2i_boolean}, @_);
    if (@_ && $t) {
        $self->__fix_toplevel_additional_ip__(0);
    }
    return $t;
}

sub ipv6_vlan_id
{
    my $self  = shift;
    my $t = $self->__accessor_scalar__({name => 'ipv6_vlan_id', validator => \&ibap_value_o2i_uint}, @_);
    if (@_ && $t) {
        $self->__fix_toplevel_additional_ip__(0);
    }
    return $t;
}

sub lan2_dscp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan2_dscp', validator => \&ibap_value_o2i_uint, use => 'override_lan2_dscp', use_truefalse => 1}, @_);
}

sub override_lan2_dscp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_lan2_dscp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub lan2_vlan_id
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan2_vlan_id', validator => \&ibap_value_o2i_uint}, @_);
}

sub lan2_ipv6_dscp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan2_ipv6_dscp', validator => \&ibap_value_o2i_uint, use => 'override_lan2_ipv6_dscp', use_truefalse => 1}, @_);
}

sub override_lan2_ipv6_dscp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_lan2_ipv6_dscp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub lan2_ipv6_vlan_id
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lan2_ipv6_vlan_id', validator => \&ibap_value_o2i_uint}, @_);
}

sub mgmt_ipv6_dscp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'node1_mgmt_ipv6_dscp', validator => \&ibap_value_o2i_uint, use => 'override_node1_mgmt_ipv6_dscp', use_truefalse => 1}, @_);
}

sub override_mgmt_ipv6_dscp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_node1_mgmt_ipv6_dscp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub mgmt_dscp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'node1_mgmt_dscp', validator => \&ibap_value_o2i_uint, use => 'override_node1_mgmt_dscp', use_truefalse => 1}, @_);
}

sub override_mgmt_dscp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_node1_mgmt_dscp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub node1_mgmt_ipv6_dscp
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2
    return $self->__accessor_scalar__({name => 'node1_mgmt_ipv6_dscp', validator => \&ibap_value_o2i_uint, use => 'override_node1_mgmt_ipv6_dscp', use_truefalse => 1}, @_);
}

sub override_node1_mgmt_ipv6_dscp
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2
    return $self->__accessor_scalar__({name => 'override_node1_mgmt_ipv6_dscp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub node1_mgmt_dscp
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2
    return $self->__accessor_scalar__({name => 'node1_mgmt_dscp', validator => \&ibap_value_o2i_uint, use => 'override_node1_mgmt_dscp', use_truefalse => 1}, @_);
}

sub override_node1_mgmt_dscp
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2
    return $self->__accessor_scalar__({name => 'override_node1_mgmt_dscp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub node2_mgmt_ipv6_dscp
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2
    return $self->__accessor_scalar__({name => 'node2_mgmt_ipv6_dscp', validator => \&ibap_value_o2i_uint, use => 'override_node2_mgmt_ipv6_dscp', use_truefalse => 1}, @_);
}

sub override_node2_mgmt_ipv6_dscp
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2
    return $self->__accessor_scalar__({name => 'override_node2_mgmt_ipv6_dscp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub node2_mgmt_dscp
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2
    return $self->__accessor_scalar__({name => 'node2_mgmt_dscp', validator => \&ibap_value_o2i_uint, use => 'override_node2_mgmt_dscp', use_truefalse => 1}, @_);
}

sub override_node2_mgmt_dscp
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2
    return $self->__accessor_scalar__({name => 'override_node2_mgmt_dscp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub pre_provisioning
{
    my $self  = shift;
    return $self->__accessor_scalar__({'name' => 'pre_provisioning', 'validator' => {'Infoblox::Grid::Member::PreProvisioning' => 1}}, @_);
}

sub passive_ha_arp_enabled
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'passive_ha_arp_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub lan_reserved_interface
{
    my $self  = shift;

    return $self->__accessor_scalar__({name => 'node1_lan_reserved_interface', validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}}, @_);
}

sub ha_reserved_interface
{
    my $self  = shift;

    return $self->__accessor_scalar__({name => 'node1_ha_reserved_interface', validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}}, @_);
}

sub mgmt_reserved_interface
{
    my $self  = shift;

    return $self->__accessor_scalar__({name => 'node1_mgmt_reserved_interface', validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}}, @_);
}

sub lan2_reserved_interface
{
    my $self  = shift;

    return $self->__accessor_scalar__({name => 'node1_lan2_reserved_interface', validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}}, @_);
}

sub node1_lan_reserved_interface
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_lan_reserved_interface', validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}}, @_);
}

sub node1_ha_reserved_interface
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_ha_reserved_interface', validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}}, @_);
}

sub node1_mgmt_reserved_interface
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_mgmt_reserved_interface', validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}}, @_);
}

sub node1_lan2_reserved_interface
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node1_lan2_reserved_interface', validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}}, @_);
}

sub node2_lan_reserved_interface
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_lan_reserved_interface', validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}}, @_);
}

sub node2_ha_reserved_interface
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_ha_reserved_interface', validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}}, @_);
}

sub node2_mgmt_reserved_interface
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_mgmt_reserved_interface', validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}}, @_);
}

sub node2_lan2_reserved_interface
{
    my $self  = shift;
    return undef if( @_ == 0 && defined $self->{'enable_ha'} && $self->{'enable_ha'} eq 'false'); # In line with previous behaviour, return undef if not an ha pair for all node1/node2 fields.

    return $self->__accessor_scalar__({name => 'node2_lan2_reserved_interface', validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}}, @_);
}


sub enable_ro_api_access
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'enable_ro_api_access', validator => \&ibap_value_o2i_boolean}, @_);
}

sub preserve_if_owns_delegation
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'preserve_if_owns_delegation', validator => \&ibap_value_o2i_boolean}, @_);
}


sub create_token
{
    my $self  = shift;

    unless ($self->{'__internal_session_cache_ref__'}) {
        set_error_codes(1001,'In order to create the token the object must have been retrieved from the server first');
        return;
    }

    my $session = ${$self->{'__internal_session_cache_ref__'}};
    return $session->__create_token__($self->__object_id__(), @_);
}

sub read_token
{
    my $self  = shift;

    unless ($self->{'__internal_session_cache_ref__'}) {
        set_error_codes(1001,'In order to read the token the object must have been retrieved from the server first');
        return;
    }

    my $session = ${$self->{'__internal_session_cache_ref__'}};
    return $session->__read_token__($self->__object_id__(), @_);
}


package Infoblox::Grid::Member::Interface;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    register_wsdl_type('ib:MemberAdditionalIp','Infoblox::Grid::Member::Interface');
    %_allowed_members = (
                         comment                 => 0,
                         gateway                 => 0,
                         enable_ipv6_auto_config => 0,
                         enable_bgp              => 0,
                         enable_ospf             => 0,
                         subnet_mask             => 0,
                         cidr                    => 0,
                         interface               => 0,
                         anycast                 => 0,
                         ipv6addr                => 0,
                         ipv4addr                => 0,
                         vlan_id                 => 0,
                         dscp                    => 0,
                         override_dscp           => 0,
                        );

    %_name_mappings =
      (
       anycast     => 'anycast_enabled',
       enable_bgp  => 'bgp_enabled',
       enable_ospf => 'ospf_enabled',
       interface   => 'interface_type',
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    $_reverse_name_mappings{'ipv4_network_setting'} = '__skip_handler__';
    $_reverse_name_mappings{'ipv6_network_setting'} = '__skip_handler__';

    %_ibap_to_object =
      (
       ipv4_network_setting => \&__i2o_ipv4__,
       ipv6_network_setting => \&__i2o_ipv6__,
       anycast_enabled      => \&ibap_i2o_boolean,
       bgp_enabled          => \&ibap_i2o_boolean,
       ospf_enabled         => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       comment                 => \&ibap_o2i_string,
       gateway                 => \&ibap_o2i_ignore,
       enable_ipv6_auto_config => \&ibap_o2i_ignore,
       subnet_mask             => \&ibap_o2i_ignore,
       cidr                    => \&ibap_o2i_ignore,
       interface               => \&ibap_o2i_string,
       anycast                 => \&ibap_o2i_boolean,
       enable_bgp              => \&ibap_o2i_boolean,
       enable_ospf             => \&ibap_o2i_boolean,
       ipv6addr                => \&ibap_o2i_ignore,
       ipv4addr                => \&ibap_o2i_ignore,
       vlan_id                 => \&ibap_o2i_ignore,
       dscp                    => \&ibap_o2i_ignore,
       override_dscp           => \&ibap_o2i_ignore,

       #
       __member_association__ => \&ibap_o2i_ignore,
      );

    @_return_fields =
      (
       tField('comment'),
       tField('anycast_enabled'),
       tField('bgp_enabled'),
       tField('ospf_enabled'),
       tField('interface_type'),
       tField('ipv4_network_setting',
              {
               sub_fields => [
                              tField('address'),
                              tField('subnet_mask'),
                              tField('gateway'),
                              tField('dscp'),
                              tField('use_dscp'),
                              tField('vlan_id'),
                             ]}),
       tField('ipv6_network_setting',
              {
               sub_fields => [
                              tField('enabled'),
                              tField('cidr_prefix'),
                              tField('virtual_ip'),
                              tField('gateway'),
                              tField('auto_router_config_enabled'),
                              tField('dscp'),
                              tField('use_dscp'),
                              tField('vlan_id'),
                             ]}),
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

    #
    $self->enable_ipv6_auto_config('false') unless defined $self->enable_ipv6_auto_config();
    $self->interface('LOOPBACK')            unless defined $self->interface();
    $self->anycast('false')                 unless defined $self->anycast();
    $self->enable_bgp('false')              unless defined $self->enable_bgp();
    $self->enable_ospf('false')             unless defined $self->enable_ospf();

}

#
#
#

sub __i2o_ipv4__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    $self->gateway($$ibap_object_ref{$current}{'gateway'});
    $self->ipv4addr($$ibap_object_ref{$current}{'address'});
    $self->subnet_mask($$ibap_object_ref{$current}{'subnet_mask'});
    $self->vlan_id($$ibap_object_ref{$current}{'vlan_id'}) if defined $$ibap_object_ref{$current}{'vlan_id'};
    $self->dscp($$ibap_object_ref{$current}{'dscp'}) if defined $$ibap_object_ref{$current}{'dscp'};
    $self->override_dscp(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'use_dscp'}));
}

sub __i2o_ipv6__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if (defined $$ibap_object_ref{$current}{'enabled'} && $$ibap_object_ref{$current}{'enabled'}) {
        $self->gateway($$ibap_object_ref{$current}{'gateway'});
        $self->ipv6addr($$ibap_object_ref{$current}{'virtual_ip'});
        $self->cidr($$ibap_object_ref{$current}{'cidr_prefix'});
        $self->enable_ipv6_auto_config(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'auto_router_config_enabled'}));
        $self->vlan_id($$ibap_object_ref{$current}{'vlan_id'}) if defined $$ibap_object_ref{$current}{'vlan_id'};
        $self->dscp($$ibap_object_ref{$current}{'dscp'}) if defined $$ibap_object_ref{$current}{'dscp'};
        $self->override_dscp(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'use_dscp'}));
    }
}

#
#
sub __skip_handler__{};

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'anycast_enabled'} = 0 unless defined $$ibap_object_ref{'anycast_enabled'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    return;
}

#
#
#
sub __o2i_ipv4__
{
    my ($self, $session, $current, $tempref) = @_;

    if ($self->ipv4addr()) {
        my %write_fields = ();
        $write_fields{'dscp'} = ibap_value_o2i_uint($self->dscp()) if defined $self->dscp();
        $write_fields{'use_dscp'} = ibap_value_o2i_boolean($self->override_dscp()) if defined $self->override_dscp();
        $write_fields{'vlan_id'} = ibap_value_o2i_uint($self->vlan_id()) if defined $self->vlan_id();

        return (1,0, tIBType('network_setting',
                             {
                              'gateway'     => ibap_value_o2i_string_undef_to_empty($self->gateway()),
                              'address'     => ibap_value_o2i_string_undef_to_empty($self->ipv4addr()),
                              'subnet_mask' => ibap_value_o2i_string_undef_to_empty($self->subnet_mask()),
                              %write_fields,
                             })
               );
    }
    else {
        return (1,1,undef);
    }
}

sub __o2i_ipv6__
{
    my ($self, $session, $current, $tempref) = @_;

    if ($self->ipv6addr()) {

        if ($self->interface() && $self->interface() ne 'LAN_HA' && $self->interface() ne 'LAN2' && $self->interface() ne 'LOOPBACK') {
            set_error_codes(1012, 'We only support LAN_HA or LAN2 or LOOPBACK interfaces for ipv6 addresses', $session);
            return (0);
        }

        my %t = (
                 'virtual_ip' => ibap_value_o2i_string_undef_to_empty($self->ipv6addr()),
                 'enabled'    => ibap_value_o2i_boolean(1)
                );

        if (defined $self->cidr()) {
            $t{'cidr_prefix'} = ibap_value_o2i_uint($self->cidr());
        }
        else {
            set_error_codes(1002,'Invalid argument, cidr is required when ipv6addr is set',$session);
            return (0);
        }

        #
        if ($self->interface() eq 'LAN_HA') {
          if (defined $self->enable_ipv6_auto_config()) {
              $t{'auto_router_config_enabled'} = ibap_value_o2i_boolean($self->enable_ipv6_auto_config());
          }
          else {
              $t{'auto_router_config_enabled'} = ibap_value_o2i_boolean(0);
          }
        }

        $t{'gateway'} = ibap_value_o2i_string($self->gateway()) if defined $self->gateway();

        $t{'dscp'} = ibap_value_o2i_uint($self->dscp()) if defined $self->dscp();
        $t{'use_dscp'} = ibap_value_o2i_boolean($self->override_dscp()) if defined $self->override_dscp();
        $t{'vlan_id'} = ibap_value_o2i_uint($self->vlan_id()) if defined $self->vlan_id();

        return (1,0, tIBType('ipv6_setting',\%t));
    }
    else {
        if ($self->ipv4addr()) {
            return (1,1,undef);
        }
        else {
            return (1,0, tIBType('ipv6_setting',
                                 {
                                  'enabled'                    => ibap_value_o2i_boolean(0),
                                 })
                   );
        }
    }
}

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;

    my $ref_write_fields=$self->SUPER::__object_to_ibap__($server, $session);

    #
    foreach (
             (
              ['ipv4_network_setting' , \&__o2i_ipv4__],
              ['ipv6_network_setting' , \&__o2i_ipv6__],
             )
            ) {
        my ($name, $func) = @{$_};

        my @t = &$func($self, $session, '', $self);
        if (@t) {
            my $success=shift @t;
            if ($success) {
                my $ignore_value=shift @t;
                unless ($ignore_value) {
                    my %write_arg;
                    $write_arg{'field'} = $name;
                    $write_arg{'value'} = shift @t;
                    unshift @$ref_write_fields, \%write_arg;
                }
            } else {
                return;
            }
        }
    }

    return $ref_write_fields;
}

#
#
#

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub gateway
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'gateway', validator => \&ibap_value_o2i_ipaddr}, @_);
    if (@_ != 0 && $res && $self->{'__member_association__'}) {
        #
        $self->{'__member_association__'}->__fix_toplevel_additional_ip__(1);
    }
    return $res;
}

sub enable_ipv6_auto_config
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'enable_ipv6_auto_config', validator => \&ibap_value_o2i_boolean}, @_);
    if (@_ != 0 && $res && $self->{'__member_association__'}) {
        $self->{'__member_association__'}->__fix_toplevel_additional_ip__(1);
    }
    return $res;
}

sub subnet_mask
{
    my $self=shift;

#
#
#
#
#
#
#
#
#
#
#

    return $self->__accessor_scalar__({name => 'subnet_mask', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub cidr
{
    my $self=shift;
    #
    my $res = $self->__accessor_scalar__({name => 'cidr', validator => \&ibap_value_o2i_uint}, @_);
    if (@_ != 0 && $res && $self->{'__member_association__'}) {
        $self->{'__member_association__'}->__fix_toplevel_additional_ip__(1);
    }
    return $res;
}


sub interface
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'interface', enum => ['LAN_HA', 'LOOPBACK', 'MGMT', 'LAN2'] }, @_);
}

sub anycast
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'anycast', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_bgp
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_bgp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_ospf
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_ospf', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6addr
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'ipv6addr', validator => \&ibap_value_o2i_ipv6addr}, @_);
    if (@_ != 0 && $res && $self->{'__member_association__'}) {
        $self->{'__member_association__'}->__fix_toplevel_additional_ip__(1);
    }
    return $res;
}

sub ipv4addr
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv4addr', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub dscp
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'dscp', validator => \&ibap_value_o2i_uint, use => 'override_dscp', use_truefalse => 1}, @_);
    if (@_ != 0 && $res && $self->{'__member_association__'}) {
        $self->{'__member_association__'}->__fix_toplevel_additional_ip__(1);
    }
    return $res;
}

sub override_dscp
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'override_dscp', validator => \&ibap_value_o2i_boolean}, @_);
    if (@_ != 0 && $res && $self->{'__member_association__'}) {
        $self->{'__member_association__'}->__fix_toplevel_additional_ip__(1);
    }
    return $res;
}

sub vlan_id
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'vlan_id', validator => \&ibap_value_o2i_uint}, @_);
    if (@_ != 0 && $res && $self->{'__member_association__'}) {
        $self->{'__member_association__'}->__fix_toplevel_additional_ip__(1);
    }
    return $res;
}


package Infoblox::Grid::Member::OSPF;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            @ISA
            %_allowed_members
            %_ibap_to_object
            %_name_mappings
            %_reverse_name_mappings
            %_object_to_ibap
            @_return_fields
            $_object_type
);

@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'anycast_ospf_config';
    register_wsdl_type('ib:anycast_ospf_config', 'Infoblox::Grid::Member::OSPF');

    %_allowed_members = (
                         'area_id'             => 1,
                         'authentication_type' => {mandatory => 1, enum => ['none', 'simple', 'message-digest','NONE', 'SIMPLE', 'MESSAGE-DIGEST']},
                         'interface'           => {mandatory => 1, enum => ['LAN_HA'], validator => \&ibap_value_o2i_ipaddr},
                         'area_type'           => {simple => 'asis', enum => ['standard', 'stub', 'nssa','STANDARD', 'STUB', 'NSSA']},
                         'authentication_key'  => {writeonly => 1, validator => \&ibap_value_o2i_string},
                         'comment'             => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'cost'                => 0,
                         'dead_interval'       => {simple => 'asis', validator => \&ibap_value_o2i_int},
                         'hello_interval'      => {simple => 'asis', validator => \&ibap_value_o2i_int},
                         'is_ipv4'             => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'key_id'              => {simple => 'asis', validator => \&ibap_value_o2i_int},
                         'retransmit_interval' => {simple => 'asis', validator => \&ibap_value_o2i_int},
                         'transmit_delay'      => {simple => 'asis', validator => \&ibap_value_o2i_int},
                         'bfd_template'        => {validator => \&ibap_value_o2i_string},
                         'enable_bfd'          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'interface'  => 'advertise_interface_vlan',
                       'key_id'     => 'authentication_key_id',
                       'enable_bfd' => 'bfd_fallover',
    );

    %_object_to_ibap = (
                        'area_id'                => \&ibap_o2i_string,
                        'area_type'              => \&ibap_o2i_enums_lc_or_undef,
                        'auto_calc_cost_enabled' => \&ibap_o2i_integer,
                        'authentication_key'     => \&ibap_o2i_string_skip_undef,
                        'authentication_type'    => \&__o2i_authtype__,
                        'comment'                => \&ibap_o2i_string,
                        'cost'                   => \&__o2i_cost__,
                        'dead_interval'          => \&ibap_o2i_integer,
                        'hello_interval'         => \&ibap_o2i_integer,
                        'interface'              => \&__o2i_advertise_interface_vlan__,
                        'key_id'                 => \&ibap_o2i_integer,
                        'retransmit_interval'    => \&ibap_o2i_integer,
                        'transmit_delay'         => \&ibap_o2i_integer,
                        'is_ipv4'                => \&ibap_o2i_boolean,
                        'enable_bfd'             => \&ibap_o2i_boolean,
                        'bfd_template'           => \&__o2i_bfd_template__,
    );

    %_reverse_name_mappings = reverse %_name_mappings;
    $_reverse_name_mappings{'advertise_interface'} = 'interface';

    %_ibap_to_object = (
                        'authentication_type'      => \&__i2o_authtype__,
                        'area_type'                => \&ibap_i2o_enums_lc_or_undef,
                        'bfd_template'             => \&ibap_i2o_object_name,
                        'advertise_interface_vlan' => \&__i2o_advertise_interface_vlan__,
      );

    @_return_fields = (
                       tField('advertise_interface'),
                       tField('area_id'),
                       tField('area_type'),
                       tField('auto_calc_cost_enabled'),
                       tField('authentication_key_id'),
                       tField('authentication_type'),
                       tField('bfd_template', {sub_fields => [tField('name')]}),
                       tField('bfd_fallover'),
                       tField('comment'),
                       tField('cost'),
                       tField('dead_interval'),
                       tField('hello_interval'),
                       tField('retransmit_interval'),
                       tField('transmit_delay'),
                       tField('is_ipv4'),
                       tField('advertise_interface_vlan', {
                           sub_fields => [
                               tField('ipv4_network_setting', {
                                   sub_fields => [tField('address')]
                               }),
                               tField('ipv6_network_setting', {
                                   sub_fields => [tField('virtual_ip')]
                               }),
                           ]
                       }),
    );
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

    #
    $self->transmit_delay(1)      unless $self->transmit_delay();
    $self->retransmit_interval(5) unless $self->retransmit_interval();
    $self->dead_interval(40)      unless $self->dead_interval();
    $self->hello_interval(10)     unless $self->hello_interval();
    $self->cost('AUTO')           unless $self->cost();
    $self->area_type('standard')  unless $self->area_type();

    #
    #
    unless ($self->is_ipv4()) {
        if ($self->interface() and is_ipv6_address($self->interface())) {
            $self->is_ipv4('false');
        } else {
            $self->is_ipv4('true');
        }
    }
}

#
#
#

sub __i2o_authtype__ {
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($$ibap_object_ref{$current} eq 'MESSAGE_DIGEST') {
        return 'message-digest';
    } else {
        return lc($$ibap_object_ref{$current});
    }
}

sub __i2o_advertise_interface_vlan__ {

    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($$ibap_object_ref{'advertise_interface'} eq 'IP') {
        return (
            $$ibap_object_ref{'advertise_interface_vlan'}{'ipv4_network_setting'}{'address'}    ||
            $$ibap_object_ref{'advertise_interface_vlan'}{'ipv6_network_setting'}{'virtual_ip'}
        );
    } else {
        return 'LAN_HA';
    }
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
        'is_ipv4',
        'bfd_fallover',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    my $res = $self->SUPER::__ibap_to_object__(
        $ibap_object_ref, $server, $session,
        $return_object_cache_ref, {'auto_calc_cost_enabled' => 1},
    );

    if ($$ibap_object_ref{'auto_calc_cost_enabled'}) {
        $self->cost('AUTO');
    }

    return $res;
}

sub __o2i_authtype__ {

    my ($self, $session, $current, $tempref) = @_;

    if ($$tempref{$current} =~ m/message-digest/i) {
        return (1, 0, ibap_value_o2i_string('MESSAGE_DIGEST'));
    } else {
        return (1, 0, ibap_value_o2i_string(uc($$tempref{$current})));
    }
}

sub __o2i_cost__ {

    my ($self, $session, $current, $tempref) = @_;

    if ($$tempref{$current} =~ m/auto/i) {
        return (1, 1, undef);
    } else {
        return ibap_o2i_integer(@_)
    }
}

sub __o2i_bfd_template__ {

    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        return (1, 0, ibap_readfield_simple_string('BFDTemplate', 'name', $$tempref{$current}, $current));
    } else {
        return (1, 1, undef);
    }
}

sub __o2i_advertise_interface_vlan__ {

    my ($self, $session, $current, $tempref) = @_;
    my ($res, $extra);

    return (1, 1, 0) unless defined $self->{interface};

    my $type = {
        'field'       => 'type',
        'search_type' => 'EXACT',
        'value'       => ibap_value_o2i_string('LAN_HA')
    };

    if (is_ipv4_address($$tempref{$current})) {
        $res = ibap_readfield_simple('MemberAdditionalIp', [
            $type,
            {
                'field'       => 'ipv4_network_setting',
                'search_type' => 'EXACT',
                'value'       => tIBType('SubMatch', {
                    'search_fields' => [{
                        'field' => 'address',
                        'value' => ibap_value_o2i_string($$tempref{$current})
                    }]
                }),
            },
        ]);

        $extra = {
            'field' => 'advertise_interface',
            'value' => ibap_value_o2i_string('IP'),
        };

    } elsif (is_ipv6_address($$tempref{$current})) {
        $res = ibap_readfield_simple('MemberAdditionalIp', [
            {
                'field'       => 'type',
                'search_type' => 'EXACT',
                'value'       => ibap_value_o2i_string('LAN_HA')
            },
            {
                'field'       => 'ipv6_network_setting',
                'search_type' => 'EXACT',
                'value'       => tIBType('SubMatch', {
                    'search_fields' => [{
                        'field' => 'virtual_ip',
                        'value' => ibap_value_o2i_string($$tempref{$current})
                    }]
                }),
            },
        ]);

        $extra = {
            'field' => 'advertise_interface',
            'value' => ibap_value_o2i_string('IP'),
        };

    } else {
        $extra = {
            'field' => 'advertise_interface',
            'value' => ibap_value_o2i_string($$tempref{$current}),
        };
    }

    return (1, 0, $res, $extra);
}

#
#
#

sub cost {

    my $self = shift;

    my $res = $self->__accessor_scalar__({name => 'cost', validator => \&ibap_value_o2i_string}, @_);

    $$self{'auto_calc_cost_enabled'} = ($_[0] and $_[0] eq 'AUTO' ? 1 : 0)
        if @_ and $res;

    return $res;
}

sub area_id {

    my $self = shift;

    if (@_ and index($_[0], '.') != -1) {
        return $self->__accessor_scalar__({name => 'area_id', validator => \&ibap_value_o2i_ipv4addr}, @_);
    } else {
        return $self->__accessor_scalar__({name => 'area_id', validator => \&ibap_value_o2i_uint}, @_);
    }
}


package Infoblox::Grid::Member::StaticRoute;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap $_object_type);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{

    $_object_type = 'network_setting';
    register_wsdl_type('ib:network_setting', 'Infoblox::Grid::Member::StaticRoute');

    %_allowed_members = (
                         gateway => 1,
                         network => 1,
                        );

    %_name_mappings = (
                       network => 'address',
                      );

    #
    %_reverse_name_mappings = (
                              );

    %_ibap_to_object =
      (
      );

    %_object_to_ibap =
      (
       gateway => \&ibap_o2i_string,
       network => \&__o2i_network__,
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

sub __ibap_object_type__ {

    return $_object_type;
}

#
#
#

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    #
    $self->network($$ibap_object_ref{'address'} .'/'.mask_to_bits($$ibap_object_ref{'subnet_mask'}));

    #
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    return;
}

#
#
#

sub __o2i_network__
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

    my $netmask;
    my $network = $$tempref{$current};

    $network =~ m!^([0-9\.]+)/([0-9\.]+)$!;
    $network = $1;

    #
    $netmask = $2;

    if ( $netmask =~ m/^[0-9]{1,2}$/ ) {
        $netmask = cidr_to_mask($netmask);
    }

    push @return_args, 1;
    push @return_args, 0;
    push @return_args, ibap_value_o2i_string($network);

    my %extra_write_arg;
    $extra_write_arg{'field'} = 'subnet_mask';
    $extra_write_arg{'value'} = ibap_value_o2i_string($netmask);
    push @return_args, \%extra_write_arg;

	return @return_args;
}

#
#
#

sub gateway
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'gateway', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub network
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'network', validator => \&ibap_value_o2i_string}, @_);
}

package Infoblox::Grid::Member::IPv6StaticRoute;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap $_object_type);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    $_object_type = 'ipv6_network_setting';

    #
    register_wsdl_type('ib:ipv6_network_setting','Infoblox::Grid::Member::IPv6StaticRoute');
    %_allowed_members = (
                         address => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_ipv6addr},
                         gateway => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_ipv6addr},
                         cidr    => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_uint},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
      );

    %_object_to_ibap =
      (
       address => \&ibap_o2i_string,
       gateway => \&ibap_o2i_string,
       cidr    => \&ibap_o2i_uint,
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


package Infoblox::Grid::Member::ServiceStatus;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    register_wsdl_type('ib:member_service_status','Infoblox::Grid::Member::ServiceStatus');
    register_wsdl_type('ib:node_service_status','Infoblox::Grid::Member::ServiceStatus');
    %_allowed_members = (
                         description => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         status      => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         service     => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                      );

    %_reverse_name_mappings = (
                              );

    %_ibap_to_object =
      (
       'status' => \&ibap_i2o_enums_ucfirst_or_undef,
      );

    %_object_to_ibap =
      (
       description => \&ibap_o2i_ignore,
       status      => \&ibap_o2i_ignore,
       service     => \&ibap_o2i_ignore,
      );

    @_return_fields = (
                       tField('description'),
                       tField('status'),
                       tField('service'),
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

#
#
#

package Infoblox::Grid::Member::ReplicationInfo;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    register_wsdl_type('ib:replication_info','Infoblox::Grid::Member::ReplicationInfo');
    %_allowed_members = (
                         ha_rep_status     => 0,
                         member_rep_status => 0,
                         send_queue        => 0,
                         last_send         => 0,
                         receive_queue     => 0,
                         last_receive      => 0,
                        );

    %_name_mappings = (
                      );

    %_reverse_name_mappings = (
                              );

    %_ibap_to_object =
      (
      );

    %_object_to_ibap =
      (
      );

    @_return_fields =
      (
       tField('ha_rep_status'),
       tField('member_rep_status'),
       tField('send_queue'),
       tField('last_send'),
       tField('receive_queue'),
       tField('last_receive'),
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

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                             \%_reverse_name_mappings,
                                             undef,
                                             \%_ibap_to_object,
                                             \%_object_to_ibap,
                                             \@_return_fields,
                                            );

}

#
#
#

sub ha_rep_status
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ha_rep_status', readonly => 1}, @_);
}

sub member_rep_status
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'member_rep_status', readonly => 1}, @_);
}

sub send_queue
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'send_queue', readonly => 1}, @_);
}

sub last_send
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'last_send', readonly => 1}, @_);
}

sub receive_queue
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'receive_queue', readonly => 1}, @_);
}

sub last_receive
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'last_receive', readonly => 1}, @_);
}

package Infoblox::Grid::Member::CapacityReport;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides %_capabilities);

@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_ONLY);

BEGIN {
    $_object_type = 'CapacityReport';
    register_wsdl_type('ib:CapacityReport', 'Infoblox::Grid::Member::CapacityReport');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0, # No need for implicit defaults
                      'single_serialization' => 0, # No need for single serialization
                     );

    %_allowed_members = (
                         hardware_type => {simple => 'asis', readonly => 1 },
                         max_capacity  => {simple => 'asis', readonly => 1 },
                         name          => {simple => 'asis', readonly => 1 },
                         object_counts => {readonly => 1},
                         percent_used  => {simple => 'asis', readonly => 1 },
                         role          => {simple => 'asis', readonly => 1 },
                         total_objects => {simple => 'asis', readonly => 1 },
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       hardware_type => 'hw_type',
                       role          => 'member_role',
                       object_counts => 'type_counts',
                      );

    %_ibap_to_object = (
                        type_counts  => \&__i2o_counts__,
                       );

    %_searchable_fields = (
                           #
                           #
                           name => [\&ibap_o2i_member_byhostname ,'vnode_oid', 'EXACT'],
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                hardware_type => [],
                                max_capacity  => [],
                                name          => [],
                                object_counts => [],
                                percent_used  => [],
                                role          => [],
                                total_objects => [],
                               );

    %_object_to_ibap = (
                         hardware_type => \&ibap_o2i_ignore,
                         max_capacity  => \&ibap_o2i_ignore,
                         name          => \&ibap_o2i_ignore,
                         object_counts => \&ibap_o2i_ignore,
                         percent_used  => \&ibap_o2i_ignore,
                         role          => \&ibap_o2i_ignore,
                         total_objects => \&ibap_o2i_ignore,
                       );

    @_return_fields = (
                         tField('hw_type'),
                         tField('max_capacity'),
                         tField('member_role'),
                         tField('name'),
                         tField('percent_used'),
                         tField('total_objects'),
                         tField('type_counts', {
                                                sub_fields =>
                                                [
                                                 tField('count'),
                                                 tField('type_name'),
                                                ]}),
                      );
};

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

sub __i2o_counts__ {
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my %counts;
    if ($$ibap_object_ref{$current} && ref($$ibap_object_ref{$current}) eq 'ARRAY' && scalar(@{$$ibap_object_ref{$current}})) {
        foreach my $t (@{$$ibap_object_ref{$current}}) {
            $counts{$t->{'type_name'}} = $t->{'count'} if $t->{'type_name'};
        }
    }

    return \%counts;
}

#
package Infoblox::Grid::Member::Reporting;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            @ISA
            $_object_type
            %_allowed_members
            @_return_fields
            %_searchable_fields
            %_object_to_ibap
            %_name_mappings
            %_reverse_name_mappings
            %_ibap_to_object
            %_return_field_overrides
            %_capabilities
            $_return_fields_initialized
);

@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_MODIFY_ONLY);

BEGIN {
    $_object_type = 'ReportingMemberProperties';
    register_wsdl_type('ib:ReportingMemberProperties', 'Infoblox::Grid::Member::Reporting');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0, # No need for implicit defaults
                      'single_serialization' => 0, # No need for single serialization
                     );

    %_allowed_members = (
                         cat_ddns                                     => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_ddns', use_truefalse => 1},
                         cat_dhcp_fingerprint                         => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_dhcp_fingerprint', use_truefalse => 1},
                         cat_dhcp_lease                               => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_dhcp_lease', use_truefalse => 1},
                         cat_dhcp_perf                                => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_dhcp_perf', use_truefalse => 1},
                         cat_discovery                                => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_discovery', use_truefalse => 1},
                         cat_dns_perf                                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_dns_perf', use_truefalse => 1},
                         cat_dns_query                                => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_dns_query', use_truefalse => 1},
                         cat_dns_query_capture                        => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_dns_query_capture', use_truefalse => 1},
                         cat_system                                   => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_system', use_truefalse => 1},
                         cat_ecosystem_subscription                   => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_ecosystem_subscription', use_truefalse => 1},
                         cat_ecosystem_publish                        => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_ecosystem_publish', use_truefalse => 1},
                         cat_audit                                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_audit', use_truefalse => 1},
                         cat_license                                  => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_license', use_truefalse => 1},
                         cat_system_capacity                          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_system_capacity', use_truefalse => 1},
                         cat_syslog                                   => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_syslog', use_truefalse => 1},
                         cat_cloud                                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_cloud', use_truefalse => 1},
                         cat_dtc                                      => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_dtc', use_truefalse => 1},
                         cat_network_user                             => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_network_user', use_truefalse => 1},
                         enabled                                      => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_enabled', use_truefalse => 1},
                         name                                         => {validator => \&ibap_value_o2i_string},
                         override_ddns                                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_dhcp_fingerprint                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_dhcp_lease                          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_dhcp_perf                           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_discovery                           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_dns_perf                            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_dns_query                           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_dns_query_capture                   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_enabled                             => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_system                              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_ecosystem_subscription              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_ecosystem_publish                   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_audit                               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_dtc                                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_network_user                        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_cloud                               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_license                             => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_syslog                              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_system_capacity                     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         role                                         => {simple => 'asis', enum => [ "FORWARDER" , "SEARCH_HEAD_INDEXER", "INDEXER" ] },
                         enable_dns_top_clients_per_domain            => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_enable_dns_top_clients_per_domain', use_truefalse => 1},
                         override_enable_dns_top_clients_per_domain   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         domains_for_dns_top_clients_per_domain       => {array => 1, validator => \&ibap_value_o2i_string},
                         override_cat_security                        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_security                                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_cat_security', use_truefalse => 1},
                         syslog_server                                => {validator => {'Infoblox::Grid::SyslogServer' => 1}},

                         #
                         enable_dns_query_per_ip_block_group          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_enable_dns_query_per_ip_block_group', use_truefalse => 1},
                         ip_block_groups                              => {array => 1, validator => \&ibap_value_o2i_string},
                         override_enable_dns_query_per_ip_block_group => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         forwarding_interface_type                    => {simple => 'asis', enum => ['LAN1', 'LAN2', 'MGMT', 'ANY']},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       enabled                                      => 'enable',
                       name                                         => 'parent',
                       override_audit                               => 'use_audit',
                       override_ddns                                => 'use_ddns',
                       override_dhcp_fingerprint                    => 'use_dhcp_fingerprint',
                       override_dhcp_lease                          => 'use_dhcp_lease',
                       override_dhcp_perf                           => 'use_dhcp_perf',
                       override_discovery                           => 'use_discovery',
                       override_dns_perf                            => 'use_dns_perf',
                       override_dns_query                           => 'use_dns_query',
                       override_dns_query_capture                   => 'use_dns_query_capture',
                       override_enabled                             => 'use_enable',
                       override_system                              => 'use_system',
                       override_ecosystem_subscription              => 'use_ecosystem_subscription',
                       override_ecosystem_publish                   => 'use_ecosystem_publish',
                       override_cloud                               => 'use_cloud',
                       override_license                             => 'use_license',
                       override_syslog                              => 'use_syslog',
                       override_system_capacity                     => 'use_system_capacity',
                       override_dtc                                 => 'use_idns',
                       override_network_user                        => 'use_user',
                       cat_dtc                                      => 'cat_idns',
                       cat_network_user                             => 'cat_user',

                       override_enable_dns_top_clients_per_domain   => 'use_dns_top_clients_per_domain',
                       override_cat_security                        => 'use_security',

                       #
                       override_enable_dns_query_per_ip_block_group => 'use_enable_dns_query_per_ip_block_group',
                      );

    %_ibap_to_object = (
                        parent                                  => \&ibap_i2o_member_name,
                        cat_ddns                                => \&ibap_i2o_boolean,
                        cat_dhcp_fingerprint                    => \&ibap_i2o_boolean,
                        cat_dhcp_lease                          => \&ibap_i2o_boolean,
                        cat_dhcp_perf                           => \&ibap_i2o_boolean,
                        cat_discovery                           => \&ibap_i2o_boolean,
                        cat_dns_perf                            => \&ibap_i2o_boolean,
                        cat_dns_query                           => \&ibap_i2o_boolean,
                        cat_dns_query_capture                   => \&ibap_i2o_boolean,
                        cat_system                              => \&ibap_i2o_boolean,
                        cat_ecosystem_subscription              => \&ibap_i2o_boolean,
                        cat_ecosystem_publish                   => \&ibap_i2o_boolean,
                        cat_audit                               => \&ibap_i2o_boolean,
                        cat_user                                => \&ibap_i2o_boolean,
                        cat_idns                                => \&ibap_i2o_boolean,
                        cat_license                             => \&ibap_i2o_boolean,
                        cat_syslog                              => \&ibap_i2o_boolean,
                        cat_system_capacity                     => \&ibap_i2o_boolean,
                        cat_cloud                               => \&ibap_i2o_boolean,
                        enable                                  => \&ibap_i2o_boolean,
                        use_ddns                                => \&ibap_i2o_boolean,
                        use_dhcp_fingerprint                    => \&ibap_i2o_boolean,
                        use_dhcp_lease                          => \&ibap_i2o_boolean,
                        use_dhcp_perf                           => \&ibap_i2o_boolean,
                        use_discovery                           => \&ibap_i2o_boolean,
                        use_dns_perf                            => \&ibap_i2o_boolean,
                        use_dns_query                           => \&ibap_i2o_boolean,
                        use_dns_query_capture                   => \&ibap_i2o_boolean,
                        use_enable                              => \&ibap_i2o_boolean,
                        use_system                              => \&ibap_i2o_boolean,
                        use_ecosystem_subscription              => \&ibap_i2o_boolean,
                        use_ecosystem_publish                   => \&ibap_i2o_boolean,
                        use_audit                               => \&ibap_i2o_boolean,
                        use_user                                => \&ibap_i2o_boolean,
                        use_idns                                => \&ibap_i2o_boolean,
                        use_license                             => \&ibap_i2o_boolean,
                        use_system_capacity                     => \&ibap_i2o_boolean,
                        use_syslog                              => \&ibap_i2o_boolean,
                        use_cloud                               => \&ibap_i2o_boolean,

                        enable_capture_dns_queries              => \&ibap_i2o_boolean,
                        capture_dns_queries_on_all_domains      => \&ibap_i2o_boolean,
                        transfer_settings                       => \&ibap_i2o_generic_object_convert,
                        enable_dns_top_clients_per_domain       => \&ibap_i2o_boolean,
                        use_dns_top_clients_per_domain          => \&ibap_i2o_boolean,
                        use_security                            => \&ibap_i2o_boolean,
                        cat_security                            => \&ibap_i2o_boolean,
                        syslog_server                           => \&ibap_i2o_generic_object_convert,

                        #
                        ip_block_groups                         => \&ibap_i2o_object_list_names,
                        use_enable_excluded_domain_names        => \&ibap_i2o_boolean,
                        use_enable_dns_query_per_ip_block_group => \&ibap_i2o_boolean,

                        #
                        enable_capture_dns_responses            => \&ibap_i2o_boolean,
                        use_enable_capture_dns                  => \&ibap_i2o_boolean,
                        anonymize_response_logging              => \&ibap_i2o_boolean,

                        #
                        store_locally                           => \&ibap_i2o_boolean,
                       );

    %_searchable_fields = (
                           name => [\&ibap_o2i_member_name ,'parent', 'EXACT'],
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                cat_ddns                                     => ['use_ddns'],
                                cat_dhcp_fingerprint                         => ['use_dhcp_fingerprint'],
                                cat_dhcp_lease                               => ['use_dhcp_lease'],
                                cat_dhcp_perf                                => ['use_dhcp_perf'],
                                cat_discovery                                => ['use_discovery'],
                                cat_dns_perf                                 => ['use_dns_perf'],
                                cat_dns_query                                => ['use_dns_query'],
                                cat_dns_query_capture                        => ['use_dns_query_capture'],
                                cat_system                                   => ['use_system'],
                                cat_ecosystem_subscription                   => ['use_ecosystem_subscription'],
                                cat_ecosystem_publish                        => ['use_ecosystem_publish'],
                                cat_audit                                    => ['use_audit'],
                                cat_license                                  => ['use_license'],
                                cat_system_capacity                          => ['use_system_capacity'],
                                cat_syslog                                   => ['use_syslog'],
                                cat_cloud                                    => ['use_cloud'],
                                cat_dtc                                      => ['use_dtc'],
                                cat_network_user                             => ['use_network_user'],
                                enabled                                      => ['use_enable'],
                                name                                         => [],
                                override_ddns                                => [],
                                override_dhcp_fingerprint                    => [],
                                override_dhcp_lease                          => [],
                                override_dhcp_perf                           => [],
                                override_discovery                           => [],
                                override_dns_perf                            => [],
                                override_dns_query                           => [],
                                override_dns_query_capture                   => [],
                                override_enabled                             => [],
                                override_system                              => [],
                                override_ecosystem_subscription              => [],
                                override_ecosystem_publish                   => [],
                                override_audit                               => [],
                                override_network_user                        => [],
                                override_dtc                                 => [],
                                override_cloud                               => [],
                                override_license                             => [],
                                override_system_capacity                     => [],
                                override_syslog                              => [],
                                role                                         => [],
                                syslog_server                                => [],

                                enable_dns_top_clients_per_domain            => ['use_dns_top_clients_per_domain'],
                                override_enable_dns_top_clients_per_domain   => [],
                                domains_for_dns_top_clients_per_domain       => [],
                                cat_security                                 => ['use_security'],
                                override_cat_security                        => [],

                                #
                                enable_dns_query_per_ip_block_group          => ['use_enable_dns_query_per_ip_block_group'],
                                ip_block_groups                              => [],
                                override_enable_dns_query_per_ip_block_group => [],

                                forwarding_interface_type                    => [],
                               );

    %_object_to_ibap = (
                        cat_ddns                                     => \&ibap_o2i_boolean,
                        cat_dhcp_fingerprint                         => \&ibap_o2i_boolean,
                        cat_dhcp_lease                               => \&ibap_o2i_boolean,
                        cat_dhcp_perf                                => \&ibap_o2i_boolean,
                        cat_discovery                                => \&ibap_o2i_boolean,
                        cat_dns_perf                                 => \&ibap_o2i_boolean,
                        cat_dns_query                                => \&ibap_o2i_boolean,
                        cat_dns_query_capture                        => \&ibap_o2i_boolean,
                        cat_system                                   => \&ibap_o2i_boolean,
                        cat_ecosystem_subscription                   => \&ibap_o2i_boolean,
                        cat_ecosystem_publish                        => \&ibap_o2i_boolean,
                        cat_audit                                    => \&ibap_o2i_boolean,
                        cat_license                                  => \&ibap_o2i_boolean,
                        cat_system_capacity                          => \&ibap_o2i_boolean,
                        cat_syslog                                   => \&ibap_o2i_boolean,
                        cat_cloud                                    => \&ibap_o2i_boolean,
                        cat_dtc                                      => \&ibap_o2i_boolean,
                        cat_network_user                             => \&ibap_o2i_boolean,
                        enabled                                      => \&ibap_o2i_boolean,
                        name                                         => \&ibap_o2i_member_name,
                        override_ddns                                => \&ibap_o2i_boolean,
                        override_dhcp_fingerprint                    => \&ibap_o2i_boolean,
                        override_dhcp_lease                          => \&ibap_o2i_boolean,
                        override_dhcp_perf                           => \&ibap_o2i_boolean,
                        override_discovery                           => \&ibap_o2i_boolean,
                        override_dns_perf                            => \&ibap_o2i_boolean,
                        override_dns_query                           => \&ibap_o2i_boolean,
                        override_dns_query_capture                   => \&ibap_o2i_boolean,
                        override_enabled                             => \&ibap_o2i_boolean,
                        override_system                              => \&ibap_o2i_boolean,
                        override_ecosystem_subscription              => \&ibap_o2i_boolean,
                        override_ecosystem_publish                   => \&ibap_o2i_boolean,
                        override_audit                               => \&ibap_o2i_boolean,
                        override_license                             => \&ibap_o2i_boolean,
                        override_system_capacity                     => \&ibap_o2i_boolean,
                        override_syslog                              => \&ibap_o2i_boolean,
                        override_cloud                               => \&ibap_o2i_boolean,
                        override_dtc                                 => \&ibap_o2i_boolean,
                        override_network_user                        => \&ibap_o2i_boolean,
                        role                                         => \&ibap_o2i_string,
                        syslog_server                                => \&ibap_o2i_generic_struct_convert,

                        enable_dns_top_clients_per_domain            => \&ibap_o2i_boolean,
                        override_enable_dns_top_clients_per_domain   => \&ibap_o2i_boolean,
                        domains_for_dns_top_clients_per_domain       => \&ibap_o2i_string_array_undef_to_empty,
                        override_cat_security                        => \&ibap_o2i_boolean,
                        cat_security                                 => \&ibap_o2i_boolean,

                        #
                        enable_dns_query_per_ip_block_group          => \&ibap_o2i_boolean,
                        ip_block_groups                              => \&__o2i_groups__,
                        override_enable_dns_query_per_ip_block_group => \&ibap_o2i_boolean,

                        forwarding_interface_type                    => \&ibap_o2i_string,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('parent',return_fields_member_basic_data()),
                       tField('use_enable'),
                       tField('enable'),
                       tField('role'),
                       tField('use_dns_query'),
                       tField('cat_dns_query'),
                       tField('use_dns_query_capture'),
                       tField('cat_dns_query_capture'),
                       tField('use_dns_perf'),
                       tField('cat_dns_perf'),
                       tField('use_ddns'),
                       tField('cat_ddns'),
                       tField('use_dhcp_fingerprint'),
                       tField('cat_dhcp_fingerprint'),
                       tField('use_dhcp_lease'),
                       tField('cat_dhcp_lease'),
                       tField('use_dhcp_perf'),
                       tField('cat_dhcp_perf'),
                       tField('use_discovery'),
                       tField('cat_discovery'),
                       tField('use_system'),
                       tField('cat_system'),
                       tField('use_ecosystem_subscription'),
                       tField('cat_ecosystem_subscription'),
                       tField('use_ecosystem_publish'),
                       tField('cat_ecosystem_publish'),
                       tField('use_audit'),
                       tField('cat_audit'),
                       tField('use_user'),
                       tField('use_idns'),
                       tField('use_cloud'),
                       tField('use_license'),
                       tField('use_syslog'),
                       tField('use_system_capacity'),
                       tField('cat_user'),
                       tField('cat_idns'),
                       tField('cat_cloud'),
                       tField('cat_license'),
                       tField('cat_system_capacity'),
                       tField('cat_syslog'),
                       tField('enable_dns_top_clients_per_domain'),
                       tField('use_dns_top_clients_per_domain'),
                       tField('domains_for_dns_top_clients_per_domain'),
                       tField('use_security'),
                       tField('cat_security'),
                       tField('forwarding_interface_type'),

                       #
                       tField('enable_dns_query_per_ip_block_group'),
                       tField('use_enable_dns_query_per_ip_block_group'),
                       tField('ip_block_groups',
                              {
                               sub_fields => [
                                              tField('name'),
                                             ]
                              }
                             ),
                      );

    $_return_fields_initialized = 0;
};

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


sub __ibap_object_type__
{
    return $_object_type;
}

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

sub __o2i_groups__
{
    my ($self, $session, $current, $tempref, $type) = @_;

    if ($$tempref{$current}) {
        my @list;
        foreach (@{$$tempref{$current}}) {
            push @list, ibap_readfield_simple_string('IpBlockGroup', 'name', $_, $current);
        }
        return (1,0, tIBType('ArrayOfBaseObject',\@list));
    }
    else {
        return (1,0, tIBType('ArrayOfBaseObject',[]));
    }
}

sub __init_instance_constants__
{
    my $self = shift;

    unless ($_return_fields_initialized) {
        $_return_fields_initialized = 1;

        my ($tmp, %tmp);

        %tmp = (
                syslog_server  => 'Infoblox::Grid::SyslogServer',
        );

        foreach (keys %tmp) {

            $tmp = $tmp{$_}->__new__();
            push @_return_fields, tField($_, {sub_fields => $tmp->__return_fields__()});
        }
    }
}


package Infoblox::Grid::Member::Capture::Control;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides %_capabilities);

@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = '_InternalCaptureControl';

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                      'single_serialization' => 0,
                     );

    %_allowed_members = (
                         action         => {simple => 'asis', mandatory => 1, enum => ['START', 'STOP'] },
                         interface      => {simple => 'asis', mandatory => 1, enum => ['ALL', 'HA', 'LAN', 'LAN1', 'LAN2','MGMT'] },
                         seconds_to_run => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_uint},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                      );

    %_ibap_to_object = (
                       );

    %_searchable_fields = (
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                               );

    %_object_to_ibap = (
                         action         => \&ibap_o2i_enums_lc_or_undef,
                         interface      => \&__o2i_interface__,
                         seconds_to_run => \&ibap_o2i_uint,
                       );

    @_return_fields = (
                      );
};

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

sub __o2i_interface__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if (($self->{'interface'}) and ($self->{'interface'} eq 'LAN')) {
        return (1, 0, tString('LAN1'))
    }
    else
    {
        return ibap_o2i_enums_lc_or_undef(@_)
    }
}


#
#
package Infoblox::Grid::Member::Capture::Status;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides %_capabilities);

@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = '_InternalCaptureResult';

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                      'single_serialization' => 0,
                     );

    %_allowed_members = (
                         status      => {simple => 'asis', readonly => 1 },
                         file_exists => {simple => 'bool', readonly => 1 },
                         file_size   => {simple => 'asis', readonly => 1 },
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                      );

    %_ibap_to_object = (
                        file_exists => \&ibap_i2o_boolean,
                       );

    %_searchable_fields = (
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                               );

    %_object_to_ibap = (
                       );

    @_return_fields = (
                      );
};

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

package Infoblox::Grid::Member::RestartServiceStatus;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_ibap_to_object
            %_return_field_overrides %_capabilities);

@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::RO);

BEGIN {
    $_object_type = 'RestartServiceStatus';
    register_wsdl_type('ib:RestartServiceStatus', 'Infoblox::Grid::Member::RestartServiceStatus');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0, # No need for implicit defaults
                      'single_serialization' => 0, # No need for single serialization
                     );

    %_allowed_members = (
                         'member'           => {'readonly' => 1},
                         'dhcp_status'      => {'readonly' => 1, 'simple' => 'asis'},
                         'dns_status'       => {'readonly' => 1, 'simple' => 'asis'},
                         'radius_status'    => {'deprecated' => 1},
                         'reporting_status' => {'readonly' => 1, 'simple' => 'asis'},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'member' => \&ibap_i2o_member_byhostname,
                       );

    %_object_to_ibap = (
                        'member'           => \&ibap_o2i_ignore,
                        'dhcp_status'      => \&ibap_o2i_ignore,
                        'dns_status'       => \&ibap_o2i_ignore,
                        'reporting_status' => \&ibap_o2i_ignore,
                       );
    %_return_field_overrides = (
                                'member'           => [],
                                'dhcp_status'      => [],
                                'dns_status'       => [],
                                'reporting_status' => [],
                               );

    @_return_fields = (
                       tField('member', return_fields_member_basic_data()),
                       tField('dhcp_status'),
                       tField('dns_status'),
                       tField('reporting_status'),
                      );

    %_searchable_fields = (
                           'member' => [\&ibap_o2i_member_byhostname, 'member', 'EXACT'],
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


#
#
package Infoblox::Grid::Member::PNodeToken;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::PAPIOverrides;
use Infoblox::IBAPTypes;
use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides %_capabilities);

@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::RO);

BEGIN {
    $_object_type = 'PNodeToken';

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                      'single_serialization' => 0,
                     );

    %_allowed_members = (
                         physical_oid   => {readonly => 1 },
                         token_exp_date => {readonly => 1 },
                         token          => {readonly => 1 },
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                      );

    %_ibap_to_object = (
                        token_exp_date  => \&ibap_i2o_datetime_to_unix_timestamp,
                       );

    %_searchable_fields = (
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                               );

    %_object_to_ibap = (
                       );

    @_return_fields = (
                      );
};

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


package Infoblox::Grid::Member::QueryFQDNParameter;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            @ISA
            $_object_type
            %_allowed_members
            %_object_to_ibap
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    %_allowed_members = (
                         'fqdn'            => {mandatory => 1, validator => \&ibap_value_o2i_string},
                         'member'          => {validator => \&ibap_value_o2i_string},
                         'name_server'     => {validator => \&ibap_value_o2i_string},
                         'record_type'     => {enum => ['ANY', 'A', 'AAAA', 'CNAME', 'DNAME', 'MX', 'NAPTR', 'NS', 'PTR', 'SRV', 'TXT', 'AXFR']},
                         'recursive_query' => {validator => \&ibap_value_o2i_boolean},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'fqdn'            => \&ibap_o2i_string,
                        'member'          => \&ibap_o2i_member_byhostname,
                        'name_server'     => \&ibap_o2i_string,
                        'record_type'     => \&ibap_o2i_string,
                        'recursive_query' => \&ibap_o2i_boolean,
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


package Infoblox::Grid::Member::QueryFQDNResponse;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            @ISA
            %_allowed_members
            %_ibap_to_object
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    %_allowed_members = (
                         'dig_started'    => {readonly => 1},
                         'result'         => {simple => 'asis', readonly => 1, enum => ['NOERROR', 'FORMERR', 'SERVFAIL', 'NXDOMAIN', 'NOTIMP', 'REFUSED', 'INTERNAL_ERROR']},
                         'result_text'    => {simple => 'asis', readonly => 1},
                         'source_address' => {simple => 'asis', readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'dig_started' => \&ibap_i2o_datetime_to_unix_timestamp,
    );
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}



1;
