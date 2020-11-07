package Infoblox::DNS::Host;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides
            %_capabilities $newhostaddress);

@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'HostRecord';
    register_wsdl_type('ib:HostRecord', 'Infoblox::DNS::Host');

    $newhostaddress = Infoblox::__options('hostaddress');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members = (
                         aliases        	   => 0,
                         comment        	   => 0,
                         configure_for_dns     => 0,
                         disable        	   => 0,
                         ipv4addrs  		   => 0,
                         ipv6addrs  		   => 0,
                         name       		   => 1,
                         ttl            	   => 0,
                         views      		   => 0,
                         zone                  => -1,
                         extattrs              => 0,
                         extensible_attributes => 0,
                         network_view          => 0,
                         rrset_order           => 0,
                         dns_name              => -1,
                         dns_aliases           => -1,
                         disable_discovery           => {validator => \&ibap_value_o2i_boolean},
                         enable_immediate_discovery  => {writeonly => 1, validator => \&ibap_value_o2i_boolean},
                         snmp_credential             => {validator => {'Infoblox::Grid::Discovery::SNMPCredential' => 1}, skip_accessor => 1}, # The method is defined in the package. This is necessary for ibap_o2i_generic_struct_convert.
                         snmp3_credential            => {validator => {'Infoblox::Grid::Discovery::SNMP3Credential' => 1}, skip_accessor => 1}, # The method is defined in the package. This is necesary for ibap_o2i_generic_struct_convert.
                         cli_credentials             => {'array' => 1, validator => {'Infoblox::Grid::Discovery::CLICredential' => 1}, 'use' => 'override_cli_credentials', 'use_truefalse' => 1},
                         override_credential         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_snmp3_credential   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_cli_credentials    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         device_type                 => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         device_vendor               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         device_location             => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         device_description          => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         allow_telnet                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cloud_info                  => {readonly => 1, validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
                         ms_ad_user_data             => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
                         ddns_protected              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         last_queried                => {readonly => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'name'     => 'fqdn' ,
                       'dns_name' => 'dns_fqdn',
                       'views'    => 'view' ,
                       'zone'     => 'parent' ,
                       'ipv4addrs' => 'addresses' ,
                       'ipv6addrs' => 'ipv6_addresses' ,
                       'disable'   => 'disabled' ,
                       'configure_for_dns'   => 'configure_for_dns' ,
                       'extattrs'  => 'extensible_attributes',
                       'disable_discovery'         => 'enable_discovery',
                       'snmp_credential'           => 'snmpv1v2_credential',
                       'snmp3_credential'          => 'snmpv3_credential',
                       'override_snmp3_credential' => 'use_snmpv3_credential',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'aliases'     => \&__i2o_aliases__,
                        'addresses'   => \&__i2o_addresses__,
                        'ipv6_addresses' => \&__i2o_ipv6_addresses__,
                        'configure_for_dns'    => \&ibap_i2o_boolean,
                        'disabled'    => \&ibap_i2o_boolean,
                        'view'        => \&ibap_i2o_generic_object_convert_to_list_of_one,
                        'extensible_attributes'    => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'network_view'          => \&ibap_i2o_generic_object_convert,
                        'rrset_order'  => \&ibap_i2o_enums_lc_or_undef,
                        'enable_discovery'       => \&ibap_i2o_boolean_reverse,
                        'snmpv1v2_credential'    => \&ibap_i2o_generic_object_convert,
                        'snmpv3_credential'      => \&ibap_i2o_generic_object_convert,
                        'cli_credentials'        => \&ibap_i2o_generic_object_list_convert,
                        'override_credential'    => \&ibap_i2o_boolean,
                        'use_snmpv3_credential'  => \&ibap_i2o_boolean,
                        'cloud_info'             => \&ibap_i2o_generic_object_convert,
                        'ms_ad_user_data'        => \&ibap_i2o_generic_object_convert,
                        'last_queried'          => \&ibap_i2o_datetime_to_unix_timestamp,
                       );

	%_return_field_overrides = (
								'aliases'      			=> [],
                                'dns_aliases'           => [],
								'comment'      			=> [],
								'configure_for_dns'     => [],
								'disable'      			=> [],
                                'extattrs'              => [],
								'extensible_attributes' => [],
								'ipv4addrs'    			=> [],
								'ipv6addrs'    			=> [],
								'name'         			=> [],
                                'dns_name'              => [],
								'ttl'          			=> ['use_ttl'],
								'views'            		=> [],
								'zone'                  => [],
								'network_view'          => [],
                                'rrset_order'           => [],
                                'disable_discovery'         => [],
                                'snmp_credential'           => ['override_credential', 'snmp3_credential', 'use_snmpv3_credential'],
                                'snmp3_credential'          => ['override_credential', 'use_snmpv3_credential'],
                                'cli_credentials'           => ['override_cli_credentials'],
                                'override_credential'       => [],
                                'override_snmp3_credential' => [],
                                'override_cli_credentials'  => [],
                                'device_type'               => [],
                                'device_vendor'             => [],
                                'device_location'           => [],
                                'device_description'        => [],
                                'allow_telnet'              => [],
                                'cloud_info'                => [],
                                'ms_ad_user_data'           => [],
                                'ddns_protected'            => [],
                                'last_queried'              => [],
							   );

    %_object_to_ibap = (
                        'RETURN_FIELDS'              => \&ibap_o2i_ignore,
                        'aliases'                    => \&__o2i_aliases__,
                        'dns_aliases'                => \&ibap_o2i_ignore,
                        'comment'                    => \&ibap_o2i_string,
                        'configure_for_dns'          => \&ibap_o2i_boolean,
                        'disable'                    => \&ibap_o2i_boolean,
                        'extattrs'                   => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'      => \&ibap_o2i_ignore,
                        'ipv4addrs'                  => \&__o2i_ipv4addrs__,
                        'ipv6addrs'                  => \&__o2i_ipv6addrs__,
                        'name'                       => \&ibap_o2i_string_undef_to_empty,
                        'dns_name'                   => \&ibap_o2i_ignore,
                        'ttl'                        => \&ibap_o2i_uint,
                        'use_ttl'                    => \&ibap_o2i_boolean,
                        'views'                      => \&ibap_o2i_view,
                        'zone'                       => \&ibap_o2i_ignore,
                        'network_view'               => \&ibap_o2i_network_view,
                        'rrset_order'                => \&ibap_o2i_enums_lc_or_undef,
                        'disable_discovery'          => \&ibap_o2i_boolean_reverse,
                        'enable_immediate_discovery' => \&ibap_o2i_boolean,
                        'snmp_credential'            => \&ibap_o2i_generic_struct_convert,
                        'snmp3_credential'           => \&ibap_o2i_generic_struct_convert,
                        'cli_credentials'            => \&ibap_o2i_generic_struct_list_convert,
                        'override_credential'        => \&ibap_o2i_boolean,
                        'override_snmp3_credential'  => \&ibap_o2i_boolean,
                        'override_cli_credentials'   => \&ibap_o2i_boolean,
                        'device_type'                => \&ibap_o2i_string,
                        'device_vendor'              => \&ibap_o2i_string,
                        'device_location'            => \&ibap_o2i_string,
                        'device_description'         => \&ibap_o2i_string,
                        'allow_telnet'               => \&ibap_o2i_boolean,
                        'cloud_info'                 => \&ibap_o2i_ignore,
                        'ms_ad_user_data'            => \&ibap_o2i_ignore,
                        'ddns_protected'             => \&ibap_o2i_boolean,
                        'last_queried'               => \&ibap_o2i_ignore,

                        #
                        'use_snmp_credential'         => \&ibap_o2i_ignore,
                        'use_snmp3_credential'        => \&ibap_o2i_ignore,
                       );

    %_searchable_fields = (
                           comment      => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],
                           ipv4addr     => [\&__o2i_ipv4addr_search__ ,'addresses', 'LIST_IN'],
                           ipv6addr     => [\&__o2i_ipv6addr_search__ ,'ipv6_addresses', 'LIST_IN'],
                           mac          => [\&__o2i_mac_search__ ,'addresses', 'LIST_IN'],
                           alias        => [\&__o2i_alias_search__ ,'aliases', 'LIST_IN'],
                           name         => [\&ibap_o2i_string ,'fqdn'   , 'REGEX'],
                           view         => [\&ibap_o2i_view   ,'view'   , 'EXACT'],
                           views        => [\&ibap_o2i_view   ,'view'   , 'EXACT'],
                           zone         => [\&ibap_o2i_string ,'parent', 'EXACT'],
                           extattrs     => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           network_view => [\&ibap_o2i_network_view ,'network_view', 'EXACT'],

                          );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('comment'),
                       tField('configure_for_dns'),
                       tField('disabled'),
                       tField('fqdn'),
                       tField('dns_fqdn'),
                       tField('parent'),
                       tField('use_ttl'),
                       tField('ttl'),
                       tField('view'),
                       tField('rrset_order'),
                       tField('enable_discovery'),
                       tField('snmpv1v2_credential', {'depth' => 1}),
                       tField('cli_credentials', {'depth' => 1}),
                       tField('override_credential'),
                       tField('use_snmpv3_credential'),
                       tField('override_cli_credentials'),
                       tField('device_type'),
                       tField('device_vendor'),
                       tField('device_location'),
                       tField('device_description'),
                       tField('allow_telnet'),
                       tField('ddns_protected'),
                       tField('last_queried'),
                      );

    push @_return_fields, tField('aliases',
                                 {
                                  sub_fields   => [
                                                   tField('alias'),
                                                   tField('dns_alias'),
                                                  ],
                                 }
                                );

    push @_return_fields, return_fields_extensible_attributes();
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
        my $tmp;

        if ($newhostaddress) {
            $tmp = Infoblox::DHCP::HostAddr->__new__();
            push @_return_fields, tField('addresses', {sub_fields => $tmp->__return_fields__()});

            $tmp = Infoblox::DHCP::IPv6HostAddr->__new__();
            push @_return_fields, tField('ipv6_addresses', {sub_fields => $tmp->__return_fields__()});
        }
        else {
            $tmp = Infoblox::DHCP::FixedAddr->__new__();
            push @_return_fields, tField('addresses', {sub_fields => $tmp->__get_host_address_return_fields__()});

            $tmp = Infoblox::DHCP::IPv6FixedAddr->__new__();
            push @_return_fields, tField('ipv6_addresses', {sub_fields => $tmp->__get_host_address_return_fields__()});
        }

        $tmp = Infoblox::DHCP::View->__new__();
        push @_return_fields,tField('network_view',{ default_no_access_ok => 1, sub_fields => $tmp->__return_fields__(),});

        #
        $tmp = Infoblox::DNS::View->__new__();

        push @_return_fields,
          tField('view', {
                          default_no_access_ok => 1,
                          sub_fields => $tmp->__return_fields__(),
                         }
                );

        $tmp = Infoblox::Grid::Discovery::SNMP3Credential->__new__();
        push @_return_fields,
          tField('snmpv3_credential', {
                                sub_fields => $tmp->__return_fields__(),
                               },
                );

        $tmp = Infoblox::Grid::CloudAPI::Info->__new__();
        push @_return_fields,
          tField('cloud_info', {
                                sub_fields => $tmp->__return_fields__()
                               }
                );
        $tmp = Infoblox::Grid::MSServer::AdUser::Data->__new__();
        push @_return_fields,
            tField('ms_ad_user_data', {sub_fields => $tmp->__return_fields__()});
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

