package Infoblox::Grid::SmartFolderChildren;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_name_mappings %_ibap_to_object %_searchable_fields @_return_fields %_return_field_overrides %_reverse_name_mappings %_capabilities $_object_type);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::SEARCH_ONLY );

BEGIN
{
    $_object_type='SmartFolderChildren';
    register_wsdl_type('ib:SmartFolderChildren','Infoblox::Grid::SmartFolderChildren');

    %_capabilities = (
                      'depth'                => 2,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'value'                 => 0,
                         'value_type'            => 0,
                         'extattrs'              => 0,
                         'extensible_attributes' => 0,
                         'comment'               => 0,
                         'is_matching_object'    => 0,
                        );

    %_reverse_name_mappings = (
                               'resource' => '_resource',
                              );

    %_ibap_to_object = (
                        'resource'   => \&ibap_i2o_generic_object_convert,
                        'value'      => \&__i2o_value__,
                        'value_type' => \&__i2o_value_type__,
                       );

    %_searchable_fields = (
                           smart_folder_name            => [\&__o2i_parent__,'parent' , 'EXACT'],
                           smart_folder_group_bys       => [\&ibap_o2i_generic_struct_list_convert,'group_bys' , 'EXACT'],
                           smart_folder_group_by_values => [\&ibap_o2i_generic_struct_list_convert,'group_by_values' , 'EXACT'],
                           query_items                  => [\&ibap_o2i_query_item_list,'query_items' , 'EXACT'],

                           #
                           smart_folder_type            => [\&ibap_o2i_ignore, 'deprecated', 'DEPRECATED'],
                          );

    @_return_fields = (
                       tField('resource', {depth => 4}),
                       tField('value'),
                       tField('value_type'),
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
sub __o2i_parent__
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{'smart_folder_type'} && $$tempref{'smart_folder_type'} =~ m/personal/i) {
        return (1, 0, ibap_readfield_simple_string('MyPersonalSmartFolder','name',$$tempref{$current},'smart_folder_name='.$$tempref{$current}.' (personal)'));
    }
    else {
        return (1, 0, ibap_readfield_simple_string('GlobalSmartFolder','name',$$tempref{$current},'smart_folder_name='.$$tempref{$current}.' (global)'));
    }
}

#
sub __i2o_value_type__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if (
        $$ibap_object_ref{$current} eq 'STRING' ||
        $$ibap_object_ref{$current} eq 'INTEGER' ||
        $$ibap_object_ref{$current} eq 'DATE' ||
        $$ibap_object_ref{$current} eq 'BOOLEAN'
       ) {
        return $$ibap_object_ref{$current};
    }
    else {
        return 'STRING';
    }
}

sub __i2o_value__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    return $$ibap_object_ref{$current}{value_type_field_name_for_type($$ibap_object_ref{'value_type'})};
}


#
#
#

sub value
{
    my $self=shift;

    #
    if ($self->_resource() && ref($self->_resource()) =~ /^Infoblox::/ && scalar(@_) == 0) {
        return $self->_resource(@_);
    }
    else {
        return $self->__accessor_scalar__({name => 'value', readonly => 1}, @_);
    }
}

sub value_type
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'value_type', readonly => 1}, @_);
}

sub _resource
{
    my $self=shift;
    return $self->__accessor_scalar__({name => '_resource', readonly => 1}, @_);
}

#
#
sub is_matching_object
{
    my $self=shift;

    if ($self->value() && ref($self->value()) =~ /^Infoblox::/) {
        return 1;
    }
    else {
        return 0;
    }
}

#
#
sub comment
{
    my $self=shift;

    if ($self->value() && ref($self->value()) =~ /^Infoblox::/ && $self->value()->can('comment')) {
        return $self->value()->comment();
    }
    else {
        return undef;
    }
}

sub extattrs
{
    my $self=shift;

    if ($self->value() && ref($self->value()) =~ /^Infoblox::/ && $self->value()->can('extattrs')) {
        return $self->value()->extattrs();
    }
    else {
        return undef;
    }
}

sub extensible_attributes
{
    my $self=shift;

    if ($self->value() && ref($self->value()) =~ /^Infoblox::/ && $self->value()->can('extensible_attributes')) {
        return $self->value()->extensible_attributes();
    }
    else {
        return undef;
    }
}


1;
