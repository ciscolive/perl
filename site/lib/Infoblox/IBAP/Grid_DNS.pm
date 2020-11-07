package Infoblox::Grid::DNS;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object $_return_fields_initialized @_sub_host_address_fields %_log_fields_mapping %_reverse_log_fields_mapping %_capabilities);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_MODIFY_ONLY);

BEGIN {
    $_object_type = 'GridDns';
    register_wsdl_type('ib:GridDns','Infoblox::Grid::DNS');

	%_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 0, # Single object, no need for single serialization
					 );


    %_allowed_members = (
        'allow_bulkhost_ddns'     => 0,
        'allow_gss_tsig_zone_updates' => 0,
        'allow_query'             => 0,
        'allow_recursive_query'   => 0,
        'allow_transfer'          => 0,
        'allow_update'            => 0,
        'blackhole_list'          => 0,
        'blacklist_action'        => 0,
        'blacklist_log_query'     => 0,
        'blacklist_redirect_addresses' => 0,
        'blacklist_redirect_ttl'  => 0,
        'blacklist_rulesets'      => 0,
        'bind_check_names_policy' => 0,
        'bulk_host_name_template' => 0,
        'bulk_host_name_templates' => 0,
        'dns64_groups'             => 0,
        'dns_cache_acceleration_ttl' => 0,
        'default_ttl'             => 0,
        'dnssec_enabled'          => 0,
        'dnssec_expired_signatures_enabled'=>0,
        'dnssec_validation_enabled'   =>0,
        'dnssec_trusted_keys'         =>0,
         dnssec_ksk_algorithms        => 0,
         dnssec_ksk_algorithm         => 0,
         dnssec_ksk_size              => 0,
         dnssec_ksk_rollover_interval => 0,
         dnssec_signature_expiration  => 0,
         dnssec_zsk_algorithms        => 0,
         dnssec_zsk_algorithm         => 0,
         dnssec_zsk_size              => 0,
         dnssec_zsk_rollover_interval => 0,
         dnssec_negative_trust_anchors   => 0,
         dnssec_nsec3_salt_min_length    => 0,
         dnssec_nsec3_salt_max_length    => 0,
         dnssec_nsec3_iterations         => 0,
         dnssec_zsk_rollover_mechanism   => 0,
         dnssec_enable_ksk_auto_rollover => 0,
         dnssec_ksk_rollover_notification_config  => 0,
         dnssec_ksk_snmp_notification_enabled  => 0,
         dnssec_ksk_email_notification_enabled  => 0,
         next_secure_type         => 0,
        'email'                   => 0,
        'enable_blackhole'        => 0,
        'enable_blacklist'        => 0,
        'enable_dns64'            => 0,
        'enable_host_rrset_order' => 0,
        'preserve_host_rrset_order_on_secondaries' => 0,
        'enable_hsm_signing'      => 0,
        'expire_after'            => 0,
        'filter_aaaa'             => 0,
        'filter_aaaa_list'        => 0,
        'forward_updates'         => 0,
        'forward_only'            => 0,
        'forwarders'              => 0,
        'gss_tsig_keys'           => 0,
        'host_name_restriction_policy' =>0,
        'logging_categories'      => 0,
        'logging_facility'        => 0,
        'member_secondary_notify' => 0,
        'negative_ttl'            => 0,
        'notify_delay'            => 0,
        'notify_source_port'      => 0,
        'nsgroup_default'         => 0,
        'nsgroups'                => 0,
        'nxdomain_redirect'         => 0,
        'nxdomain_redirect_addresses' => {array => 1, simple => 'asis', validator => \&ibap_value_o2i_ipv4addr},
        'nxdomain_redirect_addresses_ipv6' => {array => 1, simple => 'asis', validator => \&ibap_value_o2i_ipv6addr},
        'query_source_port'       => 0,
        'record_name_policies'    => 0,
        'recursive_query_list'    => 0,
        'refresh_timer'           => 0,
        'retry_timer'             => 0,
        'rootNS'                  => 0,
        'sortlist'                => 0,
        'transfer_excluded_servers' => 0,
        'transfer_format'         => 0,
        'zone_deletion_double_confirm' => 0,
        'nxdomain_redirect_ttl'   => 0,
        'nxdomain_log_query'      => 0,
        'nxdomain_rulesets'       => 0,
        'lame_ttl'                => 0,
        'copy_xfer_to_notify'     => 0,
        'transfers_in'            => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'transfers_out'           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'transfers_per_ns'        => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'serial_query_rate'       => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'max_cache_ttl'           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'max_cached_lifetime'     => 0,
        'max_ncache_ttl'           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'disable_edns'            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'enable_query_rewrite'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'query_rewrite_prefix'    => {simple => 'asis', validator => \&ibap_value_o2i_string},
        'query_rewrite_domain_names' => {array => 1, validator => \&ibap_value_o2i_string},
        'dnssec_blacklist_enabled' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dnssec_dns64_enabled'     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dnssec_nxdomain_enabled'  => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dnssec_rpz_enabled'       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'rpz_disable_nsdname_nsip' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},

        'fixed_rrset_order_fqdns'          => {validator => {'Infoblox::Grid::DNS::FixedRRSetOrderFQDN' => 1},
                                               array => 1, use_truefalse => 1, use => 'enable_fixed_rrset_order_fqdns'},
        'enable_fixed_rrset_order_fqdns'   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'rpz_qname_wait_recurse'   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'enable_delete_associated_ptr' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'restart_setting' => {validator => {'Infoblox::Grid::ServiceRestart' => 1}},
        'auto_blackhole'         => {validator => {'Infoblox::Grid::DNS::AutoBlackHole' => 1}},
        'attack_mitigation'      => {validator => {'Infoblox::Grid::DNS::AttackMitigation' => 1}},
        'response_rate_limiting' => {validator => {'Infoblox::Grid::DNS::ResponseRateLimiting' => 1}},
        'resolver_query_timeout' => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'bind_hostname_directive' => {simple => 'asis', enum => ['NONE', 'HOSTNAME']},
        'server_id_directive' => {simple => 'asis', enum => ['NONE', 'HOSTNAME']},
        'ddns_restrict_patterns_list' => {array => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
        'ddns_restrict_patterns' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'ddns_restrict_static' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'ddns_restrict_protected' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'ddns_restrict_secure' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'ddns_principal_tracking' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'ddns_force_creation_timestamp_update' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'ddns_principal_group' => {validator => {'Infoblox::DNS::DDNS::PrincipalCluster::Group' => 1}},
        'scavenging_settings' => {validator => {'Infoblox::Grid::DNS::ScavengingSetting' => 1}},
        'rpz_drop_ip_rule_enabled'                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'rpz_drop_ip_rule_min_prefix_length_ipv4' => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'rpz_drop_ip_rule_min_prefix_length_ipv6' => {simple => 'asis', validator => \&ibap_value_o2i_uint},

        'enable_capture_dns_queries'         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'capture_dns_queries_on_all_domains' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'domains_to_capture_dns_queries'     => {array => 1, validator => \&ibap_value_o2i_string},
        'file_transfer_setting'              => {validator => {'Infoblox::Grid::DNS::FileTransferSetting' => 1}},
        'enable_excluded_domain_names'       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'excluded_domain_names'              => {array => 1, validator => \&ibap_value_o2i_string},
        'enable_capture_dns_responses'       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'anonymize_response_logging'         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'store_locally'                      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dns_query_capture_file_time_limit'  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'enable_gss_tsig'                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dtc_edns_prefer_client_subnet'      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dns_health_check_domain_list'       => {array => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
        'dns_health_check_recursion_flag'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dns_health_check_anycast_control'   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'enable_dns_health_check'            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dns_health_check_interval'          => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'dns_health_check_retries'           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'dns_health_check_timeout'           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'enable_dtc_dns_fall_through'        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'dtc_topology_ea_list'               => {array => 1, validator => \&ibap_value_o2i_string},
        'dtc_dnssec_mode'                    => {simple => 'asis', enum => ['SIGNED', 'UNSIGNED']},
        'enable_client_subnet_recursive'     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'enable_client_subnet_forwarding'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'client_subnet_ipv6_prefix_length'   => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'client_subnet_ipv4_prefix_length'   => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'client_subnet_domains'              => {array => 1, validator => {'Infoblox::Grid::DNS::ClientSubnetDomain' => 1}},
        'enable_ftc'                         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'ftc_expired_record_ttl'             => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'ftc_expired_record_timeout'         => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                      );

   Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings=(
        'allow_recursive_query'          => 'recursion_enabled',
        'blackhole_list'                 => 'blackhole',
		'dns_cache_acceleration_ttl'     => 'dns_cache_ttl',
		'dnssec_enabled'                 => 'dnssec',
        'dnssec_zsk_rollover_interval'   => 'dnssec_key_params',
        'enable_host_rrset_order'        => 'host_rrset_order',
        'expire_after'                   => 'expire',
        'forwarders'                     => 'allow_forwarder',
        'forward_only'                   => 'forwarders_only',
        'forward_updates'                => 'allow_update_forwarding',
        'host_name_restriction_policy'   => 'administrative_record_name_policies',
        'logging_facility'               => 'syslog_facility',
        'member_secondary_notify'        => 'enable_secondary_notify',
        'nsgroup_default'                => 'default_ns_group',
        'nsgroups'                       => 'ns_groups',
        'nxdomain_redirect'              => 'enable_nxdomain_redirect',
        'record_name_policies'           => 'protocol_record_name_policies',
        'recursive_query_list'           => 'allow_recursive_query',
        'refresh_timer'                  => 'refresh',
        'retry_timer'                    => 'retry',
        'rootNS'                         => 'root_name_servers',
        'sortlist'                       => 'sort_lists',
        'transfer_excluded_servers'      => 'excluded_servers',
        'transfer_format'                => 'zone_transfer_format_option',
        'zone_deletion_double_confirm'   => 'double_confirm_zone_deletion',
        'enable_query_rewrite'           => 'query_rewrite_enabled',
        'enable_fixed_rrset_order_fqdns' => 'fixed_rrset_order_fqdns_enabled',
        'file_transfer_setting'          => 'transfer_settings',
        'dtc_edns_prefer_client_subnet'  => 'dtc_prefer_client_subnet',
        'enable_dtc_dns_fall_through'    => 'dtc_dns_fall_through_enabled',
        'scavenging_settings'            => 'reclamation_settings',
        'enable_dns_health_check'        => 'dns_health_check_enabled',
        'enable_client_subnet_recursive'   => 'client_subnet_recursive_enabled',
        'enable_client_subnet_forwarding'  => 'client_subnet_forwarding_enabled',
        'client_subnet_ipv6_prefix_length' => 'client_subnet_source_prefix_length_ipv6',
        'client_subnet_ipv4_prefix_length' => 'client_subnet_source_prefix_length_ipv4',
        'nxdomain_redirect_addresses_ipv6' => 'nxdomain_redirect_addresses_v6',
        'enable_ftc'                       => 'enable_smartcache',
        'ftc_expired_record_ttl'           => 'smartcache_expired_record_ttl',
        'ftc_expired_record_timeout'       => 'smartcache_expired_record_timeout',
                      );

    %_reverse_name_mappings= reverse %_name_mappings;

    $_name_mappings{'dnssec_validation_enabled'}='dnssec';
    $_name_mappings{'dnssec_expired_signatures_enabled'}='dnssec';
    $_name_mappings{'dnssec_blacklist_enabled'}='dnssec';
    $_name_mappings{'dnssec_dns64_enabled'}='dnssec';
    $_name_mappings{'dnssec_nxdomain_enabled'}='dnssec';
    $_name_mappings{'dnssec_rpz_enabled'}='dnssec';
    $_name_mappings{'enable_hsm_signing'}='dnssec';
    $_name_mappings{'dnssec_ksk_rollover_interval'} = 'dnssec_key_params';
    $_name_mappings{'dnssec_signature_expiration'} = 'dnssec_key_params';
    $_name_mappings{'dnssec_zsk_algorithms'} = 'dnssec_key_params';
    $_name_mappings{'dnssec_ksk_algorithms'} = 'dnssec_key_params';
    $_name_mappings{'dnssec_zsk_rollover_interval'} = 'dnssec_key_params';
    $_name_mappings{'dnssec_nsec3_salt_min_length'} = 'dnssec_key_params';
    $_name_mappings{'dnssec_nsec3_salt_max_length'} = 'dnssec_key_params';
    $_name_mappings{'dnssec_nsec3_iterations'} = 'dnssec_key_params';
    $_name_mappings{'dnssec_zsk_rollover_mechanism'} = 'dnssec_key_params';
    $_name_mappings{'dnssec_enable_ksk_auto_rollover'} = 'dnssec_key_params';
    $_name_mappings{'dnssec_ksk_rollover_notification_config'} = 'dnssec_key_params';
    $_name_mappings{'dnssec_ksk_snmp_notification_enabled'} = 'dnssec_key_params';
    $_name_mappings{'dnssec_ksk_email_notification_enabled'} = 'dnssec_key_params';
    $_name_mappings{'next_secure_type'} = 'dnssec_key_params';

    $_return_fields_initialized=0;

    my $field_address_ac =  tField('address_ac', {
                                                    sub_fields=>
                                                     [
                                                       tField('address_string'),
                                                       tField('permission')
                                                     ]
                                                    }
		                           );
    my $field_tsig_ac = tField('tsig_ac', {
								                 sub_fields=>
                                                  [
													   tField('tsig_key_name'),
													   tField('tsig_key_alg'),
                                                       tField('tsig_key'),
                                                       tField('use_2x_tsig_key'),
                                                  ]
                                                 }
		);

    @_return_fields=(
                     tField('allow_bulkhost_ddns'),
                     tField('allow_gss_tsig_zone_updates'),
                     tField('allow_forwarder'),
                     tField('allow_update_forwarding'),
                     tField('blacklist_action'),
                     tField('blacklist_log_query'),
                     tField('blacklist_redirect_addresses'),
                     tField('blacklist_redirect_ttl'),
                     tField('blacklist_rulesets',
                         {
                             sub_fields => [ tField('name'),]
                         }
                     ),
                     tField('dns_cache_ttl'),
                     tField('default_ttl'),
                     tField('dnssec_negative_trust_anchors'),
                     tField('double_confirm_zone_deletion'),
                     tField('email'),
                     tField('enable_blackhole'),
                     tField('enable_blacklist'),
                     tField('enable_custom_root_server'),
                     tField('enable_dns64'),
                     tField('enable_notify_source_port'),
                     tField('enable_query_source_port'),
                     tField('enable_secondary_notify'),
                     tField('enable_nxdomain_redirect'),
                     tField('nxdomain_log_query'),
                     tField('excluded_servers'),
                     tField('expire'),
                     tField('forwarders_only'),
                     tField('host_rrset_order'),
                     tField('preserve_host_rrset_order_on_secondaries'),
                     tField('negative_ttl'),
                     tField('notify_delay'),
                     tField('notify_source_port'),
                     tField('nxdomain_redirect_addresses'),
                     tField('nxdomain_redirect_addresses_v6'),
                     tField('ns_groups'),
                     tField('query_source_port'),
                     tField('recursion_enabled'),
                     tField('refresh'),
                     tField('retry'),
                     tField('syslog_facility'),
                     tField('zone_transfer_format_option'),
                     tField('nxdomain_redirect_ttl'),
                     tField('lame_ttl'),
                     tField('protocol_record_name_policies',
                            {
                             sub_fields =>
                             [
                              tField('policy_name'),
                              tField('policy_regex'),
                              tField('is_grid_default')
                             ],
                             }
                           ),
                     tField('bulk_host_name_templates',
                            {
                             sub_fields =>
                             [
                              tField('template_name'),
                              tField('template_format'),
                              tField('is_grid_default')
                             ],
                            }
                           ),
                     tField('filter_aaaa'),
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
                                                 tField('log_query_rewrite'),
                                                 tField('log_idns_gslb'),
                                                 tField('log_idns_health'),
                                                ]
                                 }
                           ),
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
                     tField('administrative_record_name_policies',
                            {
                             sub_fields =>
                             [
                              tField('check_names_policy'),
                              tField('check_names_for_ddns_and_zone_transfer'),
                              tField('record_name_policy',
                                     {
                                      sub_fields => [tField('policy_name')]
                                     }),
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
                              tField('enable_hsm_signing'),
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
                     tField('transfers_in'),
                     tField('transfers_out'),
                     tField('transfers_per_ns'),
                     tField('serial_query_rate'),
                     tField('max_cache_ttl'),
                     tField('max_cached_lifetime'),
                     tField('max_ncache_ttl'),
                     tField('disable_edns'),
                     tField('query_rewrite_enabled'),
                     tField('query_rewrite_prefix'),
                     tField('query_rewrite_domain_names'),
                     tField('rpz_disable_nsdname_nsip'),
                     tField('fixed_rrset_order_fqdns_enabled'),
                     tField('rpz_qname_wait_recurse'),
                     tField('enable_delete_associated_ptr'),
                     tField('resolver_query_timeout'),
                     tField('bind_hostname_directive'),
                     tField('server_id_directive'),
                     tField('ddns_restrict_patterns_list'),
                     tField('ddns_restrict_patterns'),
                     tField('ddns_restrict_static'),
                     tField('ddns_restrict_protected'),
                     tField('ddns_restrict_secure'),
                     tField('ddns_principal_tracking'),
                     tField('ddns_force_creation_timestamp_update'),
                     tField('ddns_principal_group'),
                     tField('rpz_drop_ip_rule_enabled'),
                     tField('rpz_drop_ip_rule_min_prefix_length_ipv4'),
                     tField('rpz_drop_ip_rule_min_prefix_length_ipv6'),
                     tField('enable_capture_dns_queries'),
                     tField('capture_dns_queries_on_all_domains'),
                     tField('domains_to_capture_dns_queries'),
                     tField('enable_excluded_domain_names'),
                     tField('excluded_domain_names'),
                     tField('enable_capture_dns_responses'),
                     tField('anonymize_response_logging'),
                     tField('store_locally'),
                     tField('dns_query_capture_file_time_limit'),
                     tField('enable_gss_tsig'),
                     tField('dtc_prefer_client_subnet'),
                     tField('dns_health_check_domain_list'),
                     tField('dns_health_check_recursion_flag'),
                     tField('dns_health_check_anycast_control'),
                     tField('dns_health_check_enabled'),
                     tField('dns_health_check_interval'),
                     tField('dns_health_check_retries'),
                     tField('dns_health_check_timeout'),
                     tField('dtc_dns_fall_through_enabled'),
                     tField('dtc_topology_ea_list', {sub_fields => [tField('name')]}),
                     tField('dtc_dnssec_mode'),
                     tField('client_subnet_recursive_enabled'),
                     tField('client_subnet_forwarding_enabled'),
                     tField('client_subnet_source_prefix_length_ipv6'),
                     tField('client_subnet_source_prefix_length_ipv4'),
                     tField('enable_smartcache'),
                     tField('smartcache_expired_record_ttl'),
                     tField('smartcache_expired_record_timeout'),
                    );

    %_searchable_fields = (
		name => [\&ibap_o2i_string ,'name', 'EXACT'],
        grid => [\&ibap_o2i_ignore, 'deprecated', 'DEPRECATED'],
        cluster => [\&ibap_o2i_ignore, 'deprecated', 'DEPRECATED'],
                          );

    %_ibap_to_object=(
        'administrative_record_name_policies' => \&ibap_i2o_record_name_policies,
        'allow_bulkhost_ddns'     => \&__i2o_allow_bulkhost_ddns__,
		'allow_gss_tsig_zone_updates' => \&ibap_i2o_boolean,
        'allow_query'       => \&ibap_i2o_ac_setting,
        'allow_recursive_query' => \&ibap_i2o_ac_setting,
        'allow_transfer'    => \&ibap_i2o_ac_setting,
        'allow_update'      => \&ibap_i2o_ac_setting,
        'allow_update_forwarding' => \&ibap_i2o_boolean,
        'blackhole'           => \&ibap_i2o_ac_setting,
        'filter_aaaa_list'    => \&ibap_i2o_ac_setting,
        'blacklist_log_query' => \&ibap_i2o_boolean,
        'blacklist_rulesets'  => \&ibap_i2o_rulesets_by_names,
        'bulk_host_name_templates' => \&__i2o_bulkhostname_template_list__,
        'dns64_groups'             => \&ibap_i2o_generic_object_list_convert,
		'dnssec'                   => \&ibap_i2o_dnssec_props,
        'dnssec_key_params'        => \&ibap_i2o_dnssec_key_params,
		'dnssec_trusted_keys'      => \&ibap_i2o_dnssec_trusted_keys,
        'double_confirm_zone_deletion' => \&ibap_i2o_boolean,
        'enable_blackhole'        => \&ibap_i2o_boolean,
        'enable_blacklist'        => \&ibap_i2o_boolean,
        'enable_dns64'        => \&ibap_i2o_boolean,
        'enable_secondary_notify' => \&ibap_i2o_boolean,
        'enable_nxdomain_redirect' => \&ibap_i2o_boolean,
        'nxdomain_log_query'      => \&ibap_i2o_boolean,
        'forwarders_only'         => \&ibap_i2o_boolean,
        gss_tsig_keys           => \&ibap_i2o_generic_object_list_convert,
        'host_rrset_order'        => \&ibap_i2o_boolean,
        'preserve_host_rrset_order_on_secondaries' => \&ibap_i2o_boolean,
		'logging_categories'      => \&ibap_i2o_logging_categories,
        'ns_groups'               => \&__i2o_nsgroups__,
        'protocol_record_name_policies' => \&__i2o_protocol_record_name_policy__,
        'recursion_enabled'      =>\&ibap_i2o_boolean,
		'root_name_servers'       => \&__i2o_ns__,
        'sort_lists'              => \&ibap_i2o_sort_list,
        'syslog_facility'         => \&ibap_i2o_enums_lc_or_undef,
        'zone_transfer_format_option' => \&ibap_i2o_transfer_format,
        'enable_custom_root_server' => \&ibap_i2o_boolean,
        'enable_notify_source_port' => \&ibap_i2o_boolean,
        'enable_query_source_port'  => \&ibap_i2o_boolean,
        'nxdomain_rulesets'         => \&ibap_i2o_rulesets_by_names,
        'copy_xfer_to_notify'       => \&ibap_i2o_boolean,

        'fixed_rrset_order_fqdns'         => \&ibap_i2o_generic_object_list_convert,
        'fixed_rrset_order_fqdns_enabled' => \&ibap_i2o_boolean,

        'enable_delete_associated_ptr' => \&ibap_i2o_boolean,
        'restart_setting' => \&ibap_i2o_generic_object_convert,
        'auto_blackhole'         => \&ibap_i2o_generic_object_convert,
        'attack_mitigation'      => \&ibap_i2o_generic_object_convert,
        'response_rate_limiting' => \&ibap_i2o_generic_object_convert,
        'ddns_principal_group'   => \&ibap_i2o_generic_object_convert,
        'reclamation_settings' => \&ibap_i2o_generic_object_convert,
        'enable_capture_dns_queries'         => \&ibap_i2o_boolean,
        'capture_dns_queries_on_all_domains' => \&ibap_i2o_boolean,
        'transfer_settings'                  => \&ibap_i2o_generic_object_convert,
        'enable_capture_dns_responses'       => \&ibap_i2o_boolean,
        'anonymize_response_logging'         => \&ibap_i2o_boolean,
        'store_locally'                      => \&ibap_i2o_boolean,
        'enable_excluded_domain_names'       => \&ibap_i2o_boolean,
        'dtc_topology_ea_list'               => \&ibap_i2o_object_list_names,
        'client_subnet_domains'              => \&ibap_i2o_generic_object_list_convert,
                      );

    %_object_to_ibap=(
        allow_bulkhost_ddns       => \&__o2i_allow_bulkhost_ddns__,
        allow_gss_tsig_zone_updates=> \&ibap_o2i_boolean,
        allow_query               => \&ibap_o2i_ac_setting,
        allow_recursive_query     => \&ibap_o2i_boolean,
        allow_transfer            => \&ibap_o2i_ac_setting,
        allow_update              => \&ibap_o2i_ac_setting,
        blackhole_list            => \&ibap_o2i_ac_setting,
        filter_aaaa               => \&ibap_o2i_enums_lc_or_undef,
        filter_aaaa_list          => \&ibap_o2i_ac_setting,
        blacklist_action          => \&ibap_o2i_string,
        blacklist_log_query       => \&ibap_o2i_boolean,
        blacklist_redirect_addresses => \&ibap_o2i_ipv4addr_list,
        blacklist_redirect_ttl    => \&ibap_o2i_uint,
        blacklist_rulesets        => \&ibap_o2i_rulesets_by_names,
        bind_check_names_policy   => \&ibap_o2i_ignore,
        bulk_host_name_template   => \&ibap_o2i_ignore,
        bulk_host_name_templates  => \&__o2i_bulkhostname_template_list__,
        dns_cache_acceleration_ttl => \&ibap_o2i_uint,
        default_ttl               => \&ibap_o2i_uint,
		dns64_groups              => \&ibap_o2i_dns64groups,
		dnssec_enabled            => \&ibap_o2i_dnssec_props,
		dnssec_expired_signatures_enabled => \&ibap_o2i_ignore,
		dnssec_trusted_keys       => \&ibap_o2i_dnssec_trusted_keys,
		dnssec_validation_enabled => \&ibap_o2i_ignore,
		enable_hsm_signing => \&ibap_o2i_dnssec_props,
        dnssec_blacklist_enabled  => \&ibap_o2i_ignore,
        dnssec_dns64_enabled      => \&ibap_o2i_ignore,
        dnssec_nxdomain_enabled   => \&ibap_o2i_ignore,
        dnssec_rpz_enabled        => \&ibap_o2i_ignore,

        #
        dnssec_ksk_algorithms                    => \&ibap_o2i_dnssec_key_params,
        dnssec_ksk_rollover_interval             => \&ibap_o2i_dnssec_key_params,
        dnssec_signature_expiration              => \&ibap_o2i_dnssec_key_params,
        dnssec_zsk_algorithms                    => \&ibap_o2i_dnssec_key_params,
        dnssec_zsk_rollover_interval             => \&ibap_o2i_dnssec_key_params,
        dnssec_nsec3_salt_min_length             => \&ibap_o2i_dnssec_key_params,
        dnssec_nsec3_salt_max_length             => \&ibap_o2i_dnssec_key_params,
        dnssec_nsec3_iterations                  => \&ibap_o2i_dnssec_key_params,
        dnssec_zsk_rollover_mechanism            => \&ibap_o2i_dnssec_key_params,
        dnssec_enable_ksk_auto_rollover          => \&ibap_o2i_dnssec_key_params,
        dnssec_negative_trust_anchors            => \&ibap_o2i_string_array_undef_to_empty,
        dnssec_ksk_rollover_notification_config  => \&ibap_o2i_dnssec_key_params,
        dnssec_ksk_snmp_notification_enabled     => \&ibap_o2i_dnssec_key_params,
        dnssec_ksk_email_notification_enabled    => \&ibap_o2i_dnssec_key_params,
        next_secure_type                         => \&ibap_o2i_dnssec_key_params,
        #
        dnssec_ksk_algorithm                     => \&ibap_o2i_ignore,
        dnssec_zsk_algorithm                     => \&ibap_o2i_ignore,
        dnssec_ksk_size                          => \&ibap_o2i_ignore,
        dnssec_zsk_size                          => \&ibap_o2i_ignore,

        enable_blackhole          => \&ibap_o2i_boolean,
        enable_blacklist          => \&ibap_o2i_boolean,
        enable_custom_root_server => \&ibap_o2i_boolean,
        enable_dns64              => \&ibap_o2i_boolean,
        enable_host_rrset_order   => \&ibap_o2i_boolean,
        preserve_host_rrset_order_on_secondaries => \&ibap_o2i_boolean,
        enable_notify_source_port => \&ibap_o2i_boolean,
        enable_query_source_port  => \&ibap_o2i_boolean,
        expire_after              => \&ibap_o2i_uint,
        email                     => \&ibap_o2i_string,
        forward_updates           => \&ibap_o2i_boolean,
        forward_only              => \&ibap_o2i_boolean,
        forwarders                => \&ibap_o2i_ipaddr_list,
        gss_tsig_keys             => \&ibap_o2i_gss_tsig_keys,
        host_name_restriction_policy =>\&__o2i_administrative_record_name_policies__,
        logging_categories        => \&ibap_o2i_logging_categories,
        logging_facility          => \&ibap_o2i_enums_lc_or_undef,
        member_secondary_notify   => \&ibap_o2i_boolean,
        negative_ttl              => \&ibap_o2i_uint,
        notify_delay              => \&ibap_o2i_uint,
        notify_source_port        => \&ibap_o2i_integer,
        nsgroups                  => \&__o2i_nsgroups__,
		nsgroup_default           => \&ibap_o2i_ignore,
        query_source_port         => \&ibap_o2i_integer,
        nxdomain_redirect         => \&ibap_o2i_boolean,
        nxdomain_log_query        => \&ibap_o2i_boolean,
        nxdomain_redirect_addresses => \&ibap_o2i_ipaddr_list,
        nxdomain_redirect_addresses_ipv6 => \&ibap_o2i_ipaddr_list,
        record_name_policies      => \&__o2i_protocol_record_name_policies__,
        recursive_query_list      => \&ibap_o2i_ac_setting,
        refresh_timer             => \&ibap_o2i_uint,
        retry_timer               => \&ibap_o2i_uint,
        rootNS                    => \&ibap_o2i_root_ns_list,
        sortlist                  => \&ibap_o2i_sort_list,
        transfer_excluded_servers => \&ibap_o2i_ipaddr_list,
        transfer_format           => \&ibap_o2i_transfer_format,
        zone_deletion_double_confirm => \&ibap_o2i_boolean,
        nxdomain_redirect_ttl        => \&ibap_o2i_uint,
        nxdomain_rulesets         => \&ibap_o2i_rulesets_by_names,
        lame_ttl                  => \&ibap_o2i_uint,
        copy_xfer_to_notify       => \&ibap_o2i_boolean,
        transfers_in              => \&ibap_o2i_uint,
        transfers_out             => \&ibap_o2i_uint,
        transfers_per_ns          => \&ibap_o2i_uint,
        serial_query_rate         => \&ibap_o2i_uint,
        max_cache_ttl             => \&ibap_o2i_uint,
        max_cached_lifetime       => \&ibap_o2i_uint,
        max_ncache_ttl             => \&ibap_o2i_uint,
        disable_edns              => \&ibap_o2i_boolean,
        enable_query_rewrite      => \&ibap_o2i_boolean,
        query_rewrite_prefix      => \&ibap_o2i_string,
        query_rewrite_domain_names => \&ibap_o2i_string_array_undef_to_empty,
        rpz_disable_nsdname_nsip  => \&ibap_o2i_boolean,

        fixed_rrset_order_fqdns        => \&ibap_o2i_generic_struct_list_convert,
        enable_fixed_rrset_order_fqdns => \&ibap_o2i_boolean,
        rpz_qname_wait_recurse    => \&ibap_o2i_boolean,
        enable_delete_associated_ptr => \&ibap_o2i_boolean,
        restart_setting => \&ibap_o2i_generic_struct_convert,
        'auto_blackhole'         => \&ibap_o2i_generic_struct_convert,
        'attack_mitigation'      => \&ibap_o2i_generic_struct_convert,
        'response_rate_limiting' => \&ibap_o2i_generic_struct_convert,
        'resolver_query_timeout' => \&ibap_o2i_uint,
        'bind_hostname_directive' => \&ibap_o2i_string,
        'server_id_directive' => \&ibap_o2i_string,
        'ddns_restrict_patterns_list' => \&ibap_o2i_string_array_undef_to_empty,
        'ddns_restrict_patterns' => \&ibap_o2i_boolean,
        'ddns_restrict_static' => \&ibap_o2i_boolean,
        'ddns_restrict_protected' => \&ibap_o2i_boolean,
        'ddns_restrict_secure' => \&ibap_o2i_boolean,
        'ddns_principal_tracking' => \&ibap_o2i_boolean,
        'ddns_force_creation_timestamp_update' => \&ibap_o2i_boolean,
        'ddns_principal_group' => \&ibap_o2i_object_by_oid_or_name_undef_ok,
        'scavenging_settings' => \&ibap_o2i_generic_struct_convert,
        'rpz_drop_ip_rule_enabled' => \&ibap_o2i_boolean,
        'rpz_drop_ip_rule_min_prefix_length_ipv4' => \&ibap_o2i_uint,
        'rpz_drop_ip_rule_min_prefix_length_ipv6' => \&ibap_o2i_uint,
        'enable_capture_dns_queries'         => \&ibap_o2i_boolean,
        'capture_dns_queries_on_all_domains' => \&ibap_o2i_boolean,
        'domains_to_capture_dns_queries'     => \&ibap_o2i_string_array_undef_to_empty,
        'file_transfer_setting'              => \&ibap_o2i_generic_struct_convert,
        'enable_excluded_domain_names'         => \&ibap_o2i_boolean,
        'excluded_domain_names'                => \&ibap_o2i_string_array_undef_to_empty,
        'enable_capture_dns_responses'         => \&ibap_o2i_boolean,
        'anonymize_response_logging'           => \&ibap_o2i_boolean,
        'store_locally'                        => \&ibap_o2i_boolean,
        'dns_query_capture_file_time_limit'    => \&ibap_o2i_uint,
        'enable_gss_tsig'                      => \&ibap_o2i_boolean,
        'dtc_edns_prefer_client_subnet' => \&ibap_o2i_boolean,
        'dns_health_check_domain_list'     => \&ibap_o2i_string_array_undef_to_empty,
        'dns_health_check_recursion_flag'  => \&ibap_o2i_boolean,
        'dns_health_check_anycast_control' => \&ibap_o2i_boolean,
        'enable_dns_health_check'          => \&ibap_o2i_boolean,
        'dns_health_check_interval'        => \&ibap_o2i_uint,
        'dns_health_check_retries'         => \&ibap_o2i_uint,
        'dns_health_check_timeout'         => \&ibap_o2i_uint,
        'enable_dtc_dns_fall_through' => \&ibap_o2i_boolean,
        'dtc_dnssec_mode' => \&ibap_o2i_string,
        'dtc_topology_ea_list'          => \&__o2i_eadef_name__,
        'enable_client_subnet_recursive' => \&ibap_o2i_boolean,
        'enable_client_subnet_forwarding' => \&ibap_o2i_boolean,
        'client_subnet_ipv6_prefix_length' => \&ibap_o2i_uint,
        'client_subnet_ipv4_prefix_length' => \&ibap_o2i_uint,
        'client_subnet_domains' => \&ibap_o2i_generic_struct_list_convert,
        enable_ftc => \&ibap_o2i_boolean,
        ftc_expired_record_ttl        => \&ibap_o2i_uint,
        ftc_expired_record_timeout        => \&ibap_o2i_uint,
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
                auto_blackhole         => 'Infoblox::Grid::DNS::AutoBlackHole',
                attack_mitigation      => 'Infoblox::Grid::DNS::AttackMitigation',
                response_rate_limiting => 'Infoblox::Grid::DNS::ResponseRateLimiting',
                ns_groups              => 'Infoblox::Grid::DNS::Nsgroup',
                dns64_groups           => 'Infoblox::Grid::DNS::DNS64Group',
                gss_tsig_keys          => 'Infoblox::Grid::KerberosKey',
                ddns_principal_group   => 'Infoblox::DNS::DDNS::PrincipalCluster::Group',
                reclamation_settings   => 'Infoblox::Grid::DNS::ScavengingSetting',
                transfer_settings      => 'Infoblox::Grid::DNS::FileTransferSetting',
                client_subnet_domains  => 'Infoblox::Grid::DNS::ClientSubnetDomain',
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

        $tmp=Infoblox::Grid::ServiceRestart->__new__();
        push @_return_fields, tField('restart_setting', { sub_fields => $tmp->__return_fields__() });

        $tmp = Infoblox::DNS::DNSSecKeyAlgorithm->__new__();
        push @_return_fields,
            tField('dnssec_key_params', { sub_fields =>
                                 [
                                  tField('ksk_algorithms', {sub_fields => $tmp->__return_fields__()}),
                                  tField('zsk_algorithms', {sub_fields => $tmp->__return_fields__()}),
                                  tField('ksk_rollover'),
                                  tField('signature_expiration'),
                                  tField('zsk_rollover'),
                                  tField('next_secure_type'),
                                  tField('nsec3_salt_min_length'),
                                  tField('nsec3_salt_max_length'),
                                  tField('nsec3_iterations'),
                                  tField('zsk_rollover_mechanism'),
                                  tField('enable_ksk_auto_rollover'),
                                  tField('ksk_rollover_notification_config'),
                                  tField('ksk_snmp_notification_enabled'),
                                  tField('ksk_email_notification_enabled'),
                                 ]
                              }
            );

        $tmp = Infoblox::Grid::DNS::FixedRRSetOrderFQDN->__new__();
        push @_return_fields,
            tField('fixed_rrset_order_fqdns', {sub_fields => $tmp->__return_fields__()});

    }

    $self->{'nxdomain_redirect'} = 'false' unless defined $self->{'nxdomain_redirect'};
    $self->{'nxdomain_redirect_ttl'} = 60 unless defined $self->{'nxdomain_redirect_ttl'};
    $self->{'nxdomain_log_query'} = 'false' unless defined $self->{'nxdomain_log_query'};
    $self->{'blacklist_action'} = 'REFUSE' unless defined $self->{'blacklist_action'};
    $self->{'blacklist_redirect_ttl'} = 60 unless defined $self->{'blacklist_redirect_ttl'};
    $self->{'blacklist_log_query'} = 'false' unless defined $self->{'blacklist_log_query'};
    $self->{'enable_blacklist'} = 'false' unless defined $self->{'enable_blacklist'};
    $self->{'dns64_groups'} = [] unless defined $self->dns64_groups();
    $self->{'dnssec_negative_trust_anchors'} = [] unless defined $self->dnssec_negative_trust_anchors();
    $self->{'client_subnet_domains'} = [] unless defined $self->{'client_subnet_domains'};
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

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'enable_blackhole'}=0 unless defined $$ibap_object_ref{'enable_blackhole'};
    $$ibap_object_ref{'enable_dns64'}=0 unless defined $$ibap_object_ref{'enable_dns64'};
    $$ibap_object_ref{'host_rrset_order'}=0 unless defined $$ibap_object_ref{'host_rrset_order'};
    $$ibap_object_ref{'recursion_enabled'}=0 unless defined $$ibap_object_ref{'recursion_enabled'};
    $$ibap_object_ref{'forwarders_only'}=0 unless defined $$ibap_object_ref{'forwarders_only'};
    $$ibap_object_ref{'allow_update_forwarding'}=0 unless defined $$ibap_object_ref{'allow_update_forwarding'};
    $$ibap_object_ref{'enable_secondary_notify'}=0 unless defined $$ibap_object_ref{'enable_secondary_notify'};
    $$ibap_object_ref{'double_confirm_zone_deletion'}=0 unless defined $$ibap_object_ref{'double_confirm_zone_deletion'};
    $$ibap_object_ref{'allow_gss_tsig_zone_updates'}=0 unless defined $$ibap_object_ref{'allow_gss_tsig_zone_updates'};
    $$ibap_object_ref{'enable_custom_root_server'}=0 unless defined $$ibap_object_ref{'enable_custom_root_server'};
    $$ibap_object_ref{'enable_blacklist'}=0 unless defined $$ibap_object_ref{'enable_blacklist'};
    $$ibap_object_ref{'blacklist_log_query'}=0 unless defined $$ibap_object_ref{'blacklist_log_query'};
    $$ibap_object_ref{'enable_notify_source_port'}=0 unless defined $$ibap_object_ref{'enable_notify_source_port'};
    $$ibap_object_ref{'enable_query_source_port'}=0 unless defined $$ibap_object_ref{'enable_query_source_port'};
    $$ibap_object_ref{'fixed_rrset_order_fqdns_enabled'}=0 unless defined $$ibap_object_ref{'fixed_rrset_order_fqdns_enabled'};

    $$ibap_object_ref{'dnssec'}{'enable_dnssec'}=0 if(defined($$ibap_object_ref{'dnssec'}) && !defined $$ibap_object_ref{'dnssec'}{'enable_dnssec'});
    $$ibap_object_ref{'dnssec'}{'enable_dnssec_validation'}=0 if(defined($$ibap_object_ref{'dnssec'}) && !defined $$ibap_object_ref{'dnssec'}{'enable_dnssec_validation'});
    $$ibap_object_ref{'dnssec'}{'enable_dnssec_expired_signatures'}=0 if(defined($$ibap_object_ref{'dnssec'}) && !defined $$ibap_object_ref{'dnssec'}{'enable_dnssec_expired_signatures'});
    $$ibap_object_ref{'dnssec'}{'enable_hsm_signing'}=0 if(defined($$ibap_object_ref{'dnssec'}) && !defined $$ibap_object_ref{'dnssec'}{'enable_hsm_signing'});
    $$ibap_object_ref{'administrative_record_name_policies'}{'check_names_for_ddns_and_zone_transfer'}=0 if(defined($$ibap_object_ref{'administrative_record_name_policies'}) && !defined $$ibap_object_ref{'administrative_record_name_policies'}{'check_names_for_ddns_and_zone_transfer'});
    $$ibap_object_ref{'enable_nxdomain_redirect'}=0 unless defined $$ibap_object_ref{'enable_nxdomain_redirect'};
    $$ibap_object_ref{'nxdomain_log_query'}=0 unless defined $$ibap_object_ref{'nxdomain_log_query'};
    $$ibap_object_ref{'preserve_host_rrset_order_on_secondaries'}=0 unless defined $$ibap_object_ref{'preserve_host_rrset_order_on_secondaries'};
    $$ibap_object_ref{'copy_xfer_to_notify'}=0 unless defined $$ibap_object_ref{'copy_xfer_to_notify'};
    $$ibap_object_ref{'disable_edns'}=0 unless defined $$ibap_object_ref{'disable_edns'};
    $$ibap_object_ref{'query_rewrite_enabled'}=0 unless defined $$ibap_object_ref{'query_rewrite_enabled'};
    $$ibap_object_ref{'rpz_disable_nsdname_nsip'}=0 unless defined $$ibap_object_ref{'rpz_disable_nsdname_nsip'};
    $$ibap_object_ref{'rpz_qname_wait_recurse'}=0 unless defined $$ibap_object_ref{'rpz_qname_wait_recurse'};
    $$ibap_object_ref{'enable_delete_associated_ptr'}=0 unless defined $$ibap_object_ref{'enable_delete_associated_ptr'};
    $$ibap_object_ref{'rpz_drop_ip_rule_enabled'}=0 unless defined $$ibap_object_ref{'rpz_drop_ip_rule_enabled'};

    $$ibap_object_ref{'ddns_restrict_patterns'} = 0 unless defined $$ibap_object_ref{'ddns_restrict_patterns'};
    $$ibap_object_ref{'ddns_restrict_static'} = 0 unless defined $$ibap_object_ref{'ddns_restrict_static'};
    $$ibap_object_ref{'ddns_restrict_protected'} = 0 unless defined $$ibap_object_ref{'ddns_restrict_protected'};
    $$ibap_object_ref{'ddns_restrict_secure'} = 0 unless defined $$ibap_object_ref{'ddns_restrict_secure'};
    $$ibap_object_ref{'ddns_principal_tracking'} = 0 unless defined $$ibap_object_ref{'ddns_principal_tracking'};
    $$ibap_object_ref{'ddns_force_creation_timestamp_update'} = 0 unless defined $$ibap_object_ref{'ddns_force_creation_timestamp_update'};

    $$ibap_object_ref{'enable_capture_dns_queries'} = 0 unless defined $$ibap_object_ref{'enable_capture_dns_queries'};
    $$ibap_object_ref{'enable_capture_dns_responses'} = 0 unless defined $$ibap_object_ref{'enable_capture_dns_responses'};
    $$ibap_object_ref{'anonymize_response_logging'} = 0 unless defined $$ibap_object_ref{'anonymize_response_logging'};
    $$ibap_object_ref{'store_locally'} = 0 unless defined $$ibap_object_ref{'store_locally'};
    $$ibap_object_ref{'capture_dns_queries_on_all_domains'} = 0 unless defined $$ibap_object_ref{'capture_dns_queries_on_all_domains'};
    $$ibap_object_ref{'enable_excluded_domain_names'} = 0 unless defined $$ibap_object_ref{'enable_excluded_domain_names'};
    $$ibap_object_ref{'enable_gss_tsig'} = 0 unless defined $$ibap_object_ref{'enable_gss_tsig'};
    $$ibap_object_ref{'dtc_prefer_client_subnet'} = 0 unless defined $$ibap_object_ref{'dtc_prefer_client_subnet'};
    $$ibap_object_ref{'dtc_dns_fall_through_enabled'} = 0 unless defined $$ibap_object_ref{'dtc_dns_fall_through_enabled'};

    $$ibap_object_ref{'dns_health_check_recursion_flag'} = 0 unless defined $$ibap_object_ref{'dns_health_check_recursion_flag'};
    $$ibap_object_ref{'dns_health_check_anycast_control'} = 0 unless defined $$ibap_object_ref{'dns_health_check_anycast_control'};
    $$ibap_object_ref{'dns_health_check_enabled'} = 0 unless defined $$ibap_object_ref{'dns_health_check_enabled'};

    $$ibap_object_ref{'client_subnet_recursive_enabled'} = 0 unless defined $$ibap_object_ref{'client_subnet_recursive_enabled'};
    $$ibap_object_ref{'client_subnet_forwarding_enabled'} = 0 unless defined $$ibap_object_ref{'client_subnet_forwarding_enabled'};

    $$ibap_object_ref{'enable_smartcache'}=0 unless defined $$ibap_object_ref{'enable_smartcache'};

	$self->allow_update([]);
	$self->allow_query([]);
	$self->allow_transfer([]);
	$self->sortlist([]);
	$self->recursive_query_list([]);
	$self->dnssec_trusted_keys([]);
    $self->blackhole_list([]);
    $self->filter_aaaa_list([]);
    $self->ddns_restrict_patterns_list([]);
    $self->dns_health_check_domain_list([]);
    $self->dtc_topology_ea_list([]);
    $self->client_subnet_domains([]);
	$self->allow_recursive_query("false");
    $self->enable_blackhole("false");
    $self->enable_host_rrset_order("false");
    $self->preserve_host_rrset_order_on_secondaries("false");
	$self->forward_only("false");
	$self->forward_updates("false");
	$self->member_secondary_notify("false");
	$self->zone_deletion_double_confirm("false");
	$self->allow_gss_tsig_zone_updates("false");
	$self->dnssec_enabled("false");
	$self->dnssec_expired_signatures_enabled("false");

	$self->SUPER::__ibap_to_object__( $ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    #
    $self->{'enable_notify_source_port'} = ibap_value_i2o_boolean($$ibap_object_ref{'enable_notify_source_port'});
    $self->{'enable_query_source_port'} = ibap_value_i2o_boolean($$ibap_object_ref{'enable_query_source_port'});
    $self->{'enable_custom_root_server'} = ibap_value_i2o_boolean($$ibap_object_ref{'enable_custom_root_server'});
    $self->{'enable_fixed_rrset_order_fqdns'} = ibap_value_i2o_boolean($$ibap_object_ref{'fixed_rrset_order_fqdns_enabled'});

    #
    delete $self->{'notify_source_port'} unless $$ibap_object_ref{'enable_notify_source_port'};
    delete $self->{'query_source_port'} unless $$ibap_object_ref{'enable_query_source_port'};
    delete $self->{'rootNS'} unless $$ibap_object_ref{'enable_custom_root_server'};

    return;
}


sub __i2o_allow_bulkhost_ddns__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if ($ibap_object_ref->{$current}=~/REFUSAL/)
    {
        return "false";
    }
    else
    {
        return "true";
    }

}

