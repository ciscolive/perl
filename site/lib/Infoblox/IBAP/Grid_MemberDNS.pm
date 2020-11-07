package Infoblox::Grid::Member::DNS;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

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
            @_sub_host_address_fields
            %_capabilities
            $_return_fields_initialized
            @_dns_health_check_members
            @_nxdomain_redirect_members
            @_ftc_members
);

@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'MemberDns';
    register_wsdl_type('ib:MemberDns','Infoblox::Grid::Member::DNS');

	%_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 0,
					 );

    @_dns_health_check_members = (
        'dns_health_check_domain_list',
        'dns_health_check_recursion_flag',
        'dns_health_check_anycast_control',
        'enable_dns_health_check',
        'dns_health_check_interval',
        'dns_health_check_retries',
        'dns_health_check_timeout',
    );

    @_nxdomain_redirect_members = (
        'nxdomain_redirect',
        'nxdomain_redirect_addresses',
        'nxdomain_redirect_addresses_ipv6'
    );

    @_ftc_members = (
        'enable_ftc',
        'ftc_expired_record_ttl',
        'ftc_expired_record_timeout',
    );

    %_allowed_members=(
        'additional_ip_list'                => 0,
        'allow_gss_tsig_zone_updates'       => 0,
        'allow_query'                       => 0,
        'allow_recursive_query'             => 0,
        'allow_transfer'                    => 0,
        'allow_update'                      => 0,
        'auto_create_a_and_ptr_for_lan2'    => 0,
        'auto_create_aaaa_and_ipv6ptr_for_lan2' => 0,
        'auto_sort_views'                   => 0,
        'bind_check_names_policy'           => 0,
        'blackhole_list'                    => 0,
        'blacklist_action'                  => 0,
        'blacklist_log_query'               => 0,
        'blacklist_redirect_addresses'      => 0,
        'blacklist_redirect_ttl'            => 0,
        'blacklist_rulesets'                => 0,
        'custom_root_name_servers'          => 0,
        'dns64_groups'                      => 0,

        'dns_notify_transfer_source_interface' => 0,
        'dns_query_source_interface'           => 0,
        'dtc_health_source_interface'         => 0,

        'dns_cache_acceleration_status'     => -1,
        'dns_cache_acceleration_ttl'        => 0,
        'dnssec_enabled'                    => 0,
        'dnssec_expired_signatures_enabled' => 0,
        'dnssec_trusted_keys'               => 0,
        'dnssec_validation_enabled'         => 0,
        'dnssec_negative_trust_anchors'     => 0,
        'enable_blackhole'                  => 0,
        'enable_blacklist'                  => 0,
        'enable_dns'                        => 0,
        'enable_dns64'                      => 0,
        'enable_dns_cache_acceleration'     => 0,
        'enable_gss_tsig'                   => 0,
        'override_enable_gss_tsig'          => 0,
        'extattrs'                          => -1,
        'extensible_attributes'             => -1,
        'facility'                          => 0,
        'filter_aaaa'                       => 0,
        'filter_aaaa_list'                  => 0,
        'forward_only'                      => 0,
        'forward_updates'                   => 0,
        'forwarders'                        => 0,
        'gss_tsig_principal_name'           => -1,
        'gss_tsig_version_number'           => -1,
        'gss_tsig_keys'                     => 0,
        'override_gss_tsig_keys'            => 0,
        'host_name_restriction_policy'      => 0,
        'logging_categories'                => 0,
        'minimal_resp'                      => 0,
        'name'                              => 1,
        'notify_delay'                      => 0,
        'notify_source_port'                => 0,
        'nxdomain_log_query'                => 0,
        'override_nxdomain_redirect'        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'nxdomain_redirect'                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_nxdomain_redirect', use_truefalse => 1, use_members => \@_nxdomain_redirect_members},
        'nxdomain_redirect_addresses'       => {array => 1, simple => 'asis', validator => \&ibap_value_o2i_ipv4addr, use => 'override_nxdomain_redirect', use_truefalse => 1, use_members => \@_nxdomain_redirect_members},
        'nxdomain_redirect_addresses_ipv6'  => {array => 1, simple => 'asis', validator => \&ibap_value_o2i_ipv6addr, use => 'override_nxdomain_redirect', use_truefalse => 1, use_members => \@_nxdomain_redirect_members},
        'nxdomain_redirect_ttl'             => 0,
        'nxdomain_rulesets'                 => 0,
        'override_forwarders'               => 0,
        'override_dns_cache_acceleration_ttl' => 0,
        'override_blacklist'                => 0,
        'override_dns64'                    => 0,
        'override_dnssec'                   => 0,
        'override_filter_aaaa'              => 0,
        'query_source_port'                 => 0,
        'recursive_client_limit'            => 0,
        'recursive_query_list'              => 0,
        'sortlist'                          => 0,
        'transfer_excluded_servers'         => 0,
        'transfer_format'                   => 0,
        'use_lan_ipv6_port'                 => 0,
        'use_lan_port'                      => 0,
        'use_lan2_port'                     => 0,
        'use_lan2_ipv6_port'                => 0,
        'use_mgmt_port'                     => 0,
        'use_mgmt_ipv6_port'                => 0,
        'use_root_name_servers'             => 0,
        'views'                             => 0,
        'lame_ttl'                          => 0,
        'override_lame_ttl'                 => 0,
        'copy_xfer_to_notify'               => 0,
        'override_copy_xfer_to_notify'      => 0,
        'transfers_in'                      => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_transfers_in', use_truefalse => 1},
        'transfers_out'                     => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_transfers_out', use_truefalse => 1},
        'transfers_per_ns'                  => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_transfers_per_ns', use_truefalse => 1},
        'serial_query_rate'                 => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_serial_query_rate', use_truefalse => 1},
        'max_cache_ttl'                     => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_max_cache_ttl', use_truefalse => 1},
        'override_transfers_in'             => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'override_transfers_out'            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'override_transfers_per_ns'         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'override_serial_query_rate'        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'override_max_cache_ttl'            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'max_cached_lifetime'               => 0,
        'override_max_cached_lifetime'      => 0,
        'max_ncache_ttl'                    => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_max_ncache_ttl', use_truefalse => 1},
        'override_max_ncache_ttl'           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'disable_edns'                      => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_disable_edns', use_truefalse => 1},
        'override_disable_edns'             => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'enable_query_rewrite'              => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_query_rewrite', use_truefalse => 1},
        'override_query_rewrite'            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dnssec_blacklist_enabled'          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dnssec_dns64_enabled'              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dnssec_nxdomain_enabled'           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dnssec_rpz_enabled'                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'override_rpz_disable_nsdname_nsip' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'rpz_disable_nsdname_nsip'          => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                use => 'override_rpz_disable_nsdname_nsip', use_truefalse => 1},

        'fixed_rrset_order_fqdns'          => {validator => {'Infoblox::Grid::DNS::FixedRRSetOrderFQDN' => 1},
                                               array => 1, skip_accessor => 1},
        'enable_fixed_rrset_order_fqdns'   => 0,
        'override_fixed_rrset_order_fqdns' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'rpz_disable_nsdname_nsip'          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_rpz_disable_nsdname_nsip', use_truefalse => 1},
        'override_rpz_qname_wait_recurse' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'rpz_qname_wait_recurse'          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_rpz_qname_wait_recurse', use_truefalse => 1},

        'auto_blackhole'                  => {validator => {'Infoblox::Grid::DNS::AutoBlackHole' => 1},
                                              use => 'override_auto_blackhole', use_truefalse => 1},
        'attack_mitigation'               => {validator => {'Infoblox::Grid::DNS::AttackMitigation' => 1},
                                              use => 'override_attack_mitigation', use_truefalse => 1},
        'response_rate_limiting'          => {validator => {'Infoblox::Grid::DNS::ResponseRateLimiting' => 1},
                                              use => 'override_response_rate_limiting', use_truefalse => 1},
        'resolver_query_timeout'          => {simple => 'asis', validator => \&ibap_value_o2i_uint,
                                              use => 'override_resolver_query_timeout', use_truefalse => 1},

        'override_auto_blackhole'         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'override_attack_mitigation'      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'override_response_rate_limiting' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'override_resolver_query_timeout' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},

        'recursive_resolver'                => {simple => 'asis', enum => ['BIND', 'UNBOUND']},
        'unbound_logging_level'             => {simple => 'asis', enum => ['ERRORS_ONLY', 'OPERATIONS', 'DETAILED_OPERATIONS',
                                                'QUERY', 'ALGORITHM', 'CACHE_MISSES']},
        'is_unbound_capable'                => {simple => 'bool', readonly => 1, validator => \&ibap_value_o2i_boolean},
        'bind_hostname_directive'           => {simple => 'asis', enum => ['NONE', 'HOSTNAME', 'USER_DEFINED'],
                                                use => 'override_bind_hostname_directive', use_truefalse => 1},
        'server_id_directive'          => {simple => 'asis', enum => ['NONE', 'HOSTNAME', 'USER_DEFINED'],
                                                use => 'override_server_id_directive', use_truefalse => 1},
        'override_bind_hostname_directive'  => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'override_server_id_directive' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'bind_hostname_directive_fqdn'      => {simple => 'asis', validator => \&ibap_value_o2i_string},
        'server_id_directive_string'   => {simple => 'asis', validator => \&ibap_value_o2i_string},

        'override_rpz_drop_ip_rule'               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'rpz_drop_ip_rule_enabled'                => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                      use => 'override_rpz_drop_ip_rule', use_truefalse => 1,
                                                      use_members => [
                                                                      'rpz_drop_ip_rule_min_prefix_length_ipv4',
                                                                      'rpz_drop_ip_rule_min_prefix_length_ipv6',
                                                                      'rpz_drop_ip_rule_enabled',
                                                      ]},
        'rpz_drop_ip_rule_min_prefix_length_ipv4' => {simple => 'asis', validator => \&ibap_value_o2i_uint,
                                                      use => 'override_rpz_drop_ip_rule', use_truefalse => 1,
                                                      use_members => [
                                                                      'rpz_drop_ip_rule_min_prefix_length_ipv4',
                                                                      'rpz_drop_ip_rule_min_prefix_length_ipv6',
                                                                      'rpz_drop_ip_rule_enabled',
                                                      ]},
        'rpz_drop_ip_rule_min_prefix_length_ipv6' => {simple => 'asis', validator => \&ibap_value_o2i_uint,
                                                      use => 'override_rpz_drop_ip_rule', use_truefalse => 1,
                                                      use_members => [
                                                                      'rpz_drop_ip_rule_min_prefix_length_ipv4',
                                                                      'rpz_drop_ip_rule_min_prefix_length_ipv6',
                                                                      'rpz_drop_ip_rule_enabled',
                                                      ]},

        'enable_capture_dns_queries'                  => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                          use => 'override_enable_capture_dns', use_truefalse => 1,
                                                          use_members => ['enable_capture_dns_responses']},
        'enable_capture_dns_responses'                => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                          use => 'override_enable_capture_dns', use_truefalse => 1,
                                                          use_members => ['enable_capture_dns_queries']},
        'override_enable_capture_dns'                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'capture_dns_queries_on_all_domains'          => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                          use => 'override_capture_dns_queries_on_all_domains', use_truefalse => 1},
        'override_capture_dns_queries_on_all_domains' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'domains_to_capture_dns_queries'              => {array => 1, validator => \&ibap_value_o2i_string},
        'file_transfer_setting'                       => {validator => {'Infoblox::Grid::DNS::FileTransferSetting' => 1}},
        'excluded_domain_names'                       => {array => 1, validator => \&ibap_value_o2i_string},
        'enable_excluded_domain_names'                => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                          use => 'override_enable_excluded_domain_names', use_truefalse => 1},
        'override_enable_excluded_domain_names'       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'anonymize_response_logging'                  => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'store_locally'                               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dns_query_capture_file_time_limit'           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'dtc_edns_prefer_client_subnet'               => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                          use => 'override_dtc_edns_prefer_client_subnet', use_truefalse => 1},
        'override_dtc_edns_prefer_client_subnet'      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dns_health_check_domain_list'                => {array => 1, simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_dns_health_check', use_truefalse => 1, use_members => \@_dns_health_check_members},
        'dns_health_check_recursion_flag'             => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_dns_health_check', use_truefalse => 1, use_members => \@_dns_health_check_members},
        'dns_health_check_anycast_control'            => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_dns_health_check', use_truefalse => 1, use_members => \@_dns_health_check_members},
        'enable_dns_health_check'                     => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_dns_health_check', use_truefalse => 1, use_members => \@_dns_health_check_members},
        'dns_health_check_interval'                   => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_dns_health_check', use_truefalse => 1, use_members => \@_dns_health_check_members},
        'dns_health_check_retries'                    => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_dns_health_check', use_truefalse => 1, use_members => \@_dns_health_check_members},
        'dns_health_check_timeout'                    => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_dns_health_check', use_truefalse => 1, use_members => \@_dns_health_check_members},
        'override_dns_health_check'                   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'glue_record_addresses'                       => {array => 1, validator => {'Infoblox::DNS::GlueRecordAddr' => 1}},
        'ipv6_glue_record_addresses'                  => {array => 1, validator => {'Infoblox::DNS::GlueRecordAddr' => 1}},
        'skip_in_grid_rpz_queries'                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dns_view_address_settings'                   => {array => 1, validator => {'Infoblox::Grid::Member::DNS::ViewAddressSetting' => 1}},
        'override_ftc'                                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'enable_ftc'                                  => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_ftc', use_truefalse => 1, use_members => \@_ftc_members},
        'ftc_expired_record_ttl'                      => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_ftc', use_truefalse => 1, use_members => \@_ftc_members},
        'ftc_expired_record_timeout'                  => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_ftc', use_truefalse => 1, use_members => \@_ftc_members},
                      );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings=(
        'name'                    => 'parent',
        'additional_ip_list'      => 'member_dns_ips',
        'auto_create_a_and_ptr_for_lan2' => 'auto_create_lan2_glue',
        'auto_create_aaaa_and_ipv6ptr_for_lan2' => 'v6_auto_create_lan2_glue',
        'allow_recursive_query'   => 'recursion_enabled',
        'blackhole_list'          => 'blackhole',
        'custom_root_name_servers' => 'root_name_servers',
		'dnssec_enabled'          => 'dnssec',
        'dns_cache_acceleration_ttl' => 'dns_cache_ttl',

        'dns_notify_transfer_source_interface' => 'notify_xfr_source',
        'dns_query_source_interface'           => 'query_source',
        'dtc_health_source_interface'         => 'idns_health_source',

        'enable_dns'              => 'enable_service',
        'override_enable_gss_tsig' => 'use_enable_gss_tsig',
        'override_gss_tsig_keys'  => 'use_gss_tsig_keys',
        'facility'                => 'syslog_facility',
        'forward_only'            => 'forwarders_only',
        'forward_updates'         => 'allow_update_forwarding',
        'forwarders'              => 'allow_forwarder',
        'glue_record_addresses'     => 'member_view_nats',
        'ipv6_glue_record_addresses' => 'v6_member_view_nats',
        'host_name_restriction_policy' => 'administrative_record_name_policies',
        'minimal_resp'            => 'minimal_response',
        'nxdomain_redirect'         => 'enable_nxdomain_redirect',
		'override_dnssec'         => 'use_dnssec',
        'override_dns64'          => 'use_dns64',
        'override_forwarders'     => 'use_forwarder_setting',
        'override_dns_cache_acceleration_ttl' => 'use_dns_cache_ttl',
        'override_blacklist'      => 'use_blacklist',
        'recursive_client_limit'  => 'concurrent_recursive_clients',
        'recursive_query_list'    =>  'allow_recursive_query',
        'sortlist'                => 'sort_lists',
        'transfer_excluded_servers' => 'excluded_servers',
        'transfer_format'         => 'zone_transfer_format_option',
        'use_lan_ipv6_port'       => 'dns_over_v6_lan',
        'use_lan_port'            => 'dns_over_lan',
        'use_lan2_port'           => 'dns_over_lan2',
        'use_lan2_ipv6_port'      => 'dns_over_v6_lan2',
        'use_mgmt_port'           => 'dns_over_mgmt',
        'use_mgmt_ipv6_port'      => 'dns_over_v6_mgmt',
        'use_root_name_servers'   => 'enable_custom_root_server',
        'views'                   => 'member_views',
        'override_nxdomain_redirect' => 'use_nxdomain_redirect',
        'override_filter_aaaa'    => 'use_filter_aaaa',
        'override_lame_ttl'       => 'use_lame_ttl',
        'override_copy_xfer_to_notify' => 'use_copy_xfer_to_notify',
        'override_transfers_in'      => 'use_transfers_in',
        'override_transfers_out'     => 'use_transfers_out',
        'override_transfers_per_ns'  => 'use_transfers_per_ns',
        'override_serial_query_rate' => 'use_serial_query_rate',
        'override_max_cached_lifetime' => 'use_max_cached_lifetime',
        'override_max_cache_ttl'       => 'use_max_cache_ttl',
        'override_max_ncache_ttl'      => 'use_max_ncache_ttl',
        'extattrs'                     => 'extensible_attributes',
        'override_disable_edns'        => 'use_disable_edns',
        'enable_query_rewrite'         => 'query_rewrite_enabled',
        'override_query_rewrite'       => 'use_query_rewrite',
        'override_rpz_disable_nsdname_nsip' => 'use_rpz_disable_nsdname_nsip',

        #
        'enable_fixed_rrset_order_fqdns'    => 'fixed_rrset_order_fqdns_enabled',
        'override_fixed_rrset_order_fqdns'  => 'use_fixed_rrset_order_fqdns',

        'override_rpz_qname_wait_recurse'   => 'use_rpz_qname_wait_recurse',

        'override_auto_blackhole'         => 'use_auto_blackhole',
        'override_attack_mitigation'      => 'use_attack_mitigation',
        'override_response_rate_limiting' => 'use_response_rate_limiting',
        'override_resolver_query_timeout' => 'use_resolver_query_timeout',

        'recursive_resolver'                => 'dns_resolver_type',
        'override_bind_hostname_directive'  => 'use_bind_hostname_directive',
        'override_server_id_directive' => 'use_server_id_directive',
        'override_rpz_drop_ip_rule' => 'use_rpz_drop_ip_rule',

        'file_transfer_setting'                       => 'transfer_settings',
        'override_enable_capture_dns'                 => 'use_enable_capture_dns',
        'override_capture_dns_queries_on_all_domains' => 'use_capture_dns_queries_on_all_domains',
        'override_enable_excluded_domain_names'       => 'use_enable_excluded_domain_names',
        'dtc_edns_prefer_client_subnet'               => 'dtc_prefer_client_subnet',
        'override_dtc_edns_prefer_client_subnet'      => 'use_dtc_prefer_client_subnet',

        'override_dns_health_check'                   => 'use_dns_health_check',
        'enable_dns_health_check'                    => 'dns_health_check_enabled',
        'dns_view_address_settings' => 'member_views_address_settings',
        'nxdomain_redirect_addresses_ipv6' => 'nxdomain_redirect_addresses_v6',
        'enable_ftc'                 => 'enable_smartcache',
        'override_ftc'               => 'use_smartcache',
        'ftc_expired_record_ttl'     => 'smartcache_expired_record_ttl',
        'ftc_expired_record_timeout' => 'smartcache_expired_record_timeout',
                      );

	%_reverse_name_mappings= reverse %_name_mappings;

    $_name_mappings{'dnssec_validation_enabled'}='dnssec';
    $_name_mappings{'dnssec_expired_signatures_enabled'}='dnssec';
    $_name_mappings{'dnssec_blacklist_enabled'}='dnssec';
    $_name_mappings{'dnssec_dns64_enabled'}='dnssec';
    $_name_mappings{'dnssec_nxdomain_enabled'}='dnssec';
    $_name_mappings{'dnssec_rpz_enabled'}='dnssec';

    $_return_fields_initialized=0;
    @_return_fields=(
                     tField('allow_forwarder'),
                     tField('allow_gss_tsig_zone_updates'),
                     tField('allow_update_forwarding'),
                     tField('auto_create_lan2_glue'),
                     tField('v6_auto_create_lan2_glue'),
                     tField('auto_sort_views'),
                     tField('blacklist_action'),
                     tField('blacklist_log_query'),
                     tField('blacklist_redirect_addresses'),
                     tField('blacklist_redirect_ttl'),
                     tField('blacklist_rulesets',
                         {
                             sub_fields => [ tField('name'),]
                         }
                     ),
                     tField('concurrent_recursive_clients'),
                     tField('dns_over_v6_lan'),
                     tField('dns_over_lan'),
                     tField('dns_over_lan2'),
                     tField('dns_over_v6_lan2'),
                     tField('dns_over_mgmt'),
                     tField('dns_over_v6_mgmt'),
                     tField('dnssec_negative_trust_anchors'),
                     tField('enable_dns64'),
                     tField('filter_aaaa'),
                     tField('notify_xfr_source', source_interface_return_fields()),
                     tField('query_source', source_interface_return_fields()),
                     tField('idns_health_source', source_interface_return_fields()),
                     tField('enable_blackhole'),
                     tField('enable_dns_cache_acceleration'),
                     tField('dns_cache_acceleration_status'),
                     tField('enable_blacklist'),
                     tField('enable_custom_root_server'),
                     tField('enable_nxdomain_redirect'),
                     tField('enable_service'),
                     tField('excluded_servers'),
                     tField('forwarders_only'),
                     tField('limit_concurrent_recursive_clients'),
                     tField('minimal_response'),
                     tField('notify_delay'),
                     tField('notify_source_port'),
                     tField('nxdomain_redirect_addresses'),
                     tField('nxdomain_redirect_addresses_v6'),
                     tField('enable_notify_source_port'),
                     tField('query_source_port'),
                     tField('enable_query_source_port'),
                     tField('recursion_enabled'),
                     tField('syslog_facility'),
                     tField('use_allow_query'),
                     tField('use_allow_update_forwarding'),
                     tField('use_blackhole'),
                     tField('use_dnssec'),
                     tField('use_dns64'),
                     tField('use_filter_aaaa'),
                     tField('use_dns_cache_ttl'),
                     tField('dns_cache_ttl'),
                     tField('use_forwarder_setting'),
                     tField('use_log_categories'),
                     tField('use_notify_delay'),
                     tField('use_nxdomain_redirect'),
                     tField('use_record_name_policy'),
                     tField('use_recursive_query_setting'),
                     tField('use_root_name_server_setting'),
                     tField('use_sort_lists'),
                     tField('use_source_ports'),
                     tField('use_syslog_facility'),
                     tField('use_blacklist'),
                     tField('use_update_setting'),
                     tField('use_zone_transfer_format'),
                     tField('use_zone_transfer_setting'),
                     tField('zone_transfer_format_option'),
                     tField('nxdomain_redirect_ttl'),
                     tField('nxdomain_log_query'),
                     tField('lame_ttl'),
                     tField('use_lame_ttl'),
                     tField('enable_gss_tsig'),
                     tField('use_enable_gss_tsig'),
                     tField('use_gss_tsig_keys'),
                     tField('logging_categories',
                            {
                             sub_fields => [
                                            tField('log_general'),
                                            tField('log_client'),
                                            tField('log_config'),
                                            tField('log_database'),
                                            tField('log_dnssec'),
                                            tField('log_lame_servers'),
                                            tField('log_network'),
                                            tField('log_notify'),
                                            tField('log_queries'),
                                            tField('log_resolver'),
                                            tField('log_security'),
                                            tField('log_update'),
                                            tField('log_xfer_in'),
                                            tField('log_xfer_out'),
                                            tField('log_update_security'),
                                            tField('log_rpz'),
                                            tField('log_responses'),
                                            tField('log_idns_gslb'),
                                            tField('log_idns_health'),
                                           ]
                            }
                           ),
                     return_fields_extensible_attributes(),
                     tField('sort_lists',
                            {
                             sub_fields =>
                             [
                              tField('sl_address'),
                              tField('sl_netmask'),
                              tField('address_matches'),
                              tField('comment'),
                              tField('querier_option'),
                             ],
                            }
                           ),
                     tField('root_name_servers',
                            {
                             sub_fields =>
                             [
                              tField('name'),
                              tField('address'),
                             ],
                            }
                           ),
                     tField('member_dns_ips',
                            {
                             sub_fields => [
                                            tField('ipv4_network_setting',
                                                   {
                                                    sub_fields => [tField('address')]
                                                   }
                                                  ),
                                            tField('ipv6_network_setting',
                                                   {
                                                    sub_fields => [tField('virtual_ip')]
                                                   }
                                                  ),
                                           ]
 							}
                           ),
                     tField('parent',return_fields_member_basic_data()),
                     tField('member_views',
                            {
                             sub_fields=>[tField('name')]
                            }
                           ),
                     tField('administrative_record_name_policies',
                            {
                             sub_fields => [
                                            tField('check_names_policy'),
                                            tField('check_names_for_ddns_and_zone_transfer'),
                                            tField('record_name_policy',
                                                   {
                                                    sub_fields =>
                                                    [
                                                     tField('policy_name')
                                                    ]
                                                   }
                                                  )
                                           ]
                            }
                           ),
                     tField('dnssec',
                            {
                             sub_fields =>
                             [
                              tField('enable_dnssec'),
                              tField('enable_dnssec_validation'),
                              tField('enable_dnssec_expired_signatures'),
                              tField('enable_dnssec_blacklist'),
                              tField('enable_dnssec_dns64'),
                              tField('enable_dnssec_nxdomain'),
                              tField('enable_dnssec_rpz'),
                             ]
                            }
                           ),
                     tField('dnssec_trusted_keys',
                            {
                             sub_fields=>
                             [
                              tField('fqdn'),
                              tField('secure_entry_point'),
                              tField('dnssec_algorithm'),
                              tField('trusted_key')
                             ]
                             }
                           ),
                     tField('nxdomain_rulesets',
                            {
                             sub_fields => [
                                            tField('name'),
                                           ]
                            }),
                     tField('copy_xfer_to_notify'),
                     tField('use_copy_xfer_to_notify'),
                     tField('transfers_in'),
                     tField('use_transfers_in'),
                     tField('transfers_out'),
                     tField('use_transfers_out'),
                     tField('transfers_per_ns'),
                     tField('use_transfers_per_ns'),
                     tField('serial_query_rate'),
                     tField('use_serial_query_rate'),
                     tField('max_cache_ttl'),
                     tField('use_max_cache_ttl'),
                     tField('max_cached_lifetime'),
                     tField('use_max_cached_lifetime'),
                     tField('max_ncache_ttl'),
                     tField('use_max_ncache_ttl'),
                     tField('disable_edns'),
                     tField('use_disable_edns'),
                     tField('query_rewrite_enabled'),
                     tField('use_query_rewrite'),
                     tField('use_rpz_disable_nsdname_nsip'),
                     tField('rpz_disable_nsdname_nsip'),
                     tField('fixed_rrset_order_fqdns_enabled'),
                     tField('use_fixed_rrset_order_fqdns'),
                     tField('use_rpz_qname_wait_recurse'),
                     tField('rpz_qname_wait_recurse'),
                     tField('use_auto_blackhole'),
                     tField('use_attack_mitigation'),
                     tField('use_response_rate_limiting'),
                     tField('use_resolver_query_timeout'),
                     tField('resolver_query_timeout'),

                     tField('dns_resolver_type'),
                     tField('unbound_logging_level'),
                     tField('is_unbound_capable'),
                     tField('use_bind_hostname_directive'),
                     tField('bind_hostname_directive'),
                     tField('bind_hostname_directive_fqdn'),
                     tField('use_server_id_directive'),
                     tField('server_id_directive'),
                     tField('server_id_directive_string'),
                     tField('use_rpz_drop_ip_rule'),
                     tField('rpz_drop_ip_rule_enabled'),
                     tField('rpz_drop_ip_rule_min_prefix_length_ipv4'),
                     tField('rpz_drop_ip_rule_min_prefix_length_ipv6'),

                     tField('enable_capture_dns_queries'),
                     tField('enable_capture_dns_responses'),
                     tField('use_enable_capture_dns'),
                     tField('capture_dns_queries_on_all_domains'),
                     tField('use_capture_dns_queries_on_all_domains'),
                     tField('domains_to_capture_dns_queries'),
                     tField('enable_excluded_domain_names'),
                     tField('use_enable_excluded_domain_names'),
                     tField('excluded_domain_names'),
                     tField('anonymize_response_logging'),
                     tField('store_locally'),
                     tField('dns_query_capture_file_time_limit'),
                     tField('dtc_prefer_client_subnet'),
                     tField('use_dtc_prefer_client_subnet'),
                     tField('dns_health_check_domain_list'),
                     tField('dns_health_check_recursion_flag'),
                     tField('dns_health_check_anycast_control'),
                     tField('dns_health_check_enabled'),
                     tField('dns_health_check_interval'),
                     tField('dns_health_check_retries'),
                     tField('dns_health_check_timeout'),
                     tField('use_dns_health_check'),
                     tField('skip_in_grid_rpz_queries'),
                     tField('enable_smartcache'),
                     tField('use_smartcache'),
                     tField('smartcache_expired_record_ttl'),
                     tField('smartcache_expired_record_timeout'),
                    );


	%_searchable_fields = (
		name => [\&ibap_o2i_member_name ,'parent', 'EXACT'],
        ipv4addr => [\&ibap_o2i_string,'address' , 'EXACT'],
        ipv6addr => [\&ibap_o2i_string,'ipv6_address' , 'EXACT'],
        extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
		extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                          );
    %_ibap_to_object=(
        administrative_record_name_policies => \&ibap_i2o_record_name_policies,
        allow_gss_tsig_zone_updates         => \&ibap_i2o_boolean,
        allow_query             => \&ibap_i2o_ac_setting,
        allow_recursive_query   => \&ibap_i2o_ac_setting,
        allow_transfer          => \&ibap_i2o_ac_setting,
        allow_update            => \&ibap_i2o_ac_setting,
        auto_create_lan2_glue   => \&ibap_i2o_boolean,
        v6_auto_create_lan2_glue=> \&ibap_i2o_boolean,
        auto_sort_views         => \&ibap_i2o_boolean,
        blackhole               => \&ibap_i2o_ac_setting,
        blacklist_log_query     => \&ibap_i2o_boolean,
        blacklist_rulesets      => \&ibap_i2o_rulesets_by_names,
        root_name_servers       => \&ibap_i2o_root_ns_list,

        notify_xfr_source       => \&ibap_i2o_source_interface,
        query_source            => \&ibap_i2o_source_interface,
        idns_health_source      => \&ibap_i2o_source_interface,

        enable_dns64            => \&ibap_i2o_boolean,
        use_dns64               => \&ibap_i2o_boolean,
        dns64_groups            => \&ibap_i2o_generic_object_list_convert,
        dns_cache_acceleration_status => \&ibap_i2o_enums_ucfirst_or_undef,
		dnssec                  => \&ibap_i2o_dnssec_props,
		dnssec_trusted_keys     => \&ibap_i2o_dnssec_trusted_keys,
        enable_blackhole        => \&ibap_i2o_boolean,
        enable_dns_cache_acceleration => \&ibap_i2o_boolean,
        enable_service          => \&ibap_i2o_boolean,
        enable_gss_tsig         => \&ibap_i2o_boolean,
        enable_blacklist        => \&ibap_i2o_boolean,
        enable_nxdomain_redirect => \&ibap_i2o_boolean,
        extensible_attributes   => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
        filter_aaaa_list        => \&ibap_i2o_ac_setting,
        gss_tsig_keys           => \&ibap_i2o_generic_object_list_convert,
        syslog_facility         => \&ibap_i2o_enums_lc_or_undef,
        forwarders_only         => \&ibap_i2o_boolean,
        allow_update_forwarding => \&ibap_i2o_boolean,
        logging_categories      => \&ibap_i2o_logging_categories,
        minimal_response        => \&ibap_i2o_boolean,
        member_view_nats        => \&ibap_i2o_generic_object_list_convert,
        v6_member_view_nats     => \&ibap_i2o_generic_object_list_convert,
        member_dns_ips          => \&__i2o_MemberAdditionalIp_list__,
        sort_lists              => \&ibap_i2o_sort_list,
        zone_transfer_format_option => \&ibap_i2o_transfer_format,
        dns_over_lan            => \&ibap_i2o_boolean,
        dns_over_lan2           => \&ibap_i2o_boolean,
        dns_over_v6_lan         => \&ibap_i2o_boolean,
        dns_over_v6_lan2        => \&ibap_i2o_boolean,
        dns_over_mgmt           => \&ibap_i2o_boolean,
        dns_over_v6_mgmt        => \&ibap_i2o_boolean,
        member_views            => \&__i2o_views_by_names__,
		parent                  => \&ibap_i2o_member_name,
        recursion_enabled       => \&ibap_i2o_boolean,
        use_allow_query         => \&ibap_i2o_boolean,
        use_allow_update_forwarding => \&ibap_i2o_boolean,
		use_dnssec              => \&ibap_i2o_boolean,
        use_blacklist           => \&ibap_i2o_boolean,
        use_dns_cache_ttl       => \&ibap_i2o_boolean,
        use_enable_gss_tsig     => \&ibap_i2o_boolean,
        use_forwarder_setting   => \&ibap_i2o_boolean,
        use_filter_aaaa         => \&ibap_i2o_boolean,
        use_gss_tsig_keys       => \&ibap_i2o_boolean,
        use_log_categories      => \&ibap_i2o_boolean,
        use_record_name_policy => \&ibap_i2o_boolean,
        use_recursive_query_setting => \&ibap_i2o_boolean,
        use_sort_lists          => \&ibap_i2o_boolean,
        limit_concurrent_recursive_clients => \&ibap_i2o_boolean,
        use_syslog_facility   => \&ibap_i2o_boolean,
        use_zone_transfer_setting => \&ibap_i2o_boolean,
        use_update_setting      => \&ibap_i2o_boolean,
        use_zone_transfer_format => \&ibap_i2o_boolean,
        use_source_ports         => \&ibap_i2o_boolean,
        enable_notify_source_port => \&ibap_i2o_boolean,
        enable_query_source_port => \&ibap_i2o_boolean,
        use_root_name_server_setting => \&ibap_i2o_boolean,
        enable_custom_root_server => \&ibap_i2o_boolean,
        nxdomain_log_query        => \&ibap_i2o_boolean,
        nxdomain_rulesets         => \&ibap_i2o_rulesets_by_names,
        use_nxdomain_redirect     => \&ibap_i2o_boolean,
        use_lame_ttl              => \&ibap_i2o_boolean,
        copy_xfer_to_notify       => \&ibap_i2o_boolean,
        use_copy_xfer_to_notify   => \&ibap_i2o_boolean,
        use_transfers_in          => \&ibap_i2o_boolean,
        use_transfers_out         => \&ibap_i2o_boolean,
        use_transfers_per_ns      => \&ibap_i2o_boolean,
        use_serial_query_rate     => \&ibap_i2o_boolean,
        use_max_cache_ttl         => \&ibap_i2o_boolean,
        use_max_cached_lifetime   => \&ibap_i2o_boolean,
        use_max_cache_ttl         => \&ibap_i2o_boolean,
        use_disable_edns          => \&ibap_i2o_boolean,
        use_rpz_disable_nsdname_nsip => \&ibap_i2o_boolean,

        'fixed_rrset_order_fqdns'         => \&ibap_i2o_generic_object_list_convert,
        'fixed_rrset_order_fqdns_enabled' => \&ibap_i2o_boolean,
        'use_fixed_rrset_order_fqdns'     => \&ibap_i2o_boolean,
        use_rpz_qname_wait_recurse   => \&ibap_i2o_boolean,
        'auto_blackhole'             => \&ibap_i2o_generic_object_convert,
        'attack_mitigation'          => \&ibap_i2o_generic_object_convert,
        'response_rate_limiting'     => \&ibap_i2o_generic_object_convert,
        'use_auto_blackhole'         => \&ibap_i2o_boolean,
        'use_attack_mitigation'      => \&ibap_i2o_boolean,
        'use_response_rate_limiting' => \&ibap_i2o_boolean,
        'use_resolver_query_timeout' => \&ibap_i2o_boolean,
        'use_server_id_directive' => \&ibap_i2o_boolean,
        'use_bind_hostname_directive' => \&ibap_i2o_boolean,

        is_unbound_capable           => \&ibap_i2o_boolean,

        'enable_capture_dns_queries'             => \&ibap_i2o_boolean,
        'enable_capture_dns_responses'           => \&ibap_i2o_boolean,
        'use_enable_capture_dns'                 => \&ibap_i2o_boolean,
        'capture_dns_queries_on_all_domains'     => \&ibap_i2o_boolean,
        'use_capture_dns_queries_on_all_domains' => \&ibap_i2o_boolean,
        'transfer_settings'                      => \&ibap_i2o_generic_object_convert,
        'anonymize_response_logging'             => \&ibap_i2o_boolean,
        'store_locally'                          => \&ibap_i2o_boolean,
        'enable_excluded_domain_names'           => \&ibap_i2o_boolean,
        'use_enable_excluded_domain_names'       => \&ibap_i2o_boolean,
        'skip_in_grid_rpz_queries'               => \&ibap_i2o_boolean,
        'member_views_address_settings'          => \&ibap_i2o_generic_object_list_convert,
                      );

    %_object_to_ibap=(
		name                      => \&ibap_o2i_member_name,
        additional_ip_list        => \&__o2i_MemberAdditionalIp_list__,
        allow_gss_tsig_zone_updates => \&ibap_o2i_boolean,
        allow_query               => \&ibap_o2i_ac_setting,
        allow_recursive_query     => \&ibap_o2i_boolean,
        allow_transfer            => \&ibap_o2i_ac_setting,
        allow_update              => \&ibap_o2i_ac_setting,
        auto_create_a_and_ptr_for_lan2 => \&ibap_o2i_boolean,
        auto_create_aaaa_and_ipv6ptr_for_lan2 => \&ibap_o2i_boolean,
        auto_sort_views           => \&ibap_o2i_boolean,
        bind_check_names_policy   => \&ibap_o2i_ignore,
        blackhole_list            => \&ibap_o2i_ac_setting,
        blacklist_action          => \&ibap_o2i_string,
        blacklist_log_query       => \&ibap_o2i_boolean,
        blacklist_redirect_addresses => \&ibap_o2i_ipv4addr_list,
        blacklist_redirect_ttl    => \&ibap_o2i_uint,
        blacklist_rulesets        => \&ibap_o2i_rulesets_by_names,
        custom_root_name_servers  => \&__o2i_ns__,
		enable_dns_cache_acceleration => \&ibap_o2i_boolean,
		dnssec_enabled            => \&ibap_o2i_dnssec_props,
		dnssec_expired_signatures_enabled => \&ibap_o2i_ignore,
		dnssec_validation_enabled => \&ibap_o2i_ignore,
        dnssec_blacklist_enabled  => \&ibap_o2i_ignore,
        dnssec_dns64_enabled      => \&ibap_o2i_ignore,
        dnssec_nxdomain_enabled   => \&ibap_o2i_ignore,
        dnssec_rpz_enabled        => \&ibap_o2i_ignore,
        dnssec_trusted_keys       => \&ibap_o2i_dnssec_trusted_keys,
        dnssec_negative_trust_anchors   => \&ibap_o2i_string_array_undef_to_empty,
        dns_cache_acceleration_ttl => \&ibap_o2i_uint,
        dns_cache_acceleration_status => \&ibap_o2i_ignore,
        dns_notify_transfer_source_interface => \&ibap_o2i_source_interface,
        dns_query_source_interface           => \&ibap_o2i_source_interface,
        dtc_health_source_interface         => \&ibap_o2i_source_interface,
        enable_blackhole          => \&ibap_o2i_boolean,
        enable_blacklist          => \&ibap_o2i_boolean,
        enable_dns                => \&ibap_o2i_boolean,
        enable_gss_tsig           => \&ibap_o2i_boolean,
        enable_dns64              => \&ibap_o2i_boolean,
	    override_dns64            => \&ibap_o2i_boolean,
	    dns64_groups              => \&ibap_o2i_dns64groups,
        extattrs                  => \&ibap_o2i_ignore, # RO field
        extensible_attributes     => \&ibap_o2i_ignore, # RO field
        gss_tsig_principal_name   => \&ibap_o2i_ignore, # RO field
        gss_tsig_version_number   => \&ibap_o2i_ignore, # RO field
        gss_tsig_keys             => \&ibap_o2i_gss_tsig_keys,
        facility                  => \&ibap_o2i_enums_lc_or_undef,
        filter_aaaa               => \&ibap_o2i_enums_lc_or_undef,
        filter_aaaa_list          => \&ibap_o2i_ac_setting,
        forwarders                => \&ibap_o2i_forwarders,
        forward_only              => \&ibap_o2i_boolean,
        forward_updates           => \&ibap_o2i_boolean,
        glue_record_addresses     => \&ibap_o2i_generic_struct_list_convert,
        ipv6_glue_record_addresses => \&ibap_o2i_generic_struct_list_convert,
        host_name_restriction_policy => \&ibap_o2i_record_name_policies,
        logging_categories        => \&ibap_o2i_logging_categories,
        minimal_resp              => \&ibap_o2i_boolean,
        notify_source_port        => \&ibap_o2i_integer,
        notify_delay              => \&ibap_o2i_uint,
        nxdomain_redirect         => \&ibap_o2i_boolean,
        nxdomain_redirect_addresses => \&ibap_o2i_ipaddr_list,
        nxdomain_redirect_addresses_ipv6 => \&ibap_o2i_ipaddr_list,
        override_dnssec           => \&ibap_o2i_boolean,
        override_filter_aaaa      => \&ibap_o2i_boolean,
        override_dns_cache_acceleration_ttl    => \&ibap_o2i_boolean,
        override_blacklist        => \&ibap_o2i_boolean,
        use_blacklist_internal  => \&ibap_o2i_ignore,
        use_blacklist_addresses => \&ibap_o2i_ignore,
        query_source_port         => \&ibap_o2i_integer,
        recursive_query_list      => \&ibap_o2i_ac_setting,
        recursive_client_limit    => \&ibap_o2i_integer,
        sortlist                  => \&ibap_o2i_sort_list,
        transfer_excluded_servers => \&ibap_o2i_ipaddr_list,
        transfer_format           => \&ibap_o2i_transfer_format,
        use_lan_ipv6_port         => \&ibap_o2i_boolean,
        use_lan_port              => \&ibap_o2i_boolean,
        use_lan2_port             => \&ibap_o2i_boolean,
        use_lan2_ipv6_port        => \&ibap_o2i_boolean,
        use_mgmt_port             => \&ibap_o2i_boolean,
        use_mgmt_ipv6_port        => \&ibap_o2i_boolean,
        views                     => \&__o2i_views_by_names__,
        use_allow_query           => \&ibap_o2i_boolean,
        use_allow_update_forwarding => \&ibap_o2i_boolean,
        use_blackhole             => \&ibap_o2i_boolean,
        override_forwarders       => \&ibap_o2i_boolean,
        use_log_categories        => \&ibap_o2i_boolean,
    	use_notify_delay          => \&ibap_o2i_boolean,
        use_record_name_policy    => \&ibap_o2i_boolean,
        use_recursive_query_setting => \&ibap_o2i_boolean,
        use_sort_lists            => \&ibap_o2i_boolean,
        limit_concurrent_recursive_clients => \&ibap_o2i_boolean,
        use_syslog_facility   => \&ibap_o2i_boolean,
        use_zone_transfer_setting => \&ibap_o2i_boolean,
        use_update_setting        => \&ibap_o2i_boolean,
        use_zone_transfer_format  => \&ibap_o2i_boolean,
        use_source_ports          => \&ibap_o2i_boolean,
        enable_notify_source_port => \&ibap_o2i_boolean,
        enable_query_source_port => \&ibap_o2i_boolean,
        override_nxdomain_redirect => \&ibap_o2i_boolean,
        use_root_name_servers     => \&ibap_o2i_boolean,
		use_root_name_server_setting => \&ibap_o2i_boolean,
        nxdomain_redirect_ttl        => \&ibap_o2i_uint,
        nxdomain_log_query        => \&ibap_o2i_boolean,
        nxdomain_rulesets         => \&ibap_o2i_rulesets_by_names,
        lame_ttl                  => \&ibap_o2i_uint,
        override_lame_ttl         => \&ibap_o2i_boolean,
        copy_xfer_to_notify          => \&ibap_o2i_boolean,
        override_copy_xfer_to_notify => \&ibap_o2i_boolean,
        transfers_in               => \&ibap_o2i_uint,
        transfers_out              => \&ibap_o2i_uint,
        transfers_per_ns           => \&ibap_o2i_uint,
        serial_query_rate          => \&ibap_o2i_uint,
        override_enable_gss_tsig   => \&ibap_o2i_boolean,
        override_gss_tsig_keys     => \&ibap_o2i_boolean,
        override_transfers_in      => \&ibap_o2i_boolean,
        override_transfers_out     => \&ibap_o2i_boolean,
        override_transfers_per_ns  => \&ibap_o2i_boolean,
        override_serial_query_rate => \&ibap_o2i_boolean,
        max_cache_ttl                => \&ibap_o2i_uint,
        override_max_cache_ttl       => \&ibap_o2i_boolean,
        max_cached_lifetime          => \&ibap_o2i_uint,
        override_max_cached_lifetime => \&ibap_o2i_boolean,
        max_ncache_ttl                => \&ibap_o2i_uint,
        override_max_ncache_ttl       => \&ibap_o2i_boolean,
        disable_edns               => \&ibap_o2i_boolean,
        override_disable_edns      => \&ibap_o2i_boolean,
        enable_query_rewrite         => \&ibap_o2i_boolean,
        override_query_rewrite       => \&ibap_o2i_boolean,
        override_rpz_disable_nsdname_nsip  => \&ibap_o2i_boolean,
        rpz_disable_nsdname_nsip     => \&ibap_o2i_boolean,
        override_rpz_qname_wait_recurse  => \&ibap_o2i_boolean,
        rpz_qname_wait_recurse           => \&ibap_o2i_boolean,

        fixed_rrset_order_fqdns          => \&ibap_o2i_generic_struct_list_convert,
        enable_fixed_rrset_order_fqdns   => \&ibap_o2i_boolean,
        override_fixed_rrset_order_fqdns => \&ibap_o2i_boolean,
        'auto_blackhole'                  => \&ibap_o2i_generic_struct_convert,
        'attack_mitigation'               => \&ibap_o2i_generic_struct_convert,
        'response_rate_limiting'          => \&ibap_o2i_generic_struct_convert,
        'resolver_query_timeout'          => \&ibap_o2i_uint,
        'override_auto_blackhole'         => \&ibap_o2i_boolean,
        'override_attack_mitigation'      => \&ibap_o2i_boolean,
        'override_response_rate_limiting' => \&ibap_o2i_boolean,
        'override_resolver_query_timeout' => \&ibap_o2i_boolean,

        recursive_resolver           => \&ibap_o2i_string,
        unbound_logging_level        => \&ibap_o2i_string,
        is_unbound_capable           => \&ibap_o2i_ignore,
        'override_rpz_drop_ip_rule'    => \&ibap_o2i_boolean,
        'rpz_drop_ip_rule_enabled' => \&ibap_o2i_boolean,
        'rpz_drop_ip_rule_min_prefix_length_ipv4' => \&ibap_o2i_uint,
        'rpz_drop_ip_rule_min_prefix_length_ipv6' => \&ibap_o2i_uint,

        'bind_hostname_directive'           => \&ibap_o2i_string,
        'bind_hostname_directive_fqdn'      => \&ibap_o2i_string,
        'server_id_directive'          => \&ibap_o2i_string,
        'server_id_directive_string'   => \&ibap_o2i_string,
        'override_bind_hostname_directive'  => \&ibap_o2i_boolean,
        'override_server_id_directive' => \&ibap_o2i_boolean,

        'enable_capture_dns_queries'                  => \&ibap_o2i_boolean,
        'enable_capture_dns_responses'                => \&ibap_o2i_boolean,
        'override_enable_capture_dns'                 => \&ibap_o2i_boolean,
        'capture_dns_queries_on_all_domains'          => \&ibap_o2i_boolean,
        'override_capture_dns_queries_on_all_domains' => \&ibap_o2i_boolean,
        'domains_to_capture_dns_queries'              => \&ibap_o2i_string_array_undef_to_empty,
        'file_transfer_setting'                       => \&ibap_o2i_generic_struct_convert,
        'enable_excluded_domain_names'                => \&ibap_o2i_boolean,
        'override_enable_excluded_domain_names'       => \&ibap_o2i_boolean,
        'excluded_domain_names'                       => \&ibap_o2i_string_array_undef_to_empty,
        'anonymize_response_logging'                  => \&ibap_o2i_boolean,
        'store_locally'                               => \&ibap_o2i_boolean,
        'dns_query_capture_file_time_limit'           => \&ibap_o2i_uint,
        'dtc_edns_prefer_client_subnet'               => \&ibap_o2i_boolean,
        'override_dtc_edns_prefer_client_subnet'      => \&ibap_o2i_boolean,

        'dns_health_check_domain_list'                => \&ibap_o2i_string_array_skip_undef,
        'dns_health_check_recursion_flag'             => \&ibap_o2i_boolean,
        'dns_health_check_anycast_control'            => \&ibap_o2i_boolean,
        'enable_dns_health_check'                     => \&ibap_o2i_boolean,
        'dns_health_check_interval'                   => \&ibap_o2i_uint,
        'dns_health_check_retries'                    => \&ibap_o2i_uint,
        'dns_health_check_timeout'                    => \&ibap_o2i_uint,
        'override_dns_health_check'                   => \&ibap_o2i_boolean,
        'skip_in_grid_rpz_queries'                    => \&ibap_o2i_boolean,
        'dns_view_address_settings'                   => \&ibap_o2i_generic_struct_list_convert,
        enable_ftc                                    => \&ibap_o2i_boolean,
        override_ftc                                  => \&ibap_o2i_boolean,
        ftc_expired_record_ttl                        => \&ibap_o2i_uint,
        ftc_expired_record_timeout                    => \&ibap_o2i_uint,

        #
        use_allow_gss_tsig_zone_updates => \&ibap_o2i_ignore,
        use_allow_update                => \&ibap_o2i_ignore,
        use_transfer_excluded_servers   => \&ibap_o2i_ignore,
        use_transfer_format             => \&ibap_o2i_ignore,
        use_filter_aaaa_list            => \&ibap_o2i_ignore,
        use_filter_aaaa                 => \&ibap_o2i_ignore,
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

        my ($tmp, %tmp);

        %tmp = (
                auto_blackhole                => 'Infoblox::Grid::DNS::AutoBlackHole',
                attack_mitigation             => 'Infoblox::Grid::DNS::AttackMitigation',
                response_rate_limiting        => 'Infoblox::Grid::DNS::ResponseRateLimiting',
                dns64_groups                  => 'Infoblox::Grid::DNS::DNS64Group',
                gss_tsig_keys                 => 'Infoblox::Grid::KerberosKey',
                transfer_settings             => 'Infoblox::Grid::DNS::FileTransferSetting',
                member_view_nats              => 'Infoblox::DNS::GlueRecordAddr',
                v6_member_view_nats           => 'Infoblox::DNS::GlueRecordAddr',
                member_views_address_settings => 'Infoblox::Grid::Member::DNS::ViewAddressSetting',
        );

        foreach (keys %tmp) {
            $tmp = $tmp{$_}->__new__();
            push @_return_fields,
                tField($_, {sub_fields => $tmp->__return_fields__()});
        }

        $tmp = Infoblox::Grid::NamedACL->__new__();

        foreach (
                 'blackhole',
                 'filter_aaaa_list',
                 'allow_transfer',
                 'allow_query',
                 'allow_recursive_query',
                 'allow_update'
        ) {
            push @_return_fields,
                tField($_, return_fields_ac_setting($tmp->__return_fields__()));
        }

        $tmp = Infoblox::Grid::DNS::FixedRRSetOrderFQDN->__new__();
        push @_return_fields,
            tField('fixed_rrset_order_fqdns', {sub_fields => $tmp->__return_fields__()});

    }


    $self->{'nxdomain_redirect'} = 'false' unless defined $self->{'nxdomain_redirect'};
    $self->{'override_nxdomain_redirect'} = 'false' unless defined $self->{'override_nxdomain_redirect'};
    $self->{'nxdomain_redirect_ttl'} = 60 unless defined $self->{'nxdomain_redirect_ttl'};
    $self->{'nxdomain_log_query'} = 'false' unless defined $self->{'nxdomain_log_query'};
    $self->{'blacklist_action'} = 'REFUSE' unless defined $self->{'blacklist_action'};
    $self->{'blacklist_log_query'} = 'false' unless defined $self->{'blacklist_log_query'};
    $self->{'override_dns_cache_acceleration_ttl'} = 'false' unless defined $self->{'override_dns_cache_acceleration_ttl'};
    $self->{'override_blacklist'} = 'false' unless defined $self->{'override_blacklist'};
    $self->{'override_forwarders'} = 'false' unless defined $self->{'override_forwarders'};
    $self->{'enable_blacklist'} = 'false' unless defined $self->{'enable_blacklist'};
    $self->{'dns64_groups'} = [] unless defined $self->dns64_groups();
    $self->{'dnssec_negative_trust_anchors'} = [] unless defined $self->dnssec_negative_trust_anchors();
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

