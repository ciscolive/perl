package Infoblox::DNS::RecordBase;

#
#
#

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
            $_object_type
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

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'cloud_info'            => {readonly => 1, validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
                         'comment'               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'creation_time'         => {readonly => 1},
                         'creator'               => {simple => 'asis', enum => ['STATIC', 'DYNAMIC', 'SYSTEM']},
                         'ddns_principal'        => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'ddns_protected'        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'disable'               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'dns_name'              => {simple => 'asis', readonly => 1},
                         'extattrs'              => {special => 'extensible_attributes'},
                         'extensible_attributes' => {special => 'extensible_attributes'},
                         'forbid_reclamation'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'name'                  => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'reclaimable'           => {simple => 'bool', readonly => 1},
                         'ttl'                   => {validator => \&ibap_value_o2i_uint, use => 'use_ttl'},
                         'views'                 => {array => 1, validator => { 'Infoblox::DNS::View' => 1 }},
                         'zone'                  => {simple => 'asis', readonly => 1},
                         'last_queried'          => {readonly => 1},
    );

    %_name_mappings = (
                       'disable'       => 'disabled',
                       'name'          => 'fqdn',
                       'views'         => 'view',
                       'zone'          => 'parent',
                       'creation_time' => 'creation_timestamp',
                       'dns_name'      => 'dns_fqdn',
                       'extattrs'      => 'extensible_attributes',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           'comment'               => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           'view'                  => [\&ibap_o2i_view, 'view', 'EXACT'],
                           'views'                 => [\&ibap_o2i_view, 'view', 'EXACT'],
                           'name'                  => [\&ibap_o2i_string, 'fqdn', 'REGEX'],
                           'zone'                  => [\&ibap_o2i_string, 'parent', 'EXACT'],
                           'extattrs'              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'creator'               => [\&ibap_o2i_string, 'creator', 'EXACT'],
                           'ddns_principal'        => [\&ibap_o2i_string, 'ddns_principal', 'REGEX'],
                           'reclaimable'           => [\&ibap_o2i_boolean, 'reclaimable', 'EXACT'],
    );

    @_return_fields = (
                       tField('comment'),
                       tField('disabled'),
                       tField('fqdn'),
                       tField('dns_fqdn'),
                       tField('parent'),
                       tField('ttl'),
                       tField('use_ttl'),
                       tField('creator'),
                       tField('creation_timestamp'),
                       tField('ddns_principal'),
                       tField('ddns_protected'),
                       tField('reclaimable'),
                       tField('forbid_reclamation'),
                       tField('last_queried'),
                       return_fields_extensible_attributes(),
    );

    %_ibap_to_object = (
                        'disabled'              => \&ibap_i2o_boolean,
                        'view'                  => \&ibap_i2o_generic_object_convert_to_list_of_one,
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'cloud_info'            => \&ibap_i2o_generic_object_convert,
                        'creation_timestamp'    => \&ibap_i2o_datetime_to_unix_timestamp,
                        'last_queried'          => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    %_object_to_ibap = (
                        'comment'               => \&ibap_o2i_string,
                        'disable'               => \&ibap_o2i_boolean,
                        'name'                  => \&ibap_o2i_string,
                        'ttl'                   => \&ibap_o2i_ttl,
                        'use_ttl'               => \&ibap_o2i_ignore,
                        'views'                 => \&ibap_o2i_view,
                        'zone'                  => \&ibap_o2i_ignore,
                        'cloud_info'            => \&ibap_o2i_ignore,
                        'creation_time'         => \&ibap_o2i_ignore,
                        'creator'               => \&ibap_o2i_string,
                        'ddns_principal'        => \&ibap_o2i_string,
                        'ddns_protected'        => \&ibap_o2i_boolean,
                        'dns_name'              => \&ibap_o2i_ignore,
                        'extattrs'              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes' => \&ibap_o2i_ignore,
                        'forbid_reclamation'    => \&ibap_o2i_boolean,
                        'reclaimable'           => \&ibap_o2i_ignore,
                        'zone'                  => \&ibap_o2i_ignore,
                        'last_queried'          => \&ibap_o2i_ignore,
    );

    %_return_field_overrides = (
                                 'cloud_info'            => [],
                                 'comment'               => [],
                                 'creation_time'         => [],
                                 'creator'               => [],
                                 'ddns_principal'        => [],
                                 'ddns_protected'        => [],
                                 'disable'               => [],
                                 'dns_name'              => [],
                                 'extattrs'              => [],
                                 'extensible_attributes' => [],
                                 'forbid_reclamation'    => [],
                                 'name'                  => [],
                                 'reclaimable'           => [],
                                 'ttl'                   => ['use_ttl'],
                                 'views'                 => [],
                                 'zone'                  => [],
                                 'last_queried'          => [],
    );
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    no strict 'refs';

    if (!$self->__initialize_members_from_arg_list__(\%{$class . '::_allowed_members'}, \%args) ||
        !$self->__validate_object_required_members__(\%{$class . '::_allowed_members'}))
    {
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

    my $self = shift;
    my $class = ref $self || $self;

    no strict 'refs';
    return ${$class . '::_object_type'};
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    my $class = ref $self || $self;

    no strict 'refs';
    return ${$class . '::_capabilities'}{$what};
}

sub __init_instance_constants__ {

    my $self = shift;
    my $class = ref $self || $self;

    no strict 'refs';

    return if ${$class . '::_return_fields_initialized'};

    my $_ref_return_fields = \@{$class . '::_return_fields'};

    my $tmp;

    $tmp = Infoblox::DNS::View->__new__();
    push @{$_ref_return_fields}, tField('view', {
        default_no_access_ok => 1,
        sub_fields           => $tmp->__return_fields__(),
    });

    $tmp = Infoblox::Grid::CloudAPI::Info->__new__();
    push @{$_ref_return_fields}, tField('cloud_info', {
        sub_fields => $tmp->__return_fields__(),
    });

    ${$class . '::_return_fields_initialized'} = 1;
}

sub __search_mapping_hook_pre__ {

    my ($self, $session, $type, $argsref,
        $out_search_fields_ref, $out_search_types_ref,
        $out_search_matches_ref) = @_;

    #
    if( defined $argsref->{'zone'} && not defined $argsref->{'view'} && not defined $argsref->{'views'} ) {
        $out_search_fields_ref->{'view'} = ibap_readfield_simple('View', 'is_default', tBool(1), 'view=(default view)');
        $out_search_types_ref->{'view'} = 'EXACT';
        $out_search_matches_ref->{'view'} = undef;
    }

    return 1;
}

sub __ibap_to_object__ {

    my $self = shift;
    my ($ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
        'disable',
        'ddns_protected',
        'reclaimable',
        'forbid_reclamation',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }


    my $res = $self->SUPER::__ibap_to_object__(@_);

    if ($$ibap_object_ref{'use_ttl'}) {
        $self->{'use_ttl'} = 1;
    } else {
        $self->{'use_ttl'} = 0;
        $self->ttl(undef);
    }

    return $res;
}


package Infoblox::DNS::Record::A;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;

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

@ISA = qw( Infoblox::DNS::RecordBase );

BEGIN {

    $_object_type = 'ARecord';
    register_wsdl_type('ib:ARecord', 'Infoblox::DNS::Record::A');

    %_capabilities = ();

    %_allowed_members = (
                         'discovered_data' => {readonly => 1, validator => {'Infoblox::Grid::Discovery::Data' => 1}},
                         'ipv4addr'        => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_ipv4addr},
                         'ms_ad_user_data' => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
    );

    %_name_mappings = (
                       'ipv4addr' => 'address',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'discovered_data' => \&ibap_i2o_generic_object_convert,
                        'ms_ad_user_data' => \&ibap_i2o_generic_object_convert,
    );

    %_searchable_fields = (
                           'discovered_data' => [\&Infoblox::Grid::Discovery::Data::__o2i_search_discovered_data__, 'discovered_data', 'EXACT'],
                           'ipv4addr'        => [\&ibap_o2i_string, 'address', 'REGEX'],
    );

    %_return_field_overrides = (
                                'discovered_data' => [],
                                'ipv4addr'        => [],
                                'ms_ad_user_data' => [],
    );


    %_object_to_ibap = (
                        'discovered_data' => \&ibap_o2i_ignore,
                        'ipv4addr'        => \&ibap_o2i_string,
                        'ms_ad_user_data' => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('address'),
                       tField('discovered_data', {depth => 1}),
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    Infoblox::IBAPBase::create_discovered_data_fields(@discovery_common_fields, @vdiscovery_fields, 'mac_address');
};


sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $self->SUPER::__init_instance_constants__();

        my $t = Infoblox::Grid::MSServer::AdUser::Data->__new__();
        push @_return_fields, tField('ms_ad_user_data', {sub_fields => $t->__return_fields__()});
    }
}

