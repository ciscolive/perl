#
# Copyright (c) 2017 Infoblox Inc. All Rights Reserved.
#
#
#

package Infoblox::Deserialize;

use Exporter 'import';
@EXPORT_OK = qw(deserialize_request);

use Carp;
use vars qw ( @ISA %objects);

use XML::Parser;
use Infoblox::IBAPSchema qw($types);
use Infoblox::Fault;
use Scalar::Util qw(weaken isweak refaddr);

BEGIN {
	foreach my $current (keys %{$types}) {
		my $members=$types->{$current};

        if (ref $members eq 'ARRAY') {
            foreach my $current_member (@{$members}) {
                $objects{$current}{@{$current_member}[0]} = @{$current_member}[1];
            }

            #
            $objects{$current}{'__type'} = $current;
        }
        else {
            #
            #
            #
            $objects{$current} = $members;
        }
	}

    #
    #
    foreach my $current (keys %objects) {
        if (ref($objects{$current}) eq 'HASH') {
            foreach my $current2 (keys %{$objects{$current}}) {
                next if $current2 eq '@extend';
                next if $current2 eq '__type';

                if ($objects{$current}{$current2} =~ /^ib:/) {
                    $objects{$current}{$current2}=$objects{$objects{$current}{$current2}};
                }
            }
        }
    }

    #
    foreach my $current (keys %objects) {
        if (ref($objects{$current}) eq 'HASH') {
            my $struct=1;

            foreach my $current2 (keys %{$objects{$current}}) {
                if ($current2 eq '@extend') {
                    if ($objects{$current}{$current2} eq 'ib:BaseObject') {
                        $struct=0;
                    }
                }
            }

            $objects{$current}{'__struct'} = $struct;
        }
    }

    #
    #
    #
    #
    my $morepasses;
    do {
        $morepasses=0;
        foreach my $current (keys %objects) {
            if (ref($objects{$current}) eq 'HASH') {
                foreach my $current2 (keys %{$objects{$current}}) {
                    if ($current2 eq '@extend') {
                        my $which=$objects{$current}{$current2};
                        delete $objects{$current}{$current2};

                        if (ref($objects{$which}) eq 'HASH') {
                            foreach (keys %{$objects{$which}}) {
                                next if $_ eq '__type';
                                next if $_ eq '__struct';
                                $morepasses=1 if $_ eq '@extend';
                                $objects{$current}{$_} = $objects{$which}{$_} unless defined $objects{$current}{$_};
                            }

                            #
                            #
                            #
                            if ($objects{$current}{'__struct'} == 1 && $objects{$which}{'__struct'} == 0) {
                                $objects{$current}{'__struct'} = 0;
                            }
                        }
                        else {
                            #
                            #
                            $objects{$current} = $objects{$which};
                        }
                    }
                }
            }
        }
    } while($morepasses);

    $objects{'SOAP-ENV:Fault'} = {
                                  'faultcode'   => 'xml:string',
                                  'faultstring' => 'xml:string',
                                  'detail'      => 'ib:Fault',
                                  '__type'      => 'SOAP-ENV:Fault',
                                 };
}

