package Infoblox::Grid::ScheduleSetting;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object
                 %_name_mappings %_reverse_name_mappings
                 %_object_to_ibap @_return_fields);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN {
    $_object_type = 'schedule_setting';
    register_wsdl_type('ib:schedule_setting', 'Infoblox::Grid::ScheduleSetting');

    %_allowed_members = (
                         'day_of_month'      => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'disable'           => {'simple' => 'bool', 'validator' => \&ibap_value_o2i_boolean},
                         'every'             => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'frequency'         => {'simple' => 'asis', 'enum' => ['DAILY', 'HOURLY', 'MONTHLY', 'WEEKLY']},
                         'hour_of_day'       => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'minutes_past_hour' => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'month'             => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'year'              => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_uint},
                         'repeat'            => {'simple' => 'asis', 'enum' => ['ONCE', 'RECUR']},
                         'time_zone'         => {'simple' => 'asis', 'validator' => \&ibap_value_o2i_tz},
                         'weekdays'          => {'array' => 1, 'enum' => ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY']},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'disable'  => 'disabled',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'disabled' => \&ibap_i2o_boolean,
                       );

    %_object_to_ibap = (
                        'day_of_month'      => \&ibap_o2i_uint,
                        'disable'           => \&ibap_o2i_boolean,
                        'every'             => \&ibap_o2i_uint,
                        'frequency'         => \&ibap_o2i_string,
                        'hour_of_day'       => \&ibap_o2i_uint,
                        'minutes_past_hour' => \&ibap_o2i_uint,
                        'month'             => \&ibap_o2i_uint,
                        'year'              => \&ibap_o2i_uint,
                        'repeat'            => \&ibap_o2i_string,
                        'time_zone'         => \&ibap_o2i_string,
                        'weekdays'          => \&ibap_o2i_string_array_undef_to_empty,
                       );

    @_return_fields = (
                       tField('day_of_month'),
                       tField('disabled'),
                       tField('every'),
                       tField('frequency'),
                       tField('hour_of_day'),
                       tField('minutes_past_hour'),
                       tField('month'),
                       tField('year'),
                       tField('repeat'),
                       tField('time_zone'),
                       tField('weekdays'),
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
    return $_object_type;
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

1;
