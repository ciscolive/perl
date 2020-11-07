# Copyright (c) 2017 Infoblox Inc.

package Infoblox::Grid::LicenseBase;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;


use vars qw(
            $_object_type
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_license_mapping
            %_name_mappings
            %_object_to_ibap
            %_return_field_overrides
            %_reverse_license_mapping
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_MODIFY );

BEGIN {

    $_object_type = 'BaseLicense';
    register_wsdl_type('ib:BaseLicense', 'Infoblox::Grid::LicenseBase');

    %_capabilities = (
        'depth'                => 0,
        'implicit_defaults'    => 1,
        'single_serialization' => 1,
    );

    %_allowed_members = (
        'expiration'        => {readonly => 1},
        'expiration_status' => {simple => 'asis', readonly => 1},
        'key'               => {simple => 'asis', readonly => 1},
        'limit'             => {simple => 'asis', readonly => 1},
        'limit_context'     => {simple => 'asis', readonly => 1},
        'type'              => {readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
        'key'   => [\&ibap_o2i_string, 'license_string', 'EXACT'],
        'type'  => [\&__o2i_type_search__, 'type', 'EXACT'],
        'limit' => [\&ibap_o2i_uint, 'limit_value', 'EXACT'],
    );

    %_name_mappings = (
        'key'   => 'license_string',
        'limit' => 'limit_value',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
        'expiration' => \&ibap_i2o_datetime_to_unix_timestamp_nolimit,
        'type'       => \&__i2o_type__,
    );

    @_return_fields = (
        tField('type'),
        tField('limit_context'),
        tField('limit_value'),
        tField('expiration'),
        tField('expiration_status'),
        tField('license_string'),
    );

    %_return_field_overrides = (
        'type'              => [],
        'limit_context'     => [],
        'limit_value'       => [],
        'expiration'        => [],
        'expiration_status' => [],
        'key'               => [],
    );

    %_license_mapping = (
        'ANYCAST'            => 'AnyCast',
        'CLOUD'              => 'Cloud Network Automation',
        'CLOUD_API'          => 'Cloud Platform',
        'DCA'                => 'DNSCacheAcceleration',
        'DDI_TRIAL'          => 'DDI Trial',
        'DHCP'               => 'DHCP',
        'DISCOVERY'          => 'Discovery',
        'DNS'                => 'DNS',
        'DNSQRW'             => 'DNS Query Rewrite',
        'DNS_CACHE_ACCEL'    => 'DNSCacheAcceleration',
        'FIREEYE'            => 'FireEye',
        'GRID'               => 'KeystoneDVS',
        'GRID_MAINTENANCE'   => 'KeystoneSup',
        'IFMAP'              => 'IF-MAP Service',
        'IFMAP_FEDERATION'   => 'IF-MAP Federation',
        'IFMAP_SK'           => 'IF-MAP Evaluation',
        'IPAM_FREEWARE'      => 'IPAM Freeware',
        'LDAP'               => 'LDAP',
        'LOAD_BALANCER'      => 'Load Balancer',
        'MGM'                => 'Multi-Grid Management',
        'MSMGMT'             => 'MS Management',
        'NIOS_MAINTENANCE'   => 'NIOSMaintenance',
        'OEM'                => 'OEM',
        'QRD'                => 'Query Redirection',
        'RADIUS'             => 'RADIUS',
        'REPORTING'          => 'Reporting',
        'RPZ'                => 'Response Policy Zones',
        'SECURITY_ECOSYSTEM' => 'Security Ecosystem',
        'TAE'                => 'Trinzic Automation Engine',
        'THREAT_ANALYTICS'   => 'Threat Analytics',
        'TP'                 => 'Threat Protection',
        'SW_TP'              => 'Threat Protection Software Add-On',
        'TP_SUB'             => 'Threat Protection Update',
        'VNIOS'              => 'vNIOS',
        'ORGANIZATION'       => 'Flex Grid Activation',
    );

    %_reverse_license_mapping = reverse %_license_mapping;
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
    $self->__init_instance_constants__();

    {
        no strict 'refs';

        if (!$self->__initialize_members_from_arg_list__(\%{$class . '::_allowed_members'}, \%args) ||
            !$self->__validate_object_required_members__(\%{$class . '::_allowed_members'}))
        {
            return;
        }

        return $self;
    }
}

sub __init_instance_constants__ {}

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

sub __i2o_type__ {

    my ($self, $session, $current, $ibap_object_ref) = @_;

    if (defined $_license_mapping{$$ibap_object_ref{$current}}) {
        return $_license_mapping{$$ibap_object_ref{$current}};
    } else {
        return $$ibap_object_ref{$current};
    }
}

sub __o2i_type_search__ {

    my ($self, $session, $current, $tempref, $type) = @_;

    if ($$tempref{$current}) {
        if ($_reverse_license_mapping{$$tempref{$current}}) {
            return (1, 0, ibap_value_o2i_string($_reverse_license_mapping{$$tempref{$current}}));
        } else {
            return (1, 0, ibap_value_o2i_string($$tempref{$current}));
        }
    } else {
        return (1, 1, undef);
    }
}


package Infoblox::Grid::LicensePool;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::PAPIOverrides;
use Infoblox::IBAPTypes;

use vars qw(
            $_object_type
            $_return_fields_initialized
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_name_mappings
            %_return_field_overrides
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::Grid::LicenseBase Infoblox::PAPIOverrides::RO );

BEGIN {

    $_object_type = 'LicensePool';
    register_wsdl_type('ib:LicensePool','Infoblox::Grid::LicensePool');


    %_capabilities = ();

    %_allowed_members = (
        'model'         => {readonly => 1, simple => 'asis'},
        'installed'     => {readonly => 1, simple => 'asis'},
        'assigned'      => {readonly => 1, simple => 'asis'},
        'temp_assigned' => {readonly => 1, simple => 'asis'},
        'subpools'      => {readonly => 1, array => 1, validator => {'Infoblox::Grid::LicenseSubPool' => 1}},
    );


    %_name_mappings = (
        'model' => 'license_model',
    );

    %_ibap_to_object = (
        'subpools' => \&ibap_i2o_generic_object_list_convert,
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
        'model' => [\&ibap_o2i_string, 'license_model', 'EXACT'],
    );

    @_return_fields = (
        tField('license_model'),
        tField('installed'),
        tField('assigned'),
        tField('temp_assigned'),
    );

    %_return_field_overrides = (
        'model'         => [],
        'installed'     => [],
        'assigned'      => [],
        'temp_assigned' => [],
        'subpools'      => [],
    );

    Infoblox::IBAPBase::subclass('Infoblox::Grid::LicenseBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my $tmp = Infoblox::Grid::LicenseSubPool->__new__();
        push @_return_fields, tField('subpools', {sub_fields => $tmp->__return_fields__()});
    }
}

package Infoblox::Grid::LicenseSubPool;

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

    $_object_type = 'license_sub_pool';
    register_wsdl_type('ib:license_sub_pool', 'Infoblox::Grid::LicenseSubPool');

    %_allowed_members = (
                         'installed'  => {simple => 'asis', readonly => 1},
                         'expiration' => {readonly => 1},
                         'key'        => {simple => 'asis', readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'key' => 'license_string',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'expiration' => \&ibap_i2o_datetime_to_unix_timestamp_nolimit,
    );

    @_return_fields = (
                       tField('installed'),
                       tField('expiration'),
                       tField('license_string'),
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


package Infoblox::Grid::LicenseGridWide;

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

@ISA = qw( Infoblox::Grid::LicenseBase );

BEGIN {

    $_object_type = 'LicenseGridwide';
    register_wsdl_type('ib:LicenseGridwide', 'Infoblox::Grid::LicenseGridWide');
    Infoblox::IBAPBase::subclass('Infoblox::Grid::LicenseBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


package Infoblox::Grid::Member::License;

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

@ISA = qw( Infoblox::Grid::LicenseBase );

BEGIN {

    $_object_type = 'License';
    register_wsdl_type('ib:License','Infoblox::Grid::Member::License');

    %_capabilities = ();

    %_allowed_members = (
                         'key'         => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'kind'        => {readonly => 1, simple => 'asis'},
                         'hwid'        => {readonly => 1, simple => 'asis'},

                         #
                         'expiry_date' => {readonly => 1},
                         'expiry_time' => {readonly => 1},
    );

    %_name_mappings = ();
    %_reverse_name_mappings = reverse %_name_mappings;

    %_object_to_ibap = ();

    %_ibap_to_object = (
       'expiration' => \&__i2o_expiration__,
    );

    %_searchable_fields = (
        'kind' => [\&ibap_o2i_string, 'kind', 'EXACT'],
        'hwid' => [\&ibap_o2i_string, 'hwid', 'EXACT'],
    );

    %_return_field_overrides = (
        'kind' => [],
        'hwid' => [],
    );


    @_return_fields = (
        tField('kind'),
        tField('hwid'),
    );

    Infoblox::IBAPBase::subclass('Infoblox::Grid::LicenseBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}

#
#
#

sub __add_override_hook__ {

    my ($object_type, $session, $object) = @_;

    my $result = $session->import_data(
        type => 'license',
        data => $object->key(),
    );

    if ($result =~ m/Static licenses imported: 0.$/) {
        set_error_codes(1013, $result, $session);
        return 0;
    }
    else {
        return 1;
    }
}

#
#
#

sub __i2o_expiration__ {

    my ($self, $session, $current, $ibap_object_ref) = @_;

    #
    if ($$ibap_object_ref{$current} =~
        /^(\d{4})-(\d{2})-(\d{2}) 
          T(\d{2}):(\d{2}):(\d{2}(\.\d{3})?) 
          (Z|(([+-])(\d{2}):(\d{2})))?$/x
    ) {
        $self->expiry_date("$2/$3/$1");
        $self->expiry_time("$4:$5:$6");
    }

    return ibap_i2o_datetime_to_unix_timestamp_nolimit(@_);
}


package Infoblox::Grid::LicensePoolContainer;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::PAPIOverrides;
use Infoblox::IBAPTypes;

use vars qw(
            $_object_type
            %_allowed_members
            %_capabilities
            %_return_field_overrides
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    $_object_type = 'LicensePoolContainer';
    register_wsdl_type('ib:LicensePoolContainer', 'Infoblox::Grid::LicensePoolContainer');

    %_capabilities = (
        'depth'                => 0,
        'implicit_defaults'    => 0,
        'single_serialization' => 0,
    );

    %_allowed_members = (
        'lpc_uid'                 => {readonly => 1, simple => 'asis'},
        'last_entitlement_update' => {readonly => 1, simple => 'asis'},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
        tField('lpc_uid'),
        tField('last_entitlement_update'),
    );

    %_return_field_overrides = (
        'lpc_uid'                 => [],
        'last_entitlement_update' => [],
    );
}

sub __ibap_to_object__ {

    my $self = shift;
    my ($ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->{'__internal_session_cache_ref__'} = $session;
    return $self->SUPER::__ibap_to_object__(@_);
}

sub update_licenses {

    my ($self, %args) = @_;

    return unless my $session = $self->__check_get_session__();
    return $session->import_data(%args, type => 'license');
}

sub allocate_licenses {

    my $self = shift;

    return unless my $session = $self->__check_get_session__();
    return $session->__allocate_licenses__($self->__object_id__(), @_);
}

sub download_pool_status {

    my $self = shift;

    return unless my $session = $self->__check_get_session__();
    return $session->__download_pool_status__($self->__object_id__(), @_);
}

sub __check_get_session__ {

    my $self = shift;

    my $session;

    unless ($session = $$self{'__internal_session_cache_ref__'}) {
        set_error_codes(1001, 'The object must have been retrieved from the server first');
    }

    return $session;
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


1;
