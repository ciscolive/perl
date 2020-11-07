package Infoblox::IPAM::Address;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use vars qw( @ISA @_STATUS_ENUM_VALUES @_USAGE_ENUM_VALUES @_LEASE_STATE_ENUM_VALUES %_allowed_members %_name_mappings %_reverse_name_mappings %_searchable_fields %_ibap_to_object %_object_to_ibap @_return_fields @_optional_return_fields @_optional_return_fields %_return_field_overrides %_capabilities $_return_fields_initialized %_acceptable_ibap_types $newhostaddress);

@ISA = qw ( Infoblox::IBAPBase );

BEGIN
{
    register_wsdl_type('ib:IPv4Address', 'Infoblox::IPAM::Address');
    register_wsdl_type('ib:IPv6Address', 'Infoblox::IPAM::Address');

    $newhostaddress = Infoblox::__options('hostaddress');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					  'limit'                => 2000,
					 );

    #
    @_STATUS_ENUM_VALUES = ('Used', 'Unused');

    #
    #
    @_USAGE_ENUM_VALUES = ('DNS', 'DHCP');

    #
    @_LEASE_STATE_ENUM_VALUES = ('free', 'backup',
        'active', 'expired', 'released', 'abandoned',
        'reset', 'bootp', 'static');

    #
    #
    %_allowed_members = (
       'duid'                       => 0,
	   'dhcp_client_identifier'     => 0,
       'extattrs'                   => 0,
	   'extensible_attributes'      => 0,
       'fingerprint'                => -1,
	   'ip_address'                 => 0,
	   'is_conflict'                => 0,
	   'lease_state'                => 0,
	   'mac_address'                => 0,
	   'name'                       => 0,
	   'names'                      => 0,
	   'network_view'               => 0,
	   'objects'                    => -1,
	   'status'                     => 0,
       'types'                      => 0,
	   'usage'                      => 0,
	   'username'                   => 0,
       'discovered_data'            => -1,
       'discover_now_status'        => -1,
       'conflict_types'             => -1,
       'reserved_port'              => -1,
       'is_invalid_mac'             => -1,
       'ms_ad_user_data'            => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    #
    %_name_mappings = (
        extattrs   => 'extensible_attributes',
        ip_address => 'address',
        name => 'dns_names',
        names => 'dns_names',
        objects => 'associated_objects',
        usage => 'usages',
        username => 'user_name',
    );

    #
    #
    %_reverse_name_mappings = (
        address => 'ip_address',
        associated_objects => 'objects',
        dns_names => 'names',
        extensible_attributes => 'extattrs',
        parent => 'network_view',
        usages => 'usage',
        user_name => 'username',
    );

    #
    #
    #
    %_searchable_fields = (
        address => [\&ibap_o2i_string, 'address', 'REGEX'],
        ip_address => [\&ibap_o2i_string, 'address', 'REGEX'],
        end_addr => [\&ibap_o2i_string, 'bogus1', 'LEQ_address'],
        extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        network => [\&__o2i_network__, 'parent', 'REGEX'],
        network_view => [\&ibap_o2i_network_view, 'network_view', 'EXACT'],
        start_addr => [\&ibap_o2i_string, 'bogus2', 'GEQ_address'],
        status => [\&__o2i_status__, 'status', 'REGEX'],
        #
        type => [\&__o2i_status__, 'status', 'REGEX'],
        fingerprint => [\&ibap_o2i_string, 'fingerprint', 'REGEX'],
        discovered_data => [\&Infoblox::Grid::Discovery::Data::__o2i_search_discovered_data__, 'discovered_data', 'EXACT'],
    );

    #
    %_ibap_to_object = (
        extensible_attributes => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
        is_conflict => \&ibap_i2o_boolean,
        lease_state => \&__i2o_lease_state__,
        parent => \&__i2o_parent__,
        types => \&__i2o_types__,
        usages => \&__i2o_usages__,
        status => \&__i2o_status__,
        associated_objects => \&__i2o_objects__,
        discovered_data    => \&ibap_i2o_generic_object_convert,
        is_invalid_mac     => \&ibap_i2o_boolean,
        ms_ad_user_data    => \&ibap_i2o_generic_object_convert,
    );

    #
    #
    #
    %_object_to_ibap = ();
    #
    $_return_fields_initialized=0;
    @_return_fields =
    (
     tField('address'),
     tField('dns_names'),
     tField('mac_address',{not_exist_ok => 1}),
     tField('duid', {not_exist_ok => 1}),
     tField('status'),
     tField('types'),
     tField('usages'),
     #
     tField('parent',
        { sub_fields =>
              [ tField('network_view', { sub_fields => [ tField('name') ]})]}),
     return_fields_extensible_attributes(),

     #
     #
     #
     tField('dhcp_client_identifier', { not_exist_ok => 1 }),
     tField('is_conflict', { not_exist_ok => 1 }),
     tField('lease_state', { not_exist_ok => 1 }),
     tField('discovered_data', { not_exist_ok => 1, depth => 1 }),
     tField('user_name', { not_exist_ok => 1 }),
     tField('fingerprint', { not_exist_ok => 1 }),
     tField('conflict_types'),
     tField('reserved_port'),
     tField('is_invalid_mac', { not_exist_ok => 1 }),
    );

    #
    %_return_field_overrides = (
        dhcp_client_identifier      => [],
        duid                        => [],
        extattrs                    => [],
        extensible_attributes       => [],
        fingerprint                 => [],
        ip_address                  => [],
        is_conflict                 => [],
        lease_state                 => [],
        mac_address                 => [],
        network_view                => [],
        objects                     => [],
        status                      => [],
        type                        => [],
        types                       => [],
        usage                       => [],
        name                        => [],
        names                       => [],
        username                    => [],
        discovered_data             => [],
        discover_now_status         => [],
        conflict_types              => [],
        reserved_port               => [],
        is_invalid_mac              => [],
        ms_ad_user_data             => [],
    );

    @_optional_return_fields = (
                                tField('discover_now_status', {not_exist_ok => 1}),
                               );

    %_acceptable_ibap_types = (
                               'ARecord'          => 'Infoblox::DNS::Record::A',
                               'AaaaRecord'       => 'Infoblox::DNS::Record::AAAA',
#
                               'DhcpRange'        => 'Infoblox::DHCP::Range',
                               'FixedAddress'     => 'Infoblox::DHCP::FixedAddr',
#
                               'HostRecord'       => 'Infoblox::DNS::Host',
                               'IPv6DhcpRange'    => 'Infoblox::DHCP::IPv6Range',
                               'IPv6FixedAddress' => 'Infoblox::DHCP::IPv6FixedAddr',
                               'Lease'            => 'Infoblox::DHCP::Lease',
                               'PtrRecord'        => 'Infoblox::DNS::Record::PTR',
                              );

    if ($newhostaddress) {
        $_acceptable_ibap_types{'HostAddress'} = 'Infoblox::DHCP::HostAddr';
    }
                              
    Infoblox::IBAPBase::create_discovered_data_fields(@discovery_common_fields,@vdiscovery_fields,'discovered_duid');
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
        my @objtype_returnfields;

        foreach my $t ( keys %_acceptable_ibap_types) {
            #
            my $x = $_acceptable_ibap_types{$t}->__new__();
            push @objtype_returnfields, tFieldObjType($t,
                                                      {
                                                       sub_fields => $x->__return_fields__()
                                                      }
                                                     );
        }

        #
        my $x = Infoblox::DNS::BulkHost->__new__();
        push @objtype_returnfields, tFieldObjType('BulkHostIpFqdn',
                                                  {
                                                   sub_fields => [
                                                                  tField('bulkhost', {sub_fields => $x->__return_fields__()}),
                                                                 ]
                                                  }
                                                 );
        push @_optional_return_fields,
          tField('associated_objects',
                 {
                  default_no_access_ok => 1,
                  not_exist_ok         => 1,
                  sub_fields           => \@objtype_returnfields,
                 }
                );

        
        my $tmp = Infoblox::Grid::MSServer::AdUser::Data->__new__();
        push @_return_fields, tField('ms_ad_user_data', {sub_fields => $tmp->__return_fields__()});
	}
}

