package Infoblox::Grid;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields $_return_fields_initialized %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE);

BEGIN {
    $_object_type = 'Grid';
    register_wsdl_type('ib:Grid','Infoblox::Grid');

    #
    #
    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                      'single_serialization' => 0,
                     );

    %_allowed_members =
      (
       admin_access_items      => 0,
       admin_access_remote_console => 0,
       enable_security_access  => 0,
       alternate_resolver      => 0,
       audit_log_format        => 0,
       informational_banner_setting => {validator => {'Infoblox::Grid::InformationalBannerSetting' => 1}, skip_accessor => 1},
       consent_banner_setting  => {validator => {'Infoblox::Grid::ConsentBannerSetting' => 1}, skip_accessor => 1},
       copy_audit_to_syslog    => 0,
       dscp                    => 0,
       enable_dns_perm_for_nw_range => 0,
       enable_member_redirect  => 0,
       enable_ntp              => 0,
       enable_recycle_bin      => 0,
       enable_scheduling       => -1,
       enable_snmpv3_query     => 0,
       enable_snmpv3_traps     => 0,
       engine_id               => -1,
       mgm_strict_delegate_mode => 0,
       lcd_input               => 0,
       enable_login_banner     => 0,
       login_banner_text       => 0,
       name                    => 1,
       nat_group_list          => {validator => {'Infoblox::Grid::NatGroup' => 1}, array => 1, skip_accessor => 1},
       notification_email_addr => 0,
       lom_users               => {validator => {'Infoblox::Grid::LOM::User' => 1}, array => 1, skip_accessor => 1},
       enable_lom              => 0,
       ntp_access_list         => 0,
       ntp_service_type        => 0,
       enable_rir_swip         => 0,
       ms_default_ip_site_link   => 0,
       ms_ldap_timeout           => 0,
       ms_log_destination        => 0,
       ms_max_connection         => 0,
       ms_rpc_timeout            => 0,
       ms_enable_invalid_mac     => 0,
       ms_enable_dhcp_monitoring => 0,
       ms_enable_dns_reports_sync => 0,
       ms_enable_dns_monitoring  => 0,
       ms_user_default_timeout   => 0,
       ms_enable_user_sync       => 0,
       ms_enable_network_users   => 0,
       ntp_authentication_key  => 0,
       ntp_server              => 0,
       ntp_kod                 => 0,
       password_min_length     => 0,
       password_num_lower_char => 0,
       password_num_upper_char => 0,
       password_num_numeric_char => 0,
       password_num_symbol_char => 0,
       password_chars_to_change => 0,
       password_expire_days    => 0,
       password_expire_enable  => 0,
       password_force_reset    => 0,
       password_reminder_days  => 0,
       prefer_resolver         => 0,
       query_comm_string       => 0,
       remote_console_access   => 0,
       scheduled_backup        => {validator => {'Infoblox::Grid::ScheduledBackup' => 1}, skip_accessor => 1},
       search_domains          => 0,
       secret                  => 0,
       session_timeout         => 0,
       snmp_admin              => 0,
       snmpv3_query_users      => 0,
       support_access          => 0,
       support_access_info     => -1,
       syslog_server                 => {validator => {'Infoblox::Grid::SyslogServer' => 1}, array => 1, use => 'external_syslog_server_enable',
                                         use_truefalse => 1},
       external_syslog_server_enable => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       syslog_size             => 0,
       trap_comm_string        => 0,
       trap_receiver           => 0,
       threshold_traps         => {validator => {'Infoblox::Grid::SNMP::ThresholdTrap' => 1}, array => 1, skip_accessor => 1},
       trap_notifications      => {validator => {'Infoblox::Grid::SNMP::TrapNotification' => 1}, array => 1, skip_accessor => 1},
       vpn_port                => 1,
       allow_recursive_deletion => 0,
       descendants_action      => {validator => {'Infoblox::Grid::ExtensibleAttributeDef::Descendants' => 1}, skip_accessor => 1},
       is_grid_visualization_visible => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       enable_gui_api_for_lan_vip => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       http_proxy_server_setting  => {validator => {'Infoblox::Grid::HTTPProxyServerSetting' => 1}},
       updates_download_member_config => {validator => {'Infoblox::Grid::UpdatesDownloadMemberConfig' => 1}, array => 1},
       restart_banner_setting  => {validator => {'Infoblox::Grid::RestartBannerSetting' => 1}},
       restart_status          => {validator => {'Infoblox::Grid::ServiceRestart::Status' => 1}, readonly => 1},
       token_usage_delay        => {simple => 'asis', validator => \&ibap_value_o2i_uint},
       rpz_hit_rate_interval  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
       rpz_hit_rate_min_query => {simple => 'asis', validator => \&ibap_value_o2i_uint},
       rpz_hit_rate_max_query => {simple => 'asis', validator => \&ibap_value_o2i_uint},
       objects_changes_tracking_setting => {validator => {'Infoblox::Grid::ObjectsChangesTrackingSetting' => 1}},
       deny_mgm_snapshots    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       service_status        => {simple => 'asis', readonly => 1, enum => ['FAILED', 'INACTIVE', 'OFFLINE', 'UNKNOWN', 'WARNING', 'WORKING']},
       syslog_backup_servers => {array => 1, validator => {'Infoblox::Grid::SyslogBackupServer' => 1}},
      );

      Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           name => [\&ibap_o2i_string,'name' , 'REGEX'],
                          );

    %_return_field_overrides =
      (
       admin_access_items      => ['!security_setting'],
       admin_access_remote_console      => ['!security_setting'],
       enable_security_access  => ['!security_setting'],
       alternate_resolver      => ['!dns_resolver_setting'],
       audit_log_format        => [],
       informational_banner_setting  => [],
       consent_banner_setting  => [],
       copy_audit_to_syslog    => [],
       dscp                    => [],
       enable_dns_perm_for_nw_range => [],
       enable_member_redirect  => [],
       enable_ntp              => ['!ntp_setting'],
       enable_recycle_bin      => [],
       enable_snmpv3_query     => ['!snmp_setting'],
       enable_snmpv3_traps     => ['!snmp_setting'],
       engine_id               => ['!snmp_setting'],
       lcd_input               => ['!security_setting'],
       enable_login_banner     => ['!security_setting'],
       login_banner_text       => ['!security_setting'],
       mgm_strict_delegate_mode => [],
       name                    => [],
       nat_group_list          => [],
       notification_email_addr => ['!email_setting'],
       lom_users               => [],
       enable_lom              => [],
       ntp_access_list         => ['!ntp_setting'],
       ntp_service_type        => ['!ntp_setting'],
       enable_rir_swip         => [],
       ms_default_ip_site_link   => ['!ms_settings'],
       ms_ldap_timeout           => ['!ms_settings'],
       ms_log_destination        => ['!ms_settings'],
       ms_max_connection         => ['!ms_settings'],
       ms_rpc_timeout            => ['!ms_settings'],
       ms_enable_invalid_mac     => ['!ms_settings'],
       ms_enable_dhcp_monitoring => ['!ms_settings'],
       ms_enable_dns_reports_sync => ['!ms_settings'],
       ms_enable_dns_monitoring  => ['!ms_settings'],
       ms_enable_network_users   => ['!ms_settings'],
       ms_enable_user_sync       => ['!ms_settings'],
       ms_user_default_timeout   => ['!ms_settings'],
       ntp_authentication_key  => ['!ntp_setting'],
       ntp_server              => ['!ntp_setting'],
       ntp_kod                 => ['!ntp_setting'],
       password_min_length     => ['!password_setting'],
       password_num_lower_char => ['!password_setting'],
       password_num_upper_char => ['!password_setting'],
       password_num_numeric_char => ['!password_setting'],
       password_num_symbol_char  => ['!password_setting'],
       password_chars_to_change  => ['!password_setting'],
       password_expire_days    => ['!password_setting'],
       password_expire_enable  => ['!password_setting'],
       password_force_reset    => ['!password_setting'],
       password_reminder_days  => ['!password_setting'],
       prefer_resolver         => ['!dns_resolver_setting'],
       query_comm_string       => ['!snmp_setting'],
       remote_console_access   => ['!security_setting'],
       scheduled_backup        => [],
       search_domains          => ['!dns_resolver_setting'],
       secret                  => [],
       session_timeout         => ['!security_setting'],
       snmpv3_query_users      => ['!snmp_setting'],
       snmp_admin              => ['!snmp_setting'],
       support_access          => ['!security_setting'],
       support_access_info     => ['!security_setting'],
       syslog_server           => ['external_syslog_server_enabled'],
       external_syslog_server_enable => [],
       syslog_size             => [],
       threshold_traps         => [],
       trap_notifications      => [],
       trap_comm_string        => ['!snmp_setting'],
       trap_receiver           => ['!snmp_setting'],
       vpn_port                => [],
       allow_recursive_deletion => [],
       descendants_action      => [],
       is_grid_visualization_visible => [],
       enable_gui_api_for_lan_vip => [],
       updates_download_member_config => [],
       http_proxy_server_setting => [],
       restart_banner_setting  => [],
       restart_status          => [],
       token_usage_delay                => [],
       rpz_hit_rate_interval => [],
       rpz_hit_rate_min_query => [],
       rpz_hit_rate_max_query => [],
       objects_changes_tracking_setting => [],       
       deny_mgm_snapshots => [],
       service_status => [],
       syslog_backup_servers => [],
      );

    %_name_mappings =
      (
       copy_audit_to_syslog    => 'audit_to_syslog_enabled',
       external_syslog_server_enable => 'external_syslog_server_enabled',
       enable_recycle_bin      => 'recycle_bin_enabled',
       enable_lom              => 'lom_enabled',
       updates_download_member_config => 'download_member_conf',
       service_status          => 'overall_service_status',
       enable_login_banner     => 'login_banner_enabled',
       notification_email_addr => 'email_setting',
       nat_group_list          => 'nat_groups',
       scheduled_backup        => 'backup_setting',
       secret                  => 'shared_secret',
       syslog_server           => 'syslog_servers',
       vpn_port                => 'vpn_port_number',
       mgm_strict_delegate_mode => 'is_gog_strict_delegate_mode',
       trap_notifications      => 'ib_traps',
       descendants_action      => 'default_descendants_action',
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    $_reverse_name_mappings{'dns_resolver_setting'} = '__skip_handler__';
    $_reverse_name_mappings{'security_setting'}     = '__skip_handler__';
    $_reverse_name_mappings{'password_setting'}     = '__skip_handler__';
    $_reverse_name_mappings{'snmp_setting'}         = '__skip_handler__';
    $_reverse_name_mappings{'ntp_setting'}          = '__skip_handler__';
    $_reverse_name_mappings{'ms_settings'}          = '__skip_handler__';

    %_ibap_to_object =
      (
       'audit_log_format'               => \&ibap_i2o_enums_lc_or_undef,
       'audit_to_syslog_enabled'        => \&ibap_i2o_boolean,
       'backup_setting'                 => \&ibap_i2o_generic_object_convert,
       'informational_banner_setting'         => \&ibap_i2o_generic_object_convert,
       'consent_banner_setting'         => \&ibap_i2o_generic_object_convert,
       'dns_resolver_setting'           => \&__i2o_resolver__,
       'email_setting'                  => \&__i2o_email__,
       'enable_dns_perm_for_nw_range'   => \&ibap_i2o_boolean,
       'enable_member_redirect'         => \&ibap_i2o_boolean,
       'is_gog_strict_delegate_mode'    => \&ibap_i2o_boolean,
       'nat_groups'                     => \&ibap_i2o_generic_object_list_convert,
       'ntp_setting'                    => \&__i2o_ntp__,
       'lom_users'                      => \&ibap_i2o_generic_object_list_convert,
       'lom_enabled'                    => \&ibap_i2o_boolean,
       'recycle_bin_enabled'            => \&ibap_i2o_boolean,
       'enable_rir_swip'                => \&ibap_i2o_boolean,
       'ms_settings'                    => \&__i2o_ms__,
       'security_setting'               => \&__i2o_security__,
       'password_setting'               => \&__i2o_password__,
       'snmp_setting'                   => \&__i2o_snmp__,
       'syslog_servers'                 => \&ibap_i2o_generic_object_list_convert,
       'threshold_traps'                => \&ibap_i2o_generic_object_list_convert,
       'ib_traps'                       => \&ibap_i2o_generic_object_list_convert,
       'default_descendants_action'     => \&__i2o_descendants_action__,
       'is_grid_visualization_visible'   => \&ibap_i2o_boolean,
       'enable_gui_api_for_lan_vip'     => \&ibap_i2o_boolean,
       'download_member_conf'           => \&ibap_i2o_generic_object_list_convert,
       'http_proxy_server_setting'      => \&ibap_i2o_generic_object_convert,
       'restart_banner_setting'         => \&ibap_i2o_generic_object_convert,
       'restart_status'                 => \&ibap_i2o_generic_object_convert,
       objects_changes_tracking_setting => \&ibap_i2o_generic_object_convert,
       'syslog_backup_servers'          => \&ibap_i2o_generic_object_list_convert,
      );

    %_object_to_ibap =
      (
       admin_access_items      => \&ibap_o2i_ignore,
       admin_access_remote_console      => \&ibap_o2i_ignore,
       enable_security_access  => \&ibap_o2i_ignore,
       alternate_resolver      => \&ibap_o2i_ignore,
       audit_log_format        => \&ibap_o2i_enums_lc_or_undef,
       informational_banner_setting  => \&ibap_o2i_generic_struct_convert,
       consent_banner_setting  => \&ibap_o2i_generic_struct_convert,
       copy_audit_to_syslog    => \&ibap_o2i_boolean,
       dscp                    => \&ibap_o2i_uint,
       enable_dns_perm_for_nw_range => \&ibap_o2i_boolean,
       enable_member_redirect  => \&ibap_o2i_boolean,
       enable_ntp              => \&ibap_o2i_ignore,
       enable_snmpv3_traps     => \&ibap_o2i_ignore,
       enable_snmpv3_query     => \&ibap_o2i_ignore,
       enable_recycle_bin      => \&ibap_o2i_boolean,
       enable_scheduling       => \&ibap_o2i_ignore,
       engine_id               => \&ibap_o2i_ignore,
       lcd_input               => \&ibap_o2i_ignore,
       enable_login_banner     => \&ibap_o2i_ignore,
       login_banner_text       => \&ibap_o2i_ignore,
       mgm_strict_delegate_mode => \&ibap_o2i_boolean,
       name                    => \&ibap_o2i_string,
       nat_group_list          => \&ibap_o2i_generic_subobject_list_convert,
       notification_email_addr => \&__o2i_email__,
       lom_users               => \&ibap_o2i_generic_struct_list_convert,
       enable_lom              => \&ibap_o2i_boolean,
       ntp_access_list         => \&ibap_o2i_ignore,
       ntp_service_type        => \&ibap_o2i_ignore,
       enable_rir_swip         => \&ibap_o2i_boolean,
       ms_default_ip_site_link   => \&ibap_o2i_ignore,
       ms_ldap_timeout           => \&ibap_o2i_ignore,
       ms_log_destination        => \&ibap_o2i_ignore,
       ms_max_connection         => \&ibap_o2i_ignore,
       ms_rpc_timeout            => \&ibap_o2i_ignore,
       ms_enable_invalid_mac     => \&ibap_o2i_ignore,
       ms_enable_dhcp_monitoring => \&ibap_o2i_ignore,
       ms_enable_dns_monitoring  => \&ibap_o2i_ignore,
       ms_enable_dns_reports_sync => \&ibap_o2i_ignore,
       ms_enable_network_users   => \&ibap_o2i_ignore,
       ms_enable_user_sync       => \&ibap_o2i_ignore,
       ms_user_default_timeout   => \&ibap_o2i_ignore,
       ntp_authentication_key  => \&ibap_o2i_ignore,
       ntp_server              => \&ibap_o2i_ignore,
       ntp_kod                 => \&ibap_o2i_ignore,
       password_min_length     => \&ibap_o2i_ignore,
       password_num_lower_char => \&ibap_o2i_ignore,
       password_num_upper_char => \&ibap_o2i_ignore,
       password_num_numeric_char => \&ibap_o2i_ignore,
       password_num_symbol_char => \&ibap_o2i_ignore,
       password_chars_to_change => \&ibap_o2i_ignore,
       password_expire_days    => \&ibap_o2i_ignore,
       password_expire_enable  => \&ibap_o2i_ignore,
       password_force_reset    => \&ibap_o2i_ignore,
       password_reminder_days  => \&ibap_o2i_ignore,
       prefer_resolver         => \&ibap_o2i_ignore,
       query_comm_string       => \&ibap_o2i_ignore,
       remote_console_access   => \&ibap_o2i_ignore,
       scheduled_backup        => \&__o2i_backup__,
       search_domains          => \&ibap_o2i_ignore,
       secret                  => \&ibap_o2i_string_skip_undef,
       session_timeout         => \&ibap_o2i_ignore,
       snmpv3_query_users      => \&ibap_o2i_ignore,
       snmp_admin              => \&ibap_o2i_ignore,
       support_access          => \&ibap_o2i_ignore,
       support_access_info     => \&ibap_o2i_ignore,
       syslog_server           => \&ibap_o2i_generic_struct_list_convert,
       syslog_size             => \&ibap_o2i_uint,
       trap_comm_string        => \&ibap_o2i_ignore,
       trap_receiver           => \&ibap_o2i_ignore,
       threshold_traps         => \&ibap_o2i_generic_struct_list_convert,
       trap_notifications      => \&ibap_o2i_generic_struct_list_convert,
       vpn_port                => \&ibap_o2i_uint,
       http_proxy_server_setting => \&ibap_o2i_generic_struct_convert,
       updates_download_member_config    => \&ibap_o2i_generic_struct_list_convert,
       token_usage_delay       => \&ibap_o2i_uint,
       allow_recursive_deletion => \&ibap_o2i_string,
       descendants_action      => \&ibap_o2i_generic_struct_convert,
       is_grid_visualization_visible => \&ibap_o2i_boolean,
       enable_gui_api_for_lan_vip => \&ibap_o2i_boolean,
       restart_banner_setting   => \&ibap_o2i_generic_struct_convert,
       restart_status           => \&ibap_o2i_ignore,
       rpz_hit_rate_interval => \&ibap_o2i_uint,
       rpz_hit_rate_min_query => \&ibap_o2i_uint,
       rpz_hit_rate_max_query => \&ibap_o2i_uint,
       objects_changes_tracking_setting => \&ibap_o2i_generic_struct_convert,
       deny_mgm_snapshots => \&ibap_o2i_boolean,
       service_status                 => \&ibap_o2i_ignore,
       syslog_backup_servers => \&ibap_o2i_generic_struct_list_convert, 

       #
       external_syslog_server_enable  => \&ibap_o2i_boolean,
       use_resolvers                  => \&ibap_o2i_ignore,
       use_query_string               => \&ibap_o2i_ignore,
       use_trap_string                => \&ibap_o2i_ignore,
       use_prefer_resolver            => \&ibap_o2i_ignore,
       use_alternate_resolver         => \&ibap_o2i_ignore,
       email_enabled                  => \&ibap_o2i_ignore,

      );

    $_return_fields_initialized=0;
    @_return_fields =
      (
       tField('audit_log_format'),
       tField('audit_to_syslog_enabled'),
       tField('dns_resolver_setting',
              {
               sub_fields => [
                              tField('enabled'),
                              tField('resolvers'),
                              tField('search_domains'),
                             ]}),
       tField('email_setting',
              {
               sub_fields => [
                              tField('enabled'),
                              tField('address'),
                             ]}),
       tField('dscp'),
       tField('enable_dns_perm_for_nw_range'),
       tField('enable_member_redirect'),
       tField('external_syslog_server_enabled'),
       tField('is_gog_strict_delegate_mode'),
       tField('name'),
       tField('lom_enabled'),
       tField('recycle_bin_enabled'),
       tField('enable_rir_swip'),
       tField('ms_settings',
              {
               sub_fields => [
                   tField('default_ip_site_link'),
                   tField('ldap_timeout'),
                   tField('log_destination'),
                   tField('max_connection'),
                   tField('rpc_timeout'),
                   tField('enable_invalid_mac'),
                   tField('enable_dhcp_monitoring'),
                   tField('enable_dns_monitoring'),
                   tField('enable_dns_reports_sync'),
                   tField('enable_ad_user_sync'),
                   tField('enable_network_users'),
                   tField('ad_user_default_timeout'),
               ],
          }),
       tField('password_setting',
              {
               sub_fields => [
                               tField('force_reset_enable'),
                               tField('password_min_length'),
                               tField('num_lower_char'),
                               tField('num_upper_char'),
                               tField('num_numeric_char'),
                               tField('num_symbol_char'),
                               tField('chars_to_change'),
                               tField('expire_enable'),
                               tField('expire_days'),
                               tField('reminder_days'),
                             ]}),
       tField('syslog_size'),
       tField('vpn_port_number'),
       tField('allow_recursive_deletion'),
       tField('is_grid_visualization_visible'),
       tField('enable_gui_api_for_lan_vip'),
       tField('token_usage_delay'),
       tField('rpz_hit_rate_interval'),
       tField('rpz_hit_rate_min_query'),
       tField('rpz_hit_rate_max_query'),
       tField('deny_mgm_snapshots'),
       tField('overall_service_status'),
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

        #
        my $t=Infoblox::Grid::NatGroup->__new__();

        push @_return_fields,
          tField('nat_groups', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        #
        $t=Infoblox::Grid::ScheduledBackup->__new__();

        push @_return_fields,
          tField('backup_setting', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        #
        $t=Infoblox::Grid::SyslogServer->__new__();

        push @_return_fields,
          tField('syslog_servers', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        $t=Infoblox::Grid::ConsentBannerSetting->__new__();
        push @_return_fields,
          tField('consent_banner_setting', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        $t=Infoblox::Grid::InformationalBannerSetting->__new__();
        push @_return_fields,
          tField('informational_banner_setting', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        

        $t=Infoblox::Grid::HTTPProxyServerSetting->__new__();
        push @_return_fields,
          tField('http_proxy_server_setting', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        $t=Infoblox::Grid::UpdatesDownloadMemberConfig->__new__();
        push @_return_fields,
          tField('download_member_conf', {
                                sub_fields => $t->__return_fields__(),
                               }
                );
        $t=Infoblox::Grid::RestartBannerSetting->__new__();
        push @_return_fields,
          tField('restart_banner_setting', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

        $t=Infoblox::Grid::ServiceRestart::Status->__new__();
        push @_return_fields,
          tField('restart_status', {
                                sub_fields => $t->__return_fields__(),
                               }
                );
        $t = Infoblox::Grid::ObjectsChangesTrackingSetting->__new__();
        push @_return_fields,
            tField('objects_changes_tracking_setting', {sub_fields => $t->__return_fields__()});

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

        $t1 = Infoblox::Grid::LOM::User->__new__();
        push @_return_fields, tField('lom_users', {sub_fields => $t1->__return_fields__()});

        $t1 = Infoblox::Grid::ExtensibleAttributeDef::Descendants->__new__();
        push @_return_fields, tField('default_descendants_action', {sub_fields => $t1->__return_fields__()});

        $t1 = Infoblox::Grid::NamedACL->__new__();
        push @_return_fields, tField('security_setting', { sub_fields => [
                                tField('admin_access_items', return_fields_ac_setting($t1->__return_fields__())),
                                tField('security_access_remote_console_enabled'),
                                tField('security_access_enabled'),
                                tField('lcd_input_enabled'),
                                tField('remote_console_access_enabled'),
                                tField('session_timeout'),
                                tField('support_access_enabled'),
                                tField('support_access_info'),
                                tField('login_banner_enabled'),
                                tField('login_banner_text'),
                             ]});
        $t2 = Infoblox::Grid::NTPAccess->__new__();
        push @_return_fields, tField('ntp_setting',
              {
               sub_fields => [
                              tField('ntp_enabled'),
                              tField('ntp_keys',
                                     {
                                      sub_fields => [
                                                     tField('number'),
                                                     tField('type'),
                                                     tField('string'),
                                                    ]
                                     }
                                    ),
                              tField('ntp_acl', return_fields_ntp_ac_setting($t1->__return_fields__(), $t2->__return_fields__())),
                              tField('ntp_servers',
                                     {
                                      sub_fields => [
                                                     tField('address'),
                                                     tField('authentication_enabled'),
                                                     tField('ntp_key'),
                                                     tField('burst'),
                                                     tField('iburst'),
                                                    ]
                                     }
                                    ),
                              tField('ntp_kod'),
                             ]});
    }

    #
    $self->{'__initializing_from_ibap__'} = 1;
    $self->enable_scheduling('true')  unless defined $self->enable_scheduling(); 
    $self->enable_recycle_bin('true')  unless defined $self->enable_recycle_bin();
    delete $self->{'__initializing_from_ibap__'};

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


sub __post_modify_hook__ {
    my ($self, $server, $session) = @_;

    #
    $session->__extensible_attribute_def_cache_update__();

    return 1;
}

#
#
#

sub __i2o_resolver__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if ($$ibap_object_ref{$current}{'enabled'}) {
        if ($$ibap_object_ref{$current}{'resolvers'} && ref($$ibap_object_ref{$current}{'resolvers'}) eq 'ARRAY') {
            $self->prefer_resolver(@{$$ibap_object_ref{$current}{'resolvers'}}[0]) if defined @{$$ibap_object_ref{$current}{'resolvers'}}[0];
            $self->alternate_resolver(@{$$ibap_object_ref{$current}{'resolvers'}}[1]) if defined @{$$ibap_object_ref{$current}{'resolvers'}}[1];
            $self->search_domains($$ibap_object_ref{$current}{'search_domains'}) if defined $$ibap_object_ref{$current}{'search_domains'};
        }

        $self->{'use_resolvers'} = 1;
    }
}

sub __i2o_email__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    return $$ibap_object_ref{$current}{'address'};
}

sub __i2o_ntp__ {
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    $self->enable_ntp(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'ntp_enabled'}));

    my %tkeys;
    foreach (
             (
              ['ntp_servers', 'Infoblox::Grid::NTPServer', 'ntp_server'],
              ['ntp_keys', 'Infoblox::Grid::NTPKey', 'ntp_authentication_key'],
             )
            ) {
        my ($name, $type,$method) = @{$_};
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
              [
               'ntp_acl',
               'ntp_access_list'
              ],
             )
            ) {
        my ($name, $method) = @{$_};

        $self->$method(ibap_i2o_ntp_ac_setting($self, $session, $name, $$ibap_object_ref{$current}, $return_object_cache_ref));
    }

    $self->ntp_kod(ibap_value_i2o_boolean($$ibap_object_ref{$current}{ntp_kod}));
}

sub __i2o_security__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    $self->lcd_input(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'lcd_input_enabled'}));
    $self->remote_console_access(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'remote_console_access_enabled'}));
    $self->session_timeout($$ibap_object_ref{$current}{'session_timeout'});
    $self->support_access(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'support_access_enabled'}));
    $self->support_access_info($$ibap_object_ref{$current}{'support_access_info'});
    $self->enable_login_banner(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'login_banner_enabled'}));
    $self->login_banner_text($$ibap_object_ref{$current}{'login_banner_text'});
    $self->enable_security_access(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'security_access_enabled'}));
    $self->admin_access_remote_console(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'security_access_remote_console_enabled'}));
    $self->admin_access_items(ibap_i2o_ac_setting($self, $session, 'admin_access_items', $ibap_object_ref->{$current}));
}

