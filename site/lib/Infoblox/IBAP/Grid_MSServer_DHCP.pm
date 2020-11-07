package Infoblox::Grid::MSServer::DHCP;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE);

BEGIN {
    $_object_type = 'MsServerDhcp';
    register_wsdl_type('ib:MsServerDhcp','Infoblox::Grid::MSServer::DHCP');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members =
      (
       address                    => -1,
       authoritative              => 0,
       broadcast_address          => 0,
       comment                    => -1,
       ddns_server_always_updates => 0,
       dhcp_utilization           => -1,
       dhcp_utilization_status    => -1,
       domain_name                => 0,
       domain_name_servers        => 0,
       dynamic_hosts              => -1,
       enable_ddns                => 0,
       enable_dhcp                => 0,
       enable_thresholds          => 0,
       extattrs                   => -1,
       extensible_attributes      => -1,
       enable_monitoring          => 0,
       override_enable_monitoring => 0,
       enable_invalid_mac          => 0,
       override_enable_invalid_mac => 0,
       last_sync_detail           => -1,
       last_sync_status           => -1,
       last_sync_ts               => -1,
       log_lease_events           => 0,
       manage_dhcp                => 0,
       ms_options                 => {validator => {'Infoblox::DHCP::MSOption' => 1}, array => 1, skip_accessor => 1},
       name                       => -1,
       override_enable_thresholds => 0,
       override_log_lease_events  => 0,
       range_high_water_mark      => 0,
       range_high_water_mark_reset => 0,
       range_low_water_mark       => 0,
       range_low_water_mark_reset => 0,
       read_only                  => -1,
       routers                    => 0,
       static_hosts               => -1,
       status                     => -1,
       status_detail              => -1,
       status_last_updated        => -1,
       supports_failover          => -1,
       login_name                        => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_login', use_truefalse => 1},
       login_password                    => {simple => 'asis', writeonly => 1, validator => \&ibap_value_o2i_string},
       override_login                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       override_synchronization_interval => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       synchronization_interval          => {simple => 'asis', validator => \&ibap_value_o2i_uint,
                                             use => 'override_synchronization_interval', use_truefalse => 1},
      );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings =
      (
       address                           => 'server_address',
       authoritative                     => 'is_authoritative',
       ddns_server_always_updates        => 'always_update_dns',
       enable_dhcp                       => 'next_sync_control',
       manage_dhcp                       => 'managed',
       name                              => 'parent',
       override_enable_thresholds        => 'use_enable_thresholds',
       override_log_lease_events         => 'use_log_lease_events',
       extattrs                          => 'extensible_attributes',
       override_enable_monitoring        => 'use_enable_monitoring',
       override_enable_invalid_mac       => 'use_enable_invalid_mac',
       override_login                    => 'use_login',
       override_synchronization_interval => 'use_synchronization_min_delay',
       synchronization_interval          => 'synchronization_min_delay',
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
						   address               => [\&ibap_o2i_string,'server_address' , 'REGEX'],
                           extattrs              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                          );

	%_return_field_overrides =
      (
       address                           => [],
       authoritative                     => [],
       broadcast_address                 => [],
       comment                           => [],
       ddns_server_always_updates        => [],
       dhcp_utilization                  => [],
       dhcp_utilization_status           => [],
       domain_name                       => [],
       domain_name_servers               => [],
       dynamic_hosts                     => [],
       enable_ddns                       => [],
       enable_dhcp                       => [],
       enable_thresholds                 => [],
       enable_monitoring                 => ['use_enable_monitoring'],
       override_enable_monitoring        => [],
       enable_invalid_mac                => ['use_enable_invalid_mac'],
       override_enable_invalid_mac       => [],
       extattrs                          => [],
       extensible_attributes             => [],
       last_sync_detail                  => [],
       last_sync_status                  => [],
       last_sync_ts                      => [],
       log_lease_events                  => [],
       manage_dhcp                       => [],
       ms_options                        => [],
       name                              => [],
       override_enable_thresholds        => [],
       override_log_lease_events         => [],
       range_high_water_mark             => [],
       range_high_water_mark_reset       => [],
       range_low_water_mark              => [],
       range_low_water_mark_reset        => [],
       read_only                         => [],
       routers                           => [],
       static_hosts                      => [],
       status                            => [],
       status_detail                     => [],
       status_last_updated               => [],
       supports_failover                 => [],
       login_name                        => ['use_login'],
       override_login                    => [],
       override_synchronization_interval => [],
       synchronization_interval          => ['use_synchronization_min_delay'],
      );

    %_ibap_to_object =
      (
       always_update_dns             => \&ibap_i2o_boolean,
       dhcp_utilization_status       => \&ibap_i2o_enums_ucfirst_or_undef,
       domain_name_servers           => \&__i2o_address__,
       enable_ddns                   => \&ibap_i2o_boolean,
       enable_thresholds             => \&ibap_i2o_boolean,
       extensible_attributes         => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
       enable_monitoring             => \&ibap_i2o_boolean,
       use_enable_monitoring         => \&ibap_i2o_boolean,
       enable_invalid_mac            => \&ibap_i2o_boolean,
       use_enable_invalid_mac        => \&ibap_i2o_boolean,
       is_authoritative              => \&ibap_i2o_boolean,
       last_sync_status              => \&ibap_i2o_enums_ucfirst_or_undef,
       log_lease_events              => \&ibap_i2o_boolean,
       managed                       => \&ibap_i2o_boolean,
       ms_options                    => \&ibap_i2o_generic_object_list_convert,
       parent                        => \&__i2o_name__,
       read_only                     => \&ibap_i2o_boolean,
       routers                       => \&__i2o_address__,
       status                        => \&ibap_i2o_enums_ucfirst_or_undef,
       supports_failover             => \&ibap_i2o_boolean,
       use_enable_thresholds         => \&ibap_i2o_boolean,
       use_log_lease_events          => \&ibap_i2o_boolean,
       use_login                     => \&ibap_i2o_boolean,
       use_synchronization_min_delay => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       address                           => \&ibap_o2i_ignore,
       authoritative                     => \&ibap_o2i_boolean,
       broadcast_address                 => \&ibap_o2i_string,
       comment                           => \&ibap_o2i_ignore,
       ddns_server_always_updates        => \&ibap_o2i_boolean,
       dhcp_utilization                  => \&ibap_o2i_ignore,
       dhcp_utilization_status           => \&ibap_o2i_ignore,
       domain_name                       => \&ibap_o2i_string,
       domain_name_servers               => \&__o2i_dnsservers__,
       dynamic_hosts                     => \&ibap_o2i_ignore,
       enable_ddns                       => \&ibap_o2i_boolean,
       enable_dhcp                       => \&__o2i_enable_dhcp__,
       enable_thresholds                 => \&ibap_o2i_boolean,
       enable_monitoring                 => \&ibap_o2i_boolean,
       override_enable_monitoring        => \&ibap_o2i_boolean,
       enable_invalid_mac                => \&ibap_o2i_boolean,
       override_enable_invalid_mac       => \&ibap_o2i_boolean,
       extattrs                          => \&ibap_o2i_ignore,
       extensible_attributes             => \&ibap_o2i_ignore,
       last_sync_detail                  => \&ibap_o2i_ignore,
       last_sync_status                  => \&ibap_o2i_ignore,
       last_sync_ts                      => \&ibap_o2i_ignore,
       log_lease_events                  => \&ibap_o2i_boolean,
       manage_dhcp                       => \&ibap_o2i_boolean,
       ms_options                        => \&ibap_o2i_generic_struct_list_convert,
       name                              => \&ibap_o2i_ignore,
       override_enable_thresholds        => \&ibap_o2i_boolean,
       override_log_lease_events         => \&ibap_o2i_boolean,
       range_high_water_mark             => \&ibap_o2i_uint,
       range_high_water_mark_reset       => \&ibap_o2i_uint,
       range_low_water_mark              => \&ibap_o2i_uint,
       range_low_water_mark_reset        => \&ibap_o2i_uint,
       read_only                         => \&ibap_o2i_ignore,
       routers                           => \&__o2i_routers__,
       static_hosts                      => \&ibap_o2i_ignore,
       status                            => \&ibap_o2i_ignore,
       status_detail                     => \&ibap_o2i_ignore,
       status_last_updated               => \&ibap_o2i_ignore,
       supports_failover                 => \&ibap_o2i_ignore,
       override_login                    => \&ibap_o2i_boolean,
       synchronization_interval          => \&ibap_o2i_uint,
       override_synchronization_interval => \&ibap_o2i_boolean,
       login_name                        => \&ibap_o2i_string,
       login_password                    => \&ibap_o2i_string,
      );

    @_return_fields =
      (
       tField('always_update_dns'),
       tField('broadcast_address'),
       tField('comment'),
       tField('dhcp_utilization'),
       tField('dhcp_utilization_status'),
       tField('domain_name'),
       tField('domain_name_servers'),
       tField('dynamic_hosts'),
       tField('enable_ddns'),
       tField('enable_thresholds'),
       tField('enable_monitoring'),
       tField('use_enable_monitoring'),
       tField('enable_invalid_mac'),
       tField('use_enable_invalid_mac'),
       tField('is_authoritative'),
       tField('last_sync_detail'),
       tField('last_sync_status'),
       tField('last_sync_ts'),
       tField('log_lease_events'),
       tField('managed'),
       tField('ms_options'),
       tField('range_high_water_mark'),
       tField('range_high_water_mark_reset'),
       tField('range_low_water_mark'),
       tField('range_low_water_mark_reset'),
       tField('read_only'),
       tField('routers'),
       tField('server_address'),
       tField('server_name'),
       tField('static_hosts'),
       tField('status'),
       tField('status_detail'),
       tField('status_last_updated'),
       tField('supports_failover'),
       tField('use_enable_thresholds'),
       tField('use_log_lease_events'),
       tField('use_login'),
       tField('login_name'),
       tField('synchronization_min_delay'),
       tField('use_synchronization_min_delay'),
       tField('parent',
              {
               sub_fields =>
               [
                tField('server_name'),
               ],
              }
             ),
       return_fields_extensible_attributes(),
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

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                             \%_reverse_name_mappings,
                                             \%_searchable_fields,
                                             \%_ibap_to_object,
                                             \%_object_to_ibap,
                                             \@_return_fields,
                                             \%_return_field_overrides
                                            );
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

sub __search_mapping_fields__
{
    my ($self, $session, $type, $argsref) = @_;

    my ($out_search_fields_ref, $out_search_types_ref, $out_search_matches_ref) = $self->SUPER::__search_mapping_fields__($session, $type, $argsref);

    if (defined $$argsref{'address'}) {
        if ($$argsref{'address'} !~ m/^[0-9\.\*\^\+\$\-\[\]\\]+$/) {
            #
            #
            #
            $out_search_fields_ref->{'server_name'} = $out_search_fields_ref->{'server_address'} if defined $out_search_fields_ref->{'server_address'};
            $out_search_types_ref->{'server_name'} = $out_search_types_ref->{'server_address'} if defined $out_search_types_ref->{'server_address'};
            $out_search_matches_ref->{'server_name'} = $out_search_matches_ref->{'server_address'} if defined $out_search_matches_ref->{'server_address'};

            #
            delete $out_search_fields_ref->{'server_address'} if defined $out_search_fields_ref->{'server_name'};
            delete $out_search_types_ref->{'server_address'} if defined $out_search_types_ref->{'server_name'};
            delete $out_search_matches_ref->{'server_address'} if defined $out_search_matches_ref->{'server_name'};
        }
    }

    return ($out_search_fields_ref, $out_search_types_ref, $out_search_matches_ref);
}

#
#
#

sub __i2o_address__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my @newlist;
    if ($ibap_object_ref->{$current}) {
        foreach (@{$ibap_object_ref->{$current}}) {
            push @newlist, $_->{'address'};
        }
    }
    return \@newlist;
}

