package Infoblox::DHCP::IPv6FixedAddrTemplate;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object $_return_fields_initialized @_sub_host_address_fields %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase);


BEGIN {
    $_object_type = 'IPv6FixedAddressTemplate';
    register_wsdl_type('ib:IPv6FixedAddressTemplate','Infoblox::DHCP::IPv6FixedAddrTemplate');

    %_capabilities = (
                      'depth'                  => 0,
                      'implicit_defaults'      => 1,
                      'single_serialization'   => 1,
                     );

    %_allowed_members = (
                         comment                        => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         domain_name                    => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_domain_name', use_truefalse => 1},
                         domain_name_servers            => {validator => \&ibap_value_o2i_string, use => 'override_domain_name_servers', use_truefalse => 1},
                         extattrs                       => {special => 'extensible_attributes'},
                         extensible_attributes          => {special => 'extensible_attributes'},
                         name                           => {simple => 'asis', validator => \&ibap_value_o2i_string, mandatory => 1},
                         number_of_addresses            => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         offset                         => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         options                        => {array => 1, validator => { 'Infoblox::DHCP::Option' => 1}, use => 'override_options', use_truefalse => 1},
                         override_domain_name           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_domain_name_servers   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_options               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_preferred_lifetime    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_valid_lifetime        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         preferred_lifetime             => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_preferred_lifetime', use_truefalse => 1},
                         valid_lifetime                 => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_valid_lifetime', use_truefalse => 1},
                         cloud_api_compatible           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       extattrs                       => 'extensible_attributes',
                       override_domain_name           => 'use_domain_name',
                       override_domain_name_servers   => 'use_domain_name_servers',
                       override_options               => 'use_options',
                       override_preferred_lifetime    => 'use_preferred_lifetime',
                       override_valid_lifetime        => 'use_lease_time',
                       valid_lifetime                 => 'lease_time',
                      );
    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           comment               => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           extattrs              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           name                  => [\&ibap_o2i_string, 'name', 'REGEX'],
                          );

    %_ibap_to_object = (
                        domain_name_servers       => \&ibap_i2o_domain_name_servers,
                        extensible_attributes     => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        options                   => \&ibap_i2o_options,
                        use_domain_name           => \&ibap_i2o_boolean,
                        use_domain_name_servers   => \&ibap_i2o_boolean,
                        use_lease_time            => \&ibap_i2o_boolean,
                        use_options               => \&ibap_i2o_boolean,
                        use_preferred_lifetime    => \&ibap_i2o_boolean,
                        cloud_api_compatible      => \&ibap_i2o_boolean,
                       );

    %_object_to_ibap = (
                        comment                         => \&ibap_o2i_string,
                        domain_name                     => \&ibap_o2i_string,
                        domain_name_servers             => \&ibap_o2i_domain_name_servers,
                        extattrs                        => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes           => \&ibap_o2i_ignore,
                        name                            => \&ibap_o2i_string,
                        number_of_addresses             => \&ibap_o2i_uint,
                        offset                          => \&ibap_o2i_uint,
                        options                         => \&ibap_o2i_options,
                        override_domain_name            => \&ibap_o2i_boolean,
                        override_domain_name_servers    => \&ibap_o2i_boolean,
                        override_options                => \&ibap_o2i_boolean,
                        override_preferred_lifetime     => \&ibap_o2i_boolean,
                        override_valid_lifetime         => \&ibap_o2i_boolean,
                        preferred_lifetime              => \&ibap_o2i_uint,
                        valid_lifetime                  => \&ibap_o2i_uint,
                        cloud_api_compatible            => \&ibap_o2i_boolean,
                       );

    $_return_fields_initialized=0;
    %_return_field_overrides = (
                                comment                         => [],
                                domain_name                     => ['use_domain_name'],
                                domain_name_servers             => ['use_domain_name_servers'],
                                extattrs                        => [],
                                extensible_attributes           => [],
                                name                            => [],
                                number_of_addresses             => [],
                                offset                          => [],
                                options                         => ['use_options'],
                                override_domain_name            => [],
                                override_domain_name_servers    => [],
                                override_options                => [],
                                override_preferred_lifetime     => [],
                                override_valid_lifetime         => [],
                                preferred_lifetime              => ['use_preferred_lifetime'],
                                valid_lifetime                  => ['use_lease_time'],
                                cloud_api_compatible            => [],
                               );


    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('comment'),
                       tField('domain_name'),
                       tField('domain_name_servers', { sub_fields => [ tField('address')]}),
                       return_fields_extensible_attributes(),
                       tField('lease_time'),
                       tField('name'),
                       tField('number_of_addresses'),
                       tField('offset'),
                       tField('options'),
                       tField('preferred_lifetime'),
                       tField('use_domain_name'),
                       tField('use_domain_name_servers'),
                       tField('use_lease_time'),
                       tField('use_options'),
                       tField('use_preferred_lifetime'),
                       tField('cloud_api_compatible'),
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
    }

    $self->{'preferred_lifetime'} = 27000 unless defined $self->preferred_lifetime();
    $self->{'valid_lifetime'} = 43200 unless defined $self->valid_lifetime();
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

    $$ibap_object_ref{'use_domain_name'} = 0 unless defined $$ibap_object_ref{'use_domain_name'};
    $$ibap_object_ref{'use_domain_name_servers'} = 0 unless defined $$ibap_object_ref{'use_domain_name_servers'};
    $$ibap_object_ref{'use_lease_time'} = 0 unless defined $$ibap_object_ref{'use_lease_time'};
    $$ibap_object_ref{'use_options'} = 0 unless defined $$ibap_object_ref{'use_options'};
    $$ibap_object_ref{'use_preferred_lifetime'} = 0 unless defined $$ibap_object_ref{'use_preferred_lifetime'};
    $$ibap_object_ref{'cloud_api_compatible'} = 0 unless defined $$ibap_object_ref{'cloud_api_compatible'};

    #
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'override_domain_name'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_domain_name'});
    $self->{'override_domain_name_servers'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_domain_name_servers'});
    $self->{'override_valid_lifetime'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_lease_time'});
    $self->{'override_options'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_options'});
    $self->{'override_preferred_lifetime'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_preferred_lifetime'});

    return;
}

#
#
#

#
#
#

1;