sub __add_override_hook__ {
    my ($object_type, $session, $argsref) = @_;
    set_error_codes(1008, "'add' not allowed for this object", $session);
    return;
}

sub __remove_override_hook__ {
    my ($object_type, $session, $argsref) = @_;
    set_error_codes(1008, "'remove' not allowed for this object", $session);
    return;
}

sub __search_override_hook__ {
    my ($object_type, $session, $argsref) = @_;
    set_error_codes(1008, "'search' not allowed for this object", $session);
    return;
}

#
#
#

sub __i2o_views_by_names__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        my @newlist = ();
        for my $view (@{$$ibap_object_ref{$current}}) {
            push @newlist, $view->{'name'};
        }
        return \@newlist;
    } else {
        return [];
    }
}

sub __i2o_MemberAdditionalIp_list__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        my @newlist = ();
        for my $add_ip (@{$$ibap_object_ref{$current}}) {
            push @newlist, $add_ip->{'ipv4_network_setting'}->{'address'} if defined($add_ip->{'ipv4_network_setting'});
            push @newlist, $add_ip->{'ipv6_network_setting'}->{'virtual_ip'} if defined($add_ip->{'ipv6_network_setting'});
        }
        return \@newlist;
    } else {
        return [];
    }
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

	#


    #
    $$ibap_object_ref{'recursion_enabled'}=0 unless defined $$ibap_object_ref{'recursion_enabled'};
    $$ibap_object_ref{'auto_sort_views'}=0 unless defined $$ibap_object_ref{'auto_sort_views'};
    $$ibap_object_ref{'auto_create_lan2_glue'}=0 unless defined $$ibap_object_ref{'auto_create_lan2_glue'};
    $$ibap_object_ref{'v6_auto_create_lan2_glue'}=0 unless defined $$ibap_object_ref{'v6_auto_create_lan2_glue'};
    $$ibap_object_ref{'enable_blackhole'}=0 unless defined $$ibap_object_ref{'enable_blackhole'};
    $$ibap_object_ref{'enable_service'}=0 unless defined $$ibap_object_ref{'enable_service'};
    $$ibap_object_ref{'forwarders_only'}=0 unless defined $$ibap_object_ref{'forwarders_only'};
    $$ibap_object_ref{'allow_update_forwarding'}=0 unless defined $$ibap_object_ref{'allow_update_forwarding'};
    $$ibap_object_ref{'minimal_response'}=0 unless defined $$ibap_object_ref{'minimal_response'};
    $$ibap_object_ref{'enable_dns_cache_acceleration'}=0 unless defined $$ibap_object_ref{'enable_dns_cache_acceleration'};
    $$ibap_object_ref{'enable_gss_tsig'}=0 unless defined $$ibap_object_ref{'enable_gss_tsig'};
    $$ibap_object_ref{'use_enable_gss_tsig'}=0 unless defined $$ibap_object_ref{'use_enable_gss_tsig'};
    $$ibap_object_ref{'use_gss_tsig_keys'}=0 unless defined $$ibap_object_ref{'use_gss_tsig_keys'};
    $$ibap_object_ref{'use_dnssec'}=0 unless defined $$ibap_object_ref{'use_dnssec'};
    $$ibap_object_ref{'use_dns64'}=0 unless defined $$ibap_object_ref{'use_dns64'};
    $$ibap_object_ref{'enable_dns64'}=0 unless defined $$ibap_object_ref{'enable_dns64'};
    $$ibap_object_ref{'use_nxdomain_redirect'}=0 unless defined $$ibap_object_ref{'use_nxdomain_redirect'};
    $$ibap_object_ref{'enable_nxdomain_redirect'}=0 unless defined $$ibap_object_ref{'enable_nxdomain_redirect'};
    $$ibap_object_ref{'nxdomain_log_query'}=0 unless defined $$ibap_object_ref{'nxdomain_log_query'};
    $$ibap_object_ref{'use_dns_cache_ttl'}=0 unless defined $$ibap_object_ref{'use_dns_cache_ttl'};
    $$ibap_object_ref{'use_blacklist'}=0 unless defined $$ibap_object_ref{'use_blacklist'};
    $$ibap_object_ref{'enable_blacklist'}=0 unless defined $$ibap_object_ref{'enable_blacklist'};
    $$ibap_object_ref{'blacklist_log_query'}=0 unless defined $$ibap_object_ref{'blacklist_log_query'};
    $$ibap_object_ref{'dns_over_lan2'}=0 unless defined $$ibap_object_ref{'dns_over_lan2'};
    $$ibap_object_ref{'dns_over_lan'}=0 unless defined $$ibap_object_ref{'dns_over_lan'};
    $$ibap_object_ref{'dns_over_v6_lan2'}=0 unless defined $$ibap_object_ref{'dns_over_v6_lan2'};
    $$ibap_object_ref{'dns_over_v6_lan'}=0 unless defined $$ibap_object_ref{'dns_over_v6_lan'};
    $$ibap_object_ref{'dns_over_mgmt'}=0 unless defined $$ibap_object_ref{'dns_over_mgmt'};
    $$ibap_object_ref{'dns_over_v6_mgmt'}=0 unless defined $$ibap_object_ref{'dns_over_v6_mgmt'};
    $$ibap_object_ref{'enable_custom_root_server'}=0 unless defined $$ibap_object_ref{'enable_custom_root_server'};
    $$ibap_object_ref{'use_lame_ttl'}=0 unless defined $$ibap_object_ref{'use_lame_ttl'};
    $$ibap_object_ref{'copy_xfer_to_notify'}=0 unless defined $$ibap_object_ref{'copy_xfer_to_notify'};
    $$ibap_object_ref{'use_copy_xfer_to_notify'}=0 unless defined $$ibap_object_ref{'use_copy_xfer_to_notify'};
    $$ibap_object_ref{'use_transfers_in'}=0 unless defined $$ibap_object_ref{'use_transfers_in'};
    $$ibap_object_ref{'use_transfers_out'}=0 unless defined $$ibap_object_ref{'use_transfers_out'};
    $$ibap_object_ref{'use_transfers_per_ns'}=0 unless defined $$ibap_object_ref{'use_transfers_per_ns'};
    $$ibap_object_ref{'use_serial_query_rate'}=0 unless defined $$ibap_object_ref{'use_serial_query_rate'};
    $$ibap_object_ref{'use_max_cache_ttl'}=0 unless defined $$ibap_object_ref{'use_max_cache_ttl'};
    $$ibap_object_ref{'use_max_cached_lifetime'}=0 unless defined $$ibap_object_ref{'use_max_cached_lifetime'};
    $$ibap_object_ref{'use_max_ncache_ttl'}=0 unless defined $$ibap_object_ref{'use_max_ncache_ttl'};
    $$ibap_object_ref{'disable_edns'}=0 unless defined $$ibap_object_ref{'disable_edns'};
    $$ibap_object_ref{'use_disable_edns'}=0 unless defined $$ibap_object_ref{'use_disable_edns'};
    $$ibap_object_ref{'query_rewrite_enabled'}=0 unless defined $$ibap_object_ref{'query_rewrite_enabled'};
    $$ibap_object_ref{'use_query_rewrite'}=0 unless defined $$ibap_object_ref{'use_query_rewrite'};
    $$ibap_object_ref{'rpz_disable_nsdname_nsip'}=0 unless defined $$ibap_object_ref{'rpz_disable_nsdname_nsip'};
    $$ibap_object_ref{'use_rpz_disable_nsdname_nsip'}=0 unless defined $$ibap_object_ref{'use_rpz_disable_nsdname_nsip'};
    $$ibap_object_ref{'rpz_qname_wait_recurse'}=0 unless defined $$ibap_object_ref{'rpz_qname_wait_recurse'};
    $$ibap_object_ref{'use_rpz_qname_wait_recurse'}=0 unless defined $$ibap_object_ref{'use_rpz_qname_wait_recurse'};
    $$ibap_object_ref{'is_unbound_capable'}=0 unless defined $$ibap_object_ref{'is_unbound_capable'};

    $$ibap_object_ref{'dnssec'}{'enable_dnssec'}=0 if(defined($$ibap_object_ref{'dnssec'}) && !defined $$ibap_object_ref{'dnssec'}{'enable_dnssec'});
    $$ibap_object_ref{'dnssec'}{'enable_dnssec_validation'}=0 if(defined($$ibap_object_ref{'dnssec'}) && !defined $$ibap_object_ref{'dnssec'}{'enable_dnssec_validation'});
    $$ibap_object_ref{'dnssec'}{'enable_dnssec_expired_signatures'}=0 if(defined($$ibap_object_ref{'dnssec'}) && !defined $$ibap_object_ref{'dnssec'}{'enable_dnssec_expired_signatures'});
    $$ibap_object_ref{'administrative_record_name_policies'}{'check_names_for_ddns_and_zone_transfer'}=0 if(defined($$ibap_object_ref{'administrative_record_name_policies'}) && !defined $$ibap_object_ref{'administrative_record_name_policies'}{'check_names_for_ddns_and_zone_transfer'});

    $$ibap_object_ref{'fixed_rrset_order_fqdns_enabled'} = 0 unless defined $$ibap_object_ref{'fixed_rrset_order_fqdns_enabled'};
    $$ibap_object_ref{'use_fixed_rrset_order_fqdns'}     = 0 unless defined $$ibap_object_ref{'use_fixed_rrset_order_fqdns'};

    $$ibap_object_ref{'use_auto_blackhole'}=0 unless defined $$ibap_object_ref{'use_auto_blackhole'};
    $$ibap_object_ref{'use_attack_mitigation'}=0 unless defined $$ibap_object_ref{'use_attack_mitigation'};
    $$ibap_object_ref{'use_response_rate_limiting'}=0 unless defined $$ibap_object_ref{'use_response_rate_limiting'};
    $$ibap_object_ref{'use_resolver_query_timeout'}=0 unless defined $$ibap_object_ref{'use_resolver_query_timeout'};
    $$ibap_object_ref{'rpz_drop_ip_rule_enabled'}=0 unless defined $$ibap_object_ref{'rpz_drop_ip_rule_enabled'};
    $$ibap_object_ref{'use_rpz_drop_ip_rule'}=0 unless defined $$ibap_object_ref{'use_rpz_drop_ip_rule'};

    $$ibap_object_ref{'use_bind_hostname_directive'} = 0 unless defined $$ibap_object_ref{'use_bind_hostname_directive'};
    $$ibap_object_ref{'use_server_id_directive'} = 0 unless defined $$ibap_object_ref{'use_server_id_directive'};

    $$ibap_object_ref{'use_enable_capture_dns'} = 0 unless defined $$ibap_object_ref{'use_enable_capture_dns'};
    $$ibap_object_ref{'enable_capture_dns_queries'} = 0 unless defined $$ibap_object_ref{'enable_capture_dns_queries'};
    $$ibap_object_ref{'enable_capture_dns_responses'} = 0 unless defined $$ibap_object_ref{'enable_capture_dns_responses'};
    $$ibap_object_ref{'anonymize_response_logging'} = 0 unless defined $$ibap_object_ref{'anonymize_response_logging'};
    $$ibap_object_ref{'store_locally'} = 0 unless defined $$ibap_object_ref{'store_locally'};
    $$ibap_object_ref{'capture_dns_queries_on_all_domains'} = 0 unless defined $$ibap_object_ref{'capture_dns_queries_on_all_domains'};
    $$ibap_object_ref{'use_capture_dns_queries_on_all_domains'} = 0 unless defined $$ibap_object_ref{'use_capture_dns_queries_on_all_domains'};
    $$ibap_object_ref{'enable_excluded_domain_names'} = 0 unless defined $$ibap_object_ref{'enable_excluded_domain_names'};
    $$ibap_object_ref{'use_enable_excluded_domain_names'} = 0 unless defined $$ibap_object_ref{'use_enable_excluded_domain_names'};
    $$ibap_object_ref{'dtc_prefer_client_subnet'} = 0 unless defined $$ibap_object_ref{'dtc_prefer_client_subnet'};
    $$ibap_object_ref{'use_dtc_prefer_client_subnet'} = 0 unless defined $$ibap_object_ref{'use_dtc_prefer_client_subnet'};

    $$ibap_object_ref{'dns_health_check_recursion_flag'} = 0 unless defined $$ibap_object_ref{'dns_health_check_recursion_flag'};
    $$ibap_object_ref{'dns_health_check_anycast_control'} = 0 unless defined $$ibap_object_ref{'dns_health_check_anycast_control'};
    $$ibap_object_ref{'dns_health_check_enabled'} = 0 unless defined $$ibap_object_ref{'dns_health_check_enabled'};
    $$ibap_object_ref{'use_dns_health_check'} = 0 unless defined $$ibap_object_ref{'use_dns_health_check'};
    $$ibap_object_ref{'skip_in_grid_rpz_queries'} = 0 unless defined $$ibap_object_ref{'skip_in_grid_rpz_queries'};

    $$ibap_object_ref{'use_smartcache'} = 0 unless defined $$ibap_object_ref{'use_smartcache'};
    $$ibap_object_ref{'enable_smartcache'} = 0 unless defined $$ibap_object_ref{'enable_smartcache'};

    $self->allow_recursive_query('false');
    $self->auto_sort_views('false');
    $self->auto_create_a_and_ptr_for_lan2('false');
    $self->auto_create_aaaa_and_ipv6ptr_for_lan2('false');
    $self->dnssec_enabled('false');
    $self->dnssec_expired_signatures_enabled('false');
    $self->dnssec_validation_enabled('false');
    $self->enable_blackhole('false');
    $self->enable_dns('false');
    $self->enable_gss_tsig('false');
    $self->forward_only('false');
    $self->forward_updates('false');
    $self->minimal_resp('false');
    $self->override_dnssec('false');
    $self->use_lan_ipv6_port('false');
    $self->use_lan_port('false');
    $self->use_lan2_port('false');
    $self->use_lan2_ipv6_port('false');
    $self->use_mgmt_port('false');
    $self->use_mgmt_ipv6_port('false');
    $self->use_root_name_servers('false');

    $self->views([]);
    $self->recursive_query_list([]);
    $self->sortlist([]);
    $self->logging_categories([]);
    $self->additional_ip_list([]);
    $self->allow_query([]);
    $self->allow_transfer([]);
    $self->allow_update([]);
    $self->blackhole_list([]);
    $self->filter_aaaa_list([]);
    $self->dnssec_trusted_keys([]);
    $self->forwarders([]);
    $self->custom_root_name_servers([]);
    $self->allow_update([]);
    $self->allow_transfer([]);
    $self->dns_health_check_domain_list([]);
    $self->glue_record_addresses([]);
    $self->ipv6_glue_record_addresses([]);
    $self->dns_view_address_settings([]);

    delete $self->{'use_allow_update'};
    delete $self->{'use_filter_aaaa'};
    delete $self->{'use_filter_aaaa_list'};
    delete $self->{'use_allow_gss_tsig_zone_updates'};

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    #
    for (
        'use_source_ports',
        'use_zone_transfer_setting',
        'use_zone_transfer_format',
        'use_allow_query',
        'use_recursive_query_setting',
        'use_update_setting',
        'use_allow_update_forwarding',
        'use_root_name_server_setting',
        'use_sort_lists',
        'use_syslog_facility',
        'use_log_categories',
        'use_record_name_policy',
        'use_blackhole',
        'use_filter_aaaa',
        'limit_concurrent_recursive_clients',
        )
    {
        $self->{$_} = ($ibap_object_ref->{$_} || 0);
    }

    #
    if (ref($self->{'filter_aaaa_list'}) eq 'ARRAY' and scalar(@{$self->{'filter_aaaa_list'}}) == 0) {
            $self->{'use_filter_aaaa_list'} = 0;
    }

    $self->{'override_nxdomain_redirect'} = ($ibap_object_ref->{'use_nxdomain_redirect'} || 0);
    $self->{'override_blacklist'} = ($ibap_object_ref->{'use_blacklist'} || 0);
    $self->{'override_forwarders'} = ($ibap_object_ref->{'use_forwarder_setting'} || 0);

    #
    delete $self->{'allow_query'} unless $self->{'use_allow_query'};

    #
    #
    if (not $self->{'override_forwarders'}) {
        delete $self->{'forward_only'};
        delete $self->{'forwarders'};
    }

    if (not $self->{'override_nxdomain_redirect'}) {
        delete $self->{'nxdomain_redirect'};
        delete $self->{'nxdomain_redirect_addresses'};
        delete $self->{'nxdomain_redirect_addresses_ipv6'};
        delete $self->{'nxdomain_redirect_ttl'};
        delete $self->{'nxdomain_log_query'};
        delete $self->{'nxdomain_rulesets'};
    }
    #
    $self->{'override_nxdomain_redirect'} = ibap_value_i2o_boolean($self->{'override_nxdomain_redirect'});
    if (not $self->{'override_blacklist'}) {
        delete $self->{'blacklist_action'};
        delete $self->{'enable_blacklist'};
        delete $self->{'blacklist_redirect_addresses'};
        delete $self->{'blacklist_redirect_ttl'};
        delete $self->{'blacklist_log_query'};
        delete $self->{'blacklist_rulesets'};
        $self->{'use_blacklist_internal'} = 0;
        $self->{'use_blacklist_addresses'} = 0;
    }
    #
    $self->{'override_blacklist'} = ibap_value_i2o_boolean($self->{'override_blacklist'});

    if( not $self->{'use_blackhole'}){
        delete $self->{'enable_blackhole'};
        delete $self->{'blackhole_list'};
    }

    $self->{'use_notify_delay'} = $$ibap_object_ref{'use_notify_delay'};
    delete $self->{'notify_delay'} unless $self->{'use_notify_delay'};

    #
    delete $self->{'forward_updates'} unless $self->{'use_allow_update_forwarding'};
    #
    delete $self->{'logging_categories'} unless $self->{'use_log_categories'};
    #
    delete $self->{'host_name_restriction_policy'} unless $self->{'use_record_name_policy'};
    #
    delete $self->{'allow_recursive_query'} unless $self->{'use_recursive_query_setting'};
    #
    delete $self->{'sortlists'} unless $self->{'use_sort_lists'};
    #
    delete $self->{'recursive_client_limit'} unless $self->{'limit_concurrent_recursive_clients'};
    #
    delete $self->{'facility'} unless $self->{'use_syslog_facility'};

    #
    #
    delete $self->{'allow_transfer'} unless $self->{'use_zone_transfer_setting'};

    #
    #
    #
    if (not $self->{'use_update_setting'}) {
        delete $self->{'allow_update'};
        delete $self->{'allow_gss_tsig_zone_updates'};
        delete $self->{'use_allow_update'};
        delete $self->{'use_allow_gss_tsig_zone_updates'};
    }
    #
    #
    unless ($self->{'use_zone_transfer_format'}) {
        delete $self->{'transfer_format'};
        delete $self->{'transfer_excluded_servers'};
        delete $self->{'use_transfer_format'};
        delete $self->{'use_transfer_excluded_servers'};
    }
    #
    #
    #
    if (not $self->{'use_source_ports'}) {
       delete $self->{'notify_source_port'};
       delete $self->{'query_source_port'};
    }
    #
    delete $self->{'notify_source_port'} unless $self->{'enable_notify_source_port'};
    #
    delete $self->{'query_source_port'} unless $self->{'enable_query_source_port'};
    #
    #
    #
    if (not $self->{'use_root_name_server_setting'}) {
        delete $self->{'use_root_name_servers'};
        delete $self->{'custom_root_name_servers'};
    }

    #
    #
    $self->{'override_dnssec'} = 'false' if not $$ibap_object_ref{'use_dnssec'};

	#
	$self->{'forward_only'} = 'false' unless defined $self->{'forward_only'};
    $self->{'allow_update'} = [] unless defined $self->{'allow_update'};
    $self->{'allow_transfer'}=[] unless defined $self->{'allow_transfer'};

    #
    $self->{'override_dns64'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_dns64'});
    $self->{'override_forwarders'} = ibap_value_i2o_boolean($self->{'override_forwarders'});
    $self->{'override_filter_aaaa'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_filter_aaaa'});
    $self->{'override_dns_cache_acceleration_ttl'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_dns_cache_ttl'});
    $self->{'override_lame_ttl'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_lame_ttl'});
    $self->{'override_copy_xfer_to_notify'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_copy_xfer_to_notify'});
    $self->{'override_transfers_in'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_transfers_in'});
    $self->{'override_transfers_out'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_transfers_out'});
    $self->{'override_transfers_per_ns'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_transfers_per_ns'});
    $self->{'override_serial_query_rate'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_serial_query_rate'});
    $self->{'override_max_cache_ttl'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_max_cache_ttl'});
    $self->{'override_max_cached_lifetime'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_max_cached_lifetime'});
    $self->{'override_max_ncache_ttl'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_max_ncache_ttl'});
    $self->{'override_disable_edns'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_disable_edns'});
    $self->{'override_query_rewrite'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_query_rewrite'});
    $self->{'override_enable_gss_tsig'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_gss_tsig'});
    $self->{'override_gss_tsig_keys'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_gss_tsig_keys'});
    $self->{'override_rpz_disable_nsdname_nsip'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_rpz_disable_nsdname_nsip'});
    $self->{'override_fixed_rrset_order_fqdns'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_fixed_rrset_order_fqdns'});
    $self->{'enable_fixed_rrset_order_fqdns'} = ibap_value_i2o_boolean($$ibap_object_ref{'fixed_rrset_order_fqdns_enabled'});
    $self->{'override_rpz_qname_wait_recurse'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_rpz_qname_wait_recurse'});

    $self->{'override_auto_blackhole'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_auto_blackhole'});
    $self->{'override_attack_mitigation'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_attack_mitigation'});
    $self->{'override_response_rate_limiting'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_response_rate_limiting'});
    $self->{'override_resolver_query_timeout'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_resolver_query_timeout'});

    $self->{'override_bind_hostname_directive'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_bind_hostname_directive'});
    $self->{'override_server_id_directive'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_server_id_directive'});

    $self->{'override_rpz_drop_ip_rule'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_rpz_drop_ip_rule'});

    $self->{'override_enable_capture_dns'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_capture_dns'});
    $self->{'override_capture_dns_queries_on_all_domains'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_capture_dns_queries_on_all_domains'});
    $self->{'override_enable_excluded_domain_names'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_excluded_domain_names'});
    $self->{'override_dtc_edns_prefer_client_subnet'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_dtc_prefer_client_subnet'});

    $self->{'override_dns_health_check'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_dns_health_check'});

    $self->{'override_ftc'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_smartcache'});

    return $res;
}

#
#
#

sub __o2i_views_by_names__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;
    push @return_args, 1;

    if ($tempref->{$current} && ref($tempref->{$current}) eq 'ARRAY') {
        push @return_args, 0;

        my @newlist = ();

        for my $view_name (@{$tempref->{$current}}) {
            push @newlist, ibap_readfield_simple('View', 'name', tString($view_name),'view');
        }

        push @return_args, tIBType('ArrayOfBaseObject',\@newlist);

    } else {
        push @return_args, 1;
        push @return_args, tIBType('ArrayOfBaseObject',[]);
    }

    return @return_args;
}

sub __o2i_MemberAdditionalIp_list__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;
    push @return_args, 1;

    if ($tempref->{$current} && ref($tempref->{$current}) eq 'ARRAY') {
        push @return_args, 0;
        my $taddy;

        my @newlist = ();
        for my $element (@{$tempref->{$current}}) {
			my $parent_field={
                              field       => 'parent',
                              search_type => 'EXACT',
                              value       => ibap_readfield_simple_string('Member','host_name',$tempref->{'name'},'name')
                             };

			my %search_request;
			if (! ref($element)) {
                if (is_ipv4_address($element)) {
                  %search_request= (
                     field => 'ipv4_network_setting',
                     value => tIBType('SubMatch',
                                      {
                                       search_fields =>
                                       [
                                        {
                                         field => 'address',
                                         value => ibap_value_o2i_string($element,'address',$session)
                                        }
                                       ]
                                      }
                                     ),
                     search_type => 'EXACT'
                   );
                } elsif (is_ipv6_address($element)) {
                  %search_request= (
                     field => 'ipv6_network_setting',
                     value => tIBType('SubMatch',
                                      {
                                       search_fields =>
                                       [
                                        {
                                         field => 'virtual_ip',
                                         value => ibap_value_o2i_string($element,'address',$session)
                                        }
                                       ]
                                      }
                                     ),
                     search_type => 'EXACT'
                   );
                }

                $taddy = $element;
			} elsif (ref($element) eq "Infoblox::Grid::Member::Interface") {
				if ($element->ipv4addr()) {
					%search_request=
                      (
                       field       => 'ipv4_network_setting',
                       search_type => 'EXACT',
                       value       => tIBType('SubMatch',
                                              {
                                               search_fields =>
                                               [
                                                {
                                                 field => 'address',
                                                 value =>ibap_value_o2i_string($element->ipv4addr(),'address',$session)
                                                }
                                               ]
                                              }
                                             )
                      );

                    $taddy = $element->ipv4addr();
                } elsif ($element->ipv6addr()) {
                    %search_request=
                      (
                       field       => 'ipv6_network_setting',
                       search_type => 'EXACT',
                       value       => tIBType('SubMatch',
                                              {
                                               search_fields =>
                                               [
                                                {
                                                 field => 'virtual_ip',
                                                 value =>ibap_value_o2i_string($element->ipv6addr(),'address',$session)
                                                }
                                               ]
                                              }
                                             )
                      );

                    $taddy = $element->ipv6addr();
				} else {
					set_error_codes(1002,"ipv4 or ipv6 address should be provided for Infoblox::Grid::Member::Interface",$session);
					return (0);
				}
			}

			my $member_add_ip_req= ibap_readfield_simple(
                                                         'MemberAdditionalIp',
                                                         [
                                                          $parent_field,
                                                          \%search_request
                                                         ],undef,'additional_ip_list='.$taddy
                                                        );
 			push @newlist, $member_add_ip_req;
        }

        push @return_args, tIBType('ArrayOfBaseObject',\@newlist);

    } else {
        push @return_args, 1;
        push @return_args, tIBType('ArrayOfBaseObject',[]);
    }

    return @return_args;
}


#
#
#
#
sub __o2i_ns__
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

            push @return_args, tIBType('ArrayOfext_server', \@newlist);

        } else {
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType('ArrayOfext_server', []);
        }
    } else {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }
    return @return_args;
}


#
#
#

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub additional_ip_list
{
    my $self=shift;
    return $self->__accessor_array__({name => 'additional_ip_list', validator => {'Infoblox::Grid::Member::Interface' => 1, 'string' => \&ibap_value_o2i_string}}, @_);
}

sub allow_gss_tsig_zone_updates
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'allow_gss_tsig_zone_updates', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_allow_gss_tsig_zone_updates'}}, @_);
    if( @_ != 0 )
    {
        #
        $self->{'use_update_setting'}= $self->{'use_allow_gss_tsig_zone_updates'} || $self->{'use_allow_update'};
    }

    return $res;
}

sub allow_query
{
    my $self=shift;
    return $self->ibap_accessor_ac_setting('allow_query', 1, {'use' => 'use_allow_query'}, @_);
}

sub allow_recursive_query
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_recursive_query', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_recursive_query_setting'}}, @_);
}

sub allow_transfer
{
    my $self=shift;
    return $self->ibap_accessor_ac_setting('allow_transfer', 1, {'use' => 'use_zone_transfer_setting'}, @_);
}

sub allow_update
{
    my $self=shift;

    my $t = $self->ibap_accessor_ac_setting('allow_update', 1, {'use' => 'use_allow_update'}, @_);

    if( @_ != 0 )
    {
        #
        $self->{'use_update_setting'}= $self->{'allow_gss_tsig_zone_updates'} || $self->{'use_allow_update'};
    }

    return $t;
}

sub auto_create_a_and_ptr_for_lan2
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'auto_create_a_and_ptr_for_lan2', validator => \&ibap_value_o2i_boolean}, @_);
}

sub auto_create_aaaa_and_ipv6ptr_for_lan2
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'auto_create_aaaa_and_ipv6ptr_for_lan2', validator => \&ibap_value_o2i_boolean}, @_);
}

sub auto_sort_views
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'auto_sort_views', validator => \&ibap_value_o2i_boolean}, @_);
}

sub bind_check_names_policy
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'bind_check_names_policy', enum => ["fail","warn"] }, @_);
}

sub filter_aaaa
{
    my $self=shift;
    my $t = $self->__accessor_scalar__({name => 'filter_aaaa', enum => ['YES','NO','BREAK_DNSSEC'], use => 'use_filter_aaaa' }, @_);

    if( @_ != 0 )
    {
        $self->{'override_filter_aaaa'}= ibap_value_i2o_boolean($self->{'use_filter_aaaa'} || $self->{'use_filter_aaaa_list'});
    }
    return $t;
}

sub filter_aaaa_list
{
    my $self=shift;

    my $t = $self->ibap_accessor_ac_setting('filter_aaaa_list', 0, {'use' => 'use_filter_aaaa_list'}, @_);

    if( @_ != 0 )
    {
        $self->{'override_filter_aaaa'}= ibap_value_i2o_boolean($self->{'use_filter_aaaa'} || $self->{'use_filter_aaaa_list'});
    }
    return $t;
}

sub override_filter_aaaa
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_filter_aaaa', validator => \&ibap_value_o2i_boolean}, @_);
}

sub blackhole_list
{
    my $self=shift;
    my $res = $self->ibap_accessor_ac_setting('blackhole_list', 0, {'use' => 'use_blackhole'}, @_);
    if($self->{'enable_blackhole'}){
        $self->{'use_blackhole'}=1;
    }
    return $res;
}
sub override_blacklist
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_blacklist', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_blacklist
{
    my $self=shift;
    my $t = $self->__accessor_scalar__({name => 'enable_blacklist', use=> \$self->{'use_blacklist_internal'}, validator => \&ibap_value_o2i_boolean}, @_);
    if( @_ != 0 )
    {
        $self->{'override_blacklist'}= ibap_value_i2o_boolean($self->{'use_blacklist_internal'} || $self->{'use_blacklist_addresses'});
    }
    return $t;
}

sub blacklist_action
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'blacklist_action', enum => ['REFUSE','REDIRECT'] }, @_);
}

sub blacklist_log_query
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'blacklist_log_query', validator => \&ibap_value_o2i_boolean}, @_);
}

sub blacklist_redirect_addresses
{
    my $self=shift;
    my $t = $self->__accessor_array__({name => 'blacklist_redirect_addresses', use => \$self->{'use_blacklist_addresses'}, validator => \&ibap_value_o2i_ipv4addr}, @_);
    if( @_ != 0 )
    {
        $self->{'override_blacklist'}= ibap_value_i2o_boolean($self->{'use_blacklist_internal'} || $self->{'use_blacklist_addresses'});
    }
    return $t;
}

sub blacklist_redirect_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'blacklist_redirect_ttl', validator => \&ibap_value_o2i_uint}, @_);
}

