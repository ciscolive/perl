# Copyright (c) 2017 Infoblox Inc.

package Infoblox::Grid::DataCollection::IPInfo;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            %_name_mappings
            %_reverse_name_mappings
            @ISA
            $_object_type
            %_allowed_members
            %_object_to_ibap
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'ip_info';
    register_wsdl_type('ib:ip_info', 'Infoblox::Grid::DataCollection::IPInfo');



    %_allowed_members = (
                         'nat_enabled' => {simple => 'bool', readonly => 1},
                         'ip_address'  => {simple => 'asis', readonly => 1},
                         'nat_group'   => {simple => 'asis', readonly => 1},
                         'nat_ip'      => {simple => 'asis', readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_reverse_name_mappings = reverse %_name_mappings;

    %_object_to_ibap = (
                        'nat_enabled' => \&ibap_o2i_ignore,
                        'ip_address'  => \&ibap_o2i_ignore,
                        'nat_group'   => \&ibap_o2i_ignore,
                        'nat_ip'      => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('ip_address'),
                       tField('nat_enabled'),
                       tField('nat_ip'),
                       tField('nat_group'),
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

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'nat_enabled'} = 0 unless defined $$ibap_object_ref{'nat_enabled'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::DataCollection::BlacklistedCluster;

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

    $_object_type = 'data_collection_blacklist';
    register_wsdl_type('ib:data_collection_blacklist', 'Infoblox::Grid::DataCollection::BlacklistedCluster');



    %_allowed_members = (
                         'comment'   => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'name'      => {readonly => 1, simple => 'asis'},
                         'unique_id' => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'comment'   => \&ibap_o2i_string,
                        'name'      => \&ibap_o2i_ignore,
                        'unique_id' => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('name'),
                       tField('comment'),
                       tField('unique_id'),
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


package Infoblox::Grid::DataCollection::Cluster;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            %_name_mappings
            %_reverse_name_mappings
            %_return_field_overrides
            %_searchable_fields
            %_capabilities
            @ISA
            @_return_fields
            $_object_type
            %_allowed_members
            %_object_to_ibap
            %_ibap_to_object
            $_return_fields_initialized
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE );

BEGIN {

    $_object_type = 'DataCollectionCluster';
    register_wsdl_type('ib:DataCollectionCluster', 'Infoblox::Grid::DataCollection::Cluster');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'blacklisted_clusters' => {array => 1, validator => {'Infoblox::Grid::DataCollection::BlacklistedCluster' => 1}},
                         'comment'              => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'datacollector_vms'    => {readonly => 1, array => 1, validator => {'Infoblox::Grid::DataCollection::IPInfo' => 1}},
                         'disable'              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'last_activation_time' => {readonly => 1},
                         'name'                 => {readonly => 1, simple => 'asis'},
                         'registration_time'    => {readonly => 1},
                         'unique_id'            => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'enable_registration'  => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'comment'   => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'name'      => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'unique_id' => [\&ibap_o2i_string, 'unique_id', 'REGEX'],
    );

    %_name_mappings = (
                       'blacklisted_clusters' => 'blacklist',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'blacklist'            => \&ibap_i2o_generic_object_list_convert,
                        'datacollector_vms'    => \&ibap_i2o_generic_object_list_convert,
                        'last_activation_time' => \&ibap_i2o_datetime_to_unix_timestamp,
                        'registration_time'    => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    %_object_to_ibap = (
                        'blacklisted_clusters' => \&ibap_o2i_generic_struct_list_convert,
                        'comment'              => \&ibap_o2i_string,
                        'datacollector_vms'    => \&ibap_o2i_ignore,
                        'disable'              => \&ibap_o2i_boolean,
                        'last_activation_time' => \&ibap_o2i_ignore,
                        'name'                 => \&ibap_o2i_ignore,
                        'registration_time'    => \&ibap_o2i_ignore,
                        'unique_id'            => \&ibap_o2i_string,
                        'enable_registration'  => \&ibap_o2i_boolean,
    );

    @_return_fields = (
                       tField('comment'),
                       tField('disable'),
                       tField('last_activation_time'),
                       tField('name'),
                       tField('registration_time'),
                       tField('unique_id'),
                       tField('enable_registration'),
    );

    %_return_field_overrides = (
                                'blacklisted_clusters' => [],
                                'comment'              => [],
                                'datacollector_vms'    => [],
                                'last_activation_time' => [],
                                'name'                 => [],
                                'registration_time'    => [],
                                'unique_id'            => [],
                                'disable'              => [],
                                'enable_registration'  => [],
    );

    $_return_fields_initialized = 0;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    $self->__init_instance_constants__();
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

        my ($tmp, %tmp);

        %tmp = (
                'datacollector_vms' => 'Infoblox::Grid::DataCollection::IPInfo',
                'blacklist'         => 'Infoblox::Grid::DataCollection::BlacklistedCluster',
        );

        foreach my $key (keys %tmp) {
            $tmp = $tmp{$key}->__new__();
            push @_return_fields, tField($key, {sub_fields => $tmp->__return_fields__()});
        }
    }
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
             'disable',
             'enable_registration',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    foreach (
             'blacklisted_clusters',
             'datacollector_vms',
    ) {
        $self->{$_} = [];
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


1;
