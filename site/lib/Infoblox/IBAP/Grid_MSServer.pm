package Infoblox::Grid::MSServer;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'MsServer';
    register_wsdl_type('ib:MsServer','Infoblox::Grid::MSServer');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members =
      (
       address                  => 1,
       ad_sites                 => 0,
       comment                  => 0,
       disable                  => 0,
       dns_view                 => 0,
       extattrs                 => 0,
       extensible_attributes    => 0,
       logging_mode             => 0,
       login                    => 1,
       managing_member          => 0,
       network_view             => 0,
       password                 => 0,
       read_only                => 0,
       synchronization_interval => 0,
       version                  => -1,
       is_AD                    => -1,
       log_destination          => 0,
       override_log_destination => 0,
       max_connection           => 0,
       override_max_connection  => 0,
       rpc_timeout              => 0,
       override_rpc_timeout     => 0,

       ad_user                  => {validator => {'Infoblox::Grid::MSServer::AdUser' => 1}},
       ad_domain                => {simple => 'asis', readonly => 1},
       root_ad_domain           => {simple => 'asis', readonly => 1},

      );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings =
      (
       is_AD                    => 'dns_server', # we can do this because this is the only member we care about
       logging_mode             => 'log_level',
       login                    => 'login_name',
       managing_member          => 'grid_member',
       password                 => 'login_password',
       synchronization_interval => 'synchronization_min_delay',
       disable                  => 'disabled',
       extattrs                 => 'extensible_attributes',
       override_log_destination => 'use_log_destination',
       max_connection           => 'ms_max_connection',
       override_max_connection  => 'use_ms_max_connection',
       rpc_timeout              => 'ms_rpc_timeout_in_seconds',
       override_rpc_timeout     => 'use_ms_rpc_timeout_in_seconds',
       ad_user                  => 'ad_user_sync',
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
						   address               => [\&ibap_o2i_string,'address' , 'REGEX'],
						   comment               => [\&ibap_o2i_string,'comment' , 'REGEX', 'IGNORE_CASE'],

                           read_only             => [\&ibap_o2i_boolean,'read_only', 'EXACT'],
                           managing_member       => [\&ibap_o2i_member_byhostname,'grid_member', 'EXACT'],
                           network_view          => [\&ibap_o2i_network_view,'network_view', 'EXACT'],
                           dns_view              => [\&ibap_o2i_view,'dns_view'   , 'EXACT'],
                           extattrs              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                          );

	%_return_field_overrides =
      (
       address                  => [],
       ad_sites                 => [],
       ad_user                  => [],
       comment                  => [],
       disable                  => [],
       dns_view                 => [],
       extattrs                 => [],
       extensible_attributes    => [],
       logging_mode             => [],
       login                    => [],
       managing_member          => [],
       network_view             => [],
       password                 => [],
       read_only                => [],
       synchronization_interval => [],
       version                  => [],
       is_AD                    => [],
       log_destination          => ['use_log_destination'],
       override_log_destination => [],
       max_connection           => ['use_ms_max_connection'],
       override_max_connection  => [],
       rpc_timeout              => ['use_ms_rpc_timeout_in_seconds'],
       override_rpc_timeout     => [],
       ad_domain                => [],
       root_ad_domain           => [],
      );

    %_ibap_to_object =
      (
       ad_sites                  => \&ibap_i2o_generic_object_convert,
       ad_user_sync              => \&ibap_i2o_generic_object_convert,
       disabled                  => \&ibap_i2o_boolean,
       dns_server                => \&__i2o_ad_capable__,
       dns_view                  => \&__i2o_view__,
       extensible_attributes     => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
       grid_member               => \&ibap_i2o_member_byhostname,
       log_level                 => \&ibap_i2o_enums_lc_or_undef,
       network_view              => \&__i2o_view__,
       read_only                 => \&ibap_i2o_boolean,
       use_log_destination       => \&ibap_i2o_boolean,
       use_ms_max_connection     => \&ibap_i2o_boolean,
       use_ms_rpc_timeout_in_seconds => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       address                  => \&ibap_o2i_string,
       ad_sites                 => \&ibap_o2i_generic_struct_convert,
       ad_user                  => \&ibap_o2i_generic_struct_convert,
       comment                  => \&ibap_o2i_string,
       disable                  => \&ibap_o2i_boolean,
       dns_view                 => \&__o2i_dns_view__,
       extattrs                 => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
       extensible_attributes    => \&ibap_o2i_ignore,
       logging_mode             => \&ibap_o2i_enums_lc_or_undef,
       login                    => \&ibap_o2i_string,
       managing_member          => \&ibap_o2i_member_byhostname,
       network_view             => \&__o2i_network_view__,
       password                 => \&ibap_o2i_string_skip_undef,
       read_only                => \&ibap_o2i_boolean,
       synchronization_interval => \&ibap_o2i_uint,
       version                  => \&ibap_o2i_ignore,
       is_AD                    => \&ibap_o2i_ignore,
       log_destination          => \&ibap_o2i_string,
       override_log_destination => \&ibap_o2i_boolean,
       max_connection           => \&ibap_o2i_uint,
       override_max_connection  => \&ibap_o2i_boolean,
       rpc_timeout              => \&ibap_o2i_uint,
       override_rpc_timeout     => \&ibap_o2i_boolean,
       ad_domain                => \&ibap_o2i_ignore,
       root_ad_domain           => \&ibap_o2i_ignore,
      );

    @_return_fields =
      (
       tField('address'),
       tField('comment'),
       tField('disabled'),
       tField('login_name'),
       tField('read_only'),
       tField('synchronization_min_delay'),
       tField('grid_member', return_fields_member_basic_data()),
       tField('log_level'),
       tField('network_view', {sub_fields => [tField('name')]}),
       tField('dns_view', {sub_fields => [tField('name')]}),
       tField('last_seen'),
       tField('dns_server', {sub_fields => [tField('supports_active_directory')]}),
       tField('version'),
       tField('log_destination'),
       tField('use_log_destination'),
       tField('ms_max_connection'),
       tField('use_ms_max_connection'),
       tField('ms_rpc_timeout_in_seconds'),
       tField('use_ms_rpc_timeout_in_seconds'),
       tField('ad_domain'),
       tField('root_ad_domain'),
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

        my ($tmp, %tmp);

        %tmp = (
                ad_sites     => 'Infoblox::Grid::MSServer::AdSites',
                ad_user_sync => 'Infoblox::Grid::MSServer::AdUser',
        );

        foreach (keys %tmp) {
            $tmp = $tmp{$_}->__new__();
            push @_return_fields, tField($_, {sub_fields => $tmp->__return_fields__()});
        }    
    }

    #
    $self->synchronization_interval(2) unless defined $self->synchronization_interval();
    $self->read_only('true') unless defined $self->read_only();
    $self->logging_mode('normal') unless defined $self->logging_mode();
    $self->disable('false') unless defined $self->disable();
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

