package Infoblox::DNS::View;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::IBAPBase;

use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object %_capabilities $_return_fields_initialized %_return_field_overrides @_minimal_return_fields @_nxdomain_redirect_members);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
	$_object_type = 'View';
    register_wsdl_type('ib:View','Infoblox::DNS::View',\@_return_fields);

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 0,
					  'single_serialization' => 1,
					 );

    @_nxdomain_redirect_members = (
        'nxdomain_redirect',
        'nxdomain_redirect_addresses',
        'nxdomain_redirect_addresses_ipv6'
    );

	$_return_fields_initialized=0;

	%_allowed_members = (
						 name 			 		           => 1,
						 comment 			 	           => 0,
						 custom_root_name_servers          => 0,
                         blacklist_action                  => 0,
                         blacklist_log_query               => 0,
                         blacklist_redirect_addresses      => 0,
                         blacklist_redirect_ttl            => 0,
                         blacklist_rulesets                => 0,
						 disable 			 	           => 0,
                         dns64_groups                      => 0,
                         dnssec_enabled                    => 0,
                         dnssec_expired_signatures_enabled => 0,
                         dnssec_trusted_keys               => 0,
                         dnssec_validation_enabled         => 0,
                         dnssec_negative_trust_anchors     => 0,
                         enable_blacklist                  => 0,
                         enable_dns64                      => 0,
                         filter_aaaa                       => 0,
                         filter_aaaa_list                  => 0,
                         forward_only                      => 0,
                         forwarders                        => 0,
                         override_blacklist                => 0,
                         extattrs                          => 0,
                         extensible_attributes             => 0,
						 match_clients 	 		           => 0,
						 match_destinations		           => 0,
						 network_view 	  		           => 0,
                         notify_delay                      => 0,
						 recursion 		 		           => 0,
						 use_root_name_servers 	           => 0,
                         override_dns64                    => 0,
                         override_dnssec                   => 0,
                         override_nxdomain_redirect        => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         nxdomain_redirect                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_nxdomain_redirect', use_truefalse => 1, use_members => \@_nxdomain_redirect_members},
                         nxdomain_redirect_addresses       => {array => 1, simple => 'asis', validator => \&ibap_value_o2i_ipv4addr, use => 'override_nxdomain_redirect', use_truefalse => 1, use_members => \@_nxdomain_redirect_members},
                         nxdomain_redirect_addresses_ipv6  => {array => 1, simple => 'asis', validator => \&ibap_value_o2i_ipv6addr, use => 'override_nxdomain_redirect', use_truefalse => 1, use_members => \@_nxdomain_redirect_members},
                         nxdomain_redirect_ttl             => 0,
                         nxdomain_log_query                => 0,
                         nxdomain_rulesets                 => 0,
                         override_filter_aaaa              => 0,
                         override_forwarders               => 0,
                         sortlist                          => 0,
                         override_sortlist                 => 0,
                         lame_ttl                          => 0,
                         override_lame_ttl                 => 0,
                         max_cache_ttl                     => 0,
                         override_max_cache_ttl            => 0,
                         max_ncache_ttl                    => 0,
                         override_max_ncache_ttl           => 0,
                         dnssec_blacklist_enabled          => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         dnssec_dns64_enabled              => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         dnssec_nxdomain_enabled           => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         dnssec_rpz_enabled                => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         enable_match_recursive_only       => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         cloud_info                        => {validator => {'Infoblox::Grid::CloudAPI::Info' => 1}, readonly => 1},
                         override_rpz_qname_wait_recurse   => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         rpz_qname_wait_recurse            => {simple => 'bool', validator => \&ibap_value_o2i_boolean, use => 'override_rpz_qname_wait_recurse', use_truefalse => 1},

                         fixed_rrset_order_fqdns          => {validator => {'Infoblox::Grid::DNS::FixedRRSetOrderFQDN' => 1},
                                                              array => 1, skip_accessor => 1},
                         enable_fixed_rrset_order_fqdns   => 0, 
                         override_fixed_rrset_order_fqdns => {simple => 'bool', validator => \&ibap_value_o2i_boolean},

                         'response_rate_limiting'          => {validator => {'Infoblox::Grid::DNS::ResponseRateLimiting' => 1},
                                                               use => 'override_response_rate_limiting', use_truefalse => 1},
                         'override_response_rate_limiting' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'ddns_restrict_patterns_list' => {array => 1, simple => 'asis', validator => \&ibap_value_o2i_string,
                                                           use => 'override_ddns_patterns_restriction', use_truefalse => 1,
                                                           use_members => ['ddns_restrict_patterns_list', 'ddns_restrict_patterns']},
                         'ddns_restrict_patterns' => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                      use => 'override_ddns_patterns_restriction', use_truefalse => 1,
                                                      use_members => ['ddns_restrict_patterns_list', 'ddns_restrict_patterns']},
                         'override_ddns_patterns_restriction' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'ddns_restrict_static' => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                    use => 'override_ddns_restrict_static', use_truefalse => 1},
                         'override_ddns_restrict_static' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'ddns_restrict_protected' => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                       use => 'override_ddns_restrict_protected', use_truefalse => 1},
                         'override_ddns_restrict_protected' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'ddns_restrict_secure' => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                    use => 'override_ddns_principal_security', use_truefalse => 1,
                                                    use_members => ['ddns_restrict_secure', 'ddns_principal_tracking', 'ddns_principal_group']},
                         'ddns_principal_tracking' => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                       use => 'override_ddns_principal_security', use_truefalse => 1,
                                                       use_members => ['ddns_restrict_secure', 'ddns_principal_tracking', 'ddns_principal_group']},
                         'ddns_principal_group' => {validator => {'Infoblox::DNS::DDNS::PrincipalCluster::Group' => 1},
                                                    use => 'override_ddns_principal_security', use_truefalse => 1,
                                                    use_members => ['ddns_restrict_secure', 'ddns_principal_tracking', 'ddns_principal_group']},
                         'override_ddns_principal_security' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'ddns_force_creation_timestamp_update' => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                                    use => 'override_ddns_force_creation_timestamp_update', use_truefalse => 1},
                         'override_ddns_force_creation_timestamp_update' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'scavenging_settings' => {validator => {'Infoblox::Grid::DNS::ScavengingSetting' => 1},
                                                    use => 'override_scavenging_settings', use_truefalse => 1},
                         'override_scavenging_settings' => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'override_rpz_drop_ip_rule'               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},

                         'rpz_drop_ip_rule_enabled'                => {simple => 'bool', validator => \&ibap_value_o2i_boolean,
                                                                       use => 'override_rpz_drop_ip_rule', use_truefalse => 1,
                                                                       use_members => [
                                                                                       'rpz_drop_ip_rule_min_prefix_length_ipv4',
                                                                                       'rpz_drop_ip_rule_min_prefix_length_ipv6',
                                                                                       'rpz_drop_ip_rule_enabled',
                                                                       ]},
                         'rpz_drop_ip_rule_min_prefix_length_ipv4' => {simple => 'asis', validator => \&ibap_value_o2i_uint,
                                                                       use => 'override_rpz_drop_ip_rule', use_truefalse => 1,
                                                                       use_members => [
                                                                                       'rpz_drop_ip_rule_min_prefix_length_ipv4',
                                                                                       'rpz_drop_ip_rule_min_prefix_length_ipv6',
                                                                                       'rpz_drop_ip_rule_enabled',
                                                                       ]},
                         'rpz_drop_ip_rule_min_prefix_length_ipv6' => {simple => 'asis', validator => \&ibap_value_o2i_uint,
                                                                       use => 'override_rpz_drop_ip_rule', use_truefalse => 1,
                                                                       use_members => [
                                                                                       'rpz_drop_ip_rule_min_prefix_length_ipv4',
                                                                                       'rpz_drop_ip_rule_min_prefix_length_ipv6',
                                                                                       'rpz_drop_ip_rule_enabled',
                                                                       ]},
						);

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

	%_name_mappings = (
					   disable  			 => 'disabled' ,
                       extattrs              => 'extensible_attributes',
					   recursion 			 => 'allow_recursion' ,
					   use_root_name_servers => 'root_name_server_type' ,
	                   dnssec_enabled        => 'dnssec',
                       forward_only          => 'forwarders_only',
                       forwarders            => 'allow_forwarder',
	                   override_dns64        => 'use_dns64',
	                   override_dnssec       => 'use_dnssec',
                       override_blacklist    => 'use_blacklist',
                       override_forwarders  => 'use_forwarder_setting',
	                   nxdomain_redirect     => 'enable_nxdomain_redirect',
                       override_filter_aaaa  => 'use_filter_aaaa',
	                   override_nxdomain_redirect => 'use_nxdomain_redirect',
	                   override_sortlist     => 'use_sort_lists',
                       sortlist              => 'sort_lists',
                       override_lame_ttl     => 'use_lame_ttl',
                       override_max_cache_ttl => 'use_max_cache_ttl',
                       override_max_ncache_ttl => 'use_max_ncache_ttl',
                       enable_fixed_rrset_order_fqdns   => 'fixed_rrset_order_fqdns_enabled',
                       override_fixed_rrset_order_fqdns => 'use_fixed_rrset_order_fqdns',
                       override_rpz_qname_wait_recurse   => 'use_rpz_qname_wait_recurse',
                       'override_response_rate_limiting' => 'use_response_rate_limiting',
                       'override_ddns_patterns_restriction' => 'use_ddns_patterns_restriction',
                       'override_ddns_restrict_static'      => 'use_ddns_restrict_static',
                       'override_ddns_restrict_protected'   => 'use_ddns_restrict_protected',
                       'override_ddns_principal_security'   => 'use_ddns_principal_security',
                       'override_ddns_force_creation_timestamp_update' => 'use_ddns_force_creation_timestamp_update',
                       'override_scavenging_settings' => 'use_reclamation',
                       'scavenging_settings'          => 'reclamation_settings',
                       'override_rpz_drop_ip_rule' => 'use_rpz_drop_ip_rule',
                       'nxdomain_redirect_addresses_ipv6' => 'nxdomain_redirect_addresses_v6',
					  );

	%_reverse_name_mappings = reverse %_name_mappings;

	$_name_mappings{'dnssec_validation_enabled'}='dnssec';
	$_name_mappings{'dnssec_expired_signatures_enabled'}='dnssec';
    $_name_mappings{'dnssec_blacklist_enabled'}='dnssec';
    $_name_mappings{'dnssec_dns64_enabled'}='dnssec';
    $_name_mappings{'dnssec_nxdomain_enabled'}='dnssec';
    $_name_mappings{'dnssec_rpz_enabled'}='dnssec';

	%_ibap_to_object = (
						allow_recursion     	 => \&ibap_i2o_boolean,
						custom_root_name_servers => \&__i2o_ns__,
						disabled     			 => \&ibap_i2o_boolean,
                        dnssec                   => \&ibap_i2o_dnssec_props,
                        dnssec_trusted_keys      => \&ibap_i2o_dnssec_trusted_keys,
                        extensible_attributes    => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        filter_aaaa_list         => \&ibap_i2o_ac_setting,
                        forwarders_only          => \&ibap_i2o_boolean,
						match_clients            => \&ibap_i2o_ac_setting,
						match_destinations       => \&ibap_i2o_ac_setting,
					    network_view 			 => \&ibap_i2o_generic_object_convert,
						root_name_server_type    => \&__i2o_ns_type__,
	                    enable_dns64             => \&ibap_i2o_boolean,
	                    use_dnssec               => \&ibap_i2o_boolean,
	                    use_dns64                => \&ibap_i2o_boolean,
                        dns64_groups             => \&ibap_i2o_generic_object_list_convert,
                        nxdomain_log_query       => \&ibap_i2o_boolean,
                        nxdomain_rulesets        => \&ibap_i2o_rulesets_by_names,
                        use_filter_aaaa          => \&ibap_i2o_boolean,
                        blacklist_log_query      => \&ibap_i2o_boolean,
                        blacklist_rulesets       => \&ibap_i2o_rulesets_by_names,
                        enable_blacklist         => \&ibap_i2o_boolean,
                        use_blacklist            => \&ibap_i2o_boolean,
                        use_forwarder_setting    => \&ibap_i2o_boolean,
                        sort_lists               => \&ibap_i2o_sort_list,
                        use_sort_lists           => \&ibap_i2o_boolean,
                        use_lame_ttl             => \&ibap_i2o_boolean, 
                        use_max_cache_ttl        => \&ibap_i2o_boolean,
                        use_max_ncache_ttl        => \&ibap_i2o_boolean,
                        enable_match_recursive_only => \&ibap_i2o_boolean,
                        use_rpz_qname_wait_recurse => \&ibap_i2o_boolean,

                        cloud_info              => \&ibap_i2o_generic_object_convert,

                        fixed_rrset_order_fqdns         => \&ibap_i2o_generic_object_list_convert,
                        fixed_rrset_order_fqdns_enabled => \&ibap_i2o_boolean,
                        use_fixed_rrset_order_fqdns     => \&ibap_i2o_boolean,
                        'response_rate_limiting'     => \&ibap_i2o_generic_object_convert,
                        'use_response_rate_limiting' => \&ibap_i2o_boolean,
                        'ddns_principal_group' => \&ibap_i2o_generic_object_convert,
                        'reclamation_settings'          => \&ibap_i2o_generic_object_convert,
                        'use_reclamation'               => \&ibap_i2o_boolean,
                        'use_rpz_drop_ip_rule'    => \&ibap_i2o_boolean,
                        'rpz_drop_ip_rule_enabled' => \&ibap_i2o_boolean,
					   );


	%_return_field_overrides = (
                                name 			 		          => [],
                                comment 			 	          => [],
                                custom_root_name_servers          => [],
                                disable 			 	          => [],
                                extattrs                          => [],
                                extensible_attributes             => [],
                                forwarders                        => ['use_forwarder_setting'],
                                forward_only                      => ['use_forwarder_setting'],   
                                dnssec_enabled                    => [],
                                dnssec_expired_signatures_enabled => [],
                                dnssec_trusted_keys               => [],
                                dnssec_validation_enabled         => [],
                                dnssec_negative_trust_anchors     => [],
                                dns64_groups                      => ['use_dns64'],
                                enable_dns64                      => ['use_dns64'],
                                override_dns64                    => [],
                                override_sortlist                 => [],
                                sortlist                          => ['use_sort_lists'],
                                match_clients 	 		          => [],
                                match_destinations		          => [],
                                network_view 	  		          => [],
								notify_delay 	                  => ['use_notify_delay'],
                                recursion => ['use_allow_recursion'],

                                #
                                #
                                #
                                #
                                #
                                use_root_name_servers =>
                                                    ['use_root_name_server'],
                                override_dnssec                   => [],
                                override_forwarders               => [],
                                nxdomain_redirect                 => ['use_nxdomain_redirect'],
                                nxdomain_redirect_addresses       => ['use_nxdomain_redirect'],
                                nxdomain_redirect_ttl             => ['use_nxdomain_redirect'],
                                nxdomain_log_query                => ['use_nxdomain_redirect'],
                                nxdomain_rulesets                 => ['use_nxdomain_redirect'],
                                enable_blacklist                  => ['use_blacklist'],
                                blacklist_redirect_addresses      => ['use_blacklist'],
                                blacklist_redirect_ttl            => ['use_blacklist'],
                                blacklist_log_query               => ['use_blacklist'],
                                blacklist_rulesets                => ['use_blacklist'],
                                lame_ttl                          => ['use_lame_ttl'],
                                max_cache_ttl                     => ['use_max_cache_ttl'],
                                max_ncache_ttl                     => ['use_max_ncache_ttl'],
                                enable_match_recursive_only       => [],
                                max_ncache_ttl                    => ['use_max_ncache_ttl'],
                                rpz_qname_wait_recurse            => ['use_rpz_qname_wait_recurse'],

                                cloud_info                        => [],

                                fixed_rrset_order_fqdns           => [],
                                enable_fixed_rrset_order_fqdns    => [],
                                override_fixed_rrset_order_fqdns  => [],

                                response_rate_limiting            => ['override_response_rate_limiting'],
                                override_response_rate_limiting   => [],
                                'ddns_restrict_patterns_list'        => ['use_ddns_patterns_restriction'],
                                'ddns_restrict_patterns'             => ['use_ddns_patterns_restriction'],
                                'override_ddns_patterns_restriction' => [],
                                'ddns_restrict_static'               => ['use_ddns_restrict_static'],
                                'override_ddns_restrict_static'      => [],
                                'ddns_restrict_protected'            => ['use_ddns_restrict_protected'],
                                'override_ddns_restrict_protected'   => [],
                                'ddns_restrict_secure'               => ['use_ddns_principal_security'],
                                'ddns_principal_tracking'            => ['use_ddns_principal_security'],
                                'ddns_principal_group'               => ['use_ddns_principal_security'],
                                'override_ddns_principal_security'   => [],
                                'ddns_force_creation_timestamp_update'          => ['use_ddns_force_creation_timestamp_update'],
                                'override_ddns_force_creation_timestamp_update' => [],
                                'scavenging_settings'               => ['use_reclamation'],
                                'override_scavenging_settings'      => [],
                                override_rpz_drop_ip_rule               => [],
                                rpz_drop_ip_rule_enabled                => ['use_rpz_drop_ip_rule', 'rpz_drop_ip_rule_min_prefix_length_ipv4',
                                                                            'rpz_drop_ip_rule_min_prefix_length_ipv6'],
                                rpz_drop_ip_rule_min_prefix_length_ipv4 => ['use_rpz_drop_ip_rule', 'rpz_drop_ip_rule_enabled',
                                                                            'rpz_drop_ip_rule_min_prefix_length_ipv6'],
                                rpz_drop_ip_rule_min_prefix_length_ipv6 => ['use_rpz_drop_ip_rule', 'rpz_drop_ip_rule_enabled',
                                                                            'rpz_drop_ip_rule_min_prefix_length_ipv4'],
							   );


	%_searchable_fields = (
						   name    => [\&ibap_o2i_string ,'name'   , 'REGEX'],
						   network_view => [\&ibap_o2i_network_view ,'network_view', 'EXACT'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
		                   extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
						  );

	%_object_to_ibap = (
						name 		 	 	 	          => \&ibap_o2i_string,
						comment 		 	 	          => \&ibap_o2i_string,
						custom_root_name_servers          => \&__o2i_ns__,
                        blacklist_action                  => \&ibap_o2i_string,
                        blacklist_log_query               => \&ibap_o2i_boolean,
                        blacklist_redirect_addresses      => \&ibap_o2i_ipv4addr_list,
                        blacklist_redirect_ttl            => \&ibap_o2i_uint,
                        blacklist_rulesets                => \&ibap_o2i_rulesets_by_names,
                        disable 		 	 	          => \&ibap_o2i_boolean,
                        dnssec_enabled                    => \&ibap_o2i_dnssec_props,
		                dnssec_expired_signatures_enabled => \&ibap_o2i_ignore,
		                dnssec_validation_enabled         => \&ibap_o2i_ignore,
                        dnssec_blacklist_enabled          => \&ibap_o2i_ignore,
                        dnssec_dns64_enabled              => \&ibap_o2i_ignore,
                        dnssec_nxdomain_enabled           => \&ibap_o2i_ignore,
                        dnssec_rpz_enabled                => \&ibap_o2i_ignore,
                        dnssec_trusted_keys               => \&ibap_o2i_dnssec_trusted_keys,
                        dnssec_negative_trust_anchors     => \&ibap_o2i_string_array_undef_to_empty,
                        enable_blacklist                  => \&ibap_o2i_boolean,
                        extattrs                          => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes             => \&ibap_o2i_ignore,
                        filter_aaaa                       => \&ibap_o2i_enums_lc_or_undef,
                        filter_aaaa_list                  => \&ibap_o2i_ac_setting,
                        forwarders                        => \&ibap_o2i_forwarders,
                        forward_only                      => \&ibap_o2i_boolean,
						match_clients 	 	 	          => \&ibap_o2i_ac_setting,
						match_destinations	 	          => \&ibap_o2i_ac_setting,
					    network_view 			          => \&ibap_o2i_network_view,
                        notify_delay                      => \&ibap_o2i_uint,
						recursion	 	 	 	          => \&ibap_o2i_boolean,
						use_allow_recursion	              => \&ibap_o2i_boolean,
						use_notify_delay	              => \&ibap_o2i_boolean,
						use_root_name_servers 	          => \&__o2i_ns_type__,
	                    override_dnssec                   => \&ibap_o2i_boolean,
                        override_forwarders               => \&ibap_o2i_boolean,
	                    enable_dns64                      => \&ibap_o2i_boolean,
	                    override_dns64                    => \&ibap_o2i_boolean,
	                    dns64_groups                      => \&ibap_o2i_dns64groups,
                        sortlist                          => \&ibap_o2i_sort_list,
                        nxdomain_redirect                 => \&ibap_o2i_boolean,
                        nxdomain_redirect_addresses       => \&ibap_o2i_ipaddr_list,
                        nxdomain_redirect_addresses_ipv6  => \&ibap_o2i_ipaddr_list,
                        override_blacklist                => \&ibap_o2i_boolean,
                        override_sortlist                 => \&ibap_o2i_boolean,
                        use_blacklist_internal            => \&ibap_o2i_ignore,
                        use_blacklist_addresses           => \&ibap_o2i_ignore,
                        override_filter_aaaa              => \&ibap_o2i_boolean,
                        override_nxdomain_redirect        => \&ibap_o2i_boolean,
                        nxdomain_redirect_ttl             => \&ibap_o2i_uint,
                        nxdomain_log_query                => \&ibap_o2i_boolean,
                        nxdomain_rulesets                 => \&ibap_o2i_rulesets_by_names,
                        lame_ttl                          => \&ibap_o2i_uint,
                        override_lame_ttl                 => \&ibap_o2i_boolean,
                        max_cache_ttl                     => \&ibap_o2i_uint,
                        override_max_cache_ttl            => \&ibap_o2i_boolean,
                        max_ncache_ttl                    => \&ibap_o2i_uint,
                        override_max_ncache_ttl           => \&ibap_o2i_boolean,
                        enable_match_recursive_only       => \&ibap_o2i_boolean,
                        cloud_info                        => \&ibap_o2i_ignore,
                        override_rpz_qname_wait_recurse   => \&ibap_o2i_boolean,
                        rpz_qname_wait_recurse            => \&ibap_o2i_boolean,

                        fixed_rrset_order_fqdns          => \&ibap_o2i_generic_struct_list_convert,
                        enable_fixed_rrset_order_fqdns   => \&ibap_o2i_boolean,
                        override_fixed_rrset_order_fqdns => \&ibap_o2i_boolean,

                        'response_rate_limiting'          => \&ibap_o2i_generic_struct_convert,
                        'override_response_rate_limiting' => \&ibap_o2i_boolean,
                        'override_rpz_drop_ip_rule'    => \&ibap_o2i_boolean,
                        'rpz_drop_ip_rule_enabled' => \&ibap_o2i_boolean,
                        'rpz_drop_ip_rule_min_prefix_length_ipv4' => \&ibap_o2i_uint,
                        'rpz_drop_ip_rule_min_prefix_length_ipv6' => \&ibap_o2i_uint,

                        'ddns_restrict_patterns_list'        => \&ibap_o2i_string_array_undef_to_empty,
                        'ddns_restrict_patterns'             => \&ibap_o2i_boolean,
                        'override_ddns_patterns_restriction' => \&ibap_o2i_boolean,
                        'ddns_restrict_static'               => \&ibap_o2i_boolean,
                        'override_ddns_restrict_static'      => \&ibap_o2i_boolean,
                        'ddns_restrict_protected'            => \&ibap_o2i_boolean,
                        'override_ddns_restrict_protected'   => \&ibap_o2i_boolean,
                        'ddns_restrict_secure'               => \&ibap_o2i_boolean,
                        'ddns_principal_tracking'            => \&ibap_o2i_boolean,
                        'ddns_principal_group'               => \&ibap_o2i_object_by_oid_or_name_undef_ok,
                        'ddns_force_creation_timestamp_update'          => \&ibap_o2i_boolean,
                        'override_ddns_force_creation_timestamp_update' => \&ibap_o2i_boolean,
                        'override_ddns_principal_security'   => \&ibap_o2i_boolean,
                        'scavenging_settings'               => \&ibap_o2i_generic_struct_convert,
                        'override_scavenging_settings'      => \&ibap_o2i_boolean,

                        #
                        use_filter_aaaa_list            => \&ibap_o2i_ignore,
                        use_filter_aaaa                 => \&ibap_o2i_ignore,
					   );

    $_return_fields_initialized=0;
    my @rlist = (
                'allow_recursion',
                'allow_forwarder',
                'name',
                'blacklist_action',
                'blacklist_log_query',
                'blacklist_redirect_addresses',
                'blacklist_redirect_ttl',
                'comment',
                'custom_root_name_servers',
                'disabled',
                'dnssec_negative_trust_anchors',
                'enable_dns64',
                'filter_aaaa',
                'forwarders_only',
                'notify_delay',
                'use_allow_recursion',
                'use_dnssec',
                'use_notify_delay',
                'use_root_name_server',
                'root_name_server_type',
                'use_nxdomain_redirect',
                'enable_nxdomain_redirect',
                'enable_blacklist',
                'nxdomain_redirect_addresses',
                'nxdomain_redirect_addresses_v6',
                'nxdomain_redirect_ttl',
                'nxdomain_log_query',
                'use_blacklist',
                'use_forwarder_setting',
                'use_sort_lists',
                'use_dns64',
                'use_filter_aaaa',
                'lame_ttl',
                'use_lame_ttl',
                'max_cache_ttl',
                'use_max_cache_ttl',
                'max_ncache_ttl',
                'use_max_ncache_ttl',
                'enable_match_recursive_only',
                'fixed_rrset_order_fqdns_enabled',
                'use_fixed_rrset_order_fqdns',
                'use_rpz_qname_wait_recurse',
                'rpz_qname_wait_recurse',
                'use_response_rate_limiting',
                'ddns_restrict_patterns_list',
                'ddns_restrict_patterns',
                'use_ddns_patterns_restriction',
                'ddns_restrict_static',
                'use_ddns_restrict_static',
                'ddns_restrict_protected',
                'use_ddns_restrict_protected',
                'ddns_restrict_secure',
                'ddns_principal_tracking',
                'use_ddns_principal_security',
                'ddns_force_creation_timestamp_update',
                'use_ddns_force_creation_timestamp_update',
                'use_reclamation',
                'use_rpz_drop_ip_rule',
                'rpz_drop_ip_rule_enabled',
                'rpz_drop_ip_rule_min_prefix_length_ipv4',
                'rpz_drop_ip_rule_min_prefix_length_ipv6',
               );

    foreach my $current (@rlist) {
        push @_return_fields, tField($current);
    }

    @_minimal_return_fields = (
                               tField('name'),
                               tField('comment'),
                              );

    push @_return_fields,tField('nxdomain_rulesets',
                                {
                                 sub_fields => [
                                                tField('name'),
                                               ]
                                });
    push @_return_fields,tField('sort_lists',
                                {
                                 sub_fields => [
                                                tField('sl_address'),
                                                tField('sl_netmask'),
                                                tField('address_matches'),
                                                tField('comment'),
                                                tField('querier_option'),
                                               ]
                                });

    push @_return_fields, return_fields_extensible_attributes();

    push @_return_fields,tField('blacklist_rulesets',
                                {
                                 sub_fields => [
                                                tField('name'),
                                               ]
                                });

    push @_return_fields, tField('dnssec_trusted_keys',
                                 {
                                  sub_fields =>
                                  [
                                   tField('fqdn'),tField('secure_entry_point'),tField('dnssec_algorithm'),tField('trusted_key')
                                  ]
                                 }
                                );

    push @_return_fields, tField('dnssec',
                                 {
                                  sub_fields =>
                                  [
                                   tField('enable_dnssec'), 
                                   tField('enable_dnssec_validation'),
                                   tField('enable_dnssec_expired_signatures'),
                                   tField('enable_dnssec_blacklist'),
                                   tField('enable_dnssec_dns64'),
                                   tField('enable_dnssec_nxdomain'),
                                   tField('enable_dnssec_rpz'),
                                  ]
                                 }
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
        #

        #

        my ($tmp, %tmp);

        %tmp = (
                cloud_info             => 'Infoblox::Grid::CloudAPI::Info',
                dns64_groups           => 'Infoblox::Grid::DNS::DNS64Group',
                response_rate_limiting => 'Infoblox::Grid::DNS::ResponseRateLimiting',
                ddns_principal_group   => 'Infoblox::DNS::DDNS::PrincipalCluster::Group',
                reclamation_settings   => 'Infoblox::Grid::DNS::ScavengingSetting',
        );

        foreach (keys %tmp) {
            $tmp = $tmp{$_}->__new__();
            push @_return_fields,
                tField($_, {sub_fields => $tmp->__return_fields__()});
        }

        $tmp = Infoblox::DHCP::View->__new__();
        push @_return_fields, 
          tField('network_view', {
                                  default_no_access_ok => 1,
                                  sub_fields => $tmp->__return_fields__(),
                                 }
                );

        $tmp = Infoblox::Grid::NamedACL->__new__();
        foreach (
                 'filter_aaaa_list',
                 'match_clients',
                 'match_destinations'
        ) {
            push @_return_fields,
                tField($_, return_fields_ac_setting($tmp->__return_fields__()));
        }

        $tmp = Infoblox::Grid::DNS::FixedRRSetOrderFQDN->__new__();
        push @_return_fields,
            tField('fixed_rrset_order_fqdns', {
                                               sub_fields => $tmp->__return_fields__()
                                              }
                  );
    }

    $self->{'blacklist_action'} = 'REFUSE' unless defined $self->{'blacklist_action'};
    $self->{'blacklist_log_query'} = 'false' unless defined $self->{'blacklist_log_query'};
    $self->{'override_blacklist'} = 'false' unless defined $self->{'override_blacklist'};
    $self->{'override_forwarders'} = 'false' unless defined $self->{'override_forwarders'};
    $self->{'override_sortlist'} = 'false' unless defined $self->{'override_sortlist'};
    $self->{'blacklist_redirect_ttl'} = 60 unless defined $self->{'blacklist_redirect_ttl'};
    $self->{'enable_blacklist'} = 'false' unless defined $self->{'enable_blacklist'};
    $self->{'nxdomain_redirect'} = 'false' unless defined $self->{'nxdomain_redirect'};
    $self->{'override_nxdomain_redirect'} = 'false' unless defined $self->{'override_nxdomain_redirect'};
    $self->{'nxdomain_redirect_ttl'} = 60 unless defined $self->{'nxdomain_redirect_ttl'};
    $self->{'nxdomain_log_query'} = 'false' unless defined $self->{'nxdomain_log_query'};
    $self->{'dns64_groups'} = [] unless defined $self->dns64_groups();
    $self->{'dnssec_negative_trust_anchors'} = [] unless defined $self->dnssec_negative_trust_anchors();
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

#
#
#

sub __i2o_ns__
{
	my ($self, $session, $current, $ibap_object_ref) = @_;
	my @newlist;

	if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
		my @nodes_list = @{$$ibap_object_ref{$current}};

		foreach my $addy (@nodes_list) {
			my $tempaddr;
			if (${$addy}{'address'} =~ m/:/) {
				$tempaddr='ipv6addr';
			} else {
				$tempaddr='ipv4addr';
			}

			push @newlist, Infoblox::DNS::RootNameServer->new( 'host_name' => ${$addy}{'name'},
															   $tempaddr   => ${$addy}{'address'},
															 );
		}
		return \@newlist;
	} else {
		return;
	}
}

