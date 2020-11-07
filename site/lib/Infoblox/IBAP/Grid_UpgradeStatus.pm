package Infoblox::Grid::UpgradeStatus;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields %_searchable_fields %_capabilities);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_ONLY );

BEGIN
{
    $_object_type = 'UpgradeStatus';
    register_wsdl_type('ib:UgradeStatus','Infoblox::Grid::UpgradeStatus');

    #
    #
    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                      'single_serialization' => 0,
                     );

    %_allowed_members = (
                         allow_distribution           => -1,
                         allow_upgrade                => -1,
                         allow_upgrade_cancel         => -1,
                         allow_upgrade_pause          => -1,
                         allow_upgrade_resume         => -1,
                         allow_upgrade_scheduling     => -1,
                         allow_upgrade_test           => -1,
                         allow_upload                 => -1,
                         current_version              => -1,
                         distribution_schedule_active => -1,
                         distribution_schedule_time   => -1,
                         distribution_state           => -1,
                         distribution_version         => -1,
                         grid_state                   => -1,
                         group_state                  => -1,
                         message                      => -1,
                         nodes                        => -1,
                         revert_version               => -1,
                         status_time                  => -1,
                         upgrade_schedule_active      => -1,
                         upgrade_schedule_time        => -1,
                         upgrade_state                => -1,
                         upgrade_test_status          => -1,
                         upload_version               => -1,
                        );

    %_name_mappings = (
                       nodes => 'status_children',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    $_reverse_name_mappings{'upgrade_status_summary'} = '__skip_handler__';

    %_ibap_to_object =
      (
       'status_children'        => \&__i2o_children__,
       'upgrade_status_summary' => \&__i2o_summary__,
      );

    %_object_to_ibap =
      (
       allow_distribution           => \&ibap_o2i_ignore,
       allow_upgrade                => \&ibap_o2i_ignore,
       allow_upgrade_cancel         => \&ibap_o2i_ignore,
       allow_upgrade_pause          => \&ibap_o2i_ignore,
       allow_upgrade_resume         => \&ibap_o2i_ignore,
       allow_upgrade_scheduling     => \&ibap_o2i_ignore,
       allow_upgrade_test           => \&ibap_o2i_ignore,
       allow_upload                 => \&ibap_o2i_ignore,
       current_version              => \&ibap_o2i_ignore,
       distribution_schedule_active => \&ibap_o2i_ignore,
       distribution_schedule_time   => \&ibap_o2i_ignore,
       distribution_state           => \&ibap_o2i_ignore,
       distribution_version         => \&ibap_o2i_ignore,
       grid_state                   => \&ibap_o2i_ignore,
       group_state                  => \&ibap_o2i_ignore,
       message                      => \&ibap_o2i_ignore,
       nodes                        => \&ibap_o2i_ignore,
       revert_version               => \&ibap_o2i_ignore,
       status_time                  => \&ibap_o2i_ignore,
       upgrade_schedule_active      => \&ibap_o2i_ignore,
       upgrade_schedule_time        => \&ibap_o2i_ignore,
       upgrade_state                => \&ibap_o2i_ignore,
       upgrade_test_status          => \&ibap_o2i_ignore,
       upload_version               => \&ibap_o2i_ignore,
      );

    %_searchable_fields =
      (
       type => [\&ibap_o2i_string,'type' , 'EXACT'], # this is not to be documented, used internally
       address => [\&ibap_o2i_string,'ip_address' , 'EXACT'],
       ipv6address => [\&ibap_o2i_string,'ipv6_address' , 'EXACT'],
      );

    @_return_fields =
      (
       tField('status_time'),
       tField('upgrade_status_summary', {
                                         sub_fields => [
                                                        tField('allow_distribution'),
                                                        tField('allow_upgrade'),
                                                        tField('allow_upgrade_cancel'),
                                                        tField('allow_upgrade_pause'),
                                                        tField('allow_upgrade_resume'),
                                                        tField('allow_upgrade_scheduling'),
                                                        tField('allow_upgrade_test'),
                                                        tField('allow_upload'),
                                                        tField('current_version'),
                                                        tField('distribution_schedule_active'),
                                                        tField('distribution_schedule_time'),
                                                        tField('distribution_state'),
                                                        tField('distribution_version'),
                                                        tField('grid_state'),
                                                        tField('group_state'),
                                                        tField('message'),
                                                        tField('revert_version'),
                                                        tField('upgrade_schedule_active'),
                                                        tField('upgrade_schedule_time'),
                                                        tField('upgrade_state'),
                                                        tField('upgrade_test_status'),
                                                        tField('upload_version'),
                                                       ],
                                        }),
       tField('status_children',
              {
               sub_fields => [
                              tField('ip_address'),
                              tField('ipv6_address'),
                              tField('ha_status'),
                              tField('pnode_role'),
                              tField('reverted'),
                              tField('time_to_revert'),
                              tField('type'),
                              tField('steps', { depth => 1 }),
                             ]}),
      );
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

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                             \%_reverse_name_mappings,
                                             \%_searchable_fields,
                                             \%_ibap_to_object,
                                             \%_object_to_ibap,
                                             \@_return_fields,
                                            );

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

