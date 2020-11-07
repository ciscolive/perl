package Infoblox::Grid::RIR;
  
use strict;
  
use Carp;
  
use Infoblox::Util;
use Infoblox::IBAPBase;        
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object
                 %_name_mappings %_reverse_name_mappings %_object_to_ibap
                 @_return_fields %_capabilities %_searchable_fields
                 %_return_field_overrides $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_REMOVE);

BEGIN {
    $_object_type = 'Rir';
    register_wsdl_type('ib:Rir','Infoblox::Grid::RIR');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'name'               => {simple => 'asis', enum => ['RIPE']},
                         'communication_mode' => {simple => 'asis', mandatory => 1, enum => ['API','EMAIL', 'NONE']},
                         'email'              => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_email', use_truefalse => 1},
                         'url'                => {simple => 'asis', validator => \&ibap_value_o2i_string, use => 'override_url', use_truefalse => 1},
                         'override_email'     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'override_url'       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
                                'name'               => [],
                                'communication_mode' => [],
                                'email'              => ['use_email'],
                                'url'                => ['use_url'],
                                'override_email'     => [],
                                'override_url'       => [],
                               );

    %_name_mappings = (
                       'override_email' => 'use_email',
                       'override_url'   => 'use_url',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('name'),
                       tField('communication_mode'),
                       tField('email'),
                       tField('url'),
                       tField('use_email'),
                       tField('use_url'),
                      );

    %_ibap_to_object = (
                        'use_email' => \&ibap_i2o_boolean,
                        'use_url'   => \&ibap_i2o_boolean,
                       );

    %_object_to_ibap = (
                        'name'               => \&ibap_o2i_string,
                        'communication_mode' => \&ibap_o2i_string,
                        'email'              => \&ibap_o2i_string,
                        'url'                => \&ibap_o2i_string,
                        'override_email'     => \&ibap_o2i_boolean,
                        'override_url'       => \&ibap_o2i_boolean,
                       );

    %_searchable_fields = (
                           'name' => [\&ibap_o2i_string, 'name', 'EXACT'],
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

    $self->name('RIPE') unless $self->name();
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

    $$ibap_object_ref{'use_email'} = 0 unless defined $$ibap_object_ref{'use_email'};
    $$ibap_object_ref{'use_url'} = 0 unless defined $$ibap_object_ref{'use_url'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    $self->{'override_email'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_email'});
    $self->{'override_url'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_url'});

    return;
}

package Infoblox::Grid::RIR::Organization;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object
                 %_name_mappings %_reverse_name_mappings %_object_to_ibap
                 @_return_fields %_capabilities %_searchable_fields
                 %_return_field_overrides $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'RirOrganization';
    register_wsdl_type('ib:RirOrganization','Infoblox::Grid::RIR::Organization');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         'id'                    => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'rir'                   => {mandatory => 1, validator => {'Infoblox::Grid::RIR' => 1}},
                         'name'                  => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'maintainer'            => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'password'              => {mandatory => 1, writeonly => 1, validator => \&ibap_value_o2i_string},
                         'sender_email'          => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'extattrs'              => {mandatory => 1, special => 'extensible_attributes'},
                         'extensible_attributes' => {mandatory => 1, special => 'extensible_attributes'},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
                                'id'                    => [],
                                'rir'                   => [],
                                'name'                  => [],
                                'maintainer'            => [],
                                'sender_email'          => [],
                                'extattrs'              => [],
                                'extensible_attributes' => [],
                               );

    %_name_mappings = (
                       'extattrs'                     => 'extensible_attributes',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    $_return_fields_initialized = 0;

    @_return_fields = (
                       tField('id'),
                       tField('name'),
                       tField('maintainer'),
                       tField('sender_email'),
                       return_fields_extensible_attributes(),
                      );

    %_ibap_to_object = (
                        'rir'                   => \&ibap_i2o_generic_object_convert,
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                       );

    %_object_to_ibap = (
                        'id'                    => \&ibap_o2i_string,
                        'rir'                   => \&ibap_o2i_object_by_oid_or_name,
                        'name'                  => \&ibap_o2i_string,
                        'maintainer'            => \&ibap_o2i_string,
                        'password'              => \&ibap_o2i_string_skip_undef,
                        'sender_email'          => \&ibap_o2i_string,
                        'extattrs'              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes' => \&ibap_o2i_ignore,
                       );

    %_searchable_fields = (
                           'id'   => [\&ibap_o2i_string, 'id', 'REGEX', 'IGNORE_CASE'],
                           'name' => [\&ibap_o2i_string, 'name', 'REGEX', 'IGNORE_CASE'],
                           'extattrs' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                          );
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self, $class;

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
    bless $self, $class;

    $self->__init_instance_constants__();

    return $self;
}

sub __init_instance_constants__
{
    my $self = shift;

    unless ($_return_fields_initialized) {
        $_return_fields_initialized = 1;
        my $t = Infoblox::Grid::RIR->__new__();
        push @_return_fields, tField('rir', { sub_fields => $t->__return_fields__() });
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

1;
