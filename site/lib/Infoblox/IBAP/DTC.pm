package Infoblox::DTC;


use strict;
use Carp;

use Infoblox::Util;
use Infoblox::PAPIOverrides;

use vars qw( @ISA
             %_allowed_members );

@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {

    %_allowed_members = (
                         'session' => {'mandatory' => 1, 'validator' => {'Infoblox::Session' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref ($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref ($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self, $class;

    return $self;
}

#
#
#

sub query {

    my ($self, $args) = @_;
    my $session = $self->{session};

    return set_error_codes(1002, 'Infoblox::DTC::Query::Parameters ' .
        'is required') unless ref ($args) eq 'Infoblox::DTC::Query::Parameters';

    my $server = $session->get_ibap_server();
    unless (defined $server) {

        return set_error_codes(1006, 'Creating session' .
            ' with the server failed.', $session);
    }

    my ($fname, $fargs) = ('IdnsQuery', {});

    #
    $$fargs{query} = $args->__object_to_ibap__();
    return undef unless defined $$fargs{query};

    #
    foreach (@{$$fargs{query}}) {
        $$fargs{$_->{field}} = $_->{value};
    }
    delete $$fargs{query};

    my $result;
    eval { $result = $server->ibap_request($fname, $fargs) };

    return $server->set_papi_error($@, $session, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $session);

    my $res_obj = Infoblox::DTC::Query::Response->__new__();
    $res_obj->__ibap_to_object__($result, $server, $session);

    return $res_obj;
}

sub add_certificate {

    my ($self, %args) = @_;
    my $session = $self->{session};
    my ($field, $fname);

    unless (defined $args{path}) {
        return set_error_codes(1002, 'path is required', $session);
    }

    #
    return $session->import_data(path => $args{path}, type => 'dtc_cert');
}

sub import_maxminddb {

    my ($self, %args) = @_;
    my $session = $self->{session};

    unless (defined $args{path}) {
        return set_error_codes(1002, 'path is required', $session);
    }

    #
    return $session->import_data(path => $args{path}, type => 'maxminddb');
}

sub generate_maxminddb {

    my ($self, %args) = @_;
    my ($func_name, $func_args) = ('GenerateMaxMindDB', {});

    my $session = $self->{session};
    my $server = $session->get_ibap_server() || return;

    #

    my $ref_allowed_arguments = {
        scheduled_at => 0,
    };

    return 0 unless $session->__validate_arguments_from_arg_list__(
        $ref_allowed_arguments, \%args);

    #

    my $scheduled_at = $args{'scheduled_at'};
    my %ibap_headers = ();

    if ($scheduled_at) {

        $ibap_headers{request_settings} = eval {
            schedule_request(
                $scheduled_at,
                undef,
                ' for parameter scheduled_at',
            );
        };

        return $server->set_papi_error($@, $session) if $@;
    }

    #

    my $result;
    eval {
        $result = $server->ibap_request(
            $func_name, $func_args, \%ibap_headers
        );
    };

    #

    return $server->set_papi_error($@, $session) if $@;
    set_error_codes(0, undef, $session);
    return 1;
}


package Infoblox::DTC::Query::Parameters;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::PAPIOverrides;
use Infoblox::IBAPBase;

use vars qw( %_allowed_members
             $_object_type
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'IdnsQuery';
    register_wsdl_type('ib:IdnsQuery', 'Infoblox::DTC::Query::Parameters');

    %_allowed_members = (
                         'address' => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'qname'   => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'type'    => {mandatory => 1, enum => ['A', 'AAAA', 'NAPTR', 'CNAME']},
                         'lbdn'    => {mandatory => 1, validator => {'Infoblox::DTC::LBDN' => 1}},
                         'member'  => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        address => \&ibap_o2i_string,
                        qname   => \&ibap_o2i_string,
                        type    => \&ibap_o2i_string,
                        lbdn    => \&ibap_o2i_object_only_by_oid,
                        member  => \&ibap_o2i_member_byhostname,
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

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}


package Infoblox::DTC::Query::Response;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::PAPIOverrides;
use Infoblox::IBAPBase;

use vars qw( %_capabilities
             %_allowed_members
             %_ibap_to_object
             $_object_type
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'IdnsQueryResponse';
    register_wsdl_type('ib:IdnsQueryResponse', 'Infoblox::DTC::Query::Response');

    %_allowed_members = (
                         'records' => {array => 1, validator => {'Infoblox::DTC::Query::Result' => 1}, readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'records' => \&ibap_i2o_generic_object_list_convert,
    );
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}


package Infoblox::DTC::Query::Result;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::PAPIOverrides;
use Infoblox::IBAPBase;

use vars qw( %_allowed_members
             $_object_type
             %_ibap_to_object
             %_name_mappings
             %_reverse_name_mappings
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'idns_query_records';
    register_wsdl_type('ib:idns_query_records', 'Infoblox::DTC::Query::Result');

    %_allowed_members = (
                         'override_ttl' => {readonly => 1, simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'ttl'          => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_ttl', use_truefalse => 1},
                         'type'         => {readonly => 1, enum => ['A', 'AAAA', 'CNAME', 'NAPTR']},
                         'rdata'        => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'override_ttl' => 'use_ttl',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'use_ttl' => \&ibap_i2o_boolean,
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

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'override_ttl'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_ttl'});

    return $res;
}

package Infoblox::DTC::LBDN;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( %_capabilities
             %_allowed_members
             %_searchable_fields
             %_name_mappings
             %_reverse_name_mappings
             @_return_fields
             $_object_type
             %_ibap_to_object
             %_object_to_ibap
             @ISA
             $_return_fields_initialized );

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'IdnsLbdn';
    register_wsdl_type('ib:IdnsLbdn', 'Infoblox::DTC::LBDN');

    %_allowed_members = (
                         'auth_zones'            => {array => 1, validator => {'Infoblox::DNS::Zone' => 1}},
                         'comment'               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'disable'               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'extattrs'              => {special => 'extensible_attributes'},
                         'extensible_attributes' => {special => 'extensible_attributes'},
                         'health'                => {readonly => 1, validator => {'Infoblox::DTC::Health' => 1}},
                         'lb_method'             => {mandatory => 1, simple => 'asis', enum => ['GLOBAL_AVAILABILITY', 'RATIO', 'ROUND_ROBIN', 'TOPOLOGY']},
                         'name'                  => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'override_ttl'          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'patterns'              => {array => 1, validator => \&ibap_value_o2i_string},
                         'persistence'           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'pools'                 => {array => 1, validator => {'Infoblox::DTC::Pool::Link' => 1}},
                         'priority'              => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'topology'              => {validator => {'Infoblox::DTC::Topology' => 1}},
                         'ttl'                   => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_ttl', use_truefalse => 1},
                         'types'                 => {array => 1, enum => ['A', 'AAAA', 'NAPTR', 'CNAME']},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'comment'               => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'extattrs'              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'fqdn'                  => [\&ibap_o2i_string, 'search_fqdn', 'REGEX'],
                           'name'                  => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'status_member'         => [\&ibap_o2i_object_by_oid_or_name, 'search_status_member', 'EXACT'],
    );

    %_name_mappings = (
                       'disable'      => 'disabled',
                       'extattrs'     => 'extensible_attributes',
                       'override_ttl' => 'use_ttl',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('comment'),
                       tField('disabled'),
                       tField('lb_method'),
                       tField('name'),
                       tField('patterns'),
                       tField('persistence'),
                       tField('priority'),
                       tField('ttl'),
                       tField('types'),
                       tField('use_ttl'),
                       return_fields_extensible_attributes(),
    );

    %_ibap_to_object = (
                        'auth_zones'            => \&ibap_i2o_generic_object_list_convert,
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'health'                => \&ibap_i2o_generic_object_convert,
                        'pools'                 => \&ibap_i2o_generic_object_list_convert,
                        'topology'              => \&ibap_i2o_generic_object_convert,
                        'types'                 => \&ibap_i2o_string_to_enum_array,
    );

    %_object_to_ibap = (
                        'auth_zones'            => \&ibap_o2i_zone_list,
                        'comment'               => \&ibap_o2i_string,
                        'disable'               => \&ibap_o2i_boolean,
                        'extattrs'              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes' => \&ibap_o2i_ignore,
                        'health'                => \&ibap_o2i_ignore,
                        'lb_method'             => \&ibap_o2i_string,
                        'name'                  => \&ibap_o2i_string,
                        'override_ttl'          => \&ibap_o2i_boolean,
                        'patterns'              => \&ibap_o2i_string_array_undef_to_empty,
                        'persistence'           => \&ibap_o2i_uint,
                        'pools'                 => \&ibap_o2i_generic_struct_list_convert,
                        'priority'              => \&ibap_o2i_uint,
                        'topology'              => \&ibap_o2i_object_by_oid_or_name,
                        'ttl'                   => \&ibap_o2i_uint,
                        'types'                 => \&ibap_o2i_enum_array_to_string,
    );

    $_return_fields_initialized = 0;
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

        my %init_tfields = (
            auth_zones => 'Infoblox::DNS::Zone',
            topology   => 'Infoblox::DTC::Topology',
            pools      => 'Infoblox::DTC::Pool::Link',
            health     => 'Infoblox::DTC::Health',
        );

        my $t;
        foreach (keys %init_tfields) {
            $t = $init_tfields{$_}->__new__();
            push @_return_fields,
                tField($_, {sub_fields => $t->__return_fields__()});
        }

    }

    $self->auth_zones([]) unless defined $self->auth_zones();
    $self->pools([]) unless defined $self->pools();
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disable'} = 0 unless defined $$ibap_object_ref{'disabled'};

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'override_ttl'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_ttl'});

    return $res;
}


package Infoblox::DTC::Pool;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( %_capabilities
             %_allowed_members
             %_searchable_fields
             %_name_mappings
             %_reverse_name_mappings
             @_return_fields
             $_object_type
             %_ibap_to_object
             %_object_to_ibap
             @ISA
             $_return_fields_initialized );

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'IdnsPool';
    register_wsdl_type('ib:IdnsPool', 'Infoblox::DTC::Pool');

    %_allowed_members = (
                         'name'                    => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'disable'                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'comment'                 => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'lb_preferred_method'     => {simple => 'asis', mandatory => 1, enum => ['ALL_AVAILABLE', 'GLOBAL_AVAILABILITY', 'RATIO', 'ROUND_ROBIN', 'TOPOLOGY', 'DYNAMIC_RATIO']},
                         'lb_preferred_topology'   => {validator => {'Infoblox::DTC::Topology' => 1}},
                         'lb_alternate_method'     => {simple => 'asis', enum => ['ALL_AVAILABLE', 'NONE', 'GLOBAL_AVAILABILITY', 'RATIO', 'ROUND_ROBIN', 'TOPOLOGY', 'DYNAMIC_RATIO']},
                         'lb_alternate_topology'   => {validator => {'Infoblox::DTC::Topology' => 1}},
                         'availability'            => {simple => 'asis', enum => ['ANY', 'QUORUM', 'ALL']},
                         'quorum'                  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'ttl'                     => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_ttl', use_truefalse => 1},
                         'override_ttl'            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},

                         'monitors'                => {array => 1, validator => { 'Infoblox::DTC::Monitor::TCP'  => 1,
                                                                                  'Infoblox::DTC::Monitor::HTTP' => 1,
                                                                                  'Infoblox::DTC::Monitor::PDP'  => 1,
                                                                                  'Infoblox::DTC::Monitor::SIP'  => 1,
                                                                                  'Infoblox::DTC::Monitor::ICMP' => 1,
                                                                                  'Infoblox::DTC::Monitor::SNMP' => 1,
                                                      }},

                         'servers'                 => {array => 1, validator => {'Infoblox::DTC::Server::Link' => 1}},
                         'health'                  => {readonly => 1, validator => {'Infoblox::DTC::Health' => 1}},
                         'dynamic_ratio_preferred' => {validator => {'Infoblox::DTC::Pool::DynamicRatioSetting' => 1}},
                         'dynamic_ratio_alternate' => {validator => {'Infoblox::DTC::Pool::DynamicRatioSetting' => 1}},
                         'extattrs'                => {special => 'extensible_attributes'},
                         'extensible_attributes'   => {special => 'extensible_attributes'},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'name'                  => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'comment'               => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'status_member'         => [\&ibap_o2i_object_by_oid_or_name, 'search_status_member', 'EXACT'],
                           'extattrs'              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
    );

    %_name_mappings = (
                       'disable'               => 'disabled',
                       'extattrs'              => 'extensible_attributes',
                       'override_ttl'          => 'use_ttl',
                       'lb_preferred_method'   => 'preferred_method',
                       'lb_preferred_topology' => 'preferred_topology',
                       'lb_alternate_method'   => 'alternate_method',
                       'lb_alternate_topology' => 'alternate_topology',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('name'),
                       tField('disabled'),
                       tField('comment'),
                       tField('preferred_method'),
                       tField('alternate_method'),
                       tField('availability'),
                       tField('quorum'),
                       tField('ttl'),
                       tField('use_ttl'),
                       return_fields_extensible_attributes(),
    );

    %_ibap_to_object = (
                        'alternate_topology'      => \&ibap_i2o_generic_object_convert,
                        'dynamic_ratio_alternate' => \&ibap_i2o_generic_object_convert,
                        'dynamic_ratio_preferred' => \&ibap_i2o_generic_object_convert,
                        'extensible_attributes'   => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'health'                  => \&ibap_i2o_generic_object_convert,
                        #
                        #
                        'monitors'                => \&ibap_i2o_generic_object_list_convert_no_cache,
                        'preferred_topology'      => \&ibap_i2o_generic_object_convert,
                        'servers'                 => \&ibap_i2o_generic_object_list_convert,
    );

    %_object_to_ibap = (
                        'availability'            => \&ibap_o2i_string,
                        'comment'                 => \&ibap_o2i_string,
                        'disable'                 => \&ibap_o2i_boolean,
                        'dynamic_ratio_alternate' => \&ibap_o2i_generic_struct_convert,
                        'dynamic_ratio_preferred' => \&ibap_o2i_generic_struct_convert,
                        'extattrs'                => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'   => \&ibap_o2i_ignore,
                        'health'                  => \&ibap_o2i_ignore,
                        'lb_alternate_method'     => \&ibap_o2i_string,
                        'lb_alternate_topology'   => \&ibap_o2i_object_by_oid_or_name,
                        'lb_preferred_method'     => \&ibap_o2i_string,
                        'lb_preferred_topology'   => \&ibap_o2i_object_by_oid_or_name,
                        'monitors'                => \&ibap_o2i_object_by_oid_or_name,
                        'name'                    => \&ibap_o2i_string,
                        'override_ttl'            => \&ibap_o2i_boolean,
                        'quorum'                  => \&ibap_o2i_uint,
                        'servers'                 => \&ibap_o2i_generic_struct_list_convert,
                        'ttl'                     => \&ibap_o2i_uint,
    );

    $_return_fields_initialized = 0;
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

        my ($t, @_objtype_return_fields);
        my %init_tfields = (
            alternate_topology      => 'Infoblox::DTC::Topology',
            dynamic_ratio_alternate => 'Infoblox::DTC::Pool::DynamicRatioSetting',
            dynamic_ratio_preferred => 'Infoblox::DTC::Pool::DynamicRatioSetting',
            health                  => 'Infoblox::DTC::Health',
            preferred_topology      => 'Infoblox::DTC::Topology',
            servers                 => 'Infoblox::DTC::Server::Link',
        );

        foreach (keys %init_tfields) {
            $t = $init_tfields{$_}->__new__();
            push @_return_fields,
                tField($_, {sub_fields => $t->__return_fields__()});
        }

        foreach my $obj_class (

            'Infoblox::DTC::Monitor::TCP',
            'Infoblox::DTC::Monitor::SIP',
            'Infoblox::DTC::Monitor::PDP',
            'Infoblox::DTC::Monitor::HTTP',
            'Infoblox::DTC::Monitor::ICMP',
            'Infoblox::DTC::Monitor::SNMP',
        ) {

            $t = $obj_class->__new__();
            push @_objtype_return_fields,
                tFieldObjType($t->__ibap_object_type__, {
                    sub_fields => $t->__return_fields__(),
                });
        }

        push @_return_fields,
            tField('monitors', {
                default_no_access_ok => 1,
                sub_fields           => \@_objtype_return_fields,
            });

    }

    $self->servers([]) unless defined $self->servers();
    $self->monitors([]) unless defined $self->monitors();
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disable'} = 0 unless defined $$ibap_object_ref{'disabled'};

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'override_ttl'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_ttl'});

    return $res;
}


package Infoblox::DTC::Pool::DynamicRatioSetting;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            $_object_type
            $_return_fields_initialized
            %_allowed_members
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_reverse_name_mappings
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'idns_pool_dynamic_ratio_settings';
    register_wsdl_type('ib:idns_pool_dynamic_ratio_settings', 'Infoblox::DTC::Pool::DynamicRatioSetting');


    %_allowed_members = (
                         'invert_monitor_metric' => {simple => 'bool', validator => \&ibap_value_o2i_boolean, },
                         'method'                => {simple => 'asis', enum => ['MONITOR', 'ROUND_TRIP_DELAY'], },
                         'monitor'               => {validator => { 'Infoblox::DTC::Monitor::TCP'  => 1,
                                                                    'Infoblox::DTC::Monitor::HTTP' => 1,
                                                                    'Infoblox::DTC::Monitor::PDP'  => 1,
                                                                    'Infoblox::DTC::Monitor::SIP'  => 1,
                                                                    'Infoblox::DTC::Monitor::ICMP' => 1,
                                                                    'Infoblox::DTC::Monitor::SNMP' => 1,
                                                    }},
                         'monitor_metric'        => {simple => 'asis', validator => \&ibap_value_o2i_string, },
                         'monitor_weighing'      => {simple => 'asis', enum => ['PRIORITY', 'RATIO'], },
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        #
                        #
                        'monitor' => \&ibap_i2o_generic_object_convert_no_cache,
    );

    %_object_to_ibap = (
                        'invert_monitor_metric' => \&ibap_o2i_boolean,
                        'method'                => \&ibap_o2i_string,
                        'monitor'               => \&ibap_o2i_object_by_oid_or_name,
                        'monitor_metric'        => \&ibap_o2i_string,
                        'monitor_weighing'      => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('invert_monitor_metric'),
                       tField('method'),
                       tField('monitor_metric'),
                       tField('monitor_weighing'),
    );
    $_return_fields_initialized = 0;

}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    $self->__init_instance_constants__();
    return $self;
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
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

sub __ibap_object_type__ {

    return $_object_type;
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my ($t, @_objtype_return_fields);

        foreach my $obj_class (
            'Infoblox::DTC::Monitor::TCP',
            'Infoblox::DTC::Monitor::SIP',
            'Infoblox::DTC::Monitor::PDP',
            'Infoblox::DTC::Monitor::HTTP',
            'Infoblox::DTC::Monitor::ICMP',
            'Infoblox::DTC::Monitor::SNMP',
        ) {

            $t = $obj_class->__new__();
            push @_objtype_return_fields,
                tFieldObjType($t->__ibap_object_type__, {
                    sub_fields => $t->__return_fields__(),
                });
        }

        push @_return_fields,
            tField('monitor', {
                default_no_access_ok => 1,
                sub_fields           => \@_objtype_return_fields,
            });
    }
}

#
#
#

sub __ibap_to_object__ {

    my $self = shift;

    my ($ibap_object_ref, $server,
        $session, $return_object_cache_ref) = @_;

    foreach (
        'invert_monitor_metric',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }


    return $self->SUPER::__ibap_to_object__(@_);
}


package Infoblox::DTC::Pool::Link;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             $_return_fields_initialized
             @_return_fields
             $_object_type
             %_ibap_to_object
             %_name_mappings
             %_reverse_name_mappings
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'idns_lbdn_pool_link';
    register_wsdl_type('ib:idns_lbdn_pool_link', 'Infoblox::DTC::Pool::Link');

    %_allowed_members = (
                         'dtc_pool' => {validator => {'Infoblox::DTC::Pool' => 1}},
                         'ratio'     => {simple => 'asis', validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'dtc_pool' => 'pool',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('ratio'),
    );

    %_ibap_to_object = (
                        'pool' => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                        'dtc_pool' => \&ibap_o2i_object_by_oid_or_name,
                        'ratio'     => \&ibap_o2i_uint,
    );

    $_return_fields_initialized = 0;
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

        my $t = Infoblox::DTC::Pool->__new__();
        push @_return_fields,
            tField('pool', {sub_fields => $t->__return_fields__()});
    }
}


package Infoblox::DTC::Server;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
            $_object_type
            $_return_fields_initialized
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_return_field_overrides
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'IdnsServer';
    register_wsdl_type('ib:IdnsServer', 'Infoblox::DTC::Server');

    %_allowed_members = (
                         'auto_create_host_record' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'comment'                 => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'disable'                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'extattrs'                => {special => 'extensible_attributes'},
                         'extensible_attributes'   => {special => 'extensible_attributes'},
                         'health'                  => {readonly => 1, validator => {'Infoblox::DTC::Health' => 1}},
                         'host'                    => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'name'                    => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'sni_hostname'            => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_sni_hostname', use_truefalse => 1},
                         'override_sni_hostname'   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'monitors'                => {array => 1, validator => {'Infoblox::DTC::Server::Monitor' => 1}},

                         'translation'             => {deprecated => 1},
                         'override_translation'    => {deprecated => 1},
    );

    %_name_mappings = (
                       'disable'               => 'disabled',
                       'extattrs'              => 'extensible_attributes',
                       'override_sni_hostname' => 'use_sni_hostname',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'comment'               => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'extattrs'              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'host'                  => [\&ibap_o2i_string, 'host', 'REGEX'],
                           'name'                  => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'pool'                  => [\&ibap_o2i_object_by_oid_or_name, 'search_pool', 'EXACT'],
                           'status_member'         => [\&ibap_o2i_object_by_oid_or_name, 'search_status_member', 'EXACT'],
                           'sni_hostname'          => [\&ibap_o2i_string, 'sni_hostname', 'REGEX'],
    );

    @_return_fields = (
                       tField('name'),
                       tField('host'),
                       tField('disabled'),
                       tField('auto_create_host_record'),
                       tField('comment'),
                       tField('sni_hostname'),
                       tField('use_sni_hostname'),
                       return_fields_extensible_attributes(),
    );

    %_ibap_to_object = (
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'health'                => \&ibap_i2o_generic_object_convert,
                        'monitors'              => \&ibap_i2o_generic_object_list_convert,
    );

    %_object_to_ibap = (
                        'auto_create_host_record' => \&ibap_o2i_boolean,
                        'comment'                 => \&ibap_o2i_string,
                        'disable'                 => \&ibap_o2i_boolean,
                        'extattrs'                => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'   => \&ibap_o2i_ignore,
                        'health'                  => \&ibap_o2i_ignore,
                        'host'                    => \&ibap_o2i_string,
                        'name'                    => \&ibap_o2i_string,
                        'translation'             => \&ibap_o2i_ignore,
                        'override_translation'    => \&ibap_o2i_ignore,
                        'sni_hostname'            => \&ibap_o2i_string,
                        'override_sni_hostname'   => \&ibap_o2i_boolean,
                        'monitors'                => \&ibap_o2i_generic_struct_list_convert,
    );

    %_return_field_overrides = (
                                'auto_create_host_record' => [],
                                'comment'                 => [],
                                'disable'                 => [],
                                'extattrs'                => [],
                                'extensible_attributes'   => [],
                                'health'                  => [],
                                'host'                    => [],
                                'name'                    => [],
                                'sni_hostname'            => ['use_sni_hostname'],
                                'override_sni_hostname'   => [],
                                'monitors'                => [],
    );

    $_return_fields_initialized = 0;
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
        
        my ($tmp, %tmp);

        %tmp = ( 
                'health'   => 'Infoblox::DTC::Health',
                'monitors' => 'Infoblox::DTC::Server::Monitor',
        );  

        foreach my $key (keys %tmp) {
            $tmp = $tmp{$key}->__new__();
            push @_return_fields, tField($key, {sub_fields => $tmp->__return_fields__()});
        }   
    }
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
        'auto_create_host_record',
        'disabled',
        'use_sni_hostname',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    $self->{'monitors'} = [];

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    $self->{'override_sni_hostname'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_sni_hostname'});

    return $res;
}


