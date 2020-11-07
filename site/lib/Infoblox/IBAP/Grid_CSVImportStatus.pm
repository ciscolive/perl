package Infoblox::Grid::CSVImportStatus;

use strict;

use Carp;

use Infoblox::Util;
use Infoblox::IBAPBase;
use Infoblox::IBAPTypes;
use Infoblox::PAPIOverrides;
use vars qw( @ISA $_object_type %_allowed_members @_return_fields %_searchable_fields %_object_to_ibap %_name_mappings %_reverse_name_mappings %_ibap_to_object @_sub_host_address_fields %_return_field_overrides %_capabilities);
@ISA = qw (Infoblox::IBAPBase Infoblox::PAPIOverrides::RO);

BEGIN {
    $_object_type = 'CSVImportTask';
    register_wsdl_type('ib:CSVImportTask','Infoblox::Grid::CSVImportTask');

    %_capabilities = (
					  'depth' 				 => 0,
					  'implicit_defaults' 	 => 1,
					  'single_serialization' => 0,
					 );

    %_allowed_members =
      (
       admin           => -1,
       end_time        => -1,
       file_name       => -1,
       import_id       => -1,
       lines_failed    => -1,
       lines_processed => -1,
       lines_total     => -1,
       lines_warning   => -1,
       start_time      => -1,
       status          => -1,
      );

    %_name_mappings =
      (
       'admin' => 'admin_name',
      );

    %_reverse_name_mappings = reverse %_name_mappings;

    %_searchable_fields =
      (
       import_id       => [\&ibap_o2i_uint, 'import_id', 'EXACT'],
      );

	%_return_field_overrides =
      (
       admin           => [],
       end_time        => [],
       file_name       => [],
       import_id       => [],
       lines_failed    => [],
       lines_processed => [],
       lines_total     => [],
       lines_warning   => [],
       start_time      => [],
       status          => [],
      );

    %_ibap_to_object =
      (
       status          => \&__i2o_status__,
      );

    %_object_to_ibap =
      (
       admin           => \&ibap_o2i_ignore,
       end_time        => \&ibap_o2i_ignore,
       file_name       => \&ibap_o2i_ignore,
       import_id       => \&ibap_o2i_ignore,
       lines_failed    => \&ibap_o2i_ignore,
       lines_processed => \&ibap_o2i_ignore,
       lines_total     => \&ibap_o2i_ignore,
       lines_warning   => \&ibap_o2i_ignore,
       start_time      => \&ibap_o2i_ignore,
       status          => \&ibap_o2i_ignore,
      );

    @_return_fields =
      (
       tField('admin_name'),
       tField('end_time'),
       tField('file_name'),
       tField('import_id'),
       tField('lines_failed'),
       tField('lines_processed'),
       tField('lines_total'),
       tField('lines_warning'),
       tField('start_time'),
       tField('status'),
      );
}

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
    $self->__initialize_ibap_common_member__(\%_name_mappings,
                                             \%_reverse_name_mappings,
                                             \%_searchable_fields,
                                             \%_ibap_to_object,
                                             \%_object_to_ibap,
                                             \@_return_fields,
                                             \%_return_field_overrides
                                            );
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

sub __i2o_status__
{
    my ($self, $session, $current, $ibap_object_ref, $return_object_cache_ref) = @_;
    #
    return ucfirst(lc($ibap_object_ref->{$current} =~ /^TEST_/ ? $' : $ibap_object_ref->{$current}));
}

#
#
#

sub admin
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'admin', readonly => 1}, @_);
}

sub end_time
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'end_time', readonly => 1}, @_);
}

sub file_name
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'file_name', readonly => 1}, @_);
}

sub import_id
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'import_id', readonly => 1}, @_);
}

sub lines_failed
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'lines_failed', readonly => 1}, @_);
}

sub lines_processed
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'lines_processed', readonly => 1}, @_);
}

sub lines_total
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'lines_total', readonly => 1}, @_);
}

sub lines_warning
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'lines_warning', readonly => 1}, @_);
}

sub start_time
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'start_time', readonly => 1}, @_);
}

sub status
{
    my $self=shift;
    return $self->__accessor_scalar__({name => 'status', readonly => 1}, @_);
}


1;