sub __i2o_bulkhostname_template_list__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}})
    {
        my @obj_list= @{$$ibap_object_ref{$current}};

        foreach my $obj(@obj_list)
        {
            $self->bulk_host_name_template(${$obj}{'template_name'}) if (${$obj}{'is_grid_default'});

            #
            #
            #
            push @newlist,
            Infoblox::Grid::DNS::BulkHostNameTemplate->new
                (
                    template_name => ${$obj}{'template_name'},
                    template_format => ${$obj}{'template_format'}
                );
        }
        return \@newlist;
    }
    else
    {
        return [];
    }
}

sub __i2o_ns__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
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

            push @newlist, Infoblox::Grid::RootNameServer->new(
                'host_name' => ${$addy}{'name'},
                $tempaddr   => ${$addy}{'address'},
                );
        }
        return \@newlist;
    } else {
        return;
    }
}

sub __i2o_nsgroups__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}})
    {
        my @obj_list= @{$$ibap_object_ref{$current}};

        foreach my $obj(@obj_list)
        {

            $self->nsgroup_default(${$obj}{'group_name'}) if (${$obj}{'is_grid_default'});

            my $nsobj = Infoblox::Grid::DNS::Nsgroup->__new__();
            $nsobj->__ibap_to_object__($obj, $session->get_ibap_server(), $session, $return_object_cache_ref);

            push @newlist, $nsobj;
        }
        return \@newlist;
    }
    else
    {
        return [];
    }
}

