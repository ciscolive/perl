package Infoblox::Grid::PersonalSmartFolder;

#

use strict;

use Carp;

use vars qw( @ISA );

@ISA = qw ( Infoblox::Grid::SmartFolderBase );

sub __ibap_object_type__
{
    return 'MyPersonalSmartFolder';
}
