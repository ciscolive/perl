package Infoblox::Grid::ServiceRestart;

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
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'restart_setting';
    register_wsdl_type('ib:restart_setting', 'Infoblox::Grid::ServiceRestart');

    %_allowed_members = (
                         'delay'           => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'restart_offline' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'timeout'         => {simple => 'asis', validator => \&ibap_value_o2i_int},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('delay'),
                       tField('restart_offline'),
                       tField('timeout'),
    );

    %_object_to_ibap = (
                        'delay'           => \&ibap_o2i_uint,
                        'restart_offline' => \&ibap_o2i_boolean,
                        'timeout'         => \&ibap_o2i_integer,
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

    $$ibap_object_ref{'restart_offline'} = 0 unless defined $$ibap_object_ref{'restart_offline'};
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

package Infoblox::Grid::ServiceRestart::Group;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( %_allowed_members
             $_return_fields_initialized
             %_capabilities
             @_return_fields
             $_object_type
             %_ibap_to_object
             %_object_to_ibap
             %_name_mappings
             %_reverse_name_mappings
             %_searchable_fields
             @ISA );

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'RestartGroup';
    register_wsdl_type('ib:RestartGroup', 'Infoblox::Grid::ServiceRestart::Group');

    %_allowed_members = (
                         'comment'               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'extattrs'              => {special => 'extensible_attributes'},
                         'extensible_attributes' => {special => 'extensible_attributes'},
                         'is_default'            => {readonly => 1, simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'last_updated_time'     => {readonly => 1, validator => \&ibap_value_o2i_uint},
                         'members'               => {array => 1, validator => \&ibap_value_o2i_string},
                         'mode'                  => {simple => 'asis', enum => ['SEQUENTIAL', 'SIMULTANEOUS']},
                         'name'                  => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'position'              => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_integer},
                         'recurring_schedule'    => {validator => {'Infoblox::Grid::ServiceRestart::Group::Schedule' => 1}},
                         'requests'              => {readonly => 1, array => 1, validator => {'Infoblox::Grid::ServiceRestart::Request' => 1}},
                         'service'               => {mandatory => 1, simple => 'asis', enum => ['DHCP', 'DNS']},
                         'status'                => {readonly => 1, validator => {'Infoblox::Grid::ServiceRestart::Status' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'comment'               => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'extattrs'              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'is_default'            => [\&ibap_o2i_boolean, 'is_default', 'EXACT'],
                           'name'                  => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'position'              => [\&ibap_o2i_uint, 'position', 'EXACT'],
                           'service'               => [\&ibap_o2i_string, 'service', 'EXACT'],
    );

    %_name_mappings = (
                       'extattrs'          => 'extensible_attributes',
                       'last_updated_time' => 'last_updated',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       return_fields_extensible_attributes(),
                       tField('comment'),
                       tField('is_default'),
                       tField('last_updated'),
                       tField('members', {sub_fields => [tField('host_name')]}),
                       tField('mode'),
                       tField('name'),
                       tField('position'),
                       tField('service'),

    );

    %_ibap_to_object = (
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'last_updated'          => \&ibap_i2o_datetime_to_unix_timestamp,
                        'members'               => \&ibap_i2o_member_name,
                        'recurring_schedule'    => \&ibap_i2o_generic_object_convert,
                        'requests'              => \&ibap_i2o_generic_object_list_convert,
                        'status'                => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                         'comment'               => \&ibap_o2i_string,
                         'extattrs'              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                         'extensible_attributes' => \&ibap_o2i_ignore,
                         'is_default'            => \&ibap_o2i_ignore,
                         'last_updated_time'     => \&ibap_o2i_ignore,
                         'members'               => \&ibap_o2i_member_name,
                         'mode'                  => \&ibap_o2i_string,
                         'name'                  => \&ibap_o2i_string,
                         'position'              => \&ibap_o2i_uint,
                         'recurring_schedule'    => \&ibap_o2i_generic_struct_convert,
                         'requests'              => \&ibap_o2i_ignore,
                         'service'               => \&ibap_o2i_string,
                         'status'                => \&ibap_o2i_ignore,
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
                'recurring_schedule' => 'Infoblox::Grid::ServiceRestart::Group::Schedule',
                'requests'           => 'Infoblox::Grid::ServiceRestart::Request',
                'status'             => 'Infoblox::Grid::ServiceRestart::Status',
        );

        foreach (keys %tmp) {
            $t = $tmp{$_}->__new__();
            push @_return_fields, tField($_, { sub_fields => $t->__return_fields__ });
        }
    }
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

    $$ibap_object_ref{'is_default'} = 0 unless defined $$ibap_object_ref{'is_default'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::ServiceRestart::Status;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             $_return_fields_initialized
             %_capabilities
             @_return_fields
             $_object_type
             %_ibap_to_object
             %_object_to_ibap
             %_name_mappings
             %_reverse_name_mappings
             %_searchable_fields
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'RestartStatus';
    register_wsdl_type('ib:RestartStatus', 'Infoblox::Grid::ServiceRestart::Status');

    %_allowed_members = (
                         'failures'        => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'finished'        => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'parent'          => {readonly => 1, validator => {'Infoblox::Grid' => 1, 'Infoblox::Grid::ServiceRestart::Group' => 1}},
                         'grouped'         => {readonly => 1, simple => 'asis', enum => ['GROUP', 'GRID']},
                         'needed_restart'  => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'no_restart'      => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'pending'         => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'pending_restart' => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'processing'      => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'restarting'      => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'success'         => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'timeouts'        => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'parent'  => [\&ibap_o2i_object_only_by_oid, 'parent', 'EXACT'],
                           'grouped' => [\&ibap_o2i_string, 'grouped', 'EXACT'],
    );

    %_name_mappings = (
                       'needed_restart' => 'new',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('failures'),
                       tField('finished'),
                       tField('grouped'),
                       tField('new'),
                       tField('no_restart'),
                       tField('parent', {sub_fields => [
                                                        tField('name'),
                                                        tField('service', {not_exist_ok => 1}),
                                                       ]}),
                       tField('pending'),
                       tField('pending_restart'),
                       tField('processing'),
                       tField('restarting'),
                       tField('success'),
                       tField('timeouts'),
    );

    %_ibap_to_object = (
                        'parent' => \&ibap_i2o_generic_object_convert_partial,
    );

    %_object_to_ibap = (
                        'failures'        => \&ibap_o2i_ignore,
                        'finished'        => \&ibap_o2i_ignore,
                        'group'           => \&ibap_o2i_ignore,
                        'grouped'         => \&ibap_o2i_ignore,
                        'needed_restart'  => \&ibap_o2i_ignore,
                        'no_restart'      => \&ibap_o2i_ignore,
                        'pending'         => \&ibap_o2i_ignore,
                        'pending_restart' => \&ibap_o2i_ignore,
                        'processing'      => \&ibap_o2i_ignore,
                        'restarting'      => \&ibap_o2i_ignore,
                        'success'         => \&ibap_o2i_ignore,
                        'timeouts'        => \&ibap_o2i_ignore,
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

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

package Infoblox::Grid::ServiceRestart::Request;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             $_return_fields_initialized
             %_capabilities
             @_return_fields
             $_object_type
             %_ibap_to_object
             %_object_to_ibap
             %_name_mappings
             %_reverse_name_mappings
             %_searchable_fields
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'RestartRequest';
    register_wsdl_type('ib:RestartRequest', 'Infoblox::Grid::ServiceRestart::Request');

    %_allowed_members = (
                         'error'             => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'forced'            => {readonly => 1, simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'group'             => {readonly => 1, validator => {'Infoblox::Grid::ServiceRestart::Group' => 1}},
                         'last_updated_time' => {readonly => 1, validator => \&ibap_value_o2i_uint},
                         'member'            => {readonly => 1, validator => \&ibap_value_o2i_string},
                         'needed'            => {readonly => 1, simple => 'asis', enum => ['UNKNOWN', 'CHECKING', 'YES', 'NO', 'FAILURE']},
                         'order'             => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_int},
                         'result'            => {readonly => 1, simple => 'asis', enum => ['SUCCESS', 'TIMEOUT', 'FAILURE', 'NORESTART']},
                         'service'           => {readonly => 1, simple => 'asis', enum => ['DNS', 'DHCP', 'DHCPV4', 'DHCPV6']},
                         'state'             => {readonly => 1, simple => 'asis', enum => ['NEW', 'QUEUED', 'PROCESSING', 'FINISHED']},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'group'  => [\&ibap_o2i_object_only_by_oid, 'group', 'EXACT'],
                           'member' => [\&ibap_o2i_member_name, 'member', 'EXACT'],
    );

    %_name_mappings = (
                       'last_updated_time' => 'last_updated',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('error'),
                       tField('forced'),
                       tField('group', {sub_fields => [
                                                       tField('name'),
                                                       tField('service'),
                                                      ]}),
                       tField('last_updated'),
                       tField('member', {sub_fields => [tField('host_name')]}),
                       tField('needed'),
                       tField('order'),
                       tField('result'),
                       tField('service'),
                       tField('state'),
    );

    %_ibap_to_object = (
                        'group'        => \&ibap_i2o_generic_object_convert_partial,
                        'member'       => \&ibap_i2o_member_name,
                        'last_updated' => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    %_object_to_ibap = (
                        'error'             => \&ibap_o2i_ignore,
                        'forced'            => \&ibap_o2i_ignore,
                        'group'             => \&ibap_o2i_ignore,
                        'last_updated_time' => \&ibap_o2i_ignore,
                        'member'            => \&ibap_o2i_ignore,
                        'needed'            => \&ibap_o2i_ignore,
                        'order'             => \&ibap_o2i_ignore,
                        'result'            => \&ibap_o2i_ignore,
                        'service'           => \&ibap_o2i_ignore,
                        'state'             => \&ibap_o2i_ignore,
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

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'forced'} = 0 unless defined $$ibap_object_ref{'forced'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::ServiceRestart::Group::Schedule;

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
             %_object_to_ibap
             $_return_fields_initialized
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'recurring_schedule';
    register_wsdl_type('ib:recurring_schedule', 'Infoblox::Grid::ServiceRestart::Group::Schedule');

    %_allowed_members = (
                         'force'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'mode'     => {simple => 'asis', enum => ['GROUPED', 'SEQUENTIAL', 'SIMULTANEOUS']},
                         'schedule' => {mandatory => 1, validator => {'Infoblox::Grid::ScheduleSetting' => 1}},
                         'services' => {array => 1, simple => 'asis', enum => ['ALL', 'DNS', 'DHCP', 'DHCPV4', 'DHCPV6']},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('force'),
                       tField('mode'),
                       tField('schedule'),
                       tField('services'),
    );

    %_ibap_to_object = (
                        'schedule' => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                        'force'    => \&ibap_o2i_boolean,
                        'mode'     => \&ibap_o2i_string,
                        'schedule' => \&ibap_o2i_generic_struct_convert,
                        'services' => \&ibap_o2i_string_array_undef_to_empty,
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

        my $t = Infoblox::Grid::ScheduleSetting->__new__();
        push @_return_fields,
            tField('schedule', {sub_fields => $t->__return_fields__()});
    }
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'force'} = 0 unless defined $$ibap_object_ref{'force'};
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::ServiceRestart::Group::Order;

use strict;
use Carp;

use Infoblox::PAPIOverrides;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( %_allowed_members
             $_return_fields_initialized
             %_capabilities
             @_return_fields
             $_object_type
             %_ibap_to_object
             %_object_to_ibap
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_ONLY );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'OrderedRestartGroups';
    register_wsdl_type('ib:OrderedRestartGroups', 'Infoblox::Grid::ServiceRestart::Group::Order');

    %_allowed_members = (
                         groups => {mandatory => 1, array => 1, validator => {'Infoblox::Grid::ServiceRestart::Group' => 1}},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = ();

    %_ibap_to_object = (
                        groups => \&ibap_i2o_generic_object_list_convert,
    );

    %_object_to_ibap = (
                        groups => \&ibap_o2i_object_by_oid_or_name,
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

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my $t = Infoblox::Grid::ServiceRestart::Group->__new__();
        push @_return_fields,
            tField('groups', {sub_fields => $t->__return_fields__()});
    }
}


package Infoblox::Grid::ServiceRestart::Request::ChangedObject;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             $_object_type
             $_return_fields_initialized
             %_capabilities
             %_ibap_to_object
             %_name_mappings
             %_object_to_ibap
             %_return_field_overrides
             %_reverse_name_mappings
             %_searchable_fields
             @_return_fields
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'RestartRequestChangedObject';
    register_wsdl_type('ib:RestartRequestChangedObject', 'Infoblox::Grid::ServiceRestart::Request::ChangedObject');

    %_allowed_members = (
                         'action'             => {simple => 'asis', readonly => 1},
                         'changed_properties' => {readonly => 1},
                         'changed_time'       => {readonly => 1},
                         'object_name'        => {simple => 'asis', readonly => 1},
                         'object_type'        => {simple => 'asis', readonly => 1},
                         'user_name'          => {simple => 'asis', readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'source'  => [\&ibap_o2i_object_only_by_oid, 'source', 'EXACT'],
                           'service' => [\&ibap_o2i_string, 'service', 'EXACT'],
                           'user_name' => [\&ibap_o2i_string, 'user_name', 'REGEX'],
    );

    @_return_fields = (
                       tField('action'),
                       tField('changed_properties', {depth => 1000}),
                       tField('changed_time'),
                       tField('object_name'),
                       tField('object_type'),
                       tField('user_name'),
    );

    %_ibap_to_object = (
                        'changed_time'       => \&ibap_i2o_datetime_to_unix_timestamp,
                        'changed_properties' => \&ibap_i2o_audit_log_event,
    );

    %_object_to_ibap = (
                        'action'             => \&ibap_o2i_ignore,
                        'changed_properties' => \&ibap_o2i_ignore,
                        'changed_time'       => \&ibap_o2i_ignore,
                        'object_name'        => \&ibap_o2i_ignore,
                        'object_type'        => \&ibap_o2i_ignore,
                        'user_name'          => \&ibap_o2i_ignore,
    );

    %_return_field_overrides = (
                                'action'             => [],
                                'changed_properties' => [],
                                'changed_time'       => [],
                                'object_name'        => [],
                                'object_type'        => [],
                                'user_name'          => [],
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

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}


1;