sub __i2o_name__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my @newlist;
    if ($ibap_object_ref->{$current} && $ibap_object_ref->{$current}{'server_name'}) {
        return $ibap_object_ref->{$current}{'server_name'};
    }
    else {
        return undef;
    }
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'always_update_dns'}             = 0 unless defined $$ibap_object_ref{'always_update_dns'};
    $$ibap_object_ref{'is_authoritative'}              = 0 unless defined $$ibap_object_ref{'is_authoritative'};
    $$ibap_object_ref{'enable_ddns'}                   = 0 unless defined $$ibap_object_ref{'enable_ddns'};
    $$ibap_object_ref{'enable_thresholds'}             = 0 unless defined $$ibap_object_ref{'enable_thresholds'};
    $$ibap_object_ref{'log_lease_events'}              = 0 unless defined $$ibap_object_ref{'log_lease_events'};
    $$ibap_object_ref{'managed'}                       = 0 unless defined $$ibap_object_ref{'managed'};
    $$ibap_object_ref{'read_only'}                     = 0 unless defined $$ibap_object_ref{'read_only'};
    $$ibap_object_ref{'use_enable_thresholds'}         = 0 unless defined $$ibap_object_ref{'use_enable_thresholds'};
    $$ibap_object_ref{'use_log_lease_events'}          = 0 unless defined $$ibap_object_ref{'use_log_lease_events'};
    $$ibap_object_ref{'enable_monitoring'}             = 0 unless defined $$ibap_object_ref{'enable_monitoring'};
    $$ibap_object_ref{'use_enable_monitoring'}         = 0 unless defined $$ibap_object_ref{'use_enable_monitoring'};
    $$ibap_object_ref{'enable_invalid_mac'}            = 0 unless defined $$ibap_object_ref{'enable_invalid_mac'};
    $$ibap_object_ref{'use_enable_invalid_mac'}        = 0 unless defined $$ibap_object_ref{'use_enable_invalid_mac'};
    $$ibap_object_ref{'supports_failover'}             = 0 unless defined $$ibap_object_ref{'supports_failover'};
    $$ibap_object_ref{'use_login'}                     = 0 unless defined $$ibap_object_ref{'use_login'};
    $$ibap_object_ref{'use_synchronization_min_delay'} = 0 unless defined $$ibap_object_ref{'use_synchronization_min_delay'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'override_enable_invalid_mac'}       = ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_invalid_mac'});
    $self->{'override_enable_monitoring'}        = ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_monitoring'});
    $self->{'override_login'}                    = ibap_value_i2o_boolean($$ibap_object_ref{'use_login'});
    $self->{'override_synchronization_interval'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_synchronization_min_delay'});
}

