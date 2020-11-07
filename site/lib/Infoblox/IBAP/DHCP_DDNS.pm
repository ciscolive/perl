package Infoblox::DHCP::DDNS;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA %_allowed_members %_name_mappings %_reverse_name_mappings @_return_fields %_object_to_ibap %_ibap_to_object $_object_type);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'ddns_zone_primary';
    register_wsdl_type('ib:ddns_zone_primary', 'Infoblox::DHCP::DDNS');
    %_allowed_members = (
                         'dns_ext_zone'     => {'validator' => \&ibap_value_o2i_string},
                         'dns_grid_zone'    => {'validator' => \&ibap_value_o2i_string},
                         'view'             => {'validator' => \&ibap_value_o2i_string},
                         'external_primary' => {'validator' => \&ibap_value_o2i_ipaddr},
                         'grid_primary'     => {'validator' => \&ibap_value_o2i_string},
                         'zone_match'       => {'mandatory' => 1, 'enum' => ['ANY_EXTERNAL', 'ANY_GRID', 'EXTERNAL', 'GRID']},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'grid_primary'     => 'dns_grid_primary',
                       'external_primary' => 'dns_ext_primary',
                       'view'             => 'dns_view',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('dns_grid_primary', { sub_fields => [tField('host_name')] }),
                       tField('dns_grid_zone', { sub_fields => [tField('fqdn')] }),
                       tField('dns_view', { sub_fields => [tField('name')] }),
                       tField('dns_ext_primary'),
                       tField('dns_ext_zone'),
                       tField('zone_match'),
                      );

    %_object_to_ibap = (
                        'grid_primary'     => \&ibap_o2i_member_byhostname,
                        'dns_grid_zone'    => \&__o2i_grid_zone__,
                        'view'             => \&ibap_o2i_view,
                        'dns_ext_zone'     => \&ibap_o2i_string,
                        'external_primary' => \&ibap_o2i_string,
                        'zone_match'       => \&ibap_o2i_string,
                       );

    %_ibap_to_object = (
                        'dns_grid_primary' => \&ibap_i2o_member_byhostname,
                        'dns_grid_zone'    => \&__i2o_grid_zone__,
                        'dns_view'         => \&ibap_i2o_object_name,
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

    return $self;
}

sub __o2i_grid_zone__
{
    my ($self, $session, $current, $tempref, $type) = @_;

    if($tempref->{$current}) {
        my @fields;

        push @fields, {
            'search_type' => 'EXACT',
            'field' => 'fqdn',
            'value' => ibap_value_o2i_string($tempref->{$current}),
        };

        if (defined $self->{'view'}) {
            push @fields, {
                'search_type' => 'EXACT',
                'field' => 'view',
                'value' => ibap_readfield_simple_string('View', 'name', $self->{'view'}, 'view'),
            };
        } else {
            push @fields, {
                'search_type' => 'EXACT',
                'field' => 'view',
                'value' => ibap_readfield_simple('View', 'is_default', tBool(1), 'view=(default view)'),
            };
        }

        return (1, 0, ibap_readfield_simple('AllZone', \@fields, undef, 'zone=' . $current));
    } else {
        return (1, 0, undef);
    }
}

sub __i2o_grid_zone__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return $ibap_object_ref->{$current}->{'fqdn'};
}

sub __ibap_object_type__ {

    return $_object_type;
}

1;
