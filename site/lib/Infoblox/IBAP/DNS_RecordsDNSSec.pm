package Infoblox::DNS::DNSSecRecordBase;

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
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_return_field_overrides
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'cloud_info' => {readonly => 1, validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
                         'creator'    => {readonly => 1, siimple => 'asis', enum => ['STATIC', 'DYNAMIC', 'SYSTEM']},
                         'dns_name'   => {readonly => 1, simple => 'asis'},
                         'name'       => {readonly => 1, simple => 'asis'},
                         'ttl'        => {readonly => 1, simple => 'asis'},
                         'view'       => {readonly => 1},
                         'zone'       => {readonly => 1, simple => 'asis'},
    );

    %_name_mappings = (
                       'name'     => 'fqdn',
                       'zone'     => 'parent',
                       'dns_name' => 'dns_fqdn',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           'view'    => [\&ibap_o2i_view, 'view', 'EXACT'],
                           'name'    => [\&ibap_o2i_string, 'fqdn', 'REGEX', 'IGNORE_CASE'],
                           'zone'    => [\&ibap_o2i_string, 'parent', 'EXACT'],
                           'creator' => [\&ibap_o2i_string, 'creator', 'EXACT'],
                           'ttl'     => [\&ibap_o2i_uint, 'ttl', 'EXACT'],
    );

    @_return_fields = (
                       tField('fqdn'),
                       tField('dns_fqdn'),
                       tField('parent'),
                       tField('ttl'),
                       tField('use_ttl'),
                       tField('creator'),
    );

    %_ibap_to_object = (
                        'view'       => \&ibap_i2o_generic_object_convert,
                        'cloud_info' => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                        'name'       => \&ibap_o2i_ignore,
                        'ttl'        => \&ibap_o2i_ignore,
                        'use_ttl'    => \&ibap_o2i_ignore,
                        'view'       => \&ibap_o2i_ignore,
                        'zone'       => \&ibap_o2i_ignore,
                        'cloud_info' => \&ibap_o2i_ignore,
                        'creator'    => \&ibap_o2i_ignore,
                        'dns_name'   => \&ibap_o2i_ignore,
    );

    %_return_field_overrides = (
                                'cloud_info' => [],
                                'creator'    => [],
                                'dns_name'   => [],
                                'name'       => [],
                                'ttl'        => ['use_ttl'],
                                'view'       => [],
                                'zone'       => [],
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

    my $res = $self->SUPER::__ibap_to_object__(@_);

    unless ($$ibap_object_ref{'use_ttl'}) {
        $$self{ttl} = undef;
    }

    return $res;
}


package Infoblox::DNS::Record::DNSKEY;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

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
            $_return_fields_initialized
            %_capabilities
);

@ISA = qw( Infoblox::DNS::DNSSecRecordBase );