sub __i2o_protocol_record_name_policy__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}})
    {
        my @obj_list= @{$$ibap_object_ref{$current}};

        foreach my $obj(@obj_list)
        {
            my $name=${$obj}{'policy_name'};
            my $regex=${$obj}{'policy_regex'};
            #
            #
            #
            push @newlist, Infoblox::Grid::RecordNamePolicy->new(
                                                                     name => $name,
                                                                     regex => $regex
                                                                    );
            $self->host_name_restriction_policy($name) if (${$obj}{'is_grid_default'});
        }
        return \@newlist;
    }
    else
    {
        return [];
    }
}


#

sub __o2i_eadef_name__ {

    my ($self, $session, $current, $tempref) = @_;
    if ($$tempref{$current} and ref $$tempref{$current} eq 'ARRAY') {
        my @res;
        foreach my $ead (@{$$tempref{$current}}) {
            push @res, ibap_readfield_simple_string(
                'ExtensibleAttributeDefinition', 'name', $ead, 'ExtensibleAttributeDefinition');
        }

        return (1, 0, tIBType('ArrayOfBaseObject', \@res));
    }

    return (1, 0, tIBType('ArrayOfBaseObject', []));
}


sub __o2i_allow_bulkhost_ddns__
{
    my ($self, $session, $current, $tempref) = @_;
    if ( $tempref->{$current})
    {
        if($tempref->{$current}=~/true/i)
        {
            return (1,0, ibap_value_o2i_string('SUCCESS'));
        }
        elsif($tempref->{$current}=~/false/i)
        {
            return (1,0, ibap_value_o2i_string('REFUSAL'));
        }
        else
        {
            set_error_codes(1012, "Illegal value for allow_bulkhost_ddns",$session);
            return (0);
        }
    }
    else
    {
        return (1,1,undef);
    }

}


