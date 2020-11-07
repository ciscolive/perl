package Infoblox::DHCP::RoamingHost;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object $_return_fields_initialized @_sub_host_address_fields %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase);


BEGIN {
    $_object_type = 'RoamingHost';
    register_wsdl_type('ib:RoamingHost','Infoblox::DHCP::RoamingHost');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
       bootfile                        => 0,
       bootserver                      => 0,
       client_identifier_prepend_zero                      => 0,
       comment                         => 0,
       ddns_domainname                 => 0,
       override_ddns_domainname         => 0,
       ddns_hostname                   => 0,
       deny_bootp                      => 0,
       dhcp_client_identifier          => 0,
       disable                         => 0,
       enable_ddns                     => 0,
       extensible_attributes           => 0,
       extattrs                        => 0,
       force_roaming_hostname          => 0,
       ignore_dhcp_option_list_request => 0,
       mac                             => 0,
       match_client                    => 0,
       name                            => 1,
       network_view                    => 0,
       nextserver                      => 0,
       options                         => 0,
       pxe_lease_time                  => 0,
       template                        => 0,
       
       #
       
       address_type                    => 0,
       ipv6_client_hostname            => -1,
       ipv6_duid                       => 0,
       override_ipv6_enable_ddns       => 0,
       ipv6_enable_ddns                => 0,
       override_ipv6_ddns_domainname   => 0,
       ipv6_ddns_domainname            => 0,
       ipv6_ddns_hostname              => 0,
       ipv6_force_roaming_hostname     => 0,
       override_ipv6_options           => 0,
       ipv6_options                    => 0,
       override_ipv6_domain_name       => 0,
       ipv6_domain_name                => 0,
       override_preferred_lifetime     => 0,
       preferred_lifetime              => 0,
       override_valid_lifetime         => 0,
       valid_lifetime                  => 0,
       ipv6_template                   => 0,
       ipv6_match_option               => 0,
       ipv6_domain_name_servers        => 0,
       override_ipv6_domain_name_servers => 0,
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           dhcp_client_identifier => [\&ibap_o2i_string ,'dhcp_client_identifier'   , 'REGEX'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           mac      => [\&ibap_o2i_string ,'mac_address'   , 'REGEX'],
                           name    => [\&ibap_o2i_string       ,'name'     , 'REGEX'],
                           network_view => [\&ibap_o2i_network_view ,'network_view', 'EXACT'],
                           ipv6_duid                  => [\&ibap_o2i_string ,'duid'         , 'REGEX'],

                          );

    %_name_mappings = (
                       'client_identifier_prepend_zero' => 'prepend_zero',
                       'disable'                        => 'disabled',
                       'mac'                            => 'mac_address',
                       'match_client'                   => 'match_option',
                       'override_ddns_domainname'       => 'use_ddns_domainname',
                       'ipv6_client_hostname'           => 'v6_client_hostname',
                       'ipv6_duid'                      => 'duid',
                       'override_ipv6_enable_ddns'      => 'use_v6_enable_ddns',
                       'ipv6_enable_ddns'               => 'v6_enable_ddns',
                       'override_ipv6_ddns_domainname'  => 'use_v6_ddns_domainname',
                       'ipv6_ddns_domainname'           => 'v6_ddns_domainname',
                       'ipv6_ddns_hostname'             => 'v6_ddns_hostname',
                       'ipv6_force_roaming_hostname'    => 'v6_force_roaming_hostname',
                       'override_ipv6_options'          => 'use_v6_options',
                       'ipv6_options'                   => 'v6_options',
                       'override_ipv6_domain_name'      => 'use_v6_domain_name',
                       'ipv6_domain_name'               => 'v6_domain_name',
                       'override_preferred_lifetime'    => 'use_preferred_lifetime',
                       'override_valid_lifetime'        => 'use_valid_lifetime',
                       'ipv6_template'                  => 'v6_template',
                       'ipv6_match_option'              => 'v6_match_option',
                       'override_ipv6_domain_name_servers' => 'use_v6_domain_name_servers',
                       'ipv6_domain_name_servers'       => 'v6_domain_name_servers',
                       'extattrs'                       => 'extensible_attributes',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'disabled'              => \&ibap_i2o_boolean,
                        'enable_ddns'           => \&ibap_i2o_boolean,
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'force_roaming_hostname' => \&ibap_i2o_boolean,
                        'match_option'          => \&__i2o_match__,
                        'network_view'          => \&ibap_i2o_generic_object_convert,
                        'prepend_zero'          => \&ibap_i2o_boolean,
                        'use_ddns_domainname'   => \&ibap_i2o_boolean,
                        'use_v6_enable_ddns'    => \&ibap_i2o_boolean,
                        'v6_enable_ddns'        => \&ibap_i2o_boolean,
                        'use_v6_ddns_domainname' => \&ibap_i2o_boolean,
                        'use_v6_options'        => \&ibap_i2o_boolean,
                        'v6_options'            => \&ibap_i2o_options,
                        'use_v6_domain_name'    => \&ibap_i2o_boolean,
                        'use_preferred_lifetime' => \&ibap_i2o_boolean,
                        'use_valid_lifetime'    => \&ibap_i2o_boolean,
                        'v6_match_option'       => \&__i2o_match__,
                        'address_type'          => \&ibap_i2o_enums_lc_or_undef,
                        'use_v6_domain_name_servers' => \&ibap_i2o_boolean,
                        'v6_domain_name_servers' => \&ibap_i2o_domain_name_servers,
                        'v6_force_roaming_hostname' => \&ibap_i2o_boolean,
                    );

    %_return_field_overrides = (
                                'allow_query'                         => ['use_allow_query'],
                                'bootfile'                            => ['!bootp_properties'],
                                'bootserver'                          => ['!bootp_properties'],
                                'client_identifier_prepend_zero'      => [],
                                'comment'                             => [],
                                'ddns_domainname'                     => ['use_ddns_domainname'],
                                'override_ddns_domainname'             => [],
                                'ddns_hostname'                       => [],
                                'deny_bootp'                          => ['!bootp_properties'],
                                'dhcp_client_identifier'              => [],
                                'disable'                             => [],
                                'enable_ddns'                         => ['use_enable_ddns'],
                                'extattrs'                            => [],
                                'extensible_attributes'               => [],
                                'force_roaming_hostname'              => [],
                                'ignore_dhcp_option_list_request'     => ['use_ignore_client_requested_options'],
                                'mac'                                 => [],
                                'match_client'                        => [],
                                'name'                                => [],
                                'network'                             => [],
                                'network_view'                        => [],
                                'nextserver'                          => ['!bootp_properties'],
                                'options'                             => ['!common_properties'],
                                'pxe_lease_time'                      => ['!common_properties'],
                                'template'                            => [],
                                'v6_template'                         => [],

                                'ipv6_duid'                           => [],
                                'override_ipv6_enable_ddns'           => [],
                                'ipv6_client_hostname'                => [],
                                'ipv6_enable_ddns'                    => ['use_v6_enable_ddns'],
                                'override_ipv6_ddns_domainname'       => [],
                                'ipv6_ddns_domainname'                => ['use_v6_ddns_domainname'],
                                'ipv6_ddns_hostname'                  => [],
                                'override_ipv6_options'               => [],
                                'ipv6_force_roaming_hostname'         => [],
                                'ipv6_options'                        => ['use_v6_options'],
                                'override_ipv6_domain_name'           => [],
                                'ipv6_domain_name'                    => ['use_v6_domain_name'],
                                'override_preferred_lifetime'         => [],
                                'preferred_lifetime'                  => ['use_preferred_lifetime'],
                                'override_valid_lifetime'             => [],
                                'valid_lifetime'                      => ['use_valid_lifetime'],
                                'address_type'                        => [],
                                'ipv6_match_option'                   => [],
                                'override_ipv6_domain_name_servers'   => [],
                                'ipv6_domain_name_servers'            => ['use_v6_domain_name_servers'],
                               );

    %_object_to_ibap = (
                        'bootfile'                           => \&ibap_o2i_ignore,
                        'bootserver'                         => \&ibap_o2i_ignore,
                        'client_identifier_prepend_zero'     => \&ibap_o2i_boolean,
                        'comment'                            => \&ibap_o2i_string,
                        'ddns_domainname'                    => \&ibap_o2i_string,
                        'ddns_hostname'                      => \&ibap_o2i_string,
                        'deny_bootp'                         => \&ibap_o2i_ignore,
                        'dhcp_client_identifier'             => \&ibap_o2i_string_undef_to_empty,
                        'disable'                            => \&ibap_o2i_boolean,
                        'enable_ddns'                        => \&ibap_o2i_boolean,
                        'extattrs'                           => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes'              => \&ibap_o2i_ignore,
                        'force_roaming_hostname'             => \&ibap_o2i_boolean,
                        'ignore_dhcp_option_list_request'    => \&ibap_o2i_ignore,
                        'mac'                                => \&ibap_o2i_string_undef_to_empty,
                        'match_client'                       => \&__o2i_match__,
                        'name'                               => \&ibap_o2i_string,
                        'network'                            => \&ibap_o2i_network,
                        'network_view'                       => \&ibap_o2i_network_view,
                        'nextserver'                         => \&ibap_o2i_ignore,
                        'options'                            => \&ibap_o2i_ignore,
                        'pxe_lease_time'                     => \&ibap_o2i_ignore,
                        'template'                           => \&__o2i_template__,
                        'ipv6_template'                      => \&__o2i_v6_template__,
                        #

                        'override_ddns_domainname'             => \&ibap_o2i_boolean,
                        'use_enable_ddns'                     => \&ibap_o2i_boolean,

                        'ipv6_duid'                           => \&ibap_o2i_string,
                        'ipv6_client_hostname'                => \&ibap_o2i_ignore,
                        'override_ipv6_enable_ddns'           => \&ibap_o2i_boolean,
                        'ipv6_enable_ddns'                    => \&ibap_o2i_boolean,
                        'override_ipv6_ddns_domainname'       => \&ibap_o2i_boolean,
                        'ipv6_ddns_domainname'                => \&ibap_o2i_string_skip_undef,
                        'ipv6_ddns_hostname'                  => \&ibap_o2i_string,
                        'override_ipv6_options'               => \&ibap_o2i_boolean,
                        'ipv6_force_roaming_hostname'         => \&ibap_o2i_boolean,
                        'ipv6_options'                        => \&ibap_o2i_options,
                        'override_ipv6_domain_name'           => \&ibap_o2i_boolean,
                        'ipv6_domain_name'                    => \&ibap_o2i_string_skip_undef,
                        'override_preferred_lifetime'         => \&ibap_o2i_boolean,
                        'preferred_lifetime'                  => \&ibap_o2i_integer_skip_undef,
                        'override_valid_lifetime'             => \&ibap_o2i_boolean,
                        'valid_lifetime'                      => \&ibap_o2i_integer_skip_undef,
                        'address_type'                        => \&ibap_o2i_enums_lc_or_undef,
                        'ipv6_match_option'                   => \&__o2i_match__,
                        'override_ipv6_domain_name_servers'   => \&ibap_o2i_boolean,
                        'ipv6_domain_name_servers'            => \&ibap_o2i_domain_name_servers,
                        #
                        #
                        #
                        #

                        'use_boot_file'                       => \&ibap_o2i_ignore,
                        'use_boot_server'                     => \&ibap_o2i_ignore,
                        'use_next_server'                     => \&ibap_o2i_ignore,
                        'use_broadcast_address'               => \&ibap_o2i_ignore,
                        'use_deny_bootp'                      => \&ibap_o2i_ignore,
                        'use_domain_name'                     => \&ibap_o2i_ignore,
                        'use_domain_name_servers'             => \&ibap_o2i_ignore,
                        'use_ignore_client_requested_options' => \&ibap_o2i_ignore,
                        'use_lease_time'                      => \&ibap_o2i_ignore,
                        'use_options'                         => \&ibap_o2i_ignore,
                        'use_pxe_lease_time'                  => \&ibap_o2i_ignore,
                        'use_routers'                         => \&ibap_o2i_ignore,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('name'),
                       tField('comment'),
                       tField('ddns_domainname'),
                       tField('ddns_hostname'),
                       tField('dhcp_client_identifier'),
                       tField('disabled'),
                       tField('enable_ddns'),
                       tField('force_roaming_hostname'),
                       tField('ip_address'),
                       tField('mac_address'),
                       tField('match_option'),
                       tField('prepend_zero'),
                       tField('use_enable_ddns'),
                       tField('use_ddns_domainname'),
                       tField('duid'),
                       tField('v6_client_hostname'),
                       tField('use_v6_enable_ddns'),
                       tField('v6_enable_ddns'),
                       tField('use_v6_ddns_domainname'),
                       tField('v6_ddns_domainname'),
                       tField('v6_ddns_hostname'),
                       tField('use_v6_options'),
                       tField('v6_force_roaming_hostname'),
                       tField('v6_options'),
                       tField('use_v6_domain_name' ),
                       tField('v6_domain_name'),
                       tField('use_preferred_lifetime'),
                       tField('use_valid_lifetime'),
                       tField('preferred_lifetime'),
                       tField('valid_lifetime'),
                       tField('address_type'),
                       tField('v6_match_option'),
                       tField('use_v6_domain_name_servers'),
                       tField('v6_domain_name_servers',{ sub_fields => [ tField('address')]}),
                      );

    push @_return_fields, tField('common_properties',
                                 {
                                  depth => 2
                                 }
                                );

    push @_return_fields, tField('bootp_properties',
                                 {
                                  depth => 1
                                 }
                                );


    push @_return_fields, return_fields_extensible_attributes();

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
        my $t = Infoblox::DHCP::View->__new__();
        push @_return_fields, tField('network_view', {
                                                      default_no_access_ok => 1,
                                                      sub_fields => $t->__return_fields__(),
                                                     });

    }

    #
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

