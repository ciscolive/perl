package Infoblox::Grid::CloudAPI;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( @ISA
             %_capabilities
             $_object_type
             %_allowed_members
             %_ibap_to_object
             %_object_to_ibap
             @_return_fields
             $_return_fields_initialized );

@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_MODIFY_ONLY );

BEGIN {

    $_object_type = 'GridCloudAPI';
    register_wsdl_type('ib:GridCloudAPI','Infoblox::Grid::CloudAPI');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'allowed_api_admins' => {array => 1, validator => {'Infoblox::Grid::CloudAPI::User' => 1}},
                         'allow_api_admins'   => {simple => 'asis', enum => ['NONE', 'LIST', 'ALL']},
                         'enable_recycle_bin' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'allowed_api_admins' => \&ibap_i2o_generic_object_list_convert,
                        'enable_recycle_bin' => \&ibap_i2o_boolean,
    );

    %_object_to_ibap = (
                        'allowed_api_admins' => \&ibap_o2i_generic_struct_list_convert,
                        'allow_api_admins'   => \&ibap_o2i_string,
                        'enable_recycle_bin' => \&ibap_o2i_boolean,
    );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('allow_api_admins'),
                       tField('enable_recycle_bin'),
    );
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

    $self->__init_instance_constants__();
    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref ($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

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

        my $t = Infoblox::Grid::CloudAPI::User->__new__();

        push @_return_fields,
            tField('allowed_api_admins', {
                sub_fields => $t->__return_fields__(),
            });
    }
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'enable_recycle_bin'} = 0 unless defined $$ibap_object_ref{'enable_recycle_bin'};

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    return $res;
}


package Infoblox::Grid::CloudAPI::User;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( @ISA
             $_object_type
             %_allowed_members
             %_ibap_to_object
             %_object_to_ibap
             @_return_fields
             $_return_fields_initialized );

@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'cloud_api_user';
    register_wsdl_type('ib:cloud_api_user','Infoblox::Grid::CloudAPI::User');

    %_allowed_members = (
                         'is_remote'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'local_admin'  => {validator => {'Infoblox::Grid::Admin::User' => 1}},
                         'remote_admin' => {simple => 'asis', validator => \&ibap_value_o2i_string}
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'is_remote'   => \&ibap_i2o_boolean,
                        'local_admin' => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                        'is_remote'    => \&ibap_o2i_boolean,
                        'local_admin'  => \&ibap_o2i_object_only_by_oid_or_undef,
                        'remote_admin' => \&ibap_o2i_string,
    );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('is_remote'),
                       tField('remote_admin'),
    );
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

    $self->__init_instance_constants__();
    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref ($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    $self->__init_instance_constants__();
    return $self;
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {
        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::Admin::User->__new__();
        push @_return_fields, tField('local_admin', {
                sub_fields => $t->__return_fields__()
            });
    }
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'is_remote'} = 0 unless defined $$ibap_object_ref{'is_remote'};

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    return $res;
}


sub __ibap_object_type__ {

    return $_object_type;
}


package Infoblox::Grid::CloudAPI::Member;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( @ISA
             %_capabilities
             $_object_type
             %_allowed_members
             %_ibap_to_object
             %_object_to_ibap
             @_return_fields
             $_return_fields_initialized
             %_name_mappings
             %_searchable_fields
             %_reverse_name_mappings );

@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE );

BEGIN {

    $_object_type = 'MemberCloudAPI';
    register_wsdl_type('ib:MemberCloudAPI','Infoblox::Grid::CloudAPI::Member');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'member'                => {readonly => 1, validator => {'Infoblox::DHCP::Member' => 1}},
                         'enable_service'        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'allowed_api_admins'    => {array => 1, validator => {'Infoblox::Grid::CloudAPI::User' => 1}},
                         'allow_api_admins'      => {simple => 'asis', enum => ['NONE', 'LIST', 'ALL']},
                         'status'                => {readonly => 1, simple => 'asis', enum => ['UNKNOWN', 'INACTIVE', 'WORKING', 'WARNING', 'FAILED']},
                         'extattrs'              => {readonly => 1, special => 'extensible_attributes'},
                         'extensible_attributes' => {readonly => 1, special => 'extensible_attributes'},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'member'   => 'parent',
                       'extattrs' => 'extensible_attributes'
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'parent'                => \&ibap_i2o_mixed_member,
                        'enable_service'        => \&ibap_i2o_boolean,
                        'allowed_api_admins'    => \&ibap_i2o_generic_object_list_convert,
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
    );

    %_searchable_fields = (
                           'name'                  => [\&ibap_o2i_string, 'host_name', 'REGEX'],
                           'comment'               => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'ipv4addr'              => [\&ibap_o2i_string, 'address', 'REGEX'],
                           'ipv6addr'              => [\&ibap_o2i_string, 'ipv6_address', 'REGEX'],
                           'extattrs'              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
    );

    %_object_to_ibap = (
                        'member'                => \&ibap_o2i_ignore,
                        'enable_service'        => \&ibap_o2i_boolean,
                        'allowed_api_admins'    => \&ibap_o2i_generic_struct_list_convert,
                        'allow_api_admins'      => \&ibap_o2i_string,
                        'status'                => \&ibap_o2i_ignore,
                        'extattrs'              => \&ibap_o2i_ignore,
                        'extensible_attributes' => \&ibap_o2i_ignore,
    );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('enable_service'),
                       tField('allow_api_admins'),
                       tField('status'),
                       tField('parent', return_fields_member_basic_data_no_access_ok()),
                       return_fields_extensible_attributes(),
    );
}

sub new {

    my ($proto, %args ) = @_;
    my $class = ref ($proto) || $proto;
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

sub __new__ {

    my ($proto, %args ) = @_;
    my $class = ref ($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

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

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'enable_service'} = 0 unless defined $$ibap_object_ref{'enable_service'};

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    return $res;
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::CloudAPI::User->__new__();
        push @_return_fields,
            tField('allowed_api_admins', {
                sub_fields => $t->__return_fields__(),
            });
    }
}

package Infoblox::Grid::CloudAPI::CloudStatistics;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( @ISA
             $_object_type
             %_allowed_members
             %_ibap_to_object
             %_object_to_ibap
             @_return_fields
             $_return_fields_initialized
             %_capabilities );

@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_ONLY );

BEGIN {

    $_object_type = 'CloudStatistics';
    register_wsdl_type('ib:CloudStatistics','Infoblox::Grid::CloudAPI::CloudStatistics');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'tenant_count'       => {readonly => 1},
                         'tenant_vm_count'    => {readonly => 1},
                         'tenant_ip_count'    => {readonly => 1},
                         'fixed_ip_count'     => {readonly => 1},
                         'floating_ip_count'  => {readonly => 1},
                         'available_ip_count' => {readonly => 1},
                         'allocated_ip_count' => {readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = ();

    %_object_to_ibap = (
                        'tenant_count'       => \&ibap_o2i_ignore,
                        'tenant_vm_count'    => \&ibap_o2i_ignore,
                        'tenant_ip_count'    => \&ibap_o2i_ignore,
                        'fixed_ip_count'     => \&ibap_o2i_ignore,
                        'floating_ip_count'  => \&ibap_o2i_ignore,
                        'available_ip_count' => \&ibap_o2i_ignore,
                        'allocated_ip_count' => \&ibap_o2i_ignore,
    );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('tenant_count'),
                       tField('tenant_vm_count'),
                       tField('tenant_ip_count'),
                       tField('fixed_ip_count'),
                       tField('floating_ip_count'),
                       tField('available_ip_count'),
                       tField('allocated_ip_count'),
    );
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

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}


package Infoblox::Grid::CloudAPI::Info;

use strict;
use Carp;

use Infoblox::Util;

