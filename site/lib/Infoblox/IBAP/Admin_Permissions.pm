package Infoblox::Grid::Admin::Permission;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use Data::Dumper;

use vars qw( @ISA %__admin_permission_resource_object_to_ibap__ %__admin_permission_ibap_to_resource_object__ %__admin_permission_all_mappings__ %__admin_permission_all_valid_submappings__ %__admin_permission_all_reverse_mappings__ $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object %_capabilities $_return_fields_initialized);
@ISA = qw ( Infoblox );

#

BEGIN {
    $_object_type = 'AccessRight';
    register_wsdl_type('ib:AccessRight', 'Infoblox::Grid::Admin::Permission');

    %_capabilities = (
                      'depth'                  => 0,
                      'implicit_defaults'      => 0,
                      'single_serialization' => 0,
                     );

    %_allowed_members = (
                         admin_group     => 'admin_group' ,
                         role          => 'role' ,
                         permission      => 'permission' ,
                         resource_type     => 'resource_type' ,
                         resource_object => 'resource_object' ,
                        );

    %_searchable_fields = (
                           admin_group     => [\&__o2i_admin_group__   ,'entity'        , 'EXACT'],
                           role            => [\&__o2i_role__          ,'entity'        , 'EXACT'],
                           resource_object => [\&__o2i_resource__      ,'resource'      , 'EXACT'],
                           resource_type   => [\&__o2i_resource_type__ ,'resource_type' , 'EXACT'],
                           permission      => [\&__o2i_permission__    ,'permission'    , 'EXACT'],
                          );

    %_object_to_ibap = (
                        RETURN_FIELDS   => \&ibap_o2i_ignore,
                        admin_group     => \&__o2i_admin_group__,
                        role            => \&__o2i_role__,
                        permission      => \&__o2i_permission__,
                        resource_type   => \&__o2i_resource_type__,
                        resource_object => \&__o2i_resource__,
                       );

    %_name_mappings = (
                       resource_object => 'resource',
                       admin_group       => 'entity',
                       role            => 'entity',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        entity             => \&__i2o_admin_group_or_role__,
                        permission       => \&__i2o_permission__,
                        resource         => \&__i2o_resource__,
                        resource_type => \&__i2o_resource_type__,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('entity', {sub_fields => [tField('name')]}),
                       tField('resource_type'),
                       tField('permission'),
                      );


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
    %__admin_permission_resource_object_to_ibap__ = (
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
                     #
                     #
                     #
                     #
                     'Infoblox::DNS::Record::DTCLBDN' => {
                                     'resource_type' => 'IDNS_LBDN_RECORD',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::Zone' => {
                                     'resource_type' => 'ZONE',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::View' => {
                                     'resource_type' => 'VIEW',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::View' => {
                                     'member_name' => 'name',
                                     'readfield_name' => 'name',
                                     'readfield_type' => 'View',
                                     'resource_type' => 'NETWORK_VIEW',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::Network' => {
                                     'member_name' => 'network',
                                     'readfield_name' => 'network',
                                     'readfield_type' => 'Network',
                                     'resource_type' => 'NETWORK',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::IPv6Network' => {
                                     'member_name' => 'network',
                                     'readfield_name' => 'network',
                                     'readfield_type' => 'IPv6Network',
                                     'resource_type' => 'IPV6_NETWORK',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::IPv6NetworkContainer' => {
                                     'member_name' => 'network',
                                     'readfield_name' => 'network',
                                     'readfield_type' => 'IPv6NetworkContainer',
                                     'resource_type' => 'IPV6_NETWORK_CONTAINER',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::Grid::Member' => {
                                     'readfield_type' => 'Member',
                                     'resource_type' => 'MEMBER',
                                     'member_function' => \&__member_convert__,
                                     },
                     'Infoblox::Grid::Member::DHCP' => {
                                     'resource_type' => 'MEMBER_DHCP_PROPERTIES',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::Grid::Member::DNS' => {
                                     'resource_type' => 'MEMBER_DNS_PROPERTIES',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::Grid::MSServer' => {
                                     'resource_type' => 'MSSERVER',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::Grid::MSServer::AdSites::Domain' => {
                                     'resource_type' => 'MS_ADSITES_DOMAIN',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::MSSuperscope' => {
                                     'resource_type' => 'MS_SUPERSCOPE',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::Filter::MAC' => {
                                     'member_name' => 'name',
                                     'readfield_name' => 'name',
                                     'readfield_type' => 'DhcpMacFilter',
                                     'resource_type' => 'DHCP_MAC_FILTER',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::SharedNetwork' => {
                                     'member_name' => 'name',
                                     'readfield_name' => 'name',
                                     'readfield_type' => 'SharedNetwork',
                                     'resource_type' => 'SHARED_NETWORK',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::IPv6SharedNetwork' => {
                                     'member_name' => 'name',
                                     'readfield_name' => 'name',
                                     'readfield_type' => 'IPv6SharedNetwork',
                                     'resource_type' => 'IPV6_SHARED_NETWORK',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::NetworkTemplate' => {
                                     'resource_type' => 'NETWORK_TEMPLATE',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::IPv6NetworkTemplate' => {
                                     'resource_type' => 'IPV6_NETWORK_TEMPLATE',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::FixedAddrTemplate' => {
                                     'resource_type' => 'FIXED_ADDRESS_TEMPLATE',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::IPv6FixedAddrTemplate' => {
                                     'resource_type' => 'IPV6_FIXED_ADDRESS_TEMPLATE',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::RangeTemplate' => {
                                     'resource_type' => 'RANGE_TEMPLATE',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::IPv6RangeTemplate' => {
                                     'resource_type' => 'IPV6_RANGE_TEMPLATE',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::NetworkContainer' => {
                                     'resource_type' => 'NETWORK_CONTAINER',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::BulkHost' => {
                                     'resource_type' => 'BULKHOST',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::Ruleset' =>  {
                                     'resource_type' => 'RULESET',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::SRG' => {
                                     'resource_type' => 'SHARED_RECORD_GROUP',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::Record::A' => {
                                     'resource_type' => 'A',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::Record::AAAA' => {
                                     'resource_type' => 'AAAA',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::Record::CNAME' => {
                                     'resource_type' => 'CNAME',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::Record::DNAME' => {
                                     'resource_type' => 'DNAME',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::Record::MX' => {
                                     'resource_type' => 'MX',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::Record::PTR' => {
                                     'resource_type' => 'PTR',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::Record::NAPTR' => {
                                     'resource_type' => 'NAPTR',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::Record::SRV' => {
                                     'resource_type' => 'SRV',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::Record::TXT' => {
                                     'resource_type' => 'TXT',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::Record::TLSA' => {
                                     'resource_type' => 'TLSA',
                                     'member_function' => \&__generic_object_convert__,
                                     },
           'Infoblox::DNS::SharedRecord::A' => {
                                     'resource_type' => 'SHARED_A',
                                     'member_function' => \&__generic_object_convert__,
                                     },
           'Infoblox::DNS::SharedRecord::AAAA' => {
                                     'resource_type' => 'SHARED_AAAA',
                                     'member_function' => \&__generic_object_convert__,
                                     },
           'Infoblox::DNS::SharedRecord::MX' => {
                                     'resource_type' => 'SHARED_MX',
                                     'member_function' => \&__generic_object_convert__,
                                     },
           'Infoblox::DNS::SharedRecord::SRV' => {
                                     'resource_type' => 'SHARED_SRV',
                                     'member_function' => \&__generic_object_convert__,
                                     },
           'Infoblox::DNS::SharedRecord::TXT' => {
                                     'resource_type' => 'SHARED_TXT',
                                     'member_function' => \&__generic_object_convert__,
                                     },
           'Infoblox::DNS::SharedRecord::CNAME' => {
                                     'resource_type' => 'SHARED_CNAME',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::Grid::DNS::DNS64Group' => {
                                     'resource_type' => 'DNS64_SYNTHESIS_GROUP',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DNS::Host' => {
                                     'resource_type' => 'HOST',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::FixedAddr' => {
                                     'readfield_type' => 'FixedAddress',
                                     'resource_type' => 'FIXED_ADDRESS',
                                     'member_function' => \&__fixedaddr_convert__,
                                     },
                     'Infoblox::DHCP::IPv6FixedAddr' => {
                                     'member_name' => 'duid',
                                     'readfield_name' => 'duid',
                                     'readfield_type' => 'IPv6FixedAddress',
                                     'resource_type' => 'IPV6_FIXED_ADDRESS',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::RoamingHost' => {
                                     'readfield_type' => 'RoamingHost',
                                     'resource_type' => 'ROAMING_HOST',
                                     'member_function' => \&__roaminghost_convert__,
                                     },
                     'Infoblox::DHCP::Range' => {
                                     'readfield_type' => 'DhcpRange',
                                     'resource_type' => 'RANGE',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::DHCP::IPv6Range' => {
                                     'readfield_type' => 'IPv6DhcpRange',
                                     'resource_type' => 'IPV6_RANGE',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::Grid::Member::FileDistribution' => {
                                     'resource_type'  =>
                                            'MEMBER_FILE_DIST_PROPERTIES',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::Grid::FileDistributionDir' => {
                                     'resource_type'    => 'FILE_DIST_DIRECTORY',
                                     'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::Grid::Member::ThreatProtection' => {
                                      'resource_type'   => 'MEMBER_SECURITY_PROPERTIES',
                                      'member_function' => \&__generic_object_convert__,
                                     },
                     'Infoblox::Grid::Discovery::Device' => {
                                      'resource_type'   => 'PORT_CONTROL',
                                      'member_function' => \&__generic_object_convert__,
                                     },

                                  );

    %__admin_permission_ibap_to_resource_object__ = (
                     'AuthZone' => {
                                     'object_type' => 'Infoblox::DNS::Zone',
                                     },
                     'ForwardZone' => {
                                     'object_type' => 'Infoblox::DNS::Zone',
                                     },
                     'StubZone' => {
                                     'object_type' => 'Infoblox::DNS::Zone',
                                     },
                     'DelegatedZone' => {
                                     'object_type' => 'Infoblox::DNS::Zone',
                                     },
                     'AllZone' => {
                                     'object_type' => 'Infoblox::DNS::Zone',
                                     },
                     'ResponsePolicyZone' => {
                                     'object_type' => 'Infoblox::DNS::Zone',
                                     },
                     'Dns64SynthesisGroup' => {
                                     'object_type' => 'Infoblox::Grid::DNS::DNS64Group',
                                     },
                     'View' => {
                                     'object_type' => 'Infoblox::DNS::View',
                                     },

                     'Network' => {
                                     'object_type' => 'Infoblox::DHCP::Network',
                                     },
                     'IPv6Network' => {
                                     'object_type' => 'Infoblox::DHCP::IPv6Network',
                                     },
                     'Member' => {
                                     'object_type' => 'Infoblox::Grid::Member',
                                     },
                     'MemberDhcp' => {
                                     'object_type' => 'Infoblox::Grid::Member::DHCP',
                                     },
                     'MemberDns' => {
                                     'object_type' => 'Infoblox::Grid::Member::DNS',
                                     },
                     'MsServer' => {
                                     'object_type' => 'Infoblox::Grid::MSServer',
                                     },
                     'MsAdSitesDomain' => {
                                     'object_type' => 'Infoblox::Grid::MSServer::AdSites::Domain',
                                     },
                     'SharedNetwork' => {
                                     'object_type' => 'Infoblox::DHCP::SharedNetwork',
                                     },
                     'IPv6SharedNetwork' => {
                                     'object_type' => 'Infoblox::DHCP::IPv6SharedNetwork',
                                     },
                     'NetworkTemplate' => {
                                     'object_type' => 'Infoblox::DHCP::NetworkTemplate',
                                     },
                     'IPv6NetworkTemplate' => {
                                     'object_type' => 'Infoblox::DHCP::IPv6NetworkTemplate',
                                     },
                     'NetworkContainer' => {
                                     'object_type' => 'Infoblox::DHCP::NetworkContainer',
                                     },
                     'IPv6NetworkContainer' => {
                                     'object_type' => 'Infoblox::DHCP::IPv6NetworkContainer',
                                     },
                     'NetworkView' => {
                                     'object_type' => 'Infoblox::DHCP::View',
                                     },
                     'DhcpRangeTemplate' => {
                                     'object_type' => 'Infoblox::DHCP::RangeTemplate',
                                     },
                     'FixedAddressTemplate' => {
                                     'object_type' => 'Infoblox::DHCP::FixedAddrTemplate',
                                     },
                     'BulkHost' => {
                                     'object_type' => 'Infoblox::DNS::BulkHost',
                                     },
                     'SharedRecordGroup' => {
                                     'object_type' => 'Infoblox::DNS::SRG',
                                     },
                     'ARecord' => {
                                     'object_type' => 'Infoblox::DNS::Record::A',
                                     },
                     'AaaaRecord' => {
                                     'object_type' => 'Infoblox::DNS::Record::AAAA',
                                     },
                     'CnameRecord' => {
                                     'object_type' => 'Infoblox::DNS::Record::CNAME',
                                     },
                     'DnameRecord' => {
                                     'object_type' => 'Infoblox::DNS::Record::DNAME',
                                     },
                     'MxRecord' => {
                                     'object_type' => 'Infoblox::DNS::Record::MX',
                                     },
                     'PtrRecord' => {
                                     'object_type' => 'Infoblox::DNS::Record::PTR',
                                     },
                     'NaptrRecord' => {
                                     'object_type' => 'Infoblox::DNS::Record::NAPTR',
                                     },
                     'SrvRecord' => {
                                     'object_type' => 'Infoblox::DNS::Record::SRV',
                                     },
                     'TxtRecord' => {
                                     'object_type' => 'Infoblox::DNS::Record::TXT',
                                     },
                     'TlsaRecord' => {
                                     'object_type' => 'Infoblox::DNS::Record::TLSA',
                                     },
                     'SharedARecord' => {
                                     'object_type' => 'Infoblox::DNS::SharedRecord::A',
                                     },
                     'SharedAaaaRecord' => {
                                     'object_type' => 'Infoblox::DNS::SharedRecord::AAAA',
                                     },
                     'SharedMxRecord' => {
                                     'object_type' => 'Infoblox::DNS::SharedRecord::MX',
                                     },
                     'SharedSrvRecord' => {
                                     'object_type' => 'Infoblox::DNS::SharedRecord::SRV',
                                     },
                     'SharedTxtRecord' => {
                                     'object_type' => 'Infoblox::DNS::SharedRecord::TXT',
                                     },
                     'SharedCnameRecord' => {
                                     'object_type' => 'Infoblox::DNS::SharedRecord::CNAME',
                                     },
                     'HostRecord' => {
                                     'object_type' => 'Infoblox::DNS::Host',
                                     },
                     'FixedAddress' => {
                                     'object_type' => 'Infoblox::DHCP::FixedAddr',
                                     },
                     'IPv6FixedAddress' => {
                                     'object_type' => 'Infoblox::DHCP::IPv6FixedAddr',
                                     },
                     'IPv6FixedAddressTemplate' => {
                                     'object_type' => 'Infoblox::DHCP::IPv6FixedAddrTemplate',
                                     },
                     'DhcpRange' => {
                                     'object_type' => 'Infoblox::DHCP::Range',
                                     },
                     'IPv6DhcpRange' => {
                                     'object_type' => 'Infoblox::DHCP::IPv6Range',
                                     },
                     'IPv6DhcpRangeTemplate' => {
                                     'object_type' => 'Infoblox::DHCP::IPv6RangeTemplate',
                                     },
                     'DhcpMacFilter' => {
                                     'object_type' => 'Infoblox::DHCP::Filter::MAC',
                                     },
                     'MemberFD' => {
                                     'object_type' => 'Infoblox::Grid::Member::FileDistribution',
                                     },
                     'TFTPDirFile' => {
                                     'object_type' => 'Infoblox::Grid::FileDistributionDir',
                                     },
                     'Ruleset' => {
                             'object_type' => 'Infoblox::DNS::Ruleset'
                                  },
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
                     'MaxMindDBInfo' => {
                             'object_type' => 'Infoblox::Grid::MaxMindDBInfo',
                     },
                     'IdnsCertificate' => {
                             'object_type' => 'Infoblox::DTC::Certificate',
                     },
                     'IdnsLbdnRecord' => {
                             'object_type' => 'Infoblox::DNS::Record::DTCLBDN',
                     },
#
#
#
                     'MemberAtp' => {
                            'object_type' => 'Infoblox::Grid::Member::ThreatProtection',
                           },
                     'Device' => {
                            'object_type' => 'Infoblox::Grid::Discovery::Device',
                           },
                                  );

    %__admin_permission_all_mappings__ = (
                         'SCHEDULE_TASK'              => 'Scheduling',

                         'AAAA'                      => 'All AAAA Records',
                         'A'                          => 'All A Records',
                         'BULKHOST'                  => 'All BULKHOST Records',
                         'CNAME'                      => 'All CNAME Records',
                         'CSV_IMPORT_TASK'        => 'All CSV Import Tasks',
                         'DASHBOARD_TASK'         => 'All Dashboard Tasks',
                         'DHCP_LEASE_HISTORY'        => 'All IPv4 DHCP Lease History',
                         'DNAME'                      => 'All DNAME Records',
                         'GRID_DHCP_PROPERTIES'   => 'Grid DHCP properties',
                         'GRID_DNS_PROPERTIES'    => 'Grid DNS properties',
                         'RECLAMATION'         => 'DNS Scavenging',
                         'DEFINED_ACL'            => 'All Named ACLs',
                         'FIXED_ADDRESS'              => 'All IPv4 DHCP Fixed Addresses/Reservations',
                         'HOST'                      => 'All Host Records',
                         'HOST_ADDRESS'                  => 'All IPv4 Host Addresses',
                         'IPV6_HOST_ADDRESS'              => 'All IPv6 Host Addresses',
                         'IPV6_FIXED_ADDRESS'      => 'All IPv6 DHCP Fixed Addresses',
                         'IPV6_DHCP_LEASE_HISTORY' => 'All IPv6 DHCP Lease History',
                         'IPV6_NETWORK'                 => 'All IPv6 Networks',
                         'IPV6_RANGE'                 => 'All IPv6 Ranges',
                         'IPV6_SHARED_NETWORK'       => 'All IPv6 DHCP Shared Networks',
                         'IPV6_TEMPLATE'           => 'All IPv6 DHCP Templates',
                         'KERBEROS_KEY'           => 'All Kerberos Keys',
                         'BFD_TEMPLATE'           => 'All BFD Templates',
                         'DHCP_MAC_FILTER'        => 'All Mac Address Filters',
                         'DNS64_SYNTHESIS_GROUP'  => 'All DNS64 Synthesis Groups',
                         'MEMBER'                      => 'All Members',
                         'MX'                          => 'All MX Records',
                         'MSSERVER'                     => 'All MS Server Members',
                         'MS_ADSITES_DOMAIN'      => 'All Microsoft Active Directory Domains',
                         'MS_SUPERSCOPE'             => 'All Microsoft Superscopes',
                         'NETWORK'                      => 'All IPv4 Networks',
                         'NETWORK_VIEW'                 => 'All Network Views',
                         'NETWORK_DISCOVERY'      => 'Network Discovery',
                         'PTR'                          => 'All PTR Records',
                         'RESTART_SERVICE'        => 'Restart',
                         'RANGE'                      => 'All IPv4 Ranges',
                         'ROAMING_HOST'           => 'All Roaming Hosts',
                         'RULESET'                => 'All Rulesets',
                         'SHARED_A'              => 'All Shared A Records',
                         'SHARED_AAAA'              => 'All Shared AAAA Records',
                         'SHARED_MX'              => 'All Shared MX Records',
                         'SHARED_NETWORK'              => 'All IPv4 DHCP Shared Networks',
                         'SHARED_RECORD_GROUP'       => 'All Shared Record Groups',
                         'SHARED_SRV'              => 'All Shared SRV Records',
                         'SHARED_TXT'              => 'All Shared TXT Records',
                         'SHARED_CNAME'              => 'All Shared CNAME Records',
                         'SRV'                          => 'All SRV Records',
                         'TEMPLATE'                  => 'All IPv4 DHCP Templates',
                         'TXT'                          => 'All TXT Records',
                         'TLSA'                          => 'All TLSA Records',
                         'VIEW'                      => 'All DNS Views',
                         'ZONE'                      => 'All Zones',
                         'GRID_FILE_DIST_PROPERTIES'  => 'Grid File Distribution Properties',
                         'GRID_AAA_PROPERTIES'  => 'Grid AAA Properties',
                         'AAA_EXTERNAL_SERVICE' => 'All AAA External Services',
                         'FIXED_ADDRESS_TEMPLATE'      => 'All IPv4 DHCP Fixed Address Templates',
                         'IPV6_FIXED_ADDRESS_TEMPLATE' => 'All IPv6 DHCP Fixed Address Templates',
                         'NAPTR'                       => 'All NAPTR Records',
                         'RANGE_TEMPLATE'              => 'All IPv4 Range Templates',
                         'IPV6_RANGE_TEMPLATE'         => 'All IPv6 Range Templates',
                         'HSM_GROUP'                   => 'All HSM Groups',
                         'OCSP_SERVICE'                => 'All Certificate Auth Services',
                         'CA_CERTIFICATE'              => 'All CA Certificates',

                         'RESPONSE_POLICY_ZONE' => 'All Response Policy Zones',
                         'RESPONSE_POLICY_RULE' => 'All Response Policy Rules',

                         'GRID_SECURITY_PROPERTIES'  => 'Grid Security configuration',

                         'IDNS_TOPOLOGY'    => 'All DTC Topologies',
                         'IDNS_LBDN'        => 'All DTC LBDNs',
                         'IDNS_LBDN_RECORD' => 'All DTC LBDN Records',
                         'IDNS_MONITOR'     => 'All DTC Monitors',
                         'IDNS_SERVER'      => 'All DTC Servers',
                         'IDNS_POOL'        => 'All DTC Pools',
                         'IDNS_GEO_IP'      => 'All DTC GeoIP',
                         'IDNS_CERTIFICATE' => 'All DTC Certificates',

                         #
                         'GRID_REPORTING_PROPERTIES' => 'Grid Reporting properties',
                         'REPORTING_DASHBOARD'       => 'Reporting dashboard',
                         'REPORTING_SEARCH'          => 'Reporting search',

                         'DHCP_FINGERPRINT'          => 'All DHCP Fingerprints',
                         'PORT_CONTROL'              => 'Port Control',
                         'ADD_A_RR_WITH_EMPTY_HOSTNAME' => 'Allow adding A/AAAA records with empty hostname',
                         'DELETED_OBJS_INFO_TRACKING' => 'Allow deleted objects information tracking',



                        );

    %__admin_permission_all_reverse_mappings__ = (
                         'scheduling'                 => 'SCHEDULE_TASK',

             'all aaaa records'               => 'AAAA',
                         'all a records'                => 'A',
                         'all bulkhost records'           => 'BULKHOST',
                         'all cname records'           => 'CNAME',
                         'all csv import tasks'        => 'CSV_IMPORT_TASK',
                         'all dashboard tasks'         => 'DASHBOARD_TASK',
                         'all dname records'           => 'DNAME',
                         'all dns64 synthesis groups'  => 'DNS64_SYNTHESIS_GROUP',
                         'all named acls'              => 'DEFINED_ACL',

                         #
                         'all fixed addresses/reservations'           => 'FIXED_ADDRESS',
                         'all ipv4 dhcp fixed addresses/reservations'   => 'FIXED_ADDRESS',

                         'all ipv6 dhcp fixed addresses' => 'IPV6_FIXED_ADDRESS',
                         'all ipv4 host addresses' => 'HOST_ADDRESS',
                         'all ipv6 host addresses' => 'IPV6_HOST_ADDRESS',
                         'all host records'               => 'HOST',
                         'all ipv6 networks'           => 'IPV6_NETWORK',
                         #
                         'all ipv6 dhcp ranges'           => 'IPV6_RANGE',
                         'all ipv6 ranges'               => 'IPV6_RANGE',
                         'all mac address filters'       => 'DHCP_MAC_FILTER',
                         'all members'                   => 'MEMBER',
                         'all microsoft superscopes'   => 'MS_SUPERSCOPE',
                         'all mx records'               => 'MX',
                         'all ms server members'       => 'MSSERVER',
                         'all microsoft active directory domains' => 'MS_ADSITES_DOMAIN',

                         #
                         'all networks'                   => 'NETWORK',
                         'all ipv4 networks'           => 'NETWORK',

                         'all network views'           => 'NETWORK_VIEW',
                         'all ptr records'               => 'PTR',

                         #
                         'all ranges'                   => 'RANGE',
                         'all ipv4 dhcp ranges'           => 'RANGE',
                         'all ipv4 ranges'               => 'RANGE',

                         'all roaming hosts'           => 'ROAMING_HOST',
                         'all rulesets'                => 'RULESET',
                         'all shared a records'       => 'SHARED_A',
                         'all shared aaaa records'       => 'SHARED_AAAA',
                         'all shared mx records'       => 'SHARED_MX',

                         #
                         'all shared networks'           => 'SHARED_NETWORK',
                         'all ipv4 dhcp shared networks' => 'SHARED_NETWORK',

                         'all ipv6 dhcp shared networks' => 'IPV6_SHARED_NETWORK',
                         'all shared record groups'       => 'SHARED_RECORD_GROUP',
                         'all shared srv records'       => 'SHARED_SRV',
                         'all shared txt records'       => 'SHARED_TXT',
                         'all shared cname records'       => 'SHARED_CNAME',
                         'all srv records'               => 'SRV',

                         #
                         'all templates'               => 'TEMPLATE',
                         'all ipv4 dhcp templates'       => 'TEMPLATE',

                         'all ipv6 dhcp templates'       => 'IPV6_TEMPLATE',
                         'all txt records'               => 'TXT',
                         'all tlsa records'               => 'TLSA',
                         'all dns views'               => 'VIEW',
                         'network discovery'           => 'NETWORK_DISCOVERY',

                         #
                         #
                         'all views'                   => 'VIEW',

                         'all zones'                   => 'ZONE',
                         'all response policy zones'   => 'RESPONSE_POLICY_ZONE',
                         'all response policy rules'   => 'RESPONSE_POLICY_RULE',

                         #
                         'lease history access'           => 'DHCP_LEASE_HISTORY',
                         'grid dhcp properties'       => 'GRID_DHCP_PROPERTIES',
                         'grid dns properties'        => 'GRID_DNS_PROPERTIES',
                         'all ipv4 dhcp lease history' => 'DHCP_LEASE_HISTORY',

                         'all ipv6 dhcp lease history' => 'IPV6_DHCP_LEASE_HISTORY',
                         'grid file distribution properties' => 'GRID_FILE_DIST_PROPERTIES',
                         'grid aaa properties'        => 'GRID_AAA_PROPERTIES',
                         'all aaa external services'  => 'AAA_EXTERNAL_SERVICE',
                         'restart'                    => 'RESTART_SERVICE',
                         'all hsm groups'             => 'HSM_GROUP',
                         'all certificate auth services' => 'OCSP_SERVICE',
                         #
                         'all ocsp services'             => 'OCSP_SERVICE',
                         'all ca certificates'        => 'CA_CERTIFICATE',

                         'grid security configuration'   => 'GRID_SECURITY_PROPERTIES',
                         'all kerberos keys'                => 'KERBEROS_KEY',
                         'all bfd templates'                => 'BFD_TEMPLATE',

                         'all dtc topologies'   => 'IDNS_TOPOLOGY',
                         'all dtc lbdns'        => 'IDNS_LBDN',
                         'all dtc lbdn records' => 'IDNS_LBDN_RECORD',
                         'all dtc monitors'     => 'IDNS_MONITOR',
                         'all dtc servers'      => 'IDNS_SERVER',
                         'all dtc pools'        => 'IDNS_POOL',
                         'all dtc geoip'        => 'IDNS_GEO_IP',
                         'all dtc certificates' => 'IDNS_CERTIFICATE',
                         'dns scavenging'      => 'RECLAMATION',

                         #
                         'grid reporting properties'     => 'GRID_REPORTING_PROPERTIES',
                         'reporting dashboard'           => 'REPORTING_DASHBOARD',
                         'reporting search'              => 'REPORTING_SEARCH',

                         'all dhcp fingerprints'         => 'DHCP_FINGERPRINT',
                         'port control'                  => 'PORT_CONTROL',
                         'allow adding a/aaaa records with empty hostname' => 'ADD_A_RR_WITH_EMPTY_HOSTNAME',
                         'allow deleted objects information tracking' => 'DELETED_OBJS_INFO_TRACKING',



                         #
                         'all ipv4 dhcp fixed address templates' => 'FIXED_ADDRESS_TEMPLATE',
                         'all ipv6 dhcp fixed address templates' => 'IPV6_FIXED_ADDRESS_TEMPLATE',
                         'all naptr records'                     => 'NAPTR',
                         'all ipv4 range templates'              => 'RANGE_TEMPLATE',
                         'all ipv6 range templates'              => 'IPV6_RANGE_TEMPLATE',
                        );

    %__admin_permission_all_valid_submappings__ = (
                         'AAAA'          => 1,
                         'A'              => 1,
                         'BULKHOST'         => 1,
                         'CNAME'          => 1,
                         'DNAME'          => 1,
                         'MX'              => 1,
                         'NAPTR'         => 1,
                         'PTR'              => 1,
                         'SRV'              => 1,
                         'TXT'              => 1,
                         'TLSA'              => 1,
                         'HOST'          => 1,
                         'IPV6_FIXED_ADDRESS' => 1,
                         'IPV6_RANGE'      => 1,
                         'IPV6_SHARED_NETWORK' => 1,
                         'FIXED_ADDRESS' => 1,
                         'MS_SUPERSCOPE' => 1,
                         'NETWORK'       => 1,
                         'RANGE'         => 1,
                         'ROAMING_HOST'  => 1,
                         'ZONE'          => 1,
                         'RESTART_SERVICE' => 1,
                         'SHARED_A'      => 1,
                         'SHARED_AAAA'   => 1,
                         'SHARED_MX'     => 1,
                         'SHARED_NETWORK' => 1,
                         'SHARED_SRV'    => 1,
                         'SHARED_TXT'    => 1,
                         'SHARED_CNAME'    => 1,
                         'RESPONSE_POLICY_ZONE' => 1,
                         'RESPONSE_POLICY_RULE' => 1,
                         'PORT_CONTROL'  => 1,
                         'HOST_ADDRESS'      => 1,
                         'IPV6_HOST_ADDRESS' => 1,
                        );
};

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = {};
    bless $self , $class;

    foreach my $key ( keys %args )
    {
        if( not exists $_allowed_members{ $key } )
        {
            set_error_codes(1101,"$key is not allowed as an argument!" );
            return;
        }

        if( not $self->$key( $args{ $key } ) )
        {
            set_error_codes(1102,"Cannot set member $key." );
            return;
        }
    }

    if( (not defined $args{ 'resource_type' }) && (not defined $args { 'resource_object' }) )
    {
        set_error_codes(1103,"At least one of resource_type and resource_object is required." );
        return;
    }

    if( (not defined $args{ 'permission' }) )
    {
        set_error_codes(1103,'permission is required.' );
        return;
    }

    if( (not defined $args{ "admin_group" }) && (not defined $args{ "role" }) )
    {
        set_error_codes(1103,"At least one of admin_group and role is required." );
        return;
    }

    if( (defined $args{ "admin_group" }) && (defined $args{ "role" }) )
    {
        set_error_codes(1103,"Cannot set both admin_group and role." );
        return;
    }

    $self->__init_instance_constants__();

    return $self;

}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = {};
    bless $self , $class;

    $self->__init_instance_constants__();

    return $self;
}