sub __i2o_ns_type__
{
	my ($self, $session, $current, $ibap_object_ref) = @_;
	my @newlist;

	if ($$ibap_object_ref{$current}) {
		if ($$ibap_object_ref{$current} =~ m/custom/i) {
			return 'true';
		}
		else {
			return 'false';
		}
	} else {
		return;
	}
}


sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'allow_recursion'} = 0 unless defined $$ibap_object_ref{'allow_recursion'};
    $$ibap_object_ref{'enable_dns64'}      = 0 unless defined $$ibap_object_ref{'enable_dns64'};
    $$ibap_object_ref{'disabled'}        = 0 unless defined $$ibap_object_ref{'disabled'};
    $$ibap_object_ref{'use_dnssec'}      = 0 unless defined $$ibap_object_ref{'use_dnssec'};
    $$ibap_object_ref{'use_dns64'}      = 0 unless defined $$ibap_object_ref{'use_dns64'};
    $$ibap_object_ref{'use_nxdomain_redirect'}=0 unless defined $$ibap_object_ref{'use_nxdomain_redirect'};
    $$ibap_object_ref{'enable_nxdomain_redirect'}=0 unless defined $$ibap_object_ref{'enable_nxdomain_redirect'};
    $$ibap_object_ref{'nxdomain_log_query'}=0 unless defined $$ibap_object_ref{'nxdomain_log_query'};
    $$ibap_object_ref{'use_blacklist'}=0 unless defined $$ibap_object_ref{'use_blacklist'};
    $$ibap_object_ref{'enable_blacklist'}=0 unless defined $$ibap_object_ref{'enable_blacklist'};
    $$ibap_object_ref{'blacklist_log_query'}=0 unless defined $$ibap_object_ref{'blacklist_log_query'};
    $$ibap_object_ref{'forwarders_only'}=0 unless defined $$ibap_object_ref{'forwarders_only'};
    $$ibap_object_ref{'use_forwarder_setting'}=0 unless defined $$ibap_object_ref{'use_forwarder_setting'};
    $$ibap_object_ref{'use_sort_lists'}=0 unless defined $$ibap_object_ref{'use_sort_lists'};
    $$ibap_object_ref{'use_filter_aaaa'}=0 unless defined $$ibap_object_ref{'use_filter_aaaa'};
    $$ibap_object_ref{'use_lame_ttl'}=0 unless defined $$ibap_object_ref{'use_lame_ttl'};
    $$ibap_object_ref{'use_max_cache_ttl'}=0 unless defined $$ibap_object_ref{'use_max_cache_ttl'};
    $$ibap_object_ref{'use_max_ncache_ttl'}=0 unless defined $$ibap_object_ref{'use_max_ncache_ttl'};
    $$ibap_object_ref{'enable_match_recursive_only'} = 0 unless defined $$ibap_object_ref{'enable_match_recursive_only'};
    $$ibap_object_ref{'rpz_qname_wait_recurse'}=0 unless defined $$ibap_object_ref{'rpz_qname_wait_recurse'};
    $$ibap_object_ref{'use_rpz_qname_wait_recurse'}=0 unless defined $$ibap_object_ref{'use_rpz_qname_wait_recurse'};

    $$ibap_object_ref{'fixed_rrset_order_fqdns_enabled'}=0 unless defined $$ibap_object_ref{'fixed_rrset_order_fqdns_enabled'};
    $$ibap_object_ref{'use_fixed_rrset_order_fqdns'}=0 unless defined $$ibap_object_ref{'use_fixed_rrset_order_fqdns'};
    $$ibap_object_ref{'use_response_rate_limiting'}=0 unless defined $$ibap_object_ref{'use_response_rate_limiting'};
    $$ibap_object_ref{'rpz_drop_ip_rule_enabled'}=0 unless defined $$ibap_object_ref{'rpz_drop_ip_rule_enabled'};
    $$ibap_object_ref{'use_rpz_drop_ip_rule'}=0 unless defined $$ibap_object_ref{'use_rpz_drop_ip_rule'};

    $$ibap_object_ref{'ddns_restrict_patterns'} = 0 unless defined $$ibap_object_ref{'ddns_restrict_patterns'};
    $$ibap_object_ref{'use_ddns_patterns_restriction'} = 0 unless defined $$ibap_object_ref{'use_ddns_patterns_restriction'};
    $$ibap_object_ref{'ddns_restrict_static'} = 0 unless defined $$ibap_object_ref{'ddns_restrict_static'};
    $$ibap_object_ref{'use_ddns_restrict_static'} = 0 unless defined $$ibap_object_ref{'use_ddns_restrict_static'};
    $$ibap_object_ref{'ddns_restrict_protected'} = 0 unless defined $$ibap_object_ref{'ddns_restrict_protected'};
    $$ibap_object_ref{'use_ddns_restrict_protected'} = 0 unless defined $$ibap_object_ref{'use_ddns_restrict_protected'};
    $$ibap_object_ref{'ddns_restrict_secure'} = 0 unless defined $$ibap_object_ref{'ddns_restrict_secure'};
    $$ibap_object_ref{'ddns_principal_tracking'} = 0 unless defined $$ibap_object_ref{'ddns_principal_tracking'};
    $$ibap_object_ref{'use_ddns_principal_security'} = 0 unless defined $$ibap_object_ref{'use_ddns_principal_security'};
    $$ibap_object_ref{'ddns_force_creation_timestamp_update'} = 0 unless defined $$ibap_object_ref{'ddns_force_creation_timestamp_update'};
    $$ibap_object_ref{'use_ddns_force_creation_timestamp_update'} = 0 unless defined $$ibap_object_ref{'use_ddns_force_creation_timestamp_update'};
    $$ibap_object_ref{'use_reclamation'} = 0 unless defined $$ibap_object_ref{'use_reclamation'};

    $self->filter_aaaa_list([]);

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref, {
                                                                                                     'use_root_name_server' => 1,
                                                                                                    });
	#
	#
	#
    delete $self->{'use_filter_aaaa'};
    delete $self->{'use_filter_aaaa_list'};

    #
    #
    $self->{'override_nxdomain_redirect'} = ($ibap_object_ref->{'use_nxdomain_redirect'} || 0);
    $self->{'override_blacklist'} = ($ibap_object_ref->{'use_blacklist'} || 0);
    $self->{'override_forwarders'} = ($ibap_object_ref->{'use_forwarder_setting'} || 0);
    

    $self->{'use_notify_delay'} = $$ibap_object_ref{'use_notify_delay'};
    delete $self->{'notify_delay'} unless $self->{'use_notify_delay'};

    if ($$ibap_object_ref{'use_dnssec'}) {
        $self->{'override_dnssec'} = 'true';
    }
    else {
        $self->{'override_dnssec'} = 'false';
    }

	if (defined $$ibap_object_ref{'use_allow_recursion'}) {
		$self->{'use_allow_recursion'}=$$ibap_object_ref{'use_allow_recursion'};
		if ($$ibap_object_ref{'use_allow_recursion'} != 1) {
			$self->recursion(undef);
		}
	}

	if (defined $$ibap_object_ref{'use_root_name_server'}) {
		if ($$ibap_object_ref{'use_root_name_server'} != 1) {
			$self->custom_root_name_servers(undef);
			$self->use_root_name_servers(undef);
		}
	}

    if (not $self->{'override_nxdomain_redirect'}) {
        delete $self->{'nxdomain_redirect'};
        delete $self->{'nxdomain_redirect_addresses'};
        delete $self->{'nxdomain_redirect_addresses_ipv6'};
        delete $self->{'nxdomain_redirect_ttl'};
        delete $self->{'nxdomain_log_query'};
        delete $self->{'nxdomain_rulesets'};
    }
    if (not $self->{'override_forwarders'}) {
        delete $self->{'forward_only'};
        delete $self->{'forwarders'};
    }
    #
    $self->{'override_nxdomain_redirect'} = ibap_value_i2o_boolean($self->{'override_nxdomain_redirect'});
    if (not $self->{'override_blacklist'}) {
        delete $self->{'blacklist_action'};
        delete $self->{'enable_blacklist'};
        delete $self->{'blacklist_redirect_addresses'};
        delete $self->{'blacklist_redirect_ttl'};
        delete $self->{'blacklist_log_query'};
        delete $self->{'blacklist_rulesets'};
        $self->{'use_blacklist_internal'} = 0;
        $self->{'use_blacklist_addresses'} = 0;
    }

	#
	$self->{'forward_only'} = 'false' unless defined $self->{'forward_only'};
    #
    $self->{'override_blacklist'} = ibap_value_i2o_boolean($self->{'override_blacklist'});
    $self->{'override_forwarders'} = ibap_value_i2o_boolean($self->{'override_forwarders'});
    $self->{'override_dns64'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_dns64'});
    $self->{'override_sortlist'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_sort_lists'});
    $self->{'override_filter_aaaa'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_filter_aaaa'});
    $self->{'override_lame_ttl'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_lame_ttl'});
    $self->{'override_max_cache_ttl'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_max_cache_ttl'});
    $self->{'override_max_ncache_ttl'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_max_ncache_ttl'});
    $self->{'enable_fixed_rrset_order_fqdns'}   = ibap_value_i2o_boolean($$ibap_object_ref{'fixed_rrset_order_fqdns_enabled'});
    $self->{'override_fixed_rrset_order_fqdns'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_fixed_rrset_order_fqdns'});
    $self->{'override_rpz_qname_wait_recurse'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_rpz_qname_wait_recurse'});
    $self->{'override_response_rate_limiting'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_response_rate_limiting'});
    $self->{'override_rpz_drop_ip_rule'}=ibap_value_i2o_boolean($$ibap_object_ref{'use_rpz_drop_ip_rule'});

    $self->{'override_ddns_patterns_restriction'}      = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_patterns_restriction'});
    $self->{'override_ddns_restrict_static'}           = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_restrict_static'});
    $self->{'override_ddns_restrict_protected'}        = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_restrict_protected'});
    $self->{'override_ddns_principal_security'}        = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_principal_security'});
    $self->{'override_scavenging_settings'}            = ibap_value_i2o_boolean($$ibap_object_ref{'use_reclamation'});
    $self->{'override_ddns_force_creation_timestamp_update'} = ibap_value_i2o_boolean($$ibap_object_ref{'use_ddns_force_creation_timestamp_update'});

	return;
}

#
#
#
sub __o2i_ns_type__
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {

		if ($$tempref{$current} !~ m/^true|false$/i) {
			push @return_args, 0;
			set_error_codes(1012,"Invalid value '$$tempref{$current}' for member $current, valid values are true, false." );
			return @return_args;
		}

		push @return_args, 1;
		push @return_args, 0;

		if ($$tempref{$current} =~ /true/i) {
			push @return_args, ibap_value_o2i_string('CUSTOM');
		}
		else {
			push @return_args, ibap_value_o2i_string('INTERNET');
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 1;
		push @return_args, undef;
	}
	return @return_args;
}

sub __o2i_ns__
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		my @nss_list=@{$$tempref{$current}};

		if (@nss_list) {
			my @newlist;

			push @return_args, 1;
			push @return_args, 0;

			foreach my $ns (@nss_list) {
				my %sub_write_arg;

				if (defined $ns->host_name()) {
					return unless $sub_write_arg{'name'} = ibap_value_o2i_string($ns->host_name(),'name',$session);
				} else {
					$sub_write_arg{'name'} = '';
				}

				if (defined $ns->ipv4addr()) {
					$sub_write_arg{'address'} = $ns->ipv4addr();
				} elsif (defined $ns->ipv6addr()) {
					$sub_write_arg{'address'} = $ns->ipv6addr();
				} else {
					$sub_write_arg{'address'} = '';
				}

				push @newlist, tIBType('ext_server', \%sub_write_arg);
			}

			push @return_args, tIBType('ArrayOfext_server', \@newlist);

			if (not defined $$tempref{'use_root_name_servers'}) {
				my %sub_arg;
				$sub_arg{'field'} = 'root_name_server_type';
				$sub_arg{'value'} = ibap_value_o2i_string('CUSTOM');
				push @return_args, \%sub_arg;
			}
		} else {
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, tIBType('ArrayOfext_server', []);
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 1;
		push @return_args, undef;
	}
	return @return_args;
}

sub __o2i_members__
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		my @nodes_list=@{$$tempref{$current}};

		if (@nodes_list) {
			my @newlist;

			push @return_args, 1;
			push @return_args, 0;

			foreach my $member (@nodes_list) {
				push @newlist,ibap_value_o2i_member_server($member,$session);
			}
			push @return_args, \@newlist;
		} else {
			my @empty_array;
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, \@empty_array;
		}
	}
	else {
		push @return_args, 1;
		push @return_args, 1;
		push @return_args, undef;
	}

	return @return_args;
}

sub __object_to_ibap__
{
	my ($self, $server, $session) = @_;

	my @write_fields;

	#
	#

	my $to_undef_root_ns=0;
	unless ($self->{'custom_root_name_servers'}) {
		$self->{'custom_root_name_servers'} = [];
		$to_undef_root_ns=1;
	}

	my $to_undef_use_ns=0;
	unless ($self->{'use_root_name_servers'}) {
		$self->{'use_root_name_servers'} = 'false';
		$to_undef_use_ns=1;
	}

	foreach my $current (keys %$self) {
		next if $current =~ m/^__/;

		my %write_arg;
		if (defined $_name_mappings{$current}) {
			$write_arg{'field'} = $_name_mappings{$current};
		}
		else {
			$write_arg{'field'} = $current;
		}

		my @converted_values = $_object_to_ibap{$current}($self, $session, $current,$self);
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
				$self->{'custom_root_name_servers'} = undef if $to_undef_root_ns;
				$self->{'use_root_name_servers'} = undef if $to_undef_use_ns;
				return;
			}
		} else {
			next;
		}
		unshift @write_fields, \%write_arg;
	}
	$self->{'custom_root_name_servers'} = undef if $to_undef_root_ns;
	$self->{'use_root_name_servers'} = undef if $to_undef_use_ns;

	my %sub_arg;
	$sub_arg{'field'} = 'use_root_name_server';

	if ($to_undef_root_ns == 1 && $to_undef_use_ns == 1) {
		#
		return unless $sub_arg{'value'} = ibap_value_o2i_boolean(0,'use_root_name_server',$session);
	}
	else {
		return unless $sub_arg{'value'} = ibap_value_o2i_boolean(1,'use_root_name_server',$session);
	}
	push @write_fields, \%sub_arg;

	return \@write_fields;
}

#
#
#

sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dnssec_enabled
{
    my $self  = shift;
    my $t=$self->__accessor_scalar__({name => 'dnssec_enabled', validator => \&ibap_value_o2i_boolean, use => \$self->{'override_dnssec'}}, @_);

    if (defined $self->{'override_dnssec'} && $self->{'override_dnssec'} !~/e/) {
        #
        #
        #

        if ($self->{'override_dnssec'} == 0) {
            $self->{ 'override_dnssec' } = "false";
        }
        elsif ($self->{'override_dnssec'} == 1) {
            $self->{ 'override_dnssec' } = "true";
        }
    }
    return $t;
}

sub override_dnssec
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'override_dnssec', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dnssec_validation_enabled
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'dnssec_validation_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dnssec_expired_signatures_enabled
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'dnssec_expired_signatures_enabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dnssec_trusted_keys
{
    my $self  = shift;

    return $self->__accessor_array__({name => 'dnssec_trusted_keys', validator => { 'Infoblox::DNS::DnssecTrustedKey' => 1 }}, @_);
}

sub filter_aaaa
{
    my $self=shift;
    my $t = $self->__accessor_scalar__({name => 'filter_aaaa', enum => ['YES','NO','BREAK_DNSSEC'], use => 'use_filter_aaaa' }, @_);

    if( @_ != 0 )
    {
        $self->{'override_filter_aaaa'}= ibap_value_i2o_boolean($self->{'use_filter_aaaa'} || $self->{'use_filter_aaaa_list'});
    }
    return $t;
}

sub filter_aaaa_list
{
    my $self=shift;
    my $t = $self->ibap_accessor_ac_setting('filter_aaaa_list', 0, {'use' => 'use_filter_aaaa_list'}, @_);

    if( @_ != 0 )
    {
        $self->{'override_filter_aaaa'}= ibap_value_i2o_boolean($self->{'use_filter_aaaa'} || $self->{'use_filter_aaaa_list'});
    }
    return $t;
}

sub override_filter_aaaa
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_filter_aaaa', validator => \&ibap_value_o2i_boolean}, @_);
}

sub use_root_name_servers
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'use_root_name_servers', validator => \&ibap_value_o2i_boolean}, @_);
}

