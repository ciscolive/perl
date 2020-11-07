package Infoblox::Grid::DHCP;

use strict;

use Carp;
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_name_mappings %_reverse_name_mappings %_searchable_fields %_ibap_to_object %_object_to_ibap @_return_fields $_return_fields_initialized %_capabilities);
@ISA = qw(Infoblox::IBAPBase);

BEGIN
{   
    $_object_type = 'GridDhcp';
    register_wsdl_type('ib:GridDhcp','Infoblox::Grid::DHCP');

    %_capabilities = (
        depth                => 0,
        implicit_defaults    => 1,
        single_serialization => 1,
    );

    #
    %_allowed_members = (
        authority => 0,
        bootfile => 0,
        bootserver => 0,
        capture_hostname => 0,
        ddns_generate_hostname => 0,
        ddns_retry_interval => 0,
        ddns_server_always_updates => 0,
        ddns_ttl => 0,
        ddns_domainname => 0,
        ddns_update_fixed_addresses => 0,
        ddns_use_option81 => 0,
        deny_bootp => 0,
        email_list => 0,
        enable_ddns => 0,
        enable_dhcp_thresholds => 0,
        enable_email_warnings => 0,
        enable_ifmap_publishing => 1,
        enable_gss_tsig => -1,
        enable_ifmap => 0,
        enable_roaming_hosts => 0,
        enable_snmp_warnings => 0,
        enable_fingerprint => 0,
        grid => 0,
        gss_tsig_key => 0,
        gss_tsig_keys => 0,
        high_water_mark => 0,
        high_water_mark_reset => 0,
        ifmap_delete_option => 1,
        ifmap_ip_mac_lifetime => 0,
        ifmap_port => 0,
        ifmap_protocol => 1,
        ifmap_server_ca_cert => 0,
        ifmap_url => 0,
        ignore_dhcp_option_list_request => 0,
        ignore_client_identifier => 0, # replaced by ignore_id
        ignore_id => 0,
        ignore_mac_addresses => 0,
        ipv6_capture_hostname => 0,
        ipv6_txt_record_handling => 0,
        ipv6_ddns_domainname => 0,
        ipv6_ddns_server_always_updates => 0,
        ipv6_ddns_ttl => 0,
        ipv6_default_prefix => 0,
        ipv6_domain_name => 0,
        ipv6_domain_name_servers =>0,
        ipv6_enable_ddns => 0,
        ipv6_enable_gss_tsig => -1,
        ipv6_enable_retry_updates => 0,
        ipv6_generate_hostname => 0,
        ipv6_gss_tsig_key => 0,
        ipv6_gss_tsig_keys => 0,
        ipv6_kdc_server => 0,
        ipv6_microsoft_code_page => 0,
        ipv6_options => 0,
        ipv6_prefixes => 0,
        ipv6_recycle_leases => 0,
        ipv6_retry_updates_interval=> 0,
        ipv6_update_dns_on_lease_renewal => 0,
        ipv6_ddns_enable_option_fqdn => 0,
        kdc_server => 0,
        lease_logging_member => 0,
        lease_scavenge_time => 0,
        log_lease_events => 0,
        low_water_mark => 0,
        low_water_mark_reset => 0,
        microsoft_code_page => 0,
        nextserver => 0,
        option60_match_rules => 0,
        options => 0,
        ping_count => 0,
        ping_timeout => 0,
        preferred_lifetime => 0,
        pxe_lease_time => 0,
        recycle_leases => 0,
        retry_ddns_updates => 0,
        syslog_facility => 0,
        txt_record_handling => 0,
        update_dns_on_lease_renewal => 0,
        validate_ifmap_ca_cert => 0,
        valid_lifetime => 0,
        disable_all_nac_filters => 0,
        #
        protocol_hostname_rewrite_policies => 0,
        enable_hostname_rewrite => 0,
        hostname_rewrite_policy => -1,
        enable_one_lease_per_client => 0,
        lease_per_client_settings => {simple => 'asis', enum => ['ONE_LEASE_PER_CLIENT', 'RELEASE_MATCHING_ID', 'NEVER_RELEASE']},
        #
        format_log_option_82 => 0,
        immediate_fa_configuration => 0,
        'restart_setting' => {validator => {'Infoblox::Grid::ServiceRestart' => 1}},
        logic_filters              => {array => 1, validator => {string => 1, 'Infoblox::DHCP::Filter::MAC' => 1,
                                       'Infoblox::DHCP::Filter::NAC' => 1, 'Infoblox::DHCP::Filter::Option' => 1}},
        'ipv6_enable_lease_scavenge' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'ipv6_lease_scavenge_time'   => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'dns_update_style'           => {simple => 'asis', enum => ['STANDARD', 'INTERIM']},
        'ipv6_dns_update_style'      => {simple => 'asis', enum => ['STANDARD', 'INTERIM']},
        'ipv6_remember_expired_client_association' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
        authority => 'is_authoritative',
        bootfile => 'boot_file',
        bootserver => 'boot_server',
        ddns_generate_hostname => 'generate_hostname',
        ddns_retry_interval => 'retry_updates_interval',
        ddns_server_always_updates => 'always_update_dns',
        ddns_update_fixed_addresses => 'update_static_leases',
        ddns_use_option81 => 'enable_option81',
        email_list => 'threshold_email_addresses',
        enable_dhcp_thresholds => 'enable_thresholds',
        enable_email_warnings => 'enable_threshold_email_warnings',
        enable_snmp_warnings => 'enable_threshold_snmp_warnings',
        high_water_mark => 'range_high_water_mark',
        high_water_mark_reset => 'range_high_water_mark_reset',
        ignore_dhcp_option_list_request => 'ignore_client_requested_options',
        ipv6_options => 'v6_options',
        ipv6_enable_ddns => 'v6_enable_ddns',
        ipv6_enable_retry_updates => 'v6_enable_retry_updates',
        ipv6_capture_hostname => 'v6_capture_hostname',
        ipv6_txt_record_handling => 'v6_txt_record_handling',
        ipv6_ddns_domainname => 'v6_ddns_domainname',
        ipv6_ddns_server_always_updates => 'v6_always_update_dns',
        ipv6_ddns_ttl => 'v6_ddns_ttl',
        ipv6_domain_name => 'v6_domain_name',
        ipv6_domain_name_servers => 'v6_domain_name_servers',
        ipv6_enable_gss_tsig => 'v6_enable_gss_tsig',
        ipv6_generate_hostname => 'v6_generate_hostname',
        ipv6_gss_tsig_keys => 'v6_gss_tsig_keys',
        ipv6_microsoft_code_page => 'v6_windows_code_page',
        ipv6_kdc_server => 'v6_kdc_server_address',
        ipv6_prefixes => 'v6_prefixes',
        ipv6_recycle_leases => 'v6_recycle_leases',
        ipv6_retry_updates_interval => 'v6_retry_updates_interval',
        ipv6_default_prefix => 'v6_default_prefix',
        ipv6_update_dns_on_lease_renewal => 'v6_update_dns_on_lease_renewal',
        ipv6_ddns_enable_option_fqdn => 'v6_enable_option81',
        kdc_server => 'kdc_server_address',
        lease_logging_member => 'logging_member',
        lease_scavenge_time => 'client_association_grace_period',
        low_water_mark => 'range_low_water_mark',
        low_water_mark_reset => 'range_low_water_mark_reset',
        microsoft_code_page => 'windows_code_page',
        nextserver => 'next_server',
        ping_count => 'ping_number',
        retry_ddns_updates => 'enable_retry_updates',
        logic_filters      => 'option_logic_filters',
        ipv6_lease_scavenge_time => 'v6_leases_scavenging_grace_period',
        ipv6_enable_lease_scavenge => 'v6_leases_scavenging_enabled',
        ipv6_dns_update_style      => 'v6_dns_update_style',
        ipv6_remember_expired_client_association => 'v6_remember_expired_client_association',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
        grid => [\&__o2i_grid__, 'grid', 'REGEX'],
        name => [\&ibap_o2i_ignore, 'deprecated', 'DEPRECATED'],
        cluster => [\&ibap_o2i_ignore, 'deprecated', 'DEPRECATED'],
    );

    %_ibap_to_object = (
        always_update_dns => \&ibap_i2o_boolean,
        capture_hostname => \&ibap_i2o_boolean,
        deny_bootp => \&ibap_i2o_boolean,
        enable_pxe_lease_time => \&ibap_i2o_boolean,
        enable_ddns => \&ibap_i2o_boolean,
        enable_ifmap => \&ibap_i2o_boolean,
        enable_ifmap_publishing => \&ibap_i2o_boolean,
        enable_option81 => \&ibap_i2o_boolean,
        enable_roaming_hosts => \&ibap_i2o_boolean,
        enable_retry_updates => \&ibap_i2o_boolean,
        enable_service => \&ibap_i2o_boolean,
        enable_gss_tsig => \&ibap_i2o_boolean,
        enable_threshold_email_warnings => \&ibap_i2o_boolean,
        enable_thresholds => \&ibap_i2o_boolean,
        enable_threshold_snmp_warnings => \&ibap_i2o_boolean,
        enable_fingerprint => \&ibap_i2o_boolean,
        generate_hostname => \&ibap_i2o_boolean,
        grid => \&__i2o_grid__,
        gss_tsig_keys => \&ibap_i2o_generic_object_list_convert,
        ifmap_delete_option => \&ibap_i2o_enums_lc_or_undef,
        ifmap_server_ca_cert => \&ibap_i2o_generic_object_convert,
        ifmap_protocol => \&ibap_i2o_enums_lc_or_undef,
        ignore_client_requested_options => \&ibap_i2o_boolean,
        ignore_id => \&ibap_i2o_enums_uc_or_undef,
        ignore_mac_addresses => \&ibap_i2o_mac_addresses,
        is_authoritative => \&ibap_i2o_boolean,
        logging_member => \&__i2o_logging_member__,
        log_lease_events => \&ibap_i2o_boolean,
        option60_match_rules => \&ibap_i2o_option60_match_rules,
        options => \&ibap_o2i_ignore,
        ping_timeout => \&ibap_i2o_integer_1000,
        recycle_leases => \&ibap_i2o_boolean,
        syslog_facility => \&ibap_i2o_enums_lc_or_undef,
        threshold_email_addresses => \&ibap_i2o_email_list,
        update_static_leases => \&ibap_i2o_boolean,
        update_dns_on_lease_renewal     => \&ibap_i2o_boolean,
        v6_update_dns_on_lease_renewal     => \&ibap_i2o_boolean,
        v6_enable_option81     => \&ibap_i2o_boolean,
        v6_always_update_dns => \&ibap_i2o_boolean,
        v6_capture_hostname => \&ibap_i2o_boolean,
        v6_domain_name_servers => \&ibap_i2o_domain_name_servers,
        v6_enable_ddns => \&ibap_i2o_boolean,
        v6_enable_gss_tsig => \&ibap_i2o_boolean,
        v6_enable_retry_updates => \&ibap_i2o_boolean,
        v6_generate_hostname => \&ibap_i2o_boolean,
        v6_gss_tsig_keys => \&ibap_i2o_generic_object_list_convert,
        v6_options => \&ibap_i2o_options,
        v6_prefixes => \&__i2o_ipv6_prefixes__,
        v6_recycle_leases => \&ibap_i2o_boolean,
        validate_ifmap_ca_cert => \&ibap_i2o_boolean,
        disable_all_nac_filters => \&ibap_i2o_boolean,
        option_logic_filters    => \&ibap_i2o_ordered_filters,
        #
        protocol_hostname_rewrite_policies => \&ibap_i2o_generic_object_list_convert,
        enable_hostname_rewrite => \&ibap_i2o_boolean,
        hostname_rewrite_policy => \&__i2o_hostname_rewrite_policy__,
        immediate_fa_configuration => \&ibap_i2o_boolean,
        'restart_setting' => \&ibap_i2o_generic_object_convert,

        #
        enable_one_lease_per_client => \&ibap_i2o_ignore,
        
    );

    %_object_to_ibap = (
        authority => \&ibap_o2i_boolean,
        bootfile => \&ibap_o2i_string,
        bootserver => \&ibap_o2i_string,
        capture_hostname => \&ibap_o2i_boolean,
        ddns_generate_hostname => \&ibap_o2i_boolean,
        ddns_retry_interval => \&ibap_o2i_integer,
        ddns_server_always_updates => \&ibap_o2i_boolean,
        ddns_ttl => \&ibap_o2i_integer,
        ddns_domainname => \&ibap_o2i_string,
        ddns_update_fixed_addresses => \&ibap_o2i_boolean,
        ddns_use_option81 => \&ibap_o2i_boolean,
        deny_bootp => \&ibap_o2i_boolean,
        email_list => \&ibap_o2i_email_list,
        enable_ddns => \&ibap_o2i_boolean,
        enable_ifmap => \&ibap_o2i_boolean,
        enable_ifmap_publishing => \&ibap_o2i_boolean,
        enable_dhcp_thresholds => \&ibap_o2i_boolean,
        enable_email_warnings => \&ibap_o2i_boolean,
        enable_gss_tsig => \&ibap_o2i_boolean,
        enable_roaming_hosts => \&ibap_o2i_boolean,
        enable_snmp_warnings => \&ibap_o2i_boolean,
        enable_fingerprint => \&ibap_o2i_boolean,
        grid => \&__o2i_grid__,
        gss_tsig_key => \&ibap_o2i_ignore,
        gss_tsig_keys => \&ibap_o2i_gss_tsig_keys,
        high_water_mark => \&ibap_o2i_uint,
        high_water_mark_reset => \&ibap_o2i_uint,
        ifmap_delete_option => \&ibap_o2i_enums_lc_or_undef,
        ifmap_ip_mac_lifetime => \&ibap_o2i_integer,
        ifmap_url => \&ibap_o2i_string,
        ifmap_port => \&ibap_o2i_integer,
        ifmap_protocol => \&ibap_o2i_enums_lc_or_undef,
        ifmap_server_ca_cert => \&__o2i_cert__,
        ignore_dhcp_option_list_request => \&ibap_o2i_boolean,
        ignore_id => \&ibap_o2i_string,
        ignore_mac_addresses => \&ibap_o2i_mac_addresses,
        ipv6_capture_hostname => \&ibap_o2i_boolean,
        ipv6_txt_record_handling => \&ibap_o2i_string,
        ipv6_ddns_domainname => \&ibap_o2i_string,
        ipv6_ddns_server_always_updates => \&ibap_o2i_boolean,
        ipv6_ddns_ttl => \&ibap_o2i_uint,
        ipv6_default_prefix => \&ibap_o2i_string,
        ipv6_domain_name => \&ibap_o2i_string,
        ipv6_domain_name_servers => \&ibap_o2i_domain_name_servers,
        ipv6_enable_ddns => \&ibap_o2i_boolean,
        ipv6_enable_gss_tsig => \&ibap_o2i_boolean,
        ipv6_enable_retry_updates => \&ibap_o2i_boolean,
        ipv6_generate_hostname => \&ibap_o2i_boolean,
        ipv6_gss_tsig_key => \&ibap_o2i_ignore,
        ipv6_gss_tsig_keys => \&ibap_o2i_ipv6_gss_tsig_keys,
        ipv6_kdc_server => \&ibap_o2i_string_undef_to_empty,
        ipv6_microsoft_code_page => \&ibap_o2i_string,
        ipv6_options => \&ibap_o2i_options,
        ipv6_prefixes => \&__o2i_ipv6_prefixes__,
        ipv6_recycle_leases => \&ibap_o2i_boolean,
        ipv6_retry_updates_interval => \&ibap_o2i_uint,
        ipv6_update_dns_on_lease_renewal => \&ibap_o2i_boolean,
        ipv6_ddns_enable_option_fqdn => \&ibap_o2i_boolean,
        kdc_server => \&ibap_o2i_string_undef_to_empty,
        lease_logging_member => \&__o2i_lease_logging_member__,
        lease_scavenge_time   => \&ibap_o2i_integer,
        log_lease_events => \&ibap_o2i_boolean,
        low_water_mark => \&ibap_o2i_uint,
        low_water_mark_reset => \&ibap_o2i_uint,
        microsoft_code_page => \&ibap_o2i_string,
        nextserver => \&ibap_o2i_string,
        option60_match_rules => \&ibap_o2i_option60_match_rules,
        options => \&ibap_o2i_ignore,
        ping_count => \&ibap_o2i_integer,
        ping_timeout => \&ibap_o2i_integer_1000,
        preferred_lifetime => \&ibap_o2i_uint,
        pxe_lease_time => \&ibap_o2i_integer,
        enable_pxe_lease_time => \&ibap_o2i_boolean,
        recycle_leases => \&ibap_o2i_boolean,
        retry_ddns_updates => \&ibap_o2i_boolean,
        syslog_facility => \&ibap_o2i_enums_lc_or_undef,
        txt_record_handling => \&ibap_o2i_string,
        update_dns_on_lease_renewal => \&ibap_o2i_boolean,
        use_broadcast_address => \&ibap_o2i_ignore,
        use_domain_name => \&ibap_o2i_ignore,
        use_domain_name_servers => \&ibap_o2i_ignore,
        use_lease_time => \&ibap_o2i_ignore,
        use_routers => \&ibap_o2i_ignore,
        use_options => \&ibap_o2i_ignore,
        use_threshold_email_addresses => \&ibap_o2i_boolean,
        validate_ifmap_ca_cert => \&ibap_o2i_boolean,
        valid_lifetime => \&ibap_o2i_integer,
        disable_all_nac_filters => \&ibap_o2i_boolean,
        logic_filters           => \&ibap_o2i_ordered_filters,
        #
        protocol_hostname_rewrite_policies => \&__o2i_hostname_rewrite_policies__,
        enable_hostname_rewrite => \&ibap_o2i_boolean,
        hostname_rewrite_policy => \&ibap_o2i_ignore,
        #
        format_log_option_82 => \&ibap_o2i_enums_lc_or_undef,
        immediate_fa_configuration =>\&ibap_o2i_boolean,
        restart_setting => \&ibap_o2i_generic_struct_convert,
        ipv6_enable_lease_scavenge => \&ibap_o2i_boolean,
        ipv6_lease_scavenge_time => \&ibap_o2i_uint,
        dns_update_style => \&ibap_o2i_string,
        ipv6_dns_update_style => \&ibap_o2i_string,
        ipv6_remember_expired_client_association => \&ibap_o2i_boolean,

        #
        enable_one_lease_per_client => \&ibap_o2i_ignore,
        lease_per_client_settings => \&ibap_o2i_string,
    );

	$_return_fields_initialized=0;
    @_return_fields = (
        tField('always_update_dns'),
        tField('boot_file'),
        tField('boot_server'),
        tField('broadcast_address'),
        tField('broadcast_address'),
        tField('capture_hostname'),
        tField('client_association_grace_period'),
        tField('ddns_ttl'),
        tField('ddns_domainname'),
        tField('deny_bootp'),
        tField('domain_name'),
        tField('domain_name_servers', { sub_fields => [ tField('address')]}),
        tField('enable_ddns'),
        tField('enable_ifmap'),
        tField('enable_ifmap_publishing'),
        tField('enable_gss_tsig'),
        tField('enable_option81'),
        tField('enable_retry_updates'),
        tField('enable_roaming_hosts'),
        tField('enable_threshold_email_warnings'),
        tField('enable_thresholds'),
        tField('enable_threshold_snmp_warnings'),
        tField('enable_fingerprint'),
        tField('generate_hostname'),
        tField('grid', { sub_fields => [ tField('name')]}),
        tField('ifmap_delete_option'),
        tField('ifmap_ip_mac_lifetime'),
        tField('ifmap_url'),
        tField('ifmap_port'),
        tField('ifmap_protocol'),
        tField('ifmap_server_ca_cert'),
        tField('ignore_client_requested_options'),
        tField('ignore_id'),
        tField('ignore_mac_addresses', { sub_fields => [ tField('mac_addr')]}),
        tField('is_authoritative'),
        tField('kdc_server_address'),
        tField('lease_time'),
        tField('logging_member', return_fields_member_basic_data()),
        tField('log_lease_events'),
        tField('next_server'),
        tField('option60_match_rules', {depth => 2}),
        tField('options', {depth => 2}),
        tField('ping_number'),
        tField('ping_timeout'),
        tField('preferred_lifetime'),
        tField('valid_lifetime'),
        tField('enable_pxe_lease_time'),
        tField('pxe_lease_time'),
        tField('range_high_water_mark'),
        tField('range_low_water_mark'),
        tField('range_high_water_mark_reset'),
        tField('range_low_water_mark_reset'),
        tField('recycle_leases'),
        tField('retry_updates_interval'),
        tField('routers'),
        tField('syslog_facility'),
        tField('txt_record_handling'),
        tField('threshold_email_addresses'),
        tField('update_static_leases'),
        tField('use_threshold_email_addresses'),
        tField('update_dns_on_lease_renewal'),
        tField('v6_always_update_dns'),
        tField('v6_capture_hostname'),
        tField('v6_txt_record_handling'),
        tField('v6_ddns_domainname'),
        tField('v6_domain_name'),
        tField('v6_domain_name_servers', { sub_fields => [ tField('address')]}),
        tField('v6_ddns_ttl'),
        tField('v6_default_prefix'),
        tField('v6_enable_ddns'),
        tField('v6_enable_gss_tsig'),
        tField('v6_enable_retry_updates'),
        tField('v6_generate_hostname'),
        tField('v6_kdc_server_address'),
        tField('v6_options', { depth => 1}),
        tField('v6_prefixes'),
        tField('v6_recycle_leases'),
        tField('v6_retry_updates_interval'),
        tField('v6_update_dns_on_lease_renewal'),
        tField('v6_enable_option81'),
        tField('v6_windows_code_page'),
        tField('v6_leases_scavenging_enabled'),
        tField('v6_leases_scavenging_grace_period'),
        tField('v6_remember_expired_client_association'),
        tField('validate_ifmap_ca_cert'),
        tField('windows_code_page'),
        tField('disable_all_nac_filters'),
        tField('option_logic_filters', return_fields_option_logic_filters()),
        #
      #
        tField('enable_hostname_rewrite'),
        tField('hostname_rewrite_policy', { sub_fields => [ tField('policy_name')]}),
        #
        tField('format_log_option_82'),
        #
        tField('immediate_fa_configuration'),
        tField('dns_update_style'),
        tField('v6_dns_update_style'),
        tField('lease_per_client_settings'),
    );
}

