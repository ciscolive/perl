package Mojolicious::Plugin::Bootstrap3;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::Util ();
use File::Basename 'dirname';
use File::Copy ();
use File::Path ();
use File::Spec ();
use Cwd        ();
use constant DEBUG => $ENV{MOJO_ASSETPACK_DEBUG} || 0;

our $VERSION = '3.3601';
our $OVERRIDE;    # ugly hack. might go away

$ENV{SASS_PATH} ||= '';

my $ASSET_DIR = do { local $_ = Cwd::abs_path(__FILE__); s!\.pm$!!; $_; };

my @DEFAULT_CSS_FILES = qw( bootstrap.scss );
my @DEFAULT_JS_FILES
  = qw( transition.js alert.js button.js carousel.js collapse.js dropdown.js modal.js tooltip.js popover.js scrollspy.js tab.js affix.js );

sub asset_path {
  my ($self, $type) = @_;
  my @path = ref $self ? @{$self->{sass_path}} : ();
  my %PATH;

  return join ':', grep { -d $_ and !$PATH{$_}++ } split(/:/, $ENV{SASS_PATH}), @path,
    File::Spec->catdir($ASSET_DIR, 'sass')
    if $type and $type eq 'sass';
  return $ASSET_DIR;
}

sub register {
  my ($self, $app, $config) = @_;
  my (@css, @js);

  $app->plugin('AssetPack') unless eval { $app->asset };

  $self->{sass_path} = [];
  $config->{custom} = 0 if $config->{theme};

  push @{$app->asset->source_paths}, $self->asset_path;
  push @css, $config->{css} ? @{$config->{css}} : @DEFAULT_CSS_FILES;
  push @js, map {"/js/bootstrap/$_"} $config->{js} ? @{$config->{js}} : @DEFAULT_JS_FILES;
  unshift @js, '/js/jquery-1.11.0.min.js' if $config->{jquery} or (@js and $config->{jquery} // 1);

  if ($config->{custom}) {
    $self->_copy_files($app,
      map { [$_, $_] } ref $config->{custom} eq 'ARRAY' ? @{$config->{custom}} : @DEFAULT_CSS_FILES);
  }

  if ($config->{theme}) {
    $self->_generate_theme($app, $config->{theme});
  }
  elsif (@css) {
    $ENV{SASS_PATH} = $self->asset_path('sass');
    warn "[BOOTSTRAP] Defining asset 'bootstrap.css' SASS_PATH=$ENV{SASS_PATH}\n" if DEBUG;
    $app->asset('bootstrap.css' => map {"/sass/$_"} @css);
  }

  if (@js) {
    $app->asset('bootstrap.js' => @js);
  }
}

sub _copy_files {
  my $modifier = ref $_[-1] eq 'CODE' ? pop : sub { };
  my ($self, $app, @files) = @_;

  for (@files) {
    my ($from, $to) = @$_;
    my $source = File::Spec->catfile($ASSET_DIR, 'sass', split '/', $from);
    my $destination = $self->_destination_file($app, $to) or next;
    File::Path::make_path(dirname $destination) unless -d dirname($destination);
    $app->log->info("[BOOTSTRAP] Copying $source to $destination");
    local $_ = Mojo::Util::slurp($source);
    $modifier->();
    Mojo::Util::spurt($_, $destination);
  }
}

sub _destination_file {
  my ($self, $app, $name) = @_;
  my ($r_destination, $w_destination);

  for my $path (@{$app->asset->source_paths}) {
    my $destination_dir = File::Spec->catdir($path, 'sass');
    my $destination = File::Spec->catfile($destination_dir, split '/', $name);
    push @{$self->{sass_path}}, $destination_dir;
    $r_destination ||= $destination if -e $destination;               # already exists
    $w_destination ||= $destination if -w dirname $destination_dir;
  }

  return $r_destination || $w_destination;
  $app->log->warn("Custom file $name does not exist in static directories!");
  return '';
}

sub _generate_theme {
  my ($self, $app, $theme) = @_;

  for my $name (keys %$theme) {
    my $url = $theme->{$name};

    warn "[BOOTSTRAP] Defining theme '$name' from $url\n" if DEBUG;

    if ($url =~ m!/_bootswatch\.scss!) {
      my $destination = $self->_destination_file($app, "$name/_bootswatch.scss");
      $self->_move($app->asset->fetch($url), $destination) if $destination and !-e $destination;
      $url =~ s!/_bootswatch\.scss!/_variables.scss!;
      local $OVERRIDE = 'bootswatch';
      $self->_generate_theme($app, {$name => $url});
    }
    else {
      my $destination = $self->_destination_file($app, "$name/_variables.scss");
      if ($destination and !-e $destination) {
        $self->_copy_files(
          $app,
          ["bootstrap.scss" => "$name.scss"],
          sub {
            s!(\@import.*bootstrap/variables.*)!\@import "$name/variables";\n$1!m;
            s!(//.*\bUtility\b.*)!$1\n\@import "$name/$OVERRIDE";\n!mi if $OVERRIDE;
          }
        );
        $self->_move($app->asset->fetch($url), $destination);
      }
      $ENV{SASS_PATH} = $self->asset_path('sass');
      warn "[BOOTSTRAP] Defining asset '$name.css' SASS_PATH=$ENV{SASS_PATH}\n" if DEBUG;
      $app->asset("$name.css" => "/sass/$name.scss");
    }
  }
}

sub _move {
  my ($self, $from, $to) = @_;
  File::Path::make_path(dirname $to);
  File::Copy::move($from, $to) or die "[BOOTSTRAP] move $from $to: $!";
}

1;

=encoding utf8

=head1 NAME

Mojolicious::Plugin::Bootstrap3 - DEPRECATED

=head1 VERSION

3.3601

=head1 DESCRIPTION

L<Mojolicious::Plugin::Bootstrap3> will be DEPRECATED.

Use L<Mojolicious::Plugin::AssetPack> directly instead:

Basic:

  use Mojolicious::Lite;
  plugin "AssetPack";

  $self->asset->process(
    "bootstrap.css" => "http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
  );
  $self->asset->process(
    "bootstrap.js" => "http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js");
  );

Sass support:

  $self->asset->process(
    "bootstrap.css" => "https://github.com/twbs/bootstrap-sass/blob/master/assets/stylesheets/_bootstrap.scss"
  );

The above will download all the included resources.

=head1 METHODS

=head2 asset_path

  $path = Mojolicious::Plugin::Bootstrap3->asset_path($type);
  $path = $self->asset_path($type);

Returns the base path to the assets bundled with this module.

Set C<$type> to "sass" if you want a return value that is suitable for
the C<SASS_PATH> environment variable.

=head2 register

  $app->plugin(
    bootstrap3 => {
      css    => [qw( bootstrap.scss )],
      js     => [qw( button.js collapse.js ... )],
      custom => 0,
      jquery => 1,
      theme  => undef,
    },
  );

Default values:

=over 4

=item * css: C<bootstrap.scss>

The name of the files to include in the asset named C<bootstrap.css>.

Specify an empty list to disable building C<bootstrap.css>.

=item * js

C<affix.js>, C<alert.js>, C<button.js>, C<carousel.js>, C<collapse.js>,
C<dropdown.js>, C<modal.js>, C<popover.js>, C<scrollspy.js>, C<tab.js>,
C<tooltip.js> and C<transition.js>.

The name of the files to include in the asset named C<bootstrap.js>.

Specify an empty list to disable building C<bootstrap.js>.

=item * custom

Disabled by default. Will copy C<sass/bootstrap.scss> to your project if
true and set C<SASS_PATH> to the appropriate paths.

=item * jquery

This will include the bundled L<jQuery|http://jquery.com/> version in the
L<bootstrap.js> asset. Set this to 0 if you include your own jQuery.

=item * theme

Specifying a theme will override L</custom> and L</css>.

See L</Themes>.

=back

=head1 CREDITS

L<bootstrap-sass|https://github.com/twbs/bootstrap-sass> has a number of major
contributors:

  Thomas McDonald
  Tristan Harward
  Peter Gumeson
  Gleb Mazovetskiy

and a L<significant number of other contributors|https://github.com/twbs/bootstrap-sass/graphs/contributors>

=head1 LICENSE

Bootstrap is licensed under L<MIT|https://github.com/twbs/bootstrap/blob/master/LICENSE>

Mojolicious is licensed under Artistic License version 2.0 and so is this code.

=head1 AUTHOR

Jan Henning Thorsen - C<jhthorsen@cpan.org>

=cut
