#Copyright (c) 2017 Infoblox Inc. All Rights Reserved.
package    Infoblox::Util;
require Exporter;
@ISA    = qw(Exporter);
@EXPORT = qw( object_handler
    cidr_to_mask
    mask_to_bits
    cidr_to_arpa
    cidr_to_network
    ip_address_munger
    is_ipv4_address
    is_ipv6_address
    is_ipv4_network
    is_ipv6_network
    get_custom_option_name
    get_custom_option_num
    check_vector_type
    check_object_type
    complex_type_handler
    boolean_to_lowercase
    ibap_value_o2i_boolean
    ibap_value_o2i_boolean_reverse
    ibap_value_i2o_boolean
    ibap_i2o_boolean
    ibap_i2o_boolean_reverse
    ibap_o2i_string
    ibap_o2i_string_skip_undef
    ibap_o2i_string_array_undef_to_empty
    ibap_o2i_string_array_skip_undef
    ibap_o2i_string_undef_to_empty
    ibap_o2i_boolean
    ibap_o2i_boolean_reverse
    ibap_o2i_integer
    ibap_i2o_integer_1000
    ibap_o2i_integer_1000
    ibap_o2i_options
    ibap_i2o_options
    ibap_o2i_ordered_filters
    ibap_i2o_ordered_filters
    ibap_o2i_uint
    ibap_o2i_uint_skip_undef
    ibap_o2i_long
    ibap_o2i_ulong
    ibap_o2i_integer_skip_undef
    ibap_o2i_ignore
    ibap_i2o_member_byhostname
    ibap_o2i_member_byhostname
    ibap_o2i_view_convert
	ibap_o2i_view
    ibap_o2i_views
	ibap_o2i_network_view
	ibap_o2i_dns64groups
    ibap_o2i_ms_adsites_domain
	ibap_o2i_network
	ibap_o2i_network_string
	ibap_o2i_network_list
    ibap_o2i_generic_network_list
    ibap_arg_remote_ddns_zone_list
	ibap_arg_bootp_props
	ibap_i2o_bootp_props
	ibap_i2o_bootp_props_no_use_flags
	ibap_o2i_common_dhcp_props
	ibap_i2o_common_dhcp_props
	ibap_i2o_common_dhcp_props_no_use_flags
    ibap_i2o_address_ac_list
    ibap_i2o_ac_setting
    ibap_o2i_ac_setting
    ibap_o2i_ac_setting_undef_to_empty_list
    ibap_i2o_ntp_ac_setting
    ibap_o2i_ntp_ac_setting
    ibap_i2o_mixed_ac
    ibap_o2i_mixed_ac
    ibap_i2o_mixed_ac_list
    ibap_o2i_mixed_ac_list
    ibap_o2i_forwarders
    ibap_i2o_object_name
    ibap_i2o_object_list_names
    ibap_i2o_grid_name_and_id
    ibap_o2i_address_ac_list
    ibap_o2i_address_ac_list_undef_to_empty_list
    ibap_i2o_tsig_ac_list
    ibap_o2i_tsig_ac_list
    ibap_i2o_exclusion
    ibap_o2i_exclusion
    ibap_i2o_exclusion_template
    ibap_o2i_exclusion_template
    ibap_i2o_sort_list
    ibap_o2i_sort_list
    ibap_i2o_query_item
    ibap_i2o_query_item_list
    ibap_o2i_query_item
    ibap_o2i_query_item_list
	ibap_i2o_remote_ddns_zone_list_convert
    ibap_i2o_generic_object_list_convert
    ibap_i2o_generic_object_list_convert_partial
    ibap_i2o_generic_object_list_convert_no_cache
    ibap_i2o_generic_object_convert
    ibap_i2o_generic_object_convert_partial
    ibap_i2o_generic_object_convert_to_list_of_one
    ibap_i2o_generic_object_convert_no_cache
    ibap_o2i_generic_struct_convert
    ibap_o2i_generic_struct_list_convert
    ibap_o2i_generic_subobject_convert
    ibap_o2i_generic_subobject_list_convert
	ibap_i2o_range_failover
	ibap_o2i_range_failover
	ibap_i2o_range_filters
	ibap_o2i_range_filters
    ibap_i2o_f5_health
    ibap_i2o_upgrade_group_name
    ibap_o2i_upgrade_group_as_object
	ibap_i2o_mixed_member
	ibap_o2i_mixed_member
    ibap_o2i_mixed_member_search
	ibap_i2o_mixed_members_list
	ibap_o2i_mixed_members_list
    ibap_o2i_msserver
    ibap_o2i_msserver_helper
    ibap_o2i_ttl
    ibap_i2o_zone_associations
    ibap_lazy_i2o_zone_associations_use_member
    ibap_o2i_zone_associations
    ibap_o2i_zone_list
    ibap_o2i_ibfield_string
    ibap_o2i_ibfield_string_exact
	ibap_readfield_simple
    ibap_readfield_simple_string
    ibap_readfieldlist_simple
    ibap_readfieldlist_simple_string
    ibap_value_i2o_dhcpmember
    ibap_value_o2i_int
    ibap_value_o2i_int_1000
    ibap_value_o2i_uint
    ibap_value_o2i_uint_undef_ok
    ibap_value_o2i_long
    ibap_value_o2i_ulong
    ibap_value_o2i_address_ac
    ibap_unwrapped_address_ac_convert
    ibap_value_o2i_member_nocache
    ibap_value_o2i_dns_msserver_convert
    ibap_value_o2i_member
	ibap_value_o2i_member_server
	ibap_value_o2i_tsig_ac
    ibap_unwrapped_tsig_ac_convert
    ibap_value_o2i_string
    ibap_value_o2i_string_no_spaces
    ibap_object_member_server_convert
	ibap_object_tsig_ac_convert
	ibap_value_i2o_address_ac
	ibap_o2i_ipv6_network
	ibap_o2i_ipv6_network_list
    ibap_value_o2i_string_undef_to_empty
	set_error_codes
	append_error_codes
    ibap_get_object_id
    ibap_value_o2i_string_to_datetime
    ibap_o2i_string_to_datetime
    ibap_o2i_unix_timestamp_to_datetime
    ibap_i2o_datetime_to_unix_timestamp
    ibap_i2o_datetime_to_unix_timestamp_nolimit
	ibap_accessor_dhcp_options
    ibap_accessor_ac_setting
	is_special_option_broadcast
	is_special_option_domain_name
	is_special_option_routers
	is_special_option_lease_time
	is_special_option_nameservers
	generate_special_object_member_cache_key
	generate_special_object_msserver_cache_key
    ibap_i2o_network_container
    capitalize_first_letter
    ibap_value_o2i_tz
    ibap_value_o2i_ipaddr
    ibap_value_o2i_ipv4addr
    ibap_value_o2i_ipv6addr
    ibap_value_o2i_ipv4_network
    ibap_value_o2i_ipv6_network
    ibap_value_o2i_ipv6_network_or_address
    ibap_value_o2i_network
    ibap_o2i_substruct_search
    ibap_o2i_substruct_exact_search
    ibap_o2i_substruct_exact_int_search
    ibap_o2i_substruct_exact_datetime_search
    ibap_o2i_ipv4addr_list
    ibap_o2i_ipaddr_list
    ibap_o2i_ipaddr_list_helper
    ibap_o2i_addresscidr_list_helper
    ibap_i2o_enums_ucfirst_or_undef
    ibap_i2o_enums_lc_or_undef
    ibap_o2i_enums_lc_or_undef
    ibap_o2i_enums_uc_or_undef
    ibap_i2o_logging_categories
    ibap_o2i_logging_categories
    ibap_i2o_transfer_format
    ibap_o2i_transfer_format
    ibap_i2o_root_ns_list
    ibap_o2i_root_ns_list
    ibap_i2o_record_name_policies
    ibap_o2i_record_name_policies
    ibap_value_i2o_match_options
    ibap_i2o_match_options
    ibap_o2i_match_options
    ibap_value_o2i_match_options
    ibap_i2o_member_name
    ibap_o2i_member_name
    ibap_value_o2i_ext_server
    ibap_i2o_primary_nameserver
    ibap_i2o_nameserver
    ibap_i2o_member_nameserver
    ibap_i2o_forwarding_servers
    ibap_o2i_forwarding_servers
    ibap_i2o_email_list
    ibap_o2i_email_list
    ibap_i2o_members_list
    ibap_o2i_members_list
    ibap_i2o_option60_match_rules
    ibap_o2i_option60_match_rules
    ibap_i2o_dns_msserver
    ibap_i2o_dns_msserver_list
    ibap_o2i_dnssec_props
    ibap_i2o_dnssec_props
    ibap_o2i_dnssec_trusted_keys
    ibap_i2o_dnssec_trusted_keys
    ibap_serialize_subobject_list
    ibap_serialize_subobject
    ibap_serialize_substruct_list
    ibap_serialize_substruct

    ibap_o2i_dnssec_key_params
    ibap_i2o_dnssec_key_params
    dnssec_algorithm_size_accessor
    @dnssec_allowed_algorithms

    ibap_o2i_key_algorithm
    ibap_i2o_key_algorithm
    ibap_value_o2i_enum_mapping
    ibap_i2o_enum_mapping_or_empty
    ibap_i2o_v_type
    ibap_o2i_substruct_exact_v_type_search
    ibap_o2i_object_only_by_oid
    ibap_o2i_object_only_by_oid_skip_undef
    ibap_o2i_object_only_by_oid_or_undef
    ibap_o2i_object_by_oid_or_name
    ibap_o2i_object_by_oid_or_readfield
    register_wsdl_type
    iso8601_datetime_to_unix_timestamp
    timestamp_at_11_01_on_same_utc_day
    schedule_request
    request_settings
    ibap_func_call_handler
    value_type_field_name_for_type
    ibap_arg_zone_convert
    ibap_i2o_discovered_data
    utc_to_umt
    umt_to_utc
    %papi_object_type_from_wsdl
    %papi_partial_subobjects
    return_fields_extensible_attributes
    return_fields_member_basic_data
    return_fields_member_basic_data_no_access_ok
    return_fields_templates
    return_fields_address_tsig_ac
    return_fields_ac_setting
    return_fields_ntp_ac_setting
    return_fields_network_partial
    return_fields_option_logic_filters
    @dnssec_algorithm_list
    @syslog_enum_values
    ibap_o2i_rulesets_by_names
    ibap_i2o_rulesets_by_names
    ibap_o2i_snmpv3_users
    ibap_i2o_snmpv3_users
    ibap_i2o_snmpv3_query_users
    ibap_o2i_snmpv3_query_users
    ibap_o2i_trap_receivers
    ibap_i2o_trap_receivers
    fixedaddress_get_search_callback_helper
    ibap_o2i_netmask_to_cidr
    ibap_i2o_netmask_to_cidr
    ibap_i2o_domain_name_servers
    ibap_o2i_domain_name_servers
    ibap_i2o_mac_addresses
    ibap_o2i_mac_addresses
    ibap_o2i_member_search
    ibap_o2i_network_container_search
    ibap_o2i_range_templates
    ibap_o2i_ipv6_range_templates
    ibap_o2i_fixed_address_templates
    ibap_o2i_ipv6_fixed_address_templates
    ibap_o2i_rir_organization
    ibap_i2o_templates
    simple_name_readfield_helper
    ibap_o2i_range_template
    ibap_o2i_ipv6_range_template
    ibap_o2i_fixed_address_template
    ibap_o2i_ipv6_fixed_address_template
    @address_type_enum_values
    ibap_o2i_gss_tsig_keys
    ibap_o2i_ipv6_gss_tsig_keys
    gleq_search_helper
    @discovery_common_fields
    @vdiscovery_fields
    ibap_i2o_enums_uc_or_undef
    ibap_o2i_enums_ucfirst_or_undef
    %copy_record_arg_to_rule_map
    %copy_record_arg_to_rr_map
    ibap_i2o_object_category_name
    ibap_i2o_dhcp_ddns
    ibap_value_o2i_oid
    ibap_value_o2i_network_helper
    object_by_oid_or_readfield_helper
    ibap_value_o2i_discovery_interfaces
    ibap_o2i_object_only_by_oid_undef_ok

    @allowed_logging_categories

    ibap_o2i_zone_by_fqdn_and_view_name
    ibap_i2o_zone_and_view_by_name

    ibap_o2i_delegated_member
    ibap_o2i_cert_data_ref
    ibap_o2i_object_by_oid_or_name_undef_ok
    ibap_o2i_object_by_oid_or_name_skip_undef

    ibap_i2o_string_to_enum_array
    ibap_o2i_enum_array_to_string
    array_contains
    ibap_i2o_audit_log_event
    ibap_o2i_object_by_name_helper

    source_interface_return_fields
    ibap_o2i_source_interface
    ibap_i2o_source_interface

);

use strict;
use warnings;
use Carp;
use POSIX qw(strftime);
use Time::Local;
use Infoblox::IBAPTypes;
use Infoblox::Fault qw(papi_error);
use Scalar::Util qw(weaken isweak);

use Data::Dumper;

my $client_version = "8.2.6-371069";

my $MAX_UINT = 2 ** 32 - 1;
my $MAX_INT32 = 2 ** 31 - 1;
my $MIN_INT32 = -(2 ** 31);

my %_log_fields_mapping=
        (
            log_general         => 'general',
            log_client          => 'client',
            log_config          => 'config',
            log_database        => 'database',
            log_dnssec          => 'dnssec',
            log_lame_servers    => 'lame_servers',
            log_network         => 'network',
            log_notify          => 'notify',
            log_queries         => 'queries',
            log_responses       => 'responses',
            log_resolver        => 'resolver',
            log_security        => 'security',
            log_update          => 'update',
            log_xfer_in         => 'xfer_in',
            log_xfer_out        => 'xfer_out',
            log_update_security => 'update_security',
            log_rpz             => 'rpz',
            log_query_rewrite   => 'query_rewrite',
            log_idns_gslb       => 'dtc_gslb',
            log_idns_health     => 'dtc_health',
        );

our %copy_record_arg_to_rule_map = (
                        copy_passthru_ip_addr             => 'PassthruIpaddr',
                        copy_passthru_domain              => 'PassthruDomain',
                        copy_block_nxd_ip_addr            => 'BlockNxdomainIpaddr',
                        copy_block_nxd_domain             => 'BlockNxdomainDomain',
                        copy_block_nodata_ip_addr         => 'BlockNoDataIpaddr',
                        copy_block_nodata_domain          => 'BlockNoDataDomain',
                        copy_subst_cname                  => 'SubstituteCName',
                        copy_subst_a                      => 'SubstituteARecord',
                        copy_subst_aaaa                   => 'SubstituteAAAARecord',
                        copy_subst_mx                     => 'SubstituteMXRecord',
                        copy_subst_ptr                    => 'SubstitutePTRRecord',
                        copy_subst_naptr                  => 'SubstituteNAPTRRecord',
                        copy_subst_srv                    => 'SubstituteSRVRecord',
                        copy_subst_txt                    => 'SubstituteTXTRecord',
                        copy_subst_ipv4_addr              => 'SubstituteIPv4AddressRecord',
                        copy_subst_ipv6_addr              => 'SubstituteIPv6AddressRecord',
                        copy_subst_ipaddr_cname           => 'SubstituteIPAddressCname',
                        copy_passthru_client_ipaddr       => 'PassthruClientIpaddr',
                        copy_block_nxdomain_client_ipaddr => 'BlockNxdomainClientIpaddr',
                        copy_block_no_data_client_ipaddr  => 'BlockNoDataClientIpaddr',
                        copy_subst_client_ipaddr_cname    => 'SubstituteClientIPAddressCname',
                       );

our %copy_record_arg_to_rr_map = (
                        copy_bind_srv => 'SRV',
                        copy_bind_txt => 'TXT',
                        copy_bind_ptr => 'PTR',
                        copy_bulk_host => 'BULK_HOST',
                        copy_bind_a => 'A',
                        copy_bind_aaaa => 'AAAA',
                        copy_bind_cname => 'CNAME',
                        copy_bind_dname => 'DNAME',
                        copy_bind_mx => 'MX',
                        copy_bind_naptr => 'NAPTR',
                        copy_host => 'HOST',
                       );

my %_reverse_log_fields_mapping= reverse %_log_fields_mapping;
our @allowed_logging_categories = keys %_reverse_log_fields_mapping;

my %_global_identifier_query_meta = (
    'type' => {
                'value_type' => 'ENUM',
                'field_type' => 'NORMAL',
    },
    'ipv4_address' => {
                       'value_type' => 'STRING',
                       'field_type' => 'NORMAL',
                      },
    'ipv6_address' => {
                       'value_type' => 'STRING',
                       'field_type' => 'NORMAL',
                      },
    'client_name' => {
                       'value_type' => 'STRING',
                       'field_type' => 'NORMAL',
                      },
    'timestamp' => {
                       'value_type' => 'DATE',
                       'field_type' => 'NORMAL',
                      },
    'metadata_type' => {
                       'value_type' => 'STRING',
                       'field_type' => 'NORMAL',
                      },
    'metadata_namespace' => {
                       'value_type' => 'STRING',
                       'field_type' => 'NORMAL',
                      },
    'identity_type' => {
                       'value_type' => 'ENUM',
                       'field_type' => 'NORMAL',
                      },
    'name' => {
                       'value_type' => 'STRING',
                       'field_type' => 'NORMAL',
                      },
    'mac_address' => {
                       'value_type' => 'STRING',
                       'field_type' => 'NORMAL',
                      },
    'administrative_domain' => {
                       'value_type' => 'STRING',
                       'field_type' => 'NORMAL',
                      },
    'other_definition' => {
                       'value_type' => 'STRING',
                       'field_type' => 'NORMAL',
                      },
);

my %v_type_name_mapping =
(
  'VirtualCenter' => 'VCENTER',
  'HostSystem'=>'VHOST',
  'VirtualMachine'=>'VMACHINE'
);

my %reverse_v_type_name_mapping = reverse %v_type_name_mapping;

my %qitems_name_mappings=(
   v_type       => 'v_entity_type',
);

my %reverse_qitems_name_mappings= reverse %qitems_name_mappings;

our @syslog_enum_values = ('debug','info','notice','warning','err','crit','alert','emerg');

our @address_type_enum_values = ('ADDRESS', 'PREFIX', 'BOTH');

our @discovery_common_fields = qw(
                                discovered_name
                                discoverer
                                first_discovered
                                last_discovered
                                netbios
                                network_component_description
                                network_component_ip
                                network_component_name
                                network_component_port_description
                                network_component_port_name
                                network_component_port_number
                                network_component_type
                                os
                                port_duplex
                                port_link_status
                                port_speed
                                port_status
                                port_vlan_description
                                port_vlan_name
                                port_vlan_number
);

our @vdiscovery_fields = qw(
        v_cluster
        v_datacenter
        v_host
        v_name
        v_netadapter
        v_switch
        v_type
);

sub umt_to_utc {
    my ($umt) = @_;
    my %mlook = (
                 '(UMT - 12:00) Eniwetok, Kwajalein'                              => '(UTC - 12:00)',
                 '(UMT - 11:00) Midway Island, Samoa'                             => '(UTC - 11:00) Midway Island, Samoa',
                 '(UMT - 10:00) Hawaii'                                           => '(UTC - 10:00) Hawaii',
                 '(UMT - 9:00) Alaska'                                            => '(UTC - 9:00) Alaska',
                 '(UMT - 8:00) Pacific Time (US and Canada), Tijuana'             => '(UTC - 8:00) Pacific Time (US and Canada), Tijuana',
                 '(UMT - 7:00) Arizona'                                           => '(UTC - 7:00) Arizona',
                 '(UMT - 7:00) Mountain Time (US and Canada)'                     => '(UTC - 7:00) Mountain Time (US and Canada)',
                 '(UMT - 6:00) Central Time (US and Canada)'                      => '(UTC - 6:00) Central Time (US and Canada)',
                 '(UMT - 6:00) Mexico City, Tegucigalpa'                          => '(UTC - 6:00) Mexico City, Tegucigalpa',
                 '(UMT - 6:00) Saskatchewan'                                      => '(UTC - 6:00) Saskatchewan',
                 '(UMT - 5:00) Bogota, Lima, Quito'                               => '(UTC - 5:00) Bogota, Lima, Quito',
                 '(UMT - 5:00) Eastern Time (US and Canada)'                      => '(UTC - 5:00) Eastern Time (US and Canada)',
                 '(UMT - 5:00) Indiana (East)'                                    => '(UTC - 5:00) Indiana (East)',
                 '(UMT - 4:00) Atlantic Time (Canada)'                            => '(UTC - 4:00) Atlantic Time (Canada)',
                 '(UMT - 4:00) Caracas, La Paz'                                   => '(UTC - 4:00) Caracas',
                 '(UMT - 4:00) Santiago'                                          => '(UTC - 4:00) Santiago',
                 '(UMT - 3:30) Newfoundland'                                      => '(UTC - 3:30) Newfoundland',
                 '(UMT - 3:00) Brasilia'                                          => '(UTC - 3:00) Brasilia',
                 '(UMT - 3:00) Buenos Aires, Georgetown'                          => '(UTC - 3:00) Buenos Aires',
                 '(UMT - 2:00) Mid-Atlantic'                                      => '(UTC - 2:00) Mid-Atlantic',
                 '(UMT - 1:00) Azores, Cape Verde Islands'                        => '(UTC - 1:00) Azores',
                 '(UMT) Casablanca, Monrovia'                                     => '(UTC) Casablanca',
                 '(UMT) Universal Mean Time, Dublin, Edinburgh, Lisbon, London'   => '(UTC) Coordinated Universal Time',
                 '(UMT + 1:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna'  => '(UTC + 1:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna',
                 '(UMT + 1:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague' => '(UTC + 1:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague',
                 '(UMT + 1:00) Brussels, Copenhagen, Madrid, Paris, Vilnius'      => '(UTC + 1:00) Brussels, Copenhagen, Madrid, Paris',
                 '(UMT + 1:00) Sarajevo, Skopje, Sofija, Warsaw, Zagreb'          => '(UTC + 1:00) Sarajevo, Skopje, Sofija, Warsaw, Zagreb',
                 '(UMT + 2:00) Athens, Istanbul, Minsk'                           => '(UTC + 2:00) Athens, Vilnius',
                 '(UMT + 2:00) Bucharest'                                         => '(UTC + 2:00) Bucharest',
                 '(UMT + 2:00) Cairo'                                             => '(UTC + 2:00) Cairo',
                 '(UMT + 2:00) Harare, Pretoria'                                  => '(UTC + 2:00) Harare',
                 '(UMT + 2:00) Helsinki, Riga, Tallinn'                           => '(UTC + 2:00) Helsinki',
                 '(UMT + 2:00) Jerusalem'                                         => '(UTC + 2:00) Jerusalem',
                 '(UMT + 3:00) Baghdad, Kuwait, Riyadh'                           => '(UTC + 3:00) Baghdad, Istanbul, Kuwait, Minsk, Riyadh',
                 '(UMT + 3:00) Moscow, St. Petersburg, Volgograd'                 => '(UTC + 3:00) Moscow, St    .   Petersburg, Volgograd',
                 '(UMT + 3:00) Nairobi'                                           => '(UTC + 3:00) Nairobi',
                 '(UMT + 3:30) Tehran'                                            => '(UTC + 3:30) Tehran',
                 '(UMT + 4:00) Abu Dhabi, Muscat'                                 => '(UTC + 4:00) Dubai',
                 '(UMT + 4:00) Baku, Tbilisi'                                     => '(UTC + 4:00) Baku',
                 '(UMT + 4:00) Kabul'                                             => '(UTC + 4:30) Kabul',
                 '(UMT + 5:00) Ekaterinburg'                                      => '(UTC + 5:00) Ekaterinburg',
                 '(UMT + 5:00) Islamabad, Karachi, Tashkent'                      => '(UTC + 5:00) Islamabad, Karachi',
                 '(UMT + 5:30) Bombay, Calcutta, Madras, New Delhi'               => '(UTC + 5:30) Bombay, Calcutta, Madras, New Delhi',
                 '(UMT + 6:00) Astana, Almaty, Dhaka'                             => '(UTC + 6:00) Dhaka',
                 '(UMT + 6:00) Colombo'                                           => '(UTC + 5:30) Colombo',
                 '(UMT + 6:30) Rangoon'                                           => '(UTC + 6:30) Rangoon',
                 '(UMT + 7:00) Bangkok, Hanoi, Jakarta'                           => '(UTC + 7:00) Bangkok, Hanoi',
                 '(UMT + 8:00) Beijing, Chongqing, Hong Kong, Urumqi'             => '(UTC + 8:00) Beijing, Chongqing, Shanghai',
                 '(UMT + 8:00) Perth'                                             => '(UTC + 8:00) Perth',
                 '(UMT + 8:00) Singapore'                                         => '(UTC + 8:00) Singapore',
                 '(UMT + 8:00) Taipei'                                            => '(UTC + 8:00) Taipei',
                 '(UMT + 9:00) Osaka, Sapporo, Tokyo'                             => '(UTC + 9:00) Osaka, Sapporo, Tokyo',
                 '(UMT + 9:00) Seoul'                                             => '(UTC + 9:00) Seoul',
                 '(UMT + 9:30) Adelaide'                                          => '(UTC + 9:30) Adelaide',
                 '(UMT + 9:30) Darwin'                                            => '(UTC + 9:30) Darwin',
                 '(UMT + 10:00) Brisbane'                                         => '(UTC + 10:00) Brisbane',
                 '(UMT + 10:00) Canberra, Melbourne, Sydney'                      => '(UTC + 10:00) Canberra, Sydney',
                 '(UMT + 10:00) Guam, Port Moresby'                               => '(UTC + 10:00) Guam',
                 '(UMT + 10:00) Hobart'                                           => '(UTC + 10:00) Hobart',
                 '(UMT + 10:00) Vladivostok'                                      => '(UTC + 10:00) Vladivostok',
                 '(UMT + 11:00) Magadan, Solomon Islands, New Caledonia'          => '(UTC + 11:00) Magadan',
                 '(UMT + 12:00) Auckland, Wellington'                             => '(UTC + 12:00) Auckland',
                 '(UMT + 12:00) Fiji, Kamchatka, Marshall Islands'                => '(UTC + 12:00) Fiji',
                );

    return ($mlook{$umt}) if defined $mlook{$umt};
    return 0;
}

sub utc_to_umt {
    my ($utc) = @_;
    my %mlook = (
                 '(UTC - 12:00)'                                                  => '(UMT - 12:00) Eniwetok, Kwajalein',
                 '(UTC - 11:00) Midway Island, Samoa'                             => '(UMT - 11:00) Midway Island, Samoa',
                 '(UTC - 10:00) Hawaii'                                           => '(UMT - 10:00) Hawaii',
                 '(UTC - 9:00) Alaska'                                            => '(UMT - 9:00) Alaska',
                 '(UTC - 8:00) Pacific Time (US and Canada), Tijuana'             => '(UMT - 8:00) Pacific Time (US and Canada), Tijuana',
                 '(UTC - 7:00) Arizona'                                           => '(UMT - 7:00) Arizona',
                 '(UTC - 7:00) Mountain Time (US and Canada)'                     => '(UMT - 7:00) Mountain Time (US and Canada)',
                 '(UTC - 6:00) Central Time (US and Canada)'                      => '(UMT - 6:00) Central Time (US and Canada)',
                 '(UTC - 6:00) Mexico City, Tegucigalpa'                          => '(UMT - 6:00) Mexico City, Tegucigalpa',
                 '(UTC - 6:00) Saskatchewan'                                      => '(UMT - 6:00) Saskatchewan',
                 '(UTC - 5:00) Bogota, Lima, Quito'                               => '(UMT - 5:00) Bogota, Lima, Quito',
                 '(UTC - 5:00) Eastern Time (US and Canada)'                      => '(UMT - 5:00) Eastern Time (US and Canada)',
                 '(UTC - 5:00) Indiana (East)'                                    => '(UMT - 5:00) Indiana (East)',
                 '(UTC - 4:00) Atlantic Time (Canada)'                            => '(UMT - 4:00) Atlantic Time (Canada)',
                 '(UTC - 4:00) Caracas'                                           => '(UMT - 4:00) Caracas, La Paz',
                 '(UTC - 4:00) Santiago'                                          => '(UMT - 4:00) Santiago',
                 '(UTC - 3:30) Newfoundland'                                      => '(UMT - 3:30) Newfoundland',
                 '(UTC - 3:00) Brasilia'                                          => '(UMT - 3:00) Brasilia',
                 '(UTC - 3:00) Buenos Aires'                                      => '(UMT - 3:00) Buenos Aires, Georgetown',
                 '(UTC - 2:00) Mid-Atlantic'                                      => '(UMT - 2:00) Mid-Atlantic',
                 '(UTC - 1:00) Azores'                                            => '(UMT - 1:00) Azores, Cape Verde Islands',
                 '(UTC) Casablanca'                                               => '(UMT) Casablanca, Monrovia',
                 '(UTC) Coordinated Universal Time'                               => '(UMT) Universal Mean Time, Dublin, Edinburgh, Lisbon, London',
                 '(UTC) Dublin'                                                   => '(UMT) Universal Mean Time, Dublin, Edinburgh, Lisbon, London',
                 '(UTC) Lisbon'                                                   => '(UMT) Universal Mean Time, Dublin, Edinburgh, Lisbon, London',
                 '(UTC) London'                                                   => '(UMT) Universal Mean Time, Dublin, Edinburgh, Lisbon, London',
                 '(UTC + 1:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna'  => '(UMT + 1:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna',
                 '(UTC + 1:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague' => '(UMT + 1:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague',
                 '(UTC + 1:00) Brussels, Copenhagen, Madrid, Paris'               => '(UMT + 1:00) Brussels, Copenhagen, Madrid, Paris, Vilnius',
                 '(UTC + 1:00) Sarajevo, Skopje, Sofija, Warsaw, Zagreb'          => '(UMT + 1:00) Sarajevo, Skopje, Sofija, Warsaw, Zagreb',
                 '(UTC + 2:00) Athens, Vilnius'                                   => '(UMT + 2:00) Athens, Istanbul, Minsk',
                 '(UTC + 2:00) Bucharest'                                         => '(UMT + 2:00) Bucharest',
                 '(UTC + 2:00) Cairo'                                             => '(UMT + 2:00) Cairo',
                 '(UTC + 2:00) Harare'                                            => '(UMT + 2:00) Harare, Pretoria',
                 '(UTC + 2:00) Helsinki'                                          => '(UMT + 2:00) Helsinki, Riga, Tallinn',
                 '(UTC + 2:00) Jerusalem'                                         => '(UMT + 2:00) Jerusalem',
                 '(UTC + 3:00) Baghdad, Istanbul, Kuwait, Minsk, Riyadh'          => '(UMT + 3:00) Baghdad, Kuwait, Riyadh',
                 '(UTC + 3:00) Moscow, St    .   Petersburg, Volgograd'           => '(UMT + 3:00) Moscow, St. Petersburg, Volgograd',
                 '(UTC + 3:00) Nairobi'                                           => '(UMT + 3:00) Nairobi',
                 '(UTC + 3:30) Tehran'                                            => '(UMT + 3:30) Tehran',
                 '(UTC + 4:00) Dubai'                                             => '(UMT + 4:00) Abu Dhabi, Muscat',
                 '(UTC + 4:00) Baku'                                              => '(UMT + 4:00) Baku, Tbilisi',
                 '(UTC + 4:30) Kabul'                                             => '(UMT + 4:00) Kabul',
                 '(UTC + 5:00) Ekaterinburg'                                      => '(UMT + 5:00) Ekaterinburg',
                 '(UTC + 5:00) Islamabad, Karachi'                                => '(UMT + 5:00) Islamabad, Karachi, Tashkent',
                 '(UTC + 5:30) Bombay, Calcutta, Madras, New Delhi'               => '(UMT + 5:30) Bombay, Calcutta, Madras, New Delhi',
                 '(UTC + 6:00) Dhaka'                                             => '(UMT + 6:00) Astana, Almaty, Dhaka',
                 '(UTC + 5:30) Colombo'                                           => '(UMT + 6:00) Colombo',
                 '(UTC + 6:30) Rangoon'                                           => '(UMT + 6:30) Rangoon',
                 '(UTC + 7:00) Bangkok, Hanoi'                                    => '(UMT + 7:00) Bangkok, Hanoi, Jakarta',
                 '(UTC + 8:00) Beijing, Chongqing, Shanghai'                      => '(UMT + 8:00) Beijing, Chongqing, Hong Kong, Urumqi',
                 '(UTC + 8:00) Hong Kong'                                         => '(UMT + 8:00) Beijing, Chongqing, Hong Kong, Urumqi',,
                 '(UTC + 8:00) Perth'                                             => '(UMT + 8:00) Perth',
                 '(UTC + 8:00) Singapore'                                         => '(UMT + 8:00) Singapore',
                 '(UTC + 8:00) Taipei'                                            => '(UMT + 8:00) Taipei',
                 '(UTC + 9:00) Osaka, Sapporo, Tokyo'                             => '(UMT + 9:00) Osaka, Sapporo, Tokyo',
                 '(UTC + 9:00) Seoul'                                             => '(UMT + 9:00) Seoul',
                 '(UTC + 9:30) Adelaide'                                          => '(UMT + 9:30) Adelaide',
                 '(UTC + 9:30) Darwin'                                            => '(UMT + 9:30) Darwin',
                 '(UTC + 10:00) Brisbane'                                         => '(UMT + 10:00) Brisbane',
                 '(UTC + 10:00) Canberra, Sydney'                                 => '(UMT + 10:00) Canberra, Melbourne, Sydney',
                 '(UTC + 10:00) Melbourne, Victoria'                              => '(UMT + 10:00) Canberra, Melbourne, Sydney',
                 '(UTC + 10:00) Guam'                                             => '(UMT + 10:00) Guam, Port Moresby',
                 '(UTC + 10:00) Hobart'                                           => '(UMT + 10:00) Hobart',
                 '(UTC + 10:00) Vladivostok'                                      => '(UMT + 10:00) Vladivostok',
                 '(UTC + 11:00) Magadan'                                          => '(UMT + 11:00) Magadan, Solomon Islands, New Caledonia',
                 '(UTC + 11:00) Solomon Islands'                                  => '(UMT + 11:00) Magadan, Solomon Islands, New Caledonia',
                 '(UTC + 12:00) Auckland'                                         => '(UMT + 12:00) Auckland, Wellington',
                 '(UTC + 12:00) Fiji'                                             => '(UMT + 12:00) Fiji, Kamchatka, Marshall Islands',
                 '(UTC + 12:00) Marshall Islands'                                 => '(UMT + 12:00) Fiji, Kamchatka, Marshall Islands',
                );

    return ($mlook{$utc}) if defined $mlook{$utc};
    return 0;
}

sub cidr_to_mask {
    my ($cidr) = @_;

    return undef unless $cidr;

    my %mlook = (
        1  => '128.0.0.0',
        2  => '192.0.0.0',
        3  => '224.0.0.0',
        4  => '240.0.0.0',
        5  => '248.0.0.0',
        6  => '252.0.0.0',
        7  => '254.0.0.0',
        8  => '255.0.0.0',
        9  => '255.128.0.0',
        10 => '255.192.0.0',
        11 => '255.224.0.0',
        12 => '255.240.0.0',
        13 => '255.248.0.0',
        14 => '255.252.0.0',
        15 => '255.254.0.0',
        16 => '255.255.0.0',
        17 => '255.255.128.0',
        18 => '255.255.192.0',
        19 => '255.255.224.0',
        20 => '255.255.240.0',
        21 => '255.255.248.0',
        22 => '255.255.252.0',
        23 => '255.255.254.0',
        24 => '255.255.255.0',
        25 => '255.255.255.128',
        26 => '255.255.255.192',
        27 => '255.255.255.224',
        28 => '255.255.255.240',
        29 => '255.255.255.248',
        30 => '255.255.255.252',
        31 => '255.255.255.254',
        32 => '255.255.255.255',
    );

    return ($mlook{$cidr});
}

sub mask_to_bits {
    my ($mask) = @_;
    my %mlook = (
        "128.0.0.0"       => "1",
        "192.0.0.0"       => "2",
        "224.0.0.0"       => "3",
        "240.0.0.0"       => "4",
        "248.0.0.0"       => "5",
        "252.0.0.0"       => "6",
        "254.0.0.0"       => "7",
        "255.0.0.0"       => "8",
        "255.128.0.0"     => "9",
        "255.192.0.0"     => "10",
        "255.224.0.0"     => "11",
        "255.240.0.0"     => "12",
        "255.248.0.0"     => "13",
        "255.252.0.0"     => "14",
        "255.254.0.0"     => "15",
        "255.255.0.0"     => "16",
        "255.255.128.0"   => "17",
        "255.255.192.0"   => "18",
        "255.255.224.0"   => "19",
        "255.255.240.0"   => "20",
        "255.255.248.0"   => "21",
        "255.255.252.0"   => "22",
        "255.255.254.0"   => "23",
        "255.255.255.0"   => "24",
        "255.255.255.128" => "25",
        "255.255.255.192" => "26",
        "255.255.255.224" => "27",
        "255.255.255.240" => "28",
        "255.255.255.248" => "29",
        "255.255.255.252" => "30",
        "255.255.255.254" => "31",
        "255.255.255.255" => "32",
    );

    return $mask if $mask =~ /^\d+$/;

	if ($mask) {
		return ($mlook{$mask});
	}
	else {
		return;
	}
}

