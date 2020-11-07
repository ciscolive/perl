package Infoblox::DHCP::RangeTemplate;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_return_field_overrides
            %_name_mappings %_reverse_name_mappings %_searchable_fields
            %_ibap_to_object %_object_to_ibap @_return_fields %_capabilities);
@ISA = qw(Infoblox::IBAPBase);


BEGIN
{
	$_object_type = 'DhcpRangeTemplate';
    register_wsdl_type('ib:DhcpRangeTemplate', 'Infoblox::DHCP::RangeTemplate');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 0,
					  'single_serialization' => 0,
					 );

    #
    #
    %_allowed_members = (
						 authority 			  	=> 0, #deprecated
						 bootfile 			  	=> 0,
						 bootserver 			=> 0,
						 comment 				=> 0,
                         enable_known_clients_option   => 0,
                         enable_unknown_clients_option => 0,
                         ddns_domainname        => 0,
                         override_ddns_domainname => 0,
                         override_lease_scavenge_time => 0,
						 ddns_generate_hostname => 0,
                         deny_all_clients 	  	=> 0,
						 deny_bootp 			=> 0,
						 enable_ddns 			=> 0,
                         extattrs               => 0,
						 extensible_attributes  => 0,
						 exclude 				=> 0,
						 failover_assoc 		=> 0,
						 filters 				=> 0,
                         known_clients_option   => 0,
                         lease_scavenge_time    => 0,
						 member 				=> 0,
						 name 				  	=> 1,
						 server_association_type => 0,
						 nextserver 			=> 0,
						 number_of_addresses 	=> 1,
						 offset 				=> 1,
						 options 				=> 0,
						 pxe_lease_time 		=> 0,
                         range_high_water_mark  => 0,
                         range_high_water_mark_reset => 0,
                         range_low_water_mark   => 0,
                         range_low_water_mark_reset => 0,
						 recycle_leases 		=> 0,
                         unknown_clients_option => 0,
                         update_dns_on_lease_renewal         => 0,
                         override_update_dns_on_lease_renewal => 0,
                         delegated_member                     => {validator => {'Infoblox::DHCP::Member' => 1}},
                         cloud_api_compatible                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},

                         logic_filters                 => {array => 1, validator => {string => 1, 'Infoblox::DHCP::Filter::MAC' => 1,
                                                           'Infoblox::DHCP::Filter::NAC' => 1, 'Infoblox::DHCP::Filter::Option' => 1},
                                                           use => 'override_logic_filters', use_truefalse => 1},
                         override_logic_filters        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
						);

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides =
        (bootfile 			  	=> ['!bootp_properties'],
         bootserver 			=> ['!bootp_properties'],
         comment 				=> [],
         ddns_domainname                     => ['use_ddns_domainname'],
         override_ddns_domainname             => [],
         ddns_generate_hostname => ['use_generate_hostname'],
         deny_all_clients 	  	=> [],
         deny_bootp 			=> ['!bootp_properties'],
         enable_ddns 			=> ['use_enable_ddns'],
         enable_known_clients_option   => [],
         enable_unknown_clients_option => [],
         extattrs               => [],
         extensible_attributes  => [],
         exclude 				=> [],
         failover_assoc 		=> [],
         filters 				=> [],
         known_clients_option   => ['use_known_clients'],
         lease_scavenge_time    => ['use_client_association_grace_period'],
         override_lease_scavenge_time => [],
         member                 => ['server_association_type','ms_server'],
         name 				  	=> [],
         nextserver 			=> ['!bootp_properties'],
         number_of_addresses 	=> [],
         offset 				=> [],
         options 				=> [],
         pxe_lease_time 		=> [],
         range_high_water_mark  	   => [],
         range_high_water_mark_reset   => [],
         range_low_water_mark 		   => [],
         range_low_water_mark_reset    => [],
         recycle_leases 		=> ['use_recycle_leases'],
         unknown_clients_option => ['use_unknown_clients'],
         update_dns_on_lease_renewal         => ['use_update_dns_on_lease_renewal'],
         override_update_dns_on_lease_renewal => [],
         server_association_type       => [],
        delegated_member               => [],
        cloud_api_compatible           => [],
         logic_filters               => ['use_option_logic_filters'],
         override_logic_filters      => [],
         );

    #
    %_name_mappings = (
					   'ddns_generate_hostname' => 'generate_hostname' ,
					   'enable_known_clients_option'   => 'use_known_clients' ,
					   'enable_unknown_clients_option' => 'use_unknown_clients' ,
					   'exclude'     			=> 'exclusion_ranges',
                       'extattrs'                     => 'extensible_attributes',
					   'failover_assoc'  		=> 'failover_association',
                       'override_update_dns_on_lease_renewal' => 'use_update_dns_on_lease_renewal',
                       'override_ddns_domainname'     => 'use_ddns_domainname',
                       'override_lease_scavenge_time' => 'use_client_association_grace_period',
                       'lease_scavenge_time'          => 'client_association_grace_period',

					   #
					   #
					   #
					   'filters' => 'mac_filter_rules' ,
                       'logic_filters'          => 'option_logic_filters',
                       'override_logic_filters' => 'use_option_logic_filters',
					  );

    %_reverse_name_mappings = (
							   'exclusion_ranges'     	  => 'exclude',
                               'extensible_attributes'    => 'extattrs',
							   'failover_association' 	  => 'failover_assoc',
							   'generate_hostname'    	  => 'ddns_generate_hostname',
							   'mac_filter_rules'     	  => 'filters',
							   'nac_filter_rules'     	  => 'filters',
							   'option_filter_rules'      => 'filters',
                               'fingerprint_filter_rules' => 'filters',
							   'relay_agent_filter_rules' => 'filters',
                               'use_known_clients'        => 'enable_known_clients_option',
                               'use_unknown_clients'      => 'enable_unknown_clients_option',
                               'ms_server'                => 'member',
                               'use_update_dns_on_lease_renewal' => 'override_update_dns_on_lease_renewal',
                               'use_ddns_domainname'             => 'override_ddns_domainname',
                               'use_client_association_grace_period' => 'override_lease_scavenge_time',
                               'client_association_grace_period' => 'lease_scavenge_time',
                               'option_logic_filters'     => 'logic_filters',
                               'use_option_logic_filters' => 'override_logic_filters',
						   );

    #
    %_searchable_fields = (
						   name => [\&ibap_o2i_string, 'name', 'REGEX'],
						   comment => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
						   server_association_type => [\&ibap_o2i_string     ,'server_association_type', 'EXACT'],
						  );

    #
    %_ibap_to_object = (
						'deny_all_clients'  	   => \&ibap_i2o_boolean,
						'enable_ddns' 			   => \&ibap_i2o_boolean,
						'exclusion_ranges' 		   => \&ibap_i2o_exclusion_template,
                        'extensible_attributes'    => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
						'failover_association'     => \&ibap_i2o_range_failover,
						'generate_hostname'        => \&ibap_i2o_boolean,
						'mac_filter_rules'         => \&ibap_i2o_range_filters,
						'member' 				   => \&ibap_i2o_mixed_member,
						'ms_server' 			   => \&ibap_i2o_mixed_member,
						'nac_filter_rules'         => \&ibap_i2o_range_filters,
						'option_filter_rules'      => \&ibap_i2o_range_filters,
                        'fingerprint_filter_rules' => \&ibap_i2o_range_filters,
						'recycle_leases'           => \&ibap_i2o_boolean,
						'relay_agent_filter_rules' => \&ibap_i2o_range_filters,
						'enable_ddns'  			   => \&ibap_i2o_boolean,
                        'use_known_clients'        => \&ibap_i2o_boolean,
                        'use_unknown_clients'      => \&ibap_i2o_boolean,
                        'update_dns_on_lease_renewal'     => \&ibap_i2o_boolean,
                        'use_update_dns_on_lease_renewal' => \&ibap_i2o_boolean,
                        'use_ddns_domainname'             => \&ibap_i2o_boolean,
                        'use_client_association_grace_period' => \&ibap_i2o_boolean,
                        'delegated_member'                    => \&ibap_i2o_mixed_member,
                        'cloud_api_compatible'                => \&ibap_i2o_boolean,
                        'option_logic_filters'     => \&ibap_i2o_ordered_filters,
                        'use_option_logic_filters' => \&ibap_i2o_boolean,
					   );

    #
    %_object_to_ibap = (
						'authority'					   	  => \&ibap_o2i_ignore,
						'bootfile'						  => \&ibap_o2i_ignore,
						'bootserver'					  => \&ibap_o2i_ignore,
						'comment'					   	  => \&ibap_o2i_string,
                        'ddns_domainname'                 => \&ibap_o2i_string,
						'ddns_generate_hostname'          => \&ibap_o2i_boolean,
						'deny_all_clients'                => \&ibap_o2i_boolean,
						'deny_bootp'					  => \&ibap_o2i_ignore,
						'enable_known_clients_option'     => \&ibap_o2i_boolean,
						'enable_unknown_clients_option'   => \&ibap_o2i_boolean,
						'server_association_type'         => \&ibap_o2i_enums_lc_or_undef,
						'exclude' 					      => \&ibap_o2i_exclusion_template,
                        'extattrs'                        => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'           => \&ibap_o2i_ignore,
						'filters' 					      => \&ibap_o2i_range_filters,
						'failover_assoc'  		          => \&ibap_o2i_range_failover,
						'member'          		          => \&ibap_o2i_mixed_member,
						'recycle_leases'				  => \&ibap_o2i_boolean,
						'enable_ddns'				   	  => \&ibap_o2i_boolean,
						'ignore_dhcp_option_list_request' => \&ibap_o2i_ignore,
                        'known_clients_option'            => \&ibap_o2i_string,
                        'lease_scavenge_time'             => \&ibap_o2i_integer,
						'nextserver'					  => \&ibap_o2i_ignore,
						'name'			                  => \&ibap_o2i_string,
						'number_of_addresses'			  => \&ibap_o2i_integer,
						'offset'					   	  => \&ibap_o2i_integer,
						'options'					   	  => \&ibap_o2i_ignore,
                        'override_lease_scavenge_time'    => \&ibap_o2i_boolean,
						'pxe_lease_time'				  => \&ibap_o2i_ignore,
						'range_high_water_mark'           => \&ibap_o2i_uint,
						'range_high_water_mark_reset'     => \&ibap_o2i_uint,
						'range_low_water_mark'            => \&ibap_o2i_uint,
						'range_low_water_mark_reset'      => \&ibap_o2i_uint,
                        'unknown_clients_option'          => \&ibap_o2i_string,
                        'update_dns_on_lease_renewal'         => \&ibap_o2i_boolean,
                        'override_logic_filters'        => \&ibap_o2i_boolean,
                        'logic_filters'                 => \&ibap_o2i_ordered_filters,

						#

                        'override_update_dns_on_lease_renewal' => \&ibap_o2i_boolean,
                        'override_ddns_domainname'             => \&ibap_o2i_boolean,
						'use_enable_ddns' 		=> \&ibap_o2i_boolean,
						'use_generate_hostname'	=> \&ibap_o2i_boolean,
						'use_recycle_leases'	=> \&ibap_o2i_boolean,
						'use_is_authoritative' 	=> \&ibap_o2i_ignore,

						#
						#
						#
						#

						'use_boot_file' 	   				  => \&ibap_o2i_ignore,
						'use_boot_server' 	   				  => \&ibap_o2i_ignore,
						'use_next_server' 	   				  => \&ibap_o2i_ignore,
						'use_deny_bootp' 	   				  => \&ibap_o2i_ignore,
						'use_domain_name' 	   				  => \&ibap_o2i_ignore,
						'use_domain_name_servers' 	   		  => \&ibap_o2i_ignore,
						'use_ignore_client_requested_options' => \&ibap_o2i_ignore,
						'use_lease_time' 	   				  => \&ibap_o2i_ignore,
						'use_options' 	   					  => \&ibap_o2i_ignore,
						'use_pxe_lease_time' 	   			  => \&ibap_o2i_ignore,

                        #
                        use_routers                         => \&ibap_o2i_ignore,
                        use_router_templates                => \&ibap_o2i_ignore,
                        routers                             => \&ibap_o2i_ignore,
                        use_broadcast_address               => \&ibap_o2i_ignore,
                        use_broadcast_address_offset        => \&ibap_o2i_ignore,
                        broadcast_address                   => \&ibap_o2i_ignore,

                        'delegated_member'                  => \&ibap_o2i_delegated_member,
                        'cloud_api_compatible'              => \&ibap_o2i_boolean,
					   );

    @_return_fields = (
                       tField('comment'),
                       tField('broadcast_address_offset'),
                       tField('client_association_grace_period'),
                       tField('deny_all_clients'),
                       tField('ddns_domainname'),
                       tField('domain_name'),
                       tField('domain_name_servers'),
                       tField('enable_ddns'),
                       tField('server_association_type'),
                       tField('enable_pxe_lease_time'),
                       tField('generate_hostname'),
                       tField('known_clients_option'),
                       tField('lease_time'),
                       tField('member'),
                       tField('ms_server',
                              { sub_fields => [tField('address'),
                                               tField('server_name')] }),
                       tField('name'),
                       tField('number_of_addresses'),
                       tField('offset'),
                       tField('options'),
                       tField('pxe_lease_time'),
                       tField('range_high_water_mark'),
                       tField('range_high_water_mark_reset'),
                       tField('range_low_water_mark'),
                       tField('range_low_water_mark_reset'),
                       tField('recycle_leases'),
                       tField('router_templates'),
                       tField('unknown_clients_option'),
                       tField('use_broadcast_address_offset'),
                       tField('use_client_association_grace_period'),
                       tField('use_domain_name'),
                       tField('use_domain_name_servers'),
                       tField('use_enable_ddns'),
                       tField('update_dns_on_lease_renewal'),
                       tField('use_update_dns_on_lease_renewal'),
                       tField('use_ddns_domainname'),
                       tField('use_generate_hostname'),
                       tField('use_known_clients'),
                       tField('use_lease_time'),
                       tField('use_options'),
                       tField('use_pxe_lease_time'),
                       tField('use_recycle_leases'),
                       tField('use_router_templates'),
                       tField('use_unknown_clients'),
                       tField('bootp_properties', { depth => 1 }),
                       tField('failover_association',
                          { sub_fields => [tField('name')] }),
                       tField('member', return_fields_member_basic_data()),
                       tField('exclusion_ranges', { depth => 1 }),
                       return_fields_extensible_attributes(),
                       tField('bootp_properties', { depth => 1 }),
                       tField('delegated_member', return_fields_member_basic_data_no_access_ok()),
                       tField('cloud_api_compatible'),
                       tField('use_option_logic_filters'),
                       tField('option_logic_filters', return_fields_option_logic_filters()),
                       );

    foreach my $filter ('mac_filter_rules', 'option_filter_rules', 'nac_filter_rules', 'relay_agent_filter_rules', 'fingerprint_filter_rules') {
        push @_return_fields, tField( $filter,
                                     {
                                      sub_fields =>
                                      [ tField('filter',
                                               { sub_fields => [tField('name')]}),
                                        tField('permission')
                                      ]
                                     }
                                    );
    }
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

    if (defined $args{'server_association_type'}) {
        #
        #
        $self->server_association_type($args{'server_association_type'});
    }

	$self->{__object_id_cache__} = {};
    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

	$self->{__object_id_cache__} = {};
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
sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'use_update_dns_on_lease_renewal'} = 0 unless defined $$ibap_object_ref{'use_update_dns_on_lease_renewal'};
    $$ibap_object_ref{'update_dns_on_lease_renewal'}  = 0 unless defined $$ibap_object_ref{'update_dns_on_lease_renewal'};
    $$ibap_object_ref{'use_ddns_domainname'}          = 0 unless defined $$ibap_object_ref{'use_ddns_domainname'};
    $$ibap_object_ref{'use_known_clients'}     = 0 unless defined $$ibap_object_ref{'use_known_clients'};
    $$ibap_object_ref{'use_unknown_clients'}   = 0 unless defined $$ibap_object_ref{'use_unknown_clients'};
    $$ibap_object_ref{'use_client_association_grace_period'}  = 0 unless defined $$ibap_object_ref{'use_client_association_grace_period'};
    $$ibap_object_ref{'use_option_logic_filters'} = 0 unless defined $$ibap_object_ref{'use_option_logic_filters'};

	if (defined $$ibap_object_ref{'bootp_properties'}) {
		$$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'}  = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'};
		$$ibap_object_ref{'bootp_properties'}{'use_boot_file'}   = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_boot_file'};
		$$ibap_object_ref{'bootp_properties'}{'use_boot_server'} = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_boot_server'};
		$$ibap_object_ref{'bootp_properties'}{'use_next_server'} = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_next_server'};
	}
    $$ibap_object_ref{'cloud_api_compatible'}                    = 0 unless defined $$ibap_object_ref{'cloud_api_compatible'};

    #
    $self->deny_bootp('false');
    $self->{'use_deny_bootp'} = 0;

	if (defined $$ibap_object_ref{'bootp_properties'}) {
		ibap_i2o_bootp_props($self,$session,'bootp_properties',$ibap_object_ref);
	}

    my $result = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

	my %temp = ( 'common_properties' => $ibap_object_ref );
	ibap_i2o_common_dhcp_props($self,$session, 'common_properties', \%temp);

	#
	#
	#

	if (defined $$ibap_object_ref{'use_enable_ddns'}) {
		$self->{'use_enable_ddns'}=$$ibap_object_ref{'use_enable_ddns'};
		if ($$ibap_object_ref{'use_enable_ddns'} != 1) {
			delete $self->{'enable_ddns'};
		}
	}

	if (defined $$ibap_object_ref{'use_generate_hostname'}) {
		$self->{'use_generate_hostname'}=$$ibap_object_ref{'use_generate_hostname'};
		if ($$ibap_object_ref{'use_generate_hostname'} != 1) {
			delete $self->{'ddns_generate_hostname'};
		}
	}

	if (defined $$ibap_object_ref{'use_recycle_leases'}) {
		$self->{'use_recycle_leases'}=$$ibap_object_ref{'use_recycle_leases'};
		if ($$ibap_object_ref{'use_recycle_leases'} != 1) {
			delete $self->{'recycle_leases'};
		}
	}

	if (defined $$ibap_object_ref{'server_association_type'}) {
		$self->{'server_association_type'}=$$ibap_object_ref{'server_association_type'};
		if ($$ibap_object_ref{'server_association_type'} ne 'FAILOVER' && $$ibap_object_ref{'server_association_type'} ne 'MS_FAILOVER') {
			delete $self->{'failover_assoc'};
		}
		if ($$ibap_object_ref{'server_association_type'} ne 'MEMBER' && $$ibap_object_ref{'server_association_type'} ne 'MS_SERVER') {
			delete $self->{'member'};
		}
	}

	if (defined $$ibap_object_ref{'use_is_authoritative'}) {
		$self->{'use_is_authoritative'}=$$ibap_object_ref{'use_is_authoritative'};
		if ($$ibap_object_ref{'use_is_authoritative'} != 1) {
			delete $self->{'authority'};
		}
	}

	if (defined $$ibap_object_ref{'bootp_properties'}) {
        if (defined $$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'}) {
            $self->{'use_deny_bootp'}=$$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'};
            if ($self->{'use_deny_bootp'} != 1) {
                delete $self->{'deny_bootp'};
            }
        }

        if (defined $$ibap_object_ref{'bootp_properties'}{'use_boot_file'}) {
            $self->{'use_boot_file'}=$$ibap_object_ref{'bootp_properties'}{'use_boot_file'};
            if ($self->{'use_boot_file'} != 1) {
                delete $self->{'bootfile'};
            }
        }

        if (defined $$ibap_object_ref{'bootp_properties'}{'use_boot_server'}) {
            $self->{'use_boot_server'}=$$ibap_object_ref{'bootp_properties'}{'use_boot_server'};
            if ($self->{'use_boot_server'} != 1) {
                delete $self->{'bootserver'};
            }
        }

        if (defined $$ibap_object_ref{'bootp_properties'}{'use_next_server'}) {
            $self->{'use_next_server'}=$$ibap_object_ref{'bootp_properties'}{'use_next_server'};
            if ($self->{'use_next_server'} != 1) {
                delete $self->{'nextserver'};
            }
        }
    }

    #
    $self->{'override_ddns_domainname'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_domainname'});
    $self->{'override_update_dns_on_lease_renewal'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_update_dns_on_lease_renewal'});
    $self->{'override_lease_scavenge_time'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_client_association_grace_period'});
    $self->{'override_logic_filters'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_option_logic_filters'});

	return $result;
}

#

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;

    my $ref_write_fields=$self->SUPER::__object_to_ibap__($server, $session);

	my @bootp_options = ibap_arg_bootp_props($self, $session, '', $self);
	if (@bootp_options) {
		my $success=shift @bootp_options;
		if ($success) {
			my $ignore_value=shift @bootp_options;
			unless ($ignore_value) {
				my $cref = shift @bootp_options;
                                $cref = $cref->value();
				foreach my $key (keys %{$cref}) {
					my %write_arg;

					$write_arg{'field'} = $key;
					$write_arg{'value'} = $$cref{$key};

					unshift @{$ref_write_fields}, \%write_arg;
				}
			}
		}
		else {
			return;
		}
	}

	my @common_options = ibap_o2i_common_dhcp_props($self, $session, '', $self);
	if (@common_options) {
		my $success=shift @common_options;
		if ($success) {
			my $ignore_value=shift @common_options;
			unless ($ignore_value) {
				my $cref = shift @common_options;

                $cref = $cref->value();

				foreach my $key (keys %{$cref}) {
					my %write_arg;
					$write_arg{'field'} = $key;
					$write_arg{'value'} = $$cref{$key};
					unshift @{$ref_write_fields}, \%write_arg;
				}
			}
		}
		else {
			return;
		}
	}

    return $ref_write_fields;
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

sub deny_bootp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'deny_bootp', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_deny_bootp'}}, @_);
}

sub deny_all_clients
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'deny_all_clients', validator => \&ibap_value_o2i_boolean}, @_);
}