sub __i2o_ad_capable__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return ibap_value_i2o_boolean($ibap_object_ref->{$current}->{'supports_active_directory'});
}

sub __i2o_view__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return $ibap_object_ref->{$current}->{'name'};
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'read_only'} = 0 unless defined $$ibap_object_ref{'read_only'};
    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};
    $$ibap_object_ref{'dns_server'}{'supports_active_directory'} = 0 unless defined $$ibap_object_ref{'dns_server'}{'supports_active_directory'};
    $$ibap_object_ref{'use_log_destination'} = 0 unless defined $$ibap_object_ref{'use_log_destination'};
    $$ibap_object_ref{'use_ms_max_connection'} = 0 unless defined $$ibap_object_ref{'use_ms_max_connection'};
    $$ibap_object_ref{'use_ms_rpc_timeout_in_seconds'} = 0 unless defined $$ibap_object_ref{'use_ms_rpc_timeout_in_seconds'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'override_log_destination'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_log_destination'});
    $self->{'override_max_connection'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_ms_max_connection'});
    $self->{'override_rpc_timeout'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_ms_rpc_timeout_in_seconds'});
	return;
}

#
#
#

sub __o2i_dns_view__
{
	my ($self, $session, $current, $tempref, $type) = @_;

    if($self->{$current}) {
        return (1, 0, ibap_readfield_simple_string('View', 'name', $self->{$current},'dns_view'));
    } else {
        return (1, 0, ibap_readfield_simple('View','is_default',tBool(1),'view=(default view)'));
    }
}

sub __o2i_network_view__
{
	my ($self, $session, $current, $tempref, $type) = @_;

    if($self->{$current}) {
        return (1, 0, ibap_readfield_simple_string('NetworkView', 'name', $self->{$current},'network_view'));
    } else {
        return (1, 0, ibap_readfield_simple('NetworkView','is_default',tBool(1),'network view=(default network view)'));
    }
}

#
#
#

sub address
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'address', validator => \&ibap_value_o2i_string}, @_);
}

sub ad_sites
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ad_sites', validator => {'Infoblox::Grid::MSServer::AdSites' => 1}}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub login
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'login', validator => \&ibap_value_o2i_string}, @_);
}

sub password
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'password', writeonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub managing_member
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'managing_member', validator => \&ibap_value_o2i_string}, @_);
}

sub read_only
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'read_only', validator => \&ibap_value_o2i_boolean}, @_);
}

sub synchronization_interval
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'synchronization_interval', validator => \&ibap_value_o2i_uint}, @_);
}

sub logging_mode
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'logging_mode', enum => ['minimum' , 'normal' , 'advanced' , 'full'] }, @_);
}

sub network_view
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'network_view', validator => \&ibap_value_o2i_string}, @_);
}

sub dns_view
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_view', validator => \&ibap_value_o2i_string}, @_);
}

sub version
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'version', readonly => 1}, @_);
}

