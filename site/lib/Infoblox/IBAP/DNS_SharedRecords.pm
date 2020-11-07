package Infoblox::DNS::SharedRecord::A;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object $_return_fields_initialized %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
	$_object_type = 'SharedARecord';
    register_wsdl_type('ib:SharedARecord', 'Infoblox::DNS::SharedRecord::A');

    %_capabilities = (
					  'depth' 				 => 2,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 0,
					 );

	%_allowed_members = (
						 comment  		 	 => 0 ,
						 disable  		 	 => 0 ,
						 ipv4addr 		 	 => 1 ,
						 name 	  		 	 => 1 ,
						 shared_record_group => 1 ,
						 ttl 	  		 	 => 0 ,
                         extensible_attributes => 0,
                         extattrs            => 0,
                         dns_name            => -1,
						);

	%_name_mappings = (
					   disable  		   => 'disabled' ,
					   ipv4addr 		   => 'address' ,
					   shared_record_group => 'parent',
                       extattrs            => 'extensible_attributes',
					  );

	%_ibap_to_object = (
						disabled => \&ibap_i2o_boolean,
						parent 	 => \&__i2o_srg__,
                        extensible_attributes =>  \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
					   );

	%_searchable_fields = (
						   name    => [\&ibap_o2i_string ,'name'   , 'REGEX'],
						   comment => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
	                       extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
						  );

	%_reverse_name_mappings = reverse %_name_mappings;

	%_return_field_overrides = (
								comment 			=> [],
								disable 			=> [],
								ipv4addr 			=> [],
								name 				=> [],
                                dns_name            => [],
								ttl 				=> ['use_ttl'],
								shared_record_group => [],
                                extattrs            => [],
                                extensible_attributes => [],
							   );
	%_object_to_ibap = (
						comment 	  		=> \&ibap_o2i_string,
						disable 	  		=> \&ibap_o2i_boolean,
						ipv4addr	  		=> \&ibap_o2i_string,
						name 		  		=> \&ibap_o2i_string,
                        dns_name            => \&ibap_o2i_ignore,
						ttl 		  		=> \&ibap_o2i_ttl,
						use_ttl 	  		=> \&ibap_o2i_ignore,
						shared_record_group => \&__o2i_srg__,
                        extattrs              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes => \&ibap_o2i_ignore,
					   );

	@_return_fields = (
                       tField('address'),
                       tField('comment'),
                       tField('disabled'),
                       tField('name'),
                       tField('dns_name'),
                       tField('parent'),
                       tField('ttl'),
                       tField('use_ttl'),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
	return $_object_type;
}

sub __ibap_capabilities__
{
	my ($self,$what)=@_;
	return $_capabilities{$what};
}

#
#
#
sub __i2o_srg__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

	return $$ibap_object_ref{$current}{'name'};
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

	#
	$self->disable('false');

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

	#
	#
	#

	if ($$ibap_object_ref{'use_ttl'}) {
		$self->{'use_ttl'}=1;
	}
	else {
		$self->{'use_ttl'}=0;
		$self->ttl(undef);
	}

	return;
}

#
#
#
sub __o2i_srg__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, ibap_readfield_simple_string('SharedRecordGroup', 'name', $$tempref{$current},$current);
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

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub shared_record_group
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'shared_record_group', validator => \&ibap_value_o2i_string}, @_);
}

sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub comment
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub ipv4addr
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv4addr', validator => \&ibap_value_o2i_string}, @_);
}

sub ttl
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ttl', validator => \&ibap_value_o2i_uint, use => \$self->{'use_ttl'}}, @_);
}

sub name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub dns_name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_name', readonly => 1}, @_);
}