sub deserialize_request {
    my $request = shift;

	my ($currentvalue, $currentelement, $currenttype, @stack, @typestack, $cache, @result);

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

	my $parser = XML::Parser->new(
		  Handlers => {
					   Init  => sub {
						   $currentvalue = ''; # placeholder for characters
						   $currentelement = {}; # this will be the big hash returning things
						   $currenttype = {};
						   $cache = {}; # this will contain the object id cache
						   #
						   return;
					   },
					   Final => sub {
						   return $currentelement; # return our parsed hash
					   },
					   Start => sub {
						   my ($expat, $name, %attrs ) = @_;
						   #
						   #
						   push @stack, $currentelement;
						   push @typestack, $currenttype;

						   #
						   #
						   if (exists ${$currentelement}{$name}) {
							   if (ref(${$currentelement}{$name}) eq 'ARRAY') {
								   #
								   #

								   push @{${$currentelement}{$name}}, {};
							   } else {
								   #
								   #
								   ${$currentelement}{$name} = [${$currentelement}{$name}, {}];
							   }

							   #
							   #
							   $currentelement = @{${$currentelement}{$name}}[-1];
						   } else {
							   #
							   #
							   ${$currentelement}{$name} = {};
							   $currentelement = ${$currentelement}{$name};
						   }

						   #
						   if ($attrs{'xsi:type'}) {
                               unless ($objects{$attrs{'xsi:type'}}) {
                                   die Infoblox::Fault->new(undef,'Deserialize',undef,1012,"Unknown object type received from server $attrs{'xsi:type'}");
                               }
                               $currenttype = $objects{$attrs{'xsi:type'}};
						   }
                           else {
                               if ($currenttype && ref($currenttype) eq 'HASH' && defined $currenttype->{$name}) {
                                   $currenttype = $currenttype->{$name};
                               }
                               elsif ($name =~ /^ib:/) {
                                   $currenttype = $objects{$name};
                               }
                               elsif ($name =~ /^SOAP/) {
                                   #
                                   #

                                   if ($name eq 'SOAP-ENV:Fault') {
                                       $currenttype = $objects{$name};
                                   }
                                   else {
                                       $currenttype = {};
                                   }
                               }
                               else {
                                   if ($name eq 'object_id') {
                                       #
                                       #
                                       $currenttype = $objects{'ib:object_id'};
                                   }
                                   else {
                                       die Infoblox::Fault->new(undef,'Deserialize',undef,1012,"Schema inconsistency, $name");
                                   }

                               }
                           }

                           if (ref($currenttype) eq 'HASH' && defined $currenttype->{'__type'}) {
                               bless $currentelement, $currenttype->{'__type'};
                           }

						   return;
					   },
					   Char  => sub {
						   my ($expat, $text) = @_;
						   $currentvalue .= $text;
						   return;
					   },
					   End   => sub {
						   my ($expat, $name) = @_;

						   if ($currentvalue ne '') {
							   #
							   #
							   #

                               if (ref($currenttype) eq '' && $currenttype eq 'xml:boolean') {
                                   #
                                   if ($currentvalue eq 'true' || $currentvalue eq '1') {
                                       $currentvalue = 1;
                                   }
                                   else {
                                       $currentvalue = 0;
                                   }
                               }

							   if (ref(${$stack[-1]}{$name}) eq 'HASH') {
								   #
								   #
								   #
								   ${$stack[-1]}{$name} = $currentvalue;
							   } elsif (ref(${$stack[-1]}{$name}) eq 'ARRAY') {
								   #
								   #
								   @{${$stack[-1]}{$name}}[-1]=$currentvalue;
							   }
							   #
						   } else {
							   #
                               #

                               my $current_default=undef;
                               if (ref($currenttype) eq 'HASH' && $currenttype->{'__type'} && $currenttype->{'__type'} =~ /ib:Array/) {
                                   $current_default=[];
                               }
                               elsif (ref($currenttype) eq 'HASH' && $currenttype->{'__struct'}) {
                                   $current_default={};
                               }
                               elsif (ref($currenttype) eq '' && $currenttype eq 'xml:string') {
                                   $current_default='';
                               }

							   if ((ref(${$stack[-1]}{$name}) eq 'HASH' || ref(${$stack[-1]}{$name}) =~ m/^ib:/) && scalar(keys %{${$stack[-1]}{$name}}) == 0) {
								   ${$stack[-1]}{$name} = $current_default;
							   } elsif (ref(${$stack[-1]}{$name}) eq 'ARRAY') {
								   if ((ref(@{${$stack[-1]}{$name}}[-1]) eq 'HASH' || ref(@{${$stack[-1]}{$name}}[-1]) =~ m/^ib:/) && scalar(keys %{@{${$stack[-1]}{$name}}[-1]}) == 0) {
									   @{${$stack[-1]}{$name}}[-1]=$current_default;
								   }
							   }
						   }

						   if ($name eq 'object_id' && defined $currentelement->{'id'} && not defined $cache->{$currentelement->{'id'}}) {
							   #
							   $cache->{$currentelement->{'id'}} = $stack[-1];
                               weaken($cache->{$currentelement->{'id'}});

							   #
                               #
                               #
                               #
                               #
                               #
                               #

                                                   } elsif (scalar(keys %{$currentelement}) > 1 && defined $currentelement->{'object_id'} && $currentelement->{'object_id'}{'id'} && defined $cache->{$currentelement->{'object_id'}{'id'}} && scalar(keys %{$cache->{$currentelement->{'object_id'}{'id'}}}) == 1) {
                                                           #
                                                           #
                                                           #
                                                           $cache->{$currentelement->{'object_id'}{'id'}} = $currentelement;
                                                           weaken($cache->{$currentelement->{'object_id'}{'id'}});
						   } elsif (scalar(keys %{$currentelement}) == 1 && defined $currentelement->{'object_id'} && $currentelement->{'object_id'}{'id'} && $currentvalue eq '' && defined $cache->{$currentelement->{'object_id'}{'id'}}) {
							   #

							   if (ref(${$stack[-1]}{$name}) eq 'HASH' || ref(${$stack[-1]}{$name}) =~ m/^ib:/ ) {
                                   #
                                   if (refaddr(${$stack[-1]}{$name}) != refaddr($cache->{$currentelement->{'object_id'}{'id'}})) {
                                       ${$stack[-1]}{$name} = $cache->{$currentelement->{'object_id'}{'id'}};
                                       weaken(${$stack[-1]}{$name});
                                   }
							   } elsif (ref(${$stack[-1]}{$name}) eq 'ARRAY') {
                                   #
                                   if (refaddr(@{${$stack[-1]}{$name}}[-1]) != refaddr($cache->{$currentelement->{'object_id'}{'id'}})) {
                                       @{${$stack[-1]}{$name}}[-1]=$cache->{$currentelement->{'object_id'}{'id'}};
                                       weaken(@{${$stack[-1]}{$name}}[-1]);
                                   }
							   }
						   }

                           if ($currentelement->{'item'}) {
                               #
                               #
                               #
                               if (ref($currentelement->{'item'}) eq 'ARRAY') {
                                   ${$stack[-1]}{$name} = $currentelement->{'item'};
                                   if (isweak($currentelement->{'item'})) {
                                       weaken(${$stack[-1]}{$name});
                                   }
                               }
                               else {
                                   ${$stack[-1]}{$name} = [$currentelement->{'item'}];
                                   if (isweak($currentelement->{'item'})) {
                                       weaken(@{${$stack[-1]}{$name}}[0]);
                                   }
                               }
                           }

                           $currenttype = pop @typestack;
						   $currentelement = pop @stack; # move back up in the tree
						   $currentvalue = ''; # Reset our current string
						   return;
					   },
					  }
								 );

	return $parser->parse($request);
}

1;
