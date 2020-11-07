package Infoblox::Session;

use LWP::UserAgent;
use LWP::ConnCache;
use URI::URL;
use HTTP::Request;
use HTTP::Response;
use HTTP::Request::Common qw(GET POST $DYNAMIC_FILE_UPLOAD);
use HTTP::Cookies;
use File::Basename;
use XML::Parser;
use Carp;
use vars qw ( @ISA );
use vars qw/ $DYNAMIC_FILE_UPLOAD /;
$DYNAMIC_FILE_UPLOAD = 1;

use Data::Dumper;
use Encode;
use Infoblox::Agent;
use Infoblox::Fault;
use Infoblox::Paging;
use Infoblox::Result;
use Infoblox::Util;

use Infoblox::IBAPTypes;
use Infoblox::Deserialize qw(deserialize_request);

@ISA = qw ( Infoblox );

my $client_version = "8.2.6-371069";
my $scheduled_at_err = " for parameter scheduled_at";

sub new {
    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;

    my $self = {};

    my %allowed_members = (
        'master'                           => {'mandatory' => 1, 'validator' => \&ibap_value_o2i_string},
        'password'                         => {'validator' => \&ibap_value_o2i_string},
        #
        'username'                         => {'validator' => \&ibap_value_o2i_string},
        'new_password'                     => {'validator' => \&ibap_value_o2i_string},
        'timeout'                          => {'validator' => \&ibap_value_o2i_uint, 'default' => undef},
        'connection_timeout'               => {'validator' => \&ibap_value_o2i_uint, 'default' => undef},
        'default_maximum_objects_returned' => {'validator' => \&ibap_value_o2i_uint},
        'default_partial_subobjects'       => {'validator' => \&ibap_value_o2i_uint, 'default' => 0},
        'verify_hostname'                  => {'validator' => \&ibap_value_o2i_uint},
        'SSL_ca_path'                      => {'validator' => \&ibap_value_o2i_string},
        'SSL_ca_file'                      => {'validator' => \&ibap_value_o2i_string},
        'SSL_cert_file'                    => {'validator' => \&ibap_value_o2i_string},
        'SSL_key_file'                     => {'validator' => \&ibap_value_o2i_string},
        'IAC'                              => {'validator' => \&ibap_value_o2i_string},
    );

    foreach (keys(%args)) {
        unless (exists $allowed_members{$_}) {
            set_error_codes(1101, "$_ is not allowed as an argument!");
            return undef;
        }

        if (exists $allowed_members{$_}->{'validator'}) {
            unless ($allowed_members{$_}->{'validator'}->($args{$_}, $_, undef, 1)) {
                unless (defined $args{$_}) {
                    #
                    #
                    set_error_codes(1104,"Invalid value: undef specified for: $_");
                }
                return undef;
            }
            return undef unless $allowed_members{$_}->{'validator'}->($args{$_}, $_, undef, 1);
        }

        $self->{$_} = $args{$_};
    }

    foreach (keys(%allowed_members)) {
        unless (exists $self->{$_}) {
            if ($allowed_members{$_}->{'mandatory'}) {
                set_error_codes(1103, "$_ is required");
                return undef;
            }

            $self->{$_} = $allowed_members{$_}->{'default'} if exists $allowed_members{$_}->{'default'};
        }
    }

    unless (
        (defined $$self{username} and defined $$self{password})          or
        (defined $$self{IAC})                                            or
        (defined $$self{SSL_cert_file} and defined $$self{SSL_key_file})
    ) {
        set_error_codes(1103, 'username with password or SSL certificate and SSL key or IAC is required');
        return undef;
    }

    if ($$self{new_password} and not (defined $$self{username} and defined $$self{password})) {
        set_error_codes(1103, 'username with password is required in order to change password');
        return undef;
    }

    #
    $self->{"limit"}          = undef;
    $self->{"statuscode"}     = undef;
    $self->{"statusdetail"}   = undef;
    $self->{"server_version"} = undef;
    $self->{"extensible_attribute_def_cache"} = ();
    $self->{"smart_folder_query_meta_cache"} = ();
    $self->{"smart_folder_query_meta_cache_by_id"} = ();

    bless($self, $class);

    if ($args{'default_maximum_objects_returned'}) {
        return unless $self->default_maximum_objects_returned($args{'default_maximum_objects_returned'});
    }

    if ($args{'default_partial_subobjects'}) {
        return unless $self->default_partial_subobjects($args{'default_partial_subobjects'});
    }

    #
    #
    my $server = $self->check_version();
    if ($self->status_code() == 0) {
        $server=$self->create_ibap_server($server);
    }

    delete $self->{'password'};
    delete $self->{'new_password'};

    unless ($server && $self->status_code() == 0) {
        #
        $self->{"username"}    = undef;
        $self->{"IAC"}         = undef;
        $self->{"ibap_server"} = undef;
        return $self;
    }

    #
    $self->__extensible_attribute_def_cache_update__();

    return $self;
}

sub logout
{
    my $self = shift;

    foreach ('ibap_server',
             'cc_mode',
             'limit',
             'server_version',
             'extensible_attribute_def_cache',
             'smart_folder_query_meta_cache',
             'smart_folder_query_meta_cache_by_id') {
        $self->{$_} = undef;
    }
}

sub default_maximum_objects_returned
{
    my ($self, $limit) = @_;

    if (@_ == 1) {
        return $self->{'limit'};
    }

    unless ($limit && $limit =~ m/^[0-9]+$/) {
        set_error_codes(1104, "Invalid value " . $limit . " for default_maximum_objects_returned. Only unsigned integers are supported",$self );
        return;
    }
    $self->{'limit'} = $limit;

    return 1;
}

sub default_partial_subobjects
{
    my ($self, $partial) = @_;

    if (@_ == 1) {
        return $self->{'default_partial_subobjects'};
    }

    unless (defined $partial && ($partial == 0 || $partial == 1)) {
        set_error_codes(1104, "Invalid value " . $partial . " for default_partial_subobjects. Only 0 or 1 are valid",$self );
        return;
    }

    $self->{'default_partial_subobjects'} = $partial;

    return 1;
}

#
sub __refresh_smart_folder_query_meta_cache__
{
    my ($self) = @_;
    my $result;
    my $server = $self->get_ibap_server() || return;

    #
    $self->{"smart_folder_query_meta_cache"} = ();
    $self->{"smart_folder_query_meta_cache_by_id"} = ();

    #
    eval {
        $result = $server->ObjectRead({object_type => 'SmartFolderQueryMeta',
                                       depth => 1,
                                       return_fields =>
                                           [tField('name'),
                                            tField('ext_attr_def_ref', { sub_fields => [
                                                                                        tField('name'),
                                                                                       ]}),
                                            tField('field_type'),
                                            tField('value_type'),
                                            tField('enum_values')]});
    };

    unless ($result) {
        my $err = $@;
        if ($err =~ m/Authorization Required/) {
            set_error_codes(1006, 'The user is not authorized for this operation. Creating session failed.',$self );
        } else {
            set_error_codes(1101, "Connection error " . $err,$self );
        }
    } else {
        #
        foreach my $result_ref (@{$result}) {
            $self->__smart_folder_query_meta_cache_add_entry__($$result_ref{name}, $$result_ref{field_type}, $$result_ref{value_type}, $$result_ref{enum_values}, $$result_ref{ext_attr_def_ref});
        }
    }
}

sub restart_status {
    my $self = shift;
    my $server = $self->get_ibap_server() || return;
    my ($result, $header);

    eval {
        ($result, $header) = $server->ibap_request('NoOperation', {}, undef, 1);
    };
    return $server->set_papi_error($@, $self) if ($@);

    if ($header && $header->{'Restart'}) {
        return split(/\s+/, $header->{'Restart'});
    }
    return ();
}

sub check_version {
    my $self           = shift;
    my $server_version = undef;
    set_error_codes(0, undef, $self);

    my $url = URI::URL->new("https://127.0.0.1/");
    my $host_ip = $self->{"master"} || "";
    if ($host_ip eq "") {
        set_error_codes(1106,"Master has not been set, cannot create session object.");
        return;
    }
    $url->host($host_ip);
    $url->port("443");
    $url->path("/nios_version.txt");
    $url->query_form('cc_status' => '1');

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
        return set_error_codes(1012, 'Internal error: socket creation failed ' . $@, $self) unless $sock;
        return set_error_codes(1012, 'Internal error: socket closure failed ' . $@, $self) unless close ($sock);
    }

    #
    #
    #
    my $server = LWP::UserAgent->new(
                                     #
                                     #
                                     timeout    => $self->{timeout},
                                     keep_alive => 1,
                                    );

    if ($server->can('ssl_opts')) {
        my $verify_hostname = 0;
        if (defined $self->{'verify_hostname'}) {
            $verify_hostname = $self->{'verify_hostname'} =~ m/^(1|true)$/i ? 1 : 0;
        }
        my %ssl;
        $ssl{'SSL_verify_mode'} = $verify_hostname;
        $ssl{'verify_hostname'} = $verify_hostname;
        $ssl{'SSL_ca_file'} = $self->{'SSL_ca_file'} if defined $self->{'SSL_ca_file'};
        $ssl{'SSL_ca_path'} = $self->{'SSL_ca_path'} if defined $self->{'SSL_ca_path'};

        #
        if (defined $self->{'SSL_key_file'} and defined $self->{'SSL_cert_file'}) {
            $ssl{'SSL_use_cert'} = 1;
            $ssl{'SSL_key_file'} = $self->{'SSL_key_file'};
            $ssl{'SSL_cert_file'} = $self->{'SSL_cert_file'};
        } elsif (defined $self->{'SSL_key_file'} or defined $self->{'SSL_cert_file'}) {
            return set_error_codes(1012, ' SSL_key_file and SSL_cert_file should be defined together', $self);
        }

        $server->ssl_opts(%ssl);
    }
    else {
        if (defined $self->{'SSL_ca_file'} || defined $self->{'SSL_ca_path'} || defined $self->{'verify_hostname'} || defined $self->{'SSL_key_file'} || defined $self->{'SSL_cert_file'}) {
            set_error_codes(1012, 'The installed version of libwww-perl does not support setting SSL options (verify_hostname, SSL_ca_file, SSL_ca_path, SSL_key_file and SSL_cert_file), please update it to a version post 5.837.', $self);
            return;
        }
    }

    my $resp = $server->request(HTTP::Request->new(GET => $url->canonical()));
    if ($resp->is_success) {
        $server_version=$resp->content;

        if ($server_version =~ m/ FIPS$/) {
            $server_version =~ s/ FIPS$//;
        }

        if ($server_version =~ m/ CC$/) {
            $server_version =~ s/ CC$//;
            $self->{'cc_mode'} = 'true';
        }

        $self->server_version($server_version);
        if ($client_version eq $server_version) {
            set_error_codes(0, undef, $self);

            #
            #
            #
            #
            if ($self->{'cc_mode'}) {
                return;
            }
            else {
                return $server;
            }
        }
    }

    if ($server_version) {
        #
        #
        #
        $location = $resp->header('location');

        if (defined $location) {
            $location =~ s!https://!!;
            chop($location);

            #
            #
            #
            if (is_ipv4_address($location) || is_ipv6_address($location)) {
                if ($location eq $host_ip) {
                    #
                    #
                    set_error_codes(1009,
                                    "This server ($host_ip) is not a grid master.", $self
                                   );
                    return;
                }
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
                    set_error_codes(1009,
                                    "This server ($host_ip) is not a grid master. The current grid master is: $location", $self
                                   );
                    return;
                #
            }
            else {
                #
                #
                set_error_codes(1009,
                                "This server ($host_ip) is not a grid master. The current grid master is: $location", $self
                               );
                return;
            }
        }
        else {
            #
            set_error_codes(1009,
                            "The version of perl module [$client_version] doesn't match the server version [$server_version]. Please upgrade your Infoblox perl module package", $self
                           );
        }
    } else {
        $status_detail = $resp->message() if ($resp->is_error());

        #
        set_error_codes(1006, (defined($status_detail) ? $status_detail : '') . ". Creating session failed.", $self);
    }

    return;
}

#

sub __validate_arguments_from_arg_list__ {

    my ($self, $ref_allowed_arguments, $ref_args_list) = @_;
    my $key;

    foreach $key (keys %$ref_args_list) {

        if (not exists $$ref_allowed_arguments{$key}) {
            set_error_codes(1101, "$key is not allowed as an argument!", $self);
            return 0;
        }
    }

    foreach $key (keys %$ref_allowed_arguments) {

        #
        #
        if (ref $$ref_allowed_arguments{$key}) {
            #
            if (
                $$ref_allowed_arguments{$key}{mandatory} and
                not exists $$ref_args_list{$key}
            ) {
                set_error_codes(1002, "'$key' is required", $self);
                return 0;
            }

            next if not exists $$ref_args_list{$key};

            #
            if ($$ref_allowed_arguments{$key}{validator}) {
                if (ref $$ref_allowed_arguments{$key}{validator} eq 'CODE') {
                   return 0 unless $$ref_allowed_arguments{$key}{validator}->(
                       $$ref_args_list{$key}, $key, $self, 1);
               }
                #

            #
            } elsif ($$ref_allowed_arguments{$key}{enum}) {
                unless (array_contains($$ref_allowed_arguments{$key}{enum}, $$ref_args_list{$key})) {
                    set_error_codes(1002, "Invalid value '$$ref_args_list{$key}' for member $key. " .
                        "Valid values are '". (join "', '", @{$$ref_allowed_arguments{$key}{enum}}) . "'", $self);
                    return 0;
                }
            }
        #
        #
        } elsif (
            $$ref_allowed_arguments{$key} and
            not exists $$ref_args_list{$key}
        ) {
            set_error_codes(1002,"'$key' is required", $self);
            return 0;
        }
    }

    return 1;
}

#
#
sub create_ibap_server {
    my ($self,$server) = @_;

    set_error_codes(0,undef,$self);

    $self->{"ibap_server"} =
        new Infoblox::Agent(
                            #
                            timeout      => $self->{timeout},
                            keep_alive   => 1,

                            #
                            blox_session => $self,
                            blox_agent   => $server,
                            connection_timeout => $self->{connection_timeout},
                           );

    #
    return $self->{"ibap_server"};
}


#
#
#
#
sub get_ibap_server {
    my ($self) = @_;
    my $ibapserv = $self->{"ibap_server"};

    if (!$ibapserv) {
        #
        #
        set_error_codes(1006, "Creating session with the server failed.",
                        $self);
    } else {
        set_error_codes(0, undef, $self);
    }

    return $ibapserv;
}

sub generate_exception_from_ibap {
    my $x=shift;
    my $e;
    my $detail;

    if (defined $x->faultstring) {
        $e = $x->faultstring;
    }

    if (defined $x->faultdetail) {
        if ($detail = $x->faultdetail->{'FaultDetail'}) {
            $e .= ":\n" . $detail->{'string'} if defined($detail->{'string'});
            $e .= "\n" . $detail->{'trace'} if defined($detail->{'trace'});
        } elsif ($detail = $x->faultdetail->{'Fault'}) {
            $e .= ":\n" . $detail->{'text'} if defined($detail->{'text'});
            $e .= "\n Code: " . $detail->{'code'} if defined($detail->{'code'});
            $e .= "\n Data: " . $detail->{'data'} if defined($detail->{'data'});
        }
    }

    return $e;
}

sub status_code {
    my $self = shift;
    if (@_ == 0) {
        return $self->{"statuscode"};
    } else {
        my $status_code = shift;
        $self->{"statuscode"} = $status_code;
    }
}

sub status_detail {
    my $self = shift;
    if (@_ == 0) {
        return $self->{"statusdetail"};
    } else {
        my $status_detail = shift;
        $self->{"statusdetail"} = $status_detail;
    }
}

sub server_version {
    my $self = shift;
    if (@_ == 0) {
        return $self->{"server_version"};
    } else {
        my $server_version = shift;
        $self->{"server_version"} = $server_version;
    }
}

sub cc_mode {
    my $self = shift;
    return $self->{"cc_mode"};
}

sub add {
    my $self = shift;

    my ($object, %args) = @_;

    my $request_settings = request_settings($self, \%args, 'add');
    return undef unless $request_settings;

    my $ref_allowed_arguments = {
        __no_override_add__ => 0,
        };
    return unless $self->__validate_arguments_from_arg_list__($ref_allowed_arguments, \%args);

    my %ibap_headers  = ();
    $ibap_headers{'request_settings'} = $request_settings if %$request_settings;

    my $no_override = $args{__no_override_add__};

    set_error_codes(0,undef,$self);

    my $response = undef;

    my $server = $self->get_ibap_server() || return;

    if ($object) {

        #
        my $object_type=ref($object);
        if ($object_type->can('__add_override_hook__') && !$no_override)
        {
            my $res = $object_type->__add_override_hook__($self, $object, %args);

            if ($self->status_code() == 9999 && $self->status_detail() eq 'continue') {
                set_error_codes(0, undef, $self);
            } else {
                return $res;
            }
        }

        my $ibap_object_type = 'RTXML';
        if ($object->can('__ibap_object_type__')) {
            $ibap_object_type = $object->__ibap_object_type__("add", $self);
        }

        if ($ibap_object_type ne 'RTXML') {
            if ($object->can('__func_call__')) {
                my $result;
                my $call_fields=$object->__func_call__($server, $self);
                if ( not $call_fields ) {
                    if ( $self->status_code() == 0 ) {
                        if (Infoblox->status_code() == 0) {
                            set_error_codes(1001,"Unspecified server error in processing request",$self );
                        } else {
                            set_error_codes(Infoblox->status_code(),Infoblox->status_detail(),$self );
                        }
                    }
                    return;
                }

                eval {
                    $result = $server->ibap_request($ibap_object_type,
                                                    $call_fields,
                                                    \%ibap_headers);
                };
                return $server->set_papi_error($@, $self, $object) if $@;
                if ($object->can(__func_call_result_handler__)) {
                    return $object->__func_call_result_handler__($result);
                }
                else {
                    return 1;
                }
            }
            else {
                my $write_fields=$object->__object_to_ibap__($server, $self);
                if ( not $write_fields ) {
                    if ( $self->status_code() == 0 ) {
                        if (Infoblox->status_code() == 0) {
                            set_error_codes(1001,"Unspecified server error in processing request",$self );
                        } else {
                            set_error_codes(Infoblox->status_code(),Infoblox->status_detail(),$self );
                        }
                    }
                    return;
                }

                my $result;

                set_error_codes(0,'Operation succeeded');
                #
                eval {
                    $result = $server->ibap_request
                      ('ObjectWrite',
                       {object_type => $ibap_object_type,
                        op => 'INSERT',
                        write_fields => $write_fields},
                       \%ibap_headers);
                };

                return $server->set_papi_error($@, $self, $object) if $@;

                #
                #
                if (defined $result->[0]{'id'}) {
                    $object->__object_id__($result->[0]{'id'}); # Do this
                } else {
                    $object->__object_id__($result->[0]{'object_id'}{'id'}); # Not this
                }

                if ($object->can('__post_insert_hook__')) {
                    return $object->__post_insert_hook__($server, $self);
                } else {
                    return 1;
                }
            }
        } else {
            set_error_codes(1114,"Object is incompatible with session object");
            return;
        }
    } else {
        set_error_codes(1002,'One or more arguments in request are missing or incorrect', $self);
        return;
    }
}

#
#
#

#
my %remove_options = (
                      NetworkDeleteOptions => {
                                               validator => {
                                                             'Infoblox::DHCP::Network'              => 1,
                                                             'Infoblox::DHCP::IPv6Network'          => 1,
                                                             'Infoblox::DHCP::NetworkContainer'     => 1,
                                                             'Infoblox::DHCP::IPv6NetworkContainer' => 1,
                                               },
                                               options   => {
                                                             send_rir_request => \&ibap_value_o2i_boolean,
                                                             reason           => \&ibap_value_o2i_string,
                                               },
                      },
                      AssociatedPTRDeleteOption => {
                                                     validator => {
                                                                   'Infoblox::DNS::Record::A'    => 1,
                                                                   'Infoblox::DNS::Record::AAAA' => 1,
                                                     },
                                                     options   => {
                                                                   remove_associated_ptr => \&ibap_value_o2i_boolean,
                                                     },
                      },
);

#
my %reverse_remove_options = ();
foreach my $option (keys %remove_options) {

    $reverse_remove_options{$_} = $option
        foreach (keys %{$remove_options{$option}{validator}});
}

sub __remove_options__ {

    my ($self, $object, $params) = @_;
    my ($iboption, $options, %opts);

    return (1, 1, undef) unless defined $params;

    unless ($iboption = $reverse_remove_options{ref $object}) {

        set_error_codes(1012, ref ($object) . ' does not support ' .
            'remove options');

        return (0);
    }

    unless (ref $params eq 'HASH') {

        set_error_codes(1012, 'remove_options should be a HASH');
        return (0);
    }

    $options = $remove_options{$iboption}{options};

    foreach my $param (keys %$params) {

        if (defined $$options{$param}) {

            $opts{$param} =
                $$options{$param}->($$params{$param});

            return (0) unless $opts{$param};

        } else {

            set_error_codes(1012, ref ($object) . ' does not support \'' .
                $param . '\' option');

            return (0);

        }
    }

    return (%opts ?
        (1, 0, {options => tIBType($iboption, \%opts)}) : (1, 1, undef));
}

#

sub remove {
    my $self = shift;
    my $object;
    my $object_type;
    my $response;
    my %ibap_headers = ();
    my $arg_key;
    my %args;
    my $server = $self->get_ibap_server() || return;
    my $request_settings = {};
    my $remove_options_arg;

    set_error_codes(0, undef, $self);

    my $do_searchable = 0;
    if (ref $_[0] eq '')    # 1st Argument is a hash key (SCALAR) (this really should not be supported)
    {
        %args = @_;

        $request_settings = request_settings($self, \%args, 'remove');
        return undef unless $request_settings;

        $object_type = delete $args{object};
        $remove_options_arg = delete $args{'remove_options'};

        #
        $object_type =~ s/ //g;
        unless ($object_type->can('new'))
        {
            set_error_codes(1001,"General failure removing object type '$object_type', please make sure this is a supported object type.",$self);
            return;
        }

        $object = $object_type->new(%args);

        $do_searchable = 1 if $object;
    } else { # 1st Argument is an object (we should really support only objects coming from "get/search", aka with object id set)
        ($object, %args) = @_;

        $remove_options_arg = delete $args{'remove_options'};

        $request_settings = request_settings($self, \%args, 'remove');
        return undef unless $request_settings;

        my $ref_allowed_arguments = {};
        return unless $self->__validate_arguments_from_arg_list__($ref_allowed_arguments, \%args) or return;

        $object_type = ref($object);

        $do_searchable = 1 unless ($object->__object_id__());
    }

    if ($do_searchable) {
        undef %args;

        my $ref_searchable_fields;
        {
            no strict 'refs';
            my $objclass = $object->__get_class_methods_class__();
            $ref_searchable_fields  = \%{$objclass . '::_searchable_fields'};
        }

        #
        #
        #
        foreach (keys %$object) {
            if (defined $ref_searchable_fields->{$_}) {
                #
                #
                #
                next if ($_ eq 'discovered_data' or (scalar(@{$ref_searchable_fields->{$_}}) >= 3 and $ref_searchable_fields->{$_}->[2] eq 'SUBMATCHSTRUCT_discovered_data'));

                $args{$_}=$$object{$_};
            }
        }
    }

    $ibap_headers{'request_settings'} = $request_settings if %$request_settings;

    if ($object) {

        #
        my $object_type=ref($object);
        if ($object_type->can('__remove_override_hook__'))
        {
            my $res = $object_type->__remove_override_hook__($self, $object);

            if ($self->status_code() == 9999 && $self->status_detail() eq 'continue') {
                set_error_codes(0, undef, $self);
            } else {
                return $res;
            }
        }

        my $ibap_object_type = 'RTXML';
        if ($object->can('__ibap_object_type__')) {
            $ibap_object_type = $object->__ibap_object_type__("remove", $self, \%args);
        }

        if ($object->can('__func_call__')) {
            set_error_codes(1001,"General failure, this object does not support remove.",$self);
            return;
        }

        #
        my ($success, $ignore, $rmo) =
            $self->__remove_options__($object, $remove_options_arg);

        return undef unless $success;
        my %rm_options = $ignore ? () : %$rmo;


        if ($ibap_object_type ne 'RTXML') {
            my $result;

            my (@search_query, $search_fields);
            if (defined $object->__object_id__() ) {
                #
                my $delargs = {object_ids =>
                                   [tObjId($object->__object_id__())],
                               %rm_options};

                $delargs->{exclude_subobj} = 1
                    if $object->can('__delete_sub_objects__')
                       and not $object->__delete_sub_objects__();

                #
                eval { $result = $server->ibap_request('ObjectDelete',
                                                       $delargs,
                                                       \%ibap_headers); };
            } else {
                my $search_query = $self->_search_parameters_helper($object,\%args,'get');
                return unless $search_query;
                #
                eval { $result = $server->ibap_request
                                     ('ObjectDelete',
                                      { object_type   => $ibap_object_type,
                                        search_fields => $search_query,
                                        %rm_options },
                                      \%ibap_headers); };
            }

            return $server->set_papi_error($@, $self, $object) if $@;

            #
            $object->__object_id__(undef);

            #
            if ($object_type->can('__post_remove_hook__'))
            {
                my @removed_object_ids;
                foreach my $result_ref (@{$result})
                {
                    push @removed_object_ids, $$result_ref{'id'};
                }

                return $object_type->__post_remove_hook__($server, $self, \@removed_object_ids);
            }
            else
            {
                return 1;
            }
        } else {
            set_error_codes(1114,"Object is incompatible with session object");
            return;
        }
    } else {
        set_error_codes(1002,'One or more arguments in request are missing or incorrect', $self);
        return;
    }
}