package Infoblox::DNS::SharedRecord::AAAA;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
	$_object_type = 'SharedAaaaRecord';
    register_wsdl_type('ib:SharedAaaaRecord', 'Infoblox::DNS::SharedRecord::AAAA');

    %_capabilities = (
					  'depth' 				 => 2,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 0,
					 );

	%_allowed_members = (
						 shared_record_group => 1 ,
						 disable  => 0,
						 comment  => 0,
						 ipv6addr => 1,
						 ttl 	  => 0,
						 name 	  => 1,
                         extensible_attributes => 0,
                         extattrs              => 0,
                         dns_name => -1,
						);

	%_name_mappings = (
					   disable  		   => 'disabled' ,
					   ipv6addr 		   => 'address' ,
					   shared_record_group => 'parent',
                       extattrs            => 'extensible_attributes',
					  );

	%_ibap_to_object = (
						parent => \&__i2o_srg__,
						disabled => \&ibap_i2o_boolean,
                        extensible_attributes =>  \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
					   );

	%_searchable_fields = (
						   name    => [\&ibap_o2i_string ,'name'   , 'REGEX'],
						   comment => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
	                       extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
						  );

	%_reverse_name_mappings = reverse %_name_mappings;

	%_return_field_overrides = (
								shared_record_group => [],
								comment  => [],
								disable  => [],
								ipv6addr => [],
								name 	 => [],
                                dns_name => [],
								ttl 	 => ['use_ttl'],
                                extattrs => [],
                                extensible_attributes => [],
							   );

	%_object_to_ibap = (
						disable  => \&ibap_o2i_boolean,
						comment  => \&ibap_o2i_string,
						ipv6addr => \&ibap_o2i_string,
						use_ttl  => \&ibap_o2i_ignore,
						ttl 	 => \&ibap_o2i_ttl,
						name 	 => \&ibap_o2i_string,
                        dns_name => \&ibap_o2i_ignore,
						shared_record_group => \&__o2i_srg__,
                        extattrs                 => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes    => \&ibap_o2i_ignore,
					   );

	@_return_fields = (
                       tField('address'),
                       tField('comment'),
                       tField('disabled'),
                       tField('name'),
                       tField('dns_name'),
                       tField('parent'),
                       tField('ttl'),
                       tField('use_ttl'),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
	return $_object_type;
}

sub __ibap_capabilities__
{
	my ($self,$what)=@_;
	return $_capabilities{$what};
}

#
#
#
sub __i2o_srg__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

	return $$ibap_object_ref{$current}{'name'};
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

	#
	$self->disable('false');
        #

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

	#
	#
	#

	if ($$ibap_object_ref{'use_ttl'}) {
		$self->{'use_ttl'}=1;
	}
	else {
		$self->{'use_ttl'}=0;
		$self->ttl(undef);
	}

	return;
}

#
#
#
sub __o2i_srg__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, ibap_readfield_simple_string('SharedRecordGroup', 'name', $$tempref{$current},$current);
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

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub shared_record_group
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'shared_record_group', validator => \&ibap_value_o2i_string}, @_);
}

sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub comment
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub ipv6addr
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ipv6addr', validator => \&ibap_value_o2i_string}, @_);
}

sub ttl
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ttl', validator => \&ibap_value_o2i_uint, use => \$self->{'use_ttl'}}, @_);
}

sub name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub dns_name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_name', readonly => 1}, @_);
}

package Infoblox::DNS::SharedRecord::MX;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
	$_object_type = 'SharedMxRecord';
    register_wsdl_type('ib:SharedMxRecord', 'Infoblox::DNS::SharedRecord::MX');

    %_capabilities = (
					  'depth' 				 => 2,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 0,
					 );

	%_allowed_members = (
						 shared_record_group => 1 ,
						 disable   => 0,
						 comment   => 0,
						 exchanger => 1,
						 pref 	   => 1,
						 ttl 	   => 0,
						 name 	   => 1,
                         extensible_attributes => 0,
                         extattrs              => 0,
                         dns_name      => -1,
                         dns_exchanger => -1,
						);

	%_name_mappings = (
					   disable  		   => 'disabled' ,
					   exchanger 		   => 'mx' ,
                       extattrs            => 'extensible_attributes',
                       dns_exchanger       => 'dns_mx',
					   pref 	   		   => 'priority' ,
					   shared_record_group => 'parent',
					  );

	%_ibap_to_object = (
						parent => \&__i2o_srg__,
						disabled => \&ibap_i2o_boolean,
                        extensible_attributes =>  \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
					   );

	%_searchable_fields = (
						   name    => [\&ibap_o2i_string ,'name'   , 'REGEX'],
						   comment => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
	                       extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
						  );

	%_reverse_name_mappings = reverse %_name_mappings;

	%_return_field_overrides = (
								shared_record_group => [],
								comment   => [],
								disable   => [],
								exchanger => [],
                                dns_exchanger => [],
								name 	  => [],
                                dns_name  => [],
								pref      => [],
								ttl 	  => ['use_ttl'],
                                extattrs  => [],
                                extensible_attributes => [],
							   );
	%_object_to_ibap = (
						disable   => \&ibap_o2i_boolean,
						comment   => \&ibap_o2i_string,
						exchanger => \&ibap_o2i_string,
                        dns_exchanger => \&ibap_o2i_ignore,
						pref      => \&ibap_o2i_integer,
						use_ttl   => \&ibap_o2i_ignore,
						ttl 	  => \&ibap_o2i_ttl,
						name 	  => \&ibap_o2i_string,
                        dns_name  => \&ibap_o2i_ignore,
						shared_record_group => \&__o2i_srg__,
                        extattrs               => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes  => \&ibap_o2i_ignore,
					   );

	@_return_fields = (
                       tField('mx'),
                       tField('dns_mx'),
                       tField('comment'),
                       tField('disabled'),
                       tField('name'),
                       tField('dns_name'),
                       tField('parent'),
                       tField('priority'),
                       tField('ttl'),
                       tField('use_ttl'),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
	return $_object_type;
}

