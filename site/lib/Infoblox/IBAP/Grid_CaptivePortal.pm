package Infoblox::Grid::Member::CaptivePortal;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'MemberCaptivePortal';
    register_wsdl_type('ib:MemberCaptivePortal','Infoblox::Grid::Member::CaptivePortal');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members =
      (
       authn_server_group           => 0,
       company_name                 => 0,
       enable_syslog_auth_failure   => 0,
       enable_syslog_auth_success   => 0,
       enable_user_type             => 0,
       encryption                   => 1,
       files                        => {validator => {'Infoblox::Grid::Member::CaptivePortal::File' => 1}, array => 1, skip_accessor => 1},
       guest_custom_field1_name     => 0,
       guest_custom_field1_required => 0,
       guest_custom_field2_name     => 0,
       guest_custom_field2_required => 0,
       guest_custom_field3_name     => 0,
       guest_custom_field3_required => 0,
       guest_custom_field4_name     => 0,
       guest_custom_field4_required => 0,
       guest_email_required         => 0,
       guest_first_name_required    => 0,
       guest_last_name_required     => 0,
       guest_middle_name_required   => 0,
       guest_phone_required         => 0,
       helpdesk_message             => 0,
       listen_address               => 0,
       name                         => -1,
       network_view                 => 0,
       port                         => 0,
       service_enabled              => 0,
       syslog_auth_failure_level    => 0,
       syslog_auth_success_level    => 0,
       welcome_message              => 0,
      );

    %_name_mappings =
      (
       'name'  => 'grid_member',
       'files' => 'customization_files',
       'port' => 'backend_port',
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           name       => [\&ibap_o2i_member_byhostname,'grid_member', 'EXACT'],
                          );

	%_return_field_overrides =
      (
       authn_server_group           => [],
       authorized_enabled           => [],
       company_name                 => [],
       enable_syslog_auth_failure   => [],
       enable_syslog_auth_success   => [],
       enable_user_type             => [],
       encryption                   => [],
       files                        => [],
       guest_custom_field1_name     => [],
       guest_custom_field1_required => [],
       guest_custom_field2_name     => [],
       guest_custom_field2_required => [],
       guest_custom_field3_name     => [],
       guest_custom_field3_required => [],
       guest_custom_field4_name     => [],
       guest_custom_field4_required => [],
       guest_email_required         => [],
       guest_first_name_required    => [],
       guest_last_name_required     => [],
       guest_middle_name_required   => [],
       guest_phone_required         => [],
       helpdesk_message             => [],
       listen_address               => [],
       name                         => [],
       network_view                 => [],
       port                         => [],
       service_enabled              => [],
       syslog_auth_failure_level    => [],
       syslog_auth_success_level    => [],
       welcome_message              => [],
      );

    %_ibap_to_object =
      (
       authn_server_group           => \&ibap_i2o_generic_object_convert,
       enable_guest                 => \&ibap_i2o_boolean,
       enable_syslog_auth_failure   => \&ibap_i2o_boolean,
       enable_syslog_auth_success   => \&ibap_i2o_boolean,
       enable_user_type             => \&ibap_i2o_enums_ucfirst_or_undef,
       encryption                   => \&__i2o_encryption__,
       customization_files          => \&ibap_i2o_generic_object_list_convert,
       grid_member                  => \&ibap_i2o_member_byhostname,
       guest_custom_field1_required => \&ibap_i2o_boolean,
       guest_custom_field2_required => \&ibap_i2o_boolean,
       guest_custom_field3_required => \&ibap_i2o_boolean,
       guest_custom_field4_required => \&ibap_i2o_boolean,
       guest_email_required         => \&ibap_i2o_boolean,
       guest_first_name_required    => \&ibap_i2o_boolean,
       guest_last_name_required     => \&ibap_i2o_boolean,
       guest_middle_name_required   => \&ibap_i2o_boolean,
       guest_phone_required         => \&ibap_i2o_boolean,
       listen_address               => \&__i2o_listen_address__,
       network_view                 => \&__i2o_name__,
       service_enabled              => \&ibap_i2o_boolean,
       syslog_auth_failure_level    => \&ibap_i2o_enums_lc_or_undef,
       syslog_auth_success_level    => \&ibap_i2o_enums_lc_or_undef,
      );

    %_object_to_ibap =
      (
       authn_server_group           => \&__o2i_sgroup__,
       company_name                 => \&ibap_o2i_string,
       enable_syslog_auth_failure   => \&ibap_o2i_boolean,
       enable_syslog_auth_success   => \&ibap_o2i_boolean,
       enable_user_type             => \&ibap_o2i_enums_lc_or_undef,
       encryption                   => \&ibap_o2i_enums_lc_or_undef,
       files                        => \&ibap_o2i_generic_struct_list_convert,
       guest_custom_field1_name     => \&ibap_o2i_string,
       guest_custom_field1_required => \&ibap_o2i_boolean,
       guest_custom_field2_name     => \&ibap_o2i_string,
       guest_custom_field2_required => \&ibap_o2i_boolean,
       guest_custom_field3_name     => \&ibap_o2i_string,
       guest_custom_field3_required => \&ibap_o2i_boolean,
       guest_custom_field4_name     => \&ibap_o2i_string,
       guest_custom_field4_required => \&ibap_o2i_boolean,
       guest_email_required         => \&ibap_o2i_boolean,
       guest_first_name_required    => \&ibap_o2i_boolean,
       guest_last_name_required     => \&ibap_o2i_boolean,
       guest_middle_name_required   => \&ibap_o2i_boolean,
       guest_phone_required         => \&ibap_o2i_boolean,
       helpdesk_message             => \&ibap_o2i_string,
       listen_address               => \&__o2i_listen_address__,
       name                         => \&ibap_o2i_member_byhostname,
       network_view                 => \&ibap_o2i_network_view,
       port                         => \&ibap_o2i_integer,
       service_enabled              => \&ibap_o2i_boolean,
       syslog_auth_failure_level    => \&ibap_o2i_enums_lc_or_undef,
       syslog_auth_success_level    => \&ibap_o2i_enums_lc_or_undef,
       welcome_message              => \&ibap_o2i_string,
      );

    $_return_fields_initialized = 0;
    @_return_fields =
      (
       tField('grid_member', return_fields_member_basic_data()),
       tField('service_enabled'),
       tField('listen_address', {
                                 sub_fields => [
                                                tField('type'),
                                                tField('additional_ip',
                                                       {
                                                        sub_fields => [
                                                                       tField('ipv4_network_setting',
                                                                              {
                                                                               sub_fields => [tField('address')]
                                                                              }
                                                                             )
                                                                      ]
                                                       }
                                                      ),
                                               ]
                                }
             ),
       tField('network_view', {sub_fields => [tField('name')]}),
       tField('encryption'),
       tField('enable_syslog_auth_success'),
       tField('enable_user_type'),
       tField('syslog_auth_success_level'),
       tField('enable_syslog_auth_failure'),
       tField('syslog_auth_failure_level'),
       tField('guest_first_name_required'),
       tField('guest_middle_name_required'),
       tField('guest_last_name_required'),
       tField('guest_email_required'),
       tField('guest_phone_required'),
       tField('guest_custom_field1_name'),
       tField('guest_custom_field1_required'),
       tField('guest_custom_field2_name'),
       tField('guest_custom_field2_required'),
       tField('guest_custom_field3_name'),
       tField('guest_custom_field3_required'),
       tField('guest_custom_field4_name'),
       tField('guest_custom_field4_required'),
       tField('company_name'),
       tField('welcome_message'),
       tField('helpdesk_message'),
       tField('backend_port'),
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

	unless ($_return_fields_initialized) {
		$_return_fields_initialized=1;

        #
        my $t=Infoblox::Grid::Member::CaptivePortal::File->__new__();
        push @_return_fields,
          tField('customization_files',
                 {
                  sub_fields => $t->__return_fields__(),
                 }
                );

        my $tr=Infoblox::Grid::Admin::RadiusAuthService->__new__();
        my $tad=Infoblox::Grid::Admin::AdAuthService->__new__();
        my $ldap=Infoblox::LDAP::AuthService->__new__();

        push @_return_fields,
          tField('authn_server_group',
                 {
                  default_no_access_ok => 1,
                  sub_fields => [
                                 tFieldObjType('AdAuthService',
                                               {
                                                sub_fields => $tad->__return_fields__()
                                               }
                                              ),
                                 tFieldObjType('RadiusAuthService',
                                               {
                                                sub_fields => $tr->__return_fields__()
                                               }
                                              ),
                                 tFieldObjType('LdapAuthService',
                                               {
                                                sub_fields => $ldap->__return_fields__()
                                               }
                                              ),
                                ]
                 }
                );
    }

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                             \%_reverse_name_mappings,
                                             \%_searchable_fields,
                                             \%_ibap_to_object,
                                             \%_object_to_ibap,
                                             \@_return_fields,
                                             \%_return_field_overrides
                                            );

    #
    $self->service_enabled('false') unless defined $self->service_enabled();
    $self->enable_syslog_auth_success('true') unless defined $self->enable_syslog_auth_success();
    $self->syslog_auth_success_level('info') unless defined $self->syslog_auth_success_level();
    $self->enable_syslog_auth_failure('false') unless defined $self->enable_syslog_auth_failure();
    $self->syslog_auth_failure_level('info') unless defined $self->syslog_auth_failure_level();
    $self->guest_first_name_required('true') unless defined $self->guest_first_name_required();
    $self->guest_middle_name_required('false') unless defined $self->guest_middle_name_required();
    $self->guest_last_name_required('true') unless defined $self->guest_last_name_required();
    $self->guest_email_required('true') unless defined $self->guest_email_required();
    $self->guest_phone_required('true') unless defined $self->guest_phone_required();
    $self->guest_custom_field1_required('false') unless defined $self->guest_custom_field1_required();
    $self->guest_custom_field2_required('false') unless defined $self->guest_custom_field2_required();
    $self->guest_custom_field3_required('false') unless defined $self->guest_custom_field3_required();
    $self->guest_custom_field4_required('false') unless defined $self->guest_custom_field4_required();
    $self->port(4433) unless defined $self->port();
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