sub __i2o_match__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
        if ($$ibap_object_ref{$current} eq 'MAC_ADDRESS') {
            return 'MAC';
        }
        elsif ($$ibap_object_ref{$current} eq 'CLIENT_ID') {
            return 'CLIENT_IDENTIFIER';
        }
        elsif($$ibap_object_ref{$current} eq 'DUID'){
            return 'DUID';
        } 
    } else {
        return;
    }
}

sub __i2o_network__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
        my ($address,$netmask);

        $address = $$ibap_object_ref{$current}{'address'};
        return $address.'/'.$$ibap_object_ref{$current}{'cidr'};
    } else {
        return;
    }
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    #

    $$ibap_object_ref{'v6_force_roaming_hostname'} = 0 unless defined $$ibap_object_ref{'v6_force_roaming_hostname'};
    $$ibap_object_ref{'force_roaming_hostname'} = 0 unless defined $$ibap_object_ref{'force_roaming_hostname'};
    $$ibap_object_ref{'use_enable_ddns'} = 0 unless defined $$ibap_object_ref{'use_enable_ddns'};
    $$ibap_object_ref{'use_ddns_domainname'}          = 0 unless defined $$ibap_object_ref{'use_ddns_domainname'};
    $$ibap_object_ref{'use_v6_enable_ddns'}= 0 unless defined $$ibap_object_ref{'use_v6_enable_ddns'};
    $$ibap_object_ref{'v6_enable_ddns'}= 0 unless defined $$ibap_object_ref{'v6_enable_ddns'};
    $$ibap_object_ref{'use_v6_ddns_domainname'}= 0 unless defined $$ibap_object_ref{'use_v6_ddns_domainname'}; 
    $$ibap_object_ref{'use_v6_options'}= 0 unless defined $$ibap_object_ref{'use_v6_options'}; 
    $$ibap_object_ref{'use_v6_domain_name' }= 0 unless defined $$ibap_object_ref{'use_v6_domain_name' }; 
    $$ibap_object_ref{'use_preferred_lifetime'}= 0 unless defined $$ibap_object_ref{'use_preferred_lifetime'}; 
    $$ibap_object_ref{'use_valid_lifetime'}= 0 unless defined $$ibap_object_ref{'use_valid_lifetime'}; 
    $$ibap_object_ref{'use_v6_domain_name_servers'}= 0 unless defined $$ibap_object_ref{'use_v6_domain_name_servers'}; 

    if (defined $$ibap_object_ref{'common_properties'}) {
        $$ibap_object_ref{'common_properties'}{'use_ignore_client_requested_options'} = 0 unless defined $$ibap_object_ref{'common_properties'}{'use_ignore_client_requested_options'};
        $$ibap_object_ref{'common_properties'}{'ignore_client_requested_options'}    = 0 unless defined $$ibap_object_ref{'common_properties'}{'ignore_client_requested_options'};
    }

    if (defined $$ibap_object_ref{'bootp_properties'}) {
        $$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'}  = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'};
        $$ibap_object_ref{'bootp_properties'}{'use_boot_file'}   = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_boot_file'};
        $$ibap_object_ref{'bootp_properties'}{'use_boot_server'} = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_boot_server'};
        $$ibap_object_ref{'bootp_properties'}{'use_next_server'} = 0 unless defined $$ibap_object_ref{'bootp_properties'}{'use_next_server'};
    }

    #
    $self->{'__initializing_from_ibap__'} = 1;
    $self->client_identifier_prepend_zero('false');
    $self->disable('false');

    $self->deny_bootp('false');
    $self->{ 'use_deny_bootp' } = 0;

    $self->enable_ddns('false');
    $self->{ 'use_enable_ddns' } = 0;

    $self->ignore_dhcp_option_list_request('false');
    $self->{ 'use_ignore_client_requested_options' } = 0;
    delete $self->{'__initializing_from_ibap__'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    if (defined $$ibap_object_ref{'bootp_properties'}) {
        ibap_i2o_bootp_props($self,$session,'bootp_properties',$ibap_object_ref);
    }

    if (defined $$ibap_object_ref{'common_properties'}) {
        ibap_i2o_common_dhcp_props($self,$session,'common_properties',$ibap_object_ref);
    }


    #
    #
    #

    if (defined $$ibap_object_ref{'use_enable_ddns'}) {
        $self->{'use_enable_ddns'}=$$ibap_object_ref{'use_enable_ddns'};
        if ($$ibap_object_ref{'use_enable_ddns'} != 1) {
            delete $self->{'enable_ddns'};
        }
    }

    if (defined $$ibap_object_ref{'bootp_properties'}) {
        if (defined $$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'}) {
            $self->{'use_deny_bootp'}=$$ibap_object_ref{'bootp_properties'}{'use_deny_bootp'};
            if ($self->{'use_deny_bootp'} != 1) {
                delete $self->{'deny_bootp'};
            }
        }

        if (defined $$ibap_object_ref{'bootp_properties'}{'use_boot_file'}) {
            $self->{'use_boot_file'}=$$ibap_object_ref{'bootp_properties'}{'use_boot_file'};
            if ($self->{'use_boot_file'} != 1) {
                delete $self->{'bootfile'};
            }
        }

        if (defined $$ibap_object_ref{'bootp_properties'}{'use_boot_server'}) {
            $self->{'use_boot_server'}=$$ibap_object_ref{'bootp_properties'}{'use_boot_server'};
            if ($self->{'use_boot_server'} != 1) {
                delete $self->{'bootserver'};
            }
        }

        if (defined $$ibap_object_ref{'bootp_properties'}{'use_next_server'}) {
            $self->{'use_next_server'}=$$ibap_object_ref{'bootp_properties'}{'use_next_server'};
            if ($self->{'use_next_server'} != 1) {
                delete $self->{'nextserver'};
            }
        }
    }

    #
    $self->{'override_ddns_domainname'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_domainname'});
    $self->{'override_ipv6_enable_ddns'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_enable_ddns'});
    $self->{'override_ipv6_ddns_domainname'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_ddns_domainname'});
    $self->{'override_ipv6_options'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_options'});
    $self->{'override_ipv6_domain_name'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_domain_name'});
    $self->{'override_preferred_lifetime'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_preferred_lifetime'});
    $self->{'override_valid_lifetime'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_valid_lifetime'});
    $self->{'override_ipv6_domain_name_servers'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_v6_domain_name_servers'});

    return;
}

#
#
#
sub __o2i_template__
{
    my ($self, $session, $current, $tempref) = @_;

    if (not defined $$tempref{$current}) {
        return (1,1, $$tempref{$current});
    } else {
        return (1,0, ibap_readfield_simple_string('FixedAddressTemplate','name',$$tempref{$current}, $current));
    }
}

sub __o2i_v6_template__
{
    my ($self, $session, $current, $tempref) = @_;
    if (not defined $$tempref{$current}) {
        return (1,1, $$tempref{$current});
    } else {
        return (1,0, ibap_readfield_simple_string('IPv6FixedAddressTemplate','name',$$tempref{$current}, $current));
    }
}

sub __o2i_match__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
        my $match;

        if ($$tempref{$current} =~ m/mac/i) {
            $match=ibap_value_o2i_string('MAC_ADDRESS');
        } elsif ($$tempref{$current} =~ m/client_identifier/i) {
            $match=ibap_value_o2i_string('CLIENT_ID');
        }
        elsif($$tempref{$current} =~ m/duid/i){
            $match=ibap_value_o2i_string('DUID');
        }
        else {
            set_error_codes(1104,"Invalid value '$$tempref{$current}' for member match_client." );
            push @return_args, 0;
            return @return_args;
        }

        push @return_args, 1;
        push @return_args, 0;
        push @return_args, $match;

    }
    else {
        push @return_args, 1;
        push @return_args, 0;
        push @return_args, undef;
    }

    return @return_args;
}

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;

    my @write_fields;

    foreach my $current (keys %$self) {
        next if $current =~ m/^__/;

        my %write_arg;
        if (defined $_name_mappings{$current}) {
            $write_arg{'field'} = $_name_mappings{$current};
        }
        else {
            $write_arg{'field'} = $current;
        }

        my @converted_values = $_object_to_ibap{$current}($self, $session, $current,$self);
        if (@converted_values) {
            my $success=shift @converted_values;
            if ($success) {
                my $ignore_value=shift @converted_values;
                $write_arg{'value'} = shift @converted_values;

                foreach my $extra_args (@converted_values) {
                    unshift @write_fields, $extra_args;
                }

                if ($ignore_value) {
                    next;
                }
            } else {
                return;
            }
        } else {
            return;
        }
        unshift @write_fields, \%write_arg;
    }

    unless (defined $self->{'dhcp_client_identifier'}) {
        unshift @write_fields, {
                         'field' => 'dhcp_client_identifier',
                         'value' => tString(''),
                        };
    }


    unless (defined $self->{'mac'}) {
        unshift @write_fields, {
                         'field' => 'mac_address',
                         'value' => tString(''),
                        };
    }

    my @bootp_options = ibap_arg_bootp_props($self, $session, '',$self);
    if (@bootp_options) {
        my $success=shift @bootp_options;
        if ($success) {
            my $ignore_value=shift @bootp_options;
            unless ($ignore_value) {
                my %write_arg;
                $write_arg{'field'} = 'bootp_properties';
                $write_arg{'value'} = shift @bootp_options;
                unshift @write_fields, \%write_arg;
            }
        }
        else {
            return;
        }
    }

    my @common_options = ibap_o2i_common_dhcp_props($self, $session, '',$self);
    if (@common_options) {
        my $success=shift @common_options;
        if ($success) {
            my $ignore_value=shift @common_options;
            unless ($ignore_value) {
                my %write_arg;
                $write_arg{'field'} = 'common_properties';
                $write_arg{'value'} = shift @common_options;
                unshift @write_fields, \%write_arg;
            }
        }
        else {
            return;
        }
    }

    return \@write_fields;
}

#
#
#

sub ignore_dhcp_option_list_request
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ignore_dhcp_option_list_request', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_ignore_client_requested_options'}}, @_);
}

sub deny_bootp
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'deny_bootp', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_deny_bootp'}}, @_);
}


