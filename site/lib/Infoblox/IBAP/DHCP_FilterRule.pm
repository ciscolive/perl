#
#
#

package Infoblox::DHCP::FilterRule;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::PAPIOverrides;
use vars qw( @ISA %_allowed_members );
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL);

BEGIN 
{
    %_allowed_members = (
        filter_name => 1,
        permission  => 1,
    );
}

#
#
sub __get_class_methods_class__
{
    return 'Infoblox::DHCP::FilterRule';
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


#
#
#

sub filter_name
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'filter_name', validator => \&ibap_value_o2i_string}, @_);
}

sub permission
{
    my $self = shift;
    return $self->__accessor_scalar__({name => 'permission', validator => \&ibap_value_o2i_string}, @_);
}

#
#
#

package Infoblox::DHCP::FilterRule::MAC;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use vars qw( @ISA );
@ISA = qw(Infoblox::DHCP::FilterRule);

package Infoblox::DHCP::FilterRule::Option;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use vars qw( @ISA );
@ISA = qw(Infoblox::DHCP::FilterRule);

package Infoblox::DHCP::FilterRule::RelayAgent;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use vars qw( @ISA );
@ISA = qw(Infoblox::DHCP::FilterRule);

package Infoblox::DHCP::FilterRule::NAC;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use vars qw( @ISA %_allowed_members );
@ISA = qw(Infoblox::DHCP::FilterRule);

sub __init_instance_constants__
{
    my $self = shift;
}

package Infoblox::DHCP::FilterRule::Fingerprint;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use vars qw( @ISA );
@ISA = qw(Infoblox::DHCP::FilterRule);

1;
