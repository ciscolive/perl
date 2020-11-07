package Infoblox::Grid::LOM::User;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields $_object_type);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    $_object_type = 'lom_user';
    register_wsdl_type('ib:lom_user','Infoblox::Grid::LOM::User');
    %_allowed_members = (
                         disable  => {simple => 'bool', mandatory => 1, validator => \&ibap_value_o2i_boolean},
                         name     => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         password => {mandatory => 1, writeonly => 1, validator => \&ibap_value_o2i_string},
                         role     => {simple => 'asis', mandatory => 1, enum => ['OPERATOR', 'USER']},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'disable' => 'disabled',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       disabled => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       disable  => \&ibap_o2i_boolean,
       name     => \&ibap_o2i_string,
       password => \&ibap_o2i_string_skip_undef,
       role     => \&ibap_o2i_string,
      );

    @_return_fields = (
                       tField('disabled'),
                       tField('name'),
                       tField('role'),
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