sub blacklist_rulesets
{
    my $self=shift;
    return $self->__accessor_array__({name => 'blacklist_rulesets', validator => \&ibap_value_o2i_string}, @_);
}


sub custom_root_name_servers
{
    my $self=shift;
    #
    if (scalar(@_) >= 1 and defined($_[0]) and ref($_[0]) eq 'ARRAY' and @{$_[0]}) { # if not empty...
        $self->{'use_root_name_servers'} = 'true';
    }
    return $self->__accessor_array__({name => 'custom_root_name_servers', validator => { 'Infoblox::DNS::RootNameServer' => 1 }, use => \$self->{'use_root_name_server_setting'}}, @_);
}

sub dns_notify_transfer_source_interface
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_notify_transfer_source_interface', enum => [ 'VIP', 'MGMT', 'LAN2', 'Any' ], validator => \&ibap_value_o2i_ipaddr}, @_);
}

sub dns_query_source_interface
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_query_source_interface', enum => [ 'VIP', 'MGMT', 'LAN2', 'Any' ], validator => \&ibap_value_o2i_ipaddr}, @_);
}

sub dtc_health_source_interface
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'dtc_health_source_interface', enum => ['VIP', 'MGMT', 'LAN2', 'Any'], validator => \&ibap_value_o2i_ipaddr}, @_);
}