sub exclude
{
    my $self = shift;

    return $self->__accessor_array__({name => 'exclude', validator => { 'Infoblox::DHCP::ExclusionRangeTemplate' => 1 }}, @_);
}

sub filters
{
    my $self = shift;

    return $self->__accessor_array__({name => 'filters', validator => { 'Infoblox::DHCP::FilterRule::MAC' => 1, 'Infoblox::DHCP::FilterRule::NAC' => 1, 'Infoblox::DHCP::FilterRule::RelayAgent' => 1, 'Infoblox::DHCP::FilterRule::Option' => 1, 'Infoblox::DHCP::FilterRule::Fingerprint' => 1 }}, @_);
}

sub options
{
    my $self  = shift;
    return ibap_accessor_dhcp_options($self, 'options', @_);
}

sub override_lease_scavenge_time
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_lease_scavenge_time', validator => \&ibap_value_o2i_boolean}, @_);
}

sub bootfile
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'bootfile', validator => \&ibap_value_o2i_string, use => \$self->{'use_boot_file'}}, @_);
}

sub nextserver
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'nextserver', validator => \&ibap_value_o2i_string, use => \$self->{'use_next_server'}}, @_);
}

sub bootserver
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'bootserver', validator => \&ibap_value_o2i_string, use => \$self->{'use_boot_server'}}, @_);
}