sub __new__
{
    my ( $proto, %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self, $class;

    $self->__init_instance_constants__();

    return $self;
}

sub __init_instance_constants__
{
    my $self = shift;

	unless ($_return_fields_initialized) {
		$_return_fields_initialized=1;

        #
        my $t=Infoblox::Grid::KerberosKey->__new__();
        push @_return_fields,
          tField('gss_tsig_keys', {
                                sub_fields => $t->__return_fields__(),
                               }
                );
        push @_return_fields,
          tField('v6_gss_tsig_keys', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        my $c=Infoblox::IFMap::CACertificate->__new__();
        push @_return_fields,
          tField('ifmap_server_ca_cert', {
                                    sub_fields => $c->__return_fields__(),
                                   }
                );

        #
        $t = Infoblox::Grid::HostNameRewritePolicy->__new__();
        push @_return_fields,
          tField('protocol_hostname_rewrite_policies', {
                                    sub_fields => $t->__return_fields__(),
                                   }
                );

        $t=Infoblox::Grid::ServiceRestart->__new__();
        push @_return_fields, tField('restart_setting', { sub_fields => $t->__return_fields__() });
    }

    $self->{'ifmap_delete_option'} = 'always' unless defined $self->ifmap_delete_option();
    $self->{'enable_ifmap_publishing'} = 'false' unless defined $self->enable_ifmap_publishing();
    $self->{'ifmap_protocol'} = 'ifmap_20' unless defined $self->ifmap_protocol();
    #
    $self->{'enable_hostname_rewrite'} = 'false' unless defined $self->enable_hostname_rewrite();
    #
    $self->{'format_log_option_82'} = 'HEX' unless defined $self->format_log_option_82();
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

sub __i2o_grid__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    return $ibap_object_ref->{$current}{'name'};
}

sub __i2o_logging_member__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    #
    return ibap_value_i2o_dhcpmember($ibap_object_ref->{$current})
}

sub __i2o_ipv6_prefixes__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
        #
        #
        return join ',', map { $_->{'v6_prefix'} } @{$ibap_object_ref->{$current}};
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
    
    $$ibap_object_ref{'enable_ifmap_publishing'}      = 0 unless defined $$ibap_object_ref{'enable_ifmap_publishing'};
    $$ibap_object_ref{'enable_ifmap'} = 0 unless defined $$ibap_object_ref{'enable_ifmap'};
    $$ibap_object_ref{'update_dns_on_lease_renewal'}  = 0 unless defined $$ibap_object_ref{'update_dns_on_lease_renewal'};
    $$ibap_object_ref{'capture_hostname'}  = 0 unless defined $$ibap_object_ref{'capture_hostname'};
    $$ibap_object_ref{'v6_capture_hostname'}  = 0 unless defined $$ibap_object_ref{'v6_capture_hostname'};
    $$ibap_object_ref{'v6_enable_retry_updates'} =0 unless defined $$ibap_object_ref{'v6_enable_retry_updates'};
    $$ibap_object_ref{'v6_update_dns_on_lease_renewal'}  = 0 unless defined $$ibap_object_ref{'v6_update_dns_on_lease_renewal'};
    $$ibap_object_ref{'v6_enable_option81'}  = 0 unless defined $$ibap_object_ref{'v6_enable_option81'};
    $$ibap_object_ref{'validate_ifmap_ca_cert'}  = 0 unless defined $$ibap_object_ref{'validate_ifmap_ca_cert'};
    $$ibap_object_ref{'disable_all_nac_filters'}  = 0 unless defined $$ibap_object_ref{'disable_all_nac_filters'};
    $$ibap_object_ref{'enable_fingerprint'} = 0 unless defined $$ibap_object_ref{'enable_fingerprint'};
    $$ibap_object_ref{'immediate_fa_configuration'} = 0 unless defined $$ibap_object_ref{'immediate_fa_configuration'};
    #
    $$ibap_object_ref{'enable_hostname_rewrite'} = 0 unless defined $$ibap_object_ref{'enable_hostname_rewrite'};
    $$ibap_object_ref{'v6_leases_scavenging_enabled'} = 0 unless defined $$ibap_object_ref{'v6_leases_scavenging_enabled'};
    $$ibap_object_ref{'v6_remember_expired_client_association'} = 0 unless defined $$ibap_object_ref{'v6_remember_expired_client_association'};

    $self->{'authority'} = 'false';
    $self->{'ddns_generate_hostname'} = 'false';
    $self->{'ddns_server_always_updates'} = 'false';
    $self->{'ddns_update_fixed_addresses'} = 'false';
    $self->{'ddns_use_option81'} = 'false';
    $self->{'deny_bootp'} = 'false';
    $self->{'enable_ddns'} = 'false';
    $self->{'enable_ifmap'} = 'false';
    $self->{'enable_dhcp_thresholds'} = 'false';
    $self->{'enable_gss_tsig'} = 'false';
    $self->{'enable_email_warnings'} = 'false';
    $self->{'enable_roaming_hosts'} = 'false';
    $self->{'enable_snmp_warnings'} = 'false';
    $self->{'ignore_dhcp_option_list_request'} = 'false';
    $self->{'ipv6_enable_ddns'} = 'false';
    $self->{'ipv6_enable_gss_tsig'} = 'false';
    $self->{'ipv6_enable_retry_updates'} = 'false';
    $self->{'ipv6_ddns_server_always_updates'} = 'false';
    $self->{'ipv6_generate_hostname'} = 'false';
    $self->{'log_lease_events'} = 'false';
    $self->{'options'} = [];
    $self->{'option60_match_rules'} = [];
    $self->{'recycle_leases'} = 'false';
    $self->{'retry_ddns_updates'} = 'false';
    $self->{'syslog_facility'} = 'DAEMON';
    $self->{'ipv6_recycle_leases'} = 'false';

    #
    for my $flag ('use_threshold_email_addresses') {
        $ibap_object_ref->{$flag} = 0
            unless defined ($ibap_object_ref->{$flag});
    }
    
    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    ibap_i2o_common_dhcp_props_no_use_flags($self, $session, 'tmphash', { tmphash => $ibap_object_ref });
    #
    for my $flag ('use_threshold_email_addresses') {
        $self->{$flag} = $ibap_object_ref->{$flag};
    }
    #

    #
    $self->{'enable_pxe_lease_time'}=ibap_value_i2o_boolean($$ibap_object_ref{'enable_pxe_lease_time'});
    $self->{'enable_ifmap'}=ibap_value_i2o_boolean($$ibap_object_ref{'enable_ifmap'});

    $self->{'email_list'} = []
        unless $self->{'use_threshold_email_addresses'} and defined $self->{'email_list'};;

    return $res;
}