sub get {
    my ($self, %args) = @_;
    my $object_type  = delete $args{object};
    my $wanted_members_ref  = delete $args{return_methods};
    my $wanted_partials  = delete $args{partial_subobjects};
    my $object_array_ref;

    set_error_codes(0,undef,$self);

    $wanted_partials = $self->{'default_partial_subobjects'} unless defined $wanted_partials;

    #
    $object_type =~ s/ //g;
    unless ($object_type->can('new'))
    {
        set_error_codes(1001,"General failure getting object type '$object_type', please make sure this is a supported object type.",$self);
        return;
    }

    #
    if ($object_type->can('__get_override_hook__'))
    {
        my $res = $object_type->__get_override_hook__($self, \%args);

        if ($self->status_code() == 9999 && $self->status_detail() eq 'continue') {
            set_error_codes(0, undef, $self);
        } else {
            return $res;
        }
    }

    my $object = $object_type->__new__();
    my $ibap_object_type = 'RTXML';

    my $server=$self->get_ibap_server() || return;

    if ($object->can('__ibap_object_type__')) {
        $ibap_object_type = $object->__ibap_object_type__("get", $self, \%args)
    }

    if ($object->can('__func_call__')) {
        set_error_codes(1001,"General failure, this object does not support get.",$self);
        return;
    }

    if ($ibap_object_type ne 'RTXML') {
        my $search_query = $self->_search_parameters_helper($object,\%args,'get');
        return unless $search_query;

        #
        if ($self->__ibap_object_read__($server, $object, $object_type,
                                        $ibap_object_type, 0, $search_query,
                                        $wanted_members_ref, 0, \$object_array_ref, undef, undef, \%args,$wanted_partials)
            != 1)
        {
            return;
        }
    }
    else {
        set_error_codes(1114,"Object is incompatible with session object");
        return;
    }

    set_error_codes($self->status_code(), $self->status_detail());

    if (Infoblox->status_code() != 0) {
        return;
    }
    if ($object_array_ref) {
        if (wantarray) {
            return @{$object_array_ref};
        } else {
            return $object_array_ref->[0];
        }
    } else {
        return;
    }
}

sub _search_parameters_helper
{
    my ($self,$object,$args,$type) = @_;

    my ($argsref, $argstyperef, $argsmatchref) = $object->__search_mapping_fields__($self,$type,$args);
    return undef unless $argsref;
    my %submatches;

    my @search_query;
    foreach (keys %$argsref) {
        my %search_arg;
        $search_arg{'field'} = $_;
        $search_arg{'value'} = $$argsref{$_};
        if ($type eq 'search' && defined($$argstyperef{$_}) && $$argstyperef{$_} =~ m/LIST_(.*)/) {
            $search_arg{'list_op'} = $1;
            if ($1 eq 'INTERSECT' || $1 eq 'CONTAIN') {
                $search_arg{'search_type'} = 'EXACT';
            }
        } elsif ($type eq 'search' && defined($$argstyperef{$_}) && $$argstyperef{$_} eq 'SEARCHALSOEXACT') {
            $search_arg{'search_type'} = 'EXACT';
        } elsif ($type eq 'get' && defined($$argstyperef{$_}) && $$argstyperef{$_} && $$argstyperef{$_} =~ m/^LIST_(.*)/) {
            #
            #
            #

            $search_arg{'list_op'} = $1;
        } elsif (defined($$argstyperef{$_}) && $$argstyperef{$_} =~ m/SUBMATCH_(.*)/) {
            $search_arg{'field'} = $1;
            $search_arg{'list_op'} = 'IN';
            $search_arg{'search_type'} = 'EXACT';
        } elsif (defined($$argstyperef{$_}) && $$argstyperef{$_} =~ m/SUBMATCHSTRUCT_(.*)/) {
            #
            #
            #
            #
            #
            #
            #
            #

            if (defined $submatches{$1}) {
                push @{$submatches{$1}->{'value'}}, $$argsref{$_};
                next;
            }
            else {
                $submatches{$1} = \%search_arg;
                $search_arg{'field'} = $1;
                $search_arg{'value'} = [$$argsref{$_}];
                delete $search_arg{'search_type'};
            }
        } elsif (defined($$argstyperef{$_}) && $$argstyperef{$_} =~ m/(GEQ|LEQ)_(.*)/) {
            $search_arg{'search_type'} = $1;
            $search_arg{'field'} = $2;
            if ($search_arg{'field'} =~ m/^(POSITIVE|NEGATIVE)_(.*)/) {
                $search_arg{'ifmatch'} = $1;
                $search_arg{'field'} = $2;
            }
        } elsif (defined($$argstyperef{$_}) && $$argstyperef{$_} eq 'EXACT_NEGATIVE') {
            $search_arg{'search_type'} = 'EXACT';
            $search_arg{'ifmatch'} = 'NEGATIVE';
        } elsif (defined $_ && $_ eq 'extensible_attributes') {
            $search_arg{'list_op'} = 'SUBSET';
            $search_arg{'search_type'} = 'EXACT';
        } else {
            if ($type eq 'search') {
                $search_arg{'search_type'} = $$argstyperef{$_};
                if ($$argsmatchref{$_}) {
                    $search_arg{'match_case'} = $$argsmatchref{$_};
                    $search_arg{'match_case'} =~ s/^GET_//; # In case this is also a get
                }

                #
                if (ref($$argsref{$_}) eq 'Infoblox::IBAPTypes::Integer' && $search_arg{'search_type'} eq 'REGEX') {
                    $search_arg{'search_type'} = 'EXACT';
                }
            }
            else {
                $search_arg{'search_type'} = 'EXACT';
                if ($$argsmatchref{$_} && $$argsmatchref{$_} eq 'GET_IGNORE_CASE') {
                    $search_arg{'match_case'} = 'IGNORE_CASE';
                }
            }
        }
        unshift @search_query, \%search_arg;
    }

    #
    #
    #
    foreach (keys %submatches) {
        $submatches{$_}->{'value'} = tIBType('SubMatch', { search_fields => $submatches{$_}->{'value'} });
    }

    return \@search_query;
}

sub search {
    my ($self, %args) = @_;
    my $object_type  = delete $args{object};
    my $wanted_members_ref  = delete $args{return_methods};
    my $wanted_partials  = delete $args{partial_subobjects};
    my $object_array_ref;

    set_error_codes(0,undef,$self);

    $wanted_partials = $self->{'default_partial_subobjects'} unless defined $wanted_partials;

    #
    $object_type =~ s/ //g;
    unless ($object_type->can('new'))
    {
        set_error_codes(1001,"General failure searching object type '$object_type', please make sure this is a supported object type.",$self);
        return;
    }

    #
    if ($object_type->can('__search_override_hook__'))
    {
        my $res = $object_type->__search_override_hook__($self, \%args);

        if ($self->status_code() == 9999 && $self->status_detail() eq 'continue') {
            set_error_codes(0, undef, $self);
        } else {
            return $res;
        }
    }

    my $object = $object_type->__new__();
    my $ibap_object_type = 'RTXML';

    my $server=$self->get_ibap_server() || return;

    if ($object->can('__ibap_object_type__')) {
        $ibap_object_type = $object->__ibap_object_type__("search", $self, \%args)
    }

    if ($object->can('__func_call__')) {
        set_error_codes(1001,"General failure, this object does not support search.",$self);
        return;
    }

    if ($ibap_object_type ne 'RTXML') {
        my $search_query = $self->_search_parameters_helper($object,\%args,'search');
        return unless $search_query;

        if ($self->__ibap_object_read__($server, $object, $object_type,
                                        $ibap_object_type, 1, $search_query,
                                        $wanted_members_ref, 0,
                                        \$object_array_ref,undef,undef,\%args,$wanted_partials)
            != 1)
        {
            return;
        }

        #
        if ($object->can('__post_search_hook__')) {
            $object->__post_search_hook__($server, $self, \%args, \$object_array_ref);
        }
    }
    else {
        set_error_codes(1114,"Object is incompatible with session object");
        return;
    }

    set_error_codes($self->status_code(), $self->status_detail());

    if (Infoblox->status_code() != 0) {
        return;
    }
    if ($object_array_ref) {
        if (wantarray) {
            return @{$object_array_ref};
        } else {
            return $object_array_ref->[0];
        }
    } else {
        return;
    }
}

sub modify {
    my $self = shift;

    my ($object, %args) = @_;

    my $request_settings = request_settings($self, \%args, 'modify');
    return undef unless $request_settings;

    my $ref_allowed_arguments = {};
    return unless $self->__validate_arguments_from_arg_list__($ref_allowed_arguments, \%args);

    my %ibap_headers  = ();
    $ibap_headers{'request_settings'} = $request_settings if %$request_settings;

    set_error_codes(0,undef,$self);

    my $response = undef;
    my $server=$self->get_ibap_server() || return;

    if ($object) {

        #
        my $object_type=ref($object);
        if ($object_type->can('__modify_override_hook__'))
        {
            my $res = $object_type->__modify_override_hook__($self, $object);

            if ($self->status_code() == 9999 && $self->status_detail() eq 'continue') {
                set_error_codes(0, undef, $self);
            } else {
                return $res;
            }
        }

        my $ibap_object_type = 'RTXML';
        if ($object->can('__ibap_object_type__')) {
            $ibap_object_type = $object->__ibap_object_type__("modify", $self);
        }

        if ($object->can('__func_call__')) {
            set_error_codes(1001,"General failure, this object does not support modify.",$self);
            return;
        }

        if ($object->{'__partial__'}) {
            set_error_codes(1001,"Objects returned by a 'slim search' cannot be modified without being filled.",$self);
            return;
        }

        if ($ibap_object_type ne 'RTXML') {

            my $old_object_id=$object->__object_id__();

            my $write_fields=$object->__object_to_ibap__($server, $self);

            if( not $write_fields ) {
                if( $self->status_code() == 0 ) {
                    if (Infoblox->status_code() == 0) {
                        set_error_codes(1001,"Unspecified server error in processing request",$self );
                    }
                    else {
                        set_error_codes(Infoblox->status_code(),Infoblox->status_detail(),$self );
                    }
                }
                return;
            }

            my $result;
            #
            eval { $result = $server->ibap_request
                     ('ObjectWrite',
                      { op => 'UPDATE',
                        object_ids => [ tObjId($old_object_id) ],
                        write_fields => $write_fields },
                      \%ibap_headers);
               };

            return $server->set_papi_error($@, $self, $object) if $@;

            #
            #
            if (defined $result->[0]{'id'}) {
                $object->__object_id__($result->[0]{'id'}); # Do this
            } else {
                $object->__object_id__($result->[0]{'object_id'}{'id'}); # Not this
            }

            set_error_codes($self->status_code(), $self->status_detail());

            if (($self->status_code()) != 0) {
                return;
            }
            else {
                if ($object->can('__post_modify_hook__')) {
                    return $object->__post_modify_hook__($server, $self, $old_object_id);
                }
                else {
                    return 1;
                }
            }
        }
        else {
            set_error_codes(1114,"Object is incompatible with session object");
            return;
        }
    } else {
        set_error_codes(1002,'One or more arguments in request are missing or incorrect', $self);
        return;
    }
}

sub empty_recycle_bin
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    #
    $fcall_args{'category'} = ibap_value_o2i_string('ALL');

    eval { $result = $server->ibap_request('EmptyRecycleBinObj', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

sub join_grid
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    if (defined $args{'grid_name'}) {
        $fcall_args{'grid_name'} = ibap_value_o2i_string($args{'grid_name'});
    }
    else {
		set_error_codes(1002,"grid_name is a required member.",$self);
		return;
    }

    if (defined $args{'master'}) {
        $fcall_args{'grid_ipaddress'} = ibap_value_o2i_string($args{'master'});
    }
    else {
		set_error_codes(1002,"master is a required member.",$self);
		return;
    }

    if (defined $args{'shared_secret'}) {
        $fcall_args{'grid_shared_secret'} = ibap_value_o2i_string($args{'shared_secret'});
    }
    else {
		set_error_codes(1002,"shared_secret is a required member.",$self);
		return;
    }

    eval { $result = $server->ibap_request('JoinGrid', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

sub leave_multi_grid
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

    set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    eval { $result = $server->ibap_request('LeaveGoG', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

sub gen_tsig_key
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    #
    my $keysize = 128;
    my $algorithm='HMAC-MD5';

    if (defined $args{'algorithm'}) {
        if ($args{'algorithm'} ne 'HMAC-MD5' && $args{'algorithm'} ne 'HMAC-SHA256') {
            set_error_codes(1012,$args{'algorithm'} . " is not a valid value for 'algorithm'. Valid values are 'HMAC-MD5' and 'HMAC-SHA256'.",$self);
            return;
        }
        $algorithm = $args{'algorithm'};
    }

    if (defined $args{'keylen'}) {
        if ($algorithm eq 'HMAC-MD5') {
            unless ($args{'keylen'} == 128 || $args{'keylen'} == 256 || $args{'keylen'} == 512) {
                set_error_codes(1012,$args{'keylen'} . " is not a valid value for 'keylen'. For HMAC-MD5 keys Valid values are 128, 256 and 512.",$self);
                return;
            }
        } elsif ($algorithm eq 'HMAC-SHA256') {
            unless ($args{'keylen'} == 128 || $args{'keylen'} == 256) {
                set_error_codes(1012,$args{'keylen'} . " is not a valid value for 'keylen'. For HMAC-SHA256 keys Valid values are 128 and 256.",$self);
                return;
            }
        }

        $keysize = $args{'keylen'};
    }

    $fcall_args{'tsig_key_alg'} = ibap_value_o2i_string($algorithm);
    $fcall_args{'tsig_key_size'} = ibap_value_o2i_uint($keysize);

    eval { $result = $server->ibap_request('GenerateTsigKey', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

	return $result->{'tsig_key'};
}

sub gen_hsm_client_cert
{
    my ( $self , %args ) = @_;
    my (%fcall_args);

    set_error_codes(0,undef,$self);

    my $server=$self->get_ibap_server() || return;
    unless (defined $server) {
      set_error_codes(1006,"Creating session with the server failed.",$self);
      return;
    }

    if ($args{'member'}) {
      $fcall_args{'vnode'} = ibap_value_o2i_member_nocache($args{'member'},$self,'member',0);
    } else {
      set_error_codes(1012, "Required \"member\" argument missing",$self);
      return 0;
    }

    if (exists($args{'algorithm'}) and $args{'algorithm'}) {
      if ($args{'algorithm'} !~ /^(RSASHA1|RSASHA256)$/) {
        set_error_codes(1103, $args{'algorithm'} . ' is an unsupported algorithm, valid values are: RSASHA1 or RSASHA256', $self);
        return 0;
      }
      $fcall_args{'algorithm'} = ibap_value_o2i_string($args{'algorithm'});
    } else {
      set_error_codes(1012, "Required \"algorithm\" argument missing",$self);
      return 0;
    }

    eval { $result = $server->ibap_request('GenerateSafeNetClientCert', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

#
sub test_hsm_status
{
    my ($self , %args) = @_;
    my (%fcall_args);
    set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

        unless (defined $server) {
                set_error_codes(1006,"Creating session with the server failed.",$self);
                return;
        }

    if (exists($args{'hsm_group'}) and exists($args{'group_name'})) {
        set_error_codes(1002," Only one member is supported: 'group_name' or 'hsm_group'.",$self);
        return;
    }

    my $hsm_group = exists($args{'hsm_group'}) ? $args{'hsm_group'} : undef;

    #
    if (!$hsm_group and exists($args{'group_name'})) {
        $hsm_group = $self->get(object => "Infoblox::Grid::HSM::Group", name => $args{'group_name'});
        unless ($hsm_group and ref($hsm_group) eq "Infoblox::Grid::HSM::Group") {
            set_error_codes(1002," group_name is not found.",$self);
            return;
        }
    }

    if ($hsm_group and ref($hsm_group) =~ /^Infoblox::Grid::HSM::/) {
        unless ($hsm_group->__object_id__()) {
            set_error_codes(1002," HSM group does not exist in the appliance.",$self);
            return;
        }
        $fcall_args{'group_id'} = tIBType('BaseObject', { object_id => tObjId($hsm_group->__object_id__()) });
    } else {
        set_error_codes(1002," hsm_group is a required member.",$self);
        return;
    }

    eval { $result = $server->ibap_request('TestHsmStatus', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;
    return $result->{'results'};
}

sub refresh_hsm
{
    my ( $self , %args ) = @_;
    my %fcall_args;

    set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

        unless (defined $server) {
                set_error_codes(1006,"Creating session with the server failed.",$self);
                return;
        }

    if (exists($args{'hsm_group'}) and exists($args{'group_name'})) {
        set_error_codes(1002," Only one member is supported: 'group_name' or 'hsm_group'.",$self);
        return;
    }

    my $hsm_group = exists($args{'hsm_group'}) ? $args{'hsm_group'} : undef;

    #
    if (!$hsm_group and exists($args{'group_name'})) {
        $hsm_group = $self->get(object => "Infoblox::Grid::HSM::Group", name => $args{'group_name'});
        unless ($hsm_group and ref($hsm_group) eq "Infoblox::Grid::HSM::Group") {
            set_error_codes(1002," group_name is not found.",$self);
            return;
        }
    }

    if ($hsm_group and ref($hsm_group) =~ /^Infoblox::Grid::HSM::/) {
        unless ($hsm_group->__object_id__()) {
            set_error_codes(1002," HSM group does not exist in the appliance.",$self);
            return;
        }
        $fcall_args{'group_id'} = tIBType('BaseObject', { object_id => tObjId($hsm_group->__object_id__()) });
    } else {
        set_error_codes(1002," hsm_group is a required member.",$self);
        return;
    }

    eval { $result = $server->ibap_request('RefreshHsm', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;
    return $result->{'results'};
}

sub publish_changes{
    my ( $self , %args ) = @_;
    my %fcall_args;

    set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

    if(defined $args{'grid_member'}) {

        unless( defined $args{'services'}){
            set_error_codes(1002, "services is required", $self);
            return;
        }else{
             unless( ($args{'services'} eq 'ALL') or ($args{'services'} eq 'ATP') ){
                set_error_codes(1002, "services should be ALL or ATP", $self);
                return;
                }
        }

        $fcall_args{'grid_member'} = ibap_readfield_simple_string('Member', 'host_name', $args{'grid_member'}, 'member');
        return unless $fcall_args{'grid_member'};

        $fcall_args{'service_option'} = ibap_value_o2i_string(uc($args{'services'}));
        return unless $fcall_args{'service_option'};

        eval { $result = $server->ibap_request('MemberPublishChanges', \%fcall_args); };

    }else{
        if (defined $args{'sequential_delay'}){
            $fcall_args{'sequential_delay'} = ibap_value_o2i_uint($args{'sequential_delay'});
            return unless $fcall_args{'sequential_delay'};
        }
        if (defined $args{'member_order'}){
            $fcall_args{'member_order'} = ibap_value_o2i_string(uc($args{'member_order'}));
            return unless $fcall_args{'member_order'};
            unless( ($args{'member_order'} eq 'SIMULTANEOUSLY') or ($args{'member_order'} eq 'SEQUENTIALLY') ){
                set_error_codes(1002, "member_order should be SIMULTANEOUSLY or SEQUENTIALLY", $self);
                return;
            }
        }
        if (defined $args{'services'}){
            $fcall_args{'service_option'} = ibap_value_o2i_string(uc($args{'services'}));
            return unless $fcall_args{'service_option'};
            unless( ($args{'services'} eq 'ALL') or ($args{'services'} eq 'ATP') ){
                set_error_codes(1002, "services should be ALL or ATP", $self);
                return;
            }
        }
        eval { $result = $server->ibap_request('GridPublishChanges', \%fcall_args); };
    }

    return $server->set_papi_error($@, $session, undef, '1012=1001') if $@;
    return 1;
}

sub get_rpz_threat_details
{
    my ( $self , %args ) = @_;
    my %fcall_args;

    my $server=$self->get_ibap_server() || return;

  	unless (defined $server) {
  		set_error_codes(1006,"Creating session with the server failed.",$self);
  		return;
  	}

    unless (defined($args{'rpz_rule_name'})) {
        set_error_codes(1012, "\"rpz_rule_name\" argument is mandatory",$self);
        return;
    }

    $fcall_args{'rpz_rule_name'} = ibap_value_o2i_string($args{'rpz_rule_name'}, $self, 'rpz_rule_name');
    return unless $fcall_args{'rpz_rule_name'};
    eval { $result = $server->ibap_request('FetchThreatStopDetails', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    my $threat_details_object = Infoblox::Grid::RPZ::ThreatDetails->__new__();
    $threat_details_object->__ibap_to_object__($result);
    return $threat_details_object;
}

sub reset_threat_protection_object {

    #
    #
    #

    my ($self, %args) = @_;
    my ($fname, $fargs) = ('AtpObjectReset', {});

    #
    #
    #

    my %_allowed_atp_obj = (
        'Infoblox::Grid::ThreatProtection::Ruleset'      => 1,
        'Infoblox::Grid::ThreatProtection::RuleCategory' => 1,
        'Infoblox::Grid::ThreatProtection::Rule'         => 1,
    );

    unless ($args{object}) {
        set_error_codes('1012', "'object' is required", $self);
        return 0;
    }

    unless ($_allowed_atp_obj{ref $args{object}}) {

        set_error_codes('1002', "Invalid value for 'object' field. Valid values are: '" .
            (join "', '", keys %_allowed_atp_obj) . "'.", $self);

        return 0;
    }

    if ($args{delete_custom_rules}) {
        unless ($args{delete_custom_rules} =~ /^(true|false)$/) {
            set_error_codes('1002', "Invalid value for 'delete_custom_rules'" .
                " field. Valid value are 'true' and 'false'", $self);
            return 0;
        }
    } else {
        $args{delete_custom_rules} = 'true';
    }

    #
    #
    #

    my %_mappings = (
                     'object'               => 'atp_object',
                     'delete_custom_rules'  => 'delete_custom_rules',
    );

    my %_o2i = (
                'object'               => \&ibap_o2i_object_only_by_oid,
                'delete_custom_rules' => \&ibap_o2i_boolean,
    );


    foreach my $member (keys %args) {

        unless ($_o2i{$member}) {
            set_error_codes('1002', "Invalid argument '$member'.", $self);
            return 0;
        }

        my ($success, $ignore, $res) =
            $_o2i{$member}->($self, $session, $member, \%args);

        return 0 unless $success;
        $$fargs{$_mappings{$member}} = $res unless $ignore;
    }

    #
    #
    #

	set_error_codes(0, undef, $self);
	my $server = $self->get_ibap_server();

    my $result;

    eval {
        $result = $server->ibap_request($fname, $fargs);
    };

    #
    #
    #

    return $server->set_papi_error($@, $self) if $@;
    return 1;

    #
    #
    #
}

sub save_db_snapshot {

    #
    #
    #

    my ($self, %args) = @_;
    my ($fname, $fargs) = ('SaveDBSnapshot', {});

    #
    #
    #

    unless ($args{comment}) {
        set_error_codes('1012', "'comment' is required", $self);
        return 0;
    }

    #
    #
    #

    my ($success, $ignore, $res) =
        ibap_o2i_string($self, $session, 'comment', \%args);

    return 0 unless $success;
    $$fargs{'comment'} = $res unless $ignore;

    #
    #
    #

	set_error_codes(0, undef, $self);
	my $server = $self->get_ibap_server();

    my $result;

    eval {
        $result = $server->ibap_request($fname, $fargs);
    };

    #
    #
    #

    return $server->set_papi_error($@, $self) if $@;
    return 1;

    #
    #
    #
}

sub rollback_db_snapshot {

    #
    #
    #

    my ($self, %args) = @_;
    my ($fname, $fargs) = ('RolloverDBSnapshot', {});

    #
    #
    #

	set_error_codes(0, undef, $self);
	my $server = $self->get_ibap_server();

    my $result;

    eval {
        $result = $server->ibap_request($fname, $fargs);
    };

    #
    #
    #

    return $server->set_papi_error($@, $self) if $@;
    return 1;

    #
    #
    #
}



sub __delete_gss_tsig_keytab
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

    return set_error_codes(1103, "remove_data for keytabs is no longer supported, to remove TSIG keys please remove the KerberosKey object directly", $self);
}

sub __purge_ifmap_data
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
	my $server = $self->get_ibap_server();

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    #
    my $member=$args{'member'};
    if(!defined($member))
    {
       set_error_codes(1012, "Required \"member\" argument missing",$self);
       return;
    }

    $fcall_args{'member'} = ibap_value_o2i_member_nocache($member, $self, 'member');
    my $result;
    eval { $result = $server->ibap_request('PurgeIfmapData', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

sub __clear_nac_cache
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
	my $server = $self->get_ibap_server();

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    #
    my $member=$args{'member'};
    if(!defined($member))
    {
       set_error_codes(1012, "Required \"member\" argument missing",$self);
       return;
    }

    $fcall_args{'member'} = ibap_value_o2i_member_nocache($member, 'member', $self, 'member');

    if (defined $args{'mac_addr'}) {
        $fcall_args{'mac_addr'} = ibap_value_o2i_string($args{'mac_addr'});
    }

    my $result;
    eval { $result = $server->ibap_request('ClearNacAuthCache', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

sub remove_tftp_file
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
	my $server = $self->get_ibap_server();

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    unless (defined($args{'directory'}) && defined($args{'name'})) {
        set_error_codes(1012, "\"name\" and \"directory\" arguments are mandatory",$self);
        return;
    }

    my $result;
    eval { $result = $server->ibap_request
             ('ObjectDelete',
              {
               object_type   => 'TFTPDirFile',
               search_fields => [
                                 {
                                  'field' => ibap_value_o2i_string('directory'),
                                  'value' => ibap_value_o2i_string($args{'directory'}),
                                  'search_type' => ibap_value_o2i_string('EXACT'),
                                 },
                                 {
                                  'field' => ibap_value_o2i_string('name'),
                                  'value' => ibap_value_o2i_string($args{'name'}),
                                  'search_type' => ibap_value_o2i_string('EXACT'),
                                 }
                                ]
              },
             )};

    return $server->set_papi_error($@, $self) if $@;
    return 1;
}

sub __copy_zone_records__
{
    my ( $self , %args ) = @_;
    my (%fcall_args, @call_args);
    my $scheduled_at = $args{'scheduled_at'};
    my %ibap_headers = ();
    my $is_rpz = $args{'is_rpz'};

    my $server = $self->get_ibap_server() || return;

    if ($scheduled_at) {
        $ibap_headers{request_settings}
            = eval {schedule_request($scheduled_at, undef, $scheduled_at_err)};
        return $server->set_papi_error($@, $self) if $@;
    }

    if (defined $args{'zone'} && defined $args{'view'}) {
        my $viewcaller = Infoblox::DNS::View->new(
                                                  name => $args{'view'}
                                                 );

        my $zonecaller = Infoblox::DNS::Zone->new(
                                                  name => $args{'zone'},
                                                  prefix => $args{'prefix'}, # Future proofing
                                                  views => [$viewcaller],
                                                 );
        my %temp_id;
        my $t;
        return unless $t = $zonecaller->__object_id_from_object__($self);
        $fcall_args{'source_zone'} = tObjIdRef($t);
    }

    if (defined $args{'dest_zone'} && defined $args{'dest_view'}) {
        my $viewcaller = Infoblox::DNS::View->new(
                                                  name => $args{'dest_view'}
                                                 );

        my $zonecaller = Infoblox::DNS::Zone->new(
                                                  name => $args{'dest_zone'},
                                                  prefix => $args{'dest_prefix'}, # Future proofing
                                                  views => [$viewcaller],
                                                 );
        my %temp_id;
        my $t;
        return unless $t = $zonecaller->__object_id_from_object__($self);
        $fcall_args{'destination_zone'} = tObjIdRef($t);
    }

    my $replace;
    if (defined $args{'replace_existing_records'}) {
        $fcall_args{'replace_existing_records'} = ibap_value_o2i_boolean($args{'replace_existing_records'}, 'replace_existing_records', $self);
        return unless $fcall_args{'replace_existing_records'};
    }

    my $clear;
    if (defined $args{'clear_dest_zone'}) {
        $fcall_args{'clear_destination_first'} = ibap_value_o2i_boolean($args{'clear_dest_zone'}, 'clear_dest_zone', $self);
        return unless $fcall_args{'clear_destination_first'};
    }

    if (defined $args{'copy_all_rr'}) {
        return unless ibap_value_o2i_boolean($args{'copy_all_rr'}, 'copy_all_rr', $self, 1);
    }

    #
    if ((not defined $args{'copy_all_rr'}) || ($args{'copy_all_rr'} =~ m/false/i) || $args{'copy_all_rr'} eq '0') {
        my @copy_records;

        my $arg_to_sel_records;
        if ($is_rpz)
        {
            $arg_to_sel_records = \%copy_record_arg_to_rule_map;
        }
        else
        {
            $arg_to_sel_records = \%copy_record_arg_to_rr_map;
        }

        foreach my $arg (keys %$arg_to_sel_records)
        {
            if (defined $args{$arg}) {
                return unless ibap_value_o2i_boolean($args{$arg}, $arg, $self, 1);
                if ($args{$arg} =~ m/true/i || $args{$arg} eq '1') {
                    push @copy_records, $arg_to_sel_records->{$arg};
                }
            }
        }
        $fcall_args{'select_records'} = \@copy_records;
    }

    #
    eval { $result = $server->ibap_request($is_rpz ?
                        'CopyRPZRules' : 'CopyZoneRecords', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

sub copy_records
{
    my $self = shift;
    return $self->__copy_zone_records__(@_, is_rpz => 0);
}

sub copy_rpz_records
{
    my $self = shift;
    return $self->__copy_zone_records__(@_, is_rpz => 1);
}

sub __convert_a_host_ptr_to_bulk_host__
{
    my ($self, $zone_oid, $args) = @_;

    my $result;
    my $server = $self->get_ibap_server() || return;

    my %fcall_args;
    $fcallargs{'zone_obj'} = tObjIdRef($zone_oid);

    if (defined $args->{'create_reverse_mapping'}) {
        $fcallargs{'create_reverse_mapping'} = ibap_value_o2i_boolean($args->{'create_reverse_mapping'});
        return unless $fcallargs{'create_reverse_mapping'};
    }

    eval { $result = $server->ibap_request('DiwConvertAPTRHosttoBulkHost', \%fcallargs); };

    return $server->set_papi_error($@, $self) if $@;
    set_error_codes(0,undef,$self);

    return 1;
}

sub set_dhcp_failover_partner_down {

    my ( $self , %args ) = @_;
	my (%fcall_args, $peer_type);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    #
    unless( defined $args{'dhcp_failover'} ) {
        set_error_codes(1002, "dhcp_failover is required", $self);
        return;
    }

    #
    unless( $peer_type = delete $args{'peer_type'} ) {
        set_error_codes(1002, "peer_type is required", $self);
        return;
    }

    if( $peer_type eq 'primary' ) {
        $fcall_args{'peer_type'} = ibap_value_o2i_string('PRIMARY');
    }
    elsif ( $peer_type eq 'secondary' ) {
        $fcall_args{'peer_type'} = ibap_value_o2i_string('SECONDARY');
    }
    else {
        set_error_codes(1002, "peer_type should be 'primary' or 'secondary'", $self );
        return;
    }

    $fcall_args{'failover_association'} = ibap_readfield_simple_string('DhcpFailoverAssoc', 'name', $args{'dhcp_failover'}, '1003=dhcp_failover='.$args{'dhcp_failover'});

    eval { $result = $server->ibap_request('SetPartnerDown', \%fcall_args); };
    return $server->set_papi_error($@, $self, undef, '1012=1001') if $@;

    return 1;
}

sub set_dhcp_failover_secondary_recover {

    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    #
    unless( defined $args{'dhcp_failover'} ) {
        set_error_codes(1002, "dhcp_failover is required", $self);
        return;
    }

    $fcall_args{'failover_association'} = ibap_readfield_simple_string('DhcpFailoverAssoc', 'name', $args{'dhcp_failover'}, '1003=dhcp_failover='.$args{'dhcp_failover'});

    eval { $result = $server->ibap_request('ForceRecoveryState', \%fcall_args); };
    return $server->set_papi_error($@, $self, undef, '1012=1001') if $@;

    return 1;
}

sub get_rpz_members
{
    my ($self, %in_args) = @_;
    my @search_query;

    my %search_arg_rpz_licenced;
    if (defined $in_args{'rpz_licensed'}){
        $search_arg_rpz_licenced{'field'} = 'rpz_licensed';
        return unless $search_arg_rpz_licenced{'value'} = ibap_value_o2i_boolean($in_args{'rpz_licensed'});
        $search_arg_rpz_licenced{'search_type'} = 'EXACT';
        unshift @search_query, \%search_arg_rpz_licenced;
    }

    my %search_arg_rpz_enabled;
    my %search_arg_view;
    if (defined $in_args{'rpz_enabled'}){
        $search_arg_rpz_enabled{'field'} = 'rpz_enabled';
        return unless $search_arg_rpz_enabled{'value'} = ibap_value_o2i_boolean($in_args{'rpz_enabled'});
        $search_arg_rpz_enabled{'search_type'} = 'EXACT';
        unshift @search_query, \%search_arg_rpz_enabled;

        unless (defined $in_args{'view'}){
            $search_arg_view{'field'} = 'view';
            return unless $search_arg_view{'value'} = ibap_readfield_simple('View','is_default',tBool(1),'view=(default view)');
            $search_arg_view{'search_type'} = 'EXACT';
            unshift @search_query, \%search_arg_view;
        }
    }

    if (defined $in_args{'view'}){
        if (!defined $in_args{'rpz_enabled'}){
            set_error_codes(1103, "'rpz_enabled' is required if \'view\' passed." );
            return;
        }
        $search_arg_view{'field'} = 'view';
        return unless $search_arg_view{'value'} = ibap_o2i_view_convert($in_args{'view'});
        $search_arg_view{'search_type'} = 'EXACT';
        unshift @search_query, \%search_arg_view;
    }

    if (scalar(@search_query) == 0)
    {
        set_error_codes(1103, "At least one valid argument is required");
        return;
    }

    my %args;

    $args{'object_type'} = 'MemberStatus';
    $args{'search_fields'} = \@search_query;
    $args{'depth'} = 1;
    $args{'return_fields'} = [
                              tField('member'),
                              tField('virtual_ip'),
                              tField('ipv6_address'),
                              tField('host_name'),
                             ];


    my $result;
    #
    my $server=$self->get_ibap_server() || return;
    eval { $result = $server->ObjectRead(\%args); };
    return $server->set_papi_error($@, $session) if $@;

    my @result_members = ();
    if (scalar(@{$result}) > 0) {
        foreach my $itm (@{$result}){
            my $member = Infoblox::DNS::Member->new(
                name     => $itm->{'host_name'},
                ipv4addr => defined $itm->{'virtual_ip'} ? $itm->{'virtual_ip'} : undef,
                ipv6addr => defined $itm->{'ipv6_address'} ? $itm->{'ipv6_address'} : undef,
                );
            push @result_members, $member;
        }
    }
    return \@result_members;
}


sub remove_eap_ca_cert {

    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    #
    unless( defined $args{'dn'} ) {
        set_error_codes(1002, "dn is required", $self);
        return;
    }

    my $result;
    eval { $result = $server->ibap_request
             ('ObjectDelete',
              {
               object_type   => 'CACertificate',
               search_fields => [
                                 {
                                  'field' => ibap_value_o2i_string('subject'),
                                  'value' => ibap_value_o2i_string($args{'dn'}),
                                  'search_type' => ibap_value_o2i_string('EXACT'),
                                 },
                                ]
              },
             )};

    return $server->set_papi_error($@, $self) if $@;
    return 1;
}

sub delete_all_licenses_by_type {

    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    #
    unless( defined $args{'type'} ) {
        set_error_codes(1002, "type is required", $self);
        return;
    }

    my $result;
    eval { $result = $server->ibap_request
             ('ObjectDelete',
              {
               object_type   => 'License',
               search_fields => [
                                 {
                                  'field' => ibap_value_o2i_string('type'),
                                  'value' => ibap_value_o2i_string($args{'type'}),
                                  'search_type' => ibap_value_o2i_string('EXACT'),
                                 },
                                ]
              },
             )};

    return $server->set_papi_error($@, $self) if $@;
    return 1;
}

sub grid_upgrade
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    unless( defined $args{'action'} ) {
        set_error_codes(1002, "action is required", $self);
        return;
    }

    unless( $args{'action'} =~ m/^UPGRADE_PAUSE|UPGRADE_RESUME|DISTRIBUTION_PAUSE|DISTRIBUTION_RESUME|DISTRIBUTION_START|DISTRIBUTION_STOP|DOWNGRADE|REVERT|UPGRADE|UPGRADE_TEST_START|UPGRADE_TEST_STOP|UPLOAD$/i ) {
        set_error_codes(1002, "$args{'action'} is not a supported action", $self);
        return;
    }

    $fcall_args{'action'} = tString(uc($args{'action'}));

    eval { $result = $server->ibap_request('GridUpgrade', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

sub set_serial_number
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    unless( defined $args{'serial_number'} ) {
        set_error_codes(1002, "serial_number is required", $self);
        return;
    }

    unless( defined $args{'secret'} ) {
        set_error_codes(1002, "secret is required", $self);
        return;
    }

    $fcall_args{'serial_number'} = tString($args{'serial_number'});
    $fcall_args{'secret'} = tString($args{'secret'});

    eval { $result = $server->ibap_request('SetUnitSerialNumber', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

sub get_if_mac_address
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    unless( defined $args{'interface'} ) {
        set_error_codes(1002, "interface is required", $self);
        return;
    }

    unless( $args{'interface'} =~ m/^LAN|LAN2|MGMT|HA$/i ) {
        set_error_codes(1002, "$args{'interface'} is not a supported interface", $self);
        return;
    }

    $fcall_args{'interface'} = tString(uc($args{'interface'}));

    eval { $result = $server->ibap_request('GetIfMacAddress', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    return $result->{'mac_address'};
}

sub node_admin_operation
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    unless( defined $args{'operation'} ) {
        set_error_codes(1002, "operation is required", $self);
        return;
    }

    unless( defined $args{'member'} ) {
        set_error_codes(1002, "member is required", $self);
        return;
    }

    unless( defined $args{'node_type'} ) {
        set_error_codes(1002, "node_type is required", $self);
        return;
    }

    unless( $args{'operation'} =~ m/^REBOOT|RESTART_PRODUCT|SHUTDOWN$/i ) {
        set_error_codes(1002, "$args{'operation'} is not a supported operation", $self);
        return;
    }

    unless( $args{'node_type'} =~ m/^ACTIVE|BOTH|PASSIVE$/i ) {
        set_error_codes(1002, "$args{'node_type'} is not a supported node_type", $self);
        return;
    }

    $fcall_args{'node_type'} = tString(uc($args{'node_type'}));
    $fcall_args{'operation'} = tString(uc($args{'operation'}));
    $fcall_args{'member'} = ibap_readfield_simple_string('Member', 'host_name', $args{'member'}, 'member');

    eval { $result = $server->ibap_request('NodeAdminOperation', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

sub skip_member_upgrade
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

    unless( defined $args{'member'} ) {
        set_error_codes(1002, "member is required", $self);
        return;
    }

    $fcall_args{'member'} = ibap_readfield_simple_string('Member', 'host_name', $args{'member'}, 'member');

    eval { $result = $server->ibap_request('SkipMemberUpgrade', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

sub member_upgrade
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

    unless( defined $args{'member'} ) {
        set_error_codes(1002, "member is required", $self);
        return;
    }

    $fcall_args{'member'} = ibap_readfield_simple_string('Member', 'host_name', $args{'member'}, 'member');

    if( defined $args{'action'} ) {
        unless ($args{'action'} =~ m/^UPGRADE|REVERT$/) {
            set_error_codes(1002, "unsupported action " .$args{'action'}, $self);
            return;
        }
    }

    if (defined $args{'action'} && $args{'action'} && $args{'action'} eq 'REVERT') {
        eval { $result = $server->ibap_request('MemberRevert', \%fcall_args); };
    }
    else {
        eval { $result = $server->ibap_request('MemberUpgrade', \%fcall_args); };
    }
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

sub get_grid_revert_status
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

    eval { $result = $server->ibap_request('GetGridRevertStatus', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    my %results_hash =
      (
       revert_allowed => 'false',
       revert_version => '',
      );

    $results_hash{'revert_allowed'} = ibap_value_i2o_boolean($result->{'revert_allowed'}) if defined $result->{'revert_allowed'};
    $results_hash{'revert_version'} = $result->{'revert_version'} if defined $result->{'revert_version'};

    return \%results_hash;
}

sub upgrade_group_now
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

    unless( defined $args{'group_name'} ) {
        set_error_codes(1002, "group_name is required", $self);
        return;
    }

    $fcall_args{'group_name'} = ibap_value_o2i_string($args{'group_name'});

    eval { $result = $server->ibap_request('UpgradeGroupNow', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

sub member_admin_operation
{
    my ( $self , %args ) = @_;
	my (%fcall_args);

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

	unless (defined $server) {
		set_error_codes(1006,"Creating session with the server failed.",$self);
		return;
	}

    unless( defined $args{'operation'} ) {
        set_error_codes(1002, "operation is required", $self);
        return;
    }

    unless( defined $args{'member'} ) {
        set_error_codes(1002, "member is required", $self);
        return;
    }

    unless( $args{'operation'} =~ m/FORCE_FAILOVER/i ) {
        set_error_codes(1002, "$args{'operation'} is not a supported operation", $self);
        return;
    }

    $fcall_args{'operation'} = tString(uc($args{'operation'}));
    $fcall_args{'member'} = ibap_readfield_simple_string('Member', 'host_name', $args{'member'}, 'member');

    eval { $result = $server->ibap_request('MemberAdminOperation', \%fcall_args); };
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

#

#
sub __network_discovery_method{

    my ($self , $function_name , %args) = @_;

    my $result;
    my %call_args;
    my $type;

    my $server = $self->get_ibap_server() || return;

    $type = $args{'type'};

    if( defined $type ) {
        if( 'GLOBAL' eq uc($type) ) {
            $call_args{'scope'} = 'GLOBAL';
        }
        elsif( 'NETWORK' eq uc($type) ) {
            $call_args{'scope'} = 'NETWORK';
        }
        elsif( 'IP_ADDRESS' eq uc($type) ) {
            $call_args{'scope'} = 'IP_ADDRESS';
        }
        else {
            set_error_codes(1002, "'$type' is invalid for argument 'type'");
            return;
        }

        if( 'GLOBAL' eq uc($type) ) {
            my $network_view = $args{'network_view'};
            if( defined $network_view ) {
                $call_args{'network_view'} = ibap_readfield_simple_string('NetworkView', 'name', $network_view->{name},undef,'EXACT');
            }
            else {
                $call_args{'network_view'} = ibap_readfield_simple('NetworkView','is_default',tBool(1),'network_view=(default network view)'),
            }
        }

        if( 'NETWORK' eq uc($type) or 'IP_ADDRESS' eq uc($type) ) {
            my $network = $args{'network'};
            if( defined $network ) {
                #
                #
                #
                my (%search_arg_address, %search_arg_netmask, @search_query);
                my ($network_address, $network_mask, $network_id);
                my $network_type;
                ($network_type,$network_address, $network_mask) = ip_address_munger($network,1);

                if(!$network_type) {
                    set_error_codes(1002, "Network $network is not valid");
                    return;
                }


                my %search_args =(
                                  'address' => tString($network_address),
                                 );


                my $network_view = $args{'network_view'};
                if ($network_view && $network_view->name()) {
                    $search_args{'network_view'} = ibap_readfield_simple_string('NetworkView','name',$network_view->name(),'network_view');
                }
                else {
                    $search_args{'network_view'} = ibap_readfield_simple('NetworkView','is_default',tBool(1),'network_view=(default network view)'),
                }
                if($network_type == 1){ #IPv4
                    $search_args{'netmask'} = ibap_value_o2i_string($network_mask);
                    #
                    $network_id = ibap_get_object_id($self, 'Network', \%search_args);
                }else{ #IPv6
                    $search_args{'cidr'} = ibap_value_o2i_uint($network_mask);
                    $network_id = ibap_get_object_id($self, 'IPv6Network',\%search_args);
                }

                if( defined $network_id ) {
                    #
                    $call_args{'network'} = tObjIdRef($network_id);
                }
                else {
                    return;
                }
            }
            else
            {
                unless( 'IP_ADDRESS' eq uc($type) && is_ipv6_address($args{'ip_address'}))
               {
                set_error_codes(1002, "'network' is required if 'type' is set to 'NETWORK' or 'IP_ADDRESS'");
                return;
               }
            }
        }

        if( 'IP_ADDRESS' eq uc($type) ) {
            my $ip_address = $args{'ip_address'};
            if( defined $ip_address) {

                $call_args{'ip_address'} = ibap_value_o2i_string($ip_address);
            }
            else {
                set_error_codes(1002, "'ip_address' is required if 'type' is set to 'IP_ADDRESS'");
                return;
            }

        }

    }
    else {
        set_error_codes(1002, "'type' is required");
        return;
    }

    eval { $result = $server->ibap_request($function_name, \%call_args); };
    return $server->set_papi_error($@, $self) if $@;

    set_error_codes(0, undef, $self);
    return 1;
}

#
sub clear_unmanaged {

    my ($self, %args) = @_;

    return $self->__network_discovery_method("ClearUnmanagedAddress", %args);
}

#
#
sub reset_discovery_timestamp{

    my ($self, %args) = @_;

    return $self->__network_discovery_method("ClearDiscoveredTimestamp", %args);
}

#
sub reset_discovery_data{

    my ($self, %args) = @_;

    return $self->__network_discovery_method("ClearAllDiscoveredData", %args);
}

#
sub network_discovery_control {

    my ($self, %args) = @_;
    my $result;
    my %call_args;
    my $action;
    my $discovery_task_id;

    my $server = $self->get_ibap_server() || return;

    #
    my $ref_allowed_arguments = {
        action       => 1,
        network      => 0,
        scheduled_at => 0,
        };
    return unless $self->__validate_arguments_from_arg_list__($ref_allowed_arguments, \%args);

    #
    $action = uc($args{'action'});

    if( $action ne 'START' &&
        $action ne 'PAUSE' &&
        $action ne 'RESUME' &&
        $action ne 'END' ) {
        set_error_codes(1002, "Invalid value for 'action'" , $self);
        return;
    }
    else {
        $call_args{'action'}=tString($action);
    }

    #
    #
    $discovery_task_id = ibap_get_object_id( $self, 'DiscoveryTask');

    if( defined($discovery_task_id) ) {
        $call_args{'task'} = tObjIdRef($discovery_task_id);
    }
    else {
        return;
    }

    my $scheduled_at = $args{'scheduled_at'};
    my %ibap_headers = ();

    if ($scheduled_at) {
        $ibap_headers{request_settings}
            = eval {schedule_request($scheduled_at, undef, $scheduled_at_err)};
        return $server->set_papi_error($@, $self) if $@;
    }

    eval {$result = $server->ibap_request('NetworkDiscoveryControl', \%call_args, \%ibap_headers);};
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}


#
sub __vdiscovery_control__ {
    my ($self, $id, %args) = @_;
    my $server = $self->get_ibap_server() || return;
    my $ref_allowed_arguments = {
        action => 1,
    };
    my %action_values = (
        START => 1,
        CANCEL => 1,
    );

    return unless $self->__validate_arguments_from_arg_list__($ref_allowed_arguments, \%args);

    unless (defined $args{action} and $action_values{$args{action}}) {
        set_error_codes(1001, 'The argument "action" has incorrect value.', $self);
        return;
    }

    my %rargs = (
        task => {object_id => tObjId($id)},
        action => $args{action},
    );

    eval {
        $server->ibap_request('CDiscoveryControl', \%rargs);
    };

    if ($@) {
        $server->set_papi_error($@, $self);
        return undef;
    }
    set_error_codes(0, undef, $self);

    return 1;
}

sub csv_import_control {

    my ($self, %args) = @_;
    my $result;
    my %call_args;
    my $action;
    my $discovery_task_id;

	set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

    my $ref_allowed_arguments = {
        action    => 1,
        import_id => 0,
        };
    return unless $self->__validate_arguments_from_arg_list__($ref_allowed_arguments, \%args);

    if( $args{'action'} !~ m/stop/i) {
        set_error_codes(1002, 'Invalid value "' . $args{'action'}. '" for "action"' , $self);
        return;
    }

    if ($args{'import_id'}) {
        $call_args{'import_id'} = tUInteger($args{'import_id'});
    } else {
        warn "Calling csv_import_control without import_id is deprecated.";
    }

    eval {$result = $server->ibap_request('StopCSVImport', \%call_args);};
    return $server->set_papi_error($@, $self) if $@;

    return 1;
}

sub clear_dns_cache {

    my ($self, %args) = @_;
    my ($fname, $fargs) = ('ClearDnsCache', {});

    #
    #
    #

    my $ref_allowed_arguments = {
        'member'          => {mandatory => 1, validator => \&ibap_value_o2i_ipv4addr},
        'domain'          => {validator => \&ibap_value_o2i_string},
        'view'            => {validator => \&ibap_value_o2i_string},
        'clear_full_tree' => {validator => \&ibap_value_o2i_boolean},
    };

    return 0 unless $self->__validate_arguments_from_arg_list__(
        $ref_allowed_arguments, \%args);


    my $server = $self->get_ibap_server() || return;

    #
    #
    #

    #

    my $ref_object_to_ibap = {
        'domain'          => \&ibap_o2i_string,
        'view'            => \&ibap_o2i_view,
        'clear_full_tree' => \&ibap_o2i_boolean,
        'member'          => sub {
                                my ($self, $session, $current, $tempref) = @_;
                                (1, 0, ibap_readfield_simple_string(
                                        'Member', 'virtual_ip', $$tempref{$current}, $current));
                           },

    };

    #

    foreach my $field (keys %$ref_object_to_ibap) {

        if ($args{$field}) {

            my @res = $$ref_object_to_ibap{$field}->(
                $self, $session, $field, \%args
            );

            return undef unless (@res and $res[0]);

            $$fargs{$field} = $res[2] if $res[2];
        }
    }

    #

    eval {
        $result = $server->ibap_request(
            $fname, $fargs, \%ibap_headers
        );
    };

    #

    return $server->set_papi_error($@, $self) if $@;
    set_error_codes(0, undef, $self);

    return 1;
}


#
sub __resize_network_or_container__ {
    my ($self, $id, $args_ref, $gog) = @_;
    my $result;
    my $server = $self->get_ibap_server() || return;

    unless ($id) {
        set_error_codes(1001,'In order to resize the network/network container, the object must have been retrieved from the server first', $self);
        return;
    }

    #
    my $prefix = $$args_ref{prefix};
    unless (defined $prefix) {
        set_error_codes(1002, "'prefix' is required");
        return;
    }

    my %args = (
                network => { object_id => tObjId($id) },
                prefix => $prefix,
                );

    #
    my $acrz = $$args_ref{auto_create_reversezone};
    $args{'auto_create_reversezone'} = ibap_value_o2i_boolean($acrz)
        if (defined $acrz);

    #
    $args{'reason'} = ibap_value_o2i_string($$args_ref{'reason'}) if defined $$args_ref{'reason'};
    if (defined $$args_ref{'send_rir_request'}) {
        $args{'send_rir_request'} = ibap_value_o2i_boolean($$args_ref{'send_rir_request'});
        return unless $args{'send_rir_request'};
    }

    #
    if ($gog) {
        eval { $result = $server->ibap_request('ResizeSubGridNetwork', \%args); };
    }
    else {
        eval { $result = $server->ibap_request('Resize', \%args); };
    }
    return $server->set_papi_error($@, $self) if $@;

    set_error_codes(0, undef, $self);
    return 1;
}

#
sub __traffic_capture__ {
    my ($self, $id, $args) = @_;
    my $result;
    my $server = $self->get_ibap_server() || return;

    unless ($id) {
        set_error_codes(1001,'In order to control traffic capture the member object must have been retrieved from the server first', $self);
        return;
    }

    my %rargs = (
                 member => {object_id => tObjId($id)}
                );

    if ($args) {
        #
        unless (ref($args) eq 'Infoblox::Grid::Member::Capture::Control') {
            set_error_codes(1001,'Invalid parameter type for traffic_capture.', $self);
            return;
        }

        my $o2i = $args->__object_to_ibap__($server, $self);

        foreach (@$o2i) {
            $rargs{$_->{'field'}} = $_->{'value'};
        }

        eval {
            $result = $server->ibap_request('CaptureTrafficControl', \%rargs);
        };

        if ($@) {
            $server->set_papi_error($@, $self);
            return undef;
        }
        set_error_codes(0,undef,$self);
        return 1;
    }
    else {
        #
        eval {
            $result = $server->ibap_request('CaptureTrafficStatus', \%rargs);
        };

        if ($@) {
            $server->set_papi_error($@, $self);
            return undef;
        }
        set_error_codes(0,undef,$self);

        my $result_object = Infoblox::Grid::Member::Capture::Status->__new__();
        $result_object->__ibap_to_object__($result, $server, $self);

        return $result_object;
    }
}

#
sub __create_token__ {
    my ($self, $id, %args) = @_;
    my $result;
    my $server = $self->get_ibap_server() || return;

    my %rargs = (member => {object_id => tObjId($id)});

    eval {
        $result = $server->ibap_request('CreateToken', \%rargs);
    };

    if ($@) {
        $server->set_papi_error($@, $self);
        return undef;
    }
    return undef unless defined $$result{'pnode_token'};
    set_error_codes(0, undef, $self);

    my @pnode_tokens;
    for my $pn_token (@{$$result{'pnode_token'}}) {
        my $result_object = Infoblox::Grid::Member::PNodeToken->__new__();
        $result_object->__ibap_to_object__($pn_token, $server, $self);
        push @pnode_tokens, $result_object;
    }

    return \@pnode_tokens;
}

#
sub __read_token__ {
    my ($self, $id, %args) = @_;
    my $result;
    my $server = $self->get_ibap_server() || return;

    my %rargs = (member => {object_id => tObjId($id)});

    eval {
        $result = $server->ibap_request('ReadToken', \%rargs);
    };

    if ($@) {
        $server->set_papi_error($@, $self);
        return undef;
    }
    return undef unless defined $$result{'pnode_token'};
    set_error_codes(0, undef, $self);

    my @pnode_tokens;
    for my $pn_token (@{$$result{'pnode_token'}}) {
        my $result_object = Infoblox::Grid::Member::PNodeToken->__new__();
        $result_object->__ibap_to_object__($pn_token, $server, $self);
        push @pnode_tokens, $result_object;
    }

    return \@pnode_tokens;
}

sub __allocate_licenses__ {
    my ($self, $id, %args) = @_;
    my $result;
    my $server = $self->get_ibap_server() || return;
    my @license_pools;
    my $ref_allowed_arguments = {
        license_pools => 0,
        hwid => 0,
    };

    unless (%args and defined($args{license_pools}) and defined($args{hwid})) {
        set_error_codes(1001, 'In order to allocate licenses the license pool and hardware id must be provided.', $self);
        return;
    }

    return unless $self->__validate_arguments_from_arg_list__($ref_allowed_arguments, \%args);

    if (ref($args{hwid}) ne '') {
        set_error_codes(1001, 'The argument "hwid" has incorrect type.', $self);
        return;
    }

    if (ref($args{license_pools}) ne 'ARRAY' or scalar(@{$args{license_pools}}) == 0) {
        set_error_codes(1001, 'The argument "license_pools" has incorrect type.', $self);
        return;
    }

    for my $pool (@{$args{license_pools}}) {
        if (ref($pool) ne 'Infoblox::Grid::LicensePool') {
            set_error_codes(1001, 'The argument "license_pools" has incorrect value.', $self);
            return;
        }
        if ($pool->__object_id__()) {
            push @license_pools, tObjIdRef($pool->__object_id__());
        } else {
            set_error_codes(1001,
                'In order to allocate licenses the object license pool must have been retrieved from the server first.',
                $self);
            return;
        }
    }

    my %rargs = (
        hwid => ibap_value_o2i_string($args{hwid}),
        license_pools => tIBType('ArrayOfBaseObject', \@license_pools),
    );

    eval {
        $result = $server->ibap_request('AllocateLicenses', \%rargs);
    };

    if ($@) {
        $server->set_papi_error($@, $self);
        return undef;
    }

    return $result;
}

sub __download_pool_status__ {

    my ($self, $id, %args) = @_;
    my $result;
    my $server = $self->get_ibap_server() || return;
    my %rargs;

    eval {
        $result = $server->ibap_request('BackupLicenses', \%rargs);
    };

    if ($@) {
        $server->set_papi_error($@, $self);
        return undef;
    }

    return $result->{'data_ref'}->{'url'};
}

#
sub __next_available_ip__ {
    my ($self, $id, %args) = @_;
    my $result;
    my $server = $self->get_ibap_server() || return;

    unless ($id) {
        set_error_codes(1001,'In order to get the next available ip the object must have been retrieved from the server first', $self);
        return;
    }

    my %rargs = (
                 parent => {object_id => tObjId($id)}
                );

    if (defined $args{'requested_num'}) {
        $rargs{'requested_num'} = ibap_value_o2i_uint($args{'requested_num'});
        return unless $rargs{'requested_num'};
    }

    if (defined $args{'excluded'} && $args{'excluded'} && scalar(@{$args{'excluded'}})) {
        my $submit_list = ibap_o2i_ipaddr_list_helper($self,$args{'excluded'});
        return unless $submit_list;
        $rargs{'exclude'} = tIBType('ArrayOfIPAddress', $submit_list);
    }

    eval {
        $result = $server->ibap_request('NextAvailableIp', \%rargs);
    };

    if ($@) {
        $server->set_papi_error($@, $self);
        return undef;
    }
    set_error_codes(0,undef,$self);

    #
    #
    #
    if ($args{'requested_num'}) {
        return $result->{'result'};
    }
    else {
        if ($result->{'result'} && ref($result->{'result'}) eq 'ARRAY' && scalar(@{$result->{'result'}}) > 0) {
            return @{$result->{'result'}}[0];
        }
        else {
            return;
        }
    }
}

sub __next_available_network__ {
    my ($self, $id, $obj, %args) = @_;
    my $result;
    my $server = $self->get_ibap_server() || return;

    #
    unless ($id && $obj->network_view() && $obj->network_view()->__object_id__()) {
        set_error_codes(1001,'In order to get the next available network the object must have been retrieved from the server first', $self);
        return;
    }

    my ($address, $cidr) = split('/', $obj->network());
    my %rargs = (
                 parent_address => tIBType('IPAddress', $address),
                 parent_cidr    => ibap_value_o2i_uint($cidr),
                 network_view   => {object_id => tObjId($obj->network_view()->__object_id__())},
                );


    unless (defined $args{'cidr'}) {
        set_error_codes(1001,'"cidr" must be set when calling next_available_network', $self);
        return;
    }
    $rargs{'cidr'} = ibap_value_o2i_uint($args{'cidr'});

    if (defined $args{'requested_num'}) {
        $rargs{'requested_num'} = ibap_value_o2i_uint($args{'requested_num'});
        return unless $rargs{'requested_num'};
    }

    if (defined $args{'excluded'} && $args{'excluded'} && scalar(@{$args{'excluded'}})) {
        my $submit_list = ibap_o2i_addresscidr_list_helper($self,$args{'excluded'});
        return unless $submit_list;
        $rargs{'exclude'} = tIBType('ArrayOfaddr_cidr', $submit_list);
    }

    eval {
        $result = $server->ibap_request('NextAvailableNetwork', \%rargs);
    };

    if ($@) {
        $server->set_papi_error($@, $self);
        return undef;
    }
    set_error_codes(0,undef,$self);

    my @munged_result;
    if ($result->{'result'} && ref($result->{'result'}) eq 'ARRAY' && scalar(@{$result->{'result'}}) > 0) {
        foreach (@{$result->{'result'}}) {
            push @munged_result, join('/',$_->{'address'},$_->{'cidr'});
        }
    }

    #
    #
    #
    if ($args{'requested_num'}) {
        return \@munged_result;
    }
    else {
        if (scalar(@munged_result)) {
            return $munged_result[0];
        }
        else {
            return;
        }
    }
}

sub __dnssec_operation__
{
    my ($self,$obj_id, $operation)=@_;

    my $result;
    my $server = $self->get_ibap_server() || return;

    unless ($obj_id) {
        set_error_codes(1001,'In order to sign the zone the object must have been retrieved from the server first', $self);
        return;
    }

    eval {
        $result = $server->ibap_request('DnsSecOperation',
                                    { zones => [{object_id => tObjId($obj_id)}], operation => tString($operation) });
    };

    return $server->set_papi_error($@, $self) if $@;
    set_error_codes(0,undef,$self);
    return 1;
}


sub __import_ds_records__
{
  my ($self, %args)=@_;
  my $buffer;

  return set_error_codes(1103, "zone is required", $self) unless ($args{'zone'});


  #
  local *DATAFILE;
  local $/=undef;
  unless(open(DATAFILE, '<', $args{'path'}))
  {
    set_error_codes(1001, "Cannot open ". $args{'path'}." $!", $self);
    return;
  }
  #
  $buffer=<DATAFILE>;
  close DATAFILE;

  #
  my $zone_readfield=ibap_arg_zone_convert($session, 'zone', {zone => $args{'zone'}, view => $args{'view'}});
  return unless(defined($zone_readfield));


  my $result;
  my $server = $self->get_ibap_server() || return;

  eval {
      $result = $server->ibap_request('DnsSecOperation',
                                  { zones => [$zone_readfield], operation => tString('IMPORT_DS'), buffer => tString($buffer) });
  };

  return $server->set_papi_error($@, $self) if $@;
  set_error_codes(0,undef,$self);
  return 1;

}

sub __move_subnets__ {

    my ($self, $site, %args) = @_;
    my ($fargs, $fname) = ({}, 'MsAdSitesMoveSubnets');
    my ($success, $ignore, $domain, @fields);

    return set_error_codes(1103, "'networks' is required", $self) unless ($args{'networks'});

    ($success, $ignore, $fargs->{'networks'}) = ibap_o2i_network_list($self, $session, 'networks', \%args);
    return unless defined $fargs->{'networks'};

    ($success, $ignore, $domain) = ibap_o2i_ms_adsites_domain($self, $session, 'domain', $site);
    return unless defined $domain;

    @fields = (
        {
            'search_type' => 'EXACT',
            'field'       => 'name',
            'value'       => ibap_value_o2i_string($site->name()),
        },
        {
            'search_type' => 'EXACT',
            'field'       => 'parent',
            'value'       => $domain,
        },
    );

    $fargs->{'destination_site'} = tIBType('BaseObject',
        ibap_readfieldlist_simple('MsAdSitesSite', \@fields, undef, 'EXACT', 'readfield_substitution'));

    return unless defined $fargs->{'destination_site'};

    my $result;
    my $server = $self->get_ibap_server() || return;

    eval {
        $result = $server->ibap_request($fname, $fargs);
    };

    return $server->set_papi_error($@, $self) if $@;
    return 1;
}

sub get_ms_ad_dc_ns_record_creation_list {

    my ($self, %args) = @_;
    my ($fargs, $fname) = ({}, 'GetMsAdDcNsRecordCreationList');

    my %_query_type_enum = (
        'SERVERS_IN_DOMAIN'      => 1,
        'SERVERS_IN_ROOT_DOMAIN' => 1,
        'ZONE'                   => 1,
    );

    #

    if ($args{zone} and $args{ms_server}) {
        set_error_codes('1103', "Cannot set both 'zone' and 'ms_server' arguments.", $self);
        return 0;
    }

    if ($args{query_type} and not $_query_type_enum{$args{query_type}}) {
        set_error_codes('1103', "Invalid 'query_type' value. The valid values are: '" .
            (join "', '", keys %_query_type_enum) . "'.", $self);

        return 0;
    }

    if ($args{zone}) {

        unless (ref $args{zone} eq 'Infoblox::DNS::Zone') {
            set_error_codes('1001', "Invalid parameter type for 'zone' argument.", $self);
            return 0;
        }

        if ($args{query_type} and $args{query_type} ne 'ZONE') {
            set_error_codes('1001', "Incompatible 'query_type' for 'zone' argument. " .
                "The valid value is 'ZONE'.", $self);
            return 0;
        }

        $args{query_type} = 'ZONE';

    } elsif ($args{ms_server}) {

        unless (ref $args{ms_server} eq 'Infoblox::Grid::MSServer') {
            set_error_codes('1001', "Invalid parameter type for 'ms_server' argument.", $self);
            return 0;
        }

        if ($args{query_type}                             and
            $args{query_type} ne 'SERVERS_IN_DOMAIN'      and
            $args{query_type} ne 'SERVERS_IN_ROOT_DOMAIN'
        ) {
            set_error_codes('1001', "Incompatible 'query_type' for 'ms_server' argument. " .
                "The valid values are 'SERVERS_IN_DOMAIN' and 'SERVERS_IN_ROOT_DOMAIN'.", $self);
            return 0;
        }

        $args{query_type} = 'SERVERS_IN_DOMAIN' unless $args{query_type};

    } else {
        set_error_codes('1001', 'At least one of arguments: \'ms_server\', \'zone\' is required', $self);
        return 0;
    }

    #

    my %_args_o2i = (
        'query_type' => \&ibap_o2i_string,
        'zone'       => \&ibap_o2i_object_only_by_oid,
        'ms_server'  => \&ibap_o2i_object_only_by_oid,
    );

    foreach my $member (keys %args) {

        unless ($_args_o2i{$member}) {
            set_error_codes('1001', 'Argument ' . $member . ' is incorrect.', $self);
            return 0;
        }

        my ($success, $ignore, $res) =
            $_args_o2i{$member}->($self, $session, $member, \%args);

        return 0 unless $success;
        $$fargs{$member} = $res unless $ignore;
    }

    #

    my $result;
    my $server = $self->get_ibap_server() || return;

    eval {
        $result = $server->ibap_request($fname, $fargs);
    };

    return $server->set_papi_error($@, $self) if $@;
    set_error_codes(0, undef, $self);

    if (ref $result eq 'ib:GetMsAdDcNsRecordCreationListResponse' and
        ref $result->{ms_dc_ns_record_creation} eq 'ARRAY') {
        my @ret;
        foreach (@{$result->{ms_dc_ns_record_creation}}) {
            my $t = Infoblox::Grid::MSServer::DCNSRecordCreation->__new__();
            $t->__ibap_to_object__($_, $server, $self);

            push @ret, $t;
        }
        return \@ret;
    } else {
        return [];
    }
}


sub __test_credential__ {
    my ($self, $oid, %args) = @_;

    my $allowed_args = {
        'id'      => 'GetCredentialStatus',
        'start'   => 'GetCredentialStatus',
        'view'    => 'TestCredential',
        'type'    => 'TestCredential',
        'device'  => 'TestCredential',
        'member'  => 'TestCredential',
        'address' => 'TestCredential',
        'cli_credentials'  => 'TestCredential',
        'snmp_credential'  => 'TestCredential',
        'snmp3_credential' => 'TestCredential',
    };

    my $fname = defined $args{'id'} ? 'GetCredentialStatus' : 'TestCredential';
    my $fargs = {};

    foreach (keys(%args)) {
        if ($allowed_args->{$_}) {
            return set_error_codes(1002, "'$_' is not supported when 'id' is ".(defined $args{'id'} ? '' : 'not ')."defined") if $allowed_args->{$_} ne $fname
        } else {
            return set_error_codes(1002, "'$_' is not supported");
        }
    }

    if ($fname eq 'GetCredentialStatus') {
        $fargs->{'id'} = ibap_value_o2i_string($args{'id'});
        return unless $fargs->{'id'};

        if (defined $args{'start'}) {
            $fargs->{'start'} = ibap_value_o2i_string($args{'start'});
            return unless $fargs->{'start'};
        }
    } else {
        $fargs->{'parent'} = tObjIdRef($oid);
        return unless $fargs->{'parent'};

        if (!defined $args{'address'} and !defined $args{'device'}) {
            return set_error_codes(1012, "'address' or 'device' is required");
        } elsif (defined $args{'address'} and defined $args{'device'}) {
            return set_error_codes(1105, "Cannot define 'address' and 'device' at the same time");
        }

        if (defined $args{'address'}) {
            $fargs->{'address'} = ibap_value_o2i_ipaddr($args{'address'});
            return unless $fargs->{'address'};
        }

        my $count = 0;

        if (defined $args{'cli_credentials'}) {
            if (ref($args{'cli_credentials'}) ne 'ARRAY') {
                return set_error_codes(1104, 'Invalid data type '.ref($args{'cli_credentials'}).' for member cli_credentials');
            }
            foreach (@{$args{'cli_credentials'}}) {
                if (ref($_) ne 'Infoblox::Grid::Discovery::CLICredential') {
                    return set_error_codes(1104, 'Invalid data type '.ref($args{'cli_credentials'}).' for member cli_credentials');
                }
            }
            $fargs->{'cli_credentials'} = ibap_serialize_substruct_list($self, $args{'cli_credentials'}, Infoblox::Grid::Discovery::CLICredential::__ibap_object_type__());
            return unless $fargs->{'cli_credentials'};
            $count++;
        }

        if (defined $args{'device'}) {
            if (ref($args{'device'}) ne 'Infoblox::Grid::Discovery::Device') {
                return set_error_codes(1104, 'Invalid data type '.ref($args{'device'}).' for member device');
            }
            if ($args{'device'}->__object_id__()) {
                $fargs->{'device'} = tObjIdRef($args{'device'}->__object_id__());
            } elsif ($args{'device'}->address()) {
                $fargs->{'device'} = ibap_readfield_simple_string($args{'device'}->__ibap_object_type__(), 'address', $args{'device'}->address());
            } else {
                return set_error_codes(1012, 'The '.ref($args{'device'})." object must be retrieved from the appliance or 'address' member must be defined before setting it");
            }
            return unless $fargs->{'device'};
        }

        if (defined $args{'member'}) {
            $fargs->{'discovery_member'} = ibap_readfield_simple_string('Member', 'host_name', $args{'member'});
            return unless $fargs->{'discovery_member'};
        }

        if (defined $args{'view'}) {
            $fargs->{'network_view'} = ibap_readfield_simple_string('NetworkView', 'name', $args{'view'});
        } else {
            $fargs->{'network_view'} = ibap_readfield_simple('NetworkView', 'is_default', tBool(1), 'network_view=(default network view)');
        }
        return unless $fargs->{'network_view'};

        if (defined $args{'snmp_credential'}) {
            if (ref($args{'snmp_credential'}) ne 'Infoblox::Grid::Discovery::SNMPCredential') {
                return set_error_codes(1104, 'Invalid data type '.ref($args{'snmp_credential'}).' for member snmp_credential');
            }
            $fargs->{'snmpv1v2_credential'} = ibap_serialize_substruct($self, $args{'snmp_credential'}, Infoblox::Grid::Discovery::SNMPCredential::__ibap_object_type__());
            return unless $fargs->{'snmpv1v2_credential'};
            $count++;
        }

        if (defined $args{'snmp3_credential'}) {
            if (ref($args{'snmp3_credential'}) ne 'Infoblox::Grid::Discovery::SNMP3Credential') {
                return set_error_codes(1104, 'Invalid data type '.ref($args{'snmp3_credential'}).' for member snmp3_credential');
            }
            $fargs->{'snmpv3_credential'} = ibap_serialize_substruct($self, $args{'snmp3_credential'}, Infoblox::Grid::Discovery::SNMP3Credential::__ibap_object_type__());
            return unless $fargs->{'snmpv3_credential'};
            $count++;
        }

        my %types = (
            'CLI'   => 'CLI',
            'SNMP'  => 'SNMPv1v2',
            'SNMP3' => 'SNMPv3',
        );

        if (defined $args{'type'}) {
            $fargs->{'test_credential_type'} = ibap_value_o2i_string($types{$args{'type'}}) if defined $types{$args{'type'}};
        } else {
            if ($count == 1) {
                if ($fargs->{'cli_credentials'}) {
                    $fargs->{'test_credential_type'} = ibap_value_o2i_string('CLI');
                } elsif ($fargs->{'snmpv1v2_credential'}) {
                    $fargs->{'test_credential_type'} = ibap_value_o2i_string('SNMPv1v2');
                } elsif ($fargs->{'snmpv3_credential'}) {
                    $fargs->{'test_credential_type'} = ibap_value_o2i_string('SNMPv3');
                }
            }
        }

        return set_error_codes(1012, "'type' member is required and the valid value is 'CLI', 'SNMP' or 'SNMP3'") unless $fargs->{'test_credential_type'};
    }

    my $result;
    my $server = $self->get_ibap_server() || return;

    eval {
        $result = $server->ibap_request($fname, $fargs);
    };

    return $server->set_papi_error($@, $self) if $@;
    set_error_codes(0, undef, $self);

    my $t = Infoblox::Grid::Discovery::TestCredential->new();
    $t->__ibap_to_object__($result, $server, $self);
    $t->{'id'} = $args{'id'} if (!$t->id() and $args{'id'});

    return $t;
}

sub fill_partial_object {
    my ($self, $object) = @_;
    my $server = $self->get_ibap_server() || return;

    if (ref($object) eq 'ARRAY') {
        #
        #
        #

        my %types;
        my @result;

        foreach (@$object) {
            #
            #
            #
            #
            #
            next unless $_;

            my %args=('object_id' => $_->__object_id__());
            my $ibap_object_type = $_->__ibap_object_type__("get", $self, \%args);

            #
            #
            #
            #
            #
            #
            if ($_->{'__partial__'} && $_->__object_id__()) {
                push @{$types{$ibap_object_type . '!' . ref($_)}}, $_;
            }
            else {
                #
                push @result, $_;
            }
        }

        foreach my $current (keys %types) {
            my $object_array_ref;
            my @search_query = map {tObjId($_->__object_id__())} @{$types{$current}};
            my ($ibap_type, $papi_type) = split /!/, $current;

            return unless ($self->__ibap_object_read__($server, @{$types{$current}}[0], $papi_type, $ibap_type, 0, \@search_query, undef, 1, \$object_array_ref) == 1);
            push @result, @{$object_array_ref};
        }

        return @result;
    }
    else {
        #
        unless ($object->{'__partial__'} && $object->__object_id__()) {
            if (wantarray) {
                return [$object];
            } else {
                return $object;
            }
        }

        my %args=('object_id' => $object->__object_id__());
        my $ibap_object_type = $object->__ibap_object_type__("get", $self, \%args);

        my $search_query = [ tObjId($object->__object_id__()) ];

        my $object_array_ref;
        return unless ($self->__ibap_object_read__($server, $object, ref($object), $ibap_object_type, 0, $search_query, undef, 1, \$object_array_ref) == 1);

        set_error_codes($self->status_code(), $self->status_detail());

        if (Infoblox->status_code() != 0) {
            return;
        }

        if ($object_array_ref) {
            if (wantarray) {
                return @{$object_array_ref};
            } else {
                return $object_array_ref->[0];
            }
        } else {
            return;
        }
    }
}

sub new_cursor
{
    my $self=shift;
    return Infoblox::Cursor->__new__($self, @_);
}

#
sub __ibap_read_lazy_field__
{
   my $self=shift;
   my $object=shift; #Object will be filled
   my $readfields=shift; #Readfield reference
   my $ibap_to_object_ref=shift; #A reference to conversion function. The function uses the calling scheme of the object's __ibap_to_object__ method

   my %args;

   my $object_id=$object->__object_id__();
   unless($object_id){
      set_error_codes(1001,"Object must be retrieved from session before using this method",$self);
      return 0;
   }
   my $server=$self->get_ibap_server() || return 0;


   %args=( object_ids => [tObjId($object_id)], depth => 0, return_fields => $readfields);

   my $result;
   eval { $result=$server->ObjectRead(\%args); };

   if ($@) {
     $server->set_papi_error($@, $self, $object);
     return 0;
   }

   unless ($result)
    {
        #
        set_error_codes(1001,"Unspecified server error in processing request",$self );
        return 0;
    }
   else
    {

        if (scalar(@{$result}) != 1)
        {
            set_error_codes(1001, "Object not found on server", $self);
            return 0;
        }

        my $result_ref=$result->[0];
        my %return_object_cache;
        $result=&$ibap_to_object_ref($object,$result_ref, $server, $self, \%return_object_cache);
        if ((defined($result) && $result == 1) || $self->status_code() != 0)
        {
          return 1;
        }else{
          return 0;
        }
    }
}

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
#
#
#
#
#
sub __ibap_object_read__
{
    my $self=shift;
    my $server=shift;
    my $object=shift;
    my $object_type=shift;
    my $ibap_object_type=shift;
    my $b_check_serialize_once=shift;
    my $ref_search_query=shift;
    my $wanted_members_ref=shift;
    my $object_id_search=shift;
    my $ref_ref_array_results=shift;
    my $ref_ext_args_hash=shift;
    my $cursor=shift;
    my $original_searchargsref=shift;
    my $wanted_partials=shift;

    my ($depth, $implicit, $ref_object_return_fields, $limit, $notpartial);

    #
    #
    #
    #
    #
    #
    #
    #
    #
    $limit = 0;
    if ($original_searchargsref->{'maximum_objects_returned'}) {
        $limit = $original_searchargsref->{'maximum_objects_returned'};
        unless ($limit =~ m/^[0-9]+$/) {
            set_error_codes(1104, "Invalid value $limit for maximum_objects_returned. Only unsigned integers are supported",$self );
            return 0;
        }
        delete $original_searchargsref->{'maximum_objects_returned'};
    }
    elsif ($self->{'limit'}) {
        $limit = $self->{'limit'};
    }

    if ($object)
    {
        if ($object->__ibap_capabilities__('depth'))
        {
            $depth = $object->__ibap_capabilities__('depth');
        }
        else
        {
            $depth = 1;
        }

        $implicit = $object->__ibap_capabilities__('implicit_defaults');

        eval {
            ($ref_object_return_fields, $notpartial) =
                $object->__return_fields__($wanted_members_ref,$wanted_partials);
        };

        return $server->set_papi_error($@, $self) if $@;

        #
        if ($object->__ibap_capabilities__('limit')) {
            my $limit_object = $object->__ibap_capabilities__('limit');

            if ($limit) {
                if ($limit_object < $limit) {
                    $limit = $limit_object;
                }
            }
            else {
                $limit = $limit_object;
            }
        }
    }
    elsif (!$object_type)
    {
        #
        #
        if (defined $$ref_ext_args_hash{implicit_defaults}) {
            $implicit = $$ref_ext_args_hash{implicit_defaults};
        }

        if (defined $$ref_ext_args_hash{depth}) {
            $depth = $$ref_ext_args_hash{depth};
        } else {
            $depth = 4;
        }

        if (defined $$ref_ext_args_hash{return_fields}) {
            $ref_object_return_fields = $$ref_ext_args_hash{return_fields};
        } # else $ref_object_return_fields = undef;
    }
    else
    {
        #
        set_error_codes(1002,"object_type cannot be provided without the object", $self);
        return 0;
    }

    my %args = ( depth => $depth, implicit_defaults => $implicit );

    if ($object_id_search) {
        $args{'object_ids'} = $ref_search_query;
    } else {
        $args{'search_fields'} = $ref_search_query;
    }

    #
    $args{'limit'} = $limit if $limit;
    $args{'return_fields'} = $ref_object_return_fields
        if (defined $ref_object_return_fields);

    #
    my $result;
    if ($b_check_serialize_once)
    {
        my $once_value;
        if ($object) {
            $once_value = $object->__ibap_capabilities__('single_serialization');
        } elsif (!$object_type) {
            if (defined $$ref_ext_args_hash{dups_use_refs}) {
                $once_value = $$ref_ext_args_hash{dups_use_refs};
            }
        } else {
            #
            set_error_codes(1002,"object_type cannot be provided without the object", $self);
            return 0;
        }

        $args{'dups_use_refs'} = $once_value if (defined $once_value);
    }

    $args{'object_type'} = $ibap_object_type unless ($object_id_search);

    #
    if (defined $cursor) {
        $args{'limit'} = $cursor->{'fetch_size'};
        $args{'paging_op'} = tString('FIRST_PAGE');

        if (defined $cursor->{'ticket'}) {
            delete $args{'search_fields'};
            delete $args{'object_ids'};
            delete $args{'object_type'};
            $args{'paging_ticket'} = $cursor->{'ticket'};
            $args{'paging_op'} = tString('NEXT_PAGE') unless defined $cursor->{'first_page'};
        }
        delete $cursor->{'first_page'} if defined $cursor->{'first_page'};

        $args{'require_info'} = tIBType('requireinfo',{'require_has_next' => tBool(1), 'require_total_size' => tBool(0)});
    }

    my $paging_info;
    eval { ($result, $paging_info) = $server->ObjectRead(\%args,undef,undef,(defined $cursor) ? 1 : undef); };

    if ($@) {
        $cursor->__invalidate__() if defined $cursor;
        $server->set_papi_error($@, $self, $object);
        return 0;
    }

    unless ($result)
    {
        #
        $cursor->__invalidate__() if defined $cursor;
        set_error_codes(1001,"Unspecified server error in processing request",$self );
        return 0;
    }
    else
    {
        if (defined $cursor) {
            $cursor->{'ticket'} = $paging_info->{'ticket'};
            $cursor->{'has_more'} = $paging_info->{'has_next'};
        }

        if (scalar(@{$result}) == 0)
        {
            set_error_codes(1003, undef, $self);
            if (defined $cursor) {
                #
                $cursor->{'has_more'} = 0;
                return 0;
            }
            else {
                return 0 unless ($object && $object->can('__get_search_callback__'));
            }
        }

        my @results_array;
        my %return_object_cache;

        if ($wanted_partials) {
            $return_object_cache{'__partial_subobjects__'} = 1;
        }

        foreach my $result_ref (@{$result})
        {
            #
            #
            #
            #
            if ($ibap_object_type eq 'SmartFolderChild') {
                $result_ref = $$result_ref{resource};
            }

            #
            #
            if (ref($result_ref) eq 'object_id') {
                $result_ref = $return_object_cache{$$result_ref{id}};
            }

            #
            #
            #
            #
            #
            my $objtype = $object_type
                        ? $object_type
                        : $papi_object_type_from_wsdl{ref($result_ref)};
            if (!$objtype) {
                next if($ibap_object_type eq 'SmartFolderChild'); #SmartFolder Children  can be unknown to papi, we just skip them
                set_error_codes(1141, "Could not determine the object type (" . ref($result_ref) . ")", $self);
                return 0;
            }

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
            #
            #
            #
            #
            #

            my $result_object=$objtype->__new__();

            #
            #
            #

            $result=$result_object->__ibap_to_object__($result_ref, $server, $self, \%return_object_cache);

            if ((defined($result) && $result == 1) || $self->status_code() != 0)
            {
                return 0;
            }

            #
            #
            #
            if ($wanted_members_ref && !defined $notpartial) {
                $result_object->{'__partial__'} = 1;
            }
            push @results_array, $result_object;
        }

        $$ref_ref_array_results=\@results_array;

        #
        if ($object && $object->can('__get_search_callback__') && not defined $cursor)
        {
            return $object->__get_search_callback__($self, $object, $ref_search_query, $ref_ref_array_results, $return_fields, undef, $original_searchargsref);
        }
    }

    return 1;
}

#
sub __extensible_attribute_def_cache_update__
{
    my $self = shift;
    my $server = $self->get_ibap_server() || return;

    my $result;
    eval {
        $result = $server->ObjectRead(
                      { object_type => 'ExtensibleAttributeDefinition',
                        depth => 1,
                        return_fields => [tField('name'),
                                          tField('attribute_type'),
                                         ] } );
    };

    unless ($result) {
        my $err = $@;
        if ($err =~ m/Authorization Required/) {
            set_error_codes(1006, 'The user is not authorized for this operation. Creating session failed.',$self );
        }
        else {
            set_error_codes(1101, "Connection error " . $err,$self );
        }
    }
    else
    {
        $self->{"extensible_attribute_def_cache"} = ();

        my %reverse_attribute_types_dict=reverse %Infoblox::Grid::ExtensibleAttributeDef::_ATTRIBUTE_TYPES_DICT;
        foreach my $result_ref (@{$result})
        {
            my $papi_type=$reverse_attribute_types_dict{$$result_ref{'attribute_type'}};
            $self->__extensible_attribute_def_cache_add_entry__($$result_ref{'object_id'}{'id'}, $$result_ref{'name'}, $papi_type, $$result_ref{'sub_grid'});
        }
    }
}

#
sub __extensible_attribute_def_cache_add_entry__
{
    my $self=shift;
    my $object_id=shift;
    my $name=shift;
    my $type=shift;
    my $sg=shift;

    my %entry=('object_id' => $object_id, 'name' => $name, 'type' => $type);

    ${$self->{"extensible_attribute_def_cache"}}{$name}=\%entry;
}


#
sub __extensible_attribute_def_cache_get_entry__
{
    my $self=shift;
    my $name=shift;


    return ${$self->{"extensible_attribute_def_cache"}}{$name};
}


#
sub __extensible_attribute_def_cache_del_entry_per_id__
{
    my $self=shift;
    my $object_id=shift;


    for my $entry_name (keys %{$self->{"extensible_attribute_def_cache"}})
    {
        my $ref_entry=${$self->{"extensible_attribute_def_cache"}}{$entry_name};
        if ($$ref_entry{'object_id'} eq $object_id)
        {
            delete ${$self->{"extensible_attribute_def_cache"}}{$entry_name};
            last;
        }
    }

}

#
#
#
#
sub __smart_folder_query_meta_cache_add_entry__
{
    my ($self, $name, $field_type, $value_type, $enum_values_ref, $extattr_ref) = @_;

    my %entry=('name' => $name, 'field_type' => $field_type,
        'value_type' => $value_type, 'enum_values' => $enum_values_ref);

    #
    my $key = $name . $field_type;

    if ($field_type eq 'EXTATTR') {
        $entry{'extattr'} = $extattr_ref;
    }

    ${$self->{'smart_folder_query_meta_cache'}}{$key}=\%entry;
}


#
sub __smart_folder_query_meta_cache_get_entry__
{
    my ($self, $name, $field_type, $grid, $grid_id) = @_;

    #
    my $key = $name . $field_type;
    return ${$self->{'smart_folder_query_meta_cache'}}{$key};
}

#
sub __time__
{
    my $self=shift;

    if (@_) {
        $self->{"__http_timing__"} = shift;
    }
    else {
        return $self->{"__http_timing__"};
    }
}

sub restart
{
    my ($self, %args) = @_;
    my ($func_name, $func_args) = ('RestartService', {});

    my $server = $self->get_ibap_server() || return;

    #
    #
    #

    my $ref_allowed_arguments = {
        scheduled_at          => 0,
        services              => 0,
        mode                  => 0,
        groups                => 0,
        members               => 0,
        force_restart         => 0,
        user_name             => 0,
    };

    my $ref_deprecated_arguments = {
        member                => 0,
        service               => 0,
        delay_between_members => 0,
        force_restart         => 0,
        scheduled_at          => 0,
    };

    #

    #
    #
    #

    if ($self->__validate_arguments_from_arg_list__(
        { %$ref_allowed_arguments, %$ref_deprecated_arguments },
        \%args,
    )) {
        unless (
            $self->__validate_arguments_from_arg_list__(
                $ref_allowed_arguments,
                \%args) or
            $self->__validate_arguments_from_arg_list__(
                $ref_deprecated_arguments,
                \%args)
        ) {

            set_error_codes(1103, "'member', 'service' and "      .
                "'delay_between_members' are deprecated. "        .
                "If they are to be used only those members "      .
                "should be specified, and not any of 'services'," .
                " 'mode', 'groups' and 'members'", $self);

            return 0;
        }
    } else {
        return 0;
    }

    #

    my %allowed_services = (
        'ALL'    => 1,
        'DNS'    => 1,
        'DHCP'   => 1,
        'DHCPV4' => 1,
        'DHCPV6' => 1,
    );

    if (ref $args{services} eq 'ARRAY') {
        if (scalar (my @res = grep { not exists $allowed_services{$_} }
            @{$args{services}}) != 0) {

            my $sz = scalar @res > 1;

            #
            #
            set_error_codes('1103', "'" . (join "', '", @res) .
                ($sz ? "' are " : "' is ") . "invalid value" .
                ($sz ? 's' : '') . " for 'services' field. " .
                "Valid values are: '" . (join "', '", keys %allowed_services) .
                "'", $self);

            return 0;
        }
    } elsif ($args{services}) {

        set_error_codes('1103', "'services' should be 'ARRAY'", $self);
        return 0;
    }

    #

    my %allowed_mode = (
        'GROUPED'      => 1,
        'SEQUENTIAL'   => 1,
        'SIMULTANEOUS' => 1,
    );

    if ($args{mode} and not exists $allowed_mode{$args{mode}}) {

        #
        set_error_codes('1103', "Invalid value '" . $args{mode} .
            "' for 'mode' field. Valid values are: '" .
            (join "', '", keys %allowed_mode) . "'", $self);

        return 0;
    }

    #

    if ($args{members} and $args{groups}) {

        set_error_codes(1103,
            "Only one of 'members' and 'groups' is allowed", $self);

        return 0;
    }

    #
    #
    #

    #
    $args{mode} = 'SEQUENTIAL' if $args{delay_between_members};
    #
    $args{mode} = 'SIMULTANEOUS' unless $args{mode};

    $args{services} = ['ALL'] unless $args{services};

    #
    $args{groups} = [] unless ($args{groups} or $args{members} or $args{member});

    #
    #
    #

    my $scheduled_at = $args{'scheduled_at'};
    my %ibap_headers = ();

    if ($scheduled_at) {

        $ibap_headers{request_settings} = eval {
            schedule_request($scheduled_at, undef, $scheduled_at_err)
        };

        return $server->set_papi_error($@, $self) if $@;
    }

    #
    #
    #

    #

    my $ref_object_to_ibap = {
        services      => \&ibap_o2i_string_array_undef_to_empty,
        groups        => \&ibap_o2i_object_only_by_oid,
        members       => \&ibap_o2i_object_only_by_oid,
        mode          => \&ibap_o2i_string,
        force_restart => \&ibap_o2i_boolean,
        user_name     => \&ibap_o2i_string,
    };

    my $ref_name_mappings = {
        force_restart => 'force',
        groups        => 'parents',
        members       => 'parents',
    };

    #

    #
    if ($args{member}) {

        my $tmp = Infoblox::DHCP::Member->new(ipv4addr => $args{'member'});
        return unless $tmp;

        my $member = ibap_value_o2i_member_nocache($tmp, $session, 'member', 0);
        $$func_args{parents} = tIBType('ArrayOfBaseObject', [$member]);
    }

    #

    foreach my $field (keys %$ref_object_to_ibap) {

        if ($args{$field}) {

            my @res = $$ref_object_to_ibap{$field}->(
                $self, $session, $field, \%args
            );

            return undef unless (@res and $res[0]);

            my $map = $$ref_name_mappings{$field};
            $$func_args{$map ? $map : $field} = $res[2] if $res[2];
        }
    }

    #

    eval {
        $result = $server->ibap_request(
            $func_name, $func_args, \%ibap_headers
        );
    };

    #

    return $server->set_papi_error($@, $self) if $@;
    set_error_codes(0, undef, $self);
    return 1;
}

sub run_scavenging {

    my ($self, %args) = @_;
    my ($func_name, $func_args) = ('RunScavenging', {});

    my $server = $self->get_ibap_server() || return;

    #
    #
    #

    my $ref_allowed_arguments = {
        object       => 1,
        action       => 0,
        scheduled_at => 0,
    };

    return 0 unless $self->__validate_arguments_from_arg_list__(
        $ref_allowed_arguments, \%args);

    my %_allowed_action = (
        'ANALYZE'         => 1,
        'RECLAIM'         => 1,
        'ANALYZE_RECLAIM' => 1,
        'RESET'           => 1,
    );

    if ($args{action} and not exists $_allowed_action{$args{action}}) {

        #
        set_error_codes('1103', "Invalid value for 'action' argument. "   .
            "Valid values are: '" . (join "', '", keys %_allowed_action)  .
            "'.", $self);

        return 0;
    }

    my %_allowed_object = (
        'Infoblox::Grid::DNS' => 1,
        'Infoblox::DNS::View' => 1,
        'Infoblox::DNS::Zone' => 1,
    );

    unless ($_allowed_object{ref $args{object}}) {

        set_error_codes('1103', "Invalid value for 'object' argument. "      .
            "The valid values are: '" . (join "', '", keys %_allowed_object) .
            "'.", $self);

        return 0;
    }

    #
    #
    #

    $args{'action'} = 'ANALYZE' unless exists $args{'action'};

    #
    #
    #

    my $scheduled_at = $args{'scheduled_at'};
    my %ibap_headers = ();

    if ($scheduled_at) {

        $ibap_headers{request_settings} = eval {
            schedule_request($scheduled_at, undef, $scheduled_at_err)
        };

        return $server->set_papi_error($@, $self) if $@;
    }

    #
    #
    #

    #

    my $ref_object_to_ibap = {
        object => \&ibap_o2i_object_only_by_oid,
        type   => \&ibap_o2i_string,
        action => \&ibap_o2i_string,

    };

    #

    foreach my $field (keys %$ref_object_to_ibap) {

        if ($args{$field}) {

            my @res = $$ref_object_to_ibap{$field}->(
                $self, $session, $field, \%args
            );

            return undef unless (@res and $res[0]);

            $$func_args{$field} = $res[2] if $res[2];
        }
    }

    #

    eval {
        $result = $server->ibap_request(
            $func_name, $func_args, \%ibap_headers
        );
    };

    #

    return $server->set_papi_error($@, $self) if $@;
    set_error_codes(0, undef, $self);
    return 1;
}

sub query_fqdn_on_member {

    my $self = shift;
    my ($fname, $fargs) = ('QueryFqdnOnMember', {});

    my $params;

    if (ref $_[0] eq 'Infoblox::Grid::Member::QueryFQDNParameter') {
        $params = shift;
    } else {
        $params = Infoblox::Grid::Member::QueryFQDNParameter->new(@_);
        return undef unless $params;
    }

    my $server = $self->get_ibap_server() || return;

    #
    #
    #

    my $o2i = $params->__object_to_ibap__();
    return undef unless $o2i;

    foreach my $p (@$o2i) {
        $$fargs{$$p{'field'}} = $$p{'value'};
    }

    #

    eval {
        $result = $server->ibap_request(
            $fname, $fargs, \%ibap_headers,
        );
    };

    #

    return $server->set_papi_error($@, $self) if $@;
    set_error_codes(0, undef, $self);

    my $response = Infoblox::Grid::Member::QueryFQDNResponse->__new__();
    $response->__ibap_to_object__($result);

    return $response;
}


sub get_all_template_vendor_id {

    my ($self, %args) = @_;

    my ($func_name, $func_args) = ('GetAllTemplateRestApiVendorIdentifiers', {});

    my $ref_allowed_arguments = {
        'outbound_type' => 0,
    };

    my $type = $args{outbound_type} || 'REST';

    unless (array_contains($type, ['REST', 'DXL'])) {
        set_error_codes(1103, "Invalid value for 'outbound_type' argument ('" .
            $args{'outbound_type'} . "'). Valid values are 'REST' "  .
            "and 'DXL'.", $self,
        );
        return undef;
    }

    $$func_args{'outbound_type'} = tString($type);

    return 0 unless $self->__validate_arguments_from_arg_list__(
        $ref_allowed_arguments, \%args);


    my $server = $self->get_ibap_server() || return;

    #

    eval {
        $result = $server->ibap_request(
            $func_name, $func_args, \%ibap_headers
        );
    };

    #

    return $server->set_papi_error($@, $self) if $@;
    set_error_codes(0, undef, $self);

    return $$result{'vendor_identifiers'} ? $$result{'vendor_identifiers'} : [];
}

sub get_template_schema_versions {

    my ($self, %args) = @_;

    my ($func_name, $func_args) = ('GetTemplateRestApiSchemaVersions', {});

    my $ref_allowed_arguments = {
        'schema_type' => 1,
    };

    return 0 unless $self->__validate_arguments_from_arg_list__(
        $ref_allowed_arguments, \%args);

    my $server = $self->get_ibap_server() || return;

    if (my $type = {
        'REST_ENDPOINT' => 'SESSION_MANAGEMENT',
        'REST_EVENT'    => 'ACTION',
    }->{$args{'schema_type'}}) {
        $$func_args{'schema_type'} = tString($type);
    } else {
        set_error_codes(1103, "Invalid value for 'schema_type' argument (" .
            $args{'schema_type'} . "). Valid values are 'REST_ENDPOINT' "  .
            "and 'REST_EVENT'.", $self,
        );

        return undef;
    }

    #

    eval {
        $result = $server->ibap_request(
            $func_name, $func_args, \%ibap_headers
        );
    };

    #

    return $server->set_papi_error($@, $self) if $@;
    set_error_codes(0, undef, $self);

    return $$result{'versions'} ? $$result{'versions'} : [];
}

sub clear_outbound_worker_log {

    my ($self, %args) = @_;

    my ($func_name, $func_args) = ('ClearWorkerLog', {});

    my $ref_allowed_arguments = {
        'endpoint' => {mandatory => 1, validator => \&ibap_value_o2i_string},
    };

    return 0 unless $self->__validate_arguments_from_arg_list__(
        $ref_allowed_arguments, \%args);

    my $res = ibap_readfield_simple_string('AllEndpoints', 'name', $args{endpoint}, 'endpoint');
    $$func_args{endpoint} = $res || return undef;

    my $server = $self->get_ibap_server() || return;

    #

    eval {
        $result = $server->ibap_request(
            $func_name, $func_args, \%ibap_headers
        );
    };

    #

    return $server->set_papi_error($@, $self) if $@;
    set_error_codes(0, undef, $self);

    my $t = Infoblox::Grid::TestResult->__new__();
    $t->__ibap_to_object__($result, $server, $session);

    return $t;
}




my %remove_data_mapping = (
);


#

my %ibap_file_export_mapping = (
#
#
#
#
#
#
#
#
#
    'admin_cert' =>
           {
            'func'     => 'DownloadCertificate',
            'cert_use' => 'ADMIN',
            'required' => ['member'],
           },
    'backup' =>
           {
            'func'     => 'GetGridData',
            'file_id'  => 'BACKUP',
            'required' => [],
            'format'   => 'TAR_GZ',
           },
    'namedacl' =>
           {
            'func'     => 'ValidateACItems',
            'required' => ['namedacl'],
           },
     'dxl_endpoint_certs' =>
           {
            'func' => 'GenEndpointDxlCertificates',
            'required' => ['ca_cert_path'],
           },
    'captive_portal_cert' =>
           {
            'func'     => 'DownloadCertificate',
            'cert_use' => 'CAPTIVE_PORTAL',
            'required' => ['member'],
           },
#
#
#
#
#
#
#
#
    'csv' =>
           {
            'func'     => 'CSVExport',
            'handler'  => \&_export_data_csv_handler,
            'required' => ['object_type'],
           },
    'csv_snapshot_file' =>
           {
            'func'     => 'GetCSVImportSnapshotFile',
            'required' => [],
           },
    'csv_uploaded_file' =>
           {
            'func'     => 'GetCSVImportFile',
            'required' => [],
           },
    'csv_error_log' =>
           {
            'func'     => 'GetCSVImportErrorLog',
            'required' => [],
           },
    'dhcp_expert_mode_config' =>
           {
            'func'     => 'GetMemberData',
            'file_id'  => 'DHCP_EXPERT_MODE_CFG',
            'required' => ['member'],
            'format'   => 'TEXT',
           },
    'dhcpd_conf' =>
           {
            'func'     => 'GetMemberData',
            'file_id'  => 'DHCP_CFG',
            'required' => ['member'],
            'format'   => 'TAR_GZ',
           },
    'dhcpdv6_conf' =>
           {
            'func'     => 'GetMemberData',
            'file_id'  => 'DHCPV6_CFG',
            'required' => ['member'],
            'format'   => 'TAR_GZ',
           },
    'dnsCache' =>
           {
            'func'     => 'GetMemberData',
            'file_id'  => 'DNS_CACHE',
            'required' => ['member'],
            'format'   => 'TAR_GZ',
           },
    'dnsStats' =>
           {
            'func'     => 'GetMemberData',
            'file_id'  => 'DNS_STATS',
            'required' => ['member'],
            'format'   => 'TAR_GZ',
           },
    'dnsAccelerationCache' =>
           {
            'func'     => 'GetMemberData',
            'file_id'  => 'DNS_ACCEL_CACHE',
            'required' => ['member'],
            'format'   => 'TAR_GZ',
           },
    'dns_conf' =>
           {
            'func'     => 'GetMemberData',
            'file_id'  => 'DNS_CFG',
            'required' => [],
            'format'   => 'TAR_GZ',
           },
    'eap_ca_cert' =>
           {
            'func'     => 'DownloadCertificate',
            'cert_use' => 'EAP_CA',
            'required' => ['dn'],
           },
    'generate_csr' =>
           {
            'func'     => 'GenerateCSR',
            'cert_use' => 'ADMIN',
            'required' => ['cn','member'],
           },
    'generate_self_signed_admin_cert' =>
           {
            'func'     => 'GenerateSelfSignedCert',
            'cert_use' => 'ADMIN',
            'required' => ['cn','days_valid','member'],
           },
    'generate_captive_portal_csr' =>
           {
            'func' => 'GenerateCSR',
            'cert_use' => 'CAPTIVE_PORTAL',
            'required' => ['cn', 'member'],
           },
    'generate_ifmap_dhcp_csr' =>
           {
            'func'     => 'GenerateCSR',
            'cert_use' => 'IFMAP_DHCP',
            'required' => ['cn','member'],
           },
    'generate_self_signed_ifmap_dhcp_cert' =>
           {
            'func'     => 'GenerateSelfSignedCert',
            'cert_use' => 'IFMAP_DHCP',
            'required' => ['cn','days_valid','member'],
           },
    'ifmap_dhcp_cert'   =>
           {
            'func' => 'DownloadCertificate',
            'cert_use' => 'IFMAP_DHCP',
            'required' => ['member'],
           },
    'generate_self_signed_captive_portal_cert' =>
           {
            'func' => 'GenerateSelfSignedCert',
            'cert_use' => 'CAPTIVE_PORTAL',
            'required' => ['cn', 'days_valid', 'member'],
           },
    'lease_history' =>
           {
            'func'     => 'GetDHCPLeaseHistoryFiles',
            'required' => [],
            'format'   => 'GZ',
           },
    'log_files' =>
           {
            'func'     => 'GetLogFiles',
            'required' => [],
           },
    'snmp_mibs' =>
           {
            'func'     => 'GetGridData',
            'file_id'  => 'SNMP_MIBS_FILE',
            'required' => [],
            'format'   => 'TAR_GZ',
           },
    'support_bundle' =>
           {
            'func'     => 'GetSupportFiles',
            'required' => ['member'],
            'format'   => 'TAR_GZ',
           },
    'ds_records' =>
           {
            'func' => 'DnsSecExport',
            'required' => ['zone'],
            'operation' => 'EXPORT_DS'
           },
    'trust_anchors' =>
           {
            'func' => 'DnsSecExport',
            'required' => ['zone'],
            'operation' => 'EXPORT_ANCHORS',
           },
    'dnssec_ksk'   =>
           {
             'func' => 'DnsSecGetZoneKeys',
             'required' => ['zone'],
             'key_pair_type' => 'KSK',
           },
     'dnssec_zsk'  =>
           {
             'func' => 'DnsSecGetZoneKeys',
             'required' => ['zone'],
             'key_pair_type' => 'ZSK',
           },
     'safenet_client_cert' =>
           {
             'func'      => 'GetSafeNetClientCert',
             'required'  => ['member', 'algorithm'],
           },
    'traffic_capture_file' =>
           {
            'func'     => 'GetMemberData',
            'file_id'  => 'TRAFFIC_CAPTURE_FILE',
            'required' => ['member'],
            'format'   => 'TAR_GZ',
           },
    'pool_status' =>
           {
            'func'     => 'BackupLicenses',
            'required' => [],
           },

    'restapi_template' => {
        'func'     => 'ExportTemplateRestApi',
        'required' => ['template'],
    },

    'restapi_template_schema' => {
        'func'     => 'ExportTemplateRestApiSchema',
        'required' => ['schema_type'],
    },
                               );

my %ibap_file_import_mapping = (
     'threat_analytics_file_upload' => {
         'func'     => 'SetLastUploadedAnalyticModuleSet',
         'required' => [],
     },
     'threat_protection_rule_update' =>
           {
             'func' => 'UpdateAtpRuleSet',
             'required' => [],
           },
#
#
#
#
#
#
#
#
#
    'dtc_cert' =>
           {
            'func'     => 'AddIdnsCertificate',
            'required' => [],
           },
    'maxminddb' =>
           {
            'func'     => 'UploadMaxMindDB',
            'required' => [],
           },
    'admin_cert' =>
           {
            'func'     => 'UploadCertificate',
            'cert_use' => 'ADMIN',
            'required' => ['member'],
           },
    'trusted_ca_cert' =>
           {
            'func'     => 'UploadCertificate',
            'cert_use' => 'EAP_CA',
            'required' => [],
           },
    'backup' =>
           {
            'func'     => 'RestoreDatabase',
            'file_id'  => 'NORMAL',
            'required' => [],
           },
#
#
#
#
#
#
#
#
    'captive_portal_cert' =>
           {
            'func'     => 'UploadCertificate',
            'cert_use' => 'CAPTIVE_PORTAL',
            'required' => ['member'],
           },
    'captive_portal_file' =>
           {
            'func'     => 'SetCaptivePortalFile',
            'file_id'  => '',
            'required' => ['member','cp_type'],
           },
    'dxl_endpoint_brokers' => {
        'func'           => 'ImportEndpointDxlBrokers',
        'result_handler' => \&__importdxlendpointbrokers_result_handler,
    },
    'clone' =>
           {
            'func'     => 'RestoreDatabase',
            'file_id'  => 'CLONE',
            'required' => [],
           },
    'csv' =>
           {
            'func'           => 'SetImportCSVFile',
            'file_id'        => '',
            'required'       => [],
            'result_handler' => \&_import_data_csv_result_handler,
           },
    'discovery_csv' =>
           {
            'func'     => 'SetDiscoveryCSV',
            'file_id'  => '',
            'required' => [],
           },
    'downgrade' =>
           {
            'func'     => 'Downgrade',
            'file_id'  => '',
            'required' => [],
           },
    'dsb' =>
           {
            'func'     => 'ImportDeviceSupportBundle',
            'required' => [],
           },
    'eap_ca_cert' =>
           {
            'func'     => 'UploadCertificate',
            'cert_use' => 'EAP_CA',
            'required' => [],
           },
    'dhcp_expert_mode_config' =>
           {
            'func'     => 'SetMemberData',
            'file_id'  => 'DHCP_EXPERT_MODE_CFG',
            'required' => ['member'],
           },
    'keytab' =>
           {
            'func'     => 'DEPRECATED',
            'file_id'  => 'uploadkeytab',
            'required' => [],
           },
    'uploadkeytab' =>
           {
            'func'     => 'UploadKeytabFile',
            'file_id'  => '',
            'required' => [],
            'result_handler' => \&__uploadkeytab_result_handler,
           },
    'join_multi_grid' =>
           {
            'func'     => 'JoinGoG',
            'required' => ['token','address'],
           },
    'leases' =>
           {
            'func'     => 'SetDHCPLeases',
            'required' => [],
           },
    'leases6' =>
           {
            'func'     => 'SetDHCPLeases',
            'required' => [],
           },
    'license' =>
           {
            'func'     => 'AddLicense',
            'required' => [],
           },
    'lease_history' =>
           {
            'func'     => 'SetDataFile',
            'file_id'  => 'DHCP_LEASE_HISTORY',
            'required' => [],
           },
    'tftp_file' =>
           {
            'func'     => 'SetDataFileDest',
            'file_id'  => 'TFTP_FILE',
            'required' => [],
           },
    'dnssec_ksk'   =>
           {
             'func' => 'DnsSecSetZoneKeys',
             'required' => ['zone'],
             'key_pair_type' => 'KSK',
           },
     'dnssec_zsk'  =>
           {
             'func' => 'DnsSecSetZoneKeys',
             'required' => ['zone'],
             'key_pair_type' => 'ZSK',
           },
    'ifmap_dhcp_cert' =>
           {
            'func'     => 'UploadCertificate',
            'cert_use' => 'IFMAP_DHCP',
            'required' => ['member'],
           },
    'upgrade' =>
           {
            'func'     => 'Upgrade',
            'file_id'  => '',
            'required' => [],
           },
    'restapi_template' => {
        'func'           => 'ImportTemplateRestApi',
        'result_handler' => \&__import_template_handler__,
    },

);

my %ibap_remove_data_mapping = (
                                'keytab'          => \&__delete_gss_tsig_keytab,
                                'ifmap_dhcp_data' => \&__purge_ifmap_data,
                                'nac_auth_cache'  => \&__clear_nac_cache,
                               );

sub remove_data
{
    my ( $self , %args ) = @_;

    if ($ibap_remove_data_mapping{$args{'type'}}) {
       my $type=delete($args{'type'});
       $ibap_remove_data_mapping{$type}($self,%args);
    }
    else {
        return set_error_codes(1103, '"' . $args{'type'} . '" is not a supported type for remove_data', $self);
    }
}

sub import_data
{
    my ( $self , %args ) = @_;

    #
    return set_error_codes(1103, "path is required", $self) unless ($args{'path'} || $args{'data'});
    return set_error_codes(1103, "type is required", $self) unless ($args{'type'});

    #

    #
    if($args{'type'} eq 'ds_records')
    {
       delete $args{'type'};
       return $self->__import_ds_records__(%args);
    }

    if (defined $ibap_file_import_mapping{$args{'type'}}) {
        #
        my (%func_args, %init_func_args);
        my $server=$self->get_ibap_server() || return;
        my $dataref;

        my $func_name = $ibap_file_import_mapping{$args{'type'}}{'func'};

        if ($func_name eq 'DEPRECATED') {
            return set_error_codes(1103, "The function " . $args{'type'} . " is no longer supported, please see " . $ibap_file_import_mapping{$args{'type'}}{'file_id'}, $self);
        }

        foreach (@{$ibap_file_import_mapping{$args{'type'}}{'required'}}) {
            return set_error_codes(1103, "$_ is required", $self) unless ($args{$_});
        }

        if ($args{'path'}) {
            unless (-f $args{'path'}) {
                return set_error_codes(1028, $args{'path'} . ' is not a valid file or it cannot be read.', $self);
            }

            #
            #
            #

            $init_func_args{'local_file'} = tString(basename($args{'path'})) if $func_name eq 'SetImportCSVFile';

            eval { $result = $server->ibap_request('DataUploadInit', \%init_func_args); };
            if ($@) {
                #
                #
                set_error_codes(1028,$@->text(),$self);
                return;
            }

            $dataref = $result->{'data_ref'};
            my $masterurl = $$dataref{'url'};
            $host_ip = $self->{"master"};
            if ($host_ip =~ m/:.*:/ && $host_ip !~ m/\[/) {
                $host_ip = "[$host_ip]";
            }
            $masterurl =~ s!https://[^/]*!https://$host_ip!;

            my $upload;
            eval { $upload = $server->request(
                                              POST $masterurl,
                                              Content_Type => 'form-data',
                                              Content      => [
                                                               import_file => [$args{'path'}],
                                                              ]
                                             );
               };

            if ($@) {
                #
                #
                #
                #
                if ($@->can('text')) {
                    set_error_codes(1028,$@->text(),$self);
                }
                else {
                    set_error_codes(1028,$@,$self);
                }
                return;
            }

            unless ($upload->is_success()) {
                set_error_codes(1004,$upload->status_line,$self);
                return;
            }
        }
        else {
            $dataref = {
                        'data_mode'     => tString('DATA_INLINE'),
                        'data_encoding' => tString('UTF8'),
                        'data'          => tString($args{'data'}),
                       };
        }

        my $file_id='';
        $file_id=$ibap_file_import_mapping{$args{'type'}}{'file_id'}  if defined $ibap_file_import_mapping{$args{'type'}}{'file_id'};
        my $cert_use  = $ibap_file_import_mapping{$args{'type'}}{'cert_use'} if defined $ibap_file_import_mapping{$args{'type'}}{'cert_use'};

        if ($args{'lease_precedence'} || $func_name eq 'SetDHCPLeases') {
            #
            $func_args{'lease_precedence'} = tString('KEEP_NEWEST');
            $func_args{'lease_precedence'} = tString('KEEP_PREVIOUS') if ($args{'lease_precedence'} && $args{'lease_precedence'} eq 'keep-previous');
            $func_args{'lease_precedence'} = tString('REPLACE_PREVIOUS') if ($args{'lease_precedence'} && $args{'lease_precedence'} eq 'replace-previous');

            #
            if ($args{'type'} eq 'leases6') {
                $func_args{'protocol'} = 'IPv6';
            }
        }

        if ($args{'format'} || $func_name eq 'SetDHCPLeases') {
            #
            $func_args{'lease_format'} = tString('ISC_LEASE');
        }

        if ($args{'network_view'}) {
            $func_args{'network_view'} = tString($args{'network_view'});
        }

        if ($args{'merge_data'}) {
            $func_args{'merge_data'} = ibap_value_o2i_boolean($args{'merge_data'},'merge_data',$self);
            return unless $func_args{'merge_data'};
        }

        if ($args{'cp_type'}) {
            if ($args{'cp_type'} =~ m/aup/i) {
                $func_args{'type'} = tString('AUP');
            }
            else {
                $func_args{'type'} = tString('IMG_' . uc($args{'cp_type'}));
            }
        }

        if ($args{'directory'}) {
            #
            if ($args{'directory'} =~ m!/$!) {
                $func_args{'dest_path'} = tString($args{'directory'} . basename($args{'path'}));
            }
            else {
                $func_args{'dest_path'} = tString($args{'directory'} . '/' . basename($args{'path'}));
            }
        }

        if ($args{'member'} || $args{'virtual_ip'}) {
            my $what='member';
            $what='virtual_ip' if $args{'virtual_ip'};

            #
#
#

            $func_args{'vnode'} = ibap_value_o2i_member_nocache($args{$what},$self,$what,0);
        }

        if ($func_name eq 'SetImportCSVFile') {
            #

            my %csv_import_args = (
                'operation'         => {'enum' => ['insert', 'update', 'replace', 'delete', 'custom'], 'default' => 'insert'},
                'override'          => {'enum' => ['merge', 'override'], 'default' => 'override'},
                'separator'         => {'enum' => ['comma', 'space', 'tab', 'semicolon'], 'default' => 'comma'},
                'csv_action'        => {'enum' => ['start', 'test'], 'default' => 'start'},
                'continue_on_error' => {'enum' => ['true', 'false'], 'default' => 'false'},
            );

            foreach my $key (keys(%csv_import_args)) {
                if (defined $args{$key}) {
                    return set_error_codes(1103, $args{$key}." is not a valid value for $key; valid values are: ".join(', ', @{$csv_import_args{$key}->{'enum'}}), $self) unless Infoblox::Util::array_contains(lc($args{$key}), $csv_import_args{$key}->{'enum'});
                } else {
                    $args{$key} = $csv_import_args{$key}->{'default'};
                }
            }

            if (lc($args{'csv_action'}) eq 'test' and lc($args{'operation'}) ne 'replace') {
                return set_error_codes(1103, 'You cannot set csv_action to "test" if operation is not "replace"', $self);
            }
        }
        if ($func_name eq 'RestoreDatabase') {
            if ($args{'force'} && $args{'force'} =~ m/true/i) {
                $file_id = 'FORCED';
                if ($args{'keep_grid_ip'} && $args{'keep_grid_ip'} =~ m/false/i) {
                    $func_args{'preserve_grid_ip'} = tBool(0);
                }
                else {
                    $func_args{'preserve_grid_ip'} = tBool(1);
                }
            }

            $func_args{'mode'} = tString($file_id);
            $file_id='';

            #
            #
            if (!defined $args{'discovery_data'} and
                !defined $args{'nios_data'}      and
                !defined $args{'splunk_app_data'}
            ) {
                $func_args{'discovery_data'} = tBool(0);
                $func_args{'splunk_app_data'} = tBool(0);
                $func_args{'nios_data'} = tBool(1);
            } else {
                foreach (
                    'discovery_data',
                    'nios_data',
                    'splunk_app_data',
                ) {
                    if (defined $args{$_}) {
                        $func_args{$_} = ibap_value_o2i_boolean($args{$_}, $_, $self);
                        return unless $func_args{$_};
                    } else {
                        $func_args{$_} = tBool(0);
                    }
                }
            }
        }

        if($func_name eq 'DnsSecSetZoneKeys') {
           $func_args{'zone'}=ibap_arg_zone_convert($session, 'zone', {zone => $args{'zone'}, view => $args{'view'}});
           return unless $func_args{'zone'};
           $func_args{'key_pair_type'}=ibap_value_o2i_string($ibap_file_export_mapping{$args{'type'}}{'key_pair_type'});
        }

        if ($func_name eq 'AddLicense') {
            if ($args{'data'} and $args{'data'} !~ /,/) {
                #
                $dataref->{'data'} = 'Unknown,Unknown,Unknown,,' . $args{'data'};
            }
            #
            $func_args{'save_unknown'} = tBool(0);
        }

        if ($func_name eq 'UploadCertificate') {
            $func_args{'cert_data_ref'} = tIBType('data_ref',$dataref);
        }
        elsif ($func_name eq 'SetNiosImage') {
            $func_args{'nios_file'} = tIBType('data_ref',$dataref);
        }
        elsif ($func_name eq 'UpdateAtpRuleSet') {
            $func_args{'ruleset'} = tIBType('data_ref',$dataref);
        }
        elsif ($func_name eq 'SetLastUploadedAnalyticModuleSet') {
            $func_args{'moduleset'} = tIBType('data_ref', $dataref);
        }
        elsif ($func_name eq 'ImportEndpointDxlBrokers') {
            $func_args{'config'} = tIBType('data_ref', $dataref);
        }
        else {
            $func_args{'data_ref'} = tIBType('data_ref',$dataref);
        }

        if ($func_name eq 'SetCaptivePortalFile' or $func_name eq 'ImportDeviceSupportBundle') {
            $func_args{'filename'} = tString(basename($args{'path'}));
        }

        if ($func_name eq 'JoinGoG') {
            $func_args{'join_file'} = $func_args{'data_ref'};
            delete $func_args{'data_ref'};

            $func_args{'join_token'} = tString($args{'token'});
            $func_args{'sgm_address'} = tString($args{'address'});
            $func_args{'sgm_port'} = tUInteger($args{'port'}) if defined $args{'port'};
            $func_args{'grid_name'} = tString($args{'grid_name'}) if defined $args{'grid_name'};
            if (defined $args{'use_mgmt_port'}) {
                $func_args{'use_mgmt_port'} = ibap_value_o2i_boolean($args{'use_mgmt_port'}, 'use_mgmt_port', $self);
                return unless defined $func_args{'use_mgmt_port'};
            }
        }

        if ($func_name eq 'ImportTemplateRestApi') {
            $args{'overwrite'} = 'false' unless defined $args{'overwrite'};
            $func_args{'overwrite'} = ibap_value_o2i_boolean($args{'overwrite'});
            return unless defined $func_args{'overwrite'};
        }

        $func_args{'file_id'} = tString($file_id) if $file_id;
        $func_args{'cert_use'} = tString($cert_use) if defined $cert_use;

        #
        #
        eval { $result = $server->ibap_request($func_name, \%func_args); };

        if ($@) {
            #
            #
            if (ref($@) && $@->can('text')) {
                set_error_codes(1028,$@->text(),$self);
            }
            else {
                set_error_codes(1028,$@,$self);
            }
            return undef;
        }

        if ($func_name eq 'AddLicense') {
            return $result->{'result'};
        }

        if (defined $ibap_file_import_mapping{$args{'type'}}{'result_handler'}) {
            return $ibap_file_import_mapping{$args{'type'}}{'result_handler'}($self,$server,$result,\%args);
        }

        return 1;
    }
    else {
        return set_error_codes(1113, '"' . $args{'type'} . '" is not a supported function', $self);
    }
}

sub __importdxlendpointbrokers_result_handler {
    my ($self, $server, $result, $argsref) = @_;

    my @brokers;
    if (defined $result->{brokers}) {
        foreach my $b (@{$$result{brokers}}) {
            my $tmp = Infoblox::DXL::Endpoint::Broker->__new__();
            $tmp->__ibap_to_object__($b, $server, $self);
            push @brokers, $tmp;
        }
    }
    return \@brokers;
}

sub __uploadkeytab_result_handler
{
    my ($self, $server, $result, $argsref) = @_;

    if (defined $result->{'keys'}) {
        my @keys;
        foreach my $t (@{$result->{'keys'}}) {
            my $k = Infoblox::Grid::KerberosKey->__new__();
            $k->{'__object_id__'} = $t->{'object_id'}{'id'};
            $k->{'__partial__'} = 1;
            push @keys, $k;
        }

        return [$self->fill_partial_object(\@keys)];
    }
    else {
        return;
    }
}

sub __import_template_handler__ {

    my ($self, $server, $result, $argsref) = @_;

    return undef unless defined $result;

    if ($result->{overall_status} eq 'FAILED') {
        set_error_codes(1012, $result->{error_message}, $self);
        return undef;
    }

    return 1;
}

sub _import_data_csv_result_handler
{
    my ($self, $server, $result, $argsref) = @_;

    my @write_fields = (
                        {
                         field       => 'action',
                         value       => tString(uc($argsref->{'csv_action'})),
                        },
                        {
                         field       => 'separator',
                         value       => tString(uc($argsref->{'separator'})),
                        },
                        {
                         field       => 'update_method',
                         value       => tString(uc($argsref->{'override'})),
                        },
                        {
                         field       => 'operation',
                         value       => tString(uc($argsref->{'operation'})),
                        }
                       );

    if (lc($argsref->{'continue_on_error'}) eq 'true') {
        push @write_fields,
          {
           field       => 'on_error',
           value       => tString('CONTINUE'),
          }
    }
    else {
        push @write_fields,
          {
           field       => 'on_error',
           value       => tString('STOP'),
          }
    }

    #
    eval { my $xresult = $server->ibap_request
             ('ObjectWrite',
              {
               op => 'UPDATE',
               object_type => tString('CSVImportTask'),
               write_fields => tIBType('ArrayOfwrite_field', \@write_fields),
               search_fields => [
                    {
                        'field' => ibap_value_o2i_string('import_id'),
                        'value' => ibap_value_o2i_int($result->{'import_id'}),
                        'search_type' => ibap_value_o2i_string('EXACT'),
                    }],
              }
             );
       };

    return $server->set_papi_error($@, $self, $object) if $@;

    return $result->{'import_id'};
}

sub export_data
{
    my ( $self , %args ) = @_;

    #
    return set_error_codes(1103, "path is required", $self) unless ($args{'path'});
    return set_error_codes(1103, "type is required", $self) unless ($args{'type'});

    if ($args{'type'} eq 'serial_numbers') {
        #
        return _internal_export_serial_numbers($self,\%args);
    }

    if ($ibap_file_export_mapping{$args{'type'}}) {
        #
        foreach (@{$ibap_file_export_mapping{$args{'type'}}{'required'}}) {
            return set_error_codes(1103, "$_ is required", $self) unless ($args{$_});
        }

        if (defined $ibap_file_export_mapping{$args{'type'}}{'handler'}) {
            return $ibap_file_export_mapping{$args{'type'}}{'handler'}(@_);
        }

        my %func_args;
        my $server=$self->get_ibap_server() || return;

        my $func_name = $ibap_file_export_mapping{$args{'type'}}{'func'};
        my $file_id   = $ibap_file_export_mapping{$args{'type'}}{'file_id'}  if defined $ibap_file_export_mapping{$args{'type'}}{'file_id'};
        my $cert_use  = $ibap_file_export_mapping{$args{'type'}}{'cert_use'} if defined $ibap_file_export_mapping{$args{'type'}}{'cert_use'};
        my $operation = $ibap_file_export_mapping{$args{'type'}}{'operation'} if defined $ibap_file_export_mapping{$args{'type'}}{'operation'};

        if ($args{'member'}) {
            #
#
            $func_args{'vnode'} = ibap_value_o2i_member_nocache($args{'member'},$self,'member',0);
        }

        $func_args{'file_id'} = tString($file_id) if defined $file_id;
        $func_args{'cert_use'} = tString($cert_use) if defined $cert_use;
        $func_args{'operation'} = tString($operation) if defined $operation;

        foreach ('start_time', 'end_time') {
            if ($args{$_}) {
                my $t = eval { iso8601_datetime_to_unix_timestamp($args{$_}); };
                return $server->set_papi_error($@, $self) if $@;
                $func_args{$_} = tDateTime($t);
            }
        }

        if($func_name eq 'GetSafeNetClientCert') {
           if ($args{'algorithm'} !~ /^(RSASHA1|RSASHA256)$/) {
             return set_error_codes(1103, $args{'algorithm'} . ' is an unsupported algorithm, valid values are: RSASHA1 or RSASHA256', $self);
           }
           $func_args{'algorithm'} = ibap_value_o2i_string($args{'algorithm'});
        }

        if($func_name eq 'DnsSecExport') {
           $func_args{'zone'}=ibap_arg_zone_convert($session, 'zone', {zone => $args{'zone'}, view => $args{'view'}});
           return unless $func_args{'zone'};
        }

        if($func_name eq 'DownloadCertificate') {
           $func_args{'common_name'}=ibap_value_o2i_string($args{'dn'}) if defined $args{'dn'};
        }

        if($func_name eq 'DnsSecGetZoneKeys') {
           $func_args{'zone'}=ibap_arg_zone_convert($session, 'zone', {zone => $args{'zone'}, view => $args{'view'}});
           return unless $func_args{'zone'};
           $func_args{'key_pair_type'}=ibap_value_o2i_string($ibap_file_export_mapping{$args{'type'}}{'key_pair_type'});
        }

        if ($func_name eq 'GetGridData') {
            if ($args{'backup_type'} && $args{'backup_type'} eq 'SCP') {
                foreach ('backup_server', 'user', 'password') {
                    unless ($args{$_}) {
                        set_error_codes(1107,"For SCP backups '$_' needs to be set",$self);
                        return;
                    }
                }

                my $useroctets= $args{'user'};
                my $passwordoctets= $args{'password'};

                #
                #
                $useroctets = encode('utf-8',$useroctets) if utf8::is_utf8($useroctets);
                $passwordoctets = encode('utf-8',$passwordoctets) if utf8::is_utf8($passwordoctets);

                $useroctets =~ s/([^A-Za-z0-9\-_\.~])/sprintf("%%%02X", ord($1))/seg;
                $passwordoctets =~ s/([^A-Za-z0-9\-_\.~])/sprintf("%%%02X", ord($1))/seg;

                #
                #
                $func_args{'remote_url'} = 'scp://' . $useroctets . ':' . $passwordoctets . '@' . $args{'backup_server'} . '/' . $args{'path'};
            }

            #
            #
            if (!defined $args{'discovery_data'} and
                !defined $args{'nios_data'}      and
                !defined $args{'splunk_app_data'}
            ) {
                if (defined $file_id and $file_id eq 'BACKUP') {
                    $func_args{'discovery_data'} = tBool(0);
                    $func_args{'splunk_app_data'} = tBool(0);
                    $func_args{'nios_data'} = tBool(1);
                }
            } else {
                foreach (
                    'discovery_data',
                    'nios_data',
                    'splunk_app_data',
                ) {
                    if (defined $args{$_}) {
                        $func_args{$_} = ibap_value_o2i_boolean($args{$_}, $_, $self);
                        return unless $func_args{$_};
                    } elsif (defined $file_id and $file_id eq 'BACKUP') {
                        $func_args{$_} = tBool(0);
                    }
                }
            }
        }

        if ($func_name =~ m/^Generate/) {
            $args{'key_size'} = 2048 unless defined $args{'key_size'};
            my $t=ibap_value_o2i_uint($args{'key_size'},'key_size',$self);
            return unless $t;
            $func_args{'key_size'}=$t;

            $t=ibap_value_o2i_string($args{'cn'},'cn',$self);
            return unless $t;

            $args{'algorithm'} = 'SHA-256' unless defined $args{'algorithm'};
            $t = ibap_value_o2i_string($args{'algorithm'}, 'algorithm', $self);
            return unless $t;
            $func_args{'algorithm'} = $t;

            $func_args{'common_name'}=$t;

            foreach (
                     (
                      ['org_unit'   , 'organizational_unit'],
                      ['org'        , 'organization'],
                      ['locality'   , 'locality'],
                      ['state'      , 'state_province'],
                      ['country'    , 'country_code'],
                      ['email'      , 'email_address'],
                      ['comment'    , 'comment'],
                      ['days_valid' , 'validity_period'],
                     )
                    ) {
                my ($papi, $ibap, $validate) = @{$_};

                #
                next if $func_name eq 'GenerateCSR' && $papi eq 'days_valid';

                #
                next unless defined $args{$papi};

                $t=ibap_value_o2i_string($args{$papi},$papi,$self);
                return unless $t;
                $func_args{$ibap}=$t;
            }
        }

        if ($func_name eq 'GetLogFiles') {

            unless ($args{msserver} or $args{member} or $args{endpoint}) {
                unless ($args{log_type} and $args{log_type} =~ m/delta/i) {
                    set_error_codes(1103, 'One of member, endpoint or msserver is required', $self);
                    return undef;
                }
            }

            if ($args{log_type} and $args{log_type} =~ m/outbound/i and not $args{endpoint}) {
                set_error_codes(1103, 'Endpoint is required for OUTBOUND log type', $self);
                return undef;
            }

            if ($args{'msserver'}) {
                $func_args{'server'} = ibap_readfield_simple_string('MsServer', 'address', $args{'msserver'});
            }

            if ($args{endpoint}) {
                $func_args{'endpoint'} = ibap_readfield_simple_string('EndpointRestApi', 'name', $args{'endpoint'});
            }

            if ($args{'include_rotated'}) {
                $func_args{'include_rotated'} = ibap_value_o2i_boolean($args{'include_rotated'});
                return unless $func_args{'include_rotated'};
            }

            if ($args{'node_type'}) {
                if ($args{'node_type'} =~ m/passive/i) {
                    $func_args{'node_type'} = tString('BACKUP');
                }
                elsif ($args{'node_type'} =~ m/active/i) {
                    $func_args{'node_type'} = tString('ACTIVE');
                }
                else {
                    return set_error_codes(1103, $args{'node_type'} .
                        ' is an unsupported node_type, valid values are: "active" or "passive"', $self);
                }
            }
            else {
                #
                $func_args{'node_type'} = tString('ACTIVE');
            }

            $func_args{'file_format'} = tString('TAR_GZ');

            if ($args{'log_type'}) {
                if ($args{'log_type'} =~ m/audit/i) {
                    $func_args{'file_id'} = tString('AUDITLOG');
                }
                elsif ($args{'log_type'} =~ m/msmgmt/i) {
                    $func_args{'file_id'} = tString('MSMGMTLOG');
                }
                elsif ($args{'log_type'} =~ m/sys/i) {
                    $func_args{'file_id'} = tString('SYSLOG');
                }
                elsif ($args{'log_type'} =~ m/outbound/i) {
                    $func_args{'file_id'} = tString('OUTBOUND');
                    $func_args{'file_format'} = tString('TEXT');
                }
                else {
                    return set_error_codes(1103, $args{'log_type'} . ' is an unsupported log_type, valid values are: ' .
                        '"outbound", "audit", "msmgmt" or "syslog"', $self);
                }
            }
            else {
                #
                $func_args{'file_id'} = tString('SYSLOG');
            }
        }


        if ($func_name eq 'GetSupportFiles') {
            #
            $func_args{'node_type'} = tString('BOTH');

            #
            #
            #
            #
            my %filetype_name_mappings = (
                                          'log_files'        => 'log_files',
                                          'rotate_log_files' => 'rotated_log_files',
                                          'core_files'       => 'core_files',
                                          'cached_zone_data' => 'cached_zone_data',
                                         );

            foreach (keys %filetype_name_mappings) {
                if ($args{$_}) {
                    $func_args{'bundle_select'}{$filetype_name_mappings{$_}} = ibap_value_o2i_boolean($args{$_},$filetype_name_mappings{$_},$self);
                    return unless $func_args{'bundle_select'}{$filetype_name_mappings{$_}};
                }
                else {
                    $func_args{'bundle_select'}{$filetype_name_mappings{$_}} = ibap_value_o2i_boolean($_ eq 'cached_zone_data' ? 'false' : 'true');
                }
            }
        }

        if ($func_name eq 'ExportTemplateRestApiSchema') {

            if (defined $args{'schema_type'}) {

                if (my $type = {
                    'REST_ENDPOINT' => 'SESSION_MANAGEMENT',
                    'REST_EVENT'    => 'ACTION',
                }->{$args{'schema_type'}}) {
                    $func_args{'schema_type'} = tString($type);

                } else {
                    set_error_codes(1103, "Invalid value for 'schema_type' argument (" .
                        $args{'schema_type'} . "). Valid values are 'REST_ENDPOINT' "  .
                        "and 'REST_EVENT'.", $self
                    );

                    return undef;
                }
            }

            if (defined $args{'version'}) {
                if (not ref $args{'version'}) {
                    $func_args{'version'} = tString($args{'version'});
                } else {
                    set_error_codes(1103, "Invalid value for 'version' argument (" .
                        ref $args{'version'} . "). Valid value is string.", $self
                    );

                    return undef;
                }
            }
        }

        if ($func_name eq 'ExportTemplateRestApi') {
            unless (ref $args{'template'} eq 'Infoblox::Notification::REST::Template') {

                set_error_codes(1103, "Invalid value for 'template' argument (" .
                    ref $args{'template'} . "). Valid value is an " . "
                    Infoblox::Notification::REST::Template object.", $self
                );

                return undef;
            }

            my ($success, $ignore, $res) = ibap_o2i_object_by_oid_or_name(
                $self, $self, 'template', \%args);

            return undef unless $success and not $ignore;
            $func_args{'template'} = $res;
        }

        $func_args{'import_id'} = tUInteger($args{'import_id'}) if defined $args{'import_id'};

        $func_args{'file_format'} = $ibap_file_export_mapping{$args{'type'}}{'format'} if defined $ibap_file_export_mapping{$args{'type'}}{'format'};

        if ($args{'namedacl'}) {
            $func_args{'defined_acl'} = Infoblox::Util::object_by_oid_or_readfield_helper($self, 'namedacl', $args{'namedacl'}, 1, 'name');
            return unless defined $func_args{'defined_acl'};
        }

        return $self->_do_export_data($server,$func_name,\%func_args,\%args);
    }
    else {
        return set_error_codes(1113, '"' . $args{'type'} . '" is not a supported function', $self);
    }
}

sub _export_data_csv_handler
{
    my ( $self , %args ) = @_;
    my %func_args;
    my $func_name = $ibap_file_export_mapping{$args{'type'}}{'func'};

    my $objtype = $args{'object_type'};
    my $separator = 'COMMA';
    my $server=$self->get_ibap_server() || return;

    if (defined $args{'separator'}) {
        unless ($args{'separator'} =~ m/^comma|space|tab|semicolon$/i) {
            return set_error_codes(1103, $args{'separator'} . ' is not a valid value for separator; valid values are: "comma", "space", "tab" or "semicolon"', $self);
        }
        $separator = uc($args{'separator'});
    }

    my %control_args;
    foreach my $t ('type','object_type','separator','path') {
        $control_args{$t} = $args{$t};
        delete $args{$t};

        my $x = '_' . $t;
        if (defined $args{$x}) {
            $args{$t} = $args{$x};
            delete $args{$x};
        }
    }

    my $object;
    eval { $object = $objtype->__new__(); };
    return set_error_codes(1103, "$objtype is not a valid object type", $self) if $@;
    $ibap_object_type = $object->__ibap_object_type__("search", $self, \%args);

    my %acceptable_ibap_types = (
                                 'ARecord'               => 1,
                                 'AaaaRecord'            => 1,
                                 'AllNetwork'            => 1,
                                 'AllZone'               => 1,
                                 'BulkHost'              => 1,
                                 'CnameRecord'           => 1,
                                 'DhcpFailoverAssoc'     => 1,
                                 'DhcpFingerprint'       => 1,
                                 'DhcpFingerprintFilter' => 1,
                                 'DhcpMacFilter'         => 1,
                                 'DhcpRange'             => 1,
                                 'DnameRecord'           => 1,
                                 'Dns64SynthesisGroup'   => 1,
                                 'FixedAddress'          => 1,
                                 'GridDhcp'              => 1,
                                 'GridDns'               => 1,
                                 'HostRecord'            => 1,
                                 'IPv6DhcpRange'         => 1,
                                 'IPv6FixedAddress'      => 1,
                                 'IPv6Network'           => 1,
                                 'IPv6NetworkContainer'  => 1,
                                 'IPv6OptionDefinition'  => 1,
                                 'IPv6OptionSpace'       => 1,
                                 'IPv6SharedNetwork'     => 1,
                                 'Lease'                 => 1,
                                 'MacFilterAddress'      => 1,
                                 'Member'                => 1,
                                 'MemberDhcp'            => 1,
                                 'MemberDns'             => 1,
                                 'MxRecord'              => 1,
                                 'NacFilter'             => 1,
                                 'NaptrRecord'           => 1,
                                 'Network'               => 1,
                                 'NetworkContainer'      => 1,
                                 'NetworkView'           => 1,
                                 'NsGroup'               => 1,
                                 'NsRecord'              => 1,
                                 'OptionDefinition'      => 1,
                                 'OptionFilter'          => 1,
                                 'OptionSpace'           => 1,
                                 'PtrRecord'             => 1,
                                 'RelayAgentFilter'      => 1,
                                 'RirOrganization'       => 1,
                                 'Ruleset'               => 1,
                                 'SharedNetwork'         => 1,
                                 'SrvRecord'             => 1,
                                 'TxtRecord'             => 1,
                                 'View'                  => 1,
                                 'ZoneChild'             => 1, # DNS::AllRecords

                                 #
                                 'AnalyticsDomainWhiteList'           => 1,
                                 'DefinedACL'                         => 1,
                                 'HostAddress'                        => 1,
                                 'IPv6HostAddress'                    => 1,
                                 'IdnsTopology'                       => 1,
                                 'IdnsTopologyRule'                   => 1,
                                 'IpBlock'                            => 1,
                                 'IpBlockGroup'                       => 1,
                                 'ResponsePolicyARecord'              => 1,
                                 'ResponsePolicyAaaaRecord'           => 1,
                                 'ResponsePolicyClientIPAddress'      => 1,
                                 'ResponsePolicyClientIPAddressCname' => 1,
                                 'ResponsePolicyCnameRecord'          => 1,
                                 'ResponsePolicyIPARecord'            => 1,
                                 'ResponsePolicyIPAaaaRecord'         => 1,
                                 'ResponsePolicyIPAddress'            => 1,
                                 'ResponsePolicyIPAddressCname'       => 1,
                                 'ResponsePolicyMxRecord'             => 1,
                                 'ResponsePolicyNaptrRecord'          => 1,
                                 'ResponsePolicyPtrRecord'            => 1,
                                 'ResponsePolicySrvRecord'            => 1,
                                 'ResponsePolicyTxtRecord'            => 1,
                                 'ResponsePolicyZoneChild'            => 1,
                                 'UpgradeGroup'                       => 1,

                                 'AtpProfile'                         => 1,
                                 'AtpProfileRule'                     => 1,
                                );

    unless (defined $acceptable_ibap_types{$ibap_object_type}) {
        return set_error_codes(1103, "$objtype is not a supported value for object_type", $self);
    }

    my $search_query = $self->_search_parameters_helper($object,\%args,'search');
    return unless $search_query;
    $func_args{'search_fields'} = $search_query;
    $func_args{'object_types'} = [tString($ibap_object_type)];
    $func_args{'separator'} = tString($separator);

    return $self->_do_export_data($server,$func_name,\%func_args,\%control_args);
}

sub _do_export_data
{
    my ($self, $server, $func_name, $func_args, $argsref) = @_;
    my $result;

    #
    eval { $result = $server->ibap_request($func_name, $func_args); };
    if ($@) {
        #
        #
        if (ref($@) && $@->can('text')) {
            set_error_codes(1028,$@->text(),$self);
        }
        else {
            set_error_codes(1028,$@,$self);
        }
        return;
    }

    my $dataref;
    if ($func_name eq 'ValidateACItems') {
        if (defined $result->{'validation_result'}) {
            $dataref = $result->{'validation_result'};
        } else {
            return 1; # if Named ACL object is ok, the server doesn't return result file
        }
    }
    else {
        $dataref = $result->{'data_ref'};
    }

    if ($func_name eq 'GenEndpointDxlCertificates') {
        foreach (
            ['client_cert', $argsref->{'path'}],
            ['ca_cert', $argsref->{'ca_cert_path'}],
        ) {
            my $dataref = $result->{$_->[0]};
            my $path    = $_->[1];

            $self->__dataref_handler__($server, $dataref, $path, $argsref->{type}) || return undef;
        }

        return 1;
    }

    $self->__dataref_handler__($server, $dataref, $argsref->{path}, $argsref->{type}) || return undef;
    return 1;
}

sub __dataref_handler__ {

    my ($self, $server, $dataref, $path, $type) = @_;

    if ($$dataref{'data_mode'} eq 'DATA_REF') {
        $self->__download_file__($server, $dataref, $path) || return undef;
    }
    elsif ($$dataref{'data_mode'} eq 'DATA_INLINE') {
        $self->__save_file__($dataref, $path) || return undef;
    }
    else {
        return set_error_codes(1113, '"' . $type . '" is not a supported function', $self);
    }

    eval {
        $result = $server->ibap_request(
            'DataGetComplete',
            {'data_ref' => tIBType('data_ref', $dataref)});
    };

    if ($@) {
        $server->set_papi_error($@, $self);
        return undef;
    }

    return 1;
}

sub __download_file__ {

    my ($self, $server, $dataref, $path) = @_;

    my $masterurl = $$dataref{'url'};
    $host_ip = $self->{"master"};
    if ($host_ip =~ m/:.*:/ && $host_ip !~ m/\[/) {
        $host_ip = "[$host_ip]";
    }
    $masterurl =~ s!https://[^/]*!https://$host_ip!;
    $masterurl =~ s/ /%20/g;

    my $retrieved_data = $server->request(
        HTTP::Request->new('GET',
                           $masterurl,
                           HTTP::Headers->new(
                                'accept' => ['*/*'],
                                'content-type' => 'application/force-download',
                                'user-agent' => 'PAPI-1.0/Agent',
                           )
                          ),
                          $path,
    );

    unless ($retrieved_data->is_success()) {
        set_error_codes(1004,$retrieved_data->status_line);
        return;
    }

    if ($retrieved_data->header('X-Died')) {
        set_error_codes(1004, $retrieved_data->header('X-Died'), $self);
        return;
    }

    return $retrieved_data;
}

sub __save_file__ {

    my ($self, $dataref, $path) = @_;

    unless (open(DATAFILE, '>' . $path)) {
        set_error_codes(1001, "Cannot open $path", $self);
        return;
    }
    unless (print DATAFILE $$dataref{'data'}) {
        set_error_codes(1001, "Cannot write to $path", $self);
        return;
    }

    close(DATAFILE);
    return 1;
}

sub _internal_export_serial_numbers
{
    my ($self, $argsref) = @_;
    my $server=$self->get_ibap_server() || return;

    #
    eval {
        $result = $server->ObjectRead({object_type => 'Member',
                                       depth => 1,
                                       return_fields =>
                                           [
                                            tField('ha_enabled'),
                                            tField('node_info',
                                                   {
                                                    sub_fields => [
                                                                   tField('serial_number'),
                                                                   tField('lan_ha_port_setting',
                                                                          {
                                                                           sub_fields => [
                                                                                          tField('public_ip_address'),
                                                                                         ]
                                                                          }),
                                                                  ]
                                                   }),
                                            tField('vip_setting',
                                                   {
                                                    sub_fields => [
                                                                   tField('address'),
                                                                  ]
                                                   }
                                                  ),
                                           ]});
    };
    return $server->set_papi_error($@, $self) if $@;

    my %serials;
    foreach my $current (@$result) {
        if ($current->{'ha_enabled'}) {
            $serials{@{$current->{'node_info'}}[0]->{'serial_number'}} = @{$current->{'node_info'}}[0]->{'lan_ha_port_setting'}->{'public_ip_address'};
            $serials{@{$current->{'node_info'}}[1]->{'serial_number'}} = @{$current->{'node_info'}}[1]->{'lan_ha_port_setting'}->{'public_ip_address'};
        }
        else {
            $serials{@{$current->{'node_info'}}[0]->{'serial_number'}} = $current->{'vip_setting'}->{'address'};
        }
    }

    unless (open(DATAFILE, '>'.$argsref->{'path'})) {
        set_error_codes(1001,"Cannot open " . $argsref->{'path'},$self );
        return;
    }

    foreach (keys %serials) {
        if (defined $serials{$_}) {
            print DATAFILE "\nLAN IP: $serials{$_}\n";
        }
        else {
            print DATAFILE "\nLAN IP: \n";
        }
        print DATAFILE "Serial No: $_\n";
    }

    close(DATAFILE);
    return 1;
}

sub rotate_log_files {
    my ( $self , %args ) = @_;
    my (%fcall_args);

    set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

    unless (defined $server) {
        set_error_codes(1006,"Creating session with the server failed.",$self);
        return;
    }

    unless( defined $args{'log_type'} ) {
        set_error_codes(1002, "'log_type' argument is required", $self);
        return;
    }

    if ($args{'log_type'} eq 'audit') {
        $fcall_args{'log_type'} = tString('AUDITLOG');
    }
    elsif ($args{'log_type'} eq 'sys') {
        $fcall_args{'log_type'} = tString('SYSLOG');
    }
    elsif ($args{'log_type'} eq 'msmgmt') {
        unless( defined $args{'server'} ) {
            set_error_codes(1002, "'server' argument is required for the 'msmgmt' log type", $self);
            return;
        }
        $fcall_args{'server'} = ibap_readfield_simple_string('MsServer', 'address', $args{'server'});
        $fcall_args{'log_type'} = tString('MSMGMTLOG');
    }
    else {
        return set_error_codes(1103,"\'$args{'log_type'}\' is an unsupported log type", $self);
    }

    #
    #
    if ($args{'log_type'} ne 'audit') {
        unless( defined $args{'node_type'} ) {
            set_error_codes(1002, "'node type' argument is required for the \'$args{'log_type'}\' log type", $self);
            return;
        }
        unless( defined $args{'member'} ) {
            set_error_codes(1002, "'member' argument is required for the \'$args{'log_type'}\' log type", $self);
            return;
        }
        $fcall_args{'node_type'} = ibap_value_o2i_string(uc($args{'node_type'}));
        $fcall_args{'member'} = ibap_readfield_simple_string('Member', 'host_name', $args{'member'}, 'member');
    }
    eval { $result = $server->ibap_request('RotateLog', \%fcall_args); };
    return $server->set_papi_error($@, $self, undef, '1012=1001') if $@;

    return 1;
}

sub _deserialization_tester_objectread
{
    my ($self, $response, $object_type) = @_;

    #
    #
    #
    #
    #
    #
    #

    set_error_codes(0,undef,$self);

    use Time::HiRes qw(gettimeofday tv_interval );
    my $t=[gettimeofday];
    my $temp = deserialize_request($response);
    my $deser_time=tv_interval($t);

    my $a = $temp->{'SOAP-ENV:Envelope'}->{'SOAP-ENV:Body'}->{'ib:ObjectReadResponse'}->{'objects'};
    if (ref($a) eq 'ARRAY') {
        $ret = $a;
    } else {
        $ret = [$a];
    }

    my @results_array;
    my %return_object_cache;

    my $ave_creation_time=0.0;
    my $max_creation_time=0.0;
    my $min_creation_time=1000.0;
    my $max_creation_which=0;
    my $min_creation_which=0;
    my $creation_time=0.0;

    my $ave_accessor_time=0.0;
    my $max_accessor_time=0.0;
    my $min_accessor_time=1000.0;
    my $max_accessor_which=0;
    my $min_accessor_which=0;
    my $accessor_time=0.0;

    my $i=0;
    foreach my $result_ref (@{$ret}) {
        $i++;

        #
        #
        #
        #
        #
        my $objtype = $object_type ? $object_type : $papi_object_type_from_wsdl{ref($result_ref)};
        if (!$objtype) {
            set_error_codes(1141, "Could not determine the object type (" . ref($result_ref) . ")", $self);
            return 0;
        }

        $t=[gettimeofday];
        my $result_object=$objtype->__new__();
        $t=tv_interval($t);
        if ($t > $max_creation_time) {
            $max_creation_time = $t;
            $max_creation_which = $i;
        }
        $ave_creation_time += $t;

        if ($t < $min_creation_time) {
            $min_creation_time = $t;
            $min_creation_which = $i;
        }

        $creation_time += $t;

        $t=[gettimeofday];
        $result=$result_object->__ibap_to_object__($result_ref, $server, $self, \%return_object_cache);
        $t=tv_interval($t);

        if ($t > $max_accessor_time) {
            $max_accessor_time = $t;
            $max_accessor_which = $i;
        }

        $ave_accessor_time += $t;

        if ($t < $min_accessor_time) {
            $min_accessor_time = $t;
            $min_accessor_which = $i;
        }

        $accessor_time += $t;

        if ((defined($result) && $result == 1) || $self->status_code() != 0) {
            return 0;
        }

        if ($wanted_members_ref) {
            $result_object->{'__partial__'} = 1;
        }
        push @results_array, $result_object;
    }

    $ave_creation_time = $ave_creation_time / $i;
    $ave_accessor_time = $ave_accessor_time / $i;

    set_error_codes($self->status_code(), $self->status_detail());

    if (Infoblox->status_code() != 0) {
        return;
    }

    $self->__time__($deser_time.':'.$creation_time.':'.$accessor_time.':'.$ave_creation_time.':'.$max_creation_time.':'.$max_creation_which.':'.$min_creation_time.':'.$min_creation_which.':'.$ave_accessor_time.':'.$max_accessor_time.':'.$max_accessor_which.':'.$min_accessor_time.':'.$min_accessor_which);

    if (wantarray) {
        return @results_array;
    } else {
        return \@results_array;
    }
}

sub get_ksk_rollover {
    my ( $self , %args ) = @_;
    my (%fcall_args);

    set_error_codes(0,undef,$self);
    my $server=$self->get_ibap_server() || return;

    unless (defined $server) {
        set_error_codes(1006,"Creating session with the server failed.",$self);
        return;
    }

    if(defined $args{'days'}) {
        my $t=ibap_value_o2i_uint($args{'days'},'days',$self);
        return unless $t;
        $fcall_args{'num_days_to_countdown'}=$t;
    }

    eval { $result = $server->ibap_request('DnsSecGetKskRollover', \%fcall_args); };
    return $server->set_papi_error($@, $self, undef, '1012=1001') if $@;

    my @res;
    if ($result->{'zone_list'}) {
        foreach (@{$result->{'zone_list'}}) {
            push @res, {
                        name => $_->{'display_domain'},
                        view => $_->{'view_name'},
                        days => $_->{'days'},
                       };
        }
    }

    return \@res;
}


my %test_mapping = (
    'Infoblox::OCSP::Responder' =>
                    {
                     'func'     => \&__test_ocsp_responder__,
                     'returns'  => 'asis',
                     'newobjok' => 1,
                    },
    'Infoblox::LDAP::Server' =>
                    {
                     'func'     => \&__test_ldap_server__,
                     'returns'  => 'asis',
                     'newobjok' => 1,
                    },
    'Infoblox::DXL::Endpoint::Broker' =>
                    {
                     'func'     => \&__test_dxl_endpoint_broker__,
                     'returns'  => 'asis',
                     'newobjok' => 1,
                    },
    'Infoblox::CiscoISE::Endpoint' => {
                                       'func' => \&__test_cisco_ise_endpoint__,
                                       'returns' => 'asis',
                                      },
    'Infoblox::Notification::REST::Endpoint' => {
                                      'func' => \&__test_restapi_endpoint__,
                                      'returns' => 'asis',
                                      'newobjok' => 1,
                                     },
    'Infoblox::Notification::Rule' => {
                                      'func' => \&__test_notification_rule__,
                                      'returns' => 'asis',
                                     },
    'Infoblox::Grid::SyslogServer' =>
                    {
                     'func'     => \&__test_syslog_server__,
                     'returns'  => 'asis',
                     'newobjok' => 1,
                    },
    'Infoblox::Grid::SyslogBackupServer' =>
                    {
                     'func'     => \&__test_syslog_backup_server__,
                     'returns'  => 'asis',
                     'newobjok' => 1,
                    },
                   );

sub __test_ocsp_responder__
{
    my ($session, $server, $args ) = @_;
    my (%fcall_args, $result);

    my $cas = $$args{'certificate_auth_service'};

    if ($cas and not ref $cas) {
        my $obj = Infoblox::Grid::Admin::CertificateAuthService->__new__();
        $obj->{name} = $cas;
        $cas = $obj;
    }

    if ($cas and ref $cas eq 'Infoblox::Grid::Admin::CertificateAuthService') {
        my ($success, $ignore, $res) = ibap_o2i_object_by_oid_or_name(
            $session, $session, 'object', {'object' => $cas});
        return undef unless $success;
        $fcall_args{'ocsp_auth_service'} = $res unless $ignore;
    } elsif ($cas) {
        set_error_codes('1104', 'Invalid object type for certificate_auth_service', $session);
        return undef;
    }

    my $o2i = $args->{'object'}->__object_to_ibap__($server, $session);
    return unless $o2i;

    my %fields = map { $_->{'field'} => $_->{'value'} } @$o2i;

    $fcall_args{'fqdn_or_ip'} = $fields{'fqdn_or_ip'};
    $fcall_args{'cert_data_ref'} = $fields{'certificate_data_ref'} if defined($fields{'certificate_data_ref'}); # optional for test
    $fcall_args{'port'} = defined($fields{'port'}) ? $fields{'port'} : ibap_value_o2i_uint(80);

    eval { $result = $server->ibap_request('TestOcspResponderSettings', \%fcall_args); };
    return $server->set_papi_error($@, $session) if $@;
    return $result->{'validateResult'};
}

sub __test_ldap_server__
{
    my ($session, $server, $args) = @_;
    my (%fcall_args, $result);

    if (defined $$args{'timeout'}) {
        $fcall_args{'timeout'} = ibap_value_o2i_string($$args{'timeout'});
    }

    if (defined $$args{'ldap_service'}) {
        if (ref($$args{'ldap_service'}) ne 'Infoblox::LDAP::AuthService') {
            return set_error_codes(1104, 'Invalid object type for ldap_service', $self);
        }

        if ($$args{'ldap_service'}->__object_id__()) {
            $fcall_args{'ldap_service'} = tObjIdRef($$args{'ldap_service'}->__object_id__());
        } else {
            return set_error_codes(1012, "The " . ref($$args{'ldap_service'}) . " must be retrieved from the appliance before using it.");
        }
    }

    $fcall_args{'ldap_server'} = ibap_serialize_substruct($session, $$args{'object'}, 'ldap_server');

    eval { $result = $server->ibap_request('TestLdapServerSettings', \%fcall_args); };
    return $server->set_papi_error($@, $session, undef, '1012=1001') if $@;
    return 1;
}

sub __test_cisco_ise_endpoint__ {

    my ($session, $server, $args) = @_;
    my ($fname, $fargs) = ('TestEndpointCiscoISEConnection', {});
    my ($endp, $result);

    my ($success, $ignore, $res) = ibap_o2i_object_only_by_oid($self, $session, 'object', $args);

    return 0 unless $success;
    $$fargs{'cisco_iseobj'} = $res unless $ignore;

    eval {
        $result = $server->ibap_request($fname, $fargs);
    };

    return $server->set_papi_error($@, $session) if $@;
    return $result->{'result'};
}

sub __test_restapi_endpoint__ {

    my ($session, $server, $args) = @_;
    my ($fname, $fargs) = ('TestConnectivityEndpointRestApi', {});

    unless ($$args{object}{uri} || $$args{object}->__object_id__()) {
        set_error_codes(1012, 'In order to test connectivity uri '        .
            'should be set for Infoblox::Notification::REST::Endpoint'    .
            'or object should have been retrieved from the server first.',
            $session);
        return 0;
    }

    if ($$args{object}->__object_id__()) {
        $$fargs{endpoint} = tObjIdRef($$args{object}->__object_id__());
    } else {
        my $o2i = $$args{object}->__object_to_ibap__($server, $session);
        return undef unless $o2i;

        foreach my $val (@$o2i) {
            if (
                my $k = {
                    'uri'                         => 1,
                    'password'                    => 1,
                    'username'                    => 1,
                    'server_cert_validation'      => 1,
                    'client_certificate_data_ref' => 'client_certificate',
                }->{$$val{'field'}}
            ) {
                $$fargs{$k eq '1' ? $$val{'field'} : $k} = $$val{'value'} if $k;
            }
        }
    }

    eval {
        $result = $server->ibap_request($fname, $fargs);
    };

    return $server->set_papi_error($@, $session) if $@;

    my $t = Infoblox::Grid::TestResult->__new__();
    $t->__ibap_to_object__($result, $server, $session);

    return $t;
}

sub __test_dxl_endpoint_broker__ {

    my ($session, $server, $args) = @_;
    my ($fname, $fargs) = ('TestConnectivityEndpointDxlBroker', {});

    my $ref_allowed_arguments = {
        'object'             => {mandatory => 1, validator => {'Infoblox::DXL::Endpoint::Broker' => 1}},
        'client_certificate' => {validator => \&ibap_value_o2i_string},
        'endpoint'           => {validator => \&ibap_value_o2i_string},
    };

    return undef unless $session->__validate_arguments_from_arg_list__($ref_allowed_arguments, $args);

    unless (defined $$args{client_certificate} or defined $$args{endpoint}) {
        set_error_codes('1001', 'At least one of arguments: \'client_certificate\', \'endpoint\' is required.', $session);
        return 0;
    }

    $$fargs{broker} = ibap_serialize_substruct($session, $args->{object}, 'endpoint_dxl_broker') || return undef;

    if (defined $$args{client_certificate}) {
        my ($success, $ignore, $res) = ibap_o2i_cert_data_ref($self, $session, 'client_certificate', $args);
        return undef unless $success;
        $$fargs{client_certificate} = $res unless $ignore;
    }

    if (defined $$args{endpoint}) {
        my $res = ibap_readfield_simple_string('EndpointDxl', 'name', $$args{endpoint}, 'endpoint');
        $$fargs{endpoint} = $res || return undef;
    }

    eval {
        $result = $server->ibap_request($fname, $fargs);
    };

    return $server->set_papi_error($@, $session) if $@;

    my $t = Infoblox::Grid::TestResult->__new__();
    $t->__ibap_to_object__($result, $server, $session);

    return $t;
}

sub __test_notification_rule__ {
    my ($session, $server, $args) = @_;
    my (%fcall_args, $result);


    if (defined $$args{'event_text'}) {
        $fcall_args{'event_text'} = ibap_value_o2i_string($$args{'event_text'});
    }
    else {
        set_error_codes(1002, 'event_text is required field', $self);
        return;
    }

    my ($success, $ignore, $res) = ibap_o2i_object_only_by_oid($self, $session, 'object', $args);

    return 0 unless $success;
    $fcall_args{'notification_rule'} = $res unless $ignore;

    eval { $result = $server->ibap_request('TriggerOutboundNotificationRule', \%fcall_args) };
    return $server->set_papi_error($@, $session) if $@;
    return 1;
}

sub __test_syslog_server__
{
    my ($session, $server, $args) = @_;
    my ($syslog_server, $result);

    $syslog_server = ibap_serialize_substruct($session, $$args{object}, 'syslog_server');
    return 0 unless $syslog_server;

    eval { $result = $server->ibap_request('TestSyslogConnection', { syslog_server => $syslog_server }) };
    return $server->set_papi_error($@, $session) if $@;
    return $result->{'validateResult'};
}

sub __test_syslog_backup_server__
{
    my ($session, $server, $args) = @_;
    my ($syslog_backup_server, $result);

    my %fargs;

    $fargs{'syslog_backup_server'} = ibap_serialize_substruct($session, $$args{object}, 'syslog_backup_server');
    return 0 unless $fargs{'syslog_backup_server'};

    if ($$args{'member'}) {
        $fargs{'member'} = ibap_readfield_simple_string('Member', 'host_name', $$args{member}, 'grid_member');
        return 0 unless $fargs{'member'};
    }

    eval {
        $result = $server->ibap_request(
            'TestSyslogBackupServerConnection',\%fargs)
    };

    return $server->set_papi_error($@, $session) if $@;
    return $result->{'validateResult'};
}



sub test
{
    my ($self, %args) = @_;

    my $server = $self->get_ibap_server() || return;

    unless (defined($server)) {
        set_error_codes(1006, "Creating session with the server failed.", $self);
        return;
    }

    unless( defined $args{'object'} && ref($args{'object'})) {
        set_error_codes(1002, "object is required and must be a valid PAPI object.", $self);
        return;
    }

    my $type = ref($args{'object'});
    unless( $test_mapping{$type} ) {
        set_error_codes(1002, "$type is not a supported object for the test function.", $self);
        return;
    }

    unless ($test_mapping{$type}{'newobjok'} || $args{'object'}->__object_id__()) {
        set_error_codes(1002, "The object must have been retrieved from the appliance in order to test it.", $self);
        return;
    }

    my $result = $test_mapping{$type}{'func'}($self, $server, \%args);
    if ($test_mapping{$type}{'returns'} eq 'statuscode') {
        #
        return $self->status_code();
    } elsif ($test_mapping{$type}{'returns'} eq 'asis') {
        return $result;
    }
    else {
        #
        return 0;
    }
}

sub discovery_diagnostics
{
    my ($self, %args) = @_;

    my $discovery = Infoblox::Grid::Discovery->new('session' => $self);
    return $discovery->diagnostics(%args);
}

sub discovery_diagnostics_status
{
    my ($self, %args) = @_;

    my $discovery = Infoblox::Grid::Discovery->new('session' => $self);
    return $discovery->diagnostics_status(%args);
}

sub start_discovery
{
    my ($self, %args) = @_;

    my $discovery = Infoblox::Grid::Discovery->new('session' => $self);
    return $discovery->start_discovery(%args);
}

sub control_ip_address
{
    my ($self, %args) = @_;

    my $discovery = Infoblox::Grid::Discovery->new('session' => $self);
    return $discovery->control_ip_address(%args);
}

#

sub convert_dynamic_lease
{
    return set_error_codes(1113, '"convert_dynamic_lease" is not supported.', $self);
}

sub convert_static_lease
{
    return set_error_codes(1113, '"convert_static_lease" is not supported.', $self);
}

sub copy_zone_records
{
    return set_error_codes(1113, '"copy_zone_records" is not supported.', $self);
}

sub delete_replicated_ad_user_and_groups
{
    return set_error_codes(1113, '"delete_replicated_ad_user_and_groups" is not supported.', $self);
}

sub dhcp_remove_expert_mode_config
{
    return set_error_codes(1113, '"dhcp_remove_expert_mode_config" is not supported.', $self);
}

sub expand_network
{
    return set_error_codes(1113, '"expand_network" is not supported.', $self);
}

sub force_recovery
{
    return set_error_codes(1113, '"force_recovery" is not supported.', $self);
}

sub generate_self_signed_cert
{
    return set_error_codes(1113, '"generate_self_signed_cert" is not supported.', $self);
}

sub list_ipam_addresses_in_network
{
    return set_error_codes(1113, '"list_ipam_addresses_in_network" is not supported.', $self);
}

sub list_replication_status
{
    return set_error_codes(1113, '"list_replication_status" is not supported.', $self);
}

sub list_zone_children
{
    return set_error_codes(1113, '"list_zone_children" is not supported.', $self);
}

sub reboot_node
{
    return set_error_codes(1113, '"reboot_node" is not supported.', $self);
}

sub remove_cluster_syslog_server
{
    return set_error_codes(1113, '"remove_cluster_syslog_server" is not supported.', $self);
}

sub remove_eap_cert
{
    return set_error_codes(1113, '"remove_eap_cert" is not supported.', $self);
}

sub remove_eap_csr
{
    return set_error_codes(1113, '"remove_eap_csr" is not supported.', $self);
}

sub remove_member_syslog_server
{
    return set_error_codes(1113, '"remove_member_syslog_server" is not supported.', $self);
}

sub remove_security_access_item
{
    return set_error_codes(1113, '"remove_security_access_item" is not supported.', $self);
}

sub shutdown_node
{
    return set_error_codes(1113, '"shutdown_node" is not supported.', $self);
}

sub split_network
{
    return set_error_codes(1113, '"split_network" is not supported.', $self);
}

sub sync_ad_domain
{
    return set_error_codes(1113, '"sync_ad_domain" is not supported.', $self);
}

sub update_date_time
{
    return set_error_codes(1113, '"update_date_time" is not supported.', $self);
}

sub upgrade_grid
{
    return set_error_codes(1113, '"upgrade_grid" is not supported.', $self);
}

1;
