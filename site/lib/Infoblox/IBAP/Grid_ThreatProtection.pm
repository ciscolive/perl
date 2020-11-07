package Infoblox::Grid::ThreatProtection::RuleParam;
  
use strict;
  
use Carp;
  
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap @_return_fields);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {
    $_object_type = 'atp_rule_param';
    register_wsdl_type('ib:atp_rule_param','Infoblox::Grid::ThreatProtection::RuleParam');

    %_allowed_members = (
                         name          => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         description   => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         syntax        => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         min           => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         max           => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         read_only     => {readonly => 1, simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         value         => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         enum_values   => {readonly => 1, simple => 'asis', array => 1, validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        name           => \&ibap_o2i_string,
                        description    => \&ibap_o2i_ignore,
                        #
                        #
                        #
                        syntax         => \&ibap_o2i_string,
                        min            => \&ibap_o2i_uint,
                        max            => \&ibap_o2i_uint,
                        read_only      => \&ibap_o2i_boolean,
                        value          => \&ibap_o2i_string,
                        enum_values    => \&ibap_o2i_string_array_undef_to_empty,
                       );

    @_return_fields =
      (
       tField('name'),
       tField('description'),
       tField('syntax'),
       tField('min'),
       tField('max'),
       tField('read_only'),
       tField('value'),
       tField('enum_values'),
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
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::Grid::ThreatProtection::RuleConfig;
  
use strict;
  
use Carp;
  
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap %_ibap_to_object @_return_fields $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'atp_rule_config';
    register_wsdl_type('ib:atp_rule_config','Infoblox::Grid::ThreatProtection::RuleConfig');

    %_allowed_members = (
                         'action'            => {'simple' => 'asis', 'enum' => ['ALERT', 'PASS', 'DROP']},
                         'log_severity'      => {'simple' => 'asis', 'enum' => ['CRITICAL', 'MAJOR', 'WARNING', 'INFORMATIONAL']},
                         'active_version'    => {'deprecated' => 1},
                         'params'            => {'mandatory' => 1, 'array'  => 1, 'validator' => {'Infoblox::Grid::ThreatProtection::RuleParam' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'params' => \&ibap_i2o_generic_object_list_convert,
                       );

    %_object_to_ibap = (
                        'action'             => \&ibap_o2i_string,
                        'log_severity'       => \&ibap_o2i_string,
                        'active_version'     => \&ibap_o2i_ignore,
                        'params'             => \&ibap_o2i_generic_struct_list_convert,
                       );

    $_return_fields_initialized=0;
    @_return_fields =
      (
       tField('action'),
       tField('log_severity'),
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
        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::ThreatProtection::RuleParam->__new__();
        push @_return_fields,
          tField('params', {'sub_fields' => $t->__return_fields__()});

    }
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::Grid::ThreatProtection::StatInfo;
  
use strict;
  
use Carp;
  
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap @_return_fields %_name_mappings %_reverse_name_mappings);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'atp_stat_info';
    register_wsdl_type('ib:atp_stat_info','Infoblox::Grid::ThreatProtection::StatInfo');

    %_allowed_members = (
                         'timestamp'     => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string_to_datetime},
                         'critical'      => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_ulong},
                         'major'         => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_ulong},
                         'warning'       => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_ulong},
                         'informational' => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_ulong},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'critical' => 'critical_count',
                       'major'    => 'major_count',
                       'warning'  => 'warning_count',
                       'informational' => 'informational_count',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_object_to_ibap = (
                        'timestamp'      => \&ibap_o2i_string,
                        'critical'       => \&ibap_o2i_ulong,
                        'major'          => \&ibap_o2i_ulong,
                        'warning'        => \&ibap_o2i_ulong,
                        'informational'  => \&ibap_o2i_ulong,
                       );

    @_return_fields =
      (
       tField('timestamp'),
       tField('critical_count'),
       tField('major_count'),
       tField('warning_count'),
       tField('informational_count'),
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
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::Grid::ThreatProtection::Ruleset;
  
use strict;
  
use Carp;
  
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap @_return_fields
                 %_capabilities $_return_fields_initialized %_name_mappings %_reverse_name_mappings);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'AtpRuleset';
    register_wsdl_type('ib:AtpRuleset','Infoblox::Grid::ThreatProtection::Ruleset');

    #
    #
    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                      'single_serialization' => 0,
                     );

    %_allowed_members = (
                         'version'                  => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'add_type'                 => {'readonly' => 1, 'simple' => 'asis', 'enum' => ['AUTOMATIC', 'MANUAL']},
                         'added_time'               => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string_to_datetime},
                         'used_by'                  => {'readonly' => 1, 'array' => 1, 'validator' => \&ibap_value_o2i_string},
                         'do_not_delete'            => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'comment'                  => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'is_factory_reset_enabled' => {'readonly' => 1, 'simple' => 'bool'},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'added_time'      => 'added_on',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_object_to_ibap = (
                        'version'                  => \&ibap_o2i_ignore,
                        'add_type'                 => \&ibap_o2i_ignore,
                        'added_time'               => \&ibap_o2i_ignore,
                        'used_by'                  => \&ibap_o2i_ignore,
                        'do_not_delete'            => \&ibap_o2i_boolean,
                        'comment'                  => \&ibap_o2i_string,
                        'is_factory_reset_enabled' => \&ibap_o2i_ignore,
                       );

    $_return_fields_initialized=0;
    @_return_fields =
      (
       tField('version'),
       tField('add_type'),
       tField('added_on'),
       tField('used_by'),
       tField('do_not_delete'),
       tField('comment'),
       tField('is_factory_reset_enabled'),
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
#
#

sub __add_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'add' not allowed for this object", $session);
    return;
}