sub __init_instance_constants__
{
    my $self = shift;

    unless ($_return_fields_initialized) {
        $_return_fields_initialized=1;

        my @resource_returnfields;
        foreach my $t ( keys %__admin_permission_ibap_to_resource_object__ ) {
            #
            my $x = $__admin_permission_ibap_to_resource_object__{$t}->{'object_type'}->__new__();

            push @resource_returnfields, tFieldObjType($t,
                                                       {
                                                        sub_fields => $x->__return_fields__()
                                                       }
                                                      );
        }

        push @_return_fields,
          tField('resource',
                 {
                  default_no_access_ok => 1,
                  sub_fields => \@resource_returnfields,
                 }
                );
    }
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

sub __search_mapping_fields__
{
    return Infoblox::IBAPBase::__search_mapping_fields__(@_);
}

sub __get_class_methods_class__
{
    my $self=shift;
    return ref($self);
}

sub __dump__
{
    my $self = shift;

    return Infoblox::IBAPBase::__dump__($self)
}

#
#
#

sub __i2o_admin_group_or_role__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
        if (ref($$ibap_object_ref{$current}) eq 'ib:Role' ) {
            $self->role($$ibap_object_ref{$current}{'name'});
        } else {
            $self->admin_group($$ibap_object_ref{$current}{'name'});
        }
    } else {
        return;
    }
}

