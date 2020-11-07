# Copyright (c) 2017 Infoblox Inc. All Rights Reserved.
package Infoblox::IBAPBase;
use strict;
use Carp;
use Infoblox::Util;
use Infoblox::Fault qw(papi_error);
use Infoblox::IBAPTypes;
use Scalar::Util qw(weaken isweak);
use Data::Dumper;
use Time::Local;

sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = {};
    bless $self , $class;

    return $self;
}


sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = {};
    bless $self , $class;

    return $self;
}

sub __get_class_methods_class__
{
    my $self=shift;

    #
    #
    #
    return ref($self);
}

#
#
sub __initialize_members_from_arg_list__
{
    my $self=shift;
    my $ref_allowed_members=shift;
    my $ref_args_list=shift;

    if (exists $ref_args_list->{'extattrs'} and exists $ref_args_list->{'extensible_attributes'}) {
        set_error_codes(1002, "Invalid argument, 'extattrs' and 'extensible_attributes' can't both be set at the same time");
        return 0;
    }

    my @overrides;

    foreach my $key ( keys %$ref_args_list )
    {
        if( not exists $$ref_allowed_members{ $key } )
        {
            set_error_codes(1101,"$key is not allowed as an argument!" );
            return 0;
        }

        if ($key =~ /^override_/) {
            push @overrides, $key;
            next;
        }

        if( not $self->$key( $$ref_args_list{ $key } ) )
        {
            append_error_codes(1102,"Cannot set member $key." );
            return 0;
		}
    }

    #
    foreach my $key (@overrides) {
        if( not $self->$key( $$ref_args_list{ $key } ) )
        {
            append_error_codes(1102,"Cannot set member $key." );
            return 0;
        }
    }

    return 1;
}


#
sub __validate_object_required_members__
{
    my $self=shift;
    my $ref_allowed_members=shift;

    foreach my $key (keys %$ref_allowed_members)
    {
        if (ref($ref_allowed_members->{$key})) {
            if (defined $ref_allowed_members->{$key}->{'mandatory'}) {
                if (!defined($self->{$key})) {
                    set_error_codes(1103,"$key is required");
                    return 0;
                }
            } elsif (defined $ref_allowed_members->{$key}->{'readonly'}) {
                if (defined($self->{$key})) {
                    set_error_codes(1104, "Member $key is read only");
                    return 0;
                }
            }
        }
        else {
            if ($$ref_allowed_members{$key} == 1) {
                if (!defined($self->{$key})) {
                    set_error_codes(1103,"$key is required");
                    return 0;
                }
            } elsif ($$ref_allowed_members{$key} == -1) {
                if (defined($self->{$key})) {
                    set_error_codes(1104, "Member $key is read only");
                    return 0;
                }
            }
        }
    }

    return 1;
}

#
sub __initialize_ibap_common_member__ {}
#
#
#
#
#

#
sub __array_contains__
{
    my $self = shift;
    return Infoblox::Util::array_contains(@_);
}

#
#
sub __accessor_lazy_scalar_readonly__
{
    my $self=shift;
    my $member_name=shift;
    my $ref_ibap_to_object=shift;
    my $readfields=shift;


    if( @_ == 0 )
    {   
        if( defined($self->{$member_name}) ){
            return $self->{$member_name};
        }
        unless($self->{'__internal_session_cache_ref__'} && $self->__object_id__()){
          set_error_codes(1001,"In order to access $member_name, the object must have been retrieved from the server first");
          return;
        }
        my $session=${$self->{'__internal_session_cache_ref__'}};
        if(defined($readfields) && defined($ref_ibap_to_object)){
           my $result=$session->__ibap_read_lazy_field__($self,$readfields,$ref_ibap_to_object);
           if(!$result && Infoblox->status_code()==0){
                set_error_codes(1001,"An unspecified error occured in processing the request for $member_name");
           }
           return $self->{$member_name};
        }else{
           set_error_codes(1001,"Internal error");   
        }
    }else{
        set_error_codes(1104, "Member $member_name is read only");
        return;
    }  
}


#
#
sub __accessor_lazy_use_member_array_object__
{
    my $self=shift;
    my $member_name=shift;
    my $ref_use_member=shift;
    my $ref_types_list=shift;
    my $ref_ibap_to_object=shift;
    my $readfields=shift;


    if( @_ == 0 )
    {   
        if( defined($self->{$member_name}) || defined($$ref_use_member)){
            return $self->{$member_name};
        }
        unless($self->{'__internal_session_cache_ref__'} && $self->__object_id__()){
          set_error_codes(1001,"In order to access $member_name, the object must have been retrieved from the server first");
          return;
        }
        my $session=${$self->{'__internal_session_cache_ref__'}};
        if(defined($readfields) && defined($ref_ibap_to_object)){
           my $result=$session->__ibap_read_lazy_field__($self,$readfields,$ref_ibap_to_object);
           if(!$result && Infoblox->status_code()==0){
                set_error_codes(1001,"An unspecified error occured in processing the request for $member_name");
           }
           return $self->{$member_name};
        }else{
           set_error_codes(1001,"Internal error");   
        }
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{$member_name} = undef;
        $$ref_use_member=0;
        }
        else
        {
            if( ref( $value ) eq 'ARRAY' )
            {
                if (Infoblox::Util::check_vector_type($value, $ref_types_list))
                {
                    $self->{$member_name} = $value;
            $$ref_use_member=1;
                }
                else
                {
                    set_error_codes(1104, "Invalid data type for member $member_name");
                    return;
                }
            }
            else
            {
                set_error_codes(1104, "Invalid data type for member $member_name");
                return;
            }
        }
    }
    return 1;
}

sub __object_id__
{
    my $self=shift;
    return $self->__accessor_scalar__({name => '__object_id__', validator => \&ibap_value_o2i_string}, @_);
}

sub __type
{
    my $self=shift;
    if( @_ == 0 )
    {
        return $self->{ "__type" };
    }
    else
    {
        my $value = shift;
        if( !defined $value )
        {
            $self->{ "__type" } = undef;
        }
        else
        {
            $self->{ "__type" } = $value;
        }
    }
    #
}


#
sub __i2o_extensible_attributes__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my %extensible_attributes;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}})
    {
        my %reverse_attribute_types_dict=reverse %Infoblox::Grid::ExtensibleAttributeDef::_ATTRIBUTE_TYPES_DICT;
        my @entries=@{$$ibap_object_ref{$current}};
        my $attribute_value;
        for my $extensible_attribute_entry (@entries)
        {
            if (ref($extensible_attribute_entry) eq 'ib:extensible_attributes_entry')
            {
                my $tag=$$extensible_attribute_entry{'tag'};
                my $values=$$extensible_attribute_entry{'values'};

                if (ref($tag) eq 'ib:object_id')
                {
                    #
                    my $object_id=$$tag{'id'};
                    $tag=$$return_object_cache_ref{$object_id};
                }
                else
                {
                    #
                    my $object_id=$$tag{'object_id'}{'id'};
                    $$return_object_cache_ref{$object_id}=$tag;
                }

                #
                #
                #
                if ((ref($tag) eq 'ib:ExtensibleAttributeDefinition') && (ref($values) eq 'ARRAY') && $$tag{'attribute_type'})
                {
                    my $attribute_name=$$tag{'name'};
                    my $attribute_type=$$tag{'attribute_type'};

                    #
                    $session->__extensible_attribute_def_cache_add_entry__($$tag{'object_id'}{'id'}, $attribute_name, $reverse_attribute_types_dict{$attribute_type},$$tag{'sub_grid'});

                    #
                    my $member_name=Infoblox::Grid::ExtensibleAttributeDef::get_soap_value_member_name($attribute_type);

                    for my $extensible_attribute_value (@$values)
                    {
                        if (ref($extensible_attribute_value) eq 'ib:extensible_attributes_value')
                        {
                            if ($attribute_type eq 'DATE')
                            {
                                $attribute_value=iso8601_datetime_to_unix_timestamp($$extensible_attribute_value{$member_name});
                            }
                            else
                            {
                                $attribute_value=$$extensible_attribute_value{$member_name};
                            }
                            #
                            #

                            if (defined($extensible_attributes{$attribute_name}))
                            {
                                if (ref($extensible_attributes{$attribute_name}) eq 'ARRAY')
                                {
                                    push @{$extensible_attributes{$attribute_name}}, $attribute_value;
                                }
                                else
                                {
                                    my @values;
                                    push @values, $extensible_attributes{$attribute_name};
                                    push @values, $attribute_value;
                                    $extensible_attributes{$attribute_name}=\@values;
                                }
                            }
                            else
                            {
                                $extensible_attributes{$attribute_name}=$attribute_value;
                            }
                        }
                    }

                    my $which = \%extensible_attributes;

                    if (defined $which->{$attribute_name}) {
                        $which->{$attribute_name} = Infoblox::Grid::Extattr->new('value' => $which->{$attribute_name});
                        if (defined $extensible_attribute_entry->{'inheritance_source'}) {
                            $which->{$attribute_name}->{'inheritance_source'} = ibap_i2o_generic_object_convert_partial($self, $session, 'inheritance_source', $extensible_attribute_entry);
                        }
                    }
                }
            }
    	}
    }


    if (scalar(keys %extensible_attributes) == 0)
    {
        return undef;
    }
    else
    {
        return \%extensible_attributes;
    }
}


#
sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref, $skipref) = @_;

    my ($ref_ibap_allowed_members,$ref_ibap_to_object,$ref_reverse_name_mappings);

    {
        no strict 'refs';
        my $objclass = $self->__get_class_methods_class__();
        $ref_ibap_allowed_members  = \%{$objclass . '::_allowed_members'};
        $ref_ibap_to_object        = \%{$objclass . '::_ibap_to_object'};
        $ref_reverse_name_mappings = \%{$objclass . '::_reverse_name_mappings'};
    }

    #
    $self->{'__initializing_from_ibap__'} = 1;
	foreach my $current (sort keys %$ibap_object_ref) {
		next if $skipref && $$skipref{$current};

		my $method = $current;

		if (defined $$ref_reverse_name_mappings{$current}) {
			$method = $$ref_reverse_name_mappings{$current};
		}
		elsif ($current eq 'object_id') {
			$self->__object_id__($$ibap_object_ref{$current}{'id'});
			next;
		}

        #
        #
        #
        #
        if (ref($ref_ibap_allowed_members->{$method}) && defined $ref_ibap_allowed_members->{$method}->{'simple'}) {

            #
            #
            #
            if ($ref_ibap_allowed_members->{$method}->{'simple'} eq 'bool') {
                if ($$ibap_object_ref{$current}) {
                    $self->{$ref_ibap_allowed_members->{$method}->{'name'}} = 'true';
                }
                else {
                    $self->{$ref_ibap_allowed_members->{$method}->{'name'}} = 'false';
                }
            }
            else {
                $self->{$ref_ibap_allowed_members->{$method}->{'name'}} = $$ibap_object_ref{$current};
            }
            next;
        }

        if ($self->can($method)) {
            #
            #
		    if (defined $$ref_ibap_to_object{$current}) {
                $self->$method($$ref_ibap_to_object{$current}($self, $session, $current, $ibap_object_ref, $return_object_cache_ref),$return_object_cache_ref);
		    } else {
			    $self->$method($$ibap_object_ref{$current});
            }
		}
	}

	$self->{'__object_id__'} = $$ibap_object_ref{'object_id'}{'id'};
    delete $self->{'__initializing_from_ibap__'};
    return;
}


#
sub __o2i_extensible_attributes__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;
    my $ref_extensible_attributes=$$tempref{$current};
    my @array_soap_entry_structures;


    if (defined($ref_extensible_attributes))
    {
        for my $attribute_name (keys %$ref_extensible_attributes)
        {
            my $soap_object_id;

            #
            my $ref_cache_entry=$session->__extensible_attribute_def_cache_get_entry__($attribute_name);

            if (defined($ref_cache_entry))
            {
                $soap_object_id=tObjIdRef($$ref_cache_entry{'object_id'});
            }
            else
            {
                #
                #
                $ref_cache_entry={'name' => $attribute_name, 'type' => 'string'};
                $soap_object_id=ibap_readfield_simple_string('ExtensibleAttributeDefinition', 'name', $attribute_name, 'extensible_attribute');
            }

            #
            my @attribute_values;
            my $value = $ref_extensible_attributes->{$attribute_name}->value();
            push(@attribute_values, (ref($value) eq 'ARRAY' ? @$value : $value));

            my @array_soap_value_structures;
            for my $attribute_value (@attribute_values)
            {
                #
                my $error_detail, my $soap_value_structure;
                my $error_code=Infoblox::Grid::ExtensibleAttributeDef::build_soap_value_structure($$ref_cache_entry{'type'}, $attribute_value, \$soap_value_structure, \$error_detail);
                if ($error_code != 0)
                {
                    set_error_codes($error_code, $error_detail, $session);

                    push @return_args, 0;
                    return @return_args;
                }

                push (@array_soap_value_structures, $soap_value_structure);
            }

            my %inheritance = ();
            if ($ref_extensible_attributes->{$attribute_name}->{'inheritance_operation'}) {
                $inheritance{'operation'} = $ref_extensible_attributes->{$attribute_name}->{'inheritance_operation'};
            }
            if ($ref_extensible_attributes->{$attribute_name}->{'descendants_action'}) {

                $inheritance{'descendants_action'} = ibap_serialize_substruct($session, $ref_extensible_attributes->{$attribute_name}->{'descendants_action'},
                    'extensible_attributes_descendants_action');

                return (0) unless $inheritance{'descendants_action'};
            }

            #
            push @array_soap_entry_structures, {'tag' => $soap_object_id, 'values' =>\@array_soap_value_structures, %inheritance};
        }

        #
        push @return_args, 1;
		push @return_args, 0;
        push @return_args, tIBType('ArrayOfextensible_attributes_entry',\@array_soap_entry_structures);

    }
    else
    {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, tIBType('ArrayOfextensible_attributes_entry', []);
	}

	return @return_args;
}

