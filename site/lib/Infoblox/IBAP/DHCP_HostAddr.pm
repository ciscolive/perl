package Infoblox::DHCP::HostAddr;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw( @ISA $_object_type %_allowed_members @_return_fields @_optional_return_fields $_return_fields_initialized %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities);

@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE );

BEGIN {
    $_object_type = 'HostAddress';
    register_wsdl_type('ib:HostAddress','Infoblox::DHCP::HostAddr');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members = (
                         bootfile                                 => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'use_boot_file', use_truefalse => 1},
                         bootserver                               => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'use_boot_server', use_truefalse => 1},
                         configure_for_dhcp                       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         deny_bootp                               => {simple => 'asis', validator => \&ibap_value_o2i_boolean, use => 'use_deny_bootp', use_truefalse => 1},
                         enable_pxe_lease_time                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         host                                     => {readonly => 1, validator => \&ibap_value_o2i_string},
                         ignore_client_requested_options          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_ignore_client_requested_options', use_truefalse => 1},
                         ipv4addr                                 => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_ipv4addr},
                         mac                                      => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         match_client                             => {enum => ['MAC','CLIENT_IDENTIFIER','RESERVED','CIRCUIT_ID','REMOTE_ID']},
                         network                                  => {readonly => 1},
                         options                                  => 0,
                         nextserver                               => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'use_next_server', use_truefalse => 1},
                         pxe_lease_time                           => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_pxe_lease_time', use_truefalse => 1},
                         use_for_ea_inheritance                   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         is_invalid_mac                           => {simple => 'bool', validator => \&ibap_value_o2i_boolean, readonly => 1},
                         last_queried                             => {readonly => 1},

                         #
                         override_bootfile                        => 0,
                         override_bootserver                      => 0,
                         override_deny_bootp                      => 0,
                         override_ignore_client_requested_options => {simple => 'asis', validator => \&ibap_value_o2i_boolean},
                         override_nextserver                      => 0,
                         override_options                         => {simple => 'asis', validator => \&ibap_value_o2i_boolean},
                         override_pxe_lease_time                  => {simple => 'asis', validator => \&ibap_value_o2i_boolean},
                         discovered_data                          => {readonly => 1, validator => {'Infoblox::Grid::Discovery::Data' => 1}},
                         reserved_interface                       => {validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}},
                         discover_now_status                      => {simple => 'asis', readonly => 1},
                         ms_ad_user_data                          => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
                         logic_filters                            => {array => 1, validator => {string => 1, 'Infoblox::DHCP::Filter::MAC' => 1,
                                                                      'Infoblox::DHCP::Filter::NAC' => 1, 'Infoblox::DHCP::Filter::Option' => 1},
                                                                      use => 'override_logic_filters', use_truefalse => 1},
                         override_logic_filters                   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
						   ipv4addr              => [\&ibap_o2i_string ,'address'     , 'REGEX'],
						   mac                   => [\&ibap_o2i_string ,'mac_address' , 'REGEX'],
						   host                  => [\&__o2i_host_search__ ,'parent'     , 'SEARCHONLY_LIST_CONTAIN'],
                           discovered_data       => [\&Infoblox::Grid::Discovery::Data::__o2i_search_discovered_data__, 'discovered_data', 'EXACT'],
                          );

    %_name_mappings = (
                       'enable_pxe_lease_time'                    => 'pxe_lease_time_enabled',
                       'host'                                     => 'parent',
                       'ignore_client_requested_options'          => 'ignore_dhcp_param_request_list',
                       'ipv4addr'                                 => 'address',
                       'mac'                                      => 'mac_address',
                       'match_client'                             => 'match_option',
                       'override_bootfile'                        => 'use_boot_file',
                       'override_bootserver'                      => 'use_boot_server',
                       'override_deny_bootp'                      => 'use_deny_bootp',
                       'override_ignore_client_requested_options' => 'use_ignore_dhcp_param_request_list',
                       'override_nextserver'                      => 'use_next_server',
                       'override_options'                         => 'use_custom_options',
                       'override_pxe_lease_time'                  => 'use_pxe_lease_time',
                       'logic_filters'                            => 'option_logic_filters',
                       'override_logic_filters'                   => 'use_option_logic_filters',
					  );

    %_reverse_name_mappings = reverse %_name_mappings;

    #
    $_name_mappings{'options'} = 'custom_options';
    $_name_mappings{'use_options'} = 'use_custom_options';

    #
    $_reverse_name_mappings{'_discovered_mac_address'} = 'discovered_mac';

    %_ibap_to_object = (
						'match_option'                        => \&ibap_i2o_match_options,
						'network'                             => \&__i2o_network__,
						'parent'                              => \&__i2o_host__,
                        'pxe_lease_time_enabled'              => \&ibap_i2o_boolean,
                        'use_boot_file'                       => \&ibap_i2o_boolean,
                        'use_boot_server'                     => \&ibap_i2o_boolean,
                        'use_deny_bootp'                      => \&ibap_i2o_boolean,
                        'use_ignore_dhcp_param_request_list'  => \&ibap_i2o_boolean,
                        'use_next_server'                     => \&ibap_i2o_boolean,
                        'use_pxe_lease_time'                  => \&ibap_i2o_boolean,
                        'use_for_ea_inheritance'              => \&ibap_i2o_boolean,
                        'discovered_data'                     => \&ibap_i2o_generic_object_convert,
                        'reserved_interface'                  => \&ibap_i2o_generic_object_convert,
                        'is_invalid_mac'                      => \&ibap_i2o_boolean,
                        'ms_ad_user_data'                     => \&ibap_i2o_generic_object_convert,
                        'option_logic_filters'               => \&ibap_i2o_ordered_filters,
                        'use_option_logic_filters'           => \&ibap_i2o_boolean,
                        'last_queried'                       => \&ibap_i2o_datetime_to_unix_timestamp,
					   );

	%_return_field_overrides = (
                                bootfile                                 => ['use_boot_file'],
                                bootserver                               => ['use_boot_server'],
                                configure_for_dhcp                       => [],
                                deny_bootp                               => ['use_deny_bootp'],
                                enable_pxe_lease_time                    => [],
                                host                                     => [],
                                ignore_client_requested_options          => ['use_ignore_dhcp_param_request_list'],
                                ipv4addr                                 => [],
                                is_invalid_mac                           => [],
                                mac                                      => [],
                                match_client                             => [],
                                network                                  => [],
                                nextserver                               => ['use_next_server'],
                                options                                  => [
                                                                             'use_custom_options',
                                                                             'broadcast_address',
                                                                             'use_broadcast_address',
                                                                             'domain_name',
                                                                             'use_domain_name',
                                                                             'lease_time',
                                                                             'use_lease_time',
                                                                             'routers',
                                                                             'use_routers',
                                                                             'domain_name_servers',
                                                                             'use_domain_name_servers',
                                                                            ],
                                override_deny_bootp                      => [],
                                override_ignore_client_requested_options => [],
                                override_options                         => [],
                                override_pxe_lease_time                  => [],
                                pxe_lease_time                           => ['use_pxe_lease_time'],
                                use_for_ea_inheritance                   => [],
                                discovered_data                          => [],
                                reserved_interface                       => [],
                                discover_now_status                      => [],
                                ms_ad_user_data                          => [],
                                logic_filters                            => ['use_option_logic_filters'],
                                override_logic_filters                   => [],
                                last_queried                             => [],
							   );

    #
    %_object_to_ibap = (
                        bootfile                                 => \&ibap_o2i_ignore,
                        bootserver                               => \&ibap_o2i_ignore,
                        configure_for_dhcp                       => \&ibap_o2i_boolean,
                        deny_bootp                               => \&ibap_o2i_ignore,
                        enable_pxe_lease_time                    => \&ibap_o2i_boolean,
                        host                                     => \&ibap_o2i_ignore,
                        ignore_client_requested_options          => \&ibap_o2i_boolean,
                        ipv4addr                                 => \&ibap_o2i_string,
                        mac                                      => \&ibap_o2i_string,
                        match_client                             => \&ibap_o2i_match_options,
                        network                                  => \&ibap_o2i_ignore,
                        nextserver                               => \&ibap_o2i_ignore,
                        options                                  => \&ibap_o2i_ignore,
                        override_bootfile                        => \&ibap_o2i_ignore,
                        override_bootserver                      => \&ibap_o2i_ignore,
                        override_deny_bootp                      => \&ibap_o2i_ignore,
                        override_ignore_client_requested_options => \&ibap_o2i_boolean,
                        override_nextserver                      => \&ibap_o2i_ignore,
                        override_options                         => \&ibap_o2i_ignore,
                        override_pxe_lease_time                  => \&ibap_o2i_boolean,
                        pxe_lease_time                           => \&ibap_o2i_ignore,
                        use_for_ea_inheritance                   => \&ibap_o2i_boolean,
                        discovered_data                          => \&ibap_o2i_ignore,
                        reserved_interface                       => \&ibap_o2i_object_only_by_oid_or_undef,
                        discover_now_status                      => \&ibap_o2i_ignore,
                        is_invalid_mac                           => \&ibap_o2i_ignore,
                        ms_ad_user_data                          => \&ibap_o2i_ignore,
                        override_logic_filters                   => \&ibap_o2i_boolean,
                        logic_filters                            => \&ibap_o2i_ordered_filters,
                        last_queried                             => \&ibap_o2i_ignore,

                        #
                        use_boot_file           => \&ibap_o2i_boolean,
                        use_boot_server         => \&ibap_o2i_boolean,
                        use_broadcast_address   => \&ibap_o2i_boolean,
                        use_deny_bootp          => \&ibap_o2i_boolean,
                        use_domain_name         => \&ibap_o2i_boolean,
                        use_domain_name_servers => \&ibap_o2i_boolean,
                        use_lease_time          => \&ibap_o2i_boolean,
                        use_next_server         => \&ibap_o2i_boolean,
                        use_routers             => \&ibap_o2i_boolean,
                       );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('address'),
                       tField('boot_file'),
                       tField('boot_server'),
                       tField('broadcast_address'),
                       tField('configure_for_dhcp'),
                       tField('custom_options'),
                       tField('deny_bootp'),
					   tField('discovered_data',{depth => 1}),
                       tField('domain_name'),
                       tField('domain_name_servers'),
                       tField('ignore_dhcp_param_request_list'),
                       tField('is_invalid_mac'),
                       tField('lease_time'),
                       tField('mac_address'),
                       tField('match_option'),
                       tField('network',
                              {
                               sub_fields => [
                                              tField('address'),
                                              tField('cidr'),
                                             ]
                              }
                             ),
                       tField('next_server'),
                       tField('parent',
                              {
                               sub_fields => [
                                              tField('fqdn'),
                                             ]
                              }
                             ),
                       tField('pxe_lease_time'),
                       tField('pxe_lease_time_enabled'),
                       tField('routers'),
                       tField('use_boot_file'),
                       tField('use_boot_server'),
                       tField('use_broadcast_address'),
                       tField('use_custom_options'),
                       tField('use_deny_bootp'),
                       tField('use_domain_name'),
                       tField('use_domain_name_servers'),
                       tField('use_ignore_dhcp_param_request_list'),
                       tField('use_lease_time'),
                       tField('use_next_server'),
                       tField('use_pxe_lease_time'),
                       tField('use_routers'),
                       tField('use_for_ea_inheritance'),
                       tField('use_option_logic_filters'),
                       tField('option_logic_filters', return_fields_option_logic_filters()),
                       tField('last_queried'),
                      );

    @_optional_return_fields = (
                                tField('discover_now_status'),
                               );

    Infoblox::IBAPBase::create_discovered_data_fields(@discovery_common_fields, @vdiscovery_fields, 'discovered_mac');

    $_return_fields_initialized = 0;
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