sub cidr_to_arpa {

    my ($address) = shift;
    my $return_value = undef;

    if ($address =~ /([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})\/(\d+)/)
    {
        my ($network) = $1;
        my ($netmask) = $2;
        my @bits          = split /\./, $network;
        my @reversed_bits = reverse @bits;
        my $num           = $netmask / 8;

        if ($num == 1) {
            $return_value = $reversed_bits[3];
        } elsif ($num == 2) {
            $return_value = join '.', $reversed_bits[2], $reversed_bits[3];
        } elsif ($num >= 3) {
            $return_value = join '.', $reversed_bits[1], $reversed_bits[2],
                $reversed_bits[3];
        }

        $return_value = $return_value . ".in-addr.arpa";
        return $return_value;
    } else {
        return $address;
    }
}

sub cidr_to_network {
    my $address      = shift;
    my $return_value = undef;

    if ($address =~ /([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})\/(\d+)/)
    {
        $return_value = join '/', $1, cidr_to_mask($2);
        return $return_value;
    } else {
        return $address;
    }
}

sub is_ipv6_address
{
    #
    #
    #
    #

    my ($addy,$offset) = @_;
    my ($double_colon_position,$ipv4_position);

    $offset = 0 unless defined $offset;

    #
    $double_colon_position = index($addy,'::');
    $ipv4_position = index($addy,'.');
    if ($double_colon_position != -1) {
        #
        return 0 if rindex($addy,'::') != $double_colon_position;

        if ($ipv4_position != -1) {
            #
            #
            #
            return 0 if $addy =~ y/:/:/ > 6;
        }
        else {
            #
            return 0 if $addy =~ y/:/:/ > 7 - $offset;
        }
    }
    else {
        #
        if ($ipv4_position != -1) {
            return 0 unless $addy =~ y/:/:/ == 6;
        }
        else {
            return 0 unless $addy =~ y/:/:/ == 7 - $offset;
        }
    }

    #
    #
    #
    #
    #
    if ($ipv4_position != -1) {
        $ipv4_position = rindex($addy,':',$ipv4_position) + 1;
        return 0 unless is_ipv4_address(substr($addy,$ipv4_position));

        $addy=substr($addy,0,$ipv4_position);

        #
        #
        #
        return 0 unless is_ipv6_address($addy,2);
        return 1;
    }

    #
    #
    my @quads = split /:/, $addy;
    foreach (@quads) {
        return 0 unless $_ =~ m/^[[:xdigit:]]{0,4}$/;
    }

    return 1;
}

sub is_ipv4_address
{
    my $addy = shift;

    #
    #
    if ($addy =~ m!^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$!) {
        return 0 if $1 > 255 || $2 > 255 || $3 > 255 || $4 > 255;
    }
    else {
        return 0;
    }

    return 1;
}

#
sub is_ipv4_network {
    my $addr = shift;

    my ($ok, $addy, $netmask) = ip_address_munger($addr);
    return 1 if ($ok == 1 && defined $netmask);
    return 0;
}

sub is_ipv6_network {
    my $addr = shift;

    my ($ok, $addy, $netmask) = ip_address_munger($addr);
    return 1 if ($ok == 2 && defined $netmask);
    return 0;
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
#
#
#
#
sub ip_address_munger
{
    my ($address, $munge_netmask, $netmask_default, $error, $session) = @_;
    my ($addy, $netmask, $cidrnetmask);

    #
    my $i = index($address, '/');
    if ( $i == -1) {
        #
        $addy = $address;
    }
    else {
        $addy = substr($address,0,$i);
        $netmask = substr($address,$i+1);

        #
        unless ($netmask =~ m/^\d{1,3}$/ || ($cidrnetmask=is_ipv4_address($netmask))) {
            set_error_codes(1104,'Invalid netmask: '.$netmask . ' in ' . $address,$session) if $error;
            return (0);
        }
    }

    #
    #
    #
    #
    #
    #
    if (is_ipv4_address($addy)) {
        if ($netmask && !($cidrnetmask) && ($netmask < 1 || $netmask > 32)) {
            set_error_codes(1104,'Invalid netmask: '.$netmask . ' in ' . $address,$session) if $error;
            return (0);
        }

        if ($munge_netmask) {
            if ($netmask) {
                if ($munge_netmask eq 'cidr') {
                    if ($cidrnetmask) {
                        my $t = mask_to_bits($netmask);
                        unless ($t) {
                            set_error_codes(1104,'Invalid netmask: '.$netmask . ' in ' . $address,$session) if $error;
                            return (0);
                        }
                        $netmask = $t;
                    }
                } else {
                    my $t = cidr_to_mask($netmask);
                    $netmask = $t if defined $t;
                }
            }
            else {
                $netmask = '255.255.255.255' if $netmask_default;
            }
        }

        return (1, $addy, $netmask);
    }

    if (is_ipv6_address($addy)) {
        #
        if ($netmask && ($cidrnetmask || ($netmask < 0 || $netmask > 128))) {
            set_error_codes(1104,'Invalid netmask: '.$netmask . ' in ' . $address,$session) if $error;
            return (0);
        }

        if ($netmask_default) {
            $netmask = '128' unless $netmask;
        }

        return (2, $addy, $netmask);
    }

    set_error_codes(1104,'Invalid IP address: '. $address,$session) if $error;
    return (0);
}

#
#
#
sub split_network_netmask {
    my $addr=shift;
    my $session=shift;
    my $cidr = shift;

    if ($cidr) {
        $cidr = 0;
    }
    else {
        $cidr = 1;
    }

    my ($ok, $addy, $netmask) = ip_address_munger($addr, $cidr, 1, 1, $session);
    return undef unless $ok;

    return ($addy, $netmask);
}

my %options_by_name_dhcp = (
                            'subnet-mask'                            => 1,
                            'time-offset'                            => 2,
                            'routers'                                => 3,
                            'time-servers'                           => 4,
                            'ien116-name-servers'                    => 5,
                            'domain-name-servers'                    => 6,
                            'log-servers'                            => 7,
                            'cookie-servers'                         => 8,
                            'lpr-servers'                            => 9,
                            'impress-servers'                        => 10,
                            'resource-location-servers'              => 11,
                            'host-name'                              => 12,
                            'boot-size'                              => 13,
                            'merit-dump'                             => 14,
                            'domain-name'                            => 15,
                            'swap-server'                            => 16,
                            'root-path'                              => 17,
                            'extensions-path'                        => 18,
                            'ip-forwarding'                          => 19,
                            'non-local-source-routing'               => 20,
                            'policy-filter'                          => 21,
                            'max-dgram-reassembly'                   => 22,
                            'default-ip-ttl'                         => 23,
                            'path-mtu-aging-timeout'                 => 24,
                            'path-mtu-plateau-table'                 => 25,
                            'interface-mtu'                          => 26,
                            'all-subnets-local'                      => 27,
                            'broadcast-address'                      => 28,
                            'perform-mask-discovery'                 => 29,
                            'mask-supplier'                          => 30,
                            'router-discovery'                       => 31,
                            'router-solicitation-address'            => 32,
                            'static-routes'                          => 33,
                            'trailer-encapsulation'                  => 34,
                            'arp-cache-timeout'                      => 35,
                            'ieee802-3-encapsulation'                => 36,
                            'default-tcp-ttl'                        => 37,
                            'tcp-keepalive-interval'                 => 38,
                            'tcp-keepalive-garbage'                  => 39,
                            'nis-domain'                             => 40,
                            'nis-servers'                            => 41,
                            'ntp-servers'                            => 42,
                            'vendor-encapsulated-options'            => 43,
                            'netbios-name-servers'                   => 44,
                            'netbios-dd-server'                      => 45,
                            'netbios-node-type'                      => 46,
                            'netbios-scope'                          => 47,
                            'font-servers'                           => 48,
                            'x-display-manager'                      => 49,
                            'dhcp-requested-address'                 => 50,
                            'dhcp-lease-time'                        => 51,
                            'dhcp-option-overload'                   => 52,
                            'dhcp-message-type'                      => 53,
                            'dhcp-server-identifier'                 => 54,
                            'dhcp-parameter-request-list'            => 55,
                            'dhcp-message'                           => 56,
                            'dhcp-max-message-size'                  => 57,
                            'dhcp-renewal-time'                      => 58,
                            'dhcp-rebinding-time'                    => 59,
                            'vendor-class-identifier'                => 60,
                            'dhcp-client-identifier'                 => 61,
                            'nwip-domain'                            => 62,
                            'nwip-suboptions'                        => 63,
                            'nisplus-domain'                         => 64,
                            'nisplus-servers'                        => 65,
                            'tftp-server-name'                       => 66,
                            'bootfile-name'                          => 67,
                            'mobile-ip-home-agent'                   => 68,
                            'smtp-server'                            => 69,
                            'pop-server'                             => 70,
                            'nntp-server'                            => 71,
                            'www-server'                             => 72,
                            'finger-server'                          => 73,
                            'irc-server'                             => 74,
                            'streettalk-server'                      => 75,
                            'streettalk-directory-assistance-server' => 76,
                            'user-class'                             => 77,
                            'slp-directory-agent'                    => 78,
                            'slp-service-scope'                      => 79,
                            'fqdn'                                   => 81,
                            'relay-agent-information'                => 82,
                            'nds-servers'                            => 85,
                            'nds-tree-name'                          => 86,
                            'nds-context'                            => 87,
                            'bcms-controller-address'                => 89,
                            'client-last-transaction-time'           => 91,
                            'uap-servers'                            => 98,
                            'netinfo-server-address'                 => 112,
                            'netinfo-server-tag'                     => 113,
                            'default-url'                            => 114,
                            'subnet-selection'                       => 118,
                            'vivco'                                  => 124,
                            'vivso'                                  => 125,
                            'authenticate'                           => 210,
                           );

my %options_by_name_dhcpv6 = (
                            'dhcp6.server-id'             => 2,
                            'dhcp6.preference'            => 7,
                            'dhcp6.unicast'               => 12,
                            'dhcp6.rapid-commit'          => 14,
                            'dhcp6.sip-servers-names'     => 21,
                            'dhcp6.sip-servers-addresses' => 22,
                            'dhcp6.name-servers'          => 23,
                            'dhcp6.domain-search'         => 24,
                            'dhcp6.nis-servers'           => 27,
                            'dhcp6.nisp-servers'          => 28,
                            'dhcp6.nis-domain-name'       => 29,
                            'dhcp6.nisp-domain-name'      => 30,
                            'dhcp6.sntp-servers'          => 31,
                            'dhcp6.info-refresh-time'     => 32,
                            'dhcp6.bcms-server-d'         => 33,
                            'dhcp6.bcms-server-a'         => 34,
                            'dhcp6.fqdn'                  => 39,
                           );

my %options_by_num_dhcp = reverse %options_by_name_dhcp;
my %options_by_num_dhcpv6 = reverse %options_by_name_dhcpv6;

sub get_custom_option_name {
    my ($num, $space) = @_;
    my $tableref;

    if ($space eq 'DHCPv6') {
        $tableref = \%options_by_num_dhcpv6;
    } elsif ($space eq 'DHCP') {
        $tableref = \%options_by_num_dhcp;
    }
    else {
        #
        #
        return undef;
    }

    #
    if ($num =~ m/^(\d+)/ || $num =~ m/option\s*(\d+)/i) {
        $num = $1;
    }
    else {
        #
        #
        return undef;
    }

    my $result = $tableref->{$num};
    unless ($result) {
        if ($num > 0 && $num < 255) {
            #
            #
            $result = 'option-' . $num;
        }
    }
    return $result;
}

sub get_custom_option_num
{
    my ($name, $space) = @_;
    my $tableref;

    if ($space eq 'DHCPv6') {
        $tableref = \%options_by_name_dhcpv6;
    } elsif ($space eq 'DHCP') {
        $tableref = \%options_by_name_dhcp;
    }
    else {
        #
        #
        return undef;
    }

    #
    $name = lc($name);

    my $result = $tableref->{$name};
    unless ($result) {
        if ($name =~ m/^option-(\d+)$/) {
            $result = $1;

            #
            if ($result < 1 || $result > 254) {
                $result = undef;
            }
        }
    }
    return $result;
}

sub trim
{
        my $string = shift;
        $string =~ s/^\s+//;
        $string =~ s/\s+$//;
        return $string;
}

sub boolean_to_lowercase {
    my $property = shift;
    if ($property =~ m/^true$/i) {
        $property = lc($property);
    }
    if ($property =~ m/^false$/i) {
        $property = lc($property);
    }

	$property = trim ($property);

    return $property;
}

sub is_in_array {
    my ($types, $element) = @_;
    my @type_list = @{$types};
    foreach my $type (@type_list) {
        if (ref($element) eq $type) {
            return 1;
        } elsif ($type eq "Infoblox::DNS::string_object"
            or $type eq "Infoblox::GUI::one::util::string_object")
        {
            if (not ref($element)) {
                return 1;
            }
        }
    }
    return;
}

sub check_vector_type {
    my ($array, $types) = @_;

    my @real_array = @{$array};

    foreach my $element (@real_array) {
        my $reference_type = ref($element);
        if (not is_in_array($types, $element)) {
            return;
        }
    }

    return 1;
}

sub check_object_type {
    my ($object, $types) = @_;

    my @type_list = @{$types};
    foreach my $type (@type_list) {
        if (ref($object) =~ /^(ib:)?${type}$/) {
            return 1;
        } elsif ($type eq "Infoblox::DNS::string_object") {
            if (not ref($object)) {
                return 1;
            }
        }
    }

    return;
}

#
sub get_local_timezone_offset
{
    my $str_offset=shift;
    my $int_offset=undef;

    if ($str_offset eq 'Z')
    {
        $int_offset = 0;
    }
    elsif ($str_offset =~ /^([-+])(\d{2}):(\d{2})$/)
    {
        $int_offset=int($2)*3600 + int($3)*60;

        if ($1 eq '-')
        {
            $int_offset*=-1;
        }
    }

    return $int_offset
}


sub ibap_value_o2i_boolean {
	my ($value_in, $field, $session, $validateonly) = @_;
	my $value;

#
#
#
#

	if (($value_in =~ m/^false$/i) || ($value_in eq '0')) {
        return 1 if $validateonly;
		$value = tBool(0);
	} elsif (($value_in =~ m/^true$/i) || ($value_in eq '1')) {
        return 1 if $validateonly;
		$value = tBool(1);
	} else {
		set_error_codes(1104,'Invalid boolean value (' . $value_in . ') for boolean field ' . (defined($field) ? $field : '') ,$session);
	}
	return $value;
}

sub ibap_value_o2i_boolean_reverse {
    my ($value_in, $field, $session, $validateonly) = @_;
    my $value;

    if (($value_in =~ m/^false$/i) || ($value_in eq '0')) {
        return 1 if $validateonly;
        $value = tBool(1);
    } elsif (($value_in =~ m/^true$/i) || ($value_in eq '1')) {
        return 1 if $validateonly;
        $value = tBool(0);
    } else {
        set_error_codes(1104,'Invalid boolean value (' . $value_in . ') for boolean field ' . (defined($field) ? $field : '') ,$session);
    }
    return $value;
}

sub ibap_value_i2o_boolean {
	my $value_in=shift;
	my $value;

	if (defined($value_in) && $value_in == 1) {
		$value='true';
	}
	else {
		$value='false';
	}

	return $value;
}

sub ibap_i2o_object_name
{
    my ($self, $session, $current, $ibap_object_ref) = @_;

	return $$ibap_object_ref{$current}{'name'};
}

sub ibap_i2o_object_category_name
{
    my ($self, $session, $current, $ibap_object_ref) = @_;

	return $ibap_object_ref->{$current}->{'name'};
}

sub ibap_i2o_object_list_names
{
    my ($self, $session, $current, $ibap_object_ref) = @_;

    my @names;
    if ($$ibap_object_ref{$current}) {
        foreach (@{$$ibap_object_ref{$current}}) {
            push @names, $_->{'name'}
        }
    }
    return \@names;
}

sub ibap_i2o_grid_name_and_id
{
    my ($self, $session, $current, $ibap_object_ref) = @_;

    $self->{'grid_id'} = $$ibap_object_ref{$current}{'id'};
	return $$ibap_object_ref{$current}{'name'};
}

sub ibap_i2o_boolean
{
	my ($self, $session, $current, $tempref) = @_;

	return ibap_value_i2o_boolean(${$tempref}{$current});
}

sub ibap_i2o_boolean_reverse
{
    return ibap_i2o_boolean(@_) eq 'true' ? 'false' : 'true';
}

sub generate_special_object_member_cache_key
{
	my $object = shift;

	return (defined($object->name()) ? $object->name() : '').'$$'.(defined($object->ipv4addr()) ? $object->ipv4addr() : '').'$$'.(defined($object->ipv6addr()) ? $object->ipv6addr() : '')
}

sub generate_special_object_msserver_cache_key
{
	my $object = shift;

    #
    if ($object->can('address')) {
        return '$$$$MSSERVER$$$$' . $object->address();
    }
    else {
        return '$$$$MSSERVER$$$$' . $object->{'ms_server'}->{'address'};
    }
}

#
sub ibap_object_member_server_convert
{
	my ($object, $construct_from, $session) = @_;

    my $membertemp = Infoblox::DNS::Member->__new__();
    $membertemp->__ibap_to_object__($construct_from, $session->get_ibap_server(), $session);

	$object->{__object_id_cache__}{generate_special_object_member_cache_key($membertemp)} =
	  ${${$construct_from}{'grid_member'}{'object_id'}}{'id'};

	return $membertemp;
}

sub ibap_value_o2i_member_nocache
{
	my ($member, $session, $fieldname, $match_name) = @_;
    my (%search_arg, @search_request,$tfield);
    my ($ipv4addr, $ipv6addr, $member_name);

    if(ref($member)){
          $ipv4addr=$member->ipv4addr() if $member->ipv4addr();
          $ipv6addr=$member->ipv6addr() if $member->ipv6addr();
          $member_name=$member->name()  if $member->name();
    }else{
          $ipv4addr=$member if (is_ipv4_address($member));
          $ipv6addr=$member if (is_ipv6_address($member));
          $member_name=$member if(!($ipv4addr || $ipv6addr));
    }

    if ($ipv4addr) {
        push @search_request,
          {
           field       => 'vip_setting',
           search_type => 'EXACT',
           value       => tIBType('SubMatch',
                                  {
                                   search_fields =>
                                   [
                                    {
                                     field => 'address',
                                     value => ibap_value_o2i_string($ipv4addr,'address',$session)
                                    }
                                   ]
                                  }
                                 )
          };

        $tfield='1012='.$fieldname.'='.$ipv4addr;
    }

    if ($ipv6addr) {
        push @search_request,
          {
           field       => 'ipv6_setting',
           search_type => 'EXACT',
           value       => tIBType('SubMatch',
                                  {
                                   search_fields =>
                                   [
                                    {
                                     field => 'virtual_ip',
                                     value => ibap_value_o2i_string($ipv6addr,'virtual_ip',$session)
                                    }
                                   ]
                                  }
                                 )
          };

        #
        $tfield='1012='.$fieldname.'='.$ipv6addr;
    }

    #
    #
    #
    #
    #
    if ($member_name && ($match_name || not defined $tfield)) {
        #

        push @search_request,
          {
           field       => 'host_name',
           search_type => 'EXACT',
           value       => ibap_value_o2i_string(lc($member_name),'name',$session)
          };

        #
        $tfield='1012='.$fieldname.'='.$member_name;
    }

    $search_arg{'object_type'} = 'Member';
    $search_arg{'error_tag'} = ibap_value_o2i_string($tfield);
    $search_arg{'search_fields'} = \@search_request;

    return tIBType('Member', {'readfield_substitution' => tIBType('ReadField', \%search_arg)});
}

sub ibap_arg_zone_convert
{
    my ($session, $current, $tempref)=@_;
    my ($name, $view, @fields);

    if (ref( $$tempref{$current} ) eq "Infoblox::DNS::Zone") {
        if ($$tempref{$current}->__object_id__()) {
            return tObjIdRef($$tempref{$current}->__object_id__());
        }
        $name = $$tempref{$current}->name();
        if (defined $$tempref{$current}->views() && ref($$tempref{$current}->views()) eq 'ARRAY' && @{$$tempref{$current}->views()}[0]->name()) {
            $view=@{$$tempref{$current}->views()}[0]->name();
        }
    }
    else {
        $name = $$tempref{$current};
        $view = $tempref->{'view'};
    }

    unless ($name) {
        set_error_codes(1012, "You must specify a name for the zone to be searched on", $session);
        return undef;
    }

    push @fields,
      {
       'search_type' => 'EXACT',
       'field' => 'fqdn',
       'value' => ibap_value_o2i_string($name),
      };

    if ($view) {
        if(ref($view) eq "Infoblox::DNS::View")
        {
          $view=$view->name();
        }
        push @fields,
          {
           'search_type' => 'EXACT',
           'field' => 'view',
           'value' => ibap_readfield_simple_string('View','name',$view,'view')
          };
    }
    else {
        push @fields,
          {
           'search_type' => 'EXACT',
           'field' => 'view',
           'value' => ibap_readfield_simple('View','is_default',tBool(1),'view=(default view)')
          };
    }

    return ibap_readfield_simple('AllZone', \@fields, undef, 'zone=' . $name);

}

sub ibap_o2i_zone_list
{
    my ($self, $session, $current, $tempref) = @_;

    if ($$tempref{$current}) {
        my @zones;
        my @list=@{$$tempref{$current}};

        foreach my $t (@list) {
            my $zone_readfield=ibap_arg_zone_convert($session,'temp',{temp => $t});
            return (0) unless $zone_readfield;

            push @zones, $zone_readfield;
        }
        return (1,0, tIBType('ib:ArrayOfBaseObject', \@zones));
    }
    else {
        return (1,0,undef);
    }
}

sub ibap_o2i_rir_organization
{
    my ($self, $session, $current, $tempref) = @_;

    if ($$tempref{$current}->__object_id__()) {
        return (1,0,tObjIdRef($$tempref{$current}->__object_id__()));
    } elsif ($$tempref{$current}->{'id'}) {
        return (1, 0, ibap_readfield_simple_string('rir_organization', 'id', $$tempref{$current}->{'id'}));
    }

    set_error_codes(1012, 'The '.ref($$tempref{$current})." object must be retrieved from the appliance or 'id' member must be defined before setting it in $current in object ".ref($self));
    return (0);
}


#
sub ibap_value_o2i_member
{
	my ($member, $session, $object, $fieldname, $match_name) = @_;
	my $oid_key = generate_special_object_member_cache_key($member);

    $match_name = 0 unless defined $match_name;
	if (defined($object->{__object_id_cache__}) && $object->{__object_id_cache__}{$oid_key}) {
        return tObjIdRef($object->{__object_id_cache__}{$oid_key});
	} else {
        return ibap_value_o2i_member_nocache($member, $session, $fieldname, $match_name);
	}
}

sub ibap_value_o2i_dns_msserver_convert
{
	my ($msserver, $session, $object, $fieldname) = @_;
	my $oid_key = generate_special_object_msserver_cache_key($msserver);

    #
    #
    #

    my $serialized = ibap_serialize_substruct($session,$msserver,$fieldname);
	if ($object->{__object_id_cache__}{$oid_key}) {
        #
        #
        if (defined $serialized && defined $$serialized{'val'} && defined $$serialized{'val'}{'ms_server'}) {
            $$serialized{'val'}{'ms_server'} = tObjIdRef($object->{__object_id_cache__}{$oid_key});
        }
	}
    return $serialized;
}

my %member_server_fields = (
    'enable_preferred_primaries' => 1,
    'preferred_primaries'        => 1,
    'grid_replicate'             => 1,
    'grid_member'                => 1,
    'stealth'                    => 1,
    'lead'                       => 1,
);

#
sub ibap_value_o2i_member_server
{
	my ($member, $session, $object, $fieldname) = @_;

    #
    #
    if (defined $object->{'__object_id_cache__'} and defined $object->{'__object_id_cache__'}->{generate_special_object_member_cache_key($member)}) {
        $member->{'__object_id_cache__'} = $object->{'__object_id_cache__'};
    }

    my $write_fields = $member->__object_to_ibap__($session->get_ibap_server(), $session);
    return unless $write_fields;

    my %sub_write_arg;

    $sub_write_arg{'grid_replicate'} = tBool(1); # by default it should be true

    foreach my $item (@$write_fields) {
        next unless $member_server_fields{$item->{'field'}};
        $sub_write_arg{$item->{'field'}} = $item->{'value'};
    }

    #
    $sub_write_arg{'grid_replicate'} = tBool(0) if ($object->can('__zone_type_from_object__') and $object->__zone_type_from_object__() eq 'ResponsePolicyZone');

    return tIBType('member_server', \%sub_write_arg);
}

sub ibap_i2o_tsig_ac_list
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        my @keys_list = @{$$ibap_object_ref{$current}};

        foreach my $key (@keys_list) {
            push @newlist, ibap_object_tsig_ac_convert($key,'',$session);
        }
        return \@newlist;
    } else {
        return [];
    }
}

sub ibap_o2i_tsig_ac_list
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if ( $$tempref{$current}) {
        my @keys_list=@{$$tempref{$current}};

        push @return_args, 1;
        push @return_args, 0;
        if (@keys_list) {
            my @newlist;

            foreach my $key (@keys_list) {
                push @newlist, ibap_value_o2i_tsig_ac($key,'',$session);
            }

            push @return_args, tIBType('ArrayOftsig_ac', \@newlist);
        }
        else
        {
            push @return_args, tIBType('ArrayOftsig_ac', []);
        }
    }
    else
    {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;

}

sub ibap_unwrapped_tsig_ac_convert
{
#
	my ($key, $field, $session) = @_;

	my %sub_write_arg;

	if ($key->key() && $key->key() eq ':2xCOMPAT') {
		$sub_write_arg{'use_2x_tsig_key'} = tBool(1);
	} else {
		$sub_write_arg{'tsig_key'} = $key->key();
	}
    $sub_write_arg{'tsig_key_alg'} = $key->algorithm();
	$sub_write_arg{'tsig_key_name'} = $key->name();

	return \%sub_write_arg;
}

sub ibap_object_tsig_ac_convert
{
	my ($key, $field, $session) = @_;

	if (defined ${$key}{'use_2x_tsig_key'} && ${$key}{'use_2x_tsig_key'} == 1) {
		return Infoblox::DNS::TSIGKey->new ( "name" => ${$key}{'tsig_key_name'},
													 "key"  => ":2xCOMPAT");
	} else {
		return Infoblox::DNS::TSIGKey->new ( "name" => ${$key}{'tsig_key_name'},
													 "key"  => ${$key}{'tsig_key'}, "algorithm" => ${$key}{'tsig_key_alg'});
	}
}

sub ibap_value_o2i_tsig_ac
{
	my ($key, $field, $session) = @_;
	return tIBType('tsig_ac', ibap_unwrapped_tsig_ac_convert($key, $field, $session));
}

sub ibap_i2o_address_ac_list
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        my @nodes_list = @{$$ibap_object_ref{$current}};

        foreach my $addy (@nodes_list) {
            push @newlist, ibap_value_i2o_address_ac($addy,'',$session);
        }
        return \@newlist;
    } else {
        return [];
    }
}

sub ibap_i2o_ac_setting
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($ibap_object_ref->{$current}) {
        if ($ibap_object_ref->{$current}->{'acl_type'}) {
            if ($ibap_object_ref->{$current}->{'acl_type'} eq 'LIST' and $ibap_object_ref->{$current}->{'ac_list'}) {
                return ibap_i2o_mixed_ac_list($self, $session, 'ac_list', $ibap_object_ref->{$current}, $return_object_cache_ref);
            } elsif ($ibap_object_ref->{$current}->{'acl_type'} eq 'DEFINED_ACL' and $ibap_object_ref->{$current}->{'defined_acl'}) {
                my $obj = Infoblox::Grid::NamedACL->__new__();
                $obj->__ibap_to_object__($ibap_object_ref->{$current}->{'defined_acl'}, $session->get_ibap_server(), $session, $return_object_cache_ref);
                $obj->{'__partial__'} = 1;
                return $obj;
            }
        }
    }

    return [];
}

sub ibap_i2o_ntp_ac_setting
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($ibap_object_ref->{$current}) {
        if ($ibap_object_ref->{$current}->{'acl_type'}) {
            if ($ibap_object_ref->{$current}->{'acl_type'} eq 'LIST' and $ibap_object_ref->{$current}->{'ac_list'}) {
                return ibap_i2o_generic_object_list_convert($self, $session, 'ac_list', $ibap_object_ref->{$current}, $return_object_cache_ref);
            } elsif ($ibap_object_ref->{$current}->{'acl_type'} eq 'DEFINED_ACL' and $ibap_object_ref->{$current}->{'defined_acl'}) {
                my $obj = Infoblox::Grid::NamedACL->__new__();
                $obj->__ibap_to_object__($ibap_object_ref->{$current}->{'defined_acl'}, $session->get_ibap_server(), $session, $return_object_cache_ref);
                $obj->{'__partial__'} = 1;
                $self->ntp_service_type($ibap_object_ref->{$current}->{'service'} eq 'TIME' ? 'Time' : 'Time and NTP control') if $ibap_object_ref->{$current}->{'service'};
                return $obj;
            } elsif ($ibap_object_ref->{$current}->{'acl_type'} eq 'NONE') {
                return [];
            }
        }
    }

    return undef;
}

sub ibap_i2o_mixed_ac
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if (ref($ibap_object_ref->{$current}) eq 'ib:address_tsig_ac') {
        if ($ibap_object_ref->{$current}->{'address_ac'}) {
            return ibap_value_i2o_address_ac($ibap_object_ref->{$current}->{'address_ac'}, '', $session);
        } elsif ($ibap_object_ref->{$current}->{'tsig_ac'}) {
            return ibap_object_tsig_ac_convert($ibap_object_ref->{$current}->{'tsig_ac'}, '', $session);
        } elsif ($ibap_object_ref->{$current}{'defined_ac'}) {
            return ibap_i2o_generic_object_convert_partial($self, $session, 'defined_ac', $ibap_object_ref->{$current}, $return_object_cache_ref);
        }
    }

    return undef;
}

sub ibap_i2o_mixed_ac_list
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;
    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        my @nodes_list = @{$$ibap_object_ref{$current}};

        foreach my $addy (@nodes_list) {
            my $res = ibap_i2o_mixed_ac($self, $session, $current, {$current => $addy}, $return_object_cache_ref);
            push @newlist, $res if defined $res;
        }
        return \@newlist;
    } else {
        return [];
    }
}

sub return_fields_address_tsig_ac
{
    return { sub_fields => [
                            tField('address_ac', { sub_fields => [
                                        tField('address_string'),
                                        tField('permission'),
                                       ]},
                                  ),
                            tField('defined_ac', { sub_fields => [
                                        tField('name'),
                                       ]},
                                  ),
                            tField('tsig_ac', { not_exist_ok => 1, sub_fields => [
                                        tField('tsig_key_name'),
                                        tField('tsig_key_alg'),
                                        tField('tsig_key'),
                                        tField('use_2x_tsig_key'),
                                       ]},
                                  ),
                           ],
           };
}

sub return_fields_ac_setting
{
    my $nacl_return_fields = shift; # return fields of Infoblox::Grid::NamedACL object

    return { sub_fields => [
                            tField('ac_list', return_fields_address_tsig_ac()),
                            tField('acl_type'),
                            tField('defined_acl', { sub_fields => [tField('name')] }),
                           ],
           };
}

sub return_fields_ntp_ac_setting
{
    my $nacl_return_fields = shift; # return fields of Infoblox::Grid::NamedACL object
    my $ntp_ac_return_fields = shift; # return fields of Infoblox::Grid::NTPAccess object

    return { sub_fields => [
                            tField('acl_type'),
                            tField('ac_list', { sub_fields => $ntp_ac_return_fields }),
                            tField('defined_acl', { sub_fields => [tField('name')] }),
                            tField('service'),
                           ],
           };
}

sub ibap_i2o_exclusion
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        my @list=@{$$ibap_object_ref{$current}};

        foreach my $excl (@list) {
            push @newlist, Infoblox::DHCP::ExclusionRange->new(
                                                   'comment'        => ${$excl}{'comment'},
                                                   'start_address' => ${$excl}{'start_address'},
                                                   'end_address'   => ${$excl}{'end_address'},
                                                  );
        }

        return \@newlist;
    } else {
        return [];
    }
}

sub ibap_o2i_exclusion
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;
    my @newlist;

    if (not defined $$tempref{$current}) {
        push @return_args, 1;
        push @return_args, 0;
        push @return_args, $$tempref{$current};
    } else {
        if (ref ($$tempref{$current}) eq 'ARRAY') {
            my @list=@{$$tempref{$current}};

            foreach my $excl (@list) {
                my %sub_write_arg;

                return unless $sub_write_arg{'comment'}       = ibap_value_o2i_string_undef_to_empty($excl->comment(),'comment',$session);
                return unless $sub_write_arg{'start_address'} = ibap_value_o2i_string_undef_to_empty($excl->start_address(),'start_address',$session);

                if ($excl->end_address()) {
                    return unless $sub_write_arg{'end_address'} = ibap_value_o2i_string_undef_to_empty($excl->end_address(),'end_address',$session);
                }
                else {
                    return unless $sub_write_arg{'end_address'} = ibap_value_o2i_string_undef_to_empty($excl->start_address(),'start_address',$session);
                }

                push @newlist, \%sub_write_arg;
            }

            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType('ArrayOfaddress_range',
                                                   \@newlist);
        } else {
            push @return_args, 0;
        }
    }
    return @return_args;
}

sub ibap_i2o_exclusion_template
{
	my ($self, $session, $current, $ibap_object_ref) = @_;
	my @newlist;

	if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
		my @list=@{$$ibap_object_ref{$current}};

		foreach my $excl (@list) {
			push @newlist, Infoblox::DHCP::ExclusionRangeTemplate->new(
												   'comment' 	   		 => ${$excl}{'comment'},
												   'number_of_addresses' => ${$excl}{'number_of_addresses'},
												   'offset'   			 => ${$excl}{'offset'},
												  );
		}

		return \@newlist;
	} else {
		return [];
	}
}

sub ibap_o2i_exclusion_template
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;
	my @newlist;

	if (not defined $$tempref{$current}) {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, $$tempref{$current};
	} else {
		if (ref ($$tempref{$current}) eq 'ARRAY') {
			my @list=@{$$tempref{$current}};

			foreach my $excl (@list) {
				my %sub_write_arg;

				return unless $sub_write_arg{'comment'} = ibap_value_o2i_string_undef_to_empty($excl->comment(),'comment',$session);
				return unless $sub_write_arg{'number_of_addresses'} = ibap_value_o2i_int($excl->number_of_addresses(),'number_of_addresses',$session);
				return unless $sub_write_arg{'offset'} = ibap_value_o2i_int($excl->offset(),'offset',$session);

				push @newlist, \%sub_write_arg;
			}

			push @return_args, 1;
			push @return_args, 0;
			push @return_args, tIBType('ArrayOfaddress_range_template',
                                       \@newlist);
		} else {
			push @return_args, 0;
		}
	}
	return @return_args;
}

sub ibap_value_o2i_ext_server
{
	my ($obj, $field, $session)=@_;
	my %sub_write_arg;

	$sub_write_arg{'name'} = $obj->name();
	if ( $obj->ipv4addr())
	{
		$sub_write_arg{'address'} = $obj->ipv4addr();
	}
	else
	{
		$sub_write_arg{'address'} = $obj->ipv6addr();
	}

    if (defined($obj->stealth()) && $obj->stealth() =~ m/true/i) {
        $sub_write_arg{'stealth'} = tBool(1);
    } else {
        $sub_write_arg{'stealth'} = tBool(0);
    }

	if ($obj->TSIGname())
	{
		$sub_write_arg{'use_tsig_key'} = tBool(1);
		$sub_write_arg{'tsig_key_name'} = $obj->TSIGname();
        $sub_write_arg{'tsig_key_alg'} = $obj->TSIGalgorithm();
		if ($obj->TSIGname() eq ':2xCOMPAT')
		{
			$sub_write_arg{'use_2x_tsig_key'} = tBool(1);
		}
		else
		{
			$sub_write_arg{'tsig_key'} = $obj->TSIGkey();
		}
	}

	return tIBType('ext_server', \%sub_write_arg );
}

sub ibap_value_i2o_address_ac
{
	my ($addy, $field, $session) = @_;

	my $converted = ${$addy}{'address_string'};
	if ($converted eq 'Any') {
		$converted = 'any';
	}

	if (${$addy}{'permission'} eq 'ALLOW') {
		return $converted;
	} else {
		return "!".$converted;
	}
}

