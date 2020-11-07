package Infoblox::Grid::NTPKey;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    register_wsdl_type('ib:NtpAuthKey','Infoblox::Grid::NTPKey');
    %_allowed_members = (
                         key_string => 0,
                         key_type   => 0,
                         key_number => 0,
                        );

    %_name_mappings = (
                       key_string => 'string',
                       key_type   => 'type',
                       key_number => 'number',

                       #
                       M => 'MD5_ASCII',
                       S => 'DES_HEX',
                       A => 'DES_ASCII',
                       N => 'DES_NTP',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       type => \&__i2o_type__,
      );

    %_object_to_ibap =
      (
       key_string => \&ibap_o2i_string,
       key_type   => \&__o2i_type__,
       key_number => \&ibap_o2i_uint,
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

    #
    $self->key_type('M') unless defined $self->key_type();

}

sub __i2o_type__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    return $_reverse_name_mappings{$$ibap_object_ref{$current}};
}

sub __o2i_type__
{
    my ($self, $session, $current, $tempref) = @_;

    return (1,0, ibap_value_o2i_string($_name_mappings{uc($$tempref{$current})}));
}

#
#
#

sub key_number
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'key_number', validator => \&ibap_value_o2i_uint}, @_);
}

sub key_string
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'key_string', validator => \&ibap_value_o2i_string}, @_);
}

sub key_type
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'key_type', enum => ['M','S','A','N','m','s','a','n'] }, @_);
}




package Infoblox::Grid::NTPServer;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    register_wsdl_type('ib:ntp_server','Infoblox::Grid::NTPServer');
    %_allowed_members = (
                         ntp_key        => 0,
                         authentication => 0,
                         address        => 0,
                         burst          => 0,
                         iburst         => 0,
                        );

    %_name_mappings = (
                       authentication => 'authentication_enabled',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       authentication_enabled => \&ibap_i2o_boolean,
       ntp_key                => \&__i2o_key__,
       burst                  => \&ibap_i2o_boolean,
       iburst                 => \&ibap_i2o_boolean,
      );

    %_object_to_ibap =
      (
       ntp_key        => \&__o2i_key__,
       authentication => \&ibap_o2i_boolean,
       address        => \&ibap_o2i_string,
       burst          => \&ibap_o2i_boolean,
       iburst         => \&ibap_o2i_boolean,
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

    #
    $self->authentication('false') unless defined $self->authentication();

}

sub __i2o_key__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    #
    return Infoblox::Grid::NTPKey->new(key_number => $$ibap_object_ref{$current}, key_string => 'NOTRETRIEVED');
}

sub __o2i_key__
{
    my ($self, $session, $current, $tempref) = @_;

    my %substruct;
    if($$tempref{$current}) {
        return(1,0,ibap_value_o2i_int($$tempref{$current}->key_number()));
    }
    else {
        return (1,1,undef);
    }
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'burst'}  = 0 unless defined $$ibap_object_ref{'burst'};
    $$ibap_object_ref{'iburst'} = 0 unless defined $$ibap_object_ref{'iburst'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

#
#
#

sub address
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'address', validator => \&ibap_value_o2i_string}, @_);
}

sub authentication
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'authentication', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ntp_key
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ntp_key', validator => { 'Infoblox::Grid::NTPKey' => 1 }}, @_);
}

sub burst
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'burst', validator => \&ibap_value_o2i_boolean}, @_);
}

sub iburst
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'iburst', validator => \&ibap_value_o2i_boolean}, @_);
}

1;