sub __ibap_to_object__ {

    my $self = shift;
    my ($ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->{'__initializing_from_ibap__'} = 1;

    $self->last_discovered('');
    $self->mac_address('');
    $self->netbios('');
    $self->os('');
    $self->v_cluster('');
    $self->v_datacenter('');
    $self->v_host('');
    $self->v_name('');
    $self->v_netadapter('');
    $self->v_switch('');
    $self->v_type('');

    delete $self->{'__initializing_from_ibap__'};

    my $res = $self->SUPER::__ibap_to_object__(@_);

    Infoblox::Grid::Discovery::Data::__init_discovered_members__($self);

    return $res;
}


package Infoblox::DNS::Record::PTR;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;

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

@ISA = qw( Infoblox::DNS::RecordBase );

BEGIN {

    $_object_type = 'PtrRecord';
    register_wsdl_type('ib:PtrRecord', 'Infoblox::DNS::Record::PTR');

    %_capabilities = ();

    %_allowed_members = (
                         'discovered_data' => {readonly => 1, validator => {'Infoblox::Grid::Discovery::Data' => 1}},
                         'dns_ptrdname'    => {simple => 'asis', readonly => 1},
                         'ipv4addr'        => 0,
                         'ipv6addr'        => 0,
                         'ms_ad_user_data' => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
                         'name'            => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'ptrdname'        => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
    );

    %_searchable_fields = (
                           'discovered_data' => [\&Infoblox::Grid::Discovery::Data::__o2i_search_discovered_data__, 'discovered_data', 'EXACT'],
                           'ipv4addr'        => [\&ibap_o2i_string, 'address', 'REGEX'],
                           'ipv6addr'        => [\&ibap_o2i_string, 'address', 'REGEX'],
                           'ptrdname'        => [\&ibap_o2i_string, 'dname', 'REGEX'],
    );

    %_name_mappings = (
                       'dns_ptrdname' => 'dns_dname',
                       'ptrdname'     => 'dname',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'discovered_data' => \&ibap_i2o_generic_object_convert,
                        'ms_ad_user_data' => \&ibap_i2o_generic_object_convert,
    );

    %_return_field_overrides = (
                                'discovered_data' => [],
                                'dns_ptrdname'    => [],
                                'ipv4addr'        => ['!address'],
                                'ipv6addr'        => ['!address'],
                                'ms_ad_user_data' => [],
                                'ptrdname'        => [],
    );

    %_object_to_ibap = (
                        'discovered_data' => \&ibap_o2i_ignore,
                        'dns_ptrdname'    => \&ibap_o2i_ignore,
                        'ipv4addr'        => \&ibap_o2i_ignore,
                        'ipv6addr'        => \&ibap_o2i_ignore,
                        'ms_ad_user_data' => \&ibap_o2i_ignore,
                        'ptrdname'        => \&ibap_o2i_string,
    );


    @_return_fields = (
                       tField('address'),
                       tField('discovered_data', {depth => 1}),
                       tField('dname'),
                       tField('dns_dname'),
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    Infoblox::IBAPBase::create_discovered_data_fields(@discovery_common_fields, @vdiscovery_fields, 'mac_address', 'discovered_duid');
};

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

    if (
        not $args{'ipv4addr'} and 
        not $args{'ipv6addr'} and
        not $args{'name'}
    ) {
        set_error_codes(1103, 'name is required if ' .
            'both ipv4addr and ipv6addr are undefined.');

        return undef;

    } elsif ($args{'ipv4addr'} and $args{'ipv6addr'}) {

        set_error_codes(1105, 'Cannot define ipv4addr ' .
            'and ipv6addr at the same time.');

        return undef;
    }

    $self->__init_instance_constants__();
    return $self;
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $self->SUPER::__init_instance_constants__();

        my $t = Infoblox::Grid::MSServer::AdUser::Data->__new__();
        push @_return_fields, tField('ms_ad_user_data', {sub_fields => $t->__return_fields__()});
    }
}

