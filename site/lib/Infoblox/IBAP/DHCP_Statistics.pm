package Infoblox::DHCP::Statistics;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA $_object_type %_allowed_members %_return_field_overrides
            %_name_mappings %_reverse_name_mappings %_searchable_fields
            %_ibap_to_object @_return_fields %_capabilities);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_ONLY );

BEGIN
{
    #
	$_object_type = 'SyntheticDynamic';

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 0,
					 );


    #
    #
    %_allowed_members = (
                         static_hosts            => -1,
                         dynamic_hosts           => -1,
                         usage                   => -1,
                         available_hosts         => -1,
                         dhcp_utilization_status => -1,
                        );

	%_return_field_overrides =
        (
         static_hosts            => [],
         dynamic_hosts           => [],
         usage                   => [],
         available_hosts         => [],
         dhcp_utilization_status => [],
        );

    #
    %_name_mappings = (
        usage           => 'dhcp_utilization',
        available_hosts => 'total_hosts',
    );
    %_reverse_name_mappings = reverse %_name_mappings;

    #
    %_searchable_fields = (
        object => [\&__o2i_object__, 'object_id', 'EXACT'],
    );

    #
    %_ibap_to_object = (
                        dhcp_utilization => \&__i2o_utilization__
    );

    #
    @_return_fields =
    (
     tField('static_hosts'),
     tField('dynamic_hosts'),
     tField('dhcp_utilization'),
     tField('total_hosts'),
     tField('dhcp_utilization_status'),
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
                                             undef,
                                             \@_return_fields,
                                             \%_return_field_overrides);


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

sub __get_override_hook__ {
    my ($object_type, $session, $args_ref) = @_;
	set_error_codes(0,undef,$session);

    my ($result, %args);
    my $server=$session->get_ibap_server() || return;

    return set_error_codes(1002, "'statistics_object' is a required get parameter", $session) unless $args_ref->{'statistics_object'};
    return set_error_codes(1002, "The object passed in 'statistics_object' must be one of Infoblox::DHCP::Network, Infoblox::DHCP::Range, Infoblox::DHCP::SharedNetwork or Infoblox::DHCP::MSSuperscope", $session) unless ref($args_ref->{'statistics_object'}) =~ m/DHCP::Network|DHCP::Range|DHCP::SharedNetwork|DHCP::MSSuperscope/;
    return set_error_codes(1002, "The object passed in 'statistics_object' must be an object retrieved from the server via get/search", $session) unless $args_ref->{'statistics_object'}->__object_id__();

    $args{'object_ids'} = [ tObjId($args_ref->{'statistics_object'}->__object_id__()) ];
    $args{'depth'} = 0;
    $args{'return_fields'} = \@_return_fields;

    eval { $result = $server->ObjectRead(\%args); };
    return $server->set_papi_error($@, $session) if $@;

    return set_error_codes(1003, undef, $session) if (scalar(@$result) == 0);

    my $object = $object_type->__new__();
    my $ibap_object_ref = @$result[0];
    my $return_object_cache_ref;

    $object->__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    return $object;
}

sub __i2o_utilization__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if ($$ibap_object_ref{$current}) {
        #
        return $$ibap_object_ref{$current} / 10.0;
    }
    else {
        return 0.0;
    }
}

#
#
#

sub static_hosts
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'static_hosts', readonly => 1}, @_);
}

sub dynamic_hosts
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dynamic_hosts', readonly => 1}, @_);
}

sub usage
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'usage', readonly => 1}, @_);
}

sub available_hosts
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'available_hosts', readonly => 1}, @_);
}

sub dhcp_utilization_status
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dhcp_utilization_status', readonly => 1}, @_);
}

1;