sub __init_instance_constants__
{
    my $self = shift;

    unless ($_return_fields_initialized) {
        $_return_fields_initialized = 1;

        my $tmp = Infoblox::Grid::Discovery::DeviceInterface->__new__();
        push @_return_fields, tField('reserved_interface', {no_access_ok => 1, sub_fields => $tmp->__return_fields__()});

        $tmp = Infoblox::Grid::MSServer::AdUser::Data->__new__();
        push @_return_fields, tField('ms_ad_user_data', {sub_fields => $tmp->__return_fields__()});

    }
}


#
#
#

sub __i2o_host__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;

	return $$ibap_object_ref{$current}{'fqdn'};
}

sub __i2o_network__
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
	my @newlist;

	if ($$ibap_object_ref{$current}) {
        my $address = $$ibap_object_ref{$current}{'address'};
		return $address.'/'.$$ibap_object_ref{$current}{'cidr'};
	} else {
		return;
	}
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'configure_for_dhcp'}                 = 0 unless defined $$ibap_object_ref{'configure_for_dhcp'};
    $$ibap_object_ref{'deny_bootp'}                         = 0 unless defined $$ibap_object_ref{'deny_bootp'};
    $$ibap_object_ref{'enable_pxe_lease_time'}              = 0 unless defined $$ibap_object_ref{'enable_pxe_lease_time'};
    $$ibap_object_ref{'ignore_dhcp_param_request_list'}     = 0 unless defined $$ibap_object_ref{'ignore_dhcp_param_request_list'};
    $$ibap_object_ref{'use_boot_file'}                      = 0 unless defined $$ibap_object_ref{'use_boot_file'};
    $$ibap_object_ref{'use_boot_server'}                    = 0 unless defined $$ibap_object_ref{'use_boot_server'};
    $$ibap_object_ref{'use_custom_options'}                 = 0 unless defined $$ibap_object_ref{'use_custom_options'};
    $$ibap_object_ref{'use_deny_bootp'}                     = 0 unless defined $$ibap_object_ref{'use_deny_bootp'};
    $$ibap_object_ref{'use_ignore_dhcp_param_request_list'} = 0 unless defined $$ibap_object_ref{'use_ignore_dhcp_param_request_list'};
    $$ibap_object_ref{'use_next_server'}                    = 0 unless defined $$ibap_object_ref{'use_next_server'};
    $$ibap_object_ref{'use_pxe_lease_time'}                 = 0 unless defined $$ibap_object_ref{'use_pxe_lease_time'};
    $$ibap_object_ref{'use_for_ea_inheritance'}             = 0 unless defined $$ibap_object_ref{'use_for_ea_inheritance'};
    $$ibap_object_ref{'use_option_logic_filters'}           = 0 unless defined $$ibap_object_ref{'use_option_logic_filters'};
    $$ibap_object_ref{'use_broadcast_address'}              = 0 unless defined $$ibap_object_ref{'use_broadcast_address'};
    $$ibap_object_ref{'use_domain_name'}                    = 0 unless defined $$ibap_object_ref{'use_domain_name'};
    $$ibap_object_ref{'use_domain_name_servers'}            = 0 unless defined $$ibap_object_ref{'use_domain_name_servers'};
    $$ibap_object_ref{'use_lease_time'}                     = 0 unless defined $$ibap_object_ref{'use_lease_time'};
    $$ibap_object_ref{'use_routers'}                        = 0 unless defined $$ibap_object_ref{'use_routers'};
    $$ibap_object_ref{'is_invalid_mac'}                     = 0 unless defined $$ibap_object_ref{'is_invalid_mac'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    $self->{'__initializing_from_ibap__'} = 1;

    #
    #
    #
    my %current_address_copy = %{$ibap_object_ref};
    my %tmp_hash = ( 'dummy_name' => \%current_address_copy );

    #
    if (defined $ibap_object_ref->{'use_custom_options'}) {
        $current_address_copy{'use_options'} = $ibap_object_ref->{'use_custom_options'};
        delete $current_address_copy{'use_custom_options'};
    }
    if (defined $ibap_object_ref->{'custom_options'}) {
        $current_address_copy{'options'} = $ibap_object_ref->{'custom_options'};
        delete $current_address_copy{'custom_options'};
    }

    ibap_i2o_bootp_props_no_use_flags($self, $session, 'dummy_name', \%tmp_hash);
    ibap_i2o_common_dhcp_props_no_use_flags($self, $session, 'dummy_name', \%tmp_hash);

    delete $self->{'__initializing_from_ibap__'};

    Infoblox::Grid::Discovery::Data::__init_discovered_members__($self);

    #
    #
    $self->{'use_boot_file'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_boot_file'});
    $self->{'use_boot_server'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_boot_server'});
    $self->{'use_next_server'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_next_server'});
    $self->{'use_deny_bootp'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_deny_bootp'});
    $self->{'override_ignore_client_requested_options'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ignore_dhcp_param_request_list'});
    $self->{'override_options'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_custom_options'});
    $self->{'override_pxe_lease_time'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_pxe_lease_time'});
    $self->{'override_logic_filters'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_option_logic_filters'});
	return;
}

#
#
#

sub __o2i_host_search__
{
    my ($self, $session, $current, $tempref, $type) = @_;

    if ($$tempref{$current}) {
        if ($type eq 'search') {
            return (1,0,ibap_readfieldlist_simple_string('HostRecord', 'fqdn', $tempref->{$current}));
        }
        else {
            return (1,0, ibap_readfield_simple_string('HostRecord', 'fqdn', $$tempref{$current},$current));
        }
    }
    else {
        return (1,1,undef);
    }
}

sub __object_to_ibap__
{
	my ($self, $server, $session) = @_;

    my $ref_write_fields=$self->SUPER::__object_to_ibap__($server, $session);
    return unless $ref_write_fields;

    #

    my @bootp_options = ibap_arg_bootp_props($self, $session, '', $self);
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
                    push @{$ref_write_fields}, \%write_arg;
                }
            }
        }
    }

    my @common_options = ibap_o2i_common_dhcp_props($self, $session, '', $self);
    if (@common_options) {
        my $success=shift @common_options;
        if ($success) {
            my $ignore_value = shift @common_options;
            unless ($ignore_value) {
                my $sub_write_args_ref = $common_options[0]->value();
                while(my ($key, $value) = each(%{$sub_write_args_ref})) {
                    next if $key eq 'use_ignore_client_requested_options';
                    next if $key eq 'use_pxe_lease_time';
                    next if $key eq 'enable_pxe_lease_time';

                    my %write_arg;
                    if ($_name_mappings{$key}) {
                        $key = $_name_mappings{$key};
                    }

                    $write_arg{'field'} = $key;
                    $write_arg{'value'} = $value;
                    push @{$ref_write_fields}, \%write_arg;
                }
            }
        }
    }

	return $ref_write_fields;
}

#
#
#

sub options
{
    my $self  = shift;
    return ibap_accessor_dhcp_options($self, 'options', @_);
}

sub override_bootfile
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'use_boot_file', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_bootserver
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'use_boot_server', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_nextserver
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'use_next_server', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_deny_bootp
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'use_deny_bootp', validator => \&ibap_value_o2i_boolean}, @_);
}

package Infoblox::DHCP::IPv6HostAddr;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields @_optional_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object $_return_fields_initialized @_sub_host_address_fields %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase);


