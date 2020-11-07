package Infoblox::DNS::BulkHost;

use strict;

use Carp;

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
			 $_return_fields_initialized
			 %_return_field_overrides
			 %_capabilities);
@ISA = qw (Infoblox::IBAPBase);

BEGIN {
    $_object_type = 'BulkHost';
    register_wsdl_type('ib:BulkHost', 'Infoblox::DNS::BulkHost');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 1,
					 );

    %_allowed_members = (
						 comment    	   => 0,
						 disable    	   => 0,
						 end_addr   	   => 1,
						 name_template 	   => 0,
						 prefix     	   => 1,
						 reverse    	   => 0,
						 start_addr 	   => 1,
						 ttl        	   => 0,
						 use_name_template => 0,
						 views      	   => 0,
						 zone       	   => 1,
                         extattrs           => 0,
                         extensible_attributes => 0,
                         dns_prefix        => -1,
                         cloud_info => {readonly => 1, validator => {'Infoblox::Grid::CloudAPI::Info' => 1}},
                         last_queried => {readonly => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       'extattrs'                     => 'extensible_attributes',
					   'zone' 		=> 'parentfqdn',
					   'start_addr' => 'start_address',
					   'end_addr' 	=> 'end_address',
					   'views' 		=> 'view',
					   'disable' 	=> 'disabled'
                      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_ibap_to_object = (
						view 	 		  => \&ibap_i2o_generic_object_convert_to_list_of_one,
						disabled 		  => \&ibap_i2o_boolean,
						reverse 		  => \&ibap_i2o_boolean,
						use_name_template => \&ibap_i2o_boolean,
						name_template     => \&__i2o_nametemplate__,
                        extensible_attributes =>  \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        cloud_info            => \&ibap_i2o_generic_object_convert,
                        last_queried          => \&ibap_i2o_datetime_to_unix_timestamp,
                       );

	%_return_field_overrides = (
								comment    	   	  => [],
								disable    	   	  => [],
								end_addr   	   	  => [],
								prefix     	   	  => [],
                                dns_prefix        => [],
								reverse    	   	  => [],
								start_addr 	   	  => [],
								use_name_template => [],
							    name_template     => ['use_name_template'],
								ttl        	   	  => ['use_ttl'],
								views      	   	  => [],
								zone       	   	  => [],
                                extattrs          => [],
                                extensible_attributes => [],
                                cloud_info            => [],
                                last_queried          => [],
							   );

    %_object_to_ibap = (
						comment    	   	  => \&ibap_o2i_string,
						disable    	   	  => \&ibap_o2i_boolean,
						end_addr   	   	  => \&ibap_o2i_string,
						prefix     	   	  => \&ibap_o2i_string,
                        dns_prefix        => \&ibap_o2i_ignore,
						reverse    	   	  => \&ibap_o2i_boolean,
						start_addr 	   	  => \&ibap_o2i_string,
						use_name_template => \&ibap_o2i_boolean,
						name_template 	  => \&__o2i_nametemplate__,
						use_ttl 	  	  => \&ibap_o2i_ignore,
						ttl 		  	  => \&ibap_o2i_ttl,
						views 		  	  => \&ibap_o2i_view,
						zone       	   	  => \&ibap_o2i_string,
                        extattrs              => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes => \&ibap_o2i_ignore,
                        cloud_info            => \&ibap_o2i_ignore,
                        last_queried          => \&ibap_o2i_ignore,
                       );

    %_searchable_fields = (
						   comment 			 => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],
						   disable    		 => [\&ibap_o2i_boolean ,'disabled', 'EXACT'],
						   end_addr  		 => [\&ibap_o2i_string ,'end_addr', 'EXACT'],
						   name_template	 => [\&__o2i_nametemplate__, 'name_template', 'EXACT'],
						   prefix  			 => [\&ibap_o2i_string ,'prefix', 'REGEX'],
						   reverse    		 => [\&ibap_o2i_boolean ,'reverse', 'EXACT'],
						   start_addr  		 => [\&ibap_o2i_string ,'start_addr', 'EXACT'],
						   ttl  			 => [\&ibap_o2i_string ,'ttl', 'EXACT'],
						   use_name_template => [\&ibap_o2i_boolean ,'use_name_template', 'EXACT'],
						   view    			 => [\&__o2i_viewlocal__   ,'view'   , 'REGEX'],
						   views   			 => [\&__o2i_viewlocal__   ,'view'   , 'REGEX'],
						   zone    			 => [\&ibap_o2i_string ,'parentfqdn', 'REGEX'],
                           extattrs          => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__,'extensible_attributes', 'SUBSET'],
                          );

	$_return_fields_initialized=0;
    @_return_fields = (
					   tField('comment'),
					   tField('disabled'),
					   tField('end_address'),
					   tField('prefix'),
                       tField('dns_prefix'),
					   tField('parentfqdn'),
					   tField('reverse'),
					   tField('start_address'),
					   tField('ttl'),
					   tField('use_ttl'),
					   tField('use_name_template'),
                       tField('last_queried'),
                       tField('name_template',
                              {
                               sub_fields   => [tField('template_name')]
                              }
                             ),
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

sub __init_instance_constants__
{
    my $self = shift;

	unless ($_return_fields_initialized) {
		$_return_fields_initialized=1;

        my $t = Infoblox::DNS::View->__new__();

        push @_return_fields,
          tField('view', {
                          default_no_access_ok => 1,
                          sub_fields => $t->__return_fields__(),
                         }
                );

        $t = Infoblox::Grid::CloudAPI::Info->__new__();

        push @_return_fields,
          tField('cloud_info', {
                                sub_fields => $t->__return_fields__(),
                               }
                );
	}
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

#
#
#

sub __i2o_nametemplate__
{
    my ($self, $session, $current, $ibap_object_ref) = @_;
    my @newlist;

    return $$ibap_object_ref{$current}{'template_name'};
}

sub __ibap_to_object__
{
	my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

	#
	$self->disable('false');
	$self->reverse('false');
	$self->use_name_template('false');

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

sub __o2i_nametemplate__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    if (defined $$tempref{$current}) {
		push @return_args, 1;
		push @return_args, 0;
		push @return_args, ibap_readfield_simple_string('BulkHostNameTemplate','template_name', $$tempref{$current},'1143=name_template='.$$tempref{$current});;
    }
    else {
        push @return_args, 1;
        push @return_args, 0;
        push @return_args, undef;
    }

    return @return_args;
}

sub __o2i_viewlocal__
{
    my ($self, $session, $current, $tempref) = @_;

    if (defined $$tempref{$current}) {
        if (ref($$tempref{$current}) eq 'ARRAY' && ref(@{$$tempref{$current}}[0]) eq 'Infoblox::DNS::View') {
            return (1,0, tString(@{$$tempref{$current}}[0]->name()));
        }
        else {
            return (1,0, tString($$tempref{$current}));
        }
    }

    return (0);
}

#
#
#

sub disable
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'disable', validator => \&ibap_value_o2i_boolean}, @_);
}

