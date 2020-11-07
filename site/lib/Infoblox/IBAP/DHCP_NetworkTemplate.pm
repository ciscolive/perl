package Infoblox::DHCP::NetworkTemplate;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object $_return_fields_initialized %_return_field_overrides %_capabilities);
@ISA = qw(Infoblox::IBAPBase);

BEGIN
{
    $_object_type = 'NetworkTemplate';
    register_wsdl_type('ib:NetworkTemplate','Infoblox::DHCP::NetworkTemplate');

	%_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members = (
        allow_any_netmask               => 0,
        authority                       => 0,
        auto_create_reversezone         => 0,
        bootfile                        => 0,
        bootserver                      => 0,
        comment                         => 0,
        ddns_domainname                 => 0,
        override_ddns_domainname         => 0,
        ddns_generate_hostname          => 0,
        ddns_update_fixed_addresses     => 0,
        ddns_server_always_updates      => 0,
        ddns_ttl                        => 0,
        override_ddns_ttl                => 0,
        ddns_use_option81               => 0,
        deny_bootp                      => 0,
        email_list                      => 0,
        enable_ddns                     => 0,
        enable_dhcp_thresholds          => 0,
        enable_email_warnings           => 0,
        enable_snmp_warnings            => 0,
        extattrs                        => {special => 'extensible_attributes'},
        extensible_attributes           => {special => 'extensible_attributes'},
        fixed_address_templates         => 0,
        high_water_mark                 => 0,
        high_water_mark_reset           => 0,
        ignore_dhcp_option_list_request => 0,
        lease_scavenge_time             => 0,
        override_lease_scavenge_time    => 0,
        low_water_mark                  => 0,
        low_water_mark_reset            => 0,
        members                         => 0,
        name                            => 1,
        netmask                         => 0,
        nextserver                      => 0,
        options                         => 0,
        pxe_lease_time                  => 0,
        range_templates                 => 0,
        recycle_leases                  => 0,
        rir                             => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        rir_organization                => {validator => {'Infoblox::Grid::RIR::Organization' => 1}},
        rir_registration_action         => {simple => 'asis', enum => ['NONE', 'CREATE']},
        rir_registration_status         => {simple => 'asis', enum => ['NOT_REGISTERED', 'REGISTERED']},
        send_rir_request                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        update_dns_on_lease_renewal     => 0,
        override_update_dns_on_lease_renewal => 0,
        ipam_trap_settings                   => {'validator' => {'Infoblox::Grid::SNMP::IPAMTrap' => 1}, use => 'override_ipam_trap_settings', use_truefalse => 1},
        override_ipam_trap_settings          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        ipam_threshold_settings              => {'validator' => {'Infoblox::Grid::SNMP::IPAMThreshold' => 1}, use => 'override_ipam_threshold_settings', use_truefalse => 1},
        override_ipam_threshold_settings     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        ipam_email_addresses                 => {array => 1, validator => \&ibap_value_o2i_string, use => 'override_ipam_email_addresses', use_truefalse => 1},
        override_ipam_email_addresses        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        delegated_member                     => {validator => {'Infoblox::DHCP::Member' => 1}},
        cloud_api_compatible                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        logic_filters                     => {array => 1, validator => {string => 1, 'Infoblox::DHCP::Filter::MAC' => 1,
                                              'Infoblox::DHCP::Filter::NAC' => 1, 'Infoblox::DHCP::Filter::Option' => 1},
                                              use => 'override_logic_filters', use_truefalse => 1},
        override_logic_filters            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
        'authority'                         => 'is_authoritative',
        'ddns_generate_hostname'            => 'generate_hostname',
        'ddns_update_fixed_addresses'       => 'update_static_leases',
        'ddns_server_always_updates'        => 'always_update_dns',
        'ddns_use_option81'                 => 'enable_option81',
        'email_list'                        => 'threshold_email_addresses',
        'enable_dhcp_thresholds'            => 'enable_thresholds',
        'enable_email_warnings'             => 'enable_threshold_email_warnings',
        'enable_snmp_warnings'              => 'enable_threshold_snmp_warnings',
        'extattrs'                          => 'extensible_attributes',
        'high_water_mark'                   => 'range_high_water_mark',
        'high_water_mark_reset'             => 'range_high_water_mark_reset',
        'ignore_dhcp_option_list_request'   => 'ignore_client_requested_options',
        'lease_scavenge_time'               => 'client_association_grace_period',
        'low_water_mark'                    => 'range_low_water_mark',
        'low_water_mark_reset'              => 'range_low_water_mark_reset',
        'members'                           => 'dhcp_members',
        'netmask'                           => 'cidr',
        'override_lease_scavenge_time'      => 'use_client_association_grace_period',
        'override_update_dns_on_lease_renewal' => 'use_update_dns_on_lease_renewal',
        'override_ddns_ttl'            => 'use_ddns_ttl',
        'override_ddns_domainname'     => 'use_ddns_domainname',
        'override_ipam_trap_settings'          => 'use_ipam_trap_settings',
        'override_ipam_threshold_settings'     => 'use_ipam_threshold_settings',
        'override_ipam_email_addresses'        => 'use_ipam_email_addresses',
        'logic_filters'          => 'option_logic_filters',
        'override_logic_filters' => 'use_option_logic_filters',
    );

	#
    %_reverse_name_mappings = (
                               'cidr'                            => 'netmask',
                               'is_authoritative'                => 'authority',
                               'generate_hostname'               => 'ddns_generate_hostname',
                               'update_static_leases'            => 'ddns_update_fixed_addresses',
                               'always_update_dns'               => 'ddns_server_always_updates',
                               'enable_option81'                 => 'ddns_use_option81',
                               'threshold_email_addresses'       => 'email_list',
                               'enable_thresholds'               => 'enable_dhcp_thresholds',
                               'enable_threshold_email_warnings' => 'enable_email_warnings',
                               'enable_threshold_snmp_warnings'  => 'enable_snmp_warnings',
                               'extensible_attributes'           => 'extattrs',
                               'range_high_water_mark'           => 'high_water_mark',
                               'range_high_water_mark_reset'     => 'high_water_mark_reset',
                               'ignore_client_requested_options' => 'ignore_dhcp_option_list_request',
                               'client_association_grace_period' => 'lease_scavenge_time',
                               'range_low_water_mark'            => 'low_water_mark',
                               'range_low_water_mark_reset'      => 'low_water_mark_reset',
                               'dhcp_members'                    => 'members',
							   'ms_dhcp_servers'                 => 'members',
                               'use_client_association_grace_period' => 'override_lease_scavenge_time',
                               'use_update_dns_on_lease_renewal' => 'override_update_dns_on_lease_renewal',
                               'use_ddns_ttl'                    => 'override_ddns_ttl',
                               'use_ddns_domainname'             => 'override_ddns_domainname',
                               'use_ipam_trap_settings'          => 'override_ipam_trap_settings',
                               'use_ipam_threshold_settings'     => 'override_ipam_threshold_settings',
                               'use_ipam_email_addresses'        => 'override_ipam_email_addresses',
                               'option_logic_filters'     => 'logic_filters',
                               'use_option_logic_filters' => 'override_logic_filters',
                              );

    $_return_fields_initialized = 0;
    @_return_fields =
      (
       tField('allow_any_netmask'),
       tField('always_update_dns'),
       tField('auto_create_reversezone'),
       tField('broadcast_address_offset'),
       tField('cidr'),
       tField('client_association_grace_period'),
       tField('comment'),
       tField('ddns_domainname'),
       tField('ddns_ttl'),
       tField('domain_name'),
       tField('enable_ddns'),
       tField('enable_option81'),
       tField('enable_pxe_lease_time'),
       tField('enable_threshold_email_warnings'),
       tField('enable_thresholds'),
       tField('enable_threshold_snmp_warnings'),
       tField('generate_hostname'),
       tField('ignore_client_requested_options'),
       tField('is_authoritative'),
       tField('lease_time'),
       tField('name'),
       tField('pxe_lease_time'),
       tField('range_high_water_mark'),
       tField('range_high_water_mark_reset'),
       tField('range_low_water_mark'),
       tField('range_low_water_mark_reset'),
       tField('recycle_leases'),
       tField('rir'),
       tField('rir_registration_action'),
       tField('rir_registration_status'),
       tField('send_rir_request'),
       tField('update_static_leases'),
       tField('use_broadcast_address_offset'),
       tField('use_client_association_grace_period'),
       tField('use_domain_name'),
       tField('use_domain_name_servers'),
       tField('use_enable_ddns'),
       tField('use_enable_option81'),
       tField('use_enable_thresholds'),
       tField('use_generate_hostname'),
       tField('use_ignore_client_requested_options'),
       tField('use_is_authoritative'),
       tField('use_lease_time'),
       tField('use_options'),
       tField('use_pxe_lease_time'),
       tField('use_recycle_leases'),
       tField('use_router_templates'),
       tField('use_threshold_email_addresses'),
       tField('use_update_static_leases'),
       tField('update_dns_on_lease_renewal'),
       tField('use_update_dns_on_lease_renewal'),
       tField('use_ddns_ttl'),
       tField('use_ddns_domainname'),
       tField('use_ipam_trap_settings'),
       tField('use_ipam_threshold_settings'),
       tField('ipam_email_addresses', {'sub_fields' => [tField('email_address')]}),
       tField('use_ipam_email_addresses'),
       tField('delegated_member', return_fields_member_basic_data_no_access_ok()),
       tField('cloud_api_compatible'),
       tField('use_option_logic_filters'),
       tField('option_logic_filters', return_fields_option_logic_filters()),
      );

    push @_return_fields, (
       tField('bootp_properties',
              {
               depth => 1
              }
             ),
       tField('domain_name_servers',
              {
               sub_fields => [tField('address')]
              }
             ),
       tField('dhcp_members',
              {
               sub_fields => [
                              tField('grid_member', return_fields_member_basic_data()),
                             ]
              }),
       tField('options',
              {
               depth => 2
              }
             ),
       tField('domain_name_servers',
              {
               sub_fields => [tField('address')]
              }
             ),
       tField('threshold_email_addresses',
              {
               sub_fields => [ tField('email_address') ]
              }
             ),
       return_fields_templates('fixed_address_templates'),
       return_fields_templates('range_templates'),
       tField('router_templates',
              {
               sub_fields => [ tField('offset') ]
              }
             ),
       return_fields_extensible_attributes(),
       tField('ms_dhcp_servers', { sub_fields => [tField('ms_server',
                                                         { sub_fields => [tField('address'),
                                                                          tField('server_name')]})]}),
      );

    %_return_field_overrides = (
        allow_any_netmask               => [],
        authority                       => [ 'use_is_authoritative' ],
        auto_create_reversezone         => [],
        bootfile                        => [ '!bootp_properties' ],
        bootserver                      => [ '!bootp_properties' ], 
        comment                         => [],
	    ddns_domainname                 => ['use_ddns_domainname'],
        ddns_generate_hostname          => [ 'use_generate_hostname' ],
        ddns_update_fixed_addresses     => [ 'use_update_static_leases' ],
        ddns_server_always_updates      => [],
 	    ddns_ttl				   	    => ['use_ddns_ttl'],
        ddns_use_option81               => [ 'use_enable_option81' ],
        deny_bootp                      => [ '!bootp_properties' ],
        email_list                      => [ 'use_threshold_email_addresses', 'use_enable_thresholds' ],
        enable_ddns                     => [ 'use_enable_ddns' ],
        enable_dhcp_thresholds          => [ 'use_enable_thresholds' ],
        enable_email_warnings           => [ 'use_enable_thresholds' ],
        enable_snmp_warnings            => [ 'use_enable_thresholds' ],
        extattrs                        => [],
        extensible_attributes           => [],
        fixed_address_templates         => [],
        high_water_mark                 => [],
        high_water_mark_reset           => [],
        ignore_dhcp_option_list_request => [ 'use_ignore_client_requested_options' ],
        lease_scavenge_time             => [ 'use_client_association_grace_period'],
        low_water_mark                  => [],
        low_water_mark_reset            => [],
        members                         => ['ms_dhcp_servers'],
        name                            => [],
        netmask                         => [],
        nextserver                      => [ '!bootp_properties' ],
        update_dns_on_lease_renewal         => ['use_update_dns_on_lease_renewal'],
        override_update_dns_on_lease_renewal => [],
        override_ddns_ttl                    => [],
        override_ddns_domainname             => [],
        override_lease_scavenge_time         => [],
        options                         =>
                                            [
                                                'use_options',
                                                'domain_name', 'use_domain_name',
                                                'domain_name_servers', 'use_domain_name_servers',
                                                'lease-time', 'use_lease_time',
                                                'broadcast_address_offset', 'use_broadcast_address_offset',
                                                'router_templates', 'use_router_templates',
                                            ],
        pxe_lease_time                  => [ 'use_pxe_lease_time' ],
        range_templates                 => [],
        recycle_leases                  => [ 'use_recycle_leases' ],
        rir                             => [],
        rir_organization                => [],
        rir_registration_action         => [],
        rir_registration_status         => [],
        send_rir_request                => [],
        ipam_trap_settings                   => ['use_ipam_trap_settings'],
        override_ipam_trap_settings          => [],
        ipam_threshold_settings              => ['use_ipam_threshold_settings'],
        override_ipam_threshold_settings     => [],
        ipam_email_addresses                 => ['use_ipam_email_addresses'],
        override_ipam_email_addresses        => [],
        delegated_member                     => [],
        cloud_api_compatible                 => [],
        logic_filters                     => ['use_option_logic_filters'],
        override_logic_filters            => [],
    );

    %_ibap_to_object = (
        allow_any_netmask                   => \&ibap_i2o_boolean,
        always_update_dns                   => \&ibap_i2o_boolean,
        auto_create_reversezone             => \&ibap_i2o_boolean,
        cidr                                => \&ibap_i2o_netmask_to_cidr,
        dhcp_members                        => \&ibap_i2o_mixed_members_list,
		ms_dhcp_servers                     => \&ibap_i2o_mixed_members_list,
        enable_ddns                         => \&ibap_i2o_boolean,
        enable_option81                     => \&ibap_i2o_boolean,
        enable_threshold_email_warnings     => \&ibap_i2o_boolean,
        enable_thresholds                   => \&ibap_i2o_boolean,
        enable_threshold_snmp_warnings      => \&ibap_i2o_boolean,
        extensible_attributes               => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
        fixed_address_templates             => \&ibap_i2o_templates,
        generate_hostname                   => \&ibap_i2o_boolean,
        is_authoritative                    => \&ibap_i2o_boolean,
        range_templates                     => \&ibap_i2o_templates,
        recycle_leases                      => \&ibap_i2o_boolean,
        rir_organization                    => \&ibap_i2o_generic_object_convert,
        send_rir_request                    => \&ibap_i2o_boolean,
        threshold_email_addresses           => \&ibap_i2o_email_list,
        update_static_leases                => \&ibap_i2o_boolean,
        update_dns_on_lease_renewal         => \&ibap_i2o_boolean,
        use_update_dns_on_lease_renewal     => \&ibap_i2o_boolean,
        use_ddns_ttl                        => \&ibap_i2o_boolean,
        use_ddns_domainname                 => \&ibap_i2o_boolean,
        use_client_association_grace_period => \&ibap_i2o_boolean,
        ipam_trap_settings                  => \&ibap_i2o_generic_object_convert,
        ipam_threshold_settings             => \&ibap_i2o_generic_object_convert,
        ipam_email_addresses                => \&ibap_i2o_email_list,
        delegated_member                    => \&ibap_i2o_mixed_member,
        cloud_api_compatible                => \&ibap_i2o_boolean,
        option_logic_filters                => \&ibap_i2o_ordered_filters,
        use_option_logic_filters            => \&ibap_i2o_boolean,
    );

    %_object_to_ibap = (
        allow_any_netmask                   => \&ibap_o2i_boolean,
        authority                           => \&ibap_o2i_boolean,
        auto_create_reversezone             => \&ibap_o2i_boolean,
        bootfile                            => \&ibap_o2i_ignore, # This is handled in ibap_arg_bootp_props
        bootserver                          => \&ibap_o2i_ignore, # This is handled in ibap_arg_bootp_props
        comment                             => \&ibap_o2i_string,
        ddns_domainname                     => \&ibap_o2i_string,
        ddns_generate_hostname              => \&ibap_o2i_boolean,
        ddns_update_fixed_addresses         => \&ibap_o2i_boolean,
        ddns_server_always_updates          => \&ibap_o2i_boolean,
        ddns_ttl                            => \&ibap_o2i_uint,
        ddns_use_option81                   => \&ibap_o2i_boolean,,
        deny_bootp                          => \&ibap_o2i_ignore, # This is handled in ibap_arg_bootp_props
        email_list                          => \&ibap_o2i_email_list,
        enable_ddns                         => \&ibap_o2i_boolean,
        enable_dhcp_thresholds              => \&ibap_o2i_boolean,
        enable_email_warnings               => \&ibap_o2i_boolean,
        enable_snmp_warnings                => \&ibap_o2i_boolean,
        extattrs                            => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
        extensible_attributes               => \&ibap_o2i_ignore,
        fixed_address_templates             => \&ibap_o2i_fixed_address_templates,
        high_water_mark                     => \&ibap_o2i_uint,
        high_water_mark_reset               => \&ibap_o2i_uint,
        ignore_dhcp_option_list_request     => \&ibap_o2i_ignore, # This is handled in ibap_o2i_common_dhcp_props
        lease_scavenge_time                 => \&ibap_o2i_integer,
        low_water_mark                      => \&ibap_o2i_uint,
        low_water_mark_reset                => \&ibap_o2i_uint,
        members                             => \&ibap_o2i_mixed_members_list,
        name                                => \&ibap_o2i_string,
        netmask                             => \&ibap_o2i_netmask_to_cidr,
        nextserver                          => \&ibap_o2i_ignore, # This is handled in ibap_arg_bootp_props
        options                             => \&ibap_o2i_ignore, # This is handled in ibap_o2i_common_dhcp_props
        pxe_lease_time                      => \&ibap_o2i_ignore, # This is handled in ibap_o2i_common_dhcp_props
        range_templates                     => \&ibap_o2i_range_templates,
        recycle_leases                      => \&ibap_o2i_boolean,
        rir                                 => \&ibap_o2i_ignore,
        rir_organization                    => \&ibap_o2i_rir_organization,
        rir_registration_action             => \&ibap_o2i_string,
        rir_registration_status             => \&ibap_o2i_string,
        send_rir_request                    => \&ibap_o2i_boolean,
        update_dns_on_lease_renewal         => \&ibap_o2i_boolean,
        ipam_trap_settings                  => \&ibap_o2i_generic_struct_convert,
        ipam_threshold_settings             => \&ibap_o2i_generic_struct_convert,
        ipam_email_addresses                => \&ibap_o2i_email_list,
        #
        override_lease_scavenge_time        => \&ibap_o2i_boolean,
        override_update_dns_on_lease_renewal => \&ibap_o2i_boolean,
        override_ddns_ttl                    => \&ibap_o2i_boolean,
        override_ddns_domainname             => \&ibap_o2i_boolean,
        use_is_authoritative                => \&ibap_o2i_boolean,
        use_domain_name                     => \&ibap_o2i_ignore, # This is handled in ibap_o2i_common_dhcp_props
        use_domain_name_servers             => \&ibap_o2i_ignore, # This is handled in ibap_o2i_common_dhcp_props
        use_recycle_leases                  => \&ibap_o2i_boolean,
        use_ignore_client_requested_options => \&ibap_o2i_ignore, # This is handled in ibap_o2i_common_dhcp_props
        use_lease_time                      => \&ibap_o2i_ignore, # This is handled in ibap_o2i_common_dhcp_props
        use_pxe_lease_time                  => \&ibap_o2i_ignore, # This is handled in ibap_o2i_common_dhcp_props
        enable_pxe_lease_time               => \&ibap_o2i_ignore, # This is handled in ibap_o2i_common_dhcp_props 
        use_options                         => \&ibap_o2i_ignore, # This is handled in ibap_o2i_common_dhcp_props
        use_enable_ddns                     => \&ibap_o2i_boolean,
        use_enable_option81                 => \&ibap_o2i_boolean,
        use_generate_hostname               => \&ibap_o2i_boolean,
        use_update_static_leases            => \&ibap_o2i_boolean,
        use_enable_thresholds               => \&ibap_o2i_boolean,
        use_threshold_email_addresses       => \&ibap_o2i_boolean,
        override_ipam_trap_settings         => \&ibap_o2i_boolean,
        override_ipam_threshold_settings    => \&ibap_o2i_boolean,
        override_ipam_email_addresses       => \&ibap_o2i_boolean,
        #
        use_boot_file                       => \&ibap_o2i_ignore,
        use_boot_server                     => \&ibap_o2i_ignore,
        use_next_server                     => \&ibap_o2i_ignore,
        use_deny_bootp                      => \&ibap_o2i_ignore,
        #
        use_routers                         => \&ibap_o2i_ignore,
        use_router_templates                => \&ibap_o2i_ignore,
        routers                             => \&ibap_o2i_ignore,
        use_broadcast_address               => \&ibap_o2i_ignore,
        use_broadcast_address_offset        => \&ibap_o2i_ignore,
        broadcast_address                   => \&ibap_o2i_ignore,

        delegated_member                    => \&ibap_o2i_delegated_member,
        cloud_api_compatible                => \&ibap_o2i_boolean,

        override_logic_filters        => \&ibap_o2i_boolean,
        logic_filters                 => \&ibap_o2i_ordered_filters,
    );

    %_searchable_fields = (
        name => [\&ibap_o2i_string, 'name', 'REGEX'],
        comment => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE' ],
        extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
    );

}