sub ddns_domainname
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ddns_domainname', validator => \&ibap_value_o2i_string, use => \$self->{'override_ddns_domainname'}, use_truefalse => 1}, @_);
}

sub override_ddns_domainname
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_ddns_domainname', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ddns_hostname{
   my $self  = shift;
    return $self->__accessor_scalar__({name => 'ddns_hostname', validator => \&ibap_value_o2i_string}, @_);
}


sub options
{
    my $self  = shift;
    return ibap_accessor_dhcp_options($self, 'options', @_);
}

sub bootfile
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'bootfile', validator => \&ibap_value_o2i_string, use => \$self->{'use_boot_file'}}, @_);
}

sub nextserver
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'nextserver', validator => \&ibap_value_o2i_string, use => \$self->{'use_next_server'}}, @_);
}

sub bootserver
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'bootserver', validator => \&ibap_value_o2i_string, use => \$self->{'use_boot_server'}}, @_);
}


sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub force_roaming_hostname
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'force_roaming_hostname', validator => \&ibap_value_o2i_boolean}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub pxe_lease_time
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'pxe_lease_time' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ 'pxe_lease_time' } = undef;
            $self->{ 'use_pxe_lease_time' } = 0 unless $self->{ 'enable_pxe_lease_time' };
        }
        else
        {
            if ($value !~ m/^[0-9]+$/) {
                set_error_codes(1104,"Invalid value '$value' for member pxe_lease_time." );
                return;
            }
            else {
                $self->{ 'pxe_lease_time' } = $value;
                $self->{ 'use_pxe_lease_time' } = 1;
            }
        }
    }
    return 1;
}