sub enable_blackhole
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'enable_blackhole', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_blackhole'}}, @_);
    if($self->{'blackhole_list'} && (ref($self->{'blackhole_list'}) eq 'Infoblox::Grid::NamedACL' || scalar(@{$self->blackhole_list})>0)){
        $self->{'use_blackhole'}=1;
    }
    return $res;
}

sub enable_dns_cache_acceleration
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_dns_cache_acceleration', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dns_cache_acceleration_status
{
    my $self=shift;
    return $self->__accessor_scalar__({readonly => 1, name => 'dns_cache_acceleration_status', validator => \&ibap_value_o2i_string}, @_);
}

sub dns_cache_acceleration_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_cache_acceleration_ttl', validator => \&ibap_value_o2i_uint, use => \$self->{'override_dns_cache_acceleration_ttl'}, use_truefalse => 1}, @_);
}

sub override_dns_cache_acceleration_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_dns_cache_acceleration_ttl', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dnssec_enabled
{
  #
  my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'dnssec_enabled' };
    }
    else
    {
        my $value = shift;
		$self->{ 'override_dnssec' } = "true";
        if( !defined $value )
        {
            $self->{ 'dnssec_enabled' } = undef;
			$self->{ 'override_dnssec' } = "false";
        }
        else
        {
			$self->{ 'dnssec_enabled' } = $value;
	}
    }
  return 1;
}

