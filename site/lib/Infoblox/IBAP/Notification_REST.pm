# Copyright (c) 2017 Infoblox Inc.

package Infoblox::Notification::REST::Endpoint;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;


use vars qw(
            $_object_type
            %_allowed_members
            %_capabilities
            %_name_mappings
            %_reverse_name_mappings
            %_object_to_ibap
            %_ibap_to_object
            %_return_field_overrides
            %_searchable_fields
            $_return_fields_initialized
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    $_object_type = 'EndpointRestApi';
    register_wsdl_type('ib:EndpointRestApi', 'Infoblox::Notification::REST::Endpoint');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'client_certificate'            => {writeonly => 1, validator => \&ibap_value_o2i_string},
                         'client_certificate_subject'    => {simple => 'asis', readonly => 1},
                         'client_certificate_valid_from' => {readonly => 1},
                         'client_certificate_valid_to'   => {readonly => 1},
                         'comment'                       => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'disable'                       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'extattrs'                      => {special => 'extensible_attributes'},
                         'extensible_attributes'         => {special => 'extensible_attributes'},
                         'name'                          => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'outbound_member_type'          => {mandatory => 1, simple => 'asis', enum => ['MEMBER', 'GM']},
                         'outbound_members'              => {array => 1, validator => \&ibap_value_o2i_string},
                         'uri'                           => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'vendor_identifier'             => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'username'                      => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'password'                      => {writeonly => 1, validator => \&ibap_value_o2i_string},
                         'template_instance'             => {validator => {'Infoblox::Notification::REST::TemplateInstance' => 1}},
                         'log_level'                     => {simple => 'asis', enum => ['DEBUG', 'INFO', 'WARNING', 'ERROR']},
                         'timeout'                       => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'server_cert_validation'        => {simple => 'asis', enum => ['CA_CERT', 'CA_CERT_NO_HOSTNAME', 'NO_VALIDATION']},
                         'wapi_user_name'                => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'wapi_user_password'            => {writeonly => 1, validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'comment'               => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'extattrs'              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'name'                  => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'uri'                   => [\&ibap_o2i_string, 'uri', 'REGEX'],
                           'vendor_identifier'     => [\&ibap_o2i_string, 'vendor_identifier', 'REGEX'],
                           'outbound_member_type'  => [\&ibap_o2i_string, 'outbound_member_type', 'EXACT'],
    );

    %_name_mappings = (
                       'client_certificate' => 'client_certificate_data_ref',
                       'disable'            => 'disabled',
                       'extattrs'           => 'extensible_attributes',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'client_certificate_valid_from' => \&ibap_i2o_datetime_to_unix_timestamp,
                        'client_certificate_valid_to'   => \&ibap_i2o_datetime_to_unix_timestamp,
                        'extensible_attributes'         => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'template_instance'             => \&ibap_i2o_generic_object_convert,
                        'outbound_members'              => \&ibap_i2o_member_name,
    );

    %_object_to_ibap = (
                        'client_certificate'            => \&ibap_o2i_cert_data_ref,
                        'client_certificate_subject'    => \&ibap_o2i_ignore,
                        'client_certificate_valid_from' => \&ibap_o2i_ignore,
                        'client_certificate_valid_to'   => \&ibap_o2i_ignore,
                        'comment'                       => \&ibap_o2i_string,
                        'disable'                       => \&ibap_o2i_boolean,
                        'extattrs'                      => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'         => \&ibap_o2i_ignore,
                        'name'                          => \&ibap_o2i_string,
                        'outbound_member_type'          => \&ibap_o2i_string,
                        'outbound_members'              => \&ibap_o2i_member_name,
                        'uri'                           => \&ibap_o2i_string,
                        'vendor_identifier'             => \&ibap_o2i_string,
                        'username'                      => \&ibap_o2i_string,
                        'password'                      => \&ibap_o2i_string_skip_undef,
                        'template_instance'             => \&Infoblox::Notification::REST::TemplateInstance::__o2i_undef_to_empty__,
                        'log_level'                     => \&ibap_o2i_string,
                        'timeout'                       => \&ibap_o2i_uint,
                        'server_cert_validation'        => \&ibap_o2i_string,
                        'wapi_user_name'                => \&ibap_o2i_string_undef_to_empty,
                        'wapi_user_password'            => \&ibap_o2i_string_undef_to_empty,
    );

    @_return_fields = (
                       tField('client_certificate_subject'),
                       tField('client_certificate_valid_from'),
                       tField('client_certificate_valid_to'),
                       tField('comment'),
                       tField('disabled'),
                       tField('name'),
                       tField('outbound_member_type'),
                       tField('outbound_members', {sub_fields => [tField('host_name')]}),
                       tField('uri'),
                       tField('vendor_identifier'),
                       tField('username'),
                       tField('log_level'),
                       tField('timeout'),
                       tField('server_cert_validation'),
                       tField('wapi_user_name'),
                       return_fields_extensible_attributes(),
    );

    %_return_field_overrides = (
                                'client_certificate_subject'    => [],
                                'client_certificate_valid_from' => [],
                                'client_certificate_valid_to'   => [],
                                'comment'                       => [],
                                'disable'                       => [],
                                'extattrs'                      => [],
                                'extensible_attributes'         => [],
                                'name'                          => [],
                                'outbound_members'              => [],
                                'outbound_member_type'          => [],
                                'uri'                           => [],
                                'vendor_identifier'             => [],
                                'username'                      => [],
                                'template_instance'             => [],
                                'log_level'                     => [],
                                'timeout'                       => [],
                                'server_cert_validation'        => [],
                                'wapi_user_name'                => [],
    );
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

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my ($tmp, %tmp);

        %tmp = (
                'template_instance' => 'Infoblox::Notification::REST::TemplateInstance',
        );

        foreach (keys %tmp) {

            $tmp = $tmp{$_}->__new__();
            push @_return_fields, tField($_, {sub_fields => $tmp->__return_fields__()});
        }
    }
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};

    $$self{outbound_members} = [];

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Notification::REST::Template;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;


