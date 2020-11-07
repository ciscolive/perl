package Infoblox::DNS::Zone;

use strict;
use Carp;

use Infoblox::IBAPBase;
use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw( @ISA
             %_filter_fields
             %_unique_members
             %_allowed_members
             %_searchable_fields
             %_object_to_ibap
             %_name_mappings
             @_return_fields
             $_return_fields_initialized
             %_ibap_to_object
             %_reverse_name_mappings
             %_return_field_overrides
             %_capabilities
             %_dnssec_defaults
             %_lazy_return_fields );
@ISA = qw (Infoblox::IBAPBase);

BEGIN {

    register_wsdl_type('ib:StubZone','Infoblox::DNS::Zone');
    register_wsdl_type('ib:AuthZone','Infoblox::DNS::Zone');
    register_wsdl_type('ib:DelegatedZone','Infoblox::DNS::Zone');
    register_wsdl_type('ib:ForwardZone','Infoblox::DNS::Zone');
    register_wsdl_type('ib:ResponsePolicyZone','Infoblox::DNS::Zone');
    #

    %_capabilities = (
                      'depth'                  => 0,
                      'implicit_defaults'      => 1,
                      'single_serialization' => 1,
                     );

    %_unique_members = (
                        delegate_to               => 'DelegatedZone',
                        delegation_ns_group       => 'DelegatedZone',
                        forward_to                => 'ForwardZone',
                        members                   => 'ForwardZone',
                        forward_ns_group          => 'ForwardZone',
                        forward_external_ns_group => 'ForwardZone',
                        primary                   => 'AuthZone', # or ResponsePolicyZone
                        multiple_primaries        => 'AuthZone', # or ResponsePolicyZone
                        secondaries               => 'AuthZone', # or ResponsePolicyZone
                        stub_members              => 'StubZone',
                        stub_ns_group             => 'StubZone',
                        stub_external_ns_group    => 'StubZone',

                       );

    %_ibap_to_object = (
                        'allow_active_dir'                              => \&ibap_i2o_address_ac_list,
                        'allow_gss_tsig_for_underscore_zone'            => \&ibap_i2o_boolean,
                        'allow_gss_tsig_zone_updates'                   => \&ibap_i2o_boolean,
                        'allow_query'                                   => \&ibap_i2o_ac_setting,
                        'allow_transfer'                                => \&ibap_i2o_ac_setting,
                        'allow_update'                                  => \&ibap_i2o_ac_setting,
                        'create_underscore_zones'                       => \&ibap_i2o_boolean,
                        'delegate_to'                                   => \&ibap_i2o_nameserver,
                        'enable_rfc2317_exclusion'                      => \&ibap_i2o_boolean,
                        'external_primaries'                            => \&ibap_i2o_nameserver,
                        'external_secondaries'                          => \&ibap_i2o_nameserver,
                        'forward_to'                                    => \&ibap_i2o_nameserver,
                        'forwarding_servers'                            => \&ibap_i2o_forwarding_servers,
                        'forwarders_only'                               => \&ibap_i2o_boolean,
                        'grid_primary_shared_with_ms_parent_delegation' => \&ibap_i2o_boolean,
                        'grid_secondaries'                              => \&ibap_i2o_member_nameserver,
                        'is_dnssec_signed'                              => \&ibap_i2o_boolean,
                        'ms_ad_integrated'                              => \&ibap_i2o_boolean,
                        'ms_managed'                                    => \&ibap_i2o_enums_ucfirst_or_undef,
                        'ms_read_only'                                  => \&ibap_i2o_boolean,
                        'ms_sync_disabled'                              => \&ibap_i2o_boolean,
                        'ms_ddns_mode'                                  => \&ibap_i2o_enums_ucfirst_or_undef,
                        'ms_allow_transfer_mode'                        => \&__i2o_ms_transfer__,
                        'ns_group'                                      => \&__i2o_ns_group__,
                        'ns_group_external'                             => \&__i2o_ns_group__,
                        'stub_from'                                     => \&ibap_i2o_nameserver,
                        'stub_members'                                  => \&ibap_i2o_member_nameserver,
                        'update_forwarding'                             => \&ibap_i2o_ac_setting,
                        'disable_forwarding'                            => \&ibap_i2o_boolean,
                        'disabled'                                      => \&ibap_i2o_boolean,
                        'dnssec_key_params'                             => \&ibap_i2o_dnssec_key_params,
                        'dnssec_keys'                                   => \&ibap_i2o_generic_object_list_convert,
                        'dnssec_ksk_rollover_date'                      => \&ibap_i2o_datetime_to_unix_timestamp,
                        'dnssec_zsk_rollover_date'                      => \&ibap_i2o_datetime_to_unix_timestamp,
                        'grid_primaries'                                => \&ibap_i2o_member_nameserver,
                        'is_multimaster'                                => \&ibap_i2o_boolean,
                        'locked'                                        => \&ibap_i2o_boolean,
                        'set_soa_serial_number'                         => \&ibap_i2o_boolean,
                        'ms_primaries'                                  => \&ibap_i2o_dns_msserver_list,
                        'ms_secondaries'                                => \&ibap_i2o_dns_msserver_list,
                        'srgs'                                          => \&__i2o_srgs__,
                        'use_allow_active_dir'                          => \&ibap_i2o_boolean,
                        'use_delegated_ttl'                             => \&ibap_i2o_boolean,
                        'use_grid_zone_timer'                           => \&ibap_i2o_boolean,
                        'stub_msservers'                                => \&ibap_i2o_dns_msserver_list,
                        'use_record_name_policy'                        => \&__i2o_policy__,
                        'use_soa_email'                                 => \&ibap_i2o_boolean,
                        'view'                                          => \&ibap_i2o_generic_object_convert_to_list_of_one,
                        'extensible_attributes'                         => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'last_queried'                                  => \&ibap_i2o_datetime_to_unix_timestamp,
                        'zone_not_queried_enabled_time'                 => \&ibap_i2o_datetime_to_unix_timestamp,
                        'rr_not_queried_enabled_time'                   => \&ibap_i2o_datetime_to_unix_timestamp,
                        'rpz_last_updated_time'                         => \&ibap_i2o_datetime_to_unix_timestamp,
                        'rpz_policy'                                    =>  \&ibap_i2o_enums_uc_or_undef,
                        'rpz_type'                                      =>  \&ibap_i2o_enums_uc_or_undef,
                        'fireeye_rule_mapping'                          =>  \&ibap_i2o_generic_object_convert,
                        'primary_type'                                  =>  \&ibap_i2o_enums_ucfirst_or_undef,
                        'copy_xfer_to_notify'                           => \&ibap_i2o_boolean,
                        'use_copy_xfer_to_notify'                       => \&ibap_i2o_boolean,
                        'soa_mnames'                                    =>  \&__i2o_soa_mnames__,
                        'soa_serials'                                   =>  \&__i2o_soa_serials__,
                        'dns_integrity_check_enabled'                   => \&ibap_i2o_boolean,
                        'dns_integrity_check_verbose_logging'           => \&ibap_i2o_boolean,
                        'dns_integrity_check_member'                    => \&ibap_i2o_member_byhostname,
                        'cloud_info'                                    => \&ibap_i2o_generic_object_convert,
                        'ddns_principal_group'                          => \&ibap_i2o_generic_object_convert,
                        'ddns_restrict_patterns'                        => \&ibap_i2o_boolean,
                        'use_ddns_patterns_restriction'                 => \&ibap_i2o_boolean,
                        'ddns_restrict_static'                          => \&ibap_i2o_boolean,
                        'use_ddns_restrict_static'                      => \&ibap_i2o_boolean,
                        'ddns_restrict_protected'                       => \&ibap_i2o_boolean,
                        'use_ddns_restrict_protected'                   => \&ibap_i2o_boolean,
                        'ddns_restrict_secure'                          => \&ibap_i2o_boolean,
                        'ddns_principal_tracking'                       => \&ibap_i2o_boolean,
                        'ddns_force_creation_timestamp_update'          => \&ibap_i2o_boolean,
                        'use_ddns_principal_security'                   => \&ibap_i2o_boolean,
                        'reclamation_settings'                          => \&ibap_i2o_generic_object_convert,
                        'use_reclamation'                               => \&ibap_i2o_boolean,
                        'override_rpz_drop_ip_rule'                     => \&ibap_i2o_boolean,
                        'rpz_drop_ip_rule_enabled'                      => \&ibap_i2o_boolean,
                        'ms_dc_ns_record_creation'                      => \&ibap_i2o_generic_object_list_convert,
                        'delegation_ns_group'                           => \&__i2o_ns_group__,
                      );

    %_name_mappings = (
                       'ad_servers'                               => 'allow_active_dir',
                       'allow_ptr_creation_in_parent'             => 'enable_rfc2317_exclusion',
                       'bind_check_names_policy'                  => 'effective_check_names_policy',
                       'disable'                                  => 'disabled',
                       'ms_sync_disable'                          => 'ms_sync_disabled',
                       'dnssec_signed'                            => 'is_dnssec_signed',
                       'dnssec_zsk_rollover_interval'             => 'dnssec_key_params',
                       'email'                                    => 'soa_email',
                       'extattrs'                                 => 'extensible_attributes',
                       'dns_email'                                => 'dns_soa_email',
                       'forward_only'                             => 'forwarders_only',
                       'host_name_restriction_policy'             => 'record_name_policy',
                       'members'                                  => 'forwarding_servers',
                       'ms_allow_transfer'                        => 'ms_allow_transfer_mode',
                       'primary_shared_with_ms_parent_delegation' => 'grid_primary_shared_with_ms_parent_delegation',
                       'name'                                     => 'fqdn' ,
                       'dns_name'                                 => 'dns_fqdn',
                       'override_delegated_ttl'                   => 'use_delegated_ttl',
                       'override_grid_email'                      => 'use_soa_email',
                       'override_grid_zone_timer'                 => 'use_grid_zone_timer',
                       'override_serial_number'                   => 'set_soa_serial_number',
                       'secondaries'                              => 'grid_secondaries',
                       'views'                                    => 'view',
                       'zone'                                     => 'parent',
                       'allow_update_forwarding'                  => 'update_forwarding',
                       'shared_record_groups'                     => 'srgs',
                       'enable_ad_servers'                        => 'use_allow_active_dir',
                       'zone_monitored_since'                     => 'zone_not_queried_enabled_time',
                       'resource_record_monitored_since'          => 'rr_not_queried_enabled_time',
                       'override_copy_xfer_to_notify'             => 'use_copy_xfer_to_notify',
                       'member_soa_mnames'                        => 'soa_mnames',
                       'member_soa_serials'                       => 'soa_serials',
                       'dns_integrity_frequency'                  => 'dns_integrity_check_frequency',
                       'dns_integrity_member'                     => 'dns_integrity_check_member',
                       'dns_integrity_verbose_logging'            => 'dns_integrity_check_verbose_logging',
                       'dns_integrity_check_enable'               => 'dns_integrity_check_enabled',
                       'override_ddns_patterns_restriction'     => 'use_ddns_patterns_restriction',
                       'override_ddns_restrict_static'          => 'use_ddns_restrict_static',
                       'override_ddns_restrict_protected'       => 'use_ddns_restrict_protected',
                       'override_ddns_principal_security'       => 'use_ddns_principal_security',
                       'override_scavenging_settings'           => 'use_reclamation',
                       'override_ddns_force_creation_timestamp_update' => 'use_ddns_force_creation_timestamp_update',
                       'scavenging_settings'                    => 'reclamation_settings',
                       'override_rpz_drop_ip_rule'                => 'use_rpz_drop_ip_rule',

                       'stub_external_ns_group'                   => 'ns_group_external',
                       'forward_external_ns_group'                => 'ns_group_external',
                       'stub_ns_group'                            => 'ns_group',
                       'forward_ns_group'                         => 'ns_group',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    $_reverse_name_mappings{'ns_group'}                        = 'ns_group';
    $_reverse_name_mappings{'ns_group_external'}               = 'stub_external_ns_group';

    $_name_mappings{'use_sec_update_forwarding'}               = 'allow_update_forwarding';
    $_name_mappings{'dnssec_ksk_rollover_interval'}            = 'dnssec_key_params';
    $_name_mappings{'dnssec_signature_expiration'}             = 'dnssec_key_params';
    $_name_mappings{'dnssec_zsk_algorithms'}                   = 'dnssec_key_params';
    $_name_mappings{'dnssec_ksk_algorithms'}                   = 'dnssec_key_params';
    $_name_mappings{'dnssec_zsk_rollover_interval'}            = 'dnssec_key_params';
    $_name_mappings{'dnssec_nsec3_salt_min_length'}            = 'dnssec_key_params';
    $_name_mappings{'dnssec_nsec3_salt_max_length'}            = 'dnssec_key_params';
    $_name_mappings{'dnssec_nsec3_iterations'}                 = 'dnssec_key_params';
    $_name_mappings{'dnssec_zsk_rollover_mechanism'}           = 'dnssec_key_params';
    $_name_mappings{'dnssec_enable_ksk_auto_rollover'}         = 'dnssec_key_params';
    $_name_mappings{'dnssec_ksk_rollover_notification_config'} = 'dnssec_key_params';
    $_name_mappings{'dnssec_ksk_snmp_notification_enabled'}    = 'dnssec_key_params';
    $_name_mappings{'dnssec_ksk_email_notification_enabled'}   = 'dnssec_key_params';
    $_name_mappings{'next_secure_type'}                        = 'dnssec_key_params';

    $_reverse_name_mappings{'use_record_name_policy'} = 'bind_check_names_policy';
    $_reverse_name_mappings{'external_secondaries'}   = 'secondaries';
    $_reverse_name_mappings{'external_primaries'}     = 'multiple_primaries';
    $_reverse_name_mappings{'grid_primaries'}         = 'multiple_primaries';
    $_reverse_name_mappings{'ms_primaries'}           = 'multiple_primaries';
    $_reverse_name_mappings{'ms_secondaries'}         = 'secondaries';
    $_reverse_name_mappings{'stub_msservers'}         = 'stub_members';

    #
    #
    %_allowed_members = (
                         ad_servers             => 0,
                         allow_gss_tsig_for_underscore_zone => 0,
                         allow_gss_tsig_zone_updates       => 0,
                         allow_ptr_creation_in_parent => 0,
                         allow_query                   => 0,
                         allow_transfer               => 0,
                         allow_update                   => 0,
                         allow_update_forwarding       => 0,
                         comment                       => 0,
                         create_ptr_for_bulk_hosts    => 0,
                         create_ptr_for_hosts         => 0,
                         create_underscore_zones      => 0,
                         delegate_to                   => 0,
                         delegation_ns_group          => 0,
                         dns_name                     => -1,
                         dns_soa_mname                => -1,
                         dns_email                    => -1,
                         do_host_abstraction          => 0,
                         delegated_ttl                  => 0,
                         disable                       => 0,
                         disable_forwarding           => 0,
                         dnssec_ksk_algorithm         => 0,
                         dnssec_ksk_algorithms        => 0,
                         dnssec_ksk_rollover_interval => 0,
                         dnssec_ksk_size              => 0,
                         dnssec_signature_expiration  => 0,
                         dnssec_signed                => 0,
                         dnssec_zsk_algorithm         => 0,
                         dnssec_zsk_algorithms        => 0,
                         dnssec_zsk_rollover_interval => 0,
                         dnssec_zsk_size              => 0,
                         dnssec_nsec3_salt_min_length    => 0,
                         dnssec_nsec3_salt_max_length    => 0,
                         dnssec_nsec3_iterations         => 0,
                         dnssec_zsk_rollover_mechanism   => 0,
                         dnssec_enable_ksk_auto_rollover => 0,
                         dnssec_keys                     => {validator => {'Infoblox::DNS::DNSSecKey' => 1}, array => 1, skip_accessor => 1},
                         dnssec_ksk_rollover_date        => -1,
                         dnssec_zsk_rollover_date        => -1,
                         dnssec_ksk_rollover_notification_config  => 0,
                         dnssec_ksk_snmp_notification_enabled  => 0,
                         dnssec_ksk_email_notification_enabled  => 0,
                         next_secure_type             => 0,
                         email                           => 0,
                         forward_only                 => 0,
                         forward_to                   => 0,
                         host_name_restriction_policy => 0,
                         import_from                   => 0,
                         locked                       => 0,
                         members                       => 0,
                         ms_ad_integrated             => 0,
                         ms_managed                   => -1,
                         ms_read_only                 => -1,
                         ms_sync_disable              => 0,
                         ms_ddns_mode                 => 0,
                         ms_allow_transfer            => 0,
                         primary_shared_with_ms_parent_delegation => -1,
                         name                           => 1,
                         network_associations         => 0,
                         notify_delay                 => 0,
                         ns_group                       => 0,
                         forward_ns_group               => 0,
                         forward_external_ns_group    => 0,
                         stub_ns_group                   => 0,
                         stub_external_ns_group       => 0,
                         override_delegated_ttl       => 0,
                         override_grid_zone_timer       => 0,
                         override_serial_number       => 0,
                         override_soa_mname           => 0, # MMDNS-1: obsolete member
                         override_grid_email           => 0,
                         prefix                       => 0,
                         primary                       => 0,
                         multiple_primaries           => 0,
                         is_multimaster               => 0,
                         remove_sub_zones               => 0,
                         secondaries                   => 0,
                         shared_record_groups           => 0,
                         soa_default_ttl               => 0,
                         soa_expire                   => 0,
                         soa_mname                       => 0,
                         member_soa_mnames            => {validator => {'Infoblox::DNS::Member::SoaMname' => 1}, array => 1, skip_accessor => 1},
                         member_soa_serials           => -1,
                         soa_negative_ttl               => 0,
                         soa_refresh                   => 0,
                         soa_retry                       => 0,
                         soa_serial_number               => 0,
                         stub_from                       => 0,
                         stub_members                   => 0,
                         enable_ad_servers            => 0,
                         views                           => 0,
                         zone                           => -1,
                         bind_check_names_policy      => 0,
                         extattrs                     => 0,
                         extensible_attributes        => 0,
                         last_queried                 => -1,
                         zone_monitored_since         => -1,
                         resource_record_monitored_since => -1,
                         rpz_policy                   => 0,
                         rpz_type                     => 0,
                         fireeye_rule_mapping         => 0,
                         substitute_name              => 0,
                         rpz_priority                 => -1,
                         rpz_last_updated_time        => -1,
                         is_feed_zone                 => -1,
                         copy_xfer_to_notify          => 0,
                         override_copy_xfer_to_notify => 0,
                         dns_integrity_check_enable     => 0,
                         dns_integrity_frequency        => 0,
                         dns_integrity_member           => 0,
                         dns_integrity_verbose_logging  => 0,
                         is_default                     => 0,
                         rpz_severity                   => 0,
                         cloud_info                     => -1,
                         restart_if_needed              => 0,
                         'ddns_restrict_patterns_list' => {array => 1, simple => 'asis', validator => \&ibap_value_o2i_string,
                                                           use => 'override_ddns_patterns_restriction', use_truefalse => 1,
                                                           use_members => ['ddns_restrict_patterns_list', 'ddns_restrict_patterns']},
                         'ddns_restrict_patterns' => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                      use => 'override_ddns_patterns_restriction', use_truefalse => 1,
                                                      use_members => ['ddns_restrict_patterns_list', 'ddns_restrict_patterns']},
                         'override_ddns_patterns_restriction' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'ddns_restrict_static' => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                    use => 'override_ddns_restrict_static', use_truefalse => 1},
                         'override_ddns_restrict_static' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'ddns_restrict_protected' => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                       use => 'override_ddns_restrict_protected', use_truefalse => 1},
                         'override_ddns_restrict_protected' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'ddns_restrict_secure' => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                    use => 'override_ddns_principal_security', use_truefalse => 1,
                                                    use_members => ['ddns_restrict_secure', 'ddns_principal_tracking', 'ddns_principal_group']},
                         'ddns_principal_tracking' => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                       use => 'override_ddns_principal_security', use_truefalse => 1,
                                                       use_members => ['ddns_restrict_secure', 'ddns_principal_tracking', 'ddns_principal_group']},
                         'ddns_principal_group' => {validator => {'Infoblox::DNS::DDNS::PrincipalCluster::Group' => 1},
                                                    use => 'override_ddns_principal_security', use_truefalse => 1,
                                                    use_members => ['ddns_restrict_secure', 'ddns_principal_tracking', 'ddns_principal_group']},
                         'override_ddns_principal_security' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},

                         'ddns_force_creation_timestamp_update' => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                              use => 'override_ddns_force_creation_timestamp_update', use_truefalse => 1},
                         'override_ddns_force_creation_timestamp_update' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'scavenging_settings' => {validator => {'Infoblox::Grid::DNS::ScavengingSetting' => 1},
                                                    use => 'override_scavenging_settings', use_truefalse => 1},
                         'override_scavenging_settings' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},

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
                         ms_dc_ns_record_creation       => {array => 1, validator => {'Infoblox::Grid::MSServer::DCNSRecordCreation' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'ad_servers'                               => \&ibap_o2i_address_ac_list,
                        'allow_gss_tsig_for_underscore_zone'       => \&ibap_o2i_boolean,
                        'allow_gss_tsig_zone_updates'              => \&ibap_o2i_boolean,
                        'allow_update_forwarding'                  => \&ibap_o2i_ac_setting,
                        'bind_check_names_policy'                  => \&__o2i_bind_policy__,
                        'comment'                                  => \&ibap_o2i_string,
                        'create_underscore_zones'                  => \&ibap_o2i_boolean,
                        'create_ptr_for_bulk_hosts'                => \&ibap_o2i_boolean,
                        'create_ptr_for_hosts'                     => \&ibap_o2i_boolean,
                        'delegate_to'                              => \&__o2i_nameserver__,
                        'delegated_ttl'                            => \&ibap_o2i_uint,
                        'dns_name'                                 => \&ibap_o2i_ignore,
                        'dns_soa_mname'                            => \&ibap_o2i_ignore,
                        'dns_email'                                => \&ibap_o2i_ignore,
                        'disable'                                  => \&ibap_o2i_boolean,
                        'disable_forwarding'                       => \&ibap_o2i_boolean,
                        'do_host_abstraction'                      => \&ibap_o2i_boolean,
                        'email'                                    => \&ibap_o2i_string_skip_undef,
                        'enable_ad_servers'                        => \&ibap_o2i_boolean,
                        'allow_ptr_creation_in_parent'             => \&ibap_o2i_boolean,
                        'forward_to'                               => \&__o2i_nameserver__,
                        'host_name_restriction_policy'             => \&__o2i_record_name_policy__,
                        'import_from'                              => \&ibap_o2i_string,
                        'locked'                                   => \&ibap_o2i_boolean,
                        'members'                                  => \&ibap_o2i_forwarding_servers,
                        'ms_ad_integrated'                         => \&ibap_o2i_boolean,
                        'ms_managed'                               => \&ibap_o2i_ignore,
                        'ms_read_only'                             => \&ibap_o2i_ignore,
                        'ms_sync_disable'                          => \&ibap_o2i_boolean,
                        'ms_ddns_mode'                             => \&ibap_o2i_enums_lc_or_undef,
                        'ms_allow_transfer'                        => \&__o2i_ms_transfer__,
                        'primary_shared_with_ms_parent_delegation' => \&ibap_o2i_ignore,
                        'name'                                     => \&__o2i_fqdn__,
                        'ns_group'                                 => \&__o2i_ns_group__,
                        'stub_ns_group'                            => \&__o2i_ns_group__,
                        'forward_ns_group'                         => \&__o2i_ns_group__,
                        'stub_external_ns_group'                   => \&__o2i_ns_group__,
                        'forward_external_ns_group'                => \&__o2i_ns_group__,
                        'delegation_ns_group'                      => \&__o2i_ns_group__,
                        'network_associations'                     => \&ibap_o2i_ignore,
                        'override_delegated_ttl'                   => \&ibap_o2i_boolean,
                        'override_grid_email'                      => \&ibap_o2i_boolean,
                        'override_grid_zone_timer'                 => \&ibap_o2i_boolean,
                        'override_serial_number'                   => \&ibap_o2i_boolean,
                        'override_soa_mname'                       => \&ibap_o2i_ignore,
                        'prefix'                                   => \&ibap_o2i_string,
                        'primary'                                  => \&ibap_o2i_ignore,
                        'multiple_primaries'                       => \&__o2i_primary__,
                        'is_multimaster'                           => \&ibap_o2i_boolean,
                        'remove_sub_zones'                         => \&ibap_o2i_ignore,
                        'secondaries'                              => \&__o2i_nameserver__,
                        'shared_record_groups'                     => \&__o2i_srgs__,
                        'soa_default_ttl'                          => \&ibap_o2i_long,
                        'soa_expire'                               => \&ibap_o2i_long,
                        'soa_mname'                                => \&ibap_o2i_string_skip_undef,
                        'member_soa_mnames'                        => \&ibap_o2i_generic_struct_list_convert,
                        'member_soa_serials'                       => \&ibap_o2i_ignore,
                        'soa_negative_ttl'                         => \&ibap_o2i_long,
                        'soa_refresh'                              => \&ibap_o2i_long,
                        'soa_retry'                                => \&ibap_o2i_long,
                        'soa_serial_number'                        => \&ibap_o2i_long,
                        'stub_from'                                => \&__o2i_nameserver__,
                        'stub_members'                             => \&__o2i_nameserver__,
                        'use_allow_query'                          => \&ibap_o2i_boolean,
                        'use_allow_update_forwarding'              => \&ibap_o2i_boolean,
                        'use_check_names_policy'                   => \&ibap_o2i_boolean,
                        'use_external_primary'                     => \&ibap_o2i_boolean,
                        'use_import_from'                          => \&ibap_o2i_boolean,
                        'use_notify_delay'                         => \&ibap_o2i_boolean,
                        'use_record_name_policy'                   => \&ibap_o2i_boolean,
                        'use_update_setting'                       => \&ibap_o2i_boolean,
                        'use_zone_transfer_setting'                => \&ibap_o2i_boolean,
                        'views'                                    => \&ibap_o2i_view,
                        'allow_query'                              => \&ibap_o2i_ac_setting,
                        'allow_transfer'                           => \&ibap_o2i_ac_setting,
                        'allow_update'                             => \&ibap_o2i_ac_setting,

                        #
                        'dnssec_ksk_algorithms'                    => \&ibap_o2i_dnssec_key_params,
                        'dnssec_ksk_rollover_interval'             => \&ibap_o2i_dnssec_key_params,
                        'dnssec_signature_expiration'              => \&ibap_o2i_dnssec_key_params,
                        'dnssec_signed'                            => \&ibap_o2i_ignore,
                        'dnssec_zsk_algorithms'                    => \&ibap_o2i_dnssec_key_params,
                        'dnssec_zsk_rollover_interval'             => \&ibap_o2i_dnssec_key_params,
                        'dnssec_nsec3_salt_min_length'             => \&ibap_o2i_dnssec_key_params,
                        'dnssec_nsec3_salt_max_length'             => \&ibap_o2i_dnssec_key_params,
                        'dnssec_nsec3_iterations'                  => \&ibap_o2i_dnssec_key_params,
                        'dnssec_zsk_rollover_mechanism'            => \&ibap_o2i_dnssec_key_params,
                        'dnssec_enable_ksk_auto_rollover'          => \&ibap_o2i_dnssec_key_params,
                        'dnssec_ksk_rollover_date'                 => \&ibap_o2i_ignore,
                        'dnssec_zsk_rollover_date'                 => \&ibap_o2i_ignore,
                        'dnssec_ksk_rollover_notification_config'  => \&ibap_o2i_dnssec_key_params,
                        'dnssec_ksk_snmp_notification_enabled'     => \&ibap_o2i_dnssec_key_params,
                        'dnssec_ksk_email_notification_enabled'    => \&ibap_o2i_dnssec_key_params,
                        'next_secure_type'                         => \&ibap_o2i_dnssec_key_params,
                        #
                        'dnssec_ksk_algorithm'                     => \&ibap_o2i_ignore,
                        'dnssec_zsk_algorithm'                     => \&ibap_o2i_ignore,
                        'dnssec_ksk_size'                          => \&ibap_o2i_ignore,
                        'dnssec_zsk_size'                          => \&ibap_o2i_ignore,

                        'dnssec_keys'                             => \&ibap_o2i_generic_struct_list_convert,
                        'extattrs'                                => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'                   => \&ibap_o2i_ignore,
                        'forward_only'                            => \&ibap_o2i_boolean,
                        'notify_delay'                            => \&ibap_o2i_uint,
                        'use_dnssec'                              => \&ibap_o2i_boolean,
                        'use_sec_update_forwarding'               => \&ibap_o2i_boolean,
                        'zone'                                    => \&ibap_o2i_ignore,
                        'last_queried'                            => \&ibap_o2i_ignore,
                        'zone_monitored_since'                    => \&ibap_o2i_ignore,
                        'resource_record_monitored_since'         => \&ibap_o2i_ignore,
                        'rpz_policy'                              => \&ibap_o2i_enums_ucfirst_or_undef,
                        'rpz_type'                                => \&ibap_o2i_string,
                        'fireeye_rule_mapping'                    => \&ibap_o2i_generic_struct_convert,
                        'substitute_name'                         => \&ibap_o2i_string,
                        'rpz_priority'                            => \&ibap_o2i_ignore,
                        'rpz_last_updated_time'                   => \&ibap_o2i_ignore,
                        'is_feed_zone'                            => \&ibap_o2i_ignore,
                        'copy_xfer_to_notify'                     => \&ibap_o2i_boolean,
                        'override_copy_xfer_to_notify'            => \&ibap_o2i_boolean,
                        'dns_integrity_check_enable'              => \&ibap_o2i_boolean,
                        'dns_integrity_frequency'                 => \&ibap_o2i_uint,
                        'dns_integrity_member'                    => \&ibap_o2i_member_byhostname,
                        'dns_integrity_verbose_logging'           => \&ibap_o2i_boolean,
                        'is_default'                              => \&ibap_o2i_ignore,
                        'rpz_severity'                            => \&ibap_o2i_string,

                        'cloud_info'                              => \&ibap_o2i_ignore,
                        'restart_if_needed'                       => \&ibap_o2i_boolean,
                        'ddns_restrict_patterns_list'             => \&ibap_o2i_string_array_undef_to_empty,
                        'ddns_restrict_patterns'                  => \&ibap_o2i_boolean,
                        'override_ddns_patterns_restriction'      => \&ibap_o2i_boolean,
                        'ddns_restrict_static'                    => \&ibap_o2i_boolean,
                        'override_ddns_restrict_static'           => \&ibap_o2i_boolean,
                        'ddns_restrict_protected'                 => \&ibap_o2i_boolean,
                        'override_ddns_restrict_protected'        => \&ibap_o2i_boolean,
                        'ddns_restrict_secure'                    => \&ibap_o2i_boolean,
                        'ddns_principal_tracking'                 => \&ibap_o2i_boolean,
                        'ddns_force_creation_timestamp_update'          => \&ibap_o2i_boolean,
                        'override_ddns_force_creation_timestamp_update' => \&ibap_o2i_boolean,
                        'ddns_principal_group'                    => \&ibap_o2i_object_by_oid_or_name_undef_ok,
                        'override_ddns_principal_security'        => \&ibap_o2i_boolean,
                        'scavenging_settings'                     => \&ibap_o2i_generic_struct_convert,
                        'override_scavenging_settings'            => \&ibap_o2i_boolean,
                        'override_rpz_drop_ip_rule'               => \&ibap_o2i_boolean,
                        'rpz_drop_ip_rule_enabled'                => \&ibap_o2i_boolean,
                        'rpz_drop_ip_rule_min_prefix_length_ipv4' => \&ibap_o2i_uint,
                        'rpz_drop_ip_rule_min_prefix_length_ipv6' => \&ibap_o2i_uint,
                        'ms_dc_ns_record_creation'                => \&ibap_o2i_generic_struct_list_convert,
                       );

    %_searchable_fields = (
                           'comment'                        => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           'name'                           => [\&__o2i_fqdn_search__, 'fqdn', 'REGEX'],
                           'primary_association_type'       => [\&__o2i_assoctype_search__, 'primary_association_type', 'EXACT'],
                           'view'                           => [\&ibap_o2i_view, 'view', 'EXACT'],
                           'views'                          => [\&ibap_o2i_view, 'view', 'EXACT'],
                           'extattrs'                       => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes'          => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'ns_group'                       => [\&__o2i_ns_group__, 'ns_group', 'EXACT'],
                           'forward_ns_group'               => [\&__o2i_ns_group__, 'ns_group', 'EXACT'],
                           'stub_ns_group'                  => [\&__o2i_ns_group__, 'ns_group', 'EXACT'],
                           'delegation_ns_group'            => [\&__o2i_ns_group__, 'delegation_ns_group', 'EXACT'],
                           'prefix'                         => [\&ibap_o2i_string, 'prefix', 'EXACT'],
                           'zone'                           => [\&ibap_o2i_string, 'parent', 'REGEX'],
                           'rpz_policy'                     => [\&ibap_o2i_enums_ucfirst_or_undef, 'rpz_policy', 'EXACT'],
                           'is_feed_zone'                   => [\&ibap_o2i_boolean, 'is_feed_zone', 'EXACT'],
                           'dnssec_ksk_rollover_date'       => [\&ibap_o2i_unix_timestamp_to_datetime, "dnssec_ksk_rollover_date","GLEQ"],
                           'dnssec_ksk_rollover_date_start' => [\&ibap_o2i_unix_timestamp_to_datetime, "dnssec_ksk_rollover_date_start", "GEQ_dnssec_ksk_rollover_date"],
                           'dnssec_ksk_rollover_date_end'   => [\&ibap_o2i_unix_timestamp_to_datetime, "dnssec_ksk_rollover_date_end", "LEQ_dnssec_ksk_rollover_date"],
                           'dnssec_zsk_rollover_date'       => [\&ibap_o2i_unix_timestamp_to_datetime, "dnssec_zsk_rollover_date","GLEQ"],
                           'dnssec_zsk_rollover_date_start' => [\&ibap_o2i_unix_timestamp_to_datetime, "dnssec_zsk_rollover_date_start", "GEQ_dnssec_zsk_rollover_date"],
                           'dnssec_zsk_rollover_date_end'   => [\&ibap_o2i_unix_timestamp_to_datetime, "dnssec_zsk_rollover_date_end", "LEQ_dnssec_zsk_rollover_date"],
                           'rpz_severity'                   => [\&ibap_o2i_string, 'rpz_severity', 'EXACT'],
    );

    #
    #
    #
    #
    #
    #
    %_filter_fields = (
                       'StubZone' =>
                       {
                        address                                  => 1,
                        create_ptr_for_bulk_hosts                => 1,
                        create_ptr_for_hosts                     => 1,
                        do_host_abstraction                      => 1,
                        bind_check_names_policy                  => 1,
                        display_domain                           => 1,
                        dnssec_signed                            => 1,
                        dnssec_ksk_rollover_interval             => 1,
                        dnssec_ksk_algorithm                     => 1,
                        dnssec_ksk_algorithms                    => 1,
                        dnssec_ksk_size                          => 1,
                        dnssec_signature_expiration              => 1,
                        dnssec_zsk_algorithm                     => 1,
                        dnssec_zsk_algorithms                    => 1,
                        dnssec_zsk_rollover_interval             => 1,
                        dnssec_zsk_size                          => 1,
                        dnssec_nsec3_salt_min_length             => 1,
                        dnssec_nsec3_salt_max_length             => 1,
                        dnssec_nsec3_iterations                  => 1,
                        dnssec_zsk_rollover_mechanism            => 1,
                        dnssec_enable_ksk_auto_rollover          => 1,
                        dnssec_keys                              => 1,
                        dnssec_ksk_rollover_date                 => 1,
                        dnssec_zsk_rollover_date                 => 1,
                        dnssec_ksk_rollover_notification_config  => 1,
                        dnssec_ksk_snmp_notification_enabled     => 1,
                        dnssec_ksk_email_notification_enabled    => 1,
                        next_secure_type                         => 1,
                        locked_by                                => 1,
                        mask_prefix                              => 1,
                        ms_allow_transfer                        => 1,
                        primary_shared_with_ms_parent_delegation => 1,
                        parent                                   => 1,
                        soa_default_ttl                          => 1,
                        email                                    => 1,
                        soa_expire                               => 1,
                        soa_mname                                => 1,
                        soa_negative_ttl                         => 1,
                        soa_refresh                              => 1,
                        soa_retry                                => 1,
                        override_serial_number                   => 1,
                        override_grid_email                      => 1,
                        override_soa_mname                       => 1,
                        view_name                                => 1,
                        delegate_to                              => 1,
                        delegation_ns_group                      => 1,
                        members                                  => 1,
                        forward_to                               => 1,
                        secondaries                              => 1,
                        primary                                  => 1,
                        multiple_primaries                       => 1,
                        is_multimaster                           => 1,
                        ms_sync_disable                          => 1,
                        allow_ptr_creation_in_parent             => 1,
                        last_queried                             => 1,
                        zone_monitored_since                     => 1,
                        resource_record_monitored_since          => 1,
                        rpz_policy                               => 1,
                        rpz_type                                 => 1,
                        rpz_severity                             => 1,
                        fireeye_rule_mapping                     => 1,
                        substitute_name                          => 1,
                        rpz_priority                             => 1,
                        rpz_last_updated_time                    => 1,
                        copy_xfer_to_notify                      => 1,
                        override_copy_xfer_to_notify             => 1,
                        member_soa_mnames                        => 1,
                        dns_integrity_check_enable               => 1,
                        dns_integrity_frequency                  => 1,
                        dns_integrity_member                     => 1,
                        dns_integrity_verbose_logging            => 1,
                        cloud_info                               => 1,
                        restart_if_needed                        => 1,
                        'ddns_restrict_patterns_list'            => 1,
                        'ddns_restrict_patterns'                 => 1,
                        'override_ddns_patterns_restriction'     => 1,
                        'ddns_restrict_static'                   => 1,
                        'override_ddns_restrict_static'          => 1,
                        'ddns_restrict_protected'                => 1,
                        'override_ddns_restrict_protected'       => 1,
                        'ddns_restrict_secure'                   => 1,
                        'ddns_principal_tracking'                => 1,
                        'ddns_force_creation_timestamp_update'          => 1,
                        'override_ddns_force_creation_timestamp_update' => 1,
                        'ddns_principal_group'                   => 1,
                        'override_ddns_principal_security'       => 1,
                        'scavenging_settings'                    => 1,
                        'override_scavenging_settings'           => 1,
                        override_rpz_drop_ip_rule                => 1,
                        rpz_drop_ip_rule_enabled                 => 1,
                        rpz_drop_ip_rule_min_prefix_length_ipv4  => 1,
                        rpz_drop_ip_rule_min_prefix_length_ipv6  => 1,
                        ms_dc_ns_record_creation                 => 1,
                        ns_group                                 => 1,
                        forward_ns_group                         => 1,
                        forward_external_ns_group                => 1,
                       },

                       'AuthZone' =>
                       {
                        address                                 => 1,
                        display_domain                          => 1,
                        mask_prefix                             => 1,
                        parent                                  => 1,
                        view_name                               => 1,
                        stub_members                            => 1,
                        stub_from                               => 1,
                        delegate_to                             => 1,
                        delegation_ns_group                      => 1,
                        members                                 => 1,
                        forward_to                              => 1,
                        allow_ptr_creation_in_parent            => 1,
                        rpz_policy                              => 1,
                        rpz_type                                => 1,
                        rpz_severity                            => 1,
                        fireeye_rule_mapping                    => 1,
                        substitute_name                         => 1,
                        rpz_priority                            => 1,
                        rpz_last_updated_time                   => 1,
                        override_rpz_drop_ip_rule               => 1,
                        rpz_drop_ip_rule_enabled                => 1,
                        rpz_drop_ip_rule_min_prefix_length_ipv4 => 1,
                        rpz_drop_ip_rule_min_prefix_length_ipv6 => 1,
                        stub_ns_group                           => 1,
                        stub_external_ns_group                  => 1,
                        forward_ns_group                        => 1,
                        forward_external_ns_group               => 1,
                       },

                       'DelegatedZone' =>
                       {
                        address                                  => 1,
                        bind_check_names_policy                  => 1,
                        create_ptr_for_bulk_hosts                => 1,
                        create_ptr_for_hosts                     => 1,
                        do_host_abstraction                      => 1,
                        display_domain                           => 1,
                        dnssec_signed                            => 1,
                        dnssec_ksk_rollover_interval             => 1,
                        dnssec_ksk_algorithm                     => 1,
                        dnssec_ksk_algorithms                    => 1,
                        dnssec_ksk_size                          => 1,
                        dnssec_signature_expiration              => 1,
                        dnssec_zsk_algorithm                     => 1,
                        dnssec_zsk_algorithms                    => 1,
                        dnssec_zsk_rollover_interval             => 1,
                        dnssec_zsk_size                          => 1,
                        dnssec_nsec3_salt_min_length             => 1,
                        dnssec_nsec3_salt_max_length             => 1,
                        dnssec_nsec3_iterations                  => 1,
                        dnssec_zsk_rollover_mechanism            => 1,
                        dnssec_enable_ksk_auto_rollover          => 1,
                        dnssec_keys                              => 1,
                        dnssec_ksk_rollover_date                 => 1,
                        dnssec_zsk_rollover_date                 => 1,
                        dnssec_ksk_rollover_notification_config  => 1,
                        dnssec_ksk_snmp_notification_enabled     => 1,
                        dnssec_ksk_email_notification_enabled    => 1,
                        next_secure_type                         => 1,
                        locked_by                                => 1,
                        mask_prefix                              => 1,
                        ms_allow_transfer                        => 1,
                        ms_sync_disable                          => 1,
                        primary_shared_with_ms_parent_delegation => 1,
                        parent                                   => 1,
                        view_name                                => 1,
                        stub_members                             => 1,
                        stub_from                                => 1,
                        members                                  => 1,
                        forward_to                               => 1,
                        secondaries                              => 1,
                        primary                                  => 1,
                        multiple_primaries                       => 1,
                        is_multimaster                           => 1,
                        last_queried                             => 1,
                        zone_monitored_since                     => 1,
                        resource_record_monitored_since          => 1,
                        rpz_policy                               => 1,
                        rpz_type                                 => 1,
                        rpz_severity                             => 1,
                        fireeye_rule_mapping                     => 1,
                        substitute_name                          => 1,
                        rpz_priority                             => 1,
                        rpz_last_updated_time                    => 1,
                        copy_xfer_to_notify                      => 1,
                        override_copy_xfer_to_notify             => 1,
                        member_soa_mnames                        => 1,
                        dns_integrity_check_enable               => 1,
                        dns_integrity_frequency                  => 1,
                        dns_integrity_member                     => 1,
                        dns_integrity_verbose_logging            => 1,
                        cloud_info                               => 1,
                        restart_if_needed                        => 1,
                        'ddns_restrict_patterns_list'            => 1,
                        'ddns_restrict_patterns'                 => 1,
                        'override_ddns_patterns_restriction'     => 1,
                        'ddns_restrict_static'                   => 1,
                        'override_ddns_restrict_static'          => 1,
                        'ddns_restrict_protected'                => 1,
                        'override_ddns_restrict_protected'       => 1,
                        'ddns_restrict_secure'                   => 1,
                        'ddns_principal_tracking'                => 1,
                        'ddns_principal_group'                   => 1,
                        'override_ddns_principal_security'       => 1,
                        'ddns_force_creation_timestamp_update'          => 1,
                        'override_ddns_force_creation_timestamp_update' => 1,
                        'scavenging_settings'                    => 1,
                        'override_scavenging_settings'           => 1,
                        override_rpz_drop_ip_rule                => 1,
                        rpz_drop_ip_rule_enabled                 => 1,
                        rpz_drop_ip_rule_min_prefix_length_ipv4  => 1,
                        rpz_drop_ip_rule_min_prefix_length_ipv6  => 1,
                        ms_dc_ns_record_creation                 => 1,
                        ns_group                                 => 1,
                        stub_ns_group                            => 1,
                        stub_external_ns_group                   => 1,
                        forward_ns_group                         => 1,
                        forward_external_ns_group                => 1,
                       },

                       'ForwardZone' =>
                       {
                        address                                  => 1,
                        create_ptr_for_bulk_hosts                => 1,
                        create_ptr_for_hosts                     => 1,
                        do_host_abstraction                      => 1,
                        display_domain                           => 1,
                        bind_check_names_policy                  => 1,
                        dnssec_signed                            => 1,
                        dnssec_ksk_rollover_interval             => 1,
                        dnssec_ksk_algorithm                     => 1,
                        dnssec_ksk_algorithms                    => 1,
                        dnssec_ksk_size                          => 1,
                        dnssec_signature_expiration              => 1,
                        dnssec_zsk_algorithm                     => 1,
                        dnssec_zsk_algorithms                    => 1,
                        dnssec_zsk_rollover_interval             => 1,
                        dnssec_zsk_size                          => 1,
                        dnssec_nsec3_salt_min_length             => 1,
                        dnssec_nsec3_salt_max_length             => 1,
                        dnssec_nsec3_iterations                  => 1,
                        dnssec_zsk_rollover_mechanism            => 1,
                        dnssec_enable_ksk_auto_rollover          => 1,
                        dnssec_keys                              => 1,
                        dnssec_ksk_rollover_date                 => 1,
                        dnssec_zsk_rollover_date                 => 1,
                        dnssec_ksk_rollover_notification_config  => 1,
                        dnssec_ksk_snmp_notification_enabled     => 1,
                        dnssec_ksk_email_notification_enabled    => 1,
                        next_secure_type                         => 1,
                        locked_by                                => 1,
                        mask_prefix                              => 1,
                        ms_allow_transfer                        => 1,
                        ms_sync_disable                          => 1,
                        primary_shared_with_ms_parent_delegation => 1,
                        parent                                   => 1,
                        allow_update_forwarding                  => 1,
                        view_name                                => 1,
                        stub_members                             => 1,
                        stub_from                                => 1,
                        delegate_to                              => 1,
                        delegation_ns_group                      => 1,
                        secondaries                              => 1,
                        primary                                  => 1,
                        multiple_primaries                       => 1,
                        is_multimaster                           => 1,
                        allow_ptr_creation_in_parent             => 1,
                        last_queried                             => 1,
                        zone_monitored_since                     => 1,
                        resource_record_monitored_since          => 1,
                        rpz_policy                               => 1,
                        rpz_type                                 => 1,
                        rpz_severity                             => 1,
                        fireeye_rule_mapping                     => 1,
                        substitute_name                          => 1,
                        rpz_priority                             => 1,
                        rpz_last_updated_time                    => 1,
                        copy_xfer_to_notify                      => 1,
                        override_copy_xfer_to_notify             => 1,
                        member_soa_mnames                        => 1,
                        dns_integrity_check_enable               => 1,
                        dns_integrity_frequency                  => 1,
                        dns_integrity_member                     => 1,
                        dns_integrity_verbose_logging            => 1,
                        cloud_info                               => 1,
                        restart_if_needed                        => 1,
                        'ddns_restrict_patterns_list'            => 1,
                        'ddns_restrict_patterns'                 => 1,
                        'override_ddns_patterns_restriction'     => 1,
                        'ddns_restrict_static'                   => 1,
                        'override_ddns_restrict_static'          => 1,
                        'ddns_restrict_protected'                => 1,
                        'override_ddns_restrict_protected'       => 1,
                        'ddns_restrict_secure'                   => 1,
                        'ddns_principal_tracking'                => 1,
                        'ddns_principal_group'                   => 1,
                        'override_ddns_principal_security'       => 1,
                        'ddns_force_creation_timestamp_update'          => 1,
                        'override_ddns_force_creation_timestamp_update' => 1,
                        'scavenging_settings'                    => 1,
                        'override_scavenging_settings'           => 1,
                        override_rpz_drop_ip_rule                => 1,
                        rpz_drop_ip_rule_enabled                 => 1,
                        rpz_drop_ip_rule_min_prefix_length_ipv4  => 1,
                        rpz_drop_ip_rule_min_prefix_length_ipv6  => 1,
                        ms_dc_ns_record_creation                 => 1,
                        ns_group                                 => 1,
                        stub_ns_group                            => 1,
                        stub_external_ns_group                   => 1,
                       },

                       #
                       #
                       'ResponsePolicyZone' =>
                       {
                        address                         => 1,
                        display_domain                  => 1,
                        mask_prefix                     => 1,
                        parent                          => 1,
                        view_name                       => 1,
                        stub_members                    => 1,
                        stub_from                       => 1,
                        delegate_to                     => 1,
                        delegation_ns_group             => 1,
                        members                         => 1,
                        forward_to                      => 1,
                        allow_ptr_creation_in_parent    => 1,
                        last_queried                    => 1,
                        zone_monitored_since            => 1,
                        resource_record_monitored_since => 1,
                        ms_allow_transfer               => 1,
                        ms_dc_ns_record_creation        => 1,
                        stub_ns_group                   => 1,
                        stub_external_ns_group          => 1,
                        forward_ns_group                => 1,
                        forward_external_ns_group       => 1,
                       },
                   );

    %_return_field_overrides = (
                                ad_servers                               => ['enable_ad_servers'],
                                allow_gss_tsig_for_underscore_zone       => [],
                                allow_gss_tsig_zone_updates              => [],
                                allow_query                              => ['use_allow_query'],
                                allow_transfer                           => ['use_zone_transfer_setting'],
                                allow_update                             => ['use_update_setting'],
                                allow_update_forwarding                  => ['use_sec_update_forwarding','use_allow_update_forwarding'],
                                bind_check_names_policy                  => ['use_check_names_policy'],
                                comment                                  => [],
                                create_underscore_zones                  => [],
                                create_ptr_for_bulk_hosts                => [],
                                create_ptr_for_hosts                     => [],
                                delegated_ttl                            => [],
                                delegate_to                              => [],
                                delegation_ns_group                      => [],
                                dns_name                                 => [],
                                dns_soa_mname                            => [],
                                dns_email                                => [],
                                disable                                  => [],
                                disable_forwarding                       => [],
                                do_host_abstraction                      => [],
                                dnssec_ksk_algorithms                    => ['use_dnssec'],
                                dnssec_ksk_rollover_interval             => ['use_dnssec'],
                                dnssec_signature_expiration              => ['use_dnssec'],
                                dnssec_signed                            => [],
                                dnssec_zsk_algorithms                    => ['use_dnssec'],
                                dnssec_zsk_rollover_interval             => ['use_dnssec'],
                                dnssec_nsec3_salt_min_length             => ['use_dnssec'],
                                dnssec_nsec3_salt_max_length             => ['use_dnssec'],
                                dnssec_nsec3_iterations                  => ['use_dnssec'],
                                dnssec_zsk_rollover_mechanism            => ['use_dnssec'],
                                dnssec_enable_ksk_auto_rollover          => ['use_dnssec'],
                                dnssec_keys                              => [],
                                dnssec_ksk_rollover_date                 => [],
                                dnssec_zsk_rollover_date                 => [],
                                dnssec_ksk_rollover_notification_config  => ['use_dnssec'],
                                dnssec_ksk_snmp_notification_enabled     => ['use_dnssec'],
                                dnssec_ksk_email_notification_enabled    => ['use_dnssec'],
                                next_secure_type                         => ['use_dnssec'],
                                email                                    => [],
                                allow_ptr_creation_in_parent             => [],
                                extattrs                                 => [],
                                extensible_attributes                    => [],
                                forward_only                             => [],
                                forward_to                               => [],
                                host_name_restriction_policy             => ['use_record_name_policy'],
                                import_from                              => ['use_import_from'],
                                locked                                   => [],
                                members                                  => [],
                                ms_ad_integrated                         => [],
                                ms_managed                               => [],
                                ms_read_only                             => [],
                                ms_sync_disable                          => [],
                                ms_ddns_mode                             => [],
                                ms_allow_transfer                        => ['#ms_allow_transfer'],
                                primary_shared_with_ms_parent_delegation => [],
                                name                                     => [],
                                notify_delay                             => ['use_notify_delay'],
                                ns_group                                 => [],
                                forward_ns_group                         => [],
                                forward_external_ns_group                => [],
                                stub_ns_group                            => [],
                                stub_external_ns_group                   => [],
                                override_delegated_ttl                   => [],
                                override_grid_email                      => [],
                                override_grid_zone_timer                 => [],
                                override_serial_number                   => [],
                                override_soa_mname                       => [],
                                prefix                                   => [],
                                primary                                  => ['grid_primaries', 'external_primaries', 'ms_primaries', 'use_external_primary'],
                                multiple_primaries                       => ['grid_primaries', 'external_primaries', 'ms_primaries', 'use_external_primary'],
                                is_multimaster                           => [],
                                remove_sub_zones                         => [],
                                secondaries                              => ['external_secondaries'],
                                shared_record_groups                     => [],
                                soa_default_ttl                          => [],
                                soa_expire                               => [],
                                member_soa_mnames                        => [],
                                member_soa_serials                       => [],
                                soa_mname                                => [],
                                soa_negative_ttl                         => [],
                                soa_refresh                              => [],
                                soa_retry                                => [],
                                soa_serial_number                        => [],
                                stub_from                                => [],
                                stub_members                             => [],
                                views                                    => [],
                                zone                                     => [],
                                last_queried                             => [],
                                zone_monitored_since                     => [],
                                resource_record_monitored_since          => [],
                                copy_xfer_to_notify                      => ['use_copy_xfer_to_notify'],
                                override_copy_xfer_to_notify             => [],
                                dns_integrity_check_enable               => [],
                                dns_integrity_frequency                  => [],
                                dns_integrity_member                     => [],
                                dns_integrity_verbose_logging            => [],
                                cloud_info                               => [],
                                'ddns_restrict_patterns_list'            => ['use_ddns_patterns_restriction'],
                                'ddns_restrict_patterns'                 => ['use_ddns_patterns_restriction'],
                                'override_ddns_patterns_restriction'     => [],
                                'ddns_restrict_static'                   => ['use_ddns_restrict_static'],
                                'override_ddns_restrict_static'          => [],
                                'ddns_restrict_protected'                => ['use_ddns_restrict_protected'],
                                'override_ddns_restrict_protected'       => [],
                                'ddns_restrict_secure'                   => ['use_ddns_principal_security'],
                                'ddns_principal_tracking'                => ['use_ddns_principal_security'],
                                'ddns_principal_group'                   => ['use_ddns_principal_security'],
                                'override_ddns_principal_security'       => [],
                                'ddns_force_creation_timestamp_update'          => ['use_ddns_force_creation_timestamp_update'],
                                'override_ddns_force_creation_timestamp_update' => [],
                                'scavenging_settings'                    => ['use_reclamation'],
                                'override_scavenging_settings'           => [],
                                override_rpz_drop_ip_rule                => [],
                                rpz_drop_ip_rule_enabled                 => ['use_rpz_drop_ip_rule', 'rpz_drop_ip_rule_min_prefix_length_ipv4',
                                                                             'rpz_drop_ip_rule_min_prefix_length_ipv6'],
                                rpz_drop_ip_rule_min_prefix_length_ipv4  => ['use_rpz_drop_ip_rule', 'rpz_drop_ip_rule_enabled',
                                                                             'rpz_drop_ip_rule_min_prefix_length_ipv6'],
                                rpz_drop_ip_rule_min_prefix_length_ipv6  => ['use_rpz_drop_ip_rule', 'rpz_drop_ip_rule_enabled',
                                                                             'rpz_drop_ip_rule_min_prefix_length_ipv4'],
                               );


    $_return_fields_initialized=0;
    my @rlist = (
                 'comment',
                 'disabled',
                 'fqdn',
                 'dns_fqdn',
                 'parent',
                 'ms_managed',
                 'ms_read_only',
                 'ms_sync_disabled',
                 'ms_ad_integrated',
                 'ms_ddns_mode',
               );

    foreach my $current (@rlist) {
        push @_return_fields, tField($current);
    }

    foreach my $current (
                         (
                          'allow_gss_tsig_for_underscore_zone',
                          'allow_gss_tsig_zone_updates',
                          'create_underscore_zones',
                          'dns_soa_mname',
                          'dns_soa_email',
                          'disable_forwarding',
                          'display_domain',
                          'delegated_ttl',
                          'effective_check_names_policy',
                          'enable_rfc2317_exclusion',
                          'forwarders_only',
                          'grid_primary_shared_with_ms_parent_delegation',
                          'import_from',
                          'ms_allow_transfer_mode',
                          'ms_allow_transfer',
                          'locked',
                          'notify_delay',
                          'prefix',
                          'set_soa_serial_number',
                          'soa_default_ttl',
                          'soa_email',
                          'soa_expire',
                          'soa_negative_ttl',
                          'soa_refresh',
                          'soa_retry',
                          'soa_serial_number',
                          'soa_mname',
                          'use_allow_active_dir',
                          'use_allow_query',
                          'use_zone_transfer_setting',
                          'use_update_setting',
                          'use_check_names_policy',
                          'use_delegated_ttl',
                          'use_external_primary',
                          'use_grid_zone_timer',
                          'use_import_from',
                          'use_notify_delay',
                          'use_record_name_policy',
                          'allow_update_forwarding',
                          'use_soa_email',
                          'use_allow_update_forwarding',
                          'use_dnssec',
                          'is_dnssec_signed',
                          'last_queried',
                          'zone_not_queried_enabled_time',
                          'rr_not_queried_enabled_time',
                          'rpz_policy',
                          'rpz_type',
                          'rpz_severity',
                          'substitute_name',
                          'rpz_priority',
                          'rpz_last_updated_time',
                          'copy_xfer_to_notify',
                          'use_copy_xfer_to_notify',
                          'is_multimaster',
                          'dns_integrity_check_enabled',
                          'dns_integrity_check_frequency',
                          'dns_integrity_check_verbose_logging',
                          'dnssec_ksk_rollover_date',
                          'dnssec_zsk_rollover_date',
                          'ddns_restrict_patterns_list',
                          'ddns_restrict_patterns',
                          'use_ddns_patterns_restriction',
                          'ddns_restrict_static',
                          'use_ddns_restrict_static',
                          'ddns_restrict_protected',
                          'use_ddns_restrict_protected',
                          'ddns_restrict_secure',
                          'ddns_principal_tracking',
                          'ddns_force_creation_timestamp_update',
                          'use_ddns_force_creation_timestamp_update',
                          'use_ddns_principal_security',
                          'use_reclamation',
                          'use_rpz_drop_ip_rule',
                          'rpz_drop_ip_rule_enabled',
                          'rpz_drop_ip_rule_min_prefix_length_ipv4',
                          'rpz_drop_ip_rule_min_prefix_length_ipv6',
                         )
                        ) {

        push @_return_fields, tField($current,
            {
             not_exist_ok => 1,
            }
        );
    }

   push @_return_fields, tField('allow_active_dir',
            {
             not_exist_ok => 1,
             sub_fields=>
              [
               tField('address_string'),
               tField('permission')
              ]
            }
          );

    foreach my $current (
                         (
                          'delegate_to',
                          'external_primaries',
                          'external_secondaries',
                          'forward_to',
                          'stub_from',
                         )
                        ) {
        push @_return_fields, tField($current,
            {
             not_exist_ok => 1,
             sub_fields =>
             [
              tField('name'),
              tField('address'),
              tField('stealth'),
              tField('use_tsig_key'),
              tField('tsig_key_alg'),
              tField('tsig_key_name'),
              tField('tsig_key'),
              tField('use_2x_tsig_key'),
              tField('shared_with_ms_parent_delegation')
             ],
            }
        );
    }

    push @_return_fields, tField('dns_integrity_check_member', return_fields_member_basic_data_no_access_ok());

    foreach my $current (
                         (
                          'stub_members',
                          'grid_primaries',
                         )
                        ) {

        push @_return_fields, tField($current,
                                     {
                                      not_exist_ok => 1,
                                      default_no_access_ok => 1,
                                      sub_fields =>
                                      [
                                       tField('lead'),
                                       tField('grid_replicate'),
                                       tField('stealth'),
                                       tField('shared_with_ms_parent_delegation', {not_exist_ok => 1}),
                                       tField('grid_member', return_fields_member_basic_data),
                                      ],
                                     }
                                    );
    }

    push @_return_fields, tField('forwarding_servers',
                    {
                     not_exist_ok => 1,
                     default_no_access_ok => 1,
                     sub_fields =>
                     [
                      tField('grid_member', return_fields_member_basic_data),
                      tField('forwarders_only'),
                      tField('use_override_forwarders'),
                      tField('forward_to',
                       {
                        not_exist_ok => 1,
                        sub_fields =>
                        [
                         tField('name'),
                         tField('address'),
                         tField('stealth'),
                         tField('use_tsig_key'),
                         tField('tsig_key_alg'),
                         tField('tsig_key_name'),
                         tField('tsig_key'),
                         tField('use_2x_tsig_key'),
                         tField('shared_with_ms_parent_delegation')
                        ],
                       },
                      ),
                     ],
                    }
                   );


    push @_return_fields, tField('grid_primary', return_fields_member_basic_data_no_access_ok());

    push @_return_fields, tField('record_name_policy',
                                 {
                                  not_exist_ok => 1,
                                  sub_fields =>
                                  [
                                   tField('policy_name'),
                                  ],
                                 }
                                );

    foreach ('ns_group', 'ns_group_external', 'delegation_ns_group') {
        push @_return_fields, tField($_, {
            not_exist_ok => 1,
            sub_fields => [tField('group_name')],
        });
    }

    push @_return_fields, tField('srgs',
                                 {
                                  not_exist_ok => 1,
                                  sub_fields =>
                                  [
                                   tField('srg_name'),
                                  ],
                                 }
                                );

    push @_return_fields, return_fields_extensible_attributes();


   #
   $_lazy_return_fields{'network_associations'}=[tField('network_associations',
                                     {
                                      not_exist_ok => 1,
                                      no_access_ok => 1,
                                      depth => 3
                                     }
                                    )];

};