sub __ibap_capabilities__
{
	my ($self,$what)=@_;
	return $_capabilities{$what};
}

#
#
#
sub __i2o_srg__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

	return $$ibap_object_ref{$current}{'name'};
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

	#
	$self->disable('false');
        #

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

	#
	#
	#

	if ($$ibap_object_ref{'use_ttl'}) {
		$self->{'use_ttl'}=1;
	}
	else {
		$self->{'use_ttl'}=0;
		$self->ttl(undef);
	}

	return;
}

#
#
#
sub __o2i_srg__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, ibap_readfield_simple_string('SharedRecordGroup', 'name', $$tempref{$current},$current);
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

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub shared_record_group
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'shared_record_group', validator => \&ibap_value_o2i_string}, @_);
}

sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub comment
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub exchanger
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'exchanger', validator => \&ibap_value_o2i_string}, @_);
}

sub pref
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'pref', validator => \&ibap_value_o2i_int}, @_);
}

sub ttl
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ttl', validator => \&ibap_value_o2i_uint, use => \$self->{'use_ttl'}}, @_);
}

sub name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub dns_name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_name', readonly => 1}, @_);
}

sub dns_exchanger
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_exchanger', readonly => 1}, @_);
}

package Infoblox::DNS::SharedRecord::TXT;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
	$_object_type = 'SharedTxtRecord';
    register_wsdl_type('ib:SharedTxtRecord', 'Infoblox::DNS::SharedRecord::TXT');

    %_capabilities = (
					  'depth' 				 => 2,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 0,
					 );

	%_allowed_members = (
						 shared_record_group => 1 ,
						 disable => 0,
						 comment => 0,
						 text    => 1,
						 ttl 	 => 0,
						 name    => 1,
                         extensible_attributes => 0,
                         extattrs              => 0,
                         dns_name => -1,
						);

	%_name_mappings = (
					   shared_record_group => 'parent',
					   disable => 'disabled' ,
                       extattrs  => 'extensible_attributes',
					  );

	%_ibap_to_object = (
						parent => \&__i2o_srg__,
						disabled => \&ibap_i2o_boolean,
                        extensible_attributes =>  \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
					   );

	%_searchable_fields = (
						   name    => [\&ibap_o2i_string ,'name'   , 'REGEX'],
						   comment => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
	                       extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
						  );

	%_reverse_name_mappings = reverse %_name_mappings;

	%_return_field_overrides = (
								shared_record_group => [],
								comment => [],
								disable => [],
								name 	=> [],
                                dns_name => [],
								text	=> [],
								ttl 	=> ['use_ttl'],
                                extattrs => [],
                                extensible_attributes => [],
							   );

	%_object_to_ibap = (
						disable => \&ibap_o2i_boolean,
						comment => \&ibap_o2i_string,
						text	=> \&ibap_o2i_string,
						use_ttl => \&ibap_o2i_ignore,
						ttl 	=> \&ibap_o2i_ttl,
						name 	=> \&ibap_o2i_string,
                        dns_name => \&ibap_o2i_ignore,
						shared_record_group => \&__o2i_srg__,
                        extattrs            => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes => \&ibap_o2i_ignore,
					   );

	@_return_fields = (
                       tField('text'),
                       tField('comment'),
                       tField('disabled'),
                       tField('name'),
                       tField('dns_name'),
                       tField('parent'),
                       tField('ttl'),
                       tField('use_ttl'),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
	return $_object_type;
}

sub __ibap_capabilities__
{
	my ($self,$what)=@_;
	return $_capabilities{$what};
}

#
#
#
sub __i2o_srg__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

	return $$ibap_object_ref{$current}{'name'};
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

	#
	$self->disable('false');
        #

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

	#
	#
	#

	if ($$ibap_object_ref{'use_ttl'}) {
		$self->{'use_ttl'}=1;
	}
	else {
		$self->{'use_ttl'}=0;
		$self->ttl(undef);
	}

	return;
}

#
#
#
sub __o2i_srg__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, ibap_readfield_simple_string('SharedRecordGroup', 'name', $$tempref{$current},$current);
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

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub shared_record_group
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'shared_record_group', validator => \&ibap_value_o2i_string}, @_);
}

sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub comment
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub text
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'text', validator => \&ibap_value_o2i_string}, @_);
}

sub ttl
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ttl', validator => \&ibap_value_o2i_uint, use => \$self->{'use_ttl'}}, @_);
}

sub name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub dns_name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_name', readonly => 1}, @_);
}

package Infoblox::DNS::SharedRecord::SRV;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
	$_object_type = 'SharedSrvRecord';
    register_wsdl_type('ib:SharedSrvRecord', 'Infoblox::DNS::SharedRecord::SRV');

    %_capabilities = (
					  'depth' 				 => 2,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 0,
					 );

	%_allowed_members = (
						 shared_record_group => 1 ,
						 disable  => 0,
						 comment  => 0,
						 target   => 1,
						 port 	  => 1,
						 weight   => 1,
						 priority => 1,
						 ttl 	  => 0,
						 name 	  => 1,
                         extensible_attributes => 0,
                         extattrs              => 0,
                         dns_name   => -1,
                         dns_target => -1,
						);


	%_name_mappings = (
					   shared_record_group => 'parent',
					   disable  => 'disabled' ,
                       extattrs => 'extensible_attributes',
					  );

	%_ibap_to_object = (
						parent => \&__i2o_srg__,
						disabled => \&ibap_i2o_boolean,
                        extensible_attributes =>  \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
					   );

	%_searchable_fields = (
						   name    => [\&ibap_o2i_string ,'name'   , 'REGEX'],
						   comment => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
	                       extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
						  );

	%_reverse_name_mappings = reverse %_name_mappings;

	%_return_field_overrides = (
								shared_record_group => [],
								comment  => [],
								disable  => [],
								name 	 => [],
                                dns_name => [],
								port 	 => [],
								priority => [],
								target 	 => [],
                                dns_target => [],
								ttl 	 => ['use_ttl'],
								weight 	 => [],
                                extattrs => [],
                                extensible_attributes => [],
							   );
	%_object_to_ibap = (
						disable  => \&ibap_o2i_boolean,
						comment  => \&ibap_o2i_string,
						target 	 => \&ibap_o2i_string,
                        dns_target => \&ibap_o2i_ignore,
						port 	 => \&ibap_o2i_integer,
						weight 	 => \&ibap_o2i_integer,
						priority => \&ibap_o2i_integer,
						use_ttl  => \&ibap_o2i_ignore,
						ttl 	 => \&ibap_o2i_ttl,
						name 	 => \&ibap_o2i_string,
                        dns_name => \&ibap_o2i_ignore,
						shared_record_group => \&__o2i_srg__,
                        extattrs                 => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes    => \&ibap_o2i_ignore,
					   );

	@_return_fields = (
                       tField('port'),
                       tField('weight'),
                       tField('priority'),
                       tField('target'),
                       tField('dns_target'),
                       tField('comment'),
                       tField('disabled'),
                       tField('name'),
                       tField('dns_name'),
                       tField('parent'),
                       tField('ttl'),
                       tField('use_ttl'),
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

    return $self;
}

sub __new__
{
    my ( $proto , %args ) = @_;
    my $class = ref ( $proto ) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);
    bless $self , $class;

    return $self;
}

sub __ibap_object_type__
{
	return $_object_type;
}

sub __ibap_capabilities__
{
	my ($self,$what)=@_;
	return $_capabilities{$what};
}

#
#
#
sub __i2o_srg__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

	return $$ibap_object_ref{$current}{'name'};
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

	#
	$self->disable('false');
        #

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

	#
	#
	#

	if ($$ibap_object_ref{'use_ttl'}) {
		$self->{'use_ttl'}=1;
	}
	else {
		$self->{'use_ttl'}=0;
		$self->ttl(undef);
	}

	return;
}

#
#
#
sub __o2i_srg__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, ibap_readfield_simple_string('SharedRecordGroup', 'name', $$tempref{$current},$current);
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

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub shared_record_group
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'shared_record_group', validator => \&ibap_value_o2i_string}, @_);
}

sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub comment
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub target
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'target', validator => \&ibap_value_o2i_string}, @_);
}

sub port
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'port', validator => \&ibap_value_o2i_int}, @_);
}

sub weight
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'weight', validator => \&ibap_value_o2i_int}, @_);
}

sub priority
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'priority', validator => \&ibap_value_o2i_int}, @_);
}

sub ttl
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ttl', validator => \&ibap_value_o2i_uint, use => \$self->{'use_ttl'}}, @_);
}

sub name
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name', validator => \&ibap_value_o2i_string}, @_);
}

