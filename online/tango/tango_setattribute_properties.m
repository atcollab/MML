function tango_setattribute_properties(DeviceList, AttributeList, PropertyList, ValueCell)
%TANGO_SETATTRIBUTE_PROPERTIES - set properties for device
%
%  INPUTS
%  1. DeviceList - Cell of tango device names
%  2. AttributeList - Cell of attribute names
%  3. PropertyList - Cell of property names
%  4. ValueCell - Cell of values 
%
%  NOTES
%  1. there is a one to one correspondance between PropertyList and
%  ValueCell
%

%
%% Written by Laurent S. Nadolski

for k1 = 1:size(DeviceList,2),
    DeviceList{k1}
    for k2 = 1:size(AttributeList,2),
        
        % get actual properties
        attr_config = tango_get_attribute_config(DeviceList{k1}, AttributeList{k2});
        if (tango_error == -1)
            %- handle error
            tango_print_error_stack;
        end

        % set all poperties
        for k3 = 1:size(PropertyList,2),
            attr_config.(PropertyList{k3}) = ValueCell{k3};
        end
        
        tango_set_attribute_config(DeviceList{k1},attr_config);
        if (tango_error == -1)
            %- handle error
            tango_print_error_stack;
        end
    end
end