sub __i2o_permission__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
        if ($$ibap_object_ref{$current} eq 'RO') {
            $self->permission('read');
        } elsif ($$ibap_object_ref{$current} eq 'RW') {
            $self->permission('write');
        } else {
            $self->permission('deny');
        }
    } else {
        return;
    }
}

sub __i2o_resource_type__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

    if (defined $$ibap_object_ref{'resource'}) {
        #
        return;
    }

    if ($$ibap_object_ref{$current}) {
        $self->resource_type($__admin_permission_all_mappings__{$$ibap_object_ref{$current}});
    } else {
        return;
    }
}

sub __i2o_resource__
{
    my ($self, $session, $current, $ibap_object_ref,
        $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current}) {
        (my $ibaptype = ref($$ibap_object_ref{$current})) =~ s/^ib://;
        if (defined $__admin_permission_ibap_to_resource_object__{$ibaptype}) {
            my $tcurrent = $__admin_permission_ibap_to_resource_object__{$ibaptype};

            my $obj=$$tcurrent{'object_type'}->__new__();
            if ($$ibap_object_ref{$current}{'access'} && $$ibap_object_ref{$current}{'access'} eq 'SHOW') {

                #
                #
                $obj->__ibap_to_object__($$ibap_object_ref{$current}, $session->get_ibap_server(), $session, $return_object_cache_ref);
                $self->resource_object($obj);
            }
            else {
                my $obj=$$tcurrent{'object_type'}->__new__();
                $obj->__ibap_to_object__($$ibap_object_ref{$current}, $session->get_ibap_server(), $session, $return_object_cache_ref);
                $self->resource_object($obj);
            }
        }
        else {
            #
            return;
        }
    }

    if ($$ibap_object_ref{'resource_type'}) {
        $self->resource_type($__admin_permission_all_mappings__{$$ibap_object_ref{'resource_type'}});
    }
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session,
        $return_object_cache_ref) = @_;

    foreach my $current (sort keys %$ibap_object_ref) {
        my $method = $current;

        if (defined $_reverse_name_mappings{$current}) {
            $method = $_reverse_name_mappings{$current};
        }
        elsif ($current eq 'object_id') {
            $self->__object_id__($$ibap_object_ref{$current}{'id'});
            next;
        }

        if (defined $_ibap_to_object{$current}) {
            $_ibap_to_object{$current}($self, $session, $current, $ibap_object_ref, $return_object_cache_ref);
        } else {
            $self->$method($$ibap_object_ref{$current});
        }
    }