sub __check_dnssec_deprecated__ {

    my ($self, %args) = @_;

    if (($args{dnssec_ksk_algorithm} ||
         $args{dnssec_ksk_size}      ||
         $args{dnssec_zsk_algorithm} ||
         $args{dnssec_zsk_size}) &&
        ($args{dnssec_ksk_algorithms} ||
         $args{dnssec_zsk_algorithms} || 
         $args{next_secure_type})) {

        set_error_codes(1105, 'dnssec_ksk_algorithm, dnssec_ksk_size, ' .
                              'dnssec_zsk_algorithm and dnssec_zsk_size are ' .
                              'deprecated, use dnssec_ksk_algorithms, ' .
                              'dnssec_zsk_algorithms and next_secure_type instead.');
        return undef;
    }

    return 1;
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    return unless $self->__check_dnssec_deprecated__(%args);

    if (defined $args{'primary'} and defined $args{'multiple_primaries'}) {
        set_error_codes(1105, 'Cannot define primary and multiple_primaries at the same time.');
        return;
    }

    if (defined $args{'soa_mname'} and defined $args{'member_soa_mnames'}) {
        set_error_codes(1105, 'Cannot define soa_mname and member_soa_mnames at the same time.');
        return;
    }

    my ($type, $member);
    foreach my $key (keys %_unique_members) {
        if (defined $args{$key}) {
            if ($type) {
                if ($type ne $_unique_members{$key}) {
                    set_error_codes(1105, "Cannot define $key and $member at the same time.");
                    return;
                }
            } else {
                $type = $_unique_members{$key};
                $member = $key;
            }
        }
    }

    if (defined $args{'rpz_policy'} && $args{'rpz_policy'} eq 'SUBSTITUTE'
        && !defined $args{'substitute_name'})
    {
        set_error_codes(1103, "'substitute_name' is required if \'rpz_policy\' is $args{'rpz_policy'}." );
        return;
    }

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
    my $self = Infoblox::IBAPBase->__new__(%args);;
    bless $self , $class;

    $self->__init_instance_constants__();

    return $self;
}

