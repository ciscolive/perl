# Copyright (c) 2017 Infoblox Inc. All Rights Reserved.
package Infoblox::DXL::Endpoint::Broker;

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
            %_name_mappings
            %_object_to_ibap
            %_reverse_name_mappings
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'endpoint_dxl_broker';
    register_wsdl_type('ib:endpoint_dxl_broker', 'Infoblox::DXL::Endpoint::Broker');


    %_allowed_members = (
                         'address'   => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'host_name' => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'port'      => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'unique_id' => {simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
    );

    %_object_to_ibap = (
                        'address'   => \&ibap_o2i_string,
                        'host_name' => \&ibap_o2i_string,
                        'port'      => \&ibap_o2i_uint,
                        'unique_id' => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('address'),
                       tField('host_name'),
                       tField('port'),
                       tField('unique_id'),
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


package Infoblox::DXL::Endpoint;

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

    $_object_type = 'EndpointDxl';
    register_wsdl_type('ib:EndpointDxl', 'Infoblox::DXL::Endpoint');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'client_certificate'            => {mandatory => 1, writeonly => 1, validator => \&ibap_value_o2i_string},
                         'client_certificate_subject'    => {simple => 'asis', readonly => 1},
                         'client_certificate_valid_from' => {readonly => 1},
                         'client_certificate_valid_to'   => {readonly => 1},
                         'brokers'                       => {mandatory => 1, array => 1, validator => {'Infoblox::DXL::Endpoint::Broker' => 1}},
                         'comment'                       => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'disable'                       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'extattrs'                      => {special => 'extensible_attributes'},
                         'extensible_attributes'         => {special => 'extensible_attributes'},
                         'log_level'                     => {simple => 'asis', enum => ['DEBUG', 'ERROR', 'INFO', 'WARNING']},
                         'name'                          => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'outbound_member_type'          => {mandatory => 1, simple => 'asis', enum => ['GM', 'MEMBER']},
                         'outbound_members'              => {array => 1, validator => \&ibap_value_o2i_string},
                         'template_instance'             => {validator => {'Infoblox::Notification::REST::TemplateInstance' => 1}},
                         'vendor_identifier'             => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'wapi_user_name'                => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'wapi_user_password'            => {simple => 'asis', writeonly => 1, validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'comment'               => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'extattrs'              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'name'                  => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'outbound_member_type'  => [\&ibap_o2i_string, 'outbound_member_type', 'EXACT'],
                           'vendor_identifier'     => [\&ibap_o2i_string, 'vendor_identifier', 'REGEX'],
    );

    %_name_mappings = (
                       'client_certificate' => 'client_certificate_data_ref',
                       'disable'            => 'disabled',
                       'extattrs'           => 'extensible_attributes',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'brokers'                       => \&ibap_i2o_generic_object_list_convert,
                        'client_certificate_valid_from' => \&ibap_i2o_datetime_to_unix_timestamp,
                        'client_certificate_valid_to'   => \&ibap_i2o_datetime_to_unix_timestamp,
                        'extensible_attributes'         => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'outbound_members'              => \&ibap_i2o_member_name,
                        'template_instance'             => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                        'brokers'                       => \&ibap_o2i_generic_struct_list_convert,
                        'client_certificate'            => \&ibap_o2i_cert_data_ref,
                        'client_certificate_subject'    => \&ibap_o2i_ignore,
                        'client_certificate_valid_from' => \&ibap_o2i_ignore,
                        'client_certificate_valid_to'   => \&ibap_o2i_ignore,
                        'comment'                       => \&ibap_o2i_string,
                        'disable'                       => \&ibap_o2i_boolean,
                        'extattrs'                      => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'         => \&ibap_o2i_ignore,
                        'log_level'                     => \&ibap_o2i_string,
                        'name'                          => \&ibap_o2i_string,
                        'outbound_member_type'          => \&ibap_o2i_string,
                        'outbound_members'              => \&ibap_o2i_member_name,
                        'template_instance'             => \&ibap_o2i_generic_struct_convert,
                        'vendor_identifier'             => \&ibap_o2i_string,
                        'wapi_user_name'                => \&ibap_o2i_string,
                        'wapi_user_password'            => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('client_certificate_subject'),
                       tField('client_certificate_valid_from'),
                       tField('client_certificate_valid_to'),
                       tField('comment'),
                       tField('disabled'),
                       tField('log_level'),
                       tField('name'),
                       tField('outbound_member_type'),
                       tField('outbound_members', {
                           'sub_fields' => [
                               tField('host_name'),
                           ],
                       }),
                       tField('vendor_identifier'),
                       tField('wapi_user_name'),
                       return_fields_extensible_attributes(),
    );    

    %_return_field_overrides = (
                                'brokers'                       => [],
                                'client_certificate_subject'    => [],
                                'client_certificate_valid_from' => [],
                                'client_certificate_valid_to'   => [],
                                'comment'                       => [],
                                'disabled'                      => [],
                                'extattrs'                      => [],
                                'extensible_attributes'         => [],
                                'log_level'                     => [],
                                'name'                          => [],
                                'outbound_member_type'          => [],
                                'outbound_members'              => [],
                                'template_instance'             => [],
                                'vendor_identifier'             => [],
                                'wapi_user_name'                => [],
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
                'brokers'           => 'Infoblox::DXL::Endpoint::Broker',
                'template_instance' => 'Infoblox::Notification::REST::TemplateInstance',
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
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    $$self{'brokers'} = [];
    $$self{'outbound_members'} = [];

    return $self->SUPER::__ibap_to_object__(@_);
}


1;