#
#
#
#
#
#
sub __dateshelper__
{
    my ($self, $session, $date, $printable) = @_;
    my ($pre, $post);
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst);
    my ($nsec,$nmin,$nhour,$nmday,$nmon,$nyear,$nwday,$nyday,$nisdst);

    my $currenttime = time();
    if ($date =~ m!^(\d\d\d\d)-(\d\d)-(\d\d)$!) {
        $year = $1 - 1900;
        $mon = $2 - 1;
        $mday = $3;
    } elsif ($date eq 'today') {
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($currenttime);
    } elsif ($date eq 'tomorrow') {
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($currenttime + 86400);
    } elsif ($date eq 'yesterday') {
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($currenttime - 86400);
    } elsif ($date eq 'thisweek') {
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($currenttime);

        #
        my $sowtime = timelocal(0,0,0,$mday,$mon,$year);

        #
        $sowtime = $sowtime - $wday * 86400;

        #
        #
        my $eowtime = $sowtime + 7 * 86400;

        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($sowtime);
        ($nsec,$nmin,$nhour,$nmday,$nmon,$nyear,$nwday,$nyday,$nisdst) = localtime($eowtime);
    } elsif ($date eq 'thismonth') {
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($currenttime);

        #
        my $somtime = timelocal(0,0,0,1,$mon,$year);

        #
        #
        #
        my $eomtime = $somtime + 32 * 86400;
        ($nsec,$nmin,$nhour,$nmday,$nmon,$nyear,$nwday,$nyday,$nisdst) = localtime($eomtime);
        $eomtime = timelocal(0,0,0,1,$nmon,$nyear);

        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($somtime);
        ($nsec,$nmin,$nhour,$nmday,$nmon,$nyear,$nwday,$nyday,$nisdst) = localtime($eomtime);
    } elsif ($date =~ m/^(-|\+)([0-9]+)$/) {
        my ($direction, $amount, $type) = ($1,$2,$3);

        #
        #
        #
        if ($direction eq '-') {
            ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($currenttime - 86400 * $amount);
            ($nsec,$nmin,$nhour,$nmday,$nmon,$nyear,$nwday,$nyday,$nisdst) = localtime($currenttime);
        } else {
            ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($currenttime + 86400);
            ($nsec,$nmin,$nhour,$nmday,$nmon,$nyear,$nwday,$nyday,$nisdst) = localtime($currenttime + 86400 * ($amount + 1));
        }
    } elsif ($date =~ m/^[0-9]+$/) {
        ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime(timestamp_at_11_01_on_same_utc_day($date));
    } else {
        set_error_codes(1104,"Invalid date '$printable' for the extensible attribute", $session);
        return undef;
    }

    #
    unless ($nyear) {
        my $nextdayepoch = timelocal(0,0,0,$mday,$mon,$year);
        $nextdayepoch += 86400;
        ($nsec,$nmin,$nhour,$nmday,$nmon,$nyear,$nwday,$nyday,$nisdst) = localtime($nextdayepoch);
    }

    $mon = sprintf("%02d", $mon+1);
    $nmon = sprintf("%02d", $nmon+1);
    $mday = sprintf("%02d", $mday);
    $nmday = sprintf("%02d", $nmday);
    $year += 1900;
    $nyear +=1900;
    $pre = tDateTime(iso8601_datetime_to_unix_timestamp($year . '-' . $mon . '-' . $mday . "T00:00:00Z"));
    $post = tDateTime(iso8601_datetime_to_unix_timestamp($nyear . '-' . $nmon . '-' . $nmday . "T00:00:00Z"));

    return ($pre, $post);
}