sub __o2i_ipv6_prefixes__
{
	my ($self, $session, $current, $tempref) = @_;

    my @list;
    if ($$tempref{$current}) {
        my @t = split /,/,$$tempref{$current};
        my $i = 1;
        foreach (@t) {
            my %sub_write_args;
            return (0) unless $sub_write_args{'name'} = ibap_value_o2i_string_undef_to_empty("Prefix_$i", 'name', $session);
            return (0) unless $sub_write_args{'v6_prefix'} = ibap_value_o2i_string($_, 'v6_prefix', $session);
            $i++;
            push @list, \%sub_write_args;
        }
    }
    return (1,0,tIBType('ArrayOfipv6_global_prefix', \@list));
}

sub __o2i_cert__
{
    my ($self, $session, $current, $tempref) = @_;

    if (not defined $$tempref{$current}) {
        return (1,0, undef);
    } else {
        return (1,0, ibap_readfield_simple_string('IfmapCACertificate','certificate',$$tempref{$current}->certificate(), $current));
    }    
}

sub __o2i_grid__
{
	my ($self, $session, $current, $tempref, $type) = @_;
    return (1,0,ibap_readfield_simple_string('Grid', 'name',
        $tempref->{$current}, 'grid', (defined($type) && ($type eq 'search')) ? 'REGEX' : 'EXACT'));
}

