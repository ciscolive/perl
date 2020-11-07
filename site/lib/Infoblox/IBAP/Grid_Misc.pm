package Infoblox::Grid::TimeZone;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw( @ISA $_object_type %_allowed_members %_capabilities %_searchable_fields);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_MODIFY_ONLY );

BEGIN {
    $_object_type = 'DateTimeStuff';
    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 0,
					  'single_serialization' => 0,
					 );

    %_searchable_fields = (
                           cluster => [\&ibap_o2i_ignore, 'deprecated', 'DEPRECATED'],
                          );

    %_allowed_members = (
                         ntp_enabled => 0,
                         time_zone   => 1,
                         cluster     => 0, # deprecated
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
    $self->ntp_enabled('false') unless defined $self->ntp_enabled();

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

sub __get_override_hook__ {
    my ($object_type, $session, $args_ref) = @_;
	set_error_codes(0,undef,$session);

    my ($result, %args);
    my $server=$session->get_ibap_server() || return;

    $args{'object_type'} = 'Grid';
    $args{'depth'} = 0;
    $args{'return_fields'} = [
                              tField('time_zone'),
                              tField('ntp_setting',
                                     {
                                      sub_fields => [
                                                     tField('ntp_enabled'),
                                                    ]
                                     })
                             ];

    eval { $result = $server->ObjectRead(\%args); };
    return $server->set_papi_error($@, $session) if $@;

    my $object = $object_type->__new__();
    my $grid=@$result[0];
    if (defined $$grid{'time_zone'} && defined $$grid{'ntp_setting'}{'ntp_enabled'}) {
        $object->time_zone($$grid{'time_zone'});
        $object->ntp_enabled(ibap_value_i2o_boolean($$grid{'ntp_setting'}{'ntp_enabled'}));
        $object->__object_id__($$grid{'object_id'}{'id'});
        return $object;
    }

    #
    set_error_codes(1001,"Unspecified server error in processing request",$session );
    return;
}


sub __modify_override_hook__ {
    my ($object_type, $session, $object) = @_;
	set_error_codes(0,undef,$session);
    my $server=$session->get_ibap_server() || return;

    #
    #
    my $oid=$object->__object_id__();
    unless ($oid) {
        my $t = $session->get("object" => "Infoblox::Grid");
        $oid=$t->__object_id__();
    }

    my @write_fields;
    if (defined $object->ntp_enabled()) {
        my %substruct;
        $substruct{'ntp_enabled'} = ibap_value_o2i_boolean($object->ntp_enabled());

		my %write_arg;
        $write_arg{'field'} = 'ntp_setting';
        $write_arg{'value'} = tIBType('grid_ntp', \%substruct);

        push @write_fields, \%write_arg;
    }

    my %write_arg;
    $write_arg{'field'} = 'time_zone';
    $write_arg{'value'} = ibap_value_o2i_tz($object->time_zone());
    push @write_fields, \%write_arg;

    eval { my $result = $server->ibap_request
             ('ObjectWrite',
              {
               op => 'UPDATE',
               object_ids => [ tObjId($oid) ],
               write_fields => \@write_fields
              }
             );
       };
    return $server->set_papi_error($@, $session) if $@;
    return 1;
}

sub ntp_enabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ntp_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub time_zone
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'time_zone', validator => \&ibap_value_o2i_tz}, @_);
}

sub cluster
{
    my $self=shift;
    return $self->__accessor_scalar__({deprecated => 1}, @_);
}


package Infoblox::Grid::DateTime;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw( @ISA $_object_type %_allowed_members %_capabilities);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_MODIFY_ONLY);