package Infoblox::DTC::Server::Link;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             @_return_fields
             $_return_fields_initialized
             $_object_type
             %_ibap_to_object
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'idns_pool_server_link';
    register_wsdl_type('ib:idns_pool_server_link', 'Infoblox::DTC::Server::Link');

    %_allowed_members = (
                         'server' => {validator => {'Infoblox::DTC::Server' => 1}},
                         'ratio'  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('ratio'),
    );

    %_ibap_to_object = (
                        'server' => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                        'server' => \&ibap_o2i_object_by_oid_or_name,
                        'ratio'  => \&ibap_o2i_uint,
    );

    $_return_fields_initialized = 0;
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

        my $t = Infoblox::DTC::Server->__new__();
        push @_return_fields,
            tField('server', {sub_fields => $t->__return_fields__()});
    }
}


package Infoblox::DTC::Server::Monitor;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            $_object_type
            %_allowed_members
            %_ibap_to_object
            %_object_to_ibap
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'idns_server_monitor';
    register_wsdl_type('ib:idns_server_monitor', 'Infoblox::DTC::Server::Monitor');


    %_allowed_members = (
                         'monitor' => {validator => {'Infoblox::DTC::Monitor::TCP'  => 1,
                                                     'Infoblox::DTC::Monitor::HTTP' => 1,
                                                     'Infoblox::DTC::Monitor::PDP'  => 1,
                                                     'Infoblox::DTC::Monitor::SIP'  => 1,
                                                     'Infoblox::DTC::Monitor::ICMP' => 1,
                                                     'Infoblox::DTC::Monitor::SNMP' => 1,
                                      }},
                         'host'    => {simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'monitor' => \&ibap_i2o_generic_object_convert_partial,
    );

    %_object_to_ibap = (
                        'monitor' => \&ibap_o2i_object_only_by_oid,
                        'host'    => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('host'),
                       tField('monitor', {
                           'sub_fields' => [
                               tField('comment'),
                               tField('name'),
                           ],
                       }),
    );
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}


