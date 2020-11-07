package Infoblox::IPAM::DiscoveryTask;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_name_mappings %_reverse_name_mappings %_object_to_ibap %_ibap_to_object $_return_fields_initialized %_capabilities %_return_field_overrides);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'DiscoveryTask';
    register_wsdl_type('ib:DiscoveryTask','Infoblox::IPAM::DiscoveryTask');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
			 );

    %_allowed_members = (
                         member             => 1,
                         merge_data         => 0,
                         mode               => 0,
                         networks 			=> 0,
                         network_view       => 0,
                         ping_retries 		=> 0,
                         ping_timeout		=> 0,
                         state              => -1,
                         status             => -1,
                         tcp_ports          => 0,
                         tcp_scan_technique => 0,
                         update_metadata    => 0,
                         disable_vmware_scanning => 0,
                         disable_ip_scanning     => 0,
                         v_network_view     => 0,
                         vservers           => {validator => {'Infoblox::IPAM::DiscoveryTask::VServer' => 1}, array => 1, skip_accessor => 1},
                         discovery_task_oid => -1,
                         scheduled_run      => {validator => {'Infoblox::Grid::ScheduleSetting' => 1}, skip_accessor => 1},
                        );

    %_searchable_fields = (
                           'discovery_task_oid' => [\&ibap_o2i_string, 'discovery_task_oid', 'EXACT'],
						  );

    #
    %_name_mappings = (
                        disable_ip_scanning     => 'ip_discovery_disabled',
                        disable_vmware_scanning => 'v_discovery_disabled',
                        v_network_view          => 'v_discovery_network_view',
                        vservers                => 'v_discovery_servers',  
				      );


    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
	   'member' 	           => \&__i2o_member__,
	   'merge_data'	           => \&ibap_i2o_boolean,
	   'networks' 			   => \&ibap_i2o_generic_object_list_convert,
	   'network_view'		   => \&ibap_i2o_generic_object_convert,
	   'tcp_ports' 			   => \&ibap_i2o_generic_object_list_convert,
	   'update_metadata'       => \&ibap_i2o_boolean,
       'ip_discovery_disabled' => \&ibap_i2o_boolean,
       'v_discovery_disabled'  => \&ibap_i2o_boolean,
       'v_discovery_network_view' => \&ibap_i2o_generic_object_convert,
       'v_discovery_servers'   => \&ibap_i2o_generic_object_list_convert,
       'scheduled_run'         => \&ibap_i2o_generic_object_convert,
					   );

    %_object_to_ibap = (
       member                          => \&__o2i_member__ ,
       merge_data                      => \&ibap_o2i_boolean ,
       mode                            => \&ibap_o2i_string ,
       networks 					   => \&ibap_o2i_network_list ,
       network_view					   => \&ibap_o2i_network_view ,
       ping_retries 				   => \&ibap_o2i_integer ,
       ping_timeout					   => \&ibap_o2i_integer ,
       state                		   => \&ibap_o2i_string ,
       status                		   => \&ibap_o2i_string ,
       tcp_ports                       => \&__o2i_tcp_ports__ ,
       tcp_scan_technique              => \&ibap_o2i_string ,
       update_metadata                 => \&ibap_o2i_boolean ,
       disable_ip_scanning             => \&ibap_o2i_boolean,
       disable_vmware_scanning         => \&ibap_o2i_boolean,
       v_network_view                  => \&ibap_o2i_network_view,
       vservers                        => \&ibap_o2i_generic_struct_list_convert,
       scheduled_run                   => \&ibap_o2i_generic_struct_convert,
       discovery_task_oid              => \&ibap_o2i_ignore,
					   );

	%_return_field_overrides = (
                                'member'             => [],
                                'merge_data'         => [],
                                'mode'               => [],
                                'networks'           => [],
                                'network_view'       => [],
                                'ping_retries'       => [],
                                'ping_timeout'       => [],
                                'state'              => [],
                                'status'             => [],
                                'tcp_ports'          => [],
                                'tcp_scan_technique' => [],
                                'update_metadata'    => [],
                                'scheduled_run'      => [],
                                'discovery_task_oid' => [],
                               );

    $_return_fields_initialized = 0;
    my @rlist = (
                 'mode',
                 'merge_data',
                 'ping_retries',
                 'ping_timeout',
                 'state',
                 'status',
                 'tcp_scan_technique',
                 'update_metadata',
                 'ip_discovery_disabled',
                 'v_discovery_disabled',
                 'discovery_task_oid',
                );

    foreach my $current (@rlist) {
        push @_return_fields, tField($current);
    }

    #
    #
    push @_return_fields, tField('member',return_fields_member_basic_data());

    push @_return_fields, tField('tcp_ports',
                                 {
                                  sub_fields   => [tField('number'),tField('comment')]
                                 });
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
        my $t = Infoblox::DHCP::View->__new__();
        push @_return_fields,
          tField('network_view', {
                                  default_no_access_ok => 1,
                                  sub_fields => $t->__return_fields__(),
                                 }
                );

        push @_return_fields,
          tField('v_discovery_network_view', {
                                  default_no_access_ok => 1,
                                  sub_fields => $t->__return_fields__(),
                                 }
                );

        $t = Infoblox::IPAM::DiscoveryTask::VServer->__new__();
        push @_return_fields,
          tField('v_discovery_servers', {
                                  default_no_access_ok => 1,
                                  sub_fields => $t->__return_fields__(),
                                 }
                );

        #
        $t = Infoblox::DHCP::Network->__new__();
        push @_return_fields,
          tField('networks', {
                              default_no_access_ok => 1,
                              sub_fields => $t->__return_fields__(),
                             }
                );

        $t = Infoblox::Grid::ScheduleSetting->__new__();
        push @_return_fields,
          tField('scheduled_run', {
                              sub_fields => $t->__return_fields__(),
                             }
                );
    }

    #
    $self->merge_data('true');
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

