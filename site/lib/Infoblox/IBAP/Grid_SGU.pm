package Infoblox::Grid::UpgradeGroup;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities $_return_fields_initialized @_upgrade_group_subfields);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'UpgradeGroup';
    register_wsdl_type('ib:UpgradeGroup','Infoblox::Grid::UpgradeGroup');
    register_wsdl_type('ib:upgrade_group','Infoblox::Grid::UpgradeGroup');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members =
      (
       comment                          => 0,
       distribution_dependent_group     => 0,
       distribution_policy              => 0,
       distribution_time                => 0,
       members                          => {validator => {'Infoblox::Grid::UpgradeGroup::Member' => 1}, array => 1, skip_accessor => 1},
       name                             => 1,
       time_zone                        => -1,
       upgrade_dependent_group          => 0,
       upgrade_policy                   => 0,
       upgrade_time                     => 0,
      );

    %_name_mappings =
      (
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           name    => [\&ibap_o2i_substruct_search ,'name', 'SUBMATCHSTRUCT_upgrade_group'],
                           comment => [\&ibap_o2i_substruct_search ,'comment', 'SUBMATCHSTRUCT_upgrade_group', 'IGNORE_CASE'],
                          );

    %_return_field_overrides =
      (
       comment                          => [],
       distribution_dependent_group     => [],
       distribution_policy              => [],
       distribution_time                => [],
       members                          => [],
       name                             => [],
       time_zone                        => [],
       upgrade_dependent_group          => [],
       upgrade_policy                   => [],
       upgrade_time                     => [],
      );

    %_ibap_to_object =
      (
       distribution_dependent_group     => \&ibap_i2o_upgrade_group_name,
       distribution_policy              => \&ibap_i2o_enums_lc_or_undef,
       members                          => \&ibap_i2o_generic_object_list_convert,
       upgrade_dependent_group          => \&ibap_i2o_upgrade_group_name,
       upgrade_policy                   => \&ibap_i2o_enums_lc_or_undef,
      );

    %_object_to_ibap =
      (
       comment                          => \&ibap_o2i_string,
       distribution_dependent_group     => \&ibap_o2i_upgrade_group_as_object,
       distribution_policy              => \&ibap_o2i_enums_lc_or_undef,
       distribution_time                => \&ibap_o2i_string_to_datetime,
       members                          => \&ibap_o2i_generic_struct_list_convert,
       name                             => \&ibap_o2i_string,
       time_zone                        => \&ibap_o2i_ignore,
       upgrade_dependent_group          => \&ibap_o2i_upgrade_group_as_object,
       upgrade_policy                   => \&ibap_o2i_enums_lc_or_undef,
       upgrade_time                     => \&ibap_o2i_string_to_datetime,
      );

    @_upgrade_group_subfields = (
                                 tField('name'),
                                 tField('comment'),
                                 tField('distribution_policy'),
                                 tField('upgrade_policy'),
                                 tField('time_zone'),
                                 tField('distribution_dependent_group',
                                        {
                                         sub_fields => [
                                                        tField('upgrade_group',
                                                               {
                                                                sub_fields => [
                                                                               tField('name'),
                                                                              ]
                                                               }
                                                              ),
                                                       ]
                                        }
                                       ),
                                 tField('upgrade_dependent_group',
                                        {
                                         sub_fields => [
                                                        tField('upgrade_group',
                                                               {
                                                                sub_fields => [
                                                                               tField('name'),
                                                                              ]
                                                               }
                                                              ),
                                                       ]
                                        }
                                       ),
                                 tField('distribution_time'),
                                 tField('upgrade_time'),
                                );

    $_return_fields_initialized = 0;
    @_return_fields =
      (
       tField('upgrade_group',
              {
               sub_fields => \@_upgrade_group_subfields,
               }
             ),
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

	unless ($_return_fields_initialized) {
		$_return_fields_initialized=1;

        #
        my $t = Infoblox::Grid::UpgradeGroup::Member->__new__();

        #
        #
        #
        my $i=0;
        foreach (@_return_fields) {
            if (defined $_->value()->{'field'} && $_->value()->{'field'} eq 'upgrade_group' ) {
                last;
            }
            $i++;
        }

        die "Internal error" if $i >= scalar(@_return_fields);

        push @{$_return_fields[$i]->value()->{'sub_fields'}},
          tField('members', {
                          sub_fields => $t->__return_fields__(),
                         }
                );
    }

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                             \%_reverse_name_mappings,
                                             \%_searchable_fields,
                                             \%_ibap_to_object,
                                             \%_object_to_ibap,
                                             \@_return_fields,
                                             \%_return_field_overrides
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

sub __return_fields_as_struct__
{
    my ($self,$what)=@_;
    return \@_upgrade_group_subfields;
}

#
#
#

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    $$ibap_object_ref{'read_only'} = 0 unless defined $$ibap_object_ref{'read_only'};
    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};

    if (defined $ibap_object_ref->{'upgrade_group'}) {
        #
        $self->SUPER::__ibap_to_object__($ibap_object_ref->{'upgrade_group'}, $server, $session, $return_object_cache_ref);
        $self->__object_id__($$ibap_object_ref{'object_id'}{'id'});
    }
    else {
        #
        $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    }

    return;
}