#
sub __o2i_search_extensible_attributes__
{
	my ($self, $session, $current, $tempref, $type) = @_;
	my @return_args;


    my $extensible_attributes_value=$$tempref{$current};
	if ((defined $extensible_attributes_value) && (keys %$extensible_attributes_value))
    {
        #
        if ($current eq 'extensible_attributes') {
            if (Infoblox::Grid::ExtensibleAttributeDef::validate_extensible_attributes_attr_format($extensible_attributes_value) == 0)
            {
                set_error_codes(1004, 'Invalid data type for member extensible_attributes', $session);

                push @return_args, 0;
                return @return_args;
            }
        } else {
            if (Infoblox::Grid::ExtensibleAttributeDef::validate_extattr_format($extensible_attributes_value) == 0)
            {
                set_error_codes(1004, 'Invalid data type for member extattrs', $session);

                push @return_args, 0;
                return @return_args;
            }
        }

        my @array_soap_matchlist_structures;
        for my $attribute_name (keys %$extensible_attributes_value)
        {
            my $soap_object_id;

            #
            my $ref_cache_entry=$session->__extensible_attribute_def_cache_get_entry__($attribute_name);
            if (defined($ref_cache_entry))
            {
                $soap_object_id= tObjId($$ref_cache_entry{'object_id'});
            }
            else
            {
                #
                #
                $ref_cache_entry={'name' => $attribute_name, 'type' => 'string'};
                $soap_object_id=ibap_readfield_simple_string('ExtensibleAttributeDefinition', 'name', $attribute_name, 'extensible_attribute');
            }

            my $value = $current eq 'extensible_attributes' ? $$extensible_attributes_value{$attribute_name} : $extensible_attributes_value->{$attribute_name}->value();
            my $nocase = 0;

            #
            if (ref($value) eq 'HASH' ) {
                if (defined $value->{'value'} && $$ref_cache_entry{'type'} eq 'string') {
                    $nocase = 1 if defined $value->{'case_insensitive'} && $value->{'case_insensitive'} eq 'true';
                    $value = $value->{'value'};
                }
                else {
                    set_error_codes(1004, 'Invalid data type for member ' . $attribute_name . ' of extensible_attributes', $session);
                    return (0);
                }
            }

            #
            my @attribute_values;
            if (ref($value) eq 'ARRAY')
            {
                push(@attribute_values, @{$value});
            }
            else
            {
                push(@attribute_values, $value);
            }

            #
            my $search_type;
            if ($type && $type eq 'search')
            {
                #
                if (defined $$ref_cache_entry{'type'} && ($$ref_cache_entry{'type'} eq 'integer' || $$ref_cache_entry{'type'} eq 'date'))
                {
                    $search_type='EXACT';
                }
                else
                {
                    $search_type='REGEX';
                }
            }
            else
            {
                $search_type='EXACT';
            }

            my @array_soap_value_match_stuctures;

            for my $attribute_value (@attribute_values)
            {
                #
                my $error_detail, my $member_name, my $member_value; my $additional;
                my $ifmatch = 'POSITIVE';

                #
                if ($type && $type eq 'search' && defined $$ref_cache_entry{'type'} && $$ref_cache_entry{'type'} eq 'integer') {
                    #
                    #
                    #
                    #
                    #
                    #
                    #
                    #

                    if ($$ref_cache_entry{'type'} eq 'integer') {
                        my ($always, $optional) = gleq_search_helper($attribute_value, $search_type);
                        $ifmatch = $always->{'ifmatch'};
                        $search_type = $always->{'search_type'};

                        my $error_code=Infoblox::Grid::ExtensibleAttributeDef::get_soap_value_structure_members($$ref_cache_entry{'type'}, $always->{'value'}, \$member_name, \$member_value, \$error_detail);
                        if ($error_code != 0) {
                            set_error_codes($error_code, $error_detail, $session);
                            return (0);
                        }

                        if ($optional) {
                            $additional = $optional;

                            my $error_code=Infoblox::Grid::ExtensibleAttributeDef::get_soap_value_structure_members($$ref_cache_entry{'type'}, $optional->{'value'}, \$additional->{'field'}, \$additional->{'value'}, \$error_detail);
                            if ($error_code != 0) {
                                set_error_codes($error_code, $error_detail, $session);
                                return (0);
                            }
                        }
                    }
                } elsif ($$ref_cache_entry{'type'} && $$ref_cache_entry{'type'} eq 'date' && $attribute_value !~ m/^[0-9]+$/) {
                    #
                    $member_name = Infoblox::Grid::ExtensibleAttributeDef::get_soap_value_member_name_by_cache_entry($session,$$ref_cache_entry{'type'});

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

                    my $aifmatch = 'NEGATIVE';
                    my $asearchtype = 'GEQ';
                    my $adate;

                    #
                    my $munged_attribute = lc $attribute_value;
                    $munged_attribute =~ s/ //g;
                    if (index($munged_attribute, '>=<') == 0) {
                        $munged_attribute =~ m/^>=<([^,]+),(.*)$/;
                        my ($left, $right) = ($1, $2);

                        unless ($left && $right) {
                            set_error_codes(1104,"Invalid date '$attribute_value' for the extensible attribute", $session);
                            return (0);
                        }

                        my ($date1l, $date1r) = $self->__dateshelper__($session,$left,$attribute_value);
                        return (0) unless $date1l;

                        my ($date2l, $date2r) = $self->__dateshelper__($session,$right,$attribute_value);
                        return (0) unless $date2l;

                        #
                        #
                        $search_type = 'GEQ';
                        $member_value = $date1l;

                        $adate = $date2r;
                    } elsif (index($munged_attribute, '>=') == 0 || index($munged_attribute, '=>') == 0) {
                        $munged_attribute = substr($munged_attribute, 2);
                        my ($datel, $dater) = $self->__dateshelper__($session,$munged_attribute,$attribute_value);
                        return (0) unless $datel;

                        $search_type = 'GEQ';
                        $member_value = $datel;
                    } elsif (index($munged_attribute, '<=') == 0 || index($munged_attribute, '=<') == 0) {
                        $munged_attribute = substr($munged_attribute, 2);
                        my ($datel, $dater) = $self->__dateshelper__($session,$munged_attribute,$attribute_value);
                        return (0) unless $datel;

                        $search_type = 'GEQ';
                        $ifmatch = 'NEGATIVE';
                        $member_value = $dater;
                    } elsif (index($munged_attribute, '>') == 0) {
                        $munged_attribute = substr($munged_attribute, 1);
                        my ($datel, $dater) = $self->__dateshelper__($session,$munged_attribute,$attribute_value);
                        return (0) unless $datel;

                        $search_type = 'GEQ';
                        $member_value = $dater;
                    } elsif (index($munged_attribute, '<') == 0) {
                        $munged_attribute = substr($munged_attribute, 1);
                        my ($datel, $dater) = $self->__dateshelper__($session,$munged_attribute,$attribute_value);
                        return (0) unless $datel;

                        $search_type = 'GEQ';
                        $ifmatch = 'NEGATIVE';
                        $member_value = $datel;
                    } else {
                        my ($datel, $dater) = $self->__dateshelper__($session,$munged_attribute,$attribute_value);
                        return (0) unless $datel;

                        $search_type = 'GEQ';
                        $member_value = $datel;

                        $adate = $dater;
                    }

                    $additional = {
                                   field       => $member_name,
                                   ifmatch     => $aifmatch,
                                   search_type => $asearchtype,
                                   value       => $adate,
                                  } if $adate;
                } else {
                    my $error_code=Infoblox::Grid::ExtensibleAttributeDef::get_soap_value_structure_members($$ref_cache_entry{'type'}, $attribute_value, \$member_name, \$member_value, \$error_detail);
                    if ($error_code != 0) {
                        set_error_codes($error_code, $error_detail, $session);
                        return (0);
                    }
                }

                #
                my $soap_search_field = {
                                         field       => $member_name,
                                         ifmatch     => $ifmatch,
                                         search_type => $search_type,
                                         value       => $member_value,
                                        };

                if ($nocase) {
                    $soap_search_field->{'match_case'} = 'IGNORE_CASE';
                }

                #
                if ($additional) {
                    push @array_soap_value_match_stuctures,
                      { search_fields => [$soap_search_field, $additional] };
                }
                else {
                    push @array_soap_value_match_stuctures,
                      { search_fields => [$soap_search_field] };
                }
            }

            #
            my $soap_search_field_tag =  { field => 'tag',
                                           value => $soap_object_id };
            my $soap_search_field_values = { field => 'values',
                                             value => tIBType('ArrayOfSubMatch', \@array_soap_value_match_stuctures),
                                             list_op => 'SUBSET' };

            #
            my $soap_matchlist_structure =
                { search_fields =>
                      [ $soap_search_field_tag, $soap_search_field_values] };

            push @array_soap_matchlist_structures, $soap_matchlist_structure;
        }

        push @return_args, 1;
		push @return_args, 0;
		push @return_args, tIBType('ArrayOfSubMatch',
                                   \@array_soap_matchlist_structures);
    }
    else
    {
        push @return_args, 1;
        push @return_args, 1;
        push @return_args, undef;
    }

    return @return_args;
}


#
sub __object_to_ibap__
{
	my ($self, $server, $session, $skipref) = @_;

	my @write_fields;

    my $ref_name_mappings;
    my $ref_object_to_ibap;

    {
        no strict 'refs';
        my $objclass = $self->__get_class_methods_class__();
        $ref_name_mappings  = \%{$objclass . '::_name_mappings'};
        $ref_object_to_ibap = \%{$objclass . '::_object_to_ibap'};

        #
        #
        #
        #
        #
        #
    }


	foreach my $current (keys %$self) {
		next if $current =~ m/^__/;
		next if $skipref && $$skipref{$current};

		my %write_arg;
		if (defined $$ref_name_mappings{$current}) {
			$write_arg{'field'} = $$ref_name_mappings{$current};
		}
		else {
			$write_arg{'field'} = $current;
		}

        die "Internal error: can't find serializer for $current in object " . ref($self) unless $$ref_object_to_ibap{$current};
        my @converted_values = $$ref_object_to_ibap{$current}($self, $session, $current,$self);

		if (@converted_values) {
			my $success=shift @converted_values;
			if ($success) {
				my $ignore_value=shift @converted_values;
				$write_arg{'value'} = shift @converted_values;

				foreach my $extra_args (@converted_values) {
					unshift @write_fields, $extra_args;
				}

				if ($ignore_value) {
					next;
				}
			} else {
				return;
			}
		} else {
			next;
		}
		unshift @write_fields, \%write_arg;
	}
	return \@write_fields;
}

sub __search_mapping_fields__
{
    my ($self, $session, $type, $argsref) = @_;
	my %out_search_fields;
	my %out_search_types;
	my %out_search_matches;

    my $ref_searchable_fields;
    my $objclass;

    {
        no strict 'refs';
        $objclass = $self->__get_class_methods_class__();
        $ref_searchable_fields  = \%{$objclass . '::_searchable_fields'};
    }

    if ($self->can('__search_mapping_hook_pre__')) {
        return unless $self->__search_mapping_hook_pre__($session, $type, $argsref, \%out_search_fields, \%out_search_types, \%out_search_matches);
    }

	foreach my $key (keys %{$argsref}) {
        #
        next if $key eq 'maximum_objects_returned';

		unless (defined $$ref_searchable_fields{$key}) {
            #
            #
            #

#
#
#

            set_error_codes(1104,"Invalid search field '$key' for object " . ref($self), $session);
            return undef;
        }

		my ($outfunction, $outkey, $outtype, $outmatch) = @{$$ref_searchable_fields{$key}};

        next if $outtype eq 'DEPRECATED';

        if ($outtype eq 'GLEQ') {
            #
            #
            #
            #

            my ($always, $optional) = gleq_search_helper($argsref->{$key}, 'EXACT');

            #
            $always->{'always'} = 1;
            foreach my $which ($always, $optional) {
                next unless $which;

                #
                #
                #

                $argsref->{$key} = $which->{'value'};
                my @converted_values = &$outfunction($self, $session, $key, $argsref, $type, $outkey);
                my $success=shift @converted_values;
                if ($success) {
                    my $ignore = shift @converted_values;

                    my $t = shift @converted_values;
                    unless ($ignore) {
                        #
                        #
                        my $toutkey = $outkey;
                        if ($which->{'search_type'} ne 'EXACT') {
                            if ($which->{'always'}) {
                                $toutkey = '##ALWAYS_' . $toutkey;
                            } else {
                                $toutkey = '##OPTIONAL_' . $toutkey;
                            }
                        }

                        $out_search_fields{$toutkey} = $t;
                        $out_search_types{$toutkey}=$outtype;
                        #
                        if ($which->{'search_type'} ne 'EXACT') {
                            #
                            #
                            $out_search_types{$toutkey}=$which->{'search_type'} . '_' . $which->{'ifmatch'} . '_' . $outkey;
                        } else {
                            if ($which->{'ifmatch'} eq 'NEGATIVE') {
                                $out_search_types{$toutkey}='EXACT_NEGATIVE';
                            }
                            else {
                                $out_search_types{$toutkey}='EXACT';
                            }
                        }
                    }
                }
            }
        }
        else {
            my @converted_values = &$outfunction($self, $session, $key, $argsref, $type, $outkey);
            if (@converted_values) {
                if ($outkey eq '__DYNAMIC__') {
                    $outkey = shift @converted_values;
                }

                my $success=shift @converted_values;
                if ($success) {
                    my $ignore = shift @converted_values;

                    my $t = shift @converted_values;
                    unless ($ignore) {
                        $out_search_fields{$outkey} = $t;
                        $out_search_types{$outkey}=$outtype;
                        $out_search_matches{$outkey}=$outmatch;
                    }

                    #
                    #
                    foreach my $extra_args (@converted_values) {
                        $out_search_fields{$$extra_args{'field'}} = $$extra_args{'value'};
                        $out_search_types{$$extra_args{'field'}}=$outtype;
                    }

                } else {
                    return;
                }
            }
		}
	}

    if ($self->can('__search_mapping_hook_post__')) {
        return unless $self->__search_mapping_hook_post__($session, $type, $argsref, \%out_search_fields, \%out_search_types, \%out_search_matches);
    }

    return (\%out_search_fields, \%out_search_types, \%out_search_matches);
}

sub __return_fields__
{
    my $self=shift;
    my $attr_ref = shift;
    my $wanted_partials = shift;
    my $optionalreturnfields;
    my @return_array = ();

    #
    #
    my $notpartial = 1;
    my $fieldsref;
    my $namemappingref;
    my $overridemappingref;

    {
        no strict 'refs';
        my $objclass = $self->__get_class_methods_class__();
        $namemappingref     = \%{$objclass . '::_name_mappings'};
        $fieldsref          = \@{$objclass . '::_return_fields'};
        $overridemappingref = \%{$objclass . '::_return_field_overrides'};
        $optionalreturnfields = \@{$objclass . '::_optional_return_fields'};
    }

    if ($attr_ref && $#$attr_ref >= 0 && $overridemappingref) {
		my %wanted_fields;
		my %not_wanted_fields;

        #
        #
        #
        #
        my $cycleall = 1;

        my (%normal_fields, %optional_fields, %negative_fields, @processed_fields);
		foreach my $a (@$attr_ref) {
            if (index($a,'+') == 0) {
                $a = substr($a,1);
                $optional_fields{$a} = 1;
                die papi_error(1101, "$a should be specified only once in return_methods ") if ($negative_fields{$a} || $normal_fields{$a});
            } elsif (index($a,'-') == 0) {
                $a = substr($a,1);
                $negative_fields{$a} = 1;
                $notpartial = undef;
                die papi_error(1101, "$a should be specified only once in return_methods ") if ($optional_fields{$a} || $normal_fields{$a});
            } else {
                $normal_fields{$a} = 1;
                $notpartial = undef;
                $cycleall = 0;
                die papi_error(1101, "$a should be specified only once in return_methods ") if ($negative_fields{$a} || $optional_fields{$a});
            }

            push @processed_fields, $a;
        }

		foreach my $a (@processed_fields) {
            unless (exists $overridemappingref->{$a}) {
                die papi_error(1101,
                               "$a is not a defined method for " . ref($self));
            }

			my $mapped = $$namemappingref{$a} || $a;
            if ($negative_fields{$a}) {
                $not_wanted_fields{$mapped} = 1;
            }
            else {
                $wanted_fields{$mapped} = 1;
            }

			if ($$overridemappingref{$a}) {
				foreach (@{$$overridemappingref{$a}}) {
					delete $wanted_fields{$mapped} if $_ =~ m/^!/;
					my $submapped = $_;
					$submapped =~ s/^!//;

                    if ($submapped =~ m/^#/) {
                        #
                        #
                        #
                        #
                        $submapped =~ s/^#//;
                    }
                    else {
                        $submapped = $$namemappingref{$submapped} || $submapped;
                    }

                    if ($negative_fields{$a}) {
                        $not_wanted_fields{$submapped} = 1;
                    } else {
                        $wanted_fields{$submapped} = 1;
                    }
				}
			}
		}

        #
        #
        if ($optionalreturnfields) {
            foreach my $i (@$optionalreturnfields) {
                next unless ($wanted_fields{${$i->value()}{'field'}});
                push @return_array, $i;

                #
                delete $wanted_fields{${$i->value()}{'field'}};
            }
        }

		#
		#
		foreach my $i (@$fieldsref) {
            my $methodname = ${$i->value()}{'field'};

            if ($cycleall) {
                push @return_array, $i unless $not_wanted_fields{$methodname};
            }
            else {
                push @return_array, $i if $wanted_fields{$methodname};
            }
		}
    }

    if ($wanted_partials) {
        unless (@return_array) {
            push @return_array, @$fieldsref;
        }

        #
        #
        #
        #

        for my $t (1 .. $#return_array) {
            if (${$return_array[$t]->value()}{'sub_fields'}) {

                #
                #
                #

                foreach (keys %papi_partial_subobjects) {

                    #
                    #
                    #

                    if ($papi_partial_subobjects{$_} == ${$return_array[$t]->value()}{'sub_fields'}) {
                        no strict 'refs';
                        $return_array[$t] = tField( ${$return_array[$t]->value()}{'field'}, {sub_fields => \@{$_ . '::_minimal_return_fields'}});
                        last;
                    }
                }
            }
        }
    }

    if (@return_array) {
		return (\@return_array,$notpartial);
    }
    else {
        return $fieldsref;
    }
}