sub ibap_o2i_address_ac_list
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;
    my @newlist;

    push @return_args, 1;

    if ( $$tempref{$current}) {
        my @nodes_list=@{$$tempref{$current}};

        push @return_args, 0;
        if (@nodes_list) {
            my @newlist;

            foreach my $addy (@nodes_list) {
                push @newlist, ibap_value_o2i_address_ac($addy,'',$session);
            }

            push @return_args, tIBType('ArrayOfaddress_ac', \@newlist);
        }
        else
        {
            push @return_args, tIBType('ArrayOfaddress_ac', []);
        }
    }
    else
    {
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}

sub ibap_o2i_address_ac_list_undef_to_empty_list
{
    my ($self, $session, $current, $tempref) = @_;

    if ( $$tempref{$current}) {
        return(ibap_o2i_address_ac_list($self, $session, $current, $tempref));
    }
    else
    {
        return(1,0, tIBType('ib:ArrayOfaddress_ac', []));
    }
}

sub ibap_o2i_ac_setting
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $tempref->{$current}) {
        my %sub_write_args;

        if (ref($tempref->{$current}) eq 'Infoblox::Grid::NamedACL') {
            $sub_write_args{'acl_type'} = 'DEFINED_ACL';

            my $data = object_by_oid_or_readfield_helper($self, $current, $tempref->{$current}, 1, 'name');

            if ($data) {
                $sub_write_args{'defined_acl'} = $data;
            } else {
                return (0);
            }
        } elsif (ref($tempref->{$current}) eq 'ARRAY') {
            if (@{$tempref->{$current}}) {
                $sub_write_args{'acl_type'} = 'LIST';

                my @data = ibap_o2i_mixed_ac_list($self, $session, $current, $tempref);

                if (@data and $data[0]) {
                    $sub_write_args{'ac_list'} = $data[2];
                } else {
                    return (0);
                }
            } else {
                $sub_write_args{'acl_type'} = 'NONE';
            }
        } else {
            set_error_codes(1012, "Unsupported type ".ref($tempref->{$current})." for $current of object ".ref($self));
            return (0);
        }

        return (1, 0, tIBType('ac_setting', \%sub_write_args));
    } else {
        return (1, 1, undef);
    }
}

sub ibap_o2i_ac_setting_undef_to_empty_list
{
    my ($self, $session, $current, $tempref) = @_;

    if (!defined $tempref->{$current}) {
        return (1, 0, tIBType('ac_setting', {'acl_type' => 'NONE'}));
    } else {
        return ibap_o2i_ac_setting($self, $session, $current, $tempref);
    }
}

sub ibap_o2i_ntp_ac_setting
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $tempref->{$current}) {
        my %sub_write_args = ();

        if (ref($tempref->{$current}) eq 'Infoblox::Grid::NamedACL') {
            $sub_write_args{'acl_type'} = 'DEFINED_ACL';

            my $data = object_by_oid_or_readfield_helper($self, $current, $tempref->{$current}, 1, 'name');

            if ($data) {
                $sub_write_args{'defined_acl'} = $data;
                if (my $service = $self->ntp_service_type()) {
                    $sub_write_args{'service'} = $service eq 'Time' ? 'TIME' : 'TIME_AND_NTPQ';
                } else {
                    $sub_write_args{'service'} = 'TIME';
                }
            } else {
                return (0);
            }
        } elsif (ref($tempref->{$current}) eq 'ARRAY') {
            if (@{$tempref->{$current}}) {
                $sub_write_args{'acl_type'} = 'LIST';
                $sub_write_args{'ac_list'} = ibap_serialize_substruct_list($session, $tempref->{$current}, 'ntp_ac');
            } else {
                $sub_write_args{'acl_type'} = 'NONE';
            }
        } else {
            set_error_codes(1012, "Unsupported type ".ref($tempref->{$current})." for $current of object ".ref($self));
            return (0);
        }

        return (1, 0, tIBType('ntp_ac_setting', \%sub_write_args));
    } else {
        return (1, 0, tIBType('ntp_ac_setting', {'acl_type' => 'NONE'}));
    }
}

sub ibap_o2i_mixed_ac
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        my %sub_write_args;

        if (ref($$tempref{$current}) eq "Infoblox::DNS::TSIGKey") {
            $sub_write_args{'tsig_ac'}=ibap_unwrapped_tsig_ac_convert($$tempref{$current},'tsig_ac', $session);
        } elsif(ref($$tempref{$current}) eq 'Infoblox::Grid::NamedACL') {
            my $data = object_by_oid_or_readfield_helper($self, $current, $$tempref{$current}, 1, 'name');

            if ($data) {
                $sub_write_args{'defined_ac'} = $data;
            } else {
                return (0);
            }
        } elsif (!ref($$tempref{$current})) {
            $sub_write_args{'address_ac'}=ibap_unwrapped_address_ac_convert($$tempref{$current},'address_ac',$session);
        } else {
            set_error_codes(1012, "Unsupported object type ".ref($$tempref{$current})." for $current of object ".ref($self));
            return (0);
        }

        return (1, 0, tIBType('address_tsig_ac', \%sub_write_args));
    } else {
        return (1, 1, undef);
    }
}

sub ibap_o2i_mixed_ac_list
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        my @item_list=@{$$tempref{$current}};
        if (@item_list) {
            my @newlist;

            foreach my $item (@item_list) {
                if (defined $item) {
                    my @data = ibap_o2i_mixed_ac($self, $session, $current, {$current => $item});

                    if ($data[0]) {
                        push @newlist, $data[2];
                    } else {
                        return (0);
                    }
                }
            }

            return (1, 0, tIBType('ArrayOfaddress_tsig_ac',\@newlist));
        } else {
            return (1, 0, tIBType('ArrayOfaddress_tsig_ac',[]));
        }
    } else {
        return (1, 1, undef);
    }
}

sub ibap_unwrapped_address_ac_convert
{
	my ($addy, $field, $session) = @_;

	my %sub_write_arg;

	if ($addy =~ m/^!/) {
		$addy =~ s/^!//;
		$sub_write_arg{'permission'} = 'DENY';
	} else {
		$sub_write_arg{'permission'} = 'ALLOW';
	}

	if ($addy =~ m/any/i) {
		$sub_write_arg{'address_string'} = 'Any';
	} else {
		$sub_write_arg{'address_string'} = $addy;
	}

    my ($p1, $p2) = split('/', $addy);
    if ($p2 and is_ipv4_address($p2)) {
        $sub_write_arg{'address_string'} = $p1;
        $sub_write_arg{'netmask'} = $p2;
    }

	return \%sub_write_arg;
}

sub ibap_value_o2i_address_ac
{
	my ($addy, $field, $session) = @_;

	return tIBType('address_ac', ibap_unwrapped_address_ac_convert($addy, $field, $session));
}

sub ibap_i2o_sort_list
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}})
    {
        my @obj_list= @{$$ibap_object_ref{$current}};

        foreach my $obj(@obj_list)
        {
            my $network=${$obj}{'sl_address'};
            my $querier_option=defined(${$obj}{'querier_option'})? ${$obj}{'querier_option'} : "ADDRESS";
            my ($ipv4cidr, $ipv6cidr);
            if(is_ipv4_address($network))
            {
                if(${$obj}{'sl_netmask'} && ($querier_option eq "NETWORK"))
                {
                    $ipv4cidr=$network."/".mask_to_bits(${$obj}{'sl_netmask'});
                }
                else
                {
                   $ipv4cidr=$network;
                }
            }
            elsif(is_ipv6_address($network))
            {
                if(${$obj}{'sl_netmask'} && ($querier_option eq "NETWORK"))
                {
                    $ipv6cidr=$network."/".${$obj}{'sl_netmask'};
                }
                else
                {
                   $ipv6cidr=$network;
                }
            }
            #
            if($network=~/any/i)
            {
               $ipv4cidr="0.0.0.0/0";
            }
            my $address_matches=${$obj}{'address_matches'};
            my @addr_match_list;
            if($address_matches && @$address_matches)
            {
                foreach my $match(@$address_matches)
                {
                    if(${$match}{'netmask'} && (${$match}{'netmask'} ne "255.255.255.255") && (${$match}{'netmask'} ne "128"))
                    {
                      my $netmask=${$match}{'netmask'};
                      if(is_ipv6_address($match->{'address'}))
                      {
                        push @addr_match_list, $match->{'address'}."/".$match->{'netmask'};
                      }
                      else
                      {
                        push @addr_match_list, $match->{'address'}."/".mask_to_bits($match->{'netmask'});
                      }
                    }
                    else
                    {
                        push @addr_match_list, $match->{'address'};
                    }
                }
            }
            if($ipv4cidr)
            {
                push @newlist, Infoblox::DNS::Sortlist->new(
                                                             source_ipv4addr => $ipv4cidr,
                                                             match_list => \@addr_match_list,
                                                             comment => ${$obj}{'comment'},
                                                           );
            }
            elsif($ipv6cidr)
            {
                push @newlist, Infoblox::DNS::Sortlist->new(
                                                             source_ipv6addr => $ipv6cidr,
                                                             match_list => \@addr_match_list,
                                                             comment => ${$obj}{'comment'},
                                                           );
            }
        }
        return \@newlist;
    }
    else
    {
        return [];
    }
}

sub ibap_o2i_sort_list
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if ( $tempref->{$current})
    {
        my @sortlists= @{$tempref->{$current}};

        if(@sortlists)
        {
            my @newlist;

            foreach my $sortlist(@sortlists)
            {
                my %sub_write_args;
                if (ref($sortlist) eq "Infoblox::DNS::Sortlist")
                {
                  my ($network,$netmask);
                  if($sortlist->source_ipv4addr())
                  {
                    my $ipv4cidr=$sortlist->source_ipv4addr();


                    #
                    if( ($ipv4cidr eq '0.0.0.0/0') || ($ipv4cidr=~/any/i))
                    {
                       $network='any';
                       $netmask='255.255.255.255';
                    }
                    else
                    {
                       ($network,$netmask)=split_network_netmask($ipv4cidr,$session);
                       return (0) unless defined $network && defined $netmask;
                       $sub_write_args{'querier_option'}=ibap_value_o2i_string('NETWORK','querier_option',$session) if $ipv4cidr =~ /\//;
                    }
                  }
                  elsif($sortlist->source_ipv6addr())
                  {

                    my $ipv6cidr=$sortlist->source_ipv6addr();

                    ($network,$netmask)=split_network_netmask($ipv6cidr,$session);
                    return (0) unless defined $network && defined $netmask;
                    $sub_write_args{'querier_option'}=ibap_value_o2i_string('NETWORK','querier_option',$session) if $ipv6cidr =~ /\//;
                  }
                  $sub_write_args{'sl_address'}=ibap_value_o2i_string($network,'sl_address',$session);
                  $sub_write_args{'sl_netmask'}=ibap_value_o2i_string($netmask,'sl_netmask',$session);
                  if (defined $sortlist->comment()) {
                      $sub_write_args{'comment'}=ibap_value_o2i_string($sortlist->comment(),'comment',$session);
                  }
                  else {
                      $sub_write_args{'comment'}=tString('');
                  }

                  if ($sortlist->match_list())
                  {
                      my @newlist1;

                      my @match_list=@{$sortlist->match_list()};

                      if(@match_list)
                      {
                          foreach my $element(@match_list)
                          {
                              my ($network,$netmask)=split_network_netmask($element,$session);
                              return (0) unless defined $network && defined $netmask;

                              my %subsub_write_args;

                              $subsub_write_args{'address'}=ibap_value_o2i_string($network,'address',$session);
                              $subsub_write_args{'netmask'}=ibap_value_o2i_string($netmask,'netmask',$session);

                              push @newlist1, tIBType('address_match', \%subsub_write_args);
                          }
                      }
                      $sub_write_args{'address_matches'}=tIBType('ArrayOfaddress_match', \@newlist1);;
                  }

                  push @newlist, tIBType('sort_list', \%sub_write_args);
                }
            }

            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType('ArrayOfsort_list', \@newlist);
        }
        else
        {
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType('ArrayOfsort_list',[]);
        }
    }
    else
    {
        #
        push @return_args, 1;
        push @return_args, 0;
        push @return_args, tIBType('ArrayOfsort_list',[]);
    }

    return @return_args;
}

sub ibap_value_o2i_enum_mapping
{
   my ($value,$field, $session, $validateonly, $mapping)=@_;
   if(defined($value)){
     if(exists($mapping->{$value})){
       return 1 if $validateonly;
       return ibap_value_o2i_string($$mapping{$value});
     }
     set_error_codes(1104, "Invalid value $value for enum field ".(defined($field) ? $field : '') , $session);
   }
   return undef;
}

sub ibap_value_o2i_int_1000
{
	my ($value, $field, $session, $validateonly) = @_;
    if(defined($value)){
	   if ( $value =~ m/^-?[0-9\.]+$/) {
        my $t = ibap_value_o2i_int($value * 1000);
        unless ($t) {
         set_error_codes(1104,'Invalid value: "' . $value . '" for integer field ' . (defined($field) ? $field : '') . ', floating point numbers are limited to a 1/1000 precision',$session);
         return undef;
        }
        return 1 if $validateonly;
		return $t;
	   } else {
		set_error_codes(1104,'Invalid value: only digits are permitted (' . $value . ') for integer field ' . (defined($field) ? $field : '') ,$session);
	   }
    }
    return undef;
}

sub ibap_value_o2i_int
{
	my ($value, $field, $session, $validateonly) = @_;
    if(defined($value)){
	   if ( $value =~ m/^-?[0-9]+$/) {
           if ($value > $MAX_INT32 or $value < $MIN_INT32) {
               set_error_codes(1104, 'Invalid value ' . $value . ' for integer field ' . (defined($field) ? $field : '') .
                   ", integer numbers should be between $MIN_INT32 and $MAX_INT32", $session);
               return undef;
           }
        return 1 if $validateonly;
		return tInteger($value);
	   } else {
		set_error_codes(1104,'Invalid value: only digits are permitted (' . $value . ') for integer field ' . (defined($field) ? $field : '') ,$session);
	   }
    }
    return undef;
}

sub ibap_value_o2i_uint
{
	my ($value, $field, $session,$validateonly) = @_;
    if(defined($value)){
	   if ($value =~ m/^[0-9]+$/) {
           if ($value > $MAX_UINT) {
            set_error_codes(1104, 'Unsigned integer value (' . $value . ') should be less than or equal to ' .
                "$MAX_UINT for field " . (defined $field ? $field : ''), $session);
            return undef;
           }
        return 1 if $validateonly;
		return tUInteger($value);
	   } else {
		set_error_codes(1104,'Invalid value: only unsigned digits are permitted (' . $value . ') for unsigned integer field ' . (defined($field) ? $field : ''), $session);
	   }
	}
    return undef;
}

sub ibap_value_o2i_long
{
    my ($value, $field, $session, $validateonly) = @_;

    #
    #
    #

    if (defined $value) {
        if ($value =~ m/^-?[0-9]+$/) {
            return 1 if $validateonly;
		    return tLong($value);
	   } else {
		set_error_codes(1104, 'Invalid value: only unsigned digits ' .
            'are permitted (' . $value . ') for long ' .
            'integer field ' . (defined($field) ? $field : ''), $session);
	   }
	}
    return undef;
}

sub ibap_value_o2i_ulong
{
    my ($value, $field, $session, $validateonly) = @_;

    if (defined $value) {
        if ($value =~ m/^[0-9]+$/) {
            return 1 if $validateonly;
		    return tULong($value);
	   } else {
		set_error_codes(1104, 'Invalid value: only unsigned digits ' .
            'are permitted (' . $value . ') for unsigned ' .
            'long integer field ' . (defined($field) ? $field : ''), $session);
	   }
	}
    return undef;
}

sub ibap_value_o2i_uint_undef_ok
{
	my ($value, $field, $session,$validateonly) = @_;

    if (not defined $value) {
        return 1 if $validateonly;
        return undef;
    }
    else {
        return ibap_value_o2i_uint($value,$field,$session);
    }
}

sub ibap_value_o2i_string
{
	my ($value, $field, $session,$validateonly) = @_;

#
    if (defined($value) && ref($value)) {
        set_error_codes(1104,'Invalid object of type (' . ref($value) . ') for field ' . $field . ', only strings are supported',$session);
        return undef;
    }

    return 1 if $validateonly;
    return tString($value);
}

sub ibap_value_o2i_string_no_spaces
{
	my ($value, $field, $session,$validateonly) = @_;

#
    if (defined($value) && ref($value)) {
        set_error_codes(1104,'Invalid object of type (' . ref($value) . ') for field ' . $field . ', only strings are supported',$session);
        return undef;
    }

    if ($value =~ m/ /) {
	    set_error_codes(1012, "Invalid value '$value', no spaces are allowed",$session);
	    return undef;
    }

    return 1 if $validateonly;
    return tString($value);
}

sub ibap_value_o2i_tz
{
	my ($value, $field, $session, $validateonly) = @_;

    if (utc_to_umt($value) || umt_to_utc($value))
	{
        return 1 if $validateonly;
        if (umt_to_utc($value)) {
            return tString(umt_to_utc($value));
        }
        else {
            return tString($value);
        }
	}
	else
	{
	    set_error_codes(1012, "Invalid time zone $value",$session);
	    return undef;
	}
}

sub ibap_value_o2i_ipaddr
{
    my ($value, $field, $session, $validateonly) = @_;

    if (is_ipv4_address($value) || is_ipv6_address($value))
    {
        return 1 if $validateonly;
        return tString($value);
    }
    else
    {
        set_error_codes(1012, "Invalid ip address $value",$session);
        return undef;
    }
}

sub ibap_value_o2i_ipv4addr
{
	my ($value, $field, $session, $validateonly) = @_;

    if (is_ipv4_address($value))
	{
        return 1 if $validateonly;
	    return tString($value);
	}
	else
	{
	    set_error_codes(1012, "Invalid ip address $value",$session);
	    return undef;
	}
}

sub ibap_value_o2i_ipv6addr
{
	my ($value, $field, $session, $validateonly) = @_;

    if (is_ipv6_address($value))
	{
        return 1 if $validateonly;
	    return tString($value);
	}
	else
	{
	    set_error_codes(1012, "Invalid ip address $value",$session);
	    return undef;
	}
}

sub ibap_value_o2i_ipv4_network
{
	my ($value, $field, $session, $validateonly) = @_;

    if (is_ipv4_network($value))
	{
        return 1 if $validateonly;
	    return tString($value); # Unlikely we'll use this, this is mostly for validation
	}
	else
	{
	    set_error_codes(1012, "Invalid network $value",$session);
	    return undef;
	}
}

sub ibap_value_o2i_ipv6_network
{
	my ($value, $field, $session, $validateonly) = @_;

    if (is_ipv6_network($value))
	{
        return 1 if $validateonly;
	    return tString($value); # Unlikely we'll use this, this is mostly for validation
	}
	else
	{
	    set_error_codes(1012, "Invalid network $value",$session);
	    return undef;
	}
}

sub ibap_value_o2i_network
{
    my ($value, $field, $session, $validateonly) = @_;
    if (is_ipv4_network($value) or is_ipv6_network($value))
    {
        return 1 if $validateonly;
        return tString($value); # Unlikely we'll use this, this is mostly for validation
    }
    else
    {
        set_error_codes(1012, "Invalid network $value",$session);
        return undef;
    }
}

sub ibap_value_o2i_ipv6_network_or_address
{
	my ($value, $field, $session, $validateonly) = @_;

    if (is_ipv6_network($value) || is_ipv6_address($value))
	{
        return 1 if $validateonly;
	    return tString($value); # Unlikely we'll use this, this is mostly for validation
	}
	else
	{
	    set_error_codes(1012, "Invalid network $value",$session);
	    return undef;
	}
}

sub ibap_o2i_ipv4addr_list
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if ( $tempref->{$current})
    {
        my @addr_list=@{$tempref->{$current}};
        if(@addr_list)
        {
            my @submit_list;
            foreach my $addr(@addr_list)
            {
                if (is_ipv4_address($addr)) {
                    push @submit_list, ibap_value_o2i_ipv4addr($addr, '', $session);
                }
                else {
                    set_error_codes(1012, "Invalid ip address $addr",$session);
                    return (0);
                }
            }
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType('ArrayOfIPAddress', \@submit_list);
        }
        else
        {
          push @return_args, 1;
          push @return_args, 0;
          push @return_args, tIBType('ArrayOfIPAddress', []);
        }
    }
    else
    {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}

sub ibap_o2i_ipaddr_list_helper
{
    my ($session, $listref) = @_;

    my @submit_list;
    foreach my $addr (@$listref) {
        if (is_ipv4_address($addr)) {
            push @submit_list, ibap_value_o2i_ipv4addr($addr, '', $session);
        } elsif (is_ipv6_address($addr)) {
            push @submit_list, ibap_value_o2i_ipv6addr($addr, '', $session);
        } else {
            set_error_codes(1012, "Invalid ip address $addr",$session);
            return undef;
        }
    }
    return \@submit_list;
}

sub ibap_o2i_addresscidr_list_helper
{
    my ($session, $listref) = @_;

    my @submit_list;
    foreach my $network (@$listref) {
        if (is_ipv4_network($network) || is_ipv6_network($network)) {
            my ($address, $cidr) = split_network_netmask($network, $session, 1);
            return undef unless defined $address && defined $cidr;
            push @submit_list, tIBType('addr_cidr', {address => $address, cidr => $cidr});
        } else {
            set_error_codes(1012, "Invalid network $network",$session);
            return undef;
        }
    }
    return \@submit_list;
}

sub ibap_o2i_ipaddr_list
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if ( $tempref->{$current})
    {
        my @addr_list=@{$tempref->{$current}};
        if(@addr_list)
        {
            my $submit_list = ibap_o2i_ipaddr_list_helper($session,$tempref->{$current});
            return (0) unless $submit_list;

            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType('ArrayOfIPAddress', $submit_list);
        }
        else
        {
          push @return_args, 1;
          push @return_args, 0;
          push @return_args, tIBType('ArrayOfIPAddress', []);
        }
    }
    else
    {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}

sub ibap_i2o_enums_uc_or_undef
{
    #
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($$ibap_object_ref{$current}) {
        return uc($$ibap_object_ref{$current});
    } else {
        return undef;
    }
}

sub ibap_i2o_enums_lc_or_undef
{
    #
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($$ibap_object_ref{$current}) {
        return lc($$ibap_object_ref{$current});
    } else {
        return undef;
    }
}

sub ibap_i2o_enum_mapping_or_empty
{
  #
  #
  my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref, $maphash)=@_;
  my $value=$$ibap_object_ref{$current};
  if($value && (ref($maphash) eq 'HASH') && exists($$maphash{$value})){
    return $$maphash{$value};
  }
  return '';
}


sub ibap_i2o_enums_ucfirst_or_undef
{
    #
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($$ibap_object_ref{$current}) {
        return ucfirst(lc($$ibap_object_ref{$current}));
    } else {
        return undef;
    }
}

sub ibap_o2i_enums_ucfirst_or_undef
{
    my ($self, $session, $current, $tempref) = @_;

    my @return_args;

    push @return_args, 1;
    push @return_args, 0;

    if ( $$tempref{$current}) {
        my $string=capitalize_first_letter($$tempref{$current});
        my $t=ibap_value_o2i_string($string,$current,$session);
        return (0) unless $t;
        push @return_args, $t;
    } else {
        push @return_args, undef;
    }

    return @return_args;
}

sub ibap_o2i_enums_lc_or_undef
{
    my ($self, $session, $current, $tempref) = @_;

    my @return_args;

    push @return_args, 1;
    push @return_args, 0;

    if ( $$tempref{$current}) {
        my $string=uc($$tempref{$current});
        my $t=ibap_value_o2i_string($string,$current,$session);
        return (0) unless $t;
        push @return_args, $t;
    } else {
        push @return_args, undef;
    }

    return @return_args;
}

sub ibap_o2i_enums_uc_or_undef
{
    my ($self, $session, $current, $tempref) = @_;

    if ( $$tempref{$current}) {
        my $string=uc($$tempref{$current});
        my $t=ibap_value_o2i_string($string,$current,$session);
        return (0) unless $t;
        return (1, 0, $t);
    } else {
        return (1, 0, undef);
    }
}

sub ibap_i2o_v_type
{
  my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref)=@_;

  return ibap_i2o_enum_mapping_or_empty($self,$session,$current,$ibap_object_ref,$return_object_cache_ref,
    \%reverse_v_type_name_mapping);
}



sub ibap_i2o_logging_categories
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($ibap_object_ref->{$current})
    {
        my $element= $ibap_object_ref->{$current};

        foreach my $key (keys %$element)
        {
            push  @newlist, $_log_fields_mapping{$key} if (${$element}{$key}==1);
        }
        return \@newlist;
    }
    else
    {
        return [];
    }
}

sub ibap_o2i_logging_categories
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;


    if ( $tempref->{$current})
    {
        my @fields=@{$tempref->{$current}}; #List of logging categories
        my %sub_write_args;

        foreach my $key(keys %_log_fields_mapping){
            $sub_write_args{$key}=ibap_value_o2i_boolean("false", $key, $session);
        }

        foreach my $field(@fields)
        {
            my $key_field=$_reverse_log_fields_mapping{$field};
            if($key_field)
            {
                $sub_write_args{$key_field}=ibap_value_o2i_boolean("true", $key_field, $session);
            }
            else
            {
                set_error_codes(1012,"Incorrect value $field in the  logging_categories list", $session);
                return (0);
            }
        }

        push @return_args, 1;
        push @return_args, 0;
        push @return_args, tIBType('logging_categories', \%sub_write_args);
    }
    else
    {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }
    return @return_args;
}

sub ibap_i2o_transfer_format
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($$ibap_object_ref{$current})
    {
        return 'many_answers' if ($$ibap_object_ref{$current}=~/MANY_ANSWERS/);
        return 'one_answer' if ($$ibap_object_ref{$current}=~/ONE_ANSWER/);
    }

    return;
}

sub ibap_o2i_transfer_format
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if ( $tempref->{$current})
    {
        if($tempref->{$current}=~/many_answers/)
        {
           return (1,0,ibap_value_o2i_string('MANY_ANSWERS'));
        }
        elsif($tempref->{$current}=~/one_answer/)
        {
           return (1,0,ibap_value_o2i_string('ONE_ANSWER'));
        }
        else
        {
            set_error_codes(1012, "Illegal value for transfer_format",$session);
            return (0);
        }
    }
    else
    {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}

sub ibap_i2o_root_ns_list
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}} && $$ibap_object_ref{'enable_custom_root_server'}) {
        my @nodes_list = @{$$ibap_object_ref{$current}};

        foreach my $addy (@nodes_list) {
            my $tempaddr;

            if (is_ipv6_address(${$addy}{'address'})) {
                $tempaddr='ipv6addr';
            } else {
                $tempaddr='ipv4addr';
            }

            push @newlist, Infoblox::DNS::RootNameServer->new(
                'host_name' => ${$addy}{'name'},
                $tempaddr   => ${$addy}{'address'},
                );
        }
        return \@newlist;
    } else {
        return;
    }
}

sub ibap_o2i_root_ns_list
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if ( $$tempref{$current}) {
        my @nss_list=@{$$tempref{$current}};

        if (@nss_list) {
            my @newlist;

            push @return_args, 1;
            push @return_args, 0;

            foreach my $ns (@nss_list) {
                my %sub_write_arg;

                if ( $ns->host_name()) {
                    return unless $sub_write_arg{'name'} = ibap_value_o2i_string($ns->host_name(),'name',$session);
                } else {
                    $sub_write_arg{'name'} = ibap_value_o2i_string('','name',$session);
                }

                if ( $ns->ipv4addr()) {
                    $sub_write_arg{'address'} = ibap_value_o2i_string($ns->ipv4addr(),'address',$session);
                } elsif ( $ns->ipv6addr()) {
                    $sub_write_arg{'address'} = ibap_value_o2i_string($ns->ipv6addr(),'address',$session);
                } else {
                    $sub_write_arg{'address'} = ibap_value_o2i_string('','address',$session);
                }

                push @newlist, tIBType('ext_server', \%sub_write_arg);
            }

            push @return_args, tIBType('ArrayOfext_server',\@newlist);

            if (not  $$tempref{'enable_custom_root_server'}) {
                my %sub_arg;
                $sub_arg{'field'} = 'enable_custom_root_server';
                $sub_arg{'value'} = ibap_value_o2i_boolean("true");
                push @return_args, \%sub_arg;
            }
        } else {
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType('ArrayOfext_server',[]);
        }
    } else {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }
    return @return_args;
}

sub ibap_i2o_record_name_policies
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $result;
    if ($$ibap_object_ref{$current})
    {
        my $obj_ref=$$ibap_object_ref{$current};
        $result=$obj_ref->{"record_name_policy"}->{"policy_name"};

        my $bind_check_names_policy;

        if(defined $result && $result eq "Strict Hostname Checking")
        {
            if($obj_ref->{"check_names_for_ddns_and_zone_transfer"}==1)
            {
                $bind_check_names_policy=lc($obj_ref->{"check_names_policy"}) if $obj_ref->{"check_names_policy"};
            }
        }

        $self->bind_check_names_policy($bind_check_names_policy);
        return($result);
    }
}

sub ibap_o2i_record_name_policies
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    my $record_name_policy=$tempref->{"host_name_restriction_policy"};
    my $bind_check_names_policy=$tempref->{"bind_check_names_policy"};

    #
    my $record_name_policy_obj;
    my $check_names_policy;
    my $check_names_for_ddns_and_zone_transfer;
    if($record_name_policy)
    {

        #
        if(($record_name_policy=~/Strict Hostname Checking/i)&& $bind_check_names_policy)
        {
            if($bind_check_names_policy=~/fail/i)
            {
                $check_names_for_ddns_and_zone_transfer="true";
                $check_names_policy="FAIL";
            }
            elsif($bind_check_names_policy=~/warn/i)
            {
                $check_names_for_ddns_and_zone_transfer="true";
                $check_names_policy="WARN";
            }
        }
        else
        {
            $check_names_for_ddns_and_zone_transfer="false";
        }

        my %sub_write_args;



        $sub_write_args{'check_names_policy'}=ibap_value_o2i_string($check_names_policy) if ($check_names_policy);
        $sub_write_args{'check_names_for_ddns_and_zone_transfer'}=ibap_value_o2i_boolean($check_names_for_ddns_and_zone_transfer) if  $check_names_for_ddns_and_zone_transfer;
        $sub_write_args{'record_name_policy'}=ibap_readfield_simple_string('RecordNamePolicy','policy_name',$record_name_policy);

        push @return_args, 1;
        push @return_args, 0;
        push @return_args, tIBType('administrative_record_name_policies', \%sub_write_args);
    }
    else
    {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}

sub ibap_value_o2i_match_options
{
	my ($value, $field, $session, $validateonly) = @_;

    my $match = lc($value);

    if ($match eq 'mac') {
        $match=ibap_value_o2i_string('MAC_ADDRESS');
    } elsif ($match eq 'client_identifier') {
        $match=ibap_value_o2i_string('CLIENT_ID');
    } elsif ($match eq 'reserved') {
        $match=ibap_value_o2i_string('RESERVED');
    } elsif ($match eq 'circuit_id') {
        $match=ibap_value_o2i_string('CIRCUIT_ID');
    } elsif ($match eq 'remote_id') {
        $match=ibap_value_o2i_string('REMOTE_ID');
    } elsif ($match eq 'duid') {
        $match=ibap_value_o2i_string('DUID');
    } else {
        set_error_codes(1104,"Invalid value '$value' for member $field" );
        return undef;
    }

    return 1 if $validateonly;
    return $match;
}

sub ibap_o2i_match_options
{
	my ($self, $session, $current, $tempref) = @_;

	if (defined $$tempref{$current}) {
        my $match = ibap_value_o2i_match_options($$tempref{$current}, 'match_client', $session);
        return (0) unless $match;

        return (1,0,$match);
	}
	else {
        return (1,0,undef);
	}
}

sub ibap_value_i2o_match_options
{
	my ($value) = @_;

	if ($value) {
		if ($value eq 'MAC_ADDRESS') {
			return 'MAC';
		}
		elsif ($value eq 'CLIENT_ID') {
			return 'CLIENT_IDENTIFIER';
		}
		elsif ($value eq 'REMOTE_ID') {
			return 'REMOTE_ID';
		}
		elsif ($value eq 'CIRCUIT_ID') {
			return 'CIRCUIT_ID';
		}
		elsif ($value eq 'RESERVED') {
			return 'RESERVED';
		}
		elsif ($value eq 'DUID') {
			return 'DUID';
		}
	} else {
		return;
	}
}

sub ibap_i2o_match_options
{
	my ($self, $session, $current, $ibap_object_ref) = @_;

    return ibap_value_i2o_match_options($$ibap_object_ref{$current});
}

sub ibap_i2o_member_name
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if (ref $$ibap_object_ref{$current} eq 'ARRAY') {
        return [map {$_->{host_name}} @{$$ibap_object_ref{$current}}];
    } elsif ($$ibap_object_ref{$current}) {
        return $$ibap_object_ref{$current}->{host_name};
    } else {
        return undef;
    }
}

sub ibap_o2i_object_by_name_helper {

    my ($self, $session, $current, $tempref, $op, $objtype, $field) = @_;

    if (ref $$tempref{$current} eq 'ARRAY') {

        my @objs = ();

        foreach (@{$$tempref{$current}}) {

            unless ($_) {
                set_error_codes(1002, 'The value of required argument "name" is not specified', $session);
                return undef;
            }

            push @objs, ibap_readfield_simple($objtype, $field, tString($_), $current . '=' . $_);
        }

        return (1, 0, tIBType('ArrayOfBaseObject', \@objs));

    } elsif ($$tempref{$current}) {

        return (1, 0, ibap_readfield_simple($objtype, $field, tString($$tempref{$current}), $current . '=' . $$tempref{$current}));

    }

    set_error_codes(1002, 'The value of required argument "name" is not specified', $session);
    return (0);
}

sub ibap_o2i_member_name {

    my ($self, $session, $current, $tempref, $op) = @_;
    return ibap_o2i_object_by_name_helper($self, $session, $current,
        $tempref, $op, 'Member', 'host_name');
}


sub ibap_value_o2i_string_undef_to_empty
{
	my ($value, $field, $session, $validateonly) = @_;

#

    if (defined($value) && ref($value)) {
        set_error_codes(1104,'Invalid object of type (' . ref($value) . ') for field ' . $field . ', only strings are supported',$session);
        return undef;
    }

    return 1 if $validateonly;
	if (defined($value)) {
		return tString($value);
	}
	else {
		return tString('');
	}
}

sub ibap_value_o2i_string_to_datetime
{
	my ($value, $field, $session, $validateonly) = @_;

    my $t = eval { iso8601_datetime_to_unix_timestamp($value); };

    if ($@) {
        set_error_codes(1104, 'Invalid ISO 8601 extended format string "'
                        . $value . '" for field '
                        . $field, $session);
        return undef;
    } else {
        return 1 if $validateonly;
        return tDateTime($t);
    }
}

sub ibap_o2i_string_to_datetime
{
	my ($self, $session, $current, $tempref) = @_;

    my $t = ibap_value_o2i_string_to_datetime($tempref->{$current},$current,$session);

    if ($t) {
        return (1, 0, $t);
    }
    else {
        return (0);
    }
}

sub ibap_o2i_unix_timestamp_to_datetime
{
	my ($self, $session, $current, $tempref) = @_;
    return (1, 0, tDateTime($tempref->{$current}));
}

sub ibap_i2o_datetime_to_unix_timestamp
{
	my ($self, $session, $current, $ibap_object_ref) = @_;
    return iso8601_datetime_to_unix_timestamp($$ibap_object_ref{$current});
}

sub ibap_i2o_datetime_to_unix_timestamp_nolimit
{
	my ($self, $session, $current, $ibap_object_ref) = @_;
    return eval { iso8601_datetime_to_unix_timestamp_nolimit($$ibap_object_ref{$current}) };
}

#
#
#
#
#
sub ibap_o2i_boolean
{
	my ($self, $session, $current, $tempref) = @_;

	if (defined $$tempref{$current}) {
		if (my $t = ibap_value_o2i_boolean($$tempref{$current})) {
            return (1, 0, $t);
		} else {
			set_error_codes(1104,'Invalid boolean value ' . $$tempref{$current} . ' for field ' . $current,$session);
			return (0);
		}
	}
	else {
        return (1, 1, undef);
	}
}

sub ibap_o2i_boolean_reverse
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        if (my $t = ibap_value_o2i_boolean_reverse($$tempref{$current})) {
            return (1, 0, $t);
        } else {
            set_error_codes(1104,'Invalid boolean value ' . $$tempref{$current} . ' for field ' . $current,$session);
            return (0);
        }
    }
    else {
        return (1, 1, undef);
    }
}

