function tango_put_properties2(dev_name, prop_name_value_list)
% TANGO_PUT_PROPERTIES - enhanced tango_put_properties
%
%  argout=tango_tango_put_properties2(dev_name, prop_name_value))
%
% INPUTS
% 1. dev_name -  device name
% 2. prop_name_value_list - the list of property value
%  
% EXAMPLES
%  
% See also tango_get_properties2, tango_command_inout2

% Written by Laurent S. Nadolski

tango_put_properties(dev_name, prop_name_value_list);

if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end