BEGIN {
    $_object_type = 'IPv6HostAddress';
    register_wsdl_type('ib:IPv6HostAddress','Infoblox::DHCP::IPv6HostAddr');

    %_capabilities = (
                      'depth'                  => 0,
                      'implicit_defaults'      => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         address_type                => {simple => 'asis', enum => [ 'ADDRESS', 'BOTH', 'PREFIX']},
                         configure_for_dhcp          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         domain_name                 => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_domain_name', use_truefalse => 1},
                         domain_name_servers         => {validator => \&ibap_value_o2i_string, use => 'override_domain_name_servers', use_truefalse => 1},
                         duid                        => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         host                        => {readonly => 1, validator => \&ibap_value_o2i_string},
                         ipv6addr                    => {simple => 'asis', validator => \&ibap_value_o2i_ipv6addr},
                         ipv6prefix                  => {simple => 'asis', validator => \&ibap_value_o2i_ipv6_network_or_address},
                         ipv6prefix_bits             => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         match_client                => {simple => 'asis', enum => [ 'DUID' ]},
                         options                     => {array => 1, validator => { 'Infoblox::DHCP::Option' => 1}, use => 'override_options', use_truefalse => 1},
                         override_domain_name        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_domain_name_servers => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_options            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_preferred_lifetime => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_valid_lifetime     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         preferred_lifetime          => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_preferred_lifetime', use_truefalse => 1},
                         valid_lifetime              => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_valid_lifetime', use_truefalse => 1},
                         use_for_ea_inheritance      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         discovered_data             => {readonly => 1, validator => {'Infoblox::Grid::Discovery::Data' => 1}},
                         reserved_interface          => {validator => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}},
                         discover_now_status         => {simple => 'asis', readonly => 1},
                         last_queried                => {readonly => 1},
                         ms_ad_user_data             => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
                         network                     => {readonly => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'host'                         => 'parent',
                       'ipv6addr'                     => 'address',
                       'ipv6prefix'                   => 'v6_prefix',
                       'ipv6prefix_bits'              => 'v6_prefix_bits',
                       'match_client'                 => 'match_option',
                       'override_domain_name'         => 'use_domain_name',
                       'override_domain_name_servers' => 'use_domain_name_servers',
                       'override_options'             => 'use_options',
                       'override_preferred_lifetime'  => 'use_preferred_lifetime',
                       'override_valid_lifetime'      => 'use_lease_time',
                       'valid_lifetime'               => 'lease_time',
                      );
    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
						   host                  => [\&__o2i_host_search__ ,'parent'     , 'SEARCHONLY_LIST_CONTAIN'],
                           duid                  => [\&ibap_o2i_string ,'duid'         , 'REGEX'],
                           ipv6addr              => [\&ibap_o2i_string ,'address'   , 'REGEX'],
                           discovered_data       => [\&Infoblox::Grid::Discovery::Data::__o2i_search_discovered_data__, 'discovered_data', 'EXACT'],
                          );

    %_ibap_to_object = (
						'parent'                  => \&__i2o_host__,
                        'configure_for_dhcp'      => \&ibap_i2o_boolean,
                        'domain_name_servers'     => \&ibap_i2o_domain_name_servers,
                        'options'                 => \&ibap_i2o_options,
                        'use_domain_name'         => \&ibap_i2o_boolean,
                        'use_domain_name_servers' => \&ibap_i2o_boolean,
                        'use_lease_time'          => \&ibap_i2o_boolean,
                        'use_options'             => \&ibap_i2o_boolean,
                        'use_preferred_lifetime'  => \&ibap_i2o_boolean,
                        'use_for_ea_inheritance'  => \&ibap_i2o_boolean,
                        'discovered_data'         => \&ibap_i2o_generic_object_convert,
                        'reserved_interface'      => \&ibap_i2o_generic_object_convert,
                        'last_queried'            => \&ibap_i2o_datetime_to_unix_timestamp,
                        'ms_ad_user_data'         => \&ibap_i2o_generic_object_convert,
                        'network'                 => \&Infoblox::DHCP::HostAddr::__i2o_network__,
                       );

    %_object_to_ibap = (
                        'address_type'                => \&ibap_o2i_string,
                        'configure_for_dhcp'          => \&ibap_o2i_boolean,
                        'domain_name'                 => \&ibap_o2i_string,
                        'domain_name_servers'         => \&ibap_o2i_domain_name_servers,
                        'duid'                        => \&ibap_o2i_string,
                        'ipv6addr'                    => \&ibap_o2i_string,
                        'ipv6prefix'                  => \&ibap_o2i_string,
                        'ipv6prefix_bits'             => \&ibap_o2i_uint,
                        'match_client'                => \&ibap_o2i_string,
                        'host'                        => \&ibap_o2i_ignore,
                        'options'                     => \&ibap_o2i_options,
                        'override_domain_name'        => \&ibap_o2i_boolean,
                        'override_domain_name_servers' => \&ibap_o2i_boolean,
                        'override_options'            => \&ibap_o2i_boolean,
                        'override_preferred_lifetime' => \&ibap_o2i_boolean,
                        'override_valid_lifetime'     => \&ibap_o2i_boolean,
                        'preferred_lifetime'          => \&ibap_o2i_uint,
                        'valid_lifetime'              => \&ibap_o2i_uint,
                        'use_for_ea_inheritance'      => \&ibap_o2i_boolean,
                        'discovered_data'             => \&ibap_o2i_ignore,
                        'reserved_interface'          => \&ibap_o2i_object_only_by_oid_or_undef,
                        'discover_now_status'         => \&ibap_o2i_ignore,
                        'last_queried'                => \&ibap_o2i_ignore,
                        'ms_ad_user_data'             => \&ibap_o2i_ignore,
                        'network'                     => \&ibap_o2i_ignore,
                       );

    %_return_field_overrides = (
                                'address_type'                => [],
                                'configure_for_dhcp'          => [],
                                'domain_name'                 => ['use_domain_name'],
                                'domain_name_servers'         => ['use_domain_name_servers'],
                                'duid'                        => [],
                                'ipv6addr'                    => [],
                                'ipv6prefix'                  => [],
                                'ipv6prefix_bits'             => [],
                                'match_client'                => [],
                                'host'                        => [],
                                'options'                     => ['use_options'],
                                'override_domain_name'        => [],
                                'override_domain_name_servers' => [],
                                'override_options'            => [],
                                'override_preferred_lifetime' => [],
                                'override_valid_lifetime'     => [],
                                'preferred_lifetime'          => ['use_preferred_lifetime'],
                                'valid_lifetime'              => ['use_lease_time'],
                                'use_for_ea_inheritance'      => [],
                                'discovered_data'             => [],
                                'reserved_interface'          => [],
                                'discover_now_status'         => [],
                                'last_queried'                => [],
                                'ms_ad_user_data'             => [],
                                'network'                     => [],
                               );


    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('address'),
                       tField('address_type'),
                       tField('configure_for_dhcp'),
                       tField('discovered_data', {depth => 1}),
                       tField('domain_name'),
                       tField('domain_name_servers'),
                       tField('duid'),
                       tField('lease_time'),
                       tField('match_option'),
                       tField('options'),
                       tField('preferred_lifetime'),
                       tField('use_domain_name'),
                       tField('use_domain_name_servers'),
                       tField('use_lease_time'),
                       tField('use_options'),
                       tField('use_preferred_lifetime'),
                       tField('v6_prefix'),
                       tField('v6_prefix_bits'),
                       tField('last_queried'),
                       tField('parent',
                              {
                               sub_fields => [
                                              tField('fqdn'),
                                             ]
                              }
                             ),
                       tField('use_for_ea_inheritance'),
                       tField('network', {sub_fields => [
                           tField('address'),
                           tField('cidr'),
                       ]}),
                      );

    @_optional_return_fields = (
                                tField('discover_now_status'),
                               );

    Infoblox::IBAPBase::create_discovered_data_fields(@discovery_common_fields, @vdiscovery_fields, 'discovered_duid');
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    unless($args{'ipv6addr'} || ($args {'ipv6prefix'} && $args { 'ipv6prefix_bits' }))
    {
        set_error_codes(1103,"At least one of ipv6addr and ipv6prefix/ipv6prefix_bits is required." );
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

        my $tmp = Infoblox::Grid::Discovery::DeviceInterface->__new__();
        push @_return_fields, tField('reserved_interface', {no_access_ok => 1, sub_fields => $tmp->__return_fields__()});

        $tmp = Infoblox::Grid::MSServer::AdUser::Data->__new__();
        push @_return_fields, tField('ms_ad_user_data', {sub_fields => $tmp->__return_fields__()});
    }

    #
    $self->match_client('DUID') unless defined $self->match_client();
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

