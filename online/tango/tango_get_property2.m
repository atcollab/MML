function prop_val = tango_get_property2(dev_name, prop_name)
% TANGO_PUT_PROPERTIES - enhanced tango_put_properties
%
%  argout=tango_tango_put_properties2(dev_name, prop_name_value_list))
%
% INPUTS
% 1. dev_name -  device name
% 2. prop_name - the name of the property to read
%
% OUTPUTS
% 1. prop_val - the list of property value
%  
% EXAMPLES
%  
% See also tango_put_property2, tango_command_inout2

% Written by Laurent S. Nadolski

prop_val = tango_get_property(dev_name, prop_name);

if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end