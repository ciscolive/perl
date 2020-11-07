package Infoblox::Grid::ApprovalWorkflow;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Time::Local;
use vars qw(@ISA $_object_type %_allowed_members %_return_field_overrides
            %_name_mappings %_reverse_name_mappings %_searchable_fields
            %_ibap_to_object %_object_to_ibap @_return_fields %_capabilities
            $_return_fields_initialized);
@ISA = qw ( Infoblox::IBAPBase );

BEGIN
{
    $_object_type = 'WorkflowApproval';
    register_wsdl_type('ib:WorkflowApproval', 'Infoblox::Grid::WorkflowApproval');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'approval_group'             => {mandatory => 1, validator => \&ibap_value_o2i_string},
                         'submitter_group'            => {mandatory => 1, oidreadonly => 1, validator => \&ibap_value_o2i_string},
                         'approval_notify_enabled'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'approval_notify_to'         => {simple => 'asis', enum => ['APPROVER', 'BOTH', 'SUBMITTER']},
                         'approved_notify_enabled'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'approved_notify_to'         => {simple => 'asis', enum => ['APPROVER', 'BOTH', 'SUBMITTER']},
                         'approver_comment_used'      => {simple => 'asis', enum => ['OPTIONAL', 'REQUIRED', 'UNUSED']}, 
                         'enable_notify_group'        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_notify_user'         => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'failed_notify_enabled'      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'failed_notify_to'           => {simple => 'asis', enum => ['APPROVER', 'BOTH', 'SUBMITTER']},
                         'rejected_notify_enabled'    => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'rejected_notify_to'         => {simple => 'asis', enum => ['APPROVER', 'BOTH', 'SUBMITTER']},
                         'rescheduled_notify_enabled' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'rescheduled_notify_to'      => {simple => 'asis', enum => ['APPROVER', 'BOTH', 'SUBMITTER']},
                         'submitter_comment_used'     => {simple => 'asis', enum => ['OPTIONAL', 'REQUIRED', 'UNUSED']},
                         'succeeded_notify_enabled'   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'succeeded_notify_to'        => {simple => 'asis', enum => ['APPROVER', 'BOTH', 'SUBMITTER']},
                         'ticket_number_used'         => {simple => 'asis', enum => ['OPTIONAL', 'REQUIRED', 'UNUSED']},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
                                'approval_group'             => [],
                                'submitter_group'            => [],
                                'approval_notify_enabled'    => [],
                                'approval_notify_to'         => [],
                                'approved_notify_enabled'    => [],
                                'approved_notify_to'         => [],
                                'approver_comment_used'      => [],
                                'enable_notify_group'        => [],
                                'enable_notify_user'         => [],
                                'failed_notify_enabled'      => [],
                                'failed_notify_to'           => [],
                                'rejected_notify_enabled'    => [],
                                'rejected_notify_to'         => [],
                                'rescheduled_notify_enabled' => [],
                                'rescheduled_notify_to'      => [],
                                'submitter_comment_used'     => [],
                                'succeeded_notify_enabled'   => [],
                                'succeeded_notify_to'        => [],
                                'ticket_number_used'         => [],
                               );

    %_name_mappings = ();

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           'approval_group'  => [\&__o2i_admin_group_name__, 'approval_group', 'EXACT'],
                           'submitter_group' => [\&__o2i_admin_group_name__, 'submitter_group', 'EXACT'],
                          );

    %_ibap_to_object = (
                        'approval_group'             => \&__i2o_admin_group_name__,
                        'submitter_group'            => \&__i2o_admin_group_name__,
                        'approval_notify_enabled'    => \&ibap_i2o_boolean,
                        'approved_notify_enabled'    => \&ibap_i2o_boolean,
                        'enable_notify_group'        => \&ibap_i2o_boolean,
                        'enable_notify_user'         => \&ibap_i2o_boolean,
                        'failed_notify_enabled'      => \&ibap_i2o_boolean,
                        'rejected_notify_enabled'    => \&ibap_i2o_boolean,
                        'rescheduled_notify_enabled' => \&ibap_i2o_boolean,
                        'succeeded_notify_enabled'   => \&ibap_i2o_boolean,
                       );

    %_object_to_ibap = (
                        'approval_group'             => \&__o2i_admin_group_name__,
                        'submitter_group'            => \&__o2i_admin_group_name__,
                        'approval_notify_enabled'    => \&ibap_o2i_boolean,
                        'approval_notify_to'         => \&ibap_o2i_string,
                        'approved_notify_enabled'    => \&ibap_o2i_boolean,
                        'approved_notify_to'         => \&ibap_o2i_string,
                        'approver_comment_used'      => \&ibap_o2i_string,
                        'enable_notify_group'        => \&ibap_o2i_boolean,
                        'enable_notify_user'         => \&ibap_o2i_boolean,
                        'failed_notify_enabled'      => \&ibap_o2i_boolean,
                        'failed_notify_to'           => \&ibap_o2i_string,
                        'rejected_notify_enabled'    => \&ibap_o2i_boolean,
                        'rejected_notify_to'         => \&ibap_o2i_string,
                        'rescheduled_notify_enabled' => \&ibap_o2i_boolean,
                        'rescheduled_notify_to'      => \&ibap_o2i_string,
                        'submitter_comment_used'     => \&ibap_o2i_string,
                        'succeeded_notify_enabled'   => \&ibap_o2i_boolean,
                        'succeeded_notify_to'        => \&ibap_o2i_string,
                        'ticket_number_used'         => \&ibap_o2i_string,
                       );

    @_return_fields = (
                       tField('approval_group', { sub_fields => [tField('name')] }),
                       tField('submitter_group', { sub_fields => [tField('name')] }),
                       tField('approval_notify_enabled'),
                       tField('approval_notify_to'),
                       tField('approved_notify_enabled'),
                       tField('approved_notify_to'),
                       tField('approver_comment_used'),
                       tField('enable_notify_group'),
                       tField('enable_notify_user'),
                       tField('failed_notify_enabled'),
                       tField('failed_notify_to'),
                       tField('rejected_notify_enabled'),
                       tField('rejected_notify_to'),
                       tField('rescheduled_notify_enabled'),
                       tField('rescheduled_notify_to'),
                       tField('submitter_comment_used'),
                       tField('succeeded_notify_enabled'),
                       tField('succeeded_notify_to'),
                       tField('ticket_number_used'),
                      );

    $_return_fields_initialized = 1;
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self, $class;

    return $self;
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

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    $$ibap_object_ref{'approval_notify_enabled'}    = 0 unless defined $$ibap_object_ref{'approval_notify_enabled'};
    $$ibap_object_ref{'approved_notify_enabled'}    = 0 unless defined $$ibap_object_ref{'approved_notify_enabled'};
    $$ibap_object_ref{'enable_notify_group'}        = 0 unless defined $$ibap_object_ref{'enable_notify_group'};
    $$ibap_object_ref{'enable_notify_user'}         = 0 unless defined $$ibap_object_ref{'enable_notify_user'};
    $$ibap_object_ref{'failed_notify_enabled'}      = 0 unless defined $$ibap_object_ref{'failed_notify_enabled'};
    $$ibap_object_ref{'rejected_notify_enabled'}    = 0 unless defined $$ibap_object_ref{'rejected_notify_enabled'};
    $$ibap_object_ref{'rescheduled_notify_enabled'} = 0 unless defined $$ibap_object_ref{'rescheduled_notify_enabled'};
    $$ibap_object_ref{'succeeded_notify_enabled'}   = 0 unless defined $$ibap_object_ref{'succeeded_notify_enabled'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __i2o_admin_group_name__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return $ibap_object_ref->{$current}->{'name'};
}

sub __o2i_admin_group_name__
{
    my ($self, $session, $current, $tempref) = @_;

    return (1,0, ibap_readfield_simple_string('AdminGroup', 'name', $$tempref{$current}));
}

1;