sub dnssec_expired_signatures_enabled
{
	my $self=shift;
    return $self->__accessor_scalar__({name => 'dnssec_expired_signatures_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dnssec_trusted_keys
{
	my $self=shift;
    return $self->__accessor_array__({name => 'dnssec_trusted_keys', validator => { 'Infoblox::DNS::DnssecTrustedKey' => 1 }}, @_);
}

sub dnssec_validation_enabled
{
	my $self=shift;
    return $self->__accessor_scalar__({name => 'dnssec_validation_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dnssec_negative_trust_anchors
{
    my $self=shift;
    return $self->__accessor_array__({name => 'dnssec_negative_trust_anchors', validator => \&ibap_value_o2i_string}, @_);
}

sub enable_dns
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_dns', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_gss_tsig
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_gss_tsig', validator => \&ibap_value_o2i_boolean, use => 'override_enable_gss_tsig', use_truefalse => 1}, @_);
}

sub override_enable_gss_tsig
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_enable_gss_tsig', validator => \&ibap_value_o2i_boolean}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 1, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 1, @_);
}

sub __gsshelper
{
    my $what=shift;
    my $self=shift;
    if (@_) {
        my $value = shift;
        my $r;

        if (defined $self->{'gss_tsig_keys'} && scalar(@{$self->{'gss_tsig_keys'}})) {
            if (scalar(@{$self->{'gss_tsig_keys'}} > 1)) {
                return set_error_codes(1104,'Multiple GSS-TSIG keys are in use, please use gss_tsig_keys instead.');
            }
            $r = $self->{'gss_tsig_keys'}->[0]->$what($value);
        }
        else {
            my $k = Infoblox::Grid::KerberosKey->new($what => $value);
            return unless defined $k;

            $r = $self->gss_tsig_keys([$k]);
        }

        #
        #
        #
        #
        if (defined $value) {
            $self->enable_gss_tsig('true');
        }
        else {
            $self->enable_gss_tsig('false');
        }

        return $r;
    }
    else {
        if (defined $self->{'gss_tsig_keys'} && scalar(@{$self->{'gss_tsig_keys'}})) {
            if (scalar(@{$self->{'gss_tsig_keys'}} > 1)) {
                return set_error_codes(1104,'Multiple GSS-TSIG keys are in use, please use gss_tsig_keys instead.');
            }
            return $self->{'gss_tsig_keys'}->[0]->$what();
        }
        return undef;
    }
}

sub gss_tsig_version_number
{
    return __gsshelper('version', @_)
}

sub gss_tsig_principal_name
{
    return __gsshelper('principal', @_)
}

sub gss_tsig_keys {
    my $self=shift;
    return $self->__accessor_array__({name => 'gss_tsig_keys', validator => {'Infoblox::Grid::KerberosKey' => 1 }, use => 'override_gss_tsig_keys', use_truefalse => 1}, @_);
}

sub override_gss_tsig_keys {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_gss_tsig_keys', validator => \&ibap_value_o2i_boolean}, @_);
}

sub facility
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'facility', use => \$self->{'use_syslog_facility'}, enum =>
                [ "daemon", "local0", "local1", "local2", "local3", "local4", "local5", "local6","local7" ]}, @_);
}

sub forwarders
{
    my $self=shift;
    #
    #
    if (scalar(@_) >= 1 and not defined($_[0])) {
        $_[0] = [];
    }

    my $res = $self->__accessor_array__({name => 'forwarders', validator => {'Infoblox::DNS::Member' => 1, 'Infoblox::DNS::Nameserver' => 1, 'string' => \&ibap_value_o2i_ipaddr }, use => \$self->{'override_forwarders'}, use_truefalse=> 1}, @_);
    if ($self->{'forward_only'} eq "true") {
        $self->{'override_forwarders'} = "true";
    }
    return $res;
}

sub forward_only
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'forward_only', validator => \&ibap_value_o2i_boolean, use => \$self->{'override_forwarders'}, use_truefalse => 1}, @_);
    if (defined $self->{'forwaders'} && scalar(@{$self->{'forwaders'}}) > 0) {
        $self->{'override_forwarders'} = "true";
    }
    return $res;
}

