package Infoblox::Grid::ExtensibleAttributeDef;

use strict;

use Carp;
use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Time::Local;

use vars qw(
            @ISA
            $_object_type
            %_ATTRIBUTE_TYPES_DICT
            %_reverse_object_types_dict
            $_reverse_object_types_initialized
            %_object_types_dict
            %_allowed_members
            %_name_mappings
            %_reverse_name_mappings
            %_searchable_fields
            %_ibap_to_object
            %_object_to_ibap
            @_return_fields
            @_allowed_object_types
            %_capabilities
            %_return_field_overrides
            %_flags
);

@ISA = qw(Exporter Infoblox::IBAPBase);

BEGIN
{
	$_object_type = 'ExtensibleAttributeDefinition';
    register_wsdl_type('ib:ExtensibleAttributeDefinition', 'Infoblox::Grid::ExtensibleAttributeDef');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 0,
					  'single_serialization' => 0,
					 );

    #
    %_ATTRIBUTE_TYPES_DICT=('string' => 'STRING',
                                'integer' => 'INTEGER',
                                'email' => 'EMAIL',
                                'date' => 'DATE',
                                'list' => 'ENUM',
                                'url' => 'URL');

    #
    %_object_types_dict = (
                           'Member' => ['Infoblox::Grid::Member'],
                           'AdminMember' => [ 'Infoblox::Grid::Admin::User' ],
                           'AdminGroup' => [ 'Infoblox::Grid::Admin::Group' ],
                           'Role' => [ 'Infoblox::Grid::Admin::Role' ],
                           'Network' => [
                                         'Infoblox::DHCP::Network', 'Infoblox::DHCP::NetworkContainer', 'Infoblox::DHCP::NetworkTemplate'
                                        ],
		                   'View' => [
                                      'Infoblox::DNS::View',
                                     ],
                           'IPv6Network' => [
                                             'Infoblox::DHCP::IPv6Network', 'Infoblox::DHCP::IPv6NetworkContainer', 'Infoblox::DHCP::IPv6NetworkTemplate'
                                            ],

                           'SharedNetwork' => [ 'Infoblox::DHCP::SharedNetwork' ],
                           'IPv6SharedNetwork' => [ 'Infoblox::DHCP::IPv6SharedNetwork' ],
                           'IPv6Network' => ['Infoblox::DHCP::IPv6Network', 'Infoblox::DHCP::IPv6NetworkContainer'],
						   'IPv6DhcpRange' => ['Infoblox::DHCP::IPv6Range', 'Infoblox::DHCP::IPv6RangeTemplate'],                            
						   'DhcpRange' => ['Infoblox::DHCP::Range', 'Infoblox::DHCP::RangeTemplate'],                            
						   'FixedAddress' => ['Infoblox::DHCP::FixedAddr', 'Infoblox::DHCP::FixedAddrTemplate'],
						   'IPv6FixedAddress' => ['Infoblox::DHCP::IPv6FixedAddr', 'Infoblox::DHCP::IPv6FixedAddrTemplate'],
						   'RoamingHost' => ['Infoblox::DHCP::RoamingHost'],
                           'RirOrganization' => ['Infoblox::Grid::RIR::Organization'],
						   'HostRecord' => ['Infoblox::DNS::Host'],
						   'BaseZone' => ['Infoblox::DNS::Zone'],
                           'ResourceRecord' => 
		                       [
								   'Infoblox::DNS::Record::A',
								   'Infoblox::DNS::Record::AAAA',
								   'Infoblox::DNS::Record::CNAME',
								   'Infoblox::DNS::Record::DNAME',
								   'Infoblox::DNS::Record::MX',
								   'Infoblox::DNS::Record::NS',
								   'Infoblox::DNS::Record::PTR',
								   'Infoblox::DNS::Record::SRV',
								   'Infoblox::DNS::Record::TXT',
								   'Infoblox::DNS::Record::TLSA',
                                   'Infoblox::DNS::Record::NAPTR',
								   'Infoblox::DNS::BulkHost',
								   'Infoblox::DNS::SharedRecord::A',
								   'Infoblox::DNS::SharedRecord::AAAA',
								   'Infoblox::DNS::SharedRecord::TXT',
								   'Infoblox::DNS::SharedRecord::MX',
								   'Infoblox::DNS::SharedRecord::SRV',
                                   'Infoblox::DNS::SharedRecord::CNAME',
							   ],
                           'SharedRecordGroup' => [ 'Infoblox::DNS::SRG'],
                           'NsGroup' => [
                                         'Infoblox::Grid::DNS::Nsgroup',
                                         'Infoblox::Grid::DNS::Nsgroup::ForwardStubServer',
                                         'Infoblox::Grid::DNS::Nsgroup::ForwardingMember',
                                         'Infoblox::Grid::DNS::Nsgroup::StubMember',
                                         'Infoblox::Grid::DNS::Nsgroup::DelegationMember',
                            ],
                           'DhcpFailoverAssoc' => [ 'Infoblox::DHCP::FailOver' ],
                           'OptionFilter' => [ 'Infoblox::DHCP::Filter::Option' ],
                           'RelayAgentFilter' => [ 'Infoblox::DHCP::Filter::RelayAgent' ],
                           'DhcpMacFilter' => [ 'Infoblox::DHCP::Filter::MAC' ],
                           'MacFilterAddress' => [ 'Infoblox::DHCP::MAC' ],
                           'NetworkView' => [ 'Infoblox::DHCP::View' ],
                           'MsServer' => [ 'Infoblox::Grid::MSServer' ],
                           'MsSuperscope' => [ 'Infoblox::DHCP::MSSuperscope' ],
                           'NacFilter'   => [ 'Infoblox::DHCP::Filter::NAC' ],
                           'Dns64SynthesisGroup' => [ 'Infoblox::Grid::DNS::DNS64Group'],
                           'DhcpFingerprint' => [ 'Infoblox::DHCP::Fingerprint' ],
                           'DhcpFingerprintFilter' => [ 'Infoblox::DHCP::Filter::Fingerprint' ],
                           'IdnsMonitorSnmp' => ['Infoblox::DTC::Monitor::SNMP'],
                           'GridDns'  => [ 'Infoblox::Grid::DNS' ],
                           'MemberDns'   => [ 'Infoblox::Grid::Member::DNS' ],
                           'SnmpUser' => ['Infoblox::Grid::SNMP::User'],

                           'IdnsCertificate'      => ['Infoblox::DTC::Certificate'],
                           'IdnsLbdn'             => ['Infoblox::DTC::LBDN'],
                           'IdnsMonitorHttp'      => ['Infoblox::DTC::Monitor::HTTP'],
                           'IdnsMonitorIcmp'      => ['Infoblox::DTC::Monitor::ICMP'],
                           'IdnsMonitorPdp'       => ['Infoblox::DTC::Monitor::PDP'],
                           'IdnsMonitorSip'       => ['Infoblox::DTC::Monitor::SIP'],
                           'IdnsMonitorTcp'       => ['Infoblox::DTC::Monitor::TCP'],
                           'IdnsPool'             => ['Infoblox::DTC::Pool'],
                           'IdnsServer'           => ['Infoblox::DTC::Server'],
                           'IdnsTopology'         => ['Infoblox::DTC::Topology'],

                           'Device'               => ['Infoblox::Grid::Discovery::Device'],
                           'DeviceInterface'      => ['Infoblox::Grid::Discovery::DeviceInterface'],

                           'VM'                   => ['Infoblox::Grid::CloudAPI::VM'],
                           'Tenant'               => ['Infoblox::Grid::CloudAPI::Tenant'],

                           'RestartGroup'         => ['Infoblox::Grid::ServiceRestart::Group'],
                           'DefinedACL'           => ['Infoblox::Grid::NamedACL'],
                           'WorkflowApproval'     => ['Infoblox::Grid::ApprovalWorkflow'],
                           'ResponsePolicyRecord' => [
                                                      'Infoblox::DNS::RPZRecord::A',
                                                      'Infoblox::DNS::RPZRecord::AIpAddress',
                                                      'Infoblox::DNS::RPZRecord::AAAA',
                                                      'Infoblox::DNS::RPZRecord::AAAAIpAddress',
                                                      'Infoblox::DNS::RPZRecord::MX',
                                                      'Infoblox::DNS::RPZRecord::NAPTR',
                                                      'Infoblox::DNS::RPZRecord::PTR',
                                                      'Infoblox::DNS::RPZRecord::SRV',
                                                      'Infoblox::DNS::RPZRecord::TXT',
                                                      'Infoblox::DNS::RPZRecord::CNAME',
                                                      'Infoblox::DNS::RPZRecord::CNAME::IpAddress',
                                                      'Infoblox::DNS::RPZRecord::CNAME::ClientIpAddress',
                                                      'Infoblox::DNS::RPZRecord::CNAME::IpAddressDN',
                                                      'Infoblox::DNS::RPZRecord::CNAME::ClientIpAddressDN',
                                                     ],
                           'BaseEndpoint'     => ['Infoblox::Grid::AllEndpoints'],
                          );

    #
    %_reverse_object_types_dict = ();
    @_allowed_object_types = ();

    $_reverse_object_types_initialized = 0;

    #
    #
    %_allowed_members = (
       'name' => 1,
       'comment' => 0,
       'type' => 1,
       'audit_log' => 0,
       'required' => 0, # obsolete, we should use user_input instead
       'namespace' => -1,
       'multiple' => 0,
       'inheritable' => 0,
       'default_value' => 0,
       'list_values' => 0,
       'min' => 0,
       'max' => 0,
       'allowed_object_types' => 0,
       'user_input' => 0,
       'descendants_action' => {validator => {'Infoblox::Grid::ExtensibleAttributeDef::Descendants' => 1}, writeonly => 1, skip_accessor => 1},
       'cloud_api' => 0,
       'mgm_private'   => 0,
       'grid_master' => 0,
    );

    %_return_field_overrides  =  (
                                  'name'                 => [],
                                  'comment'              => [],
                                  'type'                 => [],
                                  'audit_log'            => ['flags'],
                                  'required'             => ['flags'],
                                  'namespace'            => [],
                                  'multiple'             => ['flags'],
                                  'default_value'        => [],
                                  'list_values'          => [],
                                  'min'                  => [],
                                  'max'                  => [],
                                  'allowed_object_types' => [],
                                  'inheritable'          => ['flags'],
                                  'user_input'           => ['flags'],
                                  'cloud_api'            => ['flags'],
                                  'mgm_private'              => ['flags'],
                                  'grid_master'          => ['flags'],
                                 );

    #
    %_name_mappings = ('type' => 'attribute_type',
                            'default_value' => 'gui_default_value',
                            'list_values' => 'enum_values',
                            'min' => 'min_value',
                            'max' => 'max_value');

    %_reverse_name_mappings = reverse %_name_mappings;

    #
    %_searchable_fields = (
                           name => [\&ibap_o2i_string, 'name', 'REGEX'],
                           comment => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           namespace => [\&ibap_o2i_string, 'namespace', 'EXACT'],
                          );

    #
    %_ibap_to_object = (attribute_type => \&__i2o_type__,
                            allowed_object_types => \&__i2o_allowed_object_types__,
                            enum_values => \&__i2o_list_values__,
                            gui_default_value  => \&__i2o_default_value__);

    #
    %_object_to_ibap = (    name => \&ibap_o2i_string,
                            comment => \&ibap_o2i_string,
                            type => \&__o2i_type__,
                            audit_log => \&ibap_o2i_ignore,
                            required => \&ibap_o2i_ignore,
                            namespace => \&ibap_o2i_ignore,
                            multiple => \&ibap_o2i_ignore,
                            inheritable => \&ibap_o2i_ignore,
                            cloud_api => \&ibap_o2i_ignore,
                            mgm_private => \&ibap_o2i_ignore,
                            grid_master => \&ibap_o2i_ignore,
                            default_value => \&__o2i_default_value__,
                            list_values => \&__o2i_list_values__,
                            min => \&ibap_o2i_integer,
                            max => \&ibap_o2i_integer,
                            allowed_object_types => \&__o2i_allowed_object_types__,
                            user_input => \&ibap_o2i_ignore,
                            descendants_action => \&ibap_o2i_generic_struct_convert,
                       );

    #
    @_return_fields =
    (
     tField('name'),
     tField('comment'),
     tField('attribute_type'),
     tField('flags'),
     tField('gui_default_value'),
     tField('enum_values'),
     tField('namespace'),
     tField('min_value'),
     tField('max_value'),
     tField('allowed_object_types'),
     );

     %_flags = (
        'A' => [\&audit_log, 'true'],
        'L' => [\&user_input, 'recommended'],
        'M' => [\&user_input, 'required'],
        'V' => [\&multiple, 'true'],
        'I' => [\&inheritable, 'true'],
        'C' => [\&cloud_api, 'true'],
        'G' => [\&grid_master, 'true'],
        'P' => [\&mgm_private, 'true'],
     );
}

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self, $class;

    #
    $self->__init_instance_members_default_value__();
    $self->__init_reverse_object_types_dict__();

    if (exists($args{'user_input'}) && exists($args{'required'})) {
        set_error_codes(1002, "Invalid argument, 'user_input' and 'required' can't both be set at the same time");
        return; 
    }

    #
    if (exists($args{'type'}))
    {
        my %args_type;
        $args_type{'type'}=delete $args{'type'};

        return unless $self->__initialize_members_from_arg_list__(\%_allowed_members, \%args_type);
    }

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
    bless $self, $class;

    $self->__init_reverse_object_types_dict__();
    return $self;
}