sub __i2o_host__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;

	return $$ibap_object_ref{$current}{'fqdn'};
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'configure_for_dhcp'}     = 0 unless defined $$ibap_object_ref{'configure_for_dhcp'};
    $$ibap_object_ref{'use_domain_name'}        = 0 unless defined $$ibap_object_ref{'use_domain_name'};
    $$ibap_object_ref{'use_domain_name_servers'} = 0 unless defined $$ibap_object_ref{'use_domain_name_servers'};
    $$ibap_object_ref{'use_lease_time'}         = 0 unless defined $$ibap_object_ref{'use_lease_time'};
    $$ibap_object_ref{'use_options'}            = 0 unless defined $$ibap_object_ref{'use_options'};
    $$ibap_object_ref{'use_preferred_lifetime'} = 0 unless defined $$ibap_object_ref{'use_preferred_lifetime'};
    $$ibap_object_ref{'use_for_ea_inheritance'} = 0 unless defined $$ibap_object_ref{'use_for_ea_inheritance'};

    #
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'override_domain_name'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_domain_name'});
    $self->{'override_domain_name_servers'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_domain_name_servers'});
    $self->{'override_options'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_options'});
    $self->{'override_preferred_lifetime'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_preferred_lifetime'});
    $self->{'override_valid_lifetime'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_lease_time'});

    $self->{'__initializing_from_ibap__'} = 1;
	$self->last_discovered('');
	$self->netbios('');
	$self->os('');
    delete $self->{'__initializing_from_ibap__'};

    Infoblox::Grid::Discovery::Data::__init_discovered_members__($self);

    return;
}

#
#
#

sub __o2i_host_search__
{
    my ($self, $session, $current, $tempref, $type) = @_;

    if ($$tempref{$current}) {
        if ($type eq 'search') {
            return (1,0,ibap_readfieldlist_simple_string('HostRecord', 'fqdn', $tempref->{$current}));
        }
        else {
            return (1,0, ibap_readfield_simple_string('HostRecord', 'fqdn', $$tempref{$current},$current));
        }
    }
    else {
        return (1,1,undef);
    }
}


#
#
#

1;