sub recursion
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'recursion', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_allow_recursion'}}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub custom_root_name_servers
{
    my $self  = shift;

    return $self->__accessor_array__({name => 'custom_root_name_servers', validator => { 'Infoblox::DNS::RootNameServer' => 1 }}, @_);
}

sub match_clients
{
    my $self  = shift;
    return $self->ibap_accessor_ac_setting('match_clients', 1, {}, @_);
}

sub match_destinations
{
    my $self = shift;
    return $self->ibap_accessor_ac_setting('match_destinations', 1, {}, @_);
}

sub notify_delay
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'notify_delay', validator => \&ibap_value_o2i_uint, use => \$self->{'use_notify_delay'}}, @_);
}

sub name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub network_view
{
    my $self = shift;

    return $self->__accessor_scalar__({name => 'network_view', validator => { 'Infoblox::DHCP::View' => 1 }}, @_);
}

sub nxdomain_log_query
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'nxdomain_log_query', validator => \&ibap_value_o2i_boolean}, @_);
}

sub nxdomain_rulesets
{
    my $self=shift;
    return $self->__accessor_array__({name => 'nxdomain_rulesets', validator => \&ibap_value_o2i_string}, @_);
}

sub nxdomain_redirect_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'nxdomain_redirect_ttl', validator => \&ibap_value_o2i_uint}, @_);
}