sub __init_instance_members_default_value__
{
    my $self=shift;

    $self->type('string');
    $self->audit_log('false');
    $self->multiple('false');
    $self->user_input('optional');
    $self->inheritable('false');
    $self->cloud_api('false');
    $self->mgm_private('false');
    $self->grid_master('false');
}

sub __init_reverse_object_types_dict__ {

    unless ($_reverse_object_types_initialized) {

        $_reverse_object_types_initialized = 1;

        foreach my $key (keys %_object_types_dict) {

            $_reverse_object_types_dict{$_} = $key
                foreach @{$_object_types_dict{$key}};
        }

        @_allowed_object_types = keys %_reverse_object_types_dict;
    }
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
sub __i2o_type__
{
	my ($self, $session, $current, $ibap_object_ref) = @_;
    my $type;

	if ($$ibap_object_ref{$current})
    {
		my $ibap_type=$$ibap_object_ref{$current};
        my %attribute_types_dict_reverse=reverse(%Infoblox::Grid::ExtensibleAttributeDef::_ATTRIBUTE_TYPES_DICT);

        $type=$self->type($attribute_types_dict_reverse{$ibap_type});
	}

    return $type;
}

sub __i2o_allowed_object_types__ {

	my ($self, $session, $current, $ibap_object_ref) = @_;
    my @allowed_object_types;

	if ($$ibap_object_ref{$current} and
        ref $$ibap_object_ref{$current} eq 'ARRAY'
    ) {
		foreach my $object_type (@{$$ibap_object_ref{$current}}) {

            (my $subst_object_type = $object_type) =~ s/^/NOPAPI::/
                if $object_type;

            push @allowed_object_types, (
                $_object_types_dict{$object_type} ?
                    @{$_object_types_dict{$object_type}} :
                    $subst_object_type
            );
		}
    }

    return \@allowed_object_types;
}


#
sub __i2o_default_value__
{
	my ($self, $session, $current, $ibap_object_ref) = @_;
    my $default_value;

	if ($$ibap_object_ref{$current})
    {
        if (defined($$ibap_object_ref{$current}{'value_string'}))
        {
            $default_value=$$ibap_object_ref{$current}{'value_string'};
        }
        elsif (defined($$ibap_object_ref{$current}{'value_enum'}))
        {
            $default_value=$$ibap_object_ref{$current}{'value_enum'};
        }
        elsif (defined($$ibap_object_ref{$current}{'value_integer'}))
        {
            $default_value=$$ibap_object_ref{$current}{'value_integer'};
        }
        elsif (defined($$ibap_object_ref{$current}{'value_email'}))
        {
            $default_value=$$ibap_object_ref{$current}{'value_email'};
        }
        elsif (defined($$ibap_object_ref{$current}{'value_url'}))
        {
            $default_value=$$ibap_object_ref{$current}{'value_url'};
        }
        elsif (defined($$ibap_object_ref{$current}{'value_date'}))
        {
            $default_value=iso8601_datetime_to_unix_timestamp($$ibap_object_ref{$current}{'value_date'});
        }
	}

    return $default_value;
}


#
sub __i2o_list_values__
{
	my ($self, $session, $current, $ibap_object_ref) = @_;
    my @enum_values;
    my $value_object;

	if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}})
    {
		my @list=@{$$ibap_object_ref{$current}};

		foreach my $value_struct (@list)
        {
            if (defined($$value_struct{'enum_value'}))
            {
    	        $value_object=Infoblox::Grid::ExtensibleAttributeDef::ListValue->new(value => $$value_struct{'enum_value'});

                #
                $value_object->__old_value__(undef);

                push(@enum_values, $value_object);
            }
    	}
    }

    return \@enum_values;
}


