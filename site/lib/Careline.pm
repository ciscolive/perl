package Careline;
use Carp;
use Mojo::Base 'Mojo::EventEmitter';
use Mojo::Loader qw(load_class);

has 'backend';
sub new {
    my $self = shift->SUPER::new;

    my $class = 'Minion::Backend::' . shift;
    my $e     = load_class $class;
    croak ref $e ? $e : qq{Backend "$class" missing} if $e;

    return $self->backend($class->new(@_)->minion($self));
}
1;
