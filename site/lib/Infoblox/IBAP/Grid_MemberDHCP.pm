package Infoblox::Grid::Member::DHCP;

use strict;

use Carp;
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_name_mappings %_reverse_name_mappings %_searchable_fields %_ibap_to_object %_object_to_ibap @_return_fields %_return_field_overrides %_capabilities $_return_fields_initialized);
@ISA = qw(Infoblox::IBAPBase);

BEGIN
{   
    $_object_type = 'MemberDhcp';
    register_wsdl_type('ib:MemberDhcp','Infoblox::Grid::Member::DHCP');

    %_capabilities = (
        depth                => 0,
        implicit_defaults    => 1,
        single_serialization => 1,
    );

    #
    #
    %_allowed_members = (
        authority => 0,
        authn_server_group_enabled => 0,
        authn_captive_portal_enabled => 0,
        authn_captive_portal => 0,
        authn_captive_portal_authenticated_filter => 0,
        authn_captive_portal_guest_filter => 0,
        auth_server_group => 0,
        bootfile => 0,
        bootserver => 0,
        ddns_generate_hostname => 0,
        ddns_retry_interval => 0,
        ddns_server_always_updates => 0,
        override_ddns_ttl                    => 0,
        ddns_domainname => 0,
        override_ddns_domainname             => 0,
        ddns_update_fixed_addresses => 0,
        ddns_use_option81 => 0,
        ddns_zone_primaries => {validator => {'Infoblox::DHCP::DDNS' => 1}, array => 1, skip_accessor => 1},
        deny_bootp => 0,
        email_list => 0,
        enable_ddns => 0,
        enable_dhcp => 0,
        enable_dhcp_on_lan2 => 0,
        enable_dhcp_on_ipv6_lan2 => 0,
        enable_dhcp_thresholds => 0,
        enable_email_warnings => 0,
        enable_gss_tsig => 0,
        override_enable_gss_tsig => 0,
        enable_ifmap => 0,
        enable_ifmap_publishing => 0,
        extattrs              => -1,
        extensible_attributes => -1,
        override_enable_ifmap_publishing => 0,
        enable_snmp_warnings => 0,
        enable_fingerprint => 0,
        override_enable_fingerprint => 0,
        gss_tsig_key => 0,
        gss_tsig_keys => 0,
        override_gss_tsig_keys => 0,
        high_water_mark => 0,
        high_water_mark_reset => 0,
        ifmap_client_credentials => {validator => {'Infoblox::IFMap::Client::Credentials' => 1}, skip_accessor => 1},
        ifmap_last_status_update => -1,
        ifmap_password => 0,
        ifmap_status => -1,
        ifmap_status_details => -1,
        ifmap_username => 0,
        ignore_dhcp_option_list_request => 0,
        ignore_client_identifier => 0, # replaced by ignore_id
        ignore_id => 0,
        ignore_mac_addresses => 0,
        override_ignore_client_identifier => 0, # replaced by override_ignore_id
        override_ignore_id => 0,
        kdc_server => 0,
        lease_scavenge_time => 0,
        log_lease_events => 0,
        override_log_lease_events => 0,
        low_water_mark => 0,
        low_water_mark_reset => 0,
        microsoft_code_page => 0,
        name => 0,
        option60_match_rules => 0,
        options => 0,
        override_lease_scavenge_time => 0,
        ping_count => 0,
        ping_timeout => 0,
        pxe_lease_time => 0,
        recycle_leases => 0,
        retry_ddns_updates => 0,
        syslog_facility => 0,
        update_dns_on_lease_renewal         => 0,
        override_update_dns_on_lease_renewal => 0,
        ipv6_update_dns_on_lease_renewal         => 0,
        override_ipv6_update_dns_on_lease_renewal => 0,
        ipv6_ddns_enable_option_fqdn         => 0,
        override_ipv6_ddns_enable_option_fqdn => 0,
        enable_dhcpv6_service => 0,
        ipv6_ddns_server_always_updates => 0,
        ipv6_ddns_domainname => 0,
        override_ipv6_ddns_domainname => 0,
        ipv6_ddns_hostname => 0,
        override_ipv6_ddns_hostname => 0,
        ipv6_ddns_ttl => 0,
        override_ipv6_ddns_ttl => 0,
        ipv6_domain_name => 0,
        override_ipv6_domain_name => 0,
        ipv6_domain_name_servers => 0,
        override_ipv6_domain_name_servers => 0,
        ipv6_enable_ddns => 0,
        override_ipv6_enable_ddns => 0,
        ipv6_enable_gss_tsig => 0,
        override_ipv6_enable_gss_tsig => 0,
        ipv6_gss_tsig_keys => 0,
        override_ipv6_gss_tsig_keys => 0,
        ipv6_enable_retry_updates =>0,
        override_ipv6_enable_retry_updates => 0,
        ipv6_generate_hostname => 0,
        override_ipv6_generate_hostname => 0,
        ipv6_kdc_server => 0,
        override_ipv6_kdc_server => 0,
        ipv6_options => 0,
        override_ipv6_options => 0,
        ipv6_recycle_leases => 0,
        override_ipv6_recycle_leases => 0,
        ipv6_retry_updates_interval => 0,
        ipv6_server_duid => 0,
        ipv6_microsoft_code_page => 0,
        override_ipv6_microsoft_code_page => 0,
        preferred_lifetime => 0,
        override_preferred_lifetime => 0,
        valid_lifetime => 0,
        override_valid_lifetime => 0,
        #
        override_hostname_rewrite => 0,
        enable_hostname_rewrite => 0,
        hostname_rewrite_policy => 0,
        override_enable_one_lease_per_client => 0,
        enable_one_lease_per_client => 0,
        lease_per_client_settings => {simple => 'asis', enum => ['ONE_LEASE_PER_CLIENT', 'RELEASE_MATCHING_ID', 'NEVER_RELEASE'], use => 'override_lease_per_client_settings', use_truefalse => 1},
        override_lease_per_client_settings => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        immediate_fa_configuration => 0,
        override_immediate_fa_configuration => 0,
        logic_filters                 => {array => 1, validator => {string => 1, 'Infoblox::DHCP::Filter::MAC' => 1,
                                          'Infoblox::DHCP::Filter::NAC' => 1, 'Infoblox::DHCP::Filter::Option' => 1},
                                          use => 'override_logic_filters', use_truefalse => 1},
        override_logic_filters        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        ipv6_enable_lease_scavenge => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use_truefalse => 1,
                                       use => 'override_ipv6_lease_scavenge', use_members => ['ipv6_lease_scavenge_time', 'ipv6_remember_expired_client_association']},
        ipv6_lease_scavenge_time   => {simple => 'asis', validator => \&ibap_value_o2i_uint, use_truefalse => 1,
                                       use => 'override_ipv6_lease_scavenge', use_members => ['ipv6_enable_lease_scavenge', 'ipv6_remember_expired_client_association']},
        override_ipv6_lease_scavenge => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        ipv6_remember_expired_client_association => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use_truefalse => 1,
                                        use => 'override_ipv6_lease_scavenge', use_members => ['ipv6_enable_lease_scavenge', 'ipv6_lease_scavenge_time']},
        dns_update_style => {simple => 'asis', enum => ['STANDARD', 'INTERIM'], use => 'override_dns_update_style', use_truefalse => 1},
        override_dns_update_style => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        ipv6_dns_update_style => {simple => 'asis', enum => ['STANDARD', 'INTERIM'], use => 'override_ipv6_dns_update_style', use_truefalse => 1},
        override_ipv6_dns_update_style => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
        authority => 'is_authoritative',
        auth_server_group => 'authn_server_group',
        ddns_generate_hostname => 'generate_hostname',
        ddns_retry_interval => 'retry_updates_interval',
        ddns_server_always_updates => 'always_update_dns',
        ddns_update_fixed_addresses => 'update_static_leases',
        ddns_use_option81 => 'enable_option81',
        email_list => 'threshold_email_addresses',
        enable_dhcp => 'enable_service',
        enable_dhcp_on_lan2 => 'enable_lan2_service',
        enable_dhcp_on_ipv6_lan2 => 'enable_v6_lan2_service',
        enable_dhcp_thresholds => 'enable_thresholds',
        enable_email_warnings => 'enable_threshold_email_warnings',
        enable_snmp_warnings => 'enable_threshold_snmp_warnings',
        extattrs             => 'extensible_attributes',
        override_enable_fingerprint => 'use_enable_fingerprint',
        high_water_mark => 'range_high_water_mark',
        high_water_mark_reset => 'range_high_water_mark_reset',
        kdc_server => 'kdc_server_address',
        lease_scavenge_time => 'client_association_grace_period',
        low_water_mark => 'range_low_water_mark',
        low_water_mark_reset => 'range_low_water_mark_reset',
        microsoft_code_page => 'windows_code_page',
        name => 'host_name',
        override_lease_scavenge_time => 'use_client_association_grace_period',
        ping_count => 'ping_number',
        retry_ddns_updates => 'enable_retry_updates',
        override_enable_gss_tsig => 'use_enable_gss_tsig',
        override_update_dns_on_lease_renewal => 'use_update_dns_on_lease_renewal',
        override_ipv6_update_dns_on_lease_renewal => 'use_v6_update_dns_on_lease_renewal',
        override_ipv6_ddns_enable_option_fqdn => 'use_v6_enable_option81',
        override_ddns_ttl            => 'use_ddns_ttl',
        override_ddns_domainname            => 'use_ddns_domainname',
        override_enable_ifmap_publishing => 'use_enable_ifmap_publishing',
        override_gss_tsig_keys => 'use_gss_tsig_keys',
        override_log_lease_events            => 'use_log_lease_events',
        override_ipv6_domain_name => 'use_v6_domain_name',
        override_ipv6_domain_name_servers => 'use_v6_domain_name_servers',
        override_ipv6_enable_ddns => 'use_v6_enable_ddns',
        override_ipv6_enable_gss_tsig => 'use_v6_enable_gss_tsig',
        override_ipv6_enable_retry_updates => 'use_v6_enable_retry_updates',
        override_ipv6_generate_hostname => 'use_v6_generate_hostname',
        override_ipv6_options => 'use_v6_options',
        override_ipv6_recycle_leases => 'use_v6_recycle_leases',
        override_ipv6_ddns_domainname => 'use_v6_ddns_domainname',
        override_ipv6_ddns_hostname => 'use_v6_ddns_hostname',
        override_ipv6_ddns_ttl => 'use_v6_ddns_ttl',
        override_ipv6_microsoft_code_page => 'use_v6_windows_code_page',
        override_preferred_lifetime => 'use_preferred_lifetime',
        override_valid_lifetime => 'use_valid_lifetime',
        override_ignore_id => 'use_ignore_id',
        ipv6_ddns_server_always_updates => 'v6_always_update_dns',
        ipv6_ddns_domainname => 'v6_ddns_domainname',
        ipv6_ddns_hostname => 'v6_ddns_hostname',
        ipv6_ddns_ttl => 'v6_ddns_ttl',
        ipv6_domain_name => 'v6_domain_name',
        ipv6_domain_name_servers => 'v6_domain_name_servers',
        ipv6_enable_ddns => 'v6_enable_ddns',
        ipv6_enable_gss_tsig => 'v6_enable_gss_tsig',
        ipv6_enable_retry_updates => 'v6_enable_retry_updates',
        ipv6_generate_hostname => 'v6_generate_hostname',
        ipv6_gss_tsig_keys => 'v6_gss_tsig_keys',
        override_ipv6_gss_tsig_keys => 'use_v6_gss_tsig_keys',
        ipv6_kdc_server => 'v6_kdc_server_address',
        ipv6_microsoft_code_page => 'v6_windows_code_page',
        ipv6_options => 'v6_options',
        ipv6_recycle_leases => 'v6_recycle_leases',
        ipv6_retry_updates_interval => 'v6_retry_updates_interval',
        ipv6_server_duid => 'v6_server_duid',
        ipv6_update_dns_on_lease_renewal => 'v6_update_dns_on_lease_renewal',
        ipv6_ddns_enable_option_fqdn => 'v6_enable_option81',
        logic_filters          => 'option_logic_filters',
        override_logic_filters => 'use_option_logic_filters',
        override_ipv6_lease_scavenge => 'use_v6_leases_scavenging',
        ipv6_lease_scavenge_time => 'v6_leases_scavenging_grace_period',
        ipv6_enable_lease_scavenge => 'v6_leases_scavenging_enabled',
        ipv6_remember_expired_client_association => 'v6_remember_expired_client_association',
        override_hostname_rewrite => 'use_enable_hostname_rewrite',
        override_immediate_fa_configuration => 'use_immediate_fa_configuration',
        override_dns_update_style => 'use_dns_update_style',
        override_ipv6_dns_update_style => 'use_v6_dns_update_style',
        ipv6_dns_update_style => 'v6_dns_update_style',

        #
        #
        override_lease_per_client_settings => 'use_lease_per_client_settings',
        override_enable_one_lease_per_client => 'use_lease_per_client_settings',
        enable_one_lease_per_client => 'lease_per_client_settings',
    );

    %_reverse_name_mappings = (
        reverse(%_name_mappings),
        #
        bootp_properties => '__bootp_properties_handler__',
        common_properties => '__common_properties_handler__',
        extensible_attributes           => 'extattrs',

        #
        use_lease_per_client_settings => 'override_lease_per_client_settings',
        lease_per_client_settings     => 'lease_per_client_settings',
    );

    %_searchable_fields = (
        name => [\&ibap_o2i_string, 'host_name', 'REGEX'],
        ipv4addr => [\&ibap_o2i_string,'address' , 'EXACT'],
        ipv6addr => [\&ibap_o2i_string,'ipv6_address' , 'EXACT'],
        extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
    );

    %_ibap_to_object = (
        authn_captive_portal => \&ibap_i2o_member_byhostname,
        authn_captive_portal_enabled => \&ibap_i2o_boolean,
        authn_server_group_enabled => \&ibap_i2o_boolean,
        authn_captive_portal_authenticated_filter => \&ibap_i2o_generic_object_convert,
        authn_captive_portal_guest_filter => \&ibap_i2o_generic_object_convert,
        authn_server_group => \&ibap_i2o_generic_object_convert,
        ifmap_client_credentials => \&ibap_i2o_generic_object_convert,
        ifmap_last_status_update => \&ibap_i2o_datetime_to_unix_timestamp,
        ifmap_status => \&ibap_i2o_enums_lc_or_undef,
        is_authoritative => \&ibap_i2o_boolean,
        ignore_id => \&ibap_i2o_enums_uc_or_undef,
        ignore_mac_addresses => \&ibap_i2o_mac_addresses,
        use_ignore_id => \&ibap_i2o_boolean,
        generate_hostname => \&ibap_i2o_boolean,
        always_update_dns => \&ibap_i2o_boolean,
        enable_dhcpv6_service => \&ibap_i2o_boolean,
        enable_ifmap_publishing  => \&ibap_i2o_boolean,
        enable_service => \&ibap_i2o_boolean,
        enable_lan2_service => \&ibap_i2o_boolean,
        enable_v6_lan2_service => \&ibap_i2o_boolean,
        enable_threshold_email_warnings => \&ibap_i2o_boolean,
        enable_threshold_snmp_warnings => \&ibap_i2o_boolean,
        enable_thresholds => \&ibap_i2o_boolean,
        enable_retry_updates => \&ibap_i2o_boolean,
        enable_option81 => \&ibap_i2o_boolean,
        enable_ddns => \&ibap_i2o_boolean,
        ddns_zone_primaries => \&ibap_i2o_dhcp_ddns,
        enable_ifmap => \&ibap_i2o_boolean,
        enable_fingerprint => \&ibap_i2o_boolean,
        use_enable_fingerprint => \&ibap_i2o_boolean,
        log_lease_events => \&ibap_i2o_boolean,
        option60_match_rules => \&ibap_i2o_option60_match_rules,
        ping_timeout => \&ibap_i2o_integer_1000,
        recycle_leases => \&ibap_i2o_boolean,
        update_static_leases => \&ibap_i2o_boolean,
        syslog_facility => \&ibap_i2o_enums_lc_or_undef,
        threshold_email_addresses => \&ibap_i2o_email_list,
        extensible_attributes => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
        bootp_properties => \&ibap_i2o_bootp_props,
        common_properties => \&ibap_i2o_common_dhcp_props,
        update_dns_on_lease_renewal     => \&ibap_i2o_boolean,
        use_update_dns_on_lease_renewal => \&ibap_i2o_boolean,
        v6_update_dns_on_lease_renewal     => \&ibap_i2o_boolean,
        use_v6_update_dns_on_lease_renewal => \&ibap_i2o_boolean,
        v6_enable_option81     => \&ibap_i2o_boolean,
        use_v6_enable_option81 => \&ibap_i2o_boolean,
        use_ddns_ttl                    => \&ibap_i2o_boolean,
        use_ddns_domainname                    => \&ibap_i2o_boolean,
        use_client_association_grace_period => \&ibap_i2o_boolean,
        use_enable_ifmap_publishing => \&ibap_i2o_boolean,
        enable_gss_tsig => \&ibap_i2o_boolean,
        use_enable_gss_tsig => \&ibap_i2o_boolean,
        use_log_lease_events => \&ibap_i2o_boolean,
        use_valid_lifetime  => \&ibap_i2o_boolean,
        use_v6_domain_name    => \&ibap_i2o_boolean,
        use_v6_domain_name_servers => \&ibap_i2o_boolean,
        use_v6_enable_ddns => \&ibap_i2o_boolean,
        use_v6_enable_gss_tsig => \&ibap_i2o_boolean,
        use_v6_generate_hostname => \&ibap_i2o_boolean,
        use_v6_options => \&ibap_i2o_boolean,
        use_v6_recycle_leases => \&ibap_o2i_boolean,
        use_v6_enable_retry_updates => \&ibap_o2i_boolean,
        use_v6_ddns_domainname => \&ibap_i2o_boolean,
        use_v6_ddns_hostname => \&ibap_i2o_boolean,
        use_v6_ddns_ttl => \&ibap_i2o_boolean,
        use_preferred_lifetime => \&ibap_i2o_boolean,
        v6_domain_name_servers => \&ibap_i2o_domain_name_servers,
        v6_options => \&ibap_i2o_options,
        v6_recycle_leases => \&ibap_i2o_boolean,
        v6_enable_ddns => \&ibap_i2o_boolean,
        v6_enable_gss_tsig => \&ibap_i2o_boolean,
        v6_enable_retry_updates => \&ibap_i2o_boolean,
        gss_tsig_keys => \&ibap_i2o_generic_object_list_convert,
        use_gss_tsig_keys => \&ibap_i2o_boolean,
        v6_gss_tsig_keys => \&ibap_i2o_generic_object_list_convert,
        use_v6_gss_tsig_keys => \&ibap_i2o_boolean,
        v6_always_update_dns => \&ibap_i2o_boolean,
        v6_generate_hostname => \&ibap_i2o_boolean,
        override_hostname_rewrite => \&ibap_i2o_boolean,
        enable_hostname_rewrite => \&ibap_i2o_boolean,
        hostname_rewrite_policy => \&__i2o_hostname_rewrite_policy__,
        use_immediate_fa_configuration => \&ibap_i2o_boolean,
        immediate_fa_configuration => \&ibap_i2o_boolean,
        option_logic_filters     => \&ibap_i2o_ordered_filters,
        use_option_logic_filters => \&ibap_i2o_boolean,
        use_dns_update_style => \&ibap_i2o_boolean,
        use_v6_dns_update_style => \&ibap_i2o_boolean,
        use_lease_per_client_settings => \&ibap_i2o_boolean,
    );

    %_object_to_ibap = (
        authority => \&ibap_o2i_boolean,
        authn_server_group_enabled => \&ibap_o2i_boolean,
        authn_captive_portal_enabled => \&ibap_o2i_boolean,
        authn_captive_portal => \&ibap_o2i_member_byhostname,
        authn_captive_portal_authenticated_filter => \&__o2i_filter__,
        authn_captive_portal_guest_filter => \&__o2i_filter__,
        auth_server_group => \&__o2i_authserver__,
        bootfile => \&ibap_o2i_ignore,
        bootserver => \&ibap_o2i_ignore,
        ddns_generate_hostname => \&ibap_o2i_boolean,
        ddns_retry_interval => \&ibap_o2i_integer,
        ddns_server_always_updates => \&ibap_o2i_boolean,
        ddns_ttl => \&ibap_o2i_integer,
        ddns_domainname => \&ibap_o2i_string,
        ddns_update_fixed_addresses => \&ibap_o2i_boolean,
        ddns_use_option81 => \&ibap_o2i_boolean,
        ddns_zone_primaries => \&ibap_o2i_generic_struct_list_convert,
        deny_bootp => \&ibap_o2i_ignore,
        email_list => \&ibap_o2i_email_list,
        enable_ddns => \&ibap_o2i_boolean,
        enable_dhcp => \&ibap_o2i_boolean,
        enable_dhcp_on_lan2 => \&ibap_o2i_boolean,
        enable_dhcp_on_ipv6_lan2 => \&ibap_o2i_boolean,
        enable_dhcp_thresholds => \&ibap_o2i_boolean,
        enable_email_warnings => \&ibap_o2i_boolean,
        enable_gss_tsig => \&ibap_o2i_boolean,
        enable_ifmap =>  \&ibap_o2i_boolean,
        enable_ifmap_publishing => \&ibap_o2i_boolean,
        enable_snmp_warnings => \&ibap_o2i_boolean,
        enable_fingerprint => \&ibap_o2i_boolean,
        extattrs           => \&ibap_o2i_ignore,
        extensible_attributes => \&ibap_o2i_ignore,
        gss_tsig_key => \&ibap_o2i_ignore,
        gss_tsig_keys => \&ibap_o2i_gss_tsig_keys,
        override_gss_tsig_keys => \&ibap_o2i_boolean,
        high_water_mark => \&ibap_o2i_uint,
        high_water_mark_reset => \&ibap_o2i_uint,
        ifmap_client_credentials => \&__o2i_credentials__,
        ifmap_password => \&ibap_o2i_ignore,
        ifmap_last_status_update => \&ibap_o2i_ignore,
        ifmap_status => \&ibap_o2i_ignore,
        ifmap_status_details => \&ibap_o2i_ignore,
        ifmap_username => \&ibap_o2i_ignore,
        ignore_dhcp_option_list_request => \&ibap_o2i_ignore,
        ignore_id => \&ibap_o2i_string,
        ignore_mac_addresses => \&ibap_o2i_mac_addresses,
        kdc_server => \&ibap_o2i_string_undef_to_empty,
        lease_scavenge_time => \&ibap_o2i_integer,
        log_lease_events => \&ibap_o2i_boolean,
        low_water_mark => \&ibap_o2i_uint,
        low_water_mark_reset => \&ibap_o2i_uint,
        microsoft_code_page => \&ibap_o2i_string,
        name => \&ibap_o2i_string,
        nextserver => \&ibap_o2i_ignore,
        option60_match_rules => \&ibap_o2i_option60_match_rules,
        options => \&ibap_o2i_ignore,
        ping_count => \&ibap_o2i_integer,
        ping_timeout => \&ibap_o2i_integer_1000,
        pxe_lease_time => \&ibap_o2i_ignore,
        recycle_leases => \&ibap_o2i_boolean,
        retry_ddns_updates => \&ibap_o2i_boolean,
        syslog_facility => \&ibap_o2i_enums_lc_or_undef,
        bootp_properties => \&ibap_arg_bootp_props,
        common_properties => \&ibap_o2i_common_dhcp_props,
        update_dns_on_lease_renewal         => \&ibap_o2i_boolean,
        #
        override_enable_fingerprint          => \&ibap_o2i_boolean,
        override_lease_scavenge_time         => \&ibap_o2i_boolean,
        override_update_dns_on_lease_renewal => \&ibap_o2i_boolean,
        override_ddns_ttl                    => \&ibap_o2i_boolean,
        override_ddns_domainname                    => \&ibap_o2i_boolean,
        override_enable_ifmap_publishing => \&ibap_o2i_boolean,
        override_ignore_id => \&ibap_o2i_boolean,
        use_client_association_grace_period => \&ibap_o2i_boolean,
        use_enable_ddns => \&ibap_o2i_boolean,
        use_enable_option81 => \&ibap_o2i_boolean,
        use_enable_retry_updates => \&ibap_o2i_boolean,
        use_enable_thresholds => \&ibap_o2i_boolean,
        use_generate_hostname => \&ibap_o2i_boolean,
        use_is_authoritative => \&ibap_o2i_boolean,
        use_option60_match_rules => \&ibap_o2i_boolean,
        use_ping_number => \&ibap_o2i_boolean,
        use_ping_timeout => \&ibap_o2i_boolean,
        use_recycle_leases => \&ibap_o2i_boolean,
        use_syslog_facility => \&ibap_o2i_boolean,
        use_threshold_email_addresses => \&ibap_o2i_boolean,
        use_update_static_leases => \&ibap_o2i_boolean,
        use_windows_code_page => \&ibap_o2i_boolean,
        #
        use_boot_file  => \&ibap_o2i_ignore,
        use_boot_server => \&ibap_o2i_ignore,
        use_deny_bootp => \&ibap_o2i_ignore,
        use_next_server => \&ibap_o2i_ignore,
        #
        use_broadcast_address => \&ibap_o2i_ignore,
        use_domain_name => \&ibap_o2i_ignore,
        use_domain_name_servers => \&ibap_o2i_ignore,
        use_ignore_client_requested_options => \&ibap_o2i_ignore,
        use_lease_time => \&ibap_o2i_ignore,
        use_options => \&ibap_o2i_ignore,
        use_pxe_lease_time => \&ibap_o2i_ignore,
        use_routers => \&ibap_o2i_ignore,
        #
        enable_dhcpv6_service => \&ibap_o2i_boolean,
        override_log_lease_events => \&ibap_o2i_boolean,
        override_ipv6_enable_ddns => \&ibap_o2i_boolean,
        override_enable_gss_tsig => \&ibap_o2i_boolean,
        override_ipv6_enable_gss_tsig => \&ibap_o2i_boolean,
        override_ipv6_generate_hostname => \&ibap_o2i_boolean,
        override_ipv6_options => \&ibap_o2i_boolean,
        override_ipv6_recycle_leases => \&ibap_o2i_boolean,
        override_ipv6_enable_retry_updates => \&ibap_o2i_boolean,
        override_ipv6_ddns_domainname => \&ibap_o2i_boolean,
        override_ipv6_ddns_hostname => \&ibap_o2i_boolean,
        override_ipv6_domain_name   => \&ibap_o2i_boolean,
        override_ipv6_domain_name_servers => \&ibap_o2i_boolean,
        override_ipv6_ddns_ttl => \&ibap_o2i_boolean,
        override_ipv6_microsoft_code_page => \&ibap_o2i_boolean,
        override_ipv6_update_dns_on_lease_renewal => \&ibap_o2i_boolean,
        override_ipv6_ddns_enable_option_fqdn => \&ibap_o2i_boolean,
        override_preferred_lifetime => \&ibap_o2i_boolean,
        override_valid_lifetime => \&ibap_o2i_boolean,
        preferred_lifetime => \&ibap_o2i_uint,
        ipv6_options => \&ibap_o2i_options,
        ipv6_recycle_leases => \&ibap_o2i_boolean,
        ipv6_enable_ddns => \&ibap_o2i_boolean,
        ipv6_enable_gss_tsig => \&ibap_o2i_boolean,
        ipv6_enable_retry_updates => \&ibap_o2i_boolean,
        ipv6_ddns_server_always_updates => \&ibap_o2i_boolean,
        ipv6_generate_hostname => \&ibap_o2i_boolean,
        ipv6_gss_tsig_key => \&ibap_o2i_ignore,
        ipv6_gss_tsig_keys => \&ibap_o2i_ipv6_gss_tsig_keys,
        override_ipv6_gss_tsig_keys => \&ibap_o2i_boolean,
        ipv6_kdc_server => \&ibap_o2i_string_undef_to_empty,
        ipv6_ddns_domainname => \&ibap_o2i_string,
        ipv6_ddns_hostname => \&ibap_o2i_string,
        ipv6_domain_name => \&ibap_o2i_string_skip_undef,
        ipv6_domain_name_servers => \&ibap_o2i_domain_name_servers,
        ipv6_ddns_ttl => \&ibap_o2i_uint,
        ipv6_microsoft_code_page => \&ibap_o2i_string,
        ipv6_server_duid => \&ibap_o2i_string,
        ipv6_retry_updates_interval => \&ibap_o2i_uint,
        ipv6_update_dns_on_lease_renewal         => \&ibap_o2i_boolean,
        ipv6_ddns_enable_option_fqdn         => \&ibap_o2i_boolean,
        valid_lifetime => \&ibap_o2i_integer_skip_undef,
        override_logic_filters        => \&ibap_o2i_boolean,
        logic_filters                 => \&ibap_o2i_ordered_filters,
        override_hostname_rewrite => \&ibap_o2i_boolean,
        enable_hostname_rewrite => \&ibap_o2i_boolean,
        hostname_rewrite_policy => \&__o2i_hostname_rewrite_policy__,
        use_enable_hostname_rewrite_ => \&ibap_o2i_ignore,
        use_hostname_rewrite_policy_ => \&ibap_o2i_ignore,
        override_immediate_fa_configuration => \&ibap_o2i_boolean,
        immediate_fa_configuration => \&ibap_o2i_boolean,
        ipv6_enable_lease_scavenge => \&ibap_o2i_boolean,
        ipv6_lease_scavenge_time => \&ibap_o2i_uint,
        override_ipv6_lease_scavenge => \&ibap_o2i_boolean,
        ipv6_remember_expired_client_association => \&ibap_o2i_boolean,
        dns_update_style => \&ibap_o2i_string,
        override_dns_update_style => \&ibap_o2i_boolean,
        ipv6_dns_update_style => \&ibap_o2i_string,
        override_ipv6_dns_update_style => \&ibap_o2i_boolean,
        #
        override_enable_one_lease_per_client => \&ibap_o2i_ignore,
        enable_one_lease_per_client => \&ibap_o2i_ignore,
        override_lease_per_client_settings => \&ibap_o2i_boolean,
        lease_per_client_settings => \&ibap_o2i_string,
        
    );

    @_return_fields = (
        tField('authn_server_group_enabled'),
        tField('authn_captive_portal_enabled'),
        tField('authn_captive_portal', return_fields_member_basic_data()),
        tField('is_authoritative'),
        tField('ignore_id'),
        tField('ignore_mac_addresses',{ sub_fields => [ tField('mac_addr')]}),
        tField('generate_hostname'),
        tField('retry_updates_interval'),
        tField('always_update_dns'),
        tField('ddns_ttl'),
        tField('ddns_domainname'),
        tField('update_static_leases '),
        tField('client_association_grace_period'),
        tField('enable_option81'),
        tField('threshold_email_addresses'),
        tField('enable_ddns'),
        tField('enable_ifmap_publishing'),
        tField('enable_service'),
        tField('enable_lan2_service'),
        tField('enable_v6_lan2_service'),
        tField('enable_thresholds'),
        tField('enable_threshold_email_warnings'),
        tField('enable_threshold_snmp_warnings'),
        tField('enable_fingerprint'),
        tField('use_enable_fingerprint'),
        tField('host_name'),
        tField('range_high_water_mark'),
        tField('range_high_water_mark_reset'),
        tField('kdc_server_address'),
        tField('log_lease_events'),
        tField('use_log_lease_events'),
        tField('range_low_water_mark'),
        tField('range_low_water_mark_reset'),
        tField('windows_code_page'),
        tField('option60_match_rules', {depth => 2}),
        tField('ping_number'),
        tField('ping_timeout'),
        tField('recycle_leases'),
        tField('enable_retry_updates'),
        tField('syslog_facility'),
        tField('enable_ifmap'),
        tField('ifmap_last_status_update'),
        tField('ifmap_status'),
        tField('ifmap_status_details'),
        tField('update_dns_on_lease_renewal'),
        tField('use_update_dns_on_lease_renewal'),
        tField('use_client_association_grace_period'),
        tField('use_ddns_ttl'),
        tField('use_ddns_domainname'),
        tField('use_enable_ddns'),
        tField('use_enable_ifmap_publishing'),
        tField('use_enable_option81'),
        tField('use_enable_retry_updates'),
        tField('use_enable_thresholds'),
        tField('use_generate_hostname'),
        tField('use_gss_tsig_keys'),
        tField('use_is_authoritative'),
        tField('use_option60_match_rules'),
        tField('use_ping_number'),
        tField('use_ping_timeout'),
        tField('use_recycle_leases'),
        tField('use_syslog_facility'),
        tField('use_threshold_email_addresses'),
        tField('use_update_static_leases '),
        tField('use_windows_code_page'),
        tField('use_ignore_id'),
        tField('bootp_properties', { depth => 1 }),
        tField('common_properties', { depth => 2 }),
        return_fields_extensible_attributes(),
        tField('enable_dhcpv6_service'),
        tField('enable_gss_tsig'),
        tField('use_enable_gss_tsig'),
        tField('v6_always_update_dns'),
        tField('v6_ddns_domainname'),
        tField('v6_ddns_hostname'),
        tField('v6_ddns_ttl'),
        tField('v6_domain_name'),
        tField('v6_domain_name_servers',{ sub_fields => [ tField('address')]}),
        tField('v6_enable_ddns'),
        tField('v6_enable_gss_tsig'),
        tField('v6_enable_retry_updates'),
        tField('v6_generate_hostname'),
        tField('v6_kdc_server_address'),
        tField('v6_options', { depth => 1}),
        tField('v6_recycle_leases'),
        tField('v6_retry_updates_interval'),
        tField('v6_server_duid'),
        tField('v6_update_dns_on_lease_renewal'),
        tField('v6_enable_option81'),
        tField('v6_windows_code_page'),
        tField('v6_leases_scavenging_enabled'),
        tField('v6_leases_scavenging_grace_period'),
        tField('v6_remember_expired_client_association'),
        tField('preferred_lifetime'),
        tField('valid_lifetime'),
        tField('use_v6_ddns_domainname'),
        tField('use_v6_ddns_hostname'),
        tField('use_v6_ddns_ttl'),
        tField('use_v6_domain_name_servers'),
        tField('use_v6_domain_name' ),
        tField('use_v6_enable_ddns'),
        tField('use_v6_enable_gss_tsig'),
        tField('use_v6_enable_retry_updates'),
        tField('use_v6_generate_hostname'),
        tField('use_v6_gss_tsig_keys'),
        tField('use_v6_options'),
        tField('use_v6_recycle_leases'),
        tField('use_v6_update_dns_on_lease_renewal'),
        tField('use_v6_enable_option81'),
        tField('use_v6_windows_code_page'),
        tField('use_v6_leases_scavenging'),
        tField('use_preferred_lifetime'),
        tField('use_valid_lifetime'),
        tField('option_logic_filters', return_fields_option_logic_filters()),
        tField('use_enable_hostname_rewrite'),
        tField('enable_hostname_rewrite'),
        tField('hostname_rewrite_policy', { sub_fields => [ tField('policy_name')]}),
        tField('use_immediate_fa_configuration'),
        tField('immediate_fa_configuration'),
        tField('use_option_logic_filters'),
        tField('dns_update_style'),
        tField('use_dns_update_style'),
        tField('v6_dns_update_style'),
        tField('use_v6_dns_update_style'),
        tField('use_lease_per_client_settings'),
        tField('lease_per_client_settings'),
    );

    $_return_fields_initialized=0;
    %_return_field_overrides = (
        always_update_dns => [],
        auth_server_group => [],
        bootfile => ['!bootp_properties'],
        bootp_properties => [],
        bootserver => ['!bootp_properties'],
        common_properties => [],
        lease_scavenge_time => ['use_client_association_grace_period'],
        override_lease_scavenge_time => [],
        ddns_ttl                            => ['use_ddns_ttl'],
        override_ddns_ttl                    => [],
        ddns_domainname                            => ['use_ddns_domainname'],
        ddns_zone_primaries => [],
        override_ddns_domainname                    => [],
        update_dns_on_lease_renewal         => ['use_update_dns_on_lease_renewal'],
        override_update_dns_on_lease_renewal => [],
        deny_bootp => ['!bootp_properties'],
        enable_ddns => [],
        enable_ifmap => [],
        ifmap_client_credentials => [],
        ifmap_last_status_update => [],
        ifmap_status => [],
        ifmap_status_details => [],
        ifmap_username => [],
        ifmap_password => [],
        ignore_id => ['use_ignore_id'],
        ignore_mac_addresses => ['use_ignore_id'],
        ignore_client_identifier      => ['ignore_id','use_ignore_id'],
        enable_gss_tsig => ['use_enable_gss_tsig'],
        enable_ifmap_publishing => ['use_enable_ifmap_publishing'],
        enable_lan2_service => [],
        enable_v6_lan2_service => [],
        enable_option81 => [],
        enable_retry_updates => [],
        enable_service => [],
        enable_threshold_email_warnings => [],
        enable_thresholds => [],
        enable_threshold_snmp_warnings => [],
        enable_fingerprint => ['use_enable_fingerprint'],
        override_enable_fingerprint => [],
        extattrs => [],
        extensible_attributes => [],
        generate_hostname => [],
        gss_tsig_key => ['gss_tsig_keys', 'use_gss_tsig_keys'],
        gss_tsig_keys => ['use_gss_tsig_keys'],
        override_gss_tsig_keys => [],
        host_name => [],
        is_authoritative => [],
        kdc_server => [],
        log_lease_events => ['use_log_lease_events'],
        nextserver => ['!bootp_properties'],
        option60_match_rules => [],
        options => ['!common_properties'],
        ping_number => [],
        ping_timeout => [],
        pxe_lease_time => ['!common_properties'],
        range_high_water_mark => [],
        range_high_water_mark_reset => [],
        range_low_water_mark => [],
        range_low_water_mark_reset => [],
        recycle_leases => [],
        retry_updates_interval => [],
        syslog_facility => [],
        threshold_email_addresses => [],
        update_static_leases  => [],
        use_enable_ddns => [],
        use_enable_option81 => [],
        use_enable_retry_updates => [],
        use_enable_thresholds => [],
        use_generate_hostname => [],
        use_is_authoritative => [],
        use_option60_match_rules => [],
        use_ping_number => [],
        use_ping_timeout => [],
        use_recycle_leases => [],
        use_syslog_facility => [],
        use_threshold_email_addresses => [],
        use_update_static_leases  => [],
        use_windows_code_page => [],
        windows_code_page => [],
        enable_dhcpv6_service => [],
        ipv6_ddns_server_always_updates => [],
        ipv6_ddns_domainname => ['use_v6_ddns_domainname'],
        ipv6_ddns_hostname => ['use_v6_ddns_hostname'],
        ipv6_ddns_ttl => ['use_v6_ddns_ttl'],
        ipv6_domain_name => ['use_v6_domain_name'],
        ipv6_domain_name_servers => ['use_v6_domain_name_servers'],
        ipv6_enable_ddns => ['use_v6_enable_ddns'],
        ipv6_enable_gss_tsig => ['use_v6_enable_gss_tsig'],
        ipv6_enable_retry_updates => ['use_v6_enable_retry_updates'],
        ipv6_generate_hostname => ['use_v6_generate_hostname'],
        ipv6_gss_tsig_key => ['v6_gss_tsig_keys', 'use_v6_gss_tsig_keys'],
        ipv6_gss_tsig_keys => ['use_v6_gss_tsig_keys'],
        override_ipv6_gss_tsig_keys => [],
        ipv6_kdc_server => [],
        ipv6_options => ['use_v6_options'],
        ipv6_recycle_leases => ['use_v6_recycle_leases'],
        ipv6_retry_updates_interval => [],
        ipv6_server_duid => [],
        ipv6_microsoft_code_page => ['use_v6_windows_code_page'],
        ipv6_update_dns_on_lease_renewal         => ['use_v6_update_dns_on_lease_renewal'],
        ipv6_ddns_enable_option_fqdn         => ['use_enable_option81'],
        preferred_lifetime => ['use_preferred_lifetime'],
        valid_lifetime => ['use_valid_lifetime'],
        override_enable_ifmap_publishing => [],
        override_enable_gss_tsig => [],
        override_ipv6_ddns_domainname => [],
        override_ipv6_ddns_hostname => [],
        override_ipv6_domain_name => [],
        override_ipv6_domain_name_servers => [],
        override_ipv6_ddns_ttl => [],
        override_ipv6_enable_ddns => [],
        override_ipv6_enable_gss_tsig => [],
        override_ipv6_enable_retry_updates => [],
        override_ipv6_generate_hostname => [],
        override_ipv6_options => [],
        override_ipv6_recycle_leases => [],
        override_ipv6_microsoft_code_page => [],
        override_ipv6_update_dns_on_lease_renewal => [],
        override_ipv6_ddns_enable_option_fqdn => [],
        override_preferred_lifetime => [],
        override_valid_lifetime => [],
        override_ignore_id => [],
        override_ignore_client_identifier => ['use_ignore_id'],
        logic_filters               => ['use_option_logic_filters'],
        override_logic_filters      => [],
        override_hostname_rewrite => [],
        enable_hostname_rewrite => ['override_hostname_rewrite'],
        hostname_rewrite_policy => ['override_hostname_rewrite'],
        immediate_fa_configuration => ['use_immediate_fa_configuration'],
        override_immediate_fa_configuration =>[],
        override_ipv6_lease_scavenge => [],
        ipv6_enable_lease_scavenge => ['use_v6_leases_scavenging'],
        ipv6_lease_scavenge_time => ['use_v6_leases_scavenging'],
        ipv6_remember_expired_client_association => ['use_v6_leases_scavenging'], 
        dns_update_style => ['use_dns_update_style'],
        override_dns_update_style => [],
        ipv6_dns_update_style => ['use_v6_dns_update_style'],
        override_ipv6_dns_update_style => [],
        #
        lease_per_client_settings => ['use_lease_per_client_settings'],
        override_lease_per_client_settings => [],
        enable_one_lease_per_client => ['use_lease_per_client_settings'],
        override_enable_one_lease_per_client => [],
    );
}

