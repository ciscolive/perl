# Copyright (c) 2017 Infoblox Inc. All Rights Reserved.
package Infoblox::Result;

use strict;

sub set_status {
    my $self = shift;
    unless (@_ == 1) {
        return;
    }
    my $status_code = shift;
    $self->{"status_code"} = $status_code;
    my $status_message = $self->status_message($status_code);
    $self->{"status_message"} = $status_message;
}

sub set_status_code {
    my $self = shift;
    unless (@_ == 1) {
        return;
    }
    my $status_code = shift;
    $self->{"status_code"} = $status_code;
}

sub set_status_message {
    my $self = shift;
    unless (@_ == 1) {
        return;
    }
    my $status_message = shift;
    $self->{"status_message"} = $status_message;

}

sub get_status_message {
    my $self = shift;
    return $self->{"status_message"};
}

sub get_status_code {
    my $self = shift;
    return $self->{"status_code"};
}

sub get_error_details {
    my $self = shift;
    return $self->{"status_message"};
}

sub is_success {
    my $self        = shift;
    my $status_code = $self->{"status_code"};
    $status_code == 0;
}

sub is_error {
    my $self        = shift;
    my $status_code = $self->{"status_code"};
    $status_code != 0;
}

sub status_message {
    my ($self, $key) = @_;
    my %StatusCode = (
        0    => 'Operation succeeded',
        1001 => 'Unspecified server error in processing request',
        1002 => 'One or more arguments in request are missing or incorrect',
        1003 => 'The specified object was not found',
        1004 => 'Could not open/read/write/close local file or device',
        1005 => 'Duplicate object in the database',
        1006 => 'The username or password is incorrect',
        1007 => 'The user is not authorized for this operation',
        1008 => 'The operation is not allowed because an object is readonly',
        1009 => 'Client is incompatible with server',
        1010 => 'Could not connect to server',
        1011 => 'Connection expired',
        1012 => 'A syntax violation during the operation',
        1013 => 'License error',
        1014 => 'Object(s) referencing current object have not been removed',
        1015 => 'Server not available - down, upgrading restoring',
        1016 => 'Script can not run againt member node',
        1017 => 'HTTPS error: ',
        1018 => 'HTTP request success but no response content',
        1019 => 'restoration failed due to cluster data mismatch',
        1020 => 'Host IP address not found',
        1021 => 'Server not responding to request - timeout',
        1022 => 'File transfer failed',
        1023 => 'Invoking system call failed',
        1024 => 'Object(s) referencing current object have not been removed',
        1025 => 'Unknown Session',
        1026 => 'Member does not exist in the cluster',
        1027 => 'Unknown custom option name',
        1028 => 'File upload/download failed',
        1029 => 'Generate TSIG key failed',
        1030 => 'Cannot retrieve server version from appliance',
        1101 => 'xxx is not allowed as an argument',
        1102 => 'Cannot set member xxx',
        1103 => 'xxx is required',
        1104 => 'Invalid data type for member xxx',
        1105 => 'Cannot define xxx and xxx at the same time',
        1106 => 'Master has not been set. Cannot create session object',
        1107 =>
            'User name or password has not been set. Cannot create session object',
        1108 => 'Export type has not been specified',
        1109 => 'Export path has not been specified',
        1110 => 'Import type has not been specified',
        1111 => 'Import path has not been specified',
        1112 => 'Specified import file xxx does not exist',
        1113 => 'Specified object is obsoleted',
        1114 => 'Object is incompatible with session object',
        1128 =>
            'Email address/relay server address is not correct or DNS resolver is not configured',
        1132 => 'Database deadlocked',
        1133 => 'Database lock not granted',
        1134 => 'Invalid regular expression',
        1135 => 'Invalid attempt clone to a non-standalone unit',
        1136 => 'Not connected to specified grid member',
        1137 => 'Field number mismatch to the schema or actual record',
        1138 => 'No space left in tuple',
        1139 => 'Fixed field after variable field',
        1140 => 'Null field requested',
        1141 => 'Wrong type found',
        1142 => 'Fixed field length mismatch',
        1143 => 'Member reference does not point to valid object',
    );

    $StatusCode{$key};
}

1;
