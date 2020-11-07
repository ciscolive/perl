package Infoblox::Grid::SmartFolder::QueryItem;

#
#
#
#

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw( @ISA %_allowed_members @_return_fields);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    #
    #
    %_allowed_members = (
        name                      => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
        field_type                => {simple => 'asis', validator => \&ibap_value_o2i_string},
        is_extensible_attribute   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        operator                  => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
        op_match                  => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        value_type                => {enum =>['int', 'string', 'enum']},
        value                     => {simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                        tField('name'),
                        tField('field_type'),
                        tField('operator'),
                        tField('op_match'),
                        tField('value_type'),
                        tField('value',
                              { 
                                sub_fields => 
                                [ 
                                tField('value_integer'),
                                tField('value_string'),
                                tField('value_date'),
                                tField('value_boolean')
                                ],
                              } 
                            ),
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
    return '';
}

1;