#
#
#
#
#
#

    $self->__object_id__($$ibap_object_ref{'object_id'}{'id'});

    return;
}

#
#
#

sub __range_convert__
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        my $start_addr = $$tempref{$current}->start_addr();
        return ibap_readfield_simple_string('DhcpRange','start_address', $start_addr, $current);
    }
}

sub __ipv6_range_convert__
{
    my ($self, $session, $current, $tempref) = @_;

    #
    #
    #
    if (defined $$tempref{$current}) {
        my $start_addr = $$tempref{$current}->start_addr();
        my $start_prefix = $$tempref{$current}->ipv6_start_prefix();

        my @search_params;
        my $err_msg = '';
        if ($start_addr) {
            push @search_params, {
                'field' => 'start_address',
                'value' => ibap_value_o2i_string($start_addr),
            };
            $err_msg .= 'start_addr=' . $start_addr;
        }
        if ($start_prefix) {
            push @search_params, {
                'field' => 'ipv6_start_prefix',
                'value' => ibap_value_o2i_string($start_prefix),
            };
            $err_msg .= ',' if $err_msg;
            $err_msg .= 'start_addr=' . $start_addr;
        }

        return ibap_readfield_simple('IPv6DhcpRange', \@search_params, undef, $err_msg);
    }
}