sub __o2i_bulkhostname_template_list__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if ( $tempref->{$current})
    {
        my @templates= @{$tempref->{$current}};

        if(@templates)
        {
            my @newlist;
            my $default_template_found = 0;
            foreach my $template(@templates)
            {
                my @sub_write_args;

                push @sub_write_args,
                {
                    field => 'parent',
                    value => tObjIdRef('..')
                };

                #
                my $template_name=ibap_value_o2i_string($template->template_name(),'template_name',$session);
                return (0)  unless $template_name;
                push @sub_write_args,
                {
                    field => 'template_name',
                    value => $template_name
                };

                my $template_format= ibap_value_o2i_string($template->template_format(),'template_format',$session);
                return  (0) unless $template_format;
                push @sub_write_args,
                {
                    field => 'template_format',
                    value => $template_format
                };

                my $is_grid_default = 'false';
                if ($template->template_name() eq $self->bulk_host_name_template())
                {
                    $default_template_found = 1;
                    $is_grid_default = 'true';
                }

                push @sub_write_args,
                {
                    field => 'is_grid_default',
                    value => ibap_value_o2i_boolean($is_grid_default, 'is_grid_default', $session)
                };

                my $temp_obj=
                {
                 object_type => 'BulkHostNameTemplate',
                 write_fields => \@sub_write_args
                };

                push @newlist, $temp_obj;
            }

            if ($default_template_found == 1)
            {
                push @return_args, 1;
                push @return_args, 0;
                push @return_args, tIBType('ArrayOfsub_object', \@newlist);
            }
            else
            {
                push @return_args, 0;
                set_error_codes(1012, "Invalid default bulkhost name template", $session);
            }
        }
        else
        {
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType('ArrayOfsub_object', []);
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

sub __o2i_nsgroups__
{

    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

	if($$tempref{$current} && (ref($$tempref{$current}) eq 'ARRAY'))
	{
		my @nsgroups=@{$$tempref{$current}};
		my @newlist;
                my $default_nsgroup_found = 0;
		foreach my $nsg(@nsgroups)
		{
                    my $is_grid_default = 'false';
                    if ($self->nsgroup_default() && ( $nsg->name() eq $self->nsgroup_default()))
                    {
                        $default_nsgroup_found = 1;
                        $is_grid_default = 'true';
                    }
                    $nsg->{'is_grid_default'} = $is_grid_default;

			my $write_fields=$nsg->__object_to_ibap__($session->get_ibap_server(),$session);
			return (0) if(!$write_fields);

            #
            #
            #
            foreach (@$write_fields) {
                if ($$_{'field'} eq 'grid_primary' && defined $$_{'value'} && defined ${$$_{'value'}}{'readfield_substitution'}) {
                    $$_{'value'} = ${$$_{'value'}}{'readfield_substitution'};
                }
            }

			push @newlist,
			{
				object_type => "NsGroup",
				write_fields => tIBType('ArrayOfwrite_field',$write_fields)
			};
		}

                if ($default_nsgroup_found == 1 || !defined($self->nsgroup_default()) || $self->nsgroup_default() eq "")
                {
                    return (1, 0, tIBType('ArrayOfsub_object', \@newlist));
                }
                else
                {
                    push @return_args, 0;
                    set_error_codes(1012, "Invalid default nsgroup", $session);
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

sub __o2i_protocol_record_name_policies__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if ( $tempref->{$current})
    {
        my @policies= @{$tempref->{$current}};

        if(@policies)
        {
            my @newlist;
            my $default_policy_found = 0;
            foreach my $policy(@policies)
            {
                my @sub_write_args;
                push @sub_write_args,
                {
                    field => 'parent',
                    value => tObjIdRef('..')
                };

                #
                if ($policy->name())
                {
                    my $policy_name=ibap_value_o2i_string($policy->name(),'policy_name',$session);
                    return (0)  unless $policy_name;
                    push @sub_write_args,
                    {
                        field => 'policy_name',
                        value => $policy_name
                    };
                }
                else
                {
                    push @return_args, 0;
                    set_error_codes(1012,"Missing required attribute name for Infoblox::Grid::RecordNamePolicy",$session);
                    return @return_args;
                }

                if ($policy->regex())
                {
                        my $policy_regex= ibap_value_o2i_string($policy->regex(),'policy_regex',$session);
                        return  (0) unless $policy_regex;
                        push @sub_write_args,
                        {
                            field => 'policy_regex',
                            value => $policy_regex
                        };
                }
                else
                {
                    push @return_args, 0;
                    set_error_codes(1012,"Missing required attribute regex for Infoblox::Grid::RecordNamePolicy",$session);
                    return @return_args;
                }

                my $is_grid_default = 'false';
                if ($policy->name() eq $self->host_name_restriction_policy())
                {
                    $is_grid_default = 'true';
                    $default_policy_found = 1;
                }

                push @sub_write_args,
                {
                    field => 'is_grid_default',
                    value => ibap_value_o2i_boolean($is_grid_default, 'is_grid_default', $session)
                };

                my $temp_obj=
                {
                    object_type => 'RecordNamePolicy',
                    write_fields => \@sub_write_args
                };

                push @newlist, $temp_obj;
            }

            if ($default_policy_found == 1)
            {
                push @return_args, 1;
                push @return_args, 0;
                push @return_args, tIBType('ArrayOfsub_object', \@newlist);
            }
            else
            {
                push @return_args, 0;
                set_error_codes(1012, "Invalid host name restriction policy", $session)
            }
        }
        else
        {
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType('ArrayOfsub_object', []);
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


sub __o2i_administrative_record_name_policies__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    my $record_name_policy=$tempref->{"host_name_restriction_policy"};
    my $bind_check_names_policy=$tempref->{"bind_check_names_policy"};

    #
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

sub __object_to_ibap__
{
	my ($self, $server, $session) = @_;
	my %tempref=%{$self};

    my $t = $self->SUPER::__object_to_ibap__($server, $session);

    #
    #
    delete $self->{'__already_done_dnssec__'};
    return $t;
}

#



#

sub allow_bulkhost_ddns
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_bulkhost_ddns', validator => \&ibap_value_o2i_boolean}, @_);
}

sub allow_gss_tsig_zone_updates
{
	my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_gss_tsig_zone_updates', validator => \&ibap_value_o2i_boolean}, @_);
}

sub allow_query
{
    my $self=shift;
    return $self->ibap_accessor_ac_setting('allow_query', 1, {}, @_);
}


sub allow_recursive_query
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_recursive_query', validator => \&ibap_value_o2i_boolean}, @_);
}


sub allow_transfer
{
    my $self=shift;
    return $self->ibap_accessor_ac_setting('allow_transfer', 1, {}, @_);
}


sub allow_update
{
    my $self=shift;
    return $self->ibap_accessor_ac_setting('allow_update', 1, {}, @_);
}

sub blackhole_list
{
    my $self=shift;
    return $self->ibap_accessor_ac_setting('blackhole_list', 0, {}, @_);
}

sub filter_aaaa
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'filter_aaaa', enum => ['YES','NO','BREAK_DNSSEC'] }, @_);
}

sub filter_aaaa_list
{
    my $self=shift;
    return $self->ibap_accessor_ac_setting('filter_aaaa_list', 0, {}, @_);
}

sub enable_blacklist
{
    my $self=shift;
    my $t = $self->__accessor_scalar__({name => 'enable_blacklist', validator => \&ibap_value_o2i_boolean}, @_);
    return $t;
}

sub enable_hsm_signing
{
    my $self=shift;
    my $t = $self->__accessor_scalar__({name => 'enable_hsm_signing', validator => \&ibap_value_o2i_boolean}, @_);
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
    return $self->__accessor_array__({name => 'blacklist_redirect_addresses', validator => \&ibap_value_o2i_ipv4addr}, @_);
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

sub bind_check_names_policy
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'bind_check_names_policy', enum => ["fail","warn"] }, @_);
}