sub __search_mapping_fields__
{
    my ($self, $session, $type, $argsref) = @_;

    if (defined $$argsref{'address'} || defined $$argsref{'ipv6address'}) {
        $$argsref{'type'} = 'VNODE';
    }
    else {
        $$argsref{'type'} = 'GRID';
    }

    return $self->SUPER::__search_mapping_fields__($session, $type, $argsref);
}

#
#
#

sub __skip_handler__{};

sub __i2o_children__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    my @list;
    foreach my $t (@{$ibap_object_ref->{$current}}) {
        next unless ref($t) eq 'ib:UpgradeStatus';
        next unless $t->{'type'} eq 'PNODE';

        my $x=Infoblox::Grid::UpgradeNode->__new__();

        $x->{'address'} = $t->{'ip_address'}  if defined $t->{'ip_address'};
        $x->{'ipv6address'} = $t->{'ipv6_address'}  if defined $t->{'ipv6_address'};
        $x->{'role'} = $t->{'pnode_role'}     if defined $t->{'pnode_role'};
        $x->{'ha_status'} = $t->{'ha_status'} if defined $t->{'ha_status'};
        $x->{'reverted'} = ibap_value_i2o_boolean($t->{'reverted'}) if defined $t->{'reverted'};
        $x->{'time_to_revert'} = $t->{'time_to_revert'} if defined $t->{'time_to_revert'};

        if ($t->{'steps'}) {
            my @steplist;

            foreach my $step (@{$t->{'steps'}}) {
                my $s=Infoblox::Grid::UpgradeStep->__new__();

                $s->{'address'} = $step->{'status_value'} if defined $step->{'status_value'};
                $s->{'address'} = $step->{'status_text'} if defined $step->{'status_text'};
            }

            $x->{'upgrade_steps'} = \@steplist;
        }

        push @list, $x;
    }

    return \@list;
}