sub __i2o_member__
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
	my @newlist;

	if ($$ibap_object_ref{$current}) {
        return Infoblox::DHCP::Member->new(
										   'name'  		 => $$ibap_object_ref{$current}{'host_name'},
										   'ipv4addr'  	 => $$ibap_object_ref{$current}{'vip_setting'}{'address'},
										  );

	} else {
		return;
	}
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'update_metadata'} = 0 unless defined $$ibap_object_ref{'update_metadata'};
    $$ibap_object_ref{'merge_data'} = 0 unless defined $$ibap_object_ref{'merge_data'};
    $$ibap_object_ref{'v_discovery_disabled'} = 0 unless defined $$ibap_object_ref{'v_discovery_disabled'};
    $$ibap_object_ref{'ip_discovery_disabled'} = 0 unless defined $$ibap_object_ref{'ip_discovery_disabled'};

    #
    $self->update_metadata('false');
    $self->disable_ip_scanning('false');
    $self->disable_vmware_scanning('false');

    #
    $self->networks([]);

    #
    $self->tcp_ports([]);

    $self->vservers([]);

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

	return;
}

#
#
#

sub __o2i_member__
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		push @return_args, 1;
		push @return_args, 0;
        push @return_args, ibap_value_o2i_member_nocache($$tempref{$current}, $session, $current,1);
	}
	else {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, undef;
	}

	return @return_args;
}

