package Infoblox::DHCP::Fingerprint;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object
                 %_name_mappings %_reverse_name_mappings %_object_to_ibap
                 @_return_fields %_capabilities %_searchable_fields
                 %_return_field_overrides $_return_fields_initialized $_unique_readfield);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'DhcpFingerprint';
    register_wsdl_type('ib:DhcpFingerprint', 'Infoblox::DHCP::Fingerprint');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'device_class'      => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'comment'           => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'name'              => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'disable'           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'option_sequence'   => {array => 1, validator => \&ibap_value_o2i_string},
                         'ipv6_option_sequence' => {array => 1, validator => \&ibap_value_o2i_string},
                         'type'              => {simple => 'asis', enum => ['STANDARD', 'CUSTOM']},
                         'vendor_id'         => {array => 1, validator => \&ibap_value_o2i_string},
                         'extattrs'              => {special => 'extensible_attributes'},
                         'extensible_attributes' => {special => 'extensible_attributes'},
                        );

    $_unique_readfield = 'name';

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'disable'  => 'disabled',
                       'extattrs' => 'extensible_attributes',
                      );

    %_return_field_overrides = (
                                'device_class'      => [],
                                'comment'           => [],
                                'name'              => [],
                                'disabled'          => [],
                                'option_sequence'   => [],
                                'type'              => [],
                                'vendor_id'         => [],
                                'extattrs'          => [],
                                'extensible_attributes' => [],
                               );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('device_class'),
                       tField('comment'),
                       tField('name'),
                       tField('disabled'),
                       tField('option_sequence', {depth => 1}),
                       tField('type'),
                       tField('vendor_id'),
                       return_fields_extensible_attributes(),
                      );

    %_ibap_to_object = (
                        'disabled' => \&ibap_i2o_boolean,
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                       );

    %_object_to_ibap = (
                        'device_class'      => \&ibap_o2i_string,
                        'comment'           => \&ibap_o2i_string,
                        'name'              => \&ibap_o2i_string,
                        'disable'           => \&ibap_o2i_boolean,
                        'option_sequence'   => \&ibap_o2i_ignore,
                        'ipv6_option_sequence' => \&ibap_o2i_ignore,
                        'type'              => \&ibap_o2i_string,
                        'vendor_id'         => \&ibap_o2i_string_array_undef_to_empty,
                        'protocol'          => \&ibap_o2i_string,
                        'extattrs'          => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes' => \&ibap_o2i_ignore,
                       );

    %_searchable_fields = (
                           'device_class'      => [\&ibap_o2i_string, 'device_class', 'REGEX', 'IGNORE_CASE'],
                           'comment'           => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           'name'              => [\&ibap_o2i_string, 'name', 'REGEX', 'IGNORE_CASE'],
                           'type'              => [\&ibap_o2i_string, 'type', 'EXACT'],
                           'extattrs'          => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                          );
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    if (!defined $args{'option_sequence'} and !defined $args{'ipv6_option_sequence'} and !defined $args{'vendor_id'}) {
        set_error_codes(1103, 'At least one of option_sequence and vendor_id is required.');
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

    return $self;
}

sub __init_instance_constants__
{
    my $self = shift;

    $self->type('CUSTOM') unless $self->type();
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

    #
    if (defined $ibap_object_ref->{'option_sequence'}) {
        foreach (@{$ibap_object_ref->{'option_sequence'}}) {
            if (ref($_) eq 'ib:dhcp_option_fingerprint') {
                if (ibap_value_i2o_boolean($_->{'is_ipv4'}) eq 'true') {
                    $self->{'option_sequence'} = [] unless defined $self->{'option_sequence'};
                    push @{$self->{'option_sequence'}}, $_->{'option_sequence'};
                } else {
                    $self->{'ipv6_option_sequence'} = [] unless defined $self->{'ipv6_option_sequence'};
                    push @{$self->{'ipv6_option_sequence'}}, $_->{'option_sequence'};
                }
            }
        }
        delete $ibap_object_ref->{'option_sequence'};
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __object_to_ibap__
{
    my ($self, $server, $session, $skipref) = @_;

    my $res = $self->SUPER::__object_to_ibap__($server, $session, $skipref);

    #
    my @newlist;
    foreach my $ipv4 (0..1) {
        my $member = $ipv4 ? 'option_sequence' : 'ipv6_option_sequence';
        if (defined ($self->{$member})) {
            foreach (@{$self->{$member}}) {
                if (ibap_value_o2i_string($_, $member, $session, 1)) {
                    push @newlist, {'option_sequence' => tString($_), 'is_ipv4' => tBool($ipv4)};
                } else {
                    return;
                }
            }
        }
    }
    push @$res, {'field' => 'option_sequence', 'value' => tIBType('ArrayOfdhcp_option_fingerprint', \@newlist)};

    return $res;
}

#
#
#

sub __add_override_hook__ {
    my ($object_type, $session, $object) = @_;

    if ($object->type() ne 'CUSTOM') {
        return set_error_codes(1008, "'add' not allowed for this object", $session);
    }

    return set_error_codes(9999, 'continue', $session);
}

sub __remove_override_hook__ {
    my ($object_type, $session, $object) = @_;

    if ($object->type() ne 'CUSTOM') {
        return set_error_codes(1008, "'remove' not allowed for this object", $session);
    }

    return set_error_codes(9999, 'continue', $session);
}

package Infoblox::DHCP::Filter::Fingerprint;

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
    $_object_type = 'DhcpFingerprintFilter';
    register_wsdl_type('ib:DhcpFingerprintFilter', 'Infoblox::DHCP::Filter::Fingerprint');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'comment'     => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'fingerprint' => {array => 1, mandatory => 1, validator => {'Infoblox::DHCP::Fingerprint' => 1}},
                         'name'        => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'extattrs'              => {special => 'extensible_attributes'},
                         'extensible_attributes' => {special => 'extensible_attributes'},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'extattrs' => 'extensible_attributes',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                'comment'     => [],
                                'fingerprint' => [],
                                'name'        => [],
                                'extattrs'    => [],
                                'extensible_attributes' => [],
                               );

    @_return_fields = (
                       tField('comment'),
                       tField('name'),
                       return_fields_extensible_attributes(),
                      );

    %_ibap_to_object = (
                        'fingerprint' => \&ibap_i2o_generic_object_list_convert,
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                       );

    %_object_to_ibap = (
                        'comment'     => \&ibap_o2i_string,
                        'fingerprint' => \&ibap_o2i_object_by_oid_or_readfield,
                        'name'        => \&ibap_o2i_string,
                        'extattrs'              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes' => \&ibap_o2i_ignore,
                       );

    %_searchable_fields = (
                           'name'      => [\&ibap_o2i_string, 'name', 'REGEX', 'IGNORE_CASE'],
                           'comment'   => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           'extattrs'  => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
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

    unless ($_return_fields_initialized) {
        $_return_fields_initialized = 1;

        my $t = Infoblox::DHCP::Fingerprint->__new__();
        push @_return_fields, tField('fingerprint', {
                                        sub_fields => $t->__return_fields__(),
                                    });
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