sub __i2o_ms__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    $self->ms_default_ip_site_link($$ibap_object_ref{$current}{'default_ip_site_link'});
    $self->ms_ldap_timeout($$ibap_object_ref{$current}{'ldap_timeout'});
    $self->ms_log_destination($$ibap_object_ref{$current}{'log_destination'});
    $self->ms_max_connection($$ibap_object_ref{$current}{'max_connection'});
    $self->ms_rpc_timeout($$ibap_object_ref{$current}{'rpc_timeout'});
    $self->ms_enable_invalid_mac(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'enable_invalid_mac'}));
    $self->ms_enable_dhcp_monitoring(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'enable_dhcp_monitoring'}));
    $self->ms_enable_dns_monitoring(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'enable_dns_monitoring'}));
    $self->ms_enable_dns_reports_sync(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'enable_dns_reports_sync'}));
    $self->ms_enable_user_sync(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'enable_ad_user_sync'}));
    $self->ms_enable_network_users(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'enable_network_users'}));
    $self->ms_user_default_timeout($$ibap_object_ref{$current}{'ad_user_default_timeout'});
}

sub __i2o_password__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    $self->password_force_reset(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'force_reset_enable'}));
    $self->password_min_length($$ibap_object_ref{$current}{'password_min_length'});

    $self->password_num_lower_char($$ibap_object_ref{$current}{'num_lower_char'});
    $self->password_num_upper_char($$ibap_object_ref{$current}{'num_upper_char'});
    $self->password_num_numeric_char($$ibap_object_ref{$current}{'num_numeric_char'});
    $self->password_num_symbol_char($$ibap_object_ref{$current}{'num_symbol_char'});
    $self->password_chars_to_change($$ibap_object_ref{$current}{'chars_to_change'});
    $self->password_expire_days($$ibap_object_ref{$current}{'expire_days'});
    $self->password_expire_enable(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'expire_enable'}));
    $self->password_reminder_days($$ibap_object_ref{$current}{'reminder_days'});
}