package Infoblox::Grid::ThreatProtection;
  
use strict;
  
use Carp;
  
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap @_return_fields
                 %_capabilities %_searchable_fields $_return_fields_initialized
                 %_ibap_to_object);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_MODIFY_ONLY);

BEGIN {
    $_object_type = 'GridAtp';
    register_wsdl_type('ib:GridAtp','Infoblox::Grid::ThreatProtection');

    #
    #
    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                      'single_serialization' => 0,
                     );

    %_allowed_members = (
                         'rule_update_policy'            => {'simple' => 'asis', 'enum' => ['AUTOMATIC', 'MANUAL']},
                         'events_per_second_per_rule'    => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'last_checked_for_update'       => {'readonly' => 1, 'validator' => \&ibap_value_o2i_uint},
                         'last_rule_update_version'      => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'enable_auto_download'          => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'enable_scheduled_download'     => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'scheduled_download'            => {'validator' => {'Infoblox::Grid::ScheduleSetting' => 1}},
                         'disable_multiple_dns_tcp_request' => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'current_ruleset'               => {'validator' => {'Infoblox::Grid::ThreatProtection::Ruleset' => 1}},
                         'enable_nat_rules'              => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'nat_rules'                     => {'validator' => {'Infoblox::Grid::ThreatProtection::NATRule' => 1}, 'array' => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'scheduled_download' => \&ibap_i2o_generic_object_convert,
                        'current_ruleset'    => \&ibap_i2o_generic_object_convert,
                        'last_checked_for_update' => \&ibap_i2o_datetime_to_unix_timestamp,
                        'nat_rules'               => \&ibap_i2o_generic_object_list_convert,
                       );

    %_object_to_ibap = (
                        'rule_update_policy'         => \&ibap_o2i_string,
                        'events_per_second_per_rule' => \&ibap_o2i_uint,
                        'last_rule_update_version'   => \&ibap_o2i_ignore,
                        'last_checked_for_update'    => \&ibap_o2i_ignore,
                        'enable_auto_download'       => \&ibap_o2i_boolean,
                        'enable_scheduled_download'  => \&ibap_o2i_boolean,
                        'scheduled_download'         => \&ibap_o2i_generic_struct_convert,
                        'disable_multiple_dns_tcp_request' => \&ibap_o2i_boolean,
                        'current_ruleset'            => \&ibap_o2i_object_only_by_oid_undef_ok,
                        'nat_rules'                  => \&ibap_o2i_generic_struct_list_convert,
                        'enable_nat_rules'           => \&ibap_o2i_boolean,
                       );

    $_return_fields_initialized=0;
    @_return_fields =
      (
       tField('rule_update_policy'),
       tField('events_per_second_per_rule'),
       tField('last_rule_update_version'),
       tField('last_checked_for_update'),
       tField('enable_auto_download'),
       tField('enable_scheduled_download'),
       tField('disable_multiple_dns_tcp_request'),
       tField('enable_nat_rules'),
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

        $_return_fields_initialized = 1;

        my (%tmp, $t);

        %tmp = (
                scheduled_download => 'Infoblox::Grid::ScheduleSetting',
                nat_rules          => 'Infoblox::Grid::ThreatProtection::NATRule',
        );

        foreach (keys %tmp) {
            $t = $tmp{$_}->__new__();
            push @_return_fields, tField($_, { sub_fields => $t->__return_fields__() });
        }

        $t = Infoblox::Grid::ThreatProtection::Ruleset->__new__();
        push @_return_fields, tField('current_ruleset',
                        { no_access_ok => 1,
                          sub_fields => $t->__return_fields__() });
    }
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->{'__internal_session_cache_ref__'} = $session;
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
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

sub test_threat_protection_server_connectivity {

    my $self = shift;
    my ($fname, $fargs) = ('TestAtpServerConnectivity', {});

    #
    #
    #

    unless ($self->{'__internal_session_cache_ref__'}) {

        set_error_codes('1012', 'In order to test Threat Protection Server connectivity' .
            ' the object must have been retrieved from the server first');

        return 0;
    }

    my $session = $self->{'__internal_session_cache_ref__'};

    #
    #
    #

    my $server = $session->get_ibap_server() || return 0;

    my $result;
    eval {
        $result = $server->ibap_request($fname, $fargs);
    };

    #
    #
    #

    return $server->set_papi_error($@, $session, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $session);

    my $response = Infoblox::Grid::TestResult->__new__();
    $response->__ibap_to_object__($result);

    return $response;

    #
    #
    #
}


package Infoblox::Grid::Member::ThreatProtection;
  
use strict;
  
use Carp;
  
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap @_return_fields %_name_mappings %_reverse_name_mappings %_ibap_to_object
                 %_capabilities %_searchable_fields $_return_fields_initialized %_return_field_overrides);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE);

