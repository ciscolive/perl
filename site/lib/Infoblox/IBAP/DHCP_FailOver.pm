package Infoblox::DHCP::FailOver;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object $_return_fields_initialized %_return_field_overrides %_capabilities);
@ISA = qw(Infoblox::IBAPBase);

BEGIN 
{    
    $_object_type = 'DhcpFailoverAssoc';
    register_wsdl_type('ib:DhcpFailoverAssoc','Infoblox::DHCP::FailOver');

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
        name                    => 1,
        primary                 => 0, # see new()
        secondary               => 0,
        comment                 => 0,
        extattrs                => 0,
        extensible_attributes   => 0,
        load_balance_split      => 0,
        max_load_balance_delay  => 0,
        max_client_lead_time    => 0,
        max_unacked_updates     => 0,
        max_response_delay      => 0,
        recycle_leases          => 0,
        ms_server                     => 0,
        association_type              => -1,
        ms_association_mode           => -1,
        ms_failover_partner           => 0,
        ms_is_conflict                => -1,
        ms_failover_mode              => 0,
        ms_hotstandby_partner_role    => 0,
        ms_state                      => -1,
        ms_previous_state             => -1,
        ms_enable_switchover_interval => 0,
        ms_switchover_interval        => 0,
        ms_enable_authentication      => 0,
        ms_shared_secret              => 0,
    );

     %_name_mappings = (
        'extattrs'              => 'extensible_attributes',
        'primary'               => 'primary_server_type',
        'secondary'             => 'secondary_server_type', 
        'max_client_lead_time'  => 'mclt',
        'ms_failover_partner'   => 'ms_failover_partner_ref',
        'ms_hotstandby_partner_role'  => 'ms_hotstandy_partner_role',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    $_return_fields_initialized=0;
    @_return_fields = (
        tField('name'),
        tField('comment'),
        tField('primary_server_type'),
        tField('external_primary'),
        tField('secondary_server_type'),
        tField('external_secondary'),
        tField('max_response_delay'),
        tField('max_unacked_updates'),
        tField('mclt'),
        tField('max_load_balance_delay'),
        tField('load_balance_split'),
        tField('use_recycle_leases'),
        tField('recycle_leases'),
        tField('primary_state'),
        tField('secondary_state'),
        tField('association_type'),
        tField('ms_association_mode'),
        tField('ms_is_conflict'),
        tField('ms_failover_mode'),
        tField('ms_hotstandy_partner_role'),
        tField('ms_state'),
        tField('ms_previous_state'),
        tField('ms_enable_switchover_interval'),
        tField('ms_switchover_interval'),
        tField('ms_enable_authentication'),
    );

    push @_return_fields, (
                            tField('grid_primary', return_fields_member_basic_data()),
                            tField('grid_secondary', return_fields_member_basic_data()),
                            return_fields_extensible_attributes(),
                          );

    %_return_field_overrides = (
        name                    => [],
        primary                 => [ 'grid_primary', 'external_primary' ],
        secondary               => [ 'grid_secondary', 'external_secondary' ],
        comment                 => [],
        extattrs                => [],
        extensible_attributes   => [],
        load_balance_split      => [],
        max_load_balance_delay  => [],
        max_client_lead_time    => [],
        max_unacked_updates     => [],
        max_response_delay      => [],
        recycle_leases          => [ 'use_recycle_leases' ],
        primary_state           => [],
        secondary_state         => [], 
        ms_server                     => [],
        association_type              => [],
        ms_association_mode           => [],
        ms_failover_partner           => [],
        ms_is_conflict                => [],
        ms_failover_mode              => [],
        ms_hotstandby_partner_role    => [],
        ms_state                      => [],
        ms_previous_state             => [],
        ms_enable_switchover_interval => ['ms_enable_switchover_interval'],
        ms_switchover_interval        => [],
        ms_enable_authentication      => [],
        ms_shared_secret              => [],
    );

    %_ibap_to_object = (
        extensible_attributes   => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
        primary_server_type     => \&__i2o_grid_primary__,
        secondary_server_type   => \&__i2o_grid_secondary__,
        recycle_leases          => \&ibap_i2o_boolean,
        use_recycle_leases      => \&ibap_i2o_boolean,
        primary_state           => \&ibap_i2o_enums_lc_or_undef,
        secondary_state         => \&ibap_i2o_enums_lc_or_undef,
        ms_server                     => \&ibap_i2o_generic_object_convert,
        ms_failover_partner_ref       => \&ibap_i2o_generic_object_convert,
        ms_is_conflict                => \&ibap_i2o_boolean,
        ms_enable_switchover_interval => \&ibap_i2o_boolean,
        ms_enable_authentication      => \&ibap_i2o_boolean,
    );

    %_object_to_ibap = (
        name                    => \&ibap_o2i_string,
        extattrs                => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
        extensible_attributes   => \&ibap_o2i_ignore,
        primary                 => \&__o2i_server_type__,
        secondary               => \&__o2i_server_type__,
        comment                 => \&ibap_o2i_string,
        load_balance_split      => \&ibap_o2i_uint,
        max_load_balance_delay  => \&ibap_o2i_uint,
        max_client_lead_time    => \&ibap_o2i_uint,
        max_unacked_updates     => \&ibap_o2i_uint,
        max_response_delay      => \&ibap_o2i_uint,
        recycle_leases          => \&ibap_o2i_boolean, 
        use_recycle_leases      => \&ibap_o2i_boolean,
        primary_state           => \&ibap_o2i_ignore, # RO field
        secondary_state         => \&ibap_o2i_ignore, # RO field
        ms_server                     => \&ibap_o2i_object_only_by_oid,
        association_type              => \&ibap_o2i_ignore, # RO field
        ms_association_mode           => \&ibap_o2i_ignore, # RO field
        ms_failover_partner           => \&ibap_o2i_object_only_by_oid,
        ms_is_conflict                => \&ibap_o2i_ignore, # RO field
        ms_failover_mode              => \&ibap_o2i_string,
        ms_hotstandby_partner_role    => \&ibap_o2i_string,
        ms_state                      => \&ibap_o2i_ignore, # RO field
        ms_previous_state             => \&ibap_o2i_ignore, # RO field
        ms_enable_switchover_interval => \&ibap_o2i_boolean,
        ms_switchover_interval        => \&ibap_o2i_uint,
        ms_enable_authentication      => \&ibap_o2i_boolean,
        ms_shared_secret              => \&ibap_o2i_string,
    );

    %_searchable_fields = (
        name => [\&ibap_o2i_string, 'name', 'REGEX'],
        comment => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE' ],
        extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
        extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
    );
}

