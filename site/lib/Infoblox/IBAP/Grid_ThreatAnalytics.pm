package Infoblox::Grid::ThreatAnalytics;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( 
            $_object_type
            $_return_fields_initialized
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_return_field_overrides
            %_reverse_name_mappings 
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_MODIFY_ONLY );

BEGIN {

    #
    #
    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                      'single_serialization' => 0,
    );

    $_object_type = 'GridAnalytics';
    register_wsdl_type('ib:GridAnalytics', 'Infoblox::Grid::ThreatAnalytics');

    %_allowed_members = (
                         'current_moduleset'                        => {validator => {'Infoblox::Grid::ThreatAnalytics::ModuleSet' => 1}},
                         'dns_tunnel_black_list_rpz_zones'          => {array => 1, validator => {'Infoblox::DNS::Zone' => 1}},
                         'dns_tunnel_black_list_rpz_zone'           => {skip_accessor => 1, validator => {'Infoblox::DNS::Zone' => 1}},
                         'enable_auto_download'                     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_scheduled_download'                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'last_checked_for_update'                  => {readonly => 1},
                         'last_module_update_time'                  => {readonly => 1},
                         'last_module_update_version'               => {simple => 'asis', readonly => 1},
                         'last_whitelist_update_time'               => {readonly => 1},
                         'last_whitelist_update_version'            => {simple => 'asis', readonly => 1},
                         'module_update_policy'                     => {simple => 'asis', enum => ['AUTOMATIC', 'MANUAL']},
                         'scheduled_download'                       => {validator => {'Infoblox::Grid::ScheduleSetting' => 1}},
    );

    %_name_mappings = (
                       'dns_tunnel_black_list_rpz_zones'          => 'active_blacklist_rpz_list',
                       'dns_tunnel_black_list_rpz_zone'           => 'active_blacklist_rpz_list',
                       'last_module_update_time'                  => 'last_module_update_timestamp',
                       'last_whitelist_update_time'               => 'last_whitelist_update_timestamp',
    );

    %_reverse_name_mappings = (
        reverse(%_name_mappings),
        'active_blacklist_rpz_list' => 'dns_tunnel_black_list_rpz_zones',
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('enable_auto_download'),
                       tField('enable_scheduled_download'),
                       tField('last_checked_for_update'),
                       tField('last_module_update_timestamp'),
                       tField('last_module_update_version'),
                       tField('last_whitelist_update_timestamp'),
                       tField('last_whitelist_update_version'),
                       tField('module_update_policy'),
    );

    %_ibap_to_object = (
                        'active_blacklist_rpz_list'       => \&ibap_i2o_generic_object_list_convert,
                        'current_moduleset'               => \&ibap_i2o_generic_object_convert,
                        'last_checked_for_update'         => \&ibap_i2o_datetime_to_unix_timestamp,
                        'last_module_update_timestamp'    => \&ibap_i2o_datetime_to_unix_timestamp,
                        'last_whitelist_update_timestamp' => \&ibap_i2o_datetime_to_unix_timestamp,
                        'scheduled_download'              => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                        'current_moduleset'                        => \&ibap_o2i_object_only_by_oid,
                        'dns_tunnel_black_list_rpz_zones'          => \&ibap_o2i_object_only_by_oid_or_undef,
                        'enable_auto_download'                     => \&ibap_o2i_boolean,
                        'enable_scheduled_download'                => \&ibap_o2i_boolean,
                        'last_checked_for_update'                  => \&ibap_o2i_ignore,
                        'last_module_update_time'                  => \&ibap_o2i_ignore,
                        'last_module_update_version'               => \&ibap_o2i_ignore,
                        'last_whitelist_update_time'               => \&ibap_o2i_ignore,
                        'last_whitelist_update_version'            => \&ibap_o2i_ignore,
                        'module_update_policy'                     => \&ibap_o2i_string,
                        'scheduled_download'                       => \&ibap_o2i_generic_struct_convert,
    );

    %_return_field_overrides = (
                                'current_moduleset'                        => [],
                                'dns_tunnel_black_list_rpz_zones'          => [],
                                'dns_tunnel_black_list_rpz_zone'           => [],
                                'enable_auto_download'                     => [],
                                'enable_scheduled_download'                => [],
                                'last_checked_for_update'                  => [],
                                'last_module_update_time'                  => [],
                                'last_module_update_version'               => [],
                                'last_whitelist_update_time'               => [],
                                'last_whitelist_update_version'            => [],
                                'module_update_policy'                     => [],
                                'scheduled_download'                       => [],
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

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my ($t, %tmp);

        %tmp = (
                'active_blacklist_rpz_list' => 'Infoblox::DNS::Zone',
                'current_moduleset'         => 'Infoblox::Grid::ThreatAnalytics::ModuleSet',
                'scheduled_download'        => 'Infoblox::Grid::ScheduleSetting',
        );

        foreach my $key (keys %tmp) {

            $t = $tmp{$key}->__new__();
            push @_return_fields, tField($key, {sub_fields => $t->__return_fields__()});
        }
    }
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->{'__internal_session_cache_ref__'} = $session;

    foreach (
             'enable_auto_download',
             'enable_scheduled_download',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    $self->{dns_tunnel_black_list_rpz_zones} = [] unless defined $self->{dns_tunnel_black_list_rpz_zones};

    return $res;
}


sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

#
#
#

sub update_threat_analytics_moduleset {

    my ($self, %args) = @_;
    my ($fname, $fargs, $fheader) = ('UpdateAnalyticModuleSet', {}, {});

    #
    #
    #

    unless ($self->{'__internal_session_cache_ref__'}) {

        set_error_codes('1012', 'In order to update Analytics ModuleSet' . 
            ' the object must have been retrieved from the server first');

        return 0;
    }

    my $session = $self->{'__internal_session_cache_ref__'};

    my %_allowed_mode = (
        'TEST'    => 1,
        'EXECUTE' => 1,
    );

    if ($args{'mode'}) {

        unless ($_allowed_mode{$args{mode}}) {

            set_error_codes('1012', "Invalid 'mode' value. Valid values are: '" .
                (join "', '", (keys %_allowed_mode)) . "'.", $session);

            return 0;
        }
    }

    #
    #
    #

    $args{'mode'} = 'EXECUTE' unless defined $args{'mode'};

    #
    #
    #

    $$fheader{request_settings}{mode} = tString($args{'mode'});

    #
    #
    #

    my $server = $session->get_ibap_server() || return 0;

    my $result;
    eval {
        $result = $server->ibap_request($fname, $fargs, $fheader);
    };

    #
    #
    #

    return $server->set_papi_error($@, $session, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $session);

    return 1;

    #
    #
    #
}


sub test_threat_analytics_server_connectivity {

    my $self = shift;
    my ($fname, $fargs) = ('TestAnalyticServerConnectivity', {});

    #
    #
    #

    unless ($self->{'__internal_session_cache_ref__'}) {

        set_error_codes('1012', 'In order to test Analytics Server connectivity' .
            ' the object must have been retrieved from the server first');

        return 0;
    }

    my $session = $self->{'__internal_session_cache_ref__'};

    #
    #
    #

    my $server = $session->get_ibap_server() || return 0;

    my $result;
    eval {
        $result = $server->ibap_request($fname, $fargs);
    };

    #
    #
    #

    return $server->set_papi_error($@, $session, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $session);

    my $response = Infoblox::Grid::TestResult->__new__();
    $response->__ibap_to_object__($result);

    return $response;

    #
    #
    #
}

sub download_threat_analytics_moduleset_update {

    my ($self, %args) = @_;
    my ($fname, $fargs) = ('DownloadAnalyticModuleSetUpdate', {});

    unless ($self->{'__internal_session_cache_ref__'}) {

        set_error_codes('1012', 'In order to download Analytics ModuleSet' . 
            ' update the object must have been retrieved from the server first');

        return 0;
    }

    my $session = $self->{'__internal_session_cache_ref__'};
    my $server = $session->get_ibap_server() || return 0;

    my $result;
    eval {
        $result = $server->ibap_request($fname, $fargs);
    };

    return $server->set_papi_error($@, $session, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $session);

    return 1;
}
  
#
sub dns_tunnel_black_list_rpz_zone {
    my $self = shift;

    my $vals = $self->dns_tunnel_black_list_rpz_zones();

    if (defined $vals and scalar @$vals > 1) {
        set_error_codes('1103', 'dns_tunnel_black_list_rpz_zone is deprecated, ' .
                                'use dns_tunnel_black_list_rpz_zones instead.');
        return undef;
    }

    if (@_) {
        my $val = shift;
        return $self->dns_tunnel_black_list_rpz_zones(defined $val ? [$val] : []);
    } else {
        if (not defined $vals or not scalar @$vals) {
            return undef;
        } elsif (scalar @$vals) {
            return $$vals[0];
        }
    }
}