sub __new__
{
    my ( $proto, %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self, $class;

	unless ($_return_fields_initialized) {
		$_return_fields_initialized=1;

        my $t=Infoblox::Grid::Admin::RadiusAuthService->__new__();
        push @_return_fields,
          tField('authn_server_group', {
                                       sub_fields => $t->__return_fields__(),
                                      }
                );

        $t=Infoblox::DHCP::Filter::MAC->__new__();
        push @_return_fields,
          tField('authn_captive_portal_authenticated_filter', {
                                       sub_fields => $t->__return_fields__(),
                                      }
                );
        push @_return_fields,
          tField('authn_captive_portal_guest_filter', {
                                       sub_fields => $t->__return_fields__(),
                                      }
                );

        $t=Infoblox::IFMap::Client::Credentials->__new__();
        push @_return_fields,
          tField('ifmap_client_credentials', {
                                 sub_fields => $t->__return_fields__(),
                                }    
                );   

        $t=Infoblox::Grid::KerberosKey->__new__();
        push @_return_fields,
          tField('v6_gss_tsig_keys', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        push @_return_fields,
          tField('gss_tsig_keys', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        $t=Infoblox::DHCP::DDNS->__new__();
        push @_return_fields,
          tField('ddns_zone_primaries', {
                                sub_fields => $t->__return_fields__(),
                               }
                );
    }

    $self->{'override_enable_ifmap_publishing'} = 'false' unless defined $self->override_enable_ifmap_publishing();
    #
    $self->{'override_hostname_rewrite'} = 'false' unless defined $self->{'override_hostname_rewrite'};
    $self->{'enable_hostname_rewrite'} = 'false' unless defined $self->enable_hostname_rewrite();

    return $self;
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

sub __i2o_addresses__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
        return join(',',@{$$ibap_object_ref{$current}});
    } else {
        return;
    }
}

sub __i2o_hostname_rewrite_policy__
{   
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    return $ibap_object_ref->{$current}->{'policy_name'};
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    
    $self->{'ddns_server_always_updates'} = 'false';
    $self->{'enable_dhcp'} = 'false';
    $self->{'enable_dhcp_on_lan2'} = 'false';
    $self->{'enable_dhcp_on_ipv6_lan2'} = 'false';
    $self->{'enable_dhcpv6_service'} = 'false';
    $self->{'enable_email_warnings'} = 'false';
    $self->{'enable_snmp_warnings'} = 'false';
    $self->{'enable_ifmap'} = 'false';
    $self->{'enable_ifmap_publishing'} = 'false';
    $self->{'log_lease_events'} = 'false';
    $self->{'authn_server_group_enabled'} = 'false';
    $self->{'authn_captive_portal_enabled'} = 'false';
    $self->{'options'} = [];
    $self->{'bootp_properties'} = {};
    $self->{'common_properties'} = {};
    $self->{'enable_gss_tsig'} = 'false';
    $self->{'ipv6_enable_ddns'} = 'false';
    $self->{'ipv6_enable_gss_tsig'} = 'false';
    $self->{'ipv6_ddns_server_always_updates'} = 'false';
    $self->{'ipv6_generate_hostname'} = 'false';
    $self->{'ipv6_recycle_leases'} = 'false';
    $self->{'ipv6_enable_retry_updates'} = 'false';
    $self->{'immediate_fa_configuration'} = 'false';
    #
    for my $flag (
        'use_option60_match_rules',
        'use_ping_number',
        'use_ping_timeout',
        'use_recycle_leases',
        'use_syslog_facility',
        'use_windows_code_page',
        'use_log_lease_events',
        'use_enable_thresholds',
        'use_enable_retry_updates',
        'use_enable_ddns',
        'use_enable_ifmap_publishing',
        'use_threshold_email_addresses',
        'use_enable_option81',
        'use_is_authoritative',
        'use_generate_hostname',
        'use_update_static_leases',
        'use_update_dns_on_lease_renewal',
        'update_dns_on_lease_renewal',
        'use_ddns_ttl',
        'use_gss_tsig_keys',
        'use_ddns_domainname',
        'use_client_association_grace_period',
        'use_enable_gss_tsig',
        'use_v6_enable_ddns',
        'use_v6_enable_gss_tsig',
        'use_v6_generate_hostname',
        'use_v6_options',
        'use_v6_ddns_domainname',
        'use_v6_ddns_hostname',
        'use_v6_ddns_ttl',
        'use_preferred_lifetime',
        'use_v6_domain_name',
        'use_valid_lifetime',
        'use_v6_domain_name_servers',
        'use_v6_gss_tsig_keys',
        'use_v6_recycle_leases',
        'use_v6_windows_code_page',
        'use_v6_enable_retry_updates',
        'use_v6_update_dns_on_lease_renewal',
        'use_v6_enable_option81',
        'v6_update_dns_on_lease_renewal',
        'v6_enable_option81',
        'v6_enable_retry_updates',
        'override_hostname_rewrite',
        'use_lease_per_client_settings',
        'use_immediate_fa_configuration',
        'use_ignore_id',
        'enable_fingerprint',
        'use_enable_fingerprint',
        'use_option_logic_filters',
        'use_v6_leases_scavenging',
        'v6_leases_scavenging_enabled',
        'v6_remember_expired_client_association',
        'use_dns_update_style',
        'use_v6_dns_update_style',
    ) {
        $ibap_object_ref->{$flag} = 0
            unless defined ($ibap_object_ref->{$flag});
    }
    if ($ibap_object_ref && $ibap_object_ref->{bootp_properties}) {
        for my $flag (
           'use_boot_file',
           'use_boot_server',
           'use_deny_bootp',
           'use_next_server',
        ) {
            $ibap_object_ref->{$flag} = 0
                unless defined($ibap_object_ref->{bootp_properties}->{$flag});
        }
    }
    if ($ibap_object_ref && $ibap_object_ref->{common_properties}) {
        for my $flag (
            'use_broadcast_address',
            'use_domain_name',
            'use_domain_name_servers',
            'use_ignore_client_requested_options',
            'use_lease_time',
            'use_options',
            'use_pxe_lease_time',
            'use_routers',
        ) {
            $ibap_object_ref->{$flag} = 0
                unless defined($ibap_object_ref->{common_properties}->{$flag});
        }
    }

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    #
    for my $flag (
        'use_option60_match_rules',
        'use_ping_number',
        'use_ping_timeout',
        'use_recycle_leases',
        'use_syslog_facility',
        'use_windows_code_page',
        'use_enable_thresholds',
        'use_enable_retry_updates',
        'use_enable_ddns',
        'use_threshold_email_addresses',
        'use_enable_option81',
        'use_is_authoritative',
        'use_generate_hostname',
        'use_update_static_leases',
        'use_client_association_grace_period',
    ) {
        $self->{$flag} = $ibap_object_ref->{$flag};
    }
    if ($ibap_object_ref && $ibap_object_ref->{bootp_properties}) {
        for my $flag (
           'use_boot_file',
           'use_boot_server',
           'use_deny_bootp',
           'use_next_server',
        ) {
            $self->{$flag} = $ibap_object_ref->{bootp_properties}->{$flag};
        }
    }
    if ($ibap_object_ref && $ibap_object_ref->{common_properties}) {
        for my $flag (
            'use_broadcast_address',
            'use_domain_name',
            'use_domain_name_servers',
            'use_ignore_client_requested_options',
            'use_lease_time',
            'use_options',
            'use_pxe_lease_time',
            'use_routers',
        ) {
            $self->{$flag} = $ibap_object_ref->{common_properties}->{$flag};
        }
    }

    #
    delete $self->{'option60_match_rules'}
        unless $self->{'use_option60_match_rules'};
    
    delete $self->{'ping_count'}
        unless $self->{'use_ping_number'};
    
    delete $self->{'ping_timeout'}
        unless $self->{'use_ping_timeout'};
    
    delete $self->{'microsoft_code_page'}
        unless $self->{'use_windows_code_page'};

    #
    #

    #
    $self->{'authority'} = 'false'
        unless $self->{'use_is_authoritative'} and defined $self->{'authority'};

    $self->{'ddns_generate_hostname'} = 'false'
        unless $self->{'use_generate_hostname'} and defined $self->{'ddns_generate_hostname'};

    $self->{'ddns_update_fixed_addresses'} = 'false'
        unless $self->{'use_update_static_leases'} and defined $self->{'ddns_update_fixed_addresses'};

    $self->{'ddns_use_option81'} = 'false'
        unless $self->{'use_enable_option81'} and defined $self->{'ddns_use_option81'};

    $self->{'deny_bootp'} = 'false'
        if $self->{'use_deny_bootp'} and !defined $self->{'deny_bootp'};

    $self->{'email_list'} = []
        unless $self->{'use_threshold_email_addresses'} and defined $self->{'email_list'};

    $self->{'enable_ddns'} = 'false' 
        unless $self->{'use_enable_ddns'} and defined $self->{'enable_ddns'};

    $self->{'enable_ifmap'} = 'false' 
        unless defined $self->{'enable_ifmap'};

    $self->{'enable_dhcp_thresholds'} = 'false' 
        unless $self->{'use_enable_thresholds'} and defined $self->{'enable_dhcp_thresholds'};

    $self->{'ignore_dhcp_option_list_request'} = 'false'
        if $self->{'use_ignore_client_requested_options'} and !defined $self->{'ignore_dhcp_option_list_request'};

    $self->{'ipv6_enable_gss_tsig'} = 'false'
        if $self->{'override_ipv6_enable_gss_tsig'} and !defined $self->{'ipv6_enable_gss_tsig'};

    $self->{'enable_gss_tsig'} = 'false'
        if $self->{'override_enable_gss_tsig'} and !defined $self->{'enable_gss_tsig'};

    $self->{'recycle_leases'} = 'false'
        unless $self->{'use_recycle_leases'} and defined $self->{'recycle_leases'};

    $self->{'retry_ddns_updates'} = 'false' 
        unless $self->{'use_enable_retry_updates'} and defined $self->{'retry_ddns_updates'};

    $self->{'syslog_facility'} = 'DAEMON'
        unless $self->{'use_syslog_facility'} and defined $self->{'syslog_facility'};

    #
    $self->{'override_ddns_ttl'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_ttl'});
    $self->{'override_gss_tsig_keys'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_gss_tsig_keys'});
    $self->{'override_ipv6_gss_tsig_keys'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_gss_tsig_keys'});
    $self->{'override_ddns_domainname'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_domainname'});
    $self->{'override_lease_scavenge_time'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_client_association_grace_period'});
    $self->{'override_log_lease_events'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_log_lease_events'});
    $self->{'override_update_dns_on_lease_renewal'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_update_dns_on_lease_renewal'});
    $self->{'override_ipv6_update_dns_on_lease_renewal'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_update_dns_on_lease_renewal'});
    $self->{'override_ipv6_ddns_enable_option_fqdn'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_enable_option81'});
    $self->{'override_ipv6_enable_ddns'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_enable_ddns'});
    $self->{'override_enable_gss_tsig'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_gss_tsig'});
    $self->{'override_ipv6_enable_gss_tsig'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_enable_gss_tsig'});
    $self->{'override_ipv6_enable_retry_updates'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_enable_retry_updates'});
    $self->{'override_ipv6_generate_hostname'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_generate_hostname'});
    $self->{'override_ipv6_options'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_options'});
    $self->{'override_ipv6_ddns_domainname'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_ddns_domainname'});
    $self->{'override_ipv6_ddns_hostname'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_ddns_hostname'});
    $self->{'override_ipv6_ddns_ttl'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_ddns_ttl'});
    $self->{'override_preferred_lifetime'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_preferred_lifetime'});
    $self->{'override_ipv6_domain_name'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_domain_name'});
    $self->{'override_valid_lifetime'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_valid_lifetime'});
    $self->{'override_ipv6_domain_name_servers'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_domain_name_servers'});
    $self->{'override_ipv6_recycle_leases'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_recycle_leases'});
    $self->{'override_ipv6_microsoft_code_page'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_windows_code_page'});
    $self->{'override_hostname_rewrite'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_hostname_rewrite'});
    $self->{'override_lease_per_client_settings'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_lease_per_client_settings'});
    $self->{'override_immediate_fa_configuration'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_immediate_fa_configuration'});
    $self->{'override_ignore_id'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_ignore_id'});
    $self->{'override_enable_fingerprint'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_fingerprint'});
    $self->{'override_logic_filters'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_option_logic_filters'});
    $self->{'override_ipv6_lease_scavenge'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_leases_scavenging'});
    $self->{'override_dns_update_style'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_dns_update_style'});
    $self->{'override_ipv6_dns_update_style'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_dns_update_style'});

    return $res;
}

sub __o2i_addresses__
{
	my ($self, $session, $current, $tempref) = @_;

    my @list;
    if ($$tempref{$current}) {
        my @t = split /,/,$$tempref{$current};
        foreach (@t) {
            push @list, ibap_value_o2i_string($_);
        }
    }
    return (1,0,tIBType('ArrayOfIPAddress', \@list));
}

sub __o2i_authserver__
{
	my ($self, $session, $current, $tempref) = @_;

	if (not defined $$tempref{$current}) {
        return (1,0, undef);
	} else {
        return (1,0, ibap_readfield_simple_string('RadiusAuthService','name',$$tempref{$current}->name(), $current));
	}
}

sub __o2i_credentials__
{
    my ($self, $session, $current, $tempref) = @_;

    if (not defined $$tempref{$current}) {
        return (1,0, undef);
    } else {
        return ibap_o2i_generic_struct_convert($self, $session, $current, $tempref);
    }
}

sub __o2i_filter__
{
	my ($self, $session, $current, $tempref) = @_;

	if (not defined $$tempref{$current}) {
        return (1,0, undef);
	} else {
        return (1,0, ibap_readfield_simple_string('DhcpMacFilter','name',$$tempref{$current}->name(), $current));
	}
}

sub __o2i_hostname_rewrite_policy__
{
    my ($self, $session, $current, $tempref) = @_;

    if (not defined $$tempref{$current}) {
        return (1,0, undef);
    } else {
        return (1, 0, ibap_readfield_simple_string('HostNameRewritePolicy','policy_name',$$tempref{$current}, $current));
    }
}

#
#
#

sub auth_server_group
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'auth_server_group', validator => { 'Infoblox::Grid::Admin::RadiusAuthService' => 1 }}, @_);
}

sub authn_server_group_enabled
{
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'authn_server_group_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub authn_captive_portal_enabled
{
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'authn_captive_portal_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub authn_captive_portal
{
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'authn_captive_portal', validator => \&ibap_value_o2i_string}, @_);
}

sub authn_captive_portal_authenticated_filter
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'authn_captive_portal_authenticated_filter', validator => { 'Infoblox::DHCP::Filter::MAC' => 1 }}, @_);
}

sub authn_captive_portal_guest_filter
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'authn_captive_portal_guest_filter', validator => { 'Infoblox::DHCP::Filter::MAC' => 1 }}, @_);
}

sub authority { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'authority', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_is_authoritative'}}, @_);
}

sub bootfile { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'bootfile', validator => \&ibap_value_o2i_string, use => \$self->{'use_boot_file'}}, @_);
}

sub bootserver { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'bootserver', validator => \&ibap_value_o2i_string, use => \$self->{'use_boot_server'}}, @_);
}

sub ddns_generate_hostname { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ddns_generate_hostname', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_generate_hostname'}}, @_);
}

sub ddns_retry_interval { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ddns_retry_interval', validator => \&ibap_value_o2i_int}, @_);
}

sub ddns_server_always_updates { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ddns_server_always_updates', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ddns_ttl
{
     my $self=shift;
    return $self->__accessor_scalar__({name => 'ddns_ttl', validator => \&ibap_value_o2i_uint, use => \$self->{'override_ddns_ttl'}, use_truefalse => 1}, @_);
}

sub override_ddns_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ddns_ttl', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ddns_domainname
{
     my $self=shift;
    return $self->__accessor_scalar__({name => 'ddns_domainname', validator => \&ibap_value_o2i_string, use => \$self->{'override_ddns_domainname'}, use_truefalse => 1}, @_);
}

sub override_ddns_domainname
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ddns_domainname', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ddns_update_fixed_addresses { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ddns_update_fixed_addresses', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_update_static_leases'}}, @_);
}

sub ddns_use_option81 { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ddns_use_option81', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_enable_option81'}}, @_);
}

sub deny_bootp { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'deny_bootp', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_deny_bootp'}}, @_);
}

sub email_list { 
    my $self=shift; 
    return $self->__accessor_array__({name => 'email_list', validator => { 'string' => \&ibap_value_o2i_string }, use => \$self->{'use_threshold_email_addresses'}}, @_);
}

sub enable_ddns { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'enable_ddns', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_enable_ddns'}}, @_);
}

sub enable_dhcp { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'enable_dhcp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_dhcp_on_lan2 { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'enable_dhcp_on_lan2', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_dhcp_on_ipv6_lan2 { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'enable_dhcp_on_ipv6_lan2', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_dhcp_thresholds { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'enable_dhcp_thresholds', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_enable_thresholds'}}, @_);
}

sub enable_email_warnings { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'enable_email_warnings', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_ifmap { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'enable_ifmap', validator => \&ibap_value_o2i_boolean}, @_);
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

sub enable_snmp_warnings { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'enable_snmp_warnings', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_fingerprint
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'enable_fingerprint', validator => \&ibap_value_o2i_boolean, use => \$self->{'override_enable_fingerprint'}, use_truefalse => 1}, @_);
}

sub override_enable_fingerprint
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_enable_fingerprint', validator => \&ibap_value_o2i_boolean}, @_);
}

#
#
sub gss_tsig_key { 
    my $self=shift;

    my $t = $self->{'gss_tsig_keys'};
    if (@_) {
        my $value = shift;

        #
        if (defined $t && ref($t) eq 'ARRAY' && scalar(@{$t}) > 1) {
            return set_error_codes(1104,'Multiple GSS-TSIG keys are in use, please use gss_tsig_keys instead.');
        }

        if (defined $value) {
            return $self->gss_tsig_keys([$value]);
        }
        else {
            #
            $self->override_enable_gss_tsig('false');
            return $self->gss_tsig_keys(undef);
        }
    } else {
        if ($t and ref($t) eq 'ARRAY' and scalar(@{$t})) {
            #
            if (scalar(@{$t}) > 1) {
                return set_error_codes(1104,'Multiple GSS-TSIG keys are in use, please use gss_tsig_keys instead.');
            }
            return $t->[0];
        } else {
            return undef;
        }
    }
}

sub gss_tsig_keys { 
    my $self=shift; 
    return $self->__accessor_array__({name => 'gss_tsig_keys', validator => {'Infoblox::Grid::KerberosKey' => 1 }, use => 'override_gss_tsig_keys', use_truefalse => 1}, @_);
}

sub override_gss_tsig_keys {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_gss_tsig_keys', validator => \&ibap_value_o2i_boolean}, @_);
}

sub high_water_mark { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'high_water_mark', validator => \&ibap_value_o2i_uint}, @_);
}

sub high_water_mark_reset { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'high_water_mark_reset', validator => \&ibap_value_o2i_uint}, @_);
}

sub ifmap_client_credentials {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ifmap_client_credentials', validator => {'Infoblox::IFMap::Client::Credentials' => 1}}, @_);
}

sub ifmap_last_status_update {
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ifmap_last_status_update', readonly => 1, validator => \&ibap_value_o2i_int}, @_);
}

sub ifmap_password {
    my $self=shift;
    return $self->__accessor_scalar__({deprecated => 1}, @_);
}

sub ifmap_status {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ifmap_status', readonly => 1, enum => [ 'running', 'stopped', 'warning', 'failed' ]}, @_);
}

sub ifmap_status_details {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ifmap_status_details', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub ifmap_username {
    my $self=shift;
    return $self->__accessor_scalar__({deprecated => 1}, @_);
}

sub ignore_dhcp_option_list_request { 
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ignore_dhcp_option_list_request', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_ignore_client_requested_options'}}, @_);
}

sub ignore_client_identifier {
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

sub ignore_id {
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ignore_id', enum => ['NONE', 'CLIENT', 'MACADDR'], use => \$self->{'override_ignore_id'}, use_truefalse => 1}, @_);
}

sub ignore_mac_addresses {
    my $self = shift;
    return $self->__accessor_array__({name => 'ignore_mac_addresses', validator => \&ibap_value_o2i_string, use => \$self->{'override_ignore_id'}, use_truefalse => 1}, @_);
}

sub override_ignore_client_identifier {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ignore_id', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_ignore_id {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ignore_id', validator => \&ibap_value_o2i_boolean}, @_);
}

sub kdc_server { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'kdc_server', validator => \&ibap_value_o2i_string}, @_);
}