sub bulk_host_name_template
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'bulk_host_name_template', validator => \&ibap_value_o2i_string}, @_);
}


sub bulk_host_name_templates
{
    my $self=shift;
    return $self->__accessor_array__({name => 'bulk_host_name_templates', validator => { 'Infoblox::Grid::DNS::BulkHostNameTemplate' => 1 }}, @_);
}


sub default_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'default_ttl', validator => \&ibap_value_o2i_uint}, @_);
}

sub dns_cache_acceleration_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_cache_acceleration_ttl', validator => \&ibap_value_o2i_uint}, @_);
}

sub dnssec_enabled
{
	my $self=shift;
    return $self->__accessor_scalar__({name => 'dnssec_enabled', validator => \&ibap_value_o2i_boolean}, @_);
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

sub dnssec_ksk_algorithm
{
    my $self = shift;
    return $self->dnssec_algorithm_size_accessor('dnssec_ksk_algorithm', @_);
}
sub dnssec_ksk_algorithms
{
    my $self = shift;
    return $self->__accessor_array__({name => 'dnssec_ksk_algorithms', validator => {'Infoblox::DNS::DNSSecKeyAlgorithm' => 1}}, @_);
}
sub dnssec_ksk_rollover_interval
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dnssec_ksk_rollover_interval', validator => \&ibap_value_o2i_long}, @_);
}
sub dnssec_ksk_size
{
    my $self = shift;
    return $self->dnssec_algorithm_size_accessor('dnssec_ksk_size', @_);
}
sub dnssec_signature_expiration
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dnssec_signature_expiration', validator => \&ibap_value_o2i_long}, @_);
}
sub dnssec_zsk_algorithm
{
    my $self = shift;
    return $self->dnssec_algorithm_size_accessor('dnssec_zsk_algorithm', @_);
}
sub dnssec_zsk_algorithms
{
    my $self = shift;

    return $self->__accessor_array__({name => 'dnssec_zsk_algorithms', validator => {'Infoblox::DNS::DNSSecKeyAlgorithm' => 1}}, @_);
}
sub dnssec_zsk_rollover_interval
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dnssec_zsk_rollover_interval', validator => \&ibap_value_o2i_long}, @_);
}
sub dnssec_zsk_size
{
    my $self = shift;
    return $self->dnssec_algorithm_size_accessor('dnssec_zsk_size', @_);
}