sub override_forwarders
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_forwarders', validator => \&ibap_value_o2i_boolean}, @_);
}

sub forward_updates
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'forward_updates', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_allow_update_forwarding'}}, @_);
}

sub host_name_restriction_policy
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'host_name_restriction_policy', validator => \&ibap_value_o2i_string, use => \$self->{'use_record_name_policy'}}, @_);
}

sub logging_categories
{
    my $self=shift;
    return $self->__accessor_array__({name => 'logging_categories', enum => \@allowed_logging_categories, use => \$self->{'use_log_categories'}}, @_);
}

sub minimal_resp
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'minimal_resp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub notify_delay
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'notify_delay', validator => \&ibap_value_o2i_uint, use => \$self->{'use_notify_delay'}}, @_);
}

sub notify_source_port
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'notify_source_port', validator => \&ibap_value_o2i_int, use => \$self->{'enable_notify_source_port'}}, @_);
    if (($self->{'enable_notify_source_port'}
        || $self->{'enable_query_source_port'} ))
    {
        $self->{'use_source_ports'} = 1;
    } else {
        $self->{'use_source_ports'} = 0;
    }
    return $res;
}

sub override_dnssec
{
	my $self=shift;
    return $self->__accessor_scalar__({name => 'override_dnssec', validator => \&ibap_value_o2i_boolean}, @_);
}