sub __init_instance_constants__
{
    my $self = shift;

    $self->{__object_id_cache__} = {};

    unless ($_return_fields_initialized) {
        $_return_fields_initialized=1;

        #
        my $t = Infoblox::DNS::View->__new__();

        push @_return_fields,
          tField('view', {
                          default_no_access_ok => 1,
                          sub_fields => $t->__return_fields__(),
                         }
                );

        #
        $t=Infoblox::DNS::MSServer->__new__();
        push @_return_fields,
          tField('ms_primaries',
                 {
                  not_exist_ok => 1,
                  sub_fields => $t->__return_fields__(),
                 }
                );

        push @_return_fields,
          tField('ms_secondaries',
                 {
                  not_exist_ok => 1,
                  sub_fields => $t->__return_fields__(),
                 }
                );

        push @_return_fields,
          tField('stub_msservers',
                 {
                  not_exist_ok => 1,
                  sub_fields => $t->__return_fields__(),
                 }
                );

        $t=Infoblox::DNS::FireEye::RuleMapping->__new__();
        push @_return_fields,
          tField('fireeye_rule_mapping',
                 {
                  not_exist_ok => 1,
                  sub_fields => $t->__return_fields__(),
                 }
                );

        $t = Infoblox::Grid::NamedACL->__new__();
        my $ac_seting = return_fields_ac_setting($t->__return_fields__());
        foreach my $current ('allow_query', 'allow_transfer', 'allow_update', 'update_forwarding') {
            push @_return_fields, tField($current, { not_exist_ok => 1, %$ac_seting });
        }

        $t=Infoblox::DNS::Member::SoaMname->__new__();
        push @_return_fields,
          tField('soa_mnames',
                 {
                  not_exist_ok => 1,
                  sub_fields => $t->__return_fields__(),
                 }
                );

        $t=Infoblox::DNS::Member::SoaSerial->__new__();
        push @_return_fields,
          tField('soa_serials',
                 {
                  not_exist_ok => 1,
                  sub_fields => $t->__return_fields__(),
                 }
                );

        $t=Infoblox::DNS::Member->__new__();
        push @_return_fields,
          tField('grid_secondaries',
                  {
                   not_exist_ok => 1,
                   default_no_access_ok => 1,
                   sub_fields => $t->__return_fields__(),
                 }
                );

        $t=Infoblox::DNS::DNSSecKey->__new__();
        push @_return_fields,
          tField('dnssec_keys',
                 {
                  not_exist_ok => 1,
                  sub_fields => $t->__return_fields__(),
                 }
                );

        $t = Infoblox::DNS::DDNS::PrincipalCluster::Group->__new__();
        push @_return_fields,
            tField('ddns_principal_group',
                {'not_exist_ok' => 1, 'sub_fields' => $t->__return_fields__()});

        $t = Infoblox::Grid::DNS::ScavengingSetting->__new__();
        push @_return_fields,
            tField('reclamation_settings',
                {'not_exist_ok' => 1, 'sub_fields' => $t->__return_fields__()});

        $t = Infoblox::DNS::DNSSecKeyAlgorithm->__new__();
        push @_return_fields,
            tField('dnssec_key_params', {
                    not_exist_ok => 1,
                    sub_fields => [
                        tField('ksk_algorithms', {sub_fields => $t->__return_fields__()}),
                        tField('zsk_algorithms', {sub_fields => $t->__return_fields__()}),
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


        $t = Infoblox::Grid::CloudAPI::Info->__new__();
        push @_return_fields, tField('cloud_info', {
                not_exist_ok => 1,
                sub_fields   => $t->__return_fields__(),
        });

        $t = Infoblox::Grid::MSServer::DCNSRecordCreation->__new__();
        push @_return_fields, tField('ms_dc_ns_record_creation', {
                not_exist_ok => 1,
                sub_fields   => $t->__return_fields__(),
        });
    }


    #

    #
    $self->ms_allow_transfer('NSOnly') unless defined $self->ms_allow_transfer();
}

sub __fqdn_to_cidr__
{
    my ($self, $address, $prefix) = @_;

    if ($address =~ m/\.in-addr\.arpa$/) {
        my $sub = $address;
        $sub =~ s/\.in-addr\.arpa$//;

        if ($sub =~ m/^[0-9]+$/) {
            #
            return $sub . '.0.0.0/8';
        } elsif ($sub =~ m/^([0-9]+)\.([0-9]+)$/) {
            #
            return $2 . '.' . $1 . '.0.0/16';
        } elsif ($sub =~ m/^([0-9]+)\.([0-9]+)\.([0-9]+)$/) {
            my ($t1, $t2, $t3) = ($1, $2, $3);

            if (defined $prefix) {
                if ($prefix =~ m!^([0-9]+)/([0-9]+)$!) {
                    return $t3 . '.' . $t2 . '.' . $t1 . '.' . $1 . '/' . $2;
                } elsif ($prefix =~ m!^([0-9]+)-([0-9]+)$!) {
                    my $addrnum=$2 - $1 + 1;
                    my $bits=0;

                    while ($addrnum >= 2) {
                        $bits++;
                        $addrnum /=2;
                    }

                    return $t3 . '.' . $t2 . '.' . $t1 . '.' . $1 . '/' . (32 - $bits);
                }
                else {
                    #
                    return 'NoAddress';
                }
            } else {
                #
                return $3 . '.' . $2 . '.' . $1 . '.0/24';
            }
        } elsif ($sub =~ m/^([0-9]+)\/([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$/) {
            #
            return $5 . '.' . $4 . '.' . $3 . '.' . $1 . '/' . $2;
        } elsif ($sub =~ m/^([0-9]+)-([0-9]+)\.([0-9]+)\.([0-9]+)\.([0-9]+)$/) {
            #
            my $addrnum=$2 - $1 + 1;
            my $bits=0;

            while ($addrnum >= 2) {
                $bits++;
                $addrnum /=2;
            }

            return $5 . '.' . $4 . '.' . $3 . '.' . $1 . '/' . (32 - $bits);
        }
        else {
            #
            return 'NoAddress';
        }
    }
    elsif ($address =~ m/\.ip6\.arpa$/) {
        my $sub = $address;
        $sub =~ s/\.ip6\.arpa$//;

        my @rsub=reverse(split(/\./, $sub));
        my $netmask=($#rsub+1)*4;

        my @outaddr=split(//,'0000:0000:0000:0000:0000:0000:0000:0000');
        my $offset=0;

        foreach my $i (0 .. ($#rsub)) {
            if ($outaddr[$i+$offset] eq ':') {
                $offset++;
            }
            $outaddr[$i+$offset]=$rsub[$i];
        }

        return join('',@outaddr) . '/' . $netmask;
    }
    else {
        #
        return $address;
    }
}

sub __object_id_from_object__
{
    my ($self, $session) = @_;
    my ($fqdn, $view, @search_query);

    if ($self->__object_id__()) {
        return $self->__object_id__();
    }

    my %search_arg_fqdn;
    $search_arg_fqdn{'field'} = 'fqdn';
    return unless $search_arg_fqdn{'value'} = ibap_value_o2i_string($self->__fqdn_to_cidr__($self->name(),$self->prefix()),'name',$session);
    $search_arg_fqdn{'search_type'} = 'EXACT';
    unshift @search_query, \%search_arg_fqdn;

    my %search_arg_view;
    $search_arg_view{'field'} = 'view';
    if ($self->views()) {
        $search_arg_view{'value'} = ibap_readfield_simple_string('View','displayname',@{$self->views()}[0]->name(), 'view');
    }
    else {
        $search_arg_view{'value'} = ibap_readfield_simple('View','is_default',tBool(1),'view=(default view)');
    }
    unshift @search_query, \%search_arg_view;
    my %args;

    $args{'object_type'} = 'AllZone';
    $args{'search_fields'} = \@search_query;
    $args{'depth'} = 1;

    my $result;
    #
    my $server=$session->get_ibap_server() || return;
    eval { $result = $server->ObjectRead(\%args); };
    return $server->set_papi_error($@, $session) if $@;

    if (scalar(@{$result}) == 1) {
        return ${@{$result}[0]}{'object_id'}{'id'};
    }
    elsif (scalar(@{$result}) > 1) {
        #
        if ($self->views()) {
            set_error_codes(1012,'The search returned multiple matches for zone "' .  $search_arg_fqdn{'value'}->value() . '" in view "' . @{$self->views()}[0]->name()  . '"',$session);
        }
        else {
            set_error_codes(1012,'The search returned multiple matches for zone "' .  $search_arg_fqdn{'value'}->value()  . '" in the default view',$session);
        }
    }
    else {
        if ($self->views()) {
            set_error_codes(1012,'Could not find zone "' .  $search_arg_fqdn{'value'}->value() . '" in view "' . @{$self->views()}[0]->name()  . '"',$session);
        }
        else {
            set_error_codes(1012,'Could not find zone "' .  $search_arg_fqdn{'value'}->value() . '" in the default view',$session);
        }
    }
    return;
}

#
#
#
#
#

sub __is_auth_zone {
    my ($self, $objref) = @_;

    return (defined $objref ?
        defined $$objref{'grid_primaries'} :
        defined $self->primary()
    );
}

sub __is_stub_zone {
    my ($self, $objref) = @_;
    return (defined $objref ?
        (
            defined $$objref{'stub_from'}              or
            defined $$objref{'stub_ns_group'}          or
            defined $$objref{'stub_members'}           or
            defined $$objref{'stub_external_ns_group'}
        ) :
        (
            defined $self->stub_from()              or
            defined $self->stub_members()           or
            defined $self->stub_ns_group()          or
            defined $self->stub_external_ns_group()
        )
    );
}

sub __is_forward_zone {
    my ($self, $objref) = @_;
    return (defined $objref ?
        (
            defined $$objref{'forward_to'}                or
            defined $$objref{'forward_ns_group'}          or
            defined $$objref{'forwarding_servers'}        or
            defined $$objref{'forward_external_ns_group'}
        ) :
        (
            defined $self->forward_to()                or
            defined $self->members()                   or
            defined $self->forward_ns_group()          or
            defined $self->forward_external_ns_group()
        )
    );
}


sub __is_response_policy_zone {
    my ($self, $objref) = @_;
    return (defined $objref ?
        defined $$objref{rpz_policy} :
        defined $self->rpz_policy()
    );
}

sub __is_delegated_zone {
    my ($self, $objref) = @_;
    return (defined $objref ?
        (
            defined $$objref{'delegate_to'} or
            defined $$objref{'delegation_ns_group'}
        ) :
        (
            defined $self->delegate_to() or
            defined $self->delegation_ns_group()
        )
    );
}


sub __zone_type_from_object__ {

    my ($self, $objref) = @_;

    return $self->{__zone_type__} if $self->{__zone_type__};

    #
    #
    #

    if    (__is_response_policy_zone(@_)) { return 'ResponsePolicyZone' }
    elsif (__is_auth_zone(@_))            { return 'AuthZone' }
    elsif (__is_forward_zone(@_))         { return 'ForwardZone' }
    elsif (__is_stub_zone(@_))            { return 'StubZone' }
    elsif (__is_delegated_zone(@_))       { return 'DelegatedZone' }
    else                                  { return 'AuthZone' }
}

sub __ibap_object_type__ {

    my ($self, $function, $session, $args_ref) = @_;

    return (
        (
            $function  eq 'modify' or
            $function  eq 'add'    or
            ($function eq 'remove' and not %{$args_ref})
        ) ? $self->__zone_type_from_object__() : 'AllZone'
    );
}

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

sub __delete_sub_objects__
{
    my $self = shift;

    if (defined $self->{'remove_sub_zones'} && $self->{ 'remove_sub_zones' } =~ m/false/i) {
        return 0;
    }
    else {
        return 1;
    }
}

sub __check_use_dnssec__
{
  my $self = shift;

   if ( defined($self->{'dnssec_ksk_algorithms'})
     || defined($self->{'dnssec_zsk_algorithms'})
     || defined($self->{'next_secure_type'})

     || defined($self->{'dnssec_ksk_rollover_interval'})
     || defined($self->{'dnssec_signature_expiration'})
     || defined($self->{'dnssec_zsk_rollover_interval'})
     || defined($self->{'dnssec_nsec3_salt_min_length'})
     || defined($self->{'dnssec_nsec3_salt_max_length'})
     || defined($self->{'dnssec_nsec3_iterations'})
     || defined($self->{'dnssec_zsk_rollover_mechanism'})
     || defined($self->{'dnssec_enable_ksk_auto_rollover'})
     || defined($self->{'dnssec_ksk_rollover_notification_config'})
     || defined($self->{'dnssec_ksk_email_notification_enabled'})
     || defined($self->{'dnssec_ksk_snmp_notification_enabled'})
  )
  {
    $self->{'use_dnssec'}=1;
  } else {
    $self->{'use_dnssec'}=0;
  }
}

sub __dnssec_defaults__
{
    #
    #
    #
    #

    my $self = shift;

    my $ksk_algorithm = Infoblox::DNS::DNSSecKeyAlgorithm->new(
        algorithm => 'RSASHA256',
        size      => 1024,
    );

    my $zsk_algorithm = Infoblox::DNS::DNSSecKeyAlgorithm->new(
        algorithm => 'RSASHA256',
        size      => 2048,
    );

    return ('dnssec_ksk_algorithms' => [$ksk_algorithm],
            'dnssec_zsk_algorithms' => [$zsk_algorithm],
            'next_secure_type'      => 'NSEC3',
    );
}

sub __post_insert_hook__
{
  #
  my ($self, $server, $session) = @_;

  #
  $self->{__zone_type__} = $self->__zone_type_from_object__();

  $self->{'__internal_session_cache_ref__'}=\$session;

  if(defined $self->{'dnssec_signed'} && $self->{'dnssec_signed'} eq "true") {

    my $res = $session->__dnssec_operation__($self->__object_id__(), 'SIGN');

    if (!$res) {
      $self->{'dnssec_signed'} = 'false';
      set_error_codes(Infoblox->status_code(), Infoblox->status_detail(), $session);

      append_error_codes('', "Zone added, but unable to sign the zone. " .
          "Try to retrieve the zone and set dnssec_signed to \'true\' "  .
          "in the retrieved object.", $session);
    } else {
        $self->__refresh_dnssec_data__();
    }

    return $res;

  } else {
    $self->{'dnssec_signed'}='false';
    return 1;
  }
}


#
#
#


sub __i2o_allow__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
        my @nodes_list = @{$$ibap_object_ref{$current}};
        my @newlist;

        foreach my $addy (@nodes_list) {
            my $converted = ${$addy}{'address_string'};
            if ($converted eq 'Any') {
                $converted = 'any';
            }

            if (${$addy}{'permission'} eq 'ALLOW') {
                push @newlist, $converted;
            } else {
                push @newlist, '!'.$converted;
            }
        }

        return \@newlist;
    } else {
        return [];
    }
}

sub __i2o_ns_group__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $member_pfx = {
        'ib:StubZone'           => 'stub_',
        'ib:ForwardZone'        => 'forward_',
        'ib:AuthZone'           => '',
        'ib:ResponsePolicyZone' => '',
        'ib:DelegatedZone'      => 'delegation_',
    }->{ref $ibap_object_ref};

    my $member_name = {
        'ns_group_external'   => 'external_ns_group',
        'ns_group'            => 'ns_group',
        'delegation_ns_group' => 'ns_group',
    }->{$current};

    my $member = $member_pfx . $member_name;

    if (
        $member eq 'stub_external_ns_group' or
        $member eq 'delegation_ns_group'    or
        not $member_pfx
    ) {
        return $$ibap_object_ref{$current}{group_name};
    }

    $self->$member($$ibap_object_ref{$current}{group_name});
    return undef;
}

sub __i2o_managed__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($$ibap_object_ref{$current} && $$ibap_object_ref{$current} eq 'NONE') {
        return 'false';
    } else {
        return 'true';
    }
}

sub __i2o_ms_transfer__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($$ibap_object_ref{$current} eq 'ADDRESS_AC') {
        $self->ms_allow_transfer(ibap_i2o_address_ac_list($self,$session,'ms_allow_transfer',$ibap_object_ref,$return_object_cache_ref));
    } else {
        if ($$ibap_object_ref{$current} eq 'NONE') {
            return 'None';
        } elsif ($$ibap_object_ref{$current} eq 'ANY_NS') {
            return 'NSOnly';
        } elsif ($$ibap_object_ref{$current} eq 'ANY') {
            return 'Any';
        }
        else {
            #
            return undef;
        }
    }
}

sub __i2o_policy__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($$ibap_object_ref{$current}) {
        my $policyname=$$ibap_object_ref{'record_name_policy'}{'policy_name'};
        $policyname =~ s/.*\$//;

        $self->host_name_restriction_policy($policyname);
        if ($policyname eq 'Strict Hostname Checking') {
            if ($$ibap_object_ref{'use_check_names_policy'}) {
                my $policy=$$ibap_object_ref{'effective_check_names_policy'};

                if ($policy eq 'FAIL') {
                    return 'fail';
                } elsif ($policy eq 'WARN') {
                    return 'warn';
                }
            }
        }
    }
}

sub __i2o_srgs__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($$ibap_object_ref{$current}) {
        my @srg_list = @{$$ibap_object_ref{$current}};
        my @newlist;

        foreach my $srg (@srg_list) {
            push @newlist , $$srg{'srg_name'};
        }

        return \@newlist;
    } else {
        return [];
    }
}

sub __i2o_soa_mnames__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($$ibap_object_ref{$current}) {
        my @soa_list;
        foreach my $item (@{$$ibap_object_ref{$current}}) {
            my $obj = Infoblox::DNS::Member::SoaMname->__new__();
            $obj->__ibap_to_object__($item, $session->get_ibap_server(), $session, $return_object_cache_ref);
            push @soa_list, $obj;
        }
        return \@soa_list;
    } else {
        return [];
    }
}