sub __i2o_snmp__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    $self->query_comm_string($$ibap_object_ref{$current}{'queries_community_string'}) if $$ibap_object_ref{$current}{'queries_enabled'};
    $self->{'use_query_string'} = $$ibap_object_ref{$current}{'queries_enabled'};

    $self->trap_comm_string($$ibap_object_ref{$current}{'traps_community_string'}) if $$ibap_object_ref{$current}{'traps_enabled'};
    $self->{'use_trap_string'} = $$ibap_object_ref{$current}{'traps_enabled'};


    $self->snmpv3_query_users(ibap_i2o_snmpv3_query_users($self,$session,'snmpv3_queries_users',$$ibap_object_ref{$current}));
    $self->{'enable_snmpv3_query'}=ibap_value_i2o_boolean($$ibap_object_ref{$current}{'snmpv3_queries_enabled'});
    $self->{'enable_snmpv3_traps'} = ibap_value_i2o_boolean($$ibap_object_ref{$current}{'snmpv3_traps_enabled'});
    $self->trap_receiver(ibap_i2o_trap_receivers($self,$session,'trap_receivers',$$ibap_object_ref{$current}));
    $self->engine_id($$ibap_object_ref{$current}{'engine_id'});


    my $t=Infoblox::Grid::SNMP::Admin->__new__();
    $t->__ibap_to_object__($$ibap_object_ref{$current}, $session->get_ibap_server(), $session);

    #
    #
    #
    #
    $self->snmp_admin($t);

}

sub __i2o_descendants_action__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;

    my $t = Infoblox::Grid::ExtensibleAttributeDef::Descendants->__new__();
    $t->__ibap_to_object__($$ibap_object_ref{$current}, $session->get_ibap_server(), $session);

    return $t;
}

#
#
sub __skip_handler__{};

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'is_grid_visualization_visible'} = 0 unless defined $$ibap_object_ref{'is_grid_visualization_visible'};
    $$ibap_object_ref{'enable_gui_api_for_lan_vip'} = 0 unless defined $$ibap_object_ref{'enable_gui_api_for_lan_vip'};
    $$ibap_object_ref{'external_syslog_server_enabled'} = 0 unless defined $$ibap_object_ref{'external_syslog_server_enabled'};

    $self->{'updates_download_member_config'} = [] unless defined $$ibap_object_ref{'updates_download_member_config'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'__initializing_from_ibap__'} = 1;
    unless (defined $self->nat_group_list()) {
        $self->nat_group_list([]);
    }

    unless (defined $self->ntp_authentication_key()) {
        $self->ntp_authentication_key([]);
    }

    $self->{'email_enabled'} = $$ibap_object_ref{'email_setting'}{'enabled'};
    $self->{'external_syslog_server_enable'} = ibap_value_i2o_boolean($$ibap_object_ref{'external_syslog_server_enabled'});
    delete $self->{'notification_email_addr'} unless $$ibap_object_ref{'email_setting'}{'enabled'};
    delete $self->{'__initializing_from_ibap__'};

    return;
}

#
#
#
sub __o2i_backup__
{
    my ($self, $session, $current, $tempref) = @_;
    #
    $$tempref{$current}->{'source'} = 'DB';
    return ibap_o2i_generic_struct_convert($self, $session, $current, $tempref);
}

sub __o2i_ntp__
{
    my ($self, $session, $current, $tempref) = @_;

    my %substruct;

    $substruct{'ntp_enabled'} = ibap_value_o2i_boolean($self->enable_ntp());
    $substruct{'ntp_servers'} = ibap_serialize_substruct_list($session,$$tempref{'ntp_server'},'ntp_server');
    $substruct{'ntp_kod'}     = ibap_value_o2i_boolean($self->ntp_kod());
    return (0) unless $substruct{'ntp_servers'};    $substruct{'ntp_kod'}     = ibap_value_o2i_boolean($self->ntp_kod());

    foreach (
             (
              [
               'ntp_access_list',
               'ntp_acl'
              ],
             )
            ) {
        my ($name, $iname) = @{$_};

        my @data = ibap_o2i_ntp_ac_setting($self, $session, $name, $tempref);
        if ($data[0]) {
            $substruct{$iname} = $data[2];
        } else {
            return (0);
        }
    }

    $substruct{'ntp_keys'} = ibap_serialize_substruct_list($session,$$tempref{'ntp_authentication_key'},'ntp_auth_key',1);
    return (0) unless $substruct{'ntp_keys'};

    return (1, 0, tIBType('grid_ntp', \%substruct));
}

sub __o2i_email__
{
    my ($self, $session, $current, $tempref) = @_;

    return (1,0, tIBType('email_setting', {
                                           'enabled' => ibap_value_o2i_boolean($$tempref{'email_enabled'}),
                                           'address' => ibap_value_o2i_string_undef_to_empty($$tempref{$current}),
                                          }
                        ));
}

sub __o2i_resolver__
{
    my ($self, $session, $current, $tempref) = @_;

    if ($self->{'use_resolvers'}) {
        my @list;

        if (defined($self->prefer_resolver())) {
            if (ref($self->prefer_resolver())) {
                if ($self->prefer_resolver()->ipv4addr()) {
                    push @list, tIBType('IPAddress',$self->prefer_resolver()->ipv4addr());
                }
                else {
                    push @list, tIBType('IPAddress',$self->prefer_resolver()->ipv6addr());
                }
            }
            else {
                push @list, tIBType('IPAddress',$self->prefer_resolver());
            }
        } else {
            push @list, tIBType('IPAddress','');
        }

        if (defined($self->alternate_resolver())) {
            if (ref($self->alternate_resolver())) {
                if ($self->alternate_resolver()->ipv4addr()) {
                    push @list, tIBType('IPAddress',$self->alternate_resolver()->ipv4addr());
                }
                else {
                    push @list, tIBType('IPAddress',$self->alternate_resolver()->ipv6addr());
                }
            }
            else {
                push @list, tIBType('IPAddress',$self->alternate_resolver());
            }
        } else {
            push @list, tIBType('IPAddress','');
        }
        my $search_domains_list = $self->search_domains() || [];

        return (1,0, tIBType('dns_resolver_setting', {
                                                      'enabled' => tBool(1),
                                                      'resolvers' => \@list,
                                                      'search_domains' => tIBType('ArrayOfstring', $search_domains_list),
                                                     }));
    }
    else {
        return (1,0, tIBType('dns_resolver_setting', {'enabled' => tBool(0)}));
    }
}

sub __o2i_security__
{
    my ($self, $session, $current, $tempref) = @_;

    my @data = ibap_o2i_ac_setting_undef_to_empty_list($self, $session, 'admin_access_items', $tempref);
    return (0) unless $data[0];

    return (1,0, tIBType('security_setting', {
                                              'lcd_input_enabled'             => ibap_value_o2i_boolean($self->lcd_input()),
                                              'remote_console_access_enabled' => ibap_value_o2i_boolean($self->remote_console_access()),
                                              'session_timeout'               => ibap_value_o2i_uint($self->session_timeout()),
                                              'support_access_enabled'        => ibap_value_o2i_boolean($self->support_access()),
                                              'login_banner_enabled'          => ibap_value_o2i_boolean($self->enable_login_banner()),
                                              'login_banner_text'             => ibap_value_o2i_string($self->login_banner_text()),
                                              'security_access_enabled'       => ibap_value_o2i_boolean($self->enable_security_access()),
                                              'security_access_remote_console_enabled' => ibap_value_o2i_boolean($self->admin_access_remote_console()),
                                              'admin_access_items'            => $data[2],
                                             }
                              ));
}

sub __o2i_ms__
{
    my ($self, $session, $current, $tempref) = @_;

    return (1,0, tIBType('ms_settings', {
        'default_ip_site_link'    => ibap_value_o2i_string($self->ms_default_ip_site_link()),
        'ldap_timeout'            => ibap_value_o2i_uint($self->ms_ldap_timeout()),
        'log_destination'         => ibap_value_o2i_string($self->ms_log_destination()),
        'max_connection'          => ibap_value_o2i_uint($self->ms_max_connection()),
        'rpc_timeout'             => ibap_value_o2i_uint($self->ms_rpc_timeout()),
        'enable_invalid_mac'      => ibap_value_o2i_boolean($self->ms_enable_invalid_mac()),
        'enable_dhcp_monitoring'  => ibap_value_o2i_boolean($self->ms_enable_dhcp_monitoring()),
        'enable_dns_monitoring'   => ibap_value_o2i_boolean($self->ms_enable_dns_monitoring()),
        'enable_dns_reports_sync' => ibap_value_o2i_boolean($self->ms_enable_dns_reports_sync()),
        'enable_ad_user_sync'     => ibap_value_o2i_boolean($self->ms_enable_user_sync()),
        'enable_network_users'    => ibap_value_o2i_boolean($self->ms_enable_network_users()),
        'ad_user_default_timeout' => ibap_value_o2i_uint($self->ms_user_default_timeout()),
    }));
}

sub __o2i_password__
{
    my ($self, $session, $current, $tempref) = @_;

    return (1,0, tIBType('password_setting', 
            {
    'force_reset_enable'  => ibap_value_o2i_boolean($self->password_force_reset()),
    'password_min_length' => ibap_value_o2i_uint($self->password_min_length()),
    'num_lower_char'      => ibap_value_o2i_uint($self->password_num_lower_char()),
    'num_upper_char'      => ibap_value_o2i_uint($self->password_num_upper_char()),
    'num_numeric_char'    => ibap_value_o2i_uint($self->password_num_numeric_char()),
    'num_symbol_char'     => ibap_value_o2i_uint($self->password_num_symbol_char()),
    'chars_to_change'     => ibap_value_o2i_uint($self->password_chars_to_change()),
    'expire_days'         => ibap_value_o2i_uint($self->password_expire_days()),
    'expire_enable'       => ibap_value_o2i_boolean($self->password_expire_enable()),
    'reminder_days'       => ibap_value_o2i_uint($self->password_reminder_days()),
            },
        ));
}

