package Infoblox::DHCP::OptionSpace;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_return_field_overrides %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object %_capabilities);
@ISA = qw(Infoblox::IBAPBase);

BEGIN 
{
    $_object_type = 'OptionSpace';
    register_wsdl_type('ib:OptionSpace','Infoblox::DHCP::OptionSpace');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         name                => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         comment             => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         space_type          => {readonly => 1, enum => [ 'predefined_dhcp', 'vendor_space' ]},
#
#
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('name'),
                       tField('comment'),
                       tField('space_type'),
                       tField('ms_is_user_class'),
                       tField('ms_server', { sub_fields => [ tField('address'), tField('server_name')]}),
    );

    %_return_field_overrides = (
                                name             => [],
                                comment          => [],
                                space_type       => [],
#
#
                               );

    %_ibap_to_object = (
#
#
                        space_type       => \&ibap_i2o_enums_lc_or_undef,
    );

    %_object_to_ibap = (
                        name             => \&ibap_o2i_string,
                        comment          => \&ibap_o2i_string,
#
#
                        space_type       => \&ibap_o2i_ignore,
    );

    %_searchable_fields = (
        name => [\&ibap_o2i_string ,'name', 'REGEX'],
        comment => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],

#
        ms_server => [\&ibap_o2i_msserver ,'ms_server', 'EXACT'],
    );
}

#
#
#

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

sub __search_mapping_hook_pre__
{
    my ($self, $session, $type, $argsref, $out_search_fields_ref, $out_search_types_ref, $out_search_matches_ref) = @_;

    #
    $$argsref{ms_server} = undef;
    return 1;
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'ms_is_user_class'}    = 0 unless defined $$ibap_object_ref{'ms_is_user_class'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

package Infoblox::DHCP::IPv6OptionSpace;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_return_field_overrides %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object %_capabilities);
@ISA = qw(Infoblox::IBAPBase);

BEGIN 
{
    $_object_type = 'IPv6OptionSpace';
    register_wsdl_type('ib:IPv6OptionSpace','Infoblox::DHCP::IPv6OptionSpace');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         name                => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         comment             => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         enterprise_number   => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       enterprise_number => 'v6_enterprise_number',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
        name              => [],
        comment           => [],
        enterprise_number => [],
    );

    %_ibap_to_object = (
    );

    %_object_to_ibap = (
        name              => \&ibap_o2i_string,
        comment           => \&ibap_o2i_string,
        enterprise_number => \&ibap_o2i_uint,
    );

    %_searchable_fields = (
        name              => [\&ibap_o2i_string ,'name', 'EXACT'],
        comment           => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],
        enterprise_number => [\&ibap_o2i_uint ,'v6_enterprise_number', 'EXACT'],
    );

    @_return_fields = (
        tField('name'),
        tField('comment'),
        tField('v6_enterprise_number'),
    );
}

#
#
#

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

1;