sub __i2o_name__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return $ibap_object_ref->{$current}->{'name'};
}

sub __i2o_encryption__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($$ibap_object_ref{$current}) {
        if ($$ibap_object_ref{$current} eq 'SSL') {
            return 'SSL';
        }
        else {
            return 'None';
        }
    } else {
        return undef;
    }
}

sub __i2o_listen_address__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($$ibap_object_ref{$current}) {
        if ($$ibap_object_ref{$current}{'type'} eq 'IP') {
            return $$ibap_object_ref{$current}{'additional_ip'}{'ipv4_network_setting'}{'address'};
        }
        else {
            return $$ibap_object_ref{$current}{'type'};
        }
    } else {
        return undef;
    }
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;


    $$ibap_object_ref{'service_enabled'} = 0 unless defined $$ibap_object_ref{'service_enabled'};
    $$ibap_object_ref{'enable_syslog_auth_success'} = 0 unless defined $$ibap_object_ref{'enable_syslog_auth_success'};
    $$ibap_object_ref{'enable_syslog_auth_failure'} = 0 unless defined $$ibap_object_ref{'enable_syslog_auth_failure'};
    $$ibap_object_ref{'guest_first_name_required'} = 0 unless defined $$ibap_object_ref{'guest_first_name_required'};
    $$ibap_object_ref{'guest_middle_name_required'} = 0 unless defined $$ibap_object_ref{'guest_middle_name_required'};
    $$ibap_object_ref{'guest_last_name_required'} = 0 unless defined $$ibap_object_ref{'guest_last_name_required'};
    $$ibap_object_ref{'guest_email_required'} = 0 unless defined $$ibap_object_ref{'guest_email_required'};
    $$ibap_object_ref{'guest_phone_required'} = 0 unless defined $$ibap_object_ref{'guest_phone_required'};
    $$ibap_object_ref{'guest_custom_field1_required'} = 0 unless defined $$ibap_object_ref{'guest_custom_field1_required'};
    $$ibap_object_ref{'guest_custom_field2_required'} = 0 unless defined $$ibap_object_ref{'guest_custom_field2_required'};
    $$ibap_object_ref{'guest_custom_field3_required'} = 0 unless defined $$ibap_object_ref{'guest_custom_field3_required'};
    $$ibap_object_ref{'guest_custom_field4_required'} = 0 unless defined $$ibap_object_ref{'guest_custom_field4_required'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

	return;
}