#
sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    #
    $self->audit_log('false');
    $self->multiple('false');
    $self->user_input('optional');
    $self->inheritable('false');
    $self->cloud_api('false');
    $self->mgm_private('false');
    $self->grid_master('false');

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref, {'flags' => 1, });

    if (defined($$ibap_object_ref{'flags'})) {
        foreach (sort split('', $$ibap_object_ref{'flags'})) {
            $_flags{$_}->[0]->($self, $_flags{$_}->[1]) if defined $_flags{$_};
        }
    }

    return $res;
}


#
sub __o2i_type__
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

    #
    my $type=$self->type();
    if (defined $type)
    {
        my $ibap_type=$_ATTRIBUTE_TYPES_DICT{$type};
        $ibap_type=ibap_value_o2i_string($ibap_type);

		push @return_args, 1;
		push @return_args, 0;
		push @return_args, $ibap_type;
	}
	else
    {
    	push @return_args, 1;
    	push @return_args, 1;
    	push @return_args, undef;
    }

	return @return_args;
}


#
sub __o2i_list_values__
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

    #
    my $ref_list_values=$self->list_values();
    my @ibap_list_values;
    if (defined $ref_list_values)
    {
        for my $value_obj (@$ref_list_values)
        {
            my $value=$value_obj->value();
            my $ibap_value=ibap_value_o2i_string($value);
		    if (!defined($ibap_value))
            {
			    set_error_codes(1012, "Invalid character(s) ($value) for field list_values", $session);
                push @return_args, 0;
                return @return_args;
            }

            my $old_value=$value_obj->__old_value__();
            my $ibap_old_value;

            if (defined($old_value))
            {
                $ibap_old_value=ibap_value_o2i_string($old_value);
		        if (!defined($ibap_old_value))
                {
			        set_error_codes(1012, "Invalid character(s) ($old_value) for field list_values", $session);
                    push @return_args, 0;
                    return @return_args;
                }
            }

            my %ibap_structure;
            $ibap_structure{'enum_value'}=$ibap_value;

            if (defined($ibap_old_value))
            {
                $ibap_structure{'enum_value_old'}=$ibap_old_value;
            }

            push(@ibap_list_values, tIBType('extensibleattribute_enumvalue',
                                            \%ibap_structure));
		}
	}

   	push @return_args, 1;
   	push @return_args, 0;
   	push @return_args, tIBType('ArrayOfextensibleattribute_enumvalue',
                               \@ibap_list_values);

	return @return_args;
}

