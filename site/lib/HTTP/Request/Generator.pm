package HTTP::Request::Generator;
use strict;
use Filter::signatures;
use feature 'signatures';
no warnings 'experimental::signatures';
use Algorithm::Loops 'NestedLoops';
use List::MoreUtils 'zip';
use URI;
use URI::Escape;
use Exporter 'import';
use Carp 'croak';

=head1 NAME

HTTP::Request::Generator - generate HTTP requests

=head1 SYNOPSIS

    use HTTP::Request::Generator 'generate_requests';

    @requests = generate_requests(
        method  => 'GET',
        pattern => 'https://example.com/{bar,foo,gallery}/[00..99].html',
    );

    # generates 300 requests from
    #     https://example.com/bar/00.html to
    #     https://example.com/gallery/99.html

    @requests = generate_requests(
        method => 'POST',
        host   => ['example.com','www.example.com'],
        path   => '/profiles/:name',
        url_params => {
            name => ['Corion','Co-Rion'],
        },
        query_params => {
            stars => [2,3],
        },
        body_params => {
            comment => ['Some comment', 'Another comment, A++'],
        },
        headers => [
            {
                "Content-Type" => 'text/plain; encoding=UTF-8',
                Cookie => 'my_session_id',
            },
            {
                "Content-Type" => 'text/plain; encoding=Latin-1',
                Cookie => 'my_session_id',
            },
        ],
    );
    # Generates 32 requests out of the combinations

    for my $req (@requests) {
        $ua->request( $req );
    };

=cut

our $VERSION = '0.10';
our @EXPORT_OK = qw( generate_requests as_dancer as_plack as_http_request
    expand_curl_pattern
);

sub unwrap($item,$default) {
    defined $item
    ? (ref $item ? $item : [$item])
    : $default
}

sub fetch_all( $iterator, $limit=0 ) {
    my @res;
    while( my @r = $iterator->()) {
        push @res, @r;
        if( $limit && (@res > $limit )) {
            splice @res, $limit;
            last
        };
    };
    return @res
};

our %defaults = (
    method       => ['GET'],
    path         => ['/'],
    host         => [''],
    port         => [0],
    scheme       => ['http'],

    # How can we specify various values for the headers?
    headers      => [{}],

    #query_params   => [],
    #body_params  => [],
    #url_params   => [],
    #values       => [[]], # the list over which to iterate for *_params
);

# We want to skip a set of values if they make a test fail
# if a value appears anywhere with a failing test, skip it elsewhere
# or look at the history to see whether that value has passing tests somewhere
# and then keep it?!

sub fill_url( $url, $values, $raw=undef ) {
    if( $values ) {
        if( $raw ) {
            $url =~ s!:(\w+)!exists $values->{$1} ? $values->{$1} : ":$1"!ge;
        } else {
            $url =~ s!:(\w+)!exists $values->{$1} ? uri_escape($values->{$1}) : ":$1"!ge;
        };
    };
    $url
};

# Convert nonref arguments to arrayrefs
sub _makeref {
    map {
        ref $_ ne 'ARRAY' ? [$_] : $_
    } @_
}

sub _extract_enum( $name, $item ) {
    # Explicitly enumerate all ranges
    my @res = @{ $defaults{ $name } || []};

    if( $item ) {
        # Expand all ranges into the enumerated lists
        $item =~ s!\[([^.\]]+?)\.\.([^.\]]+?)\]!"{" . join(",", $1..$2 )."}"!ge;

        # Explode all enumerated items into their list
        # We should punt this into a(nother) iterator, maybe?!
        if( $item =~ /\{.*\}/ ) {
            my $changed = 1;
            @res = $item;
            while ($changed) {
                undef $changed;
                @res = map {
                    my $i = $_;
                    my @r;
                    if( $i =~ /^([^{]*)\{([^}]+)\}([^{]*)/ ) {
                        my($pre, $m, $post) = ($1,$2,$3);
                        $changed = 1;
                        @r = map { "$pre$_$post" } split /,/, $m, -1;
                    } else {
                        @r = $i
                    };
                    @r
                } @res;
            }
        } else {
            @res = $item;
        };
    };
    return \@res
}