#
#
#

sub __o2i_listen_address__
{
    my ($self, $session, $current, $tempref) = @_;
    my %struct;

    if (is_ipv4_address($$tempref{$current})) {
        $struct{'type'} = ibap_value_o2i_string('IP');
        $struct{'additional_ip'} = ibap_readfield_simple(
                                                         'MemberAdditionalIp',
                                                         [
                                                          {
                                                           field       => 'parent',
                                                           search_type => 'EXACT',
                                                           value       => ibap_readfield_simple_string('Member','host_name',$tempref->{'name'})
                                                          },
                                                          {
                                                           field       => 'type',
                                                           search_type => 'EXACT',
                                                           value       => ibap_value_o2i_string('LOOPBACK')
                                                          },
                                                          {
                                                           field => 'ipv4_network_setting',
                                                           value => tIBType('SubMatch',
                                                                            {
                                                                             search_fields =>
                                                                             [
                                                                              {
                                                                               field => 'address',
                                                                               value => ibap_value_o2i_string($$tempref{$current})
                                                                              }
                                                                             ]
                                                                            }
                                                                           ),
                                                           search_type => 'EXACT'
                                                          }
                                                         ]
                                                        );
    }
    else {
        $struct{'type'} = ibap_value_o2i_string(uc($$tempref{$current}));
    }

    return (1,0, tIBType('captive_portal_listen_address',\%struct));
}

sub __o2i_sgroup__
{
	my ($self, $session, $current, $tempref, $type) = @_;

    if ($$tempref{$current}) {
        if ($$tempref{$current}->__object_id__()) {
            return (1,0,tObjId($$tempref{$current}->__object_id__()));
        }
        else {
            my %types = (
                'Infoblox::Grid::Admin::AdAuthService'     => 'AdAuthService',
                'Infoblox::Grid::Admin::RadiusAuthService' => 'RadiusAuthService',
                'Infoblox::LDAP::AuthService'              => 'LdapAuthService',
            );

            if ($types{ref($$tempref{$current})}) {
                return (1, 0, ibap_readfield_simple_string($types{ref($$tempref{$current})}, 'name', $$tempref{$current}->name(),'authn_server_group'));
            } else {
                set_error_codes(1103, ref($$tempref{$current})." is not a valid object type for $current member", $self);
                return (0);
            }
        }
    }
    else {
        return (1,0,undef);
    }
}

#
#
#


sub authn_server_group
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'authn_server_group', validator => { 'Infoblox::Grid::Admin::AdAuthService' => 1, 'Infoblox::Grid::Admin::RadiusAuthService' => 1, 'Infoblox::LDAP::AuthService' => 1}}, @_);
}

sub company_name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'company_name', validator => \&ibap_value_o2i_string}, @_);
}

sub enable_syslog_auth_failure
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_syslog_auth_failure', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_syslog_auth_success
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_syslog_auth_success', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_user_type
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_user_type', enum => ['Authenticated','Guest','Both'] }, @_);
}

sub encryption
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'encryption', enum => ['None','SSL'] }, @_);
}

sub files
{
    my $self=shift;
    return $self->__accessor_array__({name => 'files', validator => { 'Infoblox::Grid::Member::CaptivePortal::File' => 1}}, @_);
}

sub guest_custom_field1_name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_custom_field1_name', validator => \&ibap_value_o2i_string}, @_);
}

sub guest_custom_field1_required
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_custom_field1_required', validator => \&ibap_value_o2i_boolean}, @_);
}

sub guest_custom_field2_name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_custom_field2_name', validator => \&ibap_value_o2i_string}, @_);
}