sub query_source_port
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'query_source_port', validator => \&ibap_value_o2i_int, use => \$self->{'enable_query_source_port'}}, @_);
    if (($self->{'enable_notify_source_port'}
        || $self->{'enable_query_source_port'} ))
    {
        $self->{'use_source_ports'} = 1;
    } else {
        $self->{'use_source_ports'} = 0;
    }
    return $res;
}

sub recursive_client_limit
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'recursive_client_limit', validator => \&ibap_value_o2i_int, use => \$self->{'limit_concurrent_recursive_clients'}}, @_);
}

sub recursive_query_list
{
    my $self=shift;
    return $self->ibap_accessor_ac_setting('recursive_query_list', 1, {}, @_);
}

sub sortlist
{
    my $self=shift;
    return $self->__accessor_array__({name => 'sortlist', validator => { 'Infoblox::DNS::Sortlist' => 1 }, use => \$self->{'use_sort_lists'}}, @_);
}

sub nxdomain_log_query
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'nxdomain_log_query', validator => \&ibap_value_o2i_boolean}, @_);
}

sub nxdomain_rulesets
{
    my $self=shift;
    return $self->__accessor_array__({name => 'nxdomain_rulesets', validator => \&ibap_value_o2i_string}, @_);
}

sub nxdomain_redirect_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'nxdomain_redirect_ttl', validator => \&ibap_value_o2i_uint}, @_);
}