use Infoblox::PAPIOverrides;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( %_allowed_members
             $_return_fields_initialized
             %_reverse_name_mappings
             %_ibap_to_object
             %_object_to_ibap
             %_name_mappings
             @_return_fields
             @_tenant_return_fields
             $_object_type
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'cloud_info';
    register_wsdl_type('ib:cloud_info', 'Infoblox::Grid::CloudAPI::Info');

    #
    %_allowed_members = (
                         'delegated_member'     => {validator => {'Infoblox::DHCP::Member' => 1}},
                         'tenant'               => {readonly => 1, validator => {'Infoblox::Grid::CloudAPI::Tenant' => 1}},
                         'owned_by_adaptor'     => {simple => 'bool', readonly => 1, validator => \&ibap_value_o2i_boolean},
                         'delegated_scope'      => {readonly => 1, enum => ['NONE', 'ROOT', 'SUBTREE', 'RECLAIMING']},
                         'usage'                => {readonly => 1, enum => ['NONE', 'ADAPTER', 'USED_BY', 'DELEGATED']},
                         'delegated_root'       => {readonly => 1},
                         'has_multiple_sources' => {simple => 'bool', readonly => 1, validator => \&ibap_value_o2i_boolean},
                         'multiple_sources'     => {array => 1, readonly => 1, validator => {'Infoblox::DHCP::Member' => 1}},
                         'mgmt_platform'        => {simple => 'asis', readonly => 1},
                         'authority_type'       => {simple => 'asis', readonly => 1, enum => ['NONE', 'GM', 'CP']},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'usage' => 'cloud_usage',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('delegated_scope'),
                       tField('delegated_root'),
                       tField('owned_by_adaptor'),
                       tField('cloud_usage'),
                       tField('delegated_member', return_fields_member_basic_data_no_access_ok()),
                       tField('multiple_sources', return_fields_member_basic_data_no_access_ok()),
                       tField('has_multiple_sources'),
                       tField('mgmt_platform'),
                       tField('authority_type'),
    );

    %_ibap_to_object = (
                        'delegated_member'     => \&ibap_i2o_mixed_member,
                        'tenant'               => \&ibap_i2o_generic_object_convert,
                        'multiple_sources'     => \&ibap_i2o_mixed_members_list,
                        'owned_by_adaptor'     => \&ibap_i2o_boolean,
                        'has_multiple_sources' => \&ibap_i2o_boolean,
    );

    %_object_to_ibap = (
                        'delegated_member'     => \&ibap_o2i_delegated_member,
                        'delegated_scope'      => \&ibap_o2i_ignore,
                        'delegated_root'       => \&ibap_o2i_ignore,
                        'owned_by_adaptor'     => \&ibap_o2i_ignore,
                        'tenant'               => \&ibap_o2i_ignore,
                        'usage'                => \&ibap_o2i_ignore,
                        'has_multiple_sources' => \&ibap_o2i_ignore,
                        'mgmt_platform'        => \&ibap_o2i_ignore,
                        'authority_type'       => \&ibap_o2i_ignore,
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

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my $tmp;

        #
        @_tenant_return_fields = @_return_fields;

        #
        #
        $tmp = Infoblox::Grid::CloudAPI::Tenant->__new__();
        push @_return_fields, tField('tenant', {sub_fields => $tmp->__return_fields__});
    }
}

sub __tenant_return_fields__ {

    return \@_tenant_return_fields;

}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'owned_by_adaptor'}     = 0 unless defined $$ibap_object_ref{'owned_by_adaptor'};
    $$ibap_object_ref{'has_multiple_sources'} = 0 unless defined $$ibap_object_ref{'has_multiple_sources'};

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    return $res;
}

package Infoblox::Grid::CloudAPI::Tenant;