sub dnssec_nsec3_salt_min_length
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dnssec_nsec3_salt_min_length', validator => \&ibap_value_o2i_uint}, @_);
}

sub dnssec_nsec3_salt_max_length
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dnssec_nsec3_salt_max_length', validator => \&ibap_value_o2i_uint}, @_);
}

sub dnssec_nsec3_iterations
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dnssec_nsec3_iterations', validator => \&ibap_value_o2i_uint}, @_);
}

sub dnssec_zsk_rollover_mechanism
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dnssec_zsk_rollover_mechanism', enum => [ 'DOUBLE_SIGN', 'PRE_PUBLISH' ]}, @_);
}

sub dnssec_enable_ksk_auto_rollover
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dnssec_enable_ksk_auto_rollover', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dnssec_negative_trust_anchors
{
    my $self=shift;
    return $self->__accessor_array__({name => 'dnssec_negative_trust_anchors', validator => \&ibap_value_o2i_string}, @_);
}

sub dnssec_ksk_rollover_notification_config
{
    my $self=shift;
    return  $self->__accessor_scalar__({name => 'dnssec_ksk_rollover_notification_config', enum => [ 'NONE', 'ALL', 'REQUIRE_MANUAL_INTERVENTION' ]}, @_);
}

sub dnssec_ksk_snmp_notification_enabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dnssec_ksk_snmp_notification_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dnssec_ksk_email_notification_enabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dnssec_ksk_email_notification_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}
sub next_secure_type
{
    my $self = shift;

    if (($self->{__dnssec_ksk_algorithm__} || $self->{__dnssec_zsk_algorithm__}) && @_ && $_[0]) {
        set_error_codes(1105, 'You cannot set next_secure_type to a defined value when ' .
                              'any of dnssec_ksk_algorithm and dnssec_zsk_algorithm ' .
                              'is set to a defined value.');
        return undef;
    }

    return $self->__accessor_scalar__({name => 'next_secure_type', enum => ['NSEC', 'NSEC3']}, @_);
}
sub email
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'email', validator => \&ibap_value_o2i_string}, @_);
}

