package Infoblox::PAPIOverrides::ALL;

#

use strict;
use Infoblox::Util;

#
#
#

sub __add_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'add' not allowed for this object", $session);
    return;
}

sub __modify_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'modify' not allowed for this object", $session);
    return;
}

sub __get_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'get' not allowed for this object", $session);
    return;
}

sub __search_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'search' not allowed for this object", $session);
    return;
}

sub __remove_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'remove' not allowed for this object", $session);
    return;
}

package Infoblox::PAPIOverrides::ADD_REMOVE;

#

use strict;
use Infoblox::Util;

#
#
#

sub __add_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'add' not allowed for this object", $session);
    return;
}

sub __remove_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'remove' not allowed for this object", $session);
    return;
}

package Infoblox::PAPIOverrides::SEARCH_ONLY;

#

use strict;
use Infoblox::Util;

sub __add_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'add' not allowed for this object", $session);
    return;
}

sub __modify_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'modify' not allowed for this object", $session);
    return;
}

sub __remove_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'remove' not allowed for this object", $session);
    return;
}

sub __get_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'get' not allowed for this object", $session);
    return;
}


package Infoblox::PAPIOverrides::GET_ONLY;

#

use strict;
use Infoblox::Util;

#
#
#

sub __add_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'add' not allowed for this object", $session);
    return;
}

sub __modify_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'modify' not allowed for this object", $session);
    return;
}

sub __remove_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'remove' not allowed for this object", $session);
    return;
}

sub __search_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'search' not allowed for this object", $session);
    return;
}


package Infoblox::PAPIOverrides::ADD_ONLY;

#

use strict;
use Infoblox::Util;

#
#
#

sub __modify_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'modify' not allowed for this object", $session);
    return;
}

sub __remove_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'remove' not allowed for this object", $session);
    return;
}

sub __search_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'search' not allowed for this object", $session);
    return;
}

sub __get_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'get' not allowed for this object", $session);
    return;
}


package Infoblox::PAPIOverrides::RO;

#

use strict;
use Infoblox::Util;

#
#
#

sub __add_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'add' not allowed for this object", $session);
    return;
}

sub __modify_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'modify' not allowed for this object", $session);
    return;
}

sub __remove_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'remove' not allowed for this object", $session);
    return;
}


package Infoblox::PAPIOverrides::GET_MODIFY_ONLY;

#

use strict;
use Infoblox::Util;

#
#
#

sub __add_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'add' not allowed for this object", $session);
    return;
}

sub __remove_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'remove' not allowed for this object", $session);
    return;
}

sub __search_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'search' not allowed for this object", $session);
    return;
}

package Infoblox::PAPIOverrides::ADD_MODIFY;

#

use strict;
use Infoblox::Util;

#
#
#

sub __add_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'add' not allowed for this object", $session);
    return;
}

sub __modify_override_hook__ {
    my ($object_type, $session, $object) = @_;
    set_error_codes(1008, "'modify' not allowed for this object", $session);
    return;
}


return 1;