sub __o2i_snmp__
{
    my ($self, $session, $current, $tempref) = @_;


    my $values = {
                  'queries_enabled'          => tBool($self->{'use_query_string'}),
                  'snmpv3_queries_enabled'   => ibap_value_o2i_boolean($self->{'enable_snmpv3_query'}),
                  'traps_enabled'            => tBool($self->{'use_trap_string'}),
                  'snmpv3_traps_enabled'     => ibap_value_o2i_boolean($self->{'enable_snmpv3_traps'}),
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
    my $write_fields;
    if ($self->snmp_admin()) {
        $write_fields=$self->snmp_admin()->__object_to_ibap__($session->get_ibap_server(),$session);
    }
    else {
        $write_fields=Infoblox::Grid::SNMP::Admin->new(
                                                 sysContact_node1  => '',
                                                 sysDescr_node1    => '',
                                                 sysLocation_node1 => '',
                                                 sysName_node1     => '',
                                                 sysContact_node2  => '',
                                                 sysDescr_node2    => '',
                                                 sysLocation_node2 => '',
                                                 sysName_node2     => '',
                                                )->__object_to_ibap__($session->get_ibap_server(),$session);
    }

        return (0) if(!$write_fields);

        my %substruct;
        foreach (@$write_fields) {
            $values->{$_->{'field'}} = $_->{'value'};
        }

    return (1,0, tIBType('snmp_setting', $values));
}

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;


    #
    #
    #

    if (defined $self->{'ntp_server'}) {
        my $keys=[];
        my %seen;

        if (defined $self->{'ntp_authentication_key'}) {
            $keys=$self->{'ntp_authentication_key'};
        }

        foreach my $t(@$keys) {
            $seen{$t->key_number()}=1;
        }

        foreach my $t(@{$self->{'ntp_server'}}) {
            if ($t->ntp_key() && $t->ntp_key()->key_number()) {
                unless (defined $seen{$t->ntp_key()->key_number()}) {
                    push @$keys,$t->ntp_key();
                }
            }
        }
        $self->{'ntp_authentication_key'} = $keys;
    }

    my $ref_write_fields=$self->SUPER::__object_to_ibap__($server, $session);

    return unless $ref_write_fields;

    #

    foreach (
             (
              ['dns_resolver_setting' , \&__o2i_resolver__],
              ['ms_settings'          , \&__o2i_ms__],
              ['ntp_setting'          , \&__o2i_ntp__],
              ['snmp_setting'         , \&__o2i_snmp__],
              ['security_setting'     , \&__o2i_security__],
              ['password_setting'     , \&__o2i_password__],
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

sub admin_access_items
{
    my $self = shift;
    return $self->ibap_accessor_ac_setting('admin_access_items', 0, {}, @_);
}

sub admin_access_remote_console
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'admin_access_remote_console', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_security_access
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'enable_security_access', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dscp
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'dscp', validator => \&ibap_value_o2i_uint}, @_);
}

sub syslog_size
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'syslog_size', validator => \&ibap_value_o2i_uint}, @_);
}

sub informational_banner_setting
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'informational_banner_setting', validator => { 'Infoblox::Grid::InformationalBannerSetting' => 1 }}, @_);
}

sub consent_banner_setting
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'consent_banner_setting', validator => { 'Infoblox::Grid::ConsentBannerSetting' => 1 }}, @_);
}

sub copy_audit_to_syslog
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'copy_audit_to_syslog', validator => \&ibap_value_o2i_boolean}, @_);
}

sub password_min_length
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'password_min_length', validator => \&ibap_value_o2i_uint}, @_);
}

sub password_num_lower_char
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'password_num_lower_char', validator => \&ibap_value_o2i_uint}, @_);
}

sub password_num_upper_char
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'password_num_upper_char', validator => \&ibap_value_o2i_uint}, @_);
}

sub password_num_numeric_char
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'password_num_numeric_char', validator => \&ibap_value_o2i_uint}, @_);
}

sub password_num_symbol_char
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'password_num_symbol_char', validator => \&ibap_value_o2i_uint}, @_);
}

sub password_chars_to_change
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'password_chars_to_change', validator => \&ibap_value_o2i_uint}, @_);
}

sub password_expire_days
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'password_expire_days', validator => \&ibap_value_o2i_uint}, @_);
}

sub password_reminder_days
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'password_reminder_days', validator => \&ibap_value_o2i_uint}, @_);
}

sub password_expire_enable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'password_expire_enable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub password_force_reset
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'password_force_reset', validator => \&ibap_value_o2i_boolean}, @_);
}

sub scheduled_backup
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'scheduled_backup', validator => { 'Infoblox::Grid::ScheduledBackup' => 1 }}, @_);
}

sub audit_log_format
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'audit_log_format', enum => ['detailed','brief'] }, @_);
}

sub enable_lom
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_lom', validator => \&ibap_value_o2i_boolean }, @_);
}

sub lom_users
{
    my $self=shift;
    return $self->__accessor_array__({name => 'lom_users', validator => { 'Infoblox::Grid::LOM::User' => 1 }}, @_);
}

sub nat_group_list
{
    my $self=shift;
    return $self->__accessor_array__({name => 'nat_group_list', validator => { 'Infoblox::Grid::NatGroup' => 1 }}, @_);
}

sub ntp_server
{
    my $self=shift;
    return $self->__accessor_array__({name => 'ntp_server', validator => { 'Infoblox::Grid::NTPServer' => 1 }}, @_);
}

sub ntp_kod
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ntp_kod', validator => \&ibap_value_o2i_boolean }, @_);
}

sub ntp_authentication_key
{
    my $self=shift;
    return $self->__accessor_array__({name => 'ntp_authentication_key', validator => { 'Infoblox::Grid::NTPKey' => 1 }}, @_);
}

sub ntp_access_list
{
    my $self=shift;

    if (@_) {
        if (ref($_[0]) eq 'Infoblox::Grid::NamedACL') {
            return $self->__accessor_scalar__({name => 'ntp_access_list', validator => { 'Infoblox::Grid::NamedACL' => 1 }}, @_);
        } else {
            return $self->__accessor_array__({name => 'ntp_access_list', validator => { 'Infoblox::Grid::NTPAccess' => 1 }}, @_);
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

sub enable_rir_swip
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_rir_swip', validator => \&ibap_value_o2i_boolean}, @_);
}


sub ms_default_ip_site_link
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_default_ip_site_link', validator => \&ibap_value_o2i_string}, @_);
}

sub ms_ldap_timeout
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_ldap_timeout', validator => \&ibap_value_o2i_uint}, @_);
}

sub ms_log_destination
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_log_destination', enum => ['SYSLOG', 'MSLOG']}, @_);
}

sub ms_max_connection
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_max_connection', validator => \&ibap_value_o2i_uint}, @_);
}

sub ms_rpc_timeout
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_rpc_timeout', validator => \&ibap_value_o2i_uint}, @_);
}

sub ms_enable_invalid_mac
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_enable_invalid_mac', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ms_enable_dhcp_monitoring
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_enable_dhcp_monitoring', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ms_enable_dns_monitoring
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_enable_dns_monitoring', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ms_enable_dns_reports_sync
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_enable_dns_reports_sync', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ms_enable_user_sync
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_enable_user_sync', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ms_enable_network_users
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_enable_network_users', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ms_user_default_timeout
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ms_user_default_timeout', validator => \&ibap_value_o2i_uint}, @_);
}

sub enable_dns_perm_for_nw_range
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_dns_perm_for_nw_range', validator => \&ibap_value_o2i_boolean }, @_);
}

sub enable_member_redirect
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_member_redirect', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_ntp
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_ntp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub mgm_strict_delegate_mode
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'mgm_strict_delegate_mode', validator => \&ibap_value_o2i_boolean}, @_);
}

sub notification_email_addr
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'notification_email_addr', validator => \&ibap_value_o2i_string, use => \$self->{'email_enabled'}}, @_);
}

sub snmp_admin
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'snmp_admin', validator => { 'Infoblox::Grid::SNMP::Admin' => 1 }}, @_);
}

sub trap_receiver
{
    my $self=shift;
    return $self->__accessor_array__({name => 'trap_receiver', validator => { 'string' => \&ibap_value_o2i_string, 'Infoblox::Grid::SNMP::TrapReceiver' => 1 }}, @_);
}

sub trap_comm_string
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'trap_comm_string', validator => \&ibap_value_o2i_string, use => \$self->{'use_trap_string'}}, @_);
}

sub query_comm_string
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'query_comm_string', validator => \&ibap_value_o2i_string, use => \$self->{'use_query_string'}}, @_);
}

sub session_timeout
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'session_timeout', validator => \&ibap_value_o2i_uint}, @_);
}

sub lcd_input
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'lcd_input', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_login_banner
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_login_banner', validator => \&ibap_value_o2i_boolean}, @_);
}

sub login_banner_text
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'login_banner_text', validator => \&ibap_value_o2i_string}, @_);
}

sub remote_console_access
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'remote_console_access', validator => \&ibap_value_o2i_boolean}, @_);
}

sub support_access
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'support_access', validator => \&ibap_value_o2i_boolean}, @_);
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
        $self->{'use_resolvers'}= $self->{'use_prefer_resolver'} || $self->{'use_alternate_resolver'};
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
        $self->{'use_resolvers'}= $self->{'use_prefer_resolver'} || $self->{'use_alternate_resolver'};
    }

    return $t;
}

sub search_domains
{
    my $self = shift;
    return $self->__accessor_array__({name => 'search_domains', validator => \&ibap_value_o2i_string}, @_);
}

sub enable_scheduling
{
   my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_scheduling', readonly => 1}, @_);
}

sub enable_recycle_bin
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_recycle_bin', validator => \&ibap_value_o2i_boolean}, @_);
}

sub engine_id
{
    my $self=shift;
    return $self->__accessor_array__({name => 'engine_id', readonly => 1}, @_);
}

sub vpn_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'vpn_port', validator => \&ibap_value_o2i_uint}, @_);
}

sub secret
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'secret', writeonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}


sub enable_snmpv3_query
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_snmpv3_query', validator => \&ibap_value_o2i_boolean},@_);
}

sub enable_snmpv3_traps
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_snmpv3_traps', validator => \&ibap_value_o2i_boolean},@_);
}

sub snmpv3_query_users
{
    my $self=shift;
    return $self->__accessor_array__({name => 'snmpv3_query_users', validator =>{'Infoblox::Grid::SNMP::QueriesUser' => 1}, use => \$self->{'enable_snmpv3_query'}, use_truefalse => 1 }, @_);
}

sub threshold_traps
{
    my $self=shift;
    return $self->__accessor_array__({name => 'threshold_traps', validator=> {'Infoblox::Grid::SNMP::ThresholdTrap' => 1},},@_);
}

sub trap_notifications
{
    my $self=shift;
    return $self->__accessor_array__({name => 'trap_notifications', validator=> {'Infoblox::Grid::SNMP::TrapNotification' => 1},},@_);
}

sub allow_recursive_deletion
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_recursive_deletion', enum => ['NOBODY', 'SUPERUSERS', 'ALL']}, @_);
}

sub descendants_action
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'descendants_action', validator => {'Infoblox::Grid::ExtensibleAttributeDef::Descendants' => 1}}, @_);
}

package Infoblox::Grid::SNMP::Admin;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    #
    %_allowed_members = (
                         sysDescr    => 0,
                         sysName     => 0,
                         sysLocation => 0,
                         sysContact  => 0,

                         sysDescr_node1    => 0,
                         sysName_node1     => 0,
                         sysLocation_node1 => 0,
                         sysContact_node1  => 0,

                         sysDescr_node2    => 0,
                         sysName_node2     => 0,
                         sysLocation_node2 => 0,
                         sysContact_node2  => 0,
                        );

    #
    #
    #
    #
    #
    %_name_mappings = (
                       _internal_sysContact  => 'syscontact',
                       _internal_sysDescr    => 'sysdescr',
                       _internal_sysLocation => 'syslocation',
                       _internal_sysName     => 'sysname',
                      );

    %_ibap_to_object = (
                       );

    %_object_to_ibap =
      (
       sysDescr          => \&ibap_o2i_ignore,
       sysName           => \&ibap_o2i_ignore,
       sysLocation       => \&ibap_o2i_ignore,
       sysContact        => \&ibap_o2i_ignore,
       sysDescr_node1    => \&ibap_o2i_ignore,
       sysName_node1     => \&ibap_o2i_ignore,
       sysLocation_node1 => \&ibap_o2i_ignore,
       sysContact_node1  => \&ibap_o2i_ignore,
       sysDescr_node2    => \&ibap_o2i_ignore,
       sysName_node2     => \&ibap_o2i_ignore,
       sysLocation_node2 => \&ibap_o2i_ignore,
       sysContact_node2  => \&ibap_o2i_ignore,

       _internal_sysContact   => \&ibap_o2i_string_array_undef_to_empty,
       _internal_sysDescr     => \&ibap_o2i_string_array_undef_to_empty,
       _internal_sysLocation  => \&ibap_o2i_string_array_undef_to_empty,
       _internal_sysName      => \&ibap_o2i_string_array_undef_to_empty,
      );

    %_reverse_name_mappings = reverse %_name_mappings;

}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args))
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

sub __i2o_value_helper__
{
    my ($self, $internal, $node1, $node2) = @_;

    if ($self->{$internal} && ref($self->{$internal}) eq 'ARRAY') {
        my $t = scalar(@{$self->{$internal}});
        $self->{$node1} = @{$self->{$internal}}[0];
        $self->{$node2} = @{$self->{$internal}}[1] if $t == 2;
    }
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    $self->{'sysContact_node1'}  = '';
    $self->{'sysDescr_node1'}    = '';
    $self->{'sysLocation_node1'} = '';
    $self->{'sysName_node1'}     = '';

    $self->{'sysContact_node2'}  = '';
    $self->{'sysDescr_node2'}    = '';
    $self->{'sysLocation_node2'} = '';
    $self->{'sysName_node2'}     = '';

    #
    $self->__i2o_value_helper__('_internal_sysContact','sysContact_node1','sysContact_node2');
    $self->__i2o_value_helper__('_internal_sysDescr','sysDescr_node1','sysDescr_node2');
    $self->__i2o_value_helper__('_internal_sysLocation','sysLocation_node1','sysLocation_node2');
    $self->__i2o_value_helper__('_internal_sysName','sysName_node1','sysName_node2');

    #
    delete $self->{'_internal_sysContact'};
    delete $self->{'_internal_sysDescr'};
    delete $self->{'_internal_sysLocation'};
    delete $self->{'_internal_sysName'};

    return;
}