sub __i2o_soa_serials__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($$ibap_object_ref{$current}) {
        my @soa_list;
        foreach my $item (@{$$ibap_object_ref{$current}}) {
            my $obj = Infoblox::DNS::Member::SoaSerial->__new__();
            $obj->__ibap_to_object__($item, $session->get_ibap_server(), $session, $return_object_cache_ref);
            push @soa_list, $obj;
        }
        return \@soa_list;
    } else {
        return [];
    }
}


sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    $self->{'__initializing_from_ibap__'} = 1;

    #
    if (ref($ibap_object_ref) =~ /ib:(\w+)/) {
        $self->{__zone_type__} = $1 if ref $ibap_object_ref ne 'ib:AutoZone';
    }

    #

    $self->{ '__internal_session_cache_ref__' } = \$session;
    #
    #
    $self->{'dnssec_signed'}=undef;

    #
    #
    #

    $$ibap_object_ref{'grid_primary_shared_with_ms_parent_delegation'} = 0 unless defined $$ibap_object_ref{'grid_primary_shared_with_ms_parent_delegation'};
    $$ibap_object_ref{'ms_read_only'} = 0 unless defined $$ibap_object_ref{'ms_read_only'};
    $$ibap_object_ref{'ms_sync_disabled'} = 0 unless defined $$ibap_object_ref{'ms_sync_disabled'};
    $$ibap_object_ref{'ms_ad_integrated'} = 0 unless defined $$ibap_object_ref{'ms_ad_integrated'};

    if (ref $ibap_object_ref eq 'ib:AuthZone' || ref $ibap_object_ref eq 'ib:ResponsePolicyZone') {
        $$ibap_object_ref{'ms_secondaries'} = [] unless defined $$ibap_object_ref{'ms_secondaries'};
        $$ibap_object_ref{'ms_primaries'} = [] unless defined $$ibap_object_ref{'ms_primaries'};
        $$ibap_object_ref{'external_secondaries'} = [] unless defined $$ibap_object_ref{'external_secondaries'};
        $$ibap_object_ref{'grid_primaries'} = [] unless defined $$ibap_object_ref{'grid_primaries'};
        $$ibap_object_ref{'grid_secondaries'} = [] unless defined $$ibap_object_ref{'grid_secondaries'};
        $$ibap_object_ref{'create_underscore_zones'} = 0 unless defined $$ibap_object_ref{'create_underscore_zones'};
        $$ibap_object_ref{'disable_forwarding'} = 0 unless defined $$ibap_object_ref{'disable_forwarding'};
        $$ibap_object_ref{'use_allow_query'} = 0 unless defined $$ibap_object_ref{'use_allow_query'};
        $$ibap_object_ref{'use_zone_transfer_setting'} = 0 unless defined $$ibap_object_ref{'use_zone_transfer_setting'};
        $$ibap_object_ref{'use_update_setting'} = 0 unless defined $$ibap_object_ref{'use_update_setting'};
        $$ibap_object_ref{'use_external_primary'} = 0 unless defined $$ibap_object_ref{'use_external_primary'};
        $$ibap_object_ref{'use_grid_zone_timer'} = 0 unless defined $$ibap_object_ref{'use_grid_zone_timer'};
        $$ibap_object_ref{'use_import_from'} = 0 unless defined $$ibap_object_ref{'use_import_from'};
        $$ibap_object_ref{'use_check_names_policy'} = 0 unless defined $$ibap_object_ref{'use_check_names_policy'};
        $$ibap_object_ref{'use_record_name_policy'} = 0 unless defined $$ibap_object_ref{'use_record_name_policy'};
        $$ibap_object_ref{'use_soa_email'} = 0 unless defined $$ibap_object_ref{'use_soa_email'};
        $$ibap_object_ref{'allow_gss_tsig_for_underscore_zone'} = 0 unless defined $$ibap_object_ref{'allow_gss_tsig_for_underscore_zone'};
        $$ibap_object_ref{'allow_gss_tsig_zone_updates'} = 0 unless defined $$ibap_object_ref{'allow_gss_tsig_zone_updates'};
        $$ibap_object_ref{'allow_update_forwarding'} = 0 unless defined $$ibap_object_ref{'allow_update_forwarding'};
        $$ibap_object_ref{'use_allow_active_dir'} = 0 unless defined $$ibap_object_ref{'use_allow_active_dir'};
        $$ibap_object_ref{'use_allow_update_forwarding'} = 0 unless defined $$ibap_object_ref{'use_allow_update_forwarding'};
        $$ibap_object_ref{'use_dnssec'} = 0 unless defined $$ibap_object_ref{'use_dnssec'};
        $$ibap_object_ref{'is_dnssec_signed'} = 0 unless defined $$ibap_object_ref{'is_dnssec_signed'};
        $$ibap_object_ref{'copy_xfer_to_notify'} = 0 unless defined $$ibap_object_ref{'copy_xfer_to_notify'};
        $$ibap_object_ref{'use_copy_xfer_to_notify'} = 0 unless defined $$ibap_object_ref{'use_copy_xfer_to_notify'};
        $$ibap_object_ref{'is_multimaster'} = 0 unless defined $$ibap_object_ref{'is_multimaster'};
        $$ibap_object_ref{'dns_integrity_check_enabled'} = 0 unless defined $$ibap_object_ref{'dns_integrity_check_enabled'};
        $$ibap_object_ref{'dns_integrity_check_verbose_logging'} = 0 unless defined $$ibap_object_ref{'dns_integrity_check_verbose_logging'};
        $$ibap_object_ref{'dnssec_key_params'}{'ksk_snmp_notification_enabled'} = 0 unless defined $$ibap_object_ref{'dnssec_key_params'}{'ksk_snmp_notification_enabled'};
        $$ibap_object_ref{'dnssec_key_params'}{'ksk_email_notification_enabled'} = 0 unless defined $$ibap_object_ref{'dnssec_key_params'}{'ksk_email_notification_enabled'};

        $$ibap_object_ref{'ddns_restrict_patterns_list'} = [] unless defined $$ibap_object_ref{'ddns_restrict_patterns_list'};
        $$ibap_object_ref{'ddns_restrict_patterns'} = 0 unless defined $$ibap_object_ref{'ddns_restrict_patterns'};
        $$ibap_object_ref{'use_ddns_patterns_restriction'} = 0 unless defined $$ibap_object_ref{'use_ddns_patterns_restriction'};
        $$ibap_object_ref{'ddns_restrict_static'} = 0 unless defined $$ibap_object_ref{'ddns_restrict_static'};
        $$ibap_object_ref{'use_ddns_restrict_static'} = 0 unless defined $$ibap_object_ref{'use_ddns_restrict_static'};
        $$ibap_object_ref{'ddns_restrict_protected'} = 0 unless defined $$ibap_object_ref{'ddns_restrict_protected'};
        $$ibap_object_ref{'use_ddns_restrict_protected'} = 0 unless defined $$ibap_object_ref{'use_ddns_restrict_protected'};
        $$ibap_object_ref{'ddns_restrict_secure'} = 0 unless defined $$ibap_object_ref{'ddns_restrict_secure'};
        $$ibap_object_ref{'ddns_principal_tracking'} = 0 unless defined $$ibap_object_ref{'ddns_principal_tracking'};
        $$ibap_object_ref{'ddns_force_creation_timestamp_update'} = 0 unless defined $$ibap_object_ref{'ddns_force_creation_timestamp_update'};
        $$ibap_object_ref{'use_ddns_force_creation_timestamp_update'} = 0 unless defined $$ibap_object_ref{'use_ddns_force_creation_timestamp_update'};
        $$ibap_object_ref{'use_ddns_principal_security'} = 0 unless defined $$ibap_object_ref{'use_ddns_principal_security'};
        $$ibap_object_ref{'use_reclamation'} = 0 unless defined $$ibap_object_ref{'use_reclamation'};

        #
        if($$ibap_object_ref{'use_external_primary'}) {
            delete $$ibap_object_ref{'grid_primaries'};
            delete $$ibap_object_ref{'ms_primaries'};
        }

        $self->override_grid_zone_timer('false');
        $self->override_grid_email('false');
        $self->override_soa_mname('false');
        $self->do_host_abstraction('false');
        $self->create_ptr_for_bulk_hosts('false');
        $self->create_ptr_for_hosts('false');
        $self->disable_forwarding('false');

        $self->allow_update_forwarding([]);
        $self->allow_update([]);
        $self->ad_servers([]);
        $self->allow_query([]);
        $self->allow_transfer([]);
        $self->shared_record_groups([]);
    }
    elsif (ref $ibap_object_ref eq 'ib:ForwardZone') {
        $$ibap_object_ref{'forward_to'} = [] unless defined $$ibap_object_ref{'forward_to'};
        $$ibap_object_ref{'forwarding_servers'} = [] unless defined $$ibap_object_ref{'forwarding_servers'};
        $$ibap_object_ref{'forwarders_only'} =0 unless defined $$ibap_object_ref{'forwarders_only'};
    }
    elsif (ref $ibap_object_ref eq 'ib:StubZone') {
        $$ibap_object_ref{'stub_from'} = [] unless defined $$ibap_object_ref{'stub_from'};
        $$ibap_object_ref{'stub_members'} = [] unless defined $$ibap_object_ref{'stub_members'};
        $$ibap_object_ref{'stub_msservers'} = [] unless defined $$ibap_object_ref{'stub_msservers'};
        $$ibap_object_ref{'disable_forwarding'} = 0 unless defined $$ibap_object_ref{'disable_forwarding'};
        $$ibap_object_ref{'use_soa_email'} = 0 unless defined $$ibap_object_ref{'use_soa_email'};

        $self->override_soa_mname('false');
        $self->disable_forwarding('false');
    }
    elsif (ref $ibap_object_ref eq 'ib:DelegatedZone') {
        $$ibap_object_ref{'use_delegated_ttl'} = 0 unless defined $$ibap_object_ref{'use_delegated_ttl'};
        $$ibap_object_ref{'delegate_to'} = [] unless defined $$ibap_object_ref{'delegate_to'};
        $$ibap_object_ref{'enable_rfc2317_exclusion'} = 0 unless defined $$ibap_object_ref{'enable_rfc2317_exclusion'};
    }

    if (ref $ibap_object_ref eq 'ib:ResponsePolicyZone') {
        $$ibap_object_ref{'rpz_drop_ip_rule_enabled'}=0 unless defined $$ibap_object_ref{'rpz_drop_ip_rule_enabled'};
        $$ibap_object_ref{'use_rpz_drop_ip_rule'}=0 unless defined $$ibap_object_ref{'use_rpz_drop_ip_rule'};
    }

    if (ref $ibap_object_ref eq 'ib:AuthZone') {

        $self->{'ms_dc_ns_record_creation'} = [] unless $$ibap_object_ref{'ms_dc_ns_record_creation'};
    }

    $self->disable('false');
    $self->locked('false');

    #
    $self->secondaries(undef);

    foreach my $current (sort keys %$ibap_object_ref) {
        next if $current eq 'record_name_policy';
        next if $current eq 'use_external_primary';

        my $member;

        if (defined $_reverse_name_mappings{$current}) {
            $member = $_reverse_name_mappings{$current};
        }
        else {
            $member = $current;
        }

        if ($self->can($member)) {
            if (defined $_ibap_to_object{$current}) {
                if ($current eq 'external_primaries') {
                    my $listref=$_ibap_to_object{$current}($self, $session, $current, $ibap_object_ref, $return_object_cache_ref);
                    $self->$member($listref) if $listref && scalar(@{$listref}) && $$ibap_object_ref{'use_external_primary'};
                }
                else {
                    $self->$member($_ibap_to_object{$current}($self, $session, $current, $ibap_object_ref, $return_object_cache_ref), $return_object_cache_ref);
                }
            } else {
                $self->$member($$ibap_object_ref{$current});
            }
        }
    }

    $self->__object_id__($$ibap_object_ref{'object_id'}{'id'});

    if (ref $ibap_object_ref eq 'ib:AuthZone' || ref $ibap_object_ref eq 'ib:ResponsePolicyZone') {
        $self->{'override_ddns_patterns_restriction'}      = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_patterns_restriction'});
        $self->{'override_ddns_restrict_static'}           = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_restrict_static'});
        $self->{'override_ddns_restrict_protected'}        = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_restrict_protected'});
        $self->{'override_ddns_principal_security'}        = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_principal_security'});
        $self->{'override_ddns_force_creation_timestamp_update'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_force_creation_timestamp_update'});
        $self->{'override_scavenging_settings'}            = ibap_value_i2o_boolean($$ibap_object_ref{'use_reclamation'});
    }


    #
    #
    #

    $self->{'use_notify_delay'} = $$ibap_object_ref{'use_notify_delay'};
    delete $self->{'notify_delay'} unless $self->{'use_notify_delay'};

    #
    #
    if (defined $$ibap_object_ref{'display_domain'}) {
        $self->{'display_domain'} = $$ibap_object_ref{'display_domain'};
    }

    if (defined $$ibap_object_ref{'use_allow_query'}) {
        $self->{'use_allow_query'}=$$ibap_object_ref{'use_allow_query'};
        if ($$ibap_object_ref{'use_allow_query'} != 1) {
            $self->allow_query(undef);
        }
    }

    if (defined $$ibap_object_ref{'use_zone_transfer_setting'}) {
        $self->{'use_zone_transfer_setting'}=$$ibap_object_ref{'use_zone_transfer_setting'};
        if ($$ibap_object_ref{'use_zone_transfer_setting'} != 1) {
            $self->allow_transfer(undef);
        }
    }

    if (defined $$ibap_object_ref{'use_update_setting'}) {
        $self->{'use_update_setting'}=$$ibap_object_ref{'use_update_setting'};
        if ($$ibap_object_ref{'use_update_setting'} != 1) {
            $self->allow_update(undef);
        }
    }

    if (defined $$ibap_object_ref{'use_allow_update_forwarding'}) {
        $self->{'use_allow_update_forwarding'}=$$ibap_object_ref{'use_allow_update_forwarding'};
        if ($$ibap_object_ref{'use_allow_update_forwarding'} != 1) {
            $self->allow_update_forwarding(undef);
        }
    }

    if (defined $$ibap_object_ref{'use_import_from'}) {
        $self->{'use_import_from'}=$$ibap_object_ref{'use_import_from'};
        if ($$ibap_object_ref{'use_import_from'} != 1) {
            $self->import_from(undef);
        }
    }

    if (defined $$ibap_object_ref{'use_delegated_ttl'}) {
        $self->override_delegated_ttl(ibap_value_i2o_boolean($$ibap_object_ref{'use_delegated_ttl'}));
    }

    if (defined $$ibap_object_ref{'use_copy_xfer_to_notify'}) {
        $self->override_copy_xfer_to_notify(ibap_value_i2o_boolean($$ibap_object_ref{'use_copy_xfer_to_notify'}));
    }

    $self->{'use_dnssec'}=$$ibap_object_ref{'use_dnssec'};
    if(!defined $$ibap_object_ref{'use_dnssec'} || $$ibap_object_ref{'use_dnssec'} != 1)
    {
      foreach (
          'dnssec_ksk_rollover_interval',
          'dnssec_signature_expiration',
          'dnssec_zsk_rollover_interval',
          'dnssec_nsec3_salt_min_length',
          'dnssec_nsec3_salt_max_length',
          'dnssec_nsec3_iterations',
          'dnssec_zsk_rollover_mechanism',
          'dnssec_enable_ksk_auto_rollover',
          'dnssec_ksk_rollover_notification_config',
          'dnssec_ksk_snmp_notification_enabled',
          'dnssec_ksk_email_notification_enabled',
          'dnssec_ksk_algorithm',
          'dnssec_ksk_size',
          'dnssec_zsk_algorithm',
          'dnssec_zsk_size',
          'dnssec_ksk_algorithms',
          'dnssec_zsk_algorithms',
          'next_secure_type',
      ) {
          delete $self->{$_};
      }
  }

    #
    #
    if (defined $$ibap_object_ref{'allow_update_forwarding'}) {
        $self->{'use_sec_update_forwarding'} = $$ibap_object_ref{'allow_update_forwarding'};
    }

    #
    if ($self->ns_group()) {
        $self->multiple_primaries(undef);
        $self->secondaries(undef);
    }

    if ($self->forward_ns_group())          { $self->members(undef) }
    if ($self->forward_external_ns_group()) { $self->forward_to(undef) }
    if ($self->stub_ns_group())             { $self->stub_members(undef) }
    if ($self->stub_external_ns_group())    { $self->stub_from(undef) }
    if ($self->delegation_ns_group())       { $self->delegate_to(undef) }


    if ($self->secondaries()) {
        #
        my @newlist;
        my $t = $self->secondaries();

        my (@middle, @post);
        foreach (@$t) {
            if (ref($_) eq 'Infoblox::DNS::Member') {
                push @newlist, $_;
            } elsif (ref($_) eq 'Infoblox::DNS::MSServer') {
                push @middle, $_;
            } else {
                push @post, $_;
            }
        }

        push @newlist, @middle if @middle;
        push @newlist, @post if @post;
        $self->secondaries(\@newlist);
    }

    if (defined $$ibap_object_ref{'soa_email'} && $$ibap_object_ref{'use_soa_email'} != 1) {
        $self->override_grid_email('false');
    }

    if (ref $ibap_object_ref eq 'ib:ResponsePolicyZone') {
        $self->{'override_rpz_drop_ip_rule'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_rpz_drop_ip_rule'});
    }


    delete $self->{'__initializing_from_ibap__'};
    return;
}

#
#
#

sub __o2i_fqdn_search__
{
    my ($self, $session, $current, $tempref, $type) = @_;

    if ($$tempref{$current}) {
        my $address=$self->__fqdn_to_cidr__($$tempref{$current},$$tempref{'prefix'});

        if ($address eq 'NoAddress') {
            #

            my %extra_arg;
            $extra_arg{'field'} = 'display_domain';
            $extra_arg{'value'} = ibap_value_o2i_string($$tempref{$current});
            return (1,1,undef,\%extra_arg);
        }
        else {
            return (1,0, ibap_value_o2i_string($address));
        }
    }
    else {
        return (1,1,undef);
    }
}

sub __o2i_assoctype_search__
{
    my ($self, $session, $current, $tempref, $type) = @_;

    if ($$tempref{$current}) {
        unless ($$tempref{$current} =~ m/microsoft/i) {
            set_error_codes(1104,'Invalid value ' . $$tempref{$current} . ' for search member primary_association_type.', $session );
            return undef;
        }
        return (1,0,ibap_value_o2i_string(capitalize_first_letter($$tempref{$current})));
    }
    else {
        return (1,1,undef);
    }
}

sub __search_mapping_hook_post__
{
    my ($self, $session, $type, $argsref, $out_search_fields_ref, $out_search_types_ref, $out_search_matches_ref) = @_;

    if (defined $$out_search_fields_ref{'rpz_policy'} ||
        defined $$out_search_fields_ref{'is_feed_zone'})
    {
        $out_search_fields_ref->{'zone_type'}  = ibap_value_o2i_string('RESPONSE_POLICY');
        $out_search_types_ref->{'zone_type'}   = 'EXACT';

        #
        #
        #
        if (defined $$out_search_fields_ref{'is_feed_zone'})
        {
            my $value = $out_search_fields_ref->{'is_feed_zone'};
            delete $out_search_fields_ref->{'is_feed_zone'};
            delete $out_search_types_ref->{'is_feed_zone'};
            if (defined $out_search_matches_ref->{'is_feed_zone'}){
                delete $out_search_matches_ref->{'is_feed_zone'};
            }

            #
            $out_search_fields_ref->{'primary_association_type'} = ibap_value_o2i_string('External');
            if (ibap_value_i2o_boolean($value->value()) ne 'false'){
                $out_search_types_ref->{'primary_association_type'} = 'EXACT';
            }
            else {
                $out_search_types_ref->{'primary_association_type'} = 'EXACT_NEGATIVE';
            }
        }
    }

    return 1;
}

sub __o2i_fqdn__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    my $t = ibap_value_o2i_string($self->__fqdn_to_cidr__($$tempref{$current},$$tempref{'prefix'}),'name',$session);
    unless ($t) {
        push @return_args, 0;
        push @return_args, 1;
        return @return_args;
    }
    else {
        push @return_args, 1;
        push @return_args, 0;
        push @return_args, $t;
    }

    my %sub_write_arg;

    $sub_write_arg{'field'} = 'zone_format';
    if (($$tempref{$current} =~ m/\.ip6\.arpa$/) ||
        (($$tempref{$current} =~ m!/!) &&
         ($$tempref{$current} =~ m!:!))) {
        $sub_write_arg{'value'} = tString('IPV6');
    } elsif (($$tempref{$current} =~ m/\.in-addr\.arpa$/) || ($$tempref{$current} =~ m!\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/\d{1,2}!)) {
        $sub_write_arg{'value'} = tString('IPV4');
    } else {
        $sub_write_arg{'value'} = tString('FORWARD');
    }
    push @return_args, \%sub_write_arg;
    return @return_args;
}