#
#
#

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    #
    #
    if (defined $args{'primary'} and defined $args{'secondary'}) {
        if (defined $args{'ms_server'} or defined $args{'ms_failover_partner'}) {
            return set_error_codes(1105, 'Cannot define a Microsoft and Grid failover association at the same time.');
        }
    } elsif (defined $args{'ms_server'} and defined $args{'ms_failover_partner'}) {
        if (defined $args{'primary'} or defined $args{'secondary'}) {
            return set_error_codes(1105, 'Cannot define a Microsoft and Grid failover association at the same time.');
        }
    } else {
        return set_error_codes(1105, 'One set of primary/secondary or ms_server/ms_failover_partner must be set');
    }

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

sub __init_instance_constants__ {
    my $self = shift;

    unless ($_return_fields_initialized) {
        $_return_fields_initialized=1;

        #
        my $t = Infoblox::Grid::MSServer->__new__();

        push @_return_fields,
            tField('ms_server', {sub_fields => $t->__return_fields__()});
        push @_return_fields,
          tField('ms_failover_partner_ref', {sub_fields => $t->__return_fields__()});
    }
}

#
#
#

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $ibap_object_ref->{'use_recycle_leases'}    = 0 unless defined $ibap_object_ref->{'use_recycle_leases'};
    $ibap_object_ref->{'recycle_leases'}        = 0 unless defined $ibap_object_ref->{'recycle_leases'};
    $ibap_object_ref->{'ms_is_conflict'}        = 0 unless defined $ibap_object_ref->{'ms_is_conflict'};
    $ibap_object_ref->{'ms_enable_switchover_interval'} = 0 unless defined $ibap_object_ref->{'ms_enable_switchover_interval'};
    $ibap_object_ref->{'ms_enable_authentication'}      = 0 unless defined $ibap_object_ref->{'ms_enable_authentication'};

    my $res = $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    $self->{'use_recycle_leases'} = $ibap_object_ref->{'use_recycle_leases'};
    delete $self->{'recycle_leases'} unless $self->{'use_recycle_leases'};

    #
    $self->{'ms_enable_switchover_interval'}=ibap_value_i2o_boolean($$ibap_object_ref{'ms_enable_switchover_interval'});

    return $res;
}