sub ibap_o2i_string
{
	my ($self, $session, $current, $tempref, $type) = @_;
	my @return_args;

    my $str = $$tempref{$current};
	if (defined $str) {
		my $t=ibap_value_o2i_string($str);
		if ($t) {
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, $t;
		}
		else {
			push @return_args, 0;
			set_error_codes(1104,'Invalid character(s) (' . $$tempref{$current} . ') for field ' . $current,$session);
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, undef;
	}

	return @return_args;
}

sub ibap_o2i_string_undef_to_empty
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		my $t=ibap_value_o2i_string($$tempref{$current});
		if ($t) {
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, $t;
		}
		else {
			push @return_args, 0;
			set_error_codes(1104,'Invalid character(s) (' . $$tempref{$current} . ') for field ' . $current,$session);
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, ibap_value_o2i_string('');
	}

	return @return_args;
}

#
#
sub __ibap_o2i_string_array {

    my ($self, $session, $current, $tempref) = @_;
    my @strs;

    my @list = ref $$tempref{$current} eq 'ARRAY' ?
        @{$$tempref{$current}} : ();

    foreach (@list) {
        my $t = ibap_value_o2i_string_undef_to_empty($_);
        return (0) unless $t;
        push @strs, $t;
    }

    return (1, 0, tIBType('ArrayOfstring', \@strs));
}

sub ibap_o2i_string_array_skip_undef {

    my ($self, $session, $current, $tempref) = @_;

    if (
        defined $$tempref{$current} and
        ref $$tempref{$current} eq 'ARRAY'
    ) {
        return __ibap_o2i_string_array(@_);
    } elsif (not defined $$tempref{$current}) {
        return (1, 1, undef);
    } else {
        set_error_codes(1105, "Invalid value for field $current: " .
            "not an ARRAY reference");
        return (0);
    }
}

sub ibap_o2i_string_array_undef_to_empty {

    my ($self, $session, $current, $tempref) = @_;

    if (
        defined $$tempref{$current} and
        ref $$tempref{$current} ne 'ARRAY'
    ) {
        set_error_codes(1105, "Invalid value for field $current: " .
            "not an ARRAY reference");
        return (0);
    } else {
        return __ibap_o2i_string_array(@_);
    }
}

sub ibap_o2i_string_skip_undef
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		my $t=ibap_value_o2i_string($$tempref{$current});
		if ($t) {
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, $t;
		}
		else {
			push @return_args, 0;
			set_error_codes(1104,'Invalid character(s) (' . $$tempref{$current} . ') for field ' . $current,$session);
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 1;
		push @return_args, undef;
	}
	return @return_args;
}

sub ibap_o2i_integer
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		my $t=ibap_value_o2i_int($$tempref{$current});
		if ($t) {
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, $t;
		}
		else {
			push @return_args, 0;
			set_error_codes(1012,'Only digits are permitted (' . $$tempref{$current} . ') for integer field ' . $current,$session);
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, undef;
	}
	return @return_args;
}

sub ibap_i2o_integer_1000
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $t = $ibap_object_ref->{$current};
    if ($t) {
        return ($t / 1000)
    }
    else {
        return $t;
    }
}


sub ibap_o2i_integer_1000
{
	my ($self, $session, $current, $tempref) = @_;

	if (defined $$tempref{$current}) {
		my $t=ibap_value_o2i_int_1000($$tempref{$current});
		if ($t) {
            return (1,0, $t);
		}
		else {
            return (0);
		}
	}
	else {
        return (1,0,undef);
	}
}

sub ibap_o2i_uint
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		my $t=ibap_value_o2i_uint($$tempref{$current});
		if ($t) {
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, $t;
		}
		else {
			push @return_args, 0;
			set_error_codes(1012,'Only digits are permitted (' . $$tempref{$current} . ') for integer field ' . $current,$session);
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, undef;
	}
	return @return_args;
}

sub ibap_o2i_long
{
	my ($self, $session, $current, $tempref) = @_;

	if (defined $$tempref{$current}) {
		my $t = ibap_value_o2i_long($$tempref{$current});
		if ($t) {
            return (1, 0, $t);
		}
		else {
            return (0);
		}
	}

    return (1, 0, undef);
}

sub ibap_o2i_ulong
{
	my ($self, $session, $current, $tempref) = @_;

	if (defined $$tempref{$current}) {
		my $t = ibap_value_o2i_ulong($$tempref{$current});
		if ($t) {
            return (1, 0, $t);
		}
		else {
            return (0);
		}
	}

    return (1, 0, undef);
}

sub ibap_o2i_uint_skip_undef
{
	my ($self, $session, $current, $tempref) = @_;

	if (defined $$tempref{$current}) {
		my $t=ibap_value_o2i_uint($$tempref{$current});
		if ($t) {
            return(1,0,$t);
		}
		else {
			set_error_codes(1012,'Only digits are permitted (' . $$tempref{$current} . ') for integer field ' . $current,$session);
            return (0,);
		}
	}
	else {
        return(1,1,undef);
	}
}

sub ibap_o2i_integer_skip_undef
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		my $t=ibap_value_o2i_int($$tempref{$current});
		if ($t) {
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, $t;
		}
		else {
			push @return_args, 0;
			set_error_codes(1012,'Only digits are permitted (' . $$tempref{$current} . ') for integer field ' . $current,$session);
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 1;
		push @return_args, undef;
	}
	return @return_args;
}

sub ibap_o2i_view_convert
{
    my ($ibap_view) = @_;

	if (ref( $ibap_view ) eq "Infoblox::DNS::View") {
		if ($ibap_view->__object_id__()) {
            return tObjId($ibap_view->__object_id__());
		} else {
			return ibap_readfield_simple_string('View','name',$ibap_view->name(),'view');
		}
    } else {
	    return ibap_readfield_simple_string('View','name',$ibap_view);
	}
}

#
sub ibap_o2i_view
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	push @return_args, 1;
	push @return_args, 0;
	if (not defined $$tempref{$current}) {
		push @return_args, $$tempref{$current};
	} else {
		#
		#
		#
		if (ref ($$tempref{$current}) eq 'ARRAY') {
            push @return_args, ibap_o2i_view_convert(@{$$tempref{$current}}[0]);
        } else {
            push @return_args, ibap_o2i_view_convert($$tempref{$current});
        }
    }
	return @return_args;
}

#
sub ibap_o2i_views
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	push @return_args, 1;
	push @return_args, 0;
	if (not defined $$tempref{$current}) {
		push @return_args, $$tempref{$current};
	} elsif (ref ($$tempref{$current}) eq 'ARRAY') {
        my @newlist = ();
        for my $view (@{$$tempref{$current}}) {
            push @newlist, ibap_o2i_view_convert($view);
        }
        push @return_args, \@newlist;
    }
	return @return_args;
}

sub ibap_i2o_member_byhostname
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return $ibap_object_ref->{$current}->{'host_name'};
}


sub ibap_o2i_member_byhostname
{
	my ($self, $session, $current, $tempref, $type) = @_;

    if($tempref->{$current}) {
        return (1, 0, ibap_readfield_simple_string('Member', 'host_name', $tempref->{$current},'grid_member'));
    } else {
        return (1, 0, undef);
    }
}


sub ibap_i2o_rulesets_by_names
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        my @newlist = ();
        for my $ruleset (@{$$ibap_object_ref{$current}}) {
            push @newlist, $ruleset->{'name'};
        }
        return \@newlist;
    } else {
        return [];
    }
}

sub ibap_o2i_rulesets_by_names
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;
    push @return_args, 1;

    if ($tempref->{$current} && ref($tempref->{$current}) eq 'ARRAY') {
        push @return_args, 0;

        my @newlist = ();

        for my $ruleset_name (@{$tempref->{$current}}) {
            push @newlist, ibap_readfield_simple('Ruleset', 'name', tString($ruleset_name),'Ruleset');
        }

        push @return_args, tIBType('ArrayOfBaseObject',\@newlist);

    } else {
        push @return_args, 1;
        push @return_args, tIBType('ArrayOfBaseObject',[]);
    }

    return @return_args;
}

sub ibap_o2i_snmpv3_users
{
    my ($self, $session, $current, $tempref) =@_;

    if ($tempref->{$current}){
        if(ref($tempref->{$current}) eq 'ARRAY'){

            my @newlist=();
            for my $user (@{$tempref->{$current}}){
                if(ref($user) eq "Infoblox::Grid::SNMP::User"){
                    push @newlist, ibap_readfield_simple('SnmpUser', 'name', tString($user->name()),'SnmpUser');
                }elsif(!ref($user)){
                    push @newlist, ibap_readfield_simple('SnmpUser', 'name',$user, 'SnmpUser');
                }else{
                    return (0,)
                }
            }

            return (1,0, tIBType('ArrayOfBaseObject',\@newlist));
        }else{
            my $user = $tempref->{$current};
            if(ref($user) eq "Infoblox::Grid::SNMP::User"){
                return (1,0, ibap_readfield_simple('SnmpUser', 'name', tString($user->name()),'SnmpUser'));
            }elsif(!ref($user)){
                return (1,0, ibap_readfield_simple('SnmpUser', 'name', tString($user), 'SnmpUser'));
            }else{
                return (0,)
            }
        }
    }
    return (1,1, undef);
}

sub ibap_i2o_snmpv3_query_users
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($$ibap_object_ref{$current} && ref($$ibap_object_ref{$current}) eq 'ARRAY') {
        my @newlist = ();
        for my $query_user(@{$$ibap_object_ref{$current}}) {
            my $t = Infoblox::Grid::SNMP::QueriesUser->__new__();
            $t->comment($query_user->{'comment'}) if defined $query_user->{'comment'};
            $t->user(ibap_i2o_generic_object_convert($self,$session,'snmpv3_user',$query_user,$return_object_cache_ref));
            push @newlist, $t;
        }

        return \@newlist;
    } else {
        return [];
    }
}

sub ibap_i2o_trap_receivers
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($$ibap_object_ref{$current} && ref($$ibap_object_ref{$current}) eq 'ARRAY') {
        my @newlist = ();
        for my $receiver (@{$$ibap_object_ref{$current}}) {
            unless($receiver->{'snmpv3_user'}){
                #
                push @newlist, $receiver->{'address'};
            }else{
                my $t = Infoblox::Grid::SNMP::TrapReceiver->__new__();
                $t->address($receiver->{'address'});
                $t->user(ibap_i2o_generic_object_convert($self,$session,'snmpv3_user',$receiver,$return_object_cache_ref));
                push @newlist, $t;
            }
        }

        return \@newlist;
    } else {
        return [];
    }
}

sub ibap_o2i_snmpv3_query_users
{
    my ($self, $session, $current, $tempref) = @_;

    if ($tempref->{$current}){
        my @newlist = ();
        for my $query_user (@{$tempref->{$current}}) {

            my @res = ibap_serialize_substruct($session, $query_user, 'queries_users');
            if (@res and $res[0]) {
                push @newlist, @res;
            } else {
                return (0);
            }
        }
        return (1,0,tIBType('ArrayOfqueries_users', \@newlist));
    }else{
        return (1,1,undef);
    }
}

sub ibap_o2i_trap_receivers
{
    my ($self, $session, $current, $tempref) =@_;

    if ($tempref->{$current}){
        my @newlist=();
        for my $receiver (@{$tempref->{$current}}){
            if(ref($receiver) eq "Infoblox::Grid::SNMP::TrapReceiver"){

                my @res = ibap_serialize_substruct($session, $receiver, 'trap_receiver');
                if (@res and $res[0]) {
                    push @newlist, @res;
                } else {
                    return (0);
                }

            }elsif(!ref($receiver)){
                my %sub_write_args;
                $sub_write_args{'address'} = ibap_value_o2i_string($receiver);
                push @newlist, \%sub_write_args;
            }else{
                set_error_codes(1001, "Invalid object passed for trap receiver");
                return (0,)
            }
        }
        return (1,0,tIBType('ArrayOftrap_receiver', \@newlist));
    }else{
        return (1,1,undef);
    }
}

sub ibap_o2i_dns64groups
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;
    push @return_args, 1;

    if ($tempref->{$current} && ref($tempref->{$current}) eq 'ARRAY') {
        push @return_args, 0;

        my @newlist = ();

        for my $group (@{$tempref->{$current}}) {
            push @newlist, ibap_readfield_simple('Dns64SynthesisGroup', [
                                                                         {
                                                                          'field' => 'name',
                                                                          'value' => ibap_value_o2i_string($group->name()),
                                                                         },
                                                                         {
                                                                          'field' => 'prefix',
                                                                          'value' => ibap_value_o2i_string($group->prefix()),
                                                                         }
                                                                        ],
                                                 undef, 'group='.$group->name().'/'.$group->prefix());
        }

        push @return_args, tIBType('ArrayOfBaseObject',\@newlist);

    } else {
        push @return_args, 1;
        push @return_args, tIBType('ArrayOfBaseObject',[]);
    }

    return @return_args;
}

sub ibap_o2i_network_view
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    push @return_args, 1;
    push @return_args, 0;
    if (not defined $$tempref{$current}) {
        push @return_args, $$tempref{$current};
    } else {
        #
        #
        #
        if (ref ($$tempref{$current}) eq 'ARRAY') {
            if (ref( @{$$tempref{$current}}[0] ) eq "Infoblox::DHCP::View") {
                my $tview = @{$$tempref{$current}}[0];

                if (my $objid = $tview->__object_id__()) {
                    push @return_args, tObjId($objid);
                } else {
                    push @return_args, ibap_readfield_simple_string('NetworkView','name',$tview->name(),'network_view');
                }
            }
            else {
                push @return_args, ibap_readfield_simple_string('NetworkView','name',@{$$tempref{$current}}[0], 'network_view');
            }
        }
        else {
            if (ref( $$tempref{$current} ) eq "Infoblox::DHCP::View") {
                if (my $objid = $$tempref{$current}->__object_id__()) {
                    push @return_args, tObjId($objid);
                } else {
                    push @return_args, ibap_readfield_simple_string('NetworkView','name',$$tempref{$current}->name(), 'network_view');
                }
            }
            else {
                if ($$tempref{$current} =~ m/:=:=:/) {
                    #
                    #
                    #

                    #
                    my ($field, $type, $value) = split(/:=:=:/, $$tempref{$current});
                    if ($type eq 'boolean') {
                        push @return_args, ibap_readfield_simple('NetworkView', $field, tBool($value), $field.'='.$value.' (network view)');
                    }
                    elsif ($type eq 'string') {
                        #

                        push @return_args, ibap_readfield_simple('NetworkView', $field, tString($value), $field.'='.$value.' (network view)');
                    }
                    else {
                        #
                        set_error_codes(1012,"Unsupported search type ($value)",$session);
                        return (0);
                    }
                } else {
                    push @return_args, ibap_readfield_simple_string('NetworkView','name',$$tempref{$current},'network_view');
                }
            }
        }
    }
    return @return_args;
}

sub ibap_o2i_generic_network_list
{

    my ($self, $session, $current, $tempref) = @_;
    return __ibap_o2i_network_list_common($self, $session, $current, $tempref, 2);
}

sub ibap_o2i_network_list
{
    my ($self, $session, $current, $tempref) = @_;
    return __ibap_o2i_network_list_common($self, $session, $current, $tempref, 0);
}

sub ibap_o2i_ipv6_network_list
{
    my ($self, $session, $current, $tempref) = @_;
    return __ibap_o2i_network_list_common($self, $session, $current, $tempref, 1);
}

#
#
#
#

sub __is_ipv4_given {
    my ($flag, $member) = @_;

    if (not $flag) {
        return 1;
    } elsif ($flag == 2 and
        ref $member eq 'Infoblox::DHCP::Network' or
        ref $member eq 'Infoblox::DHCP::NetworkContainer' or
        is_ipv4_address($member)
    ) {
        return 1;
    } else {
        return 0;
    }
}

sub __ibap_o2i_network_list_common {

    my ($self, $session, $current, $tempref, $is_ipv6) = @_;

    return (1, 1, undef) unless defined $$tempref{$current};
    return (0) unless ref $$tempref{$current} eq 'ARRAY';

    my @res;

    foreach my $member (@{$$tempref{$current}}) {
        my $temp = {
            'network'      => $member,
            'network_view' => $$tempref{'network_view'},
        };

        my @return;

        if (__is_ipv4_given($is_ipv6, $member)) {
            @return = ibap_o2i_network($self, $session, 'network', $temp);
        } else {
            @return  = ibap_o2i_ipv6_network($self, $session, 'network', $temp);
        }
        
        my ($success, $ignore, $result) = @return;
        return (0) unless $success;
        next if $ignore;
            
        if ($result->type() eq 'object_id') {
            #
            $result = tObjIdRef(${$result->value()}{'id'});
        }
        push @res, $result;
    }

    return (1, 0, tIBType('ArrayOfBaseObject', \@res));
}

#
#
#
#
#
#
sub ibap_o2i_network
{
   my ($self, $session, $current, $tempref, $type) = @_;
   return __ibap_o2i_network_common($self, $session, $current,
                                         $tempref, $type, 0);
}

#
#
#
#
#
#
sub ibap_o2i_ipv6_network
{
   my ($self, $session, $current, $tempref, $type) = @_;
   return __ibap_o2i_network_common($self, $session, $current,
                                         $tempref, $type, 1);
}

#
#
#
sub __ibap_o2i_network_common {

    my ($self, $session, $current, $tempref, $type, $is_ipv6) = @_;

    return (1, 0, undef) unless defined $$tempref{$current};

    my ($network, $netmask, $nview, $t, $is_nwc);

    $t = $$tempref{$current};
    $is_nwc = (ref $t eq 'Infoblox::DHCP::NetworkContainer' or
               ref $t eq 'Infoblox::DHCP::IPv6NetworkContainer');

    #
    if (
        ref $t eq 'Infoblox::DHCP::Network' or
        ref $t eq 'Infoblox::DHCP::NetworkContainer'
    ) {
        unless ($t->__object_id__()) {
            $network = $t->network();
            $netmask = $t->can('netmask') && $t->netmask();
            $nview   = $t->network_view()->name() if $t->network_view();

            unless ($netmask) {
                my $ok;
                ($ok, $network, $netmask) = ip_address_munger($network, 1, 0, 1, $session);
                return (0) unless $ok;
            }
        }
    #
    } elsif (
        ref $t eq 'Infoblox::DHCP::IPv6Network' or
        ref $t eq 'Infoblox::DHCP::IPv6NetworkContainer'
    ) {
        unless ($t->__object_id__()) {
            $network = $t->network();
            $nview   = $t->network_view()->name() if $t->network_view();

            my $ok;
            ($ok, $network, $netmask) = ip_address_munger($network, 0, 0, 0, $session);

            if (!$network || !$netmask) {
                #
                $network = $t;
                $netmask = undef;
            }
        }
    #
    } else {
        if ($t =~ /\//) {
            ($network, $netmask) = split /\//, $t;

            if (!$is_ipv6 && $netmask =~ m/^[0-9]{1,2}$/ ) {
                $netmask = cidr_to_mask($netmask);
            }
        } elsif ($type eq 'search') {
           #
           $network = $t;
        }
        
        #
        if ($$tempref{'network_view'}) {
            if (ref($$tempref{'network_view'}) eq 'Infoblox::DHCP::View') {
                $nview = $$tempref{'network_view'}->name();
            } else {
                $nview = $$tempref{'network_view'};
            }
       }
   }

    if ($network) {
        my @fields = ({
            'field' => 'address',
            'value' => ibap_value_o2i_string($network),
        });

        if ($netmask) {
            $netmask = mask_to_bits($netmask) || $netmask;
            push @fields, {
                'search_type' => 'EXACT',
                'field'       => 'cidr',
                'value'       => ibap_value_o2i_int($netmask),
            };
       }

       push @fields, __network_view_readfield($nview);

       my $ibap_object_type = $is_ipv6 ? 'IPv6Network' : 'Network';
       $ibap_object_type .= 'Container' if $is_nwc;

       if ($type && $type eq 'search') {
           return (1, 0, ibap_readfieldlist_simple($ibap_object_type, \@fields));
       }

       my $error_tag = 'network=' . ($netmask ? $network . '/' . $netmask : $network);
       return (1, 0, ibap_readfield_simple($ibap_object_type, \@fields, undef, $error_tag));

   } elsif (ref($t) && $t->can('__object_id__')) {
       return (1, 0, tObjId($t->__object_id__()));
   } else {
       #
       set_error_codes(1012, "Error parsing the network value ($t)", $session);
       return (0);
   }
}

sub __network_view_readfield {
    my $nview = shift;
    if ($nview) {
        return {
            'search_type' => 'EXACT',
            'field'       => 'network_view',
            'value'       => ibap_readfield_simple_string('NetworkView', 'name', $nview, 'network_view'),
        };
    } else {
        return {
            'search_type' => 'EXACT',
            'field'       => 'network_view',
            'value'       => ibap_readfield_simple('NetworkView', 'is_default', tBool(1), 'network_view=(default network view)'),
        };
    }
}

#
#
#
#
#
#
#

#
sub ibap_o2i_network_string
{
	my ($self, $session, $current, $tempref, $type) = @_;

	my (@return_args, $addr_type);

	if (defined $$tempref{$current}) {
		my $network = $$tempref{$current};
        my $netmask = $$tempref{'netmask'};

        my $addr = $network;

        #
        #
        #
        #
        #
        #
        #
        unless ($netmask) {
            ($addr_type, $addr, $netmask) = ip_address_munger($network,1,0,1,$session);

            unless ($addr_type) {
                if ($type) {
                    #
                    $addr = $network;
                    $netmask = undef;

                    #
                    set_error_codes(0, undef, $session);
                }
                else {
                    return(0);
                }
            }
        }

		push @return_args, 1;
		push @return_args, 0;
		push @return_args, ibap_value_o2i_string($addr);

		if ($netmask) {
			#
            my %extra_write_arg;
            $extra_write_arg{'field'} = 'cidr';
            if ($addr_type == 2) {
                #
                $extra_write_arg{'value'} = ibap_value_o2i_int($netmask);
            } else {
                my $t = mask_to_bits($netmask);
                if ($t) {
                    $extra_write_arg{'value'} = ibap_value_o2i_int($t);
                }
                else {
                    $extra_write_arg{'value'} = ibap_value_o2i_int($netmask);
                }
            }
            push @return_args, \%extra_write_arg;
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, undef;
	}

	return @return_args;
}

sub ibap_arg_remote_ddns_zone_list
{
	my ($self, $session, $current, $tempref, $fqdn_field) = @_;
	my @return_args;
	my @newlist;

	if (not defined $$tempref{$current}) {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, $$tempref{$current};
	} else {
		if (ref ($$tempref{$current}) eq 'ARRAY') {
			my @list=@{$$tempref{$current}};

			foreach my $member (@list) {
				my %sub_write_arg;

                #
                #
                #
                #
                #
                $fqdn_field = 'name' unless defined $fqdn_field;
				if ($member->can($fqdn_field) && $member->$fqdn_field()) {
					return unless $sub_write_arg{'fqdn'} = ibap_value_o2i_string($member->$fqdn_field(),'fqdn',$session);
				} else {
                    $sub_write_arg{'fqdn'} = '';
				}

				if (defined $member->ipv4addr()) {
					$sub_write_arg{'server_address'} = $member->ipv4addr();
				} elsif (defined $member->ipv6addr()) {
					$sub_write_arg{'server_address'} = $member->ipv6addr();
				} else {
					$sub_write_arg{'server_address'} = '';
				}

				#
				#
				#
				if (defined $member->gss_tsig_domain()) {
					if (defined $member->TSIGkey()) {
						set_error_codes(1104, 'Argument error: Cannot specify both gss_tsig_domain and TSIGkey attributes in external_ddns_primaries', $session);
						return;
					}
				if (defined $member->TSIGname()) {
						set_error_codes(1104, 'Argument error: Cannot specify both gss_tsig_domain and TSIGname attributes in external_ddns_primaries', $session);
						return;
					}
				}
				if (defined $member->gss_tsig_dns_principal()) {
					if (defined $member->TSIGkey()) {
						set_error_codes(1104, 'Argument error: Cannot specify both gss_tsig_dns_principal and TSIGkey attributes in external_ddns_primaries', $session);
						return;
					}
					if (defined $member->TSIGname()) {
						set_error_codes(1104, 'Argument error: Cannot specify both gss_tsig_dns_principal and TSIGname attributes in external_ddns_primaries', $session);
						return;
					}
				}

				if (defined $member->TSIGname()) {
					$sub_write_arg{'use_tsig_key'} = 'tsig';
					$sub_write_arg{'tsig_key_name'} = $member->TSIGname();
					$sub_write_arg{'tsig_key_alg'} = $member->TSIGalgorithm();
					$sub_write_arg{'tsig_key'} = $member->TSIGkey();
				} elsif (defined $member->gss_tsig_domain()) {
					$sub_write_arg{'use_tsig_key'} = 'gss-tsig';
					$sub_write_arg{'gss_tsig_domain'} = $member->gss_tsig_domain();
					$sub_write_arg{'gss_tsig_dns_principal'} = $member->gss_tsig_dns_principal();
				} else {
					$sub_write_arg{'use_tsig_key'} = 'none';
				}

				push @newlist, tIBType('remote_ddns_zone', \%sub_write_arg);
			}
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, tIBType('ArrayOfremote_ddns_zone',
                                                   \@newlist);
		} else {
			push @return_args, 0;
		}
	}
	return @return_args;
}

sub ibap_i2o_remote_ddns_zone_list_convert
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref, $fqdn_field) = @_;
	my @newlist;

	if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
		my @zones = @{$$ibap_object_ref{$current}};

		foreach my $zoneref (@zones) {
			my $nameserver = Infoblox::DNS::Nameserver->__new__();

			if ($$zoneref{'server_address'} =~ m/:/) {
				$nameserver->ipv6addr($$zoneref{'server_address'});
			}
			else {
				$nameserver->ipv4addr($$zoneref{'server_address'});
			}


            #
            #
            #
            #
            #
            $fqdn_field = 'name' unless defined $fqdn_field;
			$nameserver->$fqdn_field($$zoneref{'fqdn'});

			if ($$zoneref{'use_tsig_key'} eq 'tsig') {
				$nameserver->TSIGname($$zoneref{'tsig_key_name'});
				$nameserver->TSIGalgorithm($$zoneref{'tsig_key_alg'});
				$nameserver->TSIGkey($$zoneref{'tsig_key'});
			} elsif ($$zoneref{'use_tsig_key'} eq 'gss-tsig') {
				$nameserver->gss_tsig_domain($$zoneref{'gss_tsig_domain'});
				$nameserver->gss_tsig_dns_principal($$zoneref{'gss_tsig_dns_principal'});
			}

			push @newlist, $nameserver;
		}

		return \@newlist;
	} else {
		return;
	}
}

sub ibap_arg_bootp_props
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;
	my %sub_write_arg;

	push @return_args, 0;

	return unless $sub_write_arg{'boot_file'} = ibap_value_o2i_string_undef_to_empty($$tempref{'bootfile'});
	return unless $sub_write_arg{'boot_server'} = ibap_value_o2i_string_undef_to_empty($$tempref{'bootserver'});
	return unless $sub_write_arg{'next_server'} = ibap_value_o2i_string_undef_to_empty($$tempref{'nextserver'});

	if ($$tempref{'use_boot_file'}) {
		return unless $sub_write_arg{'use_boot_file'} = ibap_value_o2i_boolean($$tempref{'use_boot_file'}, 'internal:use_boot_file', $session);
	}
	else {
		$sub_write_arg{'use_boot_file'} = ibap_value_o2i_boolean(0, 'internal:use_boot_file', $session);
	}

	if ($$tempref{'use_boot_server'}) {
		return unless $sub_write_arg{'use_boot_server'} = ibap_value_o2i_boolean($$tempref{'use_boot_server'}, 'internal:use_boot_server', $session);
	}
	else {
		$sub_write_arg{'use_boot_server'} = ibap_value_o2i_boolean(0, 'internal:use_boot_server', $session);
	}

	if ($$tempref{'use_next_server'}) {
		return unless $sub_write_arg{'use_next_server'} = ibap_value_o2i_boolean($$tempref{'use_next_server'}, 'internal:use_next_server', $session);
	}
	else {
		$sub_write_arg{'use_next_server'} = ibap_value_o2i_boolean(0, 'internal:use_next_server', $session);
	}

	if ($$tempref{'deny_bootp'}) {
		return unless $sub_write_arg{'deny_bootp'} = ibap_value_o2i_boolean($$tempref{'deny_bootp'},'deny_bootp',$session);
	}

	if ($$tempref{'use_deny_bootp'}) {
		return unless $sub_write_arg{'use_deny_bootp'} = ibap_value_o2i_boolean($$tempref{'use_deny_bootp'}, 'internal:use_deny_bootp', $session);
	}
	else {
		$sub_write_arg{'use_deny_bootp'} = ibap_value_o2i_boolean(0, 'internal:use_deny_bootp', $session);
	}

	shift @return_args;

	push @return_args, 1;
	push @return_args, 0;
	push @return_args, tIBType('bootp_props', \%sub_write_arg);

	return @return_args;
}

sub ibap_i2o_bootp_props_util
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref, $no_use_flags) = @_;

	if ($$ibap_object_ref{$current}) {
		if ($no_use_flags || $$ibap_object_ref{$current}{'use_boot_file'}) {
			if ($$ibap_object_ref{$current}{'boot_file'}) {
				if ($self->can('bootfile')) {
					$self->bootfile($$ibap_object_ref{$current}{'boot_file'});
				}
			}
		}

		if ($no_use_flags || $$ibap_object_ref{$current}{'use_boot_server'}) {
			if ($$ibap_object_ref{$current}{'boot_server'}) {
				if ($self->can('bootserver')) {
					$self->bootserver($$ibap_object_ref{$current}{'boot_server'});
				}
			}
		}

		if ($no_use_flags || $$ibap_object_ref{$current}{'use_next_server'}) {
			if ($$ibap_object_ref{$current}{'next_server'}) {
				if ($self->can('nextserver')) {
					$self->nextserver($$ibap_object_ref{$current}{'next_server'});
				}
			}
		}

		if ($no_use_flags || $$ibap_object_ref{$current}{'use_deny_bootp'}) {
			if (defined $$ibap_object_ref{$current}{'deny_bootp'}) {
				if ($self->can('deny_bootp')) {
					$self->deny_bootp(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'deny_bootp'}));
				}
			}
		}
	}
}

sub ibap_i2o_bootp_props
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    return ibap_i2o_bootp_props_util($self, $session, $current, $ibap_object_ref, $return_object_cache_ref, 0);
}

sub ibap_i2o_bootp_props_no_use_flags
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    return ibap_i2o_bootp_props_util($self, $session, $current, $ibap_object_ref, $return_object_cache_ref, 1);
}

sub is_special_option_broadcast
{
	my $opt = shift;
	my $class = $opt->vendor_class();
	return 0 if (defined $class && ($class ne 'DHCP' && $class ne 'DHCPv6'));

	my $lopt_type = defined($opt->type()) ? $opt->type() : '';
	my $lopt_name = defined($opt->name()) ? $opt->name() : '';
	my $lopt_num = defined($opt->num()) ? $opt->num() : '';

	return ($lopt_type eq 'broadcast' || $lopt_name eq 'broadcast' || $lopt_name eq 'broadcast-address' || $lopt_num eq '28' || $lopt_type eq '28');
}

sub is_special_option_domain_name
{
	my $opt = shift;
	my $class = $opt->vendor_class();
	return 0 if (defined $class && ($class ne 'DHCP' && $class ne 'DHCPv6'));

	my $lopt_type = defined($opt->type()) ? $opt->type() : '';
	my $lopt_name = defined($opt->name()) ? $opt->name() : '';
	my $lopt_num = defined($opt->num()) ? $opt->num() : '';

	return ($lopt_type eq 'domain-name' || $lopt_name eq 'domain-name' || $lopt_num eq '15' || $lopt_type eq '15');
}

sub is_special_option_routers
{
	my $opt = shift;
	my $class = $opt->vendor_class();
	return 0 if (defined $class && ($class ne 'DHCP' && $class ne 'DHCPv6'));

	my $lopt_type = defined($opt->type()) ? $opt->type() : '';
	my $lopt_name = defined($opt->name()) ? $opt->name() : '';
	my $lopt_num = defined($opt->num()) ? $opt->num() : '';

	return ($lopt_type eq 'routers' || $lopt_name eq 'routers' || $lopt_num eq '3' || $lopt_type eq '3');
}

sub is_special_option_lease_time
{
	my $opt = shift;
	my $class = $opt->vendor_class();
	return 0 if (defined $class && ($class ne 'DHCP' && $class ne 'DHCPv6'));

	my $lopt_type = defined($opt->type()) ? $opt->type() : '';
	my $lopt_name = defined($opt->name()) ? $opt->name() : '';
	my $lopt_num = defined($opt->num()) ? $opt->num() : '';

	return ($lopt_type eq 'lease-time' || $lopt_name eq 'lease-time' || $lopt_name eq 'dhcp-lease-time' || $lopt_num eq '51' || $lopt_type eq '51');
}

sub is_special_option_nameservers
{
	my $opt = shift;
	my $class = $opt->vendor_class();
	return 0 if (defined $class && ($class ne 'DHCP' && $class ne 'DHCPv6'));

	my $lopt_type = defined($opt->type()) ? $opt->type() : '';
	my $lopt_name = defined($opt->name()) ? $opt->name() : '';
	my $lopt_num = defined($opt->num()) ? $opt->num() : '';

	return ($lopt_type eq 'nameservers' || $lopt_name eq 'nameservers' || $lopt_name eq 'domain-name-servers' || $lopt_num eq '6' || $lopt_type eq '6');
}