use vars qw(
            $_object_type
            %_allowed_members
            %_capabilities
            %_name_mappings
            %_object_to_ibap
            %_ibap_to_object
            %_return_field_overrides
            %_reverse_name_mappings
            %_reverse_template_type_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    $_object_type = 'TemplateRestApi';
    register_wsdl_type('ib:TemplateRestApi', 'Infoblox::Notification::REST::Template');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'name'              => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'vendor_identifier' => {simple => 'asis', readonly => 1},
                         'event_type'        => {array => 1, simple => 'asis', readonly => 1},
                         'template_type'     => {readonly => 1, enum => ['REST_EVENT', 'REST_ENDPOINT']},
                         'action_name'       => {simple => 'asis', readonly => 1},
                         'added_on'          => {readonly => 1},
                         'content'           => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'comment'           => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'outbound_type'     => {simple => 'asis', enum => ['REST', 'DXL']},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = ();

    %_reverse_name_mappings = reverse %_name_mappings;

    %_reverse_template_type_mappings = (
        'ACTION'             => 'REST_EVENT',
        'SESSION_MANAGEMENT' => 'REST_ENDPOINT',
    );

    %_searchable_fields = (
                           'name'              => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'comment'           => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'vendor_identifier' => [\&ibap_o2i_string, 'vendor_identifier', 'REGEX'],
                           'action_name'       => [\&ibap_o2i_string, 'action_name', 'REGEX'],
                           'outbound_type'     => [\&ibap_o2i_string, 'outbound_type', 'EXACT'],
    );

    %_ibap_to_object = (
                        'added_on'    => \&ibap_i2o_datetime_to_unix_timestamp,
                        'template_type' => \&__i2o_template_type__,
    );

    %_object_to_ibap = (
                        'name'              => \&ibap_o2i_string,
                        'vendor_identifier' => \&ibap_o2i_ignore,
                        'event_type'        => \&ibap_o2i_ignore,
                        'template_type'     => \&ibap_o2i_ignore,
                        'added_on'          => \&ibap_o2i_ignore,
                        'content'           => \&ibap_o2i_string,
                        'comment'           => \&ibap_o2i_string,
                        'action_name'       => \&ibap_o2i_ignore,
                        'outbound_type'     => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('name'),
                       tField('vendor_identifier'),
                       tField('event_type'),
                       tField('template_type'),
                       tField('added_on'),
                       tField('content'),
                       tField('comment'),
                       tField('action_name'),
                       tField('outbound_type'),
    );

    %_return_field_overrides = (
                                'name'              => [],
                                'vendor_identifier' => [],
                                'event_type'        => [],
                                'template_type'     => [],
                                'added_on'          => [],
                                'content'           => [],
                                'comment'           => [],
                                'action_name'       => [],
                                'outbound_type'     => [],
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

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __i2o_template_type__ {

    my ($self, $session, $current, $tempref) = @_;
    return $_reverse_template_type_mappings{$$tempref{$current}};
}


package Infoblox::Notification::REST::TemplateParameter;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            %_name_mappings
            %_reverse_name_mappings
            @ISA
            @_return_fields
            $_object_type
            %_allowed_members
            %_object_to_ibap
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'template_restapi_parameter';
    register_wsdl_type('ib:template_restapi_parameter', 'Infoblox::Notification::REST::TemplateParameter');

    %_allowed_members = (
                         'name'          => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'syntax'        => {mandatory => 1, simple => 'asis', enum => ['STR', 'BOOL', 'INT']},
                         'default_value' => {simple => 'asis', readonly => 1},
                         'value'         => {simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'name'          => \&ibap_o2i_string,
                        'value'         => \&ibap_o2i_string,
                        'syntax'        => \&ibap_o2i_string,
                        'default_value' => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('name'),
                       tField('value'),
                       tField('syntax'),
                       tField('default_value'),
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


package Infoblox::Notification::REST::TemplateInstance;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            %_name_mappings
            %_reverse_name_mappings
            %_capabilities
            @ISA
            %_ibap_to_object
            @_return_fields
            $_object_type
            %_allowed_members
            %_object_to_ibap
            %_return_field_overrides
            $_return_fields_initialized
            %_searchable_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'template_restapi_instance';
    register_wsdl_type('ib:template_restapi_instance', 'Infoblox::Notification::REST::TemplateInstance');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'template'   => {mandatory => 1, validator => \&ibap_value_o2i_string},
                         'parameters' => {array => 1, validator => {'Infoblox::Notification::REST::TemplateParameter' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);


    %_ibap_to_object = (
                        'template'   => \&ibap_i2o_object_name,
                        'parameters' => \&ibap_i2o_generic_object_list_convert,
    );

    %_object_to_ibap = (
                        'template'   => \&__o2i_template__,
                        'parameters' => \&ibap_o2i_generic_struct_list_convert,
    );

    @_return_fields = (
                       tField('template', {sub_fields => [tField('name')]}),
    );
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

        my $tmp = Infoblox::Notification::REST::TemplateParameter->__new__();
        push @_return_fields, tField('parameters', {sub_fields => $tmp->__return_fields__()});
    }
}

sub __o2i_template__ {

    my ($self, $session, $current, $tempref) = @_;

    if ($$tempref{$current}) {
        return (1, 0, ibap_readfield_simple_string('TemplateRestApi', 'name', $$tempref{$current}, 'template'));
    } else {
        set_error_codes('1012', 'template is required', $session);
        return (0);
    }
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->{parameters} = [];

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __o2i_undef_to_empty__ {

    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        return ibap_o2i_generic_struct_convert(@_);
    } else {
        return (1, 0, tIBType('template_restapi_instance', {}));
    }
}


1;