sub pxe_lease_time
{
    my $self  = shift;
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

sub recycle_leases
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'recycle_leases', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_recycle_leases'}}, @_);
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
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ddns_generate_hostname', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_generate_hostname'}}, @_);
}

sub enable_ddns
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_ddns', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_enable_ddns'}}, @_);
}

sub authority
{
    my $self  = shift;
    return $self->__accessor_scalar__({deprecated => 1}, @_);
}

sub server_association_type
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'server_association_type', enum => ['NONE', 'MEMBER', 'FAILOVER', 'MS_SERVER', 'MS_FAILOVER'] }, @_);
}

sub failover_assoc
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'failover_assoc' };
    }
    else
    {
        my $value = shift;
        #
        if( !defined $value )
        {
            if (not defined $self->member()) {
                $self->{ 'server_association_type' } = 'NONE';
            }
            $self->{ 'failover_assoc' } = undef;
        }
        else
        {
            $self->{ 'server_association_type' } = 'FAILOVER';
			$self->{ 'failover_assoc' } = $value;
            $self->{ 'member' } = undef;
		}
	}
	return 1;
}

sub lease_scavenge_time
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'lease_scavenge_time', use => \$self->{'override_lease_scavenge_time'}, use_truefalse => 1, validator => \&ibap_value_o2i_int},@_);
}