sub is_AD
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'is_AD', readonly => 1}, @_);
}

sub log_destination
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'log_destination', enum => ['SYSLOG', 'MSLOG'], use => 'override_log_destination', use_truefalse => 1}, @_);
}

sub override_log_destination
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_log_destination', validator => \&ibap_value_o2i_boolean}, @_);
}

sub max_connection
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'max_connection', validator => \&ibap_value_o2i_uint, use => 'override_max_connection', use_truefalse => 1}, @_);
}

sub override_max_connection
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_max_connection', validator => \&ibap_value_o2i_boolean}, @_);
}

sub rpc_timeout
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'rpc_timeout', validator => \&ibap_value_o2i_uint, use => 'override_rpc_timeout', use_truefalse => 1}, @_);
}

sub override_rpc_timeout
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_rpc_timeout', validator => \&ibap_value_o2i_boolean}, @_);
}


package Infoblox::Grid::MSServer::DNS;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE);

BEGIN {
    #
    #
    #
    $_object_type = 'MsServer';

    #
    register_wsdl_type('ib:ms_server_dns','Infoblox::Grid::MSServer::ServerDNS');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members =
      (
       extattrs              => -1,
       extensible_attributes => -1,
       address               => -1,
       name                  => -1,
       enable_dns            => 0,
       enable_dns_reports_sync => 0,
       override_enable_dns_reports_sync => 0,
       manage_dns            => 0,
       enable_monitoring     => 0,
       override_enable_monitoring => 0,
       status                => -1,
       forwarders            => 0,
       status_detail         => -1,
       status_last_updated   => -1,
       status_last_updated_ts => -1,
       last_sync_ts          => -1,
       last_sync_status      => -1,
       last_sync_detail      => -1,
       login_name                        => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_login', use_truefalse => 1},
       login_password                    => {simple => 'asis', validator => \&ibap_value_o2i_string, writeonly => 1},
       override_login                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       override_synchronization_interval => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       synchronization_interval          => {simple => 'asis', validator => \&ibap_value_o2i_uint,
                                             use => 'override_synchronization_interval', use_truefalse => 1},
      );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings =
      (
       enable_dns                        => 'next_sync_control',
       manage_dns                        => 'managed',
       name                              => 'server_name',
       extattrs                          => 'extensible_attributes',
       override_login                    => 'use_login',
       override_synchronization_interval => 'use_synchronization_min_delay',
       override_enable_dns_reports_sync  => 'use_enable_dns_reports_sync',
       synchronization_interval          => 'synchronization_min_delay',

      );

    %_reverse_name_mappings = reverse %_name_mappings;
    $_name_mappings{'internal_dns_server'} = 'dns_server';
    $_reverse_name_mappings{'dns_server'} = '__skip_handler__';

    %_searchable_fields = (
						   address               => [\&ibap_o2i_string,'address' , 'REGEX'],
                           server_ip             => [\&ibap_o2i_string, 'server_ip', 'REGEX'],
                           server_name           => [\&ibap_o2i_string, 'server_name', 'REGEX'],
                           extattrs              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                          );

	%_return_field_overrides =
      (
       address                           => [],
       name                              => [],
       enable_dns                        => ['!dns_server'],
       enable_dns_reports_sync           => ['!dns_server'],
       extattrs                          => [],
       extensible_attributes             => [],
       forwarders                        => ['!dns_server'],
       last_sync_detail                  => ['!dns_server'],
       last_sync_status                  => ['!dns_server'],
       last_sync_ts                      => ['!dns_server'],
       manage_dns                        => ['!dns_server'],
       status                            => ['!dns_server'],
       status_detail                     => ['!dns_server'],
       status_last_updated               => ['!dns_server'],
       status_last_updated_ts            => ['!dns_server'],
       enable_monitoring                 => ['!dns_server'],
       override_enable_dns_reports_sync  => ['!dns_server'],
       override_enable_monitoring        => ['!dns_server'],
       login_name                        => ['!dns_server'],
       override_login                    => ['!dns_server'],
       override_synchronization_interval => ['!dns_server'],
       synchronization_interval          => ['!dns_server'],
      );

    %_ibap_to_object =
      (
       dns_server                    => \&__i2o_dnsserver__,
       extensible_attributes         => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
       enable_dns_reports_sync       => \&ibap_i2o_boolean,
       enable_monitoring             => \&ibap_i2o_boolean,
       use_enable_dns_reports_sync   => \&ibap_i2o_boolean,
       use_enable_monitoring         => \&ibap_i2o_boolean,
       use_login                     => \&ibap_i2o_boolean,
       use_synchronization_min_delay => \&ibap_i2o_boolean,
      );

    #
    %_object_to_ibap =
      (
       address                           => \&ibap_o2i_ignore,
       name                              => \&ibap_o2i_ignore,
       enable_dns                        => \&ibap_o2i_ignore,
       extattrs                          => \&ibap_o2i_ignore,
       extensible_attributes             => \&ibap_o2i_ignore,
       forwarders                        => \&ibap_o2i_ignore,
       last_sync_detail                  => \&ibap_o2i_ignore,
       last_sync_status                  => \&ibap_o2i_ignore,
       last_sync_ts                      => \&ibap_o2i_ignore,
       manage_dns                        => \&ibap_o2i_ignore,
       status                            => \&ibap_o2i_ignore,
       status_detail                     => \&ibap_o2i_ignore,
       status_last_updated               => \&ibap_o2i_ignore,
       status_last_updated_ts            => \&ibap_o2i_ignore,
       enable_dns_reports_sync           => \&ibap_o2i_ignore,
       override_enable_dns_reports_sync  => \&ibap_o2i_ignore,
       enable_monitoring                 => \&ibap_o2i_ignore,
       override_enable_monitoring        => \&ibap_o2i_ignore,
       login_name                        => \&ibap_o2i_ignore,
       login_password                    => \&ibap_o2i_ignore,
       override_login                    => \&ibap_o2i_ignore,
       synchronization_interval          => \&ibap_o2i_ignore,
       override_synchronization_interval => \&ibap_o2i_ignore,

       internal_dns_server  => \&__o2i_dnsserver__,
      );

    @_return_fields =
      (
       tField('address'),
       tField('server_name'),
       tField('dns_server',
              {
               sub_fields =>
               [
                tField('forwarders'),
                tField('last_sync_detail'),
                tField('last_sync_status'),
                tField('last_sync_ts'),
                tField('managed'),
                tField('status'),
                tField('status_detail'),
                tField('status_last_updated'),
                tField('enable_dns_reports_sync'),
                tField('enable_monitoring'),
                tField('use_enable_dns_reports_sync'),
                tField('use_enable_monitoring'),
                tField('use_login'),
                tField('login_name'),
                tField('login_password'),
                tField('synchronization_min_delay'),
                tField('use_synchronization_min_delay'),
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

    #
    $self->{'internal_dns_server'} = 1;
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

sub __i2o_dnsserver__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    $self->manage_dns(ibap_value_i2o_boolean($ibap_object_ref->{$current}->{'managed'}));
    $self->forwarders($ibap_object_ref->{$current}->{'forwarders'});
    $self->last_sync_detail($ibap_object_ref->{$current}->{'last_sync_detail'});
    $self->last_sync_ts($ibap_object_ref->{$current}->{'last_sync_ts'});
    $self->last_sync_status(capitalize_first_letter($ibap_object_ref->{$current}->{'last_sync_status'}));
    $self->status(capitalize_first_letter($ibap_object_ref->{$current}->{'status'}));
    $self->status_detail($ibap_object_ref->{$current}->{'status_detail'});
    $self->status_last_updated($ibap_object_ref->{$current}->{'status_last_updated'});

    $self->synchronization_interval($$ibap_object_ref{$current}{'synchronization_min_delay'});
    $self->login_name($$ibap_object_ref{$current}{'login_name'});
    $self->login_password($$ibap_object_ref{$current}{'login_password'});
    if ($ibap_object_ref->{$current}->{'status_last_updated'}) {
        $self->status_last_updated_ts(iso8601_datetime_to_unix_timestamp($ibap_object_ref->{$current}->{'status_last_updated'}));
    }
    $self->enable_monitoring(ibap_value_i2o_boolean($ibap_object_ref->{$current}->{'enable_monitoring'}));
    $self->enable_dns_reports_sync(ibap_value_i2o_boolean($ibap_object_ref->{$current}->{'enable_dns_reports_sync'}));
    $self->override_enable_dns_reports_sync(ibap_value_i2o_boolean($ibap_object_ref->{$current}->{'use_enable_dns_reports_sync'}));
    $self->override_enable_monitoring(ibap_value_i2o_boolean($ibap_object_ref->{$current}->{'use_enable_monitoring'}));
    $self->override_login(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'use_login'}));
    $self->override_synchronization_interval(ibap_value_i2o_boolean($$ibap_object_ref{$current}{'use_synchronization_min_delay'}));

    #
    #
}

#
#
sub __skip_handler__{};

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    $$ibap_object_ref{'dns_server'}{'managed'} = 0 unless defined $$ibap_object_ref{'dns_server'}{'managed'};
    $$ibap_object_ref{'dns_server'}{'enable_dns_reports_sync'} = 0 unless defined $$ibap_object_ref{'dns_server'}{'enable_dns_reports_sync'};
    $$ibap_object_ref{'dns_server'}{'enable_monitoring'} = 0 unless defined $$ibap_object_ref{'dns_server'}{'enable_monitoring'};
    $$ibap_object_ref{'dns_server'}{'use_enable_dns_reports_sync'} = 0 unless defined $$ibap_object_ref{'dns_server'}{'use_enable_dns_reports_sync'};
    $$ibap_object_ref{'dns_server'}{'use_enable_monitoring'} = 0 unless defined $$ibap_object_ref{'dns_server'}{'use_enable_monitoring'};
    $$ibap_object_ref{'dns_server'}{'use_login'} = 0 unless defined $$ibap_object_ref{'dns_server'}{'use_login'};
    $$ibap_object_ref{'dns_server'}{'use_synchronization_min_delay'} = 0 unless defined $$ibap_object_ref{'dns_server'}{'use_synchronization_min_delay'};
    $$ibap_object_ref{'disable'} = 0 unless defined $$ibap_object_ref{'disable'};

    my $serv_name = $$ibap_object_ref{server_name};

    if ((not $serv_name) or ($serv_name eq $$ibap_object_ref{address})) {
        delete $$ibap_object_ref{server_name};
    }

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'override_enable_monitoring'}=ibap_value_i2o_boolean($$ibap_object_ref{'dns_server'}{'use_enable_monitoring'});
    $self->{'override_enable_dns_reports_sync'} = ibap_value_i2o_boolean($$ibap_object_ref{'dns_server'}{'use_enable_dns_reports_sync'});
    $self->{'override_login'} = ibap_value_i2o_boolean($$ibap_object_ref{'dns_server'}{'use_login'});
    $self->{'override_synchronization_interval'} = ibap_value_i2o_boolean($$ibap_object_ref{'dns_server'}{'use_synchronization_min_delay'});
	return;
}