sub __dump__
{
    my ($self, $field, $just, $inarray, $seen) = @_;

    $seen = {} unless $seen;
    $just = '' unless $just;
    $field = '' unless $field;

    my $t=ref($self);
    if ($t) {
        if ($t eq 'ARRAY') {
            print $just . $field . " -> [\n";
            $field =~ s/./ /g;
            foreach (@$self) {
                __dump__($_,'',$just . '    ' . $field, 1, $seen);
            }
            print $just . $field . "    ]\n";
        } elsif ($t =~ /Infoblox/) {
            if ($seen->{$self}) {
                print $just . $field . "    ----- recursive reference $self----\n";
                return;
            }
            $seen->{$self} = 1;

            #
            $t = $self->__get_class_methods_class__();

            #
            #
            #
            #
            no strict 'refs';

            print $just . $field . " $self {\n";
            $field =~ s/./ /g;
            if (keys %{"${t}::_allowed_members"}) {
                foreach my $current (sort keys %{"${t}::_allowed_members"}) {
                    if ($self->can($current)) {
                        __dump__($self->$current(),$current,$just . '    ' . $field, 0, $seen);
                    }
                    else {
                        print $just . '    ' . $current . " -> NOT CALLABLE\n";
                    }
                }
            }
            else {
                use Data::Dumper;
                print Dumper($self);
            }
            print $just . $field . " }\n";
        } elsif ($t eq 'HASH') {
            #

            print $just . $field . " -> {\n";
            $field =~ s/./ /g;
            foreach (keys %$self) {
                __dump__($$self{$_},$_,$just . '    ' . $field, 0, $seen);
            }
            print $just . $field . "    }\n";
        }
        else {
            #
            print $just . $field . Dumper($self);
        }
    }
    else {
        if (defined $self) {
            if ($self ne '') {
                print $just . $field . ($inarray ? '' : ' -> ') . $self . "\n";
            }
            else {
                print $just . $field . ($inarray ? "''\n" : " -> ''\n");
            }
        }
        else {
            print $just . $field . " -> undef\n";
        }
    }
}

#

sub __accessor_validate_common__
{
    my $self    = shift;
    my $name    = shift;
    my $options = shift;
    my $value   = shift;

    if (defined $$options{'enum'}) {
        unless ($self->__array_contains__($value, $$options{'enum'})) {

            #
            #
            #

            unless (defined $$options{'validator'}) {
                set_error_codes(1104,"Invalid value '$value' for member '$name', valid values are: \"" . join('", "', @{$$options{'enum'}}) . '"');
                return 0;
            }
        }
        else {
            return 1;
        }
    }

    if (defined $$options{'validator'}) {
        #
        #
        if (ref($$options{'validator'}) eq 'HASH') {
            my $type = ref($value) ? ref($value) : 'string';
            unless (defined $$options{'validator'}{$type}) {
                set_error_codes(1104, 'Invalid data type ' . $type . ' for member ' . $name);
                return 0;
            }

            #
            #
            #
            if (ref($$options{'validator'}{$type})) {
                unless ($$options{'validator'}{$type}($value,$name,undef,1)) {
                    if (defined $$options{'enum'}) {
                        my $detail = Infoblox->status_detail();
                        $detail .= ' also supported are these values: ' . join('", "', @{$$options{'enum'}}) . '"';
                        Infoblox->status_detail($detail);
                    }

                    return 0;
                };
            }
        }
        else {
            #
            unless ($$options{'validator'}($value,$name,undef,1)) {
                if (defined $$options{'enum'}) {
                    my $detail = Infoblox->status_detail();
                    $detail .= ' also supported are these values: ' . join('", "', @{$$options{'enum'}}) . '"';
                    Infoblox->status_detail($detail);
                }

                return 0;
            }
        }

        return 1;
    }

    if (defined $$options{'readonly'} && $$options{'readonly'}) {
        #
        #
        #
        return 1;
    }

    set_error_codes(1012,"Internal error, missing validator for for member " . $name);
    return 0;
}

sub __use_helper__
{
    my ($self, $options, $value) = @_;

    if ($options->{'use'}) {
        if (defined $value) {
            if (ref($options->{'use'})) {
                ${$options->{'use'}} = $options->{'use_truefalse'} ? 'true' : 1;
            } else {
                $self->{$options->{'use'}} = $options->{'use_truefalse'} ? 'true' : 1;
            }
        } else {
            my $allundef = 1;
            my $use_members = $options->{'use_members'} ? $options->{'use_members'} : [];

            foreach (@$use_members) {
                next if $_ eq $options->{'name'};
                if (defined $self->{$_}) {
                    $allundef = 0;
                    last;
                }
            }

            if ($allundef) {
                if (ref($options->{'use'})) {
                    ${$options->{'use'}} = $options->{'use_truefalse'} ? 'false' : 0;
                } else {
                    $self->{$options->{'use'}} = $options->{'use_truefalse'} ? 'false' : 0;
                }
            }
        }
    }
}

sub __accessor_scalar__
{
    my $self    = shift;
    my $options = shift;
    my $name    = $$options{'name'};

    if (defined $$options{'deprecated'}) {
        if ( @_ == 0 ) {
            return undef;
        } else {
            return 1;
        }
    }

    unless (defined $name) {
        set_error_codes(1104,"Internal error, no name set in accessor parameters");
        return undef;
    }

    if (@_ == 0) {
        if ($$options{'writeonly'}) {
            set_error_codes(1104, 'Member ' . $name . ' is write-only');
            return undef;
        }
        return $self->{$name}
    }

    if (defined $$options{'readonly'} && not defined $self->{'__initializing_from_ibap__'}) {
	    set_error_codes(1104, 'Member ' . $name . ' is read only');
        return undef;
    }

    if (defined $$options{'oidreadonly'} && $self->__object_id__() && not defined $self->{'__initializing_from_ibap__'}) {
        set_error_codes(1104, 'Member ' . $name . ' is read only for objects retrieved from the server');
        return undef;
    }

    my $value = shift;

    if ($$options{'writeonly'} && $self->{'__initializing_from_ibap__'}) {
        #
        #
        if (defined $value and $value eq '{undisclosed}') {
            return 1;
        }
    }

    if( !defined $value )
    {
        $self->{$name} = undef;

        #
        #
        #
        #
        $self->__use_helper__($options, $value);
        return 1;
    }

    return unless $self->__accessor_validate_common__($name,$options,$value,@_);

    $self->{$name} = $value;
    $self->__use_helper__($options, $value);

    if (ref($value) # XXX: unfortunately some code calls us with
                    #
        && ref($value) =~ m/^Infoblox/
        && $value->can('__object_id__')
        && $value->__object_id__()
        && defined $_[1]
        && defined $_[1]->{'__recursive__'}
        && defined $_[1]->{'__recursive__'}{$value->__object_id__()}
       ) {
        #
        #
        #
        #
        #
        weaken($self->{$name});
    }

	return 1;
}

