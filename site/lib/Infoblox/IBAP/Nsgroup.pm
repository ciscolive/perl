package Infoblox::Grid::DNS::AllNsgroups;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(
            %_name_mappings
            %_reverse_name_mappings
            %_return_field_overrides
            %_capabilities
            @ISA
            $_object_type
            %_ibap_to_object
            %_searchable_fields
            %_allowed_members
            %_object_to_ibap
            %_ns_group_mapping
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase Infoblox::PAPIOverrides::RO );

BEGIN {

    $_object_type = 'AllNsGroup';
    register_wsdl_type('ib:AllNsGroup', 'Infoblox::Grid::DNS::AllNsgroups');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'comment' => {simple => 'asis', readonly => 1},
                         'name'    => {simple => 'asis', readonly => 1},
                         'type'    => {simple => 'asis', readonly => 1, enum => ['AUTH', 'FORWARDING_MEMBER',
                                       'STUB_MEMBER', 'DELEGATION', 'FORWARD_STUB_SERVER']},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_searchable_fields = (
                           'comment' => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'name'    => [\&ibap_o2i_string, 'group_name', 'REGEX'],
                           'type'    => [\&ibap_o2i_string, 'group_type', 'EXACT'],
    );

    %_name_mappings = (
                      'name' => 'group_name',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_object_to_ibap = (
                        'comment' => \&ibap_o2i_ignore,
                        'name'    => \&ibap_o2i_ignore,
                        'type'    => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('comment'),
                       tField('group_name'),
    );

    %_return_field_overrides = (
                                'comment' => [],
                                'name'    => [],
    );

    %_ns_group_mapping = (
        'ib:NsGroup'                  => 'AUTH',
        'ib:ForwardStubServerNsGroup' => 'FORWARD_STUB_SERVER',
        'ib:ForwardingMemberNsGroup'  => 'FORWARDING_MEMBER',
        'ib:StubMemberNsGroup'        => 'STUB_MEMBER',
        'ib:DelegationNsGroup'        => 'DELEGATION'
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

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    my $res = $self->SUPER::__ibap_to_object__(
        $ibap_object_ref, $server, $session,
        $return_object_cache_ref,
    );

    $$self{type} = $_ns_group_mapping{ref $ibap_object_ref};

    return $res;
}


package Infoblox::Grid::DNS::BaseNsgroup;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;


use vars qw(
            $_object_type
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_return_field_overrides
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    $_object_type = 'Base';

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
    );

    %_allowed_members = (
                         'comment'               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'name'                  => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'extattrs'              => {special => 'extensible_attributes'},
                         'extensible_attributes' => {special => 'extensible_attributes'},
    );

    %_searchable_fields = (
                           'comment'               => [\&ibap_o2i_string, 'comment', 'REGEX'],
                           'name'                  => [\&ibap_o2i_string, 'group_name', 'REGEX'],
                           'extattrs'              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
    );

    %_name_mappings = (
                       'name'     => 'group_name',
                       'extattrs' => 'extensible_attributes',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
    );

    %_object_to_ibap = (
                        'comment'               => \&ibap_o2i_string,
                        'name'                  => \&ibap_o2i_string,
                        'extattrs'              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes' => \&ibap_o2i_ignore,
    );

    @_return_fields = (
                       tField('comment'),
                       tField('group_name'),
                       return_fields_extensible_attributes(),
    );

    %_return_field_overrides = (
                                'comment'               => [],
                                'name'                  => [],
                                'extattrs'              => [],
                                'extensible_attributes' => [],
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

    {
        no strict 'refs';

        if (!$self->__initialize_members_from_arg_list__(\%{$class . '::_allowed_members'}, \%args) ||
            !$self->__validate_object_required_members__(\%{$class . '::_allowed_members'}))
        {
            return;
        }

        return $self;
    }
}

sub __ibap_object_type__ {

    my $self = shift;
    my $class = ref $self || $self;

    {
        no strict 'refs';
        return ${$class . '::_object_type'};
    }
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    my $class = ref $self || $self;

    {
        no strict 'refs';
        return ${$class . '::_capabilities'}{$what};
    }
}


package Infoblox::Grid::DNS::Nsgroup;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
            @ISA
            $_object_type
            %_allowed_members
            @_return_fields
            %_searchable_fields
            %_object_to_ibap
            %_name_mappings
            %_reverse_name_mappings
            %_ibap_to_object
            %_return_field_overrides
            %_capabilities
);

@ISA = qw( Infoblox::Grid::DNS::BaseNsgroup );

BEGIN {

    $_object_type = 'NsGroup';
    register_wsdl_type('ib:NsGroup','Infoblox::Grid::DNS::Nsgroup');

    %_capabilities = ();

    %_allowed_members = (
                         'primary'            => 0,
                         'multiple_primaries' => 0,
                         'is_multimaster'     => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'secondaries'        => {array => 1, validator => {'Infoblox::DNS::Member' => 1, 'Infoblox::DNS::Nameserver' => 1}},
                         'ms_ad_integrated'   => {deprecated => 1},
    );

    %_name_mappings = (
                       'secondaries' => 'grid_secondaries',
    );

    %_reverse_name_mappings = (
                               'external_secondaries' => 'secondaries',
                               'grid_secondaries'     => 'secondaries',
                               'ms_secondaries'       => 'secondaries',
                               'grid_primaries'       => 'multiple_primaries',
                               'external_primaries'   => 'multiple_primaries',
                               'ms_primaries'         => 'multiple_primaries',
    );

    %_searchable_fields = ();

    @_return_fields = (
                       tField('use_external_primary'),
                       tField('external_primaries'),
                       tField('external_secondaries'),
                       tField('is_multimaster'),
                       tField('is_grid_default'),
                       tField('grid_primaries', {
                           not_exist_ok => 1,
                           no_access_ok => 1,
                           sub_fields   => [
                               tField('lead'),
                               tField('grid_replicate'),
                               tField('stealth'),
                               tField('grid_member', return_fields_member_basic_data_no_access_ok()),
                               tField('shared_with_ms_parent_delegation', {not_exist_ok => 1}),
                           ],
                       }),
                       tField('grid_secondaries', {
                           not_exist_ok => 1,
                           no_access_ok => 1,
                           sub_fields   => [
                               tField('lead'),
                               tField('grid_replicate'),
                               tField('stealth'),
                               tField('grid_member', return_fields_member_basic_data_no_access_ok()),
                               tField('shared_with_ms_parent_delegation', {not_exist_ok => 1}),
                           ],
                       }),
    );

    %_return_field_overrides = (
                                'primary'            => [],
                                'multiple_primaries' => ['use_external_primary'],
                                'is_multimaster'     => [],
                                'secondaries'        => ['external_secondaries'],
    );

    %_ibap_to_object = (
                        'grid_primaries'        => \&ibap_i2o_member_nameserver,
                        'external_primaries'    => \&ibap_i2o_nameserver,
                        'external_secondaries'  => \&ibap_i2o_nameserver,
                        'grid_secondaries'      => \&ibap_i2o_member_nameserver,
                        'is_grid_default'       => \&ibap_i2o_boolean,
                        'ms_primaries'          => \&ibap_i2o_dns_msserver_list,
                        'ms_secondaries'        => \&ibap_i2o_dns_msserver_list,
    );

    %_object_to_ibap = (
                        'primary'                 => \&ibap_o2i_ignore,
                        'multiple_primaries'      => \&__o2i_primary_servers__,
                        'use_multiple_primaries'  => \&ibap_o2i_ignore,
                        'ms_ad_integrated'        => \&ibap_o2i_ignore,
                        'secondaries'             => \&__o2i_secondary_servers__,
                        'use_external_primary'    => \&ibap_o2i_boolean,
                        'is_grid_default'         => \&ibap_o2i_boolean,
                        'is_multimaster'          => \&ibap_o2i_boolean,
    );

    Infoblox::IBAPBase::subclass('Infoblox::Grid::DNS::BaseNsgroup', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (defined $args{'primary'} and defined $args{'multiple_primaries'}) {
        set_error_codes(1105, 'Cannot define primary and multiple_primaries at the same time.');
        return;
    }

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    return $self;
}


sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'ms_ad_integrated'} = 0 unless defined $$ibap_object_ref{'ms_ad_integrated'};
    $$ibap_object_ref{'is_multimaster'}   = 0 unless defined $$ibap_object_ref{'is_multimaster'};

    $self->secondaries(undef);
    $self->primary(undef);

    my %skipref;
    $skipref{'grid_primaries'} = 1 if $$ibap_object_ref{'use_external_primary'};
    $skipref{'ms_primaries'}   = 1 if $$ibap_object_ref{'use_external_primary'};

    my $t = $self->SUPER::__ibap_to_object__(
        $ibap_object_ref, $server, $session,
        $return_object_cache_ref, \%skipref
    );

    #
    my @newlist;
    my $xt = $self->secondaries();

    my (@middle, @post);
    foreach (@$xt) {
        if (ref($_) eq 'Infoblox::DNS::Member') {
            push @newlist, $_;
        } elsif (ref($_) eq 'Infoblox::DNS::MSServer') {
            push @middle, $_;
        }
        else {
            push @post, $_;
        }
    }

    push @newlist, @middle if @middle;
    push @newlist, @post if @post;
    $self->secondaries(\@newlist);

    return $t;
}


#

sub __o2i_primary_servers__ {

    my ($self, $session, $current, $tempref) = @_;

    #
    my @return_args = (1, 1, undef);

    my %extra_ms_primaries = (
        'field' => 'ms_primaries',
        'value' => tIBType('ArrayOfms_dns_server', []),
    );

    push @return_args, \%extra_ms_primaries;

    my %extra_grid_primaries = (
        'field' => 'grid_primaries',
        'value' => tIBType('ArrayOfmember_server', []),
    );

    push @return_args, \%extra_grid_primaries;

    my %extra_external_primaries = (
        'field' => 'external_primaries',
        'value' => tIBType('ArrayOfext_server', []),
    );

    push @return_args, \%extra_external_primaries;

    if (ref $$tempref{$current} eq 'ARRAY') {

        my @nodes_list = @{$$tempref{$current}};
        my @newlist;

        if (ref($nodes_list[0]) eq 'Infoblox::DNS::Member') {

            foreach my $member (@{$$self{'multiple_primaries'}}) {
                push @newlist, ibap_value_o2i_member_server(
                    $member, $session, $self, 'member_server');
            }

            $extra_grid_primaries{'value'} = tIBType('ArrayOfmember_server', \@newlist);

        } elsif (@nodes_list && ref $nodes_list[0] eq 'Infoblox::DNS::MSServer') {

            foreach my $member (@nodes_list) {
                push @newlist, ibap_value_o2i_dns_msserver_convert(
                    $member, $session, $self, 'ms_dns_server');
            }

            $extra_ms_primaries{'value'} = tIBType('ArrayOfms_dns_server', \@newlist);

        } else {

            foreach my $member (@nodes_list) {
                push @newlist, ibap_value_o2i_ext_server(
                    $member, 'external_primaries', $session);
            }

            $extra_external_primaries{'value'} = tIBType('ArrayOfext_server', \@newlist);
        }
    }

    return @return_args;
}

