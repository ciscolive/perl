package Infoblox::Agent;

use LWP::UserAgent 5.813;
use Exporter;

use Scalar::Util qw (isvstring);
use HTTP::Request;
use HTTP::Message 5.811;
use HTTP::Response;
use HTTP::Cookies;
use HTTP::Request::Common qw(POST);
use Encode;
use MIME::Base64;
use Data::Dumper;
use Time::HiRes qw(gettimeofday tv_interval );
$Data::Dumper::Indent = 1;

use strict;

use vars qw(@ISA $VERSION @EXPORT);
@ISA = qw(LWP::UserAgent Exporter);
$VERSION = '0.1';

use Infoblox::Util;
use Infoblox::Fault;
use Infoblox::Serialize qw(serialize_request);
use Infoblox::Deserialize qw(deserialize_request);
use Scalar::Util qw(weaken);

my $debug_agent = (-f "/tmp/debug_agent");
my $debug_deserializer= (-f "/tmp/debug_deserializer");
my $debug_timing= (-f "/tmp/debug_timing");
my $initialized = 0;

sub __debug_agent_on__
{
    $debug_agent = 1;
}

sub __debug_agent_off__
{
    $debug_agent = 0;
}

sub __debug_deserializer_on__
{
    $debug_deserializer = 1;
}

sub __debug_deserializer_off__
{
    $debug_deserializer = 0;
}

sub __debug_timing_on__
{
    $debug_timing = 1;
}

sub __debug_timing_off__
{
    $debug_timing = 0;
}

sub new {
    my $class = shift;
    my %args = @_;

    my $self = delete $args{'blox_agent'};
    unless ($initialized) {
        my $v6 = Infoblox::__options('ipv6');
        unless ($v6) {
            #
            #
            require Crypt::SSLeay;
            my $csversion = $Crypt::SSLeay::VERSION;
            if (index($csversion, '_') != -1) {
                #
                #
                $csversion =~ tr/_/0/;
            }
            die "Need Crypt::SSLeay version 0.51 or later, you have version " . $csversion if $csversion < 0.51;
        }
        else {
            $self->{'ipv6_connection'} = 1;
        }
        $initialized=1;
    }

    my $session = delete $args{'blox_session'};
    my $connection_timeout = delete $args{'connection_timeout'};

    #
    if ($session->{'cc_mode'} || not defined $self) {
        $self = LWP::UserAgent->new(%args);
    }

    #
    #
    $self->{'blox_session'} = $session;
    weaken($self->{'blox_session'});

    if ($connection_timeout) {
        $self->{'connection_timeout'} = $connection_timeout;
    }

    #
    #
    #
    #
    my $verify_hostname = 0;
    if (defined $session->{'verify_hostname'}) {
        $verify_hostname = $session->{'verify_hostname'} =~ m/^(1|true)$/i ? 1 : 0;
    }
    my $ssl_ca_file = defined $session->{'SSL_ca_file'} ? $session->{'SSL_ca_file'} : 'SSL_ca_file or SSL_ca_path must be set in CC mode';
    my $ssl_ca_path = defined $session->{'SSL_ca_path'} ? $session->{'SSL_ca_path'} : 'SSL_ca_file or SSL_ca_path must be set in CC mode';

    my %ssl;
    if ($session->{'cc_mode'}) {
        unless ($self->can('ssl_opts')) {
            return set_error_codes(1012, 'Error: your version of libwww-perl does not support secure communication in CC mode, please update it to a version post 5.837.', $session);
        }
        $ssl{'verify_hostname'} = 1;
        $ssl{'SSL_verify_mode'} = 1;
        $ssl{'SSL_ca_file'} = $ssl_ca_file;
        $ssl{'SSL_ca_path'} = $ssl_ca_path;
    }
    else {
        $ssl{'SSL_verify_mode'} = $verify_hostname;
        $ssl{'verify_hostname'} = $verify_hostname;
        $ssl{'SSL_ca_file'} = $ssl_ca_file if $ssl_ca_file !~ m/SSL_ca_file/;
        $ssl{'SSL_ca_path'} = $ssl_ca_path if $ssl_ca_path !~ m/SSL_ca_path/;
    }

    #
    if (defined $session->{'SSL_key_file'} and defined $session->{'SSL_cert_file'}) {
        unless ($self->can('ssl_opts')) {
            return set_error_codes(1012, 'Error: your version of libwww-perl does not support secure communication in OCSP mode, please update it to a version post 5.837.', $session);
        }
        $ssl{'SSL_use_cert'} = 1;
        $ssl{'SSL_key_file'} = $session->{'SSL_key_file'};
        $ssl{'SSL_cert_file'} = $session->{'SSL_cert_file'};
    } elsif (defined $session->{'SSL_key_file'} or defined $session->{'SSL_cert_file'}) {
        return set_error_codes(1012, ' SSL_key_file and SSL_cert_file should be defined together', $session);
    }

    if ($self->can('ssl_opts')) {
        $self->ssl_opts(%ssl);
    }
    else {
        if ($ssl{'verify_hostname'} || $ssl_ca_path !~ m/SSL_ca_path/ || $ssl_ca_file !~ m/SSL_ca_file/) {
            return set_error_codes(1012, 'The installed version of libwww-perl does not support setting SSL options (verify_hostname, SSL_ca_file and SSL_ca_path), please update it to a version post 5.837.', $session);
        }
    }

    if ($connection_timeout) {
        $self->{'connection_timeout'} = $connection_timeout;
    }

    return unless _blox_login($self);

    $self = bless $self, $class;
    return $self;
}