sub __o2i_ns_group__ {

    my ($self, $session, $current, $tempref) = @_;

    my $zonetype = $self->__zone_type_from_object__();

    if (
        (($current eq 'forward_ns_group' or $current eq 'forward_external_ns_group') and $zonetype eq 'ForwardZone') or
        (($current eq 'stub_ns_group' or $current eq 'stub_external_ns_group') and $zonetype eq 'StubZone')          or
        ($current eq 'ns_group' and array_contains($zonetype, ['AuthZone', 'ResponsePolicyZone']))                   or
        ($current eq 'delegation_ns_group' and $zonetype eq 'DelegatedZone')
    ) {

        my $val = ref $$tempref{$current} ? $$tempref{$current}{'name'} : $$tempref{$current};

        return (defined $val ?
            (1, 0, ibap_readfield_simple_string('AllNsGroup', 'group_name', $val, $current)) :
            (1, 0, undef)
        );
    } else {
        return (1, 1, undef);
    }
}

sub __o2i_record_name_policy__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;
    if (!defined($$tempref{$current})){
       return (1, 1, undef);
    }
    elsif( $$tempref{$current} eq '') {
        push @return_args, 0;
        push @return_args, 1;

        set_error_codes(1012, 'Empty record name policy is not allowed.', $session );
    }
    else {
        push @return_args, 1;
        push @return_args, 0;
        push @return_args, ibap_readfield_simple_string('RecordNamePolicy','policy_name',$$tempref{$current}, $current);
    }

    return @return_args;
}