BEGIN {

    $_object_type = 'DnskeyRecord';
    register_wsdl_type('ib:DnskeyRecord', 'Infoblox::DNS::Record::DNSKEY');

    %_capabilities = ();

    %_allowed_members = (
                         'algorithm'  => {readonly => 1, enum => \@dnssec_algorithm_list},
                         'flags'      => {readonly => 1, simple => 'asis'},
                         'key_tag'    => {readonly => 1, simple => 'asis'},
                         'public_key' => {readonly => 1, simple => 'asis'},
    );

    %_name_mappings = ();

    %_ibap_to_object = (
                        'algorithm' => \&ibap_i2o_key_algorithm,
    );

    %_searchable_fields = (
                           'algorithm'  => [\&ibap_o2i_key_algorithm, 'algorithm', 'EXACT'],
                           'flags'      => [\&ibap_o2i_integer, 'flags', 'EXACT'],
                           'key_tag'    => [\&ibap_o2i_integer, 'key_tag', 'EXACT'],
                           'public_key' => [\&ibap_o2i_string, 'public_key', 'REGEX'],
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                'algorithm'  => [],
                                'flags'      => [],
                                'key_tag'    => [],
                                'public_key' => [],
    );

    %_object_to_ibap = ();

    @_return_fields = (
                       tField('algorithm'),
                       tField('flags'),
                       tField('key_tag'),
                       tField('public_key'),
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::DNSSecRecordBase', $_object_type, {cloud_info => 1});
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {
        $_return_fields_initialized = 1;

        #
        my $t = Infoblox::DNS::View->__new__();

        push @_return_fields, tField('view', {
            default_no_access_ok => 1,
            sub_fields           => $t->__return_fields__(),
        });
    }
}

sub __ibap_to_object__ {

    my $self = shift;
    my ($ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    my $res = $self->SUPER::__ibap_to_object__(@_);

    delete $$self{'ttl'} unless $$ibap_object_ref{'use_ttl'};
    return $res;
}


package Infoblox::DNS::Record::DS;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

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
            $_return_fields_initialized
            %_capabilities
            %_digest_type_mappings
            %_reverse_digest_type_mappings
);

@ISA = qw( Infoblox::DNS::DNSSecRecordBase );

BEGIN {

    $_object_type = 'DsRecord';
    register_wsdl_type('ib:DsRecord', 'Infoblox::DNS::Record::DS');

    %_capabilities = ();

    %_allowed_members = (
                         'algorithm'   => {readonly => 1, enum => \@dnssec_algorithm_list},
                         'digest'      => {readonly => 1, simple => 'asis'},
                         'digest_type' => {readonly => 1, enum => ['SHA1', 'SHA256', '1', '2']},
                         'key_tag'     => {readonly => 1, simple => 'asis'},
                         'last_queried' => {readonly => 1},
    );

    %_name_mappings = ();
    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'algorithm'   => \&ibap_i2o_key_algorithm,
                        'digest_type' => \&__i2o_digest_type__,
                        'last_queried'          => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    %_searchable_fields = (
                            'algorithm'   => [\&ibap_o2i_key_algorithm, 'algorithm', 'EXACT'],
                            'digest'      => [\&ibap_o2i_string, 'digest', 'REGEX'],
                            'digest_type' => [\&__o2i_digest_type__, 'digest_type', 'EXACT'],
                            'key_tag'     => [\&ibap_o2i_integer, 'key_tag', 'EXACT'],
    );

    %_return_field_overrides = (
                                'algorithm'   => [],
                                'digest'      => [],
                                'digest_type' => [],
                                'key_tag'     => [],
                                'last_queried' => [],
    );

    %_object_to_ibap = ();

    @_return_fields = (
                       tField('algorithm'),
                       tField('digest'),
                       tField('digest_type'),
                       tField('key_tag'),
                       tField('last_queried'),
    );

    %_digest_type_mappings = (
                              'SHA1'   => 'SHA_1',
                              'SHA256' => 'SHA_256',
                              '1'      => 'SHA_1',
                              '2'      => 'SHA_256'
    );

    %_reverse_digest_type_mappings = (
                                      'SHA_1'   => 'SHA1',
                                      'SHA_256' => 'SHA256'
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::DNSSecRecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}

sub __i2o_digest_type__ {

    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $value = $_reverse_digest_type_mappings{$$ibap_object_ref{$current}};
    return ($value ? $value : $$ibap_object_ref{$current});
}


sub __o2i_digest_type__ {

    my ($self, $session, $current, $tempref) = @_;

    if (not defined $$tempref{$current}) {
        return (1, 1, undef);
    } else {
        my $value = $_digest_type_mappings{$$tempref{$current}};
        return (1, 0, ibap_value_o2i_string(($value ? $value : $$tempref{$current}), 'digest_type', $session));
    }
}

#
sub __remove_override_hook__ {

    my ($obj, $session) = @_;

    set_error_codes(9999, 'continue', $session);
    return;
}


package Infoblox::DNS::Record::NSEC;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

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
            $_return_fields_initialized
            %_capabilities
            %_digest_type_mappings
            %_reverse_digest_type_mappings
);

@ISA = qw( Infoblox::DNS::DNSSecRecordBase );

BEGIN {

    $_object_type = 'NsecRecord';
    register_wsdl_type('ib:NsecRecord', 'Infoblox::DNS::Record::NSEC');

    %_capabilities = ();

    %_allowed_members = (
                         'dns_next_domain_name' => {readonly => 1, simple => 'asis'},
                         'next_domain_name'     => {readonly => 1, simple => 'asis'},
                         'types'                => {readonly => 1, simple => 'asis'},
    );

    %_name_mappings = ();
    %_reverse_name_mappings = reverse %_name_mappings;
    %_ibap_to_object = ();
    %_object_to_ibap = ();

    %_searchable_fields = (
                           'next_domain_name' => [\&ibap_o2i_string, 'next_domain_name', 'REGEX', 'IGNORE_CASE'],
                           'types'            => [\&ibap_o2i_string, 'types', 'REGEX', 'IGNORE_CASE'],
    );

    %_return_field_overrides = (
                                'dns_next_domain_name' => [],
                                'next_domain_name'     => [],
                                'types'                => [],
    );

    @_return_fields = (
                       tField('dns_next_domain_name'),
                       tField('inherited_values'),
                       tField('next_domain_name'),
                       tField('types'),
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::DNSSecRecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


package Infoblox::DNS::Record::NSEC3;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

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
            $_return_fields_initialized
            %_capabilities
            %_digest_type_mappings
            %_reverse_digest_type_mappings
);

@ISA = qw( Infoblox::DNS::DNSSecRecordBase );

BEGIN {

    $_object_type = 'Nsec3Record';
    register_wsdl_type('ib:Nsec3Record', 'Infoblox::DNS::Record::NSEC3');

    %_capabilities = ();

    %_allowed_members = (
                         'flags'           => {readonly => 1, simple => 'asis'},
                         'hash_algorithm'  => {readonly => 1, simple => 'asis'},
                         'iterations'      => {readonly => 1, simple => 'asis'},
                         'next_hash_owner' => {readonly => 1, simple => 'asis'},
                         'salt'            => {readonly => 1, simple => 'asis'},
                         'types'           => {readonly => 1, simple => 'asis'},
                         #
    );

    %_name_mappings = ();
    %_reverse_name_mappings = reverse %_name_mappings;
    %_ibap_to_object = ();
    %_object_to_ibap = ();

    %_searchable_fields = (
                           'flags'           => [\&ibap_o2i_integer, 'flags', 'EXACT'],
                           'hash_algorithm'  => [\&ibap_o2i_integer, 'hash_algorithm', 'EXACT'],
                           'iterations'      => [\&ibap_o2i_integer, 'iterations', 'EXACT'],
                           'next_hash_owner' => [\&ibap_o2i_string, 'next_hash_owner', 'REGEX', 'IGNORE_CASE'],
                           'salt'            => [\&ibap_o2i_string, 'salt', 'REGEX'],
                           'types'           => [\&ibap_o2i_string, 'types', 'REGEX', 'IGNORE_CASE'],
    );

    %_return_field_overrides = (
                                'flags'           => [],
                                'hash_algorithm'  => [],
                                'iterations'      => [],
                                'next_hash_owner' => [],
                                'salt'            => [],
                                'types'           => [],
    );

    @_return_fields = (
                        tField('flags'),
                        tField('hash_algorithm'),
                        tField('inherited_values'),
                        tField('iterations'),
                        tField('next_hash_owner'),
                        tField('salt'),
                        tField('types'),
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::DNSSecRecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


package Infoblox::DNS::Record::NSEC3PARAM;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

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
            $_return_fields_initialized
            %_capabilities
            %_digest_type_mappings
            %_reverse_digest_type_mappings
);

@ISA = qw( Infoblox::DNS::DNSSecRecordBase );

BEGIN {

    $_object_type = 'Nsec3paramRecord';
    register_wsdl_type('ib:Nsec3paramRecord', 'Infoblox::DNS::Record::NSEC3PARAM');

    %_capabilities = ();

    %_allowed_members = (
                         'flags'          => {readonly => 1, simple => 'asis'},
                         'hash_algorithm' => {readonly => 1, simple => 'asis'},
                         'iterations'     => {readonly => 1, simple => 'asis'},
                         'salt'           => {readonly => 1, simple => 'asis'},
                        );

    %_name_mappings = ();
    %_reverse_name_mappings = reverse %_name_mappings;
    %_ibap_to_object = ();
    %_object_to_ibap = ();

    %_searchable_fields = (
                           'flags'          => [\&ibap_o2i_integer, 'flags', 'EXACT'],
                           'hash_algorithm' => [\&ibap_o2i_integer, 'hash_algorithm', 'EXACT'],
                           'iterations'     => [\&ibap_o2i_integer, 'iterations', 'EXACT'],
                           'salt'           => [\&ibap_o2i_string, 'salt', 'REGEX'],
    );

    %_return_field_overrides = (
                                'flags'          => [],
                                'hash_algorithm' => [],
                                'iterations'     => [],
                                'salt'           => [],
    );

    @_return_fields = (
                       tField('flags'),
                       tField('hash_algorithm'),
                       tField('inherited_values'),
                       tField('iterations'),
                       tField('salt'),
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::DNSSecRecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


package Infoblox::DNS::Record::RRSIG;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

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
            $_return_fields_initialized
            %_capabilities
            %_digest_type_mappings
            %_reverse_digest_type_mappings
);

@ISA = qw( Infoblox::DNS::DNSSecRecordBase );

BEGIN {

    $_object_type = 'RrsigRecord';
    register_wsdl_type('ib:RrsigRecord', 'Infoblox::DNS::Record::RRSIG');

    %_capabilities = ();

    %_allowed_members = (
                         'algorithm'       => {readonly => 1, enum => \@dnssec_algorithm_list},
                         'dns_signer_name' => {readonly => 1, simple => 'asis'},
                         'expiration'      => {readonly => 1},
                         'inception'       => {readonly => 1},
                         'key_tag'         => {readonly => 1, simple => 'asis'},
                         'labels'          => {readonly => 1, simple => 'asis'},
                         'original_ttl'    => {readonly => 1, simple => 'asis'},
                         'signature'       => {readonly => 1, simple => 'asis'},
                         'signer_name'     => {readonly => 1, simple => 'asis'},
                         'type_covered'    => {readonly => 1, simple => 'asis'},
    );

    %_name_mappings = (
                       'expiration' => 'expiration_time',
                       'inception'  => 'inception_time',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'algorithm'       => \&ibap_i2o_key_algorithm,
                        'expiration_time' => \&ibap_i2o_datetime_to_unix_timestamp,
                        'inception_time'  => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    %_searchable_fields = (
                           'algorithm'       => [\&ibap_o2i_key_algorithm, 'algorithm', 'EXACT'],
                           'expiration'      => [\&ibap_o2i_unix_timestamp_to_datetime, 'expiration_time', 'GLEQ'],
                           'expiration_start' =>[\&ibap_o2i_unix_timestamp_to_datetime, 'expiration_time_start', 'GEQ_expiration_time'],
                           'expiration_end'  => [\&ibap_o2i_unix_timestamp_to_datetime, 'expiration_time_end', 'LEQ_expiration_time'],
                           'inception'       => [\&ibap_o2i_unix_timestamp_to_datetime, 'inception_time', 'GLEQ'],
                           'inception_start' => [\&ibap_o2i_unix_timestamp_to_datetime, 'inception_time_start', 'GEQ_inception_time'],
                           'inception_end'   => [\&ibap_o2i_unix_timestamp_to_datetime, 'inception_time_end', 'LEQ_inception_time'],
                           'key_tag'         => [\&ibap_o2i_integer, 'key_tag', 'EXACT'],
                           'labels'          => [\&ibap_o2i_integer, 'labels', 'EXACT'],
                           'original_ttl'    => [\&ibap_o2i_uint, 'original_ttl', 'EXACT'],
                           'signature'       => [\&ibap_o2i_string, 'signature', 'REGEX'],
                           'signer_name'     => [\&ibap_o2i_string, 'signer_name', 'REGEX', 'IGNORE_CASE'],
                           'type_covered'    => [\&ibap_o2i_string, 'type_covered', 'REGEX', 'IGNORE_CASE'],
    );

    %_return_field_overrides = (
                                'algorithm'       => [],
                                'dns_name'        => [],
                                'dns_signer_name' => [],
                                'expiration'      => [],
                                'inception'       => [],
                                'key_tag'         => [],
                                'labels'          => [],
                                'original_ttl'    => [],
                                'signature'       => [],
                                'signer_name'     => [],
                                'type_covered'    => [],
    );

    %_object_to_ibap = ();

    @_return_fields = (
                       tField('algorithm'),
                       tField('expiration_time'),
                       tField('inception_time'),
                       tField('key_tag'),
                       tField('labels'),
                       tField('original_ttl'),
                       tField('signature'),
                       tField('signer_name'),
                       tField('dns_signer_name'),
                       tField('type_covered'),
    );

    $_return_fields_initialized = 0;

    Infoblox::IBAPBase::subclass('Infoblox::DNS::DNSSecRecordBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


1;