sub __network_convert__
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        my $network = $$tempref{$current}->network();

        $network =~ m!^([0-9\.]+)/([0-9\.]+)$!;
        my $address = $1;

        #
        #
        my $netmask = $2;
        if ( $netmask =~ m/^[0-9]{1,2}$/ ) {
            $netmask = cidr_to_mask($netmask);
        }

        my @fields = (
                      {
                       'field' => 'address',
                       'value' => ibap_value_o2i_string($address),
                      },
                      {
                       'field' => 'netmask',
                       'value' => ibap_value_o2i_string($netmask),
                      },
                     );
        return ibap_readfield_simple('Network',\@fields,undef,'network='.$address.'/'.$netmask);
    }
}

sub __member_convert__
{
    my ($self, $session, $current, $tempref) = @_;

    return ibap_value_o2i_member_nocache($$tempref{$current},$session,$current,1);
}

sub __fixedaddr_convert__
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        my $errortagparams = '';
        my @fields;

        if ($$tempref{$current}->ipv4addr()) {
            push @fields, (
                           {
                            'field' => 'ip_address',
                            'value' => ibap_value_o2i_string($$tempref{$current}->ipv4addr()),
                           }
                          );
        }

        if ($$tempref{$current}->network()) {
            my $network = $$tempref{$current}->network();
            $network =~ m!^([0-9\.]+)/([0-9\.]+)$!;
            my $address = $1;

            #
            #
            my $netmask = $2;
            if ( $netmask =~ m/^[0-9]{1,2}$/ ) {
                $netmask = cidr_to_mask($netmask);
            }

            my @subfields = (
                             {
                              'field' => 'address',
                              'value' => ibap_value_o2i_string($address),
                             },
                             {
                              'field' => 'netmask',
                              'value' => ibap_value_o2i_string($netmask),
                             },
                            );

            push @fields, {
                           'field' => 'parent',
                           'value' => ibap_readfield_simple('Network',\@subfields,undef,'network='.$address.'/'.$netmask),
                          };

            $errortagparams=$address.'/'.$netmask.' ';
        }

        if ($$tempref{$current}->mac()) {
            push @fields, {
                           'field' => 'mac_address',
                           'value' => ibap_value_o2i_string($$tempref{$current}->mac()),
                          };

            $errortagparams.= $$tempref{$current}->mac() . ' ';
        }

        if ($$tempref{$current}->dhcp_client_identifier()) {
            push @fields, {
                           'field' => 'dhcp_client_identifier',
                           'value' => ibap_value_o2i_string($$tempref{$current}->dhcp_client_identifier()),
                          };

            $errortagparams.= $$tempref{$current}->dhcp_client_identifier() . ' ';
        }

        chop $errortagparams;
        return ibap_readfield_simple('FixedAddress',\@fields,undef,'fixed_address='.$errortagparams);
    }
}

