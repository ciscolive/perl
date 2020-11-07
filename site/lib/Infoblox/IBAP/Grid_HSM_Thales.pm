package Infoblox::Grid::HSM::Thales;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields %_capabilities %_searchable_fields %_return_field_overrides);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'Thales_HSM';
    register_wsdl_type('ib:thales_hsm','Infoblox::Grid::HSM::Thales');

    %_capabilities = (
                            'depth'                => 0,
                            'implicit_defaults'    => 1,
                            'single_serialization' => 1,
                     );

    %_allowed_members = (
                         disabled                      => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         keyhash                       => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         remote_esn                    => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         remote_ip                     => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         remote_port                   => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         status                        => {simple => 'asis', readonly => 1,validator => \&ibap_value_o2i_string},
                    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);


    %_return_field_overrides =
      (
        'disabled'                      => [],
        'keyhash'                       => [],
        'remote_esn'                    => [],
        'remote_ip'                     => [],
        'remote_port'                   => [],
        'status'                        => [],
        );
      
    @_return_fields =
      (
        tField('remote_ip'),
        tField('remote_port'),
        tField('status'),
        tField('remote_esn'),
        tField('keyhash'),
        tField('disabled'),
       );

    %_ibap_to_object =
      (
       'disabled'                 => \&ibap_i2o_boolean,
      ); 

    %_object_to_ibap = (
                        'remote_ip'                            => \&ibap_o2i_string,
                        'remote_port'                          => \&ibap_o2i_uint,
                        'status'                               => \&ibap_o2i_string,
                        'remote_esn'                           => \&ibap_o2i_string,
                        'keyhash'                              => \&ibap_o2i_string,
                        'disabled'                             => \&ibap_o2i_boolean,
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
    $self->disabled('false')     unless defined $self->disabled();
    $self->remote_port(9004)     unless defined $self->remote_port();
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

sub __get_class_methods_class__
{
    return 'Infoblox::Grid::HSM::Thales';
}

#
#
#
package Infoblox::Grid::HSM::Server;

use vars qw(@ISA);
@ISA = qw (Infoblox::Grid::HSM::Thales);


package Infoblox::Grid::HSM::Thales::Group;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields %_capabilities %_return_field_overrides %_searchable_fields);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'HSMThalesGroup';
    register_wsdl_type('ib:HSMThalesGroup','Infoblox::Grid::HSM::Thales::Group');

    %_capabilities = (
                            'depth'                => 0,
                            'implicit_defaults'    => 1,
                            'single_serialization' => 1,
                     );

    %_allowed_members = (
                         card_name                     => {simple => 'asis', validator => \&ibap_value_o2i_string}, 
                         comment                       => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         key_server_ip                 => {simple => 'asis','mandatory' => 1, validator => \&ibap_value_o2i_string} ,
                         key_server_port               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         name                          => {simple => 'asis', mandatory=>1, validator => \&ibap_value_o2i_string} ,
                         pass_phrase                   => {writeonly => 1, validator => \&ibap_value_o2i_string} ,
                         protection                    => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         status                        => {simple => 'asis', readonly=>1, validator => \&ibap_value_o2i_string},
                         thales_hsm                    => {array=>1, mandatory=>1, validator => {'Infoblox::Grid::HSM::Server' => 1, 'Infoblox::Grid::HSM::Thales' => 1}}, 
                    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides =
      (
        'card_name'                     => [],
        'comment'                       => [],
        'key_server_ip'                 => [],
        'key_server_port'               => [],
        'name'                          => [],
        'pass_phrase'                   => [],
        'protection'                    => [],
        'status'                        => [],
        'thales_hsm'                    => [],
      );
      
    @_return_fields =
      (
       tField('name'),
       tField('status'),
       tField('comment'),
       tField('key_server_ip'),
       tField('key_server_port'),
       tField('protection'),
       tField('card_name'),
       tField('thales_hsm'),
      );

    %_ibap_to_object =
      (
        'thales_hsm'               => \&ibap_i2o_generic_object_list_convert,
      ); 

    %_object_to_ibap = (
                        'name'                                 => \&ibap_o2i_string,
                        'status'                               => \&ibap_o2i_string,
                        'comment'                              => \&ibap_o2i_string,
                        'pass_phrase'                          => \&ibap_o2i_string_skip_undef,
                        'key_server_ip'                        => \&ibap_o2i_string,
                        'key_server_port'                      => \&ibap_o2i_uint,
                        'protection'                           => \&ibap_o2i_string,
                        'card_name'                            => \&ibap_o2i_string,
                        'thales_hsm'                           => \&ibap_o2i_generic_struct_list_convert,
                        );

    %_searchable_fields = (
                           'name'          => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'key_server_ip' => [\&ibap_o2i_string, 'key_server_ip', 'REGEX'],
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
    $self->key_server_port(9004) unless defined $self->key_server_port();
    $self->protection('MODULE')  unless defined $self->protection();
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

sub __get_class_methods_class__
{
    return 'Infoblox::Grid::HSM::Thales::Group';
}

#
#
#
package Infoblox::Grid::HSM::Group;

use vars qw(@ISA);
@ISA = qw (Infoblox::Grid::HSM::Thales::Group);

1;