#
#
#

sub __o2i_dnsservers__
{
    my ($self, $session, $current, $tempref) = @_;

    my @newlist;
    if ($self->{$current}) {
        foreach (@{$self->{$current}}) {
            push @newlist, tIBType('custom_dns_server', { address => $_ });
        }
    }

    return (1,0,tIBType('ArrayOfcustom_dns_server', \@newlist));
}

sub __o2i_routers__
{
    my ($self, $session, $current, $tempref) = @_;

    my @newlist;
    if ($self->{$current}) {
        foreach (@{$self->{$current}}) {
            push @newlist, tIBType('custom_router', { address => $_ });
        }
    }

    return (1,0,tIBType('ArrayOfcustom_dns_server', \@newlist));
}

sub __o2i_enable_dhcp__
{
	my ($self, $session, $current, $tempref, $type) = @_;

    if($self->{$current}) {
        if ($self->{$current} eq 'true') {
            return (1,0, ibap_value_o2i_string('START'));
        }
        else {
            return (1,0, ibap_value_o2i_string('STOP'));
        }
    } else {
        return (1, 1, undef);
    }
}

#
#
#

sub address
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'address', validator => \&ibap_value_o2i_string, readonly => 1}, @_);
}

sub authoritative
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'authoritative', validator => \&ibap_value_o2i_boolean}, @_);
}

