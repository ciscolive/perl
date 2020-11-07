package Infoblox::Grid::Admin::RadiusAuthService;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields $_return_fields_initialized %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'RadiusAuthService';
    register_wsdl_type('ib:RadiusAuthService','Infoblox::Grid::Admin::RadiusAuthService');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 0,
                     );

    %_allowed_members =
      (
       acct_retries   => 0,
       acct_timeout   => 1,
       auth_retries   => 0,
       auth_timeout   => 1,
       cache_ttl      => 0,
       comment        => 0,
       disabled       => 0,
       enable_cache   => 0,
       name           => 1,
       radius_servers => {mandatory => 1, validator => {'Infoblox::Grid::Admin::RadiusAuthServer' => 1}, skip_accessor => 1},
       recovery_ttl   => 0,
       selection_mode => 0,
      );

    %_searchable_fields = (
                           name => [\&ibap_o2i_string,'name' , 'EXACT'],
                          );

    %_return_field_overrides =
      (
       acct_retries   => [],
       acct_timeout   => [],
       auth_retries   => [],
       auth_timeout   => [],
       cache_ttl      => [],
       comment        => [],
       disabled       => [],
       enable_cache   => [],
       name           => [],
       radius_servers => [],
       recovery_ttl   => [],
       selection_mode => [],
      );

    %_name_mappings =
      (
       recovery_ttl   => 'recovery_interval',
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       'radius_servers' => \&ibap_i2o_generic_object_list_convert,
       'enable_cache'   => \&ibap_i2o_boolean,
       'disabled'       => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       acct_retries   => \&ibap_o2i_uint,
       acct_timeout   => \&ibap_o2i_uint,
       auth_retries   => \&ibap_o2i_uint,
       auth_timeout   => \&ibap_o2i_uint,
       cache_ttl      => \&ibap_o2i_uint,
       comment        => \&ibap_o2i_string,
       disabled       => \&ibap_o2i_boolean,
       enable_cache   => \&ibap_o2i_boolean,
       name           => \&ibap_o2i_string,
       radius_servers => \&ibap_o2i_generic_struct_list_convert,
       recovery_ttl   => \&ibap_o2i_uint,
       selection_mode => \&ibap_o2i_string,
      );

    $_return_fields_initialized=0;
    @_return_fields =
      (
       tField('comment'),
       tField('disabled'),
       tField('name'),
       tField('acct_retries'),
       tField('acct_timeout'),
       tField('auth_retries'),
       tField('auth_timeout'),
       tField('selection_mode'),
       tField('enable_cache'),
       tField('cache_ttl'),
       tField('recovery_interval'),
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
        my $t=Infoblox::Grid::Admin::RadiusAuthServer->__new__();

        push @_return_fields,
          tField('radius_servers', {
                                sub_fields => $t->__return_fields__(),
                               }
                );
    }

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                             \%_reverse_name_mappings,
                                             \%_searchable_fields,
                                             \%_ibap_to_object,
                                             \%_object_to_ibap,
                                             \@_return_fields,
                                             \%_return_field_overrides
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

    $$ibap_object_ref{'disabled'}     = 0 unless defined($$ibap_object_ref{'disabled'});
    $$ibap_object_ref{'enable_cache'} = 0 unless defined($$ibap_object_ref{'enable_cache'});

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

#
#
#

sub radius_servers
{
    my $self=shift;
    return $self->__accessor_array__({name => 'radius_servers', validator => { 'Infoblox::Grid::Admin::RadiusAuthServer' => 1 }}, @_);
}

sub acct_retries
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'acct_retries', validator => \&ibap_value_o2i_uint}, @_);
}

sub auth_retries
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'auth_retries', validator => \&ibap_value_o2i_uint}, @_);
}

sub acct_timeout
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'acct_timeout', validator => \&ibap_value_o2i_uint}, @_);
}

sub auth_timeout
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'auth_timeout', validator => \&ibap_value_o2i_uint}, @_);
}

sub cache_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'cache_ttl', validator => \&ibap_value_o2i_uint}, @_);
}

sub recovery_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'recovery_ttl', validator => \&ibap_value_o2i_uint}, @_);
}

sub disabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_cache
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_cache', validator => \&ibap_value_o2i_boolean}, @_);
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

sub selection_mode
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'selection_mode', enum => ['HUNT_GROUP','ROUND_ROBIN'] }, @_);
}


package Infoblox::Grid::Admin::RadiusAuthServer;

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
    $_object_type = 'radius_server';
    register_wsdl_type('ib:radius_server','Infoblox::Grid::Admin::RadiusAuthServer');
    %_allowed_members = (
                         acct_enabled  => 0,
                         acct_port     => 0,
                         auth_port     => 0,
                         auth_type     => 0,
                         comment       => 0,
                         disabled      => 0,
                         fqdn_or_ip    => 1,
                         shared_secret => 1,
                         use_mgmt_port => 0,
                        );

    %_name_mappings = (
                       acct_enabled  => 'use_accounting',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       'disabled'      => \&ibap_i2o_boolean,
       'use_accounting' => \&ibap_i2o_boolean,
       'use_mgmt_port' => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       acct_enabled  => \&ibap_o2i_boolean,
       acct_port     => \&ibap_o2i_uint,
       auth_port     => \&ibap_o2i_uint,
       auth_type     => \&ibap_o2i_string,
       comment       => \&ibap_o2i_string,
       disabled      => \&ibap_o2i_boolean,
       fqdn_or_ip    => \&ibap_o2i_string,
       shared_secret => \&ibap_o2i_string_skip_undef,
       use_mgmt_port => \&ibap_o2i_boolean,
      );

    @_return_fields =
      (
       tField('use_accounting'),
       tField('acct_port'),
       tField('auth_port'),
       tField('auth_type'),
       tField('comment'),
       tField('disabled'),
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

sub __ibap_object_type__ {

    return $_object_type;
}

#
#
#

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disabled'}       = 0 unless defined($$ibap_object_ref{'disabled'});
    $$ibap_object_ref{'use_accounting'} = 0 unless defined($$ibap_object_ref{'use_accounting'});
    $$ibap_object_ref{'use_mgmt_port'}  = 0 unless defined($$ibap_object_ref{'use_mgmt_port'});
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

#
#
#


#
#
#

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

sub acct_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'acct_port', validator => \&ibap_value_o2i_uint}, @_);
}

sub auth_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'auth_port', validator => \&ibap_value_o2i_uint}, @_);
}

sub acct_enabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'acct_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub use_mgmt_port
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'use_mgmt_port', validator => \&ibap_value_o2i_boolean}, @_);
}

sub fqdn_or_ip
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'fqdn_or_ip', validator => \&ibap_value_o2i_string}, @_);
}

sub shared_secret
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'shared_secret', writeonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub auth_type
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'auth_type', enum => ['PAP','CHAP'] }, @_);
}

1;


