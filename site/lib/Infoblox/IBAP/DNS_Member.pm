package Infoblox::DNS::Member;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    #
    #
    #
    #
    #

    %_allowed_members = (
                         grid_replicate => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         stealth        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         lead           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         ipv6addr       => {simple => 'asis', validator => \&ibap_value_o2i_ipv6addr},
                         ipv4addr       => {simple => 'asis', validator => \&ibap_value_o2i_ipv4addr},
                         name           => {validator => \&ibap_value_o2i_string},
                         ms_parent_delegated => {simple => 'bool', readonly => 1, validator => \&ibap_value_o2i_boolean},
                         preferred_primaries => {array => 1, nomixed => 1, use => 'override_preferred_primaries', use_truefalse => 1, validator => {'string' => \&ibap_value_o2i_string, 'Infoblox::DNS::Nameserver' => 1}},
                         override_preferred_primaries => {simple => 'bool', validator => \&ibap_value_o2i_boolean},

                         #
                         forward_to          => {array => 1, use => 'override_forwarders', use_truefalse => 1, validator => {'Infoblox::DNS::Nameserver' => 1}},
                         forwarders_only     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_forwarders => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
        'name'                         => 'grid_member',
        'ms_parent_delegated'          => 'shared_with_ms_parent_delegation',
        'override_preferred_primaries' => 'enable_preferred_primaries',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
        'grid_replicate' => \&ibap_i2o_boolean,
        'stealth'        => \&ibap_i2o_boolean,
        'lead'           => \&ibap_i2o_boolean,
        'grid_member'    => \&__i2o_grid_member__,
        'shared_with_ms_parent_delegation' => \&ibap_i2o_boolean,
        'enable_preferred_primaries'       => \&ibap_i2o_boolean,
        'preferred_primaries'              => \&__i2o_preferred_primaries__,
    );

    @_return_fields = (
        tField('grid_replicate'),
        tField('stealth'),
        tField('lead'),
        tField('grid_member', return_fields_member_basic_data),
        tField('shared_with_ms_parent_delegation', {not_exist_ok => 1}),
        tField('enable_preferred_primaries', {not_exist_ok => 1}),
        tField('preferred_primaries', { sub_fields => [
             tField('grid_primary', { sub_fields => [
                tField('host_name'),
             ]}),
             tField('ext_server', { sub_fields => [
                tField('name'),
                tField('address'),
                tField('stealth'),
                tField('use_tsig_key'),
                tField('tsig_key_alg'),
                tField('tsig_key_name'),
                tField('tsig_key'),
                tField('use_2x_tsig_key'),
                tField('shared_with_ms_parent_delegation'),
             ]}),
            ], not_exist_ok => 1}),
    );

    %_object_to_ibap = (
        'grid_replicate' => \&ibap_o2i_boolean,
        'stealth'        => \&ibap_o2i_boolean,
        'lead'           => \&ibap_o2i_boolean,
        'ipv6addr'       => \&ibap_o2i_ignore,
        'ipv4addr'       => \&ibap_o2i_ignore,
        'name'           => \&__o2i_grid_member__,
        'ms_parent_delegated' => \&ibap_o2i_boolean,
        'preferred_primaries' => \&__o2i_preferred_primaries__,
        'override_preferred_primaries' => \&ibap_o2i_boolean,
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

    if( (not defined $args{ 'ipv4addr' }) && (not defined $args { 'ipv6addr' }) && (not defined $args { 'name' }) )
    {
        set_error_codes(1103,"At least one of ipv4addr, ipv6addr and name is required." );
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

sub __i2o_grid_member__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    $self->ipv4addr($$ibap_object_ref{$current}{'vip_setting'}{'address'});
    $self->ipv6addr($$ibap_object_ref{$current}{'ipv6_setting'}{'virtual_ip'}) if $$ibap_object_ref{$current}{'ipv6_setting'}{'enabled'};

    return $$ibap_object_ref{$current}{'host_name'};
}

sub __i2o_preferred_primaries__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @data = ();

    if (defined $ibap_object_ref->{$current} and @{$ibap_object_ref->{$current}}) {
        foreach (@{$ibap_object_ref->{$current}}) {
            if (defined $_->{'grid_primary'}) {
                push @data, $_->{'grid_primary'}->{'host_name'}
            } elsif (defined $_->{'ext_server'}) {
                push @data, Infoblox::Util::ibap_nameserver_from_hash($self, $_->{'ext_server'});
            }
        }
    }

    return \@data;
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'grid_replicate'} = 0 unless defined $$ibap_object_ref{'grid_replicate'};
    $$ibap_object_ref{'stealth'} = 0 unless defined $$ibap_object_ref{'stealth'};
    $$ibap_object_ref{'lead'} = 0 unless defined $$ibap_object_ref{'lead'};
    $$ibap_object_ref{'shared_with_ms_parent_delegation'} = 0 unless defined $$ibap_object_ref{'shared_with_ms_parent_delegation'};
    $$ibap_object_ref{'enable_preferred_primaries'} = 0 unless defined $$ibap_object_ref{'enable_preferred_primaries'};

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    $self->{'override_preferred_primaries'} = ibap_value_i2o_boolean($$ibap_object_ref{'enable_preferred_primaries'});

    #
    $self->{'__object_id_cache__'}{generate_special_object_member_cache_key($self)} = ${${$$ibap_object_ref{'grid_member'}}{'object_id'}}{'id'};

    return $res;
}

