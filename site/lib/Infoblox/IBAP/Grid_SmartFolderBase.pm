package Infoblox::Grid::SmartFolderBase;

#
#

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Time::Local;
use vars qw(@ISA $_object_type %_allowed_members %_return_field_overrides
            %_name_mappings %_reverse_name_mappings %_searchable_fields
            %_ibap_to_object %_object_to_ibap @_return_fields %_capabilities $_return_fields_initialized);
@ISA = qw ( Infoblox::IBAPBase );

BEGIN
{
	$_object_type = 'NotUsable'; # we are a base class

    #
    register_wsdl_type('ib:MyPersonalSmartFolder', 'Infoblox::Grid::PersonalSmartFolder');
    register_wsdl_type('ib:GlobalSmartFolder', 'Infoblox::Grid::GlobalSmartFolder');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    #
    #
    %_allowed_members = (
        'name'                   => 1,
        'group_bys'              => {validator => {'Infoblox::Grid::SmartFolder::GroupBy' => 1}, array => 1, skip_accessor => 1},
        'query_items'            => 0,
        'comment'                => 0,
        'enable_no_values'       => 0,       # deprecated
    );

	%_return_field_overrides = (
        'name'                   => [],
        'group_bys'              => [],
        'query_items'            => [],
        'comment'                => [],
    );

    #
    %_name_mappings = ();

    %_reverse_name_mappings = ();

    #
    %_searchable_fields = (
        name    => [\&ibap_o2i_string, 'name', 'REGEX'],
        comment => [\&ibap_o2i_string, 'comment', 'REGEX'],
    );

    #
    %_ibap_to_object = (
        query_items => \&ibap_i2o_query_item_list,
        group_bys => \&ibap_i2o_generic_object_list_convert,
    );

    #
    %_object_to_ibap = (
        name => \&ibap_o2i_string,
        group_bys => \&ibap_o2i_generic_struct_list_convert,
        query_items => \&ibap_o2i_query_item_list,
        comment => \&ibap_o2i_string,
    );

    #
    $_return_fields_initialized=0;
    @_return_fields =
        (tField('name'),
         tField('comment'),
         tField('query_items',
                { sub_fields =>
                      [ tField('name'), tField('field_type'),
                        tField('operator'), tField('op_match'),
                        tField('value_type'),
                        tField('ext_attr_def_ref', { sub_fields => [
                                                                    tField('name'),
                                                                   ]}),
                        tField('value',
                               { sub_fields => [ tField('value_integer'),
                                                 tField('value_string'),
                                                 tField('value_date'),
                                                 tField('value_boolean')] } )
                        ]
              })
         );
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

    $self->__init_instance_constants__();

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self, $class;

    $self->__init_instance_constants__();

    return $self;
}

sub __init_instance_constants__
{
    my $self = shift;

	unless ($_return_fields_initialized) {
		$_return_fields_initialized=1;

        #
        my $t=Infoblox::Grid::SmartFolder::GroupBy->__new__();
        push @_return_fields,
          tField('group_bys', {
                                sub_fields => $t->__return_fields__(),
                               }
                );
    }
}

sub __ibap_object_type__
{
    #
    #
	return $_object_type;
}

#
#
sub __get_class_methods_class__
{
    return 'Infoblox::Grid::SmartFolderBase';
}

sub __ibap_capabilities__
{
	my ($self,$what)=@_;
	return $_capabilities{$what};
}

#
#
#

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session,
        $return_object_cache_ref) = @_;

    #
    $self->query_items(undef);

    #
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

#
#
#

sub name
{
    my $self=shift;

    #
    if (@_ > 0) {
        my $member_name=shift;

        #
        for ($member_name) {
            s/^\s+//; # leading spaces
            s/\s+$//; # trailing spaces
        }
        #
        #
        unshift @_, $member_name;
    }

    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub enable_no_values
{
    my $self=shift;
    return $self->__accessor_scalar__({deprecated => 1}, @_);
}

sub group_bys
{
    my $self=shift;

    return $self->__accessor_array__({name => 'group_bys', validator => { 'Infoblox::Grid::SmartFolder::GroupBy' => 1 }}, @_);
}

sub query_items
{
    my $self = shift;

    return $self->__accessor_array__({name => 'query_items', validator => { 'Infoblox::Grid::SmartFolder::QueryItem' => 1 }}, @_);
}


package Infoblox::Grid::SmartFolder::GroupBy;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_name_mappings %_object_to_ibap %_reverse_name_mappings %_ibap_to_object @_return_fields $_object_type);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    $_object_type = 'smart_folder_group_by_item';
    register_wsdl_type('ib:smart_folder_group_by_item','Infoblox::Grid::SmartFolder::GroupBy');
    %_allowed_members = (
                         enable_grouping => 0,
                         value           => 0,
                         value_type      => 0,
                        );

    %_name_mappings = (
                       enable_grouping => 'enable_group_by',
                       value           => 'group_by',
                       value_type      => 'group_by_field_type',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       'enable_group_by' => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       enable_grouping => \&ibap_o2i_boolean,
       value_type      => \&ibap_o2i_string,
       value           => \&ibap_o2i_string,
      );

    @_return_fields=(
                     tField('enable_group_by'),
                     tField('group_by'),
                     tField('group_by_field_type'),
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

    #
    $self->value_type('EXTATTR') unless defined $self->value_type();

}

sub __ibap_object_type__ {

    return $_object_type;
}

#
#
#

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session,
        $return_object_cache_ref) = @_;

    #
    $ibap_object_ref->{'enable_group_by'} = 0 unless defined($ibap_object_ref->{'enable_group_by'});

    #
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

#
#
#

sub enable_grouping
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_grouping', validator => \&ibap_value_o2i_boolean}, @_);
}

sub value_type
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'value_type', enum => ['EXTATTR', 'NORMAL'] }, @_);
}

sub value
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'value', validator => \&ibap_value_o2i_string}, @_);
}

package Infoblox::Grid::SmartFolder::GroupByValue;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_name_mappings %_object_to_ibap $_object_type);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    $_object_type = 'smart_folder_group_by_value_item';
    register_wsdl_type('ib:smart_folder_group_by_value_item','Infoblox::Grid::SmartFolder::GroupByValue');
    %_allowed_members = (
                         value => 0,
                         name  => 0,
                        );

    %_name_mappings = (
                      );

    %_object_to_ibap =
      (
       name      => \&ibap_o2i_string,
       value     => \&ibap_o2i_string,
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

sub __ibap_object_type__ {

    return $_object_type;
}

#
#
#

sub value
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'value', validator => \&ibap_value_o2i_string}, @_);
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

1;