sub __i2o_summary__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    $self->allow_distribution(ibap_value_i2o_boolean($ibap_object_ref->{$current}{'allow_distribution'}))                     if defined $ibap_object_ref->{$current}{'allow_distribution'};
    $self->allow_upgrade(ibap_value_i2o_boolean($ibap_object_ref->{$current}{'allow_upgrade'}))                               if defined $ibap_object_ref->{$current}{'allow_upgrade'};
    $self->allow_upgrade_cancel(ibap_value_i2o_boolean($ibap_object_ref->{$current}{'allow_upgrade_cancel'}))                 if defined $ibap_object_ref->{$current}{'allow_upgrade_cancel'};
    $self->allow_upgrade_pause(ibap_value_i2o_boolean($ibap_object_ref->{$current}{'allow_upgrade_pause'}))                   if defined $ibap_object_ref->{$current}{'allow_upgrade_pause'};
    $self->allow_upgrade_resume(ibap_value_i2o_boolean($ibap_object_ref->{$current}{'allow_upgrade_resume'}))                 if defined $ibap_object_ref->{$current}{'allow_upgrade_resume'};
    $self->allow_upgrade_scheduling(ibap_value_i2o_boolean($ibap_object_ref->{$current}{'allow_upgrade_scheduling'}))         if defined $ibap_object_ref->{$current}{'allow_upgrade_scheduling'};
    $self->allow_upgrade_test(ibap_value_i2o_boolean($ibap_object_ref->{$current}{'allow_upgrade_test'}))                     if defined $ibap_object_ref->{$current}{'allow_upgrade_test'};
    $self->allow_upload(ibap_value_i2o_boolean($ibap_object_ref->{$current}{'allow_upload'}))                                 if defined $ibap_object_ref->{$current}{'allow_upload'};
    $self->current_version($ibap_object_ref->{$current}{'current_version'})                                                   if defined $ibap_object_ref->{$current}{'current_version'};
    $self->distribution_schedule_active(ibap_value_i2o_boolean($ibap_object_ref->{$current}{'distribution_schedule_active'})) if defined $ibap_object_ref->{$current}{'distribution_schedule_active'};
    $self->distribution_schedule_time($ibap_object_ref->{$current}{'distribution_schedule_time'})                             if defined $ibap_object_ref->{$current}{'distribution_schedule_time'};
    $self->distribution_state($ibap_object_ref->{$current}{'distribution_state'})                                             if defined $ibap_object_ref->{$current}{'distribution_state'};
    $self->distribution_version($ibap_object_ref->{$current}{'distribution_version'})                                         if defined $ibap_object_ref->{$current}{'distribution_version'};
    $self->grid_state($ibap_object_ref->{$current}{'grid_state'})                                                             if defined $ibap_object_ref->{$current}{'grid_state'};
    $self->group_state($ibap_object_ref->{$current}{'group_state'})                                                           if defined $ibap_object_ref->{$current}{'group_state'};
    $self->message($ibap_object_ref->{$current}{'message'})                                                                   if defined $ibap_object_ref->{$current}{'message'};
    $self->revert_version($ibap_object_ref->{$current}{'revert_version'})                                                     if defined $ibap_object_ref->{$current}{'revert_version'};
    $self->upgrade_schedule_active($ibap_object_ref->{$current}{'upgrade_schedule_active'})                                   if defined $ibap_object_ref->{$current}{'upgrade_schedule_active'};
    $self->upgrade_schedule_time($ibap_object_ref->{$current}{'upgrade_schedule_time'})                                       if defined $ibap_object_ref->{$current}{'upgrade_schedule_time'};
    $self->upgrade_state($ibap_object_ref->{$current}{'upgrade_state'})                                                       if defined $ibap_object_ref->{$current}{'upgrade_state'};
    $self->upgrade_test_status($ibap_object_ref->{$current}{'upgrade_test_status'})                                           if defined $ibap_object_ref->{$current}{'upgrade_test_status'};
    $self->upload_version($ibap_object_ref->{$current}{'upload_version'})                                                     if defined $ibap_object_ref->{$current}{'upload_version'};
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'upgrade_status_summary'}{'allow_distribution'}           = 0 unless defined $$ibap_object_ref{'upgrade_status_summary'}{'allow_distribution'};
    $$ibap_object_ref{'upgrade_status_summary'}{'allow_upgrade'}                = 0 unless defined $$ibap_object_ref{'upgrade_status_summary'}{'allow_upgrade'};
    $$ibap_object_ref{'upgrade_status_summary'}{'allow_upgrade_cancel'}         = 0 unless defined $$ibap_object_ref{'upgrade_status_summary'}{'allow_upgrade_cancel'};
    $$ibap_object_ref{'upgrade_status_summary'}{'allow_upgrade_pause'}          = 0 unless defined $$ibap_object_ref{'upgrade_status_summary'}{'allow_upgrade_pause'};
    $$ibap_object_ref{'upgrade_status_summary'}{'allow_upgrade_resume'}         = 0 unless defined $$ibap_object_ref{'upgrade_status_summary'}{'allow_upgrade_resume'};
    $$ibap_object_ref{'upgrade_status_summary'}{'allow_upgrade_scheduling'}     = 0 unless defined $$ibap_object_ref{'upgrade_status_summary'}{'allow_upgrade_scheduling'};
    $$ibap_object_ref{'upgrade_status_summary'}{'allow_upgrade_test'}           = 0 unless defined $$ibap_object_ref{'upgrade_status_summary'}{'allow_upgrade_test'};
    $$ibap_object_ref{'upgrade_status_summary'}{'allow_upload'}                 = 0 unless defined $$ibap_object_ref{'upgrade_status_summary'}{'allow_upload'};
    $$ibap_object_ref{'upgrade_status_summary'}{'distribution_schedule_active'} = 0 unless defined $$ibap_object_ref{'upgrade_status_summary'}{'distribution_schedule_active'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
	return;
}

