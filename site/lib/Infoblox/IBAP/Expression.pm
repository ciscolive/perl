# Copyright (c) 2017 Infoblox Inc. All Rights Reserved.

package Infoblox::Grid::ExpressionBase;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            @ISA
            $_object_type
            %_allowed_members
            %_object_to_ibap
            %_ibap_to_object
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'papi_expression_base';
    register_wsdl_type('ib:papi_expression_base', 'Infoblox::Grid::ExpressionBase');



    %_allowed_members = (
                         'op'       => {mandatory => 1, simple => 'asis', enum => [
                                 'AND', 'ENDLIST', 'GT', 'LT', 'LE', 'GE', 'MATCH_IP', 'MATCH_RANGE', 'MATCH_CIDR', 'EQ', 'EXISTS', 'NOT_EQ', 'NOT_EXISTS', 'OR', 
                         ]},
                         'op1_type' => {simple => 'asis', enum => ['FIELD', 'LIST', 'STRING']},
                         'op2'      => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'op2_type' => {simple => 'asis', enum => ['FIELD', 'LIST', 'STRING']},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = ();

    %_object_to_ibap = (
                        'op'       => \&ibap_o2i_string_skip_undef,
                        'op1_type' => \&ibap_o2i_string_skip_undef,
                        'op2'      => \&ibap_o2i_string_skip_undef,
                        'op2_type' => \&ibap_o2i_string_skip_undef,
    );

    @_return_fields = (
                       tField('op'),
                       tField('op1_type'),
                       tField('op2'),
                       tField('op2_type'),
    );
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
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


package Infoblox::Grid::ExpressionOp;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
            @ISA
            $_object_type
            %_allowed_members
            %_object_to_ibap
            %_ibap_to_object
            @_return_fields
);

@ISA = qw( Infoblox::Grid::ExpressionBase );

BEGIN {

    $_object_type = 'expression_op';
    register_wsdl_type('ib:expression_op', 'Infoblox::Grid::ExpressionOp');

    %_allowed_members = (
                         'op1' => {simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = ();

    %_object_to_ibap = (
                        'op1' => \&ibap_o2i_string_skip_undef,
    );

    @_return_fields = (
                       tField('op1'),
    );

    Infoblox::IBAPBase::subclass('Infoblox::Grid::ExpressionBase', $_object_type);
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
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

sub __ibap_object_type__ {

    return $_object_type;
}


package Infoblox::Grid::EAExpressionOp;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
            @ISA
            $_object_type
            %_allowed_members
            %_object_to_ibap
            %_ibap_to_object
            @_return_fields
);

@ISA = qw( Infoblox::Grid::ExpressionBase );

BEGIN {

    $_object_type = 'ea_expression_op';
    register_wsdl_type('ib:ea_expression_op', 'Infoblox::Grid::EAExpressionOp');

    %_allowed_members = (
                         'op1' => {validator => {'Infoblox::Grid::ExtensibleAttributeDef' => 1}},
                         'op'  => {simple => 'asis', enum => ['AND', 'ENDLIST', 'EQ', 'EXISTS', 'NOT_EQ', 'NOT_EXISTS', 'OR']},
    );
    
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_ibap_to_object = (
                        'op1' => \&ibap_i2o_generic_object_convert_partial,
    );

    %_object_to_ibap = (
                        'op1' => \&ibap_o2i_object_by_oid_or_name_skip_undef,
    );

    @_return_fields = (
                       tField('op1', {sub_fields => [tField('name')]}),
    );

    Infoblox::IBAPBase::subclass('Infoblox::Grid::ExpressionBase', $_object_type);
}


sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
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

sub __ibap_object_type__ {

    return $_object_type;
}


1;
