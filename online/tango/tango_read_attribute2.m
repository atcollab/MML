function argout = tango_read_attribute2(dev_name, attr_name)
% TANGO_COMMAND_INOUT2 - enhanced tango_command_inout
%
%  argout=tango_read_attribute2(dev_name, attr_name)
%
% INPUTS
% 1. dev_name -  device name
% 2. argin - attribute name
%  
% OUTPUTS
%  1. output arguments
%
% EXAMPLES
%  
% See Also tango_read_attribute, tango_command_inout2

% Written by Laurent S. Nadolski

argout = tango_read_attribute (dev_name, attr_name);

if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end