sub _extract_enum_query( $query ) {
    my $items = _extract_enum( 'query', $query );
    my %parameters;
    for my $q (@$items) {
        my $u = URI->new('example.com', 'http');
        $u->query($q);
        my %f = $u->query_form;
        for my $k (keys %f) {
            $parameters{ $k }->{ $f{ $k }} = 1;
        };
    };

    for my $v (values %parameters) {
        $v = [ sort keys %$v ];
    };

    \%parameters
}


=head2 C<< expand_curl_pattern >>

    my %res = expand_curl_pattern( 'https://' );
    #

Expands a curl-style pattern to a pattern using positional placeholders.
See the C<curl> documentation on the patterns.

=cut

sub expand_curl_pattern( $pattern ) {
    my %ranges;

    # Split up the URL pattern into a scheme, host(pattern), port number and
    # path (pattern)
    #use Regexp::Debugger;
    #use re 'debug';
    my( $scheme, $host, $port, $path, $query )
        = $pattern =~ m!^(?:([^:]+):)? # scheme
                         /?/?          # optional? slashes
                         (             # hostname
                              \[(?:[:\da-fA-F]+)\]             # ipv6
                             |[^/:\[]+
                                  (?:\[[^/\]]+\][^/:\[]*)*
                                  (?=[:/]|$)                     # plain, or expansion
                             |\[[^:\]]+\][^/:]*                # expansion
                         )
                         (?::(\d+))?   # optional port
                         ([^?]*)       # path
                         (?:\?(.*))?   # optional query part
                         $!x;
    #my( $scheme, $host, $port, $path, $query )
    #    = $pattern =~ m!^(?:([^:]+):)?/?/?(\[(?:[:\da-fA-F]+)\]|[^/:\[]+(?:\[[^/\]]+\][^/:\[]*)*(?=[:/]|$)|\[[^:\]]+\][^/:]*)(?::(\d+))?([^?]*)(?:\?(.*))?$!;

    #no Regexp::Debugger;

    # Explicitly enumerate all ranges
    my $idx = 0;

    if( $scheme ) {
        $scheme =~ s!\[([^.\]]+?)\.\.([^.\[]+?)\]!$ranges{$idx} = [$1..$2]; ":".$idx++!ge;
        $scheme =~ s!\{([^\}]*)\}!$ranges{$idx} = [split /,/, $1, -1]; ":".$idx++!ge;
    };

    if( $host ) {
        $host =~ s!\[([^.\]]+?)\.\.([^.\[]+?)\]!$ranges{$idx} = [$1..$2]; ":".$idx++!ge;
        $host =~ s!\{([^\}]*)\}!$ranges{$idx} = [split /,/, $1, -1]; ":".$idx++!ge;
    };

    if( $port ) {
        $port =~ s!\[([^.\]]+?)\.\.([^.\[]+?)\]!$ranges{$idx} = [$1..$2]; ":".$idx++!ge;
        $port =~ s!\{([^\}]*)\}!$ranges{$idx} = [split /,/, $1, -1]; ":".$idx++!ge;
    };

    if( $path ) {
        $path =~ s!\[([^.\]]+?)\.\.([^.\[]+?)\]!$ranges{$idx} = [$1..$2]; ":".$idx++!ge;
        # Move all explicitly enumerated parts into lists:
        $path =~ s!\{([^\}]*)\}!$ranges{$idx} = [split /,/, $1, -1]; ":".$idx++!ge;
    };

    my %res = (
        url_params   => \%ranges,
        host         => $host,
        scheme       => $scheme,
        port         => $port,
        path         => $path,
        query_params => _extract_enum_query( $query ),
        raw_params   => 1,
    );
    %res
}

