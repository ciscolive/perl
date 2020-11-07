package Infoblox::DNS::RPZRecord::BaseRule;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides
            %_capabilities);
@ISA = qw ( Infoblox::IBAPBase );

BEGIN {
    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                     );

    %_allowed_members = (
                         comment             => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         disable             => {simple => 'bool', validator => \&ibap_value_o2i_boolean},
                         name                => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         ttl                 => {validator => \&ibap_value_o2i_uint, use => 'use_ttl'},
                         extattrs              => {special => 'extensible_attributes'},
                         extensible_attributes => {special => 'extensible_attributes'},
                         views                 => {array => 1, validator => { 'Infoblox::DNS::View' => 1 }},
                         zone                  => {simple => 'asis', readonly => 1},
                         rp_zone               => {mandatory => 1, validator => { 'Infoblox::DNS::Zone' => 1 }},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       disable  => 'disabled' ,
                       extattrs => 'extensible_attributes',
                       name     => 'fqdn' ,
                       views    => 'view' ,
                       zone     => 'parent' ,
                       rp_zone  => 'parent_zone'
                      );

    %_ibap_to_object = (
                        disabled => \&ibap_i2o_boolean,
                        extensible_attributes =>  \&Infoblox::IBAPBase::__i2o_extensible_attributes__,
                        view     => \&ibap_i2o_generic_object_convert_to_list_of_one,
                        parent_zone => \&ibap_i2o_generic_object_convert,
                       );

    %_searchable_fields = (
                           comment  => [\&ibap_o2i_string ,'comment', 'REGEX', 'IGNORE_CASE'],
                           extattrs => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           extensible_attributes => [\&Infoblox::IBAPBase::__o2i_search_extensible_attributes__, 'extensible_attributes', 'SUBSET'],
                           view     => [\&ibap_o2i_view   ,'view'   , 'EXACT'],
                           views    => [\&ibap_o2i_view   ,'view'   , 'EXACT'],
                           name     => [\&ibap_o2i_string ,'fqdn'   , 'REGEX'],
                           zone     => [\&ibap_o2i_string ,'parent', 'EXACT'],
                          );

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_return_field_overrides = (
                                comment         => [],
                                extattrs        => [],
                                extensible_attributes => [],
                                disable         => [],
                                name            => [],
                                views           => [],
                                zone            => [],
                                ttl             => ['use_ttl'],
                               );
    %_object_to_ibap = (
                        disable       => \&ibap_o2i_boolean,
                        comment       => \&ibap_o2i_string,
                        extattrs      => \&Infoblox::IBAPBase::__o2i_extensible_attributes__,
                        extensible_attributes => \&ibap_o2i_ignore,
                        use_ttl       => \&ibap_o2i_ignore,
                        ttl           => \&ibap_o2i_ttl,
                        views         => \&ibap_o2i_view,
                        name          => \&ibap_o2i_string,
                        zone          => \&ibap_o2i_ignore,
                        rp_zone       => \&__o2i_rp_zone__,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('comment'),
                       tField('disabled'),
                       tField('fqdn'),
                       tField('parent'),
                       tField('ttl'),
                       tField('use_ttl'),
                       tField('parent_zone'),
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

    #
    #

    my ($ref_ibap_return_fields,$ref_ibap_return_fields_initialized);
    {
        no strict 'refs';
        my $objclass = $self->__get_class_methods_class__();
        $ref_ibap_return_fields  = \@{$objclass . '::_return_fields'};
        $ref_ibap_return_fields_initialized = \${$objclass . '::_return_fields_initialized'};
    }

    unless ($$ref_ibap_return_fields_initialized) {
        $$ref_ibap_return_fields_initialized=1;

        my $t = Infoblox::DNS::View->__new__();
        push @{$ref_ibap_return_fields},
          tField('view', {
                          default_no_access_ok => 1,
                          sub_fields => $t->__return_fields__(),
                         }
                );
    }
}

sub __search_mapping_hook_pre__
{
    my ($self, $session, $type, $argsref, $out_search_fields_ref, $out_search_types_ref, $out_search_matches_ref) = @_;

    #
    if( defined $argsref->{'zone'} && not defined $argsref->{'view'} && not defined $argsref->{'views'} ) {
        $out_search_fields_ref->{'view'} = ibap_readfield_simple('View','is_default',tBool(1),'view=(default view)');
        $out_search_types_ref->{'view'}='EXACT';
        $out_search_matches_ref->{'view'} = undef;
    }

    return 1;
}

sub __ibap_capabilities__
{
    my ($self,$what)=@_;
    return $_capabilities{$what};
}

#
#
#
sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};
    $$ibap_object_ref{'use_ttl'} = 0 unless defined $$ibap_object_ref{'use_ttl'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __o2i_rp_zone__
{
    my ($self, $session, $current, $tempref) = @_;
    my @return_args;

    push @return_args, 1;
    push @return_args, 0;
    if (not defined $$tempref{$current}) {
        push @return_args, $$tempref{$current};
    } else {
        push @return_args, ibap_arg_zone_convert($session,$current,$tempref);
    }
    return @return_args;
}


package Infoblox::DNS::RPZRecord::A;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides
            %_capabilities);
@ISA = qw ( Infoblox::DNS::RPZRecord::BaseRule );

BEGIN {
	$_object_type = 'ResponsePolicyARecord';
    register_wsdl_type('ib:ResponsePolicyARecord', 'Infoblox::DNS::RPZRecord::A');

    %_capabilities = (
					 );

	%_allowed_members = (
                         ipv4addr            => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_ipv4addr},
	                    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

	%_name_mappings = (
                       ipv4addr            => 'address' ,
					  );

	%_ibap_to_object = (
					   );

	%_searchable_fields = (
                           ipv4addr => [\&ibap_o2i_string ,'address', 'REGEX'],
						  );

	%_reverse_name_mappings = (reverse %_name_mappings);

	%_return_field_overrides = (
                                ipv4addr        => [],
							   );
	%_object_to_ibap = (
                        ipv4addr      => \&ibap_o2i_string,
					   );

    $_return_fields_initialized=0;
	@_return_fields = (
                       tField('address'),
                      );

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RPZRecord::BaseRule', $_object_type);
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

sub __init_instance_constants__
{
    my $self = shift;
    $self->SUPER::__init_instance_constants__();
}

sub __ibap_object_type__
{
	return $_object_type;
}

package Infoblox::DNS::RPZRecord::AIpAddress;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides
            %_capabilities);
@ISA = qw ( Infoblox::DNS::RPZRecord::A );

BEGIN {
    $_object_type = 'ResponsePolicyIPARecord';
    register_wsdl_type('ib:ResponsePolicyIPARecord', 'Infoblox::DNS::RPZRecord::AIpAddress');

    %_capabilities = (
                     );

    %_allowed_members = (
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                      );

    %_ibap_to_object = (
                       );

    %_searchable_fields = (
                          );

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_return_field_overrides = (
                               );
    %_object_to_ibap = (
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                      );

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RPZRecord::A', $_object_type);
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

sub __init_instance_constants__
{
    my $self = shift;
    $self->SUPER::__init_instance_constants__();
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::DNS::RPZRecord::AAAA;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides
            %_capabilities);
@ISA = qw ( Infoblox::DNS::RPZRecord::BaseRule );

BEGIN {
    $_object_type = 'ResponsePolicyAaaaRecord';
    register_wsdl_type('ib:ResponsePolicyAaaaRecord', 'Infoblox::DNS::RPZRecord::AAAA');

    %_capabilities = (
                     );

    %_allowed_members = (
                         ipv6addr              => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_ipv6addr},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       ipv6addr => 'address' ,
                      );

    %_ibap_to_object = (
                       );

    %_searchable_fields = (
                           ipv6addr => [\&ibap_o2i_string ,'address', 'REGEX'],
                          );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_return_field_overrides = (
                                ipv6addr => [],
                               );

    %_object_to_ibap = (
                        ipv6addr => \&ibap_o2i_string,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('address'),
                      );

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RPZRecord::BaseRule', $_object_type);
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

sub __init_instance_constants__
{
    my $self = shift;
    $self->SUPER::__init_instance_constants__();
}

sub __ibap_object_type__
{
    return $_object_type;
}

package Infoblox::DNS::RPZRecord::AAAAIpAddress;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides
            %_capabilities);
@ISA = qw ( Infoblox::DNS::RPZRecord::AAAA );

