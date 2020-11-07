package Infoblox::Grid::Admin::Role;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA
             $_object_type
             %_allowed_members
             @_return_fields
             %_searchable_fields
             %_object_to_ibap
             %_name_mappings
             %_reverse_name_mappings
             %_ibap_to_object
             %_return_field_overrides
             %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'Role';
    register_wsdl_type('ib:Role', 'Infoblox::Grid::Admin::Role');

    %_capabilities = (
                      'depth'                  => 1,
                      'implicit_defaults'      => 0,
                      'single_serialization' => 0,
                     );

    %_allowed_members = (
                         name     => 1,
                         comment => 0,
                         extattrs => 0,
                         extensible_attributes => 0,
                         disabled => 0,
                        );

    %_name_mappings = (
                        'extattrs' => 'extensible_attributes',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        extensible_attributes => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        disabled => \&ibap_i2o_boolean,
                       );

    %_return_field_overrides = (
                                'name'                    => [],
                                'disabled'                 => [],
                                'comment'               => [],
                                'extattrs'              => [],
                                'extensible_attributes' => [],
                               );

    %_object_to_ibap = (
                        name     => \&ibap_o2i_string,
                        comment  => \&ibap_o2i_string,
                        disabled  => \&ibap_o2i_boolean,
                        extattrs   => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes => \&ibap_o2i_ignore,
                       );

    %_searchable_fields = (
                           name    => [\&ibap_o2i_string, 'name', 'REGEX'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                          );

    @_return_fields = (
                       tField('name'),
                       tField('comment'),
                       tField('disabled'),
                       return_fields_extensible_attributes(),
                      );

};

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

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    return;
}

#
#
#

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;

    return $self->SUPER::__object_to_ibap__($server, $session);
}

#
#
#

sub name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub disabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

1;
