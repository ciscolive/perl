#
#

#
package Infoblox::DHCP;
package Infoblox::DNS;
package Infoblox::IPAM;


package Infoblox::DHCP::Filter::UserClass;

use Infoblox::Util;

sub new
{
    set_error_codes(1113, "Infoblox::DHCP::Filter::UserClass is obsoleted, please use Infoblox::DHCP::Filter::Option instead" );
    return;
}

package Infoblox::Grid::DHCP::Filter::MAC;

use Infoblox::Util;

sub new
{
    set_error_codes(1113, "Infoblox::Grid::DHCP::Filter::MAC is obsoleted, please use Infoblox::DHCP::Filter::MAC instead" );
    return;
}

package Infoblox::Grid::DHCP::Filter::RelayAgent;

use Infoblox::Util;

sub new
{
    set_error_codes(1113, "Infoblox::Grid::DHCP::Filter::RelayAgent is obsoleted, please use Infoblox::DHCP::Filter::RelayAgent instead" );
    return;
}

package Infoblox::Grid::DHCP::Filter::UserClass;

use Infoblox::Util;

sub new
{
    set_error_codes(1113, "Infoblox::Grid::DHCP::Filter::UserClass is obsoleted, please use Infoblox::DHCP::Filter::UserClass instead" );
    return;
}

package Infoblox::Grid::DHCP::FailOver;

use Infoblox::Util;

sub new
{
    set_error_codes(1113, "Infoblox::Grid::DHCP::FailOver is obsoleted, please use Infoblox::DHCP::FailOver instead" );
    return;
}

package Infoblox::Internal::Restart;

sub new
{
    set_error_codes(1113, "Infoblox::Internal::Restart is unsupported" );
    return;
}

package Infoblox::Internal::AdDomain;

sub new
{
    set_error_codes(1113, "Infoblox::Internal::AdDomain is unsupported" );
    return;
}

package Infoblox::Internal::DHCP_remove_expert_mode_config;

sub new
{
    set_error_codes(1113, "Infoblox::Internal::DHCP_remove_expert_mode_config is unsupported" );
    return;
}

package Infoblox::Internal::Export_data;

sub new
{
    set_error_codes(1113, "Infoblox::Internal::Export_data is unsupported" );
    return;
}

package Infoblox::Internal::EAPCACert;

sub new
{
    set_error_codes(1113, "Infoblox::Internal::EAPCACert is unsupported" );
    return;
}

package Infoblox::Internal::TFTP_file;

sub new
{
    set_error_codes(1113, "Infoblox::Internal::TFTP_file is unsupported" );
    return;
}

package Infoblox::Internal::JoinGrid;

sub new
{
    set_error_codes(1113, "Infoblox::Internal::JoinGrid is unsupported" );
    return;
}

package Infoblox::Internal::EAPCert;

sub new
{
    set_error_codes(1113, "Infoblox::Internal::EAPCert is unsupported" );
    return;
}
package Infoblox::Internal::Recycle_bin;

sub new
{
    set_error_codes(1113, "Infoblox::Internal::Recycle_bin is unsupported" );
    return;
}

package Infoblox::Internal::Import_data;

sub new
{
    set_error_codes(1113, "Infoblox::Internal::Import_data is unsupported" );
    return;
}

package Infoblox::Internal::Remove_data;

sub new
{
    set_error_codes(1113, "Infoblox::Internal::Remove_data is unsupported" );
    return;
}
package Infoblox::Internal::EAPCSR;

sub new
{
    set_error_codes(1113, "Infoblox::Internal::EAPCSR is unsupported" );
    return;
}

package Infoblox::Grid::Member::RADIUS;

sub new
{
    set_error_codes(1113, "Infoblox::Grid::Member::RADIUS is unsupported" );
    return;
}

package Infoblox::Grid::License::Revoke::Params;

sub new
{
    set_error_codes(1113, "Infoblox::Grid::License::Revoke::Params is unsupported" );
    return;
}

1;