BEGIN {
    $_object_type = 'DateTimeStuff';
    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 0,
					  'single_serialization' => 0,
					 );

    %_allowed_members = (
                         'time'    => 0,
                         'date'    => 0,
                         'cluster' => 0, # deprecated
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

sub __ibap_capabilities__
{
	my ($self,$what)=@_;
	return $_capabilities{$what};
}

sub __get_override_hook__ {
    my ($object_type, $session, $args_ref) = @_;
	set_error_codes(0,undef,$session);

    my $result;
    my $server=$session->get_ibap_server() || return;

    eval { $result = $server->ibap_request('GetDateTime', {}); };
    return $server->set_papi_error($@, $session) if $@;

    my $object = $object_type->__new__();

    if (defined $$result{'datetime'} && $$result{'datetime'} =~ /^(\d\d\d\d)-(\d\d)-(\d\d)T
	               (\d\d):(\d\d):(\d\d(\.\d\d\d)?)
	               (Z|(([+-])(\d\d):(\d\d)))?$/x) {
        $object->date($2.'/'.$3.'/'.$1);
        $object->time($4.':'.$5.':'.$6);
        return $object;
    }

    #
    set_error_codes(1001,"Unspecified server error in processing request",$session );
    return;
}


sub __modify_override_hook__ {
    my ($object_type, $session, $object) = @_;
    my ($date, $time) = ($object->date(), $object->time());
	set_error_codes(0,undef,$session);

    #

    my $server=$session->get_ibap_server() || return;
    unless ($date && $time) {
        my $temp=$session->get( "object" => "Infoblox::Grid::DateTime");
        $date = $temp->date() unless $date;
        $time = $temp->time() unless $time;
    }

	my %fcall_args;
    my $req_date;
    unless ($date =~ m!^(\d\d)/(\d\d)/(\d\d\d\d)$!) {
        set_error_codes(1104,"Invalid value '$date' for member 'date'", $session);
        return;
    }
    $req_date = $3 . '-' . $1 . '-' . $2 . 'T';

    unless ($time =~ m!^(\d\d):(\d\d):(\d\d)$!) {
        set_error_codes(1104,"Invalid value '$date' for member 'date'", $session);
        return;
    }
    $req_date .= $time . 'Z';

    #
    my $t=iso8601_datetime_to_unix_timestamp($req_date);
    $fcall_args{'datetime'} = tDateTime($t);

    eval { my $result = $server->ibap_request('SetDateTime', \%fcall_args); };
    return $server->set_papi_error($@, $session) if $@;

    return 1;
}

sub time
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'time', validator => \&ibap_value_o2i_string}, @_);
}

sub date
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'date', validator => \&ibap_value_o2i_string}, @_);
}

sub cluster
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'cluster', validator => \&ibap_value_o2i_string}, @_);
}

package Infoblox::Grid::KerberosKey;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap %_searchable_fields %_capabilities @_return_fields);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_MODIFY);

BEGIN
{
    $_object_type = 'KerberosKey';
    register_wsdl_type('ib:KerberosKey','Infoblox::Grid::KerberosKey');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 0,
					  'single_serialization' => 0,
					 );

    %_allowed_members = (
                         version   => 0,
                         domain    => 0,
                         principal => 0,
                         enctype   => 0,
                         in_use    => -1,
                         upload_timestamp => -1,
                        );

    %_name_mappings = (
                       version => 'version_number',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
          in_use => \&ibap_i2o_boolean,
          upload_timestamp => \&ibap_i2o_datetime_to_unix_timestamp,
      );

    %_searchable_fields = (
						   principal    => [\&ibap_o2i_string,'principal' , 'REGEX'],
                          );

    %_object_to_ibap =
      (
       version   => \&ibap_o2i_uint,
       domain    => \&ibap_o2i_string,
       principal => \&ibap_o2i_string,
       enctype   => \&ibap_o2i_string,
       in_use    => \&ibap_o2i_ignore,
       upload_timestamp => \&ibap_o2i_ignore,
      );

    @_return_fields =
      (
       tField('domain'),
       tField('version_number'),
       tField('principal'),
       tField('enctype'),
       tField('in_use'),
       tField('upload_timestamp'),
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

sub __ibap_capabilities__
{
	my ($self,$what)=@_;
	return $_capabilities{$what};
}


#
#
#

sub domain
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'domain', validator => \&ibap_value_o2i_string}, @_);
}

sub principal
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'principal', validator => \&ibap_value_o2i_string}, @_);
}

sub version
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'version', validator => \&ibap_value_o2i_uint}, @_);
}

sub enctype
{
    my $self=shift;

    return $self->__accessor_scalar__({name => 'enctype', enum => [
        'aes128-cts-hmac-sha1-96',
        'aes256-cts-hmac-sha1-96',
        'arcfour-hmac-md5',
        'des-cbc-crc',
        'des-cbc-md5',
        'other',
    ]}, @_);
}

sub in_use
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'in_use', readonly => 1}, @_);
}

sub upload_timestamp
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'upload_timestamp', readonly => 1}, @_);
}


package Infoblox::Grid::NTPAccess;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw(@ISA %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    register_wsdl_type('ib:ntp_ac','Infoblox::Grid::NTPAccess');
    %_allowed_members = (
                         address => 0,
                         service => 0,
                        );

    %_name_mappings = (
                       'address' => 'address_ac',

                       #
                       'Time' => 'TIME',
                       'Time and NTP control' => 'TIME_AND_NTPQ',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object =
      (
       address_ac => \&__i2o_address__,
       service    => \&__i2o_service__,
      );

    %_object_to_ibap =
      (
       address => \&__o2i_address__,
       service => \&__o2i_service__,
      );

    @_return_fields = (
        tField('service'),
        tField('address_ac', { sub_fields => [
                                      tField('address_string'),
                                      tField('permission'),
                                     ]}),
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
    $self->service('Time') unless defined $self->service();

}


sub __i2o_address__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    return ibap_value_i2o_address_ac($$ibap_object_ref{$current},'',$session)
}

sub __o2i_address__
{
    my ($self, $session, $current, $tempref) = @_;

    return (1,0, ibap_value_o2i_address_ac($$tempref{$current},'',$session));
}

sub __i2o_service__ {
    my ($self, $session, $current, $ibap_object_ref) = @_;

    return $_reverse_name_mappings{$$ibap_object_ref{$current}};
}

sub __o2i_service__
{
    my ($self, $session, $current, $tempref) = @_;

    return (1,0, ibap_value_o2i_string($_name_mappings{$$tempref{$current}}));
}

#
#
#

sub address
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'address', validator => \&ibap_value_o2i_string}, @_);
}

sub service
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'service', enum => ['Time','Time and NTP control'] }, @_);
}

#
package Infoblox::Grid::X509Certificate;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields %_capabilities %_searchable_fields %_return_field_overrides $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::ADD_MODIFY);

BEGIN {
    $_object_type = 'X509Certificate';
    register_wsdl_type('ib:X509Certificate','Infoblox::Grid::X509Certificate');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         issuer             => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         serial             => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         distinguished_name => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         valid_not_before   => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                         valid_not_after    => {simple => 'asis', readonly => 1, validator => \&ibap_value_o2i_string},
                       );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'distinguished_name' => 'subject',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           serial             => [\&ibap_o2i_string, 'serial', 'EXACT'],
                           issuer             => [\&ibap_o2i_string, 'issuer', 'EXACT'],
                           distinguished_name => [\&ibap_o2i_string, 'subject', 'EXACT'],
                           valid_not_after    => [\&ibap_o2i_string_to_datetime, "valid_not_after", 'GLEQ'],
                           valid_not_before   => [\&ibap_o2i_string_to_datetime, "valid_not_before", 'GLEQ'],
                          );

    %_return_field_overrides =
      (
       issuer             => [],
       serial             => [],
       distinguished_name => [],
       valid_not_before   => [],
       valid_not_after    => [],
      );

    %_ibap_to_object = (
                       );

    %_object_to_ibap = (
                        issuer             => \&ibap_o2i_ignore,
                        serial             => \&ibap_o2i_ignore,
                        distinguished_name => \&ibap_o2i_ignore,
                        valid_not_before   => \&ibap_o2i_ignore,
                        valid_not_after    => \&ibap_o2i_ignore,
                       );

    @_return_fields =
      (
       tField('issuer'),
       tField('serial'),
       tField('subject'),
       tField('valid_not_before'),
       tField('valid_not_after'),
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

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

package Infoblox::Grid::Reporting::IpBlockGroup;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields %_capabilities %_searchable_fields %_return_field_overrides $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'IpBlockGroup';
    register_wsdl_type('ib:IpBlockGroup','Infoblox::Grid::Reporting::IpBlockGroup');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         name    => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         comment => {simple => 'asis', validator => \&ibap_value_o2i_string},
                       );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           name    => [\&ibap_o2i_string, 'name', 'REGEX'],
                           comment => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                          );

    %_return_field_overrides =
      (
       name    => [],
       comment => [],
      );

    %_ibap_to_object = (
                       );

    %_object_to_ibap = (
                        name    => \&ibap_o2i_string,
                        comment => \&ibap_o2i_string,
                       );

    @_return_fields =
      (
       tField('name'),
       tField('comment'),
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

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

package Infoblox::Grid::Reporting::IpBlock;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members %_ibap_to_object %_name_mappings %_reverse_name_mappings %_object_to_ibap @_return_fields %_capabilities %_searchable_fields %_return_field_overrides $_return_fields_initialized);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'IpBlock';
    register_wsdl_type('ib:IpBlock','Infoblox::Grid::Reporting::IpBlock');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         ip_block_group => {mandatory => 1, validator => \&ibap_value_o2i_string},
                         address        => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         comment        => {simple => 'asis', validator => \&ibap_value_o2i_string},
                       );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'address' => 'address_string',
                       'ip_block_group' => 'group',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                           ip_block_group => [\&__o2i_group_search__, 'group', 'SEARCHONLY_LIST_CONTAIN'],
                           address        => [\&ibap_o2i_string, 'address_string', 'REGEX', 'IGNORE_CASE'],
                           comment        => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                          );

    %_return_field_overrides =
      (
       ip_block_group => [],
       address        => [],
       comment        => [],
      );

    %_ibap_to_object = (
                        'group' => \&ibap_i2o_object_name,
                       );

    %_object_to_ibap = (
                        ip_block_group => \&__o2i_group__,
                        comment        => \&ibap_o2i_string,
                        address        => \&ibap_o2i_string,
                       );

    @_return_fields =
      (
       tField('address_string'),
       tField('comment'),
       tField('group',
              {
               sub_fields => [
                              tField('name'),
                             ]
              }
             ),
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

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

sub __o2i_group_search__
{
    my ($self, $session, $current, $tempref, $type) = @_;

    if ($$tempref{$current}) {
        if ($type eq 'search') {
            return (1,0,ibap_readfieldlist_simple_string('IpBlockGroup', 'name', $tempref->{$current}));
        }
        else {
            return (1,0, ibap_readfield_simple_string('IpBlockGroup', 'name', $$tempref{$current},$current));
        }
    }
    else {
        return (1,1,undef);
    }
}

sub __o2i_group__
{
    my ($self, $session, $current, $tempref, $type) = @_;

    if ($$tempref{$current}) {
        return (1,0, ibap_readfield_simple_string('IpBlockGroup', 'name', $$tempref{$current},$current));
    }
    else {
        return (1,0, undef);
    }
}

package Infoblox::Grid::IPValidationInfo;

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

BEGIN
{
    $_object_type = 'ip_validation_info';
    register_wsdl_type('ib:ip_validation_info', 'Infoblox::Grid::IPValidationInfo');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         parent   => {mandatory => 1,
                                      validator => {
                                                    'Infoblox::DHCP::Range'       => 1,
                                                    'Infoblox::DHCP::IPv6Range'   => 1,
                                                    'Infoblox::DHCP::Network'     => 1,
                                                    'Infoblox::DHCP::IPv6Network' => 1,
                                                   }},
                         address  => {validator => \&ibap_value_o2i_ipaddr},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_return_field_overrides = ();
    %_name_mappings = ();
    %_reverse_name_mappings = ();
    %_searchable_fields = ();
    %_ibap_to_object = ();
    %_object_to_ibap = (
                        parent  => \&ibap_o2i_object_by_oid_or_readfield,
                        address => \&ibap_o2i_string,
                       );
    @_return_fields = ();
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
    #
    #
    return $_object_type;
}

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}


package Infoblox::Grid::MaxMindDBInfo;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             @_return_fields
             $_object_type
             %_object_to_ibap
             %_ibap_to_object
             %_name_mappings
             %_reverse_name_mappings
             %_searchable_fields
             %_capabilities
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'MaxMindDBInfo';
    register_wsdl_type('ib:MaxMindDBInfo', 'Infoblox::Grid::MaxMindDBInfo');

    %_allowed_members = (
                         'binary_major_version' => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'binary_minor_version' => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'build_time'           => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'database_type'        => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'deployment_time'      => {readonly => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'topology_type'        => {readonly => 1, simple => 'asis', enum => ['GEOIP', 'EA']},
                         'member'               => {readonly => 1, validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'topology_type' => [\&ibap_o2i_string, 'topology_type', 'EXACT'],
    );

    %_name_mappings = (
                       'build_time'      => 'build_epoch',
                       'deployment_time' => 'maxmind_last_update',
                       'member'          => 'vnode',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('binary_major_version'),
                       tField('binary_minor_version'),
                       tField('build_epoch'),
                       tField('database_type'),
                       tField('maxmind_last_update'),
                       tField('topology_type'),
                       tField('vnode', {sub_fields => [tField('host_name')]}),
    );

    %_ibap_to_object = (
                        'vnode' => \&ibap_i2o_member_name,
    );

    %_object_to_ibap = (
                        'binary_major_verison' => \&ibap_o2i_ignore,
                        'binary_minor_version' => \&ibap_o2i_ignore,
                        'build_time'           => \&ibap_o2i_ignore,
                        'database_type'        => \&ibap_o2i_ignore,
                        'deployment_time'      => \&ibap_o2i_ignore,
                        'topology_type'        => \&ibap_o2i_ignore,
    );
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members)) {

        return;
    }

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

package Infoblox::Grid::DBSnapshot;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            %_allowed_members
            @_return_fields
            $_object_type
            %_object_to_ibap
            %_ibap_to_object
            %_name_mappings
            %_reverse_name_mappings
            %_capabilities
            @ISA
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::GET_ONLY );

BEGIN {

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    $_object_type = 'DBSnapshot';
    register_wsdl_type('ib:DBSnapshot', 'Infoblox::Grid::DBSnapshot');

    %_allowed_members = (
                         'comment'   => {readonly => 1, simple => 'asis'},
                         'timestamp' => {readonly => 1},


    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    @_return_fields = (
                       tField('comment'),
                       tField('timestamp'),
    );

    %_ibap_to_object = (
                        'timestamp' => \&ibap_i2o_datetime_to_unix_timestamp,
    );

    %_object_to_ibap = (
                        'comment'   => \&ibap_o2i_ignore,
                        'timestamp' => \&ibap_o2i_ignore,
    );
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members)) {

        return;
    }

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;

    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

package Infoblox::Grid::ConsentBannerSetting;

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

BEGIN
{
	$_object_type = 'consent_banner_setting';
    register_wsdl_type('ib:consent_banner_setting', 'Infoblox::Grid::ConsentBannerSetting');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members = (
                         enable   => {simple => 'bool', mandatory => 1, validator => \&ibap_value_o2i_boolean},
                         message  => {simple => 'asis', validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

	%_return_field_overrides = (
                                enable  => [],
                                message => [],
                               );

    %_name_mappings = (
                       'enable' => 'enabled',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                          );

    %_ibap_to_object = (
                       );

    %_object_to_ibap = (
                        enable   => \&ibap_o2i_boolean,
                        message  => \&ibap_o2i_string_undef_to_empty,
                       );

    @_return_fields = (
                       tField('enabled'),
                       tField('message'),
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
    #
    #
	return $_object_type;
}

sub __ibap_capabilities__
{
	my ($self,$what)=@_;
	return $_capabilities{$what};
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'enabled'} = 0 unless defined $$ibap_object_ref{'enabled'};
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

package Infoblox::Grid::InformationalBannerSetting;

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

BEGIN
{
	$_object_type = 'informational_banner_setting';
    register_wsdl_type('ib:informational_banner_setting', 'Infoblox::Grid::InformationalBannerSetting');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members = (
                         enable   => {simple => 'bool', mandatory => 1, validator => \&ibap_value_o2i_boolean},
                         color  => {simple => 'asis', enum => ['BLACK', 'BLUE', 'BROWN', 'CYAN', 'GREEN', 'MAGENTA', 'ORANGE', 'PURPLE', 'RED', 'YELLOW']},
                         message  => {simple => 'asis', validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

	%_return_field_overrides = (
                                enable  => [],
                                color  => [],
                                message => [],
                               );

    %_name_mappings = (
                       'enable' => 'enabled',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
                          );

    %_ibap_to_object = (
                       );

    %_object_to_ibap = (
                        enable   => \&ibap_o2i_boolean,
                        color  => \&ibap_o2i_string,
                        message  => \&ibap_o2i_string_undef_to_empty,
                       );

    @_return_fields = (
                       tField('enabled'),
                       tField('color'),
                       tField('message'),
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
    #
    #
	return $_object_type;
}

sub __ibap_capabilities__
{
	my ($self,$what)=@_;
	return $_capabilities{$what};
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'enabled'} = 0 unless defined $$ibap_object_ref{'enabled'};
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

package Infoblox::Grid::RestartBannerSetting;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use Infoblox::PAPIOverrides;

use vars qw( %_allowed_members
             @_return_fields
             $_object_type
             %_ibap_to_object
             %_object_to_ibap
             %_name_mappings
             %_reverse_name_mappings
             @ISA );

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'restart_banner_setting';
    register_wsdl_type('ib:restart_banner_setting', 'Infoblox::Grid::RestartBannerSetting');

    %_allowed_members = (
                         'enable'                     => {mandatory => 1, simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_double_confirmation' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'enable' => 'enabled',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('enabled'),
                       tField('enable_double_confirmation'),
    );

    %_object_to_ibap = (
                        'enable'                     => \&ibap_o2i_boolean,
                        'enable_double_confirmation' => \&ibap_o2i_boolean,
    );
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members)) {

        return;
    }

    return $self;
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    foreach (
        'enable_double_confirmation',
        'enable',
    ) {
        $$ibap_object_ref{$_} = 0 unless defined $$ibap_object_ref{$_};
    }

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::BFD::Template;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
            $_object_type
            %_allowed_members
            %_capabilities
            %_object_to_ibap
            %_return_field_overrides
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    $_object_type = 'BFDTemplate';
    register_wsdl_type('ib:BFDTemplate', 'Infoblox::Grid::BFD::Template');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'authentication_key'    => {writeonly => 1, validator => \&ibap_value_o2i_string},
                         'authentication_key_id' => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'authentication_type'   => {simple => 'asis', enum => ['NONE', 'MD5', 'METICULOUS-MD5', 'SHA1', 'METICULOUS-SHA1']},
                         'detection_multiplier'  => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'min_rx_interval'       => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'min_tx_interval'       => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'name'                  => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'name' => [\&ibap_o2i_string, 'name', 'REGEX'],
    );

    %_object_to_ibap = (
                        'authentication_key'    => \&ibap_o2i_string_skip_undef,
                        'authentication_key_id' => \&ibap_o2i_uint,
                        'authentication_type'   => \&ibap_o2i_string,
                        'detection_multiplier'  => \&ibap_o2i_uint,
                        'min_rx_interval'       => \&ibap_o2i_uint,
                        'min_tx_interval'       => \&ibap_o2i_uint,
                        'name'                  => \&ibap_o2i_string,
    );

    @_return_fields = (
                       tField('name'),
                       tField('authentication_type'),
                       tField('authentication_key_id'),
                       tField('min_tx_interval'),
                       tField('min_rx_interval'),
                       tField('detection_multiplier'),
    );

    %_return_field_overrides = (
                                'name'                  => [],
                                'authentication_type'   => [],
                                'authentication_key_id' => [],
                                'min_tx_interval'       => [],
                                'min_rx_interval'       => [],
                                'detection_multiplier'  => [],
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

package Infoblox::Grid::ObjectsChangesTrackingSetting;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            %_name_mappings
            %_reverse_name_mappings
            @ISA
            @_return_fields
            $_object_type
            %_allowed_members
            %_object_to_ibap
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    $_object_type = 'objects_changes_tracking_setting';
    register_wsdl_type('ib:objects_changes_tracking_setting', 'Infoblox::Grid::ObjectsChangesTrackingSetting');



    %_allowed_members = (
                         'enable'            => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'enable_completion' => {simple => 'asis', readonly => 1},
                         'state'             => {simple => 'asis', readonly => 1, enum => ['ENABLING', 'ENABLED',
                                                 'DISABLED', 'ENABLING_ERROR']},
                         'max_time_to_track' => {simple => 'asis', validator => \&ibap_value_o2i_uint},
                         'max_objs_to_track' => {simple => 'asis', validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'enable' => 'enabled',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_object_to_ibap = (
                        'enable'            => \&ibap_o2i_boolean,
                        'enable_completion' => \&ibap_o2i_ignore,
                        'state'             => \&ibap_o2i_ignore,
                        'max_time_to_track' => \&ibap_o2i_uint,
                        'max_objs_to_track' => \&ibap_o2i_uint,
    );

    @_return_fields = (
                       tField('enabled'),
                       tField('state'),
                       tField('enable_completion'),
                       tField('max_time_to_track'),
                       tField('max_objs_to_track'),
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

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'enabled'} = 0 unless defined $$ibap_object_ref{'enabled'};
    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}



package Infoblox::Grid::TestResult;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            %_allowed_members
            @ISA
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN {

    %_allowed_members = (
                         'error_messages' => {simple => 'asis', array => 1, readonly => 1},
                         'error_message'  => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'overall_status' => {simple => 'asis', readonly => 1},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
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


1;