sub __accessor_array__
{
    my $self    = shift;
    my $options = shift;
    my $name    = $$options{'name'};

    if (defined $$options{'deprecated'}) {
        if ( @_ == 0 ) {
            return undef;
        } else {
            return 1;
        }
    }

    unless (defined $name) {
        set_error_codes(1104,"Internal error, no name set in accessor parameters");
        return undef;
    }

    return $self->{$name} if (@_ == 0);

    if (defined $$options{'readonly'} && not defined $self->{'__initializing_from_ibap__'}) {
	    set_error_codes(1104, 'Member ' . $name . ' is read only');
        return undef;
    }

    if (defined $$options{'oidreadonly'} && $self->__object_id__() && not defined $self->{'__initializing_from_ibap__'}) {
        set_error_codes(1104, 'Member ' . $name . ' is read only for objects retrieved from the server');
        return undef;
    }

    my $value = shift;
    if( !defined $value )
    {
        $self->{$name} = undef;
        $self->__use_helper__($options, $value);
        return 1;
    }

    if (ref $value ne 'ARRAY') {
        set_error_codes(1104, 'Invalid data type ' . ref($value) . ' for member ' . $name . ' (only ARRAY is supported)');
        return undef;
    }

    if (defined $$options{'nomixed'}) {
        my %seen;
        foreach (@$value) {
            $seen{ref($_)} = 1;
        }

        if (scalar(keys %seen) > 1) {
            set_error_codes(1104, 'Invalid value for member ' . $name . ' (only arrays composed of a single object type are supported, your list contains: ' . join(', ',keys(%seen)) . ' )');
            return undef;
        }
    }

    foreach (@$value) {
        return unless $self->__accessor_validate_common__($name,$options,$_,@_);
    }

    if (defined $$options{'unique'}) {
        my %oids = ();
        foreach my $obj (@$value) {
            unless (ref($obj) =~ /^Infoblox::/) {
                set_error_codes(1104, 'Member ' . $name . ' must be an array of Infoblox objects');
                return undef;
            }

            unless (defined $obj->{'__object_id__'}) {
                set_error_codes(1104, 'Member ' . $name . ' must be an array of objects that have been retrieved from the appliance');
                return undef;
            }

            if (defined $oids{$obj->{'__object_id__'}}) {
                set_error_codes(1104, 'Member ' . $name . ' must be an array without duplicate objects');
                return undef;
            }

            $oids{$obj->{'__object_id__'}} = 1;
        }
    }

    $self->{$name} = $value;

    if (defined $$options{'empty_list_disable'} && scalar(@$value) == 0) {
        $self->__use_helper__($options, undef);
    } else {
        $self->__use_helper__($options, $value);
    }

	return 1;
}

sub __mgm_private_lazy_load__ {

    my $self = shift;
    my $what = shift;

    #
    return 1 if exists $$self{$what};

    unless ($self->{__internal_session_cache_ref__}) {

        set_error_codes('1001', 'In order to access MGM private methods, ' .
            'the object must have been retrieved from the server first');

        return undef;
    }

    my $session = ${$self->{__internal_session_cache_ref__}};

    my $server = $session->get_ibap_server() || return undef;

    my $result;
    eval {
        $result = $server->ObjectRead({
            'depth'         => 0,
            'object_ids'    => [tObjId($self->__object_id__())],
            'return_fields' => [
                tField('mgm_private'),
                tField('mgm_private_overridable'),
                tField('use_mgm_private'),
            ],
        });
    };

    return $server->set_papi_error($@, $session) if $@;

    my $obj = $result->[0];

    my %_name_mappings = (
        'override_mgm_private' => 'use_mgm_private',
    );

    foreach (
        'mgm_private',
        'mgm_private_overridable',
        'override_mgm_private',
    ) {

        my $member = $_name_mappings{$_} || $_;
        $$self{$_} = ibap_value_i2o_boolean($$obj{$member})
            unless exists $$self{$_};
    }

    return 1;
}

my %_mgm_private_accessors = (

    'mgm_private'             => {'validator' => \&ibap_value_o2i_boolean, 'use' => 'override_mgm_private', 'use_truefalse' => 1},
    'override_mgm_private'    => {'validator'=> \&ibap_value_o2i_boolean},
    'mgm_private_overridable' => {readonly => 1},
);

sub create_mgm_private_accessors {

    no strict 'refs';

    my $caller = caller();

    foreach my $current (keys %_mgm_private_accessors) {

        my $method = $caller . '::' . $current;

        *$method = sub {
            my $self = shift;

            return undef if not @_ and not $self->__mgm_private_lazy_load__($current);

            return $self->__accessor_scalar__(
                {name => $current, %{$_mgm_private_accessors{$current}}},
                @_);
        }
    }
}


sub create_accessors
{
    #
    no strict 'refs';

    my $_allowed_members = shift;
    my $caller = caller();

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

    foreach my $current (keys %$_allowed_members) {
        my $method = $caller . '::' . $current;

        #
        #
        next unless ref($$_allowed_members{$current});

        #
        next if $_allowed_members->{$current}->{'skip_accessor'};

        #
        $$_allowed_members{$current}{'name'} = $current unless defined $$_allowed_members{$current}{'name'};

        if (defined $$_allowed_members{$current}{'special'}) {
            if ($$_allowed_members{$current}{'special'} eq 'extensible_attributes') {
                *$method = sub { return Infoblox::Util::extensible_attributes_accessor_helper($$_allowed_members{$current}{'name'}, $$_allowed_members{$current}{'readonly'}, @_); };
            } 
        } elsif (defined $$_allowed_members{$current}{'array'}) {
            *$method = sub {
                my $self  = shift;
                return $self->__accessor_array__($$_allowed_members{$current}, @_);
            };
        } else {
            *$method = sub {
                my $self  = shift;
                return $self->__accessor_scalar__($$_allowed_members{$current}, @_);
            };
        }
    }
}

sub subclass
{
    my ($from, $to, $skip) = @_;

    $skip = {} unless defined $skip;

    #
    no strict 'refs';

    #
    #
    #
    $to = $papi_object_type_from_wsdl{'ib:' . $to};

    #
    foreach my $hashkey (
                         '_allowed_members',
                         '_return_field_overrides',
                         '_name_mappings',
                         '_reverse_name_mappings',
                         '_ibap_to_object',
                         '_object_to_ibap',
                         '_searchable_fields',
                         '_capabilities',
                        ) {
        my $from_hash = \%{"$from\::$hashkey"};
        my $to_hash = \%{"$to\::$hashkey"};

        foreach my $key (keys %$from_hash) {
            next if defined $skip->{$key};
            #
            $to_hash->{$key} = $from_hash->{$key} unless defined $to_hash->{$key};
        }
    }

    #
    my $from_return_fields = \@{"$from\::_return_fields"};
    my $to_return_fields = \@{"$to\::_return_fields"};
    foreach (@$from_return_fields) {
        next if defined $skip->{$_->{'val'}->{'field'}};
        push @$to_return_fields, $_;
    }
}

sub create_discovered_data_fields
{
    #
    #
    #
    #
    #

    #
    no strict 'refs';

    my @members = @_;
    my $caller = caller();

    my %_discovered_fields_ = (
      last_discovered                    => {simple => 'asis', name => 'last_discovered',  validator => \&ibap_value_o2i_string} ,
      mac_address                        => {simple => 'asis', name => 'mac_address', validator => \&ibap_value_o2i_string} ,
      v_type => {name => 'v_type', enum => ['VirtualCenter','HostSystem','VirtualMachine',''], readonly => 1  },
    );

    my %_discovered_search_fields = (
        discovered_duid                    => [\&ibap_o2i_substruct_exact_search, 'duid', 'SUBMATCHSTRUCT_discovered_data'], 
        discovered_mac_address             => [\&ibap_o2i_substruct_exact_search, 'mac_address', 'SUBMATCHSTRUCT_discovered_data'], 
        discovered_name                    => [\&ibap_o2i_substruct_search, 'discovered_name', 'SUBMATCHSTRUCT_discovered_data'], 
        discoverer                         => [\&ibap_o2i_substruct_search, 'discoverer', 'SUBMATCHSTRUCT_discovered_data'], 
        first_discovered                   => [\&ibap_o2i_substruct_exact_datetime_search, 'first_discovered', 'SUBMATCHSTRUCT_discovered_data'], 
        last_discovered                    => [\&ibap_o2i_substruct_exact_datetime_search, 'last_discovered', 'SUBMATCHSTRUCT_discovered_data'], 
        mac_address                        => [\&ibap_o2i_substruct_search, 'mac_address', 'SUBMATCHSTRUCT_discovered_data'], 
        netbios                            => [\&ibap_o2i_substruct_search, 'netbios_name', 'SUBMATCHSTRUCT_discovered_data'], 
        os                                 => [\&ibap_o2i_substruct_search, 'os', 'SUBMATCHSTRUCT_discovered_data'], 
        network_component_description      => [\&ibap_o2i_substruct_search, 'network_component_description', 'SUBMATCHSTRUCT_discovered_data'], 
        network_component_ip               => [\&ibap_o2i_substruct_search, 'network_component_ip', 'SUBMATCHSTRUCT_discovered_data'], 
        network_component_name             => [\&ibap_o2i_substruct_search, 'network_component_name', 'SUBMATCHSTRUCT_discovered_data'], 
        network_component_port_description => [\&ibap_o2i_substruct_search, 'network_component_port_description', 'SUBMATCHSTRUCT_discovered_data'], 
        network_component_port_name        => [\&ibap_o2i_substruct_search, 'network_component_port_name', 'SUBMATCHSTRUCT_discovered_data'], 
        network_component_port_number      => [\&ibap_o2i_substruct_exact_int_search, 'network_component_port_number', 'SUBMATCHSTRUCT_discovered_data'], 
        network_component_type             => [\&ibap_o2i_substruct_search, 'network_component_type', 'SUBMATCHSTRUCT_discovered_data'], 
        port_duplex                        => [\&ibap_o2i_substruct_exact_search, 'port_duplex', 'SUBMATCHSTRUCT_discovered_data'], 
        port_link_status                   => [\&ibap_o2i_substruct_exact_search, 'port_link_status', 'SUBMATCHSTRUCT_discovered_data'], 
        port_speed                         => [\&ibap_o2i_substruct_exact_search, 'port_speed', 'SUBMATCHSTRUCT_discovered_data'], 
        port_status                        => [\&ibap_o2i_substruct_exact_search, 'port_status', 'SUBMATCHSTRUCT_discovered_data'], 
        port_vlan_description              => [\&ibap_o2i_substruct_search, 'port_vlan_description', 'SUBMATCHSTRUCT_discovered_data'], 
        port_vlan_name                     => [\&ibap_o2i_substruct_search, 'port_vlan_name', 'SUBMATCHSTRUCT_discovered_data'], 
        port_vlan_number                   => [\&ibap_o2i_substruct_exact_int_search, 'port_vlan_number', 'SUBMATCHSTRUCT_discovered_data'], 
        v_cluster                          => [\&ibap_o2i_substruct_search, 'v_cluster', 'SUBMATCHSTRUCT_discovered_data'], 
        v_datacenter                       => [\&ibap_o2i_substruct_search, 'v_datacenter', 'SUBMATCHSTRUCT_discovered_data'], 
        v_host                             => [\&ibap_o2i_substruct_search, 'v_host', 'SUBMATCHSTRUCT_discovered_data'], 
        v_name                             => [\&ibap_o2i_substruct_search, 'v_entity_name', 'SUBMATCHSTRUCT_discovered_data'], 
        v_netadapter                       => [\&ibap_o2i_substruct_search, 'v_adapter', 'SUBMATCHSTRUCT_discovered_data'], 
        v_switch                           => [\&ibap_o2i_substruct_search, 'v_switch', 'SUBMATCHSTRUCT_discovered_data'], 
        v_type                             => [\&ibap_o2i_substruct_exact_v_type_search, 'v_entity_type', 'SUBMATCHSTRUCT_discovered_data'], 
      );
        

    my %_discovery_name_mappings = (
        netbios                => 'netbios_name',
        v_name                 => 'v_entity_name',
        v_netadapter           => 'v_adapter',
        v_type                 => 'v_entity_type',
        discovered_duid        => '_discovered_duid',
        discovered_mac_address => '_discovered_mac_address',
    );


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

    my $_allowed_members = \%{"$caller\::_allowed_members"};
    my $_ibap_to_object  = \%{"$caller\::_ibap_to_object"};
    my $_object_to_ibap  = \%{"$caller\::_object_to_ibap"};
    my $_searchable_fields = \%{"$caller\::_searchable_fields"};
    my $_return_field_overrides = \%{"$caller\::_return_field_overrides"};
    my $_name_mappings  = \%{"$caller\::_name_mappings"};
    my $_reverse_name_mappings=\%{"$caller\::_reverse_name_mappings"};

    foreach my $current (@members) {
        my $method = $caller . '::' . $current;
        my $ibap_name=$current;
        if($_discovery_name_mappings{$current}){
            $ibap_name = $_discovery_name_mappings{$current};
            $$_name_mappings{$current}=$ibap_name;
            $$_reverse_name_mappings{$ibap_name}=$current;
        }
        $$_return_field_overrides{$current} = ['!discovered_data'];
        $$_allowed_members{$current} = defined($_discovered_fields_{$current})?$_discovered_fields_{$current}:{simple => 'asis', readonly =>1, validator => \&ibap_value_o2i_string}; 
        $$_object_to_ibap{$current} = \&ibap_o2i_ignore; 
        if($_discovered_search_fields{$current}){
            $$_searchable_fields{$current}=$_discovered_search_fields{$current}
        }else{
            $$_searchable_fields{$current}= [\&ibap_o2i_substruct_search, $ibap_name, 'SUBMATCHSTRUCT_discovered_data'];
        }

        if ($current eq 'v_type' and !defined $_allowed_members->{'discovered_data'}) {
            $$_ibap_to_object{'v_entity_type'} = \&ibap_i2o_v_type;
        }

        if (defined $_discovered_fields_{$current}) {
            *$method = sub {
                my $self  = shift;
                return $self->__accessor_scalar__($_discovered_fields_{$current}, @_);
            };
        }else{
            *$method = sub {
                my $self  = shift;
                return $self->__accessor_scalar__({name => $current, readonly => 1 , validator => \&ibap_value_o2i_string }, @_);
            };
        }
    }
}

1;    # so the require or use succeeds
