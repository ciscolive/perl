package Infoblox::DHCP::SharedNetwork;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object $_return_fields_initialized %_capabilities %_return_field_overrides);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'SharedNetwork';
    register_wsdl_type('ib:SharedNetwork','Infoblox::DHCP::SharedNetwork');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members = (
       authority 					   => 0,
       bootfile 					   => 0,
       bootserver 					   => 0,
       comment 						   => 0,
       ddns_generate_hostname 		   => 0,
       ddns_server_always_updates 	   => 0,
       ddns_ttl 					   => 0,
       override_ddns_ttl                    => 0,
       ddns_update_fixed_addresses 	   => 0,
       ddns_use_option81 			   => 0,
       deny_bootp 					   => 0,
       disable 						   => 0,
       enable_ddns 					   => 0,
       extattrs                        => 0,
       extensible_attributes           => 0,
       ignore_dhcp_option_list_request => 0,
       lease_scavenge_time             => 0,
       override_lease_scavenge_time    => 0,
       name 						   => 1,
       networks 					   => 0,
       network_view					   => 0,
       nextserver 					   => 0,
       options 						   => 0,
       pxe_lease_time 				   => 0,
       update_dns_on_lease_renewal         => 0,
       override_update_dns_on_lease_renewal => 0,
       ignore_client_identifier          => 0, # replaced by ignore_id
       override_ignore_client_identifier => 0, # replaced by override_ignore_id
       ignore_id                         => {simple => 'asis', enum => ['NONE', 'CLIENT', 'MACADDR'], use => 'override_ignore_id', use_truefalse => 1},
       ignore_mac_addresses              => {array => 1, validator => \&ibap_value_o2i_string, use => 'override_ignore_id', use_truefalse => 1},
       override_ignore_id                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       ms_ad_user_data                   => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
       logic_filters                     => {array => 1, validator => {string => 1, 'Infoblox::DHCP::Filter::MAC' => 1,
                                             'Infoblox::DHCP::Filter::NAC' => 1, 'Infoblox::DHCP::Filter::Option' => 1},
                                             use => 'override_logic_filters', use_truefalse => 1},
       override_logic_filters            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
                                authority 					    => ['use_is_authoritative'],
								bootfile						=> ['!bootp_properties'],
								bootserver					    => ['!bootp_properties'],
                                comment 						=> [],
                                ddns_generate_hostname 		    => ['use_generate_hostname'],
                                ddns_server_always_updates 	    => [],
								ddns_ttl					    => ['use_ddns_ttl'],
                                override_ddns_ttl                => [],
                                ddns_update_fixed_addresses 	=> ['use_update_static_leases'],
                                ddns_use_option81 			    => ['use_enable_option81'],
                                deny_bootp 					    => ['!bootp_properties'],
                                disable 						=> [],
                                enable_ddns 					=> ['use_enable_ddns'],
                                extattrs                        => [],
                                extensible_attributes           => [],
                                ignore_dhcp_option_list_request => [],
                                lease_scavenge_time             => ['use_client_association_grace_period'],
                                override_lease_scavenge_time    => [],
                                name 						    => [],
                                networks 					    => [],
                                network_view					=> [],
                                nextserver 					    => ['!bootp_properties'],
                                options 						=> ['!common_properties'],
                                pxe_lease_time 				    => ['!common_properties'],
                                update_dns_on_lease_renewal         => ['use_update_dns_on_lease_renewal'],
                                override_update_dns_on_lease_renewal => [],
                                ignore_id                         => ['use_ignore_id'],
                                ignore_mac_addresses              => ['use_ignore_id'],
                                override_ignore_id                => [],
                                ignore_client_identifier          => ['ignore_id','use_ignore_id'],
                                override_ignore_client_identifier => ['use_ignore_id'],
                                ms_ad_user_data                   => [],
                                logic_filters                     => ['use_option_logic_filters'],
                                override_logic_filters            => [],
                               );

    %_searchable_fields = (
						   name    => [\&ibap_o2i_string, 'name'   , 'REGEX'],
                           network_view => [\&ibap_o2i_network_view ,'network_view', 'EXACT'],
                           network     => [\&ibap_o2i_network      ,'network'        , 'SEARCHONLY_LIST_CONTAIN'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
						  );

    %_name_mappings = (
					   'authority' 					 => 'is_authoritative',
					   'ddns_generate_hostname' 	 => 'generate_hostname',
					   'ddns_server_always_updates'  => 'always_update_dns',
					   'ddns_update_fixed_addresses' => 'update_static_leases',
					   'ddns_use_option81' 			 => 'enable_option81',
					   'disable' 					 => 'disabled',
                       'extattrs'                     => 'extensible_attributes',
                       'lease_scavenge_time'         => 'client_association_grace_period',
                       'override_lease_scavenge_time' => 'use_client_association_grace_period',
                       'override_update_dns_on_lease_renewal' => 'use_update_dns_on_lease_renewal',
                       'override_ddns_ttl'            => 'use_ddns_ttl',
                       'override_ignore_id' => 'use_ignore_id',
                       'logic_filters'          => 'option_logic_filters',
                       'override_logic_filters' => 'use_option_logic_filters',
				   );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
						'always_update_dns'    => \&ibap_i2o_boolean,
						'disabled' 			   => \&ibap_i2o_boolean,
						'enable_ddns' 		   => \&ibap_i2o_boolean,
						'enable_option81' 	   => \&ibap_i2o_boolean,
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
						'generate_hostname'    => \&ibap_i2o_boolean,
						'is_authoritative' 	   => \&ibap_i2o_boolean,
						'networks' 			   => \&ibap_i2o_generic_object_list_convert,
						'network_view' 		   => \&ibap_i2o_generic_object_convert,
						'update_static_leases' => \&ibap_i2o_boolean,
                        'update_dns_on_lease_renewal'     => \&ibap_i2o_boolean,
                        'use_update_dns_on_lease_renewal' => \&ibap_i2o_boolean,
                        'use_ddns_ttl'                    => \&ibap_i2o_boolean,
                        'use_client_association_grace_period' => \&ibap_i2o_boolean,
                        'ignore_id'            => \&ibap_i2o_enums_uc_or_undef,
                        'ignore_mac_addresses' =>  \&ibap_i2o_mac_addresses,
                        'use_ignore_id'        => \&ibap_i2o_boolean,
                        'ms_ad_user_data'      => \&ibap_i2o_generic_object_convert,
                        'option_logic_filters'     => \&ibap_i2o_ordered_filters,
                        'use_option_logic_filters' => \&ibap_i2o_boolean,
					   );

    %_object_to_ibap = (
						'authority'					   	  => \&ibap_o2i_boolean,
						'bootfile'						  => \&ibap_o2i_ignore,
						'bootserver'					  => \&ibap_o2i_ignore,
						'comment'					   	  => \&ibap_o2i_string,
						'deny_bootp'					  => \&ibap_o2i_ignore,
						'ddns_generate_hostname'		  => \&ibap_o2i_boolean,
						'ddns_server_always_updates'	  => \&ibap_o2i_boolean,
						'ddns_ttl'					   	  => \&ibap_o2i_integer,
						'ddns_update_fixed_addresses'     => \&ibap_o2i_boolean,
						'ddns_use_option81'			   	  => \&ibap_o2i_boolean,
						'disable'					   	  => \&ibap_o2i_boolean,
						'enable_ddns'				   	  => \&ibap_o2i_boolean,
                        'extattrs'                        => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'           => \&ibap_o2i_ignore,
						'ignore_dhcp_option_list_request' => \&ibap_o2i_ignore,
                        'lease_scavenge_time'             => \&ibap_o2i_integer,
						'name'                            => \&ibap_o2i_string,
						'nextserver'                      => \&ibap_o2i_ignore,
						'networks'                        => \&ibap_o2i_network_list,
						'network_view'                    => \&ibap_o2i_network_view,
						'nextserver'                      => \&ibap_o2i_ignore,
						'options'                         => \&ibap_o2i_ignore,
						'pxe_lease_time'                  => \&ibap_o2i_ignore,
                        'update_dns_on_lease_renewal'     => \&ibap_o2i_boolean,
                        'ignore_id'                       => \&ibap_o2i_string,
                        'ignore_mac_addresses'            => \&ibap_o2i_mac_addresses,
                        'ms_ad_user_data'                 => \&ibap_o2i_ignore,
                        'override_logic_filters'        => \&ibap_o2i_boolean,
                        'logic_filters'                 => \&ibap_o2i_ordered_filters,

						#

                        'override_update_dns_on_lease_renewal' => \&ibap_o2i_boolean,
                        'override_ddns_ttl'                    => \&ibap_o2i_boolean,
                        'override_lease_scavenge_time'         => \&ibap_o2i_boolean,
                        'override_ignore_id'    => \&ibap_o2i_boolean,
						'use_enable_ddns' 		   => \&ibap_o2i_boolean,
						'use_enable_option81' 	   => \&ibap_o2i_boolean,
						'use_enable_thresholds'    => \&ibap_o2i_boolean,
						'use_generate_hostname'    => \&ibap_o2i_boolean,
						'use_is_authoritative' 	   => \&ibap_o2i_boolean,
						'use_update_static_leases' => \&ibap_o2i_boolean,

						#
						#
						#
						#

						'use_boot_file' 	   				  => \&ibap_o2i_ignore,
						'use_boot_server' 	   				  => \&ibap_o2i_ignore,
						'use_next_server' 	   				  => \&ibap_o2i_ignore,
						'use_broadcast_address' 	   		  => \&ibap_o2i_ignore,
						'use_deny_bootp' 	   				  => \&ibap_o2i_ignore,
						'use_domain_name' 	   				  => \&ibap_o2i_ignore,
						'use_domain_name_servers' 	   		  => \&ibap_o2i_ignore,
						'use_ignore_client_requested_options' => \&ibap_o2i_ignore,
						'use_lease_time' 	   				  => \&ibap_o2i_ignore,
						'use_options' 	   					  => \&ibap_o2i_ignore,
						'use_pxe_lease_time' 	   			  => \&ibap_o2i_ignore,
						'use_routers' 	   					  => \&ibap_o2i_ignore,
					   );

    $_return_fields_initialized=0;
    @_return_fields = (
					   tField('always_update_dns'),
                       tField('client_association_grace_period'),
                       tField('use_client_association_grace_period'),
					   tField('comment'),
					   tField('ddns_ttl'),
                       tField('update_dns_on_lease_renewal'),
                       tField('use_update_dns_on_lease_renewal'),
                       tField('use_ddns_ttl'),
					   tField('disabled'),
					   tField('enable_ddns'),
					   tField('enable_option81'),
					   tField('generate_hostname'),
					   tField('is_authoritative'),
					   tField('name'),
					   tField('update_static_leases'),
					   tField('use_enable_ddns'),
					   tField('use_enable_option81'),
					   tField('use_generate_hostname'),
					   tField('use_is_authoritative'),
					   tField('use_update_static_leases'),
                       tField('ignore_id'),
                       tField('ignore_mac_addresses',{ sub_fields => [ tField('mac_addr')]}),
                       tField('use_ignore_id'),
                       tField('use_option_logic_filters'),
                       tField('option_logic_filters', return_fields_option_logic_filters()),
					   tField('common_properties',
                                                  { depth => 2 }),
					   tField('bootp_properties',
                                                  { depth => 1 }),
                       return_fields_extensible_attributes(),
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
        my $t = Infoblox::DHCP::Network->__new__();
        push @_return_fields, tField('networks',
                                 {
                                  default_no_access_ok => 1,
                                  sub_fields => $t->__return_fields__(),
                                 });

        $t = Infoblox::DHCP::View->__new__();
        push @_return_fields, tField('network_view', {
                                                      default_no_access_ok => 1,
                                                      sub_fields => $t->__return_fields__(),
                                                     });

        $t = Infoblox::Grid::MSServer::AdUser::Data->__new__();
        push @_return_fields, tField('ms_ad_user_data', {sub_fields => $t->__return_fields__()});

    }
}

sub __ibap_object_type__
{
	#
	return 'SharedNetwork';
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
	$$ibap_object_ref{'use_enable_ddns'} 		 = 0 unless defined $$ibap_object_ref{'use_enable_ddns'};
    $$ibap_object_ref{'use_client_association_grace_period'}          = 0 unless defined $$ibap_object_ref{'use_client_association_grace_period'};
	$$ibap_object_ref{'use_enable_option81'} 	 = 0 unless defined $$ibap_object_ref{'use_enable_option81'};
	$$ibap_object_ref{'use_generate_hostname'} 	 = 0 unless defined $$ibap_object_ref{'use_generate_hostname'};
	$$ibap_object_ref{'use_is_authoritative'} 	 = 0 unless defined $$ibap_object_ref{'use_is_authoritative'};
	$$ibap_object_ref{'use_update_static_leases'} = 0 unless defined $$ibap_object_ref{'use_update_static_leases'};
    $$ibap_object_ref{'use_update_dns_on_lease_renewal'} = 0 unless defined $$ibap_object_ref{'use_update_dns_on_lease_renewal'};
    $$ibap_object_ref{'update_dns_on_lease_renewal'}  = 0 unless defined $$ibap_object_ref{'update_dns_on_lease_renewal'};
    $$ibap_object_ref{'use_ddns_ttl'}                 = 0 unless defined $$ibap_object_ref{'use_ddns_ttl'};
    $$ibap_object_ref{'use_ignore_id'}     = 0 unless defined $$ibap_object_ref{'use_ignore_id'};
    $$ibap_object_ref{'use_option_logic_filters'} = 0 unless defined $$ibap_object_ref{'use_option_logic_filters'};

	if (defined $$ibap_object_ref{'common_properties'}) {
		$$ibap_object_ref{'common_properties'}{'use_ignore_client_requested_options'} = 0 unless defined $$ibap_object_ref{'common_properties'}{'use_ignore_client_requested_options'};
		$$ibap_object_ref{'common_properties'}{'ignore_client_requested_options'} 	 = 0 unless defined $$ibap_object_ref{'common_properties'}{'ignore_client_requested_options'};
	}

	if (defined $$ibap_object_ref{'bootp_properties'}) {
		$$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'}  = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'};
		$$ibap_object_ref{'bootp_properties'}{'use_boot_file'}   = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_boot_file'};
		$$ibap_object_ref{'bootp_properties'}{'use_boot_server'} = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_boot_server'};
		$$ibap_object_ref{'bootp_properties'}{'use_next_server'} = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_next_server'};
	}

	#
    $self->authority('false');
	$self->{ 'use_is_authoritative' } = 0;

    $self->ddns_generate_hostname('false');
	$self->{ 'use_generate_hostname' } = 0;

    #
    $self->ddns_server_always_updates('false');

    $self->ddns_update_fixed_addresses('false');
	$self->{ 'use_update_static_leases' } = 0;

    $self->ddns_use_option81('false');
	$self->{ 'use_enable_option81' } = 0;

    $self->disable('false');

	$self->enable_ddns('false');
	$self->{ 'use_enable_ddns' } = 0;

    $self->deny_bootp('false');
    $self->{'use_deny_bootp'} = 0;
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref, {
                                                                                                     'use_root_name_server' => 1,
                                                                                                     'address' => 1,
                                                                                                     'netmask' => 1,
                                                                                                    });

	if (defined $$ibap_object_ref{'bootp_properties'}) {
		ibap_i2o_bootp_props($self,$session,'bootp_properties',$ibap_object_ref);
	}

        ibap_i2o_common_dhcp_props($self,$session,'common_properties',$ibap_object_ref);

	#
	#
	#

	if (defined $$ibap_object_ref{'use_enable_ddns'}) {
		$self->{'use_enable_ddns'}=$$ibap_object_ref{'use_enable_ddns'};
		if ($$ibap_object_ref{'use_enable_ddns'} != 1) {
			delete $self->{'enable_ddns'};
		}
	}

	if (defined $$ibap_object_ref{'use_enable_option81'}) {
		$self->{'use_enable_option81'}=$$ibap_object_ref{'use_enable_option81'};
		if ($$ibap_object_ref{'use_enable_option81'} != 1) {
			delete $self->{'ddns_use_option81'};
		}
	}

	if (defined $$ibap_object_ref{'use_generate_hostname'}) {
		$self->{'use_generate_hostname'}=$$ibap_object_ref{'use_generate_hostname'};
		if ($$ibap_object_ref{'use_generate_hostname'} != 1) {
			delete $self->{'ddns_generate_hostname'};
		}
	}

	if (defined $$ibap_object_ref{'use_is_authoritative'}) {
		$self->{'use_is_authoritative'}=$$ibap_object_ref{'use_is_authoritative'};
		if ($$ibap_object_ref{'use_is_authoritative'} != 1) {
			delete $self->{'authority'};
		}
	}

	if (defined $$ibap_object_ref{'use_update_static_leases'}) {
		$self->{'use_update_static_leases'}=$$ibap_object_ref{'use_update_static_leases'};
		if ($$ibap_object_ref{'use_update_static_leases'} != 1) {
			delete $self->{'ddns_update_fixed_addresses'};
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
    $self->{'override_ddns_ttl'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_ttl'});
    $self->{'override_update_dns_on_lease_renewal'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_update_dns_on_lease_renewal'});
    $self->{'override_lease_scavenge_time'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_client_association_grace_period'});
    $self->{'override_ignore_id'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_ignore_id'});
    $self->{'override_logic_filters'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_option_logic_filters'});

	return;
}

#
#
#
sub __object_to_ibap__
{
	my ($self, $server, $session) = @_;

	my @write_fields;

	my $saved_always_update=$self->{'ddns_server_always_updates'};
	my $saved_option81=$self->{'ddns_use_option81'};

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
	$self->{'ddns_server_always_updates'} = $saved_always_update;
    $self->{'ddns_use_option81'} = $saved_option81;

	my @bootp_options = ibap_arg_bootp_props($self, $session, '',$self);
	if (@bootp_options) {
		my $success=shift @bootp_options;
		if ($success) {
			my $ignore_value=shift @bootp_options;
			unless ($ignore_value) {
				my %write_arg;
				$write_arg{'field'} = 'bootp_properties';
				$write_arg{'value'} = shift @bootp_options;
				unshift @write_fields, \%write_arg;
			}
		}
		else {
			return;
		}
	}

	my @common_options = ibap_o2i_common_dhcp_props($self, $session, '',$self);
	if (@common_options) {
		my $success=shift @common_options;
		if ($success) {
			my $ignore_value=shift @common_options;
			unless ($ignore_value) {
				my %write_arg;
				$write_arg{'field'} = 'common_properties';
				$write_arg{'value'} = shift @common_options;
				unshift @write_fields, \%write_arg;
			}
		}
		else {
			return;
		}
	}

	return \@write_fields;
}

#
#
#

sub network_view
{
    my $self = shift;

    return $self->__accessor_scalar__({name => 'network_view', validator => { 'Infoblox::DHCP::View' => 1 }}, @_);
}

sub deny_bootp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'deny_bootp', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_deny_bootp'}}, @_);
}

sub ignore_dhcp_option_list_request
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ignore_dhcp_option_list_request', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_ignore_client_requested_options'}}, @_);
}

sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub options
{
    my $self  = shift;
    return ibap_accessor_dhcp_options($self, 'options', @_);
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

sub ddns_update_fixed_addresses
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ddns_update_fixed_addresses', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_update_static_leases'}}, @_);
}

sub ddns_generate_hostname
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ddns_generate_hostname', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_generate_hostname'}}, @_);
}

sub ddns_server_always_updates
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ddns_server_always_updates', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ddns_use_option81
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ddns_use_option81', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_enable_option81'}}, @_);
}

sub enable_ddns
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_ddns', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_enable_ddns'}}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub authority
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'authority', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_is_authoritative'}}, @_);
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

sub update_dns_on_lease_renewal 
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'update_dns_on_lease_renewal', validator => \&ibap_value_o2i_string, use => \$self->{'override_update_dns_on_lease_renewal'}, use_truefalse => 1}, @_);
}

sub override_update_dns_on_lease_renewal 
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_update_dns_on_lease_renewal', validator => \&ibap_value_o2i_boolean}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
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

sub networks
{
    my $self=shift;

    return $self->__accessor_array__({name => 'networks', validator => { 'Infoblox::DHCP::Network' => 1 }}, @_);
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub ignore_client_identifier
{
    my $self=shift;
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

sub override_ignore_client_identifier
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_ignore_id', validator => \&ibap_value_o2i_boolean}, @_);
}


1;
