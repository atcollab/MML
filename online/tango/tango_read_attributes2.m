function attr_val_list = tango_read_attributes2 (dev_name, attr_name_list)
%TANGO_READ_ATTRIBUTES2 - enhanced tango_read_attributes
%
%  argout=tango_read_attributes(dev_name, attr_name_list)
%
%  INPUTS
%  1. dev_name -  device name
%  2. attr_name_list - attribute name list
%  
%  OUTPUTS
%  1. attr_val_list - attribute value list
%
% EXAMPLES
%  
% See Also tango_read_attributes

% Written by Laurent S. Nadolski

attr_val_list = tango_read_attributes(dev_name, attr_name_list);

if (tango_error == -1)
    %- handle error
    tango_print_error_stack;
    return
end