sub broadcast_address
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'broadcast_address', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string, readonly => 1}, @_);
}

sub ddns_server_always_updates
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ddns_server_always_updates', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dhcp_utilization
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dhcp_utilization', validator => \&ibap_value_o2i_uint, readonly => 1}, @_);
}

sub dhcp_utilization_status
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dhcp_utilization_status', validator => \&ibap_value_o2i_string, readonly => 1}, @_);
}

sub domain_name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'domain_name', validator => \&ibap_value_o2i_string}, @_);
}

sub domain_name_servers
{
    my $self=shift;
    return $self->__accessor_array__({name => 'domain_name_servers', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub dynamic_hosts
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dynamic_hosts', validator => \&ibap_value_o2i_uint, readonly => 1}, @_);
}

sub enable_ddns
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_ddns', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_dhcp
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_dhcp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_monitoring
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_monitoring', validator => \&ibap_value_o2i_boolean, use => 'override_enable_monitoring', use_truefalse => 1}, @_);
}

sub override_enable_monitoring
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_enable_monitoring', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_invalid_mac
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_invalid_mac', validator => \&ibap_value_o2i_boolean, use => 'override_enable_invalid_mac', use_truefalse => 1}, @_);
}

sub override_enable_invalid_mac
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_enable_invalid_mac', validator => \&ibap_value_o2i_boolean}, @_);
}

