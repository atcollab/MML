function ErrorFlag = setpvonline(TangoNames, NewSP, DataType);
%SETPVONLINE - Set value to online machine
%  ErrorFlag = setpvonline(ChannelNames, NewSP, DataType);
%
%  INPUTS
%  1. TangoNames - Tango attribute names
%  2. NewSP - Setpoint value
%  3. DataType - 'double' or 'string'
%
%  OUTPUTS
%  1. ErrorFlag
%
% See also getpvonline

%
%  Written for by Laurent S. Nadolski

% TODO group

if nargin < 2
    error('Must have at least two inputs');
end

ErrorFlag = 0;

[attribute device]  = getattribute(TangoNames);

for k = 1:size(attribute,1)
    tango_write_attribute(device{k},attribute{k},NewSP(k));
    if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        warning('Error with device %s',device{k});
        ErrorFlag = ErrorFlag + 1;
    end
end    