sub extattrs
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extattrs', 0, @_);
}

sub extensible_attributes
{
    return Infoblox::Util::extensible_attributes_accessor_helper('extensible_attributes', 0, @_);
}

sub comment
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'comment', validator => \&ibap_value_o2i_string}, @_);
}

sub use_name_template
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'use_name_template', validator => \&ibap_value_o2i_boolean}, @_);
}

sub name_template
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'name_template', validator => \&ibap_value_o2i_string}, @_);
}

sub ttl
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'ttl', validator => \&ibap_value_o2i_uint, use => \$self->{'use_ttl'}}, @_);
}

sub reverse
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'reverse', validator => \&ibap_value_o2i_boolean}, @_);
}

sub end_addr
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'end_addr', validator => \&ibap_value_o2i_string}, @_);
}

sub start_addr
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'start_addr', validator => \&ibap_value_o2i_string}, @_);
}

sub prefix
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'prefix', validator => \&ibap_value_o2i_string}, @_);
}

sub views
{
    my $self  = shift;

    return $self->__accessor_array__({name => 'views', validator => { 'Infoblox::DNS::View' => 1 }}, @_);
}

sub zone
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'zone', validator => \&ibap_value_o2i_string}, @_);
}

sub dns_prefix
{
    my $self  = shift;
    return $self->__accessor_scalar__({name => 'dns_prefix', readonly => 1}, @_);
}

return 1;
