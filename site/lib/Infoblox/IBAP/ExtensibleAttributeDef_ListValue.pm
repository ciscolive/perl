package Infoblox::Grid::ExtensibleAttributeDef::ListValue;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::PAPIOverrides;
use vars qw( @ISA %_allowed_members );
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    #
    #
    %_allowed_members = (
        'value'         => 1,
        '__old_value__' => 0,
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

sub __ibap_object_type__
{
    return '';
}

#
#
#

sub value
{
    my $self=shift;
    
    if( @_ == 0 )
    {
        return $self->{'value'};
    }
    else
    {
        #
        $self->__old_value__($self->{'value'});

        my $value = shift;
        if( !defined $value )
        {
            $self->{'value'} = undef;
        }
        else
        {
			$self->{'value'} = $value;
		}
	}
	return 1;
}


sub __old_value__
{
    my $self=shift;
    return $self->__accessor_scalar__({name => '__old_value__', validator => \&ibap_value_o2i_string}, @_);
}

1;
