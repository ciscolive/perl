package Infoblox::GlobalSearch;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities $_return_fields_initialized %_acceptable_ibap_types %_reverse_acceptable_ibap_types);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::SEARCH_ONLY);

BEGIN {
    $_object_type = 'GlobalSearchObject';
    register_wsdl_type('ib:GlobalSearchObject','Infoblox::GlobalSearch');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,

                      #
                      #
                      'nopaging'             => 1,
                      'limit'                => 500,
					 );

    %_allowed_members =
      (
       object           => {readonly => 1},
       matched_property => {readonly => 1},
       matched_value    => {readonly => 1},
       object_type      => {readonly => 1},
       comment          => {readonly => 1},
      );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings =
      (
       'object'      => 'resource',
       'object_type' => 'resource_type',
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields = (
						   search_string           => [\&ibap_o2i_string,'search_string' , 'REGEX'],
                           object_type             => [\&__o2i_objtype__,'objtype', 'EXACT'],
                           extattrs                => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes   => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
						   return_multiple_objects => [\&ibap_o2i_boolean,'return_multiple_objects' , 'EXACT'],
                           address                 => [\&ibap_o2i_string, 'address', 'REGEX'],
                           mac_address             => [\&ibap_o2i_string, 'mac_address', 'REGEX'],
                           duid                    => [\&ibap_o2i_string, 'duid', 'REGEX'],
                           fqdn                    => [\&ibap_o2i_string, 'fqdn', 'REGEX'],
                          );

	%_return_field_overrides =
      (
       object           => [],
       matched_property => [],
       matched_value    => [],
       object_type      => [],
       comment          => [],
      );

    %_ibap_to_object =
      (
       resource         => \&__i2o_object__,
      );

    %_object_to_ibap =
      (
       object           => \&ibap_o2i_ignore,
       matched_property => \&ibap_o2i_ignore,
       matched_value    => \&ibap_o2i_ignore,
       object_type      => \&ibap_o2i_ignore,
       comment          => \&ibap_o2i_ignore,
      );

    %_acceptable_ibap_types = (
                               'All'                                => 'All Objects',
                               'ARecord'                            => 'Infoblox::DNS::Record::A',
                               'AaaaRecord'                         => 'Infoblox::DNS::Record::AAAA',
                               'AclItem'                            => 'NOSEARCH',
                               'AdminGroup'                         => 'Infoblox::Grid::Admin::Group',
                               'AdminMember'                        => 'Infoblox::Grid::Admin::User',
                               'AllDnsRecords'                      => 'NOSEARCH',
                               'AllEndpoints'                       => 'Infoblox::Grid::AllEndpoints',
                               'AllNetwork'                         => 'All Networks',
                               'AllZone'                            => 'Infoblox::DNS::Zone',
                               'AtpProfile'                         => 'Infoblox::Grid::ThreatProtection::Profile',
                               'BlacklistRule'                      => 'NOSEARCH',
                               'BlockNoDataClientIPAddress'         => 'NOSEARCH',
                               'BlockNoDataCname'                   => 'NOSEARCH',
                               'BlockNoDataIPAddress'               => 'NOSEARCH',
                               'BlockNxdomainClientIPAddress'       => 'NOSEARCH',
                               'BlockNxdomainCname'                 => 'NOSEARCH',
                               'BlockNxdomainIPAddress'             => 'NOSEARCH',
                               'BulkHost'                           => 'Infoblox::DNS::BulkHost',
                               'CDiscoveryTask'                     => 'Infoblox::Grid::VDiscoveryTask',
                               'CnameRecord'                        => 'Infoblox::DNS::Record::CNAME',
                               'DashboardTask'                      => 'NOSEARCH',
                               'DefinedACL'                         => 'Infoblox::Grid::NamedACL',
                               'DhcidRecord'                        => 'Infoblox::DNS::Record::DHCID',
                               'DhcpFailoverAssoc'                  => 'Infoblox::DHCP::FailOver',
                               'DhcpFingerprint'                    => 'Infoblox::DHCP::Fingerprint',
                               'DhcpFingerprintFilter'              => 'Infoblox::DHCP::Filter::Fingerprint',
                               'DhcpMacFilter'                      => 'Infoblox::DHCP::Filter::MAC',
                               'DhcpOption82Filter'                 => 'NOSEARCH',
                               'DhcpOptionFilter'                   => 'Infoblox::DHCP::Filter::Option',
                               'DhcpRange'                          => 'Infoblox::DHCP::Range',
                               'DhcpRangeTemplate'                  => 'Infoblox::DHCP::RangeTemplate',
                               'DiscoveryData'                      => 'NOSEARCH',
                               'DiscoveryDevice'                    => 'NOSEARCH',
                               'DiscoveryInterface'                 => 'NOSEARCH',
                               'DnameRecord'                        => 'Infoblox::DNS::Record::DNAME',
                               'Dns64SynthesisGroup'                => 'Infoblox::Grid::DNS::DNS64Group',
                               'DnskeyRecord'                       => 'Infoblox::DNS::Record::DNSKEY',
                               'DsRecord'                           => 'Infoblox::DNS::Record::DS',
                               'FixedAddress'                       => 'Infoblox::DHCP::FixedAddr',
                               'FixedAddressTemplate'               => 'Infoblox::DHCP::FixedAddrTemplate',
                               'FtpUser'                            => 'NOSEARCH',
                               'GridDhcp'                           => 'Infoblox::Grid::DHCP',
                               'GridDiscoveryProperties'            => 'Infoblox::Grid::Discovery::Properties',
                               'GridDns'                            => 'Infoblox::Grid::DNS',
                               'HostAddress'                        => 'Infoblox::DHCP::FixedAddr',
                               'HostRecord'                         => 'Infoblox::DNS::Host',
                               'IPAMObjects'                        => 'All IPAM Objects',
                               'IPv6DhcpRange'                      => 'Infoblox::DHCP::IPv6Range',
                               'IPv6DhcpRangeTemplate'              => 'Infoblox::DHCP::IPv6RangeTemplate',
                               'IPv6FixedAddress'                   => 'Infoblox::DHCP::IPv6FixedAddr',
                               'IPv6FixedAddressTemplate'           => 'Infoblox::DHCP::IPv6FixedAddrTemplate',
                               'IPv6HostAddress'                    => 'Infoblox::DHCP::IPv6FixedAddr',
                               'IPv6Network'                        => 'Infoblox::DHCP::IPv6Network',
                               'IPv6NetworkContainer'               => 'Infoblox::DHCP::IPv6NetworkContainer',
                               'IPv6NetworkTemplate'                => 'Infoblox::DHCP::IPv6NetworkTemplate',
                               'IPv6ReservedRange'                  => 'NOSEARCH',
                               'IPv6ReservedRangeTemplate'          => 'NOSEARCH',
                               'IPv6SharedNetwork'                  => 'Infoblox::DHCP::IPv6SharedNetwork',
                               'IdnsLbdn'                           => 'Infoblox::DTC::LBDN',
                               'IdnsLbdnRecord'                     => 'Infoblox::DNS::Record::DTCLBDN',
                               'IdnsMonitorHttp'                    => 'Infoblox::DTC::Monitor::HTTP',
                               'IdnsMonitorIcmp'                    => 'Infoblox::DTC::Monitor::ICMP',
                               'IdnsMonitorPdp'                     => 'Infoblox::DTC::Monitor::PDP',
                               'IdnsMonitorSip'                     => 'Infoblox::DTC::Monitor::SIP',
                               'IdnsMonitorSnmp'                    => 'Infoblox::DTC::Monitor::SNMP',
                               'IdnsMonitorTcp'                     => 'Infoblox::DTC::Monitor::TCP',
                               'IdnsPool'                           => 'Infoblox::DTC::Pool',
                               'IdnsServer'                         => 'Infoblox::DTC::Server',
                               'IdnsTopology'                       => 'Infoblox::DTC::Topology',
                               'IpBlock'                            => 'Infoblox::Grid::Reporting::IpBlock',
                               'IpBlockGroup'                       => 'Infoblox::Grid::Reporting::IpBlockGroup',
                               'KerberosKey'                        => 'Infoblox::Grid::KerberosKey',
                               'Lease'                              => 'Infoblox::DHCP::Lease',
                               'MacFilterAddress'                   => 'Infoblox::DHCP::MAC',
                               'Member'                             => 'Infoblox::Grid::Member',
                               'MemberAnalytics'                    => 'Infoblox::Grid::ThreatAnalytics::Member',
                               'MemberAtp'                          => 'Infoblox::Grid::Member::ThreatProtection',
                               'MemberCaptivePortal'                => 'Infoblox::Grid::Member::CaptivePortal',
                               'MemberDhcp'                         => 'Infoblox::Grid::Member::DHCP',
                               'MemberDiscoveryProperties'          => 'Infoblox::Grid::Member::DiscoveryProperties',
                               'MemberDns'                          => 'Infoblox::Grid::Member::DNS',
                               'MemberFD'                           => 'Infoblox::Grid::Member::FileDistribution',
                               'MsAdSitesDomain'                    => 'Infoblox::Grid::MSServer::AdSites::Domain',
                               'MsAdSitesSite'                      => 'Infoblox::Grid::MSServer::AdSites::Site',
                               'MsServer'                           => 'Infoblox::Grid::MSServer',
                               'MsSuperscope'                       => 'Infoblox::DHCP::MSSuperscope',
                               'MxRecord'                           => 'Infoblox::DNS::Record::MX',
                               'NacFilter'                          => 'Infoblox::DHCP::Filter::NAC',
                               'NaptrRecord'                        => 'Infoblox::DNS::Record::NAPTR',
                               'Network'                            => 'Infoblox::DHCP::Network',
                               'NetworkContainer'                   => 'Infoblox::DHCP::NetworkContainer',
                               'NetworkTemplate'                    => 'Infoblox::DHCP::NetworkTemplate',
                               'NetworkUser'                        => 'Infoblox::DHCP::NetworkUser',
                               'NetworkView'                        => 'Infoblox::DHCP::View',
                               'NotificationRule'                   => 'Infoblox::Notification::Rule',
                               'NsGroup'                            => 'Infoblox::Grid::DNS::Nsgroup',
                               'NsRecord'                           => 'Infoblox::DNS::Record::NS',
                               'Nsec3paramRecord'                   => 'Infoblox::DNS::Record::NSEC3PARAM',
                               'NsecRecord'                         => 'Infoblox::DNS::Record::NSEC',
                               'NxdomainRule'                       => 'NOSEARCH',
                               'PassthruClientIPAddress'            => 'NOSEARCH',
                               'PassthruCname'                      => 'NOSEARCH',
                               'PassthruIPAddress'                  => 'NOSEARCH',
                               'PtrRecord'                          => 'Infoblox::DNS::Record::PTR',
                               'Reservation'                        => 'NOSEARCH',
                               'ReservedRange'                      => 'NOSEARCH',
                               'ReservedRangeTemplate'              => 'NOSEARCH',
                               'ResponsePolicyARecord'              => 'Infoblox::DNS::RPZRecord::A',
                               'ResponsePolicyAaaaRecord'           => 'Infoblox::DNS::RPZRecord::AAAA',
                               'ResponsePolicyClientIPAddressCname' => 'Infoblox::DNS::RPZRecord::CNAME::ClientIpAddressDN',
                               'ResponsePolicyDomainName'           => 'NOSEARCH',
                               'ResponsePolicyIPAddressCname'       => 'Infoblox::DNS::RPZRecord::CNAME::IpAddressDN',
                               'ResponsePolicyIPv4Address'          => 'NOSEARCH',
                               'ResponsePolicyIPv6Address'          => 'NOSEARCH',
                               'ResponsePolicyMxRecord'             => 'Infoblox::DNS::RPZRecord::MX',
                               'ResponsePolicyNaptrRecord'          => 'Infoblox::DNS::RPZRecord::NAPTR',
                               'ResponsePolicyPtrRecord'            => 'Infoblox::DNS::RPZRecord::PTR',
                               'ResponsePolicySrvRecord'            => 'Infoblox::DNS::RPZRecord::SRV',
                               'ResponsePolicyTxtRecord'            => 'Infoblox::DNS::RPZRecord::TXT',
                               'RirOrganization'                    => 'Infoblox::Grid::RIR::Organization',
                               'RoamingHost'                        => 'Infoblox::DHCP::RoamingHost',
                               'Role'                               => 'Infoblox::Grid::Admin::Role',
                               'RrsigRecord'                        => 'Infoblox::DNS::Record::RRSIG',
                               'Ruleset'                            => 'Infoblox::DNS::Ruleset',
                               'SharedARecord'                      => 'Infoblox::DNS::SharedRecord::A',
                               'SharedAaaaRecord'                   => 'Infoblox::DNS::SharedRecord::AAAA',
                               'SharedCnameRecord'                  => 'Infoblox::DNS::SharedRecord::CNAME',
                               'SharedMxRecord'                     => 'Infoblox::DNS::SharedRecord::MX',
                               'SharedNetwork'                      => 'Infoblox::DHCP::SharedNetwork',
                               'SharedRecordGroup'                  => 'Infoblox::DNS::SRG',
                               'SharedSrvRecord'                    => 'Infoblox::DNS::SharedRecord::SRV',
                               'SharedTxtRecord'                    => 'Infoblox::DNS::SharedRecord::TXT',
                               'SnmpUser'                           => 'Infoblox::Grid::SNMP::User',
                               'SoaRecord'                          => 'NOSEARCH',
                               'SrvRecord'                          => 'Infoblox::DNS::Record::SRV',
                               'TFTPDir'                            => 'NOSEARCH',
                               'TFTPDirFile'                        => 'Infoblox::Grid::FileDistributionDir',
                               'TFTPFile'                           => 'NOSEARCH',
                               'Tenant'                             => 'Infoblox::Grid::CloudAPI::Tenant',
                               'TlsaRecord'                         => 'Infoblox::DNS::Record::TLSA',
                               'TxtRecord'                          => 'Infoblox::DNS::Record::TXT',
                               'View'                               => 'Infoblox::DNS::View',
                               'WorkflowApproval'                   => 'Infoblox::Grid::ApprovalWorkflow',
                              );

#
#
#
#
#
#
#

    %_reverse_acceptable_ibap_types = reverse %_acceptable_ibap_types;

    $_return_fields_initialized=0;
    @_return_fields =
      (
       tField('matched_property'),
       tField('matched_value'),
       tField('resource_type'),
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

        my @objtype_returnfields;
        my %seen;

        foreach my $t ( keys %_acceptable_ibap_types) {
            next if defined $seen{$_acceptable_ibap_types{$t}};
            next if $_acceptable_ibap_types{$t} !~ m/Infoblox/;

            #
            my $x = $_acceptable_ibap_types{$t}->__new__();
            $seen{$_acceptable_ibap_types{$t}} = 1;

            push @objtype_returnfields, tFieldObjType($t,
                                                       {
                                                        sub_fields => $x->__return_fields__()
                                                       }
                                                      );

            #
            if ($_acceptable_ibap_types{$t} eq 'Infoblox::DNS::Zone') {
                foreach ('AuthZone','StubZone','DelegatedZone','ForwardZone') {
                    push @objtype_returnfields, tFieldObjType($_,
                                                              {
                                                               sub_fields => $x->__return_fields__()
                                                              }
                                                             );
                }
            }
        }

        push @_return_fields,
          tField('resource',
                 {
                  default_no_access_ok => 1,
                  sub_fields => \@objtype_returnfields,
                 }
                );

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

sub __search_mapping_hook_pre__
{
    my ($self, $session, $type, $argsref, $out_search_fields_ref, $out_search_types_ref, $out_search_matches_ref) = @_;

    #
    #
    #
    #
    #
    #

    my %_one_of_params = (
        address       => 1,
        mac_address   => 1,
        duid          => 1,
        fqdn          => 1,
    );

    my %_any_of_params = (
        extensible_attributes   => 1,
        search_string           => 1,
        object_type             => 1,
        extattrs                => 1,
        return_multiple_objects => 1,
    );

    my @one_of = grep { exists $_one_of_params{$_} } keys %$argsref;
    my @any_of = grep { exists $_any_of_params{$_} } keys %$argsref;

    #
    if (@one_of > 1) {

        set_error_codes(1002, 'Only one of ' . (join ', ', keys %_one_of_params) . 
            ' parameters is supported in one call');

        return undef;

    #
    } elsif (@one_of and @any_of) {

        set_error_codes(1002, $one_of[0] . ' is incompatible with ' .
            (join ', ', keys %_any_of_params) . ' parameters');

        return undef;

    #
    } elsif (not @one_of and not defined $$argsref{return_multiple_objects}) {

        $out_search_fields_ref->{'return_multiple_objects'} = tBool(0);
        $out_search_types_ref->{'return_multiple_objects'}='EXACT';
        $out_search_matches_ref->{'return_multiple_objects'} = undef;
    }

    return 1;
}

#
#
#

sub __i2o_object__ {
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    my $t = ibap_i2o_generic_object_convert(@_);

    if (ref($t) =~ m/Infoblox/) {
        return($t);
    }
    else {
        #
        return undef;
    }
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    #
    #

    if ($self->{'object'}) {
        #
        #
        $self->{'object_type'} = ref($self->{'object'});

#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
    }
    else {
        $self->{'object_type'} = 'UNSUPPORTED';
    }

	return;
}

#
#
#

sub __o2i_objtype__
{
    my ($self, $session, $current, $tempref, $type) = @_;

    if ($$tempref{$current}) {
        my $objtype = $$tempref{$current};
        my $object;

        unless (defined $_reverse_acceptable_ibap_types{$objtype}) {
            set_error_codes(1103, "$objtype is not a valid object type", $self);
            return (0);
        }

        if ($_reverse_acceptable_ibap_types{$objtype} eq 'NOSEARCH') {
            set_error_codes(1103, "$objtype objects do not support global search", $self);
            return (0);
        }

        my $ibap_type = $_reverse_acceptable_ibap_types{$objtype};

        #
        if ($objtype =~ m/Infoblox/) {
            eval { $object = $objtype->__new__(); };
            if ($@) {
                set_error_codes(1103, "$objtype is not a valid object type", $self);
                return (0);
            }

            my %dummy; # XXX: note we assume that the type does not depend on the search args.
            $ibap_type = $object->__ibap_object_type__($type, $session, \%dummy);

            unless ($ibap_type) {
                set_error_codes(1103, "$objtype is not a valid object type", $self);
                return (0);
            }

            if ($_acceptable_ibap_types{$ibap_type} eq 'NOSEARCH') {
                set_error_codes(1103, "$objtype does not support global search", $self);
                return (0);
            }
        }

        return (1,0, ibap_value_o2i_string($ibap_type));
    }
    else {
        return (1,1,undef);
    }
}

#
#
#

1;
