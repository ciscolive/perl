package Infoblox::DNS::GlueRecordAddr;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            $_object_type
            %_allowed_members
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_reverse_name_mappings
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'member_view_nat';
    register_wsdl_type('ib:member_view_nat', 'Infoblox::DNS::GlueRecordAddr');

    %_allowed_members = (
        'attach_empty_recursive_view' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
        'glue_record_address'         => {validator => \&ibap_value_o2i_ipaddr, enum => ['interface', 'NAT']},
        'view'                        => {validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
        'glue_record_address' => 'glue_address_choice',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
        tField('attach_empty_recursive_view'),
        tField('glue_address_choice'),
        tField('member_glue_custom_ip'),
        tField('view', {sub_fields => [tField('name')]}),
    );

    %_ibap_to_object = (
        'glue_address_choice' => \&__i2o_glue_record_address__,
        'view'                => \&ibap_i2o_object_name,
    );

    %_object_to_ibap = (
        'view'                        => \&ibap_o2i_view,
        'glue_record_address'         => \&__o2i_glue_record_address__,
        'attach_empty_recursive_view' => \&ibap_o2i_boolean,
    );
}

sub __i2o_glue_record_address__ {

    my ($self, $session, $current,
        $ibap_object_ref, $return_object_cache_ref) = @_;

    my $choice = $$ibap_object_ref{$current};

    if    ($choice eq 'INTERFACE') { return 'interface' }
    elsif ($choice eq 'NAT')       { return 'NAT' }
    else                           { return $$ibap_object_ref{'member_glue_custom_ip'} }
}

sub __o2i_glue_record_address__ {

    my ($self, $session, $current, $tempref) = @_;

    if ($$tempref{$current} eq 'interface' or $$tempref{$current} eq 'NAT') {
        return (1, 0, tString(uc $$tempref{$current}));
    } elsif ($$tempref{$current}) {

        return (1, 0, tString('OTHER'), {
            'field' => 'member_glue_custom_ip',
            'value' => tString($$tempref{$current}),
        });
    } else {
        return (1, 1, undef);
    }
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}


1;