sub __ibap_to_object__ {

    my $self = shift;
    my ($ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->{'__initializing_from_ibap__'} = 1;

    $self->last_discovered('');
    $self->mac_address('');
    $self->netbios('');
    $self->os('');
    $self->v_cluster('');
    $self->v_datacenter('');
    $self->v_host('');
    $self->v_name('');
    $self->v_netadapter('');
    $self->v_switch('');
    $self->v_type('');

    delete $self->{'__initializing_from_ibap__'};

    if ($$ibap_object_ref{'address'} and $$ibap_object_ref{'address'} =~ m/:/) {
        $self->ipv6addr($$ibap_object_ref{address});
    } else {
        $self->ipv4addr($$ibap_object_ref{address});
    }

    my $res = $self->SUPER::__ibap_to_object__(@_, {'address' => 1});

    Infoblox::Grid::Discovery::Data::__init_discovered_members__($self);

    return $res;
}

sub __object_to_ibap__ {

    my $self = shift;
    my ($server, $session) = @_;

    my $ref_write_fields = $self->SUPER::__object_to_ibap__(@_);

    my %write_arg;
    $write_arg{'field'} = 'address';

    if (defined $self->ipv4addr()) {
        return unless $write_arg{'value'} = ibap_value_o2i_string($self->ipv4addr(), 'ipv4addr', $session);
    }
    elsif (defined $self->ipv6addr()) {
        return unless $write_arg{'value'} = ibap_value_o2i_string($self->ipv6addr(), 'ipv6addr', $session);
    } else {
        #
        #
        $write_arg{'value'} = ibap_value_o2i_string(undef);
    }

    unshift @$ref_write_fields, \%write_arg;
    return $ref_write_fields;
}

#
#
#

sub ipv4addr {

    my $self = shift;

    if (@_ and $$self{ipv6addr}) {
      set_error_codes(1105, 'Cannot define ipv4addr and ipv6addr at the same time.');
      return undef;
    }

    return $self->__accessor_scalar__({name => 'ipv4addr', validator => \&ibap_value_o2i_ipv4addr}, @_);
}

sub ipv6addr {

    my $self = shift;

    if (@_ and $$self{ipv4addr}) {
      set_error_codes(1105, 'Cannot define ipv4addr and ipv6addr at the same time.');
      return undef;
    }

    return $self->__accessor_scalar__({name => 'ipv6addr', validator => \&ibap_value_o2i_ipv6addr}, @_);
}


package Infoblox::DNS::Record::AAAA;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;

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

@ISA = qw( Infoblox::DNS::RecordBase );

BEGIN {

    $_object_type = 'AaaaRecord';
    register_wsdl_type('ib:AaaaRecord', 'Infoblox::DNS::Record::AAAA');

    %_capabilities = ();

    %_allowed_members = (
                         'discovered_data' => {readonly => 1, validator => {'Infoblox::Grid::Discovery::Data' => 1}},
                         'ipv6addr'        => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_ipv6addr},
                         'ms_ad_user_data' => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
    );

    %_name_mappings = (
                       ipv6addr => 'address',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'discovered_data' => \&ibap_i2o_generic_object_convert,
                        'ms_ad_user_data' => \&ibap_i2o_generic_object_convert,
    );

    %_searchable_fields = (
                           'discovered_data' => [\&Infoblox::Grid::Discovery::Data::__o2i_search_discovered_data__, 'discovered_data', 'EXACT'],
                           'ipv6addr'        => [\&ibap_o2i_string, 'address', 'REGEX'],
    );

    %_return_field_overrides = (
                                'discovered_data' => [],
                                'ipv6addr'        => [],
                                'ms_ad_user_data' => [],
    );

    %_object_to_ibap = (
                        'discovered_data' => \&ibap_o2i_ignore,
                        'ipv6addr'        => \&ibap_o2i_string,
                        'ms_ad_user_data' => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('address'),
                       tField('discovered_data', {depth => 1}),
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    Infoblox::IBAPBase::create_discovered_data_fields(@discovery_common_fields, 'discovered_duid');
};

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $self->SUPER::__init_instance_constants__();

        my $t = Infoblox::Grid::MSServer::AdUser::Data->__new__();
        push @_return_fields, tField('ms_ad_user_data', {sub_fields => $t->__return_fields__()});
    }
}