sub __o2i_bind_policy__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if ($$tempref{$current}) {
        push @return_args, 1;
        push @return_args, 0;

        if ( $$tempref{$current} eq 'fail') {
            push @return_args, ibap_value_o2i_string('FAIL');
        }
        else {
            push @return_args, ibap_value_o2i_string('WARN');
        }
    }
    else {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}

sub __o2i_allow__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
        push @return_args, 1;
        push @return_args, 0;

        if (scalar(@{$$tempref{$current}} == 0)) {
            my @empty_array;
            push @return_args, tIBType('ArrayOfaddress_ac', \@empty_array);
        }
        else {
            my @nodes_list = @{$$tempref{$current}};
            my @newlist;

            foreach my $addy (@nodes_list) {
                push @newlist, ibap_value_o2i_address_ac($addy,'',$session);
            }
            push @return_args, tIBType('ArrayOfaddress_ac', \@newlist);
        }
    } else {
        #

        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}

sub __o2i_keys__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
        push @return_args, 1;
        push @return_args, 0;

        if (scalar(@{$$tempref{$current}} == 0)) {
            my @empty_array;
            push @return_args, tIBType('ArrayOftsig_ac',\@empty_array);
        }
        else {
            my @keys_list = @{$$tempref{$current}};
            my @newlist;

            foreach my $key (@keys_list) {
                push @newlist, ibap_value_o2i_tsig_ac($key,'',$session);
            }

            push @return_args, tIBType('ArrayOftsig_ac',\@newlist);
        }
    } else {
        #

        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}

sub __o2i_ms_transfer__
{
    my ($self, $session, $current, $tempref) = @_;

    my @return_args = (1, 0);

    if (!defined $$tempref{$current}) {
        return (1, 1, undef);
    } elsif (ref($$tempref{$current})) {
        push @return_args, ibap_value_o2i_string('ADDRESS_AC');

        my @data = ibap_o2i_address_ac_list($self, $session, $current, $tempref);

        if (@data and $data[0]) {
            my %extra_arg;
            $extra_arg{'field'} = 'ms_allow_transfer';
            $extra_arg{'value'} = $data[2];
            push @return_args, \%extra_arg;
        } else {
            return (0);
        }
    } else {
        if ($$tempref{$current} eq 'NSOnly') {
            push @return_args, ibap_value_o2i_string('ANY_NS');
        }
        else {
            push @return_args, ibap_value_o2i_string(uc($$tempref{$current}));
        }
    }

    return @return_args;
}

sub __o2i_srgs__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
        push @return_args, 1;
        push @return_args, 0;

        if (scalar(@{$$tempref{$current}} == 0)) {
            my @empty_array;
            push @return_args, tIBType('ArrayOfField', \@empty_array);
        }
        else {
            my @keys_list = @{$$tempref{$current}};
            my @newlist;
            my %seen = ();

            foreach my $key (@keys_list) {
                if($seen{$key}) {
                    set_error_codes(1002,"shared_record_groups has duplicate element '$key'",$session);
                    my @treturn_args;
                    push @treturn_args, 0;
                    return @treturn_args;
                }

                $seen{$key} = 1;

                my @sub_write_fields;
                my %sub_write_arg;
                $sub_write_arg{'field'} = 'srg';
                $sub_write_arg{'value'} = ibap_readfield_simple_string('SharedRecordGroup','name', $key, '1003=shared_record_group='.$key);
                unshift @sub_write_fields, \%sub_write_arg;

                my %sub_write_arg_2;
                $sub_write_arg_2{'field'} = 'zone';
                $sub_write_arg_2{'value'} = tObjId('..');
                unshift @sub_write_fields, \%sub_write_arg_2;

                my %sub_write_arg2;
                $sub_write_arg2{'write_fields'} = \@sub_write_fields;
                $sub_write_arg2{'object_type'} = 'SRGZone';

                push @newlist, \%sub_write_arg2;
            }
            push @return_args, tIBType('ArrayOfsub_object', \@newlist);
        }
    } else {
        #

        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}

sub __o2i_primary__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

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
    #

    push @return_args, 1;
    push @return_args, 1;
    push @return_args, undef;

    my %extra_ms_primaries;
    $extra_ms_primaries{'field'} = 'ms_primaries';
    $extra_ms_primaries{'value'} = tIBType('ArrayOfms_dns_server',[]);
    push @return_args, \%extra_ms_primaries;

    my %extra_grid_primaries;
    $extra_grid_primaries{'field'} = 'grid_primaries';
    $extra_grid_primaries{'value'} = tIBType('ArrayOfmember_server',[]);
    push @return_args, \%extra_grid_primaries;

    my %extra_external_primaries;
    $extra_external_primaries{'field'} = 'external_primaries';
    $extra_external_primaries{'value'} = tIBType('ArrayOfext_server',[]);
    push @return_args, \%extra_external_primaries;

    if(ref( $$tempref{$current} ) eq 'ARRAY') {
        my @nodes_list = @{$$tempref{$current}};
        my @newlist;

        if (@nodes_list) {
            if (ref($nodes_list[0]) eq 'Infoblox::DNS::Member') {
                foreach my $member (@{$self->{'multiple_primaries'}}) {
                    push @newlist, ibap_value_o2i_member_server($member, $session, $self, 'member_server');
                }
                $extra_grid_primaries{'value'} = tIBType('ArrayOfmember_server',\@newlist);
            } elsif (ref($nodes_list[0]) eq 'Infoblox::DNS::MSServer') {
                foreach my $member (@nodes_list) {
                    push @newlist, ibap_value_o2i_dns_msserver_convert($member, $session, $self, 'ms_dns_server');
                }

                $extra_ms_primaries{'value'} = tIBType('ArrayOfms_dns_server',\@newlist);
            } else {
                foreach my $member (@nodes_list) {
                    push @newlist, ibap_value_o2i_ext_server($member,'external_primaries',$session);
                }
                $extra_external_primaries{'value'} = tIBType('ArrayOfext_server', \@newlist);
            }
        }
    } else {
        return (1,1,undef) unless $self->__zone_type_from_object__() eq 'AuthZone';
    }

    return @return_args;
}