sub __ibap_object_type__
{
	my ($self, $function, $session, $args_ref) = @_;

	my ($type, $what, $addr, $network);

    #
    #
    if (defined $args_ref && ref($args_ref) eq 'HASH' && keys %$args_ref) {
        $what = $args_ref;
    } else {
        $what = $self;
    }

    if ($what->{address}) {
        $addr = $what->{address};
    } elsif ($what->{ip_address}) {
        $addr = $what->{ip_address};
    } elsif ($what->{start_addr}) {
        $addr = $what->{start_addr};
    } elsif ($what->{end_addr}) {
        $addr = $what->{end_addr};
    } elsif ($what->{network}) {
        $network = $what->{network};
    }

    unless ($addr || $network) {
        set_error_codes(1002,"Neither 'ip_address' nor 'network' could be found in the parameter list", $session);
    }
    else {
        if ($addr) {
            if (is_ipv4_address($addr)) {
                $type = 'IPv4Address';
            } elsif (is_ipv6_address($addr)) {
                $type = 'IPv6Address';
            } else {
                #
                set_error_codes(1104,"invalid address: $addr", $session);
            }
        } else {
            if (is_ipv4_network($network)) {
                $type = 'IPv4Address';
            } elsif (is_ipv6_network($network)) {
                $type = 'IPv6Address';
            } else {
                #
                set_error_codes(1104,"invalid network: $network", $session);
            }
        }
    }

    #
    $type = 'IPv4Address' unless $type;
    return $type;
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
    if (!$$argsref{network_view} && !$$argsref{network}) {
        $$argsref{network_view} = 'is_default:=:=:boolean:=:=:1';
    }

    unless ($argsref->{start_addr} || $argsref->{end_addr} || $argsref->{address} || $argsref->{ip_address} || $argsref->{network}) {
        #
        set_error_codes(1103,"At least one of 'network', 'address', 'start_addr', 'end_addr'  argument is required", $session);
        return 0;
    }

    return 1;
}