sub __o2i_allowed_object_types__ {

	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

    my $ref_allowed_object_types = $self->allowed_object_types();
    my %ibap_allowed_object_types; #Use hash to avoid dublicating names

    if ($ref_allowed_object_types) {
        foreach my $type (@$ref_allowed_object_types) {

            (my $subst_type = $type) =~ s/^NOPAPI:://
                if $type;

            my $ib_type = ($type =~ m/^NOPAPI::/ ?
                $subst_type :
                $_reverse_object_types_dict{$type}
            );

            $ibap_allowed_object_types{$ib_type} = 1 if $ib_type;
        }
    }

    return (1, 0, tIBType('ArrayOfExtensibleAttribute_ObjectType',
        [keys %ibap_allowed_object_types]));
}

sub __o2i_value_allowed_object_types__ {

    my ($value, $field, $session, $validate_only) = @_;

    return undef unless $validate_only;

    unless (
        $_reverse_object_types_dict{$value} or
        $value =~ m/^NOPAPI::/
    ) {
        set_error_codes('1104', "Invalid value '$value' for member '$field'.");
        return undef;
    }

    return 1;
}


#
sub __o2i_default_value__
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

    my $default_value=$self->default_value();
    if (defined($default_value))
    {
        #
        my $error_detail, my $soap_value_structure;
        my $error_code=build_soap_value_structure($self->type(), $default_value, \$soap_value_structure, \$error_detail);

        if ($error_code != 0)
        {
            set_error_codes($error_code, $error_detail);
            push @return_args, 0;
            return @return_args;
        }

    	push @return_args, 1;
		push @return_args, 0;
		push @return_args, $soap_value_structure;
	}
	else
    {
    	push @return_args, 1;
    	push @return_args, 0;
    	push @return_args, undef;
    }

	return @return_args;
}