sub lease_scavenge_time
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'lease_scavenge_time', use => \$self->{'override_lease_scavenge_time'}, use_truefalse => 1, validator => \&ibap_value_o2i_int},@_);
}

sub log_lease_events { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'log_lease_events', use => \$self->{'override_log_lease_events'}, validator => \&ibap_value_o2i_boolean, use_truefalse => 1}, @_);
}

sub low_water_mark { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'low_water_mark', validator => \&ibap_value_o2i_uint}, @_);
}

sub low_water_mark_reset { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'low_water_mark_reset', validator => \&ibap_value_o2i_uint}, @_);
}

sub microsoft_code_page { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'microsoft_code_page', validator => \&ibap_value_o2i_string, use => \$self->{'use_windows_code_page'}}, @_);
}

sub name { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub nextserver { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'nextserver', validator => \&ibap_value_o2i_string, use => \$self->{'use_next_server'}}, @_);
}

sub option60_match_rules { 
    my $self=shift; 
    return $self->__accessor_array__({name => 'option60_match_rules', validator => { 'Infoblox::DHCP::Option60MatchRule' => 1 }, use => \$self->{'use_option60_match_rules'}}, @_);
}

sub options { 
    my $self=shift; 
    return ibap_accessor_dhcp_options($self, 'options', @_);
}