sub ibap_o2i_common_dhcp_props
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;
	my %sub_write_arg;

	push @return_args, 0;

    my $self_is_template = (ref($self) =~ m/Template/);

	if ($$tempref{'pxe_lease_time'}) {
		return unless $sub_write_arg{'pxe_lease_time'} = ibap_value_o2i_int($$tempref{'pxe_lease_time'},'pxe_lease_time',$session);
	}

	if ($$tempref{'use_pxe_lease_time'}) {
		return unless $sub_write_arg{'use_pxe_lease_time'} = ibap_value_o2i_boolean($$tempref{'use_pxe_lease_time'},'internal:use_pxe_lease_time',$session);
		return unless $sub_write_arg{'enable_pxe_lease_time'} = tBool(1);
	}
	else {
		return unless $sub_write_arg{'use_pxe_lease_time'} = ibap_value_o2i_boolean(0, 'internal:use_pxe_lease_time', $session);
		return unless $sub_write_arg{'enable_pxe_lease_time'} = tBool(0);
	}

	if ($$tempref{'options'}) {
		my @options = @{$$tempref{'options'}};
		my @processed_options;

		foreach my $opt (@options) {
			#
			if (is_special_option_broadcast($opt)) {
                if ($self_is_template) {
				    return unless $sub_write_arg{'broadcast_address_offset'} = ibap_value_o2i_int($opt->value(),'broadcast_address_offset',$session);
                } else {
				    return unless $sub_write_arg{'broadcast_address'} = ibap_value_o2i_string($opt->value(),'broadcast_address',$session);
                }
			} elsif (is_special_option_domain_name($opt)) {
				return unless $sub_write_arg{'domain_name'} = ibap_value_o2i_string($opt->value(),'domain_name',$session);
			} elsif (is_special_option_routers($opt)) {
				my (@routers, @rlist);

				if (defined($opt->value())) {
					@rlist=split /,/,$opt->value();
				}

                if ($self_is_template) {
				    foreach my $addr (@rlist) {
                        push @routers, tIBType('router_template',
                            { offset => $addr });
                    }
				    $sub_write_arg{'router_templates'} = tIBType('ib:ArrayOfrouter_template', \@routers);
                } else {
				    foreach my $addr (@rlist) {
                        push @routers, tIBType('custom_router',
                            { address => $addr });
                    }
				    $sub_write_arg{'routers'} = tIBType('ib:ArrayOfcustom_router', \@routers);
				}
			} elsif (is_special_option_lease_time($opt)) {
				return unless $sub_write_arg{'lease_time'} = ibap_value_o2i_int($opt->value(),'lease_time',$session);
			} elsif (is_special_option_nameservers($opt)) {
				my (@nameservers, @nlist);

				if (defined($opt->value())) {
					@nlist=split /,/,$opt->value();
				}

				foreach my $addr (@nlist) {
                                    push @nameservers, tIBType('custom_dns_server',
                                                           { address => $addr });
				}
				$sub_write_arg{'domain_name_servers'} = tIBType('ArrayOfcustom_dns_server', \@nameservers);
			} else {
				push @processed_options, $opt;
			}
		}

		if ($$tempref{'use_lease_time'}) {
			return unless $sub_write_arg{'use_lease_time'} = ibap_value_o2i_boolean($$tempref{'use_lease_time'},'internal:use_lease_time',$session);
		}
		else {
			$sub_write_arg{'use_lease_time'} = ibap_value_o2i_boolean(0, 'internal:use_lease_time', $session);
		}

        my $use_broadcast_address_flag = 'use_broadcast_address';
        if ($self_is_template) {
            $use_broadcast_address_flag = 'use_broadcast_address_offset';
        }

		if ($$tempref{$use_broadcast_address_flag}) {
			return unless $sub_write_arg{$use_broadcast_address_flag} =
                ibap_value_o2i_boolean($$tempref{$use_broadcast_address_flag},'internal:${use_broadcast_address_flag}',$session);
		}
		else {
			$sub_write_arg{$use_broadcast_address_flag} = ibap_value_o2i_boolean(0, 'internal:${use_broadcast_address_flag}', $session);
		}

		if ($$tempref{'use_domain_name'}) {
			return unless $sub_write_arg{'use_domain_name'} = ibap_value_o2i_boolean($$tempref{'use_domain_name'},'internal:use_domain_name',$session);
		}
		else {
			$sub_write_arg{'use_domain_name'} = ibap_value_o2i_boolean(0, 'internal:use_domain_name', $session);
		}

		if ($$tempref{'use_domain_name_servers'}) {
			return unless $sub_write_arg{'use_domain_name_servers'} = ibap_value_o2i_boolean($$tempref{'use_domain_name_servers'},'internal:use_domain_name_servers',$session);
		}
		else {
			$sub_write_arg{'use_domain_name_servers'} = ibap_value_o2i_boolean(0, 'internal:use_domain_name_servers', $session);
		}

        my $use_routers_flag = 'use_routers';
        if ($self_is_template) {
            $use_routers_flag = 'use_router_templates';
        }

		if ($$tempref{$use_routers_flag}) {
    		return unless $sub_write_arg{$use_routers_flag} = ibap_value_o2i_boolean($$tempref{$use_routers_flag},'internal:${use_routers_flag}',$session);
		}
		else {
    		$sub_write_arg{$use_routers_flag} = ibap_value_o2i_boolean(0, 'internal:${use_routers_flag}', $session);
		}

		if (@processed_options) {
			$$tempref{'__temp_options__'}=\@processed_options;
			my @other_options = ibap_o2i_options_helper($self, $session, '__temp_options__',$tempref);
			undef $$tempref{'__temp_options__'};
			if (@other_options) {
				my $success=shift @other_options;
				if ($success) {
					my $ignore_value=shift @other_options;
					unless ($ignore_value) {
						$sub_write_arg{'options'} = shift @other_options;
					}
				} else {
					return;
				}
			}
			else {
				return;
			}
			$sub_write_arg{'use_options'} = ibap_value_o2i_boolean(1,'internal:use_options',$session);
			$sub_write_arg{'options'} = tIBType('ArrayOfcustom_option',$sub_write_arg{'options'});
		}
		else {
            #
			$sub_write_arg{'use_options'} = ibap_value_o2i_boolean(0,'internal:use_options',$session);
			$sub_write_arg{'options'} = tIBType('ArrayOfcustom_option', []);
		}
	}
	else {
		$sub_write_arg{'use_options'} = ibap_value_o2i_boolean(0,'internal:use_options',$session);
		$sub_write_arg{'use_lease_time'} = ibap_value_o2i_boolean(0, 'internal:use_lease_time', $session);
        if ($self_is_template) {
    		$sub_write_arg{'use_broadcast_address_offset'} = ibap_value_o2i_boolean(0, 'internal:use_broadcast_address', $session);
		    $sub_write_arg{'use_router_templates'} = ibap_value_o2i_boolean(0, 'internal:use_routers', $session);
        } else {
    		$sub_write_arg{'use_broadcast_address'} = ibap_value_o2i_boolean(0, 'internal:use_broadcast_address', $session);
		    $sub_write_arg{'use_routers'} = ibap_value_o2i_boolean(0, 'internal:use_routers', $session);
        }
		$sub_write_arg{'use_domain_name'} = ibap_value_o2i_boolean(0, 'internal:use_domain_name', $session);
		$sub_write_arg{'use_domain_name_servers'} = ibap_value_o2i_boolean(0, 'internal:use_domain_name_servers', $session);
	}

	if ($$tempref{'ignore_dhcp_option_list_request'}) {
		return unless $sub_write_arg{'ignore_client_requested_options'} = ibap_value_o2i_boolean($$tempref{'ignore_dhcp_option_list_request'},'internal:ignore_dhcp_option_list_request',$session);
	}

	if ($$tempref{'use_ignore_client_requested_options'}) {
		return unless $sub_write_arg{'use_ignore_client_requested_options'} = ibap_value_o2i_boolean($$tempref{'use_ignore_client_requested_options'},'internal:use_ignore_client_requested_options',$session);
	}
	else {
		$sub_write_arg{'use_ignore_client_requested_options'} = ibap_value_o2i_boolean(0, 'internal:use_ignore_client_requested_options', $session);
	}

	shift @return_args;

	push @return_args, 1;
	push @return_args, 0;
	push @return_args, tIBType('common_dhcp_props', \%sub_write_arg);

	return @return_args;
}

sub ibap_i2o_common_dhcp_props_util
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref, $no_use_flags) = @_;
	my @newoptions = ();

	if ($$ibap_object_ref{$current}) {
		if ($no_use_flags or $$ibap_object_ref{$current}{'use_ignore_client_requested_options'}) {
			if (defined $$ibap_object_ref{$current}{'ignore_client_requested_options'}) {
				if ($self->can('ignore_dhcp_option_list_request')) {
					$self->ignore_dhcp_option_list_request(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'ignore_client_requested_options'}));
				}
			}
		}

		if ($no_use_flags or $$ibap_object_ref{$current}{'use_pxe_lease_time'}) {
			if ($$ibap_object_ref{$current}{'pxe_lease_time'}) {
				if ($self->can('pxe_lease_time')) {
					$self->pxe_lease_time($$ibap_object_ref{$current}{'pxe_lease_time'});
				}
			}
		}

		if ($no_use_flags or $$ibap_object_ref{$current}{'use_broadcast_address'}) {
			if ($$ibap_object_ref{$current}{'broadcast_address'}) {
				my $option = Infoblox::DHCP::Option->new(
														 'num'          => '28',
														 'value'   		=> $$ibap_object_ref{$current}{'broadcast_address'},
														 'name'     	=> 'broadcast', # XXX: we should really use broadcast-address
														 'vendor_class' => 'DHCP',
														 'type'     	=> 'broadcast',
														 'ipv4addr'   	=> $$ibap_object_ref{$current}{'broadcast_address'},
														);
				push @newoptions, $option;
			}
		}

		if ($no_use_flags or $$ibap_object_ref{$current}{'use_broadcast_address_offset'}) {
			if ($$ibap_object_ref{$current}{'broadcast_address_offset'}) {
				my $option = Infoblox::DHCP::Option->new(
														 'num'          => '28',
														 'value'   		=> $$ibap_object_ref{$current}{'broadcast_address_offset'},
														 'name'     	=> 'broadcast', # XXX: we should really use broadcast-address
														 'vendor_class' => 'DHCP',
														 'type'     	=> 'broadcast',
														 'ipv4addr'   	=> $$ibap_object_ref{$current}{'broadcast_address_offset'},
														);
				push @newoptions, $option;
			}
		}

		if ($no_use_flags or $$ibap_object_ref{$current}{'use_domain_name'}) {
			if ($$ibap_object_ref{$current}{'domain_name'}) {
				my $option = Infoblox::DHCP::Option->new(
														 'num'          => '15',
														 'value'   		=> $$ibap_object_ref{$current}{'domain_name'},
														 'name'     	=> 'domain-name',
														 'vendor_class' => 'DHCP',
														 'type'     	=> 'domain-name',
														 'value'   	=> $$ibap_object_ref{$current}{'domain_name'},
														);
				push @newoptions, $option;
			}
		}

		if ($no_use_flags or $$ibap_object_ref{$current}{'use_lease_time'}) {
			if ($$ibap_object_ref{$current}{'lease_time'}) {
				my $option = Infoblox::DHCP::Option->new(
														 'num'          => '51',
														 'value'   		=> $$ibap_object_ref{$current}{'lease_time'},
														 'name'     	=> 'lease-time', # XXX: we should really use dhcp-lease-time
														 'vendor_class' => 'DHCP',
														 'type'     	=> 'lease-time',
														 'seconds'   	=> $$ibap_object_ref{$current}{'lease_time'},
														);
				push @newoptions, $option;
			}
		}

		if ($no_use_flags or $$ibap_object_ref{$current}{'use_routers'}) {
			my $option;

			if ($$ibap_object_ref{$current}{'routers'}) {
				my @routers=@{$$ibap_object_ref{$current}{'routers'}};
				my @trouter;

				foreach my $current (@routers) {
					push @trouter, ${$current}{'address'};
				}

				$option = Infoblox::DHCP::Option->new(
													  'num'          => '3',
													  'value'   	 => join(',',@trouter),
													  'name'     	 => 'routers',
													  'vendor_class' => 'DHCP',
													  "type"     	 => 'routers',
													  "ipv4addrs"    => \@trouter,
													 );
			}
			else {
				$option = Infoblox::DHCP::Option->new(
													  'num'          => '3',
													  'value'   	 => '',
													  'name'     	 => 'routers',
													  'vendor_class' => 'DHCP',
													  "type"     	 => 'routers',
													  "ipv4addrs"    => [],
													 );
			}
			push @newoptions, $option;
		}

		if ($$ibap_object_ref{$current}{'use_router_templates'}) {
			my $option;

			if ($$ibap_object_ref{$current}{'router_templates'}) {
				my @routers=@{$$ibap_object_ref{$current}{'router_templates'}};
				my @trouter;

				foreach my $current (@routers) {
					push @trouter, ${$current}{'offset'};
				}

				$option = Infoblox::DHCP::Option->new(
													  'num'          => '3',
													  'value'   	 => join(',',@trouter),
													  'name'     	 => 'routers',
													  'vendor_class' => 'DHCP',
													  "type"     	 => 'routers',
													  "ipv4addrs"    => \@trouter,
													 );
			} else {
				$option = Infoblox::DHCP::Option->new(
													  'num'          => '3',
													  'value'   	 => '',
													  'name'     	 => 'routers',
													  'vendor_class' => 'DHCP',
													  "type"     	 => 'routers',
													  "ipv4addrs"    => [],
													 );
			}
			push @newoptions, $option;
		}

		if ($no_use_flags or $$ibap_object_ref{$current}{'use_domain_name_servers'}) {
			my $option;

			if ($$ibap_object_ref{$current}{'domain_name_servers'}) {
				my @servers=@{$$ibap_object_ref{$current}{'domain_name_servers'}};
				my @tserver;

				foreach my $current (@servers) {
					push @tserver, ${$current}{'address'};
				}

				$option = Infoblox::DHCP::Option->new(
													  'num'          => '6',
													  'value'   	 => join(',',@tserver),
													  'name'     	 => 'nameservers', # XXX: we should really use domain-name-servers
													  'vendor_class' => 'DHCP',
													  "type"     	 => 'nameservers',
													  "ipv4addrs"    => \@tserver,
													 );
			}
			else {
				$option = Infoblox::DHCP::Option->new(
													  'num'          => '6',
													  'value'   	 => '',
													  'name'     	 => 'nameservers', # XXX: we should really use domain-name-servers
													  'vendor_class' => 'DHCP',
													  "type"     	 => 'nameservers',
													  "ipv4addrs"    => [],
													 );
			}
			push @newoptions, $option;
		}

		if ($no_use_flags or $$ibap_object_ref{$current}{'use_options'}) {
			if ($$ibap_object_ref{$current}{'options'}) {
                my $x = ibap_i2o_options_helper($$ibap_object_ref{$current}{'options'});
                foreach (@$x) {
                    push @newoptions, $_;
                }
			}
		}
	}

    $self->options(\@newoptions) if ($self->can('options'));
}

sub ibap_i2o_common_dhcp_props
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    return ibap_i2o_common_dhcp_props_util($self, $session, $current, $ibap_object_ref, $return_object_cache_ref, 0);
}

sub ibap_i2o_common_dhcp_props_no_use_flags
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    return ibap_i2o_common_dhcp_props_util($self, $session, $current, $ibap_object_ref, $return_object_cache_ref, 1);
}

sub ibap_o2i_options
{
    my ($self, $session, $current, $tempref) = @_;

    my ($t1,$t2,$opt) = ibap_o2i_options_helper($self, $session, $current, $tempref);
    if ($opt && ref($opt) eq 'ARRAY') {
        $opt = tIBType('ArrayOfcustom_option',$opt);
    }

    return ($t1,$t2,$opt);
}

sub ibap_i2o_options
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($ibap_object_ref->{$current} && ref($ibap_object_ref->{$current}) eq 'ARRAY') {
        return ibap_i2o_options_helper($ibap_object_ref->{$current});
    }
    else {
        return undef;
    }
}

sub ibap_i2o_options_helper
{
    my ($option_array) = @_;

    my @newoptions;
    foreach my $opt (@$option_array) {
        my $nopt = get_custom_option_num($$opt{'name'},$$opt{'space'});
        my $option;

        if ($nopt) {
            $option = Infoblox::DHCP::Option->new(
                                                  'name'     	 => $$opt{'name'},
                                                  'num' 		 => $nopt,
                                                  'type' 		 => $nopt,
                                                  'value'    	 => $$opt{'value'},
                                                  'vendor_class' => $$opt{'space'},
                                                 );
        } else {
            #
            $option = Infoblox::DHCP::Option->new(
                                                  'name'     	 => $$opt{'name'},
                                                  'value'    	 => $$opt{'value'},
                                                  'vendor_class' => $$opt{'space'},
                                                 );
            $option->num($$opt{'code'}) if defined $$opt{'code'};
        }
        push @newoptions, $option;
    }

    return \@newoptions;
}

sub ibap_o2i_options_helper
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (not defined $$tempref{$current}) {
		push @return_args, 1;
		push @return_args, 1;
		push @return_args, $$tempref{$current};
	} else {
		if (ref ($$tempref{$current}) eq 'ARRAY') {
			my @options;
			my @list=@{$$tempref{$current}};

			foreach my $opt (@list) {
				my (%topt, $space);

                #
                #
                #
                #
                #
				if ($opt->{'vendor_class'}) {
                    $space = $opt->vendor_class();
				} else {
                    if (index(ref($self),'v6') > -1 || $current eq 'ipv6_options') { # for v6 objects the default is different
                        $space = 'DHCPv6';
                    }
                    else {
                        $space = 'DHCP';
                    }
				}
                return (0) unless $topt{'space'} = ibap_value_o2i_string($space,'vendor_class',$session);

				my $optname = $opt->name();
				unless ($opt->name()) {
					if ($opt->num()) {
						$optname = get_custom_option_name($opt->num(),$space);
					}
					elsif ($opt->type()) {
						#
						$optname = get_custom_option_name($opt->type(),$space);
					}
					else {
						return;
					}
				}

                #
                #
                #
                #
                #
                #
                if ($space eq 'DHCP' &&
                    ($optname eq 'dhcp-renewal-time' ||
                        $optname eq 'dhcp-rebinding-time') &&
                    ($current eq 'ipv6_options' ||
                        (index(ref($self), 'Infoblox::DHCP::IPv6') > -1))) {
                    #
                    #
                    $topt{'is_ipv4'} = tBool(0);
                }

				return unless $topt{'name'} = ibap_value_o2i_string($optname,$optname,$session);
				return unless $topt{'value'} = ibap_value_o2i_string_undef_to_empty($opt->value(),$opt->value(),$session);

				if (defined $topt{'name'}) {
                                    push @options, \%topt;
				}
			}
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, \@options;
		} else {
			push @return_args, 0;
		}
	}
	return @return_args;
}

#
our %papi_object_type_from_wsdl;
our %papi_partial_subobjects;
sub register_wsdl_type
{
    my ($key, $value, $partial_supported) = @_;
    $papi_object_type_from_wsdl{$key} = $value;
    $papi_partial_subobjects{$value} = $partial_supported if $partial_supported;
}

sub ibap_serialize_subobject_request
{
  #
    my ($session, $objref, $ibtype, $parent, $dynamic) = @_;

    my $write_fields=$objref->__object_to_ibap__($session->get_ibap_server(),$session);
    return  unless($write_fields);

    if ($parent) {
        push @$write_fields, {
                              'field' => 'parent',
                              'value' => tObjIdRef('..'),
                             };
    }

    if ($dynamic) {
        return {
                object_type => $objref->__ibap_object_type__(),
                write_fields => tIBType('ArrayOfwrite_field',$write_fields)
               };
    }
    else {
        return {
                object_type => $ibtype,
                write_fields => tIBType('ArrayOfwrite_field',$write_fields)
               };
    }
}

sub ibap_serialize_subobject_list
{
    my ($session, $listref, $ibtype, $parent, $dynamic) = @_;

    my @newlist;
    if (defined $listref && (ref($listref) eq 'ARRAY')) {
        foreach (@{$listref}) {
            my $request=ibap_serialize_subobject_request($session, $_, $ibtype, $parent, $dynamic);
            return (0) unless $request;

            push @newlist, $request;
        }
    }

    return tIBType('ArrayOfsub_object', \@newlist);
}

sub ibap_serialize_subobject
{
    my ($session, $objref, $ibtype, $parent, $dynamic) = @_;

    my $request=ibap_serialize_subobject_request($session, $objref, $ibtype, $parent, $dynamic);
    return (0) unless $request;

    return tIBType('sub_object',
    $request);
}

sub ibap_serialize_substruct_list
{
    my ($session, $listref, $ibtype) = @_;

    my @newlist;
    if (defined $listref && (ref($listref) eq 'ARRAY')) {
        foreach (@{$listref}) {
            return (0) unless $_; # Not legal to have empties here

            my $write_fields=$_->__object_to_ibap__($session->get_ibap_server(),$session);
            return (0) unless($write_fields);

            my %ssubstruct;
            foreach (@$write_fields) {
                $ssubstruct{$_->{'field'}} = $_->{'value'};
            }

            push @newlist, tIBType($ibtype, \%ssubstruct);
        }
    }

    return tIBType('ArrayOf' . $ibtype, \@newlist);
}

sub ibap_serialize_substruct
{
    my ($session, $structref, $ibtype) = @_;

    my %substruct;
    if($structref) {
        my $write_fields=$structref->__object_to_ibap__($session->get_ibap_server(),$session);
        return (0) if(!$write_fields);

        foreach (@$write_fields) {
            $substruct{$_->{'field'}} = $_->{'value'};
        }
    }

    return tIBType($ibtype, \%substruct);
}

sub ibap_i2o_generic_object_convert_to_list_of_one
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $return_object = ibap_i2o_generic_object_convert($self, $session, $current, $ibap_object_ref, $return_object_cache_ref);

    if ($return_object) {
        my @list = ($return_object);
        if (isweak($return_object)) {
            weaken($list[0]);
        }
        return \@list;
    }
    else {
        return;
    }
}

sub ibap_i2o_generic_object_convert_partial
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $return_object = ibap_i2o_generic_object_convert($self, $session, $current, $ibap_object_ref, $return_object_cache_ref);
    $return_object->{'__partial__'} = 1 if $return_object;
    return $return_object;
}

sub object_helper
{
    my ($return_object,$ref,$id,$return_object_cache_ref,$session,$type) = @_;

    #
    #
    #
    if ($id) {
        ${$return_object_cache_ref}{$id} = $return_object;
        weaken(${$return_object_cache_ref}{$id});
        $return_object->__object_id__($id);
        ${$return_object_cache_ref}{'__recursive__'}{$id} = 1;
    }

    my $server = $session ? $session->get_ibap_server() : undef;
    $return_object->__ibap_to_object__($ref, $server, $session, $return_object_cache_ref);

    if ($id) {
        delete ${$return_object_cache_ref}{'__recursive__'}{$id};
    }

    #
    if (${$return_object_cache_ref}{'__partial_subobjects__'} && $papi_partial_subobjects{$type}) {
        $return_object->{'__partial__'} = 1;
    }

    return $return_object;
}

sub ibap_i2o_generic_object_convert
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
        #
        if (defined $$ibap_object_ref{$current}->{'object_id'}->{'id'}) {
            if (${$return_object_cache_ref}{$$ibap_object_ref{$current}->{'object_id'}->{'id'}}) {
                #
                #
                #
                #
                #
                return ${$return_object_cache_ref}{$$ibap_object_ref{$current}->{'object_id'}->{'id'}} ;
            }
        }

        my $t = $papi_object_type_from_wsdl{ref($$ibap_object_ref{$current})};

        if ($t) {
            #
            #
            my $return_object = $t->__new__();
            my $id = defined $$ibap_object_ref{$current}{'object_id'}{'id'} ? $$ibap_object_ref{$current}{'object_id'}{'id'} : undef;
            return object_helper($return_object,$$ibap_object_ref{$current},$id,$return_object_cache_ref,$session,$t);
        }
        else {
            return $$ibap_object_ref{$current};
        }
    } else {
        return;
    }
}

sub ibap_i2o_generic_object_list_convert
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        my @objects = @{$$ibap_object_ref{$current}};

		foreach my $objectref (@objects) {
			#
            if (defined $objectref->{'object_id'}->{'id'} && ${$return_object_cache_ref}{$objectref->{'object_id'}->{'id'}}) {
				push @newlist, ${$return_object_cache_ref}{$objectref->{'object_id'}->{'id'}};
                weaken($newlist[-1]);
            }
			else {
                my $t = $papi_object_type_from_wsdl{ref($objectref)};

                unless ($t) {
                    #
                    #

                    push @newlist, $objectref;
                    next;
                }

				my $return_object = $t->__new__();
                my $id = defined $objectref->{'object_id'}->{'id'} ? defined $objectref->{'object_id'}->{'id'} : undef;

                push @newlist, object_helper($return_object,$objectref,$id,$return_object_cache_ref,$session,$t);
			}
        }
        return \@newlist;
    } else {
        return;
    }
}


#
#
sub ibap_i2o_generic_object_list_convert_no_cache {
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    return ibap_i2o_generic_object_list_convert($self, $session, $current, $ibap_object_ref, {});
}

sub ibap_i2o_generic_object_convert_no_cache {
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    return ibap_i2o_generic_object_convert($self, $session, $current, $ibap_object_ref, {});
}

sub ibap_i2o_generic_object_list_convert_partial
{
    my $list = ibap_i2o_generic_object_list_convert(@_);

    if ($list and ref($list) eq 'ARRAY') {
        foreach (@$list) {
            $_->{'__partial__'} = 1;
        }
    }

    return $list;
}

my %ibap_object_type_cache = ();

sub ibap_object_type_helper
{
    my ($self, $current, $object) = @_;

    if (defined $ibap_object_type_cache{ref($self)} and exists $ibap_object_type_cache{ref($self)}->{$current}) {
        return $ibap_object_type_cache{ref($self)}->{$current};
    }

    if (ref($object) and $object->can('__ibap_object_type__')) {
        #
        return $object->__ibap_object_type__();
    } else {
        $ibap_object_type_cache{ref($self)} = {} unless defined $ibap_object_type_cache{ref($self)};

        no strict 'refs';

        my $allow_members = \%{ref($self).'::_allowed_members'};

        my @types = ();

        if ($allow_members and ref $$allow_members{$current} eq 'HASH') {

            @types = keys %{$$allow_members{$current}{validator}}
                if ref $$allow_members{$current}{validator} eq 'HASH';
        }

        $ibap_object_type_cache{ref($self)}->{$current} = (scalar(@types) == 1 and $types[0] =~ /^Infoblox::/) ? ${$types[0].'::_object_type'} : undef;
        return $ibap_object_type_cache{ref($self)}->{$current};
    }
}

sub ibap_o2i_generic_struct_convert
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $tempref->{$current}) {
        my $object_type = ibap_object_type_helper($self, $current, $tempref->{$current});

        if (defined $object_type) {
            my @res = ibap_serialize_substruct($session, $$tempref{$current}, $object_type);
            return (@res and $res[0] ? (1, 0, @res) : (0));
        } else {
            set_error_codes(1012, "Cannot define object type of structure in $current of ".ref($self));
            return (0);
        }
    } else {
        return (1, 1, undef);
    }
}

sub ibap_o2i_generic_struct_list_convert
{
    my ($self, $session, $current, $tempref) = @_;

    my $object_type = ibap_object_type_helper($self, $current, (ref($tempref->{$current}) eq 'ARRAY' and @{$tempref->{$current}}) ? $tempref->{$current}->[0] : undef);

    if (defined $object_type) {
        my @res = ibap_serialize_substruct_list($session, $$tempref{$current}, $object_type);
        return (@res and $res[0] ? (1, 0, @res) : (0));
    } else {
        set_error_codes(1012, "Cannot define object type of structures in $current of ".ref($self));
        return (0);
    }
}

sub ibap_o2i_generic_subobject_list_convert
{
    my ($self, $session, $current, $tempref) = @_;
    my $object_type = ibap_object_type_helper($self, $current, (ref($tempref->{$current}) eq 'ARRAY' and @{$tempref->{$current}}) ? $tempref->{$current}->[0] : undef);

    if (defined $object_type) {

        my @res = ibap_serialize_subobject_list($session, $$tempref{$current}, $object_type, 1);
        return (@res and $res[0] ? (1, 0, @res) : (0));
    } else {
        set_error_codes(1012, "Cannot define object type of subobjects in $current of " . ref($self));
        return (0);
    }
}

sub ibap_o2i_generic_subobject_convert
{
    my ($self, $session, $current, $tempref) = @_;
    my $object_type = ibap_object_type_helper($self, $current, $$tempref{$current});

    if (defined $object_type) {
        my @res = ibap_serialize_subobject($session, $$tempref{$current}, $object_type, 1);
        return (@res and $res[0] ? (1, 0, @res) : (0));
    } else {
        set_error_codes(1012, "Cannot define object type of subobject in $current of " . ref($self));
        return (0);
    }
}

sub ibap_i2o_upgrade_group_name
{
    my ($self, $session, $current, $ibap_object_ref) = @_;

    return $ibap_object_ref->{$current}{'upgrade_group'}{'name'};
}


sub ibap_o2i_upgrade_group_as_object
{
    my ($self, $session, $current, $tempref) = @_;

    if ($$tempref{$current}) {
        my @search_request = (
                              {
                               field       => 'upgrade_group',
                               search_type => 'EXACT',
                               value       => tIBType('SubMatch',
                                                      {
                                                       search_fields =>
                                                       [
                                                        {
                                                         field => 'name',
                                                         value => ibap_value_o2i_string($$tempref{$current},'name',$session),
                                                        }
                                                       ]
                                                      }
                                                     ),
                              });

        my %search_arg;

        $search_arg{'object_type'} = 'UpgradeGroup';
        $search_arg{'error_tag'} = ibap_value_o2i_string('1012='.$current.'='.$$tempref{$current});
        $search_arg{'search_fields'} = \@search_request;

        return (1,0,tIBType('UpgradeGroup', {'readfield_substitution' => tIBType('ReadField', \%search_arg)}));
    }
    else {
        return(1,0,undef);
    }
}

sub ibap_i2o_ordered_filters
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my ( @newlist);
    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        foreach my $member(@{$$ibap_object_ref{$current}})
        {
            my $t=${$member}{'filter'};
            push @newlist, $t->{'name'};
        }
        return \@newlist;
    }else{
        return;
    }

}


sub ibap_i2o_range_filters
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
	my (@currentlist, @newlist);

	if ($self->filters()) {
		@currentlist=@{$self->filters()};
	}

	if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
		my @list=@{$$ibap_object_ref{$current}};
		my $type;

		if ($current eq 'mac_filter_rules') {
			$type = 'Infoblox::DHCP::FilterRule::MAC';
		}
		elsif ($current eq 'relay_agent_filter_rules') {
			$type = 'Infoblox::DHCP::FilterRule::RelayAgent';
		}
		elsif ($current eq 'option_filter_rules') {
			$type = 'Infoblox::DHCP::FilterRule::Option';
		}
		elsif ($current eq 'nac_filter_rules') {
			$type = 'Infoblox::DHCP::FilterRule::NAC';
		}
        elsif ($current eq 'fingerprint_filter_rules') {
            $type = 'Infoblox::DHCP::FilterRule::Fingerprint';
        }
		else {
			#
			return;
		}

		foreach my $member (@list) {
			my $perm=${$member}{'permission'};
			if ($perm =~ m/allow/i) {
				$perm='grant';
			}
			else {
				$perm='deny';
			}

			my $t=${$member}{'filter'};

			push @newlist, $type->new(
									  'filter_name' => ${$t}{'name'},
									  'permission' 	=> $perm,
									 );
		}

		if (@currentlist) {
			push @newlist, @currentlist;
		}
	}

	if (@newlist) {
		return \@newlist;
	}
	else {
		return;
	}
}

sub ibap_value_i2o_dhcpmember {
    my $value_in=shift;

    my $value = Infoblox::DHCP::Member->__new__();
    $value->name($value_in->{'host_name'});
    $value->ipv4addr($value_in->{'vip_setting'}{'address'}) if $value_in->{'vip_setting'}{'address'};
    $value->ipv6addr($value_in->{'ipv6_setting'}{'virtual_ip'}) if $value_in->{'ipv6_setting'}{'virtual_ip'};
    return $value;
}

#
sub ibap_i2o_mixed_member
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
	my @newlist;

	if ($$ibap_object_ref{$current}) {
		my $member=$$ibap_object_ref{$current};

        #
        #
        if (ref($member) =~ m/MsServer/) {
            my $t=Infoblox::DHCP::MSServer->new(
                                                'name'    => ${$member}{'server_name'},
                                                'address' => ${$member}{'address'},
                                               );
            $self->{__object_id_cache__}{generate_special_object_msserver_cache_key($t)} = $member->{'object_id'}{'id'};
            return $t;
        }
        else {
            my $t = ibap_value_i2o_dhcpmember($member);
            $self->{__object_id_cache__}{generate_special_object_member_cache_key($t)} = $member->{'object_id'}{'id'};
            return $t;
        }
	} else {
		return;
	}
}

sub ibap_i2o_range_failover
{
	my ($self, $session, $current, $ibap_object_ref) = @_;

	if ($$ibap_object_ref{$current}) {
		return $$ibap_object_ref{$current}{'name'};
	} else {
		return;
	}
}


sub ibap_o2i_range_failover
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	push @return_args, 1;
	if (!$$tempref{$current}) {
        #
        #
        #
        push @return_args, 0;
        push @return_args, undef;
    } else {
		push @return_args, 0;
		push @return_args, ibap_readfield_simple_string('DhcpFailoverAssoc','name',$$tempref{$current});
	}

	return @return_args;
}

sub ibap_o2i_msserver_helper
{
	my ($self, $value) = @_;

	if (defined($value)) {
        my $oid_key = generate_special_object_msserver_cache_key($value);
        if ($self && $self->{__object_id_cache__}{$oid_key}) {
            return tObjIdRef($self->{__object_id_cache__}{$oid_key});
        }
        else {
            return ibap_readfield_simple_string('MsServer','address',$value->address());
        }
	}
	else {
		return undef;
	}
}

sub ibap_o2i_msserver
{
	my ($self, $session, $current, $tempref) = @_;

    return (1,0, ibap_o2i_msserver_helper($self, $$tempref{$current}));
}

sub ibap_o2i_mixed_member
{
	my ($self, $session, $current, $tempref) = @_;

	if (defined $$tempref{$current}) {
        my %extra_write_arg;
        $extra_write_arg{'field'} = 'ms_server';
        $extra_write_arg{'value'} = undef;

        if (ref($$tempref{$current}) && ref($$tempref{$current}) eq 'Infoblox::DHCP::MSServer') {
            $extra_write_arg{'value'} = ibap_o2i_msserver_helper($self, $$tempref{$current});
            return (1,0,undef,\%extra_write_arg);
        }
        else {
            return (1,0,ibap_value_o2i_member($$tempref{$current}, $session, $self, $current,1),\%extra_write_arg);
        }
	}
	else {
        return (1,0,undef);
	}
}

sub ibap_o2i_mixed_member_search
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        my $obj_type = ref($$tempref{$current});

        if ($obj_type && ($obj_type eq 'Infoblox::Grid::Member::DHCP' || $obj_type eq 'Infoblox::Grid::MSServer::DHCP')) {
            my %extra_write_arg;
            $extra_write_arg{'field'} = 'ms_server';
            $extra_write_arg{'value'} = undef;

            if ($obj_type eq 'Infoblox::Grid::MSServer::DHCP') {
                if ($$tempref{$current}->__object_id__()) {
                    $extra_write_arg{'value'} = tObjId($$tempref{$current}->__object_id__());
                    return (1,0,undef,\%extra_write_arg);
                } elsif ($$tempref{$current}->{'address'}) {
                    $extra_write_arg{'value'} = ibap_readfield_simple_string('MsServer', 'address', $$tempref{$current}->{'address'});
                    return (1,0,undef,\%extra_write_arg);
                } else {
                    set_error_codes(1012, "The $obj_type must be retrieved from the appliance before using it or 'address' member must be defined before setting it in $current in object ".ref($self));
                    return (0);
                }
            } else {
                if ($$tempref{$current}->__object_id__()) {
                    return (1,0,tObjId($$tempref{$current}->__object_id__()),\%extra_write_arg);
                } elsif ($$tempref{$current}->{'name'}) {
                    return (1,0,ibap_readfield_simple_string('Member', 'name', $$tempref{$current}->{'name'}),\%extra_write_arg);
                } else {
                    set_error_codes(1012, "The $obj_type must be retrieved from the appliance before using it or 'name' member must be defined before setting it in $current in object ".ref($self));
                    return (0);
                }
            }
        } else {
            ibap_o2i_mixed_member($self, $session, $current, $tempref);
        }
    } else {
        return (1,0,undef);
    }
}

sub ibap_o2i_forwarders
{

    my ($self, $session, $current, $tempref) = @_;
    my @return_args;
    push @return_args, 1;

    if ($tempref->{$current} && ref($tempref->{$current}) eq 'ARRAY') {
        push @return_args, 0;

        my @newlist = ();

        for my $forwarder (@{$tempref->{$current}}) {
            my $addr;

            if (ref($forwarder) =~ m/^Infoblox::DNS/) {
                $addr = $forwarder->ipv4addr();

                if ($forwarder->can('ipv6addr') && $forwarder->ipv6addr()) {
                    $addr = $forwarder->ipv6addr();
                }
            } else {
                $addr = $forwarder;
            }

            if (is_ipv4_address($addr)) {
                push @newlist, ibap_value_o2i_ipv4addr($addr, '', $session);
            } elsif (is_ipv6_address($addr)) {
                push @newlist, ibap_value_o2i_ipv6addr($addr, '', $session);
            }
            else {
                set_error_codes(1012, "Invalid ip address $addr",$session);
                return (0);
            }
        }

        push @return_args, tIBType('ArrayOfIPAddress',\@newlist);
    } else {
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}

sub ibap_o2i_range_filters
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		if (ref ($$tempref{$current}) eq 'ARRAY') {
			my (@option,@relay,@mac,@nac,@fingerprint);
			my @list=@{$$tempref{$current}};

			foreach my $filter (@list) {
				my %sub_write_arg;
				my $search_type;

				if ($filter->permission() =~ m/grant/i) {
					$sub_write_arg{'permission'}=ibap_value_o2i_string('ALLOW');
				}
				else {
					$sub_write_arg{'permission'}=ibap_value_o2i_string('DENY');
				}

				if (ref($filter) eq 'Infoblox::DHCP::FilterRule::MAC') {
					$sub_write_arg{'filter'} = ibap_readfield_simple_string('DhcpMacFilter','name',$filter->filter_name());
					push @mac, tIBType('filter_rule', \%sub_write_arg );
				}
				elsif (ref($filter) eq 'Infoblox::DHCP::FilterRule::RelayAgent') {
					$sub_write_arg{'filter'} = ibap_readfield_simple_string('RelayAgentFilter','name',$filter->filter_name());
					push @relay, tIBType('filter_rule', \%sub_write_arg );
				}
				elsif (ref($filter) eq 'Infoblox::DHCP::FilterRule::Option') {
					$sub_write_arg{'filter'} = ibap_readfield_simple_string('OptionFilter','name',$filter->filter_name());
					push @option, tIBType('filter_rule', \%sub_write_arg );
				}
				elsif (ref($filter) eq 'Infoblox::DHCP::FilterRule::NAC') {
					$sub_write_arg{'filter'} = ibap_readfield_simple_string('NacFilter','name',$filter->filter_name());
					push @nac, tIBType('filter_rule', \%sub_write_arg );
				}
                elsif (ref($filter) eq 'Infoblox::DHCP::FilterRule::Fingerprint') {
                    $sub_write_arg{'filter'} = ibap_readfield_simple_string('DhcpFingerprintFilter','name',$filter->filter_name());
                    push @fingerprint, tIBType('filter_rule', \%sub_write_arg );
                }
				else {
					#
					set_error_codes(1012,'Internal error, invalid filter rule type ' . ref($filter) . ' in filters' );
					push @return_args, 0;
					return @return_args;
				}
			}

            my $af = 'ArrayOffilter_rule';
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, tIBType($af, \@mac);

			my %extra_write_arg1;
			$extra_write_arg1{'field'} = 'relay_agent_filter_rules';
			$extra_write_arg1{'value'} = tIBType($af, \@relay);
			push @return_args, \%extra_write_arg1;

			my %extra_write_arg2;
			$extra_write_arg2{'field'} = 'option_filter_rules';
			$extra_write_arg2{'value'} = tIBType($af, \@option);
			push @return_args, \%extra_write_arg2;

			my %extra_write_arg3;
			$extra_write_arg3{'field'} = 'nac_filter_rules';
			$extra_write_arg3{'value'} = tIBType($af, \@nac);
			push @return_args, \%extra_write_arg3;

            my %extra_write_arg4;
            $extra_write_arg4{'field'} = 'fingerprint_filter_rules';
            $extra_write_arg4{'value'} = tIBType($af, \@fingerprint);
            push @return_args, \%extra_write_arg4;
		} else {
			push @return_args, 0;
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 1;
		push @return_args, undef;
	}

	return @return_args;
}