sub __o2i_lease_logging_member__
{
	my ($self, $session, $current, $tempref, $type) = @_;
    if($self->{$current} && $self->{$current}->name()) {
        return (1, 0, ibap_readfield_simple_string('Member', 'host_name', $self->{$current}->name(),'lease_logging_member'));
    } else {
        return (1, 0, undef);
    }
}

sub __o2i_hostname_rewrite_policies__
{
    my ($self, $session, $current, $tempref, $type) = @_;
    my $ibap = ibap_serialize_subobject_list($session,$$tempref{$current},'HostNameRewritePolicy');
    return $ibap ? (1,0, $ibap) : (1,0, undef);
}

sub __object_to_ibap__
{
    my ($self, $server, $session, @rest) = @_;

    if (defined($self->{'gss_tsig_keys'}) and defined($self->{'kdc_server'})) {
        $self->{'enable_gss_tsig'} = 'true';
    } else {
        $self->{'enable_gss_tsig'} = 'false';
    }
    if (defined($self->{'ipv6_gss_tsig_keys'}) and defined($self->{'ipv6_kdc_server'})) {
        $self->{'ipv6_enable_gss_tsig'} = 'true';
    } else {
        $self->{'ipv6_enable_gss_tsig'} = 'false';
    }
    my $write_fields_ref = $self->SUPER::__object_to_ibap__($server, $session, @rest);
    my ($success, $ignore_value, @common_options) = ibap_o2i_common_dhcp_props($self, $session, '', $self);
    if ($success) {
        my $sub_write_args_ref = $common_options[0]->value();
        while(my ($key, $value) = each(%{$sub_write_args_ref})) {
            next if $key =~ /^use_/; #no use_ flags for common options in this object
            next if $key =~ /pxe_lease_time/; #pxe_lease_time and enable_pxe_lease_time are already dealt with via the o2i in the hash, don't send 2 copies of them
            unshift @{$write_fields_ref}, {
                field => $key,
                value => $value
            };
        }
    }
    return $write_fields_ref;
}