sub override_lease_scavenge_time
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_lease_scavenge_time', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_log_lease_events
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_log_lease_events', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ping_count { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ping_count', validator => \&ibap_value_o2i_int, use => \$self->{'use_ping_number'}}, @_);
}

sub ping_timeout { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ping_timeout', validator => \&ibap_value_o2i_int_1000, use => \$self->{'use_ping_timeout'}}, @_);
}

sub pxe_lease_time { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'pxe_lease_time', validator => \&ibap_value_o2i_int, use => \$self->{'use_pxe_lease_time'}}, @_);
}

sub recycle_leases { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'recycle_leases', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_recycle_leases'}}, @_);
}

sub retry_ddns_updates { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'retry_ddns_updates', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_enable_retry_updates'}}, @_);
}

sub syslog_facility {
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'syslog_facility', use => \$self->{'use_syslog_facility'}, enum =>
        [qw(DAEMON LOCAL0 LOCAL1 LOCAL2 LOCAL3 LOCAL4 LOCAL5 LOCAL6 LOCAL7
        daemon local0 local1 local2 local3 local4 local5 local6 local7)]}, @_);
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

sub ipv6_update_dns_on_lease_renewal 
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv6_update_dns_on_lease_renewal', validator => \&ibap_value_o2i_boolean, use => \$self->{'override_ipv6_update_dns_on_lease_renewal'}, use_truefalse => 1}, @_);
}

