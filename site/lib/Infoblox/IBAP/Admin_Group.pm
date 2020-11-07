package Infoblox::Grid::Admin::Group;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_capabilities %_return_field_overrides %_ibap_to_object %_name_mappings %_reverse_name_mappings $get_accessrights);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'AdminGroup';
    register_wsdl_type('ib:AdminGroup','Infoblox::Grid::Admin::Group');

    $get_accessrights = Infoblox::__options('accessrights');

    %_capabilities = (
                      'depth'                  => 0,
                      'implicit_defaults'      => 0,
                      'single_serialization' => 0,
                     );

    %_allowed_members = (
                         comment               => 0,
                         disabled               => 0,
                         extattrs             => 0,
                         extensible_attributes => 0,
                         lease_history_access => 0,
                         name                   => 1,
                         permission_list       => 0,
                         superuser               => 0,
                         tree_size               => 0, # ignored, backwards compatibility
                         access_method        => 0,
                         roles                => 0,
                         email_addresses      => 0,
                         enable_restricted_user_access => 0,
                         user_access => 0,
                        );

    #
    %_ibap_to_object = (
                       disabled => \&ibap_i2o_boolean,
                       superuser => \&ibap_i2o_boolean,
                       extensible_attributes => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                       email_addresses => \&ibap_i2o_email_list,
                       enable_restricted_user_access => \&ibap_i2o_boolean,
                       user_access => \&ibap_i2o_ac_setting,
#
#
#
                       );

    %_name_mappings = (
                       'extattrs' => 'extensible_attributes',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    @_return_fields = (
                       tField('comment'),
                       tField('disabled'),
                       tField('name'),
                       tField('superuser'),
                       tField('can_access_gui'),
                       tField('can_access_papi'),
                       tField('can_access_taxii'),
                       tField('email_addresses'),
                       tField('roles', { sub_fields => [tField('name')] }),
                       tField('enable_restricted_user_access'),
                       tField('user_access', return_fields_ac_setting()),

                       return_fields_extensible_attributes(),
                       );

    %_return_field_overrides = (
                                comment              => [],
                                disabled              => [],
                                lease_history_access => [],
                                name                  => [],
                                permission_list      => [],
                                superuser              => [],
                                access_method        => [],
                                roles                => [],
                                extattrs             => [],
                                extensible_attributes => [],
                                email_addresses      => [],
                                enable_restricted_user_access => [],
                                user_access => [],
                               );

    %_searchable_fields = (
                           name    => [\&ibap_o2i_string ,'name'   , 'REGEX'],
                           roles   => [\&__o2i_roles__, 'roles', 'LIST_INTERSECT'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                          );


    %_object_to_ibap = (
                        comment              => \&ibap_o2i_string ,
                        disabled              => \&ibap_o2i_boolean,
                        lease_history_access => \&ibap_o2i_ignore,
                        name                  => \&ibap_o2i_string,
                        superuser              => \&ibap_o2i_boolean,
                        tree_size              => \&ibap_o2i_ignore,
                        roles                => \&__o2i_roles__,
                        extattrs               => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes  => \&ibap_o2i_ignore,
                        email_addresses      => \&ibap_o2i_email_list,
                        enable_restricted_user_access => \&ibap_o2i_boolean,
                        user_access => \&ibap_o2i_ac_setting_undef_to_empty_list,
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

    $self->{__unexposed_permission_cache__} = undef;

    #
    unless( defined $self->access_method() ) {
        $self->access_method( [ 'GUI', 'API', 'TAXII' ]);
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

#
#
#

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session,
        $return_object_cache_ref) = @_;

    #
    my @access_method;

    foreach my $current (sort keys %$ibap_object_ref) {
        next if $current eq 'flag';

        if ($current eq 'roles') {
            my @role_names;
            foreach (@{$$ibap_object_ref{$current}}) {
                next if (!defined $_);
                push @role_names, $_->{'name'};
            }
            $self->roles(\@role_names);
        } elsif ($current eq 'object_id') {
            $self->__object_id__($$ibap_object_ref{$current}{'id'});
        } elsif ($current =~ m/^(disabled|superuser|enable_restricted_user_access)/) {
            $self->$current(ibap_value_i2o_boolean($$ibap_object_ref{$current}));
        } elsif ($current =~ m/extensible_attributes/) {
            $self->extattrs(Infoblox::IBAPBase::__i2o_extensible_attributes__($self, $session, $current, $ibap_object_ref, $return_object_cache_ref));
        } elsif ($current =~ m/^user_access$/) {
            $self->$current(ibap_i2o_ac_setting($self, $session, $current, $ibap_object_ref, $return_object_cache_ref));
        }elsif($current =~ m/can_access_gui/) {
            my $can_access_gui = ibap_value_i2o_boolean($$ibap_object_ref{$current});
            if( $can_access_gui eq 'true' ) {
                push @access_method, 'GUI';
            }
        }elsif($current =~ m/can_access_papi/) {
            my $can_access_papi = ibap_value_i2o_boolean($$ibap_object_ref{$current});
            if( $can_access_papi eq 'true' ) {
                push @access_method, 'API';
            }
        }elsif($current =~ m/can_access_taxii/) {
            my $can_access_taxii = ibap_value_i2o_boolean($$ibap_object_ref{$current});
            if ($can_access_taxii eq 'true') {
                push @access_method, 'TAXII';
            }
        } elsif($current eq 'email_addresses') {
            $self->$current(ibap_i2o_email_list($self, $session, $current, $ibap_object_ref));
        } else {
            if ($self->can($current)) {
                $self->$current($$ibap_object_ref{$current},$return_object_cache_ref);
            }
        }
    }

    $self->access_method(\@access_method);
    if ($self->superuser() && $self->superuser() =~ m/true/i) {
        #
        #
        #

        $self->lease_history_access('true');
        $self->permission_list([]);
        return;
    }

    #
    return if !$get_accessrights;

    my @permissions = $session->get( object => 'Infoblox::Grid::Admin::Permission',
                                     admin_group => $self->name());
    #
    set_error_codes(0,undef,$session);

    my %zones;
    my @accessrights;
    my @unexposed_accessrights;

    foreach my $perm (@permissions) {
        my ($access, $op, $p)=$self->__inv_perm_mapping__($perm->permission());

        if ($perm->resource_object()) {
            if (ref($perm->resource_object()) eq 'Infoblox::DNS::Zone') {
                #
                #
                my $display_domain = $perm->resource_object()->{'display_domain'};

                my $view=@{$perm->resource_object()->views()}[0];
                my $pid=$display_domain . ';' . $view->name();

                if ($perm->resource_type()) {
                    my $rr = $zones{$pid}{'rr'};
                    unless ($rr) {
                        $zones{$pid}{'rr'} = Infoblox::Grid::Admin::ZoneRrTypePermissions->__new__();
                        $rr = $zones{$pid}{'rr'};
                    }

                    if ($perm->resource_type() eq 'All AAAA Records') {
                        $rr->aaaa_permission($p);
                    } elsif ($perm->resource_type() eq 'All A Records') {
                        $rr->a_permission($p);
                    } elsif ($perm->resource_type() eq 'All BULKHOST Records') {
                        $rr->bulk_host_permission($p);
                    } elsif ($perm->resource_type() eq 'All TXT Records') {
                        $rr->txt_permission($p);
                    } elsif ($perm->resource_type() eq 'All SRV Records') {
                        $rr->srv_permission($p);
                    } elsif ($perm->resource_type() eq 'All PTR Records') {
                        $rr->ptr_permission($p);
#
#
#
                    } elsif ($perm->resource_type() eq 'All MX Records') {
                        $rr->mx_permission($p);
                    } elsif ($perm->resource_type() eq 'All CNAME Records') {
                        $rr->cname_permission($p);
                    } elsif ($perm->resource_type() eq 'All DNAME Records') {
                        $rr->dname_permission($p);
                    } elsif ($perm->resource_type() eq 'All Host Records') {
                        $rr->host_permission($p);
                    } else {
                        push @unexposed_accessrights, $perm;
                        next;
                    }
                }
                else {
                    $zones{$pid}{'access'} = $access;
                    $zones{$pid}{'operation'} = $op;
                }
            } elsif (ref($perm->resource_object()) eq 'Infoblox::DNS::View') {
                push @accessrights, Infoblox::Grid::Admin::ViewAndZonePermission->new(
                                                                                      access     => $access,
                                                                                      operation => $op,
                                                                                      zone      => '',
                                                                                      view   => $perm->resource_object()->name());
            } elsif (ref($perm->resource_object()) eq 'Infoblox::Grid::Member') {
                push @accessrights, Infoblox::Grid::Admin::GridMemberPermission->new(
                                                                                      access     => $access,
                                                                                      operation => $op,
                                                                                      name     => $perm->resource_object()->name(),
                                                                                      ipv4Addr => $perm->resource_object()->ipv4addr());
            } elsif (ref($perm->resource_object()) eq 'Infoblox::DNS::SRG') {
                push @accessrights, Infoblox::Grid::Admin::SharedRecordGroupPermission->new(
                                                                                      access     => $access,
                                                                                      operation => $op,
                                                                                      group_name   => $perm->resource_object()->name());
            } elsif (ref($perm->resource_object()) eq 'Infoblox::DHCP::Network') {
                push @accessrights, Infoblox::Grid::Admin::NetworkPermission->new(
                                                                                  access     => $access,
                                                                                  operation => $op,
                                                                                  network => $perm->resource_object()->network());
            } elsif (ref($perm->resource_object()) eq 'Infoblox::DHCP::SharedNetwork') {
                push @accessrights, Infoblox::Grid::Admin::NetworkPermission->new(
                                                                                  access     => $access,
                                                                                  operation => $op,
                                                                                  network => $perm->resource_object()->name());
            } else {
                push @unexposed_accessrights, $perm;
                next;
            }
        }
        else {
            if ($perm->resource_type() eq 'All Zones') {
                push @accessrights, Infoblox::Grid::Admin::ViewAndZonePermission->new(
                                                                                      zone      => 'All Zones',
                                                                                      view      => '',
                                                                                      access     => $access,
                                                                                      operation => $op,
                                                                                     );

            } elsif ($perm->resource_type() eq 'All IPv4 Networks') {
                push @accessrights, Infoblox::Grid::Admin::NetworkPermission->new(
                                                                                  network     => 'All Networks',
                                                                                  access     => $access,
                                                                                  operation => $op,
                                                                            );
            } elsif ($perm->resource_type() eq 'All Members') {
                push @accessrights, Infoblox::Grid::Admin::GridMemberPermission->new(
                                                                                     ipv4Addr   => 'All Members',
                                                                                      access     => $access,
                                                                                      operation => $op,
                                                                               );
            } elsif ($perm->resource_type() eq 'All IPv4 DHCP Shared Networks') {
                push @accessrights, Infoblox::Grid::Admin::NetworkPermission->new(
                                                                                  network     => 'All Shared Networks',
                                                                                  access     => $access,
                                                                                  operation => $op,
                                                                            );
            } elsif ($perm->resource_type() eq 'All Shared Record Groups') {
                push @accessrights, Infoblox::Grid::Admin::SharedRecordGroupPermission->new(
                                                                                            group_name       => 'All Shared Record Groups',
                                                                                            access     => $access,
                                                                                            operation => $op,
                                                                                      );
            } elsif ($perm->resource_type() eq 'All IPv4 DHCP Lease History') {
                if ($p =~ /read/i ) {
                    $self->lease_history_access('true');
                }
                else {
                    $self->lease_history_access('false');
                }
            } else {
                push @unexposed_accessrights, $perm;
                next;
            }
        }
    }

    #
    #
    $self->{__unexposed_permission_cache__} = \@unexposed_accessrights;

    foreach my $zone (keys %zones) {
        my ($name, $view) = split ';', $zone;

        my $t = Infoblox::Grid::Admin::ViewAndZonePermission->new(
                                                                  access     => $zones{$zone}{'access'},
                                                                  operation => $zones{$zone}{'operation'},
                                                                  zone       => $name,
                                                                  view       => $view);

        if (defined $zones{$zone}{'rr'}) {
            $t->rr_type_permissions($zones{$zone}{'rr'});
        }

        push @accessrights, $t;
    }

    $self->permission_list(\@accessrights);

    return;
}

sub __perm_mapping__
{
    my ($self, $access, $operation)=@_;

    if ($operation) {
        if ($access =~ /deny/i) {
            return 'deny';
        } else {
            if ($operation =~ /write/i) {
                return 'write';
            } else {
                return 'read';
            }
        }
    } else {
        if ($access =~ /deny/i) {
            return 'deny';
        } elsif ($access =~ /write/i) {
            return 'write';
        } else {
            return 'read';
        }
    }
}

sub __inv_perm_mapping__
{
    my ($self, $t)=@_;

    if ($t =~ /deny/i) {
        return ('Deny', 'Read-Only', 'Deny',);
    } elsif ($t =~ /write/i) {
        return ('Allow', 'Read/Write','Read/Write',);
    } else {
        return ('Allow', 'Read-Only','Read-Only');
    }
}

sub __perm_mapping_rr__
{
    my ($self,$group,$type,$tempzone,$p) = @_;

    if ($tempzone) {
        return Infoblox::Grid::Admin::Permission->new(
                                                      admin_group       => $group,
                                                      resource_type   => $type,
                                                      resource_object => $tempzone,
                                                      permission       => $p);
    }
    else {
        return Infoblox::Grid::Admin::Permission->new(
                                                      admin_group       => $group,
                                                      resource_type   => $type,
                                                      permission       => $p);
    }
}

sub __convert_old_permission_to_new__
{
    my ($self, $currentar) = @_;

    my $op = $self->__perm_mapping__($currentar->access(),$currentar->operation());

    if (ref($currentar) =~ m/GridMemberPermission/) {
        if ($currentar->ipv4Addr() eq 'All Members') {
            return Infoblox::Grid::Admin::Permission->new(
                                                          admin_group   => $self->name(),
                                                          resource_type => 'All Members',
                                                          permission    => $op);
        } else {
            my $name=$currentar->name();
            my $tempmember;

            if ($name) {
                $tempmember = Infoblox::Grid::Member->new(
                                                          ipv4addr => $currentar->ipv4Addr(),
                                                          name       => $name,
                                                          gateway  => '127.0.0.1',
                                                          mask        => '255.255.255.255',
                                                          grid       => 0,
                                                         );
            }
            else {
                $tempmember = Infoblox::Grid::Member->new(
                                                          ipv4addr => $currentar->ipv4Addr(),
                                                          name       => 'bogus.infoblox.com',
                                                          gateway  => '127.0.0.1',
                                                          mask        => '255.255.255.255',
                                                          grid       => 0,
                                                         );
                $tempmember->name(undef);
            }

            return Infoblox::Grid::Admin::Permission->new(
                                                          admin_group      => $self->name(),
                                                          resource_object => $tempmember,
                                                          permission    => $op);
        }
    } elsif (ref($currentar) =~ m/ViewAndZonePermission/) {
        my $tempzone;
        my @returnlist;

        if (defined($currentar->zone()) && $currentar->zone() eq 'All Zones') {
            return Infoblox::Grid::Admin::Permission->new(
                                                          admin_group   => $self->name(),
                                                          resource_type => 'All Zones',
                                                          permission    => $op);
        } elsif ((not defined($currentar->zone())) || $currentar->zone() eq '') {
            my $tempview = Infoblox::DNS::View->new(name => $currentar->view());
            return Infoblox::Grid::Admin::Permission->new(
                                                          admin_group      => $self->name(),
                                                          resource_object => $tempview,
                                                          permission    => $op);
        } else {
            my $tempview = Infoblox::DNS::View->new(name => $currentar->view());
            $tempzone = Infoblox::DNS::Zone->new(name => $currentar->zone(), views => [$tempview]);
            push @returnlist, Infoblox::Grid::Admin::Permission->new(
                                                                     admin_group      => $self->name(),
                                                                     resource_object => $tempzone,
                                                                     permission    => $op);
        }

        if ($currentar->rr_type_permissions()) {
            my $perm=$currentar->rr_type_permissions();

            if ($perm->txt_permission()) {
                my $p=$self->__perm_mapping__($perm->txt_permission());
                push @returnlist, $self->__perm_mapping_rr__($self->name(),'All TXT Records', $tempzone, $p);
            }

            if ($perm->srv_permission()) {
                my $p=$self->__perm_mapping__($perm->srv_permission());
                push @returnlist, $self->__perm_mapping_rr__($self->name(),'All SRV Records',$tempzone,$p);
            }

            if ($perm->ptr_permission()) {
                my $p=$self->__perm_mapping__($perm->ptr_permission());
                push @returnlist, $self->__perm_mapping_rr__($self->name(),'All PTR Records',$tempzone,$p);
            }

            if ($perm->ns_permission()) {
                my $p=$self->__perm_mapping__($perm->ns_permission());
                push @returnlist, $self->__perm_mapping_rr__($self->name(),'All NS Records',$tempzone,$p);
            }

            if ($perm->mx_permission()) {
                my $p=$self->__perm_mapping__($perm->mx_permission());
                push @returnlist, $self->__perm_mapping_rr__($self->name(),'All MX Records',$tempzone,$p);
            }

            if ($perm->dname_permission()) {
                my $p=$self->__perm_mapping__($perm->dname_permission());
                push @returnlist, $self->__perm_mapping_rr__($self->name(),'All DNAME Records',$tempzone,$p);
            }

            if ($perm->cname_permission()) {
                my $p=$self->__perm_mapping__($perm->cname_permission());
                push @returnlist, $self->__perm_mapping_rr__($self->name(),'All CNAME Records',$tempzone,$p);
            }

            if ($perm->aaaa_permission()) {
                my $p=$self->__perm_mapping__($perm->aaaa_permission());
                push @returnlist, $self->__perm_mapping_rr__($self->name(),'All AAAA Records',$tempzone,$p);
            }

            if ($perm->a_permission()) {
                my $p=$self->__perm_mapping__($perm->a_permission());
                push @returnlist, $self->__perm_mapping_rr__($self->name(),'All A Records',$tempzone,$p);
            }

            if ($perm->bulk_host_permission()) {
                my $p=$self->__perm_mapping__($perm->bulk_host_permission());
                push @returnlist, $self->__perm_mapping_rr__($self->name(),'All BULKHOST Records',$tempzone,$p);
            }

            if ($perm->host_permission()) {
                my $p=$self->__perm_mapping__($perm->host_permission());
                push @returnlist, $self->__perm_mapping_rr__($self->name(),'All HOST Records',$tempzone,$p);
            }
        }
        return @returnlist;
    } elsif (ref($currentar) =~ m/NetworkPermission/) {
        if ($currentar->network() eq 'All Networks') {
            return Infoblox::Grid::Admin::Permission->new(
                                                          admin_group   => $self->name(),
                                                          resource_type => 'All IPv4 Networks',
                                                          permission    => $op);
        } elsif ($currentar->network() eq 'All Shared Networks') {
            return Infoblox::Grid::Admin::Permission->new(
                                                          admin_group   => $self->name(),
                                                          resource_type => 'All IPv4 DHCP Shared Networks',
                                                          permission    => $op);
        } else {
            if ($currentar->network() =~ m!^([0-9\.]+)/([0-9\.]+)$!) {
                my $tempnetwork = Infoblox::DHCP::Network->new(network => $currentar->network());
                return Infoblox::Grid::Admin::Permission->new(
                                                              admin_group      => $self->name(),
                                                              resource_object => $tempnetwork,
                                                              permission    => $op);
            } else {
                my $tempnetwork = Infoblox::DHCP::SharedNetwork->new(
                                                                     name => $currentar->network(),
                                                                     networks => []
                                                                    );
                return Infoblox::Grid::Admin::Permission->new(
                                                              admin_group      => $self->name(),
                                                              resource_object => $tempnetwork,
                                                              permission    => $op);
            }
        }
    } elsif (ref($currentar) =~ m/SharedRecordGroupPermission/) {
        if ($currentar->group_name() eq 'All Shared Record Groups') {
            return Infoblox::Grid::Admin::Permission->new(
                                                          admin_group   => $self->name(),
                                                          resource_type => 'All Shared Record Groups',
                                                          permission    => $op);
        } else {
            my $tempsrg = Infoblox::DNS::SRG->new(name => $currentar->group_name());
            return Infoblox::Grid::Admin::Permission->new(
                                                          admin_group      => $self->name(),
                                                          resource_object => $tempsrg,
                                                          permission    => $op);
        }
    }
}

#
sub __post_insert_hook__
{
    my ($self, $server, $session) = @_;
    my @insertlist;

    if ($self->superuser() && $self->superuser() =~ m/true/i) {
        #
        return 1;
    }

    if (defined $self->{'lease_history_access'}) {
        my $value=0;
        if ($self->{'lease_history_access'} =~ m/true/i) {
            $value='read';
        } else {
            $value='deny';
        }

        push @insertlist, Infoblox::Grid::Admin::Permission->new(
                                                                 admin_group   => $self->name(),
                                                                 resource_type => 'All IPv4 DHCP Lease History',
                                                                 permission    => $value);
    }

    if (defined $self->{'permission_list'}) {
        my @arlist=@{$self->{'permission_list'}};

        foreach my $currentar (@arlist) {
            push @insertlist, $self->__convert_old_permission_to_new__($currentar);
        }
    }

    if (@insertlist) {
        my @search_fields;
        push @search_fields, { field => 'entity',
                                       value => tObjId($self->__object_id__()) };

        my $result = $self->__extended_write__($server, $session, \@insertlist, \@search_fields);
        unless ($result) {
            #
            $session->remove($self);
            return;
        }
    }

    return 1;
}

sub __extended_write__
{
    my ($self, $server, $session, $objects, $search_fields_ref) = @_;
    my @objects = @{$objects};
    my @search_fields = @{$search_fields_ref};
    my @list_actions;


    foreach my $current (@objects) {
        my %temp_action;
        my $temp_converted_permission = $current->__object_to_ibap__($server, $session);

        next unless $temp_converted_permission; # This can be caused by now invalid 'all NS in zone' permissions.
        $temp_action{'item_action'} = 'INSERT';
        $temp_action{'item_write_fields'} = $temp_converted_permission;

        push @list_actions, \%temp_action;
    }

    my $result;

    #
    eval { $result = $server->ObjectWrite
                   ({op => 'UPDATE_LIST_ALL',
                     object_type => 'AccessRight',
                     search_fields => \@search_fields,
                     list_actions => \@list_actions} ); };

    return $server->set_papi_error($@, $self) if $@;
    return 1;
}

sub __post_modify_hook__
{
    my ($self, $server, $session) = @_;
    my @updatelist;

    if ($self->superuser() && $self->superuser() =~ m/true/i) {
        #
        return 1;
    }

    if (defined $self->{'lease_history_access'}) {
        my $value=0;
        if ($self->{'lease_history_access'} =~ m/true/i) {
            $value='read';
        } else {
            $value='deny';
        }

        push @updatelist, Infoblox::Grid::Admin::Permission->new(
                                                                 admin_group   => $self->name(),
                                                                 resource_type => 'All IPv4 DHCP Lease History',
                                                                 permission    => $value);
    }

    if ($self->permission_list()) {
        my @arlist=@{$self->permission_list()};
        my @others;

        if ($self->{__unexposed_permission_cache__}) {
            @others=@{$self->{__unexposed_permission_cache__}};
        }

        foreach (@arlist) {
            push @updatelist, $self->__convert_old_permission_to_new__($_);
        }

        foreach my $current (@others) {
            #
            $current->admin_group($self->name());
            push @updatelist, $current;
        }
     }

    my @search_fields;
    push @search_fields, { field => 'entity',
                               value => tObjId($self->__object_id__())};

    if ($self->permission_list() && defined $self->{'lease_history_access'}) {
        #
    } elsif ($self->permission_list()) {
        #

        my %arg2;
        $arg2{'field'} = 'resource_type';
        $arg2{'value'} = tString('DHCP_LEASE_HISTORY');
        $arg2{'ifmatch'} = 'NEGATIVE';
        push @search_fields, \%arg2;

    } elsif (defined $self->{'lease_history_access'}) {
        #
        my %arg2;
        $arg2{'field'} = 'resource_type';
        $arg2{'value'} = tString('DHCP_LEASE_HISTORY');
        push @search_fields, \%arg2;
    }
    else {
        #
        return 1;
    }

    return $self->__extended_write__($server, $session, \@updatelist, \@search_fields);
}

#
#
#

sub __o2i_roles__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current})
    {
        if (ref ($$tempref{$current}) eq 'ARRAY')
        {
            my $type_list = [ 'Infoblox::DNS::string_object' ];
            if (!Infoblox::Util::check_vector_type($$tempref{$current},
                    $type_list))
            {
                push @return_args, 0;
                return @return_args;
            }
            my @roles;
            my @list = @{$$tempref{$current}};
            foreach (@list)
            {
                next if (!defined $_);
                push @roles, ibap_readfield_simple_string(
                            'Role', 'name', $_, 'roles');
            }
            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType('ArrayOfBaseObject', \@roles);
        }
        else
        {
            push @return_args, 0;
        }
    }
    else
    {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}