sub guest_custom_field2_required
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_custom_field2_required', validator => \&ibap_value_o2i_boolean}, @_);
}

sub guest_custom_field3_name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_custom_field3_name', validator => \&ibap_value_o2i_string}, @_);
}

sub guest_custom_field3_required
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_custom_field3_required', validator => \&ibap_value_o2i_boolean}, @_);
}

sub guest_custom_field4_name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_custom_field4_name', validator => \&ibap_value_o2i_string}, @_);
}

sub guest_custom_field4_required
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_custom_field4_required', validator => \&ibap_value_o2i_boolean}, @_);
}

sub guest_email_required
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_email_required', validator => \&ibap_value_o2i_boolean}, @_);
}

sub guest_first_name_required
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_first_name_required', validator => \&ibap_value_o2i_boolean}, @_);
}

sub guest_last_name_required
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_last_name_required', validator => \&ibap_value_o2i_boolean}, @_);
}

sub guest_middle_name_required
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_middle_name_required', validator => \&ibap_value_o2i_boolean}, @_);
}

sub guest_phone_required
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'guest_phone_required', validator => \&ibap_value_o2i_boolean}, @_);
}

sub helpdesk_message
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'helpdesk_message', validator => \&ibap_value_o2i_string}, @_);
}

sub listen_address
{
    my $self=shift;

    #
    return $self->{'listen_address'} if( @_ == 0 );

    if ($_[0] eq 'VIP' || $_[0] eq 'LAN2') {
        return $self->__accessor_scalar__({name => 'listen_address', validator => \&ibap_value_o2i_string}, @_);
    }
    else {
        return $self->__accessor_scalar__({name => 'listen_address', validator => \&ibap_value_o2i_ipv4addr}, @_);
    }
}

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string, readonly => 1}, @_);
}

sub network_view
{
    my $self = shift;

    return $self->__accessor_scalar__({name => 'network_view', validator => \&ibap_value_o2i_string}, @_);
}

sub port {
    my $self=shift;
    return $self->__accessor_scalar__({name => 'port', validator => \&ibap_value_o2i_uint}, @_);
}

sub service_enabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'service_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub syslog_auth_failure_level
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'syslog_auth_failure_level', enum => \@syslog_enum_values }, @_);
}

sub syslog_auth_success_level
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'syslog_auth_success_level', enum => \@syslog_enum_values }, @_);
}

sub welcome_message
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'welcome_message', validator => \&ibap_value_o2i_string}, @_);
}


package Infoblox::Grid::Member::CaptivePortal::File;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields $_object_type);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    $_object_type = 'captive_portal_file';
    register_wsdl_type('ib:captive_portal_file','Infoblox::Grid::Member::CaptivePortal::File');
    %_allowed_members = (
                         name => -1,
                         type => -1,
                        );

    %_name_mappings = (
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       type => \&__i2o_type__,
      );

    %_object_to_ibap =
      (
       name => \&ibap_o2i_string,
       type => \&__o2i_type__,
      );

    @_return_fields =
      (
       tField('name'),
       tField('type'),
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

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                             \%_reverse_name_mappings,
                                             undef,
                                             \%_ibap_to_object,
                                             \%_object_to_ibap,
                                             \@_return_fields,
                                            );
}


sub __i2o_type__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if ($$ibap_object_ref{$current} eq 'AUP') {
        return 'AUP';
    }
    else {
        $$ibap_object_ref{$current} =~ m/^IMG_(.*)/;
        return ucfirst(lc($1));
    }
}

sub __o2i_type__
{
    my ($self, $session, $current, $tempref) = @_;

    if ($$tempref{$current} ne 'AUP') {
        return (1,0, ibap_value_o2i_string('IMG_' . uc($$tempref{$current})));
    }
    else {
        return (1,0, ibap_value_o2i_string($$tempref{$current}));
    }
}

sub __ibap_object_type__ {

    return $_object_type;
}

#
#
#

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub type
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'type', readonly => 1, enum => ['Header','Footer','Logo','AUP'] }, @_);
}

1;
