function tango_put_property2(dev_name, prop_name_value, prop_value)
% TANGO_PUT_PROPERTIES - enhanced tango_put_properties
%
%  argout=tango_tango_put_properties2(dev_name, prop_name_value))
%
% INPUTS
% 1. dev_name -  device name
% 2. prop_name_value - property value
%  
% EXAMPLES
%  
% See also tango_get_property2, tango_command_inout2

% Written by Laurent S. Nadolski

tango_put_property(dev_name, prop_name_value, prop_value);

if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end