sub _generate_requests_iter(%options) {
    my $wrapper = delete $options{ wrap } || sub { wantarray ? @_ : $_[0]};
    my @keys = sort keys %defaults;

    if( my $pattern = delete $options{ pattern }) {
        %options = (%options, expand_curl_pattern( $pattern ));
    };

    my $query_params = $options{ query_params } || {};
    my $body_params = $options{ body_params } || {};
    my $url_params = $options{ url_params } || {};

    $options{ "fixed_$_" } ||= {}
        for @keys;

    # Now only iterate over the non-empty lists
    my %args = map { my @v = unwrap($options{ $_ }, [@{$defaults{ $_ }}]);
                     @v ? ($_ => @v) : () }
               @keys;
    @keys = sort keys %args; # somewhat predictable
    $args{ $_ } ||= {}
        for qw(query_params body_params url_params);
    my @loops = _makeref @args{ @keys };
    #use Data::Dumper; warn Dumper \@loops, \@keys, \%options;

    # Turn all query_params into additional loops for each entry in keys %$query_params
    # Turn all body_params into additional loops over keys %$body_params
    my @query_params = keys %$query_params;
    push @loops, _makeref values %$query_params;
    my @body_params = keys %$body_params;
    push @loops, _makeref values %$body_params;
    my @url_params = keys %$url_params;
    push @loops, _makeref values %$url_params;

    #use Data::Dumper; warn "Looping over " . Dumper \@loops;

    my $iter = NestedLoops(\@loops,{});

    # Set up the fixed parts
    my %template;

    for(qw(query_params body_params headers)) {
        $template{ $_ } = $options{ "fixed_$_" } || {};
    };

    return sub {
        my @v = $iter->();
        return unless @v;
        #use Data::Dumper; warn Dumper \@v;

        # Patch in the new values
        my %values = %template;
        my @vv = splice @v, 0, 0+@keys;
        @values{ @keys } = @vv;

        # Now add the query_params, if any
        if(@query_params) {
            my @get_values = splice @v, 0, 0+@query_params;
            $values{ query_params } = { (%{ $values{ query_params } }, zip( @query_params, @get_values )) };
        };
        # Now add the body_params, if any
        if(@body_params) {
            my @values = splice @v, 0, 0+@body_params;
            $values{ body_params } = { %{ $values{ body_params } }, zip @body_params, @values };
        };

        # Recreate the URL with the substituted values
        if( @url_params ) {
            my %v;
            @v{ @url_params } = splice @v, 0, 0+@url_params;
            #use Data::Dumper; warn Dumper \%values;
            for my $key (qw(scheme host port path )) {
                $values{ $key } = fill_url($values{ $key }, \%v, $options{ raw_params });
            };
        };

        $values{ url } = _build_uri( \%values );

        # Merge the headers as well
        #warn "Merging headers: " . Dumper($values{headers}). " + " . (Dumper $template{headers});
        %{$values{headers}} = (%{$template{headers}}, %{$values{headers} || {}});
        return $wrapper->(\%values);
    };
}

sub _build_uri( $req ) {
    my $uri = URI->new( '', $req->{scheme} );
    if( $req->{host}) {
        $uri->host( $req->{host});
        $uri->scheme( $req->{scheme});
        $uri->port( $req->{port}) if( $req->{port} and $req->{port} != $uri->default_port );
    };
    $uri->path( $req->{path});
    # We want predictable URIs, so we sort the keys here instead of
    # just passing the hash reference
    $uri->query_form( map { $_ => $req->{query_params}->{$_} } sort keys %{ $req->{query_params} });
    #$uri->query_form( $req->{query_params});
    $uri
}

=head2 C<< generate_requests( %options ) >>

  my $g = generate_requests(
      url => '/profiles/:name',
      url_params => ['Mark','John'],
      wrap => sub {
          my( $req ) = @_;
          # Fix up some values
          $req->{headers}->{'Content-Length'} = 666;
          return $req;
      },
  );
  while( my $r = $g->()) {
      send_request( $r );
  };

This function creates data structures that are suitable for sending off
a mass of similar but different HTTP requests. All array references are expanded
into the cartesian product of their contents. The above example would create
two requests:

      url => '/profiles/Mark,
      url => '/profiles/John',

