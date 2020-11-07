package Infoblox::MasterGrid::Grid;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw( @ISA $_object_type %_allowed_members %_return_field_overrides
             @_return_fields %_searchable_fields %_object_to_ibap
             %_name_mappings %_reverse_name_mappings %_ibap_to_object
             %_capabilities);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE);

BEGIN {
    $_object_type = 'SuperGrid';
    register_wsdl_type('ib:SuperGrid', 'Infoblox::MasterGrid::Grid');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         connection_timestamp => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         detached             => {readonly => 1, simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         enabled              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         joined               => {readonly => 1, simple => 'bool', readonly => 1, validator => \&ibap_value_o2i_boolean},
                         last_event_details   => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         last_event           => {readonly => 1, validator => \&ibap_value_o2i_string},
                         last_sync_timestamp  => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         address              => {simple => 'asis', validator => \&ibap_value_o2i_string}, # Can also be fqdn, so do not validate for ipaddr
                         port                 => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         status               => {readonly => 1, validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       last_event_details => 'last_sgm_event_details',
                       last_event         => 'last_sgm_event',
                       address            => 'sgm_address',
                       port               => 'sgm_port',
                       enabled            => 'service_enabled',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                connection_timestamp => [],
                                detached             => [],
                                enabled              => [],
                                joined               => [],
                                last_event_details   => [],
                                last_event           => [],
                                last_sync_timestamp  => [],
                                address              => [],
                                port                 => [],
                                status               => [],
                               );

    %_searchable_fields = (
                           address => [\&ibap_o2i_string  ,'sgm_address'  , 'REGEX'],
                           port    => [\&ibap_o2i_uint    ,'sgm_port'     , 'EXACT'],
                          );

    %_ibap_to_object = (
                        service_enabled    => \&ibap_i2o_boolean,
                        joined             => \&ibap_i2o_boolean,
                        last_sgm_event     => \&ibap_i2o_enums_lc_or_undef,
                        status             => \&ibap_i2o_enums_lc_or_undef,
                       );


    %_object_to_ibap = (
                        connection_timestamp => \&ibap_o2i_ignore,
                        detached             => \&ibap_o2i_ignore,
                        enabled              => \&ibap_o2i_boolean,
                        joined               => \&ibap_o2i_ignore,
                        last_event_details   => \&ibap_o2i_ignore,
                        last_event           => \&ibap_o2i_ignore,
                        last_sync_timestamp  => \&ibap_o2i_ignore,
                        address              => \&ibap_o2i_string,
                        port                 => \&ibap_o2i_uint,
                        status               => \&ibap_o2i_ignore,
                       );

    @_return_fields = (
                       tField('connection_timestamp'),
                       tField('service_enabled'),
                       tField('detached'),
                       tField('joined'),
                       tField('last_sgm_event_details'),
                       tField('last_sgm_event'),
                       tField('last_sync_timestamp'),
                       tField('sgm_address'),
                       tField('sgm_port'),
                       tField('status'),
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
    $$ibap_object_ref{'service_enabled'}  = 0 unless defined $$ibap_object_ref{'service_enabled'};
    $$ibap_object_ref{'joined'}           = 0 unless defined $$ibap_object_ref{'joined'};
    $$ibap_object_ref{'detached'}         = 0 unless defined $$ibap_object_ref{'detached'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    return;
}

#
#
#

#
#
#

1;