#
sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;
    my $ref_write_fields=$self->SUPER::__object_to_ibap__($server, $session);

    if (defined $ref_write_fields)
    {
        #
        my $flags='';

        foreach (keys(%_flags)) {
            if ($_flags{$_}->[0]->($self) eq $_flags{$_}->[1]) {
                $flags .= $_;
            }
        }

        my %field;
		$field{'field'} = 'flags';
    	$field{'value'} = ibap_value_o2i_string($flags);
        unshift @$ref_write_fields, \%field;
    }

    return $ref_write_fields;
}


#
#
#

sub name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub namespace
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'namespace', enum => ['default', 'RIPE', 'MSADSITES', 'CLOUD']}, @_);
}

sub type
{
    my $self=shift;
    my @allowed_attribute_types=keys %_ATTRIBUTE_TYPES_DICT;

    return $self->__accessor_scalar__({name => 'type', enum => \@allowed_attribute_types }, @_);
}

sub audit_log
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'audit_log', validator => \&ibap_value_o2i_boolean}, @_);
}

sub required
{
    my $self = shift;
    my $res = $self->__accessor_scalar__({name => 'required', validator => \&ibap_value_o2i_boolean}, @_);

    if (@_ && $res) {
        if ($self->{'required'} && $self->{'required'} eq 'true') {
            $self->{'user_input'} = 'required';
        } elsif ($self->{'required'} && $self->{'required'} eq 'false') {
            $self->{'user_input'} = 'optional';
        }
    }

    return $res;
}

