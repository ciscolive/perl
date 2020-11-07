package Infoblox::DTC::Monitor;

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

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'LbHealthMonitor';
    register_wsdl_type('ib:LbHealthMonitor', 'Infoblox::DTC::Monitor');

    %_allowed_members = (
                         'monitor'   => {readonly => 1, validator => { 'Infoblox::DTC::Monitor::TCP'  => 1,
                                                                       'Infoblox::DTC::Monitor::HTTP' => 1,
                                                                       'Infoblox::DTC::Monitor::PDP'  => 1,
                                                                       'Infoblox::DTC::Monitor::SIP'  => 1,
                                                                       'Infoblox::DTC::Monitor::ICMP' => 1,
                                                                       'Infoblox::DTC::Monitor::SNMP' => 1,
                                        }},

                         'name'       => {readonly => 1, simple => 'asis'},
                         'type'       => {readonly => 1, simple => 'asis', enum => ['HTTP', 'ICMP', 'PDP', 'TCP', 'SIP', 'SNMP']},
                         'comment'    => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'interval'   => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'timeout'    => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'port'       => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'retry_up'   => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'retry_down' => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'monitor' => 'object',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           'name'    => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'comment' => [\&ibap_o2i_string, 'comment', 'REGEX'],
    );

    @_return_fields = (
                       tField('name'),
                       tField('type'),
                       tField('comment'),
                       tField('interval'),
                       tField('timeout'),
                       tField('port'),
                       tField('retry_up'),
                       tField('retry_down'),
    );

    %_ibap_to_object = (
                        'object' => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                        'name'       => \&ibap_o2i_ignore,
                        'monitor'    => \&ibap_o2i_ignore,
                        'type'       => \&ibap_o2i_ignore,
                        'comment'    => \&ibap_o2i_ignore,
                        'interval'   => \&ibap_o2i_ignore,
                        'timeout'    => \&ibap_o2i_ignore,
                        'port'       => \&ibap_o2i_ignore,
                        'retry_up'   => \&ibap_o2i_ignore,
                        'retry_down' => \&ibap_o2i_ignore,
    );

    %_return_field_overrides = (
                                'comment'    => [],
                                'interval'   => [],
                                'monitor'    => [],
                                'name'       => [],
                                'port'       => [],
                                'retry_down' => [],
                                'retry_up'   => [],
                                'timeout'    => [],
                                'type'       => [],
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
            tField('object', {
                default_no_access_ok => 1,
                sub_fields           => \@_objtype_return_fields,
            });
    }
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}


package Infoblox::DTC::Monitor::BaseMonitor;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
            $_object_type
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

    %_allowed_members = (
                         'comment'               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'extattrs'              => {special => 'extensible_attributes'},
                         'extensible_attributes' => {special => 'extensible_attributes'},
                         'interval'              => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'name'                  => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'port'                  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'retry_down'            => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'retry_up'              => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'timeout'               => {simple => 'asis', validator => \&ibap_value_o2i_uint},
    );

    %_name_mappings = (
                       'extattrs' => 'extensible_attributes',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           'comment'               => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'extattrs'              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'name'                  => [\&ibap_o2i_string, 'name', 'REGEX'],
    );

    @_return_fields = (
                       tField('comment'),
                       tField('interval'),
                       tField('name'),
                       tField('port'),
                       tField('retry_down'),
                       tField('retry_up'),
                       tField('timeout'),
                       return_fields_extensible_attributes(),
    );

    %_ibap_to_object = (
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
    );

    %_object_to_ibap = (
                        'comment'               => \&ibap_o2i_string,
                        'extattrs'              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes' => \&ibap_o2i_ignore,
                        'interval'              => \&ibap_o2i_uint,
                        'name'                  => \&ibap_o2i_string,
                        'port'                  => \&ibap_o2i_uint,
                        'retry_down'            => \&ibap_o2i_uint,
                        'retry_up'              => \&ibap_o2i_uint,
                        'timeout'               => \&ibap_o2i_uint,
    );

    %_return_field_overrides = (
                                'comment'               => [],
                                'extattrs'              => [],
                                'extensible_attributes' => [],
                                'interval'              => [],
                                'name'                  => [],
                                'port'                  => [],
                                'retry_down'            => [],
                                'retry_up'              => [],
                                'timeout'               => [],
    );
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    {
        no strict 'refs';

        if (!$self->__initialize_members_from_arg_list__(\%{$class . '::_allowed_members'}, \%args) ||
            !$self->__validate_object_required_members__(\%{$class . '::_allowed_members'}))
        {
            return;
        }

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

    my $self = shift;
    my $class = ref $self || $self;

    {
        no strict 'refs';
        return ${$class . '::_object_type'};
    }
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    my $class = ref $self || $self;

    {
        no strict 'refs';
        return ${$class . '::_capabilities'}{$what};
    }
}

