package Infoblox::DHCP::FixedAddrTemplate;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_name_mappings %_reverse_name_mappings %_searchable_fields %_ibap_to_object %_object_to_ibap @_return_fields %_capabilities %_return_field_overrides);
@ISA = qw(Infoblox::IBAPBase);

BEGIN
{
	$_object_type = 'FixedAddressTemplate';
    register_wsdl_type('ib:FixedAddressTemplate','Infoblox::DHCP::FixedAddrTemplate');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 0,
					  'single_serialization' => 0,
					 );

    #
    #
    %_allowed_members = (
						 bootfile 					   	 => 0,
						 bootserver 					 => 0,
						 comment 						 => 0,
						 ddns_domainname 				 => 0,
                         override_ddns_domainname         => 0,
						 ddns_hostname 				   	 => 0,
						 deny_bootp 					 => 0,
						 enable_ddns 					 => 0,
                         extattrs                        => 0,
						 extensible_attributes		     => 0,
						 ignore_dhcp_option_list_request => 0,
						 name 						   	 => 1,
						 nextserver 					 => 0,
						 number_of_addresses 			 => 0,
						 offset 						 => 0,
						 options 						 => 0,
						 pxe_lease_time 				 => 0,
                         cloud_api_compatible            => 0,
                         logic_filters                   => {array => 1, validator => {string => 1, 'Infoblox::DHCP::Filter::MAC' => 1,
                                                             'Infoblox::DHCP::Filter::NAC' => 1, 'Infoblox::DHCP::Filter::Option' => 1},
                                                              use => 'override_logic_filters', use_truefalse => 1},
                         override_logic_filters          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
						);

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    #
    %_name_mappings = (
                       'extattrs'                 => 'extensible_attributes',
                       'override_ddns_domainname' => 'use_ddns_domainname',
                       'logic_filters'            => 'option_logic_filters',
                       'override_logic_filters'   => 'use_option_logic_filters',
					  );

    %_reverse_name_mappings = reverse %_name_mappings;

	%_return_field_overrides = (
                                'bootfile'                        => ['!bootp_properties'],
                                'bootserver'                      => ['!bootp_properties'],
                                'comment'                         => [],
                                'ddns_domainname'                 => ['use_ddns_domainname'],
                                'override_ddns_domainname'         => [],
                                'ddns_hostname'                   => [],
                                'deny_bootp'                      => ['!bootp_properties'],
                                'enable_ddns'                     => ['use_enable_ddns'],
                                'extattrs'                        => [],
                                'extensible_attributes'           => [],
                                'ignore_dhcp_option_list_request' => ['use_ignore_client_requested_options'],
                                'name'                            => [],
                                'nextserver'                      => ['!bootp_properties'],
                                'number_of_addresses'             => [],
                                'offset'                          => [],
                                'options'                         => ['!common_properties'],
                                'pxe_lease_time'                  => ['!common_properties'],
                                'cloud_api_compatible'            => [],
                                'logic_filters'                     => ['use_option_logic_filters'],
                                'override_logic_filters'            => [],
							   );

    #
    %_searchable_fields = (
						   name => [\&ibap_o2i_string, 'name', 'REGEX'],
						   comment => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
						  );

    #
    %_ibap_to_object = (
						'enable_ddns'              => \&ibap_i2o_boolean,
                        'extensible_attributes'    => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'use_ddns_domainname'      => \&ibap_i2o_boolean,
                        'cloud_api_compatible'     => \&ibap_i2o_boolean,
                        'option_logic_filters'     => \&ibap_i2o_ordered_filters,
                        'use_option_logic_filters' => \&ibap_i2o_boolean,
					   );

    #
    %_object_to_ibap = (
						'bootfile'						  => \&ibap_o2i_ignore,
						'bootserver'					  => \&ibap_o2i_ignore,
						'comment'					   	  => \&ibap_o2i_string,
						'deny_bootp'					  => \&ibap_o2i_ignore,
                        'extattrs'                        => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'           => \&ibap_o2i_ignore,
						'ddns_domainname' 				  => \&ibap_o2i_string,
						'ddns_hostname' 				  => \&ibap_o2i_string,
						'enable_ddns'				   	  => \&ibap_o2i_boolean,
						'ignore_dhcp_option_list_request' => \&ibap_o2i_ignore,
						'name'  						  => \&ibap_o2i_string,
						'nextserver'					  => \&ibap_o2i_ignore,
						'number_of_addresses'			  => \&ibap_o2i_integer,
						'offset' 						  => \&ibap_o2i_integer,
						'options'					   	  => \&ibap_o2i_ignore,
						'pxe_lease_time'				  => \&ibap_o2i_ignore,
                        'cloud_api_compatible'            => \&ibap_o2i_boolean,
                        'override_logic_filters'          => \&ibap_o2i_boolean,
                        'logic_filters'                   => \&ibap_o2i_ordered_filters,

						#

						'use_enable_ddns' => \&ibap_o2i_boolean,

						#
						#
						#
						#

                        'override_ddns_domainname'             => \&ibap_o2i_boolean,
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
					   );

    #
    @_return_fields = (
                       tField('comment'),
                       tField('broadcast_address_offset'),
                       tField('ddns_domainname'),
                       tField('ddns_hostname'),
                       tField('domain_name'),
                       tField('domain_name_servers'),
                       tField('enable_ddns'),
                       tField('enable_pxe_lease_time'),
                       tField('ignore_client_requested_options'),
                       tField('lease_time'),
                       tField('name'),
                       tField('number_of_addresses'),
                       tField('offset'),
                       tField('options'),
                       tField('pxe_lease_time'),
                       tField('router_templates'),
                       tField('use_broadcast_address_offset'),
                       tField('use_ddns_domainname'),
                       tField('use_domain_name'),
                       tField('use_domain_name_servers'),
                       tField('use_enable_ddns'),
                       tField('use_ignore_client_requested_options'),
                       tField('use_lease_time'),
                       tField('use_options'),
                       tField('use_pxe_lease_time'),
                       tField('use_router_templates'),
                       return_fields_extensible_attributes(),
                       tField('bootp_properties', { depth => 1 }),
                       tField('cloud_api_compatible'),
                       tField('use_option_logic_filters'),
                       tField('option_logic_filters', return_fields_option_logic_filters()),
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
sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    
    $$ibap_object_ref{'use_ddns_domainname'}      = 0 unless defined $$ibap_object_ref{'use_ddns_domainname'};
    $$ibap_object_ref{'use_option_logic_filters'} = 0 unless defined $$ibap_object_ref{'use_option_logic_filters'};

	if (defined $$ibap_object_ref{'bootp_properties'}) {
		$$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'}  = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'};
		$$ibap_object_ref{'bootp_properties'}{'use_boot_file'}   = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_boot_file'};
		$$ibap_object_ref{'bootp_properties'}{'use_boot_server'} = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_boot_server'};
		$$ibap_object_ref{'bootp_properties'}{'use_next_server'} = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_next_server'};

	}

    #
    $self->deny_bootp('false');
    $self->{'use_deny_bootp'} = 0;

	if (defined $$ibap_object_ref{'bootp_properties'}) {
		ibap_i2o_bootp_props($self,$session,'bootp_properties',$ibap_object_ref);
	}

    $$ibap_object_ref{'cloud_api_compatible'} = 0 unless defined $$ibap_object_ref{'cloud_api_compatible'};

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
    $self->{'override_ddns_domainname'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_domainname'});
    $self->{'override_logic_filters'}   = ibap_value_i2o_boolean($$ibap_object_ref{'use_option_logic_filters'});

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
				my $valcref = shift @bootp_options;

                #
                my $cref=$$valcref{'val'};
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
				my $valcref = shift @common_options;
                my $cref=$$valcref{'val'};

                #
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


sub ignore_dhcp_option_list_request
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ignore_dhcp_option_list_request', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_ignore_client_requested_options'}}, @_);
}

sub deny_bootp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'deny_bootp', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_deny_bootp'}}, @_);
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

sub ddns_hostname
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ddns_hostname', validator => \&ibap_value_o2i_string}, @_);
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

sub enable_ddns
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_ddns', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_enable_ddns'}}, @_);
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

sub cloud_api_compatible
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'cloud_api_compatible', validator => \&ibap_value_o2i_boolean}, @_);
}

1;