BEGIN {
    $_object_type = 'ResponsePolicyIPAaaaRecord';
    register_wsdl_type('ib:ResponsePolicyIPAaaaRecord', 'Infoblox::DNS::RPZRecord::AAAAIpAddress');

    %_capabilities = (
                     );

    %_allowed_members = (
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                      );

    %_ibap_to_object = (
                       );

    %_searchable_fields = (
                          );

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_return_field_overrides = (
                               );
    %_object_to_ibap = (
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                      );

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RPZRecord::AAAA', $_object_type);
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

sub __init_instance_constants__
{
    my $self = shift;
    $self->SUPER::__init_instance_constants__();
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::DNS::RPZRecord::MX;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides
            %_capabilities);
@ISA = qw ( Infoblox::DNS::RPZRecord::BaseRule );

BEGIN {
    $_object_type = 'ResponsePolicyMxRecord';
    register_wsdl_type('ib:ResponsePolicyMxRecord', 'Infoblox::DNS::RPZRecord::MX');

    %_capabilities = (
                     );

    %_allowed_members = (
                         exchanger             => {simple => 'asis', mandatory => 1,validator => \&ibap_value_o2i_string},
                         pref                  => {simple => 'asis', mandatory => 1,validator => \&ibap_value_o2i_int},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       exchanger => 'mx' ,
                       pref      => 'priority' ,
                      );

    %_ibap_to_object = (
                       );

    %_searchable_fields = (
                           exchanger => [\&ibap_o2i_string  ,'mx'     , 'REGEX'],
                           pref      => [\&ibap_o2i_integer ,'priority','REGEX'],
                          );

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_return_field_overrides = (
                                exchanger => [],
                                pref      => [],
                               );
    %_object_to_ibap = (
                        exchanger => \&ibap_o2i_string,
                        pref      => \&ibap_o2i_integer,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('mx'),
                       tField('priority'),
                      );

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RPZRecord::BaseRule', $_object_type);
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

sub __init_instance_constants__
{
    my $self = shift;
    $self->SUPER::__init_instance_constants__();
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::DNS::RPZRecord::NAPTR;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides
            %_capabilities);
@ISA = qw ( Infoblox::DNS::RPZRecord::BaseRule );

BEGIN {
    $_object_type = 'ResponsePolicyNaptrRecord';
    register_wsdl_type('ib:ResponsePolicyNaptrRecord', 'Infoblox::DNS::RPZRecord::NAPTR');

    %_capabilities = (
                     );

    %_allowed_members = (
                         flags                 => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         order                 => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_uint},
                         preference            => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_uint},
                         regexp                => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         replacement           => {simple => 'asis', validator => \&ibap_value_o2i_string},
                         services              => {simple => 'asis', validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                      );

    %_ibap_to_object = (
                       );

    %_searchable_fields = (
                              flags           => [\&ibap_o2i_string, "flags", 'REGEX', 'IGNORE_CASE'], 
                              order           => [\&ibap_o2i_uint, "order",'EXACT'], 
                              preference      => [\&ibap_o2i_uint, "preference",'EXACT'], 
                              replacement     => [\&ibap_o2i_string, "replacement", 'REGEX'], 
                          );

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_return_field_overrides = (
                                 flags           => [],
                                 order           => [],
                                 preference      => [],
                                 regexp          => [],
                                 replacement     => [],
                                 services        => [],
                               );
    %_object_to_ibap = (
                          flags           => \&ibap_o2i_string,
                          order           => \&ibap_o2i_uint,
                          preference      => \&ibap_o2i_uint,
                          regexp          => \&ibap_o2i_string,
                          replacement     => \&ibap_o2i_string,
                          services        => \&ibap_o2i_string,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                        tField('flags'),
                        tField('order'),
                        tField('preference'),
                        tField('regexp'),
                        tField('replacement'),
                        tField('services'),
                      );

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RPZRecord::BaseRule', $_object_type);
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

sub __init_instance_constants__
{
    my $self = shift;
    $self->SUPER::__init_instance_constants__();
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::DNS::RPZRecord::PTR;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides
            %_capabilities);
@ISA = qw ( Infoblox::DNS::RPZRecord::BaseRule );

BEGIN {
    $_object_type = 'ResponsePolicyPtrRecord';
    register_wsdl_type('ib:ResponsePolicyPtrRecord', 'Infoblox::DNS::RPZRecord::PTR');

    %_capabilities = (
                     );

    %_allowed_members = (
                         ipv6addr                           => {simple => 'asis', validator => \&ibap_value_o2i_ipv6addr},
                         ipv4addr                           => {simple => 'asis', validator => \&ibap_value_o2i_ipv4addr},
                         ptrdname                           => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         name                               => {simple => 'asis', validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       ptrdname => 'dname',
                       name     => 'fqdn' ,
                      );

    %_ibap_to_object = (
                       );

    %_searchable_fields = (
                           name     => [\&ibap_o2i_string ,'fqdn'   , 'REGEX'],
                           ptrdname => [\&ibap_o2i_string ,'dname'  , 'REGEX'],

                           #
                           ipv4addr => [\&ibap_o2i_string ,'address', 'REGEX'],
                           ipv6addr => [\&ibap_o2i_string ,'address', 'REGEX'],
                          );

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_return_field_overrides = (
                                ipv4addr        => ['!address'],
                                ipv6addr        => ['!address'],
                                ptrdname        => [],
                                name            => [],
                               );
    %_object_to_ibap = (
                        ipv4addr => \&ibap_o2i_ignore,
                        ipv6addr => \&ibap_o2i_ignore,
                        ptrdname => \&ibap_o2i_string,
                        name     => \&ibap_o2i_string,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('address'),
                       tField('dname'),
                       tField('fqdn'),
                      );

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RPZRecord::BaseRule', $_object_type,
                                {'name' => 1});
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

    if((not defined $args{ 'ipv4addr' }) && (not defined $args{ 'ipv6addr' }) && (not defined $args{ 'name' }))
    {
        set_error_codes(1103,'name is required if both ipv4addr and ipv6addr are undefined.' );
        return;
    }
    elsif (defined $args{ 'ipv4addr' } && defined $args{ 'ipv6addr' }) {
        set_error_codes(1105,'Cannot define ipv4addr and ipv6addr at the same time.' );
        return;
    }

    $self->__init_instance_constants__();

    return $self;
}

sub __init_instance_constants__
{
    my $self = shift;
    $self->SUPER::__init_instance_constants__();
}

sub __ibap_object_type__
{
    return $_object_type;
}


#
#
#
sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    #
    #
    #
    $self->{'__initializing_from_ibap__'} = 1;
    if (defined $$ibap_object_ref{'address'}) {
        if (is_ipv6_address($$ibap_object_ref{'address'})) {
            $self->ipv6addr($$ibap_object_ref{'address'});
        }
        else {
            $self->ipv4addr($$ibap_object_ref{'address'});
        }
    }
    delete $self->{'__initializing_from_ibap__'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __object_to_ibap__
{
    my ($self, $server, $session, $skipref) = @_;

    my $ref_write_fields=$self->SUPER::__object_to_ibap__($server, $session, $skipref);

    my %write_arg;
    $write_arg{'field'} = 'address';

    if (defined $self->ipv4addr()) {
        return unless $write_arg{'value'} = ibap_value_o2i_string($self->ipv4addr(),'ipv4addr',$session);
        unshift @$ref_write_fields, \%write_arg;
    }
    elsif (defined $self->ipv6addr()) {
        return unless $write_arg{'value'} = ibap_value_o2i_string($self->ipv6addr(),'ipv6addr',$session);
        unshift @$ref_write_fields, \%write_arg;
    }

    return $ref_write_fields;
}


package Infoblox::DNS::RPZRecord::SRV;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides
            %_capabilities);
@ISA = qw ( Infoblox::DNS::RPZRecord::BaseRule );

BEGIN {
    $_object_type = 'ResponsePolicySrvRecord';
    register_wsdl_type('ib:ResponsePolicySrvRecord', 'Infoblox::DNS::RPZRecord::SRV');

    %_capabilities = (
                     );

    %_allowed_members = (
                         target                => {simple => 'asis', mandatory => 1,validator => \&ibap_value_o2i_string},
                         port                  => {simple => 'asis', mandatory => 1,validator => \&ibap_value_o2i_int},
                         weight                => {simple => 'asis', mandatory => 1,validator => \&ibap_value_o2i_int},
                         priority              => {simple => 'asis', mandatory => 1,validator => \&ibap_value_o2i_int},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                      );

    %_ibap_to_object = (
                       );

    %_searchable_fields = (
                           target   => [\&ibap_o2i_string  ,'target' , 'REGEX'],
                           priority => [\&ibap_o2i_integer ,'priority','REGEX'],
                           weight   => [\&ibap_o2i_integer ,'weight' , 'REGEX'],
                           port     => [\&ibap_o2i_integer ,'port'   , 'REGEX'],
                          );

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_return_field_overrides = (
                                port     => [],
                                priority => [],
                                target   => [],
                                weight   => [],
                               );
    %_object_to_ibap = (
                        target   => \&ibap_o2i_string,
                        port     => \&ibap_o2i_integer,
                        weight   => \&ibap_o2i_integer,
                        priority => \&ibap_o2i_integer,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('target'),
                       tField('priority'),
                       tField('port'),
                       tField('weight'),
                      );

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RPZRecord::BaseRule', $_object_type);
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

sub __init_instance_constants__
{
    my $self = shift;
    $self->SUPER::__init_instance_constants__();
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::DNS::RPZRecord::TXT;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides
            %_capabilities);
@ISA = qw ( Infoblox::DNS::RPZRecord::BaseRule );

BEGIN {
    $_object_type = 'ResponsePolicyTxtRecord';
    register_wsdl_type('ib:ResponsePolicyTxtRecord', 'Infoblox::DNS::RPZRecord::TXT');

    %_capabilities = (
                     );

    %_allowed_members = (
                         text                  => {simple => 'asis', validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                      );

    %_ibap_to_object = (
                       );

    %_searchable_fields = (
                           text    => [\&ibap_o2i_string ,'text'   , 'REGEX'],
                          );

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_return_field_overrides = (
                                text    => [],
                               );
    %_object_to_ibap = (
                        text    => \&ibap_o2i_string,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('text'),
                      );

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RPZRecord::BaseRule', $_object_type);
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

sub __init_instance_constants__
{
    my $self = shift;
    $self->SUPER::__init_instance_constants__();
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::DNS::RPZRecord::CNAME;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides
            %_capabilities);
@ISA = qw ( Infoblox::DNS::RPZRecord::BaseRule );

BEGIN {
    $_object_type = 'ResponsePolicyCnameRecord';
    register_wsdl_type('ib:ResponsePolicyCnameRecord', 'Infoblox::DNS::RPZRecord::CNAME');

    %_capabilities = (
                     );

    %_allowed_members = (
                         canonical             => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       canonical => 'canonical_name' ,
                      );

    %_ibap_to_object = (
                       );

    %_searchable_fields = (
                           canonical => [\&ibap_o2i_string ,'canonical_name', 'REGEX'],
                          );

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_return_field_overrides = (
                                canonical => [],
                               );
    %_object_to_ibap = (
                        canonical => \&ibap_o2i_string,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('canonical_name'),
                      );

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RPZRecord::BaseRule', $_object_type);
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

sub __init_instance_constants__
{
    my $self = shift;
    $self->SUPER::__init_instance_constants__();
}

sub __ibap_object_type__
{
    return $_object_type;
}


package Infoblox::DNS::RPZRecord::CNAME::IpAddress;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides);
@ISA = qw ( Infoblox::DNS::RPZRecord::CNAME );

BEGIN {
    $_object_type = 'ResponsePolicyIPAddress';
    register_wsdl_type('ib:ResponsePolicyIPAddress', 'Infoblox::DNS::RPZRecord::CNAME::IpAddress');

    %_allowed_members = (
                         canonical             => {simple => 'asis', mandatory => 1, validator => \&__ibap_value_o2i_canonical__},
                         is_ipv4               => {simple => 'bool', readonly => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       canonical => 'canonical_name' ,
                       is_ipv4 => 'is_ipv4_rec',
                      );

    %_ibap_to_object = (
                        is_ipv4_rec => \&ibap_i2o_boolean,
                       );

    %_searchable_fields = (
                           canonical => [\&ibap_o2i_string ,'canonical_name', 'REGEX'],
                          );

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_return_field_overrides = (
                                is_ipv4 => [],
                                canonical => [],
                               );
    %_object_to_ibap = (
                        canonical => \&ibap_o2i_string,
                        is_ipv4 => \&ibap_o2i_ignore,
                       );

    $_return_fields_initialized=0;
    @_return_fields = (
                       tField('canonical_name'),
                       tField('is_ipv4_rec'),
                      );

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RPZRecord::CNAME', $_object_type);
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

sub __init_instance_constants__
{
    my $self = shift;
    $self->SUPER::__init_instance_constants__();
}

sub __ibap_object_type__
{
    return $_object_type;
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'is_ipv4_rec'} = 0 unless defined $$ibap_object_ref{'is_ipv4_rec'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}
#
#
#
sub __ibap_value_o2i_canonical__
{
    my ($value, $field, $session, $validateonly) = @_;

    if (is_ipv4_address($value) || is_ipv6_address($value) ||
        $value eq "" || $value eq "*" ||
        is_ipv4_network($value) || is_ipv6_network($value))
    {
        return 1 if $validateonly;
        return tString($value);
    }
    else
    {
        set_error_codes(1012, "Invalid ip address $value",$session);
        return undef;
    }
}

package Infoblox::DNS::RPZRecord::CNAME::ClientIpAddress;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw ( @ISA
              %_capabilities
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
);

@ISA = qw ( Infoblox::DNS::RPZRecord::CNAME::IpAddress );

BEGIN {
    $_object_type = 'ResponsePolicyClientIPAddress';
    register_wsdl_type('ib:ResponsePolicyClientIPAddress', 'Infoblox::DNS::RPZRecord::CNAME::ClientIpAddress');

    %_capabilities = ();
    %_allowed_members = (
                         canonical => {simple => 'asis', mandatory => 1, enum => ['*', '', 'rpz-passthru']},
    
    );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = ();
    %_ibap_to_object = ();
    %_searchable_fields = ();

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_return_field_overrides = ();
    %_object_to_ibap = ();

    $_return_fields_initialized=0;
    @_return_fields = ();

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RPZRecord::CNAME::IpAddress', $_object_type);

}

sub new {

    my ($proto, %args) = @_;
    my $class = ref ($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    $self->__init_instance_constants__();
    return $self;
}

sub __init_instance_constants__ {

    my $self = shift;
    $self->SUPER::__init_instance_constants__();
}

sub __ibap_object_type__ {

    return $_object_type;
}


package Infoblox::DNS::RPZRecord::CNAME::IpAddressDN;

use strict;

use Carp;
    
use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            $_return_fields_initialized %_return_field_overrides);
@ISA = qw ( Infoblox::DNS::RPZRecord::CNAME );

BEGIN {
    $_object_type = 'ResponsePolicyIPAddressCname';
    register_wsdl_type('ib:ResponsePolicyIPAddressCname', 'Infoblox::DNS::RPZRecord::CNAME::IpAddressDN');

    %_allowed_members = (
                         canonical             => {simple => 'asis', mandatory => 1, validator => \&ibap_value_o2i_string},
                         is_ipv4               => {simple => 'bool', readonly => 1},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       canonical => 'canonical_name' ,
                       is_ipv4   => 'is_ipv4_rec',
                      );

    %_ibap_to_object = (
                        is_ipv4_rec => \&ibap_i2o_boolean,
                       );

    %_searchable_fields = (
                           canonical => [\&ibap_o2i_string ,'canonical_name', 'REGEX'],
                          );

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_return_field_overrides = (
                                is_ipv4   => [],
                                canonical => [],
                               );
    %_object_to_ibap = (
                        canonical => \&ibap_o2i_string,
                        is_ipv4   => \&ibap_o2i_ignore,
                       );

    $_return_fields_initialized = 0;
    @_return_fields = (
                       tField('canonical_name'),
                       tField('is_ipv4_rec'),
                      );

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RPZRecord::CNAME', $_object_type);
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

sub __init_instance_constants__
{
    my $self = shift;
    $self->SUPER::__init_instance_constants__();
}

sub __ibap_object_type__
{
    return $_object_type;
}

sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'is_ipv4_rec'} = 0 unless defined $$ibap_object_ref{'is_ipv4_rec'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

package Infoblox::DNS::RPZRecord::CNAME::ClientIpAddressDN;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;

use vars qw ( @ISA
              %_capabilities
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
);

@ISA = qw ( Infoblox::DNS::RPZRecord::CNAME::IpAddressDN );

BEGIN {
    $_object_type = 'ResponsePolicyClientIPAddressCname';
    register_wsdl_type('ib:ResponsePolicyClientIPAddressCname', 'Infoblox::DNS::RPZRecord::CNAME::ClientIpAddressDN');

    %_capabilities = ();
    %_allowed_members = ();

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = ();
    %_ibap_to_object = ();
    %_searchable_fields = ();

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_return_field_overrides = ();
    %_object_to_ibap = ();

    $_return_fields_initialized = 0;
    @_return_fields = ();

    Infoblox::IBAPBase::subclass('Infoblox::DNS::RPZRecord::CNAME::IpAddressDN', $_object_type);

}

sub new {

    my ($proto, %args) = @_;
    my $class = ref ($proto) || $proto;
    my $self = Infoblox::IBAPBase->new(%args);
    bless $self, $class;

    if (!$self->__initialize_members_from_arg_list__(\%_allowed_members, \%args) ||
        !$self->__validate_object_required_members__(\%_allowed_members))
    {
        return;
    }

    $self->__init_instance_constants__();
    return $self;
}

sub __init_instance_constants__ {

    my $self = shift;
    $self->SUPER::__init_instance_constants__();
}

sub __ibap_object_type__ {

    return $_object_type;
}

package Infoblox::DNS::AllRPZRecords;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;

use vars qw(@ISA $_object_type %_allowed_members @_return_fields
            %_searchable_fields %_object_to_ibap %_name_mappings
            %_reverse_name_mappings %_ibap_to_object
            %_return_field_overrides %_type_mapping
            %_capabilities %_search_type_mapping
            %_rpz_rule_mapping %_reverse_rpz_rule_mapping);
@ISA = qw ( Infoblox::IBAPBase Infoblox::PAPIOverrides::SEARCH_ONLY );

BEGIN {
    $_object_type = 'ResponsePolicyZoneChild';
    register_wsdl_type('ib:ResponsePolicyZoneChild', 'Infoblox::DNS::AllRPZRecords');

    %_rpz_rule_mapping = (
                        'PASSTHRUIPADDR'                => 'PassthruIpaddr',
                        'PASSTHRUDOMAIN'                => 'PassthruDomain',
                        'BLOCKNXDOMAINIPADDR'           => 'BlockNxdomainIpaddr',
                        'BLOCKNXDOMAINDOMAIN'           => 'BlockNxdomainDomain',
                        'BLOCKNODATAIPADDR'             => 'BlockNoDataIpaddr',
                        'BLOCKNODATADOMAIN'             => 'BlockNoDataDomain',
                        'SUBSTITUTE_CNAME'              => 'SubstituteCName',
                        'SUBSTITUTE_A_RECORD'           => 'SubstituteARecord',
                        'SUBSTITUTE_AAAA_RECORD'        => 'SubstituteAAAARecord',
                        'SUBSTITUTE_MX_RECORD'          => 'SubstituteMXRecord',
                        'SUBSTITUTE_PTR_RECORD'         => 'SubstitutePTRRecord',
                        'SUBSTITUTE_NAPTR_RECORD'       => 'SubstituteNAPTRRecord',
                        'SUBSTITUTE_SRV_RECORD'         => 'SubstituteSRVRecord',
                        'SUBSTITUTE_TXT_RECORD'         => 'SubstituteTXTRecord',
                        'SUBSTITUTE_IPV4ADDRESS_RECORD' => 'SubstituteIPv4AddressRecord',
                        'SUBSTITUTE_IPV6ADDRESS_RECORD' => 'SubstituteIPv6AddressRecord',
                        'SUBSTITUTE_IPADDR_CNAME'       => 'SubstituteIPAddressCname',
                        'PASSTHRUCLIENTIPADDR'          => 'PassthruClientIpaddr',
                        'BLOCKNXDOMAINCLIENTIPADDR'     => 'BlockNxdomainClientIpaddr',
                        'BLOCKNODATACLIENTIPADDR'       => 'BlockNoDataClientIpaddr',
                        'SUBSTITUTE_CLIENTIPADDR_CNAME' => 'SubstituteClientIPAddressCname',
    );

    %_reverse_rpz_rule_mapping = (reverse %_rpz_rule_mapping);
    
    %_capabilities = (
                      'depth'                => 0,
                      'implicit_defaults'    => 1,
                      'single_serialization' => 1,
                      'limit'                => 2000,
                      'has_next'             => 1,
                     );

    %_allowed_members = (
                         comment               => {simple => 'asis', readonly => 1},
                         disable               => {simple => 'bool', readonly => 1} ,
                         name                  => {simple => 'asis', readonly => 1},
                         record                => {readonly => 1},
                         ttl                   => {simple => 'asis', readonly => 1},
                         zone                  => {readonly => 1},
                         type                  => {readonly => 1},
                         view                  => {readonly => 1},
                         rpz_rule              => {readonly => 1},
                         last_updated          => {simple => 'asis', readonly => 1},
                         expiration_time       => {simple => 'asis', readonly => 1},
                         alert_type            => {simple => 'asis', 'readonly' => 1, enum => [
                                                                                               'INFECTION_MATCH',
                                                                                               'WEB_INFECTION',
                                                                                               'MALWARE_OBJECT',
                                                                                               'DOMAIN_MATCH',
                                                                                               'MALWARE_CALLBACK',
                                                                                              ]},
                        );

    Infoblox::IBAPBase::create_accessors(\%_allowed_members);

    %_name_mappings = (
                       disable => 'disabled' ,
                       type    => 'view_type' ,
                      );

    %_ibap_to_object = (
                        rpz_rule => \&__i2o_rpz_rule__,
                        view     => \&ibap_i2o_object_name,
                        zone     => \&Infoblox::DNS::AllRecords::__i2o_zone__,
                        disabled => \&ibap_i2o_boolean,
                        record   => \&Infoblox::DNS::AllRecords::__i2o_record__,
                        view_type => \&__i2o_viewtype__,
                        last_updated => \&ibap_i2o_datetime_to_unix_timestamp,
                        expiration_time => \&ibap_i2o_datetime_to_unix_timestamp,
                       );

    %_searchable_fields = (
                           rpz_rule => [\&__o2i_rpz_rule__, 'rpz_rule', 'EXACT'],
                           type => [\&__o2i_type_search__,'view_type', 'EXACT'],

                           zone         => [\&Infoblox::DNS::AllRecords::__o2i_zone_search__,'zone', 'EXACT'], # View is taken care of within zone
                           name         => [\&ibap_o2i_string ,'name', 'REGEX', 'IGNORE_CASE'],

                           #
                           view => [\&ibap_o2i_ignore, 'deprecated', 'DEPRECATED'],
                          );

    %_reverse_name_mappings = (reverse %_name_mappings);

    %_return_field_overrides = (
                                comment  => [],
                                disable  => [],
                                name     => [],
                                record   => [],
                                ttl      => [],
                                view     => [],
                                zone     => [],

                                rpz_rule => [],
                                type     => [],
                               );

    %_type_mapping = (
                      'ResponsePolicyARecord'          => 'A Record',
                      'ResponsePolicyAaaaRecord'       => 'AAAA Record',
                      'ResponsePolicyCnameRecord'      => 'CNAME Record',
                      'ResponsePolicyIPAddress'        => 'IP Address Record',
                      'ResponsePolicyClientIPAddress'  => 'Client IP Address Record',
                      'ResponsePolicyMxRecord'         => 'MX Record',
                      'ResponsePolicyNaptrRecord'      => 'NAPTR Record',
                      'ResponsePolicyPtrRecord'        => 'PTR Record',
                      'ResponsePolicySrvRecord'        => 'SRV Record',
                      'ResponsePolicyTxtRecord'        => 'TXT Record',
                      'ResponsePolicyIPARecord'        => 'A IP Address Record',
                      'ResponsePolicyIPAaaaRecord'     => 'AAAA IP Address Record',
                      'UnsupportedRecord'              => 'Unsupported Record',
                     );

    #
    foreach my $org (keys %_type_mapping) {
        my $t = lc($_type_mapping{$org});
        $t =~ s/record$/records/;
        $_search_type_mapping{'all ' . $t} = $org;
    }
    $_search_type_mapping{'all records'} = 'ALL';


    %_object_to_ibap = (
                         comment         => \&ibap_o2i_ignore,
                         disable         => \&ibap_o2i_ignore,
                         name            => \&ibap_o2i_ignore,
                         record          => \&ibap_o2i_ignore,
                         ttl             => \&ibap_o2i_ignore,
                         zone            => \&ibap_o2i_ignore,
                         type            => \&ibap_o2i_ignore,
                         view            => \&ibap_o2i_ignore,
                         rpz_rule        => \&ibap_o2i_ignore,
                         last_updated    => \&ibap_o2i_ignore,
                         expiration_time => \&ibap_o2i_ignore,
                         alert_type      => \&ibap_o2i_ignore,
                       );

    @_return_fields = (
                       tField('name'),
                       tField('comment'),
                       tField('disabled'),
                       tField('record', {depth =>0}), # we just want the oid
                       tField('ttl'),
                       tField('view_type'),
                       tField('view',{sub_fields => [tField('name')]}),
                       tField('zone',{sub_fields => [tField('fqdn')]}),
                       tField('rpz_rule'),
                       tField('last_updated'),
                       tField('expiration_time'),
                       tField('alert_type'),
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

sub __search_mapping_hook_pre__
{
    my ($self, $session, $type, $argsref, $out_search_fields_ref, $out_search_types_ref, $out_search_matches_ref) = @_;

    if (not defined $argsref->{'zone'}) {
        set_error_codes(1103,"zone is a required search parameter",$session);
        return 0;
    }

    return 1;
    }

sub __search_mapping_hook_post__
{
    my ($self, $session, $type, $argsref, $out_search_fields_ref, $out_search_types_ref, $out_search_matches_ref) = @_;

    $out_search_fields_ref->{'hier'}  = tBool(1);
    $out_search_types_ref->{'hier'}   = 'EXACT';
    $out_search_matches_ref->{'hier'} = undef;

    return 1;
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
sub __ibap_to_object__
{
    my ($self, $ibap_object_ref, $server, $session, $return_object_cache_ref) = @_;

    $$ibap_object_ref{'disabled'} = 0 unless defined $$ibap_object_ref{'disabled'};

    return $self->SUPER::__ibap_to_object__($ibap_object_ref, $server, $session, $return_object_cache_ref);
}

sub __i2o_viewtype__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    return defined $_type_mapping{$$ibap_object_ref{$current}} ? $_type_mapping{$$ibap_object_ref{$current}} : 'Unknown';
}

sub __i2o_rpz_rule__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;

    if($$ibap_object_ref{$current}) {
        return $_reverse_rpz_rule_mapping{$$ibap_object_ref{$current}};
    } else {
        return undef;
    }
}

#
#
#
sub __o2i_rpz_rule__
{
    my ($self, $session, $current, $tempref) = @_;

    my @return_args;

    push @return_args, 1;
    push @return_args, 0;

    if($$tempref{$current}) {
        my $t=ibap_value_o2i_string($_rpz_rule_mapping{$$tempref{$current}});
        return (0) unless $t;
        push @return_args, $t;
    } else {
        push @return_args, undef;
    }

    return @return_args;
}

sub __o2i_type_search__
{
    my ($self, $session, $current, $tempref) = @_;

    my $t = lc($$tempref{$current});

    if ($_search_type_mapping{$t}) {
        return(1,0,ibap_value_o2i_string($_search_type_mapping{$t}));
    }
    else {
        set_error_codes(1103, $$tempref{$current} . ' is not a valid value for type', $session);
        return (0);
    }
}

#
#
#

1;