sub override_blacklist
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_blacklist', validator => \&ibap_value_o2i_boolean}, @_);
}

sub enable_blacklist
{
    my $self=shift;
    my $t = $self->__accessor_scalar__({name => 'enable_blacklist', use => \$self->{'use_blacklist_internal'}, validator => \&ibap_value_o2i_boolean}, @_);
    if( @_ != 0 )
    {
        $self->{'override_blacklist'}= ibap_value_i2o_boolean($self->{'use_blacklist_internal'} || $self->{'use_blacklist_addresses'});
    }
    return $t;
}

sub blacklist_action
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'blacklist_action', enum => ['REFUSE','REDIRECT'] }, @_);
}

sub blacklist_log_query
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'blacklist_log_query', validator => \&ibap_value_o2i_boolean}, @_);
}

sub blacklist_redirect_addresses
{
    my $self=shift;
    my $t = $self->__accessor_array__({name => 'blacklist_redirect_addresses', use => \$self->{'use_blacklist_addresses'}, validator => \&ibap_value_o2i_ipv4addr}, @_);
    if( @_ != 0 )
    {
        $self->{'override_blacklist'}= ibap_value_i2o_boolean($self->{'use_blacklist_internal'} || $self->{'use_blacklist_addresses'});
    }
    return $t;
}