BEGIN {
    $_object_type = 'MemberAtp';
    register_wsdl_type('ib:MemberAtp','Infoblox::Grid::Member::ThreatProtection');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                     );

    %_allowed_members = (
                         'grid_member'                               => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'events_per_second_per_rule'                => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint,
                                                                         'use' => 'override_events_per_second_per_rule', 'use_truefalse' => 1},
                         'enable_service'                            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'override_events_per_second_per_rule'       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'disable_multiple_dns_tcp_request'          => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean,
                                                                         'use' => 'override_disable_multiple_dns_tcp_request', 'use_truefalse' => 1},
                         'override_disable_multiple_dns_tcp_request' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'current_ruleset'                           => {'validator' => {'Infoblox::Grid::ThreatProtection::Ruleset' => 1},
                                                                         'use' => 'override_current_ruleset', 'use_truefalse' => 1},
                         'override_current_ruleset'                  => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_nat_rules'                          => {'simple' => 'bool', use => 'override_enable_nat_rules',
                                                                         'use_truefalse' => 1, 'validator' => \&ibap_value_o2i_boolean},
                         'nat_rules'                                 => {'validator' => {'Infoblox::Grid::ThreatProtection::NATRule' => 1}, 'array' => 1},
                         'override_enable_nat_rules'                 => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'profile'                                   => {'validator' => {'Infoblox::Grid::ThreatProtection::Profile' => 1}},
                         'hardware_type'                             => {'readonly' => 1, 'simple' => 'asis'},
                         'hardware_model'                            => {'readonly' => 1, 'simple' => 'asis'},

                        );

    %_name_mappings = (
                       'grid_member'                               => 'host_name',
                       'override_events_per_second_per_rule'       => 'use_events_per_second_per_rule',
                       'override_disable_multiple_dns_tcp_request' => 'use_disable_multiple_dns_tcp_request',
                       'override_current_ruleset'                  => 'use_current_ruleset',
                       'override_enable_nat_rules'                 => 'use_enable_nat_rules',
                    );

    %_reverse_name_mappings = reverse %_name_mappings;

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'current_ruleset'                      => \&ibap_i2o_generic_object_convert,
                        'use_events_per_second_per_rule'       => \&ibap_i2o_boolean,
                        'use_disable_multiple_dns_tcp_request' => \&ibap_i2o_boolean,
                        'use_current_ruleset'                  => \&ibap_i2o_boolean,
                        'use_enable_nat_rules'                 => \&ibap_i2o_boolean,
                        'enable_nat_rules'                     => \&ibap_i2o_boolean,
                        'nat_rules'                            => \&ibap_i2o_generic_object_list_convert,
                        'profile'                              => \&ibap_i2o_generic_object_convert,
                       );

    %_object_to_ibap = (
                        'grid_member'                               => \&ibap_o2i_ignore,
                        'events_per_second_per_rule'                => \&ibap_o2i_uint,
                        'enable_service'                            => \&ibap_o2i_boolean,
                        'override_events_per_second_per_rule'       => \&ibap_o2i_boolean,
                        'disable_multiple_dns_tcp_request'          => \&ibap_o2i_boolean,
                        'override_disable_multiple_dns_tcp_request' => \&ibap_o2i_boolean,
                        'current_ruleset'                           => \&ibap_o2i_object_only_by_oid_undef_ok,
                        'override_current_ruleset'                  => \&ibap_o2i_boolean,
                        'override_enable_nat_rules'                 => \&ibap_o2i_boolean,
                        'enable_nat_rules'                          => \&ibap_o2i_boolean,
                        'nat_rules'                                 => \&ibap_o2i_generic_struct_list_convert,
                        'profile'                                   => \&ibap_o2i_object_only_by_oid_undef_ok,
                        'hardware_type'                             => \&ibap_o2i_ignore,
                        'hardware_model'                            => \&ibap_o2i_ignore,
                       );

    %_return_field_overrides = (
                        'grid_member'                               => [],
                        'enable_service'                            => [],
                        'events_per_second_per_rule'                => ['use_events_per_second_per_rule'],
                        'override_events_per_second_per_rule'       => [],
                        'disable_multiple_dns_tcp_request'          => ['use_disable_multiple_dns_tcp_request'],
                        'override_disable_multiple_dns_tcp_request' => [],
                        'current_ruleset'                           => ['use_current_ruleset'],
                        'override_current_ruleset'                  => [],
                        'enable_nat_rules'                          => ['use_enable_nat_rules'],
                        'override_enable_nat_rules'                 => [],
                        'nat_rules'                                 => [],
                        'profile'                                   => [],
                        'hardware_type'                             => [],
                        'hardware_model'                            => [],
                       );

    $_return_fields_initialized=0;
    @_return_fields =
      (
       tField('host_name'),
       tField('events_per_second_per_rule'),
       tField('enable_service'),
       tField('use_events_per_second_per_rule'),
       tField('disable_multiple_dns_tcp_request'),
       tField('use_disable_multiple_dns_tcp_request'),
       tField('use_current_ruleset'),
       tField('use_enable_nat_rules'),
       tField('enable_nat_rules'),
       tField('hardware_type'),
       tField('hardware_model'),

      );

    %_searchable_fields = (
        'grid_member'    => [\&ibap_o2i_string, 'host_name', 'EXACT'],
        'hardware_type'  => [\&ibap_o2i_string, 'hardware_type', 'REGEX'],
        'hardware_model' => [\&ibap_o2i_string, 'hardware_model', 'REGEX'],
        'profile'        => [\&ibap_o2i_object_only_by_oid_undef_ok, 'profile', 'EXACT'],
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

        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::ThreatProtection::Ruleset->__new__();
        push @_return_fields, tField('current_ruleset', {
                no_access_ok => 1,
                sub_fields => $t->__return_fields__(),
        });

        $t = Infoblox::Grid::ThreatProtection::NATRule->__new__();
        push @_return_fields, tField('nat_rules', { sub_fields => $t->__return_fields__() });

        $t = Infoblox::Grid::ThreatProtection::Profile->__new__();
        push @_return_fields, tField('profile', { sub_fields => $t->__return_fields__() });
    }
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

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
             'enable_service',
             'use_events_per_second_per_rule',
             'use_disable_multiple_dns_tcp_request',
             'disable_multiple_dns_tcp_request',
             'use_current_ruleset',
             'use_enable_nat_rules',
             'enable_nat_rules',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    $self->{'override_current_ruleset'}  = ibap_value_i2o_boolean($$ibap_object_ref{'use_current_ruleset'});
    $self->{'override_enable_nat_rules'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_nat_rules'});
    return $res;
}


