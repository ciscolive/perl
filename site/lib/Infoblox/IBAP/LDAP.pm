package Infoblox::LDAP::Server;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object
                 %_name_mappings %_reverse_name_mappings %_object_to_ibap
                 @_return_fields %_capabilities %_searchable_fields
                 %_return_field_overrides $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'ldap_server';
    register_wsdl_type('ib:ldap_server','Infoblox::LDAP::Server');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'address'             => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'base_dn'             => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'authentication_type' => {simple => 'asis', enum => ['ANONYMOUS','AUTHENTICATED']},
                         'bind_user_dn'        => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'bind_password'       => {writeonly => 1, validator => \&ibap_value_o2i_string},
                         'comment'             => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'disable'             => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'encryption'          => {simple => 'asis', enum => ['NONE', 'SSL']},
                         'port'                => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'use_mgmt_port'       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'version'             => {simple => 'asis', enum => ['V2', 'V3']},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
                                'address'             => [],
                                'base_dn'             => [],
                                'authentication_type' => [],
                                'bind_user_dn'        => [],
                                'bind_password'       => [],
                                'comment'             => [],
                                'disable'             => [],
                                'encryption'          => [],
                                'port'                => [],
                                'use_mgmt_port'       => [],
                                'version'             => [],
                               );

    %_name_mappings = (
                       'disable' => 'disabled',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('address'),
                       tField('base_dn'),
                       tField('authentication_type'),
                       tField('bind_user_dn'),
                     #
                       tField('comment'),
                       tField('disabled'),
                       tField('encryption'),
                       tField('port'),
                       tField('use_mgmt_port'),
                       tField('version'),
                      );

    %_ibap_to_object = (
                        'disabled'      => \&ibap_i2o_boolean,
                        'use_mgmt_port' => \&ibap_i2o_boolean,
                       );

    %_object_to_ibap = (
                        'address'             => \&ibap_o2i_string,
                        'base_dn'             => \&ibap_o2i_string,
                        'authentication_type' => \&ibap_o2i_string,
                        'bind_user_dn'        => \&ibap_o2i_string,
                        'bind_password'       => \&ibap_o2i_string_skip_undef,
                        'comment'             => \&ibap_o2i_string,
                        'disable'             => \&ibap_o2i_boolean,
                        'encryption'          => \&ibap_o2i_string,
                        'port'                => \&ibap_o2i_uint,
                        'use_mgmt_port'       => \&ibap_o2i_boolean,
                        'version'             => \&ibap_o2i_string,
                       );

    %_searchable_fields = ();
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

    if (defined $args{'authentication_type'} and $args{'authentication_type'} eq 'AUTHENTICATED') {
        if (not defined $args{'bind_user_dn'} or not defined $args{'bind_password'}) {
            set_error_codes(1103,'bind_user_dn and bind_password are required if authentication_type is "AUTHENTICATED"');
            return;
        }
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

sub __init_instance_constants__
{
    my $self = shift;

    $self->port(636) unless $self->port();
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

    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};
    $$ibap_object_ref{'use_mgmt_port'} = 0 unless defined $$ibap_object_ref{'use_mgmt_port'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::LDAP::AuthService;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object
                 %_name_mappings %_reverse_name_mappings %_object_to_ibap
                 @_return_fields %_capabilities %_searchable_fields
                 %_return_field_overrides $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'LdapAuthService';
    register_wsdl_type('ib:LdapAuthService','Infoblox::LDAP::AuthService');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'name'                           => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'servers'                        => {array => 1, mandatory => 1, validator => {'Infoblox::LDAP::Server' => 1}},
                         'timeout'                        => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'retries'                        => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'recovery_interval'              => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'mode'                           => {simple => 'asis', enum => ['ORDERED_LIST', 'ROUND_ROBIN']},
                         'ldap_group_attribute'           => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'ldap_user_attribute'            => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'search_scope'                   => {simple => 'asis', enum => ['BASE', 'ONELEVEL', 'SUBTREE']},
                         'ea_mapping'                     => {array => 1, validator => {'Infoblox::LDAP::EA_Mapping' => 1}},
                         'comment'                        => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'disable'                        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'ldap_group_authentication_type' => {simple => 'asis', enum => ['GROUP_ATTRIBUTE', 'POSIX_GROUP']},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
                                'name'                           => [],
                                'servers'                        => [],
                                'timeout'                        => [],
                                'retries'                        => [],
                                'recovery_interval'              => [],
                                'mode'                           => [],
                                'ldap_group_attribute'           => [],
                                'ldap_user_attribute'            => [],
                                'search_scope'                   => [],
                                'ea_mapping'                     => [],
                                'comment'                        => [],
                                'disable'                        => [],
                                'ldap_group_authentication_type' => [],
                               );

    %_name_mappings = (
                       'servers'      => 'ldap_servers',
                       'search_scope' => 'ldap_search_scope',
                       'ea_mapping'   => 'ldap_ea_mapping',
                       'disable'      => 'disabled',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('name'),
                       tField('timeout'),
                       tField('retries'),
                       tField('recovery_interval'),
                       tField('mode'),
                       tField('ldap_group_attribute'),
                       tField('ldap_user_attribute'),
                       tField('ldap_search_scope'),
                       tField('comment'),
                       tField('disabled'),
                       tField('ldap_group_authentication_type'),
                      );

    %_ibap_to_object = (
                        'ldap_servers'    => \&ibap_i2o_generic_object_list_convert,
                        'ldap_ea_mapping' => \&ibap_i2o_generic_object_list_convert,
                        'disabled'        => \&ibap_i2o_boolean,
                       );

    %_object_to_ibap = (
                        'name'                           => \&ibap_o2i_string,
                        'servers'                        => \&ibap_o2i_generic_struct_list_convert,
                        'timeout'                        => \&ibap_o2i_uint,
                        'retries'                        => \&ibap_o2i_uint,
                        'recovery_interval'              => \&ibap_o2i_uint,
                        'mode'                           => \&ibap_o2i_string,
                        'ldap_group_attribute'           => \&ibap_o2i_string,
                        'ldap_user_attribute'            => \&ibap_o2i_string,
                        'search_scope'                   => \&ibap_o2i_string,
                        'ea_mapping'                     => \&ibap_o2i_generic_struct_list_convert,
                        'comment'                        => \&ibap_o2i_string,
                        'disable'                        => \&ibap_o2i_boolean,
                        'ldap_group_authentication_type' => \&ibap_o2i_string,
                       );

    %_searchable_fields = (
                           'name'         => [\&ibap_o2i_string, 'name', 'REGEX', 'IGNORE_CASE'],
                           'comment'      => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           'search_scope' => [\&ibap_o2i_string, 'search_scope', 'EXACT'],
                           'mode'         => [\&ibap_o2i_string, 'mode', 'EXACT'],
                          );

    $_return_fields_initialized = 0;
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

    $self->timeout(5) unless $self->timeout();
    $self->retries(5) unless $self->retries();
    $self->recovery_interval(30) unless $self->recovery_interval();

    unless ($_return_fields_initialized) {
        $_return_fields_initialized=1;

        my $t = Infoblox::LDAP::Server->__new__();
        push @_return_fields,
        tField('ldap_servers', {
                        sub_fields => $t->__return_fields__(),
                       }
              );

        $t = Infoblox::LDAP::EA_Mapping->__new__();
        push @_return_fields,
        tField('ldap_ea_mapping', {
                        sub_fields => $t->__return_fields__(),
                       }
              );
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

    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::LDAP::EA_Mapping;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object
                 %_name_mappings %_reverse_name_mappings %_object_to_ibap
                 @_return_fields %_capabilities %_searchable_fields
                 %_return_field_overrides $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'ldap_ea_mapping';
    register_wsdl_type('ib:ldap_ea_mapping','Infoblox::LDAP::EA_Mapping');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'attr_name'    => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'ext_attr_def' => {validator => {'Infoblox::Grid::ExtensibleAttributeDef' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
                                'attr_name'    => [],
                                'ext_attr_def' => [],
                               );

    %_name_mappings = (
                       'attr_name' => 'ldap_attr_name',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('ldap_attr_name'),
                      );

    %_ibap_to_object = (
                        'ext_attr_def' => \&ibap_i2o_generic_object_convert,
                       );

    %_object_to_ibap = (
                        'attr_name'    => \&ibap_o2i_string,
                        'ext_attr_def' => \&ibap_o2i_object_by_oid_or_name,
                       );

    %_searchable_fields = ();

    $_return_fields_initialized = 0;
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
        $_return_fields_initialized=1;

        my $t = Infoblox::Grid::ExtensibleAttributeDef->__new__();
        push @_return_fields,
        tField('ext_attr_def', {
                        sub_fields => $t->__return_fields__(),
                       }
              );
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


1;