sub enable_ddns
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_ddns', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_enable_ddns'}}, @_);
}

sub match_client
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'match_client' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ 'match_client' } = undef;
        }
        else
        {
            if ($value !~ m/MAC|CLIENT_IDENTIFIER/i) {
                set_error_codes(1104,"Invalid value '$value' for member match_client." );
                return;
            }
            else {
                $self->{ 'match_client' } = $value;
            }
        }
    }
    return 1;
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub client_identifier_prepend_zero
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'client_identifier_prepend_zero', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dhcp_client_identifier
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'dhcp_client_identifier', validator => \&ibap_value_o2i_string}, @_);
}

sub mac
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'mac', validator => \&ibap_value_o2i_string}, @_);
}


sub network_view
{
    my $self = shift;

    return $self->__accessor_scalar__({name => 'network_view', validator => { 'Infoblox::DHCP::View' => 1 }}, @_);
}

sub template
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'template', validator => \&ibap_value_o2i_string}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}


sub ipv6_enable_ddns
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv6_enable_ddns', validator => \&ibap_value_o2i_boolean, use => \$self->{'override_ipv6_enable_ddns'}, use_truefalse => 1}, @_);
}

sub override_ipv6_enable_ddns
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_enable_ddns', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_ddns_hostname
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv6_ddns_hostname', validator => \&ibap_value_o2i_string}, @_);
}

