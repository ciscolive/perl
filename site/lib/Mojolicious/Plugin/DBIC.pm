package Mojolicious::Plugin::DBIC;
#------------------------------------------------------------------------------
# 基类 Mojolicious::Plugin
#------------------------------------------------------------------------------
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::Loader qw( load_class );
use Scalar::Util qw( blessed );

#------------------------------------------------------------------------------
# 初始化 VERSION
#------------------------------------------------------------------------------
our $VERSION = '1.12';

#------------------------------------------------------------------------------
# register 函数入口
#------------------------------------------------------------------------------
sub register {
  my ( $self, $app, $conf ) = @_;

  # 获取 schema
  my $schema_conf = $conf->{schema};

  # 如果 Plugin 没有携带属性，检查配置文件
  if ( !$schema_conf && $app->can('config') ) {
    $schema_conf = $app->config->{dbic}{schema};
  }

  # 新增 helper schema
  $app->helper(
    schema => sub {
      state $schema = _load_schema($schema_conf);
      return $schema;
    }
  );
}

#------------------------------------------------------------------------------
# _load_schema 加载 schema 配置
#------------------------------------------------------------------------------
sub _load_schema {
  my ($conf) = @_;

  # 判断是否为 DBIC Schema
  if ( blessed $conf && $conf->isa('DBIx::Class::Schema') ) {
    return $conf;
  }
  elsif ( ref $conf eq 'HASH' ) {
    my ( $class, $args ) = %{$conf};
    if ( my $e = load_class($class) ) {
      die sprintf 'Unable to load schema class %s: %s', $class, $e;
    }
    return $class->connect( ref $args eq 'ARRAY' ? @$args : $args );
  }

  # 兜底策略，直接抛出异常
  die sprintf "Unknown DBIC schema config. Must be schema object or HASH, not %s", ref $conf;
}

1;