sub __roaminghost_convert__
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        my $errortagparams;
        my @fields;

        if ($$tempref{$current}->name()) {
            push @fields, (
                           {
                            'field' => 'name',
                            'value' => ibap_value_o2i_string($$tempref{$current}->name()),
                           }
                          );

            $errortagparams=$$tempref{$current}->name() . ' ';
        }

        if ($$tempref{$current}->mac()) {
            push @fields, {
                           'field' => 'mac_address',
                           'value' => ibap_value_o2i_string($$tempref{$current}->mac()),
                          };
            $errortagparams=$$tempref{$current}->name() . ' ';
        }

        if ($$tempref{$current}->dhcp_client_identifier()) {
            push @fields, {
                           'field' => 'dhcp_client_identifier',
                           'value' => ibap_value_o2i_string($$tempref{$current}->dhcp_client_identifier()),
                          };
            $errortagparams.= $$tempref{$current}->dhcp_client_identifier() . ' ';
        }

        chop $errortagparams;
        return ibap_readfield_simple('RoamingHost',\@fields,undef,'roaming_host='.$errortagparams);
    }
}

sub __convert_helper__
{
    my ($self, $session, $current, $tempref) = @_;

    my $readfield_type = $$tempref{$current}->__ibap_object_type__('search',$session);
    my (@fields,$ref_searchable_fields,%searchable);

    {
        no strict 'refs';
        my $objclass = $$tempref{$current}->__get_class_methods_class__();
        $ref_searchable_fields  = \%{$objclass . '::_searchable_fields'};
    }

    #
    #
    #
    foreach (keys %{$$tempref{$current}}) {
        if (defined $ref_searchable_fields->{$_}) {
            $searchable{$_}=$$tempref{$current}{$_};
        }
    }

    my ($argsref, $argstyperef, $argsmatchref) = $$tempref{$current}->__search_mapping_fields__($session,'search', \%searchable);
    return unless $argsref;

    my ($lefttag,$righttag) = ('','');
    foreach my $field (keys %$argsref) {
        my %search_arg;
        $search_arg{'field'} = $field;
        $search_arg{'value'} = $argsref->{$field};
        if ($argstyperef->{$field} =~ m/LIST_(.*)/) {
            $search_arg{'list_op'} = $1;
        } else {
            $search_arg{'search_type'} = $argstyperef->{$field};
        }

        if ($argsmatchref->{$field}) {
            $search_arg{'match_case'} = $$argsmatchref{$field};
            $search_arg{'match_case'} =~ s/^GET_//;
        }

        if (ref($argsref->{$field}) =~ m/String|Integer|Bool|DateTime/) {
            $lefttag .= $field . ',';
            $righttag .= $argsref->{$field}->value() . ',';
        }

        push @fields, \%search_arg;
    }
    chop $lefttag if $lefttag;
    chop $righttag if $righttag;

    return ibap_readfield_simple($readfield_type,\@fields,undef,$lefttag . '=' . $righttag);
}

