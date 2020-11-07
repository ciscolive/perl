package Infoblox::Grid::Admin::AdAuthService;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields $_return_fields_initialized %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'AdAuthService';
    register_wsdl_type('ib:AdAuthService','Infoblox::Grid::Admin::AdAuthService');

    #
    #
    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 0,
                     );

    %_allowed_members =
      (
       ad_auth_server_list => {mandatory => 1, validator => {'Infoblox::Grid::Admin::AdAuthServer' => 1}, skip_accessor => 1},
       ad_domain           => 1,
       comment             => 0,
       disabled            => 0,
       name                => 1,
       timeout             => 0,
       nested_group_querying => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
      );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           name => [\&ibap_o2i_string,'name' , 'EXACT'],
                          );

    %_return_field_overrides =
      (
       ad_auth_server_list => [],
       ad_domain           => [],
       comment             => [],
       disabled            => [],
       name                => [],
       timeout             => [],
       nested_group_querying => [],
      );

    %_name_mappings =
      (
       ad_auth_server_list => 'domain_controllers',
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       'domain_controllers'             => \&ibap_i2o_generic_object_list_convert,
       'disabled'                       => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       ad_auth_server_list => \&ibap_o2i_generic_struct_list_convert,
       ad_domain           => \&ibap_o2i_string,
       comment             => \&ibap_o2i_string,
       disabled            => \&ibap_o2i_boolean,
       name                => \&ibap_o2i_string,
       timeout             => \&ibap_o2i_uint,
       nested_group_querying => \&ibap_o2i_boolean,
      );

    $_return_fields_initialized=0;
    @_return_fields =
      (
       tField('ad_domain'),
       tField('disabled'),
       tField('comment'),
       tField('name'),
       tField('timeout'),
       tField('nested_group_querying'),
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

        #
        my $t=Infoblox::Grid::Admin::AdAuthServer->__new__();

        push @_return_fields,
          tField('domain_controllers', {
                                sub_fields => $t->__return_fields__(),
                               }
                );
    }


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

sub __search_override_hook__ {
    my ($object_type, $session, $args_ref) = @_;
    set_error_codes(1008, "'search' not allowed for this object", $session);
    return;
}

#
#
#

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disabled'} = 0 unless defined($$ibap_object_ref{'disabled'});
    $$ibap_object_ref{'nested_group_querying'} = 0 unless defined $$ibap_object_ref{'nested_group_querying'};
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    return;
}

#
#
#

sub ad_auth_server_list
{
    my $self=shift;
    return $self->__accessor_array__({name => 'ad_auth_server_list', validator => { 'Infoblox::Grid::Admin::AdAuthServer' => 1 }}, @_);
}

sub timeout
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'timeout', validator => \&ibap_value_o2i_uint}, @_);
}

sub ad_domain
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ad_domain', validator => \&ibap_value_o2i_string}, @_);
}

sub disabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}


package Infoblox::Grid::Admin::AdAuthServer;

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
    $_object_type = 'domain_controller';
    register_wsdl_type('ib:domain_controller','Infoblox::Grid::Admin::AdAuthServer');
    %_allowed_members = (
                         name       => 1,
                         port       => 1,
                         comment    => 0,
                         disabled   => 0,
                         encryption => 0,
                         mgmt_port  => 0,
                        );

    %_name_mappings = (
                       mgmt_port => 'use_mgmt_port',
                       name      => 'fqdn_or_ip',
                       port      => 'auth_port',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       'encryption'    => \&__i2o_enc__,
       'disabled'      => \&ibap_i2o_boolean,
       'use_mgmt_port' => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       comment    => \&ibap_o2i_string,
       disabled   => \&ibap_o2i_boolean,
       encryption => \&__o2i_enc__,
       mgmt_port  => \&ibap_o2i_boolean,
       name       => \&ibap_o2i_string,
       port       => \&ibap_o2i_uint,
      );

    @_return_fields =
      (
       tField('comment'),
       tField('auth_port'),
       tField('disabled'),
       tField('encryption'),
       tField('fqdn_or_ip'),
       tField('use_mgmt_port'),
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

#
#
#

sub __i2o_enc__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && $$ibap_object_ref{$current} eq 'NONE') {
        return 'None';
    }
    else {
        return $$ibap_object_ref{$current};
    }
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'use_mgmt_port'} = 0 unless defined($$ibap_object_ref{'use_mgmt_port'});
    $$ibap_object_ref{'disabled'}      = 0 unless defined($$ibap_object_ref{'disabled'});
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
    return;
}

#
#
#

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;
    if (not defined $self->encryption()) {
        $self->encryption('None');
    }

    return $self->SUPER::__object_to_ibap__($server, $session);
}

sub __o2i_enc__
{
    my ($self, $session, $current, $tempref) = @_;
    return (1, 0, ibap_value_o2i_string(uc $$tempref{$current}));
}

#
#
#

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub disabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'port', validator => \&ibap_value_o2i_uint}, @_);
}

sub mgmt_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'mgmt_port', validator => \&ibap_value_o2i_boolean}, @_);
}

sub encryption
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'encryption', enum => ['SSL', 'None'] }, @_);
}

1;