#
#
#

sub __o2i_dnsserver__
{
	my ($self, $session, $current, $tempref, $type) = @_;

    my %t;

    $t{'managed'} = ibap_value_o2i_boolean($self->manage_dns());
    $t{'enable_dns_reports_sync'} = ibap_value_o2i_boolean($self->enable_dns_reports_sync());
    $t{'enable_monitoring'} = ibap_value_o2i_boolean($self->enable_monitoring());
    $t{'use_enable_dns_reports_sync'} = ibap_value_o2i_boolean($self->override_enable_dns_reports_sync());
    $t{'use_enable_monitoring'} = ibap_value_o2i_boolean($self->override_enable_monitoring());
    if (defined $self->enable_dns()) {
        if ($self->enable_dns() eq 'true') {
            $t{'next_sync_control'} = 'START';
        }
        else {
            $t{'next_sync_control'} = 'STOP';
        }
    }
    else {
        $t{'next_sync_control'} = 'NONE';
    }

    $t{'use_login'} = ibap_value_o2i_boolean($self->override_login());
    $t{'login_name'} = ibap_value_o2i_string($self->login_name()) if defined $self->{login_name};
    $t{'login_password'} = ibap_value_o2i_string($self->{login_password}) if defined $self->{login_password};

    $t{'use_synchronization_min_delay'} = ibap_value_o2i_boolean($self->override_synchronization_interval());
    $t{'synchronization_min_delay'} = ibap_value_o2i_uint($self->synchronization_interval());

    my @newlist;
    foreach my $addr (@{$self->{'forwarders'}}) {
        if (is_ipv4_address($addr)) {
            push @newlist, ibap_value_o2i_ipv4addr($addr, '', $session);
        } elsif (is_ipv6_address($addr)) {
            push @newlist, ibap_value_o2i_ipv6addr($addr, '', $session);
        } else {
            set_error_codes(1012, "Invalid ip address $addr in forwarders",$session);
            return (0);
        }
    }

    $t{'forwarders'} = tIBType('ArrayOfIPAddress',\@newlist);

    return (1, 0, tIBType('ms_server_dns',\%t));
}