package Infoblox::Grid::ThreatProtection::RuleCategory;
  
use strict;
  
use Carp;
  
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap @_return_fields $_return_fields_initialized %_capabilities %_searchable_fields);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::RO);

BEGIN {
    $_object_type = 'AtpRuleCategory';
    register_wsdl_type('ib:AtpRuleCategory','Infoblox::Grid::ThreatProtection::RuleCategory');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                     );

    %_searchable_fields = (
                           name => [\&ibap_o2i_string,'name' , 'EXACT'],
                          );

    %_allowed_members = (
                         'name'                     => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'is_factory_reset_enabled' => {'readonly' => 1, 'simple' => 'bool'},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                         'name'                     => \&ibap_o2i_ignore,
                         'is_factory_reset_enabled' => \&ibap_o2i_ignore,
                       );

    $_return_fields_initialized=0;
    @_return_fields =
      (
         tField('name'),
         tField('is_factory_reset_enabled'),
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


package Infoblox::Grid::ThreatProtection::Rule;
  
use strict;
  
use Carp;
  
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object
                 %_name_mappings %_reverse_name_mappings %_object_to_ibap
                 @_return_fields %_capabilities %_searchable_fields
                 $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'AtpRule';
    register_wsdl_type('ib:AtpRule','Infoblox::Grid::ThreatProtection::Rule');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                     );

    %_searchable_fields = (
                           name => [\&ibap_o2i_string,'name' , 'EXACT'],
                           sid => [\&ibap_o2i_string,'sid' , 'EXACT'],
                           ruleset => [\&ibap_o2i_object_only_by_oid, 'parent', 'EXACT'],
                          );

    %_allowed_members = (
                         'ruleset'                  => {'readonly' => 1, 'validator' => {'Infoblox::Grid::ThreatProtection::Ruleset' => 1}},
                         'sid'                      => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'name'                     => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'description'              => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'comment'                  => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'category'                 => {'readonly' => 1, 'validator' => \&ibap_value_o2i_string},
                         'type'                     => {'readonly' => 1, 'simple' => 'asis', 'enum' => ['SYSTEM', 'CUSTOM', 'AUTO']},
                         'allowed_actions'          => {'readonly' => 1, 'array' => 1, 'enum' => ['ALERT', 'PASS', 'DROP']},
                         'disable'                  => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'config'                   => {'mandatory' => 1, 'validator' => {'Infoblox::Grid::ThreatProtection::RuleConfig' => 1}},
                         'versions'                 => 0,
                         'version_status'           => {'deprecated' => 1},
                         'template'                 => {'mandatory' => 1, 'validator' => {'Infoblox::Grid::ThreatProtection::RuleTemplate' => 1}},
                         'is_factory_reset_enabled' => {'readonly' => 1, 'simple' => 'bool'},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'disable'             => 'disabled',
                       'ruleset'             => 'parent',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                         'parent'            => \&ibap_i2o_generic_object_convert,
                         'config'            => \&ibap_i2o_generic_object_convert,
                         'category'          => \&ibap_i2o_object_category_name,
                         'template'          => \&ibap_i2o_generic_object_convert,
                        );

    %_object_to_ibap = (
                         'ruleset'                  => \&ibap_o2i_ignore,
                         'sid'                      => \&ibap_o2i_ignore,
                         'name'                     => \&ibap_o2i_ignore,
                         'description'              => \&ibap_o2i_ignore,
                         'comment'                  => \&ibap_o2i_string,
                         'category'                 => \&ibap_o2i_ignore,
                         'type'                     => \&ibap_o2i_ignore,
                         'allowed_actions'          => \&ibap_o2i_ignore,
                         'disable'                  => \&ibap_o2i_boolean,
                         'config'                   => \&ibap_o2i_generic_struct_convert,
                         'versions'                 => \&ibap_o2i_ignore,
                         'version_status'           => \&ibap_o2i_ignore,
                         'template'                 => \&ibap_o2i_object_by_oid_or_name,
                         'is_factory_reset_enabled' => \&ibap_o2i_ignore,
                       );

    $_return_fields_initialized=0;
    @_return_fields =
      (
         tField('sid'),
         tField('name'),
         tField('description'),
         tField('comment'),
         tField('category', {'sub_fields' => [tField('name')]}),
         tField('type'),
         tField('allowed_actions'),
         tField('disabled'),
         tField('is_factory_reset_enabled'),
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

    #
    $self->disable('false') unless defined $self->disable();

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
        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::ThreatProtection::Ruleset->__new__();
        push @_return_fields,
          tField('parent', {'sub_fields' => $t->__return_fields__()});
        $t = Infoblox::Grid::ThreatProtection::RuleConfig->__new__();
        push @_return_fields,
          tField('config', {'sub_fields' => $t->__return_fields__()});
        $t = Infoblox::Grid::ThreatProtection::RuleTemplate->__new__();
        push @_return_fields,
          tField('template', {'sub_fields' => $t->__return_fields__()});

    }
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
sub versions
{
    my $self    = shift;
    return @_ ? 1 : [];
}

