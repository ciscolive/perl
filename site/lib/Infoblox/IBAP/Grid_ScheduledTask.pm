package Infoblox::Grid::ScheduledTask;

#
#
#
use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( @ISA $_object_type %_allowed_members %_searchable_fields
             %_ibap_to_object %_object_to_ibap %_name_mappings
             %_reverse_name_mappings @_return_fields %_return_field_overrides
             %_capabilities @_base_return_fields);

@ISA = qw ( Infoblox::IBAPBase );

BEGIN
{
	$_object_type = 'ScheduledTask';
    register_wsdl_type('ib:ScheduledTask', 'Infoblox::Grid::ScheduledTask');

    #
    #
    %_capabilities = (
					  'depth' 				 => 2,
					  'implicit_defaults' 	 => 0,
					  'single_serialization' => 1,
					 );

    #
    %_allowed_members = (
        changed_objects    => -1,
        scheduled_time     => 0,
        scheduled_time_end => 0,
        submit_time        => -1,
        submit_time_end    => 0,
        submitter          => -1,
        task_id            => 1,
        approval_status    => {simple => 'asis', enum => ['NONE', 'APPROVED', 'PENDING', 'REJECTED']},
        approver           => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        approver_comment   => {simple => 'asis', validator => \&ibap_value_o2i_string},
        execution_status   => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        execution_time     => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
        submitter_comment  => {simple => 'asis', validator => \&ibap_value_o2i_string},
        ticket_number      => {simple => 'asis', validator => \&ibap_value_o2i_string},
        predecessor_task   => {readonly => 1},
        task_type          => {simple => 'asis', readonly => 1},
        re_execute_task    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        is_network_insight_task => {simple => 'bool', readonly => 1},
        time_zone          => {simple => 'asis',validator => \&ibap_value_o2i_tz},
        dependent_tasks    => {readonly => 1, 'array' => 1},
        execution_details_type => {simple => 'asis', enum => ['NONE', 'WARNING'], readonly => 1},
        execution_details      => {simple => 'asis', array => 1, validator => \&ibap_value_o2i_string, readonly => 1},
        member                 => {readonly => 1, validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = ();

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
        scheduled_time       => [\&ibap_o2i_string_to_datetime, 'scheduled_time',       'GLEQ'],
        scheduled_time_start => [\&ibap_o2i_string_to_datetime, 'scheduled_time_start', 'GEQ_scheduled_time'],
        scheduled_time_end   => [\&ibap_o2i_string_to_datetime, 'scheduled_time_end',   'LEQ_scheduled_time'],
        submit_time          => [\&ibap_o2i_string_to_datetime, 'submit_time',          'GLEQ'],
        submit_time_start    => [\&ibap_o2i_string_to_datetime, 'submit_time_start',    'GEQ_submit_time'],
        submit_time_end      => [\&ibap_o2i_string_to_datetime, 'submit_time_end',      'LEQ_submit_time'],
        submitter            => [\&ibap_o2i_string,             'submitter',            'REGEX'],
        task_id              => [\&ibap_o2i_integer,            'task_id',              'EXACT'],
        #
        action               => [\&__o2i_submatch__,       'action_display',       'SUBMATCH_changed_objects'],
        object_name          => [\&__o2i_submatch__,       'object_name',          'SUBMATCH_changed_objects'],
        object_type          => [\&__o2i_submatch__,       'object_type_display',  'SUBMATCH_changed_objects'],
        #
        task_type            => [\&__o2i_task_type__, 'task_type', 'EXACT'],
        member               => [\&ibap_o2i_member_name, 'member', 'EXACT'],
    );

    %_ibap_to_object = (
        changed_objects  => \&__i2o_changed_objects,
        predecessor_task => \&ibap_i2o_generic_object_convert_partial,
        dependent_tasks  => \&ibap_i2o_generic_object_list_convert_partial,
        member           => \&ibap_i2o_member_name,
    );

    %_object_to_ibap = (
        changed_objects    => \&ibap_o2i_ignore,
        execute_now        => \&ibap_o2i_boolean,
        scheduled_time     => \&ibap_o2i_string_to_datetime,
        scheduled_time_end => \&ibap_o2i_ignore,
        submit_time        => \&ibap_o2i_string_to_datetime,
        submit_time_end    => \&ibap_o2i_ignore,
        submitter          => \&ibap_o2i_string,
        task_id            => \&ibap_o2i_integer,
        approval_status    => \&ibap_o2i_string,
        approver           => \&ibap_o2i_ignore,
        approver_comment   => \&ibap_o2i_string,
        execution_status   => \&ibap_o2i_ignore,
        execution_time     => \&ibap_o2i_ignore,
        submitter_comment  => \&ibap_o2i_string,
        ticket_number      => \&ibap_o2i_string,
        predecessor_task   => \&ibap_o2i_ignore,
        task_type          => \&ibap_o2i_ignore,
        re_execute_task    => \&ibap_o2i_boolean,
        is_network_insight_task => \&ibap_o2i_ignore,
        time_zone          => \&ibap_o2i_string_undef_to_empty,
        dependent_tasks    => \&ibap_o2i_ignore,
        execution_details_type => \&ibap_o2i_ignore,
        execution_details      => \&ibap_o2i_ignore,
        member => \&ibap_o2i_ignore,
    );

    @_base_return_fields = (
                       tField('scheduled_time'),
                       tField('submit_time'),
                       tField('submitter'),
                       tField('task_id'),
                       tField('approval_status'),
                       tField('approver'),
                       tField('approver_comment'),
                       tField('execution_status'),
                       tField('execution_time'),
                       tField('submitter_comment'),
                       tField('ticket_number'),
                       tField('task_type'),
                       tField('is_network_insight_task'),
                       tField('time_zone'),
                       tField('member', {sub_fields => [tField('host_name')]}),
                       );

    @_return_fields = (
                       @_base_return_fields,
                       tField('predecessor_task', {'sub_fields' => [@_base_return_fields]}),
                       tField('dependent_tasks', {'sub_fields' => [@_base_return_fields]}),
                       #
                       tField('changed_objects', { depth => 100 }),
                       tField('execution_details_type'),
                       tField('execution_details'),
                       );

    %_return_field_overrides = (changed_objects   => [],
                                scheduled_time    => [],
                                submit_time       => [],
                                submitter         => [],
                                task_id           => [],
                                approval_status   => [],
                                approver          => [],
                                approver_comment  => [],
                                execution_status  => [],
                                execution_time    => [],
                                submitter_comment => [],
                                ticket_number     => [],
                                predecessor_task  => [],
                                task_type         => [],
                                is_network_insight_task => [],
                                time_zone         => [],
                                dependent_tasks   => [],
                                execution_details_type => [],
                                execution_details      => [],
                                member => [],
                                );
}

sub __i2o_changed_objects
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $list = ibap_i2o_generic_object_list_convert($self,$session,$current,$ibap_object_ref,$return_object_cache_ref);
    my %dups;
    my @rvlist=grep {
        #
        #
        #
        #
        my $type = $_->object_type() ? $_->object_type() : '';
        my $name = $_->object_name() ? $_->object_name() : '';
        my $key = $type . $name;
        if ($key && exists($dups{$key})) {
            0;
        } else {
            $dups{$key} = 1 if $key;
            1;
        }
    } @$list;
    return \@rvlist;
}