C<generate_requests> returns an iterator in scalar context. In list context, it
returns the complete list of requests:

  my @requests = generate_requests(
      url => '/profiles/:name',
      url_params => ['Mark','John'],
      wrap => sub {
          my( $req ) = @_;
          # Fix up some values
          $req->{headers}->{'Content-Length'} = 666;
          return $req;
      },
  );
  for my $r (@requests) {
      send_request( $r );
  };

Note that returning a list instead of the iterator will use up quite some memory
quickly, as the list will be the cartesian product of the input parameters.

There are helper functions
that will turn that data into a data structure suitable for your HTTP framework
of choice.

  {
    method => 'GET',
    url => '/profiles/Mark',
    scheme => 'http',
    port => 80,
    headers => {},
    body_params => {},
    query_params => {},
  }

As a shorthand for creating lists, you can use the C<pattern> option, which
will expand a string into a set of requests. C<{}> will expand into alternatives
while C<[xx..yy]> will expand into the range C<xx> to C<yy>. Note that these
lists will be expanded in memory.

=head3 Options

=over 4

=item B<pattern>

    pattern => 'https://example.{com,org,net}/page_[00..99].html',

Generate URLs from this pattern instead of C<query_params>, C<url_params>
and C<url>.

=item B<url>

URL template to use.

=item B<url_params>

Parameters to replace in the C<url> template.

=item B<body_params>

Parameters to replace in the POST body.

=item B<query_params>

Parameters to replace in the GET request.

=item B<host>

Hostname(s) to use.

=item B<port>

Port(s) to use.

=item B<headers>

Headers to use. Currently, no templates are generated for the headers. You have
to specify complete sets of headers for each alternative.

=item B<limit>

Limit the number of requests generated.

=back

=cut

sub generate_requests(%options) {
    croak "Option 'protocol' is now named 'scheme'."
        if $options{ protocol };

    my $i = _generate_requests_iter(%options);
    if( wantarray ) {
        return fetch_all($i, $options{ limit });
    } else {
        return $i
    }
}

=head2 C<< as_http_request >>

    generate_requests(
        method => 'POST',
        url    => '/feedback/:item',
        wrap => \&HTTP::Request::Generator::as_http_request,
    )

Converts the request data to a L<HTTP::Request> object.

=cut

sub as_http_request($req) {
    require HTTP::Request;
    HTTP::Request->VERSION(6); # ->flatten()
    require URI;
    require URI::QueryParam;

    my $body = '';
    my $headers;
    my $form_ct;
    if( keys %{$req->{body_params}}) {
        require HTTP::Request::Common;
        my $r = HTTP::Request::Common::POST( $req->{url},
            [ %{ $req->{body_params} }],
        );
        $headers = HTTP::Headers->new( %{ $req->{headers} }, $r->headers->flatten );
        $body = $r->content;
        $form_ct = $r->content_type;
    } else {
        $headers = HTTP::Headers->new( %$headers );
    };

    # Store metadata / generate "signature" for later inspection/isolation?
    my $uri = _build_uri( $req );
    $uri->query_param( %{ $req->{query_params} || {} });
    my $res = HTTP::Request->new(
        $req->{method} => $uri,
        $headers,
        $body,
    );
    $res
}

=head2 C<< as_dancer >>

    generate_requests(
        method => 'POST',
        url    => '/feedback/:item',
        wrap => \&HTTP::Request::Generator::as_dancer,
    )

Converts the request data to a L<Dancer::Request> object.

During the creation of Dancer::Request objects, C<< %ENV >> will be empty except
for C<< $ENV{TMP} >> and C<< $ENV{TEMP} >>.


This function needs and dynamically loads the following modules:

L<Dancer::Request>

L<HTTP::Request>

=cut

