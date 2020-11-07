package Infoblox::DNS::FireEye::AlertMap;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Time::Local;
use Infoblox::PAPIOverrides;
use vars qw(@ISA $_object_type %_allowed_members %_return_field_overrides
            %_name_mappings %_reverse_name_mappings %_searchable_fields
            %_ibap_to_object %_object_to_ibap @_return_fields %_capabilities $_return_fields_initialized);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {
    $_object_type = 'fireeye_alert_map';
    register_wsdl_type('ib:fireeye_alert_map', 'Infoblox::DNS::FireEye::AlertMap');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         alert_type => {simple => 'asis', 'mandatory' => 1, enum => [
                                                                                     'INFECTION_MATCH',
                                                                                     'WEB_INFECTION',
                                                                                     'MALWARE_OBJECT',
                                                                                     'DOMAIN_MATCH',
                                                                                     'MALWARE_CALLBACK',
                                                                                    ]},

                         rpz_rule => {simple => 'asis', 'mandatory' => 1, enum => [
                                                                 'PASSTHRU',
                                                                 'NXDOMAIN',
                                                                 'NODATA',
                                                                 'SUBSTITUTE',
                                                                 'NONE',
                                                                ]},
                         lifetime => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_long},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
                                alert_type => [],
                                rpz_rule   => [],
                                lifetime   => [],
                               );

    %_name_mappings = (
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                          );

    %_ibap_to_object = (
                       );

    %_object_to_ibap = (
                         alert_type => \&ibap_o2i_string,
                         rpz_rule => \&ibap_o2i_string,
                         lifetime => \&ibap_o2i_long,
                       );

    @_return_fields = (
                       tField('alert_type'),
                       tField('rpz_rule'),
                       tField('lifetime'),
                      );
}

sub new {
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members)) {
        return;
    }

    return $self;
}

sub __new__ {
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__ {
    return $_object_type;
}

sub __ibap_capabilities__ {
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

package Infoblox::DNS::FireEye::RuleMapping;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Time::Local;
use Infoblox::PAPIOverrides;
use vars qw(@ISA $_object_type %_allowed_members %_return_field_overrides
            %_name_mappings %_reverse_name_mappings %_searchable_fields
            %_ibap_to_object %_object_to_ibap @_return_fields %_capabilities $_return_fields_initialized);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {
    $_object_type = 'fireeye_rule_mapping';
    register_wsdl_type('ib:fireeye_rule_mapping', 'Infoblox::DNS::FireEye::RuleMapping');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         substituted_domain_name  => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         fireeye_alert_mapping => {array => 1, validator => {'Infoblox::DNS::FireEye::AlertMap' => 1}},
                         apt_override => {simple => 'asis', enum => [
                                                                 'NODATA',
                                                                 'NOOVERRIDE',
                                                                 'NXDOMAIN',
                                                                 'PASSTHRU',
                                                                 'SUBSTITUTE',
                                                                ]},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = (
                                enable  => [],
                                message => [],
                               );

    %_name_mappings = (
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                          );

    %_ibap_to_object = (
                        fireeye_alert_mapping  => \&ibap_i2o_generic_object_list_convert,
                       );

    %_object_to_ibap = (
                        fireeye_alert_mapping  => \&ibap_o2i_generic_struct_list_convert,
                        substituted_domain_name  => \&ibap_o2i_string,
                        apt_override => \&ibap_o2i_string,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('substituted_domain_name'),
                       tField('apt_override'),
                      );
}

sub new {
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members)) {
        return;
    }

    $self->__init_instance_constants__();

    return $self;
}

sub __new__ {
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    $self->__init_instance_constants__();

    return $self;
}

sub __init_instance_constants__ {
    my $self = shift;

    unless ($_return_fields_initialized) {
        $_return_fields_initialized=1;

        #
        my $t=Infoblox::DNS::FireEye::AlertMap->__new__();
        push @_return_fields,
          tField('fireeye_alert_mapping',
                 {
                  sub_fields => $t->__return_fields__(),
                 }
                );
    }
}

sub __ibap_object_type__ {
    return $_object_type;
}

sub __ibap_capabilities__ {
    my ($self,$what)=@_;
    return $_capabilities{$what};
}


1;