sub __o2i_secondary_servers__ {

    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if($$tempref{$current}) {

        my @nodes_list = @{$$tempref{$current}};
        my @int_list;
        my @ext_list;
        my @mss_list;

        foreach my $member (@nodes_list) {

            if (ref $member eq 'Infoblox::DNS::Nameserver') {

                push @ext_list, ibap_value_o2i_ext_server(
                    $member, 'external_secondaries', $session);

            } elsif (ref $member eq 'Infoblox::DNS::Member') {

                push @int_list, ibap_value_o2i_member_server(
                    $member, $session, $self, $current);

            } elsif (ref $member eq 'Infoblox::DNS::MSServer') {

                push @mss_list, ibap_value_o2i_dns_msserver_convert(
                    $member, $session, $self, 'ms_dns_server');
            }
        }

        return (1, 0,
            tIBType('ArrayOfmember_server', \@int_list),
            {'field' => 'external_secondaries', 'value' => tIBType('ArrayOfext_server', \@ext_list)},
            {'field' => 'ms_secondaries', 'value' => tIBType('ArrayOfms_dns_server', \@mss_list)},
        );

    } else {
        return (1, 1, undef);
    }
}

#
sub primary {

    my $self  = shift;

    if (@_) {
        if (defined $_[0]) {
            if (ref($_[0]) eq 'Infoblox::DNS::Member') {
                return $self->multiple_primaries([$_[0]]);
            } else {
                return $self->multiple_primaries($_[0]);
            }
        } else {
            return $self->multiple_primaries([]);
        }
    } else {
        my $res = $self->multiple_primaries();
        if ($res and @$res and ref($res->[0]) eq 'Infoblox::DNS::Member') {
            return $res->[0];
        } else {
            return $res;
        }
    }
}