sub _blox_login {
    my $self = shift;
    my $session = $self->{'blox_session'};

    return unless $session;
    set_error_codes(0,undef,$session);

    my $host_ip = $session->{"master"} || "";

    #
    #
    #
    if ($host_ip eq "" || isvstring($session->{"master"})) {
        set_error_codes(1106,"Master has not been set, cannot create session object.",$session);
        return;
    }

    my $user_name     = $session->{"username"}      || "";
    my $user_pwd      = $session->{"password"}      || "";
    my $user_new_pwd  = $session->{"new_password"}  || "";
    my $iac           = $session->{"IAC"}           || "";
    my $ssl_cert_file = $session->{SSL_cert_file}   || "";
    my $ssl_key_file  = $session->{SSL_key_file}    || "";

    unless (
        ($user_name ne "" and $user_pwd ne "")         or
        ($iac ne "")                                   or
        ($ssl_cert_file ne "" and $ssl_key_file ne "")
    ) {
        set_error_codes(1107,"User name or password has not been set, cannot create session object.",$session);
        return;
    }

    if ($user_new_pwd ne "" and ($user_name eq "" or $user_pwd eq "")) {
        set_error_codes(1107, "User name and password are required to changes password, cannot create session object.", $session);
        return;
    }

    if ($self->{'ipv6_connection'}) {
        #
        delete $self->{'ipv6_connection'};

        #
        if ($host_ip =~ m/:.*:/ && $host_ip !~ m/\[/) {
            $host_ip = "[$host_ip]";
        }
    }
    my $cookie_jar = HTTP::Cookies->new();
    my $path = "https://$host_ip/index.html";

    $self->{'blox_url'}="https://$host_ip/ibap/foo";
    if ($iac ne "") {
        my $decoded;
        #
        local $^W = 0;
        $decoded = decode_base64($iac);
        $cookie_jar->set_cookie(0,'ibapauth', $decoded,'/',"$host_ip");
    }

    $self->cookie_jar($cookie_jar);

    if (defined $self->{'connection_timeout'}) {
        use IO::Socket::INET;

        #
        #
        #
        my $sock = IO::Socket::INET->new(PeerAddr => $host_ip,
                                         PeerPort => 'https(443)',
                                         Proto    => 'tcp',
                                         Timeout  => $self->{'connection_timeout'}
                                        );
        return set_error_codes(1012, 'Internal error: socket creation failed ' . $@, $session) unless $sock;
        return set_error_codes(1012, 'Internal error: socket closure failed ' . $@, $session) unless close ($sock);
    }
    my $response;
    unless($user_new_pwd){
       $response = $self->request(POST $path,
                                [ username => $user_name, password => $user_pwd, client => 'API']);
    }else{
       $response = $self->request(POST $path,
                                [ username => $user_name, password => $user_pwd, new_password => $user_new_pwd, set_password => 1, client => 'API']);
    }

    #
    if (!$response->is_success) {
        set_error_codes(1006, $response->status_line,$session);
        return;
    } elsif ($response->content =~ m{<title>(?:AuthError|Error|CertificateInvalid)</title>}) {
        set_error_codes(1006, 'The user is not authorized for this operation. Creating session failed.',$session );
        return;
    } elsif ($response->content =~ m{<title>FirstLogin:([^<]*)</title>}){
        set_error_codes(1006, "This is your first login. Please provide a new password using the 'new_password' option.\n Password policy -\n "._describe_password_policy($1),$session);
        return;
    } elsif ($response->content =~ m{<title>PasswordExpired:([^<]*)</title>}){
        set_error_codes(1006, "Your password has expired. Please provide a new password using the 'new_password'  option.\n Password policy -\n"._describe_password_policy($1),$session);
        return;
    } elsif ($response->content =~ m{<title>PasswordResetError:([^<]*)</title>}){
        set_error_codes(1006, "Your password does not conform to the password policy:\n"._describe_password_policy($1),$session);
        return;
    } elsif ($response->content =~ m!<META HTTP-EQUIV="REFRESH".*URL=https://([^"^<]*)!) {
        set_error_codes(1006, "Please connect to the Grid master at $1. Creating session failed.",$session );
        return;
    }

    my $auth = $response->request->content();
    $auth = encode('utf-8',$auth) if utf8::is_utf8($auth);
    $self->default_header('X-IBAP-Auth' => encode_base64($auth));

    return 1;
}

my %_policy_description = (
        password_min_length => "minimal password length",
        num_lower_char=> "min. number of lowercase chars",
        num_upper_char => "min. number of uppercase chars",
        num_numeric_char=> "min. number of numeric chars",
        num_symbol_char=> "min. number of symbols in password",
        chars_to_change=> "min. difference from previous password",
);

sub _describe_password_policy
{
    my $policy = shift;
    return join ";\n", 
    map { 
        my ($key,$val) = split /=/;
        exists($_policy_description{$key})?$_policy_description{$key}.": ".$val:"$key: $val";
    } split /,/, $policy;
}
    

#
#
#
sub ObjectWrite {
    my $self = shift;
    my $body = shift;

    return $self->ibap_request('ObjectWrite', $body);
}

#
sub ObjectDelete {
    my $self = shift;
    my $body = shift;

    return $self->ibap_request('ObjectDelete', $body);
}

#
sub ObjectRead {
    my $self = shift;
    my $body = shift;
    my $header = shift;
    my $return_header = shift;
    my $paging = shift;

    return $self->ibap_request('ObjectRead', $body, $header, $return_header, $paging);
}

my $req_headers =
    HTTP::Headers->new('accept' => ['text/xml',
                                    'multipart/*',
                                    'application/soap'],
                       'user-agent' => 'PAPI-1.0/Agent',
                       'soapaction' => '""');

#
#
#
#
#
#
#
#
#
#
 #
#
sub ibap_request {
    my $self = shift;
    my ($op, $body, $header, $return_header, $return_paging) = @_;

    print "IBAP REQUEST args", Dumper($body) if $debug_agent;

    my $request = serialize_request($op, $header, $body);

    print "IBAP REQUEST request '", encode('ascii', $request,
                                           Encode::FB_PERLQQ), "\n"
        if $debug_agent;

    my $httpreq;
    eval {
        $httpreq = HTTP::Request->new('POST',
                                      $self->{'blox_url'},
                                      $req_headers);
        $httpreq->add_content_utf8($request);
    };

    if ($@) {
        print "IBAP HTTP ERR $@\n" if $debug_agent;
        die $@;
    }

    #

    my $t=[gettimeofday] if $debug_timing;
    my $resp = $self->request($httpreq);
    $self->{'blox_session'}->__time__(tv_interval($t)) if $debug_timing;

    if ($resp->is_success) {
        print "IBAP REQUEST resp '", encode('ascii', $resp->content,
                                            Encode::FB_PERLQQ), "\n"
            if $debug_agent;

#
#
#
#
        my $temp = deserialize_request($resp->content);

        print "DESERIALIZED RESPONSE", Dumper($temp)
            if $debug_agent or $debug_deserializer;

        my $b = $temp->{'SOAP-ENV:Envelope'}->{'SOAP-ENV:Body'};

        #
        my $onekey = scalar(keys %$b) ? (keys %$b)[0] : undef;

        if (defined $b->{'SOAP-ENV:Fault'}) {
            die Infoblox::Fault->new($b->{'SOAP-ENV:Fault'},'ObjectRead');

        }

        my $ret;
        my %paging;
        if (defined $b->{'ib:ObjectReadResponse'}->{'objects'}) {
            my $a = $b->{'ib:ObjectReadResponse'}->{'objects'};
            if (ref($a) eq 'ARRAY') {
                $ret = $a;
            } else {
                $ret = [$a];
            }
            $paging{'ticket'} = $b->{'ib:ObjectReadResponse'}->{'paging_ticket'} if defined $b->{'ib:ObjectReadResponse'}->{'paging_ticket'};
            $paging{'has_next'} = $b->{'ib:ObjectReadResponse'}->{'has_next'} if defined $b->{'ib:ObjectReadResponse'}->{'has_next'};
        } elsif (defined $b->{'ib:ObjectWriteResponse'}->{'objects'}) {
            my $a = $b->{'ib:ObjectWriteResponse'}->{'objects'};
            if (ref($a) eq 'ARRAY') {
                $ret = $a;
            } else {
                $ret = [$a];
            }
        } elsif (defined $b->{'ib:ObjectDeleteResponse'}->{'object_ids'}) {
            my $a = $b->{'ib:ObjectDeleteResponse'}->{'object_ids'};
            if (ref($a) eq 'ARRAY') {
                $ret = $a;
            } else {
                $ret = [$a];
            }
        } elsif ($onekey) {
            #
            $ret = $b->{$onekey};
        } else {
            die Infoblox::Fault->new(undef,'ObjectRead',undef,1001,"ERROR in post handling of deserialization");
        }

        if ($return_header || $return_paging) {
            my @return;
            push @return, $ret;
            push @return, $temp->{'SOAP-ENV:Envelope'}->{'SOAP-ENV:Header'}->{'ib:IBAPHeaderResponse'} if ($return_header);
            push @return, \%paging if ($return_paging);
            return @return;
        } else {
            return $ret;
        }

    } else {
        print "IBAP REQUEST result error'", $resp->status_line, "'\n"
            if $debug_agent;
        die $resp->status_line;
    }
}

#
#
#
#
#
#
sub set_papi_error {
    my ($self, $ibap_exc, $session_obj, $typeobj, $error_override) = @_;

    if (ref($ibap_exc)) {
        if (ref($@) && $@->isa("Infoblox::Fault")) {
            $ibap_exc->set_papi_error($session_obj, $typeobj, $error_override);
        } else {
            #
            set_error_codes(1001, "Unexpected internal error (not Fault:"
                                  . ref($ibap_exc) . ")",
                            $session_obj);
        }
    } else {
        set_error_codes(1001, $ibap_exc, $session_obj);
    }
    return 0;
}