sub __o2i_tcp_ports__
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		if (ref ($$tempref{$current}) eq 'ARRAY') {
			my @members;
			my @list=@{$$tempref{$current}};

			foreach my $member (@list) {
                if(ref($member) eq 'Infoblox::IPAM::TCPPort') {
                    my %port;
                    $port{'number'} = ibap_value_o2i_int($member->number(), 'port number' , $session);
                    $port{'comment'} = ibap_value_o2i_string($member->comment(), 'port comment' , $session);
                    push @members, \%port;
                }
                else {
			        push @return_args, 0;
                }
			}
			push @return_args, 1;
			push @return_args, 0;
			push @return_args, tIBType('ArrayOfport',\@members);
		} else {
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

#
#
#

sub member
{
    my $self = shift;

    return $self->__accessor_scalar__({name => 'member', validator => { 'Infoblox::DHCP::Member' => 1 }}, @_);
}

sub mode
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'mode' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            set_error_codes(1101, "Valid values for mode are 'FULL', 'ICMP', 'NETBIOS' and 'TCP'");
            return;
        }
        else
        {
            my $uc_value = uc($value);
            unless ( $uc_value eq 'FULL' or
                     $uc_value eq 'ICMP' or 
                     $uc_value eq 'NETBIOS' or
                     $uc_value eq 'TCP') {
                set_error_codes(1101, "Valid values for mode are 'FULL', 'ICMP', 'NETBIOS' and 'TCP'");
                return;
            }

			$self->{ 'mode' } = $uc_value;
		}
	}
	return 1;
}

sub networks
{
    my $self=shift;

    return $self->__accessor_array__({name => 'networks', validator => { 'Infoblox::DHCP::Network' => 1 }}, @_);
}

sub network_view
{
    my $self = shift;

    return $self->__accessor_scalar__({name => 'network_view', validator => { 'Infoblox::DHCP::View' => 1 }}, @_);
}

sub ping_retries
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ping_retries', validator => \&ibap_value_o2i_uint}, @_);
}

sub ping_timeout
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'ping_timeout', validator => \&ibap_value_o2i_uint}, @_);
}

sub state
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'state', readonly => 1}, @_);
}

sub status
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'status', readonly => 1}, @_);
}

sub tcp_ports
{
    my $self=shift;

    return $self->__accessor_array__({name => 'tcp_ports', validator => { 'Infoblox::IPAM::TCPPort' => 1 }}, @_);
}

sub tcp_scan_technique
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'tcp_scan_technique' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            set_error_codes(1101, "Valid values for tcp_scan_technique are 'SYN', 'CONNECT'");
            return;
        }
        else
        {
            my $uc_value = uc($value);
            unless ( $uc_value eq 'SYN' or
                     $uc_value eq 'CONNECT') {
                set_error_codes(1101, "Valid values for tcp_scan_technique are 'SYN', 'CONNECT'");
                return;
            }

			$self->{ 'tcp_scan_technique' } = $uc_value;
		}
	}
	return 1;
}

sub update_metadata
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'update_metadata', validator => \&ibap_value_o2i_boolean}, @_);
}

sub merge_data
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'merge_data', validator => \&ibap_value_o2i_boolean}, @_);
}

sub v_network_view
{
    my $self = shift;

    return $self->__accessor_scalar__({name => 'v_network_view', validator => { 'Infoblox::DHCP::View' => 1 }}, @_);
}

sub vservers
{
    my $self = shift;

    return $self->__accessor_array__({name => 'vservers', validator => { 'Infoblox::IPAM::DiscoveryTask::VServer' => 1 }}, @_);
}

sub disable_ip_scanning 
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable_ip_scanning', validator => \&ibap_value_o2i_boolean}, @_);
}

sub disable_vmware_scanning 
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable_vmware_scanning', validator => \&ibap_value_o2i_boolean}, @_);
}

sub discovery_task_oid
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'discovery_task_oid', readonly => 1, validator => \&ibap_value_o2i_string}, @_);
}

sub scheduled_run
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'scheduled_run', validator => {'Infoblox::Grid::ScheduleSetting' => 1}}, @_);
}

package Infoblox::IPAM::TCPPort;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members %_name_mappings %_reverse_name_mappings @_return_fields %_ibap_to_object %_object_to_ibap %_capabilities %_capabilities %_return_field_overrides %_searchable_fields);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = "port";
    register_wsdl_type('ib:port','Infoblox::IPAM::TCPPort');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 0,
					  'single_serialization' => 0,
					 );


    %_allowed_members = (
                         number  => 1,
                         comment => 0
                        );

	%_return_field_overrides = (
                                'number'  => [],
                                'comment' => [],
                               );

    %_searchable_fields = ();
    %_name_mappings = ();
    %_reverse_name_mappings = ();

    %_ibap_to_object = ();

    %_object_to_ibap = ( 
        number  => \&ibap_o2i_string,
        comment => \&ibap_o2i_string,
    );

    my @rlist =(
                'number',
                'comment',
               );

    foreach my $current (@rlist) {
        push @_return_fields, tField($current);
    }
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

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    
    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

}