package Infoblox::DTC::Topology;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( %_capabilities
             %_allowed_members
             %_searchable_fields
             %_name_mappings
             %_reverse_name_mappings
             @_return_fields
             $_return_fields_initialized
             $_object_type
             %_ibap_to_object
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'IdnsTopology';
    register_wsdl_type('ib:IdnsTopology', 'Infoblox::DTC::Topology');

    %_allowed_members = (
                         'comment'               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'extattrs'              => {special => 'extensible_attributes'},
                         'extensible_attributes' => {special => 'extensible_attributes'},
                         'name'                  => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'rules'                 => {array => 1, validator => {'Infoblox::DTC::Topology::Rule' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'comment'               => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'name'                  => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'extattrs'              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
    );

    %_name_mappings = (
                       'extattrs' => 'extensible_attributes',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('comment'),
                       tField('name'),
                       return_fields_extensible_attributes(),
    );

    %_ibap_to_object = (
                        'rules'                 => \&ibap_i2o_generic_object_list_convert,
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
    );

    %_object_to_ibap = (
                        'comment'               => \&ibap_o2i_string,
                        'extattrs'              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes' => \&ibap_o2i_ignore,
                        'name'                  => \&ibap_o2i_string,
                        'rules'                 => \&__o2i_rules__,
    );

    $_return_fields_initialized = 0;
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

        my $t = Infoblox::DTC::Topology::Rule->__new__();
        push @_return_fields,
            tField('rules', {sub_fields => $t->__return_fields__()});
    }
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __gen_rule_id__ {

    my ($self, $i) = @_;

    #
    #
    #
    #

    my $time_octet = sprintf("%08s", substr(time(), -8)); # last eight digits of time value
    my $rand_octet = ''; # random values
    my $id_octet   = sprintf("%08s", $i); # id value

    #
    $rand_octet .= int(rand(10)) foreach (0 .. 7);

    return join '-', ($id_octet, $time_octet, $rand_octet);
}

sub __o2i_rules__ {

    my ($self, $session, $current, $tempref) = @_;
    my @rules = @{$$tempref{$current}};

    my %rule_names = ();

    my $i = 0;
    foreach (@rules) {
        unless ($_->{name}) {

            #
            my $r_name = $self->__gen_rule_id__($i);

            #
            #

            $r_name = $self->__gen_rule_id__($i++)
                while $rule_names{$r_name};

            #
            $_->{name} = $r_name;
        }

        #
        $rule_names{$_->{name}} = 1;

        $i++;
    }

    return ibap_o2i_generic_subobject_list_convert($self, $session, $current, $tempref);
}

package Infoblox::DTC::Topology::Rule;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             %_capabilities
             @_return_fields
             %_name_mappings
             %_reverse_name_mappings
             $_object_type
             %_ibap_to_object
             %_object_to_ibap
             %_searchable_fields
             @ISA
             $_return_fields_initialized );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'IdnsTopologyRule';
    register_wsdl_type('ib:IdnsTopologyRule', 'Infoblox::DTC::Topology::Rule');

    %_allowed_members = (
                         'sources'          => {array => 1, validator => {'Infoblox::DTC::Topology::Rule::Source' => 1}},
                         'destination_type' => {mandatory => 1, simple => 'asis', enum => ['POOL', 'SERVER']},
                         'destination_link' => {mandatory => 1, validator => {'Infoblox::DTC::Pool' => 1, 'Infoblox::DTC::Server' => 1}},
                         'valid'            => {readonly => 1, simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'topology'         => {readonly => 1,  validator => {'Infoblox::DTC::Topology' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'topology'           => [\&ibap_o2i_object_by_oid_or_name, 'parent', 'EXACT'],
                           'destination_type'   => [\&ibap_o2i_string, 'dest_type', 'EXACT'],
                           'destination_link'   => [\&ibap_o2i_object_by_oid_or_name, 'dest_link', 'EXACT'],
                           'valid'              => [\&ibap_o2i_boolean, 'valid', 'EXACT'],

    );

    %_name_mappings = (
                       'destination_type' => 'dest_type',
                       'destination_link' => 'dest_link',
                       'topology'         => 'parent',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    #
    #
    #
    #
    #
    #
    @_return_fields = (
                       tField('dest_type'),
                       tField('dest_link', {
                                            sub_fields => [
                                                           tField('name'),
                                                           tField('host', {
                                                                           not_exist_ok => 1,
                                                                          }
                                                           ),
                                                          ],
                                           },
                       ),
                       tField('valid'),
                       tField('parent', {sub_fields => [tField('name')]}),
                       tField('name'),
    );

    %_ibap_to_object = (
                        'sources'   => \&ibap_i2o_generic_object_list_convert,
                        'dest_link' => \&ibap_i2o_generic_object_convert_partial,
                        'parent'    => \&ibap_i2o_generic_object_convert_partial,
    );

    %_object_to_ibap = (
                        'sources'          => \&ibap_o2i_generic_struct_list_convert,
                        'destination_type' => \&ibap_o2i_string,
                        'valid'            => \&ibap_o2i_ignore,
                        'topology'         => \&ibap_o2i_ignore,
                        'destination_link' => \&ibap_o2i_object_by_oid_or_name,
                        'name'             => \&ibap_o2i_string,
    );

    $_return_fields_initialized = 0;
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

        my $t = Infoblox::DTC::Topology::Rule::Source->__new__();
        push @_return_fields,
            tField('sources', {sub_fields => $t->__return_fields__()});
    }

}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    $$ibap_object_ref{'valid'} = 0 unless defined $$ibap_object_ref{'valid'};

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);


    #
    #
    #
    #
    #
    #

    #
    #
    #

    foreach my $partial_field ('destination_link', 'topology') {

        if ($$self{$partial_field}) {

            my $obj_type = ref($$self{$partial_field});
            my $obj = $obj_type->__new__();

            foreach ('__object_id__', 'name', 'host') {

                $$obj{$_} = $$self{$partial_field}{$_}
                    if defined $$self{$partial_field}{$_};
            }

            foreach ('servers', 'monitors') {
                delete $$obj{$_};
            }

            $$obj{__partial__} = 1;
            $$self{$partial_field} = $obj;
        }
    }

    $$self{name} = $$ibap_object_ref{name};

    return $res;
}


package Infoblox::DTC::Topology::Rule::Source;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             @_return_fields
             $_object_type
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'idnstopologyrule_source';
    register_wsdl_type('ib:idnstopologyrule_source', 'Infoblox::DTC::Topology::Rule::Source');

    %_allowed_members = (
                         'source_type'  => {simple => 'asis', mandatory => 1, enum => ['SUBNET', 'SUBDIVISION', 'COUNTRY', 'CONTINENT', 'CITY', 'EA0', 'EA1', 'EA2', 'EA3']},
                         'source_op'    => {simple => 'asis', enum => ['IS', 'IS_NOT']},
                         'source_value' => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('source_type'),
                       tField('source_op'),
                       tField('source_value'),
    );

    %_object_to_ibap = (
                         'source_type'  => \&ibap_o2i_string,
                         'source_op'    => \&ibap_o2i_string,
                         'source_value' => \&ibap_o2i_string,
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

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}


package Infoblox::DTC::Topology::Label;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             @_return_fields
             $_object_type
             %_capabilities
             %_searchable_fields
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'IdnsTopologyLabel';
    register_wsdl_type('ib:IdnsTopologyLabel', 'Infoblox::DTC::Topology::Rule::Label');

    %_allowed_members = (
                         'field' => {readonly => 1, simple => 'asis', enum => ['SUBDIVISION', 'COUNTRY', 'CONTINENT', 'CITY', 'EA0', 'EA1', 'EA2', 'EA3']},
                         'label' => {readonly => 1, simple => 'asis'},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'field' => [\&ibap_o2i_string, 'field', 'EXACT'],
                           'label' => [\&ibap_o2i_string, 'label', 'REGEX'],
    );

    @_return_fields = (
                       tField('field'),
                       tField('label'),
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

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}


package Infoblox::DTC::Health;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             @_return_fields
             $_object_type
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'f5_health';
    register_wsdl_type('ib:f5_health', 'Infoblox::DTC::Health');

    %_allowed_members = (
                         'availability'  => {simple => 'asis', readonly => 1, enum => ['NONE', 'GREEN', 'YELLOW', 'RED', 'BLUE', 'GREY']},
                         'enabled_state' => {simple => 'asis', readonly => 1, enum => ['NONE', 'ENABLED', 'DISABLED', 'DISABLED_BY_PARENT']},
                         'description'   => {simple => 'asis', readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('availability'),
                       tField('enabled_state'),
                       tField('description'),
    );

    %_object_to_ibap = (
                        'availability'  => \&ibap_o2i_ignore,
                        'enabled_state' => \&ibap_o2i_ignore,
                        'description'   => \&ibap_o2i_ignore,
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

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}


package Infoblox::DTC::Certificate;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             @_return_fields
             $_object_type
             %_object_to_ibap
             %_ibap_to_object
             %_name_mappings
             %_reverse_name_mappings
             %_searchable_fields
             %_capabilities
             $_return_fields_initialized
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'IdnsCertificate';
    register_wsdl_type('ib:IdnsCertificate', 'Infoblox::DTC::Certificate');

    %_allowed_members = (
                         'certificate' => {readonly => 1, validator => {'Infoblox::Grid::X509Certificate' => 1}},
                         'in_use'      => {readonly => 1, simple => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           serial             => [\&ibap_o2i_string, 'serial', 'EXACT'],
                           issuer             => [\&ibap_o2i_string, 'issuer', 'EXACT'],
                           distinguished_name => [\&ibap_o2i_string, 'subject', 'EXACT'],
                           valid_not_after    => [\&ibap_o2i_string_to_datetime, 'valid_not_after', 'GLEQ'],
                           valid_not_before   => [\&ibap_o2i_string_to_datetime, 'valid_not_before', 'GLEQ'],
    );

    %_name_mappings = (
                       'certificate' => 'cert',
                       'in_use'      => 'used',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('used'),
    );

    %_ibap_to_object = (
                        'cert' => \&ibap_i2o_generic_object_convert,
                        'used' => \&ibap_i2o_boolean,
    );

    %_object_to_ibap = (
                        'certificate' => \&ibap_o2i_ignore,
                        'in_use'      => \&ibap_o2i_ignore,
    );

    $_return_fields_initialized = 0;
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

        my $t = Infoblox::Grid::X509Certificate->__new__();
        push @_return_fields,
            tField('cert', {
                    sub_fields => $t->__return_fields__(),
                    not_exist_ok => 1
                });
    }
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    $$ibap_object_ref{'used'} = 0 unless defined $$ibap_object_ref{'used'};

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    return $res;
}

sub __search_mapping_hook_post__ {

    my ($self, $session, $type, $argsref, $out_search_fields, $out_search_types, $out_search_matches) = @_;

    my @x509Cert;

    #
    #

    #
    #
    foreach my $field ('serial',
                       'issuer',
                       'subject',
                       'valid_not_after',
                       'valid_not_before')
    {
        if ($$out_search_fields{$field} and $$out_search_types{$field}) {
            push @x509Cert, {
                field => $field,
                value => $$out_search_fields{$field},
                type  => $$out_search_types{$field},

            };
            foreach ($out_search_fields, $out_search_types, $out_search_matches) {
                delete $_{$field};
                delete $$argsref{$_};
            }
        } elsif ($$argsref{$field}) {
            #
            return undef;
        }
    }

    return 1 unless @x509Cert;

    $$out_search_fields{'cert'} = tIBType('BaseObject', ibap_readfieldlist_simple('X509Certificate',
        \@x509Cert, undef, 'EXACT', 'readfield_substitution'));

    $$out_search_types{'cert'} = 'EXACT';
    return 1;
}


1;