#
#
#
sub __object_to_ibap__
{
	my ($self, $server, $session) = @_;

    #
    if (defined $self->{'__serialize_as_struct__'}) {
        return $self->SUPER::__object_to_ibap__($server, $session);
    }
    else {
        #
        #
        my (%write_arg, %substruct);
        my $t = $self->SUPER::__object_to_ibap__($server, $session, {'distribution_time' => 1, 'upgrade_time' => 1});

        $write_arg{'field'} = 'upgrade_group';
        foreach (@$t) {
            $substruct{$_->{'field'}} = $_->{'value'};
        }
        $write_arg{'value'} = tIBType('upgrade_group', \%substruct);
        return [\%write_arg];
    }
}

#
#
#


sub name
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub distribution_policy
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'distribution_policy', enum => ['simultaneously', 'sequentially']}, @_);
}

sub upgrade_policy
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'upgrade_policy', enum => ['simultaneously', 'sequentially']}, @_);
}

sub time_zone
{
    my $self = shift;
    return $self->__accessor_scalar__({readonly => 1, name => 'time_zone', validator => \&ibap_value_o2i_tz}, @_);
}

sub distribution_dependent_group
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'distribution_dependent_group', validator => \&ibap_value_o2i_string}, @_);
}

sub upgrade_dependent_group
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'upgrade_dependent_group', validator => \&ibap_value_o2i_string}, @_);
}

sub distribution_time
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'distribution_time', validator => \&ibap_value_o2i_string}, @_);
}

sub upgrade_time
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'upgrade_time', validator => \&ibap_value_o2i_string}, @_);
}

sub members
{
    my $self = shift;
    return $self->__accessor_array__({name => 'members', validator => {'Infoblox::Grid::UpgradeGroup::Member' => 1}}, @_);
}

package Infoblox::Grid::UpgradeGroup::Member;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_capabilities);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'vnode_upgrade_info';
    register_wsdl_type('ib:vnode_upgrade_info','Infoblox::Grid::UpgradeGroup::Member');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members =
      (
       member        => 1,
       time_zone     => -1,
      );

    %_name_mappings =
      (
       member => 'vnode_ref',
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       vnode_ref => \&ibap_i2o_member_byhostname,
      );

    %_object_to_ibap =
      (
       member        => \&ibap_o2i_member_byhostname,
       time_zone     => \&ibap_o2i_ignore,
      );

    @_return_fields =
      (
       tField('vnode_ref', {
                            sub_fields => [
                                           tField('host_name'),
                                          ],
                           },
             ),
       tField('time_zone'),
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
                                             undef,
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


#
#
#

sub member
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'member', validator => \&ibap_value_o2i_string}, @_);
}

sub time_zone
{
    my $self = shift;
    return $self->__accessor_scalar__({readonly => 1, name => 'time_zone', validator => \&ibap_value_o2i_string}, @_);
}

package Infoblox::Grid::ScheduleBase;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE);