sub ibap_o2i_ordered_filters
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
        if (ref ($$tempref{$current}) eq 'ARRAY') {
            my (@filters);
            my @list=@{$$tempref{$current}};

            foreach my $filter (@list) {
                my %sub_write_arg;
                my $search_type;


                if (ref($filter) eq 'Infoblox::DHCP::Filter::MAC') {
                    $sub_write_arg{'filter'} = ibap_readfield_simple_string('DhcpMacFilter','name',$filter->name());
                }
                elsif (ref($filter) eq 'Infoblox::DHCP::Filter::Option') {
                    $sub_write_arg{'filter'} = ibap_readfield_simple_string('OptionFilter','name',$filter->name());
                }
                elsif (ref($filter) eq 'Infoblox::DHCP::Filter::NAC') {
                    $sub_write_arg{'filter'} = ibap_readfield_simple_string('NacFilter','name',$filter->name());
                }
                elsif (ref($filter) eq 'Infoblox::DHCP::Filter::Fingerprint') {
                    $sub_write_arg{'filter'} = ibap_readfield_simple_string('DhcpFingerprintFilter','name',$filter->name());
                }
                elsif(!ref($filter)){
                    $sub_write_arg{'filter'} = ibap_readfield_simple_string('AllFilter','name',$filter);
                }
                else {
                    #
                    set_error_codes(1012,'Internal error, invalid filter type ' . ref($filter) . ' in filters' );
                    push @return_args, 0;
                    return @return_args;
                }
                push @filters, tIBType('ordered_filter_rule', \%sub_write_arg );
            }

            my $af = 'ArrayOfordered_filter_rule';
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType($af, \@filters);

        }else{
            push @return_args, 0;
        }
    } else {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}

sub ibap_o2i_ttl
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		my $t=ibap_value_o2i_uint($$tempref{$current},$current,$session);
		if ($t) {
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, $t;
		} else {
			push @return_args, 0;
			push @return_args, 1;
			return;
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 1;
		push @return_args, undef;
	}

	if (defined $$tempref{'use_ttl'}) {
		my %sub_arg;
		$sub_arg{'field'} = 'use_ttl';
		return unless $sub_arg{'value'} = ibap_value_o2i_boolean($$tempref{'use_ttl'},'use_ttl',$session);

		push @return_args, \%sub_arg;
	}
	return @return_args;
}

sub ibap_o2i_ignore
{
	my @return_args;
	push @return_args, 1;
	push @return_args, 1;
	push @return_args, undef;
	return @return_args;
}

sub ibap_o2i_substruct_search
{
	my ($self, $session, $current, $tempref, $type, $outname) = @_;
	my @return_args;
	my $localtype;
	my @out_submatch;

	if ($type eq 'search') {
		$localtype='REGEX';
	} else {
		$localtype='EXACT';
	}

	my $value = ibap_value_o2i_string_undef_to_empty($$tempref{$current});
	my %search_arg;

	$search_arg{'field'} = $outname;
	$search_arg{'value'} = $value;
	$search_arg{'search_type'} = $localtype;

    return (1,0, tIBType('search_field', \%search_arg));
}

sub ibap_o2i_substruct_exact_search
{
	my ($self, $session, $current, $tempref, $type, $outname) = @_;
    return ibap_o2i_substruct_search($self, $session, $current, $tempref, 'get', $outname);
}

sub ibap_o2i_substruct_exact_int_search
{
	my ($self, $session, $current, $tempref, $type, $outname) = @_;

	my $value = ibap_value_o2i_int($$tempref{$current});
	my %search_arg;

	$search_arg{'field'} = $outname;
	$search_arg{'value'} = $value;
	$search_arg{'search_type'} = 'EXACT';

    return (1,0, tIBType('search_field', \%search_arg));
}

sub ibap_o2i_substruct_exact_datetime_search
{
	my ($self, $session, $current, $tempref, $type, $outname) = @_;

	my $value = tDateTime($$tempref{$current});
	my %search_arg;

	$search_arg{'field'} = $outname;
	$search_arg{'value'} = $value;
	$search_arg{'search_type'} = 'EXACT';

    return (1,0, tIBType('search_field', \%search_arg));
}

sub ibap_o2i_substruct_exact_v_type_search
{
    my ($self, $session, $current, $tempref, $type, $outname) =@_;

    my $value = ibap_value_o2i_enum_mapping($$tempref{$current},$current, $session, 0,
      \%v_type_name_mapping);
	my %search_arg;

	$search_arg{'field'} = $outname;
	$search_arg{'value'} = $value;
	$search_arg{'search_type'} = 'EXACT';

    return (1,0, tIBType('search_field', \%search_arg));
}

sub ibap_o2i_object_only_by_oid
{
    my ($self, $session, $current, $tempref) = @_;

    if (ref($tempref->{$current}) eq 'ARRAY') {
        my @objs = ();
        foreach my $obj (@{$tempref->{$current}}) {
            if (my $res = object_by_oid_or_readfield_helper($self, $current, $obj, 1)) {
                push @objs, $res;
            } else {
                return (0);
            }
        }
        return (1, 0, tIBType('ArrayOfBaseObject', \@objs));
    } else {
        if (my $res = object_by_oid_or_readfield_helper($self, $current, $tempref->{$current}, 1)) {
            return (1, 0, $res);
        } else {
            return (0);
        }
    }
}

sub ibap_o2i_object_only_by_oid_skip_undef
{
    my ($self, $session, $current, $tempref) = @_;
    return defined $tempref->{$current} ? ibap_o2i_object_only_by_oid(@_) : (1, 1, undef);
}

sub ibap_o2i_object_only_by_oid_or_undef
{
    my ($self, $session, $current, $tempref) = @_;
    return defined $tempref->{$current} ? ibap_o2i_object_only_by_oid(@_) : (1, 0, undef);
}

sub ibap_o2i_object_by_oid_or_name
{
    my ($self, $session, $current, $tempref) = @_;

    if (ref($tempref->{$current}) eq 'ARRAY') {
        my @objs = ();
        foreach my $obj (@{$tempref->{$current}}) {
            if (my $res = object_by_oid_or_readfield_helper($self, $current, $obj, 1, 'name')) {
                push @objs, $res;
            } else {
                return (0);
            }
        }
        return (1, 0, tIBType('ArrayOfBaseObject', \@objs));
    } else {
        if (my $res = object_by_oid_or_readfield_helper($self, $current, $tempref->{$current}, 1, 'name')) {
            return (1, 0, $res);
        } else {
            return (0);
        }
    }
}

sub ibap_o2i_object_by_oid_or_name_undef_ok
{
    my ($self, $session, $current, $tempref) = @_;

    return (defined $$tempref{$current} ?
        ibap_o2i_object_by_oid_or_name(@_) : (1, 0, undef));

}

sub ibap_o2i_object_by_oid_or_name_skip_undef
{
    my ($self, $session, $current, $tempref) = @_;

    return (defined $$tempref{$current} ?
        ibap_o2i_object_by_oid_or_name(@_) : (1, 1, undef));

}

sub ibap_o2i_object_only_by_oid_undef_ok
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $tempref->{$current}){
        return ibap_o2i_object_only_by_oid($self, $session, $current, $tempref);
    } else {
        return (1,0,undef);
    }
}

sub object_by_oid_or_readfield_helper
{
    my ($self, $current, $object, $skip_object_readfield, $readfield) = @_;

    if (ref($object)) {
        if ($object->__object_id__()) {
            return tObjIdRef($object->__object_id__());
        } else {
            unless ($skip_object_readfield) {
                no strict 'refs';
                $readfield = ${ref($object).'::_unique_readfield'};
            }

            if ($readfield) {
                if (defined $object->$readfield()) {
                    no strict 'refs';
                    my $namemappingref = \%{ref($object).'::_name_mappings'};
                    my $ibapfield = ($namemappingref and $namemappingref->{$readfield}) ? $namemappingref->{$readfield} : $readfield;
                    return ibap_readfield_simple_string($object->__ibap_object_type__(), $ibapfield, $object->$readfield());
                } else {
                    set_error_codes(1012, 'The '.ref($object)." object must be retrieved from the appliance or '$readfield' member must be defined before setting it in $current in object ".ref($self));
                }
            } else {
                set_error_codes(1012, 'The '.ref($object)." object must be retrieved from the appliance before setting it in $current in object ".ref($self));
                return;
            }
        }
    } else {
        set_error_codes(1012, "The object must be defined before setting it in $current in object ".ref($self));
        return;
    }
}

sub ibap_o2i_object_by_oid_or_readfield
{
    my ($self, $session, $current, $tempref) = @_;

    if (ref($tempref->{$current}) eq 'ARRAY') {
        my @objs = ();
        foreach my $obj (@{$tempref->{$current}}) {
            if (my $res = object_by_oid_or_readfield_helper($self, $current, $obj)) {
                push @objs, $res;
            } else {
                return (0);
            }
        }
        return (1, 0, tIBType('ArrayOfBaseObject', \@objs));
    } else {
        if (my $res = object_by_oid_or_readfield_helper($self, $current, $tempref->{$current})) {
            return (1, 0, $res);
        } else {
            return (0);
        }
    }
}

sub ibap_readfield_simple
{
	my ($object_type, $field, $value, $tag, $sub_search_type, $name) = @_;

	my (@subsearch_query, @search_query, %search_arg);
    my $localtag='';

    #
    $sub_search_type = 'EXACT' unless (defined $sub_search_type);

	if ($value || ref($field) ne 'ARRAY') {
		my %subsearch_arg;
		$subsearch_arg{'field'} = $field;
		$subsearch_arg{'value'} = $value;
		$subsearch_arg{'search_type'} = $sub_search_type;
		unshift @subsearch_query, \%subsearch_arg;
        $localtag = $field;
	} else {
		my @fields = @{$field};
		foreach my $t (@fields) {
			my %arg;
            $localtag .= $$t{'field'}.',';
			$arg{'field'} = $$t{'field'};
			$arg{'value'} = $$t{'value'};
			$arg{'match_case'} = $$t{'match_case'} if defined $$t{'match_case'};
            if (defined $$t{'list_op'}) {
                $arg{'list_op'} = $$t{'list_op'};
            }
            else {
                $arg{'search_type'} = $sub_search_type;
            }
			unshift @subsearch_query, \%arg;
		}
        chop $localtag;
	}

	$search_arg{'object_type'} = $object_type;
	$search_arg{'search_fields'} = \@subsearch_query;
    if ($tag) {
        $search_arg{'error_tag'} = ibap_value_o2i_string('1012=' . $tag);
    }
    else {
        $search_arg{'error_tag'} = ibap_value_o2i_string('1012=' . $localtag . '= value(s) not available');
    }

    my %subobject;
    $subobject{'readfield_substitution'} = tIBType('ReadField', \%search_arg);

    if ($name) {
        #
        return {$name => tIBType($object_type, \%subobject)};
    } else {
        return tIBType($object_type, \%subobject);
    }
}


sub ibap_readfield_simple_string
{
    my ($object_type, $field, $value, $tag, $sub_search_type, $name) = @_;

    my (@subsearch_query, @search_query, %search_arg);

    #
    $sub_search_type = 'EXACT' unless (defined $sub_search_type);

    my %subsearch_arg;
    $subsearch_arg{'field'} = ibap_value_o2i_string_undef_to_empty($field);
    $subsearch_arg{'value'} = ibap_value_o2i_string_undef_to_empty($value);
    $subsearch_arg{'search_type'} = $sub_search_type;
    unshift @subsearch_query, \%subsearch_arg;

    $search_arg{'object_type'} = $object_type;
    $search_arg{'error_tag'} = ibap_value_o2i_string($tag) if $tag;

    if ($tag) {
        if ($tag =~ m/^[0-9]+=/) {
            #
            $search_arg{'error_tag'} = ibap_value_o2i_string($tag);
        } elsif ($tag =~ m/=/) {
            #
            $search_arg{'error_tag'} = ibap_value_o2i_string('1012=' . $tag);
        }
        else {
            #
            $search_arg{'error_tag'} = ibap_value_o2i_string('1012=' . $tag . '=' .  $value);
        }
    }
    else {
        #
        $search_arg{'error_tag'} = ibap_value_o2i_string('1012=' . $field . '=' . $value);
    }

    $search_arg{'search_fields'} = \@subsearch_query;
    unshift @search_query, \%search_arg;

    my %subobject;
    $subobject{'readfield_substitution'} = tIBType('ReadField', \%search_arg);

    if ($name) {
        #
       return {$name => tIBType($object_type, \%subobject)};
    } else {
       return tIBType($object_type, \%subobject);
    }
}

sub ibap_readfieldlist_simple_string
{
    my ($object_type, $field, $value, $sub_search_type, $name) = @_;

    my (@subsearch_query, @search_query, %search_arg);

    #
    $sub_search_type = 'REGEX' unless (defined $sub_search_type);

    my %subsearch_arg;
    $subsearch_arg{'field'} = ibap_value_o2i_string_undef_to_empty($field);
    $subsearch_arg{'value'} = ibap_value_o2i_string_undef_to_empty($value);
    $subsearch_arg{'search_type'} = $sub_search_type;
    unshift @subsearch_query, \%subsearch_arg;

    $search_arg{'object_type'} = $object_type;
    $search_arg{'search_fields'} = \@subsearch_query;
    unshift @search_query, \%search_arg;

    my %subobject;
    $subobject{'readfield_substitution'} = tIBType('ReadFieldList', \@search_query);

    if ($name) {
        #
        return {$name => tIBType('ReadFieldList', \%search_arg)};
    } else {
        return tIBType('ReadFieldList', \%search_arg);
    }
}

sub ibap_readfieldlist_simple
{
   my ($object_type, $field, $value, $sub_search_type, $name, $error_tag) = @_;

   my (@subsearch_query, @search_query, %search_arg);

   #
   $sub_search_type = 'REGEX' unless (defined $sub_search_type);

   if ($value || ref($field) ne 'ARRAY') {
       my %subsearch_arg;
       $subsearch_arg{'field'} = $field;
       $subsearch_arg{'value'} = $value;
       $subsearch_arg{'search_type'} = $sub_search_type;
       unshift @subsearch_query, \%subsearch_arg;
   } else {
       my @fields = @{$field};
       foreach my $t (@fields) {
           my %arg;

           $arg{'field'} = $$t{'field'};
           $arg{'value'} = $$t{'value'};
		   if ($$t{'search_type'}) {
			   $arg{'search_type'} = $$t{'search_type'};
		   }
		   else {
			   $arg{'search_type'} = $sub_search_type;
		   }

           $arg{'list_op'} = $$t{'list_op'} if $$t{'list_op'};
           unshift @subsearch_query, \%arg;
       }
   }

   $search_arg{'object_type'} = $object_type;
   $search_arg{'search_fields'} = \@subsearch_query;
   $search_arg{'error_tag'} = ibap_value_o2i_string($error_tag) if $error_tag;
   unshift @search_query, \%search_arg;

   if ($name) {
       #
       return {$name => tIBType('ReadFieldList', \%search_arg)};
   } else {
       return tIBType('ReadFieldList', \%search_arg);
   }
}

sub set_error_codes
{
	my ($code, $error, $object ) = @_;
	$error = Infoblox::Result->status_message($code)
		if not defined($error);
	if ($object) {
		$object->status_code($code);
		$object->status_detail($error);
	}
	Infoblox->status_code($code);
	Infoblox->status_detail($error);

    return 0;
}

sub append_error_codes
{
	my ($code, $error, $object ) = @_;
	$error = Infoblox::Result->status_message($code)
		if not defined($error);
	if ($object) {
		$object->status_code($code . ' ' . $object->status_code());
		$object->status_detail($error) . ' ' .$object->status_detail() ;
	}
	Infoblox->status_code($code . ' ' . Infoblox->status_code());
	Infoblox->status_detail($error . ' ' . Infoblox->status_detail());

    return 0;
}


#
sub ibap_accessor_dhcp_options
{
    my $self  = shift;
    my $member_name=shift;

    if( @_ == 0 )
    {
        return $self->{ $member_name };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ $member_name } = undef;
        }
        else
        {
            if( ref( $value ) eq 'ARRAY' )
            {
                my $type_list = [ 'Infoblox::DHCP::Option',  ];
                if( Infoblox::Util::check_vector_type( $value , $type_list ))
                {
					my @opts = ();

                    #
                    map { push @opts, $_ if defined $_->value() } @{$value};

					#
					my $use_broadcast_address_flag = 'use_broadcast_address';
                    my $use_routers_flag = 'use_routers';
                    if (ref($self) =~ m/Template/) {
                        $use_broadcast_address_flag = 'use_broadcast_address_offset';
                        $use_routers_flag = 'use_router_templates';
                    }

					$self->{$use_broadcast_address_flag} = 0;
					$self->{$use_routers_flag} = 0;
					$self->{'use_domain_name'} = 0;
					$self->{'use_lease_time'} = 0;
					$self->{'use_domain_name_servers'} = 0;

					foreach my $opt (@opts) {
						if (is_special_option_broadcast($opt)) {
							$self->{$use_broadcast_address_flag} = 1;
						} elsif (is_special_option_routers($opt)) {
							$self->{$use_routers_flag} = 1;
						} elsif (is_special_option_domain_name($opt)) {
							$self->{'use_domain_name'} = 1;
						} elsif (is_special_option_lease_time($opt)) {
							$self->{'use_lease_time'} = 1;
						} elsif (is_special_option_nameservers($opt)) {
							$self->{'use_domain_name_servers'} = 1;
						}
					}

                    $self->{ $member_name } = \@opts;
                }
                else
                {
					set_error_codes(1104,"Invalid data type for member $member_name." );
                    return;
                }
            }
			else {
				set_error_codes(1104,"Invalid data type for member $member_name." );
				return;
			}
        }
    }
    return 1;
}

sub ibap_accessor_ac_setting
{
    my ($self, $field, $tsigkey, $add_data, @values) = @_;

    if (@values) {
        my $value = shift @values;

        my %data = (name => $field, %$add_data);

        if (ref($value) eq 'ARRAY') {
            $data{'validator'} = $tsigkey ? { 'Infoblox::DNS::TSIGKey' => 1, 'string' => \&ibap_value_o2i_string } : \&ibap_value_o2i_string;
            return $self->__accessor_array__(\%data, $value);
        } else {
            return $self->__accessor_scalar__({%data, validator => {'Infoblox::Grid::NamedACL' => 1}}, $value);
        }
    } else {
        return $self->{$field};
    }
}

#
#
#
#
#
sub ibap_get_object_id
{
    my($session, $object_type, $args) = @_;
    my @search_query;
    my $object_id;
    my %search_args;
    my $search_fields;

	my $server=$session->get_ibap_server() || return;

    my %call_args;
    $call_args{'object_type'} = $object_type;
    $call_args{'depth'} = 0;

    if( defined $args ) {
        %search_args = %$args;

        foreach my $field (keys %search_args) {
            my %search_arg;
            $search_arg{'field'} = $field;
            $search_arg{'value'} = $search_args{$field};
            $search_arg{'search_type'} = 'EXACT';
            unshift @search_query , \%search_arg;
        }
    }

    if( scalar(@search_query) > 0 ) {
        $call_args{'search_fields'} = \@search_query;
    }

    my $result;
    #
    eval { $result = $server->ObjectRead(\%call_args); };
    return $server->set_papi_error($@, $session) if $@;

    #
    #
    unless (scalar @$result) {
        set_error_codes(1012,"Object not found or access not permitted." , $session);
        return undef;
    }

    return (${@{$result}[0]}{'object_id'}{'id'});
}

#
sub ibap_i2o_network_container
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
        (my $ibaptype = ref($$ibap_object_ref{$current})) =~ s/^ib://;

        #
        #
        #
        return $$ibap_object_ref{$current}{'address'}.'/'.$$ibap_object_ref{$current}{'cidr'};
    }

    #
    return '/';
}


#
#
sub capitalize_first_letter
{
    my $word = shift;

    return ucfirst(lc($word)) if ($word) or $word;
}

sub __check_ts {

    my ($ts, $dt, $err) = @_;

    if ($err and $err =~ /too big/) {
         die 'Invalid ISO 8601 date/time string "' . $dt
             . "\". Date must be before the year 2038\n";
    }

    if ($ts < 0 or $err) {
         die 'Invalid ISO 8601 date/time string "' . $dt
            . "\". Date must be after the year 1969\n";
    }
}

sub iso8601_datetime_to_unix_timestamp_nolimit {
    my $dateTime = $_[0];

    if ($dateTime =~ /^(\d\d\d\d)-(\d\d)-(\d\d)T
	               (\d\d):(\d\d):(\d\d(\.\d\d\d)?)
	               (Z|(([+-])(\d\d):(\d\d)))?$/x) {

        my $t;

        #
        #
        #
        #

        if ($8) {
            $t = eval { timegm($6, $5, $4, $3, $2 - 1, $1) };
            __check_ts($t, $dateTime, $@);

            if ($9) {
                $t += (($10 eq '-') ? +1 : -1) * ($11 * 60 * 60 + $12 * 60);
            }
        } else {
            #
            $t = eval { timelocal($6, $5, $4, $3, $2 - 1, $1) };
            __check_ts($t, $dateTime, $@);
        }

        return int($t);
    } else {
        die 'Invalid ISO 8601 date/time string "' . $dateTime . '"'
            . " (format: yyyy-mm-ddThh:mm:ss or yyyy-mm-ddThh:mm:ssZ)";
    }
}

#
#
#
sub iso8601_datetime_to_unix_timestamp {
    my $dateTime = $_[0];

    if ($dateTime =~ /^(\d\d\d\d)-(\d\d)-(\d\d)T
	               (\d\d):(\d\d):(\d\d(\.\d\d\d)?)
	               (Z|(([+-])(\d\d):(\d\d)))?$/x) {

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
        #
        #
        #
        if ($1 > 2037) {
            die 'Invalid ISO 8601 date/time string "' . $dateTime
                 . "\". Date must be before the year 2038\n";
        }
        elsif ($1 < 1970)
        {
            die 'Invalid ISO 8601 date/time string "' . $dateTime
                 . "\". Date must be after the year 1969\n";
        }

        my $t;

        if ($8) {
            $t = timegm($6, $5, $4, $3, $2 - 1, $1);
            if ($9) {
                $t += (($10 eq '-') ? +1 : -1) * ($11 * 60 * 60 + $12 * 60);
            }
        } else {
            #
            $t = timelocal($6, $5, $4, $3, $2 - 1, $1);
        }

        return int($t);
    }
    elsif ($dateTime =~ m!^(\d\d\d\d)/(\d\d)/(\d\d) (\d\d):(\d\d):(\d\d)$!) {
        #
        #
        #
        #
        return int(timegm($6, $5, $4, $3, $2 - 1, $1));
    }
    elsif ($dateTime =~ m!^(\d\d)/(\d\d)/(\d\d\d\d) (\d\d):(\d\d):(\d\d)$!) {
        #
        return int(timegm($6, $5, $4, $2, $1 - 1, $3));
    } else {
        die 'Invalid ISO 8601 date/time string "' . $dateTime . '"'
            . " (format: yyyy-mm-ddThh:mm:ss or yyyy-mm-ddThh:mm:ssZ or yyyy-mm-ddThh:mm:ss+-hh:mm)\n";
    }
}


#
#
#
#
#
#
#
sub timestamp_at_11_01_on_same_utc_day {
    my ($t) = @_;

    return iso8601_datetime_to_unix_timestamp(strftime("%Y-%m-%d", gmtime(int($t)))
                                              . "T11:01:00Z");
}

#
sub request_settings {
    my ($session, $args, $what) = @_;

    my $test_mode = delete $args->{'test_mode'};
    my $warn_mode = delete $args->{'warn_mode'};
    my $scheduled_at = delete $args->{'scheduled_at'};
    my $approval_comment = delete $args->{'approval_comment'};
    my $approval_ticket = delete $args->{'approval_ticket_number'};
    my $validateip = delete $args->{'ip_validation'};
    my $predecessor_task = delete $args->{'predecessor_task'};

    my $settings = {};

    if ($test_mode) {
        $settings->{'mode'} = 'TEST';
    } elsif ($scheduled_at or $predecessor_task) {
        $settings->{'mode'} = 'SCHEDULE';
        $settings->{'scheduling_info'} = {};

        if ($scheduled_at) {
            if (lc($scheduled_at) eq 'now') {
                $settings->{'scheduling_info'}->{'execute_now'} = tBool(1);
                $settings->{'scheduling_info'}->{'scheduled_time'} = tDateTime(time());
            } else {
                $scheduled_at = eval{ iso8601_datetime_to_unix_timestamp($scheduled_at) };

                if ($@) {
                    set_error_codes(1012, substr($@, 0, -1).' for parameter scheduled_at', $session);
                    return undef;
                }

                $settings->{'scheduling_info'}->{'scheduled_time'} = tDateTime($scheduled_at);
            }
        } else {
            set_error_codes(1103, 'scheduled_at is required', $session);
            return undef;
        }

        if ($predecessor_task) {
            if (ref($predecessor_task) ne 'Infoblox::Grid::ScheduledTask') {
                set_error_codes(1104, 'Invalid data type for member predecessor_task', $session);
                return undef;
            }

            $settings->{'scheduling_info'}->{'predecessor_task'} = ibap_value_o2i_oid($predecessor_task, 'predecessor_task', $session);
            return unless $settings->{'scheduling_info'}->{'predecessor_task'};
        }

        $settings->{'scheduling_info'}->{'warnlevel'} = ibap_value_o2i_string('WARN') if $warn_mode;
    }

    if ($validateip) {
        if ($what ne 'add' and $what ne 'modify') {
            #
            set_error_codes(1012,"Invalid option: ip_validation." , $session);
            return undef;
        }

        if (ref($validateip) eq 'ARRAY') {
            my @list;
            foreach my $t (@$validateip) {
                if (ref($t) eq 'Infoblox::Grid::IPValidationInfo') {
                    my $x = ibap_serialize_substruct($session, $t, 'ip_validation_info');
                    unless ($x) {
                        set_error_codes(Infoblox::status_code(), Infoblox::status_detail(), $session);
                        return undef
                    }
                    push @list, $x;
                }
                else {
                    set_error_codes(1012,"Invalid object in the ip_validation list, only Infoblox::Grid::IPValidationInfo objects are supported." , $session);
                    return undef;
                }
            }

            if (@list) {
                $settings->{'ip_validation_info'} = tIBType('ArrayOfip_validation_info', \@list);
            }
        }
        else {
            set_error_codes(1012,"Invalid value in ip_validation, it must be a list of Infoblox::Grid::IPValidationInfo objects." , $session);
            return undef;
        }
    }

    if ($approval_comment or $approval_ticket) {
        $settings->{'approval_info'} = {};
        $settings->{'approval_info'}->{'comment'} = ibap_value_o2i_string($approval_comment) if $approval_comment;
        $settings->{'approval_info'}->{'ticket_number'} = ibap_value_o2i_string($approval_ticket) if $approval_ticket;
    }

    return $settings;
}

#
#
#
#
#
#
sub schedule_request {
    my ($at, $warn, $errappend) = @_;

    $errappend = "" unless defined($errappend);

    my $at_epoc = eval {iso8601_datetime_to_unix_timestamp($at); };

    die papi_error(1012, substr($@, 0, -1) . $errappend)
        if $@;

    my $r = {scheduled_time => tDateTime($at_epoc)};

    if ($warn) {
        $r->{warnlevel} = $warn;
    }

    return {mode => 'SCHEDULE', scheduling_info => $r};
}

#

sub ibap_i2o_primary_nameserver
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
	my $t;

    if ($$ibap_object_ref{$current}) {
        $t=$$ibap_object_ref{$current};

		my $membertemp = Infoblox::DNS::Member->new( 'name'     => $$t{'host_name'},
													 'ipv4addr' => $$t{'vip_setting'}{'address'},
													 'stealth'  => $$ibap_object_ref{'grid_primary_stealth'} ? 'true' : 'false',
												   );

        if ($$t{'ipv6_setting'}{'enabled'}) {
            $membertemp->ipv6addr($$t{'ipv6_setting'}{'virtual_ip'});
        }


		#
		$self->{__object_id_cache__}{generate_special_object_member_cache_key($membertemp)} =
		  ${${$$ibap_object_ref{$current}}{'object_id'}}{'id'};

		return $membertemp;
    } else {
        return;
    }
}

sub ibap_i2o_member_nameserver
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && scalar(@{$$ibap_object_ref{$current}})) {
		my @dns_list = @{$$ibap_object_ref{$current}};
		my @newlist;

		foreach my $dns (@dns_list) {
			push @newlist, ibap_object_member_server_convert($self,$dns,$session,$current);
		}

		if ($current eq 'grid_secondaries') {
			push @newlist, @{$self->secondaries()} if defined $self->secondaries();
		}

		return \@newlist;
	}
}

sub ibap_i2o_forwarding_servers {

    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @result = ();

    if ($$ibap_object_ref{$current} and ref $$ibap_object_ref{$current} eq 'ARRAY') {

        foreach my $server (@{$$ibap_object_ref{$current}}) {
            my $dnsmember = ibap_object_member_server_convert($self, $server, $session);

            if ($$server{'forward_to'} and ref $$server{'forward_to'} eq 'ARRAY') {
                my @data = ();
                foreach (@{$$server{'forward_to'}}) {
                    push @data, ibap_nameserver_from_hash($self, $_, $ibap_object_ref->{'fqdn'});
                }

                $dnsmember->forward_to(\@data);
            }

            $dnsmember->forwarders_only($server->{'forwarders_only'} ? 'true' : 'false');
            $dnsmember->override_forwarders($server->{'use_override_forwarders'} ? 'true' : 'false');

            push @result, $dnsmember;
        }

        return \@result;
    }
}

sub ibap_o2i_forwarding_servers {

    my ($self, $session, $current, $tempref) = @_;

    if ($$tempref{$current} and ref $$tempref{$current} eq 'ARRAY') {

        my @data = ();
        foreach my $server (@{$$tempref{$current}}) {

            my %write_args = ();
            $write_args{'grid_member'} = ibap_value_o2i_member(
                $server, $session, $self, $current);

            my $arg = $server->forward_to();
            if ($arg and ref $arg eq 'ARRAY') {
                $write_args{'forward_to'} = [];
                foreach (@$arg) {
                    push @{$write_args{'forward_to'}}, ibap_value_o2i_ext_server($_);
                }
            }

            $arg = $server->forwarders_only();
            $write_args{'forwarders_only'} = tBool($arg eq 'true' ? 1 : 0) if defined $arg;

            $arg = $server->override_forwarders();
            $write_args{'use_override_forwarders'} = tBool($arg eq 'true' ? 1 : 0) if defined $arg;

            push @data, tIBType('forwarding_member_server', \%write_args);
        }

        return (1, 0, tIBType('ArrayOfforwarding_member_server', \@data));

    } else {
        return (1, 1, undef);
    }
}

sub ibap_i2o_dns_msserver
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
        my $dns = ibap_i2o_generic_object_convert($self, $session, $current, $ibap_object_ref, $return_object_cache_ref);
        $self->{__object_id_cache__}{generate_special_object_msserver_cache_key($dns)} = $dns->{'ms_server'}->{'object_id'}{'id'};
		return $dns;
	}
    else {
        return undef;
    }
}

sub ibap_i2o_dns_msserver_list
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
		my (@newlist,$newlist_s);

		if ($current eq 'ms_secondaries') {
			@newlist=@{$self->secondaries()} if defined $self->secondaries();
		} elsif ($current eq 'stub_msservers') {
			@newlist=@{$self->stub_members()} if defined $self->stub_members();
        }
        else {
            #
            #
            #
            #
			@newlist=@{$self->primary()} if defined $self->primary() && ref($self->primary()) eq 'ARRAY';
        }

        if (scalar(@{$$ibap_object_ref{$current}})) {
            push @newlist, @{ibap_i2o_generic_object_list_convert($self, $session, $current, $ibap_object_ref, $return_object_cache_ref)};

            foreach my $dns (@{$$ibap_object_ref{$current}}) {
                $self->{__object_id_cache__}{generate_special_object_msserver_cache_key($dns)} = $dns->{'ms_server'}->{'object_id'}{'id'};
            }
        }
        else {
            #
            if ($current eq 'ms_secondaries') {
                return $self->secondaries();
            } elsif ($current eq 'stub_msservers') {
                return $self->stub_members();
            } else {
                return $self->multiple_primaries();
            }
        }

		return (\@newlist);
	}
}

sub ibap_i2o_email_list
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

sub ibap_o2i_email_list
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		if (ref ($$tempref{$current}) eq 'ARRAY') {
			my @emails;
			my @list=@{$$tempref{$current}};

			foreach (@list) {
				my %temail;
				return unless $temail{'email_address'} = ibap_value_o2i_string($_,'email address',$session);
				push @emails, tIBType('email_address', \%temail);
			}
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, tIBType('ArrayOfemail_address', \@emails);
		} else {
			push @return_args, 0;
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, tIBType('ArrayOfemail_address', []);
	}

	return @return_args;
}

sub ibap_i2o_mixed_members_list
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
	my @newlist;

	if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
		my @list=@{$$ibap_object_ref{$current}};

		foreach my $member (@list) {
            if (ref($member) =~ m/ms_dhcp_server/) {
                my $t=Infoblox::DHCP::MSServer->new(
                                                    'name'    => ${$member}{'ms_server'}{'server_name'},
                                                    'address' => ${$member}{'ms_server'}{'address'},
                                                   );
                $self->{__object_id_cache__}{generate_special_object_msserver_cache_key($t)} = $member->{'ms_server'}{'object_id'}{'id'};
                push @newlist, $t;

            } else {

                my $t;

                if (defined ${$member}{'grid_member'}) {

                    $t = ibap_value_i2o_dhcpmember(${$member}{'grid_member'});
                    $self->{__object_id_cache__}{generate_special_object_member_cache_key($t)} = $member->{'grid_member'}{'object_id'}{'id'};

                } else {

                    $t = ibap_value_i2o_dhcpmember($member);
                    $self->{__object_id_cache__}{generate_special_object_member_cache_key($t)} = $member->{'object_id'}{'id'};

                }

                push @newlist, $t;
            }
		}

		return \@newlist;
	} else {
		return [];
	}
}

sub ibap_i2o_members_list
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
	my @newlist;

	if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
		my @list=@{$$ibap_object_ref{$current}};

		foreach my $member (@list) {
			push @newlist, ibap_value_i2o_dhcpmember(${$member}{'grid_member'});
		}

		return \@newlist;
	} else {
		return [];
	}
}

#
#
#
sub ibap_o2i_mixed_members_list
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		if (ref ($$tempref{$current}) eq 'ARRAY') {
			my (@members, @ms_members);
			my @list=@{$$tempref{$current}};

			foreach my $member (@list) {
                if (ref($member) eq 'Infoblox::DHCP::Member' || ref($member) eq 'Infoblox::Grid::Member') {
                    push @members, tIBType('member_server', {'grid_member' => ibap_value_o2i_member($member, $session, $self, 'member',1)});
                }
                else {
                    push @ms_members, tIBType('ms_dhcp_server',{ 'ms_server' => ibap_o2i_msserver_helper($self, $member) });
                }
			}

			push @return_args, 1;
			push @return_args, 0;
			push @return_args, tIBType('ArrayOfmember_server', \@members);

			my %extra_write_arg;
			$extra_write_arg{'field'} = 'ms_dhcp_servers';
			$extra_write_arg{'value'} = tIBType('ArrayOfms_dhcp_server', \@ms_members);
			push @return_args, \%extra_write_arg;
		} else {
			push @return_args, 0;
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 1;
		push @return_args, undef;
	}

	return @return_args;
}

sub ibap_o2i_members_list
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		if (ref ($$tempref{$current}) eq 'ARRAY') {
			my @members;
			my @list=@{$$tempref{$current}};

			foreach my $member (@list) {
				push @members, tIBType('member_server', {'grid_member' => ibap_value_o2i_member_nocache($member, $session, 'member',1)});
			}
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, tIBType('ArrayOfmember_server', \@members);
		} else {
			push @return_args, 0;
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 1;
		push @return_args, undef;
	}

	return @return_args;
}

