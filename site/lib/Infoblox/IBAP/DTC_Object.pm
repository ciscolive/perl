package Infoblox::DTC::ObjectBase;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            $_object_type
            $_return_fields_initialized
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_return_field_overrides
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    $_object_type = 'DtcObjectBase';

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'abstract_type'         => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         'comment'               => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         'display_type'          => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         'extattrs'              => {readonly => 1, special => 'extensible_attributes'},
                         'extensible_attributes' => {readonly => 1, special => 'extensible_attributes'},
                         'ipv4_address_list'     => {simple => 'asis', readonly => 1, array => 1, validator => \&ibap_value_o2i_string},
                         'ipv6_address_list'     => {simple => 'asis', readonly => 1, array => 1, validator => \&ibap_value_o2i_string},
                         'name'                  => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         'object'                => {validator => {'Infoblox::DTC::LBDN' => 1, 'Infoblox::DTC::Pool' => 1, 'Infoblox::DTC::Server' => 1}},
                         'status'                => {simple => 'asis', readonly => 1, enum => ['NONE', 'GREEN','YELLOW', 'RED', 'BLUE', 'GRAY']},
                         'status_time'           => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
    );

    %_name_mappings = (
                       'extattrs' => 'extensible_attributes',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           'comment'       => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           'name'          => [\&ibap_o2i_string, 'name', 'EXACT'],
                           'status_member' => [\&ibap_o2i_object_by_oid_or_name, 'search_status_member', 'EXACT'],
                           'type'          => [\&ibap_o2i_string, 'search_type', 'EXACT'],
    );

    %_return_field_overrides = (
                                'abstract_type'         => [],
                                'comment'               => [],
                                'display_type'          => [],
                                'extattrs'              => [],
                                'extensible_attributes' => [],
                                'ipv4_address_list'     => [],
                                'ipv6_address_list'     => [],
                                'name'                  => [],
                                'status'                => [],
                                'status_time'           => [],
    );

    %_ibap_to_object = (
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'object'                => \&ibap_i2o_generic_object_convert,
    );

    %_object_to_ibap = (
                        'abstract_type'         => \&ibap_o2i_ignore,
                        'comment'               => \&ibap_o2i_ignore,
                        'display_type'          => \&ibap_o2i_ignore,
                        'extattrs'              => \&ibap_o2i_ignore,
                        'extensible_attributes' => \&ibap_o2i_ignore,
                        'ipv4_address_list'     => \&ibap_o2i_ignore,
                        'ipv6_address_list'     => \&ibap_o2i_ignore,
                        'name'                  => \&ibap_o2i_ignore,
                        'object'                => \&ibap_o2i_ignore,
                        'status'                => \&ibap_o2i_ignore,
                        'status_time'           => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('abstract_type'),
                       tField('comment'),
                       tField('display_type'),
                       tField('extensible_attributes'),
                       tField('ipv4_address_list'),
                       tField('ipv6_address_list'),
                       tField('name'),
                       tField('status'),
                       tField('status_time'),
                       return_fields_extensible_attributes(),
    );

    $_return_fields_initialized = 0;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    $self->__init_instance_constants__();
    return $self;
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    {
        no strict 'refs';

        if (!$self->__initialize_members_from_arg_list__(\%{$class . '::_allowed_members'}, \%args) ||
            !$self->__validate_object_required_members__(\%{$class . '::_allowed_members'}))
        {
            return;
        }

        $self->__init_instance_constants__();
        return $self;
    }
}

sub __ibap_object_type__ {

    my $self = shift;
    my $class = ref $self || $self;

    {
        no strict 'refs';
        return ${$class . '::_object_type'};
    }
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    my $class = ref $self || $self;

    {
        no strict 'refs';
        return ${$class . '::_capabilities'}{$what};
    }
}

sub __init_instance_constants__ {

    my $self = shift;
    my $class = ref $self || $self;

	unless ($_return_fields_initialized) {

        {
            no strict 'refs';
            ${$class . '::_return_fields_initialized'} = 1;
        }

        my @objtype_returnfields;

        foreach my $which (
            'Infoblox::DTC::LBDN',
            'Infoblox::DTC::Server',
            'Infoblox::DTC::Pool',
        ) {
            my $t = $which->__new__();
            push @objtype_returnfields, tFieldObjType(
                $t->__ibap_object_type__, {sub_fields => $t->__return_fields__()});
        }

        {
            no strict 'refs';

            push @{$class . '::_return_fields'}, tField('object', {
                'default_no_access_ok' => 1,
                'sub_fields'           => \@objtype_returnfields,
            });
        }
    }
}

package Infoblox::DTC::Object;

use strict;
use Carp;

use Infoblox::Util;

use vars qw( 
            $_object_type
            $_return_fields_initialized
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_return_field_overrides
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::DTC::ObjectBase );

BEGIN {

    $_object_type = 'LbObject';
    register_wsdl_type('ib:LbObject', 'Infoblox::DTC::Object');

    Infoblox::IBAPBase::subclass('Infoblox::DTC::ObjectBase', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


package Infoblox::LB::ManagedObject;

#

use strict;
use Carp;

use Infoblox::Util;

use vars qw( 
            $_object_type
            $_return_fields_initialized
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_return_field_overrides
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::DTC::ObjectBase );

BEGIN {

    $_object_type = 'LbObject';
    register_wsdl_type('ib:LbObjectDeprecated', 'Infoblox::LB::ManagedObject');

    Infoblox::IBAPBase::subclass('Infoblox::DTC::ObjectBase', 'LbObjectDeprecated');
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}


1;
