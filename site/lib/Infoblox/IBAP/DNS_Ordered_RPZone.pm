package Infoblox::DNS::OrderedResponsePolicyZones;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members %_return_field_overrides
             @_return_fields %_searchable_fields %_object_to_ibap
             %_name_mappings %_reverse_name_mappings %_ibap_to_object
             $_return_fields_initialized %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'OrderedResponsePolicyZones';
    register_wsdl_type('ib:OrderedResponsePolicyZones', 'Infoblox::DNS::OrderedResponsePolicyZones');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         view => {validator => { 'Infoblox::DNS::View' => 1 }},
                         rp_zones  => {array => 1, validator => { 'Infoblox::DNS::Zone' => 1 }},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
                                view => [],
                                rp_zones  => [],
                               );

    %_searchable_fields = (
                           view     => [\&ibap_o2i_view, 'view', 'EXACT'],
                          );

    %_name_mappings = (
                        rp_zones => 'response_policy_zones',
                      );

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_ibap_to_object = (
                        'view' => \&ibap_i2o_generic_object_convert_to_list_of_one,
                        'response_policy_zones'  => \&ibap_i2o_generic_object_list_convert,
                       );

    %_object_to_ibap = (
                        'view' => \&ibap_o2i_view,
                        'rp_zones'  => \&ibap_o2i_zone_list,
                       );
    $_return_fields_initialized=0;
    @_return_fields = (
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

        my $tmp=Infoblox::DNS::View->__new__();
        push @_return_fields, tField('view', {
                                                 sub_fields => $tmp->__return_fields__(),
                                                }
                                    );

        $tmp=Infoblox::DNS::Zone->__new__(rpz_policy => 'GIVEN');
        push @_return_fields, tField('response_policy_zones', {
                                                 sub_fields => $tmp->__return_fields__(),
                                               }
                                    );
    }
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

sub __search_override_hook__ {
    my ($object_type, $session, $args_ref) = @_;
    set_error_codes(1008, "'search' not allowed for this object", $session);
    return;
}

sub __remove_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'remove' not allowed for this object", $session);
    return;
}

#
#
#