sub __object_to_ibap__
{
    my ($self, $server, $session, $skipref) = @_;
    
    my $write_fields_ref = $self->SUPER::__object_to_ibap__($server, $session, $skipref);

    if (defined $self->{'primary'}) {
        my %write_arg_primary;

        if (ref($self->{'primary'}) eq 'Infoblox::DHCP::Member') {
            $write_arg_primary{'field'} = 'grid_primary';
            $write_arg_primary{'value'} = ibap_value_o2i_member_nocache($self->{'primary'},$session,'primary',1);
        } else {
            $write_arg_primary{'field'} = 'external_primary';
            $write_arg_primary{'value'} = ibap_value_o2i_ipv4addr($self->{'primary'});
        }
        push @{$write_fields_ref}, \%write_arg_primary;
    }
    else {
        push @{$write_fields_ref}, {
            field => 'grid_primary',
            value => undef,
        };

        push @{$write_fields_ref}, {
            field => 'external_primary',
            value => undef,
        };
    }

    if (defined $self->{'secondary'}) {
        my %write_arg_secondary;

        if (ref($self->{'secondary'}) eq 'Infoblox::DHCP::Member') {
            $write_arg_secondary{'field'} = 'grid_secondary';
            $write_arg_secondary{'value'} = ibap_value_o2i_member_nocache($self->{'secondary'},$session,'secondary',1);
        } else {
            $write_arg_secondary{'field'} = 'external_secondary';
            $write_arg_secondary{'value'} = ibap_value_o2i_ipv4addr($self->{'secondary'});
        }
        push @{$write_fields_ref}, \%write_arg_secondary;
    }
    else {
        push @{$write_fields_ref}, {
            field => 'grid_secondary',
            value => undef,
        };

        push @{$write_fields_ref}, {
            field => 'external_secondary',
            value => undef,
        };
    }

    return $write_fields_ref;
}


#
#
#

sub __member_or_ipv4addr_convert__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref, $primary_or_secondary) = @_;

    if ($$ibap_object_ref{$current}) {
        my $primary_type = $$ibap_object_ref{$current};;        
        if ($primary_type eq 'GRID' && $$ibap_object_ref{'grid_'.$primary_or_secondary}) {
            my $t = $$ibap_object_ref{'grid_'.$primary_or_secondary};

            #
            return ibap_value_i2o_dhcpmember($t)
        } elsif ($primary_type eq 'EXTERNAL' && $$ibap_object_ref{'external_'.$primary_or_secondary}) {
            return $$ibap_object_ref{'external_'.$primary_or_secondary};
        }
    } 

    return;
}

sub __i2o_grid_primary__
{    
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return __member_or_ipv4addr_convert__($self, $session, $current, $ibap_object_ref, $return_object_cache_ref, 'primary');
}

sub __i2o_grid_secondary__
{    
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return __member_or_ipv4addr_convert__($self, $session, $current, $ibap_object_ref, $return_object_cache_ref, 'secondary');
}