sub blacklist_redirect_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'blacklist_redirect_ttl', validator => \&ibap_value_o2i_uint}, @_);
}

sub blacklist_rulesets
{
    my $self=shift;
    return $self->__accessor_array__({name => 'blacklist_rulesets', validator => \&ibap_value_o2i_string}, @_);
}

sub dnssec_negative_trust_anchors
{
    my $self=shift;
    return $self->__accessor_array__({name => 'dnssec_negative_trust_anchors', validator => \&ibap_value_o2i_string}, @_);
}

sub enable_dns64
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'enable_dns64', validator => \&ibap_value_o2i_boolean, use => \$self->{'override_dns64'}, use_truefalse => 1}, @_);
}

sub override_dns64
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_dns64', validator => \&ibap_value_o2i_boolean}, @_);
}

sub sortlist
{
    my $self=shift;
    return $self->__accessor_array__({name => 'sortlist', validator => { 'Infoblox::DNS::Sortlist' => 1 }, use => \$self->{'override_sortlist'}, use_truefalse => 1}, @_);
}

sub override_sortlist
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_sortlist', validator => \&ibap_value_o2i_boolean}, @_);
}

sub dns64_groups
{
    my $self=shift;
    return $self->__accessor_array__({name => 'dns64_groups', validator => { 'Infoblox::Grid::DNS::DNS64Group' => 1 }, use => \$self->{'override_dns64'}, use_truefalse => 1}, @_);
}

