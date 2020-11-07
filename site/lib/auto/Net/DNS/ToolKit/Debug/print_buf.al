# NOTE: Derived from blib/lib/Net/DNS/ToolKit/Debug.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit::Debug;

#line 117 "blib/lib/Net/DNS/ToolKit/Debug.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/Debug/print_buf.al)"
sub print_buf {
  my($bp,$from,$to) = @_;
  $from = 0 unless $from;
  $to = length($$bp) -1 unless $to;
  return if $from > $to;

  foreach ($from..$to) {
    my $off = $_;
    my $char = get1char($bp,$off);
    @_ = parse_char($char);
    print "  $_\t:  ";
    foreach(@_) {     
      print "$_  ";   
    }  
    print "\n";
  }
}

1;

1;
# end of Net::DNS::ToolKit::Debug::print_buf