sub ibap_i2o_option60_match_rules
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist = ();

    if ($ibap_object_ref->{$current} and ref($ibap_object_ref->{$current}) eq 'ARRAY') {
        @newlist = map {
            Infoblox::DHCP::Option60MatchRule->new(
                option_space => $_->{option_space}->{name},
                match_value => $_->{match_value},
                is_substring => ibap_value_i2o_boolean($_->{use_substring}),
                substring_offset => $_->{substring_offset},
                substring_length => $_->{substring_length},
            );
        } @{$ibap_object_ref->{$current}};
    }
    return \@newlist;
}

sub ibap_o2i_option60_match_rules
{

    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $tempref->{$current}) {
        if (ref ($tempref->{$current}) eq 'ARRAY') {
            my @opts;

            foreach (@{$tempref->{$current}}) {
                my $t={};

                $t->{'option_space'} = ibap_readfield_simple_string('OptionSpace', 'name', $_->option_space());
                $t->{'match_value'} = ibap_value_o2i_string($_->match_value());

                #
                $t->{'use_substring'} = ibap_value_o2i_boolean($_->is_substring()) if defined $_->is_substring();
                $t->{'substring_length'} = ibap_value_o2i_int($_->substring_length()) if defined $_->substring_length();
                $t->{'substring_offset'} = ibap_value_o2i_int($_->substring_offset()) if defined $_->substring_offset();

                push @opts, tIBType('option60_match_rule',$t);
            }

            @return_args = (1, 0, tIBType('ArrayOfoption60_match_rule', \@opts));
        } else {
            @return_args = (0);
        }
    } else {
        @return_args = (1, 1, undef);
    }
    return @return_args;
}

sub ibap_o2i_zone_associations
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $tempref->{$current}) {
        if (ref ($tempref->{$current}) eq 'ARRAY') {
            my @soc;

            foreach my $zoneobj(@{$tempref->{$current}}) {
                my $t={};

                $t->{'is_default'} = defined($zoneobj->{'is_default'}) ? ibap_value_o2i_boolean($zoneobj->{'is_default'}) : ibap_value_o2i_boolean("false");
                my $zone_tempref={
                                  zone => $zoneobj,
                                  view => $tempref->{'view'}
                                 };
                $t->{'zone'} = ibap_arg_zone_convert($session, 'zone', $zone_tempref);
                return (0) unless $t->{'zone'};
                push @soc, tIBType('zone_association',$t);
            }

            return (1, 0, tIBType('ArrayOfzone_association', \@soc));
        } else {
            return (0);
        }
    } else {
        return (1, 1, undef);
    }
}

sub ibap_i2o_zone_associations
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && ref($$ibap_object_ref{$current}) eq 'ARRAY') {
		my @soc_list = @{$$ibap_object_ref{$current}};
        foreach my $assoc(@soc_list){
          if($assoc->{'zone'}){
            my $zoneobj;
            $zoneobj=ibap_i2o_generic_object_convert($self,$session,'zone',$assoc,$return_object_cache_ref);
            $zoneobj->is_default(ibap_value_i2o_boolean($assoc->{'is_default'}));
            push @newlist, $zoneobj;
          }
        }
        return(\@newlist);
    }
}

sub ibap_lazy_i2o_zone_associations_use_member
{
  my $self=shift;
  my $ibap_object_ref=shift;
  my $server=shift;
  my $session=shift;
  my $return_object_cache_ref=shift;
  my $zone_list=ibap_i2o_zone_associations($self,$session,'zone_associations',$ibap_object_ref,$return_object_cache_ref);
  my $use_zone_associations=defined($ibap_object_ref->{'use_zone_associations'})?$ibap_object_ref->{'use_zone_associations'}:0;
  $self->{'use_zone_associations'}=$use_zone_associations;
  if($use_zone_associations){
      $self->{'zone_associations'}=$zone_list;
  }else{
      $self->{'zone_associations'}=undef;
  }
}

sub ibap_i2o_nameserver
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
		my @dns_list = @{$$ibap_object_ref{$current}};
		my @newlist;

		if ($current eq 'external_secondaries') {
			@newlist=@{$self->secondaries()} if defined $self->secondaries();
		}

		foreach my $dns (@dns_list) {
			push @newlist, ibap_nameserver_from_hash($self,$dns, $$ibap_object_ref{'fqdn'});
		}

		return (\@newlist);
	}
}

sub ibap_nameserver_from_hash
{
	my ($self, $construct_from, $ddns) = @_;

	my $tempaddr;
	if (${$construct_from}{'address'} =~ m/:/) {
		$tempaddr='ipv6addr';
	} else {
		$tempaddr='ipv4addr';
	}

	my $membertemp= Infoblox::DNS::Nameserver->new( 'name'     => ${$construct_from}{'name'},
										   $tempaddr => ${$construct_from}{'address'},
										   'stealth'  => (defined(${$construct_from}{'stealth'}) && ${$construct_from}{'stealth'} eq '1') ? 'true' : 'false',
										 );

    $membertemp->ddns_zone($ddns) if $ddns;

	if (${$construct_from}{'use_tsig_key'}) {
		$membertemp->TSIGname(${$construct_from}{'tsig_key_name'});
        $membertemp->TSIGalgorithm(${$construct_from}{'tsig_key_alg'});
		if (${$construct_from}{'use_2x_tsig_key'}) {
			$membertemp->TSIGkey(':2xCOMPAT');
		} else {
			$membertemp->TSIGkey(${$construct_from}{'tsig_key'});
		}
	}

	if (defined ${$construct_from}{'shared_with_ms_parent_delegation'}) {
		$membertemp->ms_parent_delegated(ibap_value_i2o_boolean(${$construct_from}{'shared_with_ms_parent_delegation'}));
	}
    else {
		$membertemp->ms_parent_delegated('false');
    }

    return $membertemp;
}

my @dnssec_data = (
    ['dnssec_enabled', 'enable_dnssec'],
    ['dnssec_expired_signatures_enabled', 'enable_dnssec_expired_signatures'],
    ['dnssec_validation_enabled', 'enable_dnssec_validation'],
    ['enable_hsm_signing', 'enable_hsm_signing'],
    ['dnssec_blacklist_enabled', 'enable_dnssec_blacklist'],
    ['dnssec_dns64_enabled', 'enable_dnssec_dns64'],
    ['dnssec_nxdomain_enabled', 'enable_dnssec_nxdomain'],
    ['dnssec_rpz_enabled', 'enable_dnssec_rpz'],
);

sub ibap_i2o_dnssec_props
{
	my ($self, $session, $current, $ibap_object_ref, $ibap_object_cache_ref) = @_;
	if($$ibap_object_ref{'dnssec'})
	{
		my $dnssec=$$ibap_object_ref{'dnssec'};
        foreach (@dnssec_data) {
            next if $_->[0] eq 'dnssec_enabled';
            $self->{$_->[0]} = ibap_value_i2o_boolean(defined $$dnssec{$_->[1]} ? $$dnssec{$_->[1]} : 0) if $self->can($_->[0]);
        }
		return ibap_value_i2o_boolean(defined $$dnssec{'enable_dnssec'} ? $$dnssec{'enable_dnssec'} : 0);
	}
}

sub ibap_o2i_dnssec_props
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	my %sub_write_args;

	if(!defined($$tempref{'dnssec_enabled'})
		&& !defined($$tempref{'dnssec_expired_signatures_enabled'})
		&& !defined($$tempref{'dnssec_validation_enabled'})
		)
	{
		return (1,1,undef);
	}

    foreach (@dnssec_data) {
        $sub_write_args{$_->[1]} = ibap_value_o2i_boolean($$tempref{$_->[0]}) if defined $$tempref{$_->[0]};
    }

	push @return_args, 1;
	push @return_args, 0;
	push @return_args, tIBType('dnssec', \%sub_write_args);

	return @return_args;
}


#
my %_alg_hash_=(
                1  => 'RSAMD5',
                3  => 'DSA',
                5  => 'RSASHA1',
                6  => 'NSEC3DSA',
                7  => 'NSEC3RSASHA1',
                8  => 'RSASHA256',
                10 => 'RSASHA512'
               );

my %_rev_alg_hash_= reverse %_alg_hash_;
$_rev_alg_hash_{'NSEC3RSASHA256'} = 8;
$_rev_alg_hash_{'NSEC3RSASHA512'} = 10;

#
our @dnssec_algorithm_list = keys %_rev_alg_hash_;
push @dnssec_algorithm_list, ('1','3','5','6','7');




sub ibap_i2o_key_algorithm
{
    my ($self, $session, $current, $ibap_object_ref, $ibap_object_cache_ref) = @_;
    my $algorithm;

    if(defined($$ibap_object_ref{$current}))
    {
        $algorithm=$$ibap_object_ref{$current};
        $algorithm=$_alg_hash_{$algorithm} if(defined($_alg_hash_{$algorithm}));

        #
        #
        if (defined($$ibap_object_ref{'next_secure_type'}) && $$ibap_object_ref{'next_secure_type'} eq 'NSEC3' && $$ibap_object_ref{$current} > 7) {
            $algorithm='NSEC3'.$algorithm;
        }
    }

    return $algorithm;
}

sub __algorithm_convert_helper__
{
    my ($value, $field, $session) = @_;
    my ($alg,$extra);

    if (exists($_rev_alg_hash_{$value})) {
        $alg=$_rev_alg_hash_{$value};
    } elsif ($value=~/^1|3|5|6|7$/) {
        $alg=$value;
    } else {
        set_error_codes(1012,"Invalid value for algorithm in $field");
    }

    if ($alg && $alg > 7) {
        if ($value =~ m/^NSEC3/) {
            $extra = 'NSEC3';
        }
        else {
            $extra = 'NSEC';
        }
    }

    return ($alg, $extra);
}


sub ibap_o2i_key_algorithm
{
    my ($self, $session, $current, $tempref) = @_;

    if(defined($$tempref{$current}))
    {
        my @return_args = (1,0);

        my ($alg, $extra) = __algorithm_convert_helper__($$tempref{$current},$current,$session);
        return (0) unless defined $alg;

        push @return_args, ibap_value_o2i_string($alg);
        if ($extra) {
			my %extra_write_arg;
			$extra_write_arg{'field'} = 'next_secure_type';
			$extra_write_arg{'value'} = ibap_value_o2i_string($extra);
			push @return_args, \%extra_write_arg;
        }

        return @return_args;
    } else {
        return(1,1,undef);
    }
}

#
#
#

=head1 SUMMARY

 @dnssec_allowed_algorithms

 &ibap_i2o_dnssec_key_params
 &ibap_o2i_dnssec_key_params
 &dnssec_algorithm_size_accessor

=head1 DNSSEC ALGORITHMS

 algorithm mappings for dnssec KSK and ZSK  algorithms.
 nst - value of 'next_secure_type'. as per DNSSECENH FS
 NSEC3RSASHA256  and NSEC3RSASHA512 should be  replaced
 with NSEC analogs.

 %_alg_hash, %_rev_alg_hash  and  such  methods  as
 __algorithm_convert_helper__, ibap_*_key_algorithm
 methods  are  left  as  well  as  they are used by
 Infoblox::DNS::DNSSecKeyRecord.

                                table 1
 ---------------------------------------
 |    algorithm   | maps       | nst   |
 |----------------|------------|-------|
 | RSAMD5         | RSAMD5     | NSEC  |
 | DSA            | DSA        | NSEC  |
 | RSASHA1        | RSASHA1    | NSEC  |
 | NSEC3DSA       | DSA        | NSEC3 |
 | NSEC3RSASHA1   | RSASHA1    | NSEC3 |
 | RSASHA256      | RSASHA256  | NSEC  |
 | RSASHA512      | RSASHA512  | NSEC  |
 | NSEC3RSASHA256 | RSASHA256  | NSEC3 |
 | NSEC3RSASHA512 | RSASHA512  | NSEC3 |
 | 1              | RSAMD5     | NSEC  |
 | 3              | DSA        | NSEC  |
 | 5              | RSASHA1    | NSEC  |
 | 8              | RSASHA256  | NSEC  |
 | 10             | RSASHA512  | NSEC  |
 | 6              | DSA        | NSEC3 |
 | 7              | RSASHA1    | NSEC3 |
 ---------------------------------------

=cut

#
my %_nsec3_algorithm_mappings = (
    NSEC3DSA       => 'DSA',
    NSEC3RSASHA1   => 'RSASHA1',
    6              => 'DSA',
    7              => 'RSASHA1',
    NSEC3RSASHA512 => 'RSASHA512',
    NSEC3RSASHA256 => 'RSASHA256',
);

#
my %_nsec_algorithm_mappings = (
    RSAMD5    => 'RSAMD5',
    DSA       => 'DSA',
    RSASHA1   => 'RSASHA1',
    RSASHA256 => 'RSASHA256',
    RSASHA512 => 'RSASHA512',
    1         => 'RSAMD5',
    3         => 'DSA',
    5         => 'RSASHA1',
    8         => 'RSASHA256',
    10        => 'RSASHA512'
);

#
our @dnssec_allowed_algorithms = (
    keys %_nsec3_algorithm_mappings,
    keys %_nsec_algorithm_mappings,
);

=head1 __dnssec_algorithm_convert_helper__( )

description:

 use this method to convert old algorithm names
 to a new algorithm values as per table 1.

parameters:

 value   - required. one of @dnssec_allowed_algorithm
 field   - required. 'dnssec_(ksk|zsk)_algorithm'

returns:

 in array context both 'algorithm' and 'next_secure_type'
 returned. in scalar context only 'next_secure_type' is returned

example:

 my ($algorithm, $next_secure_type) = __dnssec_algorithm_convert_helper__('NSEC3RSASHA256');

=cut

sub __dnssec_algorithm_convert_helper__ {

    my ($value, $field) = @_;
    my ($alg, $extra);

    #
    return undef unless defined $value;

    if (exists $_nsec3_algorithm_mappings{$value}) {

        $alg = $_nsec3_algorithm_mappings{$value};
        $extra = 'NSEC3';

    } elsif (exists $_nsec_algorithm_mappings{$value}) {

        $alg = $_nsec_algorithm_mappings{$value};
        $extra = 'NSEC';

    } else {
        set_error_codes(1012, "Invalid value for algorithm in $field");
        return;
    }
    return wantarray ? ($alg, $extra) : $extra;
}

sub __new2old_algorithm_helper__ {
    my ($self, $value) = @_;

    return undef unless defined $value;

    if ($self->{next_secure_type} && $self->{next_secure_type} eq 'NSEC3') {
        return 'NSEC3' . $value;
    } else {
        return $value;
    }
}

sub dnssec_algorithm_size_accessor {

    my $self   = shift;
    my $member = shift;

    $member =~ m/dnssec_(ksk|zsk)_(algorithm|size)/;
    my ($type, $struct_field) = ($1, $2);
    my $other_struct_field = $struct_field eq 'algorithm' ? 'size' : 'algorithm';
    my $struct_array_name = "dnssec_${type}_algorithms";
    my $other_struct_array_name = $type eq 'ksk' ? 'dnssec_zsk_algorithms' : 'dnssec_ksk_algorithms';

    my $algorithms = $self->$struct_array_name() || [];

    if (scalar @$algorithms > 1) {
        set_error_codes(1105, "$member is deprecated, use $struct_array_name instead.");
        return undef;
    }

    if (@_) {
        my $value = shift;
        my ($nvalue, $extra) = ($value, undef);

        if ($struct_field eq 'algorithm') {
            #
            #
            #
            ($nvalue, $extra) = __dnssec_algorithm_convert_helper__($value, $member);
            return undef if defined $value and not defined $nvalue;

            #
            $self->{"__${member}__"} = $value;
        }

        if (not defined $nvalue) {
            if (not scalar @$algorithms) {
                return $self->$struct_array_name(undef);
            } else {
                if (not defined $$algorithms[0]->$other_struct_field()) {

                    #
                    #
                    if (not defined $self->$other_struct_array_name()) {
                        $self->{next_secure_type} = undef;
                    }
                    return $self->$struct_array_name(undef);
                } else {
                    return $$algorithms[0]->$struct_field(undef);
                }
            }
        } else {
            if (not scalar @$algorithms) {
                my $new_alg = Infoblox::DNS::DNSSecKeyAlgorithm->new($struct_field => $nvalue);
                return $self->$struct_array_name([$new_alg]);
            } else {
                return $$algorithms[0]->$struct_field($nvalue);
            }
        }
    } else {
        if (not scalar @$algorithms) {
            return undef;
        } else {
            if ($struct_field eq 'algorithm') {
                return ($self->{"__${member}__"} ||
                        __new2old_algorithm_helper__($self, $$algorithms[0]->$struct_field()));
            } else {
                return $$algorithms[0]->$struct_field();
            }
        }
    }
}


#

sub ibap_o2i_algorithms_list
{
    my ($self, $session, $current, $tempref) = @_;

    my $algs = $$tempref{$current};
    my $is_array = ref($algs) eq 'ARRAY';

    if (not defined $algs or ($is_array and scalar(@{$algs}) == 0)) {
        return (1, 0, tIBType('ArrayOfdnssec_key_algorithm', []));
    } else {
        return ibap_o2i_generic_struct_list_convert($self,
            $session, $current, $tempref);
    }
}

sub ibap_i2o_dnssec_key_params
{
    my ($self, $session, $current, $ibap_object_ref, $ibap_object_cache_ref) = @_;
    if($$ibap_object_ref{'dnssec_key_params'})
    {
        my $key_params=$$ibap_object_ref{'dnssec_key_params'};

        #
        #
        #

        $self->next_secure_type($$key_params{'next_secure_type'});
        $self->dnssec_ksk_rollover_interval($$key_params{'ksk_rollover'});
        $self->dnssec_signature_expiration($$key_params{'signature_expiration'});
        $self->dnssec_zsk_algorithms(ibap_i2o_generic_object_list_convert($self, $session, 'zsk_algorithms', $key_params));
        $self->dnssec_ksk_algorithms(ibap_i2o_generic_object_list_convert($self, $session, 'ksk_algorithms', $key_params));
        $self->dnssec_nsec3_salt_min_length($$key_params{'nsec3_salt_min_length'});
        $self->dnssec_nsec3_salt_max_length($$key_params{'nsec3_salt_max_length'});
        $self->dnssec_nsec3_iterations($$key_params{'nsec3_iterations'});
        $self->dnssec_zsk_rollover_mechanism($$key_params{'zsk_rollover_mechanism'});
        $self->dnssec_enable_ksk_auto_rollover(ibap_value_i2o_boolean($$key_params{'enable_ksk_auto_rollover'}));
        $self->dnssec_ksk_rollover_notification_config($$key_params{'ksk_rollover_notification_config'});
        $self->dnssec_ksk_email_notification_enabled(ibap_value_i2o_boolean($$key_params{'ksk_email_notification_enabled'}));
        $self->dnssec_ksk_snmp_notification_enabled(ibap_value_i2o_boolean($$key_params{'ksk_snmp_notification_enabled'}));

        #
        #

        return $$key_params{'zsk_rollover'};
    }
}

sub ibap_o2i_dnssec_key_params
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    my %sub_write_args;

    return (1, 1, undef) if defined $self->{'__already_done_dnssec__'};
    $self->{'__already_done_dnssec__'} = 1;

    if(!defined($$tempref{'dnssec_ksk_algorithms'})
        && !defined($$tempref{'dnssec_ksk_rollover_interval'})
        && !defined($$tempref{'dnssec_signature_expiration'})
        && !defined($$tempref{'dnssec_zsk_algorithms'})
        && !defined($$tempref{'dnssec_zsk_rollover_interval'})
        && !defined($$tempref{'dnssec_nsec3_salt_min_length'})
        && !defined($$tempref{'dnssec_nsec3_salt_max_length'})
        && !defined($$tempref{'dnssec_nsec3_iterations'})
        && !defined($$tempref{'dnssec_zsk_rollover_mechanism'})
        && !defined($$tempref{'dnssec_enable_ksk_auto_rollover'})
        && !defined($$tempref{'dnssec_ksk_rollover_notification_config'})
        && !defined($$tempref{'dnssec_ksk_email_notification_enabled'})
        && !defined($$tempref{'dnssec_ksk_snmp_notification_enabled'})
        && !defined($$tempref{'next_secure_type'})
    ){
        return (1, 1, undef);
    }

    my @res;
    if ($$tempref{dnssec_ksk_algorithms}) {

        @res = ibap_o2i_algorithms_list($self, $session, 'dnssec_ksk_algorithms', $tempref);

        if (@res and $res[0]) {
            $sub_write_args{ksk_algorithms} = $res[2];
        } else {
            return (0);
        }
    }

    if ($$tempref{dnssec_zsk_algorithms}) {

        @res = ibap_o2i_algorithms_list($self, $session, 'dnssec_zsk_algorithms', $tempref);

        if (@res and $res[0]) {
            $sub_write_args{zsk_algorithms} = $res[2];
        } else {
            return (0);
        }
    }

    if($$tempref{'dnssec_ksk_rollover_interval'})
    {
        $sub_write_args{'ksk_rollover'}=tUInteger($$tempref{'dnssec_ksk_rollover_interval'});
    }
    if($$tempref{'dnssec_signature_expiration'})
    {
        $sub_write_args{'signature_expiration'}=tUInteger($$tempref{'dnssec_signature_expiration'});
    }

    if($$tempref{'dnssec_zsk_rollover_interval'}) {
        $sub_write_args{'zsk_rollover'}=tUInteger($$tempref{'dnssec_zsk_rollover_interval'});
    }

    if (defined($$tempref{'dnssec_nsec3_salt_min_length'})) {
        $sub_write_args{'nsec3_salt_min_length'} = tUInteger($$tempref{'dnssec_nsec3_salt_min_length'});
    }

    if (defined($$tempref{'dnssec_nsec3_salt_max_length'})) {
        $sub_write_args{'nsec3_salt_max_length'} = tUInteger($$tempref{'dnssec_nsec3_salt_max_length'});
    }

    if (defined($$tempref{'dnssec_nsec3_iterations'})) {
        $sub_write_args{'nsec3_iterations'} = tUInteger($$tempref{'dnssec_nsec3_iterations'});
    }

    if (defined($$tempref{'dnssec_zsk_rollover_mechanism'})) {
        $sub_write_args{'zsk_rollover_mechanism'} = tString($$tempref{'dnssec_zsk_rollover_mechanism'});
    }

    if (defined($$tempref{'dnssec_enable_ksk_auto_rollover'})) {
        $sub_write_args{'enable_ksk_auto_rollover'} = ibap_value_o2i_boolean(($$tempref{'dnssec_enable_ksk_auto_rollover'}));
    }

    if (defined($$tempref{'dnssec_ksk_rollover_notification_config'})) {
        $sub_write_args{'ksk_rollover_notification_config'} = tString($$tempref{'dnssec_ksk_rollover_notification_config'});
    }

    if (defined($$tempref{'dnssec_ksk_email_notification_enabled'})) {
        $sub_write_args{'ksk_email_notification_enabled'} = ibap_value_o2i_boolean(($$tempref{'dnssec_ksk_email_notification_enabled'}));
    }

    if (defined($$tempref{'dnssec_ksk_snmp_notification_enabled'})) {
        $sub_write_args{'ksk_snmp_notification_enabled'} = ibap_value_o2i_boolean(($$tempref{'dnssec_ksk_snmp_notification_enabled'}));
    }

    my $next_secure_type = $self->{next_secure_type};
    if ($self->{__dnssec_ksk_algorithm__} || $self->{__dnssec_zsk_algorithm__}) {
        my $zsk_nst = __dnssec_algorithm_convert_helper__($self->{__dnssec_ksk_algorithm__}, 'dnssec_ksk_algorithm');
        my $ksk_nst = __dnssec_algorithm_convert_helper__($self->{__dnssec_zsk_algorithm__}, 'dnssec_zsk_algorithm');

	    if (($ksk_nst || '') ne ($zsk_nst || '')) {
            set_error_codes(1012, 'Incompatible values between dnssec_ksk_algorithm and dnssec_zsk_algorithm');
            return (0);
        }

        $next_secure_type = $ksk_nst;
    }

    if (defined $next_secure_type) {
        $sub_write_args{'next_secure_type'} = ibap_value_o2i_string($next_secure_type);
    }

    push @return_args, 1;
    push @return_args, 0;
    push @return_args, tIBType('dnssec_key_params', \%sub_write_args);

    return @return_args;
}

#
#
#

sub ibap_i2o_dnssec_trusted_keys
{
	my ($self, $session, $current, $ibap_object_ref) = @_;
	my @newlist;

	if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {

		foreach my $key (@{$$ibap_object_ref{$current}} )
		{
		    #
            #
            #
		    push @newlist, Infoblox::DNS::DnssecTrustedKey->new(
			    fqdn                             => ${$key}{'fqdn'},
			    secure_entry_point               => ibap_value_i2o_boolean(${$key}{'secure_entry_point'}),
			    algorithm                        => ibap_i2o_key_algorithm($self,$session,'dnssec_algorithm',$key),
			    key                              => ${$key}{'trusted_key'}
			    );
		}
		return \@newlist;
	} else {
		return [];
	}

}

sub ibap_o2i_dnssec_trusted_keys
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		my @keys_list=@{$$tempref{$current}};

		if (@keys_list) {
			my @newlist;

			push @return_args, 1;
			push @return_args, 0;

			foreach my $key (@keys_list) {
			        my %sub_write_arg;

				if (defined $key->fqdn()) {
					return (0)
						unless $sub_write_arg{'fqdn'} = ibap_value_o2i_string($key->fqdn(),'fqdn',$session);
				} else {
				        set_error_codes(1012,"Missing required attribute fqdn for DnssecTrustedKey");
				        return (0);
				}
				if (defined $key->secure_entry_point()) {
					return (0)
					    unless
					    $sub_write_arg{'secure_entry_point'} =
					    ibap_value_o2i_boolean($key->secure_entry_point(),'secure_entry_point',$session);
				} else {
					$sub_write_arg{'secure_entry_point'} = ibap_value_o2i_boolean('true','secure_entry_point',$session);
				}
				if (defined $key->algorithm()) {
                    #
                    #
                    my ($alg, $extra) = __algorithm_convert_helper__($key->algorithm(),'dnssec_algorithm',$session);
                    return (0) unless $alg;

					return (0)
					    unless
					    $sub_write_arg{'dnssec_algorithm'} =
					    ibap_value_o2i_string($alg,'dnssec_algorithm',$session);
				} else {
                                        set_error_codes(1012,"Missing required attribute algorithm for DnssecTrustedKey");
					return (0);
				}
				if (defined $key->key()) {
					return (0)
					    unless
					    $sub_write_arg{'trusted_key'} =
					    ibap_value_o2i_string($key->key(),'trusted_key',$session);
				} else {
					set_error_codes(1012,"Missing required attribute key for DnssecTrustedKey");
					return (0);
				}

				push @newlist, tIBType('dnssec_trusted_key', \%sub_write_arg );
			}

			push @return_args, tIBType('ArrayOfdnssec_trusted_key',\@newlist);
		} else {
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, tIBType('ArrayOfdnssec_trusted_key', []);
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 1;
		push @return_args, undef;
	}

	return @return_args;
}

sub ibap_func_call_handler
{
	my ($self, $server, $session) = @_;

	my $call_args = {};

	foreach my $current (keys %$self) {
		next if $current =~ m/^__/;

		my $name = $current;
        my $ref_name_mappings;
        my $ref_object_to_ibap;

        {
            no strict 'refs';
            my $objclass = $self->__get_class_methods_class__();
            $ref_name_mappings  = \%{$objclass . '::_name_mappings'};
            $ref_object_to_ibap = \%{$objclass . '::_object_to_ibap'};
        }

        if (defined $ref_name_mappings->{$current}) {
            $name = $ref_name_mappings->{$current};
        }

		my @converted_values = $ref_object_to_ibap->{$current}($self, $session, $current,$self);
		if (@converted_values) {
			my $success=shift @converted_values;
			if ($success) {
				my $ignore_value=shift @converted_values;
                my $value = shift @converted_values;

                #
                #
                #
                if (ref($value) =~ /IBAPTypes::IBType$/
                    && $value->{'type'} eq 'object_id') {
                    $value = { object_id => $value };
                }

                #
                #
				foreach my $extra_args (@converted_values) {
					$call_args->{$$extra_args{'field'}} = $$extra_args{'value'};
				}

				if ($ignore_value) {
					next;
				}
				$call_args->{$name} = $value;
			} else {
				return;
			}
		} else {
			return;
		}
	}

	return $call_args;
}

#

sub return_fields_extensible_attributes
{
    return tField('extensible_attributes',
                  {
                   sub_fields =>
                   [
                    tField('values'),
                    tField('tag',
                           {
                            sub_fields =>
                            [
                             tField('attribute_type'),
                             tField('name'),
                            ],
                           }
                          ),
                    tField('inheritance_source', { sub_fields => [ tField('object_id') ] }),
                   ],
                  }
                 );
}

my $__member_subfields__ = [
                           tField('host_name'),
                           tField('vip_setting',
                                  {
                                   sub_fields =>
                                   [
                                    tField('address'),
                                   ]
                                  }
                                 ),
                           tField('ipv6_setting',
                                  {
                                   sub_fields =>
                                   [
                                    tField('enabled'),
                                    tField('virtual_ip'),
                                   ],
                                  }
                                 ),
                           ];

sub return_fields_member_basic_data
{
    return {
            sub_fields => $__member_subfields__,
           }
}

sub return_fields_member_basic_data_no_access_ok
{
    return {
            not_exist_ok => 1,
            default_no_access_ok => 1,
            sub_fields => $__member_subfields__,
           }
}

sub return_fields_templates
{
    my $tmpl_name = shift;

    return tField($tmpl_name,
        {
            sub_fields => [
                tField('template',
                    {
                        sub_fields => [ tField('name') ]
                    }
                ),
                tField('offset'),
                tField('count'),
            ]
        }
    );
}

#
sub value_type_field_name_for_type
{
    my ($type, $op_string) = @_;

    if ($type eq 'STRING' ||
        $type eq 'EMAIL' ||
        $type eq 'URL' ||
        $type eq 'ENUM') {
        return 'value_string';
    } elsif ($type eq 'INTEGER') {
        return 'value_integer';
    } elsif ($type eq 'DATE') {
        if ($op_string && (uc($op_string) eq 'RELATIVE_DATE')) {
            #
            #
            return 'value_string';
        } else {
            return 'value_date';
        }
    } elsif ($type eq 'BOOLEAN') {
        return 'value_boolean';
    } else {
        set_error_codes(1104, "Invalid value type '$type'." );
        return;
    }
}

sub _i2o_query_item
{
    my ($objectref) = @_;

    #
    #
    my $is_extensible_attribute = 'false';
    if ($$objectref{field_type} &&
        $$objectref{field_type} eq 'EXTATTR') {
        $is_extensible_attribute = 'true';
    }


    #
    #
    my $operator = lc($$objectref{operator});
    my $op_match = $$objectref{op_match};

    my $value_type = $$objectref{value_type};
    my $value_type_field = undef;
    my $value = undef;

    if (defined $value_type) {
        $value_type_field = value_type_field_name_for_type($value_type, $operator);
        $value = $$objectref{value}{$value_type_field};
    }

    if ($operator eq 'eq') {
        if (!$op_match) {
            $operator = 'ne';
        }
    } elsif ($operator eq 'begins_with') {
        if ($op_match) {
            $operator = 'begins with';
        } else {
            $operator = 'does not begin with';
        }
    } elsif ($operator eq 'ends_with') {
        if ($op_match) {
            $operator = 'ends with';
        } else {
            $operator = 'does not end with';
        }
    } elsif ($operator eq 'has_value') {
        if ($op_match) {
            $operator = 'has value';
        } else {
            $operator = 'does not have value';
        }
    }

    if (defined $value_type and $value_type eq 'DATE') {
        if ($operator eq 'eq') {
            $operator = 'on';
        }
    }

    if ($value) {
        if ($operator eq 'relative_date') {
            if ($value eq 'TODAY') {
                $operator = 'today';
                $value = undef;
            } elsif ($value eq 'YESTERDAY') {
                $operator = 'yesterday';
                $value = undef;
            } elsif ($value eq 'WEEK') {
                $operator = 'this week';
                $value = undef;
            } elsif ($value eq 'MONTH') {
                $operator = 'this month';
                $value = undef;
            } else {
                $operator = 'within';
            }
        } elsif (defined $value_type and $value_type eq 'DATE') {

            unless ($$objectref{operator} eq 'HAS_VALUE' || $$objectref{operator} eq 'EQ') {
                $value = iso8601_datetime_to_unix_timestamp($value);
            }
        }

        if (defined $value_type and $value_type eq 'BOOLEAN') {
            #
            $value = ibap_value_i2o_boolean($value);
        }
    } elsif (defined $value_type and $value_type eq 'BOOLEAN') {
        #
        $value = ibap_value_i2o_boolean(0);
    }

    my $name;
    if(exists($reverse_qitems_name_mappings{$$objectref{name}})){
      $name=$reverse_qitems_name_mappings{$$objectref{name}};
    }else{
      $name=$$objectref{name};
    }
    if ($name eq 'v_type'){
      if(exists($reverse_v_type_name_mapping{$value})){
        $value = $reverse_v_type_name_mapping{$value};
      }
    }

    my $query_item;
    if (defined($value)) {
        $query_item = Infoblox::Grid::SmartFolder::QueryItem->new(
            name => $name,
            is_extensible_attribute => $is_extensible_attribute,
            operator => $operator,
            value => $value,
        );
    }
    else {
        $query_item = Infoblox::Grid::SmartFolder::QueryItem->new(
            name => $name,
            is_extensible_attribute => $is_extensible_attribute,
            operator => $operator,
        );
    }


    return $query_item;
}

sub ibap_i2o_query_item
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($$ibap_object_ref{$current}) {
        my $objectref = $$ibap_object_ref{$current};
        my $query_item = _i2o_query_item($objectref);
        return $query_item;
    }

    return;
}

sub ibap_i2o_query_item_list
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        my @objects = @{$$ibap_object_ref{$current}};

        foreach my $objectref (@objects) {
            my $query_item = _i2o_query_item($objectref);
            push @newlist, $query_item;
        }
        return \@newlist;
    } else {
        return;
    }
}

sub ibap_i2o_discovered_data
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $ref_ibap_to_object;
    my $ref_reverse_name_mappings;

    {
        no strict 'refs';
        my $objclass = $self->__get_class_methods_class__();
        $ref_reverse_name_mappings  = \%{$objclass . '::_reverse_name_mappings'};
        $ref_ibap_to_object = \%{$objclass . '::_ibap_to_object'};
    }

    foreach my $key (keys %{$$ibap_object_ref{$current}}) {
        my $member=$key;
        #
        #
        if ($$ref_reverse_name_mappings{"_discovered_$key"}) {
            $member = $$ref_reverse_name_mappings{"_discovered_$key"};
        }elsif ($$ref_reverse_name_mappings{$key}) {
            $member = $$ref_reverse_name_mappings{$key};
        }
        my $converted_data=$$ibap_object_ref{$current}{$key};

        if($$ref_ibap_to_object{"_discovered_$key"}){
            $converted_data=$$ref_ibap_to_object{"_discovered_$key"}($self,$session, $key, $$ibap_object_ref{$current}, $return_object_cache_ref);
        }
        elsif($$ref_ibap_to_object{$key}){
            $converted_data=$$ref_ibap_to_object{$key}($self,$session, $key, $$ibap_object_ref{$current}, $return_object_cache_ref);
        }
        $self->$member($converted_data);
    }
}