use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             %_reverse_name_mappings
             %_object_to_ibap
             %_ibap_to_object
             %_searchable_fields
             %_name_mappings
             @_return_fields
             %_capabilities
             $_object_type
             $_return_fields_initialized
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'Tenant';
    register_wsdl_type('ib:Tenant', 'Infoblox::Grid::CloudAPI::Tenant');

    %_allowed_members = (
                         'name'                       => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'comment'                    => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'id'                         => {readonly => 1},
                         'vm_count'                   => {readonly => 1},
                         'network_count'              => {readonly => 1},
                         'network_views'              => {array => 1, readonly => 1},
                         'cloud_info'                 => {readonly => 1, validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
                         'first_seen'                 => {readonly => 1},
                         'last_seen'                  => {readonly => 1},
                         'first_discovered_timestamp' => {readonly => 1},
                         'last_discovered_timestamp'  => {readonly => 1},
                         'unmanaged'                  => {readonly => 1, simple => 'bool', validator => \&ibap_value_o2i_boolean},

                         #
                         'created_ts'    => {readonly => 1},
                         'last_event_ts' => {readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'name'      => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'comment'   => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'id'        => [\&ibap_o2i_string, 'unique_id', 'REGEX'],
                           'unmanaged' => [\&ibap_o2i_boolean, 'unmanaged', 'EXACT'],
    );

    %_name_mappings = (
                       'id' => 'unique_id',

    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_object_to_ibap = (
                        'name'                          => \&ibap_o2i_string,
                        'comment'                       => \&ibap_o2i_string,
                        'id'                            => \&ibap_o2i_ignore,
                        'vm_count'                      => \&ibap_o2i_ignore,
                        'network_count'                 => \&ibap_o2i_ignore,
                        'network_views'                 => \&ibap_o2i_ignore,
                        'cloud_info'                    => \&ibap_o2i_ignore,
                        'first_seen'                    => \&ibap_o2i_ignore,
                        'last_seen'                     => \&ibap_o2i_ignore,
                        'unmanaged'                     => \&ibap_o2i_ignore,
                        'first_discovered_timestamp'    => \&ibap_o2i_ignore,
                        'last_discovered_timestamp'     => \&ibap_o2i_ignore,

                        #
                        'created_ts'    => \&ibap_o2i_ignore,
                        'last_event_ts' => \&ibap_o2i_ignore,
    );

    %_ibap_to_object = (
                        'cloud_info'                 => \&ibap_i2o_generic_object_convert,
                        'first_seen'                 => \&ibap_i2o_datetime_to_unix_timestamp,
                        'last_seen'                  => \&ibap_i2o_datetime_to_unix_timestamp,
                        'first_discovered_timestamp' => \&ibap_i2o_datetime_to_unix_timestamp,
                        'last_discovered_timestamp'  => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    @_return_fields = (
                       tField('name'),
                       tField('comment'),
                       tField('unique_id'),
                       tField('first_seen'),
                       tField('last_seen'),
                       tField('vm_count'),
                       tField('network_count'),
                       tField('network_views'),
                       tField('cloud_info'),
                       tField('unmanaged'),
                       tField('first_discovered_timestamp'),
                       tField('last_discovered_timestamp'),
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

sub __init_instance_constants__
{
    my $self = shift;

    unless ($_return_fields_initialized) {
        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::CloudAPI::Info->__new__();

        #
        push @_return_fields,
          tField('cloud_info', {sub_fields => $t->__tenant_return_fields__()});
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

    $$ibap_object_ref{'unmanaged'} = 0 unless defined $$ibap_object_ref{'unmanaged'};

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'created_ts'} = $$ibap_object_ref{'first_seen'};
    $self->{'last_event_ts'} = $$ibap_object_ref{'last_seen'};

    return $res;
}


package Infoblox::Grid::CloudAPI::VMAddress;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_object_to_ibap @_return_fields $_return_fields_initialized
            %_capabilities %_searchable_fields %_return_field_overrides %_name_mappings %_reverse_name_mappings $_newhostaddress
            %_supported_objects);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO);

BEGIN
{
    $_object_type = 'VmAddress';
    register_wsdl_type('ib:VmAddress','Infoblox::Grid::CloudAPI::VMAddress');

    $_newhostaddress = Infoblox::__options('hostaddress');
    %_supported_objects = (
        'AaaaRecord'       => 1,
        'ARecord'          => 1,
        'BulkHost'         => 1,
        'DhcpRange'        => 1,
        'FixedAddress'     => 1,
        'HostRecord'       => 1,
        'IPv6DhcpRange'    => 1,
        'IPv6FixedAddress' => 1,
        'Lease'            => 1,
        'PtrRecord'        => 1,
    );

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
        vm_name                 => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        tenant_name             => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        tenant                  => {readonly => 1, validator => {'Infoblox::Grid::CloudAPI::Tenant' => 1}},
        vm_id                   => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        address                 => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        is_ipv4                 => {simple => 'bool', readonly => 1, validator => \&ibap_value_o2i_boolean},
        mac_address             => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        port_id                 => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_uint},
        dns_names               => {simple => 'asis', array => 1, readonly => 1, validator => \&ibap_value_o2i_uint},
        network_view            => {readonly => 1, validator => \&ibap_value_o2i_string},
        network                 => {readonly => 1, validator => \&ibap_value_o2i_string},
        associated_objects      => {readonly => 1, array => 1},
        associated_ip           => {readonly => 1, validator => {'Infoblox::IPAM::Address' => 1}},
        address_type            => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        private_hostname        => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        public_hostname         => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        private_address         => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        public_address          => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        elastic_address         => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        subnet_id               => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        subnet_address          => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        subnet_cidr             => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        interface_name          => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        cloud_info              => {readonly => 1, validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
        vm_availability_zone    => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        vm_vpc_id               => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        vm_vpc_name             => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        vm_network_count        => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_uint},
        vm_last_update_time     => {readonly => 1},
        vm_creation_time        => {readonly => 1},
        vm_comment              => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        vm_type                 => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        vm_kernel_id            => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        vm_hostname             => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        vm_vpc_address          => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        vm_vpc_cidr             => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        vm_operating_system     => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        associated_object_types => {readonly => 1, array => 1, validator => \&ibap_value_o2i_string},
        ms_ad_user_data    => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
    );
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
        'network_view' => 'networkview_ref',
        'network' => 'network_ref',
        'tenant' => 'tenant_ref',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
        'networkview_ref'    => \&ibap_i2o_object_name,
        'network_ref'        => \&__i2o_netname__,
        'associated_objects' => \&__i2o_objects__,
        'tenant_ref'         => \&ibap_i2o_generic_object_convert,
        'cloud_info'         => \&ibap_i2o_generic_object_convert,
        'associated_ip'      => \&ibap_i2o_generic_object_convert,
        'vm_creation_time'   => \&ibap_i2o_datetime_to_unix_timestamp,
        'vm_last_update_time'=> \&ibap_i2o_datetime_to_unix_timestamp,
        'ms_ad_user_data'    => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
        vm_name                 => \&ibap_o2i_ignore,
        tenant_name             => \&ibap_o2i_ignore,
        tenant                  => \&ibap_o2i_ignore,
        vm_id                   => \&ibap_o2i_ignore,
        address                 => \&ibap_o2i_ignore,
        is_ipv4                 => \&ibap_o2i_ignore,
        mac_address             => \&ibap_o2i_ignore,
        port_id                 => \&ibap_o2i_ignore,
        network_view            => \&ibap_o2i_ignore,
        network                 => \&ibap_o2i_ignore,
        dns_names               => \&ibap_o2i_ignore,
        associated_objects      => \&ibap_o2i_ignore,
        address_type            => \&ibap_o2i_ignore,
        private_hostname        => \&ibap_o2i_ignore,
        public_hostname         => \&ibap_o2i_ignore,
        private_address         => \&ibap_o2i_ignore,
        public_address          => \&ibap_o2i_ignore,
        elastic_address         => \&ibap_o2i_ignore,
        subnet_id               => \&ibap_o2i_ignore,
        subnet_address          => \&ibap_o2i_ignore,
        subnet_cidr             => \&ibap_o2i_ignore,
        interface_name          => \&ibap_o2i_ignore,
        cloud_info              => \&ibap_o2i_ignore,
        vm_availability_zone    => \&ibap_o2i_ignore,
        vm_vpc_id               => \&ibap_o2i_ignore,
        vm_vpc_name             => \&ibap_o2i_ignore,
        vm_network_count        => \&ibap_o2i_ignore,
        vm_last_update_time     => \&ibap_o2i_ignore,
        vm_creation_time        => \&ibap_o2i_ignore,
        vm_comment              => \&ibap_o2i_ignore,
        vm_type                 => \&ibap_o2i_ignore,
        vm_kernel_id            => \&ibap_o2i_ignore,
        vm_hostname             => \&ibap_o2i_ignore,
        vm_vpc_address          => \&ibap_o2i_ignore,
        vm_vpc_cidr             => \&ibap_o2i_ignore,
        vm_operating_system     => \&ibap_o2i_ignore,
        associated_object_types => \&ibap_o2i_ignore,
        ms_ad_user_data    => \&ibap_o2i_ignore,
    );

    %_searchable_fields = (
        vm_name     => [\&ibap_o2i_string ,'vm_name', 'REGEX'],
        address     => [\&ibap_o2i_string ,'address', 'REGEX'],
        vm_id       => [\&ibap_o2i_string ,'vm_id', 'REGEX'],
        tenant_name => [\&ibap_o2i_string ,'tenant_name', 'REGEX'],
        mac_address => [\&ibap_o2i_string ,'mac_address', 'REGEX', 'IGNORE_CASE'],
    );

    %_return_field_overrides = (
        vm_name            => [],
        tenant_name        => [],
        tenant             => [],
        vm_id              => [],
        address            => [],
        is_ipv4            => [],
        mac_address        => [],
        port_id            => [],
        network_view       => [],
        network            => [],
        dns_names          => [],
        associated_objects => [],
        ms_ad_user_data    => [],
    );

    $_return_fields_initialized=0;
    @_return_fields = (
        tField('vm_name'),
        tField('tenant_name'),
        tField('vm_id'),
        tField('address'),
        tField('is_ipv4'),
        tField('mac_address'),
        tField('port_id'),
        tField('networkview_ref', {sub_fields => [tField('name')]}),
        tField('network_ref', {sub_fields => [tField('address'), tField('cidr')]}),
        tField('dns_names'),
        tField('address_type'),
        tField('private_hostname'),
        tField('public_hostname'),
        tField('private_address'),
        tField('public_address'),
        tField('elastic_address'),
        tField('subnet_id'),
        tField('subnet_address'),
        tField('subnet_cidr'),
        tField('interface_name'),
        tField('vm_availability_zone'),
        tField('vm_vpc_id'),
        tField('vm_vpc_name'),
        tField('vm_network_count'),
        tField('vm_last_update_time'),
        tField('vm_creation_time'),
        tField('vm_comment'),
        tField('vm_type'),
        tField('vm_kernel_id'),
        tField('vm_hostname'),
        tField('vm_vpc_address'),
        tField('vm_vpc_cidr'),
        tField('vm_operating_system'),
        tField('associated_object_types'),
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

sub __ibap_object_type__
{
    return $_object_type;
}

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

sub __init_instance_constants__
{
    my $self = shift;

    unless ($_return_fields_initialized) {
        $_return_fields_initialized=1;

        my $t = Infoblox::Grid::CloudAPI::Tenant->__new__();
        push @_return_fields, tField('tenant_ref', { sub_fields => $t->__return_fields__() });

        $t = Infoblox::Grid::MSServer::AdUser::Data->__new__();
        push @_return_fields, tField('ms_ad_user_data', {sub_fields => $t->__return_fields__()});

        my @resource_returnfields;
        if ($_newhostaddress) {
            $_supported_objects{'HostAddress'} = 1;
            $_supported_objects{'IPv6HostAddress'} = 1;
        }

        foreach my $t (keys %_supported_objects) {
            my $x = $papi_object_type_from_wsdl{'ib:' . $t}->__new__();
            push @resource_returnfields, tFieldObjType($t, {sub_fields => $x->__return_fields__()});
        }

        push @_return_fields,
          tField('associated_objects',
                 {
                  default_no_access_ok => 1,
                  sub_fields => \@resource_returnfields,
                 }
                );

        $t = Infoblox::IPAM::Address->__new__();
        push @_return_fields, tField('associated_ip', { sub_fields => $t->__return_fields__() });

        $t = Infoblox::Grid::CloudAPI::Info->__new__();
        push @_return_fields, tField('cloud_info', { sub_fields => $t->__return_fields__() });
    }
}

sub __i2o_netname__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return $ibap_object_ref->{$current}->{'address'} . '/' . $ibap_object_ref->{$current}->{'cidr'};
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'is_ipv4'} = 0 unless defined $$ibap_object_ref{'is_ipv4'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __i2o_objects__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && ref($$ibap_object_ref{$current}) eq 'ARRAY') {
        foreach my $t (@{$$ibap_object_ref{$current}}) {
            (my $ibaptype = ref($t)) =~ s/^ib://;
            if ($_supported_objects{$ibaptype}) {
                my $x = $papi_object_type_from_wsdl{'ib:' . $ibaptype}->__new__();
                $x->__ibap_to_object__($t, $session->get_ibap_server(), $session, $return_object_cache_ref);
                push @newlist, $x;
            }
        }
    }

    $self->{'associated_objects'} = \@newlist;
}