package Infoblox::Grid::Member::ThreatProtection::Rule;
  
use strict;
  
use Carp;
  
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_return_field_overrides
                 %_name_mappings %_reverse_name_mappings %_object_to_ibap
                 @_return_fields %_capabilities %_searchable_fields
                 $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'MemberAtpRule';
    register_wsdl_type('ib:MemberAtpRule','Infoblox::Grid::Member::ThreatProtection::Rule');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                     );

    %_searchable_fields = (
                          'member'    => [\&ibap_o2i_object_by_oid_or_name, 'parent', 'EXACT'],
                          'rule'      => [\&ibap_o2i_object_by_oid_or_name, 'rule' , 'EXACT'],
                          'sid'       => [\&ibap_o2i_substruct_exact_int_search, 'sid', 'SUBMATCHSTRUCT_rule'],
                          'ruleset'   => [\&ibap_o2i_object_only_by_oid, 'parent', 'EXACT'],
                          );

    %_allowed_members = (
                         'sid'               => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'rule'              => {'readonly' => 1, 'validator' => {'Infoblox::Grid::ThreatProtection::Rule' => 1}},
                         'member'            => {'readonly' => 1, 'validator' => {'Infoblox::Grid::Member::ThreatProtection' => 1}},
                         'disable'           => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean, use => 'override_disable', use_truefalse => 1},
                         'override_disable'  => {'simple' => 'bool', validator => \&ibap_value_o2i_boolean},
                         'config'            => {'validator' => {'Infoblox::Grid::ThreatProtection::RuleConfig' => 1}, use => 'override_config', use_truefalse => 1},
                         'override_config'   => {'simple' => 'bool', validator => \&ibap_value_o2i_boolean},
                         'version_status'    => {'deprecated' => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'member'              => 'parent',
                       'disable'             => 'disabled',
                       'override_disable'    => 'use_disabled',
                       'override_config'     => 'use_config',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                         'config'        => \&ibap_i2o_generic_object_convert,
                         'rule'          => \&ibap_i2o_generic_object_convert,
                         'parent'        => \&ibap_i2o_generic_object_convert,
                         'use_disabled'  => \&ibap_i2o_boolean,
                         'use_config'    => \&ibap_i2o_boolean,
                        );

    %_return_field_overrides = ();

    %_object_to_ibap = (
                         'sid'               => \&ibap_o2i_ignore,
                         'rule'              => \&ibap_o2i_ignore,
                         'member'            => \&ibap_o2i_ignore,
                         'disable'           => \&ibap_o2i_boolean,
                         'override_disable'  => \&ibap_o2i_boolean,
                         'config'            => \&ibap_o2i_generic_struct_convert,
                         'override_config'   => \&ibap_o2i_boolean,
                         'version_status'    => \&ibap_o2i_ignore,
                       );

    $_return_fields_initialized=0;
    @_return_fields =
      (
         tField('sid'),
         tField('disabled'),
         tField('use_disabled'),
         tField('use_config'),
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
        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::ThreatProtection::RuleConfig->__new__();
        push @_return_fields,
          tField('config', {'sub_fields' => $t->__return_fields__()});

        $t = Infoblox::Grid::Member::ThreatProtection->__new__();
        push @_return_fields,
          tField('parent', {'sub_fields' => $t->__return_fields__()});

        $t = Infoblox::Grid::ThreatProtection::Rule->__new__();
        push @_return_fields,
          tField('rule', {'sub_fields' => $t->__return_fields__()});

    }
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

package Infoblox::Grid::ThreatProtection::RuleTemplate;
  
use strict;
  
use Carp;
  
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object
                 %_object_to_ibap @_return_fields %_capabilities %_name_mappings %_reverse_name_mappings
                 %_searchable_fields $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::RO);

