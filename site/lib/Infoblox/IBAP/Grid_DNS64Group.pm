package Infoblox::Grid::DNS::DNS64Group;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object %_return_field_overrides %_capabilities $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'Dns64SynthesisGroup';
    register_wsdl_type('ib:Dns64SynthesisGroup','Infoblox::Grid::DNS::DNS64Group');

    %_capabilities = (
                      'depth'                  => 0,
                      'implicit_defaults'      => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         clients               => 0,
                         comment               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         disable               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         dnssec_dns64_enabled  => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         exclude               => 0,
                         extattrs              => {special => 'extensible_attributes'},
                         extensible_attributes => {special => 'extensible_attributes'},
                         mapped                => 0,
                         name                  => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         prefix                => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_ipv6_network},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'disable' => 'disabled',
                       'extattrs' => 'extensible_attributes',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           comment               => [\&ibap_o2i_string ,'comment'      , 'REGEX', 'IGNORE_CASE'],
                           extattrs              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           name                  => [\&ibap_o2i_string ,'name'         , 'REGEX'],
                           prefix                => [\&ibap_o2i_string ,'prefix'         , 'REGEX', 'GET_IGNORE_CASE'],
                          );

    %_ibap_to_object = (
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'clients'               => \&ibap_i2o_ac_setting,
                        'exclude'               => \&ibap_i2o_ac_setting,
                        'mapped'                => \&ibap_i2o_ac_setting,
                       );

    %_object_to_ibap = (
                        'clients'               => \&ibap_o2i_ac_setting,
                        'comment'               => \&ibap_o2i_string,
                        'disable'               => \&ibap_o2i_boolean,
                        'dnssec_dns64_enabled'  => \&ibap_o2i_boolean,
                        'exclude'               => \&ibap_o2i_ac_setting,
                        'extattrs'              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes' => \&ibap_o2i_ignore,
                        'mapped'                => \&ibap_o2i_ac_setting,
                        'name'                  => \&ibap_o2i_string,
                        'prefix'                => \&ibap_o2i_string,
                       );

    %_return_field_overrides = (
                                'clients'               => [],
                                'comment'               => [],
                                'disable'               => [],
                                'dnssec_dns64_enabled'  => [],
                                'exclude'               => [],
                                'extattrs'              => [],
                                'extensible_attributes' => [],
                                'mapped'                => [],
                                'name'                  => [],
                                'prefix'                => [],
                               );

    @_return_fields = (
                       tField('comment'),
                       tField('disabled'),
                       tField('dnssec_dns64_enabled'),
                       tField('name'),
                       tField('prefix'),
                       return_fields_extensible_attributes(),
                      );

    $_return_fields_initialized = 0;
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    if( (not defined $args{ 'ipv6addr' }) && (not defined $args { 'ipv6prefix' } || not defined $args { 'ipv6prefix_bits' }) )
    {
        set_error_codes(1103,"At least one of ipv6addr and ipv6prefix/ipv6prefix_bits is required." );
        return;
    }

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
        $_return_fields_initialized = 1;

        my $tmp = Infoblox::Grid::NamedACL->__new__();
        foreach ('clients', 'exclude', 'mapped') {
            push @_return_fields, tField($_, return_fields_ac_setting($tmp->__return_fields__()));
        }
    }

    #
    $self->clients([]) unless defined $self->clients();
    $self->exclude([]) unless defined $self->exclude();
    $self->mapped([]) unless defined $self->mapped();
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

    $$ibap_object_ref{'disabled'}               = 0 unless defined $$ibap_object_ref{'disabled'};
    $$ibap_object_ref{'dnssec_dns64_enabled'}   = 0 unless defined $$ibap_object_ref{'dnssec_dns64_enabled'};

    #
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    return;
}

#
#
#

#
#
#

sub clients
{
    my $self = shift;
    return $self->ibap_accessor_ac_setting('clients', 0, {}, @_);
}

sub exclude
{
    my $self = shift;
    return $self->ibap_accessor_ac_setting('exclude', 0, {}, @_);
}

sub mapped
{
    my $self = shift;
    return $self->ibap_accessor_ac_setting('mapped', 0, {}, @_);
}

1;
