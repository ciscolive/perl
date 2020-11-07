package Infoblox::Grid::NamedACL;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object
                 %_name_mappings %_reverse_name_mappings %_object_to_ibap
                 @_return_fields %_capabilities %_searchable_fields
                 %_return_field_overrides);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'DefinedACL';
    register_wsdl_type('ib:DefinedACL','Infoblox::Grid::NamedACL');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'name'                  => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         'comment'               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'access_list'           => {array => 1, validator => {'Infoblox::Grid::NamedACL' => 1, 'Infoblox::DNS::TSIGKey' => 1, 'string' => \&ibap_value_o2i_string}},
                         'exploded_access_list'  => {array => 1, readonly => 1, validator => {'Infoblox::Grid::NamedACL' => 1, 'Infoblox::DNS::TSIGKey' => 1, 'string' => \&ibap_value_o2i_string}},
                         'extattrs'              => {special => 'extensible_attributes'},
                         'extensible_attributes' => {special => 'extensible_attributes'},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
                                'name'                  => [],
                                'comment'               => [],
                                'access_list'           => [],
                                'exploded_access_list'  => [],
                                'extattrs'              => [],
                                'extensible_attributes' => [],
                               );

    %_name_mappings = (
                       'exploded_access_list' => 'exploded_ac_list',
                       'extattrs'             => 'extensible_attributes',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('name'),
                       tField('comment'),
                       tField('access_list', return_fields_address_tsig_ac()),
                       tField('exploded_ac_list', return_fields_address_tsig_ac()),
                       return_fields_extensible_attributes(),
                      );

    %_ibap_to_object = (
                        'access_list'           => \&ibap_i2o_mixed_ac_list,
                        'exploded_ac_list'      => \&ibap_i2o_mixed_ac_list,
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                       );

    %_object_to_ibap = (
                        'name'                  => \&ibap_o2i_string,
                        'comment'               => \&ibap_o2i_string,
                        'access_list'           => \&ibap_o2i_mixed_ac_list,
                        'exploded_access_list'  => \&ibap_o2i_ignore,
                        'extattrs'              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes' => \&ibap_o2i_ignore,
                       );

    %_searchable_fields = (
                           'name'     => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'comment'  => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           'extattrs' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
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

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

1;
