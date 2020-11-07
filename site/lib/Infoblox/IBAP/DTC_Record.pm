# Copyright (c) 2017 Infoblox Inc.



package Infoblox::DTC::AllRecords;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            $_object_type
            $_return_fields_initialized
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_name_mappings
            %_obj_type_mapping
            %_object_to_ibap
            %_return_field_overrides
            %_reverse_name_mappings
            %_search_type_mapping
            %_searchable_fields
            %_type_mapping
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::SEARCH_ONLY );

BEGIN {

    $_object_type = 'ZoneChild';
    register_wsdl_type('ib:IdnsZoneChild', 'Infoblox::DTC::AllRecords');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'comment'      => {simple => 'asis', readonly => 1},
                         'disable'      => {simple => 'bool', readonly => 1},
                         'dtc_server'   => {readonly => 1, validator => {'Infoblox::DTC::Server' => 1}},
                         'record'       => {readonly => 1, validator => {
                                                                         'Infoblox::DTC::Record::NAPTR' => 1,
                                                                         'Infoblox::DTC::Record::A'     => 1,
                                                                         'Infoblox::DTC::Record::AAAA'  => 1,
                                                                         'Infoblox::DTC::Record::CNAME' => 1,
                                           }},
                         'ttl'          => {simple => 'asis', readonly => 1},
                         'type'         => {readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'type'         => [\&__o2i_dtc_type_search__, 'view_type', 'EXACT'],
                           'dtc_server'   => [\&ibap_o2i_object_by_oid_or_name, 'idns_server', 'EXACT'],
    );

    %_name_mappings = (
                       'disable'    => 'disabled',
                       'dtc_server' => 'idns_server',
                       'type'       => 'view_type',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'idns_server'  => \&Infoblox::DTC::RecordBase::__i2o_idns_server__,
                        'record'       => \&__i2o_dtc_record__,
                        'view_type'    => \&__i2o_dtc_viewtype__,
    );

    %_object_to_ibap = (
                        'comment'      => \&ibap_o2i_ignore,
                        'disable'      => \&ibap_o2i_ignore,
                        'dtc_server'   => \&ibap_o2i_ignore,
                        'record'       => \&ibap_o2i_ignore,
                        'type'         => \&ibap_o2i_ignore,
                        'ttl'          => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('comment'),
                       tField('disabled'),
                       tField('view_type'),
                       tField('ttl'),
                       tField('idns_server', {
                               sub_fields => [
                                   tField('host'),
                                   tField('name'),
                               ],
                       }),
                       tField('record', {depth => 0}),
    );

    %_return_field_overrides = (
                                'comment'      => [],
                                'disable'      => [],
                                'dtc_server'   => [],
                                'record'       => [],
                                'type'         => [],
                                'ttl'          => [],
    );

    $_return_fields_initialized = 0;

    %_type_mapping = (
                      'IdnsARecord'     => 'DTC A Record',
                      'IdnsAaaaRecord'  => 'DTC AAAA Record',
                      'IdnsCnameRecord' => 'DTC CNAME Record',
                      'IdnsNaptrRecord' => 'DTC NAPTR Record',
    );

    %_obj_type_mapping = (
                          'IdnsARecord'     => 'Infoblox::DTC::Record::A',
                          'IdnsAaaaRecord'  => 'Infoblox::DTC::Record::AAAA',
                          'IdnsCnameRecord' => 'Infoblox::DTC::Record::CNAME',
                          'IdnsNaptrRecord' => 'Infoblox::DTC::Record::NAPTR',
    );

    foreach my $org (keys %_type_mapping) {

        my $t = lc $_type_mapping{$org};
        $t =~ s/record$/records/;
        $_search_type_mapping{'all ' . $t} = $org;
    }

    $_search_type_mapping{'all records'} = 'ALL';
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

sub __search_mapping_hook_pre__ {

    my ($self, $session, $type, $argsref, $out_search_fields_ref, $out_search_types_ref, $out_search_matches_ref) = @_;

    unless ($argsref->{'dtc_server'}) {
        set_error_codes('1103', '\'dtc_server\' is a required search parameter', $session);
        return 0;
    }

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

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __i2o_dtc_record__ {

    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $objtype = $_obj_type_mapping{$$ibap_object_ref{'view_type'}};

    return undef unless $objtype;

    my $res_rr = $objtype->__new__();

    $res_rr->__object_id__($$ibap_object_ref{$current}{'object_id'}{'id'});
    $res_rr->{'__partial__'} = 1;

    $res_rr->disable(ibap_value_i2o_boolean($$ibap_object_ref{'disabled'})) if $res_rr->can('disable');
    $res_rr->comment($$ibap_object_ref{'comment'}) if $res_rr->can('comment');
    $res_rr->ttl($$ibap_object_ref{'ttl'}) if $res_rr->can('ttl');
    
    return $res_rr;
}

sub __i2o_dtc_viewtype__ {

    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return defined $_type_mapping{$$ibap_object_ref{$current}} ?
        $_type_mapping{$$ibap_object_ref{$current}} : 'Unknown';
}

sub __o2i_dtc_type_search__ {

    my ($self, $session, $current, $tempref) = @_;

    my $t = lc $$tempref{$current};

    if ($_search_type_mapping{$t}) {
        return (1, 0, ibap_value_o2i_string($_search_type_mapping{$t}));
    } else {
        set_error_codes(1103, $$tempref{$current} . ' is not a valid value for type', $session);
        return (0);
    }
}


package Infoblox::DTC::RecordBase;

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
                         'comment'    => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'disable'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'dtc_server' => {mandatory => 1, validator => {'Infoblox::DTC::Server' => 1}},
                         'ttl'        => {simple => 'asis', validator => \&ibap_value_o2i_uint, use => 'use_ttl'},
    );

    %_searchable_fields = (
                           'comment'    => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'dtc_server' => [\&ibap_o2i_object_by_oid_or_name, 'idns_server', 'EXACT'],
    );

    %_name_mappings = (
                       'disable'    => 'disabled',
                       'dtc_server' => 'idns_server',
    );

    %_reverse_name_mappings = reverse %_name_mappings;


    @_return_fields = (
                       tField('comment'),
                       tField('disabled'),
                       tField('ttl'),
                       tField('use_ttl'),
                       tField('idns_server', {
                               sub_fields => [
                                   tField('host'),
                                   tField('name'),
                               ],
                       }),
    );

    %_ibap_to_object = (
                        'idns_server' => \&__i2o_idns_server__,
    );

    %_object_to_ibap = (
                        'comment'    => \&ibap_o2i_string,
                        'disable'    => \&ibap_o2i_boolean,
                        'dtc_server' => \&ibap_o2i_object_by_oid_or_name,
                        'ttl'        => \&ibap_o2i_ttl,
                        'use_ttl'    => \&ibap_o2i_ignore,
    );

    %_return_field_overrides = (
                                'comment'     => [],
                                'disable'     => [],
                                'dtc_server'  => [],
                                'ttl'         => ['use_ttl'],
    );
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    {
        no strict 'refs';

        if (!$self->__initialize_members_from_arg_list__(\%{$class . '::_allowed_members'}, \%args) ||
            !$self->__validate_object_required_members__(\%{$class . '::_allowed_members'}))
        {
            return;
        }

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

    {
        no strict 'refs';
        return ${$class . '::_object_type'};
    }
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    my $class = ref $self || $self;

    {
        no strict 'refs';
        return ${$class . '::_capabilities'}{$what};
    }
}

sub __ibap_to_object__ {

    my $self = shift;
    my ($ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};
    $$ibap_object_ref{'use_ttl'}  = 0 unless defined $$ibap_object_ref{'use_ttl'};

    my $res = $self->SUPER::__ibap_to_object__(@_);

    #
    delete $$self{'ttl'} unless $$ibap_object_ref{'use_ttl'};

    return $res;
}

sub __search_mapping_hook_pre__ {

    my ($self, $session, $type, $argsref, $out_search_fields_ref, $out_search_types_ref, $out_search_matches_ref) = @_;

    unless ($argsref->{'dtc_server'}) {
        set_error_codes('1103', '\'dtc_server\' is a required search parameter', $session);
        return 0;
    }

    return 1;
}

sub __i2o_idns_server__ {

    my ($self, $session, $current, $ibap_object_ref) = @_;

    my $srv = Infoblox::DTC::Server->new(
        host => $$ibap_object_ref{$current}{host},
        name => $$ibap_object_ref{$current}{name},
    );

    $srv->{__object_id__} = $$ibap_object_ref{$current}{object_id}{id};
    $srv->{__partial__}   = 1;

    return $srv;
}

sub __init_instance_constants__ {}


package Infoblox::DTC::Record::A;

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

@ISA = qw( Infoblox::DTC::RecordBase );

BEGIN {

    %_capabilities = ();

    $_object_type = 'IdnsARecord';
    register_wsdl_type('ib:IdnsARecord', 'Infoblox::DTC::Record::A');

    %_allowed_members = (
                         'auto_created' => {simple => 'bool', readonly => 1},
                         'ipv4addr'     => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_ipv4addr},
    );

    %_name_mappings = (
                       'ipv4addr' => 'address',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           ipv4addr => [\&ibap_o2i_string, 'address', 'REGEX'],
    );

    @_return_fields = (
                       tField('address'),
                       tField('auto_created'),
    );

    %_object_to_ibap = (
                        'auto_created' => \&ibap_o2i_ignore,
                        'ipv4addr'     => \&ibap_o2i_string,
    );

    %_return_field_overrides = (
                                'auto_created' => [],
                                'ipv4addr'     => [],
    );

    Infoblox::IBAPBase::subclass('Infoblox::DTC::RecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}

sub __ibap_to_object__ {

    my $self = shift;
    my ($ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'auto_created'} = 0 unless defined $$ibap_object_ref{'auto_created'};

    return $self->SUPER::__ibap_to_object__(@_);
}


package Infoblox::DTC::Record::AAAA;

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

@ISA = qw( Infoblox::DTC::RecordBase );

BEGIN {

    %_capabilities = ();

    $_object_type = 'IdnsAaaaRecord';
    register_wsdl_type('ib:IdnsAaaaRecord', 'Infoblox::DTC::Record::AAAA');

    %_allowed_members = (
                         'auto_created' => {simple => 'bool', readonly => 1},
                         'ipv6addr'     => {simple => 'asis', validator => \&ibap_value_o2i_ipv6addr},
    );

    %_searchable_fields = (
                           ipv6addr => [\&ibap_o2i_string, 'address', 'REGEX'],
    );

    %_name_mappings = (
                       'ipv6addr' => 'address',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('address'),
                       tField('auto_created'),
    );

    %_object_to_ibap = (
                        'auto_created' => \&ibap_o2i_ignore,
                        'ipv6addr'     => \&ibap_o2i_string,
    );

    %_return_field_overrides = (
                                'auto_created' => [],
                                'ipv6addr'     => [],
    );

    Infoblox::IBAPBase::subclass('Infoblox::DTC::RecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}

sub __ibap_to_object__ {

    my $self = shift;
    my ($ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'auto_created'} = 0 unless defined $$ibap_object_ref{'auto_created'};

    return $self->SUPER::__ibap_to_object__(@_);
}


package Infoblox::DTC::Record::CNAME;

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

@ISA = qw( Infoblox::DTC::RecordBase );

BEGIN {

    %_capabilities = ();

    $_object_type = 'IdnsCnameRecord';
    register_wsdl_type('ib:IdnsCnameRecord', 'Infoblox::DTC::Record::CNAME');

    %_allowed_members = (
                         'auto_created'  => {simple => 'bool', readonly => 1},
                         'canonical'     => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'dns_canonical' => {simple => 'asis', readonly => 1},
    );

    %_searchable_fields = (
                           canonical => [\&ibap_o2i_string, 'canonical_name', 'REGEX'],
    );

    %_name_mappings = (
                       'canonical'     => 'canonical_name',
                       'dns_canonical' => 'dns_canonical_name',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('auto_created'),
                       tField('canonical_name'),
                       tField('dns_canonical_name'),
    );

    %_object_to_ibap = (
                        'auto_created'  => \&ibap_o2i_ignore,
                        'canonical'     => \&ibap_o2i_string,
                        'dns_canonical' => \&ibap_o2i_ignore,
    );

    %_return_field_overrides = (
                                'auto_created'  => [],
                                'canonical'     => [],
                                'dns_canonical' => [],
    );

    Infoblox::IBAPBase::subclass('Infoblox::DTC::RecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}

sub __ibap_to_object__ {

    my $self = shift;
    my ($ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'auto_created'} = 0 unless defined $$ibap_object_ref{'auto_created'};

    return $self->SUPER::__ibap_to_object__(@_);
}


package Infoblox::DTC::Record::NAPTR;

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

@ISA = qw( Infoblox::DTC::RecordBase );

BEGIN {

    $_object_type = 'IdnsNaptrRecord';
    register_wsdl_type('ib:IdnsNaptrRecord', 'Infoblox::DTC::Record::NAPTR');

    %_capabilities = ();

    %_allowed_members = (
                         'flags'       => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'order'       => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'preference'  => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'regexp'      => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'replacement' => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'services'    => {simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    %_searchable_fields = (
                           'flags'       => [\&ibap_o2i_string, 'flags', 'REGEX'],
                           'order'       => [\&ibap_o2i_uint, 'order', 'EXACT'],
                           'preference'  => [\&ibap_o2i_uint, 'preference', 'EXACT'],
                           'regexp'      => [\&ibap_o2i_string, 'regexp', 'REGEX'],
                           'replacement' => [\&ibap_o2i_string, 'replacement', 'REGEX'],
                           'services'    => [\&ibap_o2i_string, 'services', 'REGEX'],
    );

    %_name_mappings = ();

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
    );

    %_object_to_ibap = (
                        'flags'       => \&ibap_o2i_string,
                        'order'       => \&ibap_o2i_uint,
                        'preference'  => \&ibap_o2i_uint,
                        'regexp'      => \&ibap_o2i_string,
                        'replacement' => \&ibap_o2i_string,
                        'services'    => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('flags'),
                       tField('order'),
                       tField('preference'),
                       tField('regexp'),
                       tField('replacement'),
                       tField('services'),
    );

    %_return_field_overrides = (
                                'flags'       => [],
                                'order'       => [],
                                'preference'  => [],
                                'regexp'      => [],
                                'replacement' => [],
                                'services'    => [],
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DTC::RecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


1;