#
#
#

sub __o2i_value_helper__
{
    my ($self, $node1, $node2, $internal) = @_;

    my @temp = ('','');
    $temp[0] = $self->$node1() if $self->$node1();
    $temp[1] = $self->$node2() if $self->$node2();
    $self->{$internal} = \@temp;
}

sub __object_to_ibap__
{
	my ($self, $server, $session) = @_;

    #
    #
    #
    $self->__o2i_value_helper__('sysContact_node1','sysContact_node2','_internal_sysContact');
    $self->__o2i_value_helper__('sysDescr_node1','sysDescr_node2','_internal_sysDescr');
    $self->__o2i_value_helper__('sysLocation_node1','sysLocation_node2','_internal_sysLocation');
    $self->__o2i_value_helper__('sysName_node1','sysName_node2','_internal_sysName');

    my $t = $self->SUPER::__object_to_ibap__($server, $session);

    #
    delete $self->{'_internal_sysContact'};
    delete $self->{'_internal_sysDescr'};
    delete $self->{'_internal_sysLocation'};
    delete $self->{'_internal_sysName'};

    return $t;
}

#
#
#

#
sub sysContact
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'sysContact_node1', validator => \&ibap_value_o2i_string}, @_);
}

sub sysDescr
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'sysDescr_node1', validator => \&ibap_value_o2i_string}, @_);
}

sub sysLocation
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'sysLocation_node1', validator => \&ibap_value_o2i_string}, @_);
}

sub sysName
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'sysName_node1', validator => \&ibap_value_o2i_string}, @_);
}

sub sysContact_node1
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'sysContact_node1', validator => \&ibap_value_o2i_string}, @_);
}

sub sysDescr_node1
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'sysDescr_node1', validator => \&ibap_value_o2i_string}, @_);
}

sub sysLocation_node1
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'sysLocation_node1', validator => \&ibap_value_o2i_string}, @_);
}

sub sysName_node1
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'sysName_node1', validator => \&ibap_value_o2i_string}, @_);
}

sub sysContact_node2
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'sysContact_node2', validator => \&ibap_value_o2i_string}, @_);
}

sub sysDescr_node2
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'sysDescr_node2', validator => \&ibap_value_o2i_string}, @_);
}

sub sysLocation_node2
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'sysLocation_node2', validator => \&ibap_value_o2i_string}, @_);
}

sub sysName_node2
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'sysName_node2', validator => \&ibap_value_o2i_string}, @_);
}

#
sub _internal_sysContact
{
    my $self=shift;
    return $self->__accessor_array__({name => '_internal_sysContact', validator => \&ibap_value_o2i_string}, @_);
}

sub _internal_sysDescr
{
    my $self=shift;
    return $self->__accessor_array__({name => '_internal_sysDescr', validator => \&ibap_value_o2i_string}, @_);
}

sub _internal_sysLocation
{
    my $self=shift;
    return $self->__accessor_array__({name => '_internal_sysLocation', validator => \&ibap_value_o2i_string}, @_);
}

sub _internal_sysName
{
    my $self=shift;
    return $self->__accessor_array__({name => '_internal_sysName', validator => \&ibap_value_o2i_string}, @_);
}

package Infoblox::Grid::ScheduledBackup;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields $_object_type);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    $_object_type = 'backup_setting';
    register_wsdl_type('ib:backup_setting','Infoblox::Grid::ScheduledBackup');
    %_allowed_members = (
                         source           => 0,
                         backup_frequency => 0,
                         backup_server    => 0,
                         backup_type      => 0,
                         keep_local_copy  => 0,
                         disabled         => 0,
                         hour_of_day      => 0,
                         minute_of_hour   => 0,
                         password         => 0,
                         path             => 0,
                         user             => 0,
                         weekday          => 0,
                         nios_data        => 0,
                         discovery_data   => 0,
                         splunk_app_data  => 0,

                         #
                         status            => -1,
                         operation         => 0,
                         #
                         execute           => 0,
                         status_time       => -1,
                         restore_type      => 0,
                         restore_host      => 0,
                         restore_username  => 0,
                         restore_password  => 0,
                         restore_directory => 0,
                        );

    %_name_mappings = (
                         backup_server    => 'backup_host',
                         disabled         => 'scheduled_backups_enabled',
                         minute_of_hour   => 'minutes_past_hour',
                         path             => 'directory_path',
                         user             => 'username',
                         execute          => 'status',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    $_reverse_name_mappings{'status'} = 'status';

    %_ibap_to_object =
      (
       keep_local_copy           => \&ibap_i2o_boolean,
       backup_frequency          => \&ibap_i2o_enums_ucfirst_or_undef,
       scheduled_backups_enabled => \&__i2o_enabled__,
       weekday                   => \&ibap_i2o_enums_ucfirst_or_undef,
       nios_data                 => \&ibap_i2o_boolean,
       discovery_data            => \&ibap_i2o_boolean,
       splunk_app_data           => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       source           => \&ibap_o2i_string,
       backup_frequency => \&ibap_o2i_enums_lc_or_undef,
       backup_server    => \&ibap_o2i_string,
       backup_type      => \&ibap_o2i_string,
       keep_local_copy  => \&ibap_o2i_boolean,
       disabled         => \&__o2i_enabled__,
       hour_of_day      => \&ibap_o2i_uint,
       minute_of_hour   => \&ibap_o2i_uint,
       password         => \&ibap_o2i_string_skip_undef,
       path             => \&ibap_o2i_string,
       user             => \&ibap_o2i_string,
       weekday          => \&__o2i_weekday__,

       status            => \&ibap_o2i_ignore,
       execute           => \&__o2i_execute__,
       operation         => \&ibap_o2i_string,
       status_time       => \&ibap_o2i_ignore,
       restore_type      => \&ibap_o2i_string,
       restore_host      => \&ibap_o2i_string,
       restore_username  => \&ibap_o2i_string,
       restore_password  => \&ibap_o2i_string_skip_undef,
       restore_directory => \&ibap_o2i_string,
       nios_data         => \&ibap_o2i_boolean,
       discovery_data    => \&ibap_o2i_boolean,
       splunk_app_data   => \&ibap_o2i_boolean,
      );

    @_return_fields =
      (
       tField('source'),
       tField('backup_frequency'),
       tField('backup_host'),
       tField('backup_type'),
       tField('keep_local_copy'),
       tField('directory_path'),
       tField('hour_of_day'),
       tField('minutes_past_hour'),
       tField('scheduled_backups_enabled'),
       tField('username'),
       tField('weekday'),
       tField('status'),
       tField('operation'),
       tField('status_time'),
       tField('restore_type'),
       tField('restore_host'),
       tField('restore_username'),
       tField('restore_directory'),
       tField('nios_data'),
       tField('discovery_data'),
       tField('splunk_app_data'),
      );
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args))
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
    $self->source('DB')              unless $self->source();
    $self->disabled('false')         unless $self->disabled();
    $self->minute_of_hour(0)         unless $self->minute_of_hour();
    $self->hour_of_day('3')          unless $self->hour_of_day();
    $self->weekday('6')              unless $self->weekday();
    $self->backup_frequency('Daily') unless $self->backup_frequency();
    $self->backup_type('LOCAL')      unless $self->backup_type();
    $self->operation('NONE')         unless $self->operation();
    $self->restore_type('FTP')       unless $self->restore_type();
    $self->splunk_app_data('false')  unless $self->splunk_app_data();

    unless (defined $self->{'nios_data'} and defined $self->{'discovery_data'}) {
        $self->nios_data('true');
        $self->discovery_data('false');
    }
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
        'nios_data',
        'discovery_data',
        'splunk_app_data',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __i2o_enabled__ {
    my ($self, $session, $current, $tempref) = @_;

    if (defined(${$tempref}{$current}) && ${$tempref}{$current} == 1) {
        return 'false';
    }

    return 'true';
}

sub __o2i_enabled__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    push @return_args, 1;
    push @return_args, 0;

    #
    #
    if (($tempref->{$current} =~ m/^false$/i) || ($tempref->{$current} eq '0')) {
        push @return_args, tBool(1);
    } else {
        push @return_args, tBool(0);
    }

    return @return_args;
}

sub __o2i_weekday__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if ($tempref->{$current} =~ m/[0-7]/) {
        return (1,0, ibap_value_o2i_string(('SUNDAY','MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY')[$tempref->{$current}]));
    }
    else {
        return (1,0, ibap_value_o2i_string(uc $tempref->{$current}));
    }

    return @return_args;
}

sub __o2i_execute__ {

    my ($self, $session, $current, $tempref) = @_;

    return (1, 1, undef) unless defined $$tempref{$current};

    return (1, 0, ibap_value_o2i_string({
        'TRIGGER' => 'TRIGGERED'
    }->{$$tempref{$current}}));
}

#
#
#

sub source
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'source', enum => ['DB', 'REPORTING'] }, @_);
}

sub backup_frequency
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'backup_frequency', enum => ['Weekly','Daily','Hourly'] }, @_);
}

sub backup_server
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'backup_server', validator => \&ibap_value_o2i_string}, @_);
}

sub backup_type
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'backup_type', enum => ['LOCAL','TFTP','FTP','SCP'] }, @_);
}

sub keep_local_copy
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'keep_local_copy', validator => \&ibap_value_o2i_boolean}, @_);
}
sub disabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub hour_of_day
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'hour_of_day', validator => \&ibap_value_o2i_uint}, @_);
}

sub minute_of_hour
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'minute_of_hour', validator => \&ibap_value_o2i_uint}, @_);
}

sub password
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'password', writeonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub path
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'path', validator => \&ibap_value_o2i_string}, @_);
}

sub user
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'user', validator => \&ibap_value_o2i_string}, @_);
}

sub weekday
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'weekday', enum => ['0','1','2','3','4','5','6','7','Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday' ] }, @_);
}

sub status
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'status', readonly => 1, validator => \&ibap_value_o2i_string }, @_);
}

sub execute {

    my $self = shift;
    return $self->__accessor_scalar__({name => 'execute', writeonly => 1, enum => ['TRIGGER']}, @_);
}

sub status_time
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'status_time', readonly => 1, validator => \&ibap_value_o2i_string }, @_);
}

sub operation
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'operation', enum => ['NONE', 'BACKUP', 'RESTORE' ] }, @_);
}

sub restore_type
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'restore_type', enum => [ 'FTP', 'SCP' ] }, @_);
}

sub restore_host
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'restore_host', validator => \&ibap_value_o2i_string}, @_);
}

sub restore_username
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'restore_username', validator => \&ibap_value_o2i_string}, @_);
}

sub restore_password
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'restore_password', writeonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub restore_directory
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'restore_directory', validator => \&ibap_value_o2i_string}, @_);
}

sub nios_data
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'nios_data', validator => \&ibap_value_o2i_boolean}, @_);
}

sub discovery_data
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'discovery_data', validator => \&ibap_value_o2i_boolean}, @_);
}

sub splunk_app_data
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'splunk_app_data', validator => \&ibap_value_o2i_boolean}, @_);
}