sub dns_name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_name', readonly => 1}, @_);
}

sub dns_target
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'dns_target', readonly => 1}, @_);
}


package Infoblox::DNS::SharedRecord::CNAME;

use strict;
use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;

use vars qw(
            $_object_type
            %_allowed_members
            %_capabilities
            %_ibap_to_object
            %_name_mappings
            %_object_to_ibap
            %_reverse_name_mappings
            %_searchable_fields
            @ISA
            %_return_field_overrides
            @_return_fields
);

@ISA = qw( Infoblox::IBAPBase );

BEGIN {

    $_object_type = 'SharedCnameRecord';
    register_wsdl_type('ib:SharedCnameRecord', 'Infoblox::DNS::SharedRecord::CNAME');

    %_capabilities = (
                      'depth'                => 2,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 0,
    );

    %_allowed_members = (
                         'canonical'             => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'comment'               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         'disable'               => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         'dns_canonical'         => {simple => 'asis', readonly => 1},
                         'dns_name'              => {simple => 'asis', readonly => 1},
                         'extattrs'              => {special => 'extensible_attributes'},
                         'extensible_attributes' => {special => 'extensible_attributes'},
                         'name'                  => {mandatory => 1, simple => 'asis', validator => \&ibap_value_o2i_string},
                         'shared_record_group'   => {mandatory => 1, validator => \&ibap_value_o2i_string},
                         'ttl'                   => {simple => 'asis', use => 'use_ttl', validator => \&ibap_value_o2i_uint},
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'canonical'           => 'canonical_name',
                       'disable'             => 'disabled',
                       'dns_canonical'       => 'dns_canonical_name',
                       'extattrs'            => 'extensible_attributes',
                       'shared_record_group' => 'parent',
    );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
                        'extensible_attributes' => \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        'parent'                => \&ibap_i2o_object_name,
    );

    %_object_to_ibap = (
                        'canonical'             => \&ibap_o2i_string,
                        'comment'               => \&ibap_o2i_string,
                        'disable'               => \&ibap_o2i_boolean,
                        'dns_canonical'         => \&ibap_o2i_ignore,
                        'dns_name'              => \&ibap_o2i_ignore,
                        'extattrs'              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        'extensible_attributes' => \&ibap_o2i_ignore,
                        'name'                  => \&ibap_o2i_string,
                        'shared_record_group'   => \&__o2i_srg__,
                        'ttl'                   => \&ibap_o2i_ttl,
                        'use_ttl'               => \&ibap_o2i_ignore,
    );

    %_searchable_fields = (
                           'canonical'             => [\&ibap_o2i_string, 'canonical_name', 'REGEX'],
                           'comment'               => [\&ibap_o2i_string, 'comment', 'REGEX', 'IGNORE_CASE'],
                           'name'                  => [\&ibap_o2i_string, 'name', 'REGEX'],
                           'extensible_attributes' => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           'extattrs'              => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
    );

    @_return_fields = (
                       tField('canonical_name'),
                       tField('comment'),
                       tField('disabled'),
                       tField('dns_canonical_name'),
                       tField('dns_name'),
                       tField('name'),
                       tField('parent', {sub_fields => [tField('name')]}),
                       tField('ttl'),
                       tField('use_ttl'),
                       return_fields_extensible_attributes(),
    );

    %_return_field_overrides = (
                                'canonical'             => [],
                                'comment'               => [],
                                'disable'               => [],
                                'dns_canonical'         => [],
                                'dns_name'              => [],
                                'name'                  => [],
                                'shared_record_group'   => [],
                                'ttl'                   => ['use_ttl'],
                                'extensible_attributes' => [],
                                'extattrs'              => [],
    );
}

sub __new__ {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->__new__(%args);

    bless $self, $class;
    return $self;
}

sub new {

    my ($proto, %args) = @_;
    my $class = ref($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);

    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    return $self;
}

sub __ibap_object_type__ {

    return $_object_type;
}

sub __ibap_capabilities__ {

    my ($self, $what) = @_;
    return $_capabilities{$what};
}

sub __o2i_srg__ {

    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        return (1, 0, ibap_readfield_simple_string('SharedRecordGroup', 'name', $$tempref{$current},$current));
    } else {
        return (1, 0, undef);
    }
}

sub __ibap_to_object__ {

    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};
    $$ibap_object_ref{'use_ttl'} = 0 unless defined $$ibap_object_ref{'use_ttl'};

    $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);

    delete $self->{'ttl'} unless $$ibap_object_ref{'use_ttl'};
    $self->{'use_ttl'} = $$ibap_object_ref{'use_ttl'};

    return;
}


1;
