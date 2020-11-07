package Infoblox::Grid::Discovery;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA %_allowed_members);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    %_allowed_members = (
                         'session' => {'mandatory' => 1, 'validator' => {'Infoblox::Session' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
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

#
#
#

my %start_discovery_types = (
    'Infoblox::IPAM::Address' => 1,
    'Infoblox::DHCP::Network' => 1,
    'Infoblox::DHCP::IPv6Network' => 1,
    'Infoblox::DHCP::NetworkContainer' => 1,
    'Infoblox::DHCP::IPv6NetworkContainer' => 1,
);

sub start_discovery
{
    my ($self, %args) = @_;

    my $server = $self->{'session'}->get_ibap_server();

    unless (defined $server) {
        return set_error_codes(1006, 'Creating session with the server failed.', $self->{'session'});
    }

    my (%fcall_args, $result);

    if (defined $args{'objects'}) {
        if (ref($args{'objects'}) eq 'ARRAY' and @{$args{'objects'}}) {
            my @ipam_obj;
            foreach my $obj (@{$args{'objects'}}) {
                if ($start_discovery_types{ref($obj)}) {
                    if ($obj->__object_id__()) {
                        push @ipam_obj, tIBType('discover_now_ipam_obj', {'ipam_obj' => tObjIdRef($obj->__object_id__())});
                    } else {
                        return set_error_codes(1002, 'The '.ref($obj).' must be retrieved from the appliance before using it');
                    }
                } else {
                    return set_error_codes(1002, ref($obj).' type is not supported');
                }
            }
            $fcall_args{'ipam_objs'} = tIBType('ArrayOfdiscover_now_ipam_obj', \@ipam_obj);
        } else {
            return set_error_codes(1002, 'objects must be an array reference that contains at least one object', $self->{'session'});
        }
    } else {
        return set_error_codes(1002, 'objects is required', $self->{'session'});
    }

    eval { $result = $server->ibap_request('DiscoverNow', \%fcall_args); };
    return $server->set_papi_error($@, $self->{'session'}, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $self->{'session'});

    return 1;
}

sub control_ip_address
{
    my ($self, %args) = @_;

    my $server = $self->{'session'}->get_ibap_server();

    unless (defined $server) {
        return set_error_codes(1006, 'Creating session with the server failed.', $self->{'session'});
    }

    my (%fcall_args, $result);

    if (defined $args{'network_view'}) {
        $fcall_args{'network_view'} = ibap_readfield_simple_string('NetworkView', 'name', $args{'network_view'}, 'network_view');
    } else {
        $fcall_args{'network_view'} = ibap_readfield_simple('NetworkView', 'is_default', tBool(1), 'network_view=(default network view)');
    }

    if (defined $args{'addresses'}) {
        if (ref($args{'addresses'}) eq 'ARRAY') {
            my @addrs;
            foreach my $addr (@{$args{'addresses'}}) {
                $addr = ibap_value_o2i_ipaddr($addr, 'addresses', $self->{'session'});
                return unless defined $addr;
                push @addrs, $addr;
            }
            $fcall_args{'addresses'} = tIBType('ArrayOfIPAddress', \@addrs);
        } else {
            return set_error_codes(1002, ref($args{'addresses'}).' type is not supported');
        }
    } else {
        return set_error_codes(1002, 'addresses is required', $self->{'session'});
    }

    if (defined $args{'exclude'}) {
        $fcall_args{'exclude'} = ibap_value_o2i_boolean($args{'exclude'}, 'exclude', $self->{'session'});
        return unless defined $fcall_args{'exclude'};
    }

    eval { $result = $server->ibap_request('ControlIPAddress', \%fcall_args); };
    return $server->set_papi_error($@, $self->{'session'}, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $self->{'session'});

    return 1;
}

sub diagnostics
{
    my ($self, %args) = @_;

    my $server = $self->{'session'}->get_ibap_server();

    unless (defined $server) {
        return set_error_codes(1006, 'Creating session with the server failed.', $self->{'session'});
    }

    my (%fcall_args, $result);

    #
    if (defined $args{'address'}) {
        $fcall_args{'ip_address'} = ibap_value_o2i_ipaddr($args{'address'}, 'address', $self->{'session'});
        return unless defined $fcall_args{'ip_address'};
    } else {
        return set_error_codes(1002, 'address is required', $self->{'session'});
    }

    #
    if (defined $args{'community_string'}) {
        $fcall_args{'community_string'} = ibap_value_o2i_string($args{'community_string'}, 'community_string', $self->{'session'});
        return unless defined $fcall_args{'community_string'};
    }

    if (defined $args{'force_test'}) {
        $fcall_args{'force_test'} = ibap_value_o2i_boolean($args{'force_test'}, 'force_test', $self->{'session'});
        return unless defined $fcall_args{'force_test'};
    }

    if (defined $args{'discovery_member'}) {
        $fcall_args{'discovery_member'} = ibap_readfield_simple_string('Member', 'host_name', $args{'discovery_member'}, 'grid_member');
    }

    if (defined $args{'network_view'}) {
        $fcall_args{'network_view'} = ibap_readfield_simple_string('NetworkView', 'name', $args{'network_view'}, 'network_view');
    } else {
        $fcall_args{'network_view'} = ibap_readfield_simple('NetworkView', 'is_default', tBool(1), 'network_view=(default network view)');
    }

    if (defined $args{'debug_snmp'}) {
        $fcall_args{'debug_snmp'} = ibap_value_o2i_boolean($args{'debug_snmp'}, 'debug_snmp', $self->{'session'});
        return unless defined $fcall_args{'debug_snmp'};
    }

    eval { $result = $server->ibap_request('DiscoveryDiagnostics', \%fcall_args); };
    return $server->set_papi_error($@, $self->{'session'}, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $self->{'session'});

    return $result->{'id'};
}

sub diagnostics_status
{
    my ($self, %args) = @_;

    my $server = $self->{'session'}->get_ibap_server();

    unless (defined $server) {
        return set_error_codes(1006, 'Creating session with the server failed.', $self->{'session'});
    }

    my (%fcall_args, $result);

    if (defined $args{'id'}) {
        $fcall_args{'id'} = ibap_value_o2i_string($args{'id'}, 'id', $self->{'session'});
        return unless defined $fcall_args{'id'};
    } else {
        return set_error_codes(1002, 'id is required', $self->{'session'});
    }

    if (defined $args{'start'}) {
        $fcall_args{'Start'} = ibap_value_o2i_uint($args{'start'}, 'start', $self->{'session'});
        return unless defined $args{'start'};
    } else {
        $fcall_args{'Start'} = tInteger(0);
    }

    eval { $result = $server->ibap_request('DiscoveryDiagnosticsStatus', \%fcall_args); };
    return $server->set_papi_error($@, $self->{'session'}, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $self->{'session'});

    my $obj = Infoblox::Grid::Discovery::DiagnosticsStatus->__new__();
    $obj->__ibap_to_object__($result, $server, $self->{'session'});
    return $obj;
}

sub provision_network_port
{
    my ($self, %args) = @_;

    my $server = $self->{'session'}->get_ibap_server();

    unless (defined $server) {
        return set_error_codes(1006, 'Creating session with the server failed.', $self->{'session'});
    }

    my (%fcall_args, %ibap_headers, $result);

    if (defined $args{'scheduled_at'}) {
        my $request_settings = request_settings($self, \%args);
        return undef unless $request_settings;
        $ibap_headers{'request_settings'} = $request_settings;
    } else {
        return set_error_codes(1002, 'scheduled_at is required', $self->{'session'});
    }

    if (defined $args{'network'}) {
        my ($ok, $addy, $netmask) = ip_address_munger($args{'network'}, 'cidr', undef, 1, $self->{'session'});

        return unless $ok;

        $fcall_args{'address'} = ibap_value_o2i_ipaddr($addy, 'network', $self->{'session'});
        return unless $fcall_args{'address'};
        $fcall_args{'cidr'} = ibap_value_o2i_int($netmask, 'network', $self->{'session'});
        return unless $fcall_args{'cidr'};
    } else {
        return set_error_codes(1002, 'network is required', $self->{'session'});
    }

    if (defined $args{'router_ip'}) {
        $fcall_args{'router_ip'} = ibap_value_o2i_ipaddr($args{'router_ip'}, 'router_ip', $self->{'session'});
        return unless $fcall_args{'router_ip'};
    } else {
        return set_error_codes(1002, 'router_ip is required', $self->{'session'});
    }

    if (defined $args{'network_view'}) {
        $fcall_args{'network_view'} = ibap_readfield_simple_string('NetworkView', 'name', $args{'network_view'}, 'network_view');
    } else {
        $fcall_args{'network_view'} = ibap_readfield_simple('NetworkView', 'is_default', tBool(1), 'network_view=(default network view)');
    }

    if (defined $args{'enable_dhcp_relay'}) {
        $fcall_args{'enable_dhcp_relay'} = ibap_value_o2i_boolean($args{'enable_dhcp_relay'}, 'enable_dhcp_relay', $self->{'session'});
        return unless $fcall_args{'enable_dhcp_relay'};
    }

    unless (defined $args{'device'} or defined $args{'interface'}) {
        return set_error_codes(1103, 'At least one of device or interface is required', $self->{'session'});
    }

    if (defined $args{'device'}) {
        if (ref($args{'device'}) eq 'Infoblox::Grid::Discovery::Device') {
            $fcall_args{'device'} = object_by_oid_or_readfield_helper($self, 'device', $args{'device'}, 1, 'address');
            return unless $fcall_args{'device'};
        } else {
            return set_error_codes(1104, 'Invalid data type '.ref($args{'device'}).' for member device', $self->{'session'});
        }
    }

    if (defined $args{'interface'}) {
        $fcall_args{'interface'} = ibap_value_o2i_discovery_interfaces($args{'interface'}, 'interface', $self->{'session'}, 0, 'single');
    }

    if (defined $args{'vlan_info'}) {
        if (ref($args{'vlan_info'}) ne 'Infoblox::Grid::Discovery::VLANInfo') {
            return set_error_codes(1104, 'Invalid data type '.ref($args{'vlan_info'}).' for member vlan_info', $self->{'session'});
        }
        $fcall_args{'vlan_info'} = ibap_serialize_substruct($self->{'session'}, $args{'vlan_info'}, $args{'vlan_info'}->__ibap_object_type__());
        return unless $fcall_args{'vlan_info'};
    }

    eval { $result = $server->ibap_request('ProvisionNetworkPort', \%fcall_args, \%ibap_headers); };
    return $server->set_papi_error($@, $self->{'session'}, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $self->{'session'});

    return 1;
}

sub provision_network_dhcp_relay
{
    my ($self, %args) = @_;

    my $server = $self->{'session'}->get_ibap_server();

    unless (defined $server) {
        return set_error_codes(1006, 'Creating session with the server failed.', $self->{'session'});
    }

    my (%fcall_args, %ibap_headers, $result);

    if (defined $args{'scheduled_at'}) {
        my $request_settings = request_settings($self, \%args);
        return undef unless $request_settings;
        $ibap_headers{'request_settings'} = $request_settings;
    } else {
        return set_error_codes(1002, 'scheduled_at is required', $self->{'session'});
    }

    if (defined $args{'network'}) {
        $fcall_args{'parent_obj'} = ibap_value_o2i_network_helper($args{'network'}, 'network', $self->{'session'}, 0, $args{'network_view'});
        return unless $fcall_args{'parent_obj'};
    } else {
        return set_error_codes(1002, 'network is required', $self->{'session'});
    }

    if (defined $args{'interfaces'}) {
        $fcall_args{'interfaces'} = ibap_value_o2i_discovery_interfaces($args{'interfaces'}, 'interfaces', $self->{'session'});
        return unless $fcall_args{'interfaces'};
    } else {
        return set_error_codes(1002, 'interfaces is required', $self->{'session'});
    }

    if (defined $args{'enable_dhcp_relay'}) {
        $fcall_args{'enable_dhcp_relay'} = ibap_value_o2i_boolean($args{'enable_dhcp_relay'}, 'enable_dhcp_relay', $self->{'session'});
        return unless $fcall_args{'enable_dhcp_relay'};
    } else {
        $fcall_args{'enable_dhcp_relay'} = tBool(0);
    }

    eval { $result = $server->ibap_request('ProvisionNetworkDhcpRelay', \%fcall_args, \%ibap_headers); };
    return $server->set_papi_error($@, $self->{'session'}, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $self->{'session'});

    return 1;
}

sub clear_network_port_assignment
{
    my ($self, %args) = @_;

    my $server = $self->{'session'}->get_ibap_server();

    unless (defined $server) {
        return set_error_codes(1006, 'Creating session with the server failed.', $self->{'session'});
    }

    my (%fcall_args, %ibap_headers, $result);

    if (defined $args{'scheduled_at'}) {
        my $request_settings = request_settings($self, \%args);
        return undef unless $request_settings;
        $ibap_headers{'request_settings'} = $request_settings;
    } else {
        return set_error_codes(1002, 'scheduled_at is required', $self->{'session'});
    }

    if (defined $args{'network_deprovision_info'}) {
        unless (ref($args{'network_deprovision_info'}) eq 'ARRAY' and check_vector_type($args{'network_deprovision_info'}, ['Infoblox::Grid::Discovery::NetworkDeprovisionInfo'])) {
            return set_error_codes(1104, 'Invalid data type for member network_deprovision_info', $self->{'session'});
        }
        $fcall_args{'network_deprovision_info'} = ibap_serialize_substruct_list($self->{'session'}, $args{'network_deprovision_info'}, Infoblox::Grid::Discovery::NetworkDeprovisionInfo::__ibap_object_type__());
        return unless $fcall_args{'network_deprovision_info'};
    } else {
        return set_error_codes(1002, 'network_deprovision_info is required', $self->{'session'});
    }

    eval { $result = $server->ibap_request('ClearNetworkPortAssignment', \%fcall_args, \%ibap_headers); };
    return $server->set_papi_error($@, $self->{'session'}, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $self->{'session'});

    return 1;
}

sub control_switch_port
{
    my ($self, %args) = @_;

    my $server = $self->{'session'}->get_ibap_server();

    unless (defined $server) {
        return set_error_codes(1006, 'Creating session with the server failed.', $self->{'session'});
    }

    my (%fcall_args, %ibap_headers, $result);

    if (defined $args{'scheduled_at'}) {
        my $request_settings = request_settings($self, \%args);
        return undef unless $request_settings;
        $ibap_headers{'request_settings'} = $request_settings;
    } else {
        return set_error_codes(1002, 'scheduled_at is required', $self->{'session'});
    }

    if (defined $args{'port_configs'}) {
        unless (ref($args{'port_configs'}) eq 'ARRAY' and check_vector_type($args{'port_configs'}, ['Infoblox::Grid::Discovery::Port::Control::Info'])) {
            return set_error_codes(1104, 'Invalid data type for member port_configs', $self->{'session'});
        }

        $fcall_args{'port_configs'} = ibap_serialize_substruct_list($self->{'session'}, $args{'port_configs'}, Infoblox::Grid::Discovery::Port::Control::Info::__ibap_object_type__());
        return unless $fcall_args{'port_configs'};
    } else {
        return set_error_codes(1002, 'port_configs is required', $self->{'session'});
    }

    eval { $result = $server->ibap_request('ControlSwitchPort', \%fcall_args, \%ibap_headers); };
    return $server->set_papi_error($@, $self->{'session'}, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $self->{'session'});

    return 1;
}

sub get_job_devices
{
    my ($self, %args) = @_;

    my $server = $self->{'session'}->get_ibap_server();

    unless (defined $server) {
        return set_error_codes(1006, 'Creating session with the server failed.', $self->{'session'});
    }

    my (%fcall_args, $result);

    if (defined $args{'task'}) {
        if (ref($args{'task'})) {
            if (ref($args{'task'}) eq 'Infoblox::Grid::ScheduledTask' and $args{'task'}->__object_id__()) {
                $fcall_args{'task'} = tObjIdRef($args{'task'}->__object_id__());
            } else {
                return set_error_codes(1104, 'Invalid data type for member task', $self->{'session'});
            }
        } else {
            my $task_id = ibap_value_o2i_uint($args{'task'}, 'task', $self->{'session'});
            return undef unless $task_id;
            $fcall_args{'task'} = ibap_readfield_simple('ScheduledTask', 'task_id', $task_id, 'task_id');
        }

        return undef unless $fcall_args{'task'};
    } else {
        return set_error_codes(1002, 'task is required', $self->{'session'});
    }

    eval { $result = $server->ibap_request('GetJobDevices', \%fcall_args); };
    return $server->set_papi_error($@, $self->{'session'}, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $self->{'session'});

    my @devices = ();

    if ($result and $result->{'devices'} and ref($result->{'devices'}) eq 'ARRAY') {
        foreach (@{$result->{'devices'}}) {
            #
            my $device = Infoblox::Grid::Discovery::Device->__new__();
            $device->__ibap_to_object__($_, $server, $self->{'session'});
            $device->{'__partial__'} = 1;
            push @devices, $device;
        }
    }

    return [$self->{'session'}->fill_partial_object(\@devices)];
}

sub get_job_process_details
{
    my ($self, %args) = @_;

    my $server = $self->{'session'}->get_ibap_server();

    unless (defined $server) {
        return set_error_codes(1006, 'Creating session with the server failed.', $self->{'session'});
    }

    my (%fcall_args, $result);

    if (defined $args{'task'}) {
        if (ref($args{'task'})) {
            if (ref($args{'task'}) eq 'Infoblox::Grid::ScheduledTask' and $args{'task'}->__object_id__()) {
                $fcall_args{'task'} = tObjIdRef($args{'task'}->__object_id__());
            } else {
                return set_error_codes(1104, 'Invalid data type for member task', $self->{'session'});
            }
        } else {
            my $task_id = ibap_value_o2i_uint($args{'task'}, 'task', $self->{'session'});
            return undef unless $task_id;
            $fcall_args{'task'} = ibap_readfield_simple('ScheduledTask', 'task_id', $task_id, 'task_id');
        }

        return undef unless $fcall_args{'task'};
    } else {
        return set_error_codes(1002, 'task is required', $self->{'session'});
    }

    if (defined $args{'device'}) {
        if (ref($args{'device'}) eq 'Infoblox::Grid::Discovery::Device') {
            $fcall_args{'device'} = object_by_oid_or_readfield_helper($self, 'device', $args{'device'}, 1, 'address');
            return unless $fcall_args{'device'};
        } else {
            return set_error_codes(1104, 'Invalid data type '.ref($args{'device'}).' for member device', $self->{'session'});
        }
    } else {
        return set_error_codes(1002, 'device is required', $self->{'session'});
    }

    if (defined $args{'start_line'}) {
        $fcall_args{'start_line'} = ibap_value_o2i_int($args{'start_line'}, 'start_line', $self->{'session'});
        return unless $fcall_args{'start_line'};
    } else {
        $fcall_args{'start_line'} = tInteger(0);
    }

    eval { $result = $server->ibap_request('GetJobProcessDetails', \%fcall_args); };
    return $server->set_papi_error($@, $self->{'session'}, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $self->{'session'});

    my $obj = Infoblox::Grid::Discovery::JobProcessDetails->__new__();
    $obj->__ibap_to_object__($result, $server, $self->{'session'});

    return $obj;
}

sub discovery_data_conversion {
    my ($self, %args) = @_;
    my $server = $self->{'session'}->get_ibap_server();
    my $ref_allowed_arguments = {
        type => 1,
        attributes => 0,
        extensible_attributes => 0,
        addresses => 1
    };
    my %type_values = (
        A_AND_PTR_RECORD => 1,
        AAAA_AND_PTR_RECORD => 1,
        HOST_RECORD => 1,
        FIXED_ADDRESS => 1,
        IPV6_FIXED_ADDRESS => 1,
    );
    my %result_object_types = (
        ARecord => 'Infoblox::DNS::Record::A',
        AaaaRecord => 'Infoblox::DNS::Record::AAAA',
        PtrRecord => 'Infoblox::DNS::Record::PTR',
        HostRecord => 'Infoblox::DNS::Host',
        FixedAddress => 'Infoblox::DHCP::FixedAddr',
        IPv6FixedAddress => 'Infoblox::DHCP::IPv6FixedAddr',
    );

    unless (defined $server) {
        return set_error_codes(1006, 'Creating session with the server failed.', $self->{'session'});
    }

    return unless $self->{'session'}->__validate_arguments_from_arg_list__($ref_allowed_arguments, \%args);

    my (%fcall_args, $result);

    if (defined $args{'type'}) {
        if ($type_values{$args{'type'}}) {
            $fcall_args{'type'} = ibap_value_o2i_string($args{'type'})
        } else {
            return set_error_codes(1001, 'The argument "type" has incorrect value.', $self->{'session'});
        }
    }

    if (defined $args{'addresses'}) {
        if (ref($args{'addresses'}) ne 'ARRAY' or scalar(@{$args{'addresses'}}) == 0) {
            return set_error_codes(1001, 'The argument "addresses" has incorrect type.', $self->{'session'});
        } else {
            for my $address (@{$args{'addresses'}}) {
                if (ref($address) ne 'Infoblox::IPAM::Address') {
                    return set_error_codes(1001, 'The argument "addresses" has incorrect value.', $self->{'session'});
                }
            }
            my ($success, $ignore, $params) = ibap_o2i_object_only_by_oid(
                $args{'addresses'}, $self->{'session'}, 'addresses', \%args);
            return 0 unless $success;
            $fcall_args{'addresses'} = $params;
        }
    }

    if (defined $args{'attributes'}) {
        if (ref($args{'attributes'}) eq 'Infoblox::Grid::Discovery::ConversionAttributes') {
            my ($success, $ignore, $params) = ibap_o2i_generic_struct_convert(
                $args{'attributes'}, $self->{'session'}, 'attributes', \%args);
            return 0 unless $success;
            $fcall_args{'attributes'} = $params;
        } else {
            return set_error_codes(1104, 'Invalid data type '.ref($args{'attributes'}).' for member attributes', $self->{'session'});
        }
    }

    if (defined $args{'extensible_attributes'}) {
        my ($success, $ignore, $params) = Infoblox::IBAPBase::__o2i_extensible_attributes__(
            $args{'extensible_attributes'}, $self->{'session'}, 'extensible_attributes', \%args);
        return 0 unless $success;
        $fcall_args{'extensible_attributes'} = $params unless $ignore;
    }

    eval { $result = $server->ibap_request('DiscoveryDataConversion', \%fcall_args); };
    return $server->set_papi_error($@, $self->{'session'}, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $self->{'session'});

    my @results;
    for my $res (@{$$result{'results'}}) {
        #
        #
        my $object_type = $args{'type'} eq 'IPV6_FIXED_ADDRESS' ? 'IPv6FixedAddress' : $res->{'object_type'};

        $res->{'type'} = $result_object_types{$object_type};
        my $obj = Infoblox::Grid::Discovery::DiscoveryDataConversionResult->__new__();
        $obj->__ibap_to_object__($res, $server, $self->{'session'});
        push @results, $obj;
    }

    return \@results;
}

sub get_device_support_info
{
    my ($self, %args) = @_;
    my $server = $self->{'session'}->get_ibap_server();

    unless (defined $server) {
        return set_error_codes(1006, 'Creating session with the server failed.', $self->{'session'});
    }

    my (%fcall_args, $result);

    if (defined $args{'device'}) {
        if (ref($args{'device'}) eq 'Infoblox::Grid::Discovery::Device') {
            $fcall_args{'device'} = object_by_oid_or_readfield_helper($self, 'device', $args{'device'}, 1, 'address');
            return unless $fcall_args{'device'};
        } else {
            return set_error_codes(1104, 'Invalid data type '.ref($args{'device'}).' for member device', $self->{'session'});
        }
    } else {
        return set_error_codes(1002, 'device is required', $self->{'session'});
    }

    eval { $result = $server->ibap_request('GetDeviceSupportInfo', \%fcall_args); };
    return $server->set_papi_error($@, $self->{'session'}, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $self->{'session'});

    my $obj = Infoblox::Grid::Discovery::DeviceSupportInfoResponse->__new__();
    $obj->__ibap_to_object__($result, $server, $self->{'session'});

    return $obj;
}

package Infoblox::Grid::Discovery::NetworkDeprovisionInfo;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'network_deprovision_info';

    %_allowed_members = (
                         'interface'    => {'mandatory' => 1, 'validator' => {'Infoblox::Grid::Discovery::DeviceInterface' => 1}},
                         'network'      => {'mandatory' => 1, 'validator' => \&ibap_value_o2i_network},
                         'network_view' => {'validator' => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'interface'    => \&ibap_o2i_object_only_by_oid,
                        'network'      => \&__o2i_network__,
                        'network_view' => \&ibap_o2i_ignore,
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

sub __o2i_network__
{
    my ($self, $session, $current, $tempref) = @_;

    my ($ok, $addr, $cidr) = ip_address_munger($tempref->{$current}, 'cidr', undef, 1, $session);
    return (0) unless $ok;

    my $nview = defined $tempref->{'network_view'} ? ibap_readfield_simple_string('NetworkView', 'name', $tempref->{'network_view'}, 'network_view') :
                                                     ibap_readfield_simple('NetworkView', 'is_default', tBool(1), 'network_view=(default network view)');

    my @fields = (
                  {
                   'field' => 'address',
                   'value' => ibap_value_o2i_ipaddr($addr),
                  },
                  {
                   'field' => 'cidr',
                   'value' => ibap_value_o2i_int($cidr),
                  },
                  {
                   'field' => 'network_view',
                   'value' => $nview,
                  },
                 );

    return (1, 1, undef, @fields);
}

package Infoblox::Grid::Discovery::JobProcessDetails;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    %_allowed_members = (
                         'end_line' => {'readonly' => 1},
                         'status'   => {'readonly' => 1},
                         'stream'   => {'readonly' => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
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


package Infoblox::Grid::Discovery::ConversionAttributes;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type
                 %_allowed_members
                 %_object_to_ibap);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'conversion_attributes';
    register_wsdl_type('ib:conversion_attributes', 'Infoblox::Grid::Discovery::ConversionAttributes');

    %_allowed_members = (
        configure_for_dhcp => {validator => \&ibap_value_o2i_boolean},
        configure_for_dns => {validator => \&ibap_value_o2i_boolean},
        disabled => {validator => \&ibap_value_o2i_boolean},
        comment => {validator => \&ibap_value_o2i_string},
        zone => {validator => {'Infoblox::DNS::Zone' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
        configure_for_dhcp => \&ibap_o2i_boolean,
        configure_for_dns => \&ibap_o2i_boolean,
        disabled => \&ibap_o2i_boolean,
        comment => \&ibap_o2i_string,
        zone => \&ibap_o2i_object_only_by_oid,
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


package Infoblox::Grid::Discovery::DiscoveryDataConversionResult;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA %_allowed_members
                 %_ibap_to_object);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    %_allowed_members = (
        object => {readonly => 1, validator => {'Infoblox::DNS::Record::A' => 1,
                                                'Infoblox::DNS::Record::AAAA' => 1,
                                                'Infoblox::DNS::Record::PTR' => 1,
                                                'Infoblox::DNS::Host' => 1,
                                                'Infoblox::DHCP::FixedAddr' => 1,
                                                'Infoblox::DHCP::IPv6FixedAddr' => 1}},
        object_type => {simple => 'asis', readonly => 1},
        address => {readonly => 1, validator => {'Infoblox::IPAM::Address' => 1}},
        message => {simple => 'asis', readonly => 1},
        status => {simple => 'asis', readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
        object => \&__i2o_object__,
        address => \&__i2o_address__,
    );
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __i2o_address__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $oid = $ibap_object_ref->{$current}->{'object_id'}->{'id'};
    my $address = Infoblox::IPAM::Address->__new__();
    $address->{'__partial__'} = 1;
    $address->__object_id__($oid);

    return $address;
}

sub __i2o_object__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $oid = $ibap_object_ref->{$current}->{'object_id'}->{'id'};
    my $obj = $ibap_object_ref->{'type'}->__new__();
    $obj->{'__partial__'} = 1;
    $obj->__object_id__($oid);

    return $obj;
}

package Infoblox::Grid::Discovery::DeviceSupportInfo;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw( @ISA %_allowed_members $_object_type );
@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {
    $_object_type = 'device_support_info';
    register_wsdl_type(
                       'ib:device_support_info', 'Infoblox::Grid::Discovery::DeviceSupportInfo'
    );
    %_allowed_members = (
                         available => {simple => 'asis', readonly => 1},
                         function  => {simple => 'asis', readonly => 1},
                         supported => {simple => 'asis', readonly => 1},
                         value     => {simple => 'asis', readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

package Infoblox::Grid::Discovery::DeviceDataCollectionStatus;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA
            %_allowed_members
            %_ibap_to_object
            $_object_type
);
@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {
    $_object_type = 'device_data_collection_status';
    register_wsdl_type(
                       'ib:device_data_collection_status',
                       'Infoblox::Grid::Discovery::DeviceDataCollectionStatus'
    );
    %_allowed_members = (
                         data_source => {simple => 'asis', readonly => 1},
                         end_time    => {readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        end_time => \&ibap_i2o_datetime_to_unix_timestamp
    );
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

package Infoblox::Grid::Discovery::DeviceSupportInfoResponse;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA
            $_object_type
            %_allowed_members
            %_ibap_to_object
);
@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {
    $_object_type = 'GetDeviceSupportInfoResponse';
    register_wsdl_type(
                       'ib:GetDeviceSupportInfoResponse',
                       'Infoblox::Grid::Discovery::DeviceSupportInfoResponse'
    );

    %_allowed_members = (
                         device_support_info           => {validator => {'Infoblox::Grid::Discovery::DeviceSupportInfo' => 1},
                                                           readonly  => 1,
                                                           array     => 1},

                         device_data_collection_status => {validator => {'Infoblox::Grid::Discovery::DeviceDataCollectionStatus' => 1},
                                                           readonly  => 1,
                                                           array     => 1},
    );

    %_ibap_to_object = (
                        device_support_info           => \&ibap_i2o_generic_object_list_convert,
                        device_data_collection_status => \&ibap_i2o_generic_object_list_convert,
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
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

1;