package Infoblox::Grid::RPZ::ThreatDetails;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
            @ISA
            %_allowed_members
            %_ibap_to_object
            %_object_to_ibap
            @_return_fields
            $_object_type
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'FetchThreatStopDetailsResponse';
    register_wsdl_type('ib:FetchThreatStopDetailsResponse','Infoblox::Grid::RPZ::ThreatDetails');

    %_allowed_members = (
                         'active'             => {simple => 'bool', readonly => 1},
                         'danger_level'       => {simple => 'asis', readonly => 1},
                         'description'        => {simple => 'asis', readonly => 1},
                         'first_identified'   => {readonly => 1},
                         'known'              => {simple => 'bool', readonly => 1},
                         'last_seen'          => {readonly => 1},
                         'name'               => {simple => 'asis', readonly => 1},
                         'public_description' => {simple => 'asis', readonly => 1},
                         'short_description'  => {simple => 'asis', readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
 
    %_ibap_to_object = (
                        'first_identified' => \&ibap_i2o_datetime_to_unix_timestamp,
                        'last_seen'        => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    %_object_to_ibap = (
                        'active'             => \&ibap_o2i_ignore,
                        'danger_level'       => \&ibap_o2i_ignore,
                        'description'        => \&ibap_o2i_ignore,
                        'first_identified'   => \&ibap_o2i_ignore,
                        'known'              => \&ibap_o2i_ignore,
                        'last_seen'          => \&ibap_o2i_ignore,
                        'name'               => \&ibap_o2i_ignore,
                        'public_description' => \&ibap_o2i_ignore,
                        'short_description'  => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('known'),
                       tField('name'),
                       tField('active'),
                       tField('first_identified'),
                       tField('last_seen'),
                       tField('short_description'),
                       tField('danger_level'),
                       tField('public_description'),
                       tField('description')
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


package Infoblox::Grid::SyslogServer;

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
            @_syslog_category
);

@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    $_object_type = 'syslog_server';
    register_wsdl_type('ib:syslog_server','Infoblox::Grid::SyslogServer');

    %_allowed_members = (
                         connection_type    => 0,
                         ipv4addr           => 0,
                         address            => 0,
                         local_interface    => 0,
                         message_source     => 0,
                         port               => 0,
                         severity           => 0,
                         only_category_list => 0,
                         category_list      => 0,
                         certificate        => 0,
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       certificate => 'certificate_data_ref',
    );

    %_ibap_to_object = (
       connection_type    => \&ibap_i2o_enums_lc_or_undef,
       local_interface    => \&ibap_i2o_enums_lc_or_undef,
       message_source     => \&ibap_i2o_enums_lc_or_undef,
       severity           => \&ibap_i2o_enums_lc_or_undef,
       only_category_list => \&ibap_i2o_boolean,
   );

    %_object_to_ibap = (
       connection_type    => \&ibap_o2i_enums_lc_or_undef,
       local_interface    => \&ibap_o2i_enums_lc_or_undef,
       message_source     => \&ibap_o2i_enums_lc_or_undef,
       severity           => \&ibap_o2i_enums_lc_or_undef,
       port               => \&ibap_o2i_uint,
       address            => \&ibap_o2i_string,
       only_category_list => \&ibap_o2i_boolean,
       category_list      => \&ibap_o2i_string_array_undef_to_empty,
       certificate        => \&ibap_o2i_cert_data_ref,
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
       tField('address'),
       tField('connection_type'),
       tField('port'),
       tField('local_interface'),
       tField('severity'),
       tField('message_source'),
       tField('only_category_list'),
       tField('category_list'),
       tField('certificate'),

    );

    @_syslog_category = (
                         'NON_CATEGORIZED',
                         'ATP',
                         'DNS_CLIENT',
                         'DNS_CONFIG',
                         'DNS_DATABASE',
                         'DNS_DNSSEC',
                         'DNS_GENERAL',
                         'DNS_LAME_SERVERS',
                         'DNS_NETWORK',
                         'DNS_NOTIFY',
                         'DNS_QUERIES',
                         'DNS_QUERY_REWRITE',
                         'DNS_RESOLVER',
                         'DNS_RESPONSES',
                         'DNS_RPZ',
                         'DNS_SECURITY',
                         'DNS_UPDATE',
                         'DNS_UPDATE_SECURITY',
                         'DNS_XFER_IN',
                         'DNS_XFER_OUT',
                         'DNS_UNBOUND',
                         'DTC_HEALTHD',
                         'DTC_IDNSD',
                         'DHCPD',
                         'NTP',
                         'FTPD',
                         'TFTPD',
                         'CLOUD_API',
                         'MS_DNS_SERVER',
                         'MS_CONNECT_STATUS',
                         'MS_DNS_ZONE',
                         'MS_DHCP_SERVER',
                         'MS_DHCP_LEASE',
                         'MS_DHCP_CLEAR_LEASE',
                         'MS_SITES',
                         'MS_AD_USERS',
                         'AUTH_COMMON',
                         'AUTH_NON_SYSTEM',
                         'AUTH_UI_API',
                         'AUTH_ACTIVE_DIRECTORY',
                         'AUTH_RADIUS',
                         'AUTH_TACACS',
                         'AUTH_LDAP',
                         'OUTBOUND_API',
    );
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args))
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
    $self->message_source('any')  unless $self->message_source();
    $self->local_interface('any') unless $self->local_interface();
    $self->connection_type('udp') unless $self->connection_type();
    $self->severity('debug')      unless $self->severity();

    if (lc $self->connection_type() eq 'stcp' and not $self->port()) {
        $self->port('6514');
    }

    $self->port('514') unless $self->port();

}

sub __ibap_object_type__
{
    return $_object_type;
}

#
#
#

sub connection_type
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'connection_type', enum => ['tcp','udp', 'stcp'] }, @_);
}

sub address
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'address', validator => \&ibap_value_o2i_ipaddr}, @_);
}

sub ipv4addr
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'address', validator => \&ibap_value_o2i_string}, @_);
}

sub local_interface
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'local_interface', enum => ['any','mgmt','lan'] }, @_);
}

sub message_source
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'message_source', enum => ['any','internal','external'] }, @_);
}

sub only_category_list
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'only_category_list', validator => \&ibap_value_o2i_boolean}, @_);
}

sub category_list
{
    my $self=shift;
    return $self->__accessor_array__({name => 'category_list', enum => \@_syslog_category}, @_);
}

sub port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'port', validator => \&ibap_value_o2i_uint}, @_);
}

sub severity
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'severity', enum => \@syslog_enum_values }, @_);
}

sub certificate
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'certificate', validator => \&ibap_value_o2i_string}, @_);
}

#
#
#

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->{__certificate_ref} = $$ibap_object_ref{certificate}{id}
        if defined $$ibap_object_ref{certificate};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    #
    #
    delete $self->{certificate};
}

sub __object_to_ibap__ {

    my ($self, $server, $session, $skipref) = @_;

    if (lc $self->{connection_type} eq 'stcp') {

        return set_error_codes(1103, 'certificate is required in order ' .
            'to establish an STCP connection') unless ($self->{certificate}
            or $self->{__certificate_ref});
    }

    my $write_fields_ref = $self->SUPER::__object_to_ibap__($server, $session, $skipref);

    if ($self->{__certificate_ref} and not $self->{certificate}) {
        my %write_arg = ();
        $write_arg{field} = 'certificate';
        $write_arg{value} = tObjId($self->{__certificate_ref});
        unshift @{$write_fields_ref}, \%write_arg;
    }

    return $write_fields_ref;
}


package Infoblox::Grid::SyslogBackupServer;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            $_object_type
            %_allowed_members
            %_name_mappings
            %_object_to_ibap
            %_reverse_name_mappings
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'syslog_backup_server';
    register_wsdl_type('ib:syslog_backup_server', 'Infoblox::Grid::SyslogBackupServer');



    %_allowed_members = (
                         'address'        => {simple => 'asis', validator => \&ibap_value_o2i_ipaddr},
                         'directory_path' => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'enable'         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'password'       => {writeonly => 1, validator => \&ibap_value_o2i_string},
                         'port'           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'protocol'       => {simple => 'asis', enum => ['FTP', 'SCP']},
                         'username'       => {simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'address' => 'server_ip',
                       'enable'  => 'enabled',
                       'port'    => 'server_port',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_object_to_ibap = (
                        'address'        => \&ibap_o2i_string,
                        'directory_path' => \&ibap_o2i_string,
                        'enable'         => \&ibap_o2i_boolean,
                        'password'       => \&ibap_o2i_string,
                        'port'           => \&ibap_o2i_uint,
                        'protocol'       => \&ibap_o2i_string,
                        'username'       => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('directory_path'),
                       tField('enabled'),
                       tField('protocol'),
                       tField('server_ip'),
                       tField('server_port'),
                       tField('username'),
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

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'enabled'} = 0 unless defined $$ibap_object_ref{'enabled'};
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::NatGroup;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields $_object_type);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    $_object_type = 'NatGroup';
    register_wsdl_type('ib:NatGroup','Infoblox::Grid::NatGroup');
    %_allowed_members = (
                         name    => 1,
                         comment => 0,
                        );

    %_name_mappings = (
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
      );

    %_object_to_ibap =
      (
       name    => \&ibap_o2i_string,
       comment => \&ibap_o2i_string,
      );

    @_return_fields =
      (
       tField('name'),
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

sub __ibap_object_type__ {

    return $_object_type;
}

#
#
#

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}


package Infoblox::Grid::SNMP::TrapNotification;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides
            %_capabilities);

@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'ib_traps';
    register_wsdl_type('ib:ib_traps', 'Infoblox::Grid::SNMP::TrapNotification');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         enable_email    => {simple => 'bool',validator => \&ibap_value_o2i_boolean},
                         enable_trap     => {simple => 'bool',validator => \&ibap_value_o2i_boolean},
                         trap_type       => {simple => 'asis',validator => \&ibap_value_o2i_string, required => 1},
                        );
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       enable_email    => 'email',
                       enable_trap     => 'enabled',
                       trap_type       => 'category',
                      );

    %_ibap_to_object = (
                          trap_email      => \&ibap_i2o_boolean,
                          trap_enabled    => \&ibap_i2o_boolean,
                       );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                 enable_email    => [],
                                 enable_trap     => [],
                                 trap_type       => [],
                               );

    %_object_to_ibap = (
                          enable_email    => \&ibap_o2i_boolean,
                          enable_trap     => \&ibap_o2i_boolean,
                          trap_type       => \&ibap_o2i_string,
                       );

    @_return_fields = (
                        tField('category'),
                        tField('email'),
                        tField('enabled'),
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


#
#
#
sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    $$ibap_object_ref{"email"} = 0 unless defined $$ibap_object_ref{"email"};
    $$ibap_object_ref{"enabled"} = 0 unless defined $$ibap_object_ref{"enabled"};
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

}


package Infoblox::Grid::SNMP::TrapReceiver;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides
            $_return_fields_initialized
            %_capabilities);

@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::SEARCH_ONLY);

BEGIN {
    $_object_type = 'trap_receiver';
    register_wsdl_type('ib:trap_receiver', 'Infoblox::Grid::SNMP::TrapReceiver');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                      'use_flags'            => 1,
                     );

    %_allowed_members = (
                         address         => {simple => 'asis',validator => \&ibap_value_o2i_string},
                         user            => {validator => {'string' => \&ibap_value_o2i_string, "Infoblox::Grid::SNMP::User" => 1}},
                         comment         => {simple => 'asis',validator => \&ibap_value_o2i_string},
                        );
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       comm_string     => 'community_string',
                       user            => 'snmpv3_user',
                      );

    %_ibap_to_object = (
                          snmpv3_user     => \&ibap_i2o_generic_object_convert,
                       );

    %_searchable_fields = (
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                 address         => [],
                                 user            => [],
                                 comment            => [],
                               );

    %_object_to_ibap = (
                          address         => \&ibap_o2i_string,
                          user            => \&ibap_o2i_snmpv3_users,
                          comment         => \&ibap_o2i_string,
                       );

    @_return_fields = (
                        tField('address'),
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

        #
        my $t=Infoblox::Grid::SNMP::User->__new__();

        push @_return_fields,
          tField('snmpv3_user', {
                                sub_fields => $t->__return_fields__(),
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
    return $_object_type;
}

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

package Infoblox::Grid::SNMP::ThresholdTrap;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides
            %_capabilities);

@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'threshold_traps';
    register_wsdl_type('ib:threshold_traps', 'Infoblox::Grid::SNMP::ThresholdTrap');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         trap_reset      => {simple => 'asis',validator => \&ibap_value_o2i_uint},
                         trap_trigger    => {simple => 'asis',validator => \&ibap_value_o2i_uint},
                         trap_type       => {simple => 'asis',validator => \&ibap_value_o2i_string, mandatory => 1},
                        );
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                        trap_reset => "reset_value",
                        trap_trigger => "trigger_value",
                        trap_type => "type",
                      );

    %_ibap_to_object = (
                       );


    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                 trap_reset      => [],
                                 trap_trigger    => [],
                                 trap_type       => [],
                               );

    %_object_to_ibap = (
                          trap_reset      => \&ibap_o2i_uint,
                          trap_trigger    => \&ibap_o2i_uint,
                          trap_type       => \&ibap_o2i_string,
                       );

    @_return_fields = (
                        tField('reset_value'),
                        tField('trigger_value'),
                        tField('type'),
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


package Infoblox::Grid::SNMP::QueriesUser;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides
            $_return_fields_initialized
            %_capabilities);

@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::SEARCH_ONLY);

BEGIN {
    $_object_type = 'snmpv3_query_users';
    register_wsdl_type('ib:queries_users', 'Infoblox::Grid::SNMP::QueriesUser');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                      'use_flags'            => 1,
                     );

    %_allowed_members = (
                         user            => {validator => {'string' => \&ibap_value_o2i_string, "Infoblox::Grid::SNMP::User" => 1}},
                         comment         => {simple => 'asis',validator => \&ibap_value_o2i_string},
                        );
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       user            => 'snmpv3_user',
                      );

    %_ibap_to_object = (
                          snmpv3_user     => \&ibap_i2o_generic_object_convert,
                       );

    %_searchable_fields = (
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                 user            => [],
                                 comment         => [],
                               );

    %_object_to_ibap = (
                          user            => \&ibap_o2i_snmpv3_users,
                          comment         => \&ibap_o2i_string,
                       );

    @_return_fields = (
                        tField('comment'),
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

        #
        my $t=Infoblox::Grid::SNMP::User->__new__();

        push @_return_fields,
          tField('snmpv3_user', {
                                sub_fields => $t->__return_fields__(),
                               }
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


#
package Infoblox::Grid::Reporting;
use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides
            %_capabilities);

@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_MODIFY_ONLY);

