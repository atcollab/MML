function tango_set_attribute_property(FamilyName, property, strvalue)
%TANGO_SET_ATTRIBUTE_PROPERTY - Set an attribute property to a given value
% tango_set_attribute_property(FamilyName, value)
%
% INPUTS
% 1. FamilyName
% 2. property to set
% 3. strvalue - values to set
%
% EXAMPLES
% 1. tango_set_attribute_property('BEND','max_value','600')
%
% See also tango_get_attribute_property

%
% Written by Laurent S. Nadolski

if nargin < 3
    error('Not enough arguments')
end

if isfamily(FamilyName)
    name = family2tango(FamilyName);
else %not a family name
    name = FamilyName;
end

[attrlist devlist] = getattribute(name); 

nb = length(devlist);

if size(strvalue,1) == 1
    strlist = cellstr(repmat(strvalue,nb,1));
else
    strlist = strvalue;
end

%%% 
for k = 1:nb
    dev = devlist{k,:};
    attr = attrlist{k,:};
    attr_config = tango_get_attribute_config(dev,attr);
    attr_config.(property) = strlist{k};
    tango_set_attribute_config(dev,attr_config);
    if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        fprintf(1,'TracyServer Error %s\n',dev)
        return;
    end
end