sub __search_mapping_hook_pre__
{
    my ($self, $session, $type, $argsref, $out_search_fields_ref, $out_search_types_ref, $out_search_matches_ref) = @_;

    #
    #
    #

    #

    if( defined $argsref->{'mac'} && $argsref->{'mac'} eq '00:00:00:00:00:00') {
        delete $argsref->{'mac'};
        if ($type eq 'get') {
            $out_search_fields_ref->{'addresses'} = ibap_readfield_simple_string('HostAddress','match_option', 'RESERVED', 'mac_address=00:00:00:00:00:00');
            $out_search_types_ref->{'addresses'} = 'LIST_IN';
            $out_search_matches_ref->{'addresses'} = undef;
        } else {
            $out_search_fields_ref->{'addresses'} = ibap_readfieldlist_simple_string('HostAddress','match_option', 'RESERVED', 'EXACT');
            $out_search_types_ref->{'addresses'} = 'LIST_INTERSECT';
            $out_search_matches_ref->{'addresses'} = undef;
        }
    }

    #
    if( defined $argsref->{'zone'} && not defined $argsref->{'view'} && not defined $argsref->{'views'}) {
        $out_search_fields_ref->{'view'} = ibap_readfield_simple('View','is_default',tBool(1),'view=(default view)');
        $out_search_types_ref->{'view'}='EXACT';
        $out_search_matches_ref->{'view'} = undef;
    }

    return 1;
}

#
sub __search_mapping_hook_post__
{
    my ($self, $session, $type, $argsref, $out_search_fields_ref, $out_search_types_ref, $out_search_matches_ref) = @_;

    if ($type eq 'get') {
        if (defined $out_search_types_ref->{'addresses'} && $out_search_types_ref->{'addresses'} eq 'LIST_INTERSECT') {
            $out_search_types_ref->{'addresses'} = 'LIST_IN';
            }

        if (defined $out_search_types_ref->{'ipv6_addresses'} && $out_search_types_ref->{'ipv6_addresses'} eq 'LIST_INTERSECT') {
            $out_search_types_ref->{'ipv6_addresses'} = 'LIST_IN';
        }
    }

    return 1;
}

#
#
#

sub __i2o_aliases__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my (@alias, @dns_alias);

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        my @list=@{$$ibap_object_ref{$current}};

        foreach my $alias (@list) {
            push @alias, ${$alias}{'alias'};
            push @dns_alias, ${$alias}{'dns_alias'};
        }
    }

    $self->aliases(\@alias);
    $self->dns_aliases(\@dns_alias);

    return;
}

sub __host_address_to_fixed_address_convert__
{
    my ($self, $current_address, $session, $return_object_cache_ref) = @_;

    my $server = $session->get_ibap_server();

    my (@custom_options, $network_out, $network_in, $network_view);

    $network_in=${$current_address}{'network'};

    if ($network_in) {
        my ($address,$netmask);

        $address=${$network_in}{'address'};
        $netmask=${$network_in}{'cidr'};
        $network_view=${$network_in}{'network_view'};

        my $t = mask_to_bits($netmask);
        $netmask = $t if $t;

        $network_out=$address . '/' . $netmask;
    }

    my $fixed_addr;
    if ($network_view) {
        my $papi_network_view;
        #
        if ($return_object_cache_ref && defined $$return_object_cache_ref{'__internal_premade_cache__'} &&
            defined $$return_object_cache_ref{'__internal_ready_objects__'}{${$network_view}{'object_id'}{'id'}}) {
            $papi_network_view=$$return_object_cache_ref{'__internal_ready_objects__'}{${$network_view}{'object_id'}{'id'}};
        }
        else {
            $papi_network_view = Infoblox::DHCP::View->__new__();
            $papi_network_view->__ibap_to_object__($network_view, $server, $session, $return_object_cache_ref);
            $$return_object_cache_ref{'__internal_ready_objects__'}{${$network_view}{'object_id'}{'id'}} = $papi_network_view;
        }

        $fixed_addr = Infoblox::DHCP::FixedAddr -> new(ipv4addr         => ${$current_address}{'address'},
                                                       mac              => ${$current_address}{'mac_address'},
                                                       network          => $network_out,
                                                       network_view     => $papi_network_view,
                                                       configure_for_dhcp => 'false',
                                                      );
    } else {
        $fixed_addr = Infoblox::DHCP::FixedAddr -> new(ipv4addr         => ${$current_address}{'address'},
                                                       mac              => ${$current_address}{'mac_address'},
                                                       network          => $network_out,
                                                       configure_for_dhcp => 'false',
                                                      );
    }

    if (${$current_address}{'configure_for_dhcp'}) {
        $fixed_addr->configure_for_dhcp(ibap_value_i2o_boolean(${$current_address}{'configure_for_dhcp'}));
    }

    if (${$current_address}{'match_option'}) {
        $fixed_addr->match_client(ibap_value_i2o_match_options(${$current_address}{'match_option'}));
    }

    my %current_address_copy = %{$current_address};

    #
    if (defined $current_address->{'use_custom_options'}) {
        $current_address_copy{'use_options'} = $current_address->{'use_custom_options'};
    }
    if (defined $current_address->{'custom_options'}) {
        $current_address_copy{'options'} = $current_address->{'custom_options'};
    }

    #
    if (defined $current_address->{'pxe_lease_time_enabled'}) {
        $current_address_copy{'enable_pxe_lease_time'} = $current_address->{'pxe_lease_time_enabled'};
    }

    #
    #
    if (defined $current_address->{'use_ignore_dhcp_param_request_list'}) {
        $current_address_copy{'use_ignore_client_requested_options'} = $current_address->{'use_ignore_dhcp_param_request_list'};
    }
    if (defined $current_address->{'ignore_dhcp_param_request_list'}) {
        $current_address_copy{'ignore_client_requested_options'} = $current_address->{'ignore_dhcp_param_request_list'};
    }

    #
    #
    #
    my %tmp_hash = ( 'dummy_name' => \%current_address_copy );
    ibap_i2o_bootp_props($fixed_addr, $session, 'dummy_name', \%tmp_hash);
    ibap_i2o_common_dhcp_props($fixed_addr, $session, 'dummy_name', \%tmp_hash);

    #
    $fixed_addr->{'deny_bootp'} = 'false' unless defined $fixed_addr->{'deny_bootp'};

    return $fixed_addr;
}

sub __i2o_addresses__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @out_addresslist;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        if ($newhostaddress) {
            return ibap_i2o_generic_object_list_convert(@_);
        }
        else {
            my @addresslist=@{$$ibap_object_ref{$current}};
            my @out_addresslist;

            foreach my $current_address (@addresslist) {
                if (${$current_address}{'mac_address'} || ${$current_address}{'network'}) {
                    my $fixed_addr = __host_address_to_fixed_address_convert__($self, $current_address, $session, $return_object_cache_ref);
                    push @out_addresslist, $fixed_addr;
                } else {
                    push @out_addresslist, ${$current_address}{'address'};
                }
            }
            return \@out_addresslist;
        }
    } else {
        return [];
    }
}

sub __i2o_ipv6_addresses__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;


    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        if ($newhostaddress) {
            return ibap_i2o_generic_object_list_convert(@_);
        }
        else {
            my @addresslist=@{$$ibap_object_ref{$current}};
            my @out_addresslist;

            foreach my $current_address (@addresslist) {
                if (${$current_address}{'duid'} || ${$current_address}{'network'}) {
                    #
                    #

                    my $fixed_addr = Infoblox::DHCP::IPv6FixedAddr->__new__();
                    $fixed_addr->__ibap_to_object__($current_address, $session->get_ibap_server(), $session, $return_object_cache_ref);

                    #
                    #
                    $fixed_addr->ipv6addr(${$current_address}{'address'}) if ${$current_address}{'address'};
                    push @out_addresslist, $fixed_addr;
                } else {
                    push @out_addresslist, ${$current_address}{'address'};
                }
            }
            return \@out_addresslist;
        }
    } else {
        return [];
    }
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    #
    $self->aliases([]);
    $self->ipv6addrs([]);

    foreach (
             'disabled',
             'configure_for_dns',
             'use_ttl',
             'enable_discovery',
             'override_credential',
             'use_snmpv3_credential',
             'override_cli_credentials',
             'allow_telnet',
             'ddns_protected',
            ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    #

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref, {
                                                                                                     'use_root_name_server' => 1,
                                                                                                     'address' => 1,
                                                                                                     'cidr' => 1,
                                                                                                     'name' => 1,
                                                                                                    });

    #
    #
    #

    if (defined $$ibap_object_ref{'use_ttl'}) {
        $self->{'use_ttl'}=$$ibap_object_ref{'use_ttl'};
        if ($$ibap_object_ref{'use_ttl'} != 1) {
            $self->ttl(undef);
        }
    }

    $self->{'override_credential'}=ibap_value_i2o_boolean($$ibap_object_ref{'override_credential'});
    $self->{'override_snmp3_credential'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_snmpv3_credential'});
    $self->{'override_cli_credentials'}=ibap_value_i2o_boolean($$ibap_object_ref{'override_cli_credentials'});

    #
    if ($self->{'override_credential'} eq 'true') {
        $self->{'use_snmp_credential'} = $self->{'override_snmp3_credential'} eq 'true' ? 0 : 1;
        $self->{'use_snmp3_credential'} = $self->{'override_snmp3_credential'} eq 'true' ? 1 : 0;
    }

	return $res;
}

#
#
#

sub __o2i_ipv4addr_search__
{
    my ($self, $session, $current, $tempref, $type) = @_;
    my @return_args;

    my $search_type = 'REGEX';
    if ($type eq 'get') {
        $search_type = 'EXACT';
    }

    push @return_args, 1;
    if (not defined $$tempref{$current}) {
        push @return_args, 1;
        push @return_args, $$tempref{$current};

        if (defined $$tempref{'mac'}) {
            push @return_args,
              tIBType('SubMatch',
                      {
                       search_fields =>
                       [
                        {
                         field => 'mac_address',
                         search_type => $search_type,
                         value => ibap_value_o2i_string($$tempref{'mac'},'mac_address',$session)
                        }
                       ]
                      }
                     );

        }
    } else {
        push @return_args, 0;
        if (defined $$tempref{'mac'}) {
            my @fields = (
                  {
                   'field' => 'address',
                   'search_type' => $search_type,
                   'value' => ibap_value_o2i_string($$tempref{$current}),
                  },
                  {
                   'field' => 'mac_address',
                   'search_type' => $search_type,
                   'value' => ibap_value_o2i_string($$tempref{'mac'}),
                  },
                 );
            push @return_args,
              tIBType('SubMatch',
                      {
                       search_fields => \@fields,
                      }
                     );
        } else {
            push @return_args,
              tIBType('SubMatch',
                      {
                       search_fields =>
                       [
                        {
                         field => 'address',
                         search_type => $search_type,
                         value => ibap_value_o2i_string($$tempref{$current},'ipv4addrs',$session)
                        }
                       ]
                      }
                     );
        }
    }

    return @return_args;
}

sub __o2i_ipv6addr_search__
{
    my ($self, $session, $current, $tempref, $type) = @_;
    my @return_args;

    my $search_type = 'REGEX';
    if ($type eq 'get') {
        $search_type = 'EXACT';
    }

    push @return_args, 1;
    if (not defined $$tempref{$current}) {
        push @return_args, 1;
        push @return_args, $$tempref{$current};

        if (defined $$tempref{'duid'}) {
            push @return_args,
              tIBType('SubMatch',
                      {
                       search_fields =>
                       [
                        {
                         field => 'duid',
                         search_type => $search_type,
                         value => ibap_value_o2i_string($$tempref{'duid'},'duid',$session)
                        }
                       ]
                      }
                     );

        }
    } else {
        push @return_args, 0;
        push @return_args,
          tIBType('SubMatch',
                  {
                   search_fields =>
                   [
                    {
                     field => 'address',
                     search_type => $search_type,
                     value => ibap_value_o2i_string($$tempref{$current},'ipv6addrs',$session)
                    }
                   ]
                  }
                 );
    }

    return @return_args;
}