sub __object_to_ibap__
{
    my ($self, $server, $session, $modify) = @_;

    my @write_fields;

    #
    #

    foreach my $current (keys %$self) {
        next if $current =~ m/^__/;
        next if $current eq 'permission_list';

        my %write_arg;

        #
        if( $current eq 'access_method' ) {

            my $access_method = $self->{$current};
            my ($enable_gui, $enable_api, $enable_taxii) = (0, 0, 0);
            my (%access_gui_field, %access_papi_field, %access_taxii_field);
            foreach(@$access_method)
            {
                if(m/^GUI$/i) {
                    $enable_gui = 1;
                } elsif( m/^API$/i ) {
                    $enable_api = 1;
                } elsif ( m/^TAXII$/i) {
                    $enable_taxii = 1;
                }
                else {
                    set_error_codes(1012,'Invalid value ' . $_ . ' for field access_method', $session);
                    return;
                }
            }

            $access_gui_field{'field'}='can_access_gui';
            $access_gui_field{'value'}= tBool($enable_gui);
            unshift @write_fields, \%access_gui_field;

            $access_papi_field{'field'}='can_access_papi';
            $access_papi_field{'value'}= tBool($enable_api);
            unshift @write_fields, \%access_papi_field;

            $access_taxii_field{'field'}='can_access_taxii';
            $access_taxii_field{'value'}= tBool($enable_taxii);
            unshift @write_fields, \%access_taxii_field;

            next;
        }

        if (defined $_name_mappings{$current}) {
            $write_arg{'field'} = $_name_mappings{$current};
        }
        else {
            $write_arg{'field'} = $current;
        }

        if ($_object_to_ibap{$current}) {
            my @converted_values = $_object_to_ibap{$current}($self, $session,$current,$self);
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
            next;
        }
        else {
            next;
        }

        if (%write_arg) {
            push @write_fields, \%write_arg;
        }
    }

    return \@write_fields;
}