package Infoblox::Grid::CloudAPI::VM;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( @ISA
             %_capabilities
             $_object_type
             %_allowed_members
             %_searchable_fields
             %_ibap_to_object
             %_object_to_ibap
             %_name_mappings
             %_reverse_name_mappings
             $_return_fields_initialized
             @_return_fields);

@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE );

BEGIN {

    $_object_type = 'VM';
    register_wsdl_type('ib:VM','Infoblox::Grid::CloudAPI::VM');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'id'                     => {simple => 'asis', readonly => 1},
                         'name'                   => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'comment'                => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'first_seen'             => {readonly => 1},
                         'last_seen'              => {readonly => 1},
                         'vm_type'                => {simple => 'asis', readonly => 1},
                         'operating_system'       => {simple => 'asis', readonly => 1},
                         'kernel_id'              => {simple => 'asis', readonly => 1},
                         'vpc_id'                 => {simple => 'asis', readonly => 1},
                         'vpc_name'               => {simple => 'asis', readonly => 1},
                         'vpc_address'            => {simple => 'asis', readonly => 1},
                         'vpc_cidr'               => {simple => 'asis', readonly => 1},
                         'tenant_name'            => {simple => 'asis', readonly => 1},
                         'availability_zone'      => {simple => 'asis', readonly => 1},
                         'primary_mac_address'    => {simple => 'asis', readonly => 1},
                         'hostname'               => {simple => 'asis', readonly => 1},
                         'subnet_id'              => {simple => 'asis', readonly => 1},
                         'subnet_address'         => {simple => 'asis', readonly => 1},
                         'subnet_cidr'            => {simple => 'asis', readonly => 1},
                         'elastic_ip_address'     => {simple => 'asis', readonly => 1},
                         'network_count'          => {simple => 'asis', readonly => 1},
                         'cloud_info'             => {readonly => 1, validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'name'    => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'comment' => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'id'      => [\&ibap_o2i_string, 'id', 'REGEX'],
                           'primary_mac_address'      => [\&ibap_o2i_string, 'primary_mac_address', 'REGEX', 'IGNORE_CASE'],
                           'elastic_ip_address'      => [\&ibap_o2i_string, 'primary_mac_address', 'REGEX'],
    );

    %_name_mappings = (
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'cloud_info'               => \&ibap_i2o_generic_object_convert,
                        'first_seen'               => \&ibap_i2o_datetime_to_unix_timestamp,
                        'last_seen'                => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    %_object_to_ibap = (
                        'name'                     => \&ibap_o2i_string,
                        'comment'                  => \&ibap_o2i_string,
                        'id'                       => \&ibap_o2i_ignore,
                        'first_seen'               => \&ibap_o2i_ignore,
                        'last_seen'                => \&ibap_o2i_ignore,
                        'vm_type'                  => \&ibap_o2i_ignore,
                        'operating_system'         => \&ibap_o2i_ignore,
                        'kernel_id'                => \&ibap_o2i_ignore,
                        'vpc_id'                   => \&ibap_o2i_ignore,
                        'vpc_name'                 => \&ibap_o2i_ignore,
                        'vpc_address'              => \&ibap_o2i_ignore,
                        'vpc_cidr'                 => \&ibap_o2i_ignore,
                        'tenant_name'              => \&ibap_o2i_ignore,
                        'availability_zone'        => \&ibap_o2i_ignore,
                        'primary_mac_address'      => \&ibap_o2i_ignore,
                        'hostname'                 => \&ibap_o2i_ignore,
                        'subnet_id'                => \&ibap_o2i_ignore,
                        'subnet_cidr'              => \&ibap_o2i_ignore,
                        'subnet_address'              => \&ibap_o2i_ignore,
                        'elastic_ip_address'       => \&ibap_o2i_ignore,
                        'network_count'            => \&ibap_o2i_ignore,
                        'cloud_info'               => \&ibap_o2i_ignore,
    );

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('id'),
                       tField('name'),
                       tField('comment'),
                       tField('first_seen'),
                       tField('last_seen'),
                       tField('vm_type'),
                       tField('operating_system'),
                       tField('kernel_id'),
                       tField('vpc_id'),
                       tField('vpc_name'),
                       tField('vpc_address'),
                       tField('vpc_cidr'),
                       tField('tenant_name'),
                       tField('availability_zone'),
                       tField('primary_mac_address'),
                       tField('hostname'),
                       tField('subnet_id'),
                       tField('subnet_address'),
                       tField('subnet_cidr'),
                       tField('elastic_ip_address'),
                       tField('network_count'),
    );
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

    $self->__init_instance_constants__();

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref ($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    $self->__init_instance_constants__();

    return $self;
}

sub __init_instance_constants__
{
    my $self = shift;

    unless ($_return_fields_initialized) {
        $_return_fields_initialized=1;

        my $t = Infoblox::Grid::CloudAPI::Info->__new__();
        push @_return_fields,
          tField('cloud_info', {
                                sub_fields => $t->__return_fields__(),
                               }
                );

    }
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}
