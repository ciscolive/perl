package Mail::Milter::Authentication::Exception;
use 5.20.0;
use strict;
use warnings;
use Mail::Milter::Authentication::Pragmas;
# ABSTRACT: Class representing an exception
our $VERSION = '2.20200930.2'; # VERSION


sub new {
    my ( $class, $args ) = @_;
    my $self = $args;
    bless $self, $class;
    return $self;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Mail::Milter::Authentication::Exception - Class representing an exception

=head1 VERSION

version 2.20200930.2

=head1 CONSTRUCTOR

=head2 I<new( $args )>

die Mail::Milter::Authentication::Exception->new({ 'Type' => 'Timeout', 'Text' => 'Example timeout exception' });

Create a new exception object.

=head1 AUTHOR

Marc Bradshaw <marc@marcbradshaw.net>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Marc Bradshaw.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