BEGIN {
	$_object_type = 'NotUsable'; # we are a base class

    #
    register_wsdl_type('ib:UpgradeSchedule','Infoblox::Grid::UpgradeSchedule');
    register_wsdl_type('ib:DistributionSchedule','Infoblox::Grid::DistributionSchedule');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members =
      (
       active         => 0,
       editable       => 0,
       start_time     => 0,
       time_zone      => 0,
       upgrade_groups => 0,
      );

    %_name_mappings =
      (
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                          );

    %_return_field_overrides =
      (
       active         => [],
       editable       => [],
       start_time     => [],
       time_zone      => [],
       upgrade_groups => [],
      );

    %_ibap_to_object =
      (
       active         => \&ibap_i2o_boolean,
       editable       => \&ibap_i2o_boolean,
       upgrade_groups => \&ibap_i2o_generic_object_list_convert,
      );

    %_object_to_ibap =
      (
       active         => \&ibap_o2i_boolean,
       editable       => \&ibap_o2i_ignore,
       start_time     => \&ibap_o2i_string_to_datetime,
       time_zone      => \&ibap_o2i_string_undef_to_empty,
       upgrade_groups => \&__o2i_groups__,
      );

    $_return_fields_initialized = 0;
    @_return_fields =
      (
       tField('active'),
       tField('editable'),
       tField('start_time'),
       tField('time_zone'),
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

	unless ($_return_fields_initialized) {
		$_return_fields_initialized=1;

        #
        my $t = Infoblox::Grid::UpgradeGroup->__new__();

        push @_return_fields,
          tField('upgrade_groups', {
                                    sub_fields => $t->__return_fields_as_struct__(),
                                   }
                );
    }

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                             \%_reverse_name_mappings,
                                             \%_searchable_fields,
                                             \%_ibap_to_object,
                                             \%_object_to_ibap,
                                             \@_return_fields,
                                             \%_return_field_overrides
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

#
#
sub __get_class_methods_class__
{
    return 'Infoblox::Grid::ScheduleBase';
}

#
#
#

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    $$ibap_object_ref{'active'} = 0 unless defined $$ibap_object_ref{'active'};
    $$ibap_object_ref{'editable'} = 0 unless defined $$ibap_object_ref{'editable'};

#
#

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
#
    return;
}

#
#
#

sub __o2i_groups__
{
    my ($self, $session, $current, $tempref) = @_;

    if ($$tempref{$current}) {
        my @templist;
        foreach (@{$$tempref{$current}}) {
            $_->{'__serialize_as_struct__'} = 1;
            push @templist, $_;
        }

        my $listref = ibap_serialize_substruct_list($session,\@templist,'upgrade_group');

        foreach (@{$$tempref{$current}}) {
            delete $_->{'__serialize_as_struct__'};
        }

        return (1,0, $listref) if $listref;
        return (0);
    }
    else {
        return (1,0,tIBType('ArrayOfupgrade_group',[]));
    }
}

#
#
#

sub active
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'active', validator => \&ibap_value_o2i_boolean}, @_);
}

sub editable
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'editable', readonly => 1, validator => \&ibap_value_o2i_boolean}, @_);
}

sub start_time
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'start_time', validator => \&ibap_value_o2i_string}, @_);
}

sub time_zone
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'time_zone', validator => \&ibap_value_o2i_tz}, @_);
}

sub upgrade_groups
{
    my $self = shift;
    return $self->__accessor_array__({name => 'upgrade_groups', validator => {'Infoblox::Grid::UpgradeGroup' => 1}}, @_);
}

package Infoblox::Grid::UpgradeSchedule;
use strict;
use Carp;
use Infoblox::Util;

use vars qw( @ISA );
@ISA = qw ( Infoblox::Grid::ScheduleBase );

sub __ibap_object_type__
{
    return 'UpgradeSchedule';
}

package Infoblox::Grid::DistributionSchedule;
use strict;
use Carp;
use Infoblox::Util;

use vars qw( @ISA );
@ISA = qw ( Infoblox::Grid::ScheduleBase );

sub __ibap_object_type__
{
    return 'DistributionSchedule';
}

1;
