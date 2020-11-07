package Infoblox::DHCP::IPv6SharedNetwork;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object $_return_fields_initialized @_sub_host_address_fields %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase);


BEGIN {
    $_object_type = 'IPv6SharedNetwork';
    register_wsdl_type('ib:IPv6SharedNetwork','Infoblox::DHCP::IPv6SharedNetwork');

    %_capabilities = (
                      'depth'                  => 0,
                      'implicit_defaults'      => 1,
                      'single_serialization'   => 1,
                     );

    %_allowed_members = (
                         comment                        => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         ddns_domainname                => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_ddns_domainname', use_truefalse => 1},
                         ddns_enable_option_fqdn        => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_ddns_enable_option_fqdn', use_truefalse => 1},
                         ddns_generate_hostname         => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_ddns_generate_hostname', use_truefalse => 1},
                         ddns_ttl                       => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_ddns_ttl', use_truefalse => 1},
                         disable                        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         domain_name                    => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_domain_name', use_truefalse => 1},
                         domain_name_servers            => {validator => \&ibap_value_o2i_string, use => 'override_domain_name_servers', use_truefalse => 1},
                         enable_ddns                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_enable_ddns', use_truefalse => 1},
                         extattrs                       => {special => 'extensible_attributes'},
                         extensible_attributes          => {special => 'extensible_attributes'},
                         name                           => {simple => 'asis', validator => \&ibap_value_o2i_string, mandatory => 1},
                         network_view                   => {validator => { 'Infoblox::DHCP::View' => 1 }},
                         networks                       => {array => 1, validator => {'Infoblox::DHCP::IPv6Network' => 1}},
                         options                        => {array => 1, validator => { 'Infoblox::DHCP::Option' => 1}, use => 'override_options', use_truefalse => 1},
                         override_ddns_domainname       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_ddns_enable_option_fqdn => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_ddns_generate_hostname => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_ddns_ttl              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_domain_name           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_domain_name_servers   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_enable_ddns           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_options               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_preferred_lifetime    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_update_dns_on_lease_renewal => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_valid_lifetime        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         preferred_lifetime             => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_preferred_lifetime', use_truefalse => 1},
                         update_dns_on_lease_renewal    => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_update_dns_on_lease_renewal', use_truefalse => 1},
                         valid_lifetime                 => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_valid_lifetime', use_truefalse => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       ddns_enable_option_fqdn        => 'enable_option81',
                       ddns_generate_hostname         => 'generate_hostname',
                       disable                        => 'disabled',
                       extattrs                       => 'extensible_attributes',
                       override_ddns_domainname       => 'use_ddns_domainname',
                       override_ddns_enable_option_fqdn => 'use_enable_option81',
                       override_ddns_generate_hostname  => 'use_generate_hostname',
                       override_ddns_ttl              => 'use_ddns_ttl',
                       override_domain_name           => 'use_domain_name',
                       override_domain_name_servers   => 'use_domain_name_servers',
                       override_enable_ddns           => 'use_enable_ddns',
                       override_options               => 'use_options',
                       override_preferred_lifetime    => 'use_preferred_lifetime',
                       override_update_dns_on_lease_renewal => 'use_update_dns_on_lease_renewal',
                       override_valid_lifetime        => 'use_lease_time',
                       valid_lifetime                 => 'lease_time',
                      );
    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           comment               => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           name                  => [\&ibap_o2i_string, 'name', 'REGEX'],
                           network_view          => [\&ibap_o2i_network_view ,'network_view', 'EXACT'],
                           extattrs              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                          );

    %_ibap_to_object = (
                        enable_option81           => \&ibap_i2o_boolean,
                        disabled                  => \&ibap_i2o_boolean,
                        domain_name_servers       => \&ibap_i2o_domain_name_servers,
                        enable_ddns               => \&ibap_i2o_boolean,
                        extensible_attributes     => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        generate_hostname         => \&ibap_i2o_boolean,
                        network_view              => \&ibap_i2o_generic_object_convert,
                        networks                  => \&ibap_i2o_generic_object_list_convert,
                        options                   => \&ibap_i2o_options,
                        update_dns_on_lease_renewal => \&ibap_i2o_boolean,
                        use_ddns_domainname       => \&ibap_i2o_boolean,
                        use_ddns_ttl              => \&ibap_i2o_boolean,
                        use_domain_name           => \&ibap_i2o_boolean,
                        use_domain_name_servers   => \&ibap_i2o_boolean,
                        use_enable_ddns           => \&ibap_i2o_boolean,
                        use_enable_option81       => \&ibap_i2o_boolean,
                        use_generate_hostname     => \&ibap_i2o_boolean,
                        use_lease_time            => \&ibap_i2o_boolean,
                        use_options               => \&ibap_i2o_boolean,
                        use_preferred_lifetime    => \&ibap_i2o_boolean,
                        use_update_dns_on_lease_renewal => \&ibap_i2o_boolean,
                       );

    %_object_to_ibap = (
                        comment                         => \&ibap_o2i_string,
                        ddns_domainname                 => \&ibap_o2i_string,
                        ddns_enable_option_fqdn         => \&ibap_o2i_boolean,
                        ddns_generate_hostname          => \&ibap_o2i_boolean,
                        ddns_ttl                        => \&ibap_o2i_uint,
                        disable                         => \&ibap_o2i_boolean,
                        domain_name                     => \&ibap_o2i_string,
                        domain_name_servers             => \&ibap_o2i_domain_name_servers,
                        enable_ddns                     => \&ibap_o2i_boolean,
                        extattrs                        => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes           => \&ibap_o2i_ignore,
                        name                            => \&ibap_o2i_string,
                        network_view                    => \&ibap_o2i_network_view,
                        networks                        => \&ibap_o2i_ipv6_network_list,
                        options                         => \&ibap_o2i_options,
                        override_ddns_domainname        => \&ibap_o2i_boolean,
                        override_ddns_enable_option_fqdn => \&ibap_o2i_boolean,
                        override_ddns_generate_hostname  => \&ibap_o2i_boolean,
                        override_ddns_ttl               => \&ibap_o2i_boolean,
                        override_domain_name            => \&ibap_o2i_boolean,
                        override_domain_name_servers    => \&ibap_o2i_boolean,
                        override_enable_ddns            => \&ibap_o2i_boolean,
                        override_options                => \&ibap_o2i_boolean,
                        override_preferred_lifetime     => \&ibap_o2i_boolean,
                        override_update_dns_on_lease_renewal => \&ibap_o2i_boolean,
                        override_valid_lifetime         => \&ibap_o2i_boolean,
                        preferred_lifetime              => \&ibap_o2i_uint,
                        update_dns_on_lease_renewal     => \&ibap_o2i_boolean,
                        valid_lifetime                  => \&ibap_o2i_uint,
                       );

    $_return_fields_initialized=0;
    %_return_field_overrides = (
                                comment                         => [],
                                ddns_domainname                 => ['use_ddns_domainname'],
                                ddns_enable_option_fqdn         => ['use_enable_option81'],
                                ddns_generate_hostname          => ['use_generate_hostname'],
                                ddns_ttl                        => ['use_ddns_ttl'],
                                disable                         => [],
                                domain_name                     => ['use_domain_name'],
                                domain_name_servers             => ['use_domain_name_servers'],
                                enable_ddns                     => ['use_enable_ddns'],
                                extattrs                        => [],
                                extensible_attributes           => [],
                                name                            => [],
                                network_view                    => [],
                                networks                        => [],
                                options                         => ['use_options'],
                                override_ddns_domainname        => [],
                                override_ddns_enable_option_fqdn => [],
                                override_ddns_generate_hostname => [],
                                override_ddns_ttl               => [],
                                override_domain_name            => [],
                                override_domain_name_servers    => [],
                                override_enable_ddns            => [],
                                override_options                => [],
                                override_preferred_lifetime     => [],
                                override_update_dns_on_lease_renewal => [],
                                override_valid_lifetime         => [],
                                preferred_lifetime              => ['use_preferred_lifetime'],
                                update_dns_on_lease_renewal     => ['use_update_dns_on_lease_renewal'],
                                valid_lifetime                  => ['use_lease_time'],
                               );


    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('comment'),
                       tField('ddns_domainname'),
                       tField('ddns_ttl'),
                       tField('disabled'),
                       tField('domain_name'),
                       tField('domain_name_servers', { sub_fields => [ tField('address')]}),
                       tField('enable_ddns'),
                       tField('enable_option81'),
                       return_fields_extensible_attributes(),
                       tField('generate_hostname'),
                       tField('lease_time'),
                       tField('name'),
                       tField('options'),
                       tField('preferred_lifetime'),
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
                       tField('use_update_dns_on_lease_renewal'),
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

        #
        my $tmp_nv = Infoblox::DHCP::View->__new__();
        push @_return_fields, tField('network_view', {
                default_no_access_ok => 1,
                sub_fields => $tmp_nv->__return_fields__(),
            });
        my $tmp_net = Infoblox::DHCP::IPv6Network->__new__();
        push @_return_fields, tField('networks', {
                default_no_access_ok => 1,
                sub_fields => $tmp_net->__return_fields__(),
            });
    }
}