sub __ibap_to_object__ {

    my $self = shift;
    my ($ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->{'__initializing_from_ibap__'} = 1;

    $self->last_discovered('');
    $self->netbios('');
    $self->os('');

    delete $self->{'__initializing_from_ibap__'};

    my $res = $self->SUPER::__ibap_to_object__(@_);

    Infoblox::Grid::Discovery::Data::__init_discovered_members__($self);

    return $res;
}


package Infoblox::DNS::Record::TXT;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;

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

@ISA = qw( Infoblox::DNS::RecordBase );

BEGIN {

    $_object_type = 'TxtRecord';
    register_wsdl_type('ib:TxtRecord', 'Infoblox::DNS::Record::TXT');

    %_capabilities = ();

    %_allowed_members = (
                         'text' => {simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    %_name_mappings = ();
    %_reverse_name_mappings = ();
    %_ibap_to_object = ();

    %_searchable_fields = (
                           'text' => [\&ibap_o2i_string, 'text', 'REGEX'],
    );


    %_return_field_overrides = (
                                'text' => [],
    );

    %_object_to_ibap = (
                        'text' => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('text'),
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
};

package Infoblox::DNS::Record::CNAME;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;

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

@ISA = qw( Infoblox::DNS::RecordBase );

BEGIN {

    $_object_type = 'CnameRecord';
    register_wsdl_type('ib:CnameRecord', 'Infoblox::DNS::Record::CNAME');

    %_capabilities = ();

    %_allowed_members = (
                         'canonical'     => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'dns_canonical' => {simple => 'asis', readonly => 1},
    );

    %_searchable_fields = (
                           'canonical' => [\&ibap_o2i_string, 'canonical_name', 'REGEX'],
    );

    %_name_mappings = (
                       'canonical'     => 'canonical_name',
                       'dns_canonical' => 'dns_canonical_name',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = ();

    %_return_field_overrides = (
                                'canonical'     => [],
                                'dns_canonical' => [],
    );

    %_object_to_ibap = (
                        'canonical'     => \&ibap_o2i_string,
                        'dns_canonical' => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('canonical_name'),
                       tField('dns_canonical_name'),
    );

    $_return_fields_initialized=0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


package Infoblox::DNS::Record::DNAME;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;

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

@ISA = qw( Infoblox::DNS::RecordBase );

BEGIN {

    $_object_type = 'DnameRecord';
    register_wsdl_type('ib:DnameRecord', 'Infoblox::DNS::Record::DNAME');

    %_capabilities = ();

    %_allowed_members = (
                         'dns_target' => {simple => 'asis', readonly => 1},
                         'target'     => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                        );

    %_searchable_fields = (
                           'target' => [\&ibap_o2i_string, 'target', 'REGEX'],
    );

    %_name_mappings = ();
    %_reverse_name_mappings = ();
    %_ibap_to_object = ();

    %_object_to_ibap = (
                        'dns_target' => \&ibap_o2i_ignore,
                        'target'     => \&ibap_o2i_string,
    );

    %_return_field_overrides = (
                                'dns_target' => [],
                                'target'     => [],
    );

    @_return_fields = (
                       tField('dns_target'),
                       tField('target'),
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


package Infoblox::DNS::Record::SRV;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;

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

@ISA = qw( Infoblox::DNS::RecordBase );

BEGIN {

    $_object_type = 'SrvRecord';
    register_wsdl_type('ib:SrvRecord', 'Infoblox::DNS::Record::SRV');

    %_capabilities = ();

    %_allowed_members = (
                         'dns_target' => {simple => 'asis', readonly => 1},
                         'port'       => {simple => 'asis', mandatory => 1,validator => \&ibap_value_o2i_int},
                         'priority'   => {simple => 'asis', mandatory => 1,validator => \&ibap_value_o2i_int},
                         'target'     => {simple => 'asis', mandatory => 1,validator => \&ibap_value_o2i_string},
                         'weight'     => {simple => 'asis', mandatory => 1,validator => \&ibap_value_o2i_int},
    );

    %_searchable_fields = (
                           'port'     => [\&ibap_o2i_integer, 'port', 'REGEX'],
                           'priority' => [\&ibap_o2i_integer, 'priority', 'REGEX'],
                           'target'   => [\&ibap_o2i_string, 'target', 'REGEX'],
                           'weight'   => [\&ibap_o2i_integer, 'weight', 'REGEX'],
    );

    %_name_mappings = ();
    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = ();

    %_object_to_ibap = (
                        'dns_target' => \&ibap_o2i_ignore,
                        'port'       => \&ibap_o2i_integer,
                        'priority'   => \&ibap_o2i_integer,
                        'target'     => \&ibap_o2i_string,
                        'weight'     => \&ibap_o2i_integer,
    );

    %_return_field_overrides = (
                                'dns_target' => [],
                                'port'       => [],
                                'priority'   => [],
                                'target'     => [],
                                'ttl'        => ['use_ttl'],
                                'weight'     => [],
    );

    @_return_fields = (
                       tField('dns_target'),
                       tField('port'),
                       tField('priority'),
                       tField('target'),
                       tField('weight'),
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
};


package Infoblox::DNS::Record::MX;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;

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

@ISA = qw( Infoblox::DNS::RecordBase );

BEGIN {

    $_object_type = 'MxRecord';
    register_wsdl_type('ib:MxRecord', 'Infoblox::DNS::Record::MX');

    %_capabilities = ();

    %_allowed_members = (
                         'exchanger'     => {simple => 'asis', mandatory => 1,validator => \&ibap_value_o2i_string},
                         'pref'          => {simple => 'asis', mandatory => 1,validator => \&ibap_value_o2i_int},
                         'dns_exchanger' => {simple => 'asis', readonly => 1},
    );

    %_searchable_fields = (
                           'exchanger' => [\&ibap_o2i_string, 'mx', 'REGEX'],
                           'pref'      => [\&ibap_o2i_integer, 'priority', 'REGEX'],
    );

    %_name_mappings = (
                       'dns_exchanger' => 'dns_mx',
                       'exchanger'     => 'mx',
                       'pref'          => 'priority',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = ();

    %_object_to_ibap = (
                        'dns_exchanger' => \&ibap_o2i_ignore,
                        'exchanger'     => \&ibap_o2i_string,
                        'pref'          => \&ibap_o2i_integer,
    );

    %_return_field_overrides = (
                                'dns_exchanger' => [],
                                'exchanger'     => [],
                                'pref'          => [],
    );

    @_return_fields = (
                       tField('dns_mx'),
                       tField('mx'),
                       tField('priority'),
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


package Infoblox::DNS::Record::NAPTR;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;

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

@ISA = qw( Infoblox::DNS::RecordBase );

BEGIN {

    $_object_type = 'NaptrRecord';
    register_wsdl_type('ib:NaptrRecord', 'Infoblox::DNS::Record::NAPTR');

    %_capabilities = ();

    %_allowed_members = (
                         'dns_replacement' => {simple => 'asis', readonly => 1},
                         'flags'           => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'order'           => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'preference'      => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'regexp'          => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'replacement'     => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'services'        => {simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    %_name_mappings = ();
    %_reverse_name_mappings = reverse %_name_mappings;
    %_ibap_to_object = ();

    %_searchable_fields = (
                           'flags'       => [\&ibap_o2i_string, 'flags', 'REGEX', 'IGNORE_CASE'],
                           'order'       => [\&ibap_o2i_uint, 'order', 'EXACT'],
                           'preference'  => [\&ibap_o2i_uint, 'preference', 'EXACT'],
                           'replacement' => [\&ibap_o2i_string, 'replacement', 'REGEX'],
    );

    %_object_to_ibap = (
                        'flags'           => \&ibap_o2i_string,
                        'order'           => \&ibap_o2i_uint,
                        'preference'      => \&ibap_o2i_uint,
                        'regexp'          => \&ibap_o2i_string,
                        'replacement'     => \&ibap_o2i_string,
                        'dns_replacement' => \&ibap_o2i_ignore,
                        'services'        => \&ibap_o2i_string,
    );

    %_return_field_overrides = (
                                'dns_replacement' => [],
                                'flags'           => [],
                                'order'           => [],
                                'preference'      => [],
                                'regexp'          => [],
                                'replacement'     => [],
                                'services'        => [],
    );

    @_return_fields = (
                       tField('dns_replacement'),
                       tField('flags'),
                       tField('order'),
                       tField('preference'),
                       tField('regexp'),
                       tField('replacement'),
                       tField('services'),
    );

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


package Infoblox::DNS::Record::TLSA;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;

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

@ISA = qw( Infoblox::DNS::RecordBase );

BEGIN {

    $_object_type = 'TlsaRecord';
    register_wsdl_type('ib:TlsaRecord', 'Infoblox::DNS::Record::TLSA');

    %_capabilities = ();

    %_allowed_members = (
                         'certificate_data'  => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'certificate_usage' => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_uint},
                         'matched_type'      => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_uint},
                         'selector'          => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_uint},
    );

    %_searchable_fields = (
                           'certificate_data' => [\&ibap_o2i_string, 'certificate_data', 'REGEX'],
    );

    %_name_mappings = ();
    %_reverse_name_mappings = reverse %_name_mappings;
    %_ibap_to_object = ();

    %_object_to_ibap = (
                        'certificate_data'  => \&ibap_o2i_string,
                        'certificate_usage' => \&ibap_o2i_uint,
                        'matched_type'      => \&ibap_o2i_uint,
                        'selector'          => \&ibap_o2i_uint,
    );

    %_return_field_overrides = (
                                'certificate_data'  => [],
                                'certificate_usage' => [],
                                'matched_type'      => [],
                                'selector'          => [],
    );

    @_return_fields = (
                       tField('certificate_data'),
                       tField('certificate_usage'),
                       tField('matched_type'),
                       tField('selector'),
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RecordBase', $_object_type, {
        'creation_time' => 1,
        'creation_timestamp' => 1,
        'reclaimable'   => 1,
        'forbid_reclamation' => 1,
        'ddns_principal' => 1,
        'ddns_protected' => 1,
    });

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


package Infoblox::DNS::AllRecords;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;
use Infoblox::PAPIOverrides;

use vars qw(
            @ISA
            $_object_type
            %_allowed_members
            @_return_fields
            %_searchable_fields
            %_object_to_ibap
            %_name_mappings
            %_reverse_name_mappings
            %_ibap_to_object
            %_return_field_overrides
            %_type_mapping
            %_capabilities
            %_search_type_mapping
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::SEARCH_ONLY );

BEGIN {

    $_object_type = 'ZoneChild';
    register_wsdl_type('ib:ZoneChild', 'Infoblox::DNS::AllRecords');

    %_capabilities = (
                      'depth'                => 0,
                      'has_next'             => 1,
                      'implicit_defaults'    => 1,
                      'limit'                => 2000,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'comment'        => {simple => 'asis', readonly => 1},
                         'creator'        => {simple => 'asis', readonly => 1, enum => ['STATIC', 'DYNAMIC', 'SYSTEM']},
                         'ddns_principal' => {simple => 'asis', readonly => 1},
                         'ddns_protected' => {simple => 'bool', readonly => 1},
                         'disable'        => {simple => 'bool', readonly => 1},
                         'dtc_obscured'   => {readonly => 1},
                         'last_queried'   => {readonly => 1},
                         'name'           => {simple => 'asis', readonly => 1},
                         'reclaimable'    => {simple => 'bool', readonly => 1},
                         'record'         => {readonly => 1},
                         'ttl'            => {simple => 'asis', readonly => 1},
                         'type'           => {readonly => 1},
                         'view'           => {readonly => 1},
                         'zone'           => {readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'disable'      => 'disabled',
                       'type'         => 'view_type',
                       'dtc_obscured' => 'idns_obscured',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'idns_obscured' => \&ibap_i2o_object_name,
                        'last_queried'  => \&ibap_i2o_datetime_to_unix_timestamp,
                        'record'        => \&__i2o_record__,
                        'view'          => \&ibap_i2o_object_name,
                        'view_type'     => \&__i2o_viewtype__,
                        'zone'          => \&__i2o_zone__,
    );

    %_searchable_fields = (
                           'creator'        => [\&ibap_o2i_string, 'creator', 'EXACT'],
                           'ddns_principal' => [\&ibap_o2i_string, 'ddns_principal', 'REGEX'],
                           'name'           => [\&ibap_o2i_string, 'name', 'REGEX', 'IGNORE_CASE'],
                           'reclaimable'    => [\&ibap_o2i_boolean, 'reclaimable', 'EXACT'],
                           'start_record'   => [\&__o2i_record_search__, 'record', 'EXACT'],
                           'type'           => [\&__o2i_type_search__, 'view_type', 'EXACT'],
                           'view'           => [\&ibap_o2i_ignore, 'deprecated', 'DEPRECATED'],
                           'zone'           => [\&__o2i_zone_search__, 'zone', 'EXACT'], # View is taken care of within zone
    );

    %_return_field_overrides = (
                                'comment'        => [],
                                'creator'        => [],
                                'ddns_principal' => [],
                                'ddns_protected' => [],
                                'disable'        => [],
                                'last_queried'   => [],
                                'name'           => [],
                                'reclaimable'    => [],
                                'record'         => [],
                                'ttl'            => [],
                                'type'           => [],
                                'view'           => [],
                                'zone'           => [],
    );

    %_type_mapping = (
                      'ARecord'           => 'A Record',
                      'AaaaRecord'        => 'AAAA Record',
                      'BulkHost'          => 'Bulk Host',
                      'CnameRecord'       => 'CNAME Record',
                      'DnameRecord'       => 'DNAME Record',
                      'DnskeyRecord'      => 'DNSKEY Record',
                      'DsRecord'          => 'DS Record',
                      'HostAddress'       => 'Host Address',
                      'HostAlias'         => 'Host Alias',
                      'HostRecord'        => 'Host Record',
                      'IPv6HostAddress'   => 'IPV6 Host Address',
                      'IdnsLbdnRecord'    => 'DTC LBDN Record',
                      'MxRecord'          => 'MX Record',
                      'NaptrRecord'       => 'NAPTR Record',
                      'NsRecord'          => 'NS Record',
                      'Nsec3ParamRecord'  => 'NSEC3 Parameter Record',
                      'Nsec3Record'       => 'NSEC3 Record',
                      'NsecRecord'        => 'NSEC Record',
                      'PtrRecord'         => 'PTR Record',
                      'RrsigRecord'       => 'RSIG Record',
                      'SecRecord'         => 'SEC Record',
                      'SharedARecord'     => 'Shared A Record',
                      'SharedAaaaRecord'  => 'Shared AAAA Record',
                      'SharedMxRecord'    => 'Shared MX Record',
                      'SharedSrvRecord'   => 'Shared SRV Record',
                      'SharedTxtRecord'   => 'Shared TXT Record',
                      'SoaRecord'         => 'SOA Record',
                      'SrvRecord'         => 'SRV Record',
                      'TlsaRecord'        => 'TLSA Record',
                      'TxtRecord'         => 'TXT Record',
                      'DhcidRecord'       => 'DHCID Record',
                      'UnsupportedRecord' => 'Unsupported Record',
    );

    #
    #
    foreach my $org (keys %_type_mapping) {
        my $t = lc $_type_mapping{$org};
        $t =~ s/record$/records/;
        $_search_type_mapping{'all ' . $t} = $org;
    }

    $_search_type_mapping{'all records'} = 'ALL';

    %_object_to_ibap = ();

    @_return_fields = (
                       tField('comment'),
                       tField('creator'),
                       tField('ddns_principal'),
                       tField('ddns_protected'),
                       tField('disabled'),
                       tField('last_queried'),
                       tField('name'),
                       tField('reclaimable'),
                       tField('ttl'),
                       tField('view_type'),
                       tField('idns_obscured', {sub_fields => [tField('name')]}),
                       tField('record', {depth => 0}), # we just want the oid
                       tField('view', {sub_fields => [tField('name')]}),
                       tField('zone', {sub_fields => [tField('fqdn')]}),
    );
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

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub __search_mapping_hook_pre__ {

    my ($self, $session, $type, $argsref,
        $out_search_fields_ref, $out_search_types_ref,
        $out_search_matches_ref) = @_;

    if (not defined $$argsref{'zone'}) {
        set_error_codes(1103, "zone is a required search parameter", $session);
        return 0;
    }

    return 1;
}

sub __search_mapping_hook_post__ {

    my ($self, $session, $type, $argsref,
        $out_search_fields_ref, $out_search_types_ref,
        $out_search_matches_ref) = @_;

    $out_search_fields_ref->{'hier'}  = tBool(1);
    $out_search_types_ref->{'hier'}   = 'EXACT';
    $out_search_matches_ref->{'hier'} = undef;

    return 1;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __ibap_to_object__ {

    my $self = shift;
    my ($ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
        'disabled',
        'ddns_protected',
        'reclaimable',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    return $self->SUPER::__ibap_to_object__(@_);
}

sub __i2o_record__ {

    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $objtype = $papi_object_type_from_wsdl{'ib:' . $$ibap_object_ref{'view_type'}};

    unless ($objtype) {
        #
        #
        return undef;
    }

    my $result_object = $objtype->__new__();
    $result_object->__object_id__($$ibap_object_ref{$current}{'object_id'}{'id'});
    $result_object->{'__partial__'} = 1;

    $result_object->{'__initializing_from_ibap__'} = 1;

    $result_object->reclaimable(ibap_value_i2o_boolean($$ibap_object_ref{'reclaimable'})) if $result_object->can('reclaimable');
    $result_object->creator($$ibap_object_ref{'creator'}) if $result_object->can('creator');
    $result_object->name($$ibap_object_ref{'name'}) if $result_object->can('name');
    $result_object->comment($$ibap_object_ref{'comment'}) if $result_object->can('comment');
    $result_object->disable(ibap_value_i2o_boolean($$ibap_object_ref{'disabled'})) if $result_object->can('disable');
    $result_object->ddns_protected(ibap_value_i2o_boolean($$ibap_object_ref{'ddns_protected'})) if $result_object->can('ddns_protected');
    $result_object->ddns_principal($$ibap_object_ref{'ddns_principal'}) if $result_object->can('ddns_principal');

    delete $result_object->{'__initializing_from_ibap__'};

    return $result_object;
}

sub __i2o_zone__ {

    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    return $$ibap_object_ref{$current}{'fqdn'};
}

sub __i2o_viewtype__ {

    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    return defined $_type_mapping{$$ibap_object_ref{$current}} ? $_type_mapping{$$ibap_object_ref{$current}} : 'Unknown';
}

sub __o2i_zone_search__ {

    my ($self, $session, $current, $tempref) = @_;
    my $zone_readfield = ibap_arg_zone_convert($session, $current, $tempref);

    if ($zone_readfield) {
        return (1, 0, $zone_readfield);
    } else {
        return (0);
    }
}

sub __o2i_type_search__ {

    my ($self, $session, $current, $tempref) = @_;

    my $t = lc $$tempref{$current};

    if ($_search_type_mapping{$t}) {
        return(1, 0, ibap_value_o2i_string($_search_type_mapping{$t}));
    }
    else {
        set_error_codes(1103, $$tempref{$current} . ' is not a valid value for type', $session);
        return (0);
    }
}

sub __o2i_record_search__
{
    my ($self, $session, $current, $tempref) = @_;

    if (ref $$tempref{$current} eq 'Infoblox::DNS::AllRecords' and $$tempref{$current}->__object_id__()) {
        return (1, 0, tObjIdRef($$tempref{$current}->__object_id__()));
    } else {

        set_error_codes(1012, "You must specify a previously returned " .
            "Infoblox::DNS::AllRecords object to start your request with", $session);

        return (0);
    }
}


package Infoblox::DNS::Record::NS;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;

use vars qw(
            @ISA
            $_object_type
            %_allowed_members
            @_return_fields
            %_searchable_fields
            %_object_to_ibap
            %_name_mappings
            %_reverse_name_mappings
            %_ibap_to_object
            $_return_fields_initialized
            %_return_field_overrides
            %_capabilities
);

@ISA = qw( Infoblox::IBAPBase );

BEGIN {
    $_object_type = 'NsRecord';
    register_wsdl_type('ib:NsRecord', 'Infoblox::DNS::Record::NS');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'addresses'          => {mandatory => 1, array => 1, validator => {'Infoblox::DNS::Nameserver::Address' => 1}},
                         'cloud_info'         => {readonly => 1, validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
                         'creator'            => {simple => 'asis', enum => ['STATIC', 'DYNAMIC', 'SYSTEM']},
                         'dns_name'           => {readonly => 1, simple => 'asis'},
                         'ms_delegation_name' => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'name'               => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'nameserver'         => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'views'              => {array => 1, validator => {'Infoblox::DNS::View' => 1}},
                         'last_queried'       => {readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'addresses'  => 'zone_nameservers',
                       'dns_name'   => 'dns_fqdn',
                       'name'       => 'fqdn',
                       'nameserver' => 'dname',
                       'views'      => 'view',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'cloud_info'       => \&ibap_i2o_generic_object_convert,
                        'view'             => \&ibap_i2o_generic_object_convert_to_list_of_one,
                        'zone_nameservers' => \&ibap_i2o_generic_object_list_convert,
                        'last_queried'     => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    %_searchable_fields = (
                           'creator'    => [\&ibap_o2i_string, 'creator', 'EXACT'],
                           'name'       => [\&ibap_o2i_string, 'fqdn', 'REGEX'],
                           'nameserver' => [\&ibap_o2i_string, 'dname', 'REGEX'],
                           'view'       => [\&ibap_o2i_view, 'view', 'EXACT'],
                           'views'      => [\&ibap_o2i_view, 'view', 'EXACT'],
    );

    %_return_field_overrides = (
                                'addresses'             => [],
                                'cloud_info'            => [],
                                'creator'               => [],
                                'dns_name'              => [],
                                'extensible_attributes' => [],
                                'ms_delegation_name'    => [],
                                'name'                  => [],
                                'nameserver'            => [],
                                'views'                 => [],
                                'last_queried'          => [],
    );

    %_object_to_ibap = (
                        'addresses'          => \&ibap_o2i_generic_struct_list_convert,
                        'cloud_info'         => \&ibap_o2i_ignore,
                        'creator'            => \&ibap_o2i_string,
                        'dns_name'           => \&ibap_o2i_ignore,
                        'ms_delegation_name' => \&ibap_o2i_string,
                        'name'               => \&ibap_o2i_string,
                        'nameserver'         => \&ibap_o2i_string,
                        'views'              => \&ibap_o2i_view,
                        'last_queried'       => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('ms_delegation_name'),
                       tField('dname'),
                       tField('fqdn'),
                       tField('dns_fqdn'),
                       tField('creator'),
                       tField('last_queried'),
    );

    $_return_fields_initialized = 0;
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

        my $t = Infoblox::DNS::View->__new__();

        push @_return_fields, tField('view', {
            default_no_access_ok => 1,
            sub_fields           => $t->__return_fields__(),
        });

        $t = Infoblox::DNS::Nameserver::Address->__new__();

        push @_return_fields, tField('zone_nameservers', {
            sub_fields => $t->__return_fields__(),
        });

        $t = Infoblox::Grid::CloudAPI::Info->__new__();

        push @_return_fields, tField('cloud_info', {
            sub_fields => $t->__return_fields__()
        });
    }
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

package Infoblox::DNS::Record::DTCLBDN;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;

use Infoblox::PAPIOverrides;

use vars qw(
            @ISA
            $_object_type
            %_allowed_members
            @_return_fields
            %_searchable_fields
            %_object_to_ibap
            %_name_mappings
            %_reverse_name_mappings
            %_ibap_to_object
            %_return_field_overrides
            %_capabilities
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    $_object_type = 'IdnsLbdnRecord';
    register_wsdl_type('ib:IdnsLbdnRecord', 'Infoblox::DNS::Record::DTCLBDN');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'comment'               => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         'disable'               => {simple => 'bool', readonly => 1, validator => \&ibap_value_o2i_boolean},
                         'extattrs'              => {readonly => 1, special => 'extensible_attributes'},
                         'extensible_attributes' => {readonly => 1, special => 'extensible_attributes'},
                         'lbdn'                  => {readonly => 1, validator => {'Infoblox::DTC::LBDN' => 1}},
                         'name'                  => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         'pattern'               => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         'view'                  => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         'zone'                  => {readonly => 1, validator => \&ibap_value_o2i_string},
                         'last_queried'          => {readonly => 1},
    );


    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
	                       'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'comment'               => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           'extattrs'              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'name'                  => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'view'                  => [\&__o2i_view_search_hook__, 'view', 'EXACT'],
                           'zone'                  => [\&ibap_o2i_zone_by_fqdn_and_view_name, 'zone', 'EXACT'],
    );

    %_name_mappings = (
                       'disable'  => 'disabled',
                       'extattrs' => 'extensible_attributes',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_object_to_ibap = (
                        'comment'               => \&ibap_o2i_ignore,
                        'disable'               => \&ibap_o2i_ignore,
                        'extattrs'              => \&ibap_o2i_ignore,
                        'extensible_attributes' => \&ibap_o2i_ignore,
                        'lbdn'                  => \&ibap_o2i_ignore,
                        'pattern'               => \&ibap_o2i_ignore,
                        'view'                  => \&ibap_o2i_ignore,
                        'zone'                  => \&ibap_o2i_ignore,
                        'last_queried'          => \&ibap_o2i_ignore,
    );

    %_ibap_to_object = (
                        'disabled'              => \&ibap_i2o_boolean,
                        'extensible_attributes' =>  \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'lbdn'                  => \&ibap_i2o_generic_object_convert_partial,
                        'zone'                  => \&ibap_i2o_zone_and_view_by_name,
                        'last_queried'          => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    @_return_fields = (
                       tField('comment'),
                       tField('disabled'),
                       tField('name'),
                       tField('pattern'),
                       tField('zone', {sub_fields => [tField('fqdn'), tField('view_name')]}),
                       tField('lbdn', {sub_fields => [tField('name')]}),
                       tField('last_queried'),
                       return_fields_extensible_attributes(),
    );
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref ($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
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

    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __o2i_view_search_hook__ {

    my ($self, $session, $current, $tempref, $type) = @_;

    unless ($$tempref{'zone'}) {
        set_error_codes(1012, "zone is a required search parameter if view is specified.", $session);
        return (0);
    }
    return (1, 1, undef);
}


package Infoblox::DNS::Record::DHCID;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;
use Infoblox::PAPIOverrides;

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

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_MODIFY );

BEGIN {

    $_object_type = 'DhcidRecord';
    register_wsdl_type('ib:DhcidRecord', 'Infoblox::DNS::Record::DHCID');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'dhcid'         => {readonly => 1, simple => 'asis'},
                         'creation_time' => {readonly => 1},
                         'creator'       => {readonly => 1, simple => 'asis', enum => ['STATIC', 'DYNAMIC', 'SYSTEM']},
                         'dns_name'      => {readonly => 1, simple => 'asis'},
                         'name'          => {readonly => 1, simple => 'asis'},
                         'ttl'           => {readonly => 1, simple => 'asis'},
                         'views'         => {readonly => 1, array => 1, validator => {'Infoblox::DNS::View' => 1}},
                         'zone'          => {readonly => 1, simple => 'asis'},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'dhcid'         => 'dhcid_string',
                       'name'          => 'fqdn',
                       'dns_name'      => 'dns_fqdn',
                       'zone'          => 'parent',
                       'views'         => 'view',
                       'creation_time' => 'creation_timestamp',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           'dhcid'   => [\&ibap_o2i_string, 'dhcid_string', 'REGEX'],
                           'name'    => [\&ibap_o2i_string, 'fqdn', 'REGEX'],
                           'view'    => [\&ibap_o2i_view, 'view', 'EXACT'],
                           'views'   => [\&ibap_o2i_view, 'view', 'EXACT'],
                           'zone'    => [\&ibap_o2i_string, 'parent', 'EXACT'],
                           'creator' => [\&ibap_o2i_string, 'creator', 'EXACT'],
    );

    @_return_fields = (
                       tField('dhcid_string'),
                       tField('parent'),
                       tField('fqdn'),
                       tField('dns_fqdn'),
                       tField('parent'),
                       tField('ttl'),
                       tField('use_ttl'),
                       tField('creator'),
                       tField('creation_timestamp'),
    );

    %_ibap_to_object = (
                        'view'               => \&ibap_i2o_generic_object_convert_to_list_of_one,
                        'creation_timestamp' => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    %_object_to_ibap = (
                        'name'          => \&ibap_o2i_ignore,
                        'ttl'           => \&ibap_o2i_ignore,
                        'use_ttl'       => \&ibap_o2i_ignore,
                        'views'         => \&ibap_o2i_ignore,
                        'zone'          => \&ibap_o2i_ignore,
                        'creation_time' => \&ibap_o2i_ignore,
                        'creator'       => \&ibap_o2i_ignore,
                        'dns_name'      => \&ibap_o2i_ignore,
                        'zone'          => \&ibap_o2i_ignore,
    );

    %_return_field_overrides = (
                                'creation_time' => [],
                                'creator'       => [],
                                'dns_name'      => [],
                                'name'          => [],
                                'ttl'           => ['use_ttl'],
                                'views'         => [],
                                'zone'          => [],
    );

    $_return_fields_initialized = 0;
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref ($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
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

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my $tmp = Infoblox::DNS::View->__new__();
        push @_return_fields, tField('view', {
            default_no_access_ok => 1,
            sub_fields           => $tmp->__return_fields__(),
        });
    }
}

sub __search_mapping_hook_pre__ {

    my ($self, $session, $type, $argsref,
        $out_search_fields_ref, $out_search_types_ref,
        $out_search_matches_ref) = @_;

    #
    if( defined $argsref->{'zone'} && not defined $argsref->{'view'} && not defined $argsref->{'views'} ) {
        $out_search_fields_ref->{'view'} = ibap_readfield_simple('View', 'is_default', tBool(1), 'view=(default view)');
        $out_search_types_ref->{'view'} = 'EXACT';
        $out_search_matches_ref->{'view'} = undef;
    }

    return 1;
}

sub __ibap_to_object__ {

    my $self = shift;
    my ($ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    my $res = $self->SUPER::__ibap_to_object__(@_);

    if ($$ibap_object_ref{'use_ttl'}) {
        $self->{'use_ttl'} = 1;
    } else {
        $self->{'use_ttl'} = 0;
        delete $self->{ttl};
    }

    return $res;
}



1;
