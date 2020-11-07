package Infoblox::DHCP::IPv6NetworkTemplate;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object $_return_fields_initialized %_return_field_overrides %_capabilities $_return_fields_initialized %_lazy_return_fields);
@ISA = qw ( Infoblox::IBAPBase );

BEGIN {
    $_object_type = 'IPv6NetworkTemplate';
    register_wsdl_type('ib:IPv6NetworkTemplate', 'Infoblox::DHCP::IPv6NetworkTemplate');

    %_capabilities = (
        'depth'                 => 0,
        'implicit_defaults'     => 1,
        'single_serialization'  => 1,
    );

    %_allowed_members = (
        allow_any_netmask                       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        auto_create_reversezone                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        cidr                                    => {simple => 'asis', validator => \&ibap_value_o2i_uint},
        comment                                 => {simple => 'asis', validator => \&ibap_value_o2i_string},
        ddns_domainname                         => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_ddns_domainname', use_truefalse => 1},
        ddns_enable_option_fqdn                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_ddns_enable_option_fqdn', use_truefalse => 1},
        ddns_generate_hostname                  => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_ddns_generate_hostname', use_truefalse => 1},
        ddns_server_always_updates              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        ddns_ttl                                => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_ddns_ttl', use_truefalse => 1},
        domain_name                             => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_domain_name', use_truefalse => 1},
        domain_name_servers                     => {validator => \&ibap_value_o2i_string, use => 'override_domain_name_servers', use_truefalse => 1},
        enable_ddns                             => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_enable_ddns', use_truefalse => 1},
        extattrs                                => {special => 'extensible_attributes'},
        extensible_attributes                   => {special => 'extensible_attributes'},
        fixed_address_templates                 => {array => 1, validator => {'Infoblox::DHCP::Template' => 1}},
        ipv6prefix                              => {simple => 'asis', validator => \&ibap_value_o2i_ipv6_network_or_address},
        members                                 => {array => 1, validator => { 'Infoblox::DHCP::Member' => 1 }, nomixed => 1},
        name                                    => {simple => 'asis', validator => \&ibap_value_o2i_string, mandatory => 1},
        options                                 => {array => 1, validator => { 'Infoblox::DHCP::Option' => 1}, use => 'override_options', use_truefalse => 1},
        override_ddns_domainname                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        override_ddns_enable_option_fqdn        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        override_ddns_generate_hostname         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        override_ddns_ttl                       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        override_domain_name                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        override_domain_name_servers            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        override_enable_ddns                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        override_options                        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        override_preferred_lifetime             => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        override_recycle_leases                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        override_update_dns_on_lease_renewal    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        override_valid_lifetime                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        preferred_lifetime                      => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_preferred_lifetime', use_truefalse => 1},
        range_templates                         => {array => 1, validator => {'Infoblox::DHCP::Template' => 1}},
        recycle_leases                          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_recycle_leases', use_truefalse => 1},
        rir                                     => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        rir_organization                        => {validator => {'Infoblox::Grid::RIR::Organization' => 1}},
        rir_registration_action                 => {simple => 'asis', enum => ['NONE', 'CREATE']},
        rir_registration_status                 => {simple => 'asis', enum => ['NOT_REGISTERED', 'REGISTERED']},
        send_rir_request                        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        update_dns_on_lease_renewal             => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_update_dns_on_lease_renewal', use_truefalse => 1},
        valid_lifetime                          => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_valid_lifetime', use_truefalse => 1},
        delegated_member                        => {validator => {'Infoblox::DHCP::Member' => 1}},
        cloud_api_compatible                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
        ddns_enable_option_fqdn                 => 'enable_option81',
        ddns_generate_hostname                  => 'generate_hostname',
        ddns_server_always_updates              => 'always_update_dns',
        extattrs                                => 'extensible_attributes',
        ipv6prefix                              => 'v6_prefix',
        members                                 => 'dhcp_members',
        override_ddns_domainname                => 'use_ddns_domainname',
        override_ddns_ttl                       => 'use_ddns_ttl',
        override_domain_name                    => 'use_domain_name',
        override_domain_name_servers            => 'use_domain_name_servers',
        override_enable_ddns                    => 'use_enable_ddns',
        override_ddns_enable_option_fqdn        => 'use_enable_option81',
        override_ddns_generate_hostname         => 'use_generate_hostname',
        override_options                        => 'use_options',
        override_preferred_lifetime             => 'use_preferred_lifetime',
        override_recycle_leases                 => 'use_recycle_leases',
        override_update_dns_on_lease_renewal    => 'use_update_dns_on_lease_renewal',
        override_valid_lifetime                 => 'use_lease_time',
        valid_lifetime                          => 'lease_time',
    );

    %_searchable_fields = (
        comment                 => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
        name                    => [\&ibap_o2i_string, 'name', 'REGEX', 'IGNORE_CASE'],
        extattrs                => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        extensible_attributes   => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
        auto_create_reversezone                 => \&ibap_i2o_boolean,
        enable_option81                         => \&ibap_i2o_boolean,
        dhcp_members                            => \&ibap_i2o_members_list,
        domain_name_servers                     => \&ibap_i2o_domain_name_servers,
        extensible_attributes                   => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
        fixed_address_templates                 => \&ibap_i2o_templates,
        generate_hostname                       => \&ibap_i2o_boolean,
        network_view                            => \&ibap_i2o_generic_object_convert,
        options                                 => \&ibap_i2o_options,
        range_templates                         => \&ibap_i2o_templates,
        recycle_leases                          => \&ibap_i2o_boolean,
        rir_organization                        => \&ibap_i2o_generic_object_convert,
        send_rir_request                        => \&ibap_i2o_boolean,
        use_ddns_domainname                     => \&ibap_i2o_boolean,
        use_ddns_ttl                            => \&ibap_i2o_boolean,
        use_domain_name                         => \&ibap_i2o_boolean,
        use_domain_name_servers                 => \&ibap_i2o_boolean,
        use_enable_ddns                         => \&ibap_i2o_boolean,
        use_enable_option81                     => \&ibap_i2o_boolean,
        use_generate_hostname                   => \&ibap_i2o_boolean,
        use_options                             => \&ibap_i2o_boolean,
        use_preferred_lifetime                  => \&ibap_i2o_boolean,
        use_recycle_leases                      => \&ibap_i2o_boolean,
        use_update_dns_on_lease_renewal         => \&ibap_i2o_boolean,
        delegated_member                        => \&ibap_i2o_mixed_member,
        cloud_api_compatible                    => \&ibap_i2o_boolean,
    );

    %_object_to_ibap = (
        allow_any_netmask                       => \&ibap_o2i_boolean,
        auto_create_reversezone                 => \&ibap_o2i_boolean,
        cidr                                    => \&ibap_o2i_uint,
        comment                                 => \&ibap_o2i_string,
        ddns_domainname                         => \&ibap_o2i_string,
        ddns_enable_option_fqdn                 => \&ibap_o2i_boolean,
        ddns_generate_hostname                  => \&ibap_o2i_boolean,
        ddns_server_always_updates              => \&ibap_o2i_boolean,
        ddns_ttl                                => \&ibap_o2i_uint,
        domain_name                             => \&ibap_o2i_string,
        domain_name_servers                     => \&ibap_o2i_domain_name_servers,
        enable_ddns                             => \&ibap_o2i_boolean,
        extattrs                                => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
        extensible_attributes                   => \&ibap_o2i_ignore,
        fixed_address_templates                 => \&ibap_o2i_ipv6_fixed_address_templates,
        ipv6prefix                              => \&ibap_o2i_string,
        members                                 => \&ibap_o2i_members_list,
        name                                    => \&ibap_o2i_string,
        options                                 => \&ibap_o2i_options,
        override_ddns_domainname                => \&ibap_o2i_boolean,
        override_ddns_enable_option_fqdn        => \&ibap_o2i_boolean,
        override_ddns_generate_hostname         => \&ibap_o2i_boolean,
        override_ddns_ttl                       => \&ibap_o2i_boolean,
        override_domain_name                    => \&ibap_o2i_boolean,
        override_domain_name_servers            => \&ibap_o2i_boolean,
        override_enable_ddns                    => \&ibap_o2i_boolean,
        override_options                        => \&ibap_o2i_boolean,
        override_preferred_lifetime             => \&ibap_o2i_boolean,
        override_recycle_leases                 => \&ibap_o2i_boolean,
        override_update_dns_on_lease_renewal    => \&ibap_o2i_boolean,
        override_valid_lifetime                 => \&ibap_o2i_boolean,
        preferred_lifetime                      => \&ibap_o2i_uint,
        range_templates                         => \&ibap_o2i_ipv6_range_templates,
        recycle_leases                          => \&ibap_o2i_boolean,
        rir                                     => \&ibap_o2i_ignore,
        rir_organization                        => \&ibap_o2i_rir_organization,
        rir_registration_action                 => \&ibap_o2i_string,
        rir_registration_status                 => \&ibap_o2i_string,
        send_rir_request                        => \&ibap_o2i_boolean,
        update_dns_on_lease_renewal             => \&ibap_o2i_boolean,
        valid_lifetime                          => \&ibap_o2i_uint,
        delegated_member                        => \&ibap_o2i_delegated_member,
        cloud_api_compatible                    => \&ibap_o2i_boolean,
    );

    %_return_field_overrides = (
        allow_any_netmask                       => [],
        auto_create_reversezone                 => [],
        cidr                                    => [],
        comment                                 => [],
        ddns_domainname                         => ['use_ddns_domainname'],
        ddns_enable_option_fqdn                 => ['use_enable_option81'],
        ddns_generate_hostname                  => ['use_generate_hostname'],
        ddns_server_always_updates              => [],
        ddns_ttl                                => ['use_ddns_ttl'],
        domain_name                             => ['use_domain_name'],
        domain_name_servers                     => ['use_domain_name_servers'],
        enable_ddns                             => ['use_enable_ddns'],
        extattrs                                => [],
        extensible_attributes                   => [],
        fixed_address_templates                 => [],
        ipv6prefix                              => [],
        members                                 => [],
        name                                    => [],
        options                                 => ['use_options'],
        override_ddns_domainname                => [],
        override_ddns_enable_option_fqdn        => [],
        override_ddns_generate_hostname         => [],
        override_ddns_ttl                       => [],
        override_domain_name                    => [],
        override_domain_name_servers            => [],
        override_enable_ddns                    => [],
        override_options                        => [],
        override_preferred_lifetime             => [],
        override_recycle_leases                 => [],
        override_update_dns_on_lease_renewal    => [],
        override_valid_lifetime                 => [],
        preferred_lifetime                      => ['use_preferred_lifetime'],
        range_templates                         => [],
        recycle_leases                          => ['use_recycle_leases'],
        rir                                     => [],
        rir_organization                        => [],
        rir_registration_action                 => [],
        rir_registration_status                 => [],
        send_rir_request                        => [],
        update_dns_on_lease_renewal             => ['use_update_dns_on_lease_renewal'],
        valid_lifetime                          => ['use_lease_time'],
        delegated_member                        => [],
        cloud_api_compatible                    => [],
    );

    $_return_fields_initialized=0;
    @_return_fields = (
        tField('allow_any_netmask'),
        tField('always_update_dns'),
        tField('auto_create_reversezone'),
        tField('cidr'),
        tField('comment'),
        tField('ddns_domainname'),
        tField('ddns_ttl'),
        tField('dhcp_members',
            {
                sub_fields => [
                    tField('grid_member', return_fields_member_basic_data()),
                ]
            }),
        tField('domain_name'),
        tField('domain_name_servers', { sub_fields => [ tField('address')]}),
        tField('enable_ddns'),
        tField('enable_option81'),
        return_fields_extensible_attributes(),
        return_fields_templates('fixed_address_templates'),
        tField('generate_hostname'),
        tField('lease_time'),
        tField('name'),
        tField('options'),
        tField('preferred_lifetime'),
        return_fields_templates('range_templates'),
        tField('recycle_leases'),
        tField('rir'),
        tField('rir_registration_action'),
        tField('rir_registration_status'),
        tField('send_rir_request'),
        tField('update_dns_on_lease_renewal'),
        tField('use_ddns_domainname'),
        tField('use_ddns_ttl'),
        tField('use_domain_name'),
        tField('use_domain_name_servers'),
        tField('use_enable_ddns'),
        tField('use_enable_option81'),
        tField('use_generate_hostname'),
        tField('use_lease_time'),
        tField('use_options'),
        tField('use_preferred_lifetime'),
        tField('use_recycle_leases'),
        tField('use_update_dns_on_lease_renewal'),
        tField('v6_prefix'),
        tField('delegated_member', return_fields_member_basic_data_no_access_ok()),
        tField('cloud_api_compatible'),
    );
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) || !$self->__validate_object_required_members__(\%_allowed_members))
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

    #
    unless ($_return_fields_initialized) {
        $_return_fields_initialized=1;

        my $t = Infoblox::Grid::RIR::Organization->__new__();
        push @_return_fields, tField('rir_organization', { sub_fields => $t->__return_fields__() });
    }

    #
    $self->auto_create_reversezone('false') unless defined $self->auto_create_reversezone();
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

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    $ibap_object_ref->{'send_rir_request'}                      = 0 unless defined $ibap_object_ref->{'send_rir_request'};
    $$ibap_object_ref{'allow_any_netmask'}                      = 0 unless defined $$ibap_object_ref{'allow_any_netmask'};
    $$ibap_object_ref{'auto_create_reversezone'}                = 0 unless defined $$ibap_object_ref{'auto_create_reversezone'};
    $$ibap_object_ref{'always_update_dns'}                      = 0 unless defined $$ibap_object_ref{'always_update_dns'};
    $$ibap_object_ref{'dhcp_members'}                           = [] unless defined $$ibap_object_ref{'dhcp_members'};
    $$ibap_object_ref{'enable_ddns'}                            = 0 unless defined $$ibap_object_ref{'enable_ddns'};
    $$ibap_object_ref{'enable_option81'}                        = 0 unless defined $$ibap_object_ref{'enable_option81'};
    $$ibap_object_ref{'fixed_address_templates'}                = [] unless defined $$ibap_object_ref{'fixed_address_templates'};
    $$ibap_object_ref{'generate_hostname'}                      = 0 unless defined $$ibap_object_ref{'generate_hostname'};
    $$ibap_object_ref{'options'}                                = [] unless defined $$ibap_object_ref{'options'};
    $$ibap_object_ref{'range_templates'}                        = [] unless defined $$ibap_object_ref{'range_templates'};
    $$ibap_object_ref{'recycle_leases'}                         = 0 unless defined $$ibap_object_ref{'recycle_leases'};
    $$ibap_object_ref{'update_dns_on_lease_renewal'}            = 0 unless defined $$ibap_object_ref{'update_dns_on_lease_renewal'};
    $$ibap_object_ref{'use_ddns_domainname'}                    = 0 unless defined $$ibap_object_ref{'use_ddns_domainname'};
    $$ibap_object_ref{'use_ddns_ttl'}                           = 0 unless defined $$ibap_object_ref{'use_ddns_ttl'};
    $$ibap_object_ref{'use_domain_name'}                        = 0 unless defined $$ibap_object_ref{'use_domain_name'};
    $$ibap_object_ref{'use_domain_name_servers'}                = 0 unless defined $$ibap_object_ref{'use_domain_name_servers'};
    $$ibap_object_ref{'use_enable_ddns'}                        = 0 unless defined $$ibap_object_ref{'use_enable_ddns'};
    $$ibap_object_ref{'use_enable_option81'}                    = 0 unless defined $$ibap_object_ref{'use_enable_option81'};
    $$ibap_object_ref{'use_generate_hostname'}                  = 0 unless defined $$ibap_object_ref{'use_generate_hostname'};
    $$ibap_object_ref{'use_options'}                            = 0 unless defined $$ibap_object_ref{'use_options'};
    $$ibap_object_ref{'use_preferred_lifetime'}                 = 0 unless defined $$ibap_object_ref{'use_preferred_lifetime'};
    $$ibap_object_ref{'use_recycle_leases'}                     = 0 unless defined $$ibap_object_ref{'use_recycle_leases'};
    $$ibap_object_ref{'use_update_dns_on_lease_renewal'}        = 0 unless defined $$ibap_object_ref{'use_update_dns_on_lease_renewal'};
    $$ibap_object_ref{'use_update_static_leases'}               = 0 unless defined $$ibap_object_ref{'use_update_static_leases'};
    $$ibap_object_ref{'cloud_api_compatible'}                   = 0 unless defined $$ibap_object_ref{'cloud_api_compatible'};

    #
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'override_ddns_domainname'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_domainname'});
    $self->{'override_ddns_generate_hostname'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_generate_hostname'});
    $self->{'override_ddns_enable_option_fqdn'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_option81'});
    $self->{'override_ddns_ttl'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_ttl'});
    $self->{'override_domain_name'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_domain_name'});
    $self->{'override_domain_name_servers'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_domain_name_servers'});
    $self->{'override_enable_ddns'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_ddns'});
    $self->{'override_options'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_options'});
    $self->{'override_preferred_lifetime'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_preferred_lifetime'});
    $self->{'override_update_dns_on_lease_renewal'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_update_dns_on_lease_renewal'});
    $self->{'override_valid_lifetime'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_lease_time'});

    return;
}

#
#
#

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;

    return $self->SUPER::__object_to_ibap__($server, $session);
}

#
#
#

1;