#
#
#

sub __object_to_ibap__
{
	my ($self, $server, $session) = @_;

    return $self->SUPER::__object_to_ibap__($server, $session);
}

#
#
#

sub number
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'number', validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

package Infoblox::IPAM::DiscoveryTask::VServer;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides
            %_capabilities);

@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::SEARCH_ONLY);

BEGIN {
    $_object_type = 'vdiscovery_server';
    register_wsdl_type('ib:vdiscovery_server', 'Infoblox::IPAM::DiscoveryTask::VServer');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         disable         => 0,
                         encryption      => 0,
                         fqdn_or_ip      => 1,
                         password        => 1,
                         port            => 0,
                         username        => 1,
                        );

    %_name_mappings = (
                       disable         => 'disabled',
                       encryption      => 'conn_proto',
                      );

    %_ibap_to_object = (
                          conn_proto      => \&__i2o_encryption__,
                          disabled        => \&ibap_i2o_boolean,
                       );

    %_searchable_fields = (
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                 disable         => [],
                                 encryption      => [],
                                 fqdn_or_ip      => [],
                                 password        => [],
                                 port            => [],
                                 username        => [],
                               );

    %_object_to_ibap = (
                          disable         => \&ibap_o2i_boolean,
                          encryption      => \&__o2i_encryption__,
                          fqdn_or_ip      => \&ibap_o2i_string,
                          password        => \&ibap_o2i_string_skip_undef,
                          port            => \&ibap_o2i_uint,
                          username        => \&ibap_o2i_string,
                       );

    my @rlist =qw(
               conn_proto
               disabled
               fqdn_or_ip
               port
               username
               );

    foreach my $current (@rlist) {
        push @_return_fields, tField($current);
    }
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

    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                                \%_reverse_name_mappings,
                                                \%_searchable_fields,
                                                \%_ibap_to_object,
                                                \%_object_to_ibap,
                                                \@_return_fields,
                                                \%_return_field_overrides);

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

sub __i2o_encryption__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    return ibap_i2o_enum_mapping_or_empty($self,$session,$current,$ibap_object_ref, undef, {HTTPS => "true", HTTP => "false"});
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;
    
    $$ibap_object_ref{'disabled'} = 0 unless defined($$ibap_object_ref{'disabled'});
    $self->disable("false");
    $self->encryption("false");
    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

}

#
#
#

sub __o2i_encryption__
{
    my ($self, $session, $current, $tempref) = @_;
    my $conv=ibap_value_o2i_enum_mapping($$tempref{$current},$current,$session,0,{"true" => "HTTPS", "false" => "HTTP"});
    if($conv){
      return (1,0,$conv);
    }else{
      return (0);
    }
}

#
#
#
sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name =>'disable', validator=> \&ibap_value_o2i_boolean},@_);
}
sub encryption
{
    my $self=shift;
    return $self->__accessor_scalar__({name =>'encryption', validator=> \&ibap_value_o2i_boolean},@_);
}
sub fqdn_or_ip
{
    my $self=shift;
    return $self->__accessor_scalar__({name =>'fqdn_or_ip', validator=> \&ibap_value_o2i_string},@_);
}
sub password
{
    my $self=shift;
    return $self->__accessor_scalar__({name =>'password', writeonly => 1, validator=> \&ibap_value_o2i_string},@_);
}
sub port
{
    my $self=shift;
    return $self->__accessor_scalar__({name =>'port', validator=> \&ibap_value_o2i_uint},@_);
}
sub username
{
    my $self=shift;
    return $self->__accessor_scalar__({name =>'username', validator=> \&ibap_value_o2i_string},@_);
}

1;
