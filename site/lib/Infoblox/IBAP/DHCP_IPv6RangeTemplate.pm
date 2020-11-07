package Infoblox::DHCP::IPv6RangeTemplate;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members %_return_field_overrides
             @_return_fields %_searchable_fields %_object_to_ibap
             %_name_mappings %_reverse_name_mappings %_ibap_to_object
             $_return_fields_initialized %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'IPv6DhcpRangeTemplate';
    register_wsdl_type('ib:IPv6DhcpRangeTemplate', 'Infoblox::DHCP::IPv6RangeTemplate');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         comment                 => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         exclude                 => {array => 1, validator => {'Infoblox::DHCP::ExclusionRangeTemplate' => 1}},
                         extattrs                => {special => 'extensible_attributes'},
                         extensible_attributes   => {special => 'extensible_attributes'},
                         member                  => {validator => { 'Infoblox::DHCP::Member' => 1}},
                         name                    => {simple => 'asis', validator => \&ibap_value_o2i_string, mandatory => 1},
                         number_of_addresses     => {simple => 'asis', validator => \&ibap_value_o2i_uint, mandatory => 1},
                         offset                  => {simple => 'asis', validator => \&ibap_value_o2i_uint, mandatory => 1},
                         override_recycle_leases => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         recycle_leases          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_recycle_leases', use_truefalse => 1},
                         server_association_type => {simple => 'asis', enum => [ 'NONE', 'MEMBER']},
                         delegated_member        => {validator => {'Infoblox::DHCP::Member' => 1}},
                         cloud_api_compatible    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'exclude'                 => 'exclusion_ranges',
                       'extattrs'                => 'extensible_attributes',
                       'override_recycle_leases' => 'use_recycle_leases',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                comment                 => [],
                                exclude                 => [],
                                extattrs                => [],
                                extensible_attributes   => [],
                                member                  => [],
                                name                    => [],
                                number_of_addresses     => [],
                                offset                  => [],
                                override_recycle_leases => [],
                                recycle_leases          => ['use_recycle_leases'],
                                server_association_type => [],
                                delegated_member        => [],
                                cloud_api_compatible    => [],
                               );

    %_searchable_fields = (
                           comment               => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           extattrs              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           member                => [\&ibap_o2i_member_search, 'member', 'EXACT'],
                           name                  => [\&ibap_o2i_string, 'name', 'REGEX'],
						   server_association_type => [\&ibap_o2i_string     ,'server_association_type', 'EXACT'],
                          );

    %_ibap_to_object = (
                        exclusion_ranges      => \&ibap_i2o_exclusion_template,
                        extensible_attributes => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        member                => \&ibap_i2o_mixed_member,
                        recycle_leases        => \&ibap_i2o_boolean,
                        use_recycle_leases    => \&ibap_i2o_boolean,
                        delegated_member      => \&ibap_i2o_mixed_member,
                        cloud_api_compatible  => \&ibap_i2o_boolean,
                       );


    %_object_to_ibap = (
                         comment                 => \&ibap_o2i_string,
                         exclude                 => \&ibap_o2i_exclusion_template,
                         extattrs                => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                         extensible_attributes   => \&ibap_o2i_ignore,
                         member                  => \&__o2i_member__,
                         name                    => \&ibap_o2i_string,
                         number_of_addresses     => \&ibap_o2i_uint,
                         offset                  => \&ibap_o2i_uint,
                         override_recycle_leases => \&ibap_o2i_boolean,
                         recycle_leases          => \&ibap_o2i_boolean,
                         server_association_type => \&ibap_o2i_string,
                         delegated_member        => \&ibap_o2i_delegated_member,
                         cloud_api_compatible    => \&ibap_o2i_boolean,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('comment'),
                       tField('exclusion_ranges', { depth => 1}),
                       return_fields_extensible_attributes(),
                       tField('member', return_fields_member_basic_data_no_access_ok()),
                       tField('name'),
                       tField('number_of_addresses'),
                       tField('offset'),
                       tField('recycle_leases'),
                       tField('server_association_type'),
                       tField('use_recycle_leases'),
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

    $self->{__object_id_cache__} = {};

    #
    unless (defined $self->recycle_leases()) {
        $self->recycle_leases('true');
        $self->override_recycle_leases('false'); # reset the override
    }
    $self->server_association_type('NONE') unless defined $self->server_association_type();
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

    #
    $$ibap_object_ref{'recycle_leases'}       = 0 unless defined $$ibap_object_ref{'recycle_leases'};
    $$ibap_object_ref{'use_recycle_leases'}   = 0 unless defined $$ibap_object_ref{'use_recycle_leases'};
    $$ibap_object_ref{'cloud_api_compatible'} = 0 unless defined $$ibap_object_ref{'cloud_api_compatible'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'override_recycle_leases'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_recycle_leases'});

    return;
}

#
#
#

sub __o2i_member__
{
	my ($self, $session, $current, $tempref, $type) = @_;

    if($tempref->{$current}) {
        return (1,0,ibap_value_o2i_member($$tempref{$current}, $session, $self, $current,1));
    } else {
        return (1,0,undef);
    }
}


#
#
#
1;
