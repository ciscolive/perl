package Infoblox::IPAM::Statistics;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA $_object_type %_allowed_members %_return_field_overrides
            %_name_mappings %_reverse_name_mappings %_searchable_fields $_return_fields_initialized
            %_ibap_to_object %_object_to_ibap @_return_fields %_capabilities);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN
{
    #
	$_object_type = 'AllNetwork';

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 0,
					 );


    #
    #
    %_allowed_members = (
       'network'                    => 1,
	   'network_view'               => 0,
        'ms_ad_user_data'           => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

	%_return_field_overrides =
        (
         utilization        => [],
         conflict_count     => [],
         unmanaged_count    => [],
         utilization_update => [],
         ms_ad_user_data    => [],
         );



    #
    %_name_mappings = (
        network => 'address',
        netmask => 'cidr',
    );
    %_reverse_name_mappings = reverse %_name_mappings;

    #
    %_searchable_fields = (
        network      => [\&ibap_o2i_network_string, 'address', 'REGEX'],
        network_view => [\&ibap_o2i_network_view, 'network_view', 'EXACT'],
    );

    #
    %_ibap_to_object = (
        network_view    => \&ibap_i2o_generic_object_convert,
        ms_ad_user_data => \&ibap_i2o_generic_object_convert,
    );

    #
    %_object_to_ibap = (
        network            => \&ibap_o2i_network_string,
        network_view       => \&ibap_o2i_network_view,
        ms_ad_user_data    => \&ibap_o2i_ignore,
    );

    #
    @_return_fields =
    (
     tField('utilization'),
     tField('address'),
     tField('cidr'),

     #
     #
     tField('conflict_count', { not_exist_ok => 1 }),
     tField('unmanaged_count', { not_exist_ok => 1 }),
     tField('utilization_update', { not_exist_ok => 1 }),
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

sub __init_instance_constants__ {

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my $tmp = Infoblox::Grid::MSServer::AdUser::Data->__new__();
        push @_return_fields, tField('ms_ad_user_data', {sub_fields => $tmp->__return_fields__()});

    }
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

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;

    #
	$self->{ '__internal_session_cache_ref__' } = \$session;

    #
    #
    $self->{network_view} = 'is_default:=:=:boolean:=:=:1' unless $self->{network_view};

    return $self->SUPER::__object_to_ibap__($server, $session);
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    #
	$self->{ '__internal_session_cache_ref__' } = \$session;

    #
    my $address = $$ibap_object_ref{'address'} ? $$ibap_object_ref{'address'} : '';
    my $netmask = $$ibap_object_ref{'cidr'} ? $$ibap_object_ref{'cidr'} : '';

    $self->{network} = $address . '/' . $netmask;

    #
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref, {'address' => 1, 'cidr' => 1, });
}

#
#
#

sub utilization
{
    my $self=shift;
    my $value = $self->__accessor_scalar__({name => 'utilization', validator => \&ibap_value_o2i_int}, @_);
    #
    if (defined $value) {
        return ($value / 10);
    } else {
        return;
    }
}

sub conflict_count
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'conflict_count', validator => \&ibap_value_o2i_int}, @_);
}

sub unmanaged_count
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'unmanaged_count', validator => \&ibap_value_o2i_int}, @_);
}

sub utilization_update
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'utilization_update', validator => \&ibap_value_o2i_string}, @_);
}


1;
