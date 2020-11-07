#
# Copyright (c) 2017 Infoblox Inc. All Rights Reserved.
#

package Infoblox::IBAPTypes;

use warnings;
use Exporter 'import';
@EXPORT = qw (tString tInteger tBool tIBType tField tFieldObjType tObjId tDateTime
              IBData tUInteger tObjIdRef tULong tLong);

use Infoblox::IBAPTypeUtil qw(util_string util_dateTime util_integer
                              util_long util_ulong
                              util_anyType util_bool util_uinteger);

sub tString {
    return Infoblox::IBAPTypes::String->new($_[0]);
}

#
sub tInteger {
    return Infoblox::IBAPTypes::Integer->new($_[0]);
}

#
sub tUInteger {
    return Infoblox::IBAPTypes::UInteger->new($_[0]);
}

#
sub tBool {
    return Infoblox::IBAPTypes::Bool->new($_[0]);
}

sub tLong {
    return Infoblox::IBAPTypes::Long->new($_[0]);
}

sub tULong {
    return Infoblox::IBAPTypes::ULong->new($_[0]);
}

#
sub tDateTime {
    return Infoblox::IBAPTypes::DateTime->new($_[0]);
}

#
sub tIBType {
    return Infoblox::IBAPTypes::IBType->new(@_);
}

#
sub tField {
    my $field = shift;
    my $a = (shift || {});

    $a->{field} = $field;

    return tIBType('Field', $a);
}

sub tFieldObjType {
    my $field = shift;
    my $a = (shift || {});

    $a->{object_type} = $field;

    return tIBType('Field', $a);
}

#
sub tObjId {
    my $objid = shift;

    return tIBType('object_id', { id => $objid });
}

#
sub tObjIdRef
{
    my $objid = shift;

    return tIBType('BaseObject', { object_id => tObjId($objid) } );
};

#
#
#
#
#
#
#
sub IBData {
    my ($name, $val) = @_;

    return { $name => $val };
}

package Infoblox::IBAPTypes::BaseType;

sub type { die "Type method must be overridden"; };

sub serialize { die "Serialize method must be overridden"; };

sub new {
    my $class = shift;
    my $val = shift;
    return bless \$val, $class;
}

sub value {
    my $self = shift;

    return $$self;
}

package Infoblox::IBAPTypes::String;
use base 'Infoblox::IBAPTypes::BaseType';

sub type { return "xsd:string"; };

sub serialize {
    my ($self, $name, $needtype) = @_;

    return Infoblox::IBAPTypes::util_string($name, $$self, $needtype);
}

package Infoblox::IBAPTypes::Bool;
use base 'Infoblox::IBAPTypes::BaseType';

sub type { return "xsd:boolean"; };

sub serialize {
    my ($self, $name, $needtype) = @_;

    return Infoblox::IBAPTypes::util_bool($name, $$self, $needtype);
}

package Infoblox::IBAPTypes::Integer;
use base 'Infoblox::IBAPTypes::BaseType';

sub type { return "xsd:integer"; };

sub serialize {
    my ($self, $name, $needtype) = @_;

    return Infoblox::IBAPTypes::util_integer($name, $$self, $needtype);
}

package Infoblox::IBAPTypes::UInteger;
use base 'Infoblox::IBAPTypes::BaseType';

sub type { return "xsd:unsignedInt"; };

sub serialize {
    my ($self, $name, $needtype) = @_;

    return Infoblox::IBAPTypes::util_uinteger($name, $$self, $needtype);
}

package Infoblox::IBAPTypes::Long;
use base 'Infoblox::IBAPTypes::BaseType';

sub type { return "xsd:long"; };

sub serialize {
    my ($self, $name, $needtype) = @_;

    return Infoblox::IBAPTypes::util_long($name, $$self, $needtype);
}

package Infoblox::IBAPTypes::ULong;
use base 'Infoblox::IBAPTypes::BaseType';

sub type { return "xsd:unsignedLong"; };

sub serialize {
    my ($self, $name, $needtype) = @_;

    return Infoblox::IBAPTypes::util_ulong($name, $$self, $needtype);
}

package Infoblox::IBAPTypes::DateTime;
use base 'Infoblox::IBAPTypes::BaseType';

#

sub type { return "xsd:dateTime"; };

sub serialize {
    my ($self, $name, $needtype) = @_;

    return Infoblox::IBAPTypes::util_dateTime($name, $$self, $needtype);
}

package Infoblox::IBAPTypes::IBType;
use base 'Infoblox::IBAPTypes::BaseType';

use Infoblox::IBAPSchema qw(%typefuncs $basetypes);

sub type { return $_[0]->{type}; };

sub new {
    my ($class, $type, $val) = @_;

    $type =~ s/^ib://;

    my $serialfunc = $typefuncs{$type};

    if (!$serialfunc and %typefuncs) {
        #
        #
        die "Type '$type' is not known";
    }

    my $self = { serialfunc => $serialfunc, val => $val,
                 type => $type };
    return bless $self, $class;
}

sub serialize {
    my ($self, $name, $needtype) = @_;

    return &{$self->{serialfunc}}($name, $self->{val}, $needtype);
}

sub value {
    my $self = shift;

    return $self->{val};
}

1;