sub override_ipv6_update_dns_on_lease_renewal 
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_update_dns_on_lease_renewal', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_ddns_enable_option_fqdn 
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv6_ddns_enable_option_fqdn', validator => \&ibap_value_o2i_boolean, use => \$self->{'override_ipv6_ddns_enable_option_fqdn'}, use_truefalse => 1}, @_);
}

sub override_ipv6_ddns_enable_option_fqdn 
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_ddns_enable_option_fqdn', validator => \&ibap_value_o2i_boolean}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 1, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 1, @_);
}

#
sub __bootp_properties_handler__{}
sub __common_properties_handler__{}

sub enable_dhcpv6_service {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_dhcpv6_service', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_enable_ddns {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_enable_ddns', validator => \&ibap_value_o2i_boolean, use => 'override_ipv6_enable_ddns', use_truefalse => 1}, @_);
}

#
sub enable_one_lease_per_client {

    my $self = shift;

    my %lease_mapping = (
        'true'  => 'ONE_LEASE_PER_CLIENT',
        'false' => 'RELEASE_MATCHING_ID',
    );

    my %reverse_lease_mapping = reverse %lease_mapping;

    if (@_) {

        my $val = shift @_;

        if ($lease_mapping{$val} or not defined $val) {
            return $self->lease_per_client_settings($lease_mapping{$val});
        } else {
            ibap_value_o2i_boolean($val, 'enable_one_lease_per_client', undef, 1);
            return undef;
        }
    } else {
        my $val = $self->lease_per_client_settings();
        return $val unless defined $val;

        my $ret = $reverse_lease_mapping{$val};

        if (not defined $ret) {
            set_error_codes('1103', 'enable_one_lease_per_client is deprecated, use lease_per_client_settings instead.');
            return undef;
        }

        return $ret;
    }
}