sub override_forwarders
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_forwarders', validator => \&ibap_value_o2i_boolean}, @_);
}

sub forwarders
{
    my $self=shift;
    #
    #
    if (scalar(@_) >= 1 and not defined($_[0])) {
        $_[0] = [];
    }

    my $res = $self->__accessor_array__({name => 'forwarders', validator => {'Infoblox::DNS::Member' => 1, 'Infoblox::DNS::Nameserver' => 1, 'string' => \&ibap_value_o2i_ipaddr }, use => \$self->{'override_forwarders'}, use_truefalse => 1}, @_);
    if (defined $self->{'forward_only'} && $self->{'forward_only'} eq "true") {
        $self->{'override_forwarders'} = "true";
    }
    return $res;
}

sub forward_only
{
    my $self=shift;
    my $res = $self->__accessor_scalar__({name => 'forward_only', validator => \&ibap_value_o2i_boolean, use => \$self->{'override_forwarders'}, use_truefalse => 1}, @_);
    if (defined $self->{'forwaders'} && scalar(@{$self->{'forwaders'}}) > 0) {
        $self->{'override_forwarders'} = "true";
    }
    return $res;
}

sub lame_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'lame_ttl', validator => \&ibap_value_o2i_uint, use => \$self->{'override_lame_ttl'}, use_truefalse => 1}, @_);
}