sub __o2i_submatch__
{
    my ($self, $session, $key, $tempref, $type) = @_;
    my $value = $tempref->{$key};

    if ($key eq 'object_type') {
        $key = 'object_type_display';
    }

    if ($key eq 'action') {
        $key = 'action_display';
    }

    my $sf = {field => $key,
              value => ibap_value_o2i_string_undef_to_empty($value),
              search_type => ($type eq 'search' ? 'REGEX' : 'EXACT')};

    return (1, 0, tIBType('SubMatch', {search_fields => [$sf]}));
}

my %task_types = (
    'OBJECT_CHANGE' => 1,
    'PORT_CONTROL' => 1,
);

sub __o2i_task_type__
{
    my ($self, $session, $key, $tempref, $type) = @_;

    if ($task_types{$tempref->{$key}}) {
        return ibap_o2i_string(@_);
    } else {
        set_error_codes(1104, "'$tempref->{$key}' task type is not supported", $session);
        return (0);
    }
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
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

sub __add_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'add' not allowed for this object", $session);
    return;
}

#
#
#

sub changed_objects {
    my $self=shift;
    return $self->__accessor_array__({name => 'changed_objects', validator => { 'Infoblox::Grid::ScheduledTask::ChangedObject' => 1 }, readonly => 1}, @_);
}

sub scheduled_time {
    my $self = shift;

    if (@_ == 0) {
        return $self->{'scheduled_time'};
    }

    my $value = shift;

    if (defined $value) {
        #
        if ($value =~ m/^now$/i) {
            $self->{'execute_now'} = "true";

            return 1;
        }
        #
        eval {schedule_request($value, undef, ' for field scheduled_time')};
        return $@->set_papi_error() if $@;
    }

    $self->{'scheduled_time'} = $value;

	return 1;
}

sub submit_time {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'submit_time', readonly => 1}, @_);
}

sub submitter {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'submitter', readonly => 1}, @_);
}

sub task_id {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'task_id', readonly => 1}, @_);
}

1;