sub immediate_fa_configuration {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'immediate_fa_configuration', validator => \&ibap_value_o2i_boolean, use => 'override_immediate_fa_configuration', use_truefalse => 1}, @_);
}

sub ipv6_enable_gss_tsig {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_enable_gss_tsig', validator => \&ibap_value_o2i_boolean, use => 'override_ipv6_enable_gss_tsig', use_truefalse => 1}, @_);
}

sub enable_gss_tsig {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_gss_tsig', validator => \&ibap_value_o2i_boolean, use => 'override_enable_gss_tsig', use_truefalse => 1}, @_);
}

sub ipv6_enable_retry_updates {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_enable_retry_updates', validator => \&ibap_value_o2i_boolean, use => 'override_ipv6_enable_retry_updates', use_truefalse => 1}, @_);
}

sub ipv6_ddns_server_always_updates {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_ddns_server_always_updates', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_generate_hostname {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_generate_hostname', validator => \&ibap_value_o2i_boolean, use => 'override_ipv6_generate_hostname', use_truefalse => 1}, @_);
}

sub ipv6_options {
    my $self=shift;
    return $self->__accessor_array__({name => 'ipv6_options', validator => {'Infoblox::DHCP::Option' => 1}, use => 'override_ipv6_options', use_truefalse => 1}, @_);
}

