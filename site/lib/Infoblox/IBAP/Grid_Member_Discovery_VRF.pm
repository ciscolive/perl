package Infoblox::Grid::Member::Discovery::VRF;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
  $_object_type
  %_allowed_members
  %_capabilities
  %_name_mappings
  %_object_to_ibap
  %_ibap_to_object
  %_return_field_overrides
  %_reverse_name_mappings
  %_searchable_fields
  @ISA
  @_return_fields );

@ISA = ('Infoblox::IBAPBase');

BEGIN {

  $_object_type = 'Vrf';
  register_wsdl_type('ib:Vrf', 'Infoblox::Grid::Member::Discovery::VRF');

  %_capabilities = ('depth' => 0, 'implicit_defaults' => 1, 'single_serialization' => 1);

  %_allowed_members = (
	'name'                => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
	'description'         => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
	'route_distinguisher' => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
	'network_view'        => {'readonly' => 1, 'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
	'device'              => {'readonly' => 1 },
	'network_view'        => {'readonly' => 1 },
  );

  Infoblox::IBAPBase::create_accessors(\%_allowed_members);

  %_searchable_fields = (
	name                => [\&ibap_o2i_string,       'name',                'REGEX'],
	description         => [\&ibap_o2i_string,       'description',         'REGEX'],
	route_distinguisher => [\&ibap_o2i_string,       'route_distinguisher', 'EXACT'],
	network_view        => [\&ibap_o2i_network_view, 'network_view',        'EXACT'],
  );

  %_ibap_to_object = (
    device       => \&ibap_i2o_generic_object_convert_partial,
	network_view => \&ibap_i2o_object_name
  );

  %_object_to_ibap = (
	'name'                => \&ibap_o2i_ignore,
	'description'         => \&ibap_o2i_ignore,
	'route_distinguisher' => \&ibap_o2i_ignore,
	'network_view'        => \&ibap_o2i_ignore,
	'device'              => \&ibap_o2i_ignore,
  );

  @_return_fields = (
	tField('name'), 
	tField('description'),
	tField('route_distinguisher'),
	tField('device', {sub_fields => [tField('name'), tField('address') ]}),
	tField('network_view', {sub_fields => [tField('name')]})
  );


  %_return_field_overrides	= (
  	'name'                => [],
  	'description'         => [],
  	'route_distinguisher' => [],
  	'device'              => [],
  	'network_view'        => []
  	);

}

sub __new__ {

  my ($proto, %args) = @_;
  my $class = ref($proto) || $proto;
  my $self = Infoblox::IBAPBase->__new__(%args);

  bless $self, $class;
  return $self;
}

sub new {

  my ($proto, %args) = @_;
  my $class = ref($proto) || $proto;
  my $self = Infoblox::IBAPBase->new(%args);

  bless $self, $class;

  if ( !$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args)
	|| !$self->__validate_object_required_members__(\%_allowed_members))
  {
	return;
  }

  return $self;
}

sub __ibap_object_type__ {

  return $_object_type;
}

sub __ibap_capabilities__ {

  my ($self, $what) = @_;
  return $_capabilities{$what};
}


42;