sub __search_override_hook__ {
    my ($object_type, $session, $args_ref) = @_;
    set_error_codes(1008, "'search' not allowed for this object", $session);
    return;
}

sub authority { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'authority', validator => \&ibap_value_o2i_boolean}, @_);
}

sub bootfile { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'bootfile', validator => \&ibap_value_o2i_string}, @_);
}

sub bootserver { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'bootserver', validator => \&ibap_value_o2i_string}, @_);
}

sub capture_hostname
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'capture_hostname', validator => \&ibap_value_o2i_boolean }, @_);
}

sub ddns_generate_hostname { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ddns_generate_hostname', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_ifmap { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'enable_ifmap', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_ifmap_publishing { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'enable_ifmap_publishing', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ifmap_delete_option { 
    my $self=shift;
    if( @_ != 0 && $_[0] && ($_[0] eq 'always' || $_[0] eq 'never') )
    {
        $self->{ 'ifmap_ip_mac_lifetime' } = undef;
    }

    return $self->__accessor_scalar__({name => 'ifmap_delete_option', enum => [ 'always', 'never', 'older_than' ]}, @_);
}

sub ifmap_ip_mac_lifetime { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ifmap_ip_mac_lifetime', validator => \&ibap_value_o2i_int}, @_);
}

sub ifmap_url { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ifmap_url', validator => \&ibap_value_o2i_string, use => \$self->{'enable_ifmap'}, use_truefalse => 1}, @_);
}

