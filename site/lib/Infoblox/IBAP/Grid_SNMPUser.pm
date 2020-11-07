
package Infoblox::Grid::SNMP::User;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides
            %_capabilities);

@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'SnmpUser';
    register_wsdl_type('ib:SnmpUser', 'Infoblox::Grid::SNMP::User');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         auth_password   => {writeonly => 1, validator => \&ibap_value_o2i_string},
                         auth_protocol   => {enum => [ 'md5', 'none', 'sha']},
                         comment         => {simple => 'asis',validator => \&ibap_value_o2i_string},
                         disable         => {simple => 'bool',validator => \&ibap_value_o2i_boolean},
                         name            => {simple => 'asis',validator => \&ibap_value_o2i_string},
                         privacy_password => {writeonly => 1, validator => \&ibap_value_o2i_string},
                         privacy_protocol => {enum => [ 'aes', 'des', 'none']},
                         extattrs              => {special => 'extensible_attributes'},
                         extensible_attributes => {special => 'extensible_attributes'},
                        );
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       auth_password   => 'authentication_password',
                       auth_protocol   => 'authentication_protocol',
                       disable         => 'disabled',
                       extattrs        => 'extensible_attributes',
                      );

    %_ibap_to_object = (
                          authentication_protocol => \&ibap_i2o_enums_lc_or_undef,
                          disabled         => \&ibap_i2o_boolean,
                          privacy_protocol => \&ibap_i2o_enums_lc_or_undef,
						  extensible_attributes =>  \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                       );

    %_searchable_fields = (
						   comment  => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],
						   name  => [\&ibap_o2i_string ,'name', 'REGEX'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
						   extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                 auth_password   => [],
                                 auth_protocol   => [],
                                 comment         => [],
                                 disable         => [],
                                 extattrs        => [],
                                 extensible_attributes => [],
                                 name            => [],
                                 privacy_password => [],
                                 privacy_protocol => [],
                               );

    %_object_to_ibap = (
                          auth_password   => \&ibap_o2i_string_skip_undef,
                          auth_protocol   => \&ibap_o2i_enums_lc_or_undef,
                          comment         => \&ibap_o2i_string,
                          disable         => \&ibap_o2i_boolean,
                          name            => \&ibap_o2i_string,
                          privacy_password => \&ibap_o2i_string_skip_undef,
                          privacy_protocol => \&ibap_o2i_enums_lc_or_undef,
                          extattrs         => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                          extensible_attributes => \&ibap_o2i_ignore,
                       );

    @_return_fields = (
                        tField('authentication_protocol'),
                        tField('comment'),
                        tField('disabled'),
                        tField('name'),
                        tField('privacy_protocol'),
                        return_fields_extensible_attributes(),
                      );
};
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

#
#
#
sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
      $$ibap_object_ref{"disabled"} = 0 unless defined $$ibap_object_ref{"disabled"};
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

}


1;