sub user_input
{
    my $self = shift;
    my $res = $self->__accessor_scalar__({name => 'user_input', enum => ['recommended', 'required', 'optional']}, @_);

    if (@_ && $res) {
        $self->{'required'} = $self->{'user_input'} eq 'required' ? 'true' : 'false';
    }

    return $res;
}

sub multiple
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'multiple', validator => \&ibap_value_o2i_boolean}, @_);
}

sub inheritable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'inheritable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub cloud_api
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'cloud_api', validator => \&ibap_value_o2i_boolean}, @_);
}

sub mgm_private
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'mgm_private', validator => \&ibap_value_o2i_boolean}, @_);
}

sub grid_master
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'grid_master', validator => \&ibap_value_o2i_boolean}, @_);
}


sub default_value
{
    my $self=shift;

    if( @_ == 0 )
    {
        return $self->{'default_value'};
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{'default_value'} = undef;
        }
        else
        {
            #
            my $ibap_type=$_ATTRIBUTE_TYPES_DICT{$self->type()};

			#
            if (defined($ibap_type) && !defined (get_soap_attribute_value($ibap_type, $value)))
            {
				set_error_codes(1104,"Invalid value '$value' for member 'default_value'");
				return;
            }
            else
            {
                $self->{'default_value'} = $value;
            }
		}
	}
	return 1;
}


sub list_values
{
    my $self=shift;

    return $self->__accessor_array__({name => 'list_values', validator => { 'Infoblox::Grid::ExtensibleAttributeDef::ListValue' => 1 }}, @_);
}

sub min
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'min', validator => \&ibap_value_o2i_int}, @_);
}

sub max
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'max', validator => \&ibap_value_o2i_int}, @_);
}

