function tango_print_attribute_list(dev)

%- get attributes info
attr_info_list = tango_attribute_list_query(dev);
%- always check error
if (tango_error == -1)
   %- handle error
   tango_print_error_stack;
   return;
end
%- attr_info_list is valid
%- print info for <operator> attribute
for i = 1:size(attr_info_list,2)
    if (attr_info_list(i).disp_level == 0)
      disp(attr_info_list(i));
    end
end