#
#
#

sub enable_dns
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_dns', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_dns_reports_sync
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_dns_reports_sync', validator => \&ibap_value_o2i_boolean, use => 'override_enable_dns_reports_sync', use_truefalse => 1}, @_);
}

sub enable_monitoring
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_monitoring', validator => \&ibap_value_o2i_boolean, use => 'override_enable_monitoring', use_truefalse => 1}, @_);
}

sub override_enable_dns_reports_sync
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_enable_dns_reports_sync', validator => \&ibap_value_o2i_boolean}, @_);
}

sub override_enable_monitoring
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_enable_monitoring', validator => \&ibap_value_o2i_boolean}, @_);
}

sub manage_dns
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'manage_dns', validator => \&ibap_value_o2i_boolean}, @_);
}

sub status
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'status', readonly => 1}, @_);
}

sub forwarders
{
    my $self=shift;
    return $self->__accessor_array__({name => 'forwarders', validator => { 'string' => \&ibap_value_o2i_ipaddr }}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 1, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 1, @_);
}

sub address
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'address', readonly => 1}, @_);
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', readonly => 1}, @_);
}

sub status_detail
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'status_detail', readonly => 1}, @_);
}

sub status_last_updated
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'status_last_updated', readonly => 1}, @_);
}

sub status_last_updated_ts
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'status_last_updated_ts', readonly => 1}, @_);
}

sub last_sync_ts
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'last_sync_ts', readonly => 1}, @_);
}

