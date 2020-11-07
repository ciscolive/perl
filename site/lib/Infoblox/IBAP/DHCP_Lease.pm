package Infoblox::DHCP::Lease;

use strict;

use Carp;
use POSIX qw(strftime);
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_name_mappings %_reverse_name_mappings %_searchable_fields %_ibap_to_object %_object_to_ibap @_return_fields %_return_field_overrides $_return_fields_initialized %_capabilities);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_MODIFY);

BEGIN
{
    $_object_type = 'Lease';
    register_wsdl_type('ib:Lease','Infoblox::DHCP::Lease');

    %_capabilities = (
        depth                => 0,
        implicit_defaults    => 1,
        single_serialization => 1,
    );

    %_allowed_members = (
        billing_class       => -1,
        binding_state       => -1,
        client_hostname     => -1,
        cltt                => -1,
        ends                => -1,
        fingerprint         => -1,
        hardware            => -1,
        ip_address          => -1,
        ipv6_duid           => -1,
        ipv6_iaid           => -1,
        ipv6_preferred_lifetime => -1,
        ipv6_prefix_bits    => -1,
        ipv4addr            => -1,  # deprecated
        mac                 => -1,
        network             => -1,
        network_view        => -1,
        next_binding_state  => -1,
        on_commit           => -1,
        on_expiry           => -1,
        on_release          => -1,
        option              => -1,
        protocol            => -1,
        remote_id           => -1,
        starts              => -1,
        tsfp                => -1,
        tstp                => -1,
        uid                 => -1,
        username            => -1,
        served_by           => -1,
        variable            => -1,
        discovered_data     => -1,
        is_invalid_mac      => -1,
        ms_ad_user_data     => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
        ipv6_duid           => 'v6_duid',
        ipv6_iaid           => 'v6_iaid',
        ipv6_preferred_lifetime => 'v6_preferred_lifetime',
        ipv6_prefix_bits    => 'v6_prefix_bits',
        mac                 => 'hardware',
    );
    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
        ip_address          => [\&ibap_o2i_string, 'ip_address', 'REGEX'],
        ipv6_duid           => [\&ibap_o2i_string, 'v6_duid', 'REGEX'],
        ipv6_prefix_bits    => [\&ibap_o2i_uint,   'v6_prefix_bits', 'EXACT'],
        ipv4addr            => [\&ibap_o2i_string, 'ip_address', 'REGEX'],
        protocol            => [\&ibap_o2i_string, 'protocol', 'EXACT'],
        start_addr          => [\&ibap_o2i_string, 'ip_address_start', 'GEQ_ip_address' ],
        end_addr            => [\&ibap_o2i_string, 'ip_address_end', 'LEQ_ip_address' ],
        mac                 => [\&ibap_o2i_string, 'hardware', 'REGEX'],
        username            => [\&ibap_o2i_string, 'username', 'REGEX'],
        network_view        => [\&ibap_o2i_network_view ,'network_view', 'EXACT'],
        member              => [\&__o2i_member__,'member', 'EXACT'],
        client_hostname     => [\&ibap_o2i_string, 'client_hostname', 'REGEX'],
        fingerprint         => [\&ibap_o2i_string, 'fingerprint', 'REGEX'],
        discovered_data     => [\&Infoblox::Grid::Discovery::Data::__o2i_search_discovered_data__, 'discovered_data', 'EXACT'],
        remote_id           => [\&ibap_o2i_string, 'remote_id', 'REGEX'],
   );

    %_ibap_to_object = (
        binding_state       => \&ibap_i2o_enums_lc_or_undef,
        next_binding_state  => \&ibap_i2o_enums_lc_or_undef,
        hardware            => \&__i2o_hardware__,
        network             => \&__i2o_network__,
        network_view        => \&ibap_i2o_generic_object_convert,
        starts              => \&__i2o_lease_time_member__,
        ends                => \&__i2o_lease_time_member__,
        tstp                => \&__i2o_lease_time_member__,
        tsfp                => \&__i2o_lease_time_member__,
        cltt                => \&__i2o_lease_time_member__,
        discovered_data     => \&ibap_i2o_generic_object_convert,
        is_invalid_mac      => \&ibap_i2o_boolean,
        ms_ad_user_data     => \&ibap_i2o_generic_object_convert,
    );

    #
    %_object_to_ibap = (
        billing_class       => \&ibap_o2i_ignore,
        binding_state       => \&ibap_o2i_ignore,
        client_hostname     => \&ibap_o2i_ignore,
        cltt                => \&ibap_o2i_ignore,
        ends                => \&ibap_o2i_ignore,
        fingerprint         => \&ibap_o2i_ignore,
        hardware            => \&ibap_o2i_ignore,
        ip_address          => \&ibap_o2i_ignore,
        ipv6_duid           => \&ibap_o2i_ignore,
        ipv6_iaid           => \&ibap_o2i_ignore,
        ipv6_preferred_lifetime => \&ibap_o2i_ignore,
        ipv6_prefix_bits    => \&ibap_o2i_ignore,
        ipv4addr            => \&ibap_o2i_ignore,
        mac                 => \&ibap_o2i_ignore,
        network             => \&ibap_o2i_ignore,
        network_view        => \&ibap_o2i_ignore,
        next_binding_state  => \&ibap_o2i_ignore,
        on_commit           => \&ibap_o2i_ignore,
        on_expiry           => \&ibap_o2i_ignore,
        on_release          => \&ibap_o2i_ignore,
        option              => \&ibap_o2i_ignore,
        protocol            => \&ibap_o2i_ignore,
        remote_id           => \&ibap_o2i_ignore,
        starts              => \&ibap_o2i_ignore,
        tsfp                => \&ibap_o2i_ignore,
        tstp                => \&ibap_o2i_ignore,
        uid                 => \&ibap_o2i_ignore,
        username            => \&ibap_o2i_ignore,
        served_by           => \&ibap_o2i_ignore,
        variable            => \&ibap_o2i_ignore,
        discovered_data     => \&ibap_o2i_ignore,
        is_invalid_mac      => \&ibap_o2i_ignore,
        ms_ad_user_data     => \&ibap_o2i_ignore,
    );

    $_return_fields_initialized = 0;
    @_return_fields = (
        tField('ip_address'),
        tField('hardware'),
        tField('client_hostname'),
        tField('binding_state'),
        tField('next_binding_state'),
        tField('starts'),
        tField('ends'),
        tField('fingerprint'),
        tField('tstp'),
        tField('tsfp'),
        tField('cltt'),
        tField('uid'),
        tField('billing_class'),
        tField('option'),
        tField('variable'),
        tField('on_commit'),
        tField('on_expiry'),
        tField('on_release'),
        tField('protocol'),
        tField('remote_id'),
        tField('username'),
        tField('served_by'),
        tField('network', {
            sub_fields => [ tField('address'), tField('cidr') ]
        }),
        tField('never_starts'),
        tField('never_ends'),
        tField('discovered_data', { depth => 1 } ),
        tField('v6_duid'),
        tField('v6_iaid'),
        tField('v6_preferred_lifetime'),
        tField('v6_prefix_bits'),
        tField('is_invalid_mac'),
    );

    %_return_field_overrides = (
        billing_class       => [],
        binding_state       => [],
        client_hostname     => [],
        cltt                => [],
        ends                => [],
        fingerprint         => [],
        hardware            => [],
        ip_address          => [],
        ipv6_duid           => [],
        ipv6_iaid           => [],
        ipv6_preferred_lifetime => [],
        ipv6_prefix_bits    => [],
        ipv4addr            => ['!ip_address', '!protocol'],
        mac                 => [],
        network             => [],
        network_view        => [],
        next_binding_state  => [],
        on_commit           => [],
        on_expiry           => [],
        on_release          => [],
        option              => [],
        protocol            => [],
        remote_id           => [],
        starts              => [],
        tsfp                => [],
        tstp                => [],
        uid                 => [],
        username            => [],
        served_by           => [],
        variable            => [],
        discovered_data     => [],
        is_invalid_mac      => [],
        ms_ad_user_data     => [],
    );
    Infoblox::IBAPBase::create_discovered_data_fields(@discovery_common_fields,@vdiscovery_fields,'mac_address', 'discovered_duid');
}