sub __o2i_mac_search__
{
    my ($self, $session, $key_mac, $tempref, $type) = @_;

    #
    #
    if (defined $$tempref{'ipv4addr'} || not defined $$tempref{$key_mac}) {
         return (1,1,undef);
    }

    my $search_type = 'REGEX';
    if ($type eq 'get') {
        $search_type = 'EXACT';
    }

    return (1,0, tIBType('SubMatch',
                         {
                          search_fields =>
                          [
                           {
                            field => 'mac_address',
                            search_type => $search_type,
                            value => ibap_value_o2i_string($$tempref{$key_mac},'mac_address',$session)
                           }
                          ]
                         }
                        )
           );
}

sub __o2i_alias_search__
{
    my ($self, $session, $current, $tempref, $type) = @_;
    my @return_args;

    my $search_type = 'REGEX';
    if ($type eq 'get') {
        $search_type = 'EXACT';
    }

    return(1, 0, 
              tIBType('SubMatch',
                      {
                       search_fields =>
                       [
                        {
                         field => 'alias',
                         search_type => $search_type,
                         value => ibap_value_o2i_string($$tempref{$current},'alias',$session)
                        }
                       ]
                      }
                     )
	);
}

sub __o2i_aliases__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
        if (ref ($$tempref{$current}) eq 'ARRAY') {
            my @aliases;
            my @allist=@{$$tempref{$current}};


            foreach my $alias (@allist) {
                my @alibap = (
                               {
                                'field' => 'parent',
                                'value' => tObjIdRef('..'),
                               }
                             );

                my %temp1;
                $temp1{'field'} = 'alias';
                return unless $temp1{'value'} = ibap_value_o2i_string($alias,'alias',$session);
                push @alibap, \%temp1;

                my %temp;
                $temp{'object_type'} = 'HostAlias';
                $temp{'write_fields'} = \@alibap;
                push @aliases, \%temp;
            }

            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType('ArrayOfsub_object',\@aliases);
        } else {
            push @return_args, 0;
        }
    }
    else {
        push @return_args, 1;
        push @return_args, 0;
        push @return_args, tIBType('ArrayOfsub_object',[]);
    }

    return @return_args;
}


sub __fixed_address_to_host_address_convert__
{
    my ($self, $addr, $session, $addribap_ref) = @_;

    my @addribap = ();

    my %temp1;
    $temp1{'field'} = 'address';
    return unless $temp1{'value'} = ibap_value_o2i_string($addr->ipv4addr(),'address',$session);
    push @{$addribap_ref}, \%temp1;

    my %temp2;
    $temp2{'field'} = 'mac_address';
    return unless $temp2{'value'} = ibap_value_o2i_string($addr->mac(),'mac_address',$session);
    push @{$addribap_ref}, \%temp2;

    if ($addr->configure_for_dhcp()) {
        my %temp3;
        $temp3{'field'} = 'configure_for_dhcp';
        return unless $temp3{'value'} = ibap_value_o2i_boolean($addr->configure_for_dhcp(),'configure_for_dhcp',$session);
        push @{$addribap_ref}, \%temp3;
    }

    if ($addr->match_client()) {
        my %temp3;
        $temp3{'field'} = 'match_option';
        return unless $temp3{'value'} = ibap_value_o2i_match_options($addr->match_client(),'match_client',$session);
        push @{$addribap_ref}, \%temp3;
    }

    my @bootp_options = ibap_arg_bootp_props($self, $session, '', $addr);
    if (@bootp_options) {
        my $success=shift @bootp_options;
        if ($success) {
            my $ignore_value=shift @bootp_options;
            unless ($ignore_value) {
                my $sub_write_args_ref = $bootp_options[0]->value();
                while(my ($key, $value) = each(%{$sub_write_args_ref})) {
                    my %write_arg;
                    $write_arg{'field'} = $key;
                    $write_arg{'value'} = $value;
                    push @{$addribap_ref}, \%write_arg;
                }
            }
        }
    }

    my @common_options = ibap_o2i_common_dhcp_props($self, $session, '', $addr);
    if (@common_options) {
        my $success=shift @common_options;
        if ($success) {
            my $ignore_value = shift @common_options;
            unless ($ignore_value) {
                my $sub_write_args_ref = $common_options[0]->value();
                while(my ($key, $value) = each(%{$sub_write_args_ref})) {
                    my %write_arg;
                    #
                    if ($key eq 'options') {
                        $key = 'custom_options';
                    } elsif ($key eq 'use_options') {
                        $key = 'use_custom_options';
                    }
                    #
                    if ($key eq 'enable_pxe_lease_time') {
                        $key = 'pxe_lease_time_enabled';
                    }
                    #
                    #
                    if ($key eq 'ignore_client_requested_options') {
                        $key = 'ignore_dhcp_param_request_list';
                    } elsif ($key eq 'use_ignore_client_requested_options') {
                        $key = 'use_ignore_dhcp_param_request_list';
                    }
                    $write_arg{'field'} = $key;
                    $write_arg{'value'} = $value;
                    push @{$addribap_ref}, \%write_arg;
                }
            }
        }
    }
}

my %__fa2ha_ignore_fields = (
    'disabled'                   => 1,
    'parent'                     => 1, # parent field is already contained in $addribap_ref, see __o2i_ipv6addr__
    'extensible_attributes'      => 1,
    'enable_discovery'           => 1,
    'override_credential'        => 1,
    'enable_immediate_discovery' => 1,
    'snmpv1v2_credential'        => 1,
    'snmpv3_credential'          => 1,
    'use_snmpv3_credential'      => 1,
    'cli_credentials'            => 1,
    'override_cli_credentials'   => 1,
    'device_type'                => 1,
    'device_vendor'              => 1,
    'device_location'            => 1,
    'device_description'         => 1,
    'allow_telnet'               => 1,
);

sub __ipv6_fixed_address_to_host_address_convert__
{
    my ($self, $addr, $session, $addribap_ref) = @_;

    #
    #
    my $write_fields=$addr->__object_to_ibap__($session->get_ibap_server(),$session, { comment => 1, template => 1, network_view => 1, extensible_attributes => 1});
    return unless($write_fields);

    foreach (@$write_fields) {
        #
        if ($_->{'field'} eq 'ip_address') {
            $_->{'field'} = 'address';
        }

        #
        next if $__fa2ha_ignore_fields{$_->{'field'}};

        push @{$addribap_ref}, $_;
    }

    #
    if ($addr->configure_for_dhcp()) {
        my %temp;
        $temp{'field'} = 'configure_for_dhcp';
        return unless $temp{'value'} = ibap_value_o2i_boolean($addr->configure_for_dhcp(),'configure_for_dhcp',$session);
        push @{$addribap_ref}, \%temp;
    }
}

sub __o2i_ipaddrs_helper__
{
    my ($self, $session, $current, $tempref, $v6) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
        if (ref ($$tempref{$current}) eq 'ARRAY') {
            if ($newhostaddress) {
                my @haddrs;

                foreach my $addr (@{$$tempref{$current}}) {
                    #
                    #
                    #

                    my $write_fields=$addr->__object_to_ibap__($session->get_ibap_server(),$session);
                    return (0) if(!$write_fields);

                    push @$write_fields, {
                                          'field' => 'parent',
                                          'value' => tObjIdRef('..'),
                                         };

                    my %temp = (
                                write_fields => $write_fields,
                               );

                    if ($v6) {
                        $temp{'object_type'} = 'IPv6HostAddress';
                    }
                    else {
                        $temp{'object_type'} = 'HostAddress';
                    }
                    push @haddrs, \%temp;
                }

                push @return_args, 1;
                push @return_args, 0;
                push @return_args, tIBType('ArrayOfsub_object', \@haddrs);
            } else {
                my @addresses;
                foreach my $addr (@{$$tempref{$current}}) {
                    my @addribap = (
                                    {
                                     'field' => 'parent',
                                     'value' => tObjIdRef('..'),
                                    }
                                   );

                    if (ref $addr eq 'Infoblox::DHCP::FixedAddr') {
                        __fixed_address_to_host_address_convert__($self, $addr, $session, \@addribap);
                    } elsif (ref $addr eq 'Infoblox::DHCP::IPv6FixedAddr') {
                        __ipv6_fixed_address_to_host_address_convert__($self, $addr, $session, \@addribap);
                    } else {
                        my %temp1;
                        $temp1{'field'} = 'address';
                        $temp1{'value'} = tString($addr);
                        push @addribap, \%temp1;
                    }

                    my %temp = (
                                write_fields => \@addribap
                               );
                    if ($v6) {
                        $temp{'object_type'} = 'IPv6HostAddress';
                    }
                    else {
                        $temp{'object_type'} = 'HostAddress';
                    }
                    push @addresses, \%temp;
                }
                push @return_args, 1;
                push @return_args, 0;
                push @return_args, tIBType('ArrayOfsub_object', \@addresses);
            }
        } else {
            push @return_args, 0;
        }
    }
    else {
        push @return_args, 1;
        push @return_args, 0;
        push @return_args, tIBType('ArrayOfsub_object',[]);
    }

    return @return_args;
}

sub __o2i_ipv4addrs__
{
    my ($self, $session, $current, $tempref) = @_;

    return __o2i_ipaddrs_helper__($self,$session,$current,$tempref,0);
}

sub __o2i_ipv6addrs__
{
    my ($self, $session, $current, $tempref) = @_;

    return __o2i_ipaddrs_helper__($self,$session,$current,$tempref,1);
}

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;

    my @write_fields;

    foreach my $current (keys %$self) {
        next if $current =~ m/^__/;

        my %write_arg;
        if (defined $_name_mappings{$current}) {
            $write_arg{'field'} = $_name_mappings{$current};
        }
        else {
            $write_arg{'field'} = $current;
        }

        my @converted_values = $_object_to_ibap{$current}($self, $session, $current,$self);
        if (@converted_values) {
            my $success=shift @converted_values;
            if ($success) {
                my $ignore_value=shift @converted_values;
                $write_arg{'value'} = shift @converted_values;

                foreach my $extra_args (@converted_values) {
                    unshift @write_fields, $extra_args;
                }

                if ($ignore_value) {
                    next;
                }
            } else {
                return;
            }
        } else {
            return;
        }
        unshift @write_fields, \%write_arg;
    }

    return \@write_fields;
}

#
#
#

sub disable
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv4addrs
{
    my $self  = shift;

    if ($newhostaddress) {
        return $self->__accessor_array__({name => 'ipv4addrs', validator => { 'Infoblox::DHCP::HostAddr' => 1 }}, @_);
    }
    else {
        return $self->__accessor_array__({name => 'ipv4addrs', validator => { 'string' => \&ibap_value_o2i_ipv4addr, 'Infoblox::DHCP::FixedAddr' => 1 }}, @_);
    }
}

sub ipv6addrs
{
    my $self  = shift;

    if ($newhostaddress) {
        return $self->__accessor_array__({name => 'ipv6addrs', validator => { 'Infoblox::DHCP::IPv6HostAddr' => 1 }}, @_);
    }
    else {
        return $self->__accessor_array__({name => 'ipv6addrs', validator => { 'string' => \&ibap_value_o2i_ipv6addr, 'Infoblox::DHCP::IPv6FixedAddr' => 1 }}, @_);
    }
}

sub aliases
{
    my $self  = shift;

    return $self->__accessor_array__({name => 'aliases', validator => { 'string' => \&ibap_value_o2i_string }}, @_);
}

sub configure_for_dns
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'configure_for_dns', validator => \&ibap_value_o2i_boolean}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub zone
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'zone', readonly => 1}, @_);
}

sub ttl
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ttl', validator => \&ibap_value_o2i_uint, use => \$self->{'use_ttl'}}, @_);
}

sub views
{
    my $self  = shift;

    return $self->__accessor_array__({name => 'views', validator => { 'Infoblox::DNS::View' => 1 }}, @_);
}

sub name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub network_view
{
    my $self = shift;

    return $self->__accessor_scalar__({name => 'network_view', validator => { 'Infoblox::DHCP::View' => 1 }}, @_);
}

sub rrset_order
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'rrset_order', enum => ['cyclic','random','fixed']}, @_);
}

sub dns_name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_name', readonly => 1}, @_);
}

sub dns_aliases
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_aliases', readonly => 1}, @_);
}

sub __update_snmp_overrides__
{
    my ($self, $member) = @_;

    if ($member eq 'snmp_credential') {
        $self->{'use_snmp3_credential'} = $self->{'use_snmp_credential'} ? 0 : 1;

        if ($self->{'use_snmp3_credential'} and !defined $self->{'snmp3_credential'}) {
            $self->{'use_snmp3_credential'} = 0;
        }
    } else {
        $self->{'use_snmp_credential'} = $self->{'use_snmp3_credential'} ? 0 : 1;

        if ($self->{'use_snmp_credential'} and !defined $self->{'snmp_credential'}) {
            $self->{'use_snmp_credential'} = 0;
        }
    }

    $self->override_snmp3_credential($self->{'use_snmp3_credential'} ? 'true' : 'false');
    $self->override_credential(($self->{'use_snmp_credential'} or $self->{'use_snmp3_credential'}) ? 'true' : 'false');
}

sub snmp_credential
{
    my $self = shift;

    my $res = $self->__accessor_scalar__({name => 'snmp_credential', validator => {'Infoblox::Grid::Discovery::SNMPCredential' => 1}, use => 'use_snmp_credential'}, @_);
    $self->__update_snmp_overrides__('snmp_credential') if (@_ and $res);

    return $res;
}

sub snmp3_credential
{
    my $self = shift;

    my $res = $self->__accessor_scalar__({name => 'snmp3_credential', validator => {'Infoblox::Grid::Discovery::SNMP3Credential' => 1}, use => 'use_snmp3_credential'}, @_);
    $self->__update_snmp_overrides__('snmp3_credential') if (@_ and $res);

    return $res;
}

return 1;

