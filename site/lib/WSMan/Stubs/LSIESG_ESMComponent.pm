package LSIESG_ESMComponent;
use WSMan::Stubs::Initializable;
use WSMan::Stubs::CIM_Card;
use strict;


@LSIESG_ESMComponent::ISA = qw(_Initializable CIM_Card);


#===============================================================================
#			INITIALIZER
#===============================================================================

sub _init{
    my ($self, %args) = @_;
    $self->CIM_Card::_init();
    unless(exists $self->{invokableMethods}){
        $self->{invokableMethods} = {};
    }
    unless(exists $self->{id_keys}){
        $self->{id_keys} = ();
    }
    $self->{Chassis_Tag} = undef;
    $self->{epr_name} = undef;  
    @{$self->{id_keys}} = keys %{{ map { $_ => 1 } @{$self->{id_keys}} }};
    if(keys %args){
        $self->_subinit(%args);
    }
}


#===============================================================================


#===============================================================================
#            Chassis_Tag accessor method.
#===============================================================================

sub Chassis_Tag{
    my ($self, $newval) = @_;
    $self->{Chassis_Tag} = $newval if @_ > 1;
    return $self->{Chassis_Tag};
}
#===============================================================================


#===============================================================================
#           epr_name accessor method.
#===============================================================================

sub epr_name{
    my ($self, $newval) = @_;
    $self->{epr_name} = $newval if @_ > 1;
    return $self->{epr_name};
}
#===============================================================================


1;