BEGIN {
    $_object_type = 'GridReportingProperties';
    register_wsdl_type('ib:GridReportingProperties', 'Infoblox::Grid::Reporting');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0, # No need for implicit defaults
                      'single_serialization' => 0, # No need for single serialization
                     );

    %_allowed_members = (
                         cat_ddns                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_dhcp_fingerprint        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_dhcp_lease              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_dhcp_perf               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_discovery               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_dns_perf                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_dns_query               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_dns_scavenging          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_dns_query_capture       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_ipam                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_system                  => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_ecosystem_subscription  => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_ecosystem_publish       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_audit                   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_cloud                   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_license                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_syslog                  => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_system_capacity         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_dtc                     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cat_network_user            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         data_port                   => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         email_format                => {simple => 'asis', enum => [ 'HTML', 'TEXT']},
                         email_send_as               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         email_subject               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         enabled                     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         mgmt_port                   => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         pdf_paper_orientation       => {simple => 'asis', enum => [ 'LANDSCAPE', 'PORTRAIT']},
                         pdf_paper_size              => {simple => 'asis', enum => [ 'A2', 'A3', 'A4', 'LEGAL', 'LETTER']},
                         reporting_server            => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         reports_per_user            => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         scheduled_backup            => {validator => {'Infoblox::Grid::ScheduledBackup' => 1}},
                         vol_usage_violation_allowed => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         vol_usage_violation_count   => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},

                         enable_dns_top_clients_per_domain      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         domains_for_dns_top_clients_per_domain => {array => 1, validator => \&ibap_value_o2i_string},
                         num_of_dns_top_clients_per_domain      => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         cat_security                           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         rpz_client_limit                       => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         rpz_entry_limit                        => {simple => 'asis', validator => \&ibap_value_o2i_uint},

                         #
                         enable_dns_query_per_ip_block_group => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         ip_block_groups                     => {array => 1, validator => \&ibap_value_o2i_string},
                         indices                             => {array => 1, validator => {'Infoblox::Grid::Reporting::Index' => 1}},

                         #
                         atp_max_ip_rule_stats_per_interval => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         atp_ip_rule_stats_interval_minutes => {simple => 'asis', validator => \&ibap_value_o2i_uint},

                         cluster_mode => {simple => 'asis', enum => ['SINGLE_INDEXER', 'SINGLE_SITE', 'MULTI_SITE']},
                         cluster_sites => {array => 1, validator => {'Infoblox::Grid::Reporting::Site' => 1}},
                         primary_site  => {simple => 'asis', validator => \&ibap_value_o2i_string},

                         syslog_server => {validator => {'Infoblox::Grid::SyslogServer' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       enabled            => 'enable',
                       scheduled_backup   => 'backup_setting',
                       cat_dns_scavenging => 'cat_dns_reclamation',
                       cat_dtc            => 'cat_idns',
                       cat_network_user   => 'cat_user',
                      );

    %_ibap_to_object = (
                        backup_setting              => \&ibap_i2o_generic_object_convert,
                        cat_ddns                    => \&ibap_i2o_boolean,
                        cat_dhcp_fingerprint        => \&ibap_i2o_boolean,
                        cat_dhcp_lease              => \&ibap_i2o_boolean,
                        cat_dhcp_perf               => \&ibap_i2o_boolean,
                        cat_discovery               => \&ibap_i2o_boolean,
                        cat_dns_perf                => \&ibap_i2o_boolean,
                        cat_dns_query               => \&ibap_i2o_boolean,
                        cat_dns_reclamation         => \&ibap_i2o_boolean,
                        cat_dns_query_capture       => \&ibap_i2o_boolean,
                        cat_ipam                    => \&ibap_i2o_boolean,
                        cat_system                  => \&ibap_i2o_boolean,
                        cat_ecosystem_subscription  => \&ibap_i2o_boolean,
                        cat_ecosystem_publish       => \&ibap_i2o_boolean,
                        cat_audit                   => \&ibap_i2o_boolean,
                        cat_cloud                   => \&ibap_i2o_boolean,
                        cat_license                 => \&ibap_i2o_boolean,
                        cat_syslog                  => \&ibap_i2o_boolean,
                        cat_system_capacity         => \&ibap_i2o_boolean,
                        cat_idns                    => \&ibap_i2o_boolean,
                        cat_user                    => \&ibap_i2o_boolean,
                        enable                      => \&ibap_i2o_boolean,

                        enable_dns_top_clients_per_domain  => \&ibap_i2o_boolean,
                        cat_security                       => \&ibap_i2o_boolean,

                        #
                        ip_block_groups                     => \&ibap_i2o_object_list_names,
                        indices                             => \&ibap_i2o_generic_object_list_convert,

                        cluster_sites => \&ibap_i2o_generic_object_list_convert,
                        syslog_server => \&ibap_i2o_generic_object_convert,
                       );

    %_searchable_fields = (
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                backup_setting              => [],
                                cat_ddns                    => [],
                                cat_dhcp_fingerprint        => [],
                                cat_dhcp_lease              => [],
                                cat_dhcp_perf               => [],
                                cat_discovery               => [],
                                cat_dns_perf                => [],
                                cat_dns_query               => [],
                                cat_dns_scavenging          => [],
                                cat_dns_query_capture       => [],
                                cat_ipam                    => [],
                                cat_system                  => [],
                                cat_ecosystem_subscription  => [],
                                cat_ecosystem_publish       => [],
                                cat_audit                   => [],
                                cat_cloud                   => [],
                                cat_license                 => [],
                                cat_syslog                  => [],
                                cat_system_capacity         => [],
                                cat_dtc                     => [],
                                cat_network_user            => [],
                                data_port                   => [],
                                email_format                => [],
                                email_send_as               => [],
                                email_subject               => [],
                                enabled                     => [],
                                mgmt_port                   => [],
                                pdf_paper_orientation       => [],
                                pdf_paper_size              => [],
                                reporting_server            => [],
                                reports_per_user            => [],
                                vol_usage_violation_allowed => [],
                                vol_usage_violation_count   => [],
                                cluster_mode                => [],
                                cluster_sites               => [],
                                primary_site                => [],
                                syslog_server               => [],

                                enable_dns_top_clients_per_domain      => [],
                                domains_for_dns_top_clients_per_domain => [],
                                num_of_dns_top_clients_per_domain      => [],
                                cat_security                           => [],

                                #
                                enable_dns_query_per_ip_block_group => [],
                                ip_block_groups                     => [],
                                indices                             => [],

                                #
                                atp_max_ip_rule_stats_per_interval => [],
                                atp_ip_rule_stats_interval_minutes => [],
                               );

    %_object_to_ibap = (
                        scheduled_backup            => \&__o2i_backup__,
                        cat_ddns                    => \&ibap_o2i_boolean,
                        cat_dhcp_fingerprint        => \&ibap_o2i_boolean,
                        cat_dhcp_lease              => \&ibap_o2i_boolean,
                        cat_dhcp_perf               => \&ibap_o2i_boolean,
                        cat_discovery               => \&ibap_o2i_boolean,
                        cat_dns_perf                => \&ibap_o2i_boolean,
                        cat_dns_query               => \&ibap_o2i_boolean,
                        cat_dns_scavenging          => \&ibap_o2i_boolean,
                        cat_dns_query_capture       => \&ibap_o2i_boolean,
                        cat_ipam                    => \&ibap_o2i_boolean,
                        cat_system                  => \&ibap_o2i_boolean,
                        cat_ecosystem_subscription  => \&ibap_o2i_boolean,
                        cat_ecosystem_publish       => \&ibap_o2i_boolean,
                        cat_audit                   => \&ibap_o2i_boolean,
                        cat_cloud                   => \&ibap_o2i_boolean,
                        cat_license                 => \&ibap_o2i_boolean,
                        cat_syslog                  => \&ibap_o2i_boolean,
                        cat_system_capacity         => \&ibap_o2i_boolean,
                        cat_dtc                     => \&ibap_o2i_boolean,
                        cat_network_user            => \&ibap_o2i_boolean,
                        data_port                   => \&ibap_o2i_uint,
                        email_format                => \&ibap_o2i_string,
                        email_send_as               => \&ibap_o2i_string,
                        email_subject               => \&ibap_o2i_string,
                        enabled                     => \&ibap_o2i_boolean,
                        mgmt_port                   => \&ibap_o2i_uint,
                        pdf_paper_orientation       => \&ibap_o2i_string,
                        pdf_paper_size              => \&ibap_o2i_string,
                        reporting_server            => \&ibap_o2i_string,
                        reports_per_user            => \&ibap_o2i_uint,
                        vol_usage_violation_allowed => \&ibap_o2i_uint,
                        vol_usage_violation_count   => \&ibap_o2i_ignore,
                        cluster_mode                => \&ibap_o2i_string,
                        cluster_sites               => \&ibap_o2i_generic_struct_list_convert,
                        primary_site                => \&ibap_o2i_ignore,
                        syslog_server               => \&ibap_o2i_generic_struct_convert,

                        enable_dns_top_clients_per_domain      => \&ibap_o2i_boolean,
                        domains_for_dns_top_clients_per_domain => \&ibap_o2i_string_array_undef_to_empty,
                        num_of_dns_top_clients_per_domain      => \&ibap_o2i_uint,
                        cat_security                           => \&ibap_o2i_boolean,
                        rpz_client_limit                       => \&ibap_o2i_uint,
                        rpz_entry_limit                        => \&ibap_o2i_uint,
                        indices                                => \&ibap_o2i_generic_struct_list_convert,

                        #
                        enable_dns_query_per_ip_block_group => \&ibap_o2i_boolean,
                        ip_block_groups                     => \&__o2i_groups__,

                        #
                        atp_max_ip_rule_stats_per_interval => \&ibap_o2i_uint,
                        atp_ip_rule_stats_interval_minutes => \&ibap_o2i_uint,

                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('cat_ddns'),
                       tField('cat_dhcp_fingerprint'),
                       tField('cat_dhcp_lease'),
                       tField('cat_dhcp_perf'),
                       tField('cat_discovery'),
                       tField('cat_dns_perf'),
                       tField('cat_dns_query'),
                       tField('cat_dns_reclamation'),
                       tField('cat_dns_query_capture'),
                       tField('cat_ipam'),
                       tField('cat_system'),
                       tField('cat_ecosystem_subscription'),
                       tField('cat_ecosystem_publish'),
                       tField('cat_audit'),
                       tField('cat_idns'),
                       tField('cat_user'),
                       tField('cat_cloud'),
                       tField('cat_license'),
                       tField('cat_syslog'),
                       tField('cat_system_capacity'),
                       tField('data_port'),
                       tField('email_format'),
                       tField('email_send_as'),
                       tField('email_subject'),
                       tField('enable'),
                       tField('mgmt_port'),
                       tField('pdf_paper_orientation'),
                       tField('pdf_paper_size'),
                       tField('reporting_server'),
                       tField('reports_per_user'),
                       tField('vol_usage_violation_allowed'),
                       tField('vol_usage_violation_count'),
                       tField('cluster_mode'),
                       tField('primary_site'),
                       tField('enable_dns_top_clients_per_domain'),
                       tField('domains_for_dns_top_clients_per_domain'),
                       tField('num_of_dns_top_clients_per_domain'),
                       tField('cat_security'),
                       tField('rpz_client_limit'),
                       tField('rpz_entry_limit'),

                       #
                       tField('enable_dns_query_per_ip_block_group'),
                       tField('ip_block_groups',
                              {
                               sub_fields => [
                                              tField('name'),
                                             ]
                              }
                             ),

                       #
                       tField('atp_max_ip_rule_stats_per_interval'),
                       tField('atp_ip_rule_stats_interval_minutes'),
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
                syslog_server  => 'Infoblox::Grid::SyslogServer',
                backup_setting => 'Infoblox::Grid::ScheduledBackup',
                indices        => 'Infoblox::Grid::Reporting::Index',
                cluster_sites  => 'Infoblox::Grid::Reporting::Site',
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

#
#
#

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


sub __o2i_backup__
{
    my ($self, $session, $current, $tempref) = @_;
    #
    $$tempref{$current}->{'source'} = 'REPORTING';
    return ibap_o2i_generic_struct_convert($self, $session, $current, $tempref);
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->{__internal_session_cache_ref__} = $session;

    delete $$ibap_object_ref{primary_site} unless defined $$ibap_object_ref{cluster_sites};
    $$self{cluster_sites} = [] unless defined $$ibap_object_ref{cluster_sites};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub validate_reporting_configuration {

    my $self = shift;

    unless ($self->{__internal_session_cache_ref__}) {

        set_error_codes(1001, 'In order to validate reporting configuration '.
            'the object must have been retrieved from the server first');

        return undef;
    }

    my $session = $self->{__internal_session_cache_ref__};

    my $server = $session->get_ibap_server() || return undef;

    my $result;
    eval {
        $result = $server->ibap_request(
            'ValidateReportingConfiguration', {}, {}
        ); 
    };

    return $server->set_papi_error($@, $self, undef, '1012=1001') if $@;

    return (ref $result eq 'ib:ValidateReportingConfigurationResponse' ?
        $result->{result} : undef);
}


package Infoblox::Grid::Reporting::Index;
use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields %_object_to_ibap @_allowed_indexes);

@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'reportingindex';
    register_wsdl_type('ib:reportingindex', 'Infoblox::Grid::Reporting::Index');

    @_allowed_indexes = (
        'AUDIT',
        'CLOUD',
        'DHCP',
        'DHCP_LEASE',
        'DISCOVERY',
        'DNS',
        'DNS_CAPTURE',
        'DTC',
        'ECOSYSTEM_PUBLISH',
        'ECOSYSTEM_SUBSCRIPTION',
        'IPAM',
        'LICENSE',
        'SECURITY',
        'SYSLOG',
        'SYSTEM',
        'SYSTEM_CAPACITY',
    );

    %_allowed_members = (
                         'max_pct'  => {'simple' => 'asis', 'mandatory' => 1, 'validator' => \&ibap_value_o2i_uint},
                         'name'     => {'simple' => 'asis', 'mandatory' => 1, 'enum' => \@_allowed_indexes},
                         'used_pct' => {'simple' => 'asis', 'readonly' => 1, 'validator' => \&ibap_value_o2i_uint},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'max_pct'  => \&ibap_o2i_uint,
                        'name'     => \&ibap_o2i_string,
                        'used_pct' => \&ibap_o2i_ignore,
                       );

    @_return_fields = (
                       tField('max_pct'),
                       tField('name'),
                       tField('used_pct'),
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
    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    return $self;
}

sub __ibap_object_type__
{
    return $_object_type;
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'name'} = 'DTC' if $$ibap_object_ref{'name'} and $$ibap_object_ref{'name'} eq 'IDNS';

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    return $res;
}

sub __object_to_ibap__
{
	my ($self, $server, $session) = @_;

    $$self{'name'} = 'IDNS' if $$self{'name'} and $$self{'name'} eq 'DTC';

    my $res = $self->SUPER::__object_to_ibap__($server, $session);
    
    $$self{'name'} = 'DTC' if $$self{'name'} and $$self{'name'} eq 'IDNS';
    
    return $res;
}


package Infoblox::Grid::Reporting::Site;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            @ISA
            @_return_fields
            $_object_type
            %_allowed_members
            %_object_to_ibap
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'reportingsiteproperties';
    register_wsdl_type('ib:reportingsiteproperties', 'Infoblox::Grid::Reporting::Site');



    %_allowed_members = (
                         'comment'            => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'priority'           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'reporting_site'     => {mandatory => 1, simple => 'asis', enum => ['single_site', 'site1', 'site2', 'site3',
                                                  'site4', 'site5']},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'comment'            => \&ibap_o2i_string,
                        'priority'           => \&ibap_o2i_uint,
                        'reporting_site'     => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('comment'),
                       tField('priority'),
                       tField('reporting_site'),
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


package Infoblox::Grid::HostNameRewritePolicy;
use strict;              

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
                         
use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides
            %_capabilities);
                         
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'HostNameRewritePolicy';
    register_wsdl_type('ib:HostNameRewritePolicy', 'Infoblox::Grid::HostNameRewritePolicy');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0, # No need for implicit defaults
                      'single_serialization' => 0, # No need for single serialization
                     );

    %_allowed_members = (
                         'name'                  => {'simple' => 'asis', 'mandatory' => 1, 'validator' => \&ibap_value_o2i_string},
                         'valid_characters'      => {'simple' => 'asis', 'mandatory' => 1, 'validator' => \&ibap_value_o2i_string},
                         'replacement_character' => {'simple' => 'asis', 'mandatory' => 1, 'validator' => \&ibap_value_o2i_string},
                         'is_grid_default'       => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'pre_defined'           => {'simple' => 'bool', 'readonly' => 1, 'validator' => \&ibap_value_o2i_boolean},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                        'name' => 'policy_name',
                      );

    %_ibap_to_object = (
                        'is_grid_default' => \&ibap_i2o_boolean,
                        'pre_defined'     => \&ibap_i2o_boolean,
                       );

    %_searchable_fields = ();

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                'name'                  => [],
                                'valid_characters'      => [],
                                'replacement_character' => [],
                                'is_grid_default'       => [],
                                'pre_defined'           => [],
                               );

    %_object_to_ibap = (
                        'name'                  => \&ibap_o2i_string,
                        'valid_characters'      => \&ibap_o2i_string,
                        'replacement_character' => \&ibap_o2i_string,
                        'is_grid_default'       => \&ibap_o2i_boolean,
                        'pre_defined'           => \&ibap_o2i_ignore,
                       );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('policy_name'),
                       tField('valid_characters'),
                       tField('replacement_character'),
                       tField('is_grid_default'),
                       tField('pre_defined'),
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

      $self->{'is_grid_default'} = 'false' unless defined $self->is_grid_default();
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