sub enable_blackhole
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_blackhole', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_host_rrset_order
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_host_rrset_order', validator => \&ibap_value_o2i_boolean}, @_);
}

sub preserve_host_rrset_order_on_secondaries
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'preserve_host_rrset_order_on_secondaries', validator => \&ibap_value_o2i_boolean}, @_);
}

sub expire_after
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'expire_after', validator => \&ibap_value_o2i_uint}, @_);
}

sub forwarders
{
    my $self=shift;
    return $self->__accessor_array__({name => 'forwarders', validator => \&ibap_value_o2i_string}, @_);
}

sub forward_only
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'forward_only', validator => \&ibap_value_o2i_boolean}, @_);
}


sub forward_updates
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'forward_updates', validator => \&ibap_value_o2i_boolean}, @_);
}

sub gss_tsig_keys {
    my $self=shift;
    return $self->__accessor_array__({name => 'gss_tsig_keys', validator => {'Infoblox::Grid::KerberosKey' => 1 }}, @_);
}

sub host_name_restriction_policy
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'host_name_restriction_policy', validator => \&ibap_value_o2i_string}, @_);
}

sub logging_categories
{
    my $self=shift;
    return $self->__accessor_array__({name => 'logging_categories', enum => \@allowed_logging_categories}, @_);
}


sub logging_facility
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'logging_facility', enum => [ 'daemon', 'local0', 'local1', 'local2', 'local3', 'local4', 'local5', 'local6', 'local7' ] }, @_);
}


sub member_secondary_notify
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'member_secondary_notify', validator => \&ibap_value_o2i_boolean}, @_);
}

sub nxdomain_redirect
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'nxdomain_redirect', validator => \&ibap_value_o2i_boolean}, @_);
}

sub nxdomain_log_query
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'nxdomain_log_query', validator => \&ibap_value_o2i_boolean}, @_);
}

sub negative_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'negative_ttl', validator => \&ibap_value_o2i_uint}, @_);
}


sub notify_source_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'notify_source_port', validator => \&ibap_value_o2i_int, use => \$self->{'enable_notify_source_port'}}, @_);

}

sub notify_delay
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'notify_delay', validator => \&ibap_value_o2i_uint}, @_);

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

sub nsgroup_default
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'nsgroup_default', validator => \&ibap_value_o2i_string}, @_);
}


sub nsgroups
{
    my $self=shift;
    return $self->__accessor_array__({name => 'nsgroups', validator => { 'Infoblox::Grid::DNS::Nsgroup' => 1 }}, @_);
}


sub query_source_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'query_source_port', validator => \&ibap_value_o2i_int, use => \$self->{'enable_query_source_port'}}, @_);
}


sub record_name_policies
{
    my $self=shift;
    return $self->__accessor_array__({name => 'record_name_policies', validator => { 'Infoblox::Grid::RecordNamePolicy' => 1 }}, @_);
}

sub recursive_query_list
{
    my $self=shift;
    return $self->ibap_accessor_ac_setting('recursive_query_list', 1, {}, @_);
}

sub refresh_timer
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'refresh_timer', validator => \&ibap_value_o2i_uint}, @_);
}


sub retry_timer
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'retry_timer', validator => \&ibap_value_o2i_uint}, @_);
}


sub rootNS
{
    my $self=shift;
    return $self->__accessor_array__({name => 'rootNS', validator => { 'Infoblox::Grid::RootNameServer' => 1 }, use => \$self->{'enable_custom_root_server'}}, @_);
}


sub sortlist
{
    my $self=shift;
    return $self->__accessor_array__({name => 'sortlist', validator => { 'Infoblox::DNS::Sortlist' => 1 }}, @_);
}


sub transfer_excluded_servers
{
    my $self=shift;
    return $self->__accessor_array__({name => 'transfer_excluded_servers', validator => \&ibap_value_o2i_string}, @_);
}


sub transfer_format
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'transfer_format', enum => [ 'many_answers', 'one_answer' ] }, @_);
}


sub zone_deletion_double_confirm
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'zone_deletion_double_confirm', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_dns64
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_dns64', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dns64_groups
{
    my $self=shift;
    return $self->__accessor_array__({name => 'dns64_groups', validator => { 'Infoblox::Grid::DNS::DNS64Group' => 1 }}, @_);
}

sub lame_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'lame_ttl', validator => \&ibap_value_o2i_uint}, @_);
}

sub copy_xfer_to_notify
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'copy_xfer_to_notify', validator => \&ibap_value_o2i_boolean}, @_);
}

sub max_cached_lifetime
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'max_cached_lifetime', validator => \&ibap_value_o2i_uint}, @_);
}

package Infoblox::Grid::DNS::FixedRRSetOrderFQDN;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             @_return_fields
             $_object_type
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'fixed_rrset_order_fqdn';
    register_wsdl_type('ib:fixed_rrset_order_fqdn', 'Infoblox::Grid::DNS::FixedRRSetOrderFQDN');

    %_allowed_members = (
                         'fqdn'        => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'record_type' => {simple => 'asis', enum => ['A', 'AAAA', 'BOTH']},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('fqdn'),
                       tField('record_type'),
    );

    %_object_to_ibap = (
                        fqdn        => \&ibap_o2i_string,
                        record_type => \&ibap_o2i_string,
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

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

package Infoblox::Grid::DNS::AttackDetect;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             $_return_fields_initialized
             @_return_fields
             $_object_type
             %_ibap_to_object
             %_name_mappings
             %_reverse_name_mappings
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'dns_attack_detect';
    register_wsdl_type('ib:dns_attack_detect', 'Infoblox::Grid::DNS::AttackDetect');

    %_allowed_members = (
                         'enable'        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'high'          => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'interval_max'  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'interval_min'  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'interval_time' => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'low'           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('enable'),
                       tField('high'),
                       tField('interval_max'),
                       tField('interval_min'),
                       tField('interval_time'),
                       tField('low'),
    );

    %_ibap_to_object = (
                        'enable' => \&ibap_i2o_boolean,
    );

    %_object_to_ibap = (
                        'enable'        => \&ibap_o2i_boolean,
                        'high'          => \&ibap_o2i_uint,
                        'interval_max'  => \&ibap_o2i_uint,
                        'interval_min'  => \&ibap_o2i_uint,
                        'interval_time' => \&ibap_o2i_uint,
                        'low'           => \&ibap_o2i_uint,
    );

    $_return_fields_initialized = 0;
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

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'enable'} = 0 unless defined $$ibap_object_ref{'enable'};
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::DNS::AttackMitigation;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             $_return_fields_initialized
             @_return_fields
             $_object_type
             %_ibap_to_object
             %_name_mappings
             %_reverse_name_mappings
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'dns_attack_mitigation';
    register_wsdl_type('ib:dns_attack_mitigation', 'Infoblox::Grid::DNS::AttackMitigation');

    %_allowed_members = (
                         'detect_chr'                => {validator => {'Infoblox::Grid::DNS::AttackDetect' => 1}},
                         'detect_chr_grace'          => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'detect_nxdomain_responses' => {validator => {'Infoblox::Grid::DNS::AttackDetect' => 1}},
                         'detect_udp_drop'           => {validator => {'Infoblox::Grid::DNS::AttackDetect' => 1}},
                         'interval'                  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'mitigate_nxdomain_lru'     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('detect_chr_grace'),
                       tField('interval'),
                       tField('mitigate_nxdomain_lru'),
    );

    %_ibap_to_object = (
                        'detect_chr'                => \&ibap_i2o_generic_object_convert,
                        'detect_nxdomain_responses' => \&ibap_i2o_generic_object_convert,
                        'detect_udp_drop'           => \&ibap_i2o_generic_object_convert,
                        'mitigate_nxdomain_lru'     => \&ibap_i2o_boolean,
    );

    %_object_to_ibap = (
                        'detect_chr'                => \&ibap_o2i_generic_struct_convert,
                        'detect_chr_grace'          => \&ibap_o2i_uint,
                        'detect_nxdomain_responses' => \&ibap_o2i_generic_struct_convert,
                        'detect_udp_drop'           => \&ibap_o2i_generic_struct_convert,
                        'interval'                  => \&ibap_o2i_uint,
                        'mitigate_nxdomain_lru'     => \&ibap_o2i_boolean,
    );

    $_return_fields_initialized = 0;
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

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{mitigate_nxdomain_lru} = 0 unless defined $$ibap_object_ref{mitigate_nxdomain_lru};


    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        foreach ('detect_chr', 'detect_nxdomain_responses', 'detect_udp_drop') {

            my $t = Infoblox::Grid::DNS::AttackDetect->__new__();
            push @_return_fields,
                tField($_, {sub_fields => $t->__return_fields__()});
        }
    }
}

