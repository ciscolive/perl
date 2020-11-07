package Infoblox::Grid::Member::PreProvisioning::Hardware;
  
use strict;
  
use Carp;
  
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap @_return_fields);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'pre_provision_hardware';
    register_wsdl_type('ib:pre_provision_hardware', 'Infoblox::Grid::Member::PreProvisioning::Hardware');

    %_allowed_members = (
                         'hwmodel' => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                         'hwtype'  => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'hwmodel' => \&ibap_o2i_string,
                        'hwtype'  => \&ibap_o2i_string,
                       );

    @_return_fields = (
                       tField('hwmodel'),
                       tField('hwtype'),
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

package Infoblox::Grid::Member::PreProvisioning;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_object_to_ibap %_ibap_to_object @_return_fields);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'pre_provision';
    register_wsdl_type('ib:pre_provision', 'Infoblox::Grid::Member::PreProvisioning');

    %_allowed_members = (
                         'hardware_info' => {'array' => 1, 'validator' => {'Infoblox::Grid::Member::PreProvisioning::Hardware' => 1}},
                         'licenses'      => {'array' => 1, 'validator' => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'hardware_info' => \&ibap_o2i_generic_struct_list_convert,
                        'licenses'      => \&ibap_o2i_string_array_undef_to_empty,
                       );

    %_ibap_to_object = (
                        'hardware_info' => \&ibap_i2o_generic_object_list_convert,
                       );

    @_return_fields = (
                       tField('hardware_info', {'depth' => 1}),
                       tField('licenses'),
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


1;
