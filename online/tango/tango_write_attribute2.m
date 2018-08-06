function tango_write_attribute2 (dev_name, attr_name, attr_value)
% TANGO_WRITE_ATTRIBUTE2 - enhanced Writes a single attribute on the
%
%  argout=tango_write_attribute2(dev_name, attr_name, attr_value)
%
% INPUTS
% 1. dev_name -  device name
% 2. attr_name  - attribute name
% 3. attr_value - attribute value
%  
% EXAMPLES
%  
% See Also tango_read_attribute2, tango_command_inout2

% Written by Laurent S. Nadolski

tango_write_attribute(dev_name, attr_name, attr_value);

if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end