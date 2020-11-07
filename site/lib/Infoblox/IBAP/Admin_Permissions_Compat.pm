package Infoblox::Grid::Admin::NetworkPermission;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::PAPIOverrides;
use vars qw( @ISA %_allowed_members );
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    %_allowed_members = (
                         priority  => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         access    => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         operation => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         network   => {simple => 'asis', validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
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

package Infoblox::Grid::Admin::ViewAndZonePermission;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::PAPIOverrides;
use vars qw( @ISA %_allowed_members );
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    %_allowed_members = (
                         priority            => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         access               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         operation           => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         zone                => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         view                => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         rr_type_permissions => {validator => { 'Infoblox::Grid::Admin::ZoneRrTypePermissions' => 1}},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
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

package Infoblox::Grid::Admin::GridMemberPermission;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::PAPIOverrides;
use vars qw( @ISA %_allowed_members );
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    %_allowed_members = (
                         name      => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         priority  => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         access    => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         operation => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         ipv4Addr  => {simple => 'asis', validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
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

package Infoblox::Grid::Admin::ZoneRrTypePermissions;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::PAPIOverrides;
use vars qw( @ISA %_allowed_members );
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    %_allowed_members = (
                         txt_permission       => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         srv_permission       => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         ptr_permission       => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         ns_permission        => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         mx_permission        => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         dname_permission     => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         cname_permission     => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         aaaa_permission       => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         a_permission         => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         bulk_host_permission => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         host_permission       => {simple => 'asis', validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
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

package Infoblox::Grid::Admin::SharedRecordGroupPermission;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::PAPIOverrides;
use vars qw( @ISA %_allowed_members );
@ISA = qw(Infoblox::IBAPBase Infoblox::PAPIOverrides::ALL );

BEGIN
{
    %_allowed_members = (
                         access     => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         operation  => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         group_name => {simple => 'asis', validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);
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


1;

