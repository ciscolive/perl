package Test2::Harness::Util::JSON;
use strict;
use warnings;

our $VERSION = '1.000038';

BEGIN {
    local $@ = undef;
    my $ok = eval {
        require JSON::MaybeXS;
        JSON::MaybeXS->import('JSON');
        1;

        if (JSON() eq 'JSON::PP') {
            *JSON_IS_PP = sub() { 1 };
            *JSON_IS_XS = sub() { 0 };
            *JSON_IS_CPANEL = sub() { 0 };
            *JSON_IS_CPANEL_OR_XS = sub() { 0 };
        }
        elsif (JSON() eq 'JSON::XS') {
            *JSON_IS_PP = sub() { 0 };
            *JSON_IS_XS = sub() { 1 };
            *JSON_IS_CPANEL = sub() { 0 };
            *JSON_IS_CPANEL_OR_XS = sub() { 1 };
        }
        elsif (JSON() eq 'Cpanel::JSON::XS') {
            *JSON_IS_PP = sub() { 0 };
            *JSON_IS_XS = sub() { 0 };
            *JSON_IS_CPANEL = sub() { 1 };
            *JSON_IS_CPANEL_OR_XS = sub() { 1 };
        }
    };

    unless ($ok) {
        require JSON::PP;
        *JSON = sub() { 'JSON::PP' };

        *JSON_IS_PP = sub() { 1 };
        *JSON_IS_XS = sub() { 0 };
        *JSON_IS_CPANEL = sub() { 0 };
        *JSON_IS_CPANEL_OR_XS = sub() { 0 };
    }

}

our @EXPORT = qw{JSON encode_json decode_json encode_pretty_json encode_canon_json};
our @EXPORT_OK = qw{JSON_IS_PP JSON_IS_XS JSON_IS_CPANEL JSON_IS_CPANEL_OR_XS};
BEGIN { require Exporter; our @ISA = qw(Exporter) }

my $json          = JSON->new->utf8(1)->convert_blessed(1)->allow_nonref(1);
my $json_non_utf8 = JSON->new->utf8(0)->convert_blessed(1)->allow_nonref(1);
my $canon         = JSON->new->utf8(1)->canonical(1)->convert_blessed(1)->allow_nonref(1);
my $pretty        = JSON->new->utf8(1)->pretty(1)->canonical(1)->convert_blessed(1)->allow_nonref(1);

sub encode_json        { $json->encode(@_) }
sub encode_canon_json  { $canon->encode(@_) }
sub encode_pretty_json { $pretty->encode(@_) }

sub decode_json {
    my ($input) = @_;
    my $data;

    local $@;
    my $error;

    # Try to decode the JSON stream as utf8. In malformed tests or tests which are intentionally
    # testing bytes behavior we need to accept the bytes from the JSON file instead.
    my $ok = eval { $data = $json->decode($input); 1 } || do {
        $error = $@;
        eval { $data = $json_non_utf8->decode($input); 1 };
    };
    $error ||= $@;
    return $data if $ok;
    my $mess = Carp::longmess("JSON decode error: $error");
    die "$mess\n=======\n$input\n=======\n";
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Test2::Harness::Util::JSON - Utility class to help Test2::Harness pick the best
JSON implementation.

=head1 DESCRIPTION

This package provides functions for encoding/decoding json, and uses the best
json tools available.

=head1 SYNOPSIS

    use Test2::Harness::Util::JSON qw/encode_json decode_json/;

    my $data = { foo => 1 };
    my $json = encode_json($data);
    my $copy = decode_json($json);

=head1 EXPORTS

=over 4

=item $package = JSON()

This returns the JSON package being used by yath.

=item $bool = JSON_IS_PP()

True if yath is using L<JSON::PP>.

=item $bool = JSON_IS_XS()

True if yath is using L<JSON::XS>.

=item $bool = JSON_IS_CPANEL()

True if yath is using L<Cpanel::JSON::XS>.

=item $bool = JSON_IS_CPANEL_OR_XS()

True if either L<JSON::XS> or L<Cpanel::JSON::XS> are being used.

=item $string = encode_json($data)

Encode data into json. String will be 1-line.

=item $data = decode_json($string)

Decode json data from the string.

=item $string = encode_pretty_json($data)

Encode into human-friendly json.

=item $string = encode_canon_json($data)

Encode into canon-json.

=back

=head1 SOURCE

The source code repository for Test2-Harness can be found at
F<http://github.com/Test-More/Test2-Harness/>.

=head1 MAINTAINERS

=over 4

=item Chad Granum E<lt>exodist@cpan.orgE<gt>

=back

=head1 AUTHORS

=over 4

=item Chad Granum E<lt>exodist@cpan.orgE<gt>

=back

=head1 COPYRIGHT

Copyright 2020 Chad Granum E<lt>exodist7@gmail.comE<gt>.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See F<http://dev.perl.org/licenses/>

=cut
