package Infoblox::Grid::Admin::AuthPolicy;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields $_return_fields_initialized %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_MODIFY_ONLY);

BEGIN {
    $_object_type = 'AuthPolicy';
    register_wsdl_type('AuthPolicy','Infoblox::Grid::Admin::AuthPolicy');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members =
      (
       admin_groups  => 0,
       auth_services => 0,
       default_group => 0,
       usage_type    => {simple => 'asis', enum => ['FULL', 'AUTH_ONLY']},
      );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                          );

    %_return_field_overrides =
      (
       admin_groups  => [],
       auth_services => [],
       default_group => [],
       usage_type    => [],
      );

    %_name_mappings =
      (
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       admin_groups  => \&ibap_i2o_generic_object_list_convert,
       auth_services => \&ibap_i2o_generic_object_list_convert,
       default_group => \&ibap_i2o_generic_object_convert,
      );

    %_object_to_ibap =
      (
       admin_groups  => \&__o2i_groups__,
       auth_services => \&__o2i_services__,
       default_group => \&__o2i_default__,
       usage_type    => \&ibap_o2i_string,
      );

    $_return_fields_initialized=0;
    @_return_fields =
      (
       tField('usage_type'),
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

        $_return_fields_initialized = 1;

        my $tmp;
        my @_tmp_return_fields;

        foreach my $obj (
            'Infoblox::Grid::Admin::AdAuthService',
            'Infoblox::Grid::Admin::RadiusAuthService',
            'Infoblox::Grid::Admin::LocalUserAuthService',
            'Infoblox::Grid::Admin::TACACSPlusAuthService',
            'Infoblox::LDAP::AuthService',
            'Infoblox::Grid::Admin::CertificateAuthService',
        ) {
            $tmp = $obj->__new__();

            push @_tmp_return_fields, tFieldObjType(
                $tmp->__ibap_object_type__,
                {sub_fields => $tmp->__return_fields__()},
            );
        }

        push @_return_fields, tField('auth_services', {
            'default_no_access_ok' => 1,
            'sub_fields'           => \@_tmp_return_fields,
        });


        $tmp = Infoblox::Grid::Admin::Group->__new__();

        push @_return_fields, tField('default_group', {
            default_no_access_ok => 1,
            sub_fields           => $tmp->__return_fields__(),
        });

        push @_return_fields, tField('admin_groups', {
            default_no_access_ok => 1,
            sub_fields           => $tmp->__return_fields__(),
        });
    }

    #
    $self->admin_groups([]) unless defined $self->admin_groups();
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

sub __o2i_groups__
{
    my ($self, $session, $current, $tempref) = @_;

    my @list;
    if ($$tempref{$current}) {
        foreach (@{$$tempref{$current}}) {
            push @list, ibap_readfield_simple_string('AdminGroup','name',$_->name());
        }
    }

    return (1,0, tIBType('ArrayOfBaseObject',\@list));
}

sub __o2i_default__
{
    my ($self, $session, $current, $tempref) = @_;
    if ($$tempref{$current}) {
        return (1,0, ibap_readfield_simple_string('AdminGroup','name',$$tempref{$current}->name()));
    }
    else {
        return (1,0,undef);
    }
}

sub __o2i_services__
{
    my ($self, $session, $current, $tempref) = @_;

    my @newlist;
    if (defined $$tempref{$current} && (ref($$tempref{$current}) eq 'ARRAY')) {
        foreach (@{$$tempref{$current}}) {
            unless ($_->__object_id__()) {
                if (ref($_) eq 'Infoblox::Grid::Admin::LocalUserAuthService') {
                    set_error_codes(1002, 'The Infoblox::Grid::Admin::LocalUserAuthService must have been retrieved from the server as part of an Infoblox::Grid::Admin::AuthPolicy get', $session);
                }
                else {
                    set_error_codes(1002, 'The ' . ref($_) . ' object must have been retrieved from the server via get/search', $session);
                }
                return (0);
            }
            else {
                push @newlist, tObjIdRef($_->__object_id__())
            }
        }
    }

    return (1,0,tIBType('ArrayOfBaseObject', \@newlist));
}

#
#
#

sub auth_services
{
    my $self=shift;
    return $self->__accessor_array__({name => 'auth_services', validator => { 'Infoblox::Grid::Admin::AdAuthService' => 1, 'Infoblox::Grid::Admin::RadiusAuthService' => 1, 'Infoblox::Grid::Admin::LocalUserAuthService' => 1, 'Infoblox::Grid::Admin::TACACSPlusAuthService' => 1, 'Infoblox::LDAP::AuthService' => 1, 'Infoblox::Grid::Admin::CertificateAuthService' => 1 }}, @_);
}

sub default_group
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'default_group', validator => { 'Infoblox::Grid::Admin::Group' => 1 }}, @_);
}

sub admin_groups
{
    my $self=shift;
    return $self->__accessor_array__({name => 'admin_groups', validator => { 'Infoblox::Grid::Admin::Group' => 1 }}, @_);
}


package Infoblox::Grid::Admin::LocalUserAuthService;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields $_object_type %_capabilities);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_ONLY );

BEGIN
{
    $_object_type='LocalUserAuthService';
    register_wsdl_type('ib:LocalUserAuthService','Infoblox::Grid::Admin::LocalUserAuthService');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 0,
                     );

    %_allowed_members = (
                         name     => -1,
                         comment  => -1,
                         disabled => -1,
                        );

    %_name_mappings = (
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       'disabled'      => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       name     => \&ibap_o2i_ignore,
       comment  => \&ibap_o2i_ignore,
       disabled => \&ibap_o2i_ignore,
      );

    @_return_fields =
      (
       tField('name'),
       tField('comment'),
       tField('disabled'),
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
                                                undef,
                                                \%_ibap_to_object,
                                                \%_object_to_ibap,
                                                \@_return_fields
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

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disabled'}      = 0 unless defined($$ibap_object_ref{'disabled'});
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    return;
}

#
#
#

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string, readonly => 1}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string, readonly => 1}, @_);
}

sub disabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disabled', validator => \&ibap_value_o2i_boolean, readonly => 1}, @_);
}


1;
