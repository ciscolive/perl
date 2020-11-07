package Infoblox::Grid::HSM::SafeNet;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields %_capabilities %_searchable_fields %_return_field_overrides $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'hsm_safenet';
    register_wsdl_type('ib:hsm_safenet','Infoblox::Grid::HSM::SafeNet');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         name                     => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         partition_serial         => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_ulong},
                         server_certificate       => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},

                         disabled                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},

                         is_fips_compliant        => {simple => 'bool', readonly => 1, validator => \&ibap_value_o2i_boolean},
                         partition_capacity       => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_uint},
                         partition_id             => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         status                   => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides =
      (
       disabled                   => [],
       is_fips_compliant          => [],
       name                       => [],
       partition_capacity         => [],
       partition_id               => [],
       partition_serial           => [],
       server_certificate         => [],
       status                     => [],
      );

    %_name_mappings =
               (
                'server_certificate'  => 'server_cert',
                'partition_serial'    => 'partition_serial_number',
               );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields =
      (
       tField('disabled'),
       tField('is_fips_compliant'),
       tField('name'),
       tField('partition_capacity'),
       tField('partition_id'),
       tField('partition_serial_number'),
       tField('server_cert'),
       tField('status'),
      );

    %_ibap_to_object =
      (
       'disabled'            => \&ibap_i2o_boolean,
       'is_fips_compliant'   => \&ibap_i2o_boolean,
       'server_cert'         => \&__i2o_cert,
      ); 

    %_object_to_ibap = (
                        'disabled'                      => \&ibap_o2i_boolean,
                        'is_fips_compliant'             => \&ibap_o2i_ignore,
                        'name'                          => \&ibap_o2i_string,
                        'partition_capacity'            => \&ibap_o2i_ignore,
                        'partition_id'                  => \&ibap_o2i_ignore,
                        'partition_serial'              => \&ibap_o2i_ulong,
                        'server_certificate'            => \&__o2i_cert__,
                        'status'                        => \&ibap_o2i_ignore,
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
    $self->disabled('false') unless defined $self->disabled();
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

sub __o2i_cert__
{
    my ($self, $session, $current, $tempref) = @_;

    return undef unless $$tempref{$current};

    my %substruct = ();
    $substruct{'data_mode'} = ibap_value_o2i_string('DATA_INLINE');

    my $fcontent = undef;

    if ($$tempref{$current} !~ /\n/) {
      if (-e $$tempref{$current}) {
        if (open(my $fcert, '<'.$$tempref{$current})) {
          $fcontent = join("", <$fcert>);
          close($fcert)
        } else {
          set_error_codes(1001, "Cannot open ".$$tempref{$current}, $session);
          return undef;
        }
      }
    }

    $fcontent = $$tempref{$current} unless defined($fcontent);

    if ($fcontent =~ /^-{5}BEGIN CERTIFICATE-{5}.+-{5}END CERTIFICATE-{5}$/s) {
      $substruct{'data'} = ibap_value_o2i_string($fcontent);
      return (1, 0, tIBType('data_ref', \%substruct));
    } else {
      set_error_codes(1001, "The certificate is incorrect", $session);
      return undef;
    }

    return undef;
}

sub __i2o_cert__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    return '';
}


package Infoblox::Grid::HSM::SafeNet::Group;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields %_capabilities %_searchable_fields %_return_field_overrides $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'HSMSafeNetGroup';
    register_wsdl_type('ib:HSMSafeNetGroup','Infoblox::Grid::HSM::SafeNet::Group');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         name          => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         passphrase    => {mandatory => 1, writeonly => 1, validator => \&ibap_value_o2i_string},
                         hsm_servers   => {array => 1, mandatory => 1, validator => {'Infoblox::Grid::HSM::SafeNet' => 1}},
                         hsm_version   => {simple => 'asis', mandatory => 1, enum => ['LunaSA_4','LunaSA_5','LunaSA_6']},

                         comment       => {simple => 'asis', validator => \&ibap_value_o2i_string},

                         serial_number => {simple => 'asis', readonly => 1, validator => \&ibap_valui_o2i_uint},
                         status        => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides =
      (
        'comment'        => [],
        'serial_number'  => [],
        'hsm_servers'    => [],
        'hsm_version'    => [],
        'name'           => [],
        'passphrase'     => [],
        'status'         => [],
      );

    %_name_mappings =
      (
        'hsm_servers'   => 'hsm_safenet',
        'serial_number' => 'group_sn',
        'passphrase'    => 'pass_phrase'
      );

    %_reverse_name_mappings = reverse %_name_mappings;
      
    @_return_fields =
      (
       tField('comment'),
       tField('group_sn'),
       tField('name'),
       tField('hsm_safenet'),
       tField('hsm_version'),
       tField('status'),
      );

    %_ibap_to_object =
      (
        'hsm_safenet'     => \&ibap_i2o_generic_object_list_convert,
      ); 

    %_object_to_ibap = (
                        'comment'         => \&ibap_o2i_string,
                        'serial_number'   => \&ibap_o2i_ignore,
                        'hsm_servers'     => \&ibap_o2i_generic_struct_list_convert,
                        'hsm_version'     => \&ibap_o2i_string,
                        'name'            => \&ibap_o2i_string,
                        'passphrase'      => \&ibap_o2i_string_skip_undef,
                        'status'          => \&ibap_o2i_ignore,
                        );

    %_searchable_fields = (
                           'name' => [\&ibap_o2i_string, 'name', 'REGEX'],
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
