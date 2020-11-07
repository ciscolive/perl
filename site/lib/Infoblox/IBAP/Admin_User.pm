## Copyright (c) 2017 Infoblox Inc. All Rights Reserved.

package Infoblox::Grid::Admin::User;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_capabilities %_name_mappings %_reverse_name_mappings %_return_field_overrides %_ibap_to_object %_object_to_ibap);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'AdminMember';
    register_wsdl_type('ib:AdminMember', 'Infoblox::Grid::Admin::User');

    %_capabilities = (
                      'depth'                  => 0,
                      'implicit_defaults'      => 0,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         admin_group => 0,
                         comment      => 0,
                         disabled    => 0,
                         email          => 0,
                         extattrs    => 0,
                         extensible_attributes => 0,
                         name          => 1,
                         password    => 0,
                         time_zone   => 0,
                         tree_size   => 0, # ignored, it's deprecated
                         roles       => -1,
                         auth_type   => {simple => 'asis', enum => ['LOCAL', 'RADIUS', 'REMOTE']},
                         enable_certificate_authentication => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         ca_certificate_issuer => {validator => \&ibap_value_o2i_string},
                         client_certificate_serial_number => {simple => 'asis', validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        disabled => \&ibap_i2o_boolean,
                        groups     => \&__i2o_group__,
                        extensible_attributes => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        ca_certificate_issuer => \&__i2o_issuer__,
                       );

    %_object_to_ibap = (
                        disabled       => \&ibap_o2i_boolean,
                        comment       => \&ibap_o2i_string,
                        admin_group      => \&__o2i_group__,
                        email         => \&ibap_o2i_string,
                        name          => \&ibap_o2i_string,
                        password      => \&ibap_o2i_string_skip_undef,
                        roles         => \&ibap_o2i_ignore,
                        tree_size      => \&ibap_o2i_ignore,
                        time_zone        => \&ibap_o2i_string,
                        use_time_zone => \&ibap_o2i_boolean,
                        extattrs      => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes => \&ibap_o2i_ignore,
                        auth_type             => \&ibap_o2i_string,
                        enable_certificate_authentication => \&ibap_o2i_boolean,
                        ca_certificate_issuer => \&__o2i_issuer__,
                        client_certificate_serial_number => \&ibap_o2i_string,
                       );

    @_return_fields = (
                       tField('comment'),
                       tField('disabled'),
                       tField('email'),
                       tField('name'),
                       tField('time_zone'),
                       tField('use_time_zone'),
                       tField('auth_type'),
                       tField('groups',
                              {
                               sub_fields => [
                                              tField('name'),
                                              tField('roles', { sub_fields => [tField('name')] }),
                                             ]
                              }),
                       tField('enable_certificate_authentication'),
                       tField('ca_certificate_issuer', {sub_fields => [tField('issuer')]}),
                       tField('client_certificate_serial_number'),
                       return_fields_extensible_attributes(),
                      );

    %_return_field_overrides = (
                                admin_group => [],
                                comment     => [],
                                disabled    => [],
                                email         => [],
                                name         => [],
                                password    => [],
                                time_zone   => ['use_time_zone'],
                                roles       => ['groups'],
                                extattrs    => [],
                                extensible_attributes => [],
                                auth_type   => [],
                                enable_certificate_authentication => [],
                                ca_certificate_issuer => [],
                                client_certificate_serial_number => [],
                               );

    %_name_mappings = (
                       'admin_group' => 'groups',
                       'extattrs'    => 'extensible_attributes',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           name        => [\&ibap_o2i_string ,'name'        ,'REGEX'],
                           admin_group => [\&__o2i_group_search__ ,'groups'      ,'LIST_IN'],
                           role        => [\&__o2i_role_search__ ,'groups'      ,'LIST_INTERSECT'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           ca_certificate_issuer => [\&__o2i_issuer__, 'ca_certificate_issuer', 'EXACT'],
                           client_certificate_serial_number => [\&ibap_o2i_string, 'client_certificate_serial_number', 'REGEX'],
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
    #
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
sub __i2o_group__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if ($$ibap_object_ref{$current}) {
        #
        #
        #
        #
        my $wantedgroup = @{$$ibap_object_ref{$current}}[0];

        my @roles;
        if ($wantedgroup->{'roles'} && @{$wantedgroup->{'roles'}}) {
            foreach (@{$wantedgroup->{'roles'}}) {
                push @roles, $_->{'name'};
            }
        }
        $self->roles(\@roles);
        return $wantedgroup->{'name'};
    }
    else {
        $self->roles([]);
        return;
    }
}

sub __i2o_issuer__ {

    my ($self, $session, $current, $ibap_object_ref) = @_;
    return $$ibap_object_ref{$current}{issuer};
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    if (defined $$ibap_object_ref{'use_time_zone'}) {
        $self->{'use_time_zone'}=$$ibap_object_ref{'use_time_zone'};
        if (!$$ibap_object_ref{'use_time_zone'}) {
            $self->time_zone(undef);
        }
    }

    return;
}

#
#
#

sub __o2i_issuer__ {

    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        return (1, 0, ibap_readfield_simple_string('CACertificate', 'issuer', $$tempref{$current}, $current));
    } else {
        return (1, 0, undef);
    }
}

sub __o2i_group__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    push @return_args, 1;
    push @return_args, 0;
    push @return_args, tIBType('ArrayOfBaseObject', [ ibap_readfield_simple_string('AdminGroup', 'name', $$tempref{$current}, $current) ] );

    return @return_args;
}