#
#
#

sub __o2i_server_type__
{
    #
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    push @return_args, 1;
    if (not defined $tempref->{$current}) {
        push @return_args, 1;
        push @return_args, undef;
    } else { 
        push @return_args, 0;
        if (ref($tempref->{$current}) eq 'Infoblox::DHCP::Member') {
            push @return_args, tString('GRID');
        } else {
            push @return_args, tString('EXTERNAL');
        }
    }

    return @return_args;
}

#
#
#

sub name 
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub primary 
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'primary', validator => { 'Infoblox::DHCP::Member' => 1, 'string' => \&ibap_value_o2i_string }}, @_);
}

sub secondary 
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'secondary', validator => { 'Infoblox::DHCP::Member' => 1, 'string' => \&ibap_value_o2i_string }}, @_);
}

sub load_balance_split 
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'load_balance_split', validator => \&ibap_value_o2i_uint}, @_);
}

sub max_load_balance_delay 
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'max_load_balance_delay', validator => \&ibap_value_o2i_uint}, @_);
}

sub max_client_lead_time
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'max_client_lead_time', validator => \&ibap_value_o2i_uint}, @_);
}
 
sub max_unacked_updates
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'max_unacked_updates', validator => \&ibap_value_o2i_uint}, @_);
}

sub max_response_delay
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'max_response_delay', validator => \&ibap_value_o2i_uint}, @_);
}

sub primary_state
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'primary_state', enum =>
                                       [
                                        'unknown',
                                        'start',
                                        'normal',
                                        'communications_interrupted',
                                        'partner_down',
                                        'recover',
                                        'recover_wait',
                                        'recover_done',
                                        'resolution_interrupted',
                                        'potential_conflict',
                                        'conflict_done',
                                        'paused',
                                        'shutdown'
                                       ]},
                                      @_);
}

sub recycle_leases
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'recycle_leases', validator => \&ibap_value_o2i_boolean, use => \$self->{'use_recycle_leases'}}, @_);
}

sub secondary_state
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'secondary_state', enum =>
                                       [
                                        'unknown',
                                        'start',
                                        'normal',
                                        'communications_interrupted',
                                        'partner_down',
                                        'recover',
                                        'recover_wait',
                                        'recover_done',
                                        'resolution_interrupted',
                                        'potential_conflict',
                                        'conflict_done',
                                        'paused',
                                        'shutdown'
                                       ]},
        @_);
}

sub ms_server
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ms_server', validator => {'Infoblox::Grid::MSServer' => 1}}, @_);
}

sub association_type
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'association_type', readonly => 1}, @_);
}

sub ms_association_mode
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ms_association_mode', readonly => 1}, @_);
}

sub ms_failover_partner
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ms_failover_partner', validator => {'Infoblox::Grid::MSServer' => 1}}, @_);
}

sub ms_is_conflict
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ms_is_conflict', readonly => 1}, @_);
}

sub ms_failover_mode
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ms_failover_mode', enum => ['LOADBALANCE', 'HOTSTANDBY']}, @_);
}

sub ms_hotstandby_partner_role
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ms_hotstandby_partner_role', enum => ['ACTIVE', 'PASSIVE']}, @_);
}

sub ms_state
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ms_state', readonly => 1}, @_);
}

sub ms_previous_state
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ms_previous_state', readonly => 1}, @_);
}

sub ms_enable_switchover_interval
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ms_enable_switchover_interval', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ms_switchover_interval
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ms_switchover_interval', validator => \&ibap_value_o2i_uint, use => 'ms_enable_switchover_interval', use_truefalse => 1}, @_);
}

sub ms_enable_authentication
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ms_enable_authentication', validator => \&ibap_value_o2i_boolean}, @_);
}

sub ms_shared_secret
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'ms_shared_secret', validator => \&ibap_value_o2i_string}, @_);
}



1;