sub __o2i_grid_member__
{
    my ($self, $session, $current, $tempref) = @_;
    return (1, 0, ibap_value_o2i_member($self, $session, $self, 'grid_member'));
}

sub __o2i_preferred_primaries__
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $tempref->{$current}) {
        my @data;
        foreach (@{$tempref->{$current}}) {
            if (ref($_)) {
                push @data, tIBType('member_ext_server', {'ext_server' => ibap_value_o2i_ext_server($_)});
            } else {
                push @data, tIBType('member_ext_server', {'grid_primary' => ibap_readfield_simple_string('Member', 'host_name', $_)});
            }
        }
        return (1, 0, tIBType('ArrayOfmember_ext_server', \@data));
    } else {
        return (1, 1, undef);
    }
}

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;

    #
    unless (exists $self->{'name'}) {
        $self->{'name'} = undef;
        $self->{'__init_name__'} = 1;
    }

    my $res = $self->SUPER::__object_to_ibap__($server, $session);

    if ($self->{'__init_name__'}) {
        delete $self->{'name'};
        delete $self->{'__init_name__'};
    }

    return $res;
}

package Infoblox::DNS::Member::SoaMname;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA %_allowed_members @_return_fields %_object_to_ibap %_name_mappings
                 %_ibap_to_object %_ibap_to_object $_object_type);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL); 

BEGIN {

    $_object_type = 'member_soa_mname';
    register_wsdl_type('ib:member_soa_mname', 'Infoblox::DNS::Member::SoaMname');

    %_allowed_members = (
                         'grid_member' => 0,
                         'ms_server'   => 0,
                         'mname'       => {'validator' => \&ibap_value_o2i_string},
                         'dns_mname'   => {'readonly' => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('grid_member', {'sub_fields' => [tField('host_name')]}),
                       tField('ms_server', {'sub_fields' => [tField('address')]}),
                       tField('mname'),
                       tField('dns_mname'),
                      );

    %_ibap_to_object = (
                        'grid_member' => \&ibap_i2o_member_byhostname,
                        'ms_server'   => \&__i2o_ms_server__,
                       );

    %_object_to_ibap = (
                        'grid_member' => \&ibap_o2i_member_byhostname,
                        'ms_server'   => \&__o2i_ms_server__,
                        'mname'       => \&ibap_o2i_string,
                        'dns_mname'   => \&ibap_o2i_ignore,
                       );
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    if (defined $args{'grid_member'} and defined $args{'ms_server'}) {
        set_error_codes(1105, 'Cannot define grid_member and ms_server at the same time.');
        return;
    }

    unless (defined $args{'grid_member'} or defined $args{'ms_server'}) {
        set_error_codes(1103, 'grid_member or ms_server is required');
        return;
    }

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

sub __o2i_ms_server__
{
    my ($self, $session, $current, $tempref) = @_;
    return (1, 0, ibap_readfield_simple_string('MsServer', 'address', $tempref->{$current}));
}

sub __i2o_ms_server__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    return $ibap_object_ref->{$current}->{'address'};
}

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;

    if (defined $self->{'grid_member'} and defined $self->{'ms_server'}) {
        set_error_codes(1105, 'Cannot define grid_member and ms_server at the same time.', $session);
        return;
    }

    return $self->SUPER::__object_to_ibap__($server, $session);
}

sub __ibap_object_type__ {

    return $_object_type;
}

#
#
#

sub grid_member
{
    my $self=shift;

    my $res = $self->__accessor_scalar__({name => 'grid_member', validator => \&ibap_value_o2i_string}, @_);
    delete $self->{'ms_server'} if (@_ and $res);

    return $res;
}

sub ms_server
{
    my $self=shift;

    my $res = $self->__accessor_scalar__({name => 'ms_server', validator => \&ibap_value_o2i_string}, @_);
    delete $self->{'grid_member'} if (@_ and $res);

    return $res;
}

package Infoblox::DNS::Member::SoaSerial;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA %_allowed_members @_return_fields %_ibap_to_object);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    %_allowed_members = (
                         'grid_member' => {'readonly' => 1},
                         'ms_server'   => {'readonly' => 1},
                         'serial'      => {'readonly' => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('grid_member', {'sub_fields' => [tField('host_name')]}),
                       tField('ms_server', {'sub_fields' => [tField('address')]}),
                       tField('serial'),
                      );

    %_ibap_to_object = (
                        'grid_member' => \&ibap_i2o_member_byhostname,
                        'ms_server'   => \&__i2o_ms_server__,
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

sub __i2o_ms_server__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    return $ibap_object_ref->{$current}->{'address'};
}

1;
