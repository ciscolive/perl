## Copyright (c) 2017 Infoblox Inc. All Rights Reserved.

package Infoblox::DNS::SRG;

use strict;

use Carp;
use Data::Dumper;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw( @ISA
			 $_object_type
			 %_allowed_members
			 @_return_fields
			 %_searchable_fields
			 %_object_to_ibap
			 %_name_mappings
			 %_reverse_name_mappings
			 %_ibap_to_object
			 %_return_field_overrides
             $_return_fields_initialized
			 %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'SharedRecordGroup';
    register_wsdl_type('ib:SharedRecordGroup', 'Infoblox::DNS::SRG');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 0,
					  'single_serialization' => 1,
					 );

    %_allowed_members = (
						 name             		   	 => 1,
						 comment 	        		 => 0,
						 zone_association 	       	 => 0,
						 record_name_policy 	     => 0,
						 override_record_name_policy => 0,
                         extattrs                    => 0,
                         extensible_attributes       => 0,
                        );

    %_name_mappings = (
                       'extattrs'                     => 'extensible_attributes',
					   'zone_association' 	       	 => 'zones',
					   'override_record_name_policy' => 'use_record_name_policy',
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
						use_record_name_policy => \&ibap_i2o_boolean,
						zones 				   => \&__i2o_zones__,
						record_name_policy 	   => \&__i2o_policy__,
                        extensible_attributes  => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                       );

	%_return_field_overrides = (
								name             		   	=> [],
								comment 	        		=> [],
								zone_association 	       	=> [],
                                extattrs                    => [],
                                extensible_attributes       => [],
								record_name_policy 	     	=> [],
								override_record_name_policy => [],
							   );

    %_object_to_ibap = (
						name 	  					=> \&ibap_o2i_string,
						comment 	  				=> \&ibap_o2i_string,
						zone_association 	       	=> \&__o2i_zones__,
						record_name_policy 	     	=> \&__o2i_policy__,
						override_record_name_policy => \&ibap_o2i_boolean,
                        extattrs                    => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes       => \&ibap_o2i_ignore,
                       );

    %_searchable_fields = (
						   name    => [\&ibap_o2i_string ,'name'   , 'REGEX'],
						   comment => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
	                       extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                          );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('comment'),
                       tField('name'),
                       tField('record_name_policy', { sub_fields => [ tField('policy_name')] }),
                       tField('use_record_name_policy'),
                       return_fields_extensible_attributes(),
                      );
};


sub new
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self , $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

	$self->__init_instance_constants__();

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

	$self->__init_instance_constants__();

    return $self;
}

sub __ibap_object_type__
{
    #
    return $_object_type;
}

sub __ibap_capabilities__
{
	my ($self,$what)=@_;
	return $_capabilities{$what};
}

sub __init_instance_constants__
{
    my $self = shift;

	unless ($_return_fields_initialized) {
		$_return_fields_initialized=1;

        #
        my $t = Infoblox::DNS::Zone->__new__();

        push @_return_fields,
          tField('zones',
                 {
                  default_no_access_ok => 1,
                  sub_fields => [
                                  tField('srg_name'),
                                  tField('zone',
                                         {
                                          sub_fields => $t->__return_fields__(),
                                         }
                                        )
                                 ]
                 }
                );
	}
}

#
#
#

sub __i2o_zones__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    my @newlist;

    if ($$ibap_object_ref{$current} && @{$$ibap_object_ref{$current}}) {
        my (@newlist, @ids);
        my $result;
        my $server = $session->get_ibap_server() || return;

        foreach my $zone (@{$$ibap_object_ref{$current}}) {
            push @newlist, ibap_i2o_generic_object_convert($self, $session, 'zone', $zone, $return_object_cache_ref);
        }
        return \@newlist;
    } else {
        return [];
    }
}

sub __i2o_policy__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

	return $$ibap_object_ref{$current}{'policy_name'};
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

	return;
}

#
#
#

sub __o2i_zones__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
        if (ref ($$tempref{$current}) eq 'ARRAY') {
			my @zoneslist=@{$$tempref{$current}};
			my @newlist;

			foreach my $zone (@zoneslist) {
				my $t;

				#
				#
				return unless $t = $zone->__object_id_from_object__($session);

				my @sub_write_fields;
				my %sub_write_arg;
				$sub_write_arg{'field'} = 'zone';
				$sub_write_arg{'value'} = tObjId($t);
				unshift @sub_write_fields, \%sub_write_arg;

                my %sub_write_arg_srg;
 				my %temp_id_srg = ( id => '..');
 				$sub_write_arg_srg{'field'} = 'srg';
 				$sub_write_arg_srg{'value'} = tObjId('..');
 				unshift @sub_write_fields, \%sub_write_arg_srg;

				my %sub_write_arg2;
				$sub_write_arg2{'write_fields'} = \@sub_write_fields;
				$sub_write_arg2{'object_type'} = 'SRGZone';

				push @newlist, \%sub_write_arg2;
			}

            push @return_args, 1;
            push @return_args, 0;
            push @return_args, tIBType('ArrayOfsub_object', \@newlist);
        } else {
            push @return_args, 0;
        }
    }
    else {
        push @return_args, 1;
        push @return_args, 0;
        push @return_args, tIBType('ArrayOfsub_object',[]);
    }

    return @return_args;
}

sub __o2i_policy__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, ibap_readfield_simple_string('RecordNamePolicy', 'policy_name' , $$tempref{$current}, $current);
    }
    else {
        push @return_args, 1;
        push @return_args, 0;
        push @return_args, undef;
    }

    return @return_args;
}

#
#
#

sub override_record_name_policy
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'override_record_name_policy', validator => \&ibap_value_o2i_boolean}, @_);
}

sub record_name_policy
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'record_name_policy', validator => \&ibap_value_o2i_string}, @_);
}

sub comment
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub zone_association
{
    my $self=shift;

    return $self->__accessor_array__({name => 'zone_association', validator => { 'Infoblox::DNS::Zone' => 1 }}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

1;
