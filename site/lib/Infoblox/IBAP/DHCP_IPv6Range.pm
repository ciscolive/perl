package Infoblox::DHCP::IPv6Range;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members %_return_field_overrides
             @_return_fields @_optional_return_fields %_searchable_fields %_object_to_ibap
             %_name_mappings %_reverse_name_mappings %_ibap_to_object
             $_return_fields_initialized %_capabilities);
@ISA = qw (Infoblox::IBAPBase);


BEGIN {
    $_object_type = 'IPv6DhcpRange';
    register_wsdl_type('ib:IPv6DhcpRange', 'Infoblox::DHCP::IPv6Range');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         address_type            => {simple => 'asis', enum => ['ADDRESS', 'PREFIX', 'BOTH'] },
                         comment                 => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         disable                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         end_addr                => {simple => 'asis', validator => \&ibap_value_o2i_ipv6addr},
                         exclude                 => {array => 1, validator => {'Infoblox::DHCP::ExclusionRange' => 1}},
                         extattrs                => {special => 'extensible_attributes'},
                         extensible_attributes   => {special => 'extensible_attributes'},
                         ipv6_end_prefix         => {simple => 'asis', validator => \&ibap_value_o2i_ipv6_network_or_address},
                         ipv6_prefix_bits        => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         ipv6_start_prefix       => {simple => 'asis', validator => \&ibap_value_o2i_ipv6_network_or_address},
                         member                  => 0,
                         name                    => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         network                 => {mandatory => 1, validator => \&ibap_value_o2i_ipv6_network},
                         network_view            => {validator => { 'Infoblox::DHCP::View' => 1 }},
                         override_recycle_leases => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         recycle_leases          => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_recycle_leases', use_truefalse => 1},
                         server_association_type => {simple => 'asis', enum => [ 'NONE', 'MEMBER']},
                         start_addr              => {simple => 'asis', validator => \&ibap_value_o2i_ipv6addr},
                         template                => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         enable_discovery                => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_enable_discovery', use_members => ['enable_discovery', 'discovery_member'], use_truefalse => 1},     
                         override_enable_discovery       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         discovery_member                => {validator => \&ibap_value_o2i_string, use => 'override_enable_discovery', use_members => ['enable_discovery', 'discovery_member'], use_truefalse => 1},
                         discovery_basic_poll_settings   => {validator => {'Infoblox::Grid::Discovery::BasicPollSettings' => 1}, use => 'override_discovery_basic_poll_settings', use_truefalse => 1},    
                         enable_immediate_discovery      => {simple => 'bool', writeonly => 1, validator => \&ibap_value_o2i_boolean},
                         override_discovery_basic_poll_settings => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         discover_now_status             => {simple => 'asis', readonly => 1},
                         discovery_blackout_setting      => {validator => {'Infoblox::Grid::Discovery::Properties::BlackoutSetting' => 1}, use => 'override_blackout_setting', 'use_members' => ['discovery_blackout_setting', 'port_control_blackout_setting'], use_truefalse => 1},
                         port_control_blackout_setting   => {validator => {'Infoblox::Grid::Discovery::Properties::BlackoutSetting' => 1}, use => 'override_blackout_setting', 'use_members' => ['discovery_blackout_setting', 'port_control_blackout_setting'], use_truefalse => 1},
                         same_port_control_discovery_blackout   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         override_blackout_setting       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cloud_info                      => {validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
                         restart_if_needed               => {simple => 'bool', validator => \&ibap_value_o2i_boolean, writeonly => 1},
                         endpoint_sources                => {readonly => 1, array => 1, validator => {'Infoblox::CiscoISE::Endpoint' => 1}},
                         override_subscribe_settings     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         subscribe_settings              => {use => 'override_subscribe_settings', use_truefalse => 1,
                                                             validator => {'Infoblox::CiscoISE::SubscribeSetting' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'disable'                 => 'disabled',
                       'extattrs'                => 'extensible_attributes',
                       'end_addr'                => 'end_address' ,
                       'exclude'                 => 'exclusion_ranges',
                       'ipv6_end_prefix'         => 'v6_end_prefix',
                       'ipv6_prefix_bits'        => 'v6_prefix_bits',
                       'ipv6_start_prefix'       => 'v6_start_prefix',
                       'network'                 => 'parent',
                       'override_recycle_leases' => 'use_recycle_leases',
                       'start_addr'              => 'start_address' ,
                       'discovery_basic_poll_settings'          => 'basic_polling_settings',
                       'override_discovery_basic_poll_settings' => 'use_basic_polling_settings',
                       'override_enable_discovery'              => 'use_member_enable_discovery',
                       'override_blackout_setting'              => 'use_blackout_setting',
                       'override_subscribe_settings'            => 'use_subscribe_settings',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                address_type                           => [],
                                comment                                => [],
                                disable                                => [],
                                end_addr                               => [],
                                exclude                                => [],
                                extattrs                               => [],
                                extensible_attributes                  => [],
                                ipv6_end_prefix                        => [],
                                ipv6_prefix_bits                       => [],
                                ipv6_start_prefix                      => [],
                                member                                 => [],
                                name                                   => [],
                                network                                => [],
                                network_view                           => [],
                                override_recycle_leases                => [],
                                recycle_leases                         => ['use_recycle_leases'],
                                server_association_type                => [],
                                start_addr                             => [],
                                enable_discovery                       => ['discovery_member','use_member_enable_discovery'],
                                override_enable_discovery              => [],
                                discovery_member                       => ['enable_discovery','use_member_enable_discovery'],
                                discovery_basic_poll_settings          => ['use_basic_polling_settings'],
                                override_discovery_basic_poll_settings => [],
                                discover_now_status                    => [],
                                discovery_blackout_setting             => ['port_control_blackout_setting', 'use_blackout_setting'],
                                port_control_blackout_setting          => ['discovery_blackout_setting', 'use_blackout_setting'],
                                override_blackout_setting              => [],
                                same_port_control_discovery_blackout   => [],
                                subscribe_settings                     => ['use_subscribe_settings'],
                                override_subscribe_settings            => [],
                                endpoint_sources                       => [],
                                cloud_info                             => [],
                               );

    %_searchable_fields = (
                           comment               => [\&ibap_o2i_string       ,'comment'       , 'REGEX', 'IGNORE_CASE'],
                           end_addr              => [\&ibap_o2i_string       ,'end_address'   , 'REGEX'],
                           extattrs              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           ipv6_end_prefix       => [\&ibap_o2i_string       ,'v6_end_prefix' , 'REGEX'],
                           ipv6_start_prefix     => [\&ibap_o2i_string       ,'v6_start_prefix' , 'REGEX'],
                           member                => [\&ibap_o2i_member_search,'member'        , 'EXACT'],
                           name                  => [\&ibap_o2i_string       ,'name'          , 'REGEX'],
                           network               => [\&ibap_o2i_ipv6_network ,'parent'        , 'SEARCHONLY_LIST_CONTAIN'],
                           network_view          => [\&ibap_o2i_network_view ,'network_view' , 'EXACT'],
                           start_addr            => [\&ibap_o2i_string       ,'start_address' , 'REGEX'],
						   server_association_type => [\&ibap_o2i_string     ,'server_association_type', 'EXACT'],
                          );

    %_ibap_to_object = (
                        disabled              => \&ibap_i2o_boolean,
                        exclusion_ranges      => \&ibap_i2o_exclusion,
                        extensible_attributes => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        member                => \&ibap_i2o_mixed_member,
                        network_view          => \&ibap_i2o_generic_object_convert,
                        parent                => \&__i2o_network__,
                        recycle_leases        => \&ibap_i2o_boolean,
                        #
                        use_recycle_leases    => \&ibap_i2o_boolean,
                        enable_discovery             => \&ibap_i2o_boolean,
                        use_member_enable_discovery  => \&ibap_i2o_boolean,
                        basic_polling_settings       => \&ibap_i2o_generic_object_convert,
                        use_basic_polling_settings   => \&ibap_i2o_boolean,
                        discovery_member             => \&ibap_i2o_member_byhostname,
                        discovery_blackout_setting    => \&ibap_i2o_generic_object_convert,
                        port_control_blackout_setting => \&ibap_i2o_generic_object_convert,
                        cloud_info                    => \&ibap_i2o_generic_object_convert,
                        'subscribe_settings'          => \&ibap_i2o_generic_object_convert,
                        'endpoint_sources'            => \&ibap_i2o_generic_object_list_convert,
                       );


    %_object_to_ibap = (
                         address_type            => \&ibap_o2i_string,
                         comment                 => \&ibap_o2i_string,
                         disable                 => \&ibap_o2i_boolean,
                         end_addr                => \&ibap_o2i_string,
                         exclude                 => \&ibap_o2i_exclusion,
                         extattrs                => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                         extensible_attributes   => \&ibap_o2i_ignore,
                         ipv6_end_prefix         => \&ibap_o2i_string,
                         ipv6_prefix_bits        => \&ibap_o2i_uint,
                         ipv6_start_prefix       => \&ibap_o2i_string,
                         member                  => \&__o2i_member__,
                         name                    => \&ibap_o2i_string,
                         network                 => \&ibap_o2i_ipv6_network,
                         network_view            => \&ibap_o2i_network_view,
                         override_recycle_leases => \&ibap_o2i_boolean,
                         recycle_leases          => \&ibap_o2i_boolean,
                         server_association_type => \&ibap_o2i_string,
                         start_addr              => \&ibap_o2i_string,
                         template                => \&ibap_o2i_ipv6_range_template,
                         enable_discovery              => \&ibap_o2i_boolean,
                         discovery_member              => \&ibap_o2i_member_byhostname,
                         discovery_basic_poll_settings => \&ibap_o2i_generic_struct_convert,
                         enable_immediate_discovery    => \&ibap_o2i_boolean,
                         override_enable_discovery     => \&ibap_o2i_boolean,
                         override_discovery_basic_poll_settings => \&ibap_o2i_boolean,
                         discover_now_status           => \&ibap_o2i_ignore,
                         discovery_blackout_setting    => \&ibap_o2i_generic_struct_convert,
                         port_control_blackout_setting => \&ibap_o2i_generic_struct_convert,
                         override_blackout_setting     => \&ibap_o2i_boolean,
                         same_port_control_discovery_blackout => \&ibap_o2i_boolean,
                         cloud_info                            => \&ibap_o2i_generic_struct_convert,
                         restart_if_needed                     => \&ibap_o2i_boolean,
                         subscribe_settings                     => \&ibap_o2i_generic_struct_convert,
                         endpoint_sources                       => \&ibap_o2i_ignore,
                         override_subscribe_settings            => \&ibap_o2i_boolean,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('address_type'),
                       tField('comment'),
                       tField('disabled'),
                       tField('end_address'),
                       tField('exclusion_ranges', { depth => 1}),
                       return_fields_extensible_attributes(),
                       tField('name'),
                       tField('parent', { sub_fields => [ tField('address'), tField('cidr')]}),
                       tField('recycle_leases'),
                       tField('server_association_type'),
                       tField('start_address'),
                       #
                       tField('use_recycle_leases'),
                       tField('v6_end_prefix'),
                       tField('v6_prefix_bits'),
                       tField('v6_start_prefix'),
                       tField('member', return_fields_member_basic_data_no_access_ok()),
                       tField('enable_discovery'),
                       tField('use_member_enable_discovery'),
                       tField('use_basic_polling_settings'),
                       tField('discovery_member', {'sub_fields' => [tField('host_name')]}),
                       tField('use_blackout_setting'),
                       tField('same_port_control_discovery_blackout'),
                       tField('use_subscribe_settings'),
                      );

    @_optional_return_fields = (
                                tField('discover_now_status'),
                               );
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    #
    #
    #
    unless($args{'template'} ||
        ($args{'start_addr'} && $args{'end_addr'}) ||
        ($args{'ipv6_start_prefix'} && $args{'ipv6_end_prefix'} && $args{'ipv6_prefix_bits'}))
    {
        set_error_codes(1103,"At least one of start_addr/end_addr or ipv6_start_prefix/ipv6_end_prefix/ipv6_prefix_bits is required." );
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
        $_return_fields_initialized=1;

        my ($tmp, %tmp);

        $tmp = Infoblox::DHCP::View->__new__();
        push @_return_fields, tField('network_view', {
                                                      default_no_access_ok => 1,
                                                      sub_fields           => $tmp->__return_fields__(),
                                                     });
        %tmp = (
                'basic_polling_settings'        => 'Infoblox::Grid::Discovery::BasicPollSettings',
                'discovery_blackout_setting'    => 'Infoblox::Grid::Discovery::Properties::BlackoutSetting',
                'port_control_blackout_setting' => 'Infoblox::Grid::Discovery::Properties::BlackoutSetting',
                'cloud_info'                    => 'Infoblox::Grid::CloudAPI::Info',
                'subscribe_settings'            => 'Infoblox::CiscoISE::SubscribeSetting',
                'endpoint_sources'              => 'Infoblox::CiscoISE::Endpoint',
        );

        foreach my $key (keys %tmp) {
            $tmp = $tmp{$key}->__new__();
            push @_return_fields, tField($key, {sub_fields => $tmp->__return_fields__()});
        }
    }

    $self->{__object_id_cache__} = {};

    #
    unless (defined $self->recycle_leases()) {
        $self->recycle_leases('true');
        $self->override_recycle_leases('false'); # reset the override
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

sub __i2o_network__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
        my $address;

        $address = $$ibap_object_ref{$current}{'address'};
        return $address.'/'.$$ibap_object_ref{$current}{'cidr'};
    } else {
        return;
    }
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->{ '__internal_session_cache_ref__' } = \$session;

    #
    $$ibap_object_ref{'recycle_leases'}                       = 0 unless defined $$ibap_object_ref{'recycle_leases'};
    $$ibap_object_ref{'use_recycle_leases'}                   = 0 unless defined $$ibap_object_ref{'use_recycle_leases'};
    $$ibap_object_ref{'disabled'}                             = 0 unless defined $$ibap_object_ref{'disabled'};
    $$ibap_object_ref{'enable_discovery'}                     = 0 unless defined $$ibap_object_ref{'enable_discovery'};
    $$ibap_object_ref{'use_member_enable_discovery'}          = 0 unless defined $$ibap_object_ref{'use_member_enable_discovery'};
    $$ibap_object_ref{'use_basic_polling_settings'}           = 0 unless defined $$ibap_object_ref{'use_basic_polling_settings'};
    $$ibap_object_ref{'use_blackout_setting'}                 = 0 unless defined $$ibap_object_ref{'use_blackout_setting'};
    $$ibap_object_ref{'same_port_control_discovery_blackout'} = 0 unless defined $$ibap_object_ref{'same_port_control_discovery_blackout'};
    $$ibap_object_ref{'use_subscribe_settings'}               = 0 unless defined $$ibap_object_ref{'use_subscribe_settings'};

    $self->{endpoint_sources} = [];

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{'override_recycle_leases'}                = ibap_value_i2o_boolean($$ibap_object_ref{'use_recycle_leases'});
    $self->{'override_enable_discovery'}              = ibap_value_i2o_boolean($$ibap_object_ref{'use_member_enable_discovery'});
    $self->{'override_discovery_basic_poll_settings'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_basic_polling_settings'});
    $self->{'override_blackout_setting'}              = ibap_value_i2o_boolean($$ibap_object_ref{'use_blackout_setting'});
    $self->{'override_subscribe_settings'}            = ibap_value_i2o_boolean($$ibap_object_ref{'use_subscribe_settings'});

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

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;
    $self->{ '__internal_session_cache_ref__' } = \$session;

    return $self->SUPER::__object_to_ibap__($server, $session);
}

#
#
#
sub next_available_ip
{
    my $self  = shift;

    unless ($self->{ '__internal_session_cache_ref__' } && $self->__object_id__()) {
        set_error_codes(1001,'In order to get the next available ip the object must have been retrieved from the server first');
        return;
    }

    my $session = ${$self->{ '__internal_session_cache_ref__' }};
    return $session->__next_available_ip__($self->__object_id__(),@_);
}

sub member
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'member' };
    }
    else
    {
        my $value = shift;

        #

        if (not defined $value) {
            $self->{ 'server_association_type' } = 'NONE';
            $self->{ 'member' } = $value;
        }
        else
        {
            if (ref($value) eq 'Infoblox::DHCP::Member') {
                $self->{ 'member' } = $value;
                $self->{ 'server_association_type' } = 'MEMBER';
            }
            else
            {
                set_error_codes(1104,'Invalid data type ' . ref($value) . 'for member member.' );
                return;
            }
        }
    }
    return 1;
}

1;