sub override_lame_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_lame_ttl', validator => \&ibap_value_o2i_boolean}, @_);
}

sub max_cache_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'max_cache_ttl', validator => \&ibap_value_o2i_uint, use => 'override_max_cache_ttl', use_truefalse => 1}, @_);
}

sub override_max_cache_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_max_cache_ttl', validator => \&ibap_value_o2i_boolean}, @_);
}

sub max_ncache_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'max_ncache_ttl', validator => \&ibap_value_o2i_uint, use => 'override_max_ncache_ttl', use_truefalse => 1}, @_);
}

sub override_max_ncache_ttl
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_max_ncache_ttl', validator => \&ibap_value_o2i_boolean}, @_);
}

sub fixed_rrset_order_fqdns
{
    my $self = shift;
    my $res = $self->__accessor_array__({name => 'fixed_rrset_order_fqdns', validator => {'Infoblox::Grid::DNS::FixedRRSetOrderFQDN' => 1},
        use => 'enable_fixed_rrset_order_fqdns', use_truefalse => 1}, @_);

    $self->{override_fixed_rrset_order_fqdns} = 'true' if @_ and $_[0] and $res;
    return $res;
}

sub enable_fixed_rrset_order_fqdns
{
    my $self = shift;
    my $res = $self->__accessor_scalar__({name => 'enable_fixed_rrset_order_fqdns', validator => \&ibap_value_o2i_boolean}, @_);

    $self->{override_fixed_rrset_order_fqdns} = 'true' if @_ and $_[0] and $res;
    return $res;
}


1;
