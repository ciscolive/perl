package Infoblox::DHCP::View;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA
			 $_object_type
			 %_allowed_members
			 @_return_fields
			 %_searchable_fields
			 %_object_to_ibap
			 %_name_mappings
			 %_reverse_name_mappings
			 %_ibap_to_object
             @_internal_no_circular_fields
			 %_return_field_overrides
             $_return_fields_initialized
             @_minimal_return_fields
			 %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'NetworkView';
    register_wsdl_type('ib:NetworkView','Infoblox::DHCP::View',\@_return_fields);

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members = (
						 name                        => 1,
						 comment                     => 0,
                         extattrs                    => 0,
                         extensible_attributes       => 0,
						 external_ddns_primaries     => 0,
						 internal_ddns_zones         => 0,
						 internal_updates_view       => 0,
                         associated_dns_views        => -1,
                         ddns_zone_primaries         => {validator => {'Infoblox::DHCP::DDNS' => 1}, skip_accessor => 1},
                         cloud_info                  => 0,
                         ms_ad_user_data             => {validator => {'Infoblox::Grid::MSServer::AdUser::Data' => 1}, readonly => 1},
                         mgm_private                 => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                        );
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
					   internal_ddns_zones         => 'internal_forward_zones',
					   internal_updates_view       => 'ddns_dns_view',
					   external_ddns_primaries     => 'remote_forward_zones',
                       extattrs                    => 'extensible_attributes',
                      );

    %_reverse_name_mappings = (
							   internal_forward_zones => 'internal_ddns_zones',
							   ddns_dns_view          => 'internal_updates_view',
							   remote_forward_zones   => 'external_ddns_primaries',
							   remote_reverse_zones   => 'external_ddns_primaries',
                               extensible_attributes  => 'extattrs',
							  );

    %_ibap_to_object = (
						remote_forward_zones   => \&__i2o_remote_zones__,
						remote_reverse_zones   => \&__i2o_remote_zones__,
                        extensible_attributes  => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
						internal_forward_zones => \&ibap_i2o_generic_object_list_convert,
						ddns_dns_view          => \&ibap_i2o_generic_object_convert,
						associated_dns_views   => \&ibap_i2o_generic_object_list_convert,
                        ddns_zone_primaries    => \&ibap_i2o_dhcp_ddns,
                        cloud_info             => \&ibap_i2o_generic_object_convert,
                        ms_ad_user_data        => \&ibap_i2o_generic_object_convert,
                       );

	%_return_field_overrides = (
								name                        => [],
								comment                     => [],
                                extattrs                    => [],
                                extensible_attributes       => [],
								external_ddns_primaries     => [],
								internal_ddns_zones         => [],
								internal_updates_view       => [],
                                associated_dns_views        => [],
                                ddns_zone_primaries         => [],
                                cloud_info                  => [],
                                ms_ad_user_data             => [],
                                mgm_private                 => [],
							   );

    %_object_to_ibap = (
						name                        => \&ibap_o2i_string,
						comment                     => \&ibap_o2i_string,
                        extattrs                    => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes       => \&ibap_o2i_ignore,
						external_ddns_primaries     => \&__o2i_external_ddns_primaries__,
						internal_ddns_zones         => \&__o2i_zone__,
						internal_updates_view       => \&ibap_o2i_view,
						#
						associated_dns_views        => \&ibap_o2i_ignore,
                        ddns_zone_primaries         => \&ibap_o2i_generic_struct_list_convert,
                        cloud_info                  => \&ibap_o2i_generic_struct_convert,
                        ms_ad_user_data             => \&ibap_o2i_ignore,
                        mgm_private                 => \&ibap_o2i_boolean,
                       );

    %_searchable_fields = (
						   name    => [\&ibap_o2i_string ,'name'   , 'REGEX'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                          );

    @_minimal_return_fields = (
                               tField('name'),
                               tField('comment'),
                              );

    $_return_fields_initialized=0;
    my @rlist = (
                 'name',
                 'comment',
                 'internal_forward_zones',
                 'ddns_dns_view',
                 'mgm_private',
                 'associated_dns_views',
                );

    foreach my $current (@rlist) {
        push @_return_fields, tField($current);
    }

    @rlist = (
              'remote_forward_zones',
              'remote_reverse_zones',
             );

    foreach my $current (@rlist) {
        push @_return_fields, tField($current,
                                     {
                                      sub_fields => [
                                                     tField('fqdn'),
                                                     tField('server_address'),
                                                     tField('use_tsig_key'),
                                                     tField('tsig_key_alg'),
                                                     tField('tsig_key_name'),
                                                     tField('tsig_key'),
                                                     tField('gss_tsig_domain'),
                                                     tField('gss_tsig_dns_principal'),
                                                    ]
                                     }
                                    );

        push @_internal_no_circular_fields, tField($current,
                                                   {
                                                    sub_fields => [
                                                                   tField('fqdn'),
                                                                   tField('server_address'),
                                                                   tField('use_tsig_key'),
                                                                   tField('tsig_key_alg'),
                                                                   tField('tsig_key_name'),
                                                                   tField('tsig_key'),
                                                                  ]
                                                   }
                                                  );
    }

    #
    @rlist = (
             'ddns_dns_view',
             'associated_dns_views',
            );

    foreach my $current (@rlist) {
        push @_return_fields, tField($current,
                                     {
                                      depth => 3
                                     }
                                    );

        push @_internal_no_circular_fields, tField($current,
                                                   {
                                                    depth => 3,
                                                   }
                                                  );
    }

    #
    #
    #
    #
    #
    #
    #
    push @_internal_no_circular_fields, tField('internal_forward_zones',
                                               {
                                                sub_fields => [ tField('fqdn')],
                                               }
                                              );

    push @_return_fields,return_fields_extensible_attributes();

    push @_internal_no_circular_fields,return_fields_extensible_attributes();
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

sub __init_instance_constants__
{
    my $self = shift;

	unless ($_return_fields_initialized) {
		$_return_fields_initialized=1;

        #
        my $z = Infoblox::DNS::Zone->__new__();

        #
        #
        #
        #
        my $t = $z->__return_fields__();
        my @return_fields_copy;

        foreach my $x (@$t) {
            if ($x->{'val'}->{'field'} eq 'view') {
                my @view_return_fields;

                foreach my $y (@{$x->{'val'}->{'sub_fields'}}) {
                    if ($y->{'val'}->{'field'} eq 'network_view') {
                        push @view_return_fields, tField('network_view', { sub_fields => \@_internal_no_circular_fields });
                    }
                    else {
                        push @view_return_fields, $y;
                    }
                }
                push @return_fields_copy, tField('view', { sub_fields => \@view_return_fields });
            }
            else {
                push @return_fields_copy, $x;
            }
        }

        push @_return_fields,
          tField('internal_forward_zones', {
                          default_no_access_ok => 1,
                          sub_fields => \@return_fields_copy,
                         }
                );

        my %tmp = (
                   'ddns_zone_primaries' => 'Infoblox::DHCP::DDNS',
                   'cloud_info'          => 'Infoblox::Grid::CloudAPI::Info',
                   'ms_ad_user_data'     => 'Infoblox::Grid::MSServer::AdUser::Data',
        );

        foreach my $key (keys %tmp) {
            $t = $tmp{$key}->__new__();
            push @_return_fields, tField($key, {sub_fields => $t->__return_fields__()});
        }
    }
}

#
#
#
sub __i2o_remote_zones__
{
	my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my (@tlist, @newlist);

    if ($self->external_ddns_primaries()) {
        @tlist = @{$self->external_ddns_primaries()};
    }

    #
    my $zones = ibap_i2o_remote_ddns_zone_list_convert($self,
        $session, $current, $ibap_object_ref, $return_object_cache_ref, 'ddns_zone');

    push @newlist, @tlist if @tlist;
    push @newlist, @$zones if $zones;

    if (@newlist) {
        return \@newlist;
    } else {
        return;
    }
}


sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    #
    #
    $self->external_ddns_primaries([]);
    $self->internal_ddns_zones([]);

    $self->{'__internal_session_cache_ref__'} = $session;

    $$ibap_object_ref{'mgm_private'} = 0 unless defined $$ibap_object_ref{'mgm_private'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    #
    $self->{associated_dns_views} = [] unless defined $self->{associated_dns_views};

	return;
}

#
#
#
sub __o2i_external_ddns_primaries__
{
	my ($self, $session, $current, $tempref) = @_;
    my %temphash;
    my @return_args;

    if (defined $tempref->{$current}) {
		if (ref ($tempref->{$current}) eq 'ARRAY') {
            #

            my @zone_list = @{$tempref->{$current}};

            #
            my $suffix_pattern = '\.in-addr\.arpa';
            my $suffix_pattern_ipv6 ='\.ip6\.arpa';
            my $reverse_zone_pattern = "$suffix_pattern\$|$suffix_pattern_ipv6\$";

            #
            #
            my $fqdn_field = 'ddns_zone';
            my @forward_zones = grep {$_->$fqdn_field() !~ /$reverse_zone_pattern/} @zone_list;
            my @reverse_zones = grep {$_->$fqdn_field() =~ /$reverse_zone_pattern/} @zone_list;

            my ($forward_zones_ref, $reverse_zones_ref);

            #
            if (@forward_zones) {
                $forward_zones_ref = \@forward_zones;
            } else {
                $forward_zones_ref = [];
            }

            #
            $temphash{$current} = $forward_zones_ref;
            @return_args = ibap_arg_remote_ddns_zone_list($self,
                $session, $current, \%temphash, $fqdn_field);

            #
            if (@reverse_zones) {
                $reverse_zones_ref = \@reverse_zones;
            } else {
                $reverse_zones_ref = [];
            }

            #
            $temphash{$current} = $reverse_zones_ref;
            my @reverse_zone_args = ibap_arg_remote_ddns_zone_list($self,
                $session, $current, \%temphash, $fqdn_field);

            #
            #
            #
            return if (!@return_args || !@reverse_zone_args);

            #
            my $success=shift @reverse_zone_args;
            if ($success) {
                my $ignore_value=shift @reverse_zone_args;
                return if $ignore_value;

                my %extra_args;
                $extra_args{'field'} = 'remote_reverse_zones';
                $extra_args{'value'} = shift @reverse_zone_args;
                push @return_args, \%extra_args
            } else {
                push @return_args, 0;
            }
		} else {
			push @return_args, 0;
		}
    } else {
		push @return_args, 1;
		push @return_args, 1;
		push @return_args, undef;
    }

    return @return_args;
}

sub __o2i_zone__
{
	my ($self, $session, $current, $tempref) = @_;
	my @return_args;

	if (defined $$tempref{$current}) {
		if (ref ($$tempref{$current}) eq 'ARRAY') {
			my @list=@{$$tempref{$current}};
			my @newlist;

			foreach my $member (@list) {
				if ($member->__object_id__()) {
					push @newlist, tObjIdRef($member->__object_id__());
				} else {
					my $viewref = $member->views();
					my $view;
					my @fields;

					if ($viewref) {
						$view = @{$viewref}[0];
					}

                    my $tview = ' ';
					if ($viewref && $view->name()) {
						@fields = (
								   {
									'field' => 'fqdn',
									'value' => ibap_value_o2i_string($member->name()),
								   },
								   {
									'field' => 'view',
									'value' => ibap_readfield_simple_string('View','name',$view->name(),'view'),
								   },
								  );

                        $tview .= $view->name();
					} else {
						@fields = (
								   {
									'field' => 'fqdn',
									'value' => ibap_value_o2i_string($member->name()),
								   },
								   {
									'field' => 'view',
									'value' => ibap_readfield_simple('View','is_default', tBool(1),'view=(default view)'),
								   },
								  );

                        $tview .= '(default view)';
					}
					push @newlist, ibap_readfield_simple('AllZone',\@fields,undef,'zone='. $member->name() . $tview);
				}
			}
			push @return_args, 1;
			push @return_args, 0;
                        #
                        #
			push @return_args, tIBType('ArrayOfBaseObject', \@newlist);
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

sub __object_to_ibap__
{
	my ($self, $server, $session) = @_;

    return $self->SUPER::__object_to_ibap__($server, $session);
}

#
#
#

sub comment
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub external_ddns_primaries
{
    my $self=shift;

    return $self->__accessor_array__({name => 'external_ddns_primaries', validator => { 'Infoblox::DNS::Nameserver' => 1 }}, @_);
}

sub internal_ddns_zones
{
    my $self=shift;

    return $self->__accessor_array__({name => 'internal_ddns_zones', validator => { 'Infoblox::DNS::Zone' => 1 }}, @_);
}

sub internal_updates_view
{
    my $self=shift;

    return $self->__accessor_scalar__({name => 'internal_updates_view', validator => { 'Infoblox::DNS::View' => 1 }}, @_);
}

sub associated_dns_views
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'associated_dns_views', validator => { 'Infoblox::DNS::View' => 1 }, readonly => 1}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub ddns_zone_primaries
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'ddns_zone_primaries', validator => { 'Infoblox::DHCP::DDNS' => 1 }}, @_);
}