sub __o2i_group_search__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    #
    return (1,1,0) if exists $$tempref{'role'};

    push @return_args, 1;
    push @return_args, 0;
    if (not defined $$tempref{$current}) {
        push @return_args, $$tempref{$current};
    } else {
        push @return_args, ibap_readfield_simple_string('AdminGroup','name',$$tempref{$current}, $current);
    }
    return @return_args;
}

sub __o2i_role_search__
{
    my ($self, $session, $current, $tempref, $type, $outname) = @_;

    my @sfields;
    if (exists $$tempref{'admin_group'}) {
        my $which = 'EXACT';
        $which = 'REGEX' if $type eq 'search';

        my $argref =
          {
           'search_type' => $which,
           'field'       => 'name',
          };

        #
        if (defined $$tempref{'admin_group'}) {
            $argref->{'value'} = ibap_value_o2i_string($$tempref{'admin_group'});
            return (0) unless $argref->{'value'};
        }
        else {
            $argref->{'value'} = undef;
        }

        push @sfields, $argref;
    }

    if (not defined $$tempref{$current}) {
        push @sfields,
          {
           'list_op'     => 'EQUAL',
           'field'       => 'roles',
           'value'       => tIBType('ib:ArrayOfBaseObject',[]),
          };
    } else {
        push @sfields,
          {
           'list_op'     => 'IN',
           'field'       => 'roles',
           'value'       => ibap_readfield_simple_string('Role','name',$$tempref{$current}, 'role=' . $$tempref{$current}),
          };
    }

    return (1,0,ibap_readfieldlist_simple('AdminGroup', \@sfields, undef, 'EXACT'));
}

#
#
#

sub admin_group
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'admin_group', validator => \&ibap_value_o2i_string}, @_);
}

sub disabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub password
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'password', writeonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub roles
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'roles', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub time_zone
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'time_zone', validator => \&ibap_value_o2i_string, use => \$self->{'use_time_zone'}}, @_);
}

sub email
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'email', validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

#
sub tree_size
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return 100;
    }
    else
    {
        return 1;
    }
}

package Infoblox::Grid::Admin::User::Profile;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields %_capabilities %_searchable_fields %_return_field_overrides $_return_fields_initialized);

@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_MODIFY_ONLY);

BEGIN {
    $_object_type = 'UserProfile';
    register_wsdl_type('ib:UserProfile','Infoblox::Grid::Admin::User::Profile');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         email               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         old_password        => {writeonly => 1, validator => \&ibap_value_o2i_string},
                         password            => {writeonly => 1, validator => \&ibap_value_o2i_string},
                         table_size          => {simple => 'asis', validator => \&ibap_value_o2i_int},
                         time_zone           => {simple => 'asis', validator => \&ibap_value_o2i_string},

                         admin_group         => {readonly => 1, validator => {'Infoblox::Grid::Admin::Group' => 1}},
                         days_to_expire      => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_int},
                         last_login          => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         user_type           => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},   # enum => ['LOCAL', 'REMOVE']
                         global_search_on_ea => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
                'email'               => [],
                'old_password'        => [],
                'password'            => [],
                'table_size'          => [],
                'time_zone'           => [],
                'admin_group'         => [],
                'days_to_expire'      => [],
                'last_login'          => [],
                'user_type'           => [],
                'global_search_on_ea' => [],
               );

    %_name_mappings = ();

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                tField('email'),
                tField('table_size'),
                tField('time_zone'),
              #
                tField('days_to_expire'),
                tField('last_login'),
                tField('user_type'),
                tField('global_search_on_ea'),
               );

    %_ibap_to_object = (
                'admin_group'         => \&ibap_i2o_generic_object_convert,
                'global_search_on_ea' => \&ibap_i2o_boolean,
               );

    %_object_to_ibap = (
                'email'               => \&ibap_o2i_string,
                'old_password'        => \&ibap_o2i_string_skip_undef,
                'password'            => \&ibap_o2i_string_skip_undef,
                'table_size'          => \&ibap_o2i_integer,
                'time_zone'           => \&ibap_o2i_string,
                'admin_group'         => \&ibap_o2i_ignore,
                'days_to_expire'      => \&ibap_o2i_ignore,
                'last_login'          => \&ibap_o2i_ignore,
                'user_type'           => \&ibap_o2i_ignore,
                'global_search_on_ea' => \&ibap_o2i_boolean,
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

    unless ($_return_fields_initialized) {
      $_return_fields_initialized = 1;

      my $t = Infoblox::Grid::Admin::Group->__new__();
      push @_return_fields,
        tField('admin_group', {
                        sub_fields => $t->__return_fields__()
                      }
              );
    }
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'global_search_on_ea'} = 0 unless defined $$ibap_object_ref{'global_search_on_ea'};
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
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
