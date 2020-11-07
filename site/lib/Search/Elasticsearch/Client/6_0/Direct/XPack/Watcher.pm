package Search::Elasticsearch::Client::6_0::Direct::XPack::Watcher;
$Search::Elasticsearch::Client::6_0::Direct::XPack::Watcher::VERSION = '6.81';
use Moo;
with 'Search::Elasticsearch::Client::6_0::Role::API';
with 'Search::Elasticsearch::Role::Client::Direct';
use namespace::clean;

__PACKAGE__->_install_api('xpack.watcher');

1;

# ABSTRACT: Plugin providing Watcher API for Search::Elasticsearch 6.x

__END__

=pod

=encoding UTF-8

=head1 NAME

Search::Elasticsearch::Client::6_0::Direct::XPack::Watcher - Plugin providing Watcher API for Search::Elasticsearch 6.x

=head1 VERSION

version 6.81

=head1 SYNOPSIS

    my $response = $es->xpack->watcher->start();

=head2 DESCRIPTION

This class extends the L<Search::Elasticsearch> client with a C<watcher>
namespace, to support the
L<Watcher APIs|https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api.html>.

=head1 METHODS

The full documentation for the Watcher feature is available here:
L<https://www.elastic.co/guide/en/x-pack/current/xpack-alerting.html>

=head2 C<put_watch()>

    $response = $es->xpack->watcher->put_watch(
        id    => $watch_id,     # required
        body  => {...}
    );

The C<put_watch()> method is used to register a new watcher or to update
an existing watcher.

See the L<put_watch docs|https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-put-watch.html>
for more information.

Query string parameters:
    C<active>,
    C<error_trace>,
    C<human>,
    C<if_primary_term>,
    C<if_seq_no>,
    C<master_timeout>,
    C<version>

=head2 C<get_watch()>

    $response = $es->xpack->watcher->get_watch(
        id    => $watch_id,     # required
    );

The C<get_watch()> method is used to retrieve a watch by ID.

See the L<get_watch docs|https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-get-watch.html>
for more information.

Query string parameters:
    C<error_trace>,
    C<human>

=head2 C<delete_watch()>

    $response = $es->xpack->watcher->delete_watch(
        id    => $watch_id,     # required
    );

The C<delete_watch()> method is used to delete a watch by ID.

Query string parameters:
    C<error_trace>,
    C<force>,
    C<human>,
    C<master_timeout>

See the L<delete_watch docs|https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-delete-watch.html>
for more information.

=head2 C<execute_watch()>

    $response = $es->xpack->watcher->execute_watch(
        id    => $watch_id,     # optional
        body  => {...}          # optional
    );

The C<execute_watch()> method forces the execution of a previously
registered watch.  Optional parameters may be passed in the C<body>.

Query string parameters:
    C<debug>,
    C<error_trace>,
    C<human>

See the L<execute_watch docs|https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-execute-watch.html>
for more information.

=head2 C<ack_watch()>

    $response = $es->xpack->watcher->ack_watch(
        watch_id => $watch_id,                  # required
        action_id => $action_id | \@action_ids  # optional
    );

The C<ack_watch()> method is used to manually throttle the execution of
a watch.

Query string parameters:
    C<error_trace>,
    C<human>,
    C<master_timeout>

See the L<ack_watch docs|https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-ack-watch.html>
for more information.

=head2 C<activate_watch()>

    $response = $es->xpack->watcher->activate_watch(
        watch_id => $watch_id,                  # required
    );

The C<activate_watch()> method is used to activate a deactive watch.

Query string parameters:
    C<error_trace>,
    C<human>,
    C<master_timeout>

See the L<activate_watch docs|https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-activate-watch.html>
for more information.

=head2 C<deactivate_watch()>

    $response = $es->xpack->watcher->deactivate_watch(
        watch_id => $watch_id,                  # required
    );

The C<deactivate_watch()> method is used to deactivate an active watch.

Query string parameters:
    C<error_trace>,
    C<human>,
    C<master_timeout>

See the L<deactivate_watch docs|https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-deactivate-watch.html>
for more information.

=head2 C<stats()>

    $response = $es->xpack->watcher->stats(
        metric => $metric       # optional
    );

The C<stats()> method returns information about the status of the watcher plugin.

See the L<stats docs|https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-stats.html>
for more information.

Query string parameters:
    C<error_trace>,
    C<human>

=head2 C<stop()>

    $response = $es->xpack->watcher->stop();

The C<stop()> method stops the watcher service if it is running.

See the L<stop docs|https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-stop.html>
for more information.

Query string parameters:
    C<error_trace>,
    C<human>

=head2 C<start()>

    $response = $es->xpack->watcher->start();

The C<start()> method starts the watcher service if it is not already running.

See the L<start docs|https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-start.html>
for more information.

Query string parameters:
    C<error_trace>,
    C<human>

=head2 C<restart()>

    $response = $es->xpack->watcher->restart();

The C<restart()> method stops then starts the watcher service.

See the L<restart docs|https://www.elastic.co/guide/en/elasticsearch/reference/current/watcher-api-restart.html>
for more information.

Query string parameters:
    C<error_trace>,
    C<human>

=head1 AUTHOR

Enrico Zimuel <enrico.zimuel@elastic.co>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2020 by Elasticsearch BV.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut
