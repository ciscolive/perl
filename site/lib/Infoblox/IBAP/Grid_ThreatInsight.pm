# Copyright (c) 2017 Infoblox Inc. All Rights Reserved.
package Infoblox::Grid::ThreatInsight::CloudClient;

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

    $_object_type = 'ThreatInsightCloudClient';
    register_wsdl_type('ib:ThreatInsightCloudClient', 'Infoblox::Grid::ThreatInsight::CloudClient');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'blacklist_rpz_list' => {array => 1, validator => {'Infoblox::DNS::Zone' => 1}, },
                         'enable'             => {simple => 'bool', validator => \&ibap_value_o2i_boolean, },
                         'interval'           => {simple => 'asis', validator => \&ibap_value_o2i_uint, },
                         'token'              => {simple => 'asis', writeonly => 1, validator => \&ibap_value_o2i_string, },
                         'force_refresh'      => {writeonly => 1, validator => \&ibap_value_o2i_boolean, },
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
    );

    %_name_mappings = (
                       'enable' => 'enabled',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'blacklist_rpz_list' => \&ibap_i2o_generic_object_list_convert,
    );

    %_object_to_ibap = (
                        'blacklist_rpz_list' => \&ibap_o2i_object_only_by_oid,
                        'enable'             => \&ibap_o2i_boolean,
                        'force_refresh'      => \&ibap_o2i_boolean,
                        'interval'           => \&ibap_o2i_uint,
                        'token'              => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('enabled'),
                       tField('interval'),
    );    

    %_return_field_overrides = (
                                'blacklist_rpz_list' => [],
                                'enable'             => [],
                                'interval'           => [],
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
                'blacklist_rpz_list' => 'Infoblox::DNS::Zone',
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

    $self->{'__internal_session_cache_ref__'} = $session;

    foreach (
        'enabled',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    $$self{'blacklist_rpz_list'} = [];

    return $self->SUPER::__ibap_to_object__(@_);
}

sub test_threat_insight_cloud_client_connectivity {

    my ($self, %args) = @_;
    my ($fname, $fargs) = ('TestConnectivityThreatInsightCloudClient', {});

    #
    #
    #

    unless ($self->{'__internal_session_cache_ref__'}) {

        set_error_codes('1012', 'In order to test Threat Insight Cloud Client connectivity' .
            ' the object must have been retrieved from the server first');

        return 0;
    }

    my $session = $self->{'__internal_session_cache_ref__'};

    my $ref_allowed_arguments = {
        'token' => {'validator' => \&ibap_value_o2i_string},
    };

    return 0 unless $session->__validate_arguments_from_arg_list__($ref_allowed_arguments, \%args);

    #
    #
    #

    if ($args{'token'}) {
        $$fargs{'token'} = ibap_value_o2i_string($args{'token'});
        return 0 unless defined $$fargs{'token'};
    }

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


sub request_threat_insight_cloud_client_token {

    my ($self, %args) = @_;
    my ($fname, $fargs) = ('RequestThreatInsightCloudClientToken', {});

    #
    #
    #

    unless ($self->{'__internal_session_cache_ref__'}) {

        set_error_codes('1012', 'In order to request Threat Insight Cloud Client token' .
            ' the object must have been retrieved from the server first');

        return 0;
    }

    my $session = $self->{'__internal_session_cache_ref__'};

    my $ref_allowed_arguments = {
        'email'    => {mandatory => 1, validator => \&ibap_value_o2i_string},
        'password' => {mandatory => 1, validator => \&ibap_value_o2i_string},
    };

    return 0 unless $session->__validate_arguments_from_arg_list__($ref_allowed_arguments, \%args);

    #
    #
    #

    for ('email', 'password') {
        $$fargs{$_} = ibap_value_o2i_string($args{$_});
        return 0 unless defined $$fargs{$_};
    }

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

    return $$result{token};

    #
    #
    #
}


1;
