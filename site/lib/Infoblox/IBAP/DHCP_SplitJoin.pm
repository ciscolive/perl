package Infoblox::DHCP::SplitJoinBase;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members %_object_to_ibap %_capabilities %_name_mappings);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'NotUsable';

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                      'single_serialization' => 0,
                     );
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


sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

#
#
#
#

#
#
#
sub __o2i_network__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
        my $network= $$tempref{$current};
        if ((ref($$tempref{$current}) && ref($$tempref{$current}) eq 'Infoblox::DHCP::Network') || 
            (ref($$tempref{$current}) && ref($$tempref{$current}) eq 'Infoblox::DHCP::IPv6Network') ||
              ! defined $self->network_view()) {
            if(ref($network) eq 'Infoblox::DHCP::IPv6Network' || ( !ref($network) && is_ipv6_network($network))){
                return ibap_o2i_ipv6_network($self, $session, $current, $tempref);
            }else{
                return ibap_o2i_network($self, $session, $current, $tempref);
            }
        }
        else 
        {
            my $object=is_ipv6_network($$tempref{$current})?"Infoblox::DHCP::IPv6Network":"Infoblox::DHCP::Network";
                                

            my $network = $object->new(
              network => $$tempref{$current},
              network_view => $self->network_view(),
                                      );
            my %temp = (
                        network => $network,
                       );

            if(ref($network) eq 'Infoblox::DHCP::IPv6Network'){
                return ibap_o2i_ipv6_network($self, $session, $current, \%temp);
            }else{
                return ibap_o2i_network($self, $session, $current, \%temp);
            }
        }
    }
    else {
        push @return_args, 1;
        push @return_args, 0;
        push @return_args, undef;
    }

    return @return_args;
}

sub __func_call__
{
    return ibap_func_call_handler(@_);
}

#
#
#

sub network
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'network', validator => { 'string' => \&ibap_value_o2i_string, 'Infoblox::DHCP::Network' => 1, 'Infoblox::DHCP::IPv6Network' => 1 }}, @_);
}

sub network_view
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'network_view', validator => { 'Infoblox::DHCP::View' => 1 }}, @_);
}

sub auto_create_reversezone
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'auto_create_reversezone', validator => \&ibap_value_o2i_boolean}, @_);
}

sub prefix
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'prefix', validator => \&ibap_value_o2i_uint}, @_);
}

package Infoblox::DHCP::SplitNetwork;

use strict;

use Carp;
use Infoblox::Util;

use vars qw( @ISA $_object_type %_allowed_members %_object_to_ibap %_name_mappings %_capabilities);
@ISA = qw (Infoblox::DHCP::SplitJoinBase);

BEGIN {
    $_object_type = 'SplitNetwork';

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                      'single_serialization' => 0,
                     );

    %_allowed_members = (
                         network                 => 1,
                         auto_create_reversezone => 0,
                         add_all_subnetworks     => 0,
                         prefix                  => 1,
                         prefix_collector_ipv6_network_addr => 0,
                         network_view            => 0,
                        );

    %_object_to_ibap =
      (
       'auto_create_reversezone'         => \&ibap_o2i_boolean,
       'add_all_subnetworks'             => \&ibap_o2i_boolean,
       'prefix'                          => \&ibap_o2i_integer,
       'prefix_collector_ipv6_network_addr' => \&ibap_o2i_string,
       'network'                         => \&Infoblox::DHCP::SplitJoinBase::__o2i_network__,
       'network_view'                    => \&ibap_o2i_ignore,
      );

    %_name_mappings =
      (
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

sub __init_instance_constants__
{
    my $self = shift;

    #
    $self->auto_create_reversezone('false') unless defined $self->auto_create_reversezone();
    $self->add_all_subnetworks('false') unless defined $self->add_all_subnetworks();

}

sub __ibap_object_type__
{
    return $_object_type;
}

sub add_all_subnetworks
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'add_all_subnetworks', validator => \&ibap_value_o2i_boolean}, @_);
}

#
sub prefix_collector_ipv6_network_addr
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'prefix_collector_ipv6_network_addr', validator => \&ibap_value_o2i_ipv6addr}, @_);
}

package Infoblox::DHCP::ExpandNetwork;

use strict;

use Carp;
use Infoblox::Util;

use vars qw( @ISA $_object_type %_allowed_members %_object_to_ibap %_capabilities %_name_mappings);
@ISA = qw (Infoblox::DHCP::SplitJoinBase);

BEGIN {
    $_object_type = 'ExpandNetwork';

    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 0,
                      'single_serialization' => 0,
                     );

    %_allowed_members = (
                         network                 => 1,
                         auto_create_reversezone => 0,
                         prefix                  => 1,
                         network_view            => 0,
                         option_delete_ea        => 0,
                        );

    %_object_to_ibap =
      (
       'auto_create_reversezone'         => \&ibap_o2i_boolean,
       'prefix'                          => \&ibap_o2i_integer,
       'network'                         => \&Infoblox::DHCP::SplitJoinBase::__o2i_network__,
       'network_view'                    => \&ibap_o2i_ignore,
       'option_delete_ea'                => \&ibap_o2i_string,
      );

    %_name_mappings =
      (
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

sub __init_instance_constants__
{
    my $self = shift;

    #
    $self->auto_create_reversezone('false') unless defined $self->auto_create_reversezone();

}

sub __ibap_object_type__
{
    return $_object_type;
}

sub option_delete_ea
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'option_delete_ea', enum => ['RETAIN', 'REMOVE']}, @_);
}

1;