sub member
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'member' };
    }
    else
    {
        my $value = shift;
        #
        #
        if ((not defined $value) || $value eq '') {
            if (not defined $self->failover_assoc()) {
                $self->{ 'server_association_type' } = 'NONE';
            }
            $self->{ 'member' } = $value;
        }
        else
        {
            if( Infoblox::Util::check_object_type( $value , [ 'Infoblox::DHCP::Member' ] ))
            {
                $self->{ 'member' } = $value;
				$self->{ 'server_association_type' } = 'MEMBER';
				$self->{ 'failover_assoc' } = undef;
            } elsif (Infoblox::Util::check_object_type( $value , [ 'Infoblox::DHCP::MSServer' ] )) {
                $self->{ 'member' } = $value;
				$self->{ 'server_association_type' } = 'MS_SERVER';
				$self->{ 'failover_assoc' } = undef;
            }
            else
            {
				set_error_codes(1104,'Invalid data type for member member.' );
                return;
            }
        }
    }
    return 1;
}

sub number_of_addresses
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'number_of_addresses', validator => \&ibap_value_o2i_uint}, @_);
}

sub offset
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'offset', validator => \&ibap_value_o2i_uint}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub enable_known_clients_option
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_known_clients_option', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_unknown_clients_option
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_unknown_clients_option', validator => \&ibap_value_o2i_boolean}, @_);
}

sub known_clients_option
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'known_clients_option', enum => ['Allow','Deny'] }, @_);
}

sub unknown_clients_option
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'unknown_clients_option', enum => ['Allow','Deny'] }, @_);
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

sub range_high_water_mark
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_high_water_mark', validator => \&ibap_value_o2i_uint}, @_);
}

sub range_high_water_mark_reset
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_high_water_mark_reset', validator => \&ibap_value_o2i_uint}, @_);
}

sub range_low_water_mark
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_low_water_mark', validator => \&ibap_value_o2i_uint}, @_);
}

sub range_low_water_mark_reset
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_low_water_mark_reset', validator => \&ibap_value_o2i_uint}, @_);
}

1;