sub __init_instance_constants__ {}


package Infoblox::DTC::Monitor::TCP;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
            $_object_type
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

@ISA = qw( Infoblox::DTC::Monitor::BaseMonitor );

BEGIN {

    %_capabilities = ();

    $_object_type = 'IdnsMonitorTcp';
    register_wsdl_type('ib:IdnsMonitorTcp', 'Infoblox::DTC::Monitor::TCP');

    %_allowed_members = (
                         'port' => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
    );
    %_searchable_fields = ();
    @_return_fields = ();
    %_object_to_ibap = ();
    %_return_field_overrides = ();

    Infoblox::IBAPBase::subclass('Infoblox::DTC::Monitor::BaseMonitor', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


package Infoblox::DTC::Monitor::PDP;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
            $_object_type
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

@ISA = qw( Infoblox::DTC::Monitor::BaseMonitor );

BEGIN {

    %_capabilities = ();

    $_object_type = 'IdnsMonitorPdp';
    register_wsdl_type('ib:IdnsMonitorPdp', 'Infoblox::DTC::Monitor::PDP');

    %_allowed_members = ();
    %_searchable_fields = ();
    @_return_fields = ();
    %_object_to_ibap = ();
    %_return_field_overrides = ();

    Infoblox::IBAPBase::subclass('Infoblox::DTC::Monitor::BaseMonitor', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


package Infoblox::DTC::Monitor::ICMP;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
            $_object_type
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

@ISA = qw( Infoblox::DTC::Monitor::BaseMonitor );

BEGIN {

    %_capabilities = ();

    $_object_type = 'IdnsMonitorIcmp';
    register_wsdl_type('ib:IdnsMonitorIcmp', 'Infoblox::DTC::Monitor::ICMP');

    %_allowed_members = ();
    %_searchable_fields = ();
    @_return_fields = ();
    %_object_to_ibap = ();
    %_return_field_overrides = ();

    Infoblox::IBAPBase::subclass('Infoblox::DTC::Monitor::BaseMonitor', $_object_type, {'port' => 1});
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


package Infoblox::DTC::Monitor::SIP;

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

@ISA = qw( Infoblox::DTC::Monitor::BaseMonitor );

BEGIN {

    %_capabilities = ();

    $_object_type = 'IdnsMonitorSip';
    register_wsdl_type('ib:IdnsMonitorSip', 'Infoblox::DTC::Monitor::SIP');

    %_allowed_members = (
                         'ciphers'       => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'client_cert'   => {validator => {'Infoblox::DTC::Certificate' => 1}},
                         'request'       => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'result'        => {simple => 'asis', enum => ['ANY', 'CODE_IS', 'CODE_IS_NOT']},
                         'result_code'   => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'transport'     => {simple => 'asis', enum => ['TCP', 'UDP', 'TLS', 'SIPS']},
                         'validate_cert' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    %_searchable_fields = ();
    %_name_mappings = ();
    %_reverse_name_mappings = ();

    @_return_fields = (
                       tField('ciphers'),
                       tField('request'),
                       tField('result'),
                       tField('result_code'),
                       tField('transport'),
                       tField('validate_cert'),
    );

    %_ibap_to_object = (
                        'client_cert' => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                        'ciphers'       => \&ibap_o2i_string,
                        'client_cert'   => \&ibap_o2i_object_only_by_oid,
                        'request'       => \&ibap_o2i_string,
                        'result'        => \&ibap_o2i_string,
                        'result_code'   => \&ibap_o2i_uint,
                        'transport'     => \&ibap_o2i_string,
                        'validate_cert' => \&ibap_o2i_boolean,
    );

    %_return_field_overrides = (
                                'ciphers'       => [],
                                'client_cert'   => [],
                                'request'       => [],
                                'result'        => [],
                                'result_code'   => [],
                                'transport'     => [],
                                'validate_cert' => [],
    );

    Infoblox::IBAPBase::subclass('Infoblox::DTC::Monitor::BaseMonitor', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    $_return_fields_initialized = 0;
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my $t = Infoblox::DTC::Certificate->__new__();
        push @_return_fields,
            tField('client_cert', {sub_fields => $t->__return_fields__()});
    }
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'validate_cert'} = 0 unless defined $$ibap_object_ref{'validate_cert'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::DTC::Monitor::HTTP;

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

@ISA = qw( Infoblox::DTC::Monitor::BaseMonitor );

BEGIN {

    %_capabilities = ();

    $_object_type = 'IdnsMonitorHttp';
    register_wsdl_type('ib:IdnsMonitorHttp', 'Infoblox::DTC::Monitor::HTTP');

    %_allowed_members = (
                         'ciphers'               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'client_cert'           => {validator => {'Infoblox::DTC::Certificate' => 1}},
                         'content_check'         => {simple => 'asis', enum => ['NONE', 'MATCH', 'EXTRACT']},
                         'content_check_input'   => {simple => 'asis', enum => ['HEADERS', 'ALL', 'BODY']},
                         'content_check_op'      => {simple => 'asis', enum => ['EQ', 'NEQ', 'LEQ', 'GEQ']},
                         'content_check_regex'   => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'content_extract_group' => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'content_extract_type'  => {simple => 'asis', enum => ['INTEGER', 'STRING']},
                         'content_extract_value' => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'request'               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'result'                => {simple => 'asis', enum => ['ANY', 'CODE_IS', 'CODE_IS_NOT']},
                         'result_code'           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'secure'                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'validate_cert'         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_sni'            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    %_name_mappings = ();
    %_searchable_fields = ();

    @_return_fields = (
                       tField('request'),
                       tField('result'),
                       tField('result_code'),
                       tField('secure'),
                       tField('ciphers'),
                       tField('content_check'),
                       tField('content_check_input'),
                       tField('content_check_regex'),
                       tField('content_check_op'),
                       tField('content_extract_group'),
                       tField('content_extract_type'),
                       tField('content_extract_value'),
                       tField('validate_cert'),
                       tField('enable_sni'),
    );

    %_ibap_to_object = (
                        'client_cert' => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                        'ciphers'               => \&ibap_o2i_string,
                        'client_cert'           => \&ibap_o2i_object_only_by_oid,
                        'content_check'         => \&ibap_o2i_string,
                        'content_check_input'   => \&ibap_o2i_string,
                        'content_check_op'      => \&ibap_o2i_string,
                        'content_check_regex'   => \&ibap_o2i_string,
                        'content_extract_group' => \&ibap_o2i_uint,
                        'content_extract_type'  => \&ibap_o2i_string,
                        'content_extract_value' => \&ibap_o2i_string,
                        'request'               => \&ibap_o2i_string,
                        'result'                => \&ibap_o2i_string,
                        'result_code'           => \&ibap_o2i_uint,
                        'secure'                => \&ibap_o2i_boolean,
                        'validate_cert'         => \&ibap_o2i_boolean,
                        'enable_sni'            => \&ibap_o2i_boolean,
    );

    %_return_field_overrides = (
                                'ciphers'               => [],
                                'client_cert'           => [],
                                'content_check'         => [],
                                'content_check_input'   => [],
                                'content_check_op'      => [],
                                'content_check_regex'   => [],
                                'content_extract_group' => [],
                                'content_extract_type'  => [],
                                'content_extract_value' => [],
                                'request'               => [],
                                'result'                => [],
                                'result_code'           => [],
                                'secure'                => [],
                                'validate_cert'         => [],
                                'enable_sni'            => [],
    );

    Infoblox::IBAPBase::subclass('Infoblox::DTC::Monitor::BaseMonitor', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    $_return_fields_initialized = 0;
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my $t = Infoblox::DTC::Certificate->__new__();
        push @_return_fields,
            tField('client_cert', {sub_fields => $t->__return_fields__()});
    }
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'secure'} = 0 unless defined $$ibap_object_ref{'secure'};
    $$ibap_object_ref{'validate_cert'} = 0 unless defined $$ibap_object_ref{'validate_cert'};
    $$ibap_object_ref{'enable_sni'} = 0 unless defined $$ibap_object_ref{'enable_sni'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::DTC::Monitor::SNMP;

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

@ISA = qw( Infoblox::DTC::Monitor::BaseMonitor );

BEGIN {

    %_capabilities = ();

    $_object_type = 'IdnsMonitorSnmp';
    register_wsdl_type('ib:IdnsMonitorSnmp', 'Infoblox::DTC::Monitor::SNMP');

    %_allowed_members = (
                         'community' => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'context'   => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'engine_id' => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'oids'      => {array => 1, validator => {'Infoblox::DTC::Monitor::SNMP::OID' => 1}},
                         'user'      => {validator => \&ibap_value_o2i_string},
                         'version'   => {simple => 'asis', enum => ['V1', 'V2C', 'V3']},
    );

    %_searchable_fields = (
                           'context'   => [\&ibap_o2i_string, 'context', 'REGEX'],
                           'engine_id' => [\&ibap_o2i_string, 'engine_id', 'REGEX'],
    );

    @_return_fields = (
                       tField('community'),
                       tField('context'),
                       tField('engine_id'),
                       tField('user', {sub_fields => [tField('name')]}),
                       tField('version'),
    );

    %_ibap_to_object = (
                        'oids' => \&ibap_i2o_generic_object_list_convert,
                        'user' => \&ibap_i2o_object_name,
    );

    %_object_to_ibap = (
                        'community' => \&ibap_o2i_string,
                        'context'   => \&ibap_o2i_string,
                        'engine_id' => \&ibap_o2i_string,
                        'oids'      => \&ibap_o2i_generic_struct_list_convert,
                        'user'      => \&ibap_o2i_snmpv3_users,
                        'version'   => \&ibap_o2i_string,
    );

    %_return_field_overrides = (
                                'community' => [],
                                'context'   => [],
                                'engine_id' => [],
                                'oids'      => [],
                                'user'      => [],
                                'version'   => [],
    );

    Infoblox::IBAPBase::subclass('Infoblox::DTC::Monitor::BaseMonitor', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    $_return_fields_initialized = 0;
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my $tmp = Infoblox::DTC::Monitor::SNMP::OID->__new__();
        push @_return_fields, tField('oids', {sub_fields => $tmp->__return_fields__()});
    }
}


package Infoblox::DTC::Monitor::SNMP::OID;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            @ISA
            $_object_type
            %_allowed_members
            %_object_to_ibap
            %_name_mappings
            %_reverse_name_mappings
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'idns_monitor_snmp_oid';
    register_wsdl_type('ib:idns_monitor_snmp_oid', 'Infoblox::DTC::Monitor::SNMP::OID');



    %_allowed_members = (
                         'comment'   => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'condition' => {simple => 'asis', enum => ['ANY', 'EXACT', 'LEQ', 'GEQ', 'RANGE']},
                         'first'     => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'last'      => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'oid'       => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'type'      => {simple => 'asis', enum => ['STRING', 'INTEGER']},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                      'oid' => 'snmp_oid',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_object_to_ibap = (
                        'comment'   => \&ibap_o2i_string,
                        'condition' => \&ibap_o2i_string,
                        'first'     => \&ibap_o2i_string,
                        'last'      => \&ibap_o2i_string,
                        'oid'       => \&ibap_o2i_string,
                        'type'      => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('snmp_oid'),
                       tField('comment'),
                       tField('type'),
                       tField('condition'),
                       tField('first'),
                       tField('last'),
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

sub __ibap_object_types__ {

    return $_object_type;
}


1;
