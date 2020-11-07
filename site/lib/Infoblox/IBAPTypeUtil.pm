#
# Copyright (c) 2017 Infoblox Inc. All Rights Reserved.
#

package Infoblox::IBAPTypeUtil;

use warnings;
use Exporter 'import';
@EXPORT_OK = qw(util_string util_dateTime util_integer util_anyType util_bool
                xo util_uinteger util_nil util_long util_ulong);

use POSIX qw(strftime);

my $nicexml = 1;
my $nicexmlindent = 0;

#
#
#
#
#
#
sub xo {
    my ($s, $indentchange) = @_;

    if (defined($indentchange) and $indentchange < 0) {
        $nicexmlindent += $indentchange;
    }

    if ($s) {
        if ($nicexml) {
            $s .= "\n" unless $s =~ m/\n$/;
            $s = " " x $nicexmlindent . $s;
        } else {
            $s =~ s/^\s*(.*?)\s*$/$1/;
        }
    }

    if (defined($indentchange) and $indentchange > 0) {
        $nicexmlindent += $indentchange;
    }

    return $s;
}


sub util_scalarType {
    my ($name, $val, $typestr) = @_;

    $val = $$val if ref($val);

    if (defined($val)) {
        return "<$name" . ($typestr ? ' xsi:type="' . $typestr . '"': "") . ">"
             .    $val
             . "</$name>";
    } else {
        return "";
    }
}

sub util_string {
    my ($name, $val, $needtype) = @_;

    if (defined($val)) {
        if (ref($val)) {
            if ($val->can('value')) {
                $val = $val->value();
            } else {
                die "$name: Expected string, got '$val' (type "
                    . ref($val) . ")";
            }
        }

        $val =~ s/\&/&amp;/g;
        $val =~ s/</&lt;/g;
        $val =~ s/>/&gt;/g;
        $val =~ s/\042/&quot;/g;   # "
        $val =~ s/\n/&#xA;/g;
        $val =~ s/\015/&#xD;/g;
    
        return util_scalarType($name, $val,
                               $needtype ? "xsd:string": undef);
    } else {
        return util_nil($name);
    }
}


sub util_integer {
    my ($name, $val, $needtype) = @_;

    return util_scalarType($name, $val,
                           $needtype ? "xsd:integer": undef);
}

sub util_uinteger {
    my ($name, $val, $needtype) = @_;

    return util_scalarType($name, $val,
                           $needtype ? "xsd:unsignedInt": undef);
}

sub util_ulong {
    my ($name, $val, $needtype) = @_;

    return util_scalarType($name, $val,
                            $needtype ? "xsd:unsignedLong" : undef);
}

sub util_long {
    my ($name, $val, $needtype) = @_;

    return util_scalarType($name, $val,
                            $needtype ? "xsd:long" : undef);
}

sub util_nil {
    my ($name) = @_;

    die "nil element must have a name"
        unless defined($name);
    
    return "<$name xsi:nil=\"true\"/>";
}


sub util_bool {
    my ($name, $val, $needtype) = @_;

    $val = $$val if ref($val);

    if (defined($val)) {
        return util_scalarType($name, ($val ? 1 : 0),
                               $needtype ? "xsd:boolean": undef);
    } else {
        return util_nil($name);
    }
}


sub util_dateTime {
    my ($name, $val, $needtype) = @_;

    $val = $$val if ref($val);

    if (defined($val)) {
        return util_scalarType($name, strftime("%Y-%m-%dT%H:%M:%SZ", gmtime(int($val))),
                               $needtype ? "xsd:dateTime": undef);
    } else {
        return util_nil($name);
    }
}



sub util_anyType {
    my ($name, $val) = @_;

    if (defined($val)) {

        die "$name:Argument ($val) to anyType can not be array/hash/scalar ref"
            if ref($val) =~ m{ARRAY|HASH|SCALAR|CODE};
        die "$name:Argument ($val) to anyType must have serialize method"
            unless ref($val) and $val->can('serialize');

        return $val->serialize($name, 1); # 1 = need type
    } else {
        return util_nil($name);
    }
}

1;
