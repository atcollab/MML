function tango_set_device_property(FamilyName, property, strvalue)
%TANGO_SET_DEVICE_PROPERTY - Set a device property to a given value
% tango_set_device_property(DeviceName, value)
%
% INPUTS
% 1. Family name or Device name
% 2. property to set
% 3. strvalue - values to set
%
% EXAMPLES
% 1. tango_set_device_property('CycleBEND','Delta','1')
%
% See also tango_get_attribute_property, tango_get_device_property

%
% Written by Laurent S. Nadolski

if nargin < 3
    error('Not enough arguments')
end

if isfamily(FamilyName)
    name = family2tango(FamilyName);
    [attr devlist] = getattribute(name);
else %not a family name
    devlist = FamilyName;
    if ~iscell(devlist)
        devlist = {devlist};
    end
end
    
nb = length(devlist);

if size(strvalue,1) == 1
    strlist = cellstr(repmat(strvalue,nb,1));
else
    strlist = strvalue;
end

% tango_put_property2('LT1/AE/cycleD.1','Delta',{'0.1'})

%%% 
for k = 1:nb
    prop_config = tango_get_property2(devlist{k,:},property);
    %% check if property defined. If not do nothing
    if ~isempty(prop_config.value)
        prop_config.value = strlist{k};
        tango_put_property(devlist{k,:}, property, strlist(k));
        if (tango_error == -1)
            %- handle error
            tango_print_error_stack;
            fprintf(1,'TracyServer Error %s\n',devlist{k,:})
            return;
        end
    else
        warning('Property %s is not defined\n Action canceled',property)
    end
end