BEGIN {
    $_object_type = 'AtpRuleTemplate';
    register_wsdl_type('ib:AtpRuleTemplate','Infoblox::Grid::ThreatProtection::RuleTemplate');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                     );

    %_searchable_fields = (
                           name => [\&ibap_o2i_string,'name' , 'EXACT'],
                           sid => [\&ibap_o2i_string,'sid' , 'EXACT'],
                           ruleset => [\&ibap_o2i_object_only_by_oid, 'parent', 'EXACT'],
                          );

    %_allowed_members = (
                         'sid'               => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'name'              => {'mandatory' => 1, 'oidreadonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'description'       => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'category'          => {'readonly' => 1, 'validator' => \&ibap_value_o2i_string},
                         'allowed_actions'   => {'readonly' => 1, 'array' => 1, 'enum' => ['ALERT', 'PASS', 'DROP']},
                         'default_config'    => {'readonly' => 1, 'validator' => {'Infoblox::Grid::ThreatProtection::RuleConfig' => 1}},
                         'ruleset'           => {'readonly' => 1, 'validator' => {'Infoblox::Grid::ThreatProtection::Ruleset' => 1}},
                         'versions'          => 0,
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'ruleset' => 'parent',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                         'parent'            => \&ibap_i2o_generic_object_convert,
                         'default_config'    => \&ibap_i2o_generic_object_convert,
                         'category'          => \&ibap_i2o_object_category_name,
                        );

    %_object_to_ibap = (
                         'sid'               => \&ibap_o2i_ignore,
                         'name'              => \&ibap_o2i_ignore,
                         'description'       => \&ibap_o2i_ignore,
                         'category'          => \&ibap_o2i_ignore,
                         'allowed_actions'   => \&ibap_o2i_ignore,
                         'default_config'    => \&ibap_o2i_generic_struct_convert,
                         'versions'          => \&ibap_o2i_ignore,
                         'ruleset'           => \&ibap_o2i_ignore,
                       );

    $_return_fields_initialized=0;
    @_return_fields =
      (
         tField('sid'),
         tField('name'),
         tField('description'),
         tField('category', {'sub_fields' => [tField('name')]}),
         tField('allowed_actions'),
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
        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::ThreatProtection::RuleConfig->__new__();
        push @_return_fields,
          tField('default_config', {'sub_fields' => $t->__return_fields__()});

        $t = Infoblox::Grid::ThreatProtection::Ruleset->__new__();
        push @_return_fields,
          tField('parent', {'sub_fields' => $t->__return_fields__()});
    }
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

sub versions
{
    my $self = shift;
    return @_ ? 1 : [];
}

package Infoblox::Grid::ThreatProtection::Statistics;
  
use strict;
  
use Carp;
  
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap %_ibap_to_object %_searchable_fields
                 @_return_fields %_capabilities $_return_fields_initialized
                 %_name_mappings %_reverse_name_mappings %_return_field_overrides);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::RO);

