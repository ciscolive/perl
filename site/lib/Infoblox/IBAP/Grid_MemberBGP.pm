package Infoblox::Grid::Member::BGP::AS;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            @ISA
            %_allowed_members
            %_ibap_to_object
            %_name_mappings
            %_reverse_name_mappings
            %_object_to_ibap
            @_return_fields
            $_return_fields_initialized
            $_object_type
);

@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'anycast_bgp_as_config';
    register_wsdl_type('ib:anycast_bgp_as_config', 'Infoblox::Grid::Member::BGP::AS');

    %_allowed_members = (
                         'as'        => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'keepalive' => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'holddown'  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'neighbors' => {array => 1, validator => {'Infoblox::Grid::Member::BGP::Neighbor' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'as' => 'as_number',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'neighbors' => \&ibap_i2o_generic_object_list_convert,
    );

    %_object_to_ibap = (
                        'as'        => \&ibap_o2i_uint,
                        'keepalive' => \&ibap_o2i_uint,
                        'holddown'  => \&ibap_o2i_uint,
                        'neighbors' => \&ibap_o2i_generic_struct_list_convert,
    );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('as_number'),
                       tField('keepalive'),
                       tField('holddown'),
    );
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members)) {

        return;
    }

    $self->__init_instance_constants__();
    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    $self->__init_instance_constants__();
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::Member::BGP::Neighbor->__new__();
        push @_return_fields, tField('neighbors', {sub_fields => $t->__return_fields__()});
    }

    #
    $self->keepalive(4) unless defined $self->keepalive();
    $self->holddown(16) unless defined $self->holddown();
}


package Infoblox::Grid::Member::BGP::Neighbor;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields $_object_type);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'anycast_bgp_neighbor_config';
    register_wsdl_type('ib:anycast_bgp_neighbor_config', 'Infoblox::Grid::Member::BGP::Neighbor');

    %_allowed_members = (
                         'neighbor_ip'         => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_ipaddr},
                         'remote_as'           => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'authentication_mode' => {simple => 'asis', enum => ['NONE', 'MD5']},
                         'bfd_template'        => {validator => \&ibap_value_o2i_string},
                         'bgp_neighbor_pass'   => {writeonly => 1, validator => \&ibap_value_o2i_string},
                         'comment'             => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'enable_bfd'          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_multihop'     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'interface'           => {simple => 'asis', enum => ['LAN_HA']},
                         'multihop_ttl'        => {simple => 'asis', validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'interface'       => 'advertise_interface',
                       'enable_multihop' => 'multihop',
                       'enable_bfd'      => 'bfd_fallover',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'bfd_template' => \&ibap_i2o_object_name,
    );

    %_object_to_ibap = (
                        'authentication_mode' => \&ibap_o2i_string,
                        'bfd_template'        => \&__o2i_bfd_template__,
                        'bgp_neighbor_pass'   => \&ibap_o2i_string_skip_undef,
                        'comment'             => \&ibap_o2i_string,
                        'enable_bfd'          => \&ibap_o2i_boolean,
                        'enable_multihop'     => \&ibap_o2i_boolean,
                        'interface'           => \&ibap_o2i_string,
                        'multihop_ttl'        => \&ibap_o2i_uint,
                        'neighbor_ip'         => \&ibap_o2i_string,
                        'remote_as'           => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('advertise_interface'),
                       tField('neighbor_ip'),
                       tField('authentication_mode'),
                       tField('remote_as'),
                       tField('comment'),
                       tField('multihop'),
                       tField('multihop_ttl'),
                       tField('bfd_template', {sub_fields => [tField('name')]}),
                       tField('bfd_fallover'),
    );
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members)) {

        return;
    }

    $self->__init_instance_constants__();
    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    $self->__init_instance_constants__();
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __init_instance_constants__ {

    my $self = shift;

    #
    $self->interface('LAN_HA') unless defined $self->interface();
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
        'multihop',
        'bfd_fallover',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __o2i_bfd_template__ {

    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        return (1, 0, ibap_readfield_simple_string('BFDTemplate', 'name', $$tempref{$current}, $current));
    } else {
        return (1, 1, undef);
    }
}


1;