sub __generic_object_convert__
{
    my ($self, $session, $current, $tempref) = @_;
    my $current_task = $__admin_permission_resource_object_to_ibap__{ref($$tempref{$current})};
    my @return_values;

    if (defined($$tempref{'resource_type'}) && $$tempref{'resource_type'} && defined $__admin_permission_all_reverse_mappings__{lc($$tempref{'resource_type'})} ) {
        if (defined $$tempref{$current}) {
            if (defined $__admin_permission_all_valid_submappings__{$__admin_permission_all_reverse_mappings__{lc($$tempref{'resource_type'})}}) {
                #

                if ($$tempref{$current}->can('__object_id__') && $$tempref{$current}->__object_id__()) {
                    push @return_values, tObjId($$tempref{$current}->__object_id__());
                }
                elsif ($$tempref{$current}->can('__object_id__')) {
                    #
                    push @return_values, $self->__convert_helper__($session, $current, $tempref);
                }
                else {
                    #
                    if ($$current_task{'readfield_type'} eq 'Network') {
                        push @return_values, $self->__network_convert__($session,$current,$tempref);
                    }
                    elsif ($$current_task{'readfield_type'} eq 'DhcpRange') {
                        push @return_values, $self->__range_convert__($session,$current,$tempref);
                    }
                    elsif ($$current_task{'readfield_type'} eq 'IPv6DhcpRange') {
                        push @return_values, $self->__ipv6_range_convert__($session,$current,$tempref);
                    }
                    else {
                        my $t=$$current_task{'member_name'};
                        push @return_values, ibap_readfield_simple_string($$current_task{'readfield_type'},$$current_task{'readfield_name'},$$tempref{$current}->$t());
                    }
                }

                my %extra_write_arg;
                $extra_write_arg{'field'} = 'resource_type';
                $extra_write_arg{'value'} = ibap_value_o2i_string($__admin_permission_all_reverse_mappings__{lc($$tempref{'resource_type'})},'',$session);
                push @return_values, \%extra_write_arg;
            }
            else {
                #
                set_error_codes(1012,'Internal error: invalid subtype "' . $$tempref{'resource_type'} . '" in permission');
                return;
            }
        }
        else {
            #
            push @return_values, undef;

            my %extra_write_arg;
            $extra_write_arg{'field'} = 'resource_type';
            $extra_write_arg{'value'} = ibap_value_o2i_string($__admin_permission_all_reverse_mappings__{lc($$current_task{'resource_type'})},'',$session);
            push @return_values, \%extra_write_arg;
        }
    }
    else {
        if ($$tempref{$current}->can('__object_id__') && $$tempref{$current}->__object_id__()) {
            push @return_values, tObjId($$tempref{$current}->__object_id__());
        }
        elsif ($$tempref{$current}->can('__object_id__')) {
            #
            push @return_values, $self->__convert_helper__($session, $current, $tempref);
        }
        else {
            #
            if ($$current_task{'readfield_type'} eq 'Network') {
                push @return_values, $self->__network_convert__($session,$current,$tempref);
            }
            elsif ($$current_task{'readfield_type'} eq 'DhcpRange') {
                push @return_values, $self->__range_convert__($session,$current,$tempref);
            }
            elsif ($$current_task{'readfield_type'} eq 'IPv6DhcpRange') {
                push @return_values, $self->__ipv6_range_convert__($session,$current,$tempref);
            }
                        else {
                my $t=$$current_task{'member_name'};
                push @return_values, ibap_readfield_simple_string($$current_task{'readfield_type'},$$current_task{'readfield_name'},$$tempref{$current}->$t());
            }
        }
    }
    return @return_values;
}

