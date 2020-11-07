package Search::Elasticsearch::Client::6_0::Direct::Snapshot;
$Search::Elasticsearch::Client::6_0::Direct::Snapshot::VERSION = '6.81';
use Moo;
with 'Search::Elasticsearch::Client::6_0::Role::API';
with 'Search::Elasticsearch::Role::Client::Direct';
__PACKAGE__->_install_api('snapshot');

1;

=pod

=encoding UTF-8

=head1 NAME

Search::Elasticsearch::Client::6_0::Direct::Snapshot - A client for managing snapshot/restore

=head1 VERSION

version 6.81

=head1 DESCRIPTION

This module provides methods to manage snapshot/restore, or backups.
It can create, get and delete configured backup repositories, and
create, get, delete and restore snapshots of your cluster or indices.

It does L<Search::Elasticsearch::Role::Client::Direct>.

=head1 METHODS

=head2 C<create_repository()>

    $e->snapshot->create_repository(
        repository  => 'repository',        # required
        body        => { defn }             # required
    );

Create a repository for backups.

Query string parameters:
    C<error_trace>,
    C<human>,
    C<master_timeout>,
    C<timeout>,
    C<verify>

See the L<"snapshot/restore docs"|http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshot.html>
for more information.

=head2 C<get_repository()>

    $e->snapshot->get_repository(
        repository  => 'repository' | \@repositories    # optional
    );

Retrieve existing repositories.

Query string parameters:
    C<error_trace>,
    C<human>,
    C<local>,
    C<master_timeout>

See the L<"snapshot/restore docs"|http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshot.html>
for more information.

=head2 C<verify_repository()>

    $e->snapshot->verify_repository(
        repository  => 'repository' # required
    );

Verify existing repository.

Query string parameters:
    C<error_trace>,
    C<human>,
    C<master_timeout>,
    C<timeout>

See the L<"snapshot/restore docs"|http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshot.html>
for more information.

=head2 C<delete_repository()>

    $e->snapshot->delete_repository(
        repository  => 'repository' | \@repositories    # required
    );

Delete repositories by name.

Query string parameters:
    C<error_trace>,
    C<human>,
    C<master_timeout>,
    C<timeout>

See the L<"snapshot/restore docs"|http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshot.html>
for more information.

=head2 C<create()>

    $e->snapshot->create(
        repository  => 'repository',     # required
        snapshot    => 'snapshot',       # required,

        body        => { snapshot defn } # optional
    );

Create a snapshot of the whole cluster or individual indices in the named
repository.

Query string parameters:
    C<error_trace>,
    C<human>,
    C<master_timeout>,
    C<wait_for_completion>

=head2 C<get()>

    $e->snapshot->get(
        repository  => 'repository'                   # required
        snapshot    => 'snapshot'   | \@snapshots     # required
    );

Retrieve snapshots in the named repository.

Query string parameters:
    C<error_trace>,
    C<human>,
    C<ignore_unavailable>,
    C<master_timeout>,
    C<verbose>

See the L<"snapshot/restore docs"|http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshot.html>
for more information.

=head2 C<delete()>

    $e->snapshot->delete(
        repository  => 'repository',              # required
        snapshot    => 'snapshot'                 # required
    );

Delete snapshot in the named repository.

Query string parameters:
    C<error_trace>,
    C<human>,
    C<master_timeout>

See the L<"snapshot/restore docs"|http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshot.html>
for more information.

=head2 C<restore()>

    $e->snapshot->restore(
        repository  => 'repository',              # required
        snapshot    => 'snapshot'                 # required

        body        => { what to restore }        # optional
    );

Restore a named snapshot.

Query string parameters:
    C<error_trace>,
    C<human>,
    C<master_timeout>,
    C<wait_for_completion>

See the L<"snapshot/restore docs"|http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshot.html>
for more information.

=head2 C<status()>

    $result = $e->snapshot->status(
        repository  => 'repository',              # optional
        snapshot    => 'snapshot' | \@snapshots   # optional
    );

Returns status information about the specified snapshots.

Query string parameters:
    C<error_trace>,
    C<human>,
    C<ignore_unavailable>,
    C<master_timeout>

See the L<"snapshot/restore docs"|http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-snapshot.html>
for more information.

=head1 AUTHOR

Enrico Zimuel <enrico.zimuel@elastic.co>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2020 by Elasticsearch BV.

This is free software, licensed under:

  The Apache License, Version 2.0, January 2004

=cut

__END__

# ABSTRACT: A client for managing snapshot/restore