#
#
#

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

        my $t = Infoblox::Grid::RIR::Organization->__new__();
        push @_return_fields, tField('rir_organization', { sub_fields => $t->__return_fields__() });

        $t = Infoblox::Grid::SNMP::IPAMTrap->__new__();
        push @_return_fields, tField('ipam_trap_settings', { sub_fields => $t->__return_fields__() });

        $t = Infoblox::Grid::SNMP::IPAMThreshold->__new__();
        push @_return_fields, tField('ipam_threshold_settings', { sub_fields => $t->__return_fields__() });
    }
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
#
#

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    #
    $ibap_object_ref->{'send_rir_request'}                    = 0 unless defined $ibap_object_ref->{'send_rir_request'};
    $ibap_object_ref->{'use_is_authoritative'}                = 0 unless defined $ibap_object_ref->{'use_is_authoritative'};
    $$ibap_object_ref{'use_client_association_grace_period'}  = 0 unless defined $$ibap_object_ref{'use_client_association_grace_period'};
    $ibap_object_ref->{'use_domain_name'}                     = 0 unless defined $ibap_object_ref->{'use_domain_name'};
    $ibap_object_ref->{'use_broadcast_address_offset'}        = 0 unless defined $ibap_object_ref->{'use_broadcast_address_offset'};
    $ibap_object_ref->{'use_router_templates'}                = 0 unless defined $ibap_object_ref->{'use_router_templates'};
    $ibap_object_ref->{'use_domain_name_servers'}             = 0 unless defined $ibap_object_ref->{'use_domain_name_servers'};
    $ibap_object_ref->{'use_recycle_leases'}                  = 0 unless defined $ibap_object_ref->{'use_recycle_leases'};
    $ibap_object_ref->{'use_ignore_client_requested_options'} = 0 unless defined $ibap_object_ref->{'use_ignore_client_requested_options'};
    $ibap_object_ref->{'use_lease_time'}                      = 0 unless defined $ibap_object_ref->{'use_lease_time'};
    $ibap_object_ref->{'use_pxe_lease_time'}                  = 0 unless defined $ibap_object_ref->{'use_pxe_lease_time'};
    $ibap_object_ref->{'use_options'}                         = 0 unless defined $ibap_object_ref->{'use_options'};
    $ibap_object_ref->{'use_enable_ddns'}                     = 0 unless defined $ibap_object_ref->{'use_enable_ddns'};
    $ibap_object_ref->{'use_enable_option81'}                 = 0 unless defined $ibap_object_ref->{'use_enable_option81'};
    $ibap_object_ref->{'use_generate_hostname'}               = 0 unless defined $ibap_object_ref->{'use_generate_hostname'};
    $ibap_object_ref->{'use_update_static_leases'}            = 0 unless defined $ibap_object_ref->{'use_update_static_leases'};
    $ibap_object_ref->{'use_enable_thresholds'}               = 0 unless defined $ibap_object_ref->{'use_enable_thresholds'};
    $ibap_object_ref->{'use_threshold_email_addresses'}       = 0 unless defined $ibap_object_ref->{'use_threshold_email_addresses'};
    $ibap_object_ref->{'bootp_properties'}{'use_deny_bootp'}  = 0 unless defined $ibap_object_ref->{'bootp_properties'}{'use_deny_bootp'};
    $ibap_object_ref->{'bootp_properties'}{'use_boot_file'}   = 0 unless defined $ibap_object_ref->{'bootp_properties'}{'use_boot_file'};
    $ibap_object_ref->{'bootp_properties'}{'use_boot_server'} = 0 unless defined $ibap_object_ref->{'bootp_properties'}{'use_boot_server'};
    $ibap_object_ref->{'bootp_properties'}{'use_next_server'} = 0 unless defined $ibap_object_ref->{'bootp_properties'}{'use_next_server'};
    $ibap_object_ref->{'use_update_dns_on_lease_renewal'}     = 0 unless defined $ibap_object_ref->{'use_update_dns_on_lease_renewal'};
    $ibap_object_ref->{'update_dns_on_lease_renewal'}         = 0 unless defined $ibap_object_ref->{'update_dns_on_lease_renewal'};
    $ibap_object_ref->{'use_ddns_ttl'}                        = 0 unless defined $ibap_object_ref->{'use_ddns_ttl'};
    $ibap_object_ref->{'use_ddns_domainname'}                 = 0 unless defined $ibap_object_ref->{'use_ddns_domainname'};
    $ibap_object_ref->{'use_ipam_trap_settings'}              = 0 unless defined $ibap_object_ref->{'use_ipam_trap_settings'};
    $ibap_object_ref->{'use_ipam_threshold_settings'}         = 0 unless defined $ibap_object_ref->{'use_ipam_threshold_settings'};
    $ibap_object_ref->{'use_ipam_email_addresses'}            = 0 unless defined $ibap_object_ref->{'use_ipam_email_addresses'};
    $$ibap_object_ref{'use_option_logic_filters'}             = 0 unless defined $$ibap_object_ref{'use_option_logic_filters'};

    #
    $ibap_object_ref->{'allow_any_netmask'}                     = 0 unless defined $ibap_object_ref->{'allow_any_netmask'};
    $ibap_object_ref->{'is_authoritative'}                      = 0 unless defined $ibap_object_ref->{'is_authoritative'};
    $ibap_object_ref->{'auto_create_reversezone'}               = 0 unless defined $ibap_object_ref->{'auto_create_reversezone'};
    $ibap_object_ref->{'generate_hostname'}                     = 0 unless defined $ibap_object_ref->{'generate_hostname'};
    $ibap_object_ref->{'update_statis_leases'}                  = 0 unless defined $ibap_object_ref->{'update_statis_leases'};
    $ibap_object_ref->{'enable_option81'}                       = 0 unless defined $ibap_object_ref->{'enable_option81'}; 
    $ibap_object_ref->{'enable_ddns'}                           = 0 unless defined $ibap_object_ref->{'enable_ddns'};
    $ibap_object_ref->{'ignore_client_requested_options'}       = 0 unless defined $ibap_object_ref->{'ignore_client_requested_options'};
    $ibap_object_ref->{'recycle_leases'}                        = 0 unless defined $ibap_object_ref->{'recycle_leases'};
    $ibap_object_ref->{'enable_thresholds'}                     = 0 unless defined $ibap_object_ref->{'enable_thresholds'};
    $ibap_object_ref->{'enable_threshold_email_warnings'}       = 0 unless defined $ibap_object_ref->{'enable_threshold_email_warnings'};
    $ibap_object_ref->{'enable_threshold_snmp_warnings'}        = 0 unless defined $ibap_object_ref->{'enable_threshold_snmp_warnings'};
    $ibap_object_ref->{'bootp_properties'}{'deny_bootp'}        = 0 unless defined $ibap_object_ref->{'bootp_properties'}{'deny_bootp'};
    $ibap_object_ref->{'always_update_dns'}                     = 0 unless defined $ibap_object_ref->{'always_update_dns'};
    $ibap_object_ref->{'fixed_address_templates'}               = [] unless defined $ibap_object_ref->{'fixed_address_templates'};
    $ibap_object_ref->{'range_templates'}                       = [] unless defined $ibap_object_ref->{'range_templates'};
    $ibap_object_ref->{'domain_name_servers'}                   = [] unless defined $ibap_object_ref->{'domain_name_servers'};
    $ibap_object_ref->{'options'}                               = [] unless defined $ibap_object_ref->{'options'};
    $ibap_object_ref->{'router_templates'}                      = [] unless defined $ibap_object_ref->{'router_templates'};
    $ibap_object_ref->{'threshold_email_addresses'}             = [] unless defined $ibap_object_ref->{'threshold_email_addresses'};

    $ibap_object_ref->{'cloud_api_compatible'}                  = 0 unless defined $ibap_object_ref->{'cloud_api_compatible'};

    #
    $ibap_object_ref->{'ddns_ttl'}                              = 0 unless defined $ibap_object_ref->{'ddns_ttl'};
    $self->members([]);

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    ibap_i2o_bootp_props($self, $session, 'bootp_properties', $ibap_object_ref);

    my %tmp_hash = ( 'common_properties' => $ibap_object_ref );
    ibap_i2o_common_dhcp_props($self, $session, 'common_properties', \%tmp_hash);

    #
    if (defined $ibap_object_ref->{'use_is_authoritative'}) {
        $self->{'use_is_authoritative'} = $ibap_object_ref->{'use_is_authoritative'};
        if ($ibap_object_ref->{'use_is_authoritative'} != 1) {
            delete $self->{'authority'};
        }
    }

    if (defined $ibap_object_ref->{'use_generate_hostname'}) {
        $self->{'use_generate_hostname'} = $ibap_object_ref->{'use_generate_hostname'};
        if ($ibap_object_ref->{'use_generate_hostname'} != 1) {
            delete $self->{'ddns_generate_hostname'};
        }
    }

    if (defined $ibap_object_ref->{'use_update_static_leases'}) {
        $self->{'use_update_static_leases'} = $ibap_object_ref->{'use_update_static_leases'};
        if ($ibap_object_ref->{'use_update_static_leases'} != 1) {
            delete $self->{'ddns_update_fixed_addresses'};
        }
    }

    if (defined $ibap_object_ref->{'use_enable_option81'}) {
        $self->{'use_enable_option81'} = $ibap_object_ref->{'use_enable_option81'};
        if ($ibap_object_ref->{'use_enable_option81'} != 1) {
            delete $self->{'ddns_use_option81'};
        }
    }

    if (defined $ibap_object_ref->{'use_enable_thresholds'}) {
        $self->{'use_enable_thresholds'} = $ibap_object_ref->{'use_enable_thresholds'};
        if ($ibap_object_ref->{'use_enable_thresholds'} != 1) {
            delete $self->{'email_list'};
            delete $self->{'enable_dhcp_thresholds'};
            delete $self->{'enable_email_warnings'};
            delete $self->{'enable_snmp_warnings'};
        }
    }

    if (defined $ibap_object_ref->{'use_threshold_email_addresses'}) {
        $self->{'use_threshold_email_addresses'} = $ibap_object_ref->{'use_threshold_email_addresses'};
        if ($ibap_object_ref->{'use_threshold_email_addresses'} != 1) {
            delete $self->{'email_list'};
        }
    }

    if (defined $ibap_object_ref->{'use_enable_ddns'}) {
        $self->{'use_enable_ddns'} = $ibap_object_ref->{'use_enable_ddns'};
        if ($ibap_object_ref->{'use_enable_ddns'} != 1) {
            delete $self->{'enable_ddns'};
        }
    }

    if (defined $ibap_object_ref->{'use_ignore_client_requested_options'}) {
        $self->{'use_ignore_client_requested_options'} = $ibap_object_ref->{'use_ignore_client_requested_options'};
        if ($ibap_object_ref->{'use_ignore_client_requested_options'} != 1) {
            delete $self->{'ignore_dhcp_option_list_request'};
        }
    }

    if (defined $ibap_object_ref->{'use_pxe_lease_time'}) {
        $self->{'use_pxe_lease_time'} = $ibap_object_ref->{'use_pxe_lease_time'};
        if ($ibap_object_ref->{'use_pxe_lease_time'} != 1) {
            delete $self->{'pxe_lease_time'};
        }
    }

    if (defined $ibap_object_ref->{'use_recycle_leases'}) {
        $self->{'use_recycle_leases'} = $ibap_object_ref->{'use_recycle_leases'};
        if ($ibap_object_ref->{'use_recycle_leases'} != 1) {
            delete $self->{'recycle_leases'};
        }
    }

    if (defined $ibap_object_ref->{'bootp_properties'}{'use_deny_bootp'}) {
        $self->{'use_deny_bootp'} = $ibap_object_ref->{'bootp_properties'}{'use_deny_bootp'};
        if ($ibap_object_ref->{'bootp_properties'}{'use_deny_bootp'} != 1) {
            delete $self->{'deny_bootp'};
        }
    }

    if (defined $ibap_object_ref->{'bootp_properties'}{'use_boot_file'}) {
        $self->{'use_boot_file'} = $ibap_object_ref->{'bootp_properties'}{'use_boot_file'};
        if ($ibap_object_ref->{'bootp_properties'}{'use_boot_file'} != 1) {
            delete $self->{'bootfile'};
        }
    }

    if (defined $ibap_object_ref->{'bootp_properties'}{'use_boot_server'}) {
        $self->{'use_boot_server'} = $ibap_object_ref->{'bootp_properties'}{'use_boot_server'};
        if ($ibap_object_ref->{'bootp_properties'}{'use_boot_server'} != 1) {
            delete $self->{'bootserver'};
        }
    }

    if (defined $ibap_object_ref->{'bootp_properties'}{'use_next_server'}) {
        $self->{'use_next_server'} = $ibap_object_ref->{'bootp_properties'}{'use_next_server'};
        if ($ibap_object_ref->{'bootp_properties'}{'use_next_server'} != 1) {
            delete $self->{'nextserver'};
        }
    }

    #
    $self->{'override_ddns_ttl'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_ttl'});
    $self->{'override_ddns_domainname'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_domainname'});
    $self->{'override_update_dns_on_lease_renewal'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_update_dns_on_lease_renewal'});
    $self->{'override_lease_scavenge_time'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_client_association_grace_period'});
    $self->{'override_ipam_trap_settings'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_ipam_trap_settings'});
    $self->{'override_ipam_threshold_settings'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_ipam_threshold_settings'});
    $self->{'override_ipam_email_addresses'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_ipam_email_addresses'});
    $self->{'override_logic_filters'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_option_logic_filters'});

    return $res;
}

sub __object_to_ibap__
{
    my ($self, $server, $session, $skipref) = @_;

    #
    #
    #
    #
    #
    #
    #
    #
    if (not defined $self->{'ddns_server_always_updates'}) {
        $self->ddns_server_always_updates('true');
    }

    #
    #
    #
    if (((not defined $self->allow_any_netmask()) || $self->allow_any_netmask() ne 'true')
        && (not defined $self->netmask()))
    {
        $self->netmask("255.0.0.0");
    }

    #
    if (defined $self->{'email_list'} or
        defined $self->{'enable_dhcp_thresholds'} or
        defined $self->{'enable_email_warnings'} or
        defined $self->{'enable_snmp_warnings'}) 
    {
        $self->{'use_enable_thresholds'} = 1;
    } else {
        $self->{'use_enable_thresholds'} = 0;
    }

    my $write_fields_ref = $self->SUPER::__object_to_ibap__($server, $session, $skipref);

    my @bootp_options = ibap_arg_bootp_props($self, $session, '',$self);
    if (@bootp_options) {
        my $success=shift @bootp_options;
        if ($success) {
            my $ignore_value=shift @bootp_options;
            unless ($ignore_value) {
                my %write_arg;
                $write_arg{'field'} = 'bootp_properties';
                $write_arg{'value'} = shift @bootp_options;
                push @{$write_fields_ref}, \%write_arg;
            }
        }
    }

    my @common_options = ibap_o2i_common_dhcp_props($self, $session, '',$self);
    if (@common_options) {
        my $success=shift @common_options;
        if ($success) {
            my $ignore_value = shift @common_options;
            unless ($ignore_value) {

                my $sub_write_args_ref = $common_options[0]->value();
                while(my ($key, $value) = each(%{$sub_write_args_ref})) {
                    my %write_arg;
                    $write_arg{'field'} = $key;
                    $write_arg{'value'} = $value;
                    unshift @{$write_fields_ref}, \%write_arg;
                }
            }
        }
    }

    return $write_fields_ref;
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


sub allow_any_netmask
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'allow_any_netmask', validator => \&ibap_value_o2i_boolean}, @_);
}

sub authority
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'authority', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_is_authoritative'}}, @_);
}

sub auto_create_reversezone {
    my $self = shift;
    return $self->__accessor_scalar__({name => 'auto_create_reversezone', validator => \&ibap_value_o2i_boolean}, @_);
}

sub bootfile
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'bootfile', validator => \&ibap_value_o2i_string, use => \$self->{'use_boot_file'}}, @_);
}

sub bootserver
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'bootserver', validator => \&ibap_value_o2i_string, use => \$self->{'use_boot_server'}}, @_);
}

sub comment
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
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

sub ddns_generate_hostname
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ddns_generate_hostname', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_generate_hostname'}}, @_);
}

sub ddns_update_fixed_addresses
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ddns_update_fixed_addresses', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_update_static_leases'}}, @_);
}

sub ddns_server_always_updates
{
    my $self = shift;
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

sub ddns_use_option81
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ddns_use_option81', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_enable_option81'}}, @_);
}

sub deny_bootp
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'deny_bootp', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_deny_bootp'}}, @_);
}

sub email_list
{
    my $self = shift;
    return $self->__accessor_array__({name => 'email_list', validator => { 'string' => \&ibap_value_o2i_string }, use => \$self->{'use_threshold_email_addresses'}}, @_);
}

sub enable_ddns
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'enable_ddns', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_enable_ddns'}}, @_);
}

sub enable_dhcp_thresholds
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'enable_dhcp_thresholds', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_email_warnings
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'enable_email_warnings', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_snmp_warnings
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'enable_snmp_warnings', validator => \&ibap_value_o2i_boolean}, @_);
}

sub fixed_address_templates
{
    my $self = shift;
    return $self->__accessor_array__({name => 'fixed_address_templates', validator => {'Infoblox::DHCP::Template' => 1}}, @_);
}

sub high_water_mark
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'high_water_mark', validator => \&ibap_value_o2i_uint}, @_);
}