sub allowed_object_types
{
    my $self=shift;

    return $self->__accessor_array__({name => 'allowed_object_types', validator => \&__o2i_value_allowed_object_types__,
                                      enum => \@_allowed_object_types}, @_);
}

sub descendants_action
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'descendants_action', writeonly => 1, validator => {'Infoblox::Grid::ExtensibleAttributeDef::Descendants' => 1}}, @_);
}


#
#
#

#
sub __post_insert_hook__
{
    my $self=shift;
    my $server=shift;
    my $session=shift;

    #
    $session->__extensible_attribute_def_cache_add_entry__($self->__object_id__(), $self->name(), $self->type());

    return 1;
}


#
sub __post_modify_hook__
{
    my $self=shift;
    my $server=shift;
    my $session=shift;
    my $old_object_id=shift;

    #
    $session->__extensible_attribute_def_cache_del_entry_per_id__($old_object_id);

    #
    $session->__extensible_attribute_def_cache_add_entry__($self->__object_id__(), $self->name(), $self->type());

    return 1;
}


#
sub __post_remove_hook__
{
    my $class=shift;
    my $server=shift;
    my $session=shift;
    my $ref_object_ids=shift;

    #
    for my $object_id (@$ref_object_ids)
    {
        $session->__extensible_attribute_def_cache_del_entry_per_id__($object_id);
    }

    return 1;
}


#
#
#

#
sub get_soap_value_member_name_by_cache_entry
{
    my ($session,$type) = @_;

    my $ibap_type=$_ATTRIBUTE_TYPES_DICT{$type};
    if (defined($ibap_type))
    {
        my $t = get_soap_value_member_name($ibap_type);
        return $t if $t;
    }

    set_error_codes(1104,"Invalid value '$type' for member type", $session);
    return undef;
}

#
sub get_soap_value_member_name
{
    my $ibap_type=shift;
    my $member_name;

    if ($ibap_type eq 'STRING')
    {
        $member_name='value_string';
    }
    elsif ($ibap_type eq 'ENUM')
    {
        $member_name='value_enum';
    }
    elsif ($ibap_type eq 'EMAIL')
    {
        $member_name='value_email';
    }
    elsif ($ibap_type eq 'URL')
    {
        $member_name='value_url';
    }
    elsif ($ibap_type eq 'INTEGER')
    {
        $member_name='value_integer';
    }
    elsif ($ibap_type eq 'DATE')
    {
        $member_name='value_date';
    }

    return $member_name;
}


#
sub get_soap_attribute_value
{
    my $ibap_type=shift;
    my $value=shift;
    my $soap_value;

    if (($ibap_type eq 'STRING') || ($ibap_type eq 'ENUM') || ($ibap_type eq 'EMAIL') || ($ibap_type eq 'URL'))
    {
        $soap_value=ibap_value_o2i_string($value);
    }
    elsif ($ibap_type eq 'INTEGER')
    {
        $soap_value=ibap_value_o2i_int($value);
    }
    elsif ($ibap_type eq 'DATE')
    {
        #
        if ($value =~ m/^\d+$/) {
            $soap_value=tDateTime(timestamp_at_11_01_on_same_utc_day($value))
        } elsif ($value =~ m/^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/) {
            #
            #
            $soap_value = tDateTime(iso8601_datetime_to_unix_timestamp($value . "T11:01:00Z"));
        }
    }

    return $soap_value;
}


#
sub get_soap_value_structure_members
{
    my $type=shift;
    my $value=shift;
    my $ref_member_name=shift;
    my $ref_member_value=shift;
    my $ref_error_detail=shift;

    #
    my $ibap_type=$_ATTRIBUTE_TYPES_DICT{$type};
    if (defined($ibap_type))
    {
        #
        $$ref_member_name=get_soap_value_member_name($ibap_type);

        #
        $$ref_member_value=get_soap_attribute_value($ibap_type, $value);
        if (defined($$ref_member_value))
        {
            return 0;
        }
        else
        {
            $$ref_error_detail="Invalid value '$value' for field value";
            return 1004;
        }
    }
    else
    {
        $$ref_error_detail="Invalid value '$type' for member type";
        return 1104;
    }
}


#
sub build_soap_value_structure
{
    my $type=shift;
    my $value=shift;
    my $ref_soap_value_structure=shift;
    my $ref_error_detail=shift;

    my $member_name, my $member_value;
    my $error_code = get_soap_value_structure_members($type, $value, \$member_name, \$member_value, $ref_error_detail);

    if ($error_code == 0)
    {
         $$ref_soap_value_structure=tIBType('extensible_attributes_value',
                                            { $member_name => $member_value });
    }

    return $error_code;
}


#
sub validate_extensible_attributes_attr_format
{
    my $extensible_attributes=shift;

    if (ref($extensible_attributes) ne 'HASH')
    {
        return 0;
    }

    for my $name (keys %$extensible_attributes)
    {
        my $value=$$extensible_attributes{$name};
        return set_error_codes(1104, "Invalid value for '$name' in extensible_attributes, undefined value is not supported") unless defined $value;

        my $value_ref=ref($value);

        if ((ref($name) ne '') || ($value_ref ne '' && $value_ref ne 'ARRAY' && $value_ref ne 'HASH'))
        {
            return 0;
        }
    }

    return 1;
}

sub validate_extattr_format
{
    my $value = shift;

    if (ref($value) ne 'HASH') {
        set_error_codes(1104, 'Invalid object of type (' . ref($value) . ') for field extattrs, only a reference to a hash is supported');
        return undef;
    }

    foreach (keys(%$value)) {
        if (ref($value->{$_}) ne 'Infoblox::Grid::Extattr') {
            set_error_codes(1104, 'Invalid object of type (' . ref($value->{$_}) . ') for hash value of field extattrs, only Infoblox::Grid::Extattr is supported');
            return undef;
        }
    }

    return 1;
}

package Infoblox::Grid::ExtensibleAttributeDef::Descendants;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA %_allowed_members %_object_to_ibap @_return_fields $_object_type);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN
{
    $_object_type = 'extensible_attributes_descendants_action';
    register_wsdl_type('ib:extensible_attributes_descendants_action', 'Infoblox::Grid::ExtensibleAttributeDef::Descendants');

    %_allowed_members = (
                         'option_without_ea' => {simple => 'asis', enum => ['INHERIT', 'NOT_INHERIT']},
                         'option_with_ea'    => {simple => 'asis', enum => ['CONVERT', 'INHERIT', 'RETAIN']},
                         'option_delete_ea'  => {simple => 'asis', enum => ['REMOVE', 'RETAIN']},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_object_to_ibap = (
                        'option_without_ea' => \&ibap_o2i_string,
                        'option_with_ea'    => \&ibap_o2i_string,
                        'option_delete_ea'  => \&ibap_o2i_string,
                       );

    @_return_fields = (
                       tField('option_without_ea'),
                       tField('option_with_ea'),
                       tField('option_delete_ea'),
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
    bless $self, $class;

    return $self;
}

sub __ibap_object_type__
{
	return $_object_type;
}

package Infoblox::Grid::Extattr;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA %_allowed_members);
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN
{
    #

    %_allowed_members = (
                         'value'                 => 1,
                         'inheritance_operation' => {writeonly => 1, enum => ['DELETE', 'INHERIT', 'OVERRIDE']},
                         'descendants_action'    => {writeonly => 1, validator => {'Infoblox::Grid::ExtensibleAttributeDef::Descendants' => 1}},
                         'inheritance_source'    => {readonly => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
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
    bless $self, $class;

    return $self;
}

#
#
#

sub value
{
    my $self = shift;

    if (@_) {
        my $value = shift;
        if (ref($value)) {
            if (ref($value) eq 'ARRAY') {
                foreach my $item (@$value) {
                    if (ref($item) ne '') {
                        set_error_codes(1104, 'Invalid object of type (' . ref($item) . ') for field value, only a reference to an array of scalar values is supported');
                        return undef;
                    }
                }
            } else {
                set_error_codes(1104, 'Invalid object of type (' . ref($value) . ') for field value, only a reference to an array of scalar values or a scalar value is supported');
                return undef;
            }
        }

        $self->{'value'} = $value;
        return 1;
    } else {
        return $self->{'value'};
    }
}

1;