sub ipv6_ddns_domainname {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_ddns_domainname', validator => \&ibap_value_o2i_string, use => 'override_ipv6_ddns_domainname', use_truefalse => 1}, @_);
}

sub ipv6_ddns_hostname {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_ddns_hostname', validator => \&ibap_value_o2i_string, use => 'override_ipv6_ddns_hostname', use_truefalse => 1}, @_);
}

sub ipv6_ddns_ttl {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_ddns_ttl', validator => \&ibap_value_o2i_uint, use => 'override_ipv6_ddns_ttl', use_truefalse => 1}, @_);
}

sub ipv6_gss_tsig_key { 
    my $self=shift;

    my $t = $self->{'ipv6_gss_tsig_keys'};
    if (@_) {
        my $value = shift;

        #
        if (defined $t && ref($t) eq 'ARRAY' && scalar(@{$t}) > 1) {
            return set_error_codes(1104,'Multiple GSS-TSIG keys are in use, please use ipv6_gss_tsig_keys instead.');
        }

        if (defined $value) {
            return $self->ipv6_gss_tsig_keys([$value]);
        }
        else {
            return $self->ipv6_gss_tsig_keys(undef);
        }
    } else {
        if ($t and ref($t) eq 'ARRAY' and scalar(@{$t})) {
            if (scalar(@{$t}) > 1) {
                return set_error_codes(1104,'Multiple GSS-TSIG keys are in use, please use gss_tsig_keys instead.');
            }
            return $t->[0];
        } else {
            return undef;
        }
    }
}