sub ifmap_port { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ifmap_port', validator => \&ibap_value_o2i_int}, @_);
}

sub ifmap_protocol {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ifmap_protocol', enum => [ 'ifmap_11', 'ifmap_20' ]}, @_);
}

sub ifmap_server_ca_cert { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ifmap_server_ca_cert', validator => { 'Infoblox::IFMap::CACertificate' => 1}}, @_);
}

sub ddns_retry_interval { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ddns_retry_interval', validator => \&ibap_value_o2i_int}, @_);
}

sub ddns_server_always_updates { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ddns_server_always_updates', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ddns_ttl { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ddns_ttl', validator => \&ibap_value_o2i_int}, @_);
}

sub ddns_domainname { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ddns_domainname', validator => \&ibap_value_o2i_string}, @_);
}

sub ddns_update_fixed_addresses { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ddns_update_fixed_addresses', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ddns_use_option81 { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ddns_use_option81', validator => \&ibap_value_o2i_boolean}, @_);
}

sub deny_bootp { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'deny_bootp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_domain_name { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ipv6_domain_name', validator => \&ibap_value_o2i_string}, @_);
}

sub ipv6_domain_name_servers {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_domain_name_servers', validator => \&ibap_value_o2i_string}, @_);
}

sub ipv6_microsoft_code_page { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ipv6_microsoft_code_page', validator => \&ibap_value_o2i_string}, @_);
}