package Infoblox::Grid::SNMP::IPAMThreshold;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap @_return_fields);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'ipam_threshold';
    register_wsdl_type('ib:ipam_threshold', 'Infoblox::Grid::SNMP::IPAMThreshold');

    %_allowed_members = (
                         'reset_value'                    => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'trigger_value'                  => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint}
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'reset_value'                    => \&ibap_o2i_uint,
                        'trigger_value'                  => \&ibap_o2i_uint,
                       );

    @_return_fields = (
                       tField('reset_value'),
                       tField('trigger_value'),
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

package Infoblox::Grid::SNMP::IPAMTrap;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap @_return_fields);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'ipam_trap';
    register_wsdl_type('ib:ipam_trap', 'Infoblox::Grid::SNMP::IPAMTrap');

    %_allowed_members = (
                         'enable_email_warnings'          => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'enable_snmp_warnings'           => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'enable_email_warnings'          => \&ibap_o2i_boolean,
                        'enable_snmp_warnings'           => \&ibap_o2i_boolean,
                       );

    @_return_fields = (
                       tField('enable_email_warnings'),
                       tField('enable_snmp_warnings'),
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

    foreach ('enable_email_warnings', 'enable_snmp_warnings') {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::HTTPProxyServerSetting;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            %_name_mappings
            %_reverse_name_mappings
            @ISA
            @_return_fields
            $_object_type
            %_allowed_members
            %_object_to_ibap
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'http_proxy_server_setting';
    register_wsdl_type('ib:http_proxy_server_setting', 'Infoblox::Grid::HTTPProxyServerSetting');

    %_allowed_members = (
                         'address'                      => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'certificate'                  => {validator => \&ibap_value_o2i_string},
                         'comment'                      => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'enable_content_inspection'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_proxy'                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'password'                     => {writeonly => 1, validator => \&ibap_value_o2i_string},
                         'port'                         => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'username'                     => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'verify_cname'                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_username_and_password' => {'simple' => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    %_name_mappings = (
                       'certificate'                  => 'cacert',
                       'enable_username_and_password' => 'use_username_passwd',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'address'                      => \&ibap_o2i_string,
                        'certificate'                  => \&ibap_o2i_cert_data_ref,
                        'comment'                      => \&ibap_o2i_string,
                        'enable_content_inspection'    => \&ibap_o2i_boolean,
                        'enable_proxy'                 => \&ibap_o2i_boolean,
                        'password'                     => \&ibap_o2i_string,
                        'port'                         => \&ibap_o2i_uint,
                        'username'                     => \&ibap_o2i_string,
                        'verify_cname'                 => \&ibap_o2i_boolean,
                        'enable_username_and_password' => \&ibap_o2i_boolean,
    );

    @_return_fields = (
                       tField('address'),
                       tField('comment'),
                       tField('enable_content_inspection'),
                       tField('enable_proxy'),
                       tField('port'),
                       tField('username'),
                       tField('verify_cname'),
                       tField('cacert'),
                       tField('use_username_passwd'),
    );
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->{__certificate_data_ref} = $$ibap_object_ref{cacert}{data}
        if defined $$ibap_object_ref{cacert};

    foreach (
        'enable_proxy',
        'enable_content_inspection',
        'verify_cname',
        'use_username_passwd',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    delete $self->{cacert};
}

sub __object_to_ibap__ {

    my ($self, $server, $session, $skipref) = @_;

    my $write_fields_ref = $self->SUPER::__object_to_ibap__($server, $session, $skipref);

    if ($self->{__certificate_data_ref} and not $self->{certificate}) {

        my $write_arg = {
            'field' => 'cacert',
            'value' => tIBType('data_ref', {
                'data_mode' => 'DATA_INLINE',
                'data'      => tString($self->{__certificate_data_ref})
            }),
        };

        unshift @{$write_fields_ref}, $write_arg;
    }

    return $write_fields_ref;
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


package Infoblox::Grid::UpdatesDownloadMemberConfig;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            @ISA
            @_return_fields
            $_object_type
            %_allowed_members
            %_object_to_ibap
            %_ibap_to_object
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'updates_download_member_config';
    register_wsdl_type('ib:updates_download_member_config', 'Infoblox::Grid::UpdatesDownloadMemberConfig');



    %_allowed_members = (
                         'interface' => {enum => ['ANY', 'VIP', 'LAN2', 'MGMT']},
                         'is_online' => {simple => 'bool', readonly => 1},
                         'member'    => {validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'member' => \&ibap_i2o_member_byhostname,
                        'interface' => \&__i2o_interface__,
    );

    %_object_to_ibap = (
                        'interface' => \&__o2i_interface__,
                        'is_online' => \&ibap_o2i_ignore,
                        'member'    => \&ibap_o2i_member_byhostname,
    );

    @_return_fields = (
                       tField('member', {sub_fields => [tField('host_name')]}),
                       tField('interface'),
                       tField('is_online'),
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

sub __o2i_interface__ {

    my ($self, $session, $current, $tempref) = @_;
    return ($$tempref{$current} and $$tempref{$current} eq 'VIP' ?
        (1, 0, tString('LAN1')) : ibap_o2i_string(@_));
}

sub __i2o_interface__ {

    my ($self, $session, $current, $ibap_object_ref) = @_;

    my $val = $$ibap_object_ref{$current};
    return ($val and $val eq 'LAN1' ?
        'VIP' : $val);
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'is_online'} = 0 unless defined $$ibap_object_ref{'is_online'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

package Infoblox::Grid::Dashboard;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            %_capabilities
            @ISA
            @_return_fields
            $_object_type
            %_allowed_members
            %_object_to_ibap
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_MODIFY_ONLY );

BEGIN {

    $_object_type = 'GridDashboard';
    register_wsdl_type('ib:GridDashboard', 'Infoblox::Grid::Dashboard');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 0,
    );

    %_allowed_members = (
                         'atp_critical_event_warning_threshold'         => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'atp_critical_event_critical_threshold'        => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'atp_major_event_warning_threshold'            => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'atp_major_event_critical_threshold'           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'atp_warning_event_warning_threshold'          => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'atp_warning_event_critical_threshold'         => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'rpz_blocked_hit_warning_threshold'            => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'rpz_blocked_hit_critical_threshold'           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'rpz_substituted_hit_warning_threshold'        => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'rpz_substituted_hit_critical_threshold'       => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'rpz_passthru_event_warning_threshold'         => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'rpz_passthru_event_critical_threshold'        => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'analytics_tunneling_event_warning_threshold'  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'analytics_tunneling_event_critical_threshold' => {simple => 'asis', validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'atp_critical_event_warning_threshold'         => \&ibap_o2i_uint,
                        'atp_critical_event_critical_threshold'        => \&ibap_o2i_uint,
                        'atp_major_event_warning_threshold'            => \&ibap_o2i_uint,
                        'atp_major_event_critical_threshold'           => \&ibap_o2i_uint,
                        'atp_warning_event_warning_threshold'          => \&ibap_o2i_uint,
                        'atp_warning_event_critical_threshold'         => \&ibap_o2i_uint,
                        'rpz_blocked_hit_warning_threshold'            => \&ibap_o2i_uint,
                        'rpz_blocked_hit_critical_threshold'           => \&ibap_o2i_uint,
                        'rpz_substituted_hit_warning_threshold'        => \&ibap_o2i_uint,
                        'rpz_substituted_hit_critical_threshold'       => \&ibap_o2i_uint,
                        'rpz_passthru_event_warning_threshold'         => \&ibap_o2i_uint,
                        'rpz_passthru_event_critical_threshold'        => \&ibap_o2i_uint,
                        'analytics_tunneling_event_warning_threshold'  => \&ibap_o2i_uint,
                        'analytics_tunneling_event_critical_threshold' => \&ibap_o2i_uint,
    );

    @_return_fields = (
                       tField('atp_critical_event_warning_threshold'),
                       tField('atp_critical_event_critical_threshold'),
                       tField('atp_major_event_warning_threshold'),
                       tField('atp_major_event_critical_threshold'),
                       tField('atp_warning_event_warning_threshold'),
                       tField('atp_warning_event_critical_threshold'),
                       tField('rpz_blocked_hit_warning_threshold'),
                       tField('rpz_blocked_hit_critical_threshold'),
                       tField('rpz_substituted_hit_warning_threshold'),
                       tField('rpz_substituted_hit_critical_threshold'),
                       tField('rpz_passthru_event_warning_threshold'),
                       tField('rpz_passthru_event_critical_threshold'),
                       tField('analytics_tunneling_event_warning_threshold'),
                       tField('analytics_tunneling_event_critical_threshold'),
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


package Infoblox::Grid::AllEndpoints;

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

    $_object_type = 'AllEndpoints';
    register_wsdl_type('ib:AllEndpoints', 'Infoblox::Grid::AllEndpoints');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'address'            => {simple => 'asis', readonly => 1},
                         'comment'            => {simple => 'asis', readonly => 1},
                         'disable'            => {simple => 'bool', readonly => 1},
                         'subscribing_member' => {readonly => 1},
                         'type'               => {simple => 'asis', readonly => 1},
                         'version'            => {simple => 'asis', readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'address'            => [\&ibap_o2i_string, 'address', 'REGEX'],
                           'comment'            => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'subscribing_member' => [\&ibap_o2i_member_name, 'subscribing_member', 'EXACT'],
                           'type'               => [\&ibap_o2i_string, 'type', 'EXACT'],
                           'version'            => [\&ibap_o2i_string, 'version', 'EXACT'],
    );

    %_name_mappings = (
                       'disable' => 'disabled',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'subscribing_member' => \&ibap_i2o_member_name,
    );

    %_object_to_ibap = (
                        'address'            => \&ibap_o2i_ignore,
                        'comment'            => \&ibap_o2i_ignore,
                        'disable'            => \&ibap_o2i_ignore,
                        'subscribing_member' => \&ibap_o2i_ignore,
                        'type'               => \&ibap_o2i_ignore,
                        'version'            => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('address'),
                       tField('comment'),
                       tField('disabled'),
                       tField('subscribing_member', {sub_fields => [tField('host_name')]}),
                       tField('type'),
                       tField('version'),
    );

    %_return_field_overrides = (
                                'address'            => [],
                                'comment'            => [],
                                'disable'            => [],
                                'subscribing_member' => [],
                                'type'               => [],
                                'version'            => [],
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

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{disabled} = 0 unless defined $$ibap_object_ref{disabled};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}



1;