BEGIN {
    $_object_type = 'AtpEventStatistics';
    register_wsdl_type('ib:AtpEventStatistics','Infoblox::Grid::ThreatProtection::Statistics');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                     );

    %_searchable_fields = (
                           'grid_member' => [\&ibap_o2i_member_byhostname, 'member' , 'EXACT'],
                          );

    %_allowed_members = (
                         'grid_member' => {'readonly' => 1, 'validator' => \&ibap_value_o2i_string},
                         'stat_infos'  => {'readonly' => 1, 'array' => 1, 'validator' => {'Infoblox::Grid::ThreatProtection::StatInfo' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'grid_member' => 'member',
                       'stat_infos'  => 'event_stat_infos',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                        'grid_member' => [],
                        'stat_infos'  => [],
                       );

    %_ibap_to_object = (
                         'member' => \&ibap_i2o_member_byhostname,
                         'event_stat_infos' => \&ibap_i2o_generic_object_list_convert,
                        );

    %_object_to_ibap = (
                         'grid_member' => \&ibap_o2i_ignore,
                         'stat_infos'  => \&ibap_o2i_ignore,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('member', {'sub_fields' =>[tField('host_name')]}),
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
        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::ThreatProtection::StatInfo->__new__();
        push @_return_fields,
          tField('event_stat_infos', {'sub_fields' => $t->__return_fields__()});

    }
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


package Infoblox::Grid::ThreatProtection::NATPort;

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

    $_object_type = 'atp_nat_port';
    register_wsdl_type('ib:atp_nat_port', 'Infoblox::Grid::ThreatProtection::NATPort');

    %_allowed_members = (
                         start_port => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_uint},
                         end_port   => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_uint},
                         block_size => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('start_port'),
                       tField('end_port'),
                       tField('block_size'),
    );

    %_object_to_ibap = (
                        start_port => \&ibap_o2i_uint,
                        end_port   => \&ibap_o2i_uint,
                        block_size => \&ibap_o2i_uint,
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

package Infoblox::Grid::ThreatProtection::NATRule;

use strict;
use Carp;

use Infoblox::PAPIOverrides;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( %_allowed_members
             @_return_fields
             $_return_fields_initialized
             $_object_type
             %_ibap_to_object
             %_object_to_ibap
             %_name_mappings
             %_reverse_name_mappings
             @ISA
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'atp_nat_rule';
    register_wsdl_type('ib:atp_nat_rule', 'Infoblox::Grid::ThreatProtection::NATRule');

    %_allowed_members = (
                         'address'       => {simple => 'asis', validator => \&ibap_value_o2i_ipaddr},
                         'cidr'          => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'end_address'   => {simple => 'asis', validator => \&ibap_value_o2i_ipaddr},
                         'nat_ports'     => {validator => {'Infoblox::Grid::ThreatProtection::NATPort' => 1}, array => 1},
                         'network'       => {simple => 'asis', validator => \&ibap_value_o2i_ipaddr},
                         'rule_type'     => {simple => 'asis', enum => ['ADDRESS', 'NETWORK', 'RANGE'], mandatory => 1},
                         'start_address' => {simple => 'asis', validator => \&ibap_value_o2i_ipaddr},

    );

    %_reverse_name_mappings = reverse %_name_mappings;

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('network'),
                       tField('address'),
                       tField('cidr'),
                       tField('end_address'),
                       tField('rule_type'),
                       tField('start_address'),
    );

    %_ibap_to_object = (
                        'nat_ports' => \&ibap_i2o_generic_object_list_convert,
    );

    %_object_to_ibap = (
                        'address'       => \&ibap_o2i_string,
                        'cidr'          => \&ibap_o2i_uint,
                        'end_address'   => \&ibap_o2i_string,
                        'nat_ports'     => \&ibap_o2i_generic_struct_list_convert,
                        'network'       => \&ibap_o2i_string,
                        'rule_type'     => \&ibap_o2i_string,
                        'start_address' => \&ibap_o2i_string,
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

    #
    my %_req_table = (
                      'ADDRESS' => ['address'],
                      'NETWORK' => ['network', 'cidr'],
                      'RANGE'   => ['start_address', 'end_address'],
    );

    my $type = $self->rule_type();
    my $req_values = $_req_table{$type};

    if ( scalar (grep { not defined $self->$_ } @$req_values) > 0) {

        set_error_codes('1103', "'" . (join "', '", @$req_values) . (
            scalar @$req_values > 1 ? "' are" : "' is") . ' required ' .
            "for '$type' rule type");

        return undef;
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

        my $t = Infoblox::Grid::ThreatProtection::NATPort->__new__();
        push @_return_fields,
            tField('nat_ports', {sub_fields => $t->__return_fields__()});
    }
}


package Infoblox::Grid::ThreatProtection::Profile;

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

    $_object_type = 'AtpProfile';
    register_wsdl_type('ib:AtpProfile', 'Infoblox::Grid::ThreatProtection::Profile');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'comment'                                   => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'current_ruleset'                           => {validator => {'Infoblox::Grid::ThreatProtection::Ruleset' => 1}, use => 'override_current_ruleset', use_truefalse => 1},
                         'disable_multiple_dns_tcp_request'          => {simple => 'bool', use => 'override_disable_multiple_dns_tcp_request', use_truefalse => 1, validator => \&ibap_value_o2i_boolean},
                         'events_per_second_per_rule'                => {simple => 'asis', use => 'override_events_per_second_per_rule', use_truefalse => 1, validator => \&ibap_value_o2i_uint},
                         'extattrs'                                  => {special => 'extensible_attributes'},
                         'extensible_attributes'                     => {special => 'extensible_attributes'},
                         'members'                                   => {array => 1, validator => \&ibap_value_o2i_string},
                         'name'                                      => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'override_current_ruleset'                  => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'override_disable_multiple_dns_tcp_request' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'override_events_per_second_per_rule'       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'source'                                    => {writeonly => 1, validator => {'Infoblox::Grid::ThreatProtection::Profile' => 1, 'Infoblox:Member:ThreatProtection' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'comment'               => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'extattrs'              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'name'                  => [\&ibap_o2i_string, 'name', 'REGEX'],
    );

    %_name_mappings = (
                       'extattrs'                                  => 'extensible_attributes',
                       'override_current_ruleset'                  => 'use_current_ruleset',
                       'override_disable_multiple_dns_tcp_request' => 'use_disable_multiple_dns_tcp_request',
                       'override_events_per_second_per_rule'       => 'use_events_per_second_per_rule',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'current_ruleset'       => \&ibap_i2o_generic_object_convert,
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'members'               => \&ibap_i2o_member_name,
    );

    %_object_to_ibap = (
                        'comment'                                   => \&ibap_o2i_string,
                        'current_ruleset'                           => \&ibap_o2i_object_only_by_oid_undef_ok,
                        'disable_multiple_dns_tcp_request'          => \&ibap_o2i_boolean,
                        'events_per_second_per_rule'                => \&ibap_o2i_uint,
                        'extattrs'                                  => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'                     => \&ibap_o2i_ignore,
                        'members'                                   => \&__ibap_o2i_atp_member_name__,
                        'name'                                      => \&ibap_o2i_string,
                        'override_current_ruleset'                  => \&ibap_o2i_boolean,
                        'override_disable_multiple_dns_tcp_request' => \&ibap_o2i_boolean,
                        'override_events_per_second_per_rule'       => \&ibap_o2i_boolean,
                        'source'                                    => \&ibap_o2i_object_only_by_oid,
    );

    @_return_fields = (
                       tField('comment'),
                       tField('disable_multiple_dns_tcp_request'),
                       tField('events_per_second_per_rule'),
                       tField('extensible_attributes'),
                       tField('members', {sub_fields => [tField('host_name')]}),
                       tField('name'),
                       tField('use_current_ruleset'),
                       tField('use_disable_multiple_dns_tcp_request'),
                       tField('use_events_per_second_per_rule'),
                       return_fields_extensible_attributes(),
    );    

    %_return_field_overrides = (
                                'comment'                                   => [],
                                'current_ruleset'                           => ['use_current_ruleset'],
                                'disable_multiple_dns_tcp_request'          => ['use_disable_multiple_dns_tcp_request'],
                                'events_per_second_per_rule'                => ['use_events_per_second_per_rule'],
                                'extattrs'                                  => [],
                                'extensible_attributes'                     => [],
                                'members'                                   => [],
                                'name'                                      => [],
                                'override_current_ruleset'                  => [],
                                'override_disable_multiple_dns_tcp_request' => [],
                                'override_events_per_second_per_rule'       => [],
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

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my ($tmp, %tmp);

        %tmp = (
                'current_ruleset' => 'Infoblox::Grid::ThreatProtection::Ruleset',
        );

        foreach my $key (keys %tmp) {
            $tmp = $tmp{$key}->__new__();
            push @_return_fields, tField($key, {sub_fields => $tmp->__return_fields__()});
        }
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
        'disable_multiple_dns_tcp_request',
        'use_current_ruleset',
        'use_disable_multiple_dns_tcp_request',
        'use_events_per_second_per_rule',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    $$self{'members'} = [];

    my $res = $self->SUPER::__ibap_to_object__(@_);

    $$self{'override_current_ruleset'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_current_ruleset'});
    $$self{'override_disable_multiple_dns_tcp_request'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_disable_multiple_dns_tcp_request'});
    $$self{'override_events_per_second_per_rule'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_events_per_second_per_rule'});

    return $res;
}

sub __ibap_o2i_atp_member_name__ {

    my ($self, $session, $current, $tempref, $op) = @_;
    return ibap_o2i_object_by_name_helper($self, $session, $current,
        $tempref, $op, 'MemberAtp', 'host_name');
}

package Infoblox::Grid::ThreatProtection::Profile::Rule;

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

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE );

BEGIN {

    $_object_type = 'AtpProfileRule';
    register_wsdl_type('ib:AtpProfileRule', 'Infoblox::Grid::ThreatProtection::Profile::Rule');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'config'           => {use => 'override_config', use_truefalse => 1, validator => {'Infoblox::Grid::ThreatProtection::RuleConfig' => 1}},
                         'disable'          => {simple => 'bool', use => 'override_disable', use_truefalse => 1, validator => \&ibap_value_o2i_boolean},
                         'override_config'  => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'override_disable' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'profile'          => {readonly => 1, validator => {'Infoblox::Grid::ThreatProtection::Profile' => 1}},
                         'rule'             => {readonly => 1, validator => {'Infoblox::Grid::ThreatProtection::Rule' => 1}},
                         'sid'              => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'profile' => [\&ibap_o2i_object_only_by_oid, 'parent', 'EXACT'],
                           'rule'    => [\&ibap_o2i_object_only_by_oid, 'rule', 'EXACT'],
                           'sid'     => [\&ibap_o2i_uint, 'sid', 'EXACT'],
    );

    %_name_mappings = (
                       'disable'          => 'disabled',
                       'override_config'  => 'use_config',
                       'override_disable' => 'use_disabled',
                       'profile'          => 'parent',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'config' => \&ibap_i2o_generic_object_convert,
                        'parent' => \&ibap_i2o_generic_object_convert,
                        'rule'   => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                        'config'           => \&ibap_o2i_generic_struct_convert,
                        'disable'          => \&ibap_o2i_boolean,
                        'override_config'  => \&ibap_o2i_boolean,
                        'override_disable' => \&ibap_o2i_boolean,
                        'profile'          => \&ibap_o2i_ignore,
                        'rule'             => \&ibap_o2i_ignore,
                        'sid'              => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('disabled'),
                       tField('sid'),
                       tField('use_config'),
                       tField('use_disabled'),
    );    

    %_return_field_overrides = (
                                'config'           => [],
                                'disable'          => [],
                                'override_config'  => [],
                                'override_disable' => [],
                                'profile'          => [],
                                'rule'             => [],
                                'sid'              => [],
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

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my ($tmp, %tmp);

        %tmp = (
                'config' => 'Infoblox::Grid::ThreatProtection::RuleConfig',
                'parent' => 'Infoblox::Grid::ThreatProtection::Profile',
                'rule'   => 'Infoblox::Grid::ThreatProtection::Rule',
        );

        foreach my $key (keys %tmp) {
            $tmp = $tmp{$key}->__new__();
            push @_return_fields, tField($key, {sub_fields => $tmp->__return_fields__()});
        }
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
        'disabled',
        'use_config',
        'use_disabled',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    my $res = $self->SUPER::__ibap_to_object__(@_);

    $$self{'override_config'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_config'});
    $$self{'override_disable'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_disabled'});

    return $res;
}


1;