sub email_list { 
    my $self=shift; 
    return $self->__accessor_array__({name => 'email_list', validator => { 'string' => \&ibap_value_o2i_string }, use => \$self->{'use_threshold_email_addresses'}}, @_);
}

sub enable_ddns { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'enable_ddns', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_dhcp_thresholds { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'enable_dhcp_thresholds', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_email_warnings { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'enable_email_warnings', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_gss_tsig { 
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_gss_tsig', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_roaming_hosts { 
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_roaming_hosts', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_snmp_warnings { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'enable_snmp_warnings', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_fingerprint {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_fingerprint', validator => \&ibap_value_o2i_boolean}, @_);
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
    return $self->__accessor_array__({name => 'gss_tsig_keys', validator => {'Infoblox::Grid::KerberosKey' => 1 }}, @_);
}

sub high_water_mark { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'high_water_mark', validator => \&ibap_value_o2i_uint}, @_);
}

sub high_water_mark_reset { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'high_water_mark_reset', validator => \&ibap_value_o2i_uint}, @_);
}

sub ignore_dhcp_option_list_request { 
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ignore_dhcp_option_list_request', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ignore_client_identifier {
    my $self  = shift;
    if(@_ == 0) {
        return (defined $self->ignore_id() && $self->ignore_id() eq 'CLIENT') ? 'true' : 'false';
    } else {
        my $value = shift;
        if (($value =~ m/^false$/i) || ($value eq '0')) {
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

sub ignore_id
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ignore_id', enum => ['NONE', 'CLIENT', 'MACADDR'] }, @_);
}

sub ignore_mac_addresses
{
    my $self = shift;
    return $self->__accessor_array__({name => 'ignore_mac_addresses', validator => \&ibap_value_o2i_string}, @_);
}

sub kdc_server { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'kdc_server', validator => \&ibap_value_o2i_string}, @_);
}

sub lease_logging_member { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'lease_logging_member', validator => { 'Infoblox::DHCP::Member' => 1 }}, @_);
}

sub lease_scavenge_time
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'lease_scavenge_time',  validator => \&ibap_value_o2i_int},@_);
}

sub log_lease_events { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'log_lease_events', validator => \&ibap_value_o2i_boolean}, @_);
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
    return $self->__accessor_scalar__({name => 'microsoft_code_page', validator => \&ibap_value_o2i_string}, @_);
}