#
#
#

sub __o2i_admin_group__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if( defined $$tempref{$current} ) {
        #
        if (defined $$tempref{'role'}) {
            set_error_codes(1104,
                "Can't have both 'admin_group' and 'role' together.",
                $session );
            push @return_args, 0;
        } else {
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, ibap_readfield_simple(
                'AdminGroup','name',
                ibap_value_o2i_string($$tempref{$current}),'admin_group');
        }
    } else {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }
    return @return_args;
}

sub __o2i_role__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if( defined $$tempref{$current} ) {
        #
        if (defined $$tempref{'admin_group'}) {
            set_error_codes(1104,
                "Can't have both 'admin_group' and 'role' together.",
                $session );
            push @return_args, 0;
        } else {
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, ibap_readfield_simple_string(
                                'Role', 'name', $$tempref{$current},'role');
        }
    } else {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }
    return @return_args;
}

sub __o2i_permission__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
        if ($$tempref{$current} =~ m/read/i) {
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, ibap_value_o2i_string('RO');
        } elsif ($$tempref{$current} =~ m/write/i) {
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, ibap_value_o2i_string('RW');
        } elsif ($$tempref{$current} =~ m/deny/i) {
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, ibap_value_o2i_string('DENY');
        }
        else {
            set_error_codes(1104,"Invalid value '$$tempref{$current}' for member permission.", $session );
            push @return_args, 0;
        }
    }
    else {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }
    return @return_args;
}

sub __o2i_resource_type__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{'resource_object'} && $$tempref{$current} ne '') {
        #
        return;
    }

    if (defined $$tempref{$current}) {
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
        #
        #
        if ($$tempref{$current} eq '') {
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, ibap_value_o2i_string('');
        }
        elsif (defined $__admin_permission_all_reverse_mappings__{lc($$tempref{$current})}) {
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, ibap_value_o2i_string($__admin_permission_all_reverse_mappings__{lc($$tempref{$current})});
        } else {
            set_error_codes(1104,"Invalid value '$$tempref{$current}' for member resource_type.", $session );
            push @return_args, 0;
        }
    }
    else {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }
    return @return_args;
}

sub __o2i_resource__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
        if (defined $__admin_permission_resource_object_to_ibap__{ref($$tempref{$current})}) {
            my ($t1, $t2) = ${$__admin_permission_resource_object_to_ibap__{ref($$tempref{$current})}}{'member_function'}($self,$session,$current,$tempref);

            if ($t1 || $t2) {
                push @return_args, 1;
                if ($t1) {
                    push @return_args, 0;
                    push @return_args, $t1;
                    if ($t2) {
                        push @return_args, $t2;
                    }
                }
                else {
                    push @return_args, 1;
                    push @return_args, undef;
                    push @return_args, $t2;
                }
            }
            else {
                #
                unless (Infoblox::status_code()) {
                    set_error_codes(1012,'Internal error: cannot convert object ' . ref($$tempref{$current}) . ' for field ' . $current, $session);
                }
                push @return_args, 0;
            }
        }
        else {
            set_error_codes(1012,'Internal error: invalid child object type ' . ref($$tempref{$current}) . ' for field ' . $current,$session);
            push @return_args, 0;
        }
    }
    else {
        push @return_args, 1;
        push @return_args, 0;
        push @return_args, undef;
    }

    return @return_args;
}

sub __object_to_ibap__
{
    my ($self, $server, $session) = @_;

    my @write_fields;

    foreach my $current (keys %$self) {
        next if $current =~ m/^__/;

        my %write_arg;
        if (defined $_name_mappings{$current}) {
            $write_arg{'field'} = $_name_mappings{$current};
        }
        else {
            $write_arg{'field'} = $current;
        }

        my @converted_values = $_object_to_ibap{$current}($self, $session, $current, $self);
        if (@converted_values) {
            my $success=shift @converted_values;
            if ($success) {
                my $ignore_value=shift @converted_values;
                $write_arg{'value'} = shift @converted_values;

                foreach my $extra_args (@converted_values) {
                    unshift @write_fields, $extra_args;
                }

                if ($ignore_value) {
                    next;
                }
            } else {
                return;
            }
        } else {
            next;
        }
        unshift @write_fields, \%write_arg;
    }
    return \@write_fields;
}

#
#
sub __object_id__
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ '__object_id__' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ '__object_id__' } = undef;
        }
        else
        {
            $self->{ '__object_id__' } = $value;
        }
    }
    return 1;
}

sub __return_fields__
{
    my $self = shift;
    return \@_return_fields;
}

#
#
#

sub admin_group
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'admin_group' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ 'admin_group' } = undef;
        }
        else
        {
            $self->{ 'admin_group' } = $value;
        }
    }
    return 1;
}

sub role
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'role' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ 'role' } = undef;
        }
        else
        {
            $self->{ 'role' } = $value;
        }
    }
    return 1;
}

sub permission
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'permission' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ 'permission' } = undef;
        }
        else
        {
            if ($value =~ m/^read|write|deny$/i) {
                $self->{ 'permission' } = $value;
            }
            else {
                set_error_codes(1104,"Invalid value '$value' for member permission." );
                return;
            }
        }
    }
    return 1;
}

sub resource_type
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'resource_type' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ 'resource_type' } = undef;
        }
        else
        {
            if (defined $__admin_permission_all_reverse_mappings__{lc($value)}) {
                $self->{ 'resource_type' } = $value;
            }
            else {
                  set_error_codes(1104,"Invalid value '$value' for member resource_type." );
                  return;
            }
        }
    }
    return 1;
}

sub resource_object
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'resource_object' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ 'resource_object' } = undef;
        }
        else
        {
            my @t = keys %__admin_permission_resource_object_to_ibap__;
            if( Infoblox::Util::check_object_type( $value , \@t ))
              {
                  $self->{ 'resource_object' } = $value;
              }
            else
              {
                  set_error_codes(1104,'Invalid data type ' . ref($value) . 'for member resource_object.' );
                  return;
              }
        }
    }
    return 1;
}

1;