sub ipv6_ddns_domainname
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv6_ddns_domainname', validator => \&ibap_value_o2i_string, use => \$self->{'override_ipv6_ddns_domainname'}, use_truefalse => 1}, @_);
}

sub override_ipv6_ddns_domainname
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_ddns_domainname', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_options
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'ipv6_options', validator => {'Infoblox::DHCP::Option' => 1}, use => \$self->{'override_ipv6_options'}, use_truefalse => 1}, @_);
}

sub override_ipv6_options
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_options', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_domain_name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv6_domain_name', validator => \&ibap_value_o2i_string, use => \$self->{'override_ipv6_domain_name'}, use_truefalse => 1}, @_);
}

sub override_ipv6_domain_name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_domain_name', validator => \&ibap_value_o2i_boolean}, @_);
}

sub preferred_lifetime
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'preferred_lifetime', validator => \&ibap_value_o2i_int, use => \$self->{'override_preferred_lifetime'}, use_truefalse => 1}, @_);
}

sub override_preferred_lifetime
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_preferred_lifetime', validator => \&ibap_value_o2i_boolean}, @_);
}

sub valid_lifetime
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'valid_lifetime', validator => \&ibap_value_o2i_int, use => \$self->{'override_valid_lifetime'}, use_truefalse => 1}, @_);
}

sub override_valid_lifetime
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_valid_lifetime', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_duid
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv6_duid', validator => \&ibap_value_o2i_string}, @_);
}


sub ipv6_template
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv6_template', validator => \&ibap_value_o2i_string}, @_);
}

sub ipv6_domain_name_servers
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv6_domain_name_servers', validator => \&ibap_value_o2i_string, use => \$self->{'override_ipv6_domain_name_servers'}, use_truefalse => 1}, @_);
}

sub override_ipv6_domain_name_servers
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_ipv6_domain_name_servers', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ipv6_match_option
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv6_match_option', enum => ['DUID','duid']}, @_);
}

sub address_type
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'address_type', enum => ['ipv4','ipv6','both']}, @_);
}

sub ipv6_client_hostname
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ipv6_client_hostname', readonly => 1},@_);
}

sub ipv6_force_roaming_hostname
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6_force_roaming_hostname', validator => \&ibap_value_o2i_boolean}, @_);
}

1;
