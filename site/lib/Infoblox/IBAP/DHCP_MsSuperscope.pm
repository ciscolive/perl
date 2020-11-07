package Infoblox::DHCP::MSSuperscope;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'MsSuperscope';
    register_wsdl_type('ib:MsSuperscope','Infoblox::DHCP::MSSuperscope');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members =
      (
       comment                 => 0,
       disable                 => 0,
       extensible_attributes   => 0,
       extattrs                => 0,
       name                    => 1,
       network_view            => 0,
       range_high_water_mark   => -1,
       range_high_water_mark_reset => -1,
       range_low_water_mark    => -1,
       range_low_water_mark_reset => -1,
       ranges                  => 1,
      );

    %_name_mappings =
      (
       disable                 => 'disabled',
       extattrs                => 'extensible_attributes',
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
						   comment               => [\&ibap_o2i_string,'comment', 'REGEX', 'IGNORE_CASE'],
						   name                  => [\&ibap_o2i_string,'name' , 'REGEX'],
                           extattrs              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           network_view          => [\&ibap_o2i_network_view ,'network_view', 'EXACT'],
                          );

	%_return_field_overrides =
      (
       comment                 => [],
       disable                 => [],
       extattrs                => [],
       extensible_attributes   => [],
       name                    => [],
       network_view            => [],
       range_high_water_mark   => [],
       range_high_water_mark_reset => [],
       range_low_water_mark    => [],
       range_low_water_mark_reset => [],
       ranges                  => [],
      );

    %_ibap_to_object =
      (
       disabled                => \&ibap_i2o_boolean,
       extensible_attributes   => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
       network_view            => \&ibap_i2o_generic_object_convert,
       ranges                  => \&ibap_i2o_generic_object_list_convert,
      );

    %_object_to_ibap =
      (
       comment                 => \&ibap_o2i_string,
       disable                 => \&ibap_o2i_boolean,
       extattrs                => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
       extensible_attributes   => \&ibap_o2i_ignore,
       name                    => \&ibap_o2i_string,,
       network_view            => \&ibap_o2i_network_view,
       range_high_water_mark   => \&ibap_o2i_ignore,
       range_high_water_mark_reset => \&ibap_o2i_ignore,
       range_low_water_mark    => \&ibap_o2i_ignore,
       range_low_water_mark_reset => \&ibap_o2i_ignore,
       ranges                  => \&__o2i_ranges__,
      );

    $_return_fields_initialized = 0;
    @_return_fields =
      (
       tField('comment'),
       tField('disabled'),
       tField('name'),
       tField('range_high_water_mark'),
       tField('range_high_water_mark_reset'),
       tField('range_low_water_mark'),
       tField('range_low_water_mark_reset'),
       return_fields_extensible_attributes(),
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

        my $t = Infoblox::DHCP::View->__new__();
        push @_return_fields,tField('network_view', {
                                                     default_no_access_ok => 1,
                                                     sub_fields => $t->__return_fields__(),
                                                    });

        $t = Infoblox::DHCP::Range->__new__();
        push @_return_fields,tField('ranges', {
                                               default_no_access_ok => 1,
                                               sub_fields => $t->__return_fields__(),
                                              });
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
#

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disabled'}     = 0 unless defined $$ibap_object_ref{'disabled'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

#
#
#

sub __o2i_ranges__
{
    my ($self, $session, $current, $tempref) = @_;
    my @newlist;

	if (defined $$tempref{$current} && ref($$tempref{$current}) eq 'ARRAY' && scalar(@{$$tempref{$current}})) {
        my @list=@{$$tempref{$current}};

        foreach my $member (@list) {
            if ($member->__object_id__()) {
                push @newlist, tObjIdRef($member->__object_id__());
            } else {
                #
                #
                my @fields = (
                              {
                               'field' => 'start_address',
                               'value' => ibap_value_o2i_string($member->start_addr()),
                              },
                              {
                               'field' => 'end_address',
                               'value' => ibap_value_o2i_string($member->end_addr()),
                              }
                             );

                my $t;
                if ($member->network_view()) {
                    $t=$member->network_view()->name();
                    push @fields, {
                                   'field' => 'network_view',
                                   'value' => ibap_readfield_simple_string('NetworkView','name',$t,'network_view'),
                                  };
                }
                else {
                    $t='default';
                    push @fields, {
                                   'field' => 'network_view',
                                   'value' => ibap_readfield_simple('NetworkView','is_default',tBool(1),'network_view=(default network view)'),
                                  };
                }

                #
                if ($member->member() && ref($member->member()) eq 'Infoblox::DHCP::MSServer') {
                    push @fields, {
                                   'field' => 'ms_server',
                                   'value' => ibap_o2i_msserver_helper($self,$member->member()),
                                  };
                }

                push @newlist, ibap_readfield_simple('DhcpRange',\@fields,undef,'range='. $member->start_addr().'-'.$member->end_addr().'-'.$t);
			}
        }
    }

    return (1,0,tIBType('ArrayOfBaseObject', \@newlist));
}

#
#
#

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub dhcp_utilization
{
    my $self=shift;
    return $self->__accessor_scalar__({deprecated => 1}, @_);
}

sub dhcp_utilization_status
{
    my $self=shift;
    return $self->__accessor_scalar__({deprecated => 1}, @_);
}

sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dynamic_hosts
{
    my $self=shift;
    return $self->__accessor_scalar__({deprecated => 1}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub network_view
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'network_view', validator => { 'Infoblox::DHCP::View' => 1 }}, @_);
}

sub range_high_water_mark
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_high_water_mark', validator => \&ibap_value_o2i_uint, readonly => 1}, @_);
}

sub range_high_water_mark_reset
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_high_water_mark_reset', validator => \&ibap_value_o2i_uint, readonly => 1}, @_);
}

sub range_low_water_mark
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_low_water_mark', validator => \&ibap_value_o2i_uint, readonly => 1}, @_);
}

sub range_low_water_mark_reset
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'range_low_water_mark_reset', validator => \&ibap_value_o2i_uint, readonly => 1}, @_);
}

sub ranges
{
    my $self = shift;
    return $self->__accessor_array__({name => 'ranges', validator => { 'Infoblox::DHCP::Range' => 1 }}, @_);
}

sub static_hosts
{
    my $self=shift;
    return $self->__accessor_scalar__({deprecated => 1}, @_);
}

1;