sub grid { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'grid', validator => \&ibap_value_o2i_string}, @_);
}

sub nextserver { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'nextserver', validator => \&ibap_value_o2i_string}, @_);
}

sub option60_match_rules { 
    my $self=shift; 
    return $self->__accessor_array__({name => 'option60_match_rules', validator => { 'Infoblox::DHCP::Option60MatchRule' => 1 }}, @_);
}

sub options { 
    my $self=shift; 
    return ibap_accessor_dhcp_options($self, 'options', @_);
}

sub ping_count { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ping_count', validator => \&ibap_value_o2i_int}, @_);
}

sub ping_timeout { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ping_timeout', validator => \&ibap_value_o2i_int_1000}, @_);
}

sub pxe_lease_time { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'pxe_lease_time', validator => \&ibap_value_o2i_int, use => \$self->{'enable_pxe_lease_time'}, use_truefalse => 1}, @_);
}

sub recycle_leases { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'recycle_leases', validator => \&ibap_value_o2i_boolean}, @_);
}

sub retry_ddns_updates { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'retry_ddns_updates', validator => \&ibap_value_o2i_boolean}, @_);
}

sub syslog_facility {
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'syslog_facility', enum =>
        [qw(DAEMON LOCAL0 LOCAL1 LOCAL2 LOCAL3 LOCAL4 LOCAL5 LOCAL6 LOCAL7
        daemon local0 local1 local2 local3 local4 local5 local6 local7)]}, @_); 
}

sub update_dns_on_lease_renewal 
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'update_dns_on_lease_renewal', validator => \&ibap_value_o2i_boolean }, @_);
}

sub ipv6_update_dns_on_lease_renewal 
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv6_update_dns_on_lease_renewal', validator => \&ibap_value_o2i_boolean }, @_);
}

sub ipv6_ddns_enable_option_fqdn 
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv6_ddns_enable_option_fqdn', validator => \&ibap_value_o2i_boolean }, @_);
}

sub ipv6_enable_ddns {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_enable_ddns', validator => \&ibap_value_o2i_boolean}, @_);
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


sub ipv6_ddns_server_always_updates {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_ddns_server_always_updates', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_enable_gss_tsig {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_enable_gss_tsig', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_enable_retry_updates {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_enable_retry_updates', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_generate_hostname {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_generate_hostname', validator => \&ibap_value_o2i_boolean}, @_);
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
    return $self->__accessor_array__({name => 'ipv6_gss_tsig_keys', validator => { 'Infoblox::Grid::KerberosKey' => 1 }}, @_);
}

sub ipv6_kdc_server {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_kdc_server', validator => \&ibap_value_o2i_string}, @_);
}

sub ipv6_options {
    my $self=shift;
    return $self->__accessor_array__({name => 'ipv6_options', validator => {'Infoblox::DHCP::Option' => 1}}, @_);
}

sub ipv6_prefixes {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_prefixes', validator => \&ibap_value_o2i_string}, @_);
}

sub ipv6_recycle_leases { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'ipv6_recycle_leases', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_retry_updates_interval {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_retry_updates_interval', validator => \&ibap_value_o2i_uint}, @_);
}

sub ipv6_default_prefix {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_default_prefix', validator => \&ibap_value_o2i_string}, @_);
}

sub ipv6_ddns_domainname {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_ddns_domainname', validator => \&ibap_value_o2i_string}, @_);
}

sub ipv6_txt_record_handling {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_txt_record_handling', enum => [ 'IGNORE_CONTENTS', 'ISC', 'ISC_TRANSITIONAL', 'MS' ]}, @_);
}

sub ipv6_capture_hostname {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_capture_hostname', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_ddns_ttl {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_ddns_ttl', validator => \&ibap_value_o2i_uint}, @_);
}

sub preferred_lifetime {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'preferred_lifetime', validator => \&ibap_value_o2i_uint}, @_);
}

sub txt_record_handling {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'txt_record_handling', enum => [ 'IGNORE_CONTENTS', 'ISC', 'ISC_TRANSITIONAL', 'MS' ]}, @_);
}

sub validate_ifmap_ca_cert {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'validate_ifmap_ca_cert', validator => \&ibap_value_o2i_boolean}, @_);
}

sub valid_lifetime {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'valid_lifetime', validator => \&ibap_value_o2i_uint}, @_);
}

sub disable_all_nac_filters {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable_all_nac_filters', validator => \&ibap_value_o2i_boolean}, @_);
}

#

sub protocol_hostname_rewrite_policies {
    my $self=shift;
    return $self->__accessor_array__({name => 'protocol_hostname_rewrite_policies', validator => {'Infoblox::Grid::HostNameRewritePolicy' => 1}}, @_);
}

sub enable_hostname_rewrite {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_hostname_rewrite', validator => \&ibap_value_o2i_boolean}, @_);
}

sub hostname_rewrite_policy {
   my $self=shift;
   return $self->__accessor_scalar__({name => 'hostname_rewrite_policy', validator => \&ibap_value_o2i_string}, @_);
}

#

sub format_log_option_82 { 
    my $self=shift;
    return $self->__accessor_scalar__({name => 'format_log_option_82', enum => [ 'HEX', 'TEXT' ]}, @_);
}

sub immediate_fa_configuration {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'immediate_fa_configuration', validator => \&ibap_value_o2i_boolean}, @_);
}

1;
