package Infoblox::IFMap::CACertificate;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides
            %_capabilities);

@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'IfmapCACertificate';
    register_wsdl_type('ib:IfmapCACertificate', 'Infoblox::IFMap::CACertificate');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         certificate     => 1,
                         issuer          => -1,
                         subject         => -1,
                         valid_not_after => -1,
                         valid_not_before => -1,
                        );

    %_name_mappings = (
                      );

    %_ibap_to_object = (
                       );

    %_searchable_fields = (
                              certificate     => [\&ibap_o2i_string, "certificate", 'EXACT'],
                              issuer          => [\&ibap_o2i_string, "issuer", 'REGEX', 'IGNORE_CASE'],
                              subject         => [\&ibap_o2i_string, "subject", 'REGEX', 'IGNORE_CASE'],
                              valid_not_after => [\&ibap_o2i_string_to_datetime, "valid_not_after", 'GLEQ'],
                              valid_not_after_start => [\&ibap_o2i_string_to_datetime, "valid_not_after_start", 'GEQ_valid_not_after'],
                              valid_not_after_end => [\&ibap_o2i_string_to_datetime, "valid_not_after_end", 'LEQ_valid_not_after'],
                              valid_not_before => [\&ibap_o2i_string_to_datetime, "valid_not_before", 'GLEQ'],
                              valid_not_before_start => [\&ibap_o2i_string_to_datetime, "valid_not_before_start", 'GEQ_valid_not_before'],
                              valid_not_before_end => [\&ibap_o2i_string_to_datetime, "valid_not_before_end", 'LEQ_valid_not_before'],
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                 certificate     => [],
                                 issuer          => [],
                                 subject         => [],
                                 valid_not_after => [],
                                 valid_not_before => [],
                               );

    %_object_to_ibap = (
                          certificate     => \&ibap_o2i_string,
                          issuer          => \&ibap_o2i_ignore,
                          subject         => \&ibap_o2i_ignore,
                          valid_not_after => \&ibap_o2i_ignore,
                          valid_not_before => \&ibap_o2i_ignore,
                       );

    @_return_fields = (
                        tField('certificate'),
                        tField('issuer'),
                        tField('subject'),
                        tField('valid_not_after'),
                        tField('valid_not_before'),
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

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

#
#
#


sub __modify_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'modify' not allowed for this object", $session);
    return;
}



#
#
#
sub certificate
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'certificate', validator => \&ibap_value_o2i_string}, @_);
}

sub issuer
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'issuer', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub subject
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'subject', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub valid_not_after
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'valid_not_after', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub valid_not_before
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'valid_not_before', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}


package Infoblox::IFMap::Client::Credentials;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields $_return_fields_initialized $_object_type);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    $_object_type = 'ifmap_client_credentials';
    register_wsdl_type('ib:ifmap_client_credentials','Infoblox::IFMap::Client::Credentials');
    %_allowed_members = (
                         authentication => 1,
                         username       => 0,
                         password       => 0,
                         server_url     => 0,
                         server_ca_cert => 0,
                        );

    %_name_mappings = (
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       authentication => \&__i2o_auth__,
       server_ca_cert => \&ibap_i2o_generic_object_convert,
      );

    %_object_to_ibap =
      (
       authentication => \&__o2i_auth__,
       username       => \&ibap_o2i_string,
       password       => \&ibap_o2i_string_skip_undef,
       server_url     => \&ibap_o2i_string,
       server_ca_cert => \&__o2i_cert__,
      );

    $_return_fields_initialized = 0;
    @_return_fields = (
                       tField('authentication'),
                       tField('username'),
                       #
                       tField('server_url'),
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

        my $t=Infoblox::IFMap::CACertificate->__new__();
        push @_return_fields,
          tField('server_ca_cert', {
                                    sub_fields => $t->__return_fields__(),
                                   }
                );
    }

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                             \%_reverse_name_mappings,
                                             undef,
                                             \%_ibap_to_object,
                                             \%_object_to_ibap,
                                             \@_return_fields,
                                            );

    #
    $self->authentication('basic') unless defined $self->authentication();
}

sub __ibap_object_type__ {

    return $_object_type;
}

#
#
#

sub __i2o_auth__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    if ($$ibap_object_ref{$current} eq 'CERT') {
        return 'certificate';
    } else {
        return lc($$ibap_object_ref{$current});
    }
}

#
#
#

sub __o2i_cert__
{
	my ($self, $session, $current, $tempref) = @_;

	if (not defined $$tempref{$current}) {
        return (1,0, undef);
	} else {
        return (1,0, ibap_readfield_simple_string('IfmapCACertificate','certificate',$$tempref{$current}->certificate(), $current));
	}
}

sub __o2i_auth__ {
    my ($self, $session, $current, $tempref) = @_;

    if ($$tempref{$current} eq 'certificate') {
        return (1,0, ibap_value_o2i_string('CERT'));
    }
    else {
        return (1,0, ibap_value_o2i_string(uc($$tempref{$current})));
    }
}


#
#
#

sub authentication
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'authentication', enum => ['basic', 'certificate']}, @_);
}

sub username
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'username', validator => \&ibap_value_o2i_string}, @_);
}

sub password
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'password', writeonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub server_url
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'server_url', validator => \&ibap_value_o2i_string}, @_);
}

sub server_ca_cert
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'server_ca_cert', validator => { 'Infoblox::IFMap::CACertificate' => 1}}, @_);
}


1;
