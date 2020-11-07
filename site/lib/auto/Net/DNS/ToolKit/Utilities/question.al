# NOTE: Derived from blib/lib/Net/DNS/ToolKit/Utilities.pm.
# Changes made here will be lost when autosplit is run again.
# See AutoSplit.pm.
package Net::DNS::ToolKit::Utilities;

#line 140 "blib/lib/Net/DNS/ToolKit/Utilities.pm (autosplit into blib/lib/auto/Net/DNS/ToolKit/Utilities/question.al)"
sub question {
  my ($name,$type) = @_;
  return undef unless
	$type == T_NS ||
	$type == T_MX ||
	$type == T_ANY ||
	$type == T_TXT ||
	$type == T_PTR ||
	$type == T_A;

  my $buffer;
  my $offset = newhead(\$buffer,
	&id(),
	BITS_QUERY | RD,		# query, recursion desired
	1,0,0,0,			# one question
  );
  my ($get,$put,$parse) = new Net::DNS::ToolKit::RR;
  $offset = $put->Question(\$buffer,$offset,$name,$type,C_IN);
  return $buffer;
}

# end of Net::DNS::ToolKit::Utilities::question
1;
