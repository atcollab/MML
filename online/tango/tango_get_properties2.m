function prop_val_list = tango_get_properties2(dev_name, prop_name_list)
% TANGO_PUT_PROPERTIES - enhanced tango_put_properties
%
%  argout=tango_tango_put_properties2(dev_name, prop_name_value_list))
%
% INPUTS
% 1. dev_name -  device name
% 2. prop_name_list - the name of the properties to read
%
% OUTPUTS
% 1. prop_val_list - the list of property value
%  
% EXAMPLES
%  
% See also tango_put_properties2, tango_command_inout2

% Written by Laurent S. Nadolski

prop_val_list = tango_get_properties(dev_name, prop_name_list);

if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end