package Infoblox::DHCP::Filter::Option;

use strict;

use Carp;
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_name_mappings %_reverse_name_mappings %_searchable_fields %_ibap_to_object %_object_to_ibap @_return_fields %_return_field_overrides %_capabilities);
@ISA = qw(Infoblox::IBAPBase);

BEGIN
{
    $_object_type = 'OptionFilter';
    register_wsdl_type('ib:OptionFilter','Infoblox::DHCP::Filter::Option');

    %_capabilities = (
        depth 				 => 0,
        implicit_defaults 	 => 1,
        single_serialization => 1,
    );

    #
    #
    %_allowed_members = (
        name => 1,
        option_space => 0,
        apply_as_class => 0,
        boot_file => 0,
        boot_server => 0,
        extensible_attributes => 0,
        extattrs              => 0,
        lease_time => 0,
        next_server => 0,
        option_list => 0,
        pxe_lease_time => 0,
        comment => 0,
        expression => 0,
    );

    %_name_mappings = (
        option_list => 'options',
        extattrs    => 'extensible_attributes',
    );

    %_reverse_name_mappings = reverse %_name_mappings;                                

    %_searchable_fields = (
        name => [\&ibap_o2i_string, 'name', 'REGEX'],
        extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        comment => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],
    );
 
    %_ibap_to_object = (
        apply_as_class => \&ibap_i2o_boolean,
        extensible_attributes => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
        option_space => \&__i2o_option_space__,
        options => \&__i2o_options__,
    );
                        
    %_object_to_ibap = (
        apply_as_class => \&ibap_o2i_boolean,
        boot_file => \&ibap_o2i_string,
        boot_server => \&ibap_o2i_string,
        expression  => \&ibap_o2i_string,
        lease_time => \&ibap_o2i_integer,
        name => \&ibap_o2i_string,
        next_server => \&ibap_o2i_string,
        option_list => \&__o2i_option_list__,
        option_space => \&__o2i_option_space__,
        pxe_lease_time => \&ibap_o2i_integer,
        extattrs               => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
        extensible_attributes  => \&ibap_o2i_ignore,
        comment => \&ibap_o2i_string,
    );
    
    @_return_fields = (
        tField('apply_as_class'),
        tField('boot_file'),
        tField('boot_server'),
        tField('comment'),
        tField('expression'),
        tField('lease_time'),
        tField('name'),
        tField('next_server'),
        tField('option_space'),
        tField('options'),
        tField('pxe_lease_time'),
        tField('option_space', {
            sub_fields => [
                tField('name'),
            ],
        }),
        return_fields_extensible_attributes(),
    );

    %_return_field_overrides = (
        apply_as_class => [],
        boot_file => [],
        boot_server => [],
        comment => [],
        extattrs => [],
        extensible_attributes => [],
        expression => [],
        lease_time => [],
        name => [],
        next_server => [],
        option_list => [],
        option_space => [],
        pxe_lease_time => [],
    );
}

sub new
{
    my ( $proto, %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    return $self;
}

sub __new__
{
    my ( $proto, %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self, $class;

    return $self;
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

sub __i2o_option_space__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    return $ibap_object_ref->{$current}{'name'};
}

sub __i2o_options__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @custom_options = map {
        Infoblox::DHCP::Option->new(
            name         => $_->{'name'},
            value        => $_->{'value'},
            vendor_class => $_->{'space'},
        );
    } @{$ibap_object_ref->{$current}};
    return \@custom_options;
}

sub __ibap_to_object__
{       
    my ($self, $ibap_object_ref, @rest) = @_;

    $self->{'option_list'} = [];
    $$ibap_object_ref{'apply_as_class'} = 0 unless defined($$ibap_object_ref{'apply_as_class'});
    

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, @rest);

    return $res;
}

sub __o2i_option_space__
{
    my ($self, $session, $current, $tempref) = @_;
    return (1,0,ibap_readfield_simple_string('OptionSpace', 'name', $tempref->{$current}, 'option_space', 'EXACT'));
}

sub __o2i_option_list__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $tempref->{$current}) {
        if (ref ($tempref->{$current}) eq 'ARRAY') {
            my @opts = map {
                tIBType('custom_option',{
                    name => $_->name(),
                    value => $_->value(),
                    space => $_->vendor_class(),
                });
           } @{$tempref->{$current}};
            @return_args = (1, 0, tIBType('ArrayOfcustom_option', \@opts));
        } else {
            push @return_args, 0;
        }
    }
    else {
        @return_args = (1, 1, undef);
    }
    return @return_args;
}

sub __object_to_ibap__
{
    my ($self, @rest) = @_;
    #
    $self->{'option_space'} = 'DHCP'
        unless defined($self->{'option_space'});

    return $self->SUPER::__object_to_ibap__(@rest);
}

sub apply_as_class {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'apply_as_class', validator => \&ibap_value_o2i_boolean}, @_);
}

sub boot_file { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'boot_file', validator => \&ibap_value_o2i_string}, @_);
}

sub boot_server { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'boot_server', validator => \&ibap_value_o2i_string}, @_);
}

sub lease_time { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'lease_time', validator => \&ibap_value_o2i_int}, @_);
}

sub name { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub next_server { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'next_server', validator => \&ibap_value_o2i_string}, @_);
}

sub option_list { 
    my $self=shift; 
    return $self->__accessor_array__({name => 'option_list', validator => { 'Infoblox::DHCP::Option' => 1 }}, @_);
}

sub option_space { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'option_space', validator => \&ibap_value_o2i_string}, @_);
}

sub pxe_lease_time { 
    my $self=shift; 
    return $self->__accessor_scalar__({name => 'pxe_lease_time', validator => \&ibap_value_o2i_int}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub expression
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'expression', validator => \&ibap_value_o2i_string}, @_);
}

1;
