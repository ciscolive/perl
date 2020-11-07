package Infoblox::CiscoISE::Endpoint;

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

    $_object_type = 'EndPointCiscoISE';
    register_wsdl_type('ib:EndPointCiscoISE', 'Infoblox::CiscoISE::Endpoint');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'address'                              => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'bulk_download_certificate'            => {mandatory => 1, writeonly => 1, validator => \&ibap_value_o2i_string},
                         'bulk_download_certificate_subject'    => {simple => 'asis', readonly => 1},
                         'bulk_download_certificate_valid_from' => {readonly => 1},
                         'bulk_download_certificate_valid_to'   => {readonly => 1},
                         'client_certificate'                   => {mandatory => 1, writeonly => 1, validator => \&ibap_value_o2i_string},
                         'client_certificate_subject'           => {simple => 'asis', readonly => 1},
                         'client_certificate_valid_from'        => {readonly => 1},
                         'client_certificate_valid_to'          => {readonly => 1},
                         'comment'                              => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'connection_status'                    => {simple => 'asis', readonly => 1},
                         'connection_timeout'                   => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'disable'                              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'extattrs'                             => {special => 'extensible_attributes'},
                         'extensible_attributes'                => {special => 'extensible_attributes'},
                         'network_view'                         => {validator => \&ibap_value_o2i_string},
                         'publish_settings'                     => {validator => {'Infoblox::CiscoISE::PublishSetting' => 1}},
                         'resolved_address'                     => {simple => 'asis', readonly => 1},
                         'resolved_secondary_address'           => {simple => 'asis', readonly => 1},
                         'secondary_address'                    => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'subscribe_settings'                   => {mandatory => 1, validator => {'Infoblox::CiscoISE::SubscribeSetting' => 1}},
                         'subscribing_member'                   => {mandatory => 1, validator => \&ibap_value_o2i_string},
                         'type'                                 => {simple => 'asis', enum => ['TYPE_CISCO']},
                         'version'                              => {mandatory => 1, simple => 'asis', enum => ['VERSION_1_3', 'VERSION_1_4', 'VERSION_2_0']},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'address'                    => [\&ibap_o2i_string, 'address', 'REGEX'],
                           'comment'                    => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'extattrs'                   => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes'      => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'network_view'               => [\&ibap_o2i_network_view, 'network_view', 'EXACT'],
                           'resolved_address'           => [\&ibap_o2i_string, 'resolved_ip', 'REGEX'],
                           'resolved_secondary_address' => [\&ibap_o2i_string, 'resolved_ip_secondary', 'REGEX'],
                           'secondary_address'          => [\&ibap_o2i_string, 'address_secondary', 'REGEX'],
                           'subscribing_member'         => [\&ibap_o2i_member_name, 'subscribing_member', 'EXACT'],
                           'type'                       => [\&ibap_o2i_string, 'type', 'EXACT'],
                           'version'                    => [\&ibap_o2i_string, 'ise_version', 'EXACT'],
    );

    %_name_mappings = (
                       'bulk_download_certificate'  => 'bulk_download_certificate_data_ref',
                       'client_certificate'         => 'client_certificate_data_ref',
                       'connection_status'          => 'ciscoise_connection_status',
                       'disable'                    => 'disabled',
                       'extattrs'                   => 'extensible_attributes',
                       'resolved_address'           => 'resolved_ip',
                       'resolved_secondary_address' => 'resolved_ip_secondary',
                       'secondary_address'          => 'address_secondary',
                       'version'                    => 'ise_version',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'bulk_download_certificate_valid_from' => \&ibap_i2o_datetime_to_unix_timestamp,
                        'bulk_download_certificate_valid_to'   => \&ibap_i2o_datetime_to_unix_timestamp,
                        'client_certificate_valid_from'        => \&ibap_i2o_datetime_to_unix_timestamp,
                        'client_certificate_valid_to'          => \&ibap_i2o_datetime_to_unix_timestamp,
                        'extensible_attributes'                => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'network_view'                         => \&ibap_i2o_object_name,
                        'publish_settings'                     => \&ibap_i2o_generic_object_convert,
                        'subscribe_settings'                   => \&ibap_i2o_generic_object_convert,
                        'subscribing_member'                   => \&ibap_i2o_member_name,
    );

    %_object_to_ibap = (
                        'address'                              => \&ibap_o2i_string,
                        'bulk_download_certificate'            => \&ibap_o2i_cert_data_ref,
                        'bulk_download_certificate_subject'    => \&ibap_o2i_ignore,
                        'bulk_download_certificate_valid_from' => \&ibap_o2i_ignore,
                        'bulk_download_certificate_valid_to'   => \&ibap_o2i_ignore,
                        'client_certificate'                   => \&ibap_o2i_cert_data_ref,
                        'client_certificate_subject'           => \&ibap_o2i_ignore,
                        'client_certificate_valid_from'        => \&ibap_o2i_ignore,
                        'client_certificate_valid_to'          => \&ibap_o2i_ignore,
                        'comment'                              => \&ibap_o2i_string,
                        'connection_status'                    => \&ibap_o2i_ignore,
                        'connection_timeout'                   => \&ibap_o2i_uint,
                        'disable'                              => \&ibap_o2i_boolean,
                        'extattrs'                             => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'                => \&ibap_o2i_ignore,
                        'network_view'                         => \&ibap_o2i_network_view,
                        'publish_settings'                     => \&ibap_o2i_generic_struct_convert,
                        'resolved_address'                     => \&ibap_o2i_ignore,
                        'resolved_secondary_address'           => \&ibap_o2i_ignore,
                        'secondary_address'                    => \&ibap_o2i_string,
                        'subscribe_settings'                   => \&ibap_o2i_generic_struct_convert,
                        'subscribing_member'                   => \&ibap_o2i_member_name,
                        'type'                                 => \&ibap_o2i_string,
                        'version'                              => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('address'),
                       tField('address_secondary'),
                       tField('bulk_download_certificate_subject'),
                       tField('bulk_download_certificate_valid_from'),
                       tField('bulk_download_certificate_valid_to'),
                       tField('ciscoise_connection_status'),
                       tField('client_certificate_subject'),
                       tField('client_certificate_valid_from'),
                       tField('client_certificate_valid_to'),
                       tField('comment'),
                       tField('connection_timeout'),
                       tField('disabled'),
                       tField('ise_version'),
                       tField('network_view', {sub_fields => [tField('name')]}),
                       tField('resolved_ip'),
                       tField('resolved_ip_secondary'),
                       tField('subscribing_member', {sub_fields => [tField('host_name')]}),
                       tField('type'),
                       return_fields_extensible_attributes(),
    );

    %_return_field_overrides = (
                                'address'                              => [],
                                'bulk_download_certificate_subject'    => [],
                                'bulk_download_certificate_valid_from' => [],
                                'bulk_download_certificate_valid_to'   => [],
                                'client_certificate_subject'           => [],
                                'client_certificate_valid_from'        => [],
                                'client_certificate_valid_to'          => [],
                                'comment'                              => [],
                                'connection_status'                    => [],
                                'connection_timeout'                   => [],
                                'disable'                              => [],
                                'extattrs'                             => [],
                                'extensible_attributes'                => [],
                                'network_view'                         => [],
                                'publish_settings'                     => [],
                                'resolved_address'                     => [],
                                'resolved_secondary_address'           => [],
                                'secondary_address'                    => [],
                                'subscribe_settings'                   => [],
                                'subscribing_member'                   => [],
                                'type'                                 => [],
                                'version'                              => [],
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
                'subscribe_settings' => 'Infoblox::CiscoISE::SubscribeSetting',
                'publish_settings'   => 'Infoblox::CiscoISE::PublishSetting',
        );

        foreach (keys %tmp) {

            $tmp = $tmp{$_}->__new__();
            push @_return_fields, tField($_, {sub_fields => $tmp->__return_fields__()});
        }
    }
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{disabled} = 0 unless defined $$ibap_object_ref{disabled};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::CiscoISE::SubscribeSetting;

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
            %_object_to_ibap
            @ISA
            @_allowed_attributes
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'ciscoise_subscribe_settings';
    register_wsdl_type('ib:ciscoise_subscribe_settings', 'Infoblox::CiscoISE::SubscribeSetting');

    @_allowed_attributes = (
        'DOMAINNAME',
        'ENDPOINT_PROFILE',
        'SECURITY_GROUP',
        'SESSION_STATE',
        'SSID',
        'USERNAME',
        'VLAN',
    );

    %_allowed_members = (
                         'enabled_attributes'   => {mandatory => 1, array => 1, simple => 'asis', enum => \@_allowed_attributes},
                         'mapped_ea_attributes' => {array => 1, validator => {'Infoblox::CiscoISE::EAAssociation' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);


    %_ibap_to_object = (
                        'mapped_ea_attributes' => \&ibap_i2o_generic_object_list_convert,
    );

    %_object_to_ibap = (
                        'enabled_attributes'   => \&ibap_o2i_string_array_undef_to_empty,
                        'mapped_ea_attributes' => \&ibap_o2i_generic_struct_list_convert,
    );

    @_return_fields = (
                       tField('enabled_attributes'),
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

        my ($tmp, %tmp);

        %tmp = (
                'mapped_ea_attributes' => 'Infoblox::CiscoISE::EAAssociation',
        );

        foreach (keys %tmp) {

            $tmp = $tmp{$_}->__new__();
            push @_return_fields, tField($_, {sub_fields => $tmp->__return_fields__()});
        }
    }
}


package Infoblox::CiscoISE::EAAssociation;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            @ISA
            @_return_fields
            @_allowed_names
            %_name_mappings
            %_reverse_name_mappings
            $_object_type
            %_allowed_members
            %_object_to_ibap
            %_ibap_to_object
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'ciscoise_subscribe_ea_association';
    register_wsdl_type('ib:ciscoise_subscribe_ea_association', 'Infoblox::CiscoISE::EAAssociation');

    @_allowed_names = (
        'ACCOUNT_SESSION_ID',
        'AUDIT_SESSION_ID',
        'EPS_STATUS',
        'IP_ADDRESS',
        'MAC',
        'NAS_IP_ADDRESS',
        'NAS_PORT_ID',
        'POSTURE_STATUS',
        'POSTURE_TIMESTAMP',
    );

    %_allowed_members = (
                         'name'      => {mandatory => 1, simple => 'asis', enum => \@_allowed_names},
                         'mapped_ea' => {mandatory => 1, validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'name' => 'ea_name',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'mapped_ea' => \&ibap_i2o_object_name,
    );

    %_object_to_ibap = (
                        'mapped_ea' => \&__o2i_ead_name__,
                        'name'      => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('ea_name'),
                       tField('mapped_ea', {sub_fields => [tField('name')]}),
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

sub __o2i_ead_name__ {

    my ($self, $session, $current, $tempref, $op) = @_;

    my $ead;
    unless (ref $$tempref{$current}) {

        $ead = Infoblox::Grid::ExtensibleAttributeDef->__new__();
        $ead->{name} = $$tempref{$current};
    } else {
        $ead = $$tempref{$current};
    }

    return ibap_o2i_object_by_oid_or_name($self, $session, 'ead', {ead => $ead});

}


package Infoblox::CiscoISE::PublishSetting;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            $_object_type
            %_allowed_members
            %_name_mappings
            %_object_to_ibap
            %_reverse_name_mappings
            @ISA
            @_allowed_attributes
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'ciscoise_publish_settings';
    register_wsdl_type('ib:ciscoise_publish_settings', 'Infoblox::CiscoISE::PublishSetting');

    @_allowed_attributes = (
        'CLIENT_ID',
        'FINGERPRINT',
        'HOSTNAME',
        'INFOBLOX_MEMBER',
        'IPADDRESS',
        'LEASE_END_TIME',
        'LEASE_START_TIME',
        'LEASE_STATE',
        'MAC_OR_DUID',
        'NETBIOS_NAME',
    );

    %_allowed_members = (
                         'enabled_attributes' => {mandatory => 1, array => 1, simple => 'asis', enum => \@_allowed_attributes},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'enabled_attributes' => \&ibap_o2i_string_array_undef_to_empty,
    );

    @_return_fields = (
                       tField('enabled_attributes'),
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
