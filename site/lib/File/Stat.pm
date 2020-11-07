package File::Stat;
use 5.006;
use strict;
use warnings;
use base qw(Exporter);
our $VERSION		= '0.01';
our @EXPORT			= qw();
our %EXPORT_TAGS	= (
	'stat'		=> [qw(&stat)],
	'lstat'		=> [qw(&lstat)],
	'override'	=> [qw(&lstat &stat)],
	'global'	=> [qw(
		$st_dev $st_ino $st_inode $st_mode $st_nlink $st_uid $st_gid
		$st_rdev $st_size $st_atime $st_mtime $st_ctime $st_blksize $st_blocks
	)],
);
$EXPORT_TAGS{all}	= [ map {@{$EXPORT_TAGS{$_}}} keys %EXPORT_TAGS ];
our @EXPORT_OK		= @{$EXPORT_TAGS{all}};

our($st_dev,$st_ino,$st_inode,$st_mode,$st_nlink,$st_uid,$st_gid,
$st_rdev,$st_size,$st_atime,$st_mtime,$st_ctime,$st_blksize,$st_blocks);
# Preloaded methods go here.
sub class	{ref$_[0]||$_[0]}
sub new		{bless [stat($_[1])],$_[0]->class;}
sub stat_	{CORE::stat(shift)}
sub lstat_	{CORE::lstat(shift)}
sub set		{
	return (
		$st_dev,$st_ino,$st_inode,$st_mode,$st_nlink,$st_uid,$st_gid,
		$st_rdev,$st_size,$st_atime,$st_mtime,$st_ctime,$st_blksize,$st_blocks
	) = @_;
}
sub stat {
	return new File::Stat(shift)	unless(wantarray);
	return set( stat_(shift) );
}
sub lstat {
	return new File::Stat(shift)	unless(wantarray);
	return set( lstat_(shift) );
}
sub dev		:method	{shift()->[ 0]}
sub ino		:method	{shift()->[ 1]}
sub inode	:method	{shift()->[ 1]}
sub mode	:method	{shift()->[ 2]}
sub nlink	:method	{shift()->[ 3]}
sub uid		:method	{shift()->[ 4]}
sub gid		:method	{shift()->[ 5]}
sub rdev	:method	{shift()->[ 6]}
sub size	:method	{shift()->[ 7]}
sub atime	:method	{shift()->[ 8]}
sub mtime	:method	{shift()->[ 9]}
sub ctime	:method	{shift()->[10]}
sub blksize	:method	{shift()->[11]}
sub blocks	:method	{shift()->[12]}
1;
__END__
# Below is stub documentation for your module. You better edit it!

=head1 NAME

File::Stat - OOP interface for Perl's built-in stat() functions

=head1 SYNOPSIS

  use File::Stat;				# normaly
  use File::Stat qw/:stat/;		# override stat
  use File::Stat qw/:lstat/;	# override lstat
  use File::Stat qw/:override/;	# = qw/:stat :lstat
  use File::Stat qw/:global/;	# export $st_* valiable
  use File::Stat qw/:all/;		# all exports

  $stat		= new File::Stat($file_name||$file_handle);
  $stat		= stat( $file );	# optional
  @stat		= stat( $file );	# return normal array(not object)
  $lstat	= lstat( $file );	# optional
  @lstat	= lstat( $file );	# return normal array(not object)

  #OOP I/F
  $stat->dev;		# or $stat->[0];
  $stat->ino;		# $stat->[1]; alias $stat->inode
  $stat->mode;		# or $stat->[2];
  $stat->nlink;		# or $stat->[3];
  $stat->uid;		# or $stat->[4];
  $stat->gid;		# or $stat->[5];
  $stat->rdev;		# or $stat->[6];
  $stat->size;		# or $stat->[7];
  $stat->atime;		# or $stat->[8];
  $stat->mtime;		# or $stat->[9];
  $stat->ctime;		# or $stat->[10];
  $stat->blksize;	# or $stat->[11];
  $stat->blocks;	# or $stat->[12];

  # optional export 
  stat($file_name||$file_handle);
  $st_dev
  $st_ino
  $st_mode
  $st_nlink
  $st_uid
  $st_gid
  $st_rdev
  $st_size
  $st_atime
  $st_mtime
  $st_ctime
  $st_blksize
  $st_blocks

=head1 DESCRIPTION

simply OOP I/F by the name.
name space not tainted default.
if Perl5.8 or higher then use File::stat.

=head1 AUTHOR

Shin Honda<lt>makoto@cpan.jp<gt>

=head1 SEE ALSO

L<stat>.

=cut