sub __o2i_nameserver__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;
    my $type = $self->__zone_type_from_object__();

    if (defined $$tempref{$current}) {
        if (scalar(@{$$tempref{$current}} == 0)) {
            #
            #
            #
            #

            my (%sub_write_arg,%sub_write_arg2,%sub_write_arg3);
            if ($current eq 'secondaries' && $type eq 'AuthZone') {
                $sub_write_arg{'field'} = 'grid_secondaries';
                $sub_write_arg2{'field'} = 'external_secondaries';
                $sub_write_arg3{'field'} = 'ms_secondaries';
            } elsif ($current eq 'members' && $type eq 'ForwardZone') {
                $sub_write_arg{'field'} = 'forwarding_servers';
            } elsif ($current eq 'forward_to' && $type eq 'ForwardZone') {
                $sub_write_arg{'field'} = 'forward_to';
            } elsif ($current eq 'delegate_to' && $type eq 'DelegateZone') {
                $sub_write_arg{'field'} = 'delegate_to';
            } elsif ($current eq 'stub_from' && $type eq 'StubZone') {
                $sub_write_arg{'field'} = 'stub_from';
            } elsif ($current eq 'stub_members' && $type eq 'StubZone') {
                $sub_write_arg{'field'} = 'stub_members';
                $sub_write_arg3{'field'} = 'stub_msservers';
            } elsif ($current eq 'secondaries' && $type eq 'ResponsePolicyZone') {
                $sub_write_arg{'field'} = 'grid_secondaries';
                $sub_write_arg2{'field'} = 'external_secondaries';
            }

            push @return_args, 1;
            push @return_args, 1;
            push @return_args, undef;

            if (defined $sub_write_arg{'field'}) {
                $sub_write_arg{'value'} = tIBType('ArrayOfmember_server', []);
                push @return_args, \%sub_write_arg;
            }

            if (defined $sub_write_arg2{'field'}) {
                $sub_write_arg2{'value'} = tIBType('ArrayOfext_server', []);
                push @return_args, \%sub_write_arg2;
            }

            if (defined $sub_write_arg3{'field'}) {
                $sub_write_arg3{'value'} = tIBType('ArrayOfms_dns_server', []);
                push @return_args, \%sub_write_arg3;
            }
        }
        else {
            my @nodes_list = @{$$tempref{$current}};
            my @newlist_member;
            my @newlist_server;
            my @newlist_ms;

#
#

            foreach my $member (@nodes_list) {
                if(ref( $member ) eq 'Infoblox::DNS::Nameserver') {
                    my %sub_write_arg;

                    if (defined $member->name()) {
                        my @tfail;
                        push @tfail, 0;

                        return @tfail unless $sub_write_arg{'name'} = ibap_value_o2i_string($member->name(),'name',$session);
                    }
                    else {
                        $sub_write_arg{'name'} = '';
                    }

                    if (defined $member->ipv4addr()) {
                        $sub_write_arg{'address'} = $member->ipv4addr();
                    }
                    elsif (defined $member->ipv6addr()) {
                        $sub_write_arg{'address'} = $member->ipv6addr();
                    }
                    else {
                        $sub_write_arg{'address'} = '';
                    }

                    if (defined($member->stealth()) && $member->stealth() =~ m/true/i) {
                        $sub_write_arg{'stealth'} = tBool(1);
                    }
                    else {
                        $sub_write_arg{'stealth'} = tBool(0);
                    }

                    if (defined $member->TSIGname()) {
                        $sub_write_arg{'use_tsig_key'} = tBool(1);
                        $sub_write_arg{'tsig_key_name'} = $member->TSIGname();
                        if ($member->TSIGname() eq ':2xCOMPAT') {
                            $sub_write_arg{'use_2x_tsig_key'} = tBool(1);
                        }
                        else {
                            $sub_write_arg{'tsig_key_alg'} = $member->TSIGalgorithm();
                            $sub_write_arg{'tsig_key'} = $member->TSIGkey();
                        }
                    }

                    push @newlist_server, tIBType('ext_server', \%sub_write_arg);
                }
                elsif (ref( $member ) eq 'Infoblox::DNS::MSServer') {
                    push @newlist_ms, ibap_value_o2i_dns_msserver_convert($member, $session, $self, 'ms_dns_server');
                }
                else {
                    push @newlist_member,ibap_value_o2i_member_server($member,$session,$self,$current);
                }
            }

            push @return_args, 1;
            push @return_args, 0;
            if ($current eq 'secondaries') {
                push @return_args, tIBType('ArrayOfmember_server', \@newlist_member);

                my %sub_write_arg2;
                $sub_write_arg2{'field'} = 'external_secondaries';
                $sub_write_arg2{'value'} = tIBType('ArrayOfext_server', \@newlist_server);
                push @return_args, \%sub_write_arg2;

                my %sub_write_arg3;
                $sub_write_arg3{'field'} = 'ms_secondaries';
                $sub_write_arg3{'value'} = tIBType('ArrayOfms_dns_server', \@newlist_ms);
                push @return_args, \%sub_write_arg3;
            }
            elsif ($current eq 'members') {
                push @return_args, tIBType('ArrayOfmember_server', \@newlist_member);
            }
            elsif ($current eq 'forward_to') {
                push @return_args, tIBType('ArrayOfext_server', \@newlist_server);
            }
            elsif ($current eq 'delegate_to') {
                push @return_args, tIBType('ArrayOfext_server', \@newlist_server);
            }
            elsif ($current eq 'stub_from') {
                push @return_args, tIBType('ArrayOfext_server', \@newlist_server);
            }
            elsif ($current eq 'stub_members') {
                push @return_args, tIBType('ArrayOfmember_server', \@newlist_member);

                my %sub_write_arg3;
                $sub_write_arg3{'field'} = 'stub_msservers';
                $sub_write_arg3{'value'} = tIBType('ArrayOfms_dns_server', \@newlist_ms);
                push @return_args, \%sub_write_arg3;
            }
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


sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;
    my $type = $self->__zone_type_from_object__();

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

    if ($self->{use_dnssec}) {

        #
        my %default_values = $self->__dnssec_defaults__();

        foreach (keys %default_values) {

            #
            #

            if (m/^dnssec_(k|z)sk_algorithms$/) {

                if (ref($$self{$_}) eq 'ARRAY') {

                    #
                    foreach my $alg (@{$$self{$_}}) {
                        $$alg{algorithm} = 'RSASHA256' unless defined $$alg{algorithm};
                    }

                    #
                    $$self{$_} = undef unless scalar @{$$self{$_}};
                }
            }

            $$self{$_} = $default_values{$_} unless defined $$self{$_};
        }
    }

    #
    my $t = $self->SUPER::__object_to_ibap__($server, $session, $_filter_fields{$type});

    delete $self->{'soa_mname'};

    #
    #
    delete $self->{'__already_done_dnssec__'};
    return $t;
}

#
#
#

sub host_name_restriction_policy
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'host_name_restriction_policy' };
    }
    else
    {
        my $value = shift;
        $self->{ 'use_record_name_policy' } = 'true';
        if( !defined $value )
        {
            $self->{ 'host_name_restriction_policy' } = undef;
            $self->{ 'use_record_name_policy' } = 'false';
        }
        else
        {
            $self->{ 'host_name_restriction_policy' } = $value;
        }
    }
    return 1;
}

sub disable_forwarding
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable_forwarding', validator => \&ibap_value_o2i_boolean}, @_);
}

sub forward_only
{
     my $self=shift;
    return $self->__accessor_scalar__({name => 'forward_only', validator => \&ibap_value_o2i_boolean}, @_);
}

sub notify_delay
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'notify_delay', validator => \&ibap_value_o2i_uint, use => \$self->{'use_notify_delay'}}, @_);
}

sub ns_group {

    my $self  = shift;

    return undef unless $self->__zone_type_check__('auth', @_);
    my $res = $self->__accessor_scalar__({name => 'ns_group', 'validator' => {'string' => 1, 'Infoblox::Grid::DNS::Nsgroup' => 1}}, @_);

    if (@_ and $res and defined $self->{'ns_group'}) {
        $self->{multiple_primaries}   = undef;
        $self->{secondaries}          = undef;
        $self->{use_external_primary} = 0;
    }

    return $res;
}

sub forward_ns_group {

    my $self = shift;

    return undef unless $self->__zone_type_check__('forward', @_);
    my $res = $self->__accessor_scalar__({name => 'forward_ns_group', 'validator' => {'string' => 1, 'Infoblox::Grid::DNS::Nsgroup::ForwardingMember' => 1}}, @_);
    if (@_ and $res and defined $self->{'forward_ns_group'}) { $self->{members} = undef }

    return $res;
}

sub stub_ns_group {

    my $self  = shift;

    return undef unless $self->__zone_type_check__('stub', @_);
    my $res = $self->__accessor_scalar__({name => 'stub_ns_group', 'validator' => {'string' => 1, 'Infoblox::Grid::DNS::Nsgroup::StubMember' => 1}}, @_);
    if (@_ and $res and defined $self->{'stub_ns_group'}) { $self->{stub_members} = undef }

    return $res;
}

sub stub_external_ns_group {

    my $self = shift;

    return undef unless $self->__zone_type_check__('stub', @_);
    my $res = $self->__accessor_scalar__({name => 'stub_external_ns_group', 'validator' => \&ibap_value_o2i_string}, @_);
    if (@_ and $res and defined $self->{'stub_external_ns_group'}) { $self->{stub_from} = undef }

    return $res;
}

sub forward_external_ns_group {

    my $self = shift;

    return undef unless $self->__zone_type_check__('forward', @_);
    my $res = $self->__accessor_scalar__({name => 'forward_external_ns_group', 'validator' => \&ibap_value_o2i_string}, @_);
    if (@_ and $res and defined $self->{'forward_external_ns_group'}) { $self->{forward_to} = undef }

    return $res;
}

sub delegation_ns_group {

    my $self = shift;

    return undef unless $self->__zone_type_check__('delegate', @_);
    my $res = $self->__accessor_scalar__({name => 'delegation_ns_group', 'validator' => {'string' => 1, 'Infoblox::Grid::DNS::Nsgroup::DelegationMember' => 1}}, @_);
    if (@_ and $res and defined $self->{'delegation_ns_group'}) { $self->{delegate_to} = undef }

    return $res;
}



sub create_underscore_zones
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'create_underscore_zones', validator => \&ibap_value_o2i_boolean}, @_);
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

sub prefix
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'prefix', validator => \&ibap_value_o2i_string_no_spaces}, @_);
}

sub import_from
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'import_from' };
    }
    else
    {
        my $value = shift;
        $self->{ 'use_import_from' } = 1;
        if( !defined $value )
        {
            $self->{ 'import_from' } = undef;
            $self->{ 'use_import_from' } = 0;
        }
        else
        {
            $self->{ 'import_from' } = $value;
        }
    }
    return 1;
}

sub allow_gss_tsig_for_underscore_zone
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_gss_tsig_for_underscore_zone', validator => \&ibap_value_o2i_boolean}, @_);
}

sub allow_gss_tsig_zone_updates
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_gss_tsig_zone_updates', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_ad_servers
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_ad_servers', validator => \&ibap_value_o2i_boolean}, @_);
}

sub allow_ptr_creation_in_parent
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_ptr_creation_in_parent', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ad_servers
{
    my $self=shift;
    return $self->__accessor_array__({name => 'ad_servers', validator => { 'string' => \&ibap_value_o2i_string }}, @_);
}

sub allow_update_forwarding
{
    my $self  = shift;
    my $res = $self->ibap_accessor_ac_setting('allow_update_forwarding', 1, {use => 'use_allow_update_forwarding'}, @_);

    if (@_ and $res) {
        $self->{'use_sec_update_forwarding'} = defined $_[0] ? 1 : 0;
    }

    return $res;
}

sub allow_update
{
    my $self  = shift;
    return $self->ibap_accessor_ac_setting('allow_update', 1, {use => 'use_update_setting'}, @_);
}


sub allow_transfer
{
    my $self  = shift;
    return $self->ibap_accessor_ac_setting('allow_transfer', 1, {use => 'use_zone_transfer_setting'}, @_);
}

sub allow_query
{
    my $self  = shift;
    return $self->ibap_accessor_ac_setting('allow_query', 1, {use => 'use_allow_query'}, @_);
}

sub __zone_type_check__ {

    #
    #
    #

    my ($self, $type, @args) = @_;

    #
    #
    return 1 unless @args and $$self{__zone_type__};

    my $ztype = $$self{__zone_type__};

    if (
        ($type eq 'auth'     and ($ztype eq 'AuthZone' or $ztype eq 'ResponsePolicyZone'))   or
        ($type eq 'stub'     and $ztype eq 'StubZone')                                       or
        ($type eq 'forward'  and $ztype eq 'ForwardZone')                                    or
        ($type eq 'delegate' and $ztype eq 'DelegatedZone')
    ) {
        return 1;
    }

    set_error_codes('1105', ucfirst($type) . "Zone type members are not " .
        "allowed for $$self{__zone_type__}");

    return undef;
}

sub __update_member_soa_mnames__
{
    my $self = shift;

    #
    if (!$self->{'__initializing_from_ibap__'} and $self->{'member_soa_mnames'} and scalar(@{$self->{'member_soa_mnames'}}) == 1) {
        delete $self->{'member_soa_mnames'}->[0]->{'grid_member'};
        delete $self->{'member_soa_mnames'}->[0]->{'ms_server'};
    }
}

#
sub primary
{
    my $self  = shift;

    if (@_) {
        my $value = shift;
        if (defined $value) {
            if (ref($value) eq 'Infoblox::DNS::Member') {
                my $res = $self->multiple_primaries([$value]);
                $self->__update_member_soa_mnames__();
                return $res;
            } else {
                if (ref($value) eq 'ARRAY' and @$value and ref($value->[0]) eq 'Infoblox::DNS::Member') {
                    set_error_codes(1104,'Invalid data type for member primary.');
                    return;
                } else {
                    my $res = $self->multiple_primaries($value);
                    $self->__update_member_soa_mnames__() if $res;
                    return $res;
                }
            }
        } else {
            $self->__update_member_soa_mnames__();
            return $self->multiple_primaries([]);
        }
    } else {
        my $res = $self->multiple_primaries();
        if ($res and @$res and ref($res->[0]) eq 'Infoblox::DNS::Member') {
            return $res->[0];
        } else {
            return $res;
        }
    }
}

sub multiple_primaries
{
    my $self = shift;

    return undef unless $self->__zone_type_check__('auth', @_);
    my $res = $self->__accessor_array__({name => 'multiple_primaries', nomixed => 1, validator => {'Infoblox::DNS::Member' => 1, 'Infoblox::DNS::Nameserver' => 1, 'Infoblox::DNS::MSServer' => 1}}, @_);

    if (@_ and $res) {
        if ($self->{'multiple_primaries'} and @{$self->{'multiple_primaries'}} and ref($self->{'multiple_primaries'}->[0]) eq 'Infoblox::DNS::Nameserver') {
            $self->{'use_external_primary'} = 1;
        } else {
            $self->{'use_external_primary'} = 0;
        }
    }

    return $res;
}

sub is_multimaster
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'is_multimaster', validator => \&ibap_value_o2i_boolean}, @_);
}

sub secondaries
{
    my $self  = shift;

    return undef unless $self->__zone_type_check__('auth', @_);
    return $self->__accessor_array__({
            name      => 'secondaries',
            validator => {
                          'Infoblox::DNS::Member'     => 1,
                          'Infoblox::DNS::Nameserver' => 1,
                          'Infoblox::DNS::MSServer'   => 1,
    }}, @_);
}

sub forward_to {

    my $self  = shift;

    return undef unless $self->__zone_type_check__('forward', @_);
    return $self->__accessor_array__({name => 'forward_to', validator => {'Infoblox::DNS::Nameserver' => 1}}, @_);
}

sub members
{
    my $self  = shift;

    return undef unless $self->__zone_type_check__('forward', @_);
    return $self->__accessor_array__({'name' => 'members', validator => {'Infoblox::DNS::Member' => 1}}, @_);
}

sub delegate_to
{
    my $self  = shift;

    return undef unless $self->__zone_type_check__('delegate', @_);
    return $self->__accessor_array__({name => 'delegate_to', validator => {'Infoblox::DNS::Nameserver' => 1}}, @_);
}

sub stub_from
{
    my $self  = shift;

    return undef unless $self->__zone_type_check__('stub', @_);
    return $self->__accessor_array__({'name' => 'stub_from', validator => {'Infoblox::DNS::Nameserver' => 1}}, @_);
}

sub stub_members
{
    my $self  = shift;

    return undef unless $self->__zone_type_check__('stub', @_);
    return $self->__accessor_array__({'name' => 'stub_members', validator => {'Infoblox::DNS::Member' => 1, 'Infoblox::DNS::MSServer' => 1}}, @_);
}

sub zone
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'zone', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub override_serial_number
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_serial_number', validator => \&ibap_value_o2i_boolean}, @_);
}

sub do_host_abstraction
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'do_host_abstraction', writeonly => 1, validator => \&ibap_value_o2i_boolean}, @_);
}

sub locked
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'locked', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ms_ad_integrated
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_ad_integrated', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ms_managed
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_managed', readonly => 1}, @_);
}

sub primary_shared_with_ms_parent_delegation
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'primary_shared_with_ms_parent_delegation', readonly => 1}, @_);
}

sub ms_read_only
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_read_only', readonly => 1}, @_);
}

sub ms_sync_disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_sync_disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ms_ddns_mode
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_ddns_mode', enum => ['Secure','None','Any'] }, @_);
}

sub ms_allow_transfer
{
    my $self = shift;

    if (@_) {
        my $value = $_[0];
        if (ref($value)) {
            return $self->__accessor_array__({name => 'ms_allow_transfer', validator => \&ibap_value_o2i_ipv4addr}, @_);
        } else {
            return $self->__accessor_scalar__({name => 'ms_allow_transfer', enum => ['NSOnly','Any','None'] }, @_);
        }
    } else {
        return $self->{'ms_allow_transfer'};
    }
}

sub soa_serial_number
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'soa_serial_number', validator => \&ibap_value_o2i_uint}, @_);
}

sub member_soa_serials
{
    my $self = shift;
    return $self->__accessor_array__({name => 'member_soa_serials', readonly => 1, validator => {'Infoblox::DNS::Member::SoaSerial' => 1}}, @_);
}

sub soa_mname
{
    my $self=shift;

    if (@_) {
        my $value = shift;
        if (defined $value) {
            my $soa = Infoblox::DNS::Member::SoaMname->__new__();
            $soa->mname($value);
            return $self->member_soa_mnames([$soa]);
        } else {
            return $self->member_soa_mnames([]);
        }
    } else {
        my $res = $self->member_soa_mnames();
        return ($res and @$res) ? $res->[0]->mname() : undef;
    }
}

sub member_soa_mnames
{
    my $self = shift;
    return $self->__accessor_array__({name => 'member_soa_mnames', validator => {'Infoblox::DNS::Member::SoaMname' => 1}}, @_);
}

#
sub override_soa_mname
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_soa_mname', deprecated => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub soa_negative_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'soa_negative_ttl', validator => \&ibap_value_o2i_long}, @_);
}

sub soa_default_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'soa_default_ttl', validator => \&ibap_value_o2i_long}, @_);
}

sub soa_expire
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'soa_expire', validator => \&ibap_value_o2i_long}, @_);
}

sub soa_retry
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'soa_retry', validator => \&ibap_value_o2i_long}, @_);
}

sub soa_refresh
{
    my $self=shift;
    #
    return $self->__accessor_scalar__({name => 'soa_refresh', validator => \&ibap_value_o2i_long}, @_);
}

sub delegated_ttl
{
    my $self=shift;
    if( @_ == 0 )
    {
        return $self->{ 'delegated_ttl' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{'delegated_ttl'} = undef;
            $self->override_delegated_ttl('false');
        }
        else
        {
            if ($value !~ m/^[0-9]+$/)
            {
                set_error_codes(1104,"Invalid value '$value' for member delegated_ttl");
                return;
            }
            else
            {
                $self->{'delegated_ttl'} = $value;
                $self->override_delegated_ttl('true');
            }
        }
    }

    return 1;
}

sub override_delegated_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_delegated_ttl', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_grid_zone_timer
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_grid_zone_timer', validator => \&ibap_value_o2i_string}, @_);
}

sub override_grid_email
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_grid_email', validator => \&ibap_value_o2i_string}, @_);
}

sub remove_sub_zones
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'remove_sub_zones', validator => \&ibap_value_o2i_string}, @_);
}

sub email
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'email' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ 'email' } = undef;
            $self->override_grid_email('false');
        }
        else
        {
            $self->{ 'email' } = $value;
            $self->override_grid_email('true');
        }
    }
    return 1;
}

sub views
{
    my $self=shift;

    return $self->__accessor_array__({name => 'views', validator => { 'Infoblox::DNS::View' => 1 }}, @_);
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub dns_name
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'dns_name', readonly => 1}, @_);
}

sub dns_soa_mname
{
    my $self = shift;

    if (@_) {
        return set_error_codes(1104, 'Member dns_soa_mname is read only');
    } else {
        if ($self->{'member_soa_mnames'} and @{$self->{'member_soa_mnames'}}) {
            return $self->{'member_soa_mnames'}->[0]->dns_mname();
        } else {
            return undef;
        }
    }
}

sub dns_email
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'dns_email', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub shared_record_groups
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'shared_record_groups', validator => { 'string' => 1 }}, @_);
}

sub bind_check_names_policy
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ "bind_check_names_policy" };
    }
    else
    {
        my $value = shift;
        $self->{ "use_check_names_policy" } = 'true';
        if( !defined $value )
        {
            $self->{ "bind_check_names_policy" } = undef;
            $self->{ "use_check_names_policy" } = 'false';
        }
        else
        {
            if ($value !~ m/^warn|fail$/) {
                set_error_codes(1104,'Invalid value ' . $value . ' for member bind_check_names_policy.' );
                return;
            }
            else {
                $self->{ "bind_check_names_policy" } = $value;
            }
        }
    }
    return 1;
}

sub network_associations
{
  my $self=shift;
  return $self->__accessor_lazy_scalar_readonly__('network_associations',\&__i2o_network_associations__,$_lazy_return_fields{'network_associations'},@_);
}

sub __i2o_network_associations__
{
  my ($self,$ibap_object_ref,$server,$session,$return_object_cache_ref)=@_;
  $self->{'network_associations'}=ibap_i2o_generic_object_list_convert($self,$session,'network_associations',$ibap_object_ref,$return_object_cache_ref);
  unless(defined($self->{'network_associations'})){
    $self->{'network_associations'}=[];
  }
  return 1;
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub dnssec_ksk_algorithm {

    my $self = shift;
    return $self->dnssec_algorithm_size_accessor('dnssec_ksk_algorithm', @_);
}

sub dnssec_ksk_algorithms
{
    my $self = shift;

    my $res = $self->__accessor_array__({name => 'dnssec_ksk_algorithms', validator => {'Infoblox::DNS::DNSSecKeyAlgorithm' => 1}}, @_);
    return $res if (@_ and not $res) or not @_;

    $self->__check_use_dnssec__();
    return $res;
}

sub dnssec_ksk_rollover_interval
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'dnssec_ksk_rollover_interval', validator => \&ibap_value_o2i_long}, @_);
    $self->__check_use_dnssec__();
    return $res;
}
sub dnssec_ksk_size {

    my $self = shift;
    return $self->dnssec_algorithm_size_accessor('dnssec_ksk_size', @_);
}

sub dnssec_signature_expiration
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'dnssec_signature_expiration', validator => \&ibap_value_o2i_long}, @_);
    $self->__check_use_dnssec__();
    return $res;
}
sub dnssec_zsk_algorithm
{
    my $self = shift;
    return $self->dnssec_algorithm_size_accessor('dnssec_zsk_algorithm', @_);
}
sub dnssec_zsk_algorithms
{
    my $self = shift;

    my $res = $self->__accessor_array__({name => 'dnssec_zsk_algorithms', validator => {'Infoblox::DNS::DNSSecKeyAlgorithm' => 1}}, @_);
    return $res if (@_ and not $res) or not @_;

    $self->__check_use_dnssec__();
    return $res;
}
sub dnssec_zsk_rollover_interval
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'dnssec_zsk_rollover_interval', validator => \&ibap_value_o2i_long}, @_);
    $self->__check_use_dnssec__();
    return $res;
}
sub dnssec_zsk_size
{
    my $self = shift;
    return $self->dnssec_algorithm_size_accessor('dnssec_zsk_size', @_);
}
sub dnssec_nsec3_salt_min_length
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'dnssec_nsec3_salt_min_length', validator => \&ibap_value_o2i_uint}, @_);
    $self->__check_use_dnssec__();
    return $res;
}
sub dnssec_nsec3_salt_max_length
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'dnssec_nsec3_salt_max_length', validator => \&ibap_value_o2i_uint}, @_);
    $self->__check_use_dnssec__();
    return $res;
}
sub dnssec_nsec3_iterations
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'dnssec_nsec3_iterations', validator => \&ibap_value_o2i_uint}, @_);
    $self->__check_use_dnssec__();
    return $res;
}
sub dnssec_zsk_rollover_mechanism
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'dnssec_zsk_rollover_mechanism', enum => [ 'DOUBLE_SIGN', 'PRE_PUBLISH' ]}, @_);
    $self->__check_use_dnssec__();
    return $res;
}
sub dnssec_enable_ksk_auto_rollover
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'dnssec_enable_ksk_auto_rollover', validator => \&ibap_value_o2i_boolean}, @_);
    $self->__check_use_dnssec__();
    return $res;
}
sub dnssec_keys
{
    my $self=shift;
    my $res = $self->__accessor_array__({name => 'dnssec_keys', validator => { 'Infoblox::DNS::DNSSecKey' => 1 }}, @_);
    $self->__check_use_dnssec__();
    return $res;
}
sub dnssec_ksk_rollover_date
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'dnssec_ksk_rollover_date', validator => \&ibap_value_o2i_uint, readonly => 1}, @_);
    $self->__check_use_dnssec__();
    return $res;
}
sub dnssec_zsk_rollover_date
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'dnssec_zsk_rollover_date', validator => \&ibap_value_o2i_uint, readonly => 1}, @_);
    $self->__check_use_dnssec__();
    return $res;
}

sub dnssec_ksk_rollover_notification_config
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'dnssec_ksk_rollover_notification_config', enum => [ 'NONE', 'ALL', 'REQUIRE_MANUAL_INTERVENTION' ]}, @_);
    $self->__check_use_dnssec__();
    return $res;
}

sub dnssec_ksk_snmp_notification_enabled
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'dnssec_ksk_snmp_notification_enabled', validator => \&ibap_value_o2i_boolean}, @_);
    $self->__check_use_dnssec__();
    return $res;
}
sub dnssec_ksk_email_notification_enabled
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'dnssec_ksk_email_notification_enabled', validator => \&ibap_value_o2i_boolean}, @_);
    $self->__check_use_dnssec__();
    return $res;
}

sub next_secure_type {

    my $self = shift;

    if (($self->{__dnssec_ksk_algorithm__} || $self->{__dnssec_zsk_algorithm__}) && @_ && $_[0]) {
        set_error_codes(1105, 'You cannot set next_secure_type to a defined value when ' .
                              'any of dnssec_ksk_algorithm and dnssec_zsk_algorithm ' .
                              'is set to a defined value.');
        return undef;
    }

    my $res = $self->__accessor_scalar__({name => 'next_secure_type', enum => ['NSEC', 'NSEC3']}, @_);
    $self->__check_use_dnssec__();
    return $res;
}

#
sub dnssec_signed
{
    my $self  = shift;
    if(@_ == 0)
    {
      return $self->{'dnssec_signed'};
    }
    my $value=shift;
    if($value!~/^true|false$/i)
    {
      set_error_codes(1104, "Invalid value '$value' for member dnssec_signed");
      return 0;
    }

    #
    #
    if(!defined($self->{'dnssec_signed'}))
    {
      $self->{'dnssec_signed'}=$value;
      return 1;
    }

    if  ($value eq $self->{'dnssec_signed'})
    {
      #
      return 1;
    }


    unless ($self->{ '__internal_session_cache_ref__' } && $self->__object_id__()) {
        set_error_codes(1001,'In order to sign/unsign DNS zone the object must have been retrieved from the server first');
        return;
    }
    my $session = ${$self->{ '__internal_session_cache_ref__' }};
    my $operation = ($value eq "true")?'SIGN':'UNSIGN';
    my $res=$session->__dnssec_operation__($self->__object_id__(),$operation);

    if ($res) {
        #
        $self->{'dnssec_signed'}=$value;
        $self->__refresh_dnssec_data__();
    }
    return $res;
}

sub dnssec_resign
{
    my $self = shift;

    unless ($self->{'__internal_session_cache_ref__'} && $self->__object_id__()) {
        set_error_codes(1001, 'In order to resign DNS zone the object must have been retrieved from the server first');
        return;
    }

    my $session = ${$self->{'__internal_session_cache_ref__'}};
    return $session->__dnssec_operation__($self->__object_id__(), 'RESIGN');
}

sub initiate_ksk_rollover
{
    my $self=shift;

    unless ($self->{ '__internal_session_cache_ref__' } && $self->__object_id__()) {
        set_error_codes(1001,'In order to sign/unsign DNS zone the object must have been retrieved from the server first');
        return;
    }

    my $session=${$self->{ '__internal_session_cache_ref__' }};
    return $session->__dnssec_operation__($self->__object_id__(),'ROLLOVER_KSK');
}

sub execute_dns_parent_check
{
    my $self=shift;

    unless ($self->{ '__internal_session_cache_ref__' } && $self->__object_id__()) {
        set_error_codes(1001,'In order to sign/unsign DNS zone the object must have been retrieved from the server first');
        return;
    }

    my $session=${$self->{ '__internal_session_cache_ref__' }};
    my $server = $session->get_ibap_server() || return;

    eval {
        $server->ibap_request('ExecuteDNSParentCheck', { zone => {object_id => tObjId($self->__object_id__())}});
    };

    return $server->set_papi_error($@, $session) if $@;
    set_error_codes(0,undef,$session);
    return 1;
}

sub initiate_zsk_rollover
{
    my $self=shift;

    unless ($self->{ '__internal_session_cache_ref__' } && $self->__object_id__()) {
        set_error_codes(1001,'In order to sign/unsign DNS zone the object must have been retrieved from the server first');
        return;
    }

    my $session=${$self->{ '__internal_session_cache_ref__' }};
    return $session->__dnssec_operation__($self->__object_id__(),'ROLLOVER_ZSK');
}

sub __refresh_dnssec_data__
{
    my $self = shift;

    #
    unless ($self->{ '__internal_session_cache_ref__' } && $self->__object_id__()) {
        set_error_codes(1001,'In order to sign/unsign DNS zone the object must have been retrieved from the server first');
        return;
    }

    my (%args, $result);
    my $session = ${$self->{ '__internal_session_cache_ref__' }};
    my $server=$session->get_ibap_server() || return;

    my $t = Infoblox::DNS::DNSSecKeyAlgorithm->__new__();

    $args{'depth'} = 0;
    $args{'object_ids'} = [tObjId($self->__object_id__())];
    $args{'return_fields'} = [
                              tField('is_dnssec_signed'),
                              tField('use_grid_zone_timer'),
                              tField('soa_refresh'),
                              tField('soa_retry'),
                              tField('dnssec_key_params',
                                     {
                                      not_exist_ok => 1,
                                      no_access_ok => 1,
                                      sub_fields =>
                                      [
                                       tField('ksk_algorithms', {sub_fields => $t->__return_fields__()}),
                                       tField('ksk_rollover'),
                                       tField('signature_expiration'),
                                       tField('zsk_algorithms', {sub_fields => $t->__return_fields__()}),
                                       tField('zsk_rollover'),
                                       tField('next_secure_type'),
                                      ]
                                     }
                                    )
                             ];

    eval { $result = $server->ObjectRead(\%args); };
    return $server->set_papi_error($@, $session) if $@;

    my $zone=@$result[0];
    if ($zone->{'is_dnssec_signed'} && defined $zone->{'dnssec_key_params'}) {

        #
        #
        $self->{'override_grid_zone_timer'} = ibap_value_i2o_boolean($$zone{'use_grid_zone_timer'});
        $self->{'soa_refresh'} = $$zone{'soa_refresh'};
        $self->{'soa_retry'} = $$zone{'soa_retry'};
    }
}

sub convert_a_host_ptr_to_bulk_host
{
    my ($self, $args) = @_;

    unless ($self->{ '__internal_session_cache_ref__' } && $self->__object_id__()) {
        set_error_codes(1001,'In order to convert DNS records, the zone object must have been retrieved from the server first');
        return;
    }

    my $session=${$self->{ '__internal_session_cache_ref__' }};
    return $session->__convert_a_host_ptr_to_bulk_host__($self->__object_id__(), $args);
}

sub last_queried
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'last_queried', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub zone_monitored_since
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'zone_monitored_since', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub resource_record_monitored_since
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'resource_record_monitored_since', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub rpz_policy
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'rpz_policy', enum => [ 'GIVEN', 'PASSTHRU', 'NXDOMAIN', 'NODATA', 'SUBSTITUTE', 'DISABLED' ]}, @_);
}

sub rpz_type
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'rpz_type', enum => [ 'LOCAL', 'FIREEYE', 'FEED' ]}, @_);
}

sub rpz_severity
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'rpz_severity', enum => [ 'CRITICAL', 'MAJOR', 'WARNING', 'INFORMATIONAL' ]}, @_);
}

sub fireeye_rule_mapping
{
    my $self=shift;

    return $self->__accessor_scalar__({name => 'fireeye_rule_mapping', validator => { 'Infoblox::DNS::FireEye::RuleMapping' => 1 }}, @_);
}

sub substitute_name
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'substitute_name', validator => \&ibap_value_o2i_string}, @_);
}

sub rpz_priority
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'rpz_priority', readonly => 1, validator => \&ibap_value_o2i_uint}, @_);
}

sub rpz_last_updated_time
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'rpz_last_updated_time', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub is_feed_zone
{
    my $self = shift;
    my $type = $self->__zone_type_from_object__();
    unless ($type eq 'ResponsePolicyZone'){
        $self->{'is_feed_zone'} = undef;
    }
    else{
        $self->{'is_feed_zone'} = $self->{ 'use_external_primary' } ? 'true' : 'false';
    }

    return $self->__accessor_scalar__({name => 'is_feed_zone', readonly => 1, validator => \&ibap_value_o2i_boolean}, @_);
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

sub create_ptr_for_bulk_hosts
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'create_ptr_for_bulk_hosts', writeonly => 1, validator => \&ibap_value_o2i_boolean}, @_);
}

sub create_ptr_for_hosts
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'create_ptr_for_hosts', writeonly => 1, validator => \&ibap_value_o2i_boolean}, @_);
}

sub dns_integrity_check_enable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_integrity_check_enable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dns_integrity_frequency
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_integrity_frequency', validator => \&ibap_value_o2i_uint}, @_);
}

sub dns_integrity_member
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_integrity_member', validator => \&ibap_value_o2i_string}, @_);
}

sub dns_integrity_verbose_logging
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_integrity_verbose_logging', validator => \&ibap_value_o2i_boolean}, @_);
}

sub is_default
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'is_default', validator => \&ibap_value_o2i_boolean}, @_);
}

sub cloud_info
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'cloud_info', readonly => 1, validator => {'Infoblox::Grid::CloudAPI::Info' => 1}}, @_);
}

sub restart_if_needed
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'restart_if_needed', validator => \&ibap_value_o2i_boolean, writeonly => 1}, @_);
}


package Infoblox::DNS::Zone::Discrepancy;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap @_return_fields
            %_capabilities %_searchable_fields %_ibap_to_object %_name_mappings
            %_reverse_name_mappings);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {
    $_object_type = 'ParentCheckDiscrepancy';
    register_wsdl_type('ib:ParentCheckDiscrepancy','Infoblox::DNS::Zone::Discrepancy');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
        'zone'      => {'validator' => \&ibap_value_o2i_string},
        'view'      => {'validator' => \&ibap_value_o2i_string},
        'timestamp' => {'validator' => \&ibap_value_o2i_uint},
        'severity'  => {'simple' => 'asis', enum => [
            'CRITICAL',
            'SEVERE',
            'WARNING',
            'INFORMATIONAL',
            'NORMAL',]},
        'description' => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       timestamp => 'last_check_timestamp',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'zone' => \&__i2o_zone__,
                        'last_check_timestamp' => \&ibap_i2o_datetime_to_unix_timestamp,
                       );

    %_object_to_ibap = (
        'zone'        => \&ibap_o2i_ignore,
        'view'        => \&ibap_o2i_ignore,
        'timestamp'   => \&ibap_o2i_ignore,
        'severity'    => \&ibap_o2i_ignore,
        'description' => \&ibap_o2i_ignore,
    );

    %_searchable_fields = (
        zone     => [\&__o2i_zone_search__, 'zone' , 'EXACT'],
        view     => [\&ibap_o2i_ignore, 'ignore' , 'DEPRECATED'],  # taken care of in zone
        severity => [\&ibap_o2i_string ,'severity', 'EXACT'],
    );

    @_return_fields =
      (
       tField('zone', {
           sub_fields => [
               tField('fqdn'),
               tField('view', {
                   sub_fields => [
                       tField('name'),
               ]}),
           ]}),
       tField('last_check_timestamp'),
       tField('severity'),
       tField('description'),
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

sub __o2i_zone_search__
{
    my ($self, $session, $current, $tempref) = @_;

    my $zone_readfield=ibap_arg_zone_convert($session,$current,$tempref);
    if(defined($zone_readfield)) {
        return (1,0,$zone_readfield);
    } else {
        return (0,0,undef);
    }
}

sub __i2o_zone__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    $self->view($$ibap_object_ref{$current}{'view'}{'name'});
    return $$ibap_object_ref{$current}{'fqdn'};
}

package Infoblox::DNS::DNSSecKey;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use Time::Local;
use vars qw(@ISA $_object_type %_allowed_members %_return_field_overrides
            %_name_mappings %_reverse_name_mappings %_searchable_fields
            %_ibap_to_object %_object_to_ibap @_return_fields %_capabilities $_return_fields_initialized);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    $_object_type = 'dnssec_key';
    register_wsdl_type('ib:dnssec_key', 'Infoblox::DNS::DNSSecKey');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         tag             => {simple => 'asis', validator => \&ibap_value_o2i_uint, 'readonly' => 1},
                         status          => {simple => 'asis', enum => ['ACTIVE', 'PUBLISHED', 'ROLLED', 'IMPORTED'], 'readonly' => 1},
                         type            => {simple => 'asis', enum => ['ZSK', 'KSK'], 'readonly' => 1},
                         next_event_date => {validator => \&ibap_value_o2i_uint, 'readonly' => 1},
                         algorithm       => {simple => 'asis', validator => \&ibap_value_o2i_string, 'readonly' => 1},
                         public_key      => {simple => 'asis', validator => \&ibap_value_o2i_string, 'readonly' => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
                                tag             => [],
                                status          => [],
                                type            => [],
                                next_event_date => [],
                                algorithm       => [],
                                public_key      => [],
                               );

    %_name_mappings = (
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                          );

    %_ibap_to_object = (
                        next_event_date => \&ibap_i2o_datetime_to_unix_timestamp,
                       );

    %_object_to_ibap = (
                        tag             => \&ibap_o2i_uint,
                        status          => \&ibap_o2i_string,
                        type            => \&ibap_o2i_string,
                        next_event_date => \&ibap_o2i_uint,
                        algorithm       => \&ibap_o2i_ignore,
                        public_key      => \&ibap_o2i_ignore,
                       );

    @_return_fields = (
                        tField('tag'),
                        tField('status'),
                        tField('type'),
                        tField('next_event_date'),
                        tField('algorithm'),
                        tField('public_key'),
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
    #
    #
    return $_object_type;
}

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}


package Infoblox::DNS::DNSSecKeyAlgorithm;

use strict;

use Carp;

use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::Util;
use Infoblox::PAPIOverrides;

use vars qw ( @ISA $_object_type %_allowed_members
              @_return_fields %_object_to_ibap
              %_ibap_to_object );

@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'dnssec_key_algorithm';
    register_wsdl_type('ib:dnssec_key_algorithm', 'Infoblox::DNS::DNSSecKeyAlgorithm');

    %_allowed_members = (
                         'algorithm' => {simple => 'asis', enum => ['RSAMD5', 'DSA', 'RSASHA1', 'RSASHA256', 'RSASHA512']},
                         'size'      => {simple => 'asis', validator => \&ibap_value_o2i_long},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('algorithm'),
                       tField('size'),
    );

    %_object_to_ibap = (
                        'algorithm' => \&ibap_o2i_string,
                        'size'      => \&ibap_o2i_long,
    );

    %_ibap_to_object = (
                        'algorithm' => \&ibap_i2o_key_algorithm,
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


1;