sub supports_failover
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'supports_failover', validator => \&ibap_value_o2i_boolean, readonly => 1}, @_);
}

sub enable_thresholds
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_thresholds', validator => \&ibap_value_o2i_boolean}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 1, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 1, @_);
}

sub last_sync_detail
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'last_sync_detail', validator => \&ibap_value_o2i_string, readonly => 1}, @_);
}

sub last_sync_status
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'last_sync_status', validator => \&ibap_value_o2i_string, readonly => 1}, @_);
}

sub last_sync_ts
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'last_sync_ts', validator => \&ibap_value_o2i_string, readonly => 1}, @_);
}

sub log_lease_events
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'log_lease_events', validator => \&ibap_value_o2i_boolean}, @_);
}

sub manage_dhcp
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'manage_dhcp', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ms_options
{
    my $self=shift;
    return $self->__accessor_array__({name => 'ms_options', validator => { 'Infoblox::DHCP::MSOption' => 1 }}, @_);
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string, readonly => 1}, @_);
}

sub override_enable_thresholds
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_enable_thresholds', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_log_lease_events
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_log_lease_events', validator => \&ibap_value_o2i_boolean}, @_);
}

sub range_high_water_mark
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_high_water_mark', validator => \&ibap_value_o2i_uint}, @_);
}

sub range_high_water_mark_reset
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_high_water_mark_reset', validator => \&ibap_value_o2i_uint}, @_);
}

sub range_low_water_mark
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_low_water_mark', validator => \&ibap_value_o2i_uint}, @_);
}

sub range_low_water_mark_reset
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_low_water_mark_reset', validator => \&ibap_value_o2i_uint}, @_);
}

sub read_only
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'read_only', validator => \&ibap_value_o2i_boolean, readonly => 1}, @_);
}

sub routers
{
    my $self=shift;
    return $self->__accessor_array__({name => 'routers', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub static_hosts
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'static_hosts', validator => \&ibap_value_o2i_uint, readonly => 1}, @_);
}

sub status
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'status', validator => \&ibap_value_o2i_string, readonly => 1}, @_);
}

sub status_detail
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'status_detail', validator => \&ibap_value_o2i_string, readonly => 1}, @_);
}

sub status_last_updated
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'status_last_updated', validator => \&ibap_value_o2i_string, readonly => 1}, @_);
}

1;