sub last_sync_status
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'last_sync_status', readonly => 1}, @_);
}

sub last_sync_detail
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'last_sync_detail', readonly => 1}, @_);
}


package Infoblox::Grid::MSServer::AdSites;


use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;


use vars qw ( @ISA $_object_type %_allowed_members
              @_return_fields %_object_to_ibap %_name_mappings
              %_reverse_name_mappings %_ibap_to_object
              $_return_fields_initialized );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'ms_ad_sites';
    register_wsdl_type('ib:ms_ad_sites', 'Infoblox::Grid::MSServer::AdSites');

    %_allowed_members = (
                         'default_ip_site_link'              => {simple => 'asis', use_truefalse => 1, validator => \&ibap_value_o2i_string, use => 'override_default_ip_site_link'},
                         'last_sync_ts'                      => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string_to_datetime},
                         'last_sync_status'                  => {simple => 'asis', readonly => 1, enum => ['ERROR', 'OK', 'WARNING']},
                         'last_sync_detail'                  => {simple => 'asis', readonly => 1},
                         'ldap_timeout'                      => {simple => 'asis', use_truefalse => 1, use => 'override_ldap_timeout', validator => \&ibap_value_o2i_uint},
                         'ldap_auth_port'                    => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'ldap_encryption'                   => {simple => 'asis', enum => ['NONE', 'SSL']},
                         'login_name'                        => {simple => 'asis', use_truefalse => 1, validator => \&ibap_value_o2i_string, use => 'override_login'},
                         'managed'                           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'override_default_ip_site_link'     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'override_ldap_timeout'             => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'override_login'                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'override_synchronization_interval' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'read_only'                         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'synchronization_interval'          => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'override_synchronization_interval', use_truefalse => 1},
                         'login_password'                    => {writeonly => 1, validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'override_default_ip_site_link'     => 'use_default_ip_site_link',
                       'override_ldap_timeout'             => 'use_ldap_timeout',
                       'override_login'                    => 'use_login',
                       'synchronization_interval'          => 'synchronization_min_delay',
                       'override_synchronization_interval' => 'use_synchronization_min_delay',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('default_ip_site_link'),
                       tField('login_name'),
                       tField('last_sync_ts'),
                       tField('last_sync_status'),
                       tField('last_sync_detail'),
                       tField('ldap_timeout'),
                       tField('ldap_auth_port'),
                       tField('ldap_encryption'),
                       tField('managed'),
                       tField('use_default_ip_site_link'),
                       tField('use_ldap_timeout'),
                       tField('use_login'),
                       tField('use_synchronization_min_delay'),
                       tField('synchronization_min_delay'),
                       tField('read_only'),
    );

    %_object_to_ibap = (
                        'default_ip_site_link'              => \&ibap_o2i_string,
                        'ldap_timeout'                      => \&ibap_o2i_uint,
                        'ldap_auth_port'                    => \&ibap_o2i_uint,
                        'ldap_encryption'                   => \&ibap_o2i_string,
                        'login_name'                        => \&ibap_o2i_string,
                        'login_password'                    => \&ibap_o2i_string,
                        'managed'                           => \&ibap_o2i_boolean,
                        'override_default_ip_site_link'     => \&ibap_o2i_boolean,
                        'override_login'                    => \&ibap_o2i_boolean,
                        'override_ldap_timeout'             => \&ibap_o2i_boolean,
                        'override_synchronization_interval' => \&ibap_o2i_boolean,
                        'read_only'                         => \&ibap_o2i_boolean,
                        'synchronization_interval'          => \&ibap_o2i_uint,
                        'last_sync_ts'                      => \&ibap_o2i_ignore,
                        'last_sync_status'                  => \&ibap_o2i_ignore,
                        'last_sync_detail'                  => \&ibap_o2i_ignore,
    );

    $_return_fields_initialized = 0;
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members)) {

        return;
    }

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_to_object__ {

	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'read_only'} = 0 unless defined $$ibap_object_ref{'read_only'};
    $$ibap_object_ref{'managed'} = 0 unless defined $$ibap_object_ref{'managed'};

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'override_default_ip_site_link'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_default_ip_site_link'});
    $self->{'override_login'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_login'});
    $self->{'override_ldap_timeout'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_ldap_timeout'});
    $self->{'override_synchronization_interval'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_synchronization_min_delay'});

    return $res;
}


package Infoblox::Grid::MSServer::AdSites::Site;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;


use vars qw( @ISA $_object_type %_allowed_members
             @_return_fields %_object_to_ibap
             %_name_mappings %_reverse_name_mappings
             %_ibap_to_object $_return_fields_initialized
             %_searchable_fields %_capabilities );

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
	);

    $_object_type = 'MsAdSitesSite';
    register_wsdl_type('ib:MsAdSitesSite', 'Infoblox::Grid::MSServer::AdSites::Site');

    %_allowed_members = (
                         'name'         =>  {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'domain'       =>  {mandatory => 1, validator => {'Infoblox::Grid::MSServer::AdSites::Domain' => 1}},
                         'networks'     =>  {array => 1, validator => {
                                                                       'Infoblox::DHCP::Network'              => 1,
                                                                       'Infoblox::DHCP::IPv6Network'          => 1,
                                                                       'Infoblox::DHCP::NetworkContainer'     => 1,
                                                                       'Infoblox::DHCP::IPv6NetworkContainer' => 1,
                                            }},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'domain' => 'parent',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           'name'   => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'domain' => [\&ibap_o2i_ms_adsites_domain, 'parent', 'EXACT'],
    );

    @_return_fields = (
                       tField('name'),
    );

    %_ibap_to_object = (
                        'parent'   => \&ibap_i2o_generic_object_convert,
                        'networks' => \&ibap_i2o_generic_object_list_convert,
    );

    %_object_to_ibap = (
                        'networks' => \&ibap_o2i_generic_network_list,
                        'domain'   => \&ibap_o2i_ms_adsites_domain,
                        'name'     => \&ibap_o2i_string,
    );

    $_return_fields_initialized = 0;
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members)) {

        return;
    }

    $self->__init_instance_constants__();
    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    $self->__init_instance_constants__();

    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my ($t, @_objtype_return_fields);

        foreach my $obj_class (
            'Infoblox::DHCP::Network',
            'Infoblox::DHCP::IPv6Network',
            'Infoblox::DHCP::NetworkContainer',
            'Infoblox::DHCP::IPv6NetworkContainer',
        ) {
            $t = $obj_class->__new__();
            push @_objtype_return_fields,
                tFieldObjType($t->__ibap_object_type__, {
                    sub_fields => $t->__return_fields__(),
                });
        }

        push @_return_fields,
            tField('networks', {
                default_no_access_ok => 1,
                sub_fields           => \@_objtype_return_fields,
            });

        $t = Infoblox::Grid::MSServer::AdSites::Domain->__new__();
        push @_return_fields,
            tField('parent', {sub_fields => $t->__return_fields__()});
    }

    $self->networks([]) unless defined $self->networks();
}