package Infoblox::Grid::ThreatAnalytics::Member;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( %_capabilities
             %_allowed_members
             %_searchable_fields
             @_return_fields
             $_return_fields_initialized
             $_object_type
             %_ibap_to_object
             %_object_to_ibap
             @ISA
             %_name_mappings
             %_reverse_name_mappings );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'MemberAnalytics';
    register_wsdl_type('ib:MemberAnalytics', 'Infoblox::Grid::ThreatAnalytics::Member');

    %_allowed_members = (
                         'comment'        => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'enable_service' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'ipv4addr'       => {simple => 'asis', readonly => 1},
                         'ipv6addr'       => {simple => 'asis', readonly => 1},
                         'name'           => {simple => 'asis', readonly => 1},
                         'status'         => {simple => 'asis', readonly => 1,
                                              enum => ['FAILED', 'INACTIVE', 'UNKNOWN', 'WARNING', 'WORKING']},
    );

    %_name_mappings = (
                       'ipv4addr' => 'address',
                       'ipv6addr' => 'ipv6_address',
                       'name'     => 'host_name',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'comment'  => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'ipv4addr' => [\&ibap_o2i_string, 'address', 'REGEX'],
                           'ipv6addr' => [\&ibap_o2i_string, 'ipv6_address', 'REGEX'],
                           'name'     => [\&ibap_o2i_string, 'host_name', 'REGEX'],
                           'status'   => [\&ibap_o2i_string, 'status', 'EXACT'],
    );

    @_return_fields = (
                       tField('comment'),
                       tField('enable_service'),
                       tField('address'),
                       tField('ipv6_address'),
                       tField('host_name'),
                       tField('status'),
    );

    %_ibap_to_object = (
                        'enable_service' => \&ibap_i2o_boolean,
    );

    %_object_to_ibap = (
                        'comment'        => \&ibap_o2i_string,
                        'enable_service' => \&ibap_o2i_boolean,
                        'ipv4addr'       => \&ibap_o2i_ignore,
                        'ipv6addr'       => \&ibap_o2i_ignore,
                        'name'           => \&ibap_o2i_ignore,
                        'status'         => \&ibap_o2i_ignore,
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

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->{'__internal_session_cache_ref__'} = $session;
    $$ibap_object_ref{'enable_service'} = 0 unless defined $$ibap_object_ref{'enable_service'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub move_black_list_rpz_cnames_to_threat_analytics_whitelist {

    my ($self, @cnames) = @_;

    unless ($self->{'__internal_session_cache_ref__'}) {

        set_error_codes(1012, 'In order to move RPZ CNAME '  . 
            'records to Analytics Whitelist the objects must ' .
            'have been retrieved from the server first');

        return 0;
    }

    my $session = $self->{'__internal_session_cache_ref__'};

    unless (@cnames and check_vector_type(\@cnames, ['Infoblox::DNS::RPZRecord::CNAME'])) {
        set_error_codes(1103, "List of RPZ CNAME objects is required", $session);
        return 0;
    }
    my $server = $session->get_ibap_server();
    unless (defined $server) {

        return set_error_codes(1006, 'Creating session' .
            ' with the server failed.', $session);
    }

    my ($fargs, $fname) = ({},
        'MoveBlackListRPZToAnalyticsDomainWhiteList');

    $$fargs{'rpz_cnames'} = ibap_o2i_object_by_oid_or_name(
        $self, $session, 'cnames', {cnames => \@cnames});

    return 0 unless $$fargs{'rpz_cnames'};

    my $result;
    eval { $result = $server->ibap_request($fname, $fargs) };

    return $server->set_papi_error($@, $session, undef, '1012=1001') if $@;
    set_error_codes(0, undef, $session);

    return 1;
}


package Infoblox::Grid::ThreatAnalytics::WhiteList;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( %_capabilities
             %_allowed_members
             %_searchable_fields
             @_return_fields
             $_return_fields_initialized
             $_object_type
             %_ibap_to_object
             %_object_to_ibap
             @ISA
             %_name_mappings
             %_reverse_name_mappings );

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'AnalyticsDomainWhiteList';
    register_wsdl_type('ib:AnalyticsDomainWhiteList', 'Infoblox::Grid::ThreatAnalytics::WhiteList');

    %_allowed_members = (
                         'comment' => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'disable' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'fqdn'    => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'type'    => {simple => 'asis', readonly => 1, enum => ['SYSTEM', 'CUSTOM', 'BOTH']},
    );

    %_name_mappings = (
                       'disable' => 'disabled',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'comment' => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'fqdn'    => [\&ibap_o2i_string, 'fqdn', 'REGEX'],
                           'type'    => [\&ibap_o2i_string, 'type', 'EXACT'],
    );

    @_return_fields = (
                       tField('fqdn'),
                       tField('comment'),
                       tField('disabled'),
                       tField('type'),
    );

    %_ibap_to_object = (
                        'disabled' => \&ibap_i2o_boolean,
    );

    %_object_to_ibap = (
                        'comment' => \&ibap_o2i_string,
                        'disable' => \&ibap_o2i_boolean,
                        'fqdn'    => \&ibap_o2i_string,
                        'type'    => \&ibap_o2i_ignore,
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

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disable'} = 0 unless defined $$ibap_object_ref{'disabled'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::ThreatAnalytics::ModuleSet;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            $_object_type
            %_allowed_members
            %_capabilities
            %_object_to_ibap
            %_return_field_overrides
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    $_object_type = 'AnalyticsModuleSet';
    register_wsdl_type('ib:AnalyticsModuleSet', 'Infoblox::Grid::ThreatAnalytics::ModuleSet');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'version' => {simple => 'asis', readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'version' => [\&ibap_o2i_string, 'version', 'REGEX'],
    );

    %_object_to_ibap = (
                        'version' => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('version'),
    );

    %_return_field_overrides = (
                                'version' => [],
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

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}


1;