sub __ibap_object_type__
{
    #
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

    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};
    $$ibap_object_ref{'enable_ddns'} = 0 unless defined $$ibap_object_ref{'enable_ddns'};
    $$ibap_object_ref{'enable_option81'} = 0 unless defined $$ibap_object_ref{'enable_option81'};
    $$ibap_object_ref{'generate_hostname'} = 0 unless defined $$ibap_object_ref{'generate_hostname'};
    $$ibap_object_ref{'update_dns_on_lease_renewal'} = 0 unless defined $$ibap_object_ref{'update_dns_on_lease_renewal'};
    $$ibap_object_ref{'use_ddns_domainname'} = 0 unless defined $$ibap_object_ref{'use_ddns_domainname'};
    $$ibap_object_ref{'use_ddns_ttl'} = 0 unless defined $$ibap_object_ref{'use_ddns_ttl'};
    $$ibap_object_ref{'use_domain_name'} = 0 unless defined $$ibap_object_ref{'use_domain_name'};
    $$ibap_object_ref{'use_domain_name_servers'} = 0 unless defined $$ibap_object_ref{'use_domain_name_servers'};
    $$ibap_object_ref{'use_enable_ddns'} = 0 unless defined $$ibap_object_ref{'use_enable_ddns'};
    $$ibap_object_ref{'use_enable_option81'} = 0 unless defined $$ibap_object_ref{'use_enable_option81'};
    $$ibap_object_ref{'use_generate_hostname'} = 0 unless defined $$ibap_object_ref{'use_generate_hostname'};
    $$ibap_object_ref{'use_lease_time'} = 0 unless defined $$ibap_object_ref{'use_lease_time'};
    $$ibap_object_ref{'use_options'} = 0 unless defined $$ibap_object_ref{'use_options'};
    $$ibap_object_ref{'use_preferred_lifetime'} = 0 unless defined $$ibap_object_ref{'use_preferred_lifetime'};
    $$ibap_object_ref{'use_update_dns_on_lease_renewal'} = 0 unless defined $$ibap_object_ref{'use_update_dns_on_lease_renewal'};

    #
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'override_ddns_domainname'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_domainname'});
    $self->{'override_ddns_ttl'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_ttl'});
    $self->{'override_domain_name'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_domain_name'});
    $self->{'override_domain_name_servers'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_domain_name_servers'});
    $self->{'override_enable_ddns'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_ddns'});
    $self->{'override_ddns_generate_hostname'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_generate_hostname'});
    $self->{'override_ddns_enable_option_fqdn'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_option81'});
    $self->{'override_options'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_options'});
    $self->{'override_preferred_lifetime'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_preferred_lifetime'});
    $self->{'override_update_dns_on_lease_renewal'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_update_dns_on_lease_renewal'});
    $self->{'override_valid_lifetime'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_lease_time'});

    return;
}

#
#
#

#
#
#

1;