sub transfer_excluded_servers
{
    my $self=shift;
    my $t = $self->__accessor_array__({name => 'transfer_excluded_servers', validator => \&ibap_value_o2i_string, use => \$self->{'use_transfer_excluded_servers'}}, @_);

    if( @_ != 0 )
    {
        #
        $self->{'use_zone_transfer_format'}= $self->{'use_transfer_excluded_servers'} || $self->{'use_transfer_format'};
    }

    return $t;
}

sub transfer_format
{
    my $self=shift;
    my $t = $self->__accessor_scalar__({name => 'transfer_format', use => \$self->{'use_transfer_format'}, enum => [ 'many_answers', 'one_answer' ]}, @_);

    if( @_ != 0 )
    {
        #
        $self->{'use_zone_transfer_format'}= $self->{'use_transfer_excluded_servers'} || $self->{'use_transfer_format'};
    }

    return $t;
}

sub use_lan_ipv6_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'use_lan_ipv6_port', validator => \&ibap_value_o2i_boolean}, @_);
}

sub use_lan_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'use_lan_port', validator => \&ibap_value_o2i_boolean}, @_);
}

sub use_lan2_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'use_lan2_port', validator => \&ibap_value_o2i_boolean}, @_);
}

sub use_lan2_ipv6_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'use_lan2_ipv6_port', validator => \&ibap_value_o2i_boolean}, @_);
}

sub use_mgmt_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'use_mgmt_port', validator => \&ibap_value_o2i_boolean}, @_);
}

sub use_mgmt_ipv6_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'use_mgmt_ipv6_port', validator => \&ibap_value_o2i_boolean}, @_);
}

sub use_root_name_servers
{
    my $self=shift;
    #
    #
    #
    #
    #
    #
    return $self->__accessor_scalar__({name => 'use_root_name_servers', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_root_name_server_setting'}}, @_);
}

sub views
{
    my $self=shift;
    return $self->__accessor_array__({name => 'views', validator => \&ibap_value_o2i_string}, @_);
}

sub enable_dns64
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_dns64', validator => \&ibap_value_o2i_boolean, use => \$self->{'override_dns64'}, use_truefalse => 1}, @_);
}

sub override_dns64
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_dns64', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dns64_groups
{
    my $self=shift;
    return $self->__accessor_array__({name => 'dns64_groups', validator => { 'Infoblox::Grid::DNS::DNS64Group' => 1 }, use => \$self->{'override_dns64'}, use_truefalse => 1}, @_);
}

sub lame_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'lame_ttl', validator => \&ibap_value_o2i_uint, use => \$self->{'override_lame_ttl'}, use_truefalse => 1}, @_);
}

sub override_lame_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_lame_ttl', validator => \&ibap_value_o2i_boolean}, @_);
}

sub copy_xfer_to_notify
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'copy_xfer_to_notify', validator => \&ibap_value_o2i_boolean, use => \$self->{'override_copy_xfer_to_notify'}, use_truefalse => 1}, @_);
}

sub override_copy_xfer_to_notify
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_copy_xfer_to_notify', validator => \&ibap_value_o2i_boolean}, @_);
}

sub max_cached_lifetime
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'max_cached_lifetime', validator => \&ibap_value_o2i_uint, use => \$self->{'override_max_cached_lifetime'}, use_truefalse => 1}, @_);
}

sub override_max_cached_lifetime
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'override_max_cached_lifetime', validator => \&ibap_value_o2i_boolean}, @_);
}

sub fixed_rrset_order_fqdns
{
    my $self = shift;
    my $res = $self->__accessor_array__({name => 'fixed_rrset_order_fqdns', validator => {'Infoblox::Grid::DNS::FixedRRSetOrderFQDN' => 1},
        use => 'enable_fixed_rrset_order_fqdns', use_truefalse => 1}, @_);

    $self->{override_fixed_rrset_order_fqdns} = 'true' if @_ and $_[0] and $res;
    return $res;
}

sub enable_fixed_rrset_order_fqdns
{
    my $self = shift;
    my $res = $self->__accessor_scalar__({name => 'enable_fixed_rrset_order_fqdns', validator => \&ibap_value_o2i_boolean}, @_);

    $self->{override_fixed_rrset_order_fqdns} = 'true' if @_ and $_[0] and $res;
    return $res;
}


package Infoblox::Grid::Member::DNS::ViewAddressSetting;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            $_object_type
            %_allowed_members
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_reverse_name_mappings
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'query_notify_xfr_config';
    register_wsdl_type('ib:query_notify_xfr_config', 'Infoblox::Grid::Member::DNS::ViewAddressSetting');


    %_allowed_members = (
                         'enable_notify_source_port'        => {simple => 'bool', use => 'override_source_ports', use_members => ['enable_notify_source_port', 'enable_query_source_port', 'query_source_port', 'notify_source_port'], validator => \&ibap_value_o2i_boolean},
                         'enable_query_source_port'         => {simple => 'bool', use => 'override_source_ports', use_members => ['enable_notify_source_port', 'enable_query_source_port', 'query_source_port', 'notify_source_port'], validator => \&ibap_value_o2i_boolean},
                         'notify_delay'                     => {simple => 'asis', use => 'override_notify_delay', validator => \&ibap_value_o2i_uint},
                         'notify_source_port'               => {simple => 'asis', use => 'override_source_ports', use_members => ['enable_notify_source_port', 'enable_query_source_port', 'query_source_port', 'notify_source_port'], validator => \&ibap_value_o2i_uint},
                         'notify_transfer_source_interface' => {enum => ['VIP', 'MGMT', 'LAN2', 'Any'], validator => \&ibap_value_o2i_ipaddr},
                         'override_notify_delay'            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'override_source_ports'            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'query_source_interface'           => {enum => ['VIP', 'MGMT', 'LAN2', 'Any'], validator => \&ibap_value_o2i_ipaddr},
                         'query_source_port'                => {simple => 'asis', use => 'override_source_ports', use_members => ['enable_notify_source_port', 'enable_query_source_port', 'query_source_port', 'notify_source_port'], validator => \&ibap_value_o2i_uint},
                         'view_name'                        => {mandatory => 1, validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'notify_transfer_source_interface' => 'notify_xfr_source',
                       'override_notify_delay'            => 'use_notify_delay',
                       'override_source_ports'            => 'use_source_ports',
                       'query_source_interface'           => 'query_source',
                       'view_name'                        => 'view',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'notify_xfr_source' => \&ibap_i2o_source_interface,
                        'query_source'      => \&ibap_i2o_source_interface,
                        'view'              => \&ibap_i2o_object_name,
    );

    %_object_to_ibap = (
                        'enable_notify_source_port'        => \&ibap_o2i_boolean,
                        'enable_query_source_port'         => \&ibap_o2i_boolean,
                        'notify_delay'                     => \&ibap_o2i_uint,
                        'notify_source_port'               => \&ibap_o2i_uint,
                        'notify_transfer_source_interface' => \&ibap_o2i_source_interface,
                        'override_notify_delay'            => \&ibap_o2i_boolean,
                        'override_source_ports'            => \&ibap_o2i_boolean,
                        'query_source_interface'           => \&ibap_o2i_source_interface,
                        'query_source_port'                => \&ibap_o2i_uint,
                        'view_name'                        => \&ibap_o2i_view,
    );

    @_return_fields = (
                       tField('enable_notify_source_port'),
                       tField('enable_query_source_port'),
                       tField('notify_delay'),
                       tField('notify_source_port'),
                       tField('notify_xfr_source', source_interface_return_fields()),
                       tField('query_source', source_interface_return_fields()),
                       tField('query_source_port'),
                       tField('use_notify_delay'),
                       tField('use_source_ports'),
                       tField('view', {
                           'sub_fields' => [
                               tField('name'),
                           ],
                       }),
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

#
#
#

sub __ibap_to_object__ {

    my $self = shift;

    my ($ibap_object_ref, $server,
        $session, $return_object_cache_ref) = @_;

    foreach (
        'enable_notify_source_port',
        'enable_query_source_port',
        'use_notify_delay',
        'use_source_ports',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }


    my $res = $self->SUPER::__ibap_to_object__(@_);

    $$self{'override_notify_delay'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_notify_delay'});
    $$self{'override_source_ports'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_source_ports'});

    return $res;
}


1; # so the require or use succeeds
