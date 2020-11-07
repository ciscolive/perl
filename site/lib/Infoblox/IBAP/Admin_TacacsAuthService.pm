package Infoblox::Grid::Admin::TACACSPlusAuthService;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields $_return_fields_initialized %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'TacacsplusAuthService';
    register_wsdl_type('ib:TacacsplusAuthService','Infoblox::Grid::Admin::TACACSPlusAuthService');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 0,
                     );

    %_allowed_members =
      (
       acct_retries       => {simple => 'asis', validator => \&ibap_value_o2i_uint},
       acct_timeout       => {simple => 'asis', validator => \&ibap_value_o2i_uint},
       auth_retries       => {simple => 'asis', validator => \&ibap_value_o2i_uint},
       auth_timeout       => {simple => 'asis', validator => \&ibap_value_o2i_uint},
       comment            => {simple => 'asis', validator => \&ibap_value_o2i_string},
       disabled           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
       name               => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
       tacacsplus_servers => {array => 1, mandatory => 1, validator => { 'Infoblox::Grid::Admin::TACACSPlusAuthServer' => 1 }},
      );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           name => [\&ibap_o2i_string,'name' , 'EXACT'],
                          );

    %_return_field_overrides =
      (
       acct_retries       => [],
       acct_timeout       => [],
       auth_retries       => [],
       auth_timeout       => [],
       comment            => [],
       disabled           => [],
       name               => [],
       tacacsplus_servers => [],
      );

    %_name_mappings =
      (
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       'tacacsplus_servers' => \&ibap_i2o_generic_object_list_convert,
       'disabled'           => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       acct_retries   => \&ibap_o2i_uint,
       acct_timeout   => \&ibap_o2i_uint,
       auth_retries   => \&ibap_o2i_uint,
       auth_timeout   => \&ibap_o2i_uint,
       comment        => \&ibap_o2i_string,
       disabled       => \&ibap_o2i_boolean,
       name           => \&ibap_o2i_string,
       tacacsplus_servers => \&ibap_o2i_generic_struct_list_convert,
      );

    $_return_fields_initialized=0;
    @_return_fields =
      (
       tField('comment'),
       tField('disabled'),
       tField('name'),
       tField('auth_retries'),
       tField('auth_timeout'),
       tField('acct_retries'),
       tField('acct_timeout'),
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
        my $t=Infoblox::Grid::Admin::TACACSPlusAuthServer->__new__();

        push @_return_fields,
          tField('tacacsplus_servers', {
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

    $$ibap_object_ref{'disabled'}     = 0 unless defined($$ibap_object_ref{'disabled'});

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

package Infoblox::Grid::Admin::TACACSPlusAuthServer;

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
    $_object_type = 'tacacsplus_server';
    register_wsdl_type('ib:tacacsplus_server','Infoblox::Grid::Admin::TACACSPlusAuthServer');
    %_allowed_members = (
                         acct_enabled  => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         auth_type     => {simple => 'asis', enum => [ 'PAP', 'CHAP', 'ASCII']},
                         comment       => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         disabled      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         fqdn_or_ip    => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         use_mgmt_port => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         port          => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         shared_secret => {mandatory => 1, writeonly => 1, validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       acct_enabled  => 'accounting_enabled',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       'disabled'           => \&ibap_i2o_boolean,
       'accounting_enabled' => \&ibap_i2o_boolean,
       'use_mgmt_port'      => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       acct_enabled  => \&ibap_o2i_boolean,
       auth_type     => \&ibap_o2i_string,
       comment       => \&ibap_o2i_string,
       disabled      => \&ibap_o2i_boolean,
       fqdn_or_ip    => \&ibap_o2i_string,
       use_mgmt_port => \&ibap_o2i_boolean,
       port          => \&ibap_o2i_uint,
       shared_secret => \&ibap_o2i_string_skip_undef,
      );

    @_return_fields =
      (
       tField('accounting_enabled'),
       tField('auth_type'),
       tField('comment'),
       tField('disabled'),
       tField('fqdn_or_ip'),
       tField('use_mgmt_port'),
       tField('port'),
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

sub __ibap_object_type__ {

    return $_object_type;
}


#
#
#

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disabled'}           = 0 unless defined($$ibap_object_ref{'disabled'});
    $$ibap_object_ref{'accounting_enabled'} = 0 unless defined($$ibap_object_ref{'accounting_enabled'});
    $$ibap_object_ref{'use_mgmt_port'}      = 0 unless defined($$ibap_object_ref{'use_mgmt_port'});
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

#
#
#

1;