sub __ibap_capabilities__ {

	my ($self, $what) = @_;
	return $_capabilities{$what};
}

sub __ibap_to_object__ {

	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->{ '__internal_session_cache_ref__' } = \$session;

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    return $res;
}

#
#
#

sub move_subnets {

    my $self = shift;

    unless ($self->{'__internal_session_cache_ref__'}) {
        return set_error_code(1001, 'In order to move subnetes the object must have been retrieved from the server first');
    }

    return ${$self->{'__internal_session_cache_ref__'}}->__move_subnets__($self, @_);
}


package Infoblox::Grid::MSServer::AdSites::Domain;

use strict;
use Carp;

use Infoblox::IBAPTypes;
use Infoblox::Util;
use Infoblox::IBAPBase;


use vars qw( @ISA $_object_type %_allowed_members %_name_mappings
             @_return_fields %_object_to_ibap %_ibap_to_object
             %_reverse_name_mappings $_return_fields_initialized
             %_capabilities %_searchable_fields );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
	);

    $_object_type = 'MsAdSitesDomain';
    register_wsdl_type('ib:MsAdSitesDomain', 'Infoblox::Grid::MSServer::AdSites::Domain');

    %_allowed_members = (
                         'ea_definition'       => {readonly => 1},
                         'name'                => {simple => 'asis', readonly => 1},
                         'netbios'             => {simple => 'asis', readonly => 1},
                         'network_view'        => {readonly => 1},
                         'ms_sync_master_name' => {simple => 'asis', readonly => 1},
                         'read_only'           => {simple => 'bool', readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                      'netbios'      => 'netbios_name',
                      'name'         => 'dns_name',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           'name'          => [\&ibap_o2i_string, 'dns_name', 'REGEX'],
                           'netbios'       => [\&ibap_o2i_string, 'netbios_name', 'REGEX'],
                           'network_view'  => [\&ibap_o2i_network_view, 'network_view', 'EXACT'],
                           'ea_definition' => [\&__o2i_ext_attr_def__, 'ea_definition', 'EXACT'],
    );

    %_ibap_to_object = (
                        'ea_definition' => \&ibap_i2o_object_name,
                        'network_view'  => \&ibap_i2o_object_name,
    );

    @_return_fields = (
                       tField('dns_name'),
                       tField('ms_sync_master_name'),
                       tField('netbios_name'),
                       tField('read_only'),
                       tField('ea_definition', {sub_fields => [tField('name')]}),
                       tField('network_view',  {sub_fields => [tField('name')]}),
    );

    $_return_fields_initialized = 0;
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members)) {

        return;
    }

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_to_object__ {

	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'read_only'} = 0 unless defined $$ibap_object_ref{'read_only'};

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    return $res;
}

sub __ibap_capabilities__ {

	my ($self, $what) = @_;
	return $_capabilities{$what};
}

#
#
#

