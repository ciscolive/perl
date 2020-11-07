package Infoblox::Cursor;

use strict;
use Carp;

use Infoblox::Util;

sub DESTROY
{
    my $self=shift;

    #
    delete $self->{'cache'};

    #
    #
}

#
sub __new__ {
    my ($proto, $session, %args) = @_;
    my $class = ref($proto) || $proto;

    my $self = {};

    bless($self, $class);

    $self->{'session'}            = $session;
    $self->{'object_type'}        = delete $args{'object'};
    $self->{'wanted_members_ref'} = delete $args{'return_methods'};
    $self->{'args'}               = \%args;
    $self->{'cache'}              = [];
    $self->{'has_more'}           = 1;

    unless (defined $self->{'session'} && ref($self->{'session'}) eq 'Infoblox::Session') {
        set_error_codes(1103,"A valid session is a required argument.");
        return;
    }

    if (defined $args{'fetch_size'}) {
        if ($args{'fetch_size'} =~ /^\d+$/) {
            $self->{'fetch_size'}=$args{'fetch_size'};
        }
        else {
            set_error_codes(1104,"Invalid value '" . $args{'fetch_size'}. "' for member 'fetch_size'",$session);
            return;
        }
        delete $args{'fetch_size'};
    }
    else {
        $self->{'fetch_size'}=100;
    }

    unless ($self->{'object_type'}) {
        set_error_codes(1103,"'object' is a required argument.",$session);
        return;
    }

    my $object = $self->{'object_type'}->__new__();

    if ($object->can('__ibap_capabilities__')) {
        if ($object->__ibap_capabilities__('nopaging')) {
            set_error_codes(1001,"General failure, this object does not support cursors.",$session);
            return;
        }
    }

    my $ibap_object_type = $object->__ibap_object_type__("search", $session, \%args) if $object->can('__ibap_object_type__');

    if ($object->can('__func_call__') || $object->can('__search_override_hook__') || not defined $ibap_object_type) {
        set_error_codes(1001,"General failure, this object does not support cursors.",$session);
        return;
    }

    $self->{'search_query'} = $session->_search_parameters_helper($object,\%args,'search');
    return unless $self->{'search_query'};

    $self->{'caller_object'} = $object;
    $self->{'ibap_object_type'} = $ibap_object_type;

    return $self;
}

sub __check_invalid__
{
    my $self=shift;
    if (defined $self->{'invalid'}) {
        set_error_codes(1001,"General failure, this cursor has become invalid and cannot be used for more queries.",$self->{'session'});
        return 1;
    }
    return;
}

sub __invalidate__
{
    my $self=shift;

    $self->{'has_more'} = 0;
    delete $self->{'ticket'};
    $self->{'invalid'}=1;

    return;
}

sub fetch
{
    my ($self) = @_;
    return if $self->__check_invalid__();

    #
    #
    my $howmany=1;

    #
    #
    #
    while (1) {
        if (scalar(@{$self->{'cache'}}) < $howmany ) {
            last if $self->{'has_more'} == 0;

            if (defined $self->{'inside_get_search_callback'}) {
                return unless $self->__cache_fill_callback__();
            }
            else {
                return unless $self->__cache_fill__();
            }
        }
        else {
            last;
        }
    }

    unless (scalar(@{$self->{'cache'}})) {
        return;
    }

    if (scalar(@{$self->{'cache'}}) <= $howmany) {
        if ($howmany == 1) {
            return shift @{$self->{'cache'}};
        }
        else {
            return $self->{'cache'};
        }
    }
    else {
        #
        #

        return shift @{$self->{'cache'}};
    }
}

sub __cache_fill_callback__
{
    my $self=shift;
    return if $self->__check_invalid__();

    my $object_array_ref;
    my $server=$self->{'session'}->get_ibap_server() || return;

    $self->{'has_more'}=1;
    if ($self->{'caller_object'}->__get_search_callback__($self->{'session'}, $self->{'caller_object'},
                                         $self->{'search_query'}, \$object_array_ref, $self->{'wanted_members_ref'},
                                         $self,$self->{'args'}) != 1) {
        if ($self->{'has_more'} == 0 && not defined $self->{'invalid'}) {
            $self->{'has_more'} = 0;

            #
            #
            #
            set_error_codes(0,undef,$self->{'session'});
            return 1;
        }

        return;
    }

    push @{$self->{'cache'}}, @{$object_array_ref};
    return 1;
}

sub __cache_fill__
{
    my $self=shift;
    return if $self->__check_invalid__();

    my $object_array_ref;
    my $server=$self->{'session'}->get_ibap_server() || return;

    $self->{'has_more'}=1;
    if ($self->{'session'}->__ibap_object_read__($server, $self->{'caller_object'}, $self->{'object_type'},
                                                 $self->{'ibap_object_type'}, 1, $self->{'search_query'},
                                                 $self->{'wanted_members_ref'}, 0,
                                                 \$object_array_ref, undef, $self, $self->{'args'})
        != 1) {

        if ($self->{'has_more'} == 0 && not defined $self->{'invalid'}) {
            if ($self->{'caller_object'}->can('__get_search_callback__')) {
                #
                delete $self->{'ticket'};
                $self->{'has_more'} = 1;
                $self->{'inside_get_search_callback'} = 1;
            }

            #
            #
            #
            set_error_codes(0,undef,$self->{'session'});
            return 1;
        }

        return;
    }

    #
    #
    #
    #
    #
    if ($self->{'has_more'} == 0 && not defined $self->{'invalid'}) {
        if ($self->{'caller_object'}->can('__get_search_callback__')) {
            #
            delete $self->{'ticket'};
            $self->{'has_more'} = 1;
            $self->{'inside_get_search_callback'} = 1;
        }
    }

    $self->{'caller_object'}->__post_search_hook__($server, $self->{'session'}, $self->{'args'}, \$object_array_ref) if $self->{'caller_object'}->can('__post_search_hook__');

    push @{$self->{'cache'}}, @{$object_array_ref};
    return 1;
}

1;