sub ipv6_gss_tsig_keys { 
    my $self=shift;
    return $self->__accessor_array__({name => 'ipv6_gss_tsig_keys', validator => { 'Infoblox::Grid::KerberosKey' => 1 }, use => 'override_ipv6_gss_tsig_keys', use_truefalse => 1}, @_);
}

sub override_ipv6_gss_tsig_keys {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_gss_tsig_keys', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_kdc_server {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_kdc_server', validator => \&ibap_value_o2i_string}, @_);
}

sub ipv6_server_duid {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_server_duid', validator => \&ibap_value_o2i_string}, @_);
}

sub preferred_lifetime {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'preferred_lifetime', validator => \&ibap_value_o2i_uint, use => 'override_preferred_lifetime', use_truefalse => 1}, @_);
}

sub override_ipv6_enable_ddns {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_enable_ddns', validator => \&ibap_value_o2i_boolean}, @_);
}

#
sub override_enable_one_lease_per_client {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_lease_per_client_settings', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_immediate_fa_configuration {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_immediate_fa_configuration', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_ipv6_generate_hostname {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_generate_hostname', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_ipv6_options {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_options', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_ipv6_ddns_domainname {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_ddns_domainname', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_ipv6_ddns_hostname {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_ddns_hostname', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_ipv6_ddns_ttl {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_ddns_ttl', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_preferred_lifetime {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_preferred_lifetime', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_ipv6_enable_gss_tsig {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_enable_gss_tsig', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_enable_gss_tsig {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_enable_gss_tsig', validator => \&ibap_value_o2i_boolean}, @_);
}


sub override_ipv6_enable_retry_updates {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_enable_retry_updates', validator => \&ibap_value_o2i_boolean}, @_);
}

sub valid_lifetime {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'valid_lifetime', validator => \&ibap_value_o2i_int, use => \$self->{'override_valid_lifetime'}, use_truefalse => 1}, @_);
}

sub override_valid_lifetime {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_valid_lifetime', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_domain_name_servers {
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ipv6_domain_name_servers', validator => \&ibap_value_o2i_string, use => \$self->{'override_ipv6_domain_name_servers'}, use_truefalse => 1}, @_);
}

sub override_ipv6_domain_name_servers {
    my $self = shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_domain_name_servers', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_domain_name {
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ipv6_domain_name', validator => \&ibap_value_o2i_string, use => \$self->{'override_ipv6_domain_name'}, use_truefalse => 1}, @_);
}

sub override_ipv6_domain_name {
    my $self = shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_domain_name', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_recycle_leases {
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ipv6_recycle_leases', validator => \&ibap_value_o2i_boolean, use => \$self->{'override_ipv6_recycle_leases'}, use_truefalse => 1}, @_);
}

sub override_ipv6_recycle_leases {
    my $self = shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_recycle_leases', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_microsoft_code_page {
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ipv6_microsoft_code_page', validator => \&ibap_value_o2i_string, use => 'override_ipv6_microsoft_code_page', use_truefalse => 1}, @_);
}

sub override_ipv6_microsoft_code_page {
    my $self = shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_microsoft_code_page', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_retry_updates_interval {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_retry_updates_interval', validator => \&ibap_value_o2i_uint}, @_);
}

#

sub override_hostname_rewrite {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_hostname_rewrite', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_hostname_rewrite {
    my $self=shift;
    my $t = $self->__accessor_scalar__({name => 'enable_hostname_rewrite', validator => \&ibap_value_o2i_boolean, use => \$self->{use_enable_hostname_rewrite_}}, @_);

    if (@_ != 0 ) {
        $self->{'override_hostname_rewrite'} = $self->{'use_enable_hostname_rewrite_'} || $self->{'use_hostname_rewrite_policy_'} ? 'true' : 'false';
    }

    return $t;
}

sub hostname_rewrite_policy {
    my $self=shift;
    my $t = $self->__accessor_scalar__({name => 'hostname_rewrite_policy', validator => \&ibap_value_o2i_string, use => \$self->{'use_hostname_rewrite_policy_'}}, @_);

   if (@_ != 0 ) {
        $self->{'override_hostname_rewrite'} = $self->{'use_enable_hostname_rewrite_'} || $self->{'use_hostname_rewrite_policy_'} ? 'true' : 'false';
    }

    return $t;
}

sub ddns_zone_primaries
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'ddns_zone_primaries', validator => { 'Infoblox::DHCP::DDNS' => 1 }}, @_)
}

1;