sub cloud_info
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'cloud_info', validator => {'Infoblox::Grid::CloudAPI::Info' => 1}}, @_);
}

sub modify_vrf_assignment {
  my ($self, %args) = @_;

  unless ( $self->{'__internal_session_cache_ref__'} ) {
  	set_error_codes(1001, 'In order to modify VRF assignment the Infoblox::DHCP::View should be retrieved from the server first');
	return 0;
  }
  my $session = $self->{'__internal_session_cache_ref__'};
  my $server  = $session->get_ibap_server() || return 0;

  my $ref_allowed_arguments = { vrfs => 1, mode => 1 };

  unless ($session->__validate_arguments_from_arg_list__($ref_allowed_arguments, \%args)) {
		return 0;
  }
  
  if ( $args{mode} ne 'UNASSIGN' && $args{mode} ne 'ASSIGN' ) {
		set_error_codes(1103, "Invalid 'mode' value. The valid values are 'ASSIGN' and 'UNASSING'.", $session);
    	return 0;
  }

  unless (ref $args{vrfs} eq 'ARRAY') {	
		set_error_codes(1103, "Invalid 'vrfs' value. The valid value is an ARRAY ref.", $session);
		return 0;
  }
  
  foreach my $vrf ( @{$args{vrfs}}  ) {
  	if (ref $vrf ne 'Infoblox::Grid::Member::Discovery::VRF') {
    	set_error_codes('1103', "Invalid 'vrfs' values. The valid value is an array of Infoblox::Grid::Member::Discovery::VRF object.", $session);
		return 0;    	
  	}
  }
  
  my ($rc, $is_ignore, $ibap_vrfs) = ibap_o2i_object_by_oid_or_name( $self, $session, 'vrf', {vrf => $args{vrfs}} );
  return 0 unless $rc;
  
  my $ibap_network_view = tIBType('BaseObject', { object_id => tObjId($self->__object_id__()) });
 
  my $func_args = { 
  	  network_view => $ibap_network_view,
  	  vrf          => $ibap_vrfs,
  	  mode         => ibap_value_o2i_string($args{mode})
  };
  
  my $result;
  eval { $result = $server->ibap_request('ModifyVrfAssignment', $func_args); };

  return $server->set_papi_error($@, $session) if $@;
  set_error_codes(0, undef);
  return 1;

}


1;