package Infoblox::Grid::DNS::ResponseRateLimiting;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             $_return_fields_initialized
             @_return_fields
             $_object_type
             %_ibap_to_object
             %_name_mappings
             %_reverse_name_mappings
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'response_rate_limiting';
    register_wsdl_type('ib:response_rate_limiting', 'Infoblox::Grid::DNS::ResponseRateLimiting');

    %_allowed_members = (
                         'enable_rrl'           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'log_only'             => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'responses_per_second' => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'slip'                 => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'window'               => {simple => 'asis', validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('enable_rrl'),
                       tField('log_only'),
                       tField('responses_per_second'),
                       tField('slip'),
                       tField('window'),
    );

    %_ibap_to_object = (
                        'enable_rrl' => \&ibap_i2o_boolean,
                        'log_only'   => \&ibap_i2o_boolean,
    );

    %_object_to_ibap = (
                        'enable_rrl'            => \&ibap_o2i_boolean,
                        'log_only'             => \&ibap_o2i_boolean,
                        'responses_per_second' => \&ibap_o2i_uint,
                        'slip'                 => \&ibap_o2i_uint,
                        'window'               => \&ibap_o2i_uint,
    );

    $_return_fields_initialized = 0;
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

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach ('enable_rrl', 'log_only') {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

package Infoblox::Grid::DNS::AutoBlackHole;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             $_return_fields_initialized
             @_return_fields
             $_object_type
             %_ibap_to_object
             %_name_mappings
             %_reverse_name_mappings
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'auto_blackhole';
    register_wsdl_type('ib:auto_blackhole', 'Infoblox::Grid::DNS::AutoBlackHole');

    %_allowed_members = (
                         'enable_fetches_per_server' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_fetches_per_zone'   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_holddown'           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'fetches_per_server'        => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'fetches_per_zone'          => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'fps_freq'                  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'holddown'                  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'holddown_threshold'        => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'holddown_timeout'          => {simple => 'asis', validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('enable_fetches_per_server'),
                       tField('enable_fetches_per_zone'),
                       tField('enable_holddown'),
                       tField('fetches_per_server'),
                       tField('fetches_per_zone'),
                       tField('fps_freq'),
                       tField('holddown'),
                       tField('holddown_threshold'),
                       tField('holddown_timeout'),
    );

    %_ibap_to_object = (
                         'enable_fetches_per_server' => \&ibap_i2o_boolean,
                         'enable_fetches_per_zone'   => \&ibap_i2o_boolean,
                         'enable_holddown'           => \&ibap_i2o_boolean,
    );

    %_object_to_ibap = (
                        'enable_fetches_per_server' => \&ibap_o2i_boolean,
                        'enable_fetches_per_zone'   => \&ibap_o2i_boolean,
                        'enable_holddown'           => \&ibap_o2i_boolean,
                        'fetches_per_server'        => \&ibap_o2i_uint,
                        'fetches_per_zone'          => \&ibap_o2i_uint,
                        'fps_freq'                  => \&ibap_o2i_uint,
                        'holddown'                  => \&ibap_o2i_uint,
                        'holddown_threshold'        => \&ibap_o2i_uint,
                        'holddown_timeout'          => \&ibap_o2i_uint,
    );

    $_return_fields_initialized = 0;
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

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
             'enable_fetches_per_server',
             'enable_fetches_per_zone',
             'enable_holddown',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::DNS::ScavengingSetting;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            $_object_type
            $_return_fields_initializd
            $_return_fields_initialized
            %_allowed_members
            %_name_mappings
            %_reverse_name_mappings
            %_ibap_to_object
            %_object_to_ibap
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'reclamation_settings';
    register_wsdl_type('ib:reclamation_settings', 'Infoblox::Grid::DNS::ScavengingSetting');



    %_allowed_members = (
                         'ea_expression_list'          => {array => 1, validator => {'Infoblox::Grid::EAExpressionOp' => 1}},
                         'enable_auto_reclamation'     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_recurrent_scavenging' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_rr_last_queried'      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_scavenging'           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_zone_last_queried'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'expression_list'             => {array => 1, validator => {'Infoblox::Grid::ExpressionOp' => 1}},
                         'reclaim_associated_records'  => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'scavenging_schedule'         => {validator => {'Infoblox::Grid::ScheduleSetting' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'enable_recurrent_scavenging' => 'enable_recurrent_reclamation',
                       'enable_scavenging'           => 'enable_reclamation',
                       'scavenging_schedule'         => 'reclamation_schedule',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'ea_expression_list'   => \&ibap_i2o_generic_object_list_convert,
                        'expression_list'      => \&ibap_i2o_generic_object_list_convert,
                        'reclamation_schedule' => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                        'ea_expression_list'          => \&ibap_o2i_generic_struct_list_convert,
                        'enable_auto_reclamation'     => \&ibap_o2i_boolean,
                        'enable_recurrent_scavenging' => \&ibap_o2i_boolean,
                        'enable_rr_last_queried'      => \&ibap_o2i_boolean,
                        'enable_scavenging'           => \&ibap_o2i_boolean,
                        'enable_zone_last_queried'    => \&ibap_o2i_boolean,
                        'expression_list'             => \&ibap_o2i_generic_struct_list_convert,
                        'reclaim_associated_records'  => \&ibap_o2i_boolean,
                        'scavenging_schedule'         => \&ibap_o2i_generic_struct_convert,
    );

    @_return_fields = (
                       tField('enable_reclamation'),
                       tField('enable_rr_last_queried'),
                       tField('enable_zone_last_queried'),
                       tField('enable_recurrent_reclamation'),
                       tField('enable_auto_reclamation'),
                       tField('reclaim_associated_records'),
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
                'reclamation_schedule' => 'Infoblox::Grid::ScheduleSetting',
                'expression_list'      => 'Infoblox::Grid::ExpressionOp',
                'ea_expression_list'   => 'Infoblox::Grid::EAExpressionOp',
        );

        foreach (keys %tmp) {
            $tmp = $tmp{$_}->__new__();
            push @_return_fields, tField($_, {sub_fields => $tmp->__return_fields__()});
        }
    }
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
             'enable_reclamation',
             'enable_recurrent_reclamation',
             'enable_auto_reclamation',
             'reclaim_associated_records',
             'enable_rr_last_queried',
             'enable_zone_last_queried',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    foreach (
        'expression_list',
        'ea_expression_list',
    ) {
        $self->{$_} = [];
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::DNS::ScavengingTask;

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
            %_return_field_overrides
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    $_object_type = 'ReclamationTask';
    register_wsdl_type('ib:ReclamationTask', 'Infoblox::Grid::DNS::ScavengingTask');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 0,
    );

    %_allowed_members = (
                         'associated_object'   => {readonly => 1, validator => {
                                                                                'Infoblox::Grid::DNS' => 1,
                                                                                'Infoblox::DNS::View' => 1,
                                                                                'Infoblox::DNS::Zone' => 1,
                                                  }},
                         'start_time'          => {readonly => 1},
                         'end_time'            => {readonly => 1},
                         'status'              => {simple => 'asis', readonly => 1, enum => ['CREATED', 'RUNNING', 'COMPLETED', 'ERROR']},
                         'action'              => {simple => 'asis', readonly => 1, enum => ['ANALYZE', 'RECLAIM', 'ANALYZE_RECLAIM', 'RECURRING', 'RESET']},
                         'reclaimed_records'   => {simple => 'asis', readonly => 1},
                         'reclaimable_records' => {simple => 'asis', readonly => 1},
                         'processed_records'   => {simple => 'asis', readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'associated_object' => 'parent',
    );

    %_searchable_fields = (
                           'associated_object'  => [\&ibap_o2i_object_only_by_oid, 'parent', 'EXACT'],
                           'action'             => [\&ibap_o2i_string, 'action', 'EXACT'],
                           'status'             => [\&ibap_o2i_string, 'status', 'EXACT'],
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'parent'     => \&ibap_i2o_generic_object_convert_partial,
                        'start_time' => \&ibap_i2o_datetime_to_unix_timestamp,
                        'end_time'   => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    @_return_fields = (
                       tField('parent', {
                               sub_fields => [
                                   tField('dns_fqdn', {
                                           not_exist_ok => 1
                                   }),
                                   tField('view', {
                                       not_exist_ok => 1,
                                       sub_fields   => [
                                           tField('name')
                                       ]
                                   }),
                                   tField('name', {
                                           not_exist_ok => 1
                                   }),
                                   tField('comment', {
                                       not_exist_ok => 1
                                   }),
                                ],
                       }),
                       tField('start_time'),
                       tField('end_time'),
                       tField('status'),
                       tField('action'),
                       tField('reclaimed_records'),
                       tField('reclaimable_records'),
                       tField('processed_records'),
    );

    %_return_field_overrides = (
                                'associated_object'   => [],
                                'start_time'          => [],
                                'end_time'            => [],
                                'status'              => [],
                                'action'              => [],
                                'reclaimed_records'   => [],
                                'reclaimable_records' => [],
                                'processed_records'   => [],
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


package Infoblox::Grid::DNS::FileTransferSetting;

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
            %_object_to_ibap
            %_name_mappings
            %_reverse_name_mappings
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'transfer_setting';
    register_wsdl_type('ib:transfer_setting', 'Infoblox::Grid::DNS::FileTransferSetting');

    %_allowed_members = (
                         'directory' => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'host'      => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'password'  => {writeonly => 1, validator => \&ibap_value_o2i_string},
                         'type'      => {simple => 'asis', enum => ['FTP', 'SCP', 'NONE']},
                         'username'  => {simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       type => 'transfer_type',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_object_to_ibap = (
                        'directory' => \&ibap_o2i_string,
                        'type'      => \&ibap_o2i_string,
                        'host'      => \&ibap_o2i_string,
                        'username'  => \&ibap_o2i_string,
                        'password'  => \&ibap_o2i_string_skip_undef,
    );


    @_return_fields = (
                       tField('directory'),
                       tField('transfer_type'),
                       tField('host'),
                       tField('username'),
    );
};

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

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}


package Infoblox::Grid::DNS::ClientSubnetDomain;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            $_object_type
            %_allowed_members
            %_object_to_ibap
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'client_subnet_domain';
    register_wsdl_type('ib:client_subnet_domain', 'Infoblox::Grid::DNS::ClientSubnetDomain');


    %_allowed_members = (
                         'domain'     => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'permission' => {simple => 'asis', enum => ['ALLOW', 'DENY']},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'domain'     => \&ibap_o2i_string,
                        'permission' => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('domain'),
                       tField('permission'),
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

1;