sub high_water_mark_reset
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'high_water_mark_reset', validator => \&ibap_value_o2i_uint}, @_);
}

sub ignore_dhcp_option_list_request
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ignore_dhcp_option_list_request', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_ignore_client_requested_options'}}, @_);
}

sub lease_scavenge_time
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'lease_scavenge_time', use => \$self->{'override_lease_scavenge_time'}, use_truefalse => 1, validator => \&ibap_value_o2i_int},@_);
}

sub override_lease_scavenge_time
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_lease_scavenge_time', validator => \&ibap_value_o2i_boolean}, @_);
}

sub low_water_mark
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'low_water_mark', validator => \&ibap_value_o2i_uint}, @_);
}

sub low_water_mark_reset
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'low_water_mark_reset', validator => \&ibap_value_o2i_uint}, @_);
}

sub members
{
    my $self = shift;
    return $self->__accessor_array__({name => 'members', validator => { 'Infoblox::DHCP::Member' => 1, 'Infoblox::DHCP::MSServer' => 1 }, nomixed => 1}, @_);
}

sub name
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub netmask
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'netmask', validator => \&ibap_value_o2i_string}, @_);
}

sub nextserver
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'nextserver', validator => \&ibap_value_o2i_string, use => \$self->{'use_next_server'}}, @_);
}

sub options
{
    my $self = shift;
    return ibap_accessor_dhcp_options($self, 'options', @_);
}

sub pxe_lease_time
{
    my $self = shift;
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

sub range_templates
{
    my $self = shift;
    return $self->__accessor_array__({name => 'range_templates', validator => {'Infoblox::DHCP::Template' => 1}}, @_);
}

sub recycle_leases
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'recycle_leases', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_recycle_leases'}}, @_);
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

1;