sub _o2i_query_item
{
    my ($session, $item, $name, $tempref) = @_;
    my %sub_write_arg;

    my $field_type;
    my $query_meta_entry_ref = $_global_identifier_query_meta{$name};

    #
    #
    #
    if ($item->is_extensible_attribute() &&
        $item->is_extensible_attribute() eq 'false') {
        $field_type = 'NORMAL';
    } else {
        $field_type = 'EXTATTR';
    }

    $query_meta_entry_ref = $session->__smart_folder_query_meta_cache_get_entry__($name, $field_type,
                                                                                 );

    if ($field_type eq 'EXTATTR') {
        if ($query_meta_entry_ref && defined $query_meta_entry_ref->{extattr}{object_id}{id}) {
            $sub_write_arg{ext_attr_def_ref} = tObjIdRef($query_meta_entry_ref->{extattr}{object_id}{id});
        } else {
            my @fields = (
                          {
                           'field' => 'name',
                           'value' => ibap_value_o2i_string($name),
                          }
                         );


            $sub_write_arg{ext_attr_def_ref} = ibap_readfield_simple('ExtensibleAttributeDefinition', \@fields, undef, 'extensible_attribute='.$name
                                                                    );
                    }
                }

    $sub_write_arg{field_type} = ibap_value_o2i_string($field_type, 'field_type', $session);

    #
    my $operator = $item->operator();
    my $value_to_subtract = 0;
    my $op_string;
    my $op_match = $item->op_match();
    my $op_value;
    my $no_value = 0; # don't get value

    #
    my $value;
    my $value_type;
    my $value_type_field;

    if (not defined $op_match) {
        $op_match = 1;
    }
    else {
        if ($op_match eq 'false') {
            $op_match = 0;
        }
    }

    if (defined $operator) {
        if (lc($operator) eq 'eq') {
            $op_string = 'EQ';
        } elsif (lc($operator) eq 'ne') {
            $op_string = 'EQ';
            $op_match = 0;
        } elsif (lc($operator) eq 'gt') {
            $op_string = 'GT';
        } elsif (lc($operator) eq 'geq') {
            $op_string = 'GEQ';
        } elsif (lc($operator) eq 'lt') {
            $op_string = 'LT';
        } elsif (lc($operator) eq 'leq') {
            $op_string = 'LEQ';
         } elsif (lc($operator) eq 'begins with') {
            $op_string = 'BEGINS_WITH';
        } elsif (lc($operator) eq 'does not begin with') {
            $op_string = 'BEGINS_WITH';
            $op_match = 0;
        } elsif (lc($operator) eq 'ends with') {
            $op_string = 'ENDS_WITH';
        } elsif (lc($operator) eq 'does not end with') {
            $op_string = 'ENDS_WITH';
            $op_match = 0;
        } elsif (lc($operator) eq 'has value') {
            $op_string = 'HAS_VALUE';
            $no_value = 1;
        } elsif (lc($operator) eq 'does not have value') {
            $op_string = 'HAS_VALUE';
            $op_match = 0;
            $no_value = 1;
        } elsif (lc($operator) eq 'on') {
            $op_string = 'EQ';
            $value_type = 'DATE';
            $value_type_field = 'value_date';
        } elsif (lc($operator) eq 'within') {
            $op_string = 'RELATIVE_DATE';
        } elsif (lc($operator) eq 'today') {
            $op_string = 'RELATIVE_DATE';
            $op_value = 'TODAY';
        } elsif (lc($operator) eq 'yesterday') {
            $op_string = 'RELATIVE_DATE';
            $op_value = 'YESTERDAY';
        } elsif (lc($operator) eq 'this week') {
            $op_string = 'RELATIVE_DATE';
            $op_value = 'WEEK';
        } elsif (lc($operator) eq 'this month') {
            $op_string = 'RELATIVE_DATE';
            $op_value = 'MONTH';
        } else {
            set_error_codes(1104, "Invalid operator '$operator'", $session);
            return undef;
        }
        $sub_write_arg{operator} = ibap_value_o2i_string($op_string, 'operator', $session);
        $sub_write_arg{op_match} = tBool($op_match);
    } else {
        set_error_codes(1103,"'operator' is a required field for SmartFolder::QueryItem", $session);
        return undef;
    }

    #
    #
    if (!$no_value) {
        #
        #
        #
        $value = $op_value ? $op_value : $item->value();
    }

    if ($op_string eq 'RELATIVE_DATE') {
        #
        $value_type = 'DATE';
    } elsif ($query_meta_entry_ref &&
             ref($query_meta_entry_ref) eq 'HASH') {
        #
        $value_type = $$query_meta_entry_ref{value_type};
    } elsif (!$value_type) {
        #
        $value_type = 'STRING';
    }

    if (!$value_type_field and defined $value_type) {
        #
        $value_type_field = value_type_field_name_for_type($value_type, $op_string);
    }

    $sub_write_arg{value_type} = ibap_value_o2i_string($value_type, 'value_type', $session);

    if ($value && $value_type && $value_type_field) {
        #
        #
        if ($value_type_field eq 'value_date') {
            if ($op_string eq 'EQ') {
                $value = iso8601_datetime_to_unix_timestamp($value);
            }
            else {
                $value = tDateTime($value);
            }
        } elsif ($value_type_field eq 'value_boolean') {
            #
            #
            $value = ibap_value_o2i_boolean($value);
        } elsif ($value_type_field eq 'value_string') {
            #
            #
            unless($name eq 'v_entity_type'){
              $value = ibap_value_o2i_string($value);
            }else{
              $value = ibap_value_o2i_enum_mapping($value,$value,$session,0,
                \%v_type_name_mapping);
            }
        } elsif ($value_type_field eq 'value_integer') {
            $value = ibap_value_o2i_int($value);
        } else {
            set_error_codes(1104, "Invalid value type field '$value_type_field'", $session);
            return undef;
        }

        $sub_write_arg{value} = tIBType('query_item_value', {$value_type_field => $value});
    }

    return \%sub_write_arg;
}

sub ibap_o2i_query_item
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {

        #
        #
        #

        #
        $session->__refresh_smart_folder_query_meta_cache__();

        my $item = $$tempref{$current};
        if (ref($item) eq 'Infoblox::Grid::SmartFolder::QueryItem') {
            my @tfail;
            push @tfail, 0;

            #
            my $name = $item->name();
            if(exists($qitems_name_mappings{$name})){
              $name=$qitems_name_mappings{$name};
            }
            my $sub_write_arg = _o2i_query_item($session, $item, $name, $tempref);
            return @tfail unless $sub_write_arg;

            if (defined $name) {
                return @tfail unless $sub_write_arg->{name} = ibap_value_o2i_string($name, 'name', $session);
            } else {
                set_error_codes(1103,"'name' is a required field for SmartFolder::QueryItem", $session);
                return @tfail;
            }

            push @return_args, 1;
            push @return_args, 0;
            push @return_args, $sub_write_arg;
        }
    }
    else {
        #
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}

sub ibap_o2i_query_item_list
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
        if (ref ($$tempref{$current}) eq 'ARRAY') {
            my @items;

            #
            #
            #

            #
            $session->__refresh_smart_folder_query_meta_cache__();

            foreach my $item (@{$$tempref{$current}}) {
                if (ref($item) eq 'Infoblox::Grid::SmartFolder::QueryItem') {
                    my @tfail;
                    push @tfail, 0;

                    #
                    my $name = $item->name();
                    if(exists($qitems_name_mappings{$name})){
                      $name=$qitems_name_mappings{$name};
                    }
                    my $sub_write_arg = _o2i_query_item($session, $item, $name, $tempref);
                    return @tfail unless $sub_write_arg;

                    if (defined $name) {
                        return @tfail unless $sub_write_arg->{name} = ibap_value_o2i_string($name, 'name', $session);
                    } else {
                        set_error_codes(1103,"'name' is a required field for SmartFolder::QueryItem", $session);
                        return @tfail;
                    }

                    push @items, $sub_write_arg;
                }
            }

            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType('ArrayOfquery_item',\@items);
        } else {
            #
            push @return_args, 0;
        }
    }
    else {
        #
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}

sub fixedaddress_get_search_callback_helper
{
	my ($self, $session, $object, $search_query_ref, $ref_ref_array_results, $return_fields, $cursor, $subfields) = @_;
	my ($currentcode,$currentmsg) = ($session->status_code(),$session->status_detail(),0);

	#
	my $server=$session->get_ibap_server() || return;
	set_error_codes($currentcode,$currentmsg,$session);
	#

	my ($result, @t, %args, $v6);
    $v6 = 1 if (ref($self) eq 'Infoblox::DHCP::IPv6FixedAddr');

    unless (defined $cursor && defined $cursor->{'ticket'}) {
        #
        @t=@{$search_query_ref};
        $args{'object_type'} = $v6 ? 'IPv6HostAddress' : 'HostAddress';

        foreach (@t) {
            if (${$_}{'field'} && ${$_}{'field'} eq 'ip_address') {
                #
                ${$_}{'field'} = 'address';
            } elsif (${$_}{'field'} && ${$_}{'field'} eq 'parent') {
                #
                ${$_}{'field'} = 'network';
            } elsif (${$_}{'type'} && ${$_}{'type'} eq 'object_id') {
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
                #
                return 1;
            } elsif (${$_}{'field'} && ${$_}{'field'} eq 'name') {
                #
                #
                #
                if (defined $cursor) {
                    $cursor->{has_more} = 0;
                }
                if ($ref_ref_array_results && ref($$ref_ref_array_results) eq 'ARRAY' && scalar(@{$$ref_ref_array_results})) {
                    #
                    #
                    return 1;
                }
                else {
                    #
                    #
                    #
                    #
                    #
                    set_error_codes(1003, undef, $session);
                    return 0;
                }
            }
        }
        $args{'search_fields'} = $search_query_ref;
    }

	#
    $args{'depth'} = 1;
    $args{'dups_use_refs'} = 1;
    $args{'return_fields'} = $subfields;
    $args{'implicit_defaults'} = 1;

    if (defined $cursor) {
        $args{'limit'} = $cursor->{'fetch_size'};
        $args{'paging_op'} = tString('FIRST_PAGE');

        if (defined $cursor->{'ticket'}) {
            $args{'paging_ticket'} = $cursor->{'ticket'};
            $args{'paging_op'} = tString('NEXT_PAGE') unless defined $cursor->{'first_page'};
        }
        delete $cursor->{'first_page'} if defined $cursor->{'first_page'};

        $args{'require_info'} = tIBType('requireinfo',{'require_has_next' => tBool(1), 'require_total_size' => tBool(0)});
    }

	#
    my $paging_info;
    if (defined $cursor) {
        eval { ($result, $paging_info) = $server->ObjectRead(\%args,undef,undef,1); };
    }
    else {
        eval { $result = $server->ObjectRead(\%args); };
    }
    if ($@) {
        $cursor->__invalidate__() if defined $cursor;
        $server->set_papi_error($@, $session, $object);
        return 0;
    }

    if (defined $cursor) {
        $cursor->{'ticket'} = $paging_info->{'ticket'};
        $cursor->{'has_more'} = $paging_info->{'has_next'};
    }

    #
    if (scalar(@{$result}) == 0) {
        if ($ref_ref_array_results && ref($$ref_ref_array_results) eq 'ARRAY' && scalar(@{$$ref_ref_array_results})) {
            #
            #
            return 1;
        }
        else {
            #
            #
            #
            #
            #
            set_error_codes(1003, undef, $session);
            return 0;
        }
    }

    my @results_array;
    my $pushlocal=1;

    my $host_caller=Infoblox::DNS::Host->__new__();
    #
    my %tempcache;
    if ($v6) {
        $result = $host_caller->__i2o_ipv6_addresses__($session, 'temp', { temp => $result}, \%tempcache);
    }
    else {
        $result = $host_caller->__i2o_addresses__($session, 'temp', { temp => $result}, \%tempcache);
    }

    if ($ref_ref_array_results && ref($$ref_ref_array_results) eq 'ARRAY' && scalar(@{$$ref_ref_array_results})) {
        #
        #
        $pushlocal=0;
    }

    if ($result && scalar(@{$result})) {
        foreach my $t (@{$result}) {
            #
            if ($v6) {
                next unless ref($t) eq 'Infoblox::DHCP::IPv6FixedAddr';
                next unless $t->duid();
            }
            else {
                next unless ref($t) eq 'Infoblox::DHCP::FixedAddr';
                next unless $t->mac();
            }

            if ($pushlocal) {
                push @results_array, $t;
            }
            else {
                push @{$$ref_ref_array_results}, $t;
            }
        }
    }

    if ($pushlocal) {
        if ($ref_ref_array_results) {
            $$ref_ref_array_results=\@results_array;
        }
    }

    set_error_codes(0, undef, $session);
    return 1;
}

sub ibap_o2i_netmask_to_cidr
{
    my ($self, $session, $current, $tempref) = @_;

    my $netmask = $tempref->{$current};
    if ($netmask) {
        my $cidr = mask_to_bits($netmask);
        if ($cidr) {
            return (1, 0, ibap_value_o2i_int($cidr));
        } else {
            set_error_codes(1012, 'invalid netmask (' . $netmask . ')' . $current, $session);
            return (0);
        }
    } else {
        return (1, 0, undef);
    }
}

sub ibap_i2o_netmask_to_cidr
{
    my ($self, $session, $current, $tempref) = @_;

    return cidr_to_mask($tempref->{$current});
}

sub ibap_i2o_f5_health
{
    my ($self, $session, $current, $tempref) = @_;

    $self->availability($tempref->{$current}{'availability'});
    $self->description($tempref->{$current}{'description'});
    return $tempref->{$current}{'enabled_state'};
}

sub ibap_i2o_domain_name_servers
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
        my @list;
        foreach (@{$$ibap_object_ref{$current}}) {
            push @list, $_->{'address'};
        }
        return join(',',@list);
    } else {
        return;
    }
}

sub ibap_o2i_domain_name_servers
{
	my ($self, $session, $current, $tempref) = @_;

    my @list;
    if ($$tempref{$current}) {
        my @t = split /,/,$$tempref{$current};
        foreach (@t) {
            push @list, tIBType('custom_dns_server', { address => ibap_value_o2i_string($_) });
        }
    }
    return (1,0,tIBType('ArrayOfcustom_dns_server', \@list));
}

sub ibap_i2o_mac_addresses
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($$ibap_object_ref{$current}) {
        my @list;
        foreach (@{$$ibap_object_ref{$current}}) {
            push @list, $_->{'mac_addr'};
        }
        return \@list;
    } else {
        return;
    }
}

sub ibap_o2i_mac_addresses
{
    my ($self, $session, $current, $tempref) = @_;

    my @list;
    if ($$tempref{$current}) {
        foreach (@{$$tempref{$current}}) {
            push @list, tIBType('custom_mac', { mac_addr => ibap_value_o2i_string($_) });
        }
    }
    return (1,0,tIBType('ArrayOfcustom_mac', \@list));
}

sub ibap_o2i_member_search
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        return ('dhcp_members',1,0,ibap_value_o2i_member($$tempref{$current}, 'member', $session, $self, 'member',1));
    }
    else {
        return (undef,1,1,undef);
    }
}

sub ibap_o2i_network_container_search
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
        my ($network, $netmask);

        if ($$tempref{$current} =~ /\//) {
            ($network, $netmask) = split /\//, $$tempref{$current};

            if (is_ipv4_address($netmask)) {
                $netmask = mask_to_bits($netmask);
            }
        }
        else {
            set_error_codes(1012,"the network container passed does not have a netmask",$session);
            return (0);
        }

        my @fields = (
                      {
                       'field' => 'address',
                       'value' => ibap_value_o2i_string($network),
                      },
                      {
                       'field' => 'cidr',
                       'value' => ibap_value_o2i_string($netmask),
                      }
                     );

        return (1,0, ibap_readfieldlist_simple('NetworkContainer', \@fields, undef, 'EXACT'));
	}
	else {
        return (undef,1,1,undef);
	}
}


#
sub __papi_to_ibap_templates__
{
    my ($self, $session, $current, $tempref, $obj_name) = @_;

    my @return_args;
    push @return_args, 1;

    if ($tempref->{$current} && ref($tempref->{$current}) eq 'ARRAY') {
        push @return_args, 0;

        my @newlist = ();

        for my $tmpl (@{$tempref->{$current}}) {
            my %sub_write_args;
            $sub_write_args{'template'} = ibap_readfield_simple($obj_name, 'name', tString($tmpl->{'name'}), $current);
            $sub_write_args{'offset'} = ibap_value_o2i_uint($tmpl->{'offset'}, 'offset', $session) if defined $tmpl->{'offset'};
            $sub_write_args{'count'} = ibap_value_o2i_uint($tmpl->{'count'}, 'count', $session)  if defined $tmpl->{'count'};
            push @newlist, tIBType('child_template_info', \%sub_write_args);
        }

        push @return_args, tIBType('ArrayOfchild_template_info',\@newlist);
    } else {
        push @return_args, 1;
        push @return_args, tIBType('ArrayOfchild_template_info',[]);
    }

    return @return_args;
}

sub ibap_o2i_fixed_address_templates
{
    my ($self, $session, $current, $tempref) = @_;

    return __papi_to_ibap_templates__(
            $self,
            $session,
            $current,
            $tempref,
            'FixedAddressTemplate');
}

sub ibap_o2i_ipv6_fixed_address_templates
{
    my ($self, $session, $current, $tempref) = @_;

    return __papi_to_ibap_templates__(
            $self,
            $session,
            $current,
            $tempref,
            'IPv6FixedAddressTemplate');
}

sub ibap_o2i_range_templates
{
    my ($self, $session, $current, $tempref) = @_;

    return __papi_to_ibap_templates__(
            $self,
            $session,
            $current,
            $tempref,
            'DhcpRangeTemplate');
}

sub ibap_o2i_ipv6_range_templates
{
    my ($self, $session, $current, $tempref) = @_;

    return __papi_to_ibap_templates__(
            $self,
            $session,
            $current,
            $tempref,
            'IPv6DhcpRangeTemplate');
}

sub ibap_i2o_templates
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    if ($ibap_object_ref->{$current} && @{$ibap_object_ref->{$current}}) {
        my @newlist = ();
        for my $tmpl (@{$ibap_object_ref->{$current}}) {
            push @newlist, Infoblox::DHCP::Template->new(
                name     => $tmpl->{'template'}{'name'},
                offset   => $tmpl->{'offset'},
                count    => $tmpl->{'count'},
            );
        }
        return \@newlist;
    } else {
        return [];
    }
}

sub simple_name_readfield_helper
{
	my ($self, $session, $current, $tempref, $obj_name) = @_;

	if (defined $tempref->{$current}) {
        return (1, 0, ibap_readfield_simple_string($obj_name, 'name', $tempref->{$current}, $current));
	} else {
        return (1, 1, undef);
	}
}

sub ibap_o2i_fixed_address_template
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return simple_name_readfield_helper(
            $self,
            $session,
            $current,
            $ibap_object_ref,
            'FixedAddressTemplate');
}

sub ibap_o2i_ipv6_fixed_address_template
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return simple_name_readfield_helper(
            $self,
            $session,
            $current,
            $ibap_object_ref,
            'IPv6FixedAddressTemplate');
}

sub ibap_o2i_range_template
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return simple_name_readfield_helper(
            $self,
            $session,
            $current,
            $ibap_object_ref,
            'DhcpRangeTemplate');
}

sub ibap_o2i_ipv6_range_template
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return simple_name_readfield_helper(
            $self,
            $session,
            $current,
            $ibap_object_ref,
            'IPv6DhcpRangeTemplate');
}

sub ibap_o2i_gss_tsig_keys
{
	my ($self, $session, $current, $tempref, $type) = @_;

    return o2i_gss_tsig_keys_helper(
        $self, $session, $current, $tempref, 'gss_tsig_key');
}

sub ibap_o2i_ipv6_gss_tsig_keys
{
	my ($self, $session, $current, $tempref, $type) = @_;

    return o2i_gss_tsig_keys_helper(
        $self, $session, $current, $tempref, 'ipv6_gss_tsig_key');
}

sub o2i_gss_tsig_keys_helper
{
    my ($self, $session, $current, $tempref, $type, $fieldname) = @_;

    if ($tempref->{$current} && ref($tempref->{$current}) eq 'ARRAY') {
        my @newlist;
        foreach my $t (@{$tempref->{$current}}) {
            if($t && $t->{principal}) {
                my $v = ibap_value_o2i_string($t->{principal});
                return unless $v;

                my @fields = (
                    {
                        'field' => 'principal',
                        'value' => $v,
                    },
                );
                my $what='principal=' . $t->{principal};

                if (defined $t->{'version'}) {
                    $v = ibap_value_o2i_uint($t->{version});
                    return unless $v;

                    push @fields, {
                        'field' => 'version_number',
                        'value' => $v,
                    };
                    $what .= ',version=' . $t->{version};
                }

                if (defined $t->{'enctype'}) {
                    $v = ibap_value_o2i_string($t->{enctype});
                    return unless $v;

                    push @fields, {
                        'field' => 'enctype',
                        'value' => $v,
                    };
                    $what .= ',enctype=' . $t->{enctype};
                }

                push @newlist, ibap_readfield_simple('KerberosKey', \@fields, undef, $what);
            }
        }
        return (1, 0, tIBType('ArrayOfBaseObject', \@newlist));
    } else {
        return (1, 0, undef);
    }
}

sub gleq_search_helper
{
    my ($value, $search_type) = @_;
    my ($ifmatch, $always, $optional, $chopping) = ('POSITIVE', undef, undef, undef);

    #
    my $munged_value = $value;
    $munged_value =~ s/ //g;
    if ($munged_value =~ m/^>=<([^,]+),(.*)$/) {
        $munged_value = '>=' . $1;

        $optional = {
                     ifmatch     => 'POSITIVE',
                     search_type => 'LEQ',
                     value       => $2,
                    };
    }

    if (index($munged_value, '>=') == 0 || index($munged_value, '=>') == 0) {
        $chopping = 2;
        $search_type = 'GEQ';
    } elsif (index($munged_value, '<=') == 0 || index($munged_value, '=<') == 0) {
        $chopping = 2;
        $search_type = 'LEQ';
    } elsif (index($munged_value, '>') == 0) {
        $chopping = 1;
        $search_type = 'LEQ';
        $ifmatch = 'NEGATIVE';
    } elsif (index($munged_value, '<') == 0) {
        $chopping = 1;
        $search_type = 'GEQ';
        $ifmatch = 'NEGATIVE';
    } elsif (index($munged_value, '!=') == 0 || index($munged_value, '/=') == 0) {
        $chopping = 2;
        $ifmatch = 'NEGATIVE';
    }

    $munged_value = substr($munged_value, $chopping) if $chopping;

    $always = {
               ifmatch     => $ifmatch,
               search_type => $search_type,
               value       => $munged_value,
              };

    return ($always, $optional);
}

my $ea_data = {
    'validator' => {
                    'extattrs' => \&Infoblox::Grid::ExtensibleAttributeDef::validate_extattr_format,
                    'grid_extattrs' => \&Infoblox::Grid::ExtensibleAttributeDef::validate_extattr_format,
                    'extensible_attributes' => \&Infoblox::Grid::ExtensibleAttributeDef::validate_extensible_attributes_attr_format,
                    'grid_extensible_attributes' => \&Infoblox::Grid::ExtensibleAttributeDef::validate_extensible_attributes_attr_format,
                   },
    'relation'  => {
                    'extattrs' => 'extensible_attributes',
                    'grid_extattrs' => 'grid_extensible_attributes',
                    'extensible_attributes' => 'extattrs',
                    'grid_extensible_attributes' => 'grid_extattrs',
                   },
};

sub extensible_attributes_accessor_helper
{
    my ($member, $readonly, $self, @data) = @_;

    my %params = ();
    $params{'validator'} = $ea_data->{'validator'}->{$member};
    $params{'readonly'} = 1 if $readonly;

    my $res = $self->__accessor_scalar__({'name' => $member, %params}, @data);

    if (@_ and $res) {
        if (ref($self->{$member}) eq 'HASH') {
            $self->{$ea_data->{'relation'}->{$member}} = {};
            my $extattrs = ($member eq 'extattrs' or $member eq 'grid_extattrs') ? 1 : 0;
            foreach (keys(%{$self->{$member}})) {
                my $value = $extattrs ? $self->{$member}->{$_}->value() : Infoblox::Grid::Extattr->new('value' => $self->{$member}->{$_});
                $self->{$ea_data->{'relation'}->{$member}}->{$_} = $value;
            }
        } else {
            $self->{$ea_data->{'relation'}->{$member}} = undef;
        }
    }

    return $res;
}

sub return_fields_network_partial
{
    return {
             'sub_fields' => [
                tField('address'),
                tField('cidr'),
                tField('network_view', {'sub_fields' => [tField('name')]}),
             ],
           };
}

sub return_fields_option_logic_filters {

    return {
            sub_fields => [
                tField('filter', {
                        sub_fields => [tField('name')]
                })
            ],
    }
}

#
#
sub array_contains
{
    my ($value, $ref_array) = @_;

    for my $array_value (@$ref_array) {
        return 1 if $array_value eq $value;
    }

    return 0;
}

sub ibap_i2o_dhcp_ddns
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($$ibap_object_ref{$current}) {
        my @data;
        foreach my $item (@{$$ibap_object_ref{$current}}) {
            my $obj = Infoblox::DHCP::DDNS->__new__();
            $obj->__ibap_to_object__($item, $session->get_ibap_server(), $session, $return_object_cache_ref);
            push @data, $obj;
        }
        return \@data;
    } else {
        return [];
    }
}

sub ibap_value_o2i_oid
{
    my ($value, $field, $session, $validateonly) = @_;

    if (defined $value) {
        if (ref($value) and $value->__object_id__()) {
            return 1 if $validateonly;
            return tObjIdRef($value->__object_id__());
        } else {
            set_error_codes(1012, "The ".ref($value)." must be retrieved from the appliance before using it".($field ? " in $field" : ''), $session);
        }
    }

    return undef;
}

sub ibap_value_o2i_network_helper
{
    my ($network, $field, $session, $validateonly, $nview) = @_;

    if (defined $network) {
        if (ref($network) eq 'Infoblox::DHCP::Network' or ref($network) eq 'Infoblox::DHCP::IPv6Network') {
            if ($network->__object_id__()) {
                return 1 if $validateonly;
                return tObjIdRef($network->__object_id__());
            }

            $network = $network->network();
            $nview = $network->network_view()->name() if $network->network_view();
        } elsif (ref($network)) {
            return set_error_codes(1104, 'Invalid data type '.ref($network).' for member '.$field, $session);
        }

        my ($ok, $addr, $cidr) = ip_address_munger($network, 'cidr', undef, 1, $session);

        return unless $ok;
        return 1 if $validateonly;

        my @fields = (
                      {
                       'search_type' => 'EXACT',
                       'field' => 'address',
                       'value' => ibap_value_o2i_ipaddr($addr),
                      },
                      {
                       'search_type' => 'EXACT',
                       'field' => 'cidr',
                       'value' => ibap_value_o2i_int($cidr),
                      }
                     );

        if (defined $nview) {
            push @fields,
                 {
                  'search_type' => 'EXACT',
                  'field' => 'network_view',
                  'value' => ibap_readfield_simple_string('NetworkView','name', ref($nview) ? $nview->name() : $nview, 'network_view'),
                 };
        } else {
            push @fields,
                 {
                  'field' => 'network_view',
                  'value' => ibap_readfield_simple('NetworkView', 'is_default', tBool(1), 'network_view=(default network view)'),
                 };
        }

        return tIBType('BaseObject', ibap_readfieldlist_simple($ok == 1 ? 'Network' : 'IPv6Network', \@fields, undef, 'EXACT', 'readfield_substitution'));
    }
}

sub ibap_value_o2i_discovery_interfaces
{
    my ($value, $field, $session, $validateonly, $type) = @_;

    if (defined $value) {
        if (not $type and ref($value) eq 'ARRAY') {
            unless (check_vector_type($value, ['Infoblox::Grid::Discovery::DeviceInterface'])) {
                set_error_codes(1104, 'Invalid data type for member '.$field, $session);
                return;
            }

            my @interfaces;

            foreach my $item (@$value) {
               if ($item->__object_id__()) {
                    push @interfaces, tObjIdRef($item->__object_id__()) unless $validateonly;
                } else {
                    set_error_codes(1012, 'The '.ref($item)." object must be retrieved from the appliance before setting it", $session);
                    return;
                }
            }

            return 1 if $validateonly;
            return tIBType('ArrayOfBaseObject', \@interfaces);
        } elsif ($type eq 'single' and ref($value) eq 'Infoblox::Grid::Discovery::DeviceInterface') {
            return ibap_value_o2i_oid(@_);
        } else {
            set_error_codes(1104, 'Invalid data type'.ref($value).' for member '.$field, $session);
            return;
        }
    }
}

sub ibap_o2i_ms_adsites_domain
{
    my ($self, $session, $current, $tempref, $type) = @_;
    my $domain = $$tempref{$current};

    if (defined $domain and ref($domain) eq 'Infoblox::Grid::MSServer::AdSites::Domain') {

        my $netbios = $domain->netbios();
        my $name = $domain->name();

        unless (defined $netbios and defined $name) {
            set_error_codes(1012, "the domain passed should have both netbios and name attributes", $session);
            return (0);
        }

        my @domain_fields = (
            {
                'search_type' => 'EXACT',
                'field'       => 'netbios_name',
                'value'       => ibap_value_o2i_string($netbios),
            },
            {
                'search_type' => 'EXACT',
                'field'       => 'dns_name',
                'value'       => ibap_value_o2i_string($name),
            },
        );

        my $nview = $domain->network_view();
        if (defined $nview) {

            push @domain_fields,
                {
                    'search_type' => 'EXACT',
                    'field'       => 'network_view',
                    'value'       => ibap_readfield_simple_string('NetworkView','name', $nview, 'network_view'),
                };

        } else {

            push @domain_fields,
                {
                    'field' => 'network_view',
                    'value' => ibap_readfield_simple('NetworkView', 'is_default', tBool(1), 'network_view=(default network view)'),
                };
        }

        return (1, 0, tIBType('BaseObject',
                ibap_readfieldlist_simple('MsAdSitesDomain', \@domain_fields, undef, 'EXACT', 'readfield_substitution')));

    } else {

        return (1, 0, undef);
    }
}

sub ibap_o2i_zone_by_fqdn_and_view_name
{
    my ($self, $session, $current, $tempref, $type) = @_;

    my @fields;
    my $tview = ' ';
    if ($$tempref{'view'}) {
        @fields = (
                   {
                    'field' => 'fqdn',
                    'value' => ibap_value_o2i_string($$tempref{$current}),
                   },
                   {
                    'field' => 'view',
                    'value' => ibap_readfield_simple_string('View','name',$$tempref{'view'},'view'),
                   },
                  );

        $tview .= $$tempref{'view'};
    } else {
        @fields = (
                   {
                    'field' => 'fqdn',
                    'value' => ibap_value_o2i_string($$tempref{$current}),
                   },
                   {
                    'field' => 'view',
                    'value' => ibap_readfield_simple('View','is_default', tBool(1),'view=(default view)'),
                   },
                  );

        $tview .= '(default view)';
    }

    return (1,0, ibap_readfield_simple('AllZone',\@fields,undef,'zone='. $$tempref{$current} . $tview));

}

sub ibap_i2o_zone_and_view_by_name
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    $self->view($$ibap_object_ref{$current}{'view_name'});
    return $$ibap_object_ref{$current}{'fqdn'};
}


sub ibap_o2i_delegated_member {

    my ($self, $session, $current, $tempref, $type) = @_;

    if($tempref->{$current}) {
        return (1, 0, ibap_value_o2i_member($$tempref{$current}, $session, $self, $current, 1));
    } else {
        return (1, 0, undef);
    }
}

sub ibap_o2i_cert_data_ref
{
    my ($self, $session, $current, $tempref) = @_;

    return (1, 1, 0) unless $$tempref{$current};

    my %substruct = ();
    $substruct{'data_mode'} = ibap_value_o2i_string('DATA_INLINE');

    if (-e $$tempref{$current}) {
      if (open(my $fcert, '<'.$$tempref{$current})) {
        $substruct{'data'} = ibap_value_o2i_string(join("", <$fcert>));
        close($fcert)
      } else {
        set_error_codes(1001, "Cannot open certificate file " . $$tempref{$current} . ": $!", $session);
        return (0);
      }
    } else {
      set_error_codes(1001, "Certificate file " . $$tempref{$current} . " not found", $session);
      return (0);
    }

    return (1, 0, tIBType('data_ref', \%substruct));
}

sub ibap_i2o_string_to_enum_array {

    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    unless ($$ibap_object_ref{$current}) {
        return undef;
    } else {
        return [split / /, $$ibap_object_ref{$current}];
    }
}

sub ibap_o2i_enum_array_to_string {

    my ($self, $session, $current, $tempref) = @_;

    unless ($$tempref{$current} and @{$$tempref{$current}}) {
        return (1, 0, tString(''));
    } else {
        return (1, 0, tString(join ' ', @{$$tempref{$current}}));
    }
}

sub __audit_log_event_fmtval
{
    my $val = shift;
    my $ret = '';

    #

    if (exists $val->{str}) {
        #
        ($ret = $val->{str}) =~ s/([\\\"])/"\\" . $1/eg;
         $ret = '"'.$ret.'"';
    } elsif (exists $val->{bool}) {
        $ret = $val->{bool} ? "True" : "False";
    } elsif (exists $val->{int}) {
        $ret = $val->{int};
    } elsif (exists $val->{objtype}) {
        $ret = $val->{objtype}.':'.$val->{objname};
    } elsif (exists $val->{datetime}) {
        $ret = $val->{datetime}; # XXX Conversion to string needed here?
    } elsif (exists $val->{list}) {
        $ret = '[' . join(',', map { __audit_log_event_fmtval($_); } @{$val->{list}}) . ']';
    } elsif (exists $val->{struct}) {
        #
        $ret = '[' . join(',', map { __audit_log_event_fmtval($_); } @{$val->{struct}}) . ']';
    } else {
        $ret = "NULL";
    }

    #
    if (exists $val->{name}) {
        $ret = $val->{name} . '=' . $ret;
    }

    return $ret;
}

sub ibap_i2o_audit_log_event
{
    my ($self, $session, $key, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @arr = ();
    for my $logevent (@{$ibap_object_ref->{$key}}) {
        $logevent->{name} =~ s/MGMSubGrid/Grid/i if defined $logevent->{name}; # NIOS-38030: 'MGMSubGrid' is internal value. It should be presented as 'Grid'.
        my $event = $logevent->{event};
        my $attrs = join ' ', map {
            $_->{name}.'='.$_->{value}
        } @{$logevent->{attributes}};
        $attrs .= ':'
            if (exists $logevent->{values} && @{$logevent->{values}});

        my %actions = (
            'CREATED'=>'Set',
            'MODIFIED'=>'Changed',
        );

        my $converted_action;
        if ($actions{$event}) {
            $converted_action = $actions{$event};
        }
        else {
            $converted_action = ucfirst(lc($event));
        }

        my $values = $converted_action.' '.join ',', map {
            my $from = $_->{from};
            my $to = __audit_log_event_fmtval($_->{to});
            if ($from) {
                $_->{name}.':"'. __audit_log_event_fmtval($from) .'"->'.$to;
            } else {
                $_->{name}.'='.$to;
            }
        } @{$logevent->{values}};
        push @arr, join ' ', (
            $logevent->{type},
            $logevent->{name},
            $attrs,
            $values
        );
    }
    return \@arr;
}

sub source_interface_return_fields {
    return {
        sub_fields => [
            tField('type'),
            tField('additional_ip', {
                sub_fields => [
                    tField('ipv4_network_setting', {sub_fields => [tField('address')]}),
                    tField('ipv6_network_setting', {sub_fields => [tField('virtual_ip')]})
                ]
            }),
        ]
    };
}

sub ibap_i2o_source_interface {

    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($$ibap_object_ref{$current}) {
        if ($$ibap_object_ref{$current}{'type'} eq "IP") {
            if (defined $$ibap_object_ref{$current}{'additional_ip'}{'ipv4_network_setting'}) {
                return $$ibap_object_ref{$current}{'additional_ip'}{'ipv4_network_setting'}{'address'};
            } else {
                return $$ibap_object_ref{$current}{'additional_ip'}{'ipv6_network_setting'}{'virtual_ip'};
            }
        }
        else {
            if ($$ibap_object_ref{$current}{'type'} eq 'ANY') {
                return 'Any';
            }
            else {
                return uc($$ibap_object_ref{$current}{'type'});
            }
        }
    } else {
        return undef;
    }
}

sub ibap_o2i_source_interface {

    my ($self, $session, $current, $tempref) = @_;
    my %struct;

    my $ip_addr = is_ipv4_address($$tempref{$current}) ? 1 :
                  is_ipv6_address($$tempref{$current}) ? 2 : 0;

    if ($ip_addr) {

        my @additional_ip = (
            {
                field       => 'parent',
                search_type => 'EXACT',
                value       => ibap_readfield_simple_string('Member', 'host_name', $tempref->{'name'}),
            },
            {
                field       => 'type',
                search_type => 'EXACT',
                value       => ibap_value_o2i_string('LOOPBACK'),
            },
        );

        if ($ip_addr == 1) {

            push @additional_ip, {
                field       => 'ipv4_network_setting',
                search_type => 'EXACT',
                value       => tIBType('SubMatch', {
                    search_fields => [{
                        field => 'address',
                        value => ibap_value_o2i_string($$tempref{$current})
                    }],
                }),
            };

        } else {

            push @additional_ip, {
                field       => 'ipv6_network_setting',
                search_type => 'EXACT',
                value       => tIBType('SubMatch', {
                    search_fields => [{
                        field => 'virtual_ip',
                        value => ibap_value_o2i_string($$tempref{$current})
                    }]
                }),
            };
        }

        $struct{type} = ibap_value_o2i_string('IP');
        $struct{additional_ip} = ibap_readfield_simple('MemberAdditionalIp', \@additional_ip);

    } else {
        $struct{'type'} = ibap_value_o2i_string(uc($$tempref{$current}));
    }

    return (1, 0, tIBType('dnssourceaddress',\%struct));
}


1;