#
#
#

sub permission_list
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'permission_list', validator => { 'Infoblox::Grid::Admin::ViewAndZonePermission' => 1, 'Infoblox::Grid::Admin::NetworkPermission' => 1, 'Infoblox::Grid::Admin::GridMemberPermission' => 1, 'Infoblox::Grid::Admin::SharedRecordGroupPermission' => 1}}, @_);
}

sub lease_history_access
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'lease_history_access', validator => \&ibap_value_o2i_string}, @_);
}

sub disabled
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disabled', validator => \&ibap_value_o2i_boolean}, @_);
}

sub superuser
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'superuser', validator => \&ibap_value_o2i_boolean}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

#
sub tree_size
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return;
    }
    else
    {
        return 1;
    }
}

sub comment
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub access_method
{
    my $self  = shift;
    return $self->__accessor_array__({name => 'access_method', validator => \&ibap_value_o2i_string}, @_);
}

sub roles
{
    my $self  = shift;
    if( @_ == 0 )
    {
        return $self->{ 'roles' };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ 'roles' } = undef;
        }
        else
        {
            if (ref($value) eq 'ARRAY')
            {
                $self->{ 'roles' } = $value;
            }
            else
            {
                set_error_codes(1104, 'Invalid data type for member roles.');
            }
        }
    }
    return 1;
}


sub email_addresses
{
    my $self=shift;
    return $self->__accessor_array__({name => 'email_addresses', validator => \&ibap_value_o2i_string}, @_);
}

sub enable_restricted_user_access {

    my $self = shift;
    return $self->__accessor_scalar__({name => 'enable_restricted_user_access', validator => \&ibap_value_o2i_boolean}, @_);
}

sub user_access {

    my $self = shift;
    return $self->ibap_accessor_ac_setting('user_access', 0, {}, @_)
}


1;