#
#
#

sub new
{
    my ( $proto, %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self, $class;

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
        my $tmp = Infoblox::DHCP::View->__new__();
        push @_return_fields, tField('network_view', {
                                                      default_no_access_ok => 1,
                                                      sub_fields => $tmp->__return_fields__(),
                                                     });

        $tmp = Infoblox::Grid::MSServer::AdUser::Data->__new__();
        push @_return_fields, tField('ms_ad_user_data', {sub_fields => $tmp->__return_fields__()});
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

sub __remove_override_hook__ {
    my ($type, $session, $self) = @_;
    my $server = $session->get_ibap_server();
    my $network_view = $self->network_view();
    my $ipv6_prefix_bits = $self->ipv6_prefix_bits();

    my $call_args = {
        address => ibap_value_o2i_string($self->ip_address(), 'address', $session)
    };

    if( defined $network_view ) {
        $call_args->{'network_view'} = ibap_readfield_simple_string('NetworkView', 'name', $network_view->{name},'network_view','EXACT');
    } else {
        $call_args->{'network_view'} = ibap_readfield_simple('NetworkView','is_default',tBool(1),'network_view=(default network view)'),
    }

    if ( defined $ipv6_prefix_bits ) {
        $call_args->{'v6_prefix_bits'} = ibap_value_o2i_string($self->ipv6_prefix_bits(), 'v6_prefix_bits', $session);
    }

    eval {
        $server->ibap_request('ClearLease', $call_args); 
    };
    return $server->set_papi_error($@, $session) if $@;
    return 1;
}

#
#
#

#
sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref, $skipref) = @_;

    $$ibap_object_ref{'is_invalid_mac'} = 0 unless defined $$ibap_object_ref{'is_invalid_mac'};

    my $ret = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref, $skipref);

    if (defined $$ibap_object_ref{'never_starts'} && $$ibap_object_ref{'never_starts'} == 1)
    {
        $self->{'starts'} = 'never;';
    }
    if (defined $$ibap_object_ref{'never_ends'} && $$ibap_object_ref{'never_ends'} == 1)
    {
        $self->{'ends'} = 'never;';
    }

    my $ip_address = $ibap_object_ref->{'ip_address'};
    if ($ip_address) {
        #
        #
        my $protocol = $ibap_object_ref->{'protocol'};
        #
        if ($protocol && ($protocol eq 'IPV4')) {
            $self->{'ipv4addr'} = $ip_address;
        } else {
            $self->{'ipv4addr'} = undef;
        }
    }

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

    return $ret;
}


sub __i2o_hardware__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($ibap_object_ref->{$current}) {
        #
        #
        #
        #
        $self->hardware('ethernet');
        return $ibap_object_ref->{$current};
    } else {
        return undef;
    }
}

sub __i2o_network__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($ibap_object_ref->{$current}) {
        my $t = $ibap_object_ref->{$current};
        my $t2 = cidr_to_mask($t->{'cidr'});
        $t2 = $t->{'cidr'} unless $t2;

        return $t->{'address'}.'/'.$t2;
    } else {
        return undef;
    }
}

sub __i2o_lease_time_member__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if ($ibap_object_ref->{$current})
    {
        my $t = eval { iso8601_datetime_to_unix_timestamp($ibap_object_ref->{$current}); };
        if ($@)
        {
            return undef;
        }
        else
        {
            return strftime("%w %Y/%m/%d %H:%M:%S", gmtime(int($t)));
        }
    }
    else
    {
        return undef;   
    }
}


sub __o2i_member__
{
	my ($self, $session, $current, $tempref, $type) = @_;

    if($tempref->{$current}) {
        return (1, 0, ibap_readfield_simple_string('Member', 'host_name', $tempref->{$current},'member'));
    } else {
        return (1, 0, undef);
    }
}

#
#
#

sub billing_class
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'billing_class', readonly => 1}, @_);
}

sub binding_state
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'binding_state', readonly => 1, enum =>
        [ 'free', 'backup', 'active', 'expired', 'released', 'abandoned', 'reset' ]},
        @_);
}

sub client_hostname
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'client_hostname', readonly => 1}, @_);
}

sub cltt
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'cltt', readonly => 1}, @_);
}

sub ends
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ends', readonly => 1}, @_);
}

sub fingerprint
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'fingerprint', readonly => 1}, @_);
}

sub hardware
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'hardware', readonly => 1}, @_);
}

sub ip_address
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ip_address', readonly => 1}, @_);
}

sub ipv4addr
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ipv4addr', readonly => 1}, @_);
}

sub ipv6_duid
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ipv6_duid', readonly => 1}, @_);
}

sub ipv6_iaid
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ipv6_iaid', readonly => 1}, @_);
}

sub ipv6_preferred_lifetime
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ipv6_preferred_lifetime', readonly => 1}, @_);
}

sub ipv6_prefix_bits
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ipv6_prefix_bits', readonly => 1}, @_);
}

sub is_invalid_mac
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'is_invalid_mac', readonly => 1}, @_);
}

sub mac
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'mac', readonly => 1}, @_);
}

sub network
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'network', readonly => 1}, @_);
}

sub network_view
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'network_view', validator => { 'Infoblox::DHCP::View' => 1 }}, @_);
}

sub next_binding_state
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'next_binding_state', readonly => 1, enum =>
        [ 'free', 'backup', 'active', 'expired', 'released', 'abandoned', 'reset' ]},
        @_);
}

sub on_commit
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'on_commit', readonly => 1}, @_);
}

sub on_expiry
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'on_expiry', readonly => 1}, @_);
}

sub on_release
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'on_release', readonly => 1}, @_);
}

sub option
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'option', readonly => 1}, @_);
}

sub protocol
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'protocol', readonly => 1,
            enum => [ 'IPV4', 'IPV6', 'BOTH' ]}, @_);
}

sub remote_id
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'remote_id', readonly => 1}, @_);
}

sub starts
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'starts', readonly => 1}, @_);
}

sub tsfp
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'tsfp', readonly => 1}, @_);
}

sub tstp
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'tstp', readonly => 1}, @_);
}

sub uid
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'uid', readonly => 1}, @_);
}

sub username
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'username', readonly => 1}, @_);
}

sub served_by
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'served_by', readonly => 1}, @_);
}

sub variable
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'variable', readonly => 1}, @_);
}

sub discovered_data
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'discovered_data', readonly => 1}, @_);
}

1;

