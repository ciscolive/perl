package Infoblox::Notification::Rule;

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
            @_event_type_enum
            @_event_dedup_field
            @_notification_action_enum
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    $_object_type = 'NotificationRule';
    register_wsdl_type('ib:NotificationRule', 'Infoblox::Notification::Rule');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    @_event_type_enum = (
        'DNS_RPZ',
        'DHCP_LEASES',
        'SECURITY_ADP',
        'IPAM',
        'ANALYTICS_DNS_TUNNEL',
        'DB_CHANGE_DHCP_FIXED_ADDRESS_IPV4',
        'DB_CHANGE_DHCP_FIXED_ADDRESS_IPV6',
        'DB_CHANGE_DHCP_NETWORK_IPV4',
        'DB_CHANGE_DHCP_NETWORK_IPV6',
        'DB_CHANGE_DHCP_RANGE_IPV4',
        'DB_CHANGE_DHCP_RANGE_IPV6',
        'DB_CHANGE_DNS_HOST_ADDRESS_IPV4',
        'DB_CHANGE_DNS_HOST_ADDRESS_IPV6',
    );

    @_notification_action_enum = (
        'CISCOISE_QUARANTINE',
        'CISCOISE_PUBLISH',
        'RESTAPI_TEMPLATE_INSTANCE',
    );

    @_event_dedup_field = (
        'SOURCE_IP',
        'QUERY_NAME',
        'RPZ_POLICY',
        'RPZ_TYPE',
        'QUERY_TYPE',
        'NETWORK',
        'NETWORK_VIEW',
    );

    %_allowed_members = (
                         'all_members'                         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'comment'                             => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'disable'                             => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'event_type'                          => {mandatory => 1, simple => 'asis', enum => \@_event_type_enum},
                         'expression_list'                     => {mandatory => 1, array => 1, validator => {'Infoblox::Notification::RuleExpressionOp' => 1}},
                         'name'                                => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'notification_action'                 => {mandatory => 1, simple => 'asis', enum => \@_notification_action_enum},
                         'notification_target'                 => {mandatory => 1, validator => {'Infoblox::CiscoISE::Endpoint' => 1, 'Infoblox::Notification::REST::Endpoint' => 1, 'Infoblox::DXL::Endpoint' => 1}},
                         'override_publish_settings'           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'publish_settings'                    => {use => 'override_publish_settings', use_truefalse => 1, validator => {'Infoblox::CiscoISE::PublishSetting' => 1}},
                         'selected_members'                    => {array => 1, validator => \&ibap_value_o2i_string},
                         'template_instance'                   => {validator => {'Infoblox::Notification::REST::TemplateInstance' => 1}},
                         'enable_event_deduplication'          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'event_deduplication_lookback_period' => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'enable_event_deduplication_log'      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'event_deduplication_fields'          => {array => 1, enum => \@_event_dedup_field},
    );

    %_searchable_fields = (
                           'name'                => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'comment'             => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'event_type'          => [\&ibap_o2i_string, 'event_type', 'EXACT'],
                           'notification_action' => [\&ibap_o2i_string, 'notification_action', 'EXACT'],
                           'notification_target' => [\&ibap_o2i_object_only_by_oid, 'notification_target', 'EXACT'],
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'disable'                             => 'disabled',
                       'override_publish_settings'           => 'use_publish_settings',
                       'enable_event_deduplication'          => 'event_dedup_enabled',
                       'event_deduplication_lookback_period' => 'event_dedup_lookback_period',
                       'enable_event_deduplication_log'      => 'event_dedup_log_enabled',
                       'event_deduplication_fields'          => 'event_dedup_fields',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'expression_list'     => \&ibap_i2o_generic_object_list_convert,
                        'notification_target' => \&ibap_i2o_generic_object_convert,
                        'publish_settings'    => \&ibap_i2o_generic_object_convert,
                        'selected_members'    => \&ibap_i2o_member_name,
                        'template_instance'   => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                        'name'                                => \&ibap_o2i_string,
                        'comment'                             => \&ibap_o2i_string,
                        'disable'                             => \&ibap_o2i_boolean,
                        'event_type'                          => \&ibap_o2i_string,
                        'all_members'                         => \&ibap_o2i_boolean,
                        'selected_members'                    => \&ibap_o2i_member_name,
                        'expression_list'                     => \&ibap_o2i_generic_struct_list_convert,
                        'notification_action'                 => \&ibap_o2i_string,
                        'notification_target'                 => \&ibap_o2i_object_only_by_oid,
                        'publish_settings'                    => \&ibap_o2i_generic_struct_convert,
                        'override_publish_settings'           => \&ibap_o2i_boolean,
                        'template_instance'                   => \&Infoblox::Notification::REST::TemplateInstance::__o2i_undef_to_empty__,
                        'enable_event_deduplication'          => \&ibap_o2i_boolean,
                        'event_deduplication_lookback_period' => \&ibap_o2i_uint,
                        'enable_event_deduplication_log'      => \&ibap_o2i_boolean,
                        'event_deduplication_fields'          => \&ibap_o2i_string_array_undef_to_empty,
    );

    @_return_fields = (
                       tField('name'),
                       tField('comment'),
                       tField('disabled'),
                       tField('event_type'),
                       tField('all_members'),
                       tField('selected_members', {sub_fields => [tField('host_name')]}),
                       tField('notification_action'),
                       tField('use_publish_settings'),
                       tField('event_dedup_enabled'),
                       tField('event_dedup_lookback_period'),
                       tField('event_dedup_log_enabled'),
                       tField('event_dedup_fields'),
    );

    %_return_field_overrides = (
                                'name'                                => [],
                                'comment'                             => [],
                                'disable'                             => [],
                                'event_type'                          => [],
                                'all_members'                         => [],
                                'selected_members'                    => [],
                                'expression_list'                     => [],
                                'notification_action'                 => [],
                                'notification_target'                 => [],
                                'publish_settings'                    => ['use_publish_settings'],
                                'override_publish_settings'           => [],
                                'template_instance'                   => [],
                                'enable_event_deduplication'          => [],
                                'event_deduplication_lookback_period' => [],
                                'enable_event_deduplication_log'      => [],
                                'event_deduplication_file_list'       => [],
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
                'expression_list'     => 'Infoblox::Notification::RuleExpressionOp',
                'notification_target' => ['Infoblox::CiscoISE::Endpoint', 'Infoblox::Notification::REST::Endpoint', 'Infoblox::DXL::Endpoint'],
                'publish_settings'    => 'Infoblox::CiscoISE::PublishSetting',
                'template_instance'   => 'Infoblox::Notification::REST::TemplateInstance',
        );

        foreach my $key (keys %tmp) {

            if (ref $tmp{$key} eq 'ARRAY') {

                my @_objtype_return_fields;
                foreach my $objtype (@{$tmp{$key}}) {

                    $tmp = $objtype->__new__();

                    push @_objtype_return_fields, tFieldObjType(
                        $tmp->__ibap_object_type__(), {
                            sub_fields => $tmp->__return_fields__(),
                        },
                    );

                }

                push @_return_fields, tField($key, {
                    'default_no_access_ok' => 1,
                    'sub_fields'           => \@_objtype_return_fields,
                });

                next;
            }

            $tmp = $tmp{$key}->__new__();
            push @_return_fields, tField($key, {sub_fields => $tmp->__return_fields__()});
        }
    }
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
             'disabled',
             'all_members',
             'use_publish_settings',
             'event_dedup_enabled',
             'event_dedup_log_enabled',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    foreach (
             'selected_members',
             'expression_list',
             'event_deduplication_fields',
    ) {
        $self->{$_} = [];
    }

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    $self->{'override_publish_settings'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_publish_settings'});

    return $res;
}


package Infoblox::Notification::RuleExpressionOp;

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
            %_ibap_to_object
            @_return_fields
            @_allowed_op1
            @_allowed_op
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'rule_expression_op';
    register_wsdl_type('ib:rule_expression_op', 'Infoblox::Notification::RuleExpressionOp');

    @_allowed_op1 = (
        'ADDRESS_TYPE',
        'DHCP_FINGERPRINT',
        'DHCP_LEASE_STATE',
        'DHCP_IP_ADDRESS',
        'DISABLE',
        'DNS_RPZ_ACTION_POLICY',
        'DNS_RPZ_NAME',
        'DNS_RPZ_RULE_NAME',
        'DNS_RPZ_TYPE',
        'DUID',
        'HOST',
        'IPV4_ADDRESS',
        'IPV6_ADDRESS',
        'IPV6_PREFIX',
        'IPV6_PREFIX_BITS',
        'MAC',
        'NAME',
        'NETWORK',
        'NETWORK_VIEW',
        'SECURITY_ADP_RULE_MESSAGE',
        'SECURITY_ADP_RULE_SEVERITY',
        'SECURITY_ADP_SID',
        'SERVER_ASSOC_TYPE_IPV4',
        'SERVER_ASSOC_TYPE_IPV6',
        'SOURCE_IP',
    );

    @_allowed_op = (
        'AND',
        'OR',
        'ENDLIST',
        'EQ',
        'NOT_EQ',
        'REGEX',
        'MATCH_CIDR',
        'CONTAINED_IN',
        'MATCH_RANGE',
        'LE',
        'GE',
    );

    %_allowed_members = (
                         'op'       => {mandatory => 1, simple => 'asis', enum => \@_allowed_op},
                         'op1'      => {simple => 'asis', enum => \@_allowed_op1},
                         'op1_type' => {simple => 'asis', enum => ['FIELD', 'LIST', 'STRING']},
                         'op2'      => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'op2_type' => {simple => 'asis', enum => ['STRING']},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = ();

    %_object_to_ibap = (
                        'op'       => \&ibap_o2i_string_skip_undef,
                        'op1'      => \&ibap_o2i_string_skip_undef,
                        'op1_type' => \&ibap_o2i_string_skip_undef,
                        'op2'      => \&ibap_o2i_string_skip_undef,
                        'op2_type' => \&ibap_o2i_string_skip_undef,
    );

    @_return_fields = (
                       tField('op'),
                       tField('op1'),
                       tField('op1_type'),
                       tField('op2'),
                       tField('op2_type'),
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


1;
