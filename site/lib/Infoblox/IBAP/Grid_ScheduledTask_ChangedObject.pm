package Infoblox::Grid::ScheduledTask::ChangedObject;

#
#
#
#

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    register_wsdl_type('ib:changed_object', 'Infoblox::Grid::ScheduledTask::ChangedObject');

    #
    %_allowed_members = (
        action             => -1,
        changed_properties => -1,
        object_name        => -1,
        object_type        => -1,
    );

    %_name_mappings = (
        'object_type'      => 'object_type_display',
        'action'           => 'action_display',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
        changed_properties => \&ibap_i2o_audit_log_event,
    );

}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}


sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $ibap_object_ref->{'action_display'} =~ s/MGMSubGrid/Grid/i if defined $ibap_object_ref->{'action_display'}; # NIOS-38030: 'MGMSubGrid' is internal value. It should be presented as 'Grid'.

    my $skipref = {'object_type' => 1, 'action' => 1};
	return $self->SUPER::__ibap_to_object__( $ibap_object_ref, $server, $session, $return_object_cache_ref, $skipref);
}

#
#
#

sub action {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'action', readonly => 1}, @_);
}

sub changed_properties {
    my $self=shift;
    return $self->__accessor_array__({name => 'changed_properties', validator => { 'string' => \&ibap_value_o2i_string }, readonly => 1}, @_);
}

sub object_name {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'object_name', readonly => 1}, @_);
}

sub object_type {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'object_type', readonly => 1}, @_);
}

1;