sub as_dancer($req) {
    require Dancer::Request;
    require HTTP::Request;
    HTTP::Request->VERSION(6); # ->flatten()

    my $body = '';
    my $headers;
    my $form_ct;
    if( keys %{$req->{body_params}}) {
        require HTTP::Request::Common;
        my $r = HTTP::Request::Common::POST( $req->{url},
            [ %{ $req->{body_params} }],
        );
        $headers = HTTP::Headers->new( %{ $req->{headers} }, $r->headers->flatten );
        $body = $r->content;
        $form_ct = $r->content_type;
    } else {
        $headers = HTTP::Headers->new( %$headers );
    };

    my $uri = _build_uri( $req );

    # Store metadata / generate "signature" for later inspection/isolation?
    my %old_ENV = %ENV;
    local %ENV; # wipe out non-overridable default variables of Dancer::Request
    my @keep = (qw(TMP TEMP));
    @ENV{ @keep } = @old_ENV{ @keep };
    my $res = Dancer::Request->new_for_request(
        $req->{method} =>  $uri->path,
        $req->{query_params},
        $body,
        $headers,
        { CONTENT_LENGTH => length($body),
          CONTENT_TYPE   => $form_ct,
          HTTP_HOST      => (join ":", $req->{host}, $req->{port}),
          SERVER_NAME    => $req->{host},
          SERVER_PORT    => $req->{port},
          REQUEST_METHOD => $req->{ method },
          REQUEST_URI    => $uri,
          SCRIPT_NAME    => $uri->path,

        },
    );
    $res->{_http_body}->add($body);
    #use Data::Dumper; warn Dumper $res;
    $res
}

=head2 C<< as_plack >>

    generate_requests(
        method => 'POST',
        url    => '/feedback/:item',
        wrap => \&HTTP::Request::Generator::as_plack,
    )

Converts the request data to a L<Plack::Request> object.

During the creation of Plack::Request objects, C<< %ENV >> will be empty except
for C<< $ENV{TMP} >> and C<< $ENV{TEMP} >>.

This function needs and dynamically loads the following modules:

L<Plack::Request>

L<HTTP::Headers>

L<Hash::MultiValue>

=cut

sub as_plack($req) {
    require Plack::Request;
    Plack::Request->VERSION(1.0047);
    require HTTP::Headers;
    require Hash::MultiValue;

    my %env = %$req;
    $env{ 'psgi.version' } = '1.0';
    $env{ 'psgi.url_scheme' } = delete $env{ scheme };
    $env{ 'plack.request.query_parameters' } = [%{delete $env{ query_params }||{}} ];
    $env{ 'plack.request.body_parameters' } = [%{delete $env{ body_params }||{}} ];
    $env{ 'plack.request.headers' } = HTTP::Headers->new( %{ delete $req->{headers} });
    $env{ REQUEST_METHOD } = delete $env{ method };
    $env{ REQUEST_URI } = _build_uri( $req );
    $env{ SCRIPT_NAME } = $env{ REQUEST_URI }->path;
    delete $env{ url };
    $env{ QUERY_STRING } = ''; # not correct, but...
    $env{ SERVER_NAME } = delete $env{ host };
    $env{ SERVER_PORT } = delete $env{ port };
    # need to convert the headers into %env HTTP_ keys here
    $env{ CONTENT_TYPE } = undef;

    # Store metadata / generate "signature" for later inspection/isolation?
    my %old_ENV = %ENV;
    local %ENV; # wipe out non-overridable default variables of Dancer::Request
    my @keep = (qw(TMP TEMP));
    @ENV{ @keep } = @old_ENV{ @keep };
    my $res = Plack::Request->new(\%env);
    $res
}

1;

=head1 SEE ALSO

L<The Curl Manpage|https://curl.haxx.se/docs/manpage.html> for the pattern syntax

=head1 REPOSITORY

The public repository of this module is
L<https://github.com/Corion/HTTP-Request-Generator>.

=head1 SUPPORT

The public support forum of this module is L<https://perlmonks.org/>.

=head1 BUG TRACKER

Please report bugs in this module via the RT CPAN bug queue at
L<https://rt.cpan.org/Public/Dist/Display.html?Name=HTTP-Request-Generator>
or via mail to L<HTTP-Request-Generator-Bugs@rt.cpan.org|mailto:HTTP-Request-Generator-Bugs@rt.cpan.org>.

=head1 AUTHOR

Max Maischein C<corion@cpan.org>

=head1 COPYRIGHT (c)

Copyright 2017-2019 by Max Maischein C<corion@cpan.org>.

=head1 LICENSE

This module is released under the same terms as Perl itself.

=cut
