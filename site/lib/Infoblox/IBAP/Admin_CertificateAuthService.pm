# Copyright (c) 2017 Infoblox Inc. All Rights Reserved.
package Infoblox::Grid::Admin::CertificateAuthService;

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
            @_auto_populate_login_enum
            @_ocsp_check_enum
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    $_object_type = 'OcspAuthService';
    register_wsdl_type('ib:OcspAuthService','Infoblox::Grid::Admin::CertificateAuthService');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    @_auto_populate_login_enum = (
        'AD_SUBJECT_ISSUER',
        'SAN_EMAIL',
        'SAN_UPN',
        'SERIAL_NUMBER',
        'S_DN_CN',
        'S_DN_EMAIL',
    );

    @_ocsp_check_enum = (
        'AIA_AND_MANUAL',
        'AIA_ONLY',
        'DISABLED',
        'MANUAL',
    );

    %_allowed_members = (
        'auto_populate_login'     => {simple => 'asis', enum => \@_auto_populate_login_enum},
        'ca_certificates'         => {mandatory => 1, array => 1, validator => {'Infoblox::Grid::CACertificate' => 1}},
        'client_cert_subject'     => {simple => 'asis', validator => \&ibap_value_o2i_string},
        'comment'                 => {simple => 'asis', validator => \&ibap_value_o2i_string},
        'disabled'                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'enable_password_request' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'enable_remote_lookup'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'max_retries'             => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'name'                    => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
        'ocsp_check'              => {simple => 'asis', enum => \@_ocsp_check_enum},
        'ocsp_responders'         => {array => 1, validator => {'Infoblox::OCSP::Responder' => 1}},
        'recovery_interval'       => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'remote_lookup_password'  => {writeonly => 1, validator => \&ibap_value_o2i_string},
        'remote_lookup_service'   => {validator => \&ibap_value_o2i_string},
        'remote_lookup_username'  => {simple => 'asis', validator => \&ibap_value_o2i_string},
        'response_timeout'        => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'trust_model'             => {simple => 'asis', enum => ['DIRECT','DELEGATED']},
        'user_match_type'         => {simple => 'asis', enum => ['AUTO_MATCH', 'DIRECT_MATCH']},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
        'name'                    => [],
        'ocsp_responders'         => [],
        'disabled'                => [],
        'comment'                 => [],
        'trust_model'             => [],
        'recovery_interval'       => [],
        'max_retries'             => [],
        'response_timeout'        => [],
        'auto_populate_login'     => [],
        'ca_certificates'         => [],
        'client_cert_subject'     => [],
        'enable_password_request' => [],
        'enable_remote_lookup'    => [],
        'ocsp_check'              => [],
        'user_match_type'         => [],
        'remote_lookup_service'   => [],
        'remote_lookup_username'  => [],
    );

    %_name_mappings = ();

    %_reverse_name_mappings = reverse %_name_mappings;
      
    @_return_fields = (
       tField('name'),
       tField('disabled'),
       tField('comment'),
       tField('trust_model'),
       tField('recovery_interval'),
       tField('max_retries'),
       tField('response_timeout'),
       tField('auto_populate_login'),
       tField('client_cert_subject'),
       tField('enable_password_request'),
       tField('enable_remote_lookup'),
       tField('ocsp_check'),
       tField('user_match_type'),
       tField('remote_lookup_service', {sub_fields => [tField('name')]}),
       tField('remote_lookup_username'),
    );

    %_ibap_to_object = (
        'ca_certificates'       => \&ibap_i2o_generic_object_list_convert,
        'ocsp_responders'       => \&ibap_i2o_generic_object_list_convert,
        'remote_lookup_service' => \&ibap_i2o_object_name,
    ); 

    %_object_to_ibap = (
        'auto_populate_login'     => \&ibap_o2i_string,
        'ca_certificates'         => \&ibap_o2i_object_only_by_oid,
        'client_cert_subject'     => \&ibap_o2i_string,
        'comment'                 => \&ibap_o2i_string,
        'disabled'                => \&ibap_o2i_boolean,
        'enable_password_request' => \&ibap_o2i_boolean,
        'enable_remote_lookup'    => \&ibap_o2i_boolean,
        'login_if_resp_unavail'   => \&ibap_o2i_ignore,
        'max_retries'             => \&ibap_o2i_uint,
        'name'                    => \&ibap_o2i_string,
        'ocsp_check'              => \&ibap_o2i_string,
        'ocsp_responders'         => \&ibap_o2i_generic_struct_list_convert,
        'recovery_interval'       => \&ibap_o2i_uint,
        'remote_lookup_password'  => \&ibap_o2i_string_skip_undef,
        'remote_lookup_service'   => \&__o2i_ad_auth_service__,
        'remote_lookup_username'  => \&ibap_o2i_string,
        'response_timeout'        => \&ibap_o2i_uint,
        'ssh_mode'                => \&ibap_o2i_ignore,
        'trust_model'             => \&ibap_o2i_string,
        'user_match_type'         => \&ibap_o2i_string,
    );

    %_searchable_fields = (
        'auto_populate_login'    => [\&ibap_o2i_string, 'auto_populate_login', 'EXACT'],
        'client_cert_subject'    => [\&ibap_o2i_string, 'client_cert_subject', 'REGEX'],
        'disabled'               => [\&ibap_o2i_boolean, 'disabled', 'EXACT'],
        'name'                   => [\&ibap_o2i_string, 'name', 'REGEX'],
        'remote_lookup_username' => [\&ibap_o2i_string, 'remote_lookup_username', 'REGEX'],
        'user_match_type'        => [\&ibap_o2i_string, 'user_match_type', 'EXACT'],
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

    if (
        not defined($$self{ocsp_responders}) and
        ($$self{ocsp_check} ne 'DISABLED' and $$self{ocsp_check} ne 'AIA_ONLY')
    ) {
        set_error_codes(1002, "'ocsp_responders' is required unless 'ocsp_check' " .
            "is set to 'DISABLED' or 'AIA_ONLY'.");
        return undef;
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
            ocsp_responders => 'Infoblox::OCSP::Responder',
            ca_certificates => 'Infoblox::Grid::CACertificate',
        );

        foreach (keys %tmp) {
            $tmp = $tmp{$_}->__new__();
            push @_return_fields,
                tField($_, {sub_fields => $tmp->__return_fields__()});
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

    my $self = shift;
    my ($ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
        'disabled',
        'enable_password_request',
        'enable_remote_lookup',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    $self->{ca_certificates} = [];

    return $self->SUPER::__ibap_to_object__(@_);
}

sub __o2i_ad_auth_service__ {

    my ($self, $session, $current, $tempref) = @_;

    return (1, 0, undef) unless $$tempref{$current};

    return (1, 0, ibap_readfield_simple_string('AdAuthService',
        'name', $$tempref{$current}, 'remote_lookup_service'));
}


package Infoblox::OCSP::AuthService;

use Infoblox::Util;

sub new {

    set_error_codes(1113, "Infoblox::OCSP::AuthService is obsoleted, " .
        "please use Infoblox::Grid::Admin::CertificateAuthService instead.");

    return undef;
}


package Infoblox::Grid::CACertificate;

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
            %_ibap_to_object
            %_name_mappings
            %_reverse_name_mappings
            %_object_to_ibap
            @_return_fields
            %_capabilities
            %_searchable_fields
            %_return_field_overrides
            $_return_fields_initialized
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_MODIFY );

BEGIN {

    $_object_type = 'CACertificate';
    register_wsdl_type('ib:CACertificate','Infoblox::Grid::CACertificate');

    %_capabilities = (
        'depth'                => 0,
        'implicit_defaults'    => 1,
        'single_serialization' => 1,
    );

    %_allowed_members = (
        issuer             => {simple => 'asis', readonly => 1},
        serial             => {simple => 'asis', readonly => 1},
        distinguished_name => {simple => 'asis', readonly => 1},
        used_by            => {simple => 'asis', readonly => 1},
    );
        
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
        'issuer'              => [],
        'serial'              => [],
        'distinguished_name'  => [],
        'used_by'             => [],
    );

    %_name_mappings = (
        'distinguished_name' => 'subject',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
       tField('issuer'),
       tField('serial'),
       tField('subject'),
       tField('used_by'),
    );

    %_ibap_to_object = ();

    %_object_to_ibap = (
        'issuer'              => \&ibap_o2i_ignore,
        'serial'              => \&ibap_o2i_ignore,
        'distinguished_name'  => \&ibap_o2i_ignore,
        'used_by'             => \&ibap_o2i_ignore,
    );

    %_searchable_fields = (
        'serial'             => [\&ibap_o2i_string, 'serial', 'EXACT'],
        'issuer'             => [\&ibap_o2i_string, 'issuer', 'EXACT'],
        'distinguished_name' => [\&ibap_o2i_string, 'subject', 'EXACT'],
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


package Infoblox::OCSP::Responder;

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
            %_ibap_to_object
            %_name_mappings
            %_reverse_name_mappings
            %_object_to_ibap
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'ocsp_responder';
    register_wsdl_type('ib:ocsp_responder','Infoblox::OCSP::Responder');

    %_allowed_members = (
        'address'     => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
        'certificate' => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
        'port'        => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        'comment'     => {simple => 'asis', validator => \&ibap_value_o2i_string},
        'disabled'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
        'address'     => 'fqdn_or_ip',
        'certificate' => 'certificate_data_ref',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
        tField('certificate'),
        tField('comment'),
        tField('disabled'),
        tField('fqdn_or_ip'),
        tField('port'),
    );

    %_ibap_to_object = (); 

    %_object_to_ibap = (
        'address'     => \&ibap_o2i_string,
        'certificate' => \&ibap_o2i_cert_data_ref,
        'comment'     => \&ibap_o2i_string,
        'disabled'    => \&ibap_o2i_boolean,
        'port'        => \&ibap_o2i_uint,
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

sub __ibap_to_object__ {

    my $self = shift;
    my ($ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    if (defined $$ibap_object_ref{'certificate'}) {
        $self->{'__certificate_ref'} = $$ibap_object_ref{'certificate'}{'id'};
        delete $$ibap_object_ref{'certificate'};
    }

    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};

    $self->SUPER::__ibap_to_object__(@_);

    return;
}

sub __object_to_ibap__ {

    my $self = shift;
    my ($server, $session, $skipref) = @_;

    my $write_fields_ref = $self->SUPER::__object_to_ibap__(@_);

    if ($self->{'__certificate_ref'} and !$self->{'certificate'}) {
        unshift @{$write_fields_ref}, {
            'field' => 'certificate',
            'value' => tObjId($self->{'__certificate_ref'}),
        };
    }

    return $write_fields_ref;
}


1;
