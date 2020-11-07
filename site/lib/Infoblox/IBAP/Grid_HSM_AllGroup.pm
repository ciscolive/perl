package Infoblox::Grid::HSM::AllGroup;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields %_capabilities %_searchable_fields %_return_field_overrides);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_ONLY );

BEGIN {
    $_object_type = 'AllHSMGroup';
    register_wsdl_type('ib:AllHSMGroup','Infoblox::Grid::HSM::AllGroup');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         groups             => {array => 1, readonly => 1, validator => {'Infoblox::Grid::HSM::Group' => 1, 'Infoblox::Grid::HSM::Thales::Group' => 1, 'Infoblox::Grid::HSM::SafeNet::Group' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides =
      (
        groups             => [],
      );
      
    @_return_fields =
      (
        tField('groups', { depth => 1 }),
       );

    %_ibap_to_object =
      (
       'groups'   => \&ibap_i2o_generic_object_list_convert,
      ); 

    %_object_to_ibap = (
                        'groups'               => \&ibap_o2i_ignore,
                       );

    %_searchable_fields = ();

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

    $self->{'groups'} = [] unless defined $self->groups();
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


1;