sub __o2i_ext_attr_def__ {

    my ($self, $session, $current, $tempref, $type) = @_;

    if($$tempref{$current}) {
        return (1, 0, ibap_readfield_simple_string('ExtensibleAttributeDefinition', 'name', $$tempref{$current}, 'ea_definition'));
    } else {
        return (0);
    }
}


package Infoblox::Grid::MSServer::AdUser;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             @_return_fields
             $_object_type
             %_ibap_to_object
             %_name_mappings
             %_reverse_name_mappings
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'ms_ad_user';
    register_wsdl_type('ib:ms_ad_user', 'Infoblox::Grid::MSServer::AdUser');

    %_allowed_members = (
                         'enable_user_sync'                  => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                                 use => 'override_enable_user_sync', use_truefalse => 1},
                         'last_sync_detail'                  => {simple => 'asis', readonly => 1},
                         'last_sync_status'                  => {simple => 'asis', readonly => 1},
                         'last_sync_time'                    => {simple => 'asis', readonly => 1},
                         'login_name'                        => {simple => 'asis', validator => \&ibap_value_o2i_string,
                                                                 use => 'override_login', use_truefalse => 1},
                         'login_password'                    => {writeonly => 1, validator => \&ibap_value_o2i_string},
                         'override_enable_user_sync'         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'override_login'                    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'override_synchronization_interval' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'synchronization_interval'          => {simple => 'asis', validator => \&ibap_value_o2i_uint,
                                                                 use => 'override_synchronization_interval', use_truefalse => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'enable_user_sync'                  => 'enable_ad_user_sync',
                       'last_sync_time'                    => 'last_sync_ts',
                       'override_enable_user_sync'         => 'use_enable_ad_user_sync',
                       'override_login'                    => 'use_login',
                       'override_synchronization_interval' => 'use_synchronization_min_delay',
                       'synchronization_interval'          => 'synchronization_min_delay',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('enable_ad_user_sync'),
                       tField('last_sync_detail'),
                       tField('last_sync_status'),
                       tField('last_sync_ts'),
                       tField('login_name'),
                       tField('login_password'),
                       tField('synchronization_min_delay'),
                       tField('use_enable_ad_user_sync'),
                       tField('use_login'),
                       tField('use_synchronization_min_delay'),
    );

    %_ibap_to_object = (
                        'enable_ad_user_sync'           => \&ibap_i2o_boolean,
                        'use_enable_ad_user_sync'       => \&ibap_i2o_boolean,
                        'use_login'                     => \&ibap_i2o_boolean,
                        'use_synchronization_min_delay' => \&ibap_i2o_boolean,
                        'last_sync_ts'                  => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    %_object_to_ibap = (
                        'enable_user_sync'                  => \&ibap_o2i_boolean,
                        'last_sync_detail'                  => \&ibap_o2i_ignore,
                        'last_sync_status'                  => \&ibap_o2i_ignore,
                        'last_sync_time'                    => \&ibap_o2i_ignore,
                        'login_name'                        => \&ibap_o2i_string,
                        'login_password'                    => \&ibap_o2i_string,
                        'override_enable_user_sync'         => \&ibap_o2i_boolean,
                        'override_login'                    => \&ibap_o2i_boolean,
                        'override_synchronization_interval' => \&ibap_o2i_boolean,
                        'synchronization_interval'          => \&ibap_o2i_uint,
    );
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members)) {

        return;
    }

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    foreach (
             'enable_ad_user_sync',
             'use_enable_ad_user_sync',
             'use_login',
             'use_synchronization_min_delay',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    $self->{'override_enable_user_sync'}         = ibap_value_i2o_boolean($$ibap_object_ref{'use_enable_ad_user_sync'});
    $self->{'override_login'}                    = ibap_value_i2o_boolean($$ibap_object_ref{'use_login'});
    $self->{'override_synchronization_interval'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_synchronization_min_delay'});

    return $res;
}


package Infoblox::Grid::MSServer::AdUser::Data;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             @_return_fields
             $_object_type
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'ms_ad_user_data';
    register_wsdl_type('ib:ms_ad_user_data', 'Infoblox::Grid::MSServer::AdUser::Data');

    %_allowed_members = (
                         'active_users_count' => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('active_users_count'),
    );

    %_object_to_ibap = (
                        'active_users_count' => \&ibap_o2i_ignore,
    );

}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members)) {

        return;
    }

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}


package Infoblox::Grid::MSServer::DCNSRecordCreation;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            @ISA
            @_return_fields
            $_object_type
            %_allowed_members
            %_object_to_ibap
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'ms_dc_ns_record_creation';
    register_wsdl_type('ib:ms_dc_ns_record_creation', 'Infoblox::Grid::MSServer::DCNSRecordCreation');



    %_allowed_members = (
                         'address' => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'comment' => {simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'address' => \&ibap_o2i_string,
                        'comment' => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('address'),
                       tField('comment'),
    );
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}


1;
