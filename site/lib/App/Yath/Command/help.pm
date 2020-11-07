package App::Yath::Command::help;
use strict;
use warnings;

use Test2::Util qw/pkg_to_file/;

our $VERSION = '1.000038';

use parent 'App::Yath::Command';
use Test2::Harness::Util::HashBase qw/<_command_info_hash/;

use Test2::Harness::Util qw/open_file find_libraries/;
use List::Util ();

sub options {};
sub group { '' }
sub summary { 'Show the list of commands' }

sub description {
    return <<"    EOT"
This command provides a list of commands when called with no arguments.
When given a command name as an argument it will print the help for that
command.
    EOT
}

sub command_info_hash {
    my $self = shift;

    return $self->{+_COMMAND_INFO_HASH} if $self->{+_COMMAND_INFO_HASH};

    my %commands;
    my $command_libs = find_libraries('App::Yath::Command::*');
    for my $lib (sort keys %$command_libs) {
        my $ok = eval { require $command_libs->{$lib}; 1 };
        unless ($ok) {
            warn "Failed to load command '$command_libs->{$lib}': $@";
            next;
        }

        next if $lib->internal_only;
        my $name = $lib->name;
        my $group = $lib->group;
        $commands{$group}->{$name} = $lib->summary;
    }

    return $self->{+_COMMAND_INFO_HASH} = \%commands;
}

sub command_list {
    my $self = shift;

    my $command_hash = $self->command_info_hash();
    my @commands = map keys %$_, values %$command_hash;
    return @commands;
}

sub run {
    my $self = shift;
    my $args = $self->{+ARGS};

    return $self->command_help($args->[0]) if @$args;

    my $script = $self->settings->harness->script // $0;
    my $maxlen = List::Util::max(map length, $self->command_list);

    print "\nUsage: $script COMMAND [options]\n\nAvailable Commands:\n";

    my $command_info_hash = $self->command_info_hash;
    for my $group (sort keys %$command_info_hash) {
        my $set = $command_info_hash->{$group};

        printf("    %${maxlen}s:  %s\n", $_, $set->{$_}) for sort keys %$set;
        print "\n";
    }

    return 0;
}

sub command_help {
    my $self = shift;
    my ($command) = @_;

    require App::Yath;
    my $cmd_class = App::Yath->load_command($command);
    print $cmd_class->cli_help(settings => $self->{+SETTINGS});

    return 0;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::Yath::Command::help - Show the list of commands

=head1 DESCRIPTION

This command provides a list of commands when called with no arguments.
When given a command name as an argument it will print the help for that
command.


=head1 USAGE

    $ yath [YATH OPTIONS] help [COMMAND OPTIONS]

=head2 YATH OPTIONS

=head3 Developer

=over 4

=item --dev-lib

=item --dev-lib=lib

=item -D

=item -D=lib

=item -Dlib

=item --no-dev-lib

Add paths to @INC before loading ANYTHING. This is what you use if you are developing yath or yath plugins to make sure the yath script finds the local code instead of the installed versions of the same code. You can provide an argument (-Dfoo) to provide a custom path, or you can just use -D without and arg to add lib, blib/lib and blib/arch.

Can be specified multiple times


=back

=head3 Environment

=over 4

=item --persist-dir ARG

=item --persist-dir=ARG

=item --no-persist-dir

Where to find persistence files.


=item --persist-file ARG

=item --persist-file=ARG

=item --pfile ARG

=item --pfile=ARG

=item --no-persist-file

Where to find the persistence file. The default is /{system-tempdir}/project-yath-persist.json. If no project is specified then it will fall back to the current directory. If the current directory is not writable it will default to /tmp/yath-persist.json which limits you to one persistent runner on your system.


=item --project ARG

=item --project=ARG

=item --project-name ARG

=item --project-name=ARG

=item --no-project

This lets you provide a label for your current project/codebase. This is best used in a .yath.rc file. This is necessary for a persistent runner.


=back

=head3 Help and Debugging

=over 4

=item --show-opts

=item --no-show-opts

Exit after showing what yath thinks your options mean


=item --version

=item -V

=item --no-version

Exit after showing a helpful usage message


=back

=head3 Plugins

=over 4

=item --no-scan-plugins

=item --no-no-scan-plugins

Normally yath scans for and loads all App::Yath::Plugin::* modules in order to bring in command-line options they may provide. This flag will disable that. This is useful if you have a naughty plugin that it loading other modules when it should not.


=item --plugins PLUGIN

=item --plugins +App::Yath::Plugin::PLUGIN

=item --plugins PLUGIN=arg1,arg2,...

=item --plugin PLUGIN

=item --plugin +App::Yath::Plugin::PLUGIN

=item --plugin PLUGIN=arg1,arg2,...

=item -pPLUGIN

=item --no-plugins

Load a yath plugin.

Can be specified multiple times


=back

=head2 COMMAND OPTIONS

=head3 Git Options

=over 4

=item --git-change-base master

=item --git-change-base HEAD^

=item --git-change-base df22abe4

=item --no-git-change-base

Find files changed by all commits in the current branch from most recent stopping when a commit is found that is also present in the history of the branch/commit specified as the change base.


=back

=head3 Help and Debugging

=over 4

=item --dummy

=item -d

=item --no-dummy

Dummy run, do not actually execute anything

Can also be set with the following environment variables: C<T2_HARNESS_DUMMY>


=item --help

=item -h

=item --no-help

exit after showing help information


=item --keep-dirs

=item --keep_dir

=item -k

=item --no-keep-dirs

Do not delete directories when done. This is useful if you want to inspect the directories used for various commands.


=back

=head3 YathUI Options

=over 4

=item --yathui-api-key ARG

=item --yathui-api-key=ARG

=item --no-yathui-api-key

Yath-UI API key. This is not necessary if your Yath-UI instance is set to single-user


=item --yathui-grace

=item --no-yathui-grace

If yath cannot connect to yath-ui it normally throws an error, use this to make it fail gracefully. You get a warning, but things keep going.


=item --yathui-long-duration 10

=item --no-yathui-long-duration

Minimum duration length (seconds) before a test goes from MEDIUM to LONG


=item --yathui-medium-duration 5

=item --no-yathui-medium-duration

Minimum duration length (seconds) before a test goes from SHORT to MEDIUM


=item --yathui-mode summary

=item --yathui-mode qvf

=item --yathui-mode qvfd

=item --yathui-mode complete

=item --no-yathui-mode

Set the upload mode (default 'qvfd')


=item --yathui-project ARG

=item --yathui-project=ARG

=item --no-yathui-project

The Yath-UI project for your test results


=item --yathui-retry

=item --no-yathui-retry

How many times to try an operation before giving up

Can be specified multiple times


=item --yathui-url http://my-yath-ui.com/...

=item --uri http://my-yath-ui.com/...

=item --no-yathui-url

Yath-UI url


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