sub __i2o_parent__
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my $nview_name;

    my $ibap_parent = $$ibap_object_ref{$current};
	if ($ibap_parent) {
        my $type_list = ['Network', 'IPv6Network'];
        if (check_object_type($ibap_parent, $type_list)) {
            my $nview = $$ibap_parent{network_view};
            if ($nview &&
                check_object_type($nview, ['NetworkView'])) {
                $nview_name = $$nview{name};
            }
        }
	}

    return $nview_name;
}

sub __i2o_types__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
        if ($$ibap_object_ref{$current}) {
            #
            my @mapped;
            foreach (@{$$ibap_object_ref{$current}}) {
                if ($_ eq 'DHCP_RANGE') {
                    push @mapped, 'RANGE';
                }
                else {
                    push @mapped, $_;
                }
            }
            return join(',', @mapped);
        }
        else {
        return undef;
        }
}

sub __i2o_usages__
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my $usage;

    my $ibap_usage = $$ibap_object_ref{$current};
	if ($ibap_usage) {
        #
        #
        $usage = join(',', @$ibap_usage);
	}

    return $usage;
}

sub __i2o_objects__
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my $usage;

    my %temporary;
    my @list;

    if ($$ibap_object_ref{$current}) {
        foreach my $currentobj (@{$$ibap_object_ref{$current}}) {
            if (ref($currentobj) eq 'ib:BulkHostIpFqdn') {
                $temporary{'object'} = $currentobj->{'bulkhost'};
            }
            else {
                $temporary{'object'} = $currentobj;
            }

            push @list, ibap_i2o_generic_object_convert($self,$session,'object',\%temporary,$return_object_cache_ref);
        }

        return \@list;
    }
    else {
        return undef;
    }
    my $ibap_usage = $$ibap_object_ref{$current};
	if ($ibap_usage) {
        #
        #
        $usage = join(',', @$ibap_usage);
	}

    return $usage;
}

sub __i2o_status__
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $status;

    #
    #
    my $ibap_status = $$ibap_object_ref{$current};
    if ($ibap_status) {
        $status = capitalize_first_letter($ibap_status);
    }

    #
    #
    #
    #
    #
    if ($status && $status eq 'Used') {
        #
        #
        if ($$ibap_object_ref{is_conflict}) {
            $status .= ', Conflict';
        } elsif ($$ibap_object_ref{types} &&
                 $self->__array_contains__('UNMANAGED',
                                           $$ibap_object_ref{types})) {
            $status .= ', Unmanaged';
        }
    }
    return $status;
}

sub __i2o_lease_state__
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    #
    #
    #
    return lc($$ibap_object_ref{$current});
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'is_invalid_mac'} = 0 unless defined $$ibap_object_ref{'is_invalid_mac'};

    #
    $self->is_conflict('false');

    #
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    #
    #

    #
    #
    $self->{'__initializing_from_ibap__'} = 1;
    $self->v_cluster('');
    $self->v_datacenter('');
    $self->v_host('');
    $self->v_name('');
    $self->v_netadapter('');
    $self->v_switch('');
    $self->v_type('');
    delete $self->{'__initializing_from_ibap__'};

    Infoblox::Grid::Discovery::Data::__init_discovered_members__($self);

    return;
}