sub multiple_primaries
{
    my $self = shift;

    #
    my $res = $self->__accessor_array__({name => 'multiple_primaries', nomixed => 1,
        validator => {'Infoblox::DNS::Member' => 1, 'Infoblox::DNS::Nameserver' => 1}}, @_);

    if (@_ and $res) {
        if ($self->{'multiple_primaries'} and @{$self->{'multiple_primaries'}} and
            ref($self->{'multiple_primaries'}->[0]) eq 'Infoblox::DNS::Nameserver')
        {
            $self->{'use_external_primary'} = 1;
        } else {
            $self->{'use_external_primary'} = 0;
        }
    }

    return $res;
}


package Infoblox::Grid::DNS::Nsgroup::ForwardStubServer;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;


use vars qw(
            $_object_type
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_return_field_overrides
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::Grid::DNS::BaseNsgroup );

BEGIN {

    $_object_type = 'ForwardStubServerNsGroup';
    register_wsdl_type('ib:ForwardStubServerNsGroup', 'Infoblox::Grid::DNS::Nsgroup::ForwardStubServer');

    %_capabilities = ();

    %_allowed_members = (
                         'external_servers' => {mandatory => 1, array => 1, validator => {'Infoblox::DNS::Nameserver' => 1}},
    );


    %_searchable_fields = ();
    %_name_mappings = ();
    %_reverse_name_mappings = ();

    %_ibap_to_object = (
                        'external_servers' => \&ibap_i2o_nameserver,
    );

    %_object_to_ibap = (
                        'external_servers' => \&__o2i_nameservers__,
    );

    @_return_fields = (
                       tField('external_servers', {
                           sub_fields => [
                               tField('name'),
                               tField('address'),
                           ],
                       }),
    );

    %_return_field_overrides = (
                                'external_servers' => [],
    );

    Infoblox::IBAPBase::subclass('Infoblox::Grid::DNS::BaseNsgroup', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}

sub __o2i_nameservers__ {

    my ($self, $session, $current, $tempref) = @_;

    if ($$tempref{$current} and scalar @{$$tempref{$current}}) {

        my @ext_servers = @{$$self{$current}};
        my @res;

        foreach my $srv (@ext_servers) {
            push @res, ibap_value_o2i_ext_server($srv,
                'external_servers', $session);
        }

        return (1, 0, tIBType('ArrayOfext_server', \@res));
    }

    return (1, 0, tIBType('ArrayOfext_server', []));
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$self{'external_servers'} = [];

    return $self->SUPER::__ibap_to_object__(
        $ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::DNS::Nsgroup::ForwardingMember;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;


use vars qw(
            $_object_type
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_return_field_overrides
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::Grid::DNS::BaseNsgroup );

BEGIN {

    $_object_type = 'ForwardingMemberNsGroup';
    register_wsdl_type('ib:ForwardingMemberNsGroup', 'Infoblox::Grid::DNS::Nsgroup::ForwardingMember');

    %_capabilities = ();

    %_allowed_members = (
                         'forwarding_servers' => {mandatory => 1, array => 1, validator => {'Infoblox::DNS::Member' => 1}},
    );

    %_searchable_fields = ();
    %_name_mappings = ();
    %_reverse_name_mappings = ();

    %_ibap_to_object = (
                        'forwarding_servers' => \&ibap_i2o_forwarding_servers,
    );

    %_object_to_ibap = (
                        'forwarding_servers' => \&ibap_o2i_forwarding_servers,
    );

    @_return_fields = (
                       tField('forwarding_servers', {
                            sub_fields => [
                                tField('grid_member', return_fields_member_basic_data()),
                                tField('forward_to', {
                                    sub_fields => [
                                        tField('name'),
                                        tField('address'),
                                    ],
                                }),
                                tField('forwarders_only'),
                                tField('use_override_forwarders'),
                            ],
                        }),
    );

    %_return_field_overrides = (
                                'forwarding_servers' => [],
    );

    Infoblox::IBAPBase::subclass('Infoblox::Grid::DNS::BaseNsgroup', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$self{'forwarding_servers'} = [];

    return $self->SUPER::__ibap_to_object__(
        $ibap_object_ref, $server, $session, $return_object_cache_ref);
}


package Infoblox::Grid::DNS::Nsgroup::StubMember;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;


use vars qw(
            $_object_type
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_return_field_overrides
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::Grid::DNS::BaseNsgroup );

BEGIN {

    $_object_type = 'StubMemberNsGroup';
    register_wsdl_type('ib:StubMemberNsGroup', 'Infoblox::Grid::DNS::Nsgroup::StubMember');

    %_capabilities = ();

    %_allowed_members = (
                         'stub_members' => {mandatory => 1, array => 1, validator => \&ibap_value_o2i_string},
    );

    %_searchable_fields = ();
    %_name_mappings = ();
    %_reverse_name_mappings = ();

    %_ibap_to_object = (
                        'stub_members' => \&__i2o_stub_members__,
    );

    %_object_to_ibap = (
                        'stub_members' => \&__o2i_stub_members__,
    );

    @_return_fields = (
                       tField('stub_members', {
                            sub_fields => [
                                tField('grid_member', return_fields_member_basic_data()),
                            ],
                       }),
    );

    %_return_field_overrides = (
                                'stub_members' => [],
    );

    Infoblox::IBAPBase::subclass('Infoblox::Grid::DNS::BaseNsgroup', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$self{'stub_members'} = [];

    return $self->SUPER::__ibap_to_object__(
        $ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __o2i_stub_members__ {

    my ($self, $session, $current, $tempref) = @_;

    my (@res, %struct);
    if (ref $$tempref{$current} eq 'ARRAY') {
        foreach my $member (@{$$tempref{$current}}) {

            my $write_member = ibap_readfield_simple_string('Member', 'host_name', $member, 'grid_member');
            push @res, tIBType('member_server', {'grid_member' => $$write_member{'val'}});
        }
    }

    return (1, 0, tIBType('ArrayOfmember_server', \@res));
}

sub __i2o_stub_members__ {

    my ($self, $session, $current, $ibap_object_ref) = @_;

    my @res;
    if (ref $$ibap_object_ref{$current} eq 'ARRAY') {
        foreach my $member (@{$$ibap_object_ref{$current}}) {
            push @res, $$member{'grid_member'}{'host_name'}
                if ref $member eq 'ib:member_server' and $$member{'grid_member'};
        }
    }

    return \@res;
}


package Infoblox::Grid::DNS::Nsgroup::DelegationMember;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;


use vars qw(
            $_object_type
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_return_field_overrides
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            @_return_fields
);

@ISA = qw( Infoblox::Grid::DNS::BaseNsgroup );

BEGIN {

    $_object_type = 'DelegationNsGroup';
    register_wsdl_type('ib:DelegationNsGroup', 'Infoblox::Grid::DNS::Nsgroup::DelegationMember');

    %_capabilities = ();

    %_allowed_members = (
                         'delegation_servers' => {mandatory => 1, array => 1, validator => {'Infoblox::DNS::Nameserver' => 1}},
    );


    %_searchable_fields = ();

    %_name_mappings = (
                       'delegation_servers' => 'delegate_to',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'delegate_to' => \&ibap_i2o_nameserver,
    );

    %_object_to_ibap = (
                        'delegation_servers' => \&__o2i_delegationservers__,
    );

    @_return_fields = (
                       tField('delegate_to', {
                           sub_fields => [
                               tField('name'),
                               tField('address'),
                           ],
                       }),
    );

    %_return_field_overrides = (
                                'delegation_servers' => [],
    );

    Infoblox::IBAPBase::subclass('Infoblox::Grid::DNS::BaseNsgroup', $_object_type);
    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
}

sub __o2i_delegationservers__ {

    my ($self, $session, $current, $tempref) = @_;

    if ($$tempref{$current} and scalar @{$$tempref{$current}}) {

        my @ext_servers = @{$$self{$current}};
        my @res;

        foreach my $srv (@ext_servers) {
            push @res, ibap_value_o2i_ext_server($srv,
                'delegate_to', $session);
        }

        return (1, 0, tIBType('ArrayOfext_server', \@res));
    }

    return (1, 0, tIBType('ArrayOfext_server', []));
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$self{'delegation_servers'} = [];

    return $self->SUPER::__ibap_to_object__(
        $ibap_object_ref, $server, $session, $return_object_cache_ref);
}



1;