#
#
#

sub allow_distribution
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_distribution', readonly => 1}, @_);
}

sub allow_upgrade
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_upgrade', readonly => 1}, @_);
}

sub allow_upgrade_cancel
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_upgrade_cancel', readonly => 1}, @_);
}

sub allow_upgrade_pause
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_upgrade_pause', readonly => 1}, @_);
}

sub allow_upgrade_resume
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_upgrade_resume', readonly => 1}, @_);
}

sub allow_upgrade_scheduling
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_upgrade_scheduling', readonly => 1}, @_);
}

sub allow_upgrade_test
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_upgrade_test', readonly => 1}, @_);
}

sub allow_upload
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'allow_upload', readonly => 1}, @_);
}

sub current_version
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'current_version', readonly => 1}, @_);
}

sub distribution_schedule_active
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'distribution_schedule_active', readonly => 1}, @_);
}

sub distribution_schedule_time
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'distribution_schedule_time', readonly => 1}, @_);
}

sub distribution_state
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'distribution_state', readonly => 1}, @_);
}

sub distribution_version
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'distribution_version', readonly => 1}, @_);
}

sub grid_state
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'grid_state', readonly => 1}, @_);
}

sub group_state
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'group_state', readonly => 1}, @_);
}

sub message
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'message', readonly => 1}, @_);
}

sub nodes
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'nodes', readonly => 1}, @_);
}

sub revert_version
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'revert_version', readonly => 1}, @_);
}

sub status_time
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'status_time', readonly => 1}, @_);
}

sub upgrade_schedule_active
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'upgrade_schedule_active', readonly => 1}, @_);
}

sub upgrade_schedule_time
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'upgrade_schedule_time', readonly => 1}, @_);
}

sub upgrade_state
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'upgrade_state', readonly => 1}, @_);
}

sub upgrade_test_status
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'upgrade_test_status', readonly => 1}, @_);
}

sub upload_version
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'upload_version', readonly => 1}, @_);
}


package Infoblox::Grid::UpgradeNode;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    #
    %_allowed_members = (
                         address       => -1,
                         ha_status     => -1,
                         ipv6address   => -1,
                         role          => -1,
                         reverted      => -1,
                         time_to_revert=> -1,
                         upgrade_steps => -1,
                        );
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

#
#
#

sub address
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'address', readonly => 1}, @_);
}

sub ipv6address
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ipv6address', readonly => 1}, @_);
}

sub ha_status
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ha_status', readonly => 1}, @_);
}

sub role
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'role', readonly => 1}, @_);
}

sub reverted
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'reverted', readonly => 1}, @_);
}

sub time_to_revert
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'time_to_revert', readonly => 1}, @_);
}

sub upgrade_steps
{
    my $self=shift;
    return $self->__accessor_array__({name => 'upgrade_steps', readonly => 1}, @_);
}


package Infoblox::Grid::UpgradeStep;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    #
    %_allowed_members = (
                         status_value => -1,
                         status_text  => -1,
                        );
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

#
#
#

sub status_value
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'status_value', readonly => 1}, @_);
}

sub status_text
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'status_text', readonly => 1}, @_);
}



1;