#
sub __o2i_network__
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

    my $address = $$tempref{'address'};
    my $network = $$tempref{'network'};
    my $is_ipv6 = ($address && is_ipv6_address($address)) ||
                  ($network && is_ipv6_network($network));

    if ($is_ipv6) {
        return ibap_o2i_ipv6_network($self, $session, $current, $tempref);
    } else {
        #
        return ibap_o2i_network($self, $session, $current, $tempref);
    }
}

#
sub __o2i_usage__
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

    #
    #
    #
    my $usage = $self->usage();
    my @usage_arr = split(',', $usage) if defined $usage;
    my @ibap_usages;
    if (@usage_arr)
    {
        for my $ibap_usage (@_USAGE_ENUM_VALUES)
        {
            for my $papi_usage (@usage_arr)
            {
                if ($self->__array_contains__($papi_usage, \@usage_arr))
                {
                    if (!$self->__array_contains__($ibap_usage, \@ibap_usages))
                    {
                        push(@ibap_usages, $ibap_usage);
                    }
                    last;
                }
            }
        }
	}

   	push @return_args, 1;
   	push @return_args, 0;
   	push @return_args, \@ibap_usages;

	return @return_args;
}

sub __o2i_status__
{
	my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    my $status = $$tempref{$current};
    if (!$status || uc($status) eq 'ALL') {
        #
        #
        #
    	push @return_args, 1;
    	push @return_args, 1;
    	push @return_args, undef;
        return @return_args;
    } else {
        unless ($self->__array_contains__(capitalize_first_letter($status),
                \@_STATUS_ENUM_VALUES)) {
            #
            set_error_codes(1002, "Type $status is not supported", $session);
            push @return_args, 0;
            return @return_args;
        }

        #
        #
        return ibap_o2i_enums_lc_or_undef($self, $session, $current,
                                    $tempref);
    }
}

#
#
#

sub network_view
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'network_view', validator => \&ibap_value_o2i_string}, @_);
}

sub ip_address
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ip_address', validator => \&ibap_value_o2i_string}, @_);
}

#
#
sub name
{
    my $self = shift;
    my $names = $self->names();
    if ($names && @$names) {
        return @{$names}[0];
    }
    return;
}

sub names
{
    my $self = shift;
    return $self->__accessor_array__({name => 'names', validator => \&ibap_value_o2i_string}, @_);
}

sub mac_address
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'mac_address', validator => \&ibap_value_o2i_string}, @_);
}

sub duid
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'duid', validator => \&ibap_value_o2i_string}, @_);
}

sub types
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'types', validator => \&ibap_value_o2i_string}, @_);
}

sub usage
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'usage', validator => \&ibap_value_o2i_string}, @_);
}


sub netbios_name
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'netbios', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

#
sub dhcp_client_identifier
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'dhcp_client_identifier', validator => \&ibap_value_o2i_string}, @_);
}

sub is_conflict
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'is_conflict', validator => \&ibap_value_o2i_boolean}, @_);
}

sub is_invalid_mac
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'is_invalid_mac', readonly => 1}, @_);
}

sub lease_state
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'lease_state', enum => \@_LEASE_STATE_ENUM_VALUES }, @_);
}

sub username
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'username', validator => \&ibap_value_o2i_string}, @_);
}

sub status
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'status', validator => \&ibap_value_o2i_string}, @_);
}

sub objects
{
    my $self = shift;
    return $self->__accessor_array__({name => 'objects', readonly => 1}, @_);
}

sub fingerprint
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'fingerprint', readonly => 1}, @_);
}

sub discovered_data
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'discovered_data', readonly => 1}, @_);
}

sub discover_now_status
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'discover_now_status', readonly => 1}, @_);
}

sub conflict_types
{
    my $self = shift;
    return $self->__accessor_array__({name => 'conflict_types', readonly => 1}, @_);
}

sub reserved_port
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'reserved_port', readonly => 1}, @_);
}

#
#
#

#

sub __add_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'add' not allowed for this object", $session);
    return;
}

sub __modify_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'modify' not allowed for this object", $session);
    return;
}

sub __search_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'search' not allowed for this object", $session);
    return;
}

1;
