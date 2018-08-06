function state = tango_state2(dev_name)
%TANGO_STATE2 - Get state of a tango device with error control
%
% INPUTS
% 1. dev_name -  device name
%  
% OUTPUTS
%  1. state - Tango state of the device
%
% EXAMPLES
%  
% See Also tango_read_attribute, tango_command_inout2

% Written by Laurent S. Nadolski

rep = tango_state(dev_name);

state = rep.name;


if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end
