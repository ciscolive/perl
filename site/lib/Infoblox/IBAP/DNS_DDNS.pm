package Infoblox::DNS::DDNS::PrincipalCluster;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
            $_object_type
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

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    $_object_type = 'DdnsPrincipalCluster';
    register_wsdl_type('ib:DdnsPrincipalCluster', 'Infoblox::DNS::DDNS::PrincipalCluster');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'group'      => {mandatory => 1, validator => {string => 1, 'Infoblox::DNS::DDNS::PrincipalCluster::Group' => 1}},
                         'comment'    => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'name'       => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'principals' => {array => 1, validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'comment' => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'name'    => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'group'   => [\&__o2i_principal_cluster_group__, 'parent', 'EXACT'],
    );
    
    %_name_mappings = (
                       'group' => 'parent',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'parent' => \&ibap_i2o_object_name,
    );

    %_object_to_ibap = (
                        'comment'    => \&ibap_o2i_string,
                        'name'       => \&ibap_o2i_string,
                        'principals' => \&ibap_o2i_string_array_undef_to_empty,
                        'group'      => \&__o2i_principal_cluster_group__,
    );

    @_return_fields = (
                       tField('parent', {sub_fields => [tField('name')]}),
                       tField('name'),
                       tField('comment'),
                       tField('principals'),
    );

    %_return_field_overrides = (
                                'comment'    => [],
                                'name'       => [],
                                'principals' => [],
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

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __o2i_principal_cluster_group__ {

    my ($self, $session, $current, $tempref) = @_;

    unless ($$tempref{$current}) {
        set_error_codes(1104, '\'group\' should be defined');
        return (0);
    }

    my $obj = ref $$tempref{$current} ? $$tempref{$current} :
        Infoblox::DNS::DDNS::PrincipalCluster::Group->new(name => $$tempref{$current});

    return (0) unless $obj;

    return ibap_o2i_object_by_oid_or_name(
        $self, $session, 'obj', {obj => $obj});
}


package Infoblox::DNS::DDNS::PrincipalCluster::Group;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
            $_object_type
            $_return_fields_initialized
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_object_to_ibap
            %_return_field_overrides
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    $_object_type = 'DdnsPrincipalGroup';
    register_wsdl_type('ib:DdnsPrincipalGroup', 'Infoblox::DNS::DDNS::PrincipalCluster::Group');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'clusters' => {readonly => 1, array => 1, validator => {'Infoblox::DNS::DDNS::PrincipalCluster' => 1}},
                         'comment'  => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'name'     => {simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'comment' => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'name'    => [\&ibap_o2i_string, 'name', 'REGEX'],
    );

    %_ibap_to_object = (
                        'clusters' => \&ibap_i2o_generic_object_list_convert,
    );

    %_object_to_ibap = (
                        'clusters' => \&ibap_o2i_ignore,
                        'comment'  => \&ibap_o2i_string,
                        'name'     => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('name'),
                       tField('comment'),
    );

    %_return_field_overrides = (
                                'clusters' => [],
                                'comment'  => [],
                                'name'     => [],
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

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    $self->__init_instance_constants__();
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __init_instance_constants__ {

    my $self = shift;

    unless ($_return_fields_initialized) {

        $_return_fields_initialized = 1;

        my $t = Infoblox::DNS::DDNS::PrincipalCluster->__new__();

        push @_return_fields, tField('clusters',
            {sub_fields => $t->__return_fields__()});
    }
}


1;
