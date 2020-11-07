package Infoblox::DNS::Ruleset::NxdomainRule;

use strict;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides
            %_capabilities);

@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'nxdomain_rule_struct';
    register_wsdl_type('ib:nxdomain_rule_struct', 'Infoblox::DNS::Ruleset::NxdomainRule');

    %_capabilities = (
                      'depth'                  => 0,
                      'implicit_defaults'      => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         pattern           => 1 ,
                         action           => 1 ,
                        );

    %_name_mappings = ();

    %_ibap_to_object = ();

    %_searchable_fields = (
                           pattern  => [\&ibap_o2i_string,'pattern', 'REGEX', 'IGNORE_CASE'],
                           action => [\&ibap_o2i_enums_lc_or_undef, 'action', 'EXACT'],
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                pattern         => [],
                                action         => [],
                               );


    %_object_to_ibap = (
                        pattern       => \&ibap_o2i_string,
                        action       => \&ibap_o2i_enums_lc_or_undef,
                       );

    @_return_fields = (
                       tField('pattern'),
                       tField('action'),
                      );
};

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

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                                \%_reverse_name_mappings,
                                                \%_searchable_fields,
                                                \%_ibap_to_object,
                                                \%_object_to_ibap,
                                                \@_return_fields,
                                                \%_return_field_overrides);

    #
    $self->{'__initializing_from_ibap__'}=1;
    $self->pattern('') unless defined $self->pattern();
    $self->action('PASS') unless defined $self->action();
    delete $self->{'__initializing_from_ibap__'};
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
#
#
sub pattern
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'pattern', validator => \&ibap_value_o2i_string}, @_);
}

sub action
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'action', enum => [ 'PASS', 'REDIRECT', 'MODIFY']}, @_);
}

package Infoblox::DNS::Ruleset;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides
            %_capabilities $_return_fields_initialized);

@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'Ruleset';
    register_wsdl_type('ib:Ruleset', 'Infoblox::DNS::Ruleset');

    %_capabilities = (
                      'depth'                  => 0,
                      'implicit_defaults'      => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         name           => 1,
                         type           => 1,
                         disabled       => 0,
                         comment        => 0,
                         nxdomain_rules => {validator => {'Infoblox::DNS::Ruleset::NxdomainRule' => 1}, skip_accessor => 1},
                        );

    %_name_mappings = ();

    %_ibap_to_object = (
                        'disabled' => \&ibap_i2o_boolean,
                        'nxdomain_rules' => \&ibap_i2o_generic_object_list_convert ,
                       );

    %_searchable_fields = (
                           name  => [\&ibap_o2i_string,'name', 'REGEX', 'IGNORE_CASE'],
                           type  => [\&ibap_o2i_string,'type', 'EXACT'],
                           disabled => [\&ibap_o2i_boolean,'disabled'   , 'EXACT'],
                           comment  => [\&ibap_o2i_string,'comment', 'REGEX', 'IGNORE_CASE'],
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                name         => [],
                                type         => [],
                                disabled         => [],
                                comment         => [],
                                nxdomain_rules         => [],
                               );


    %_object_to_ibap = (
                        name => \&ibap_o2i_string,
                        type => \&ibap_o2i_string,
                        disabled => \&ibap_o2i_boolean,
                        comment => \&ibap_o2i_string,
                        nxdomain_rules => \&ibap_o2i_generic_struct_list_convert,
                       );

	$_return_fields_initialized=0;
    @_return_fields = (
                       tField('name'),
                       tField('type'),
                       tField('disabled'),
                       tField('comment'),
                       );
};

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
        my $t=Infoblox::DNS::Ruleset::NxdomainRule->__new__();
        push @_return_fields,
          tField('nxdomain_rules', {
                                    sub_fields => $t->__return_fields__(),
                                   }
                );
	}

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                                \%_reverse_name_mappings,
                                                \%_searchable_fields,
                                                \%_ibap_to_object,
                                                \%_object_to_ibap,
                                                \@_return_fields,
                                                \%_return_field_overrides);

    #
    $self->{'__initializing_from_ibap__'}=1;
    $self->comment('') unless defined $self->comment();
    $self->disabled('false') unless defined $self->disabled();
    delete $self->{'__initializing_from_ibap__'};
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
#
#
sub name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub type
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'type', enum => [ 'NXDOMAIN', 'BLACKLIST' ]}, @_);
}

sub disabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub comment
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub nxdomain_rules
{
    my $self=shift;
    return $self->__accessor_array__({name => 'nxdomain_rules', validator => { 'Infoblox::DNS::Ruleset::NxdomainRule' => 1 }}, @_);
}
