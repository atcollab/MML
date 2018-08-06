function attr_prop = tango_get_device_property(varargin)
%TANGO_GET_DEVICE_PROPERTY - Set a device property to a given value
% tango_get_device_property(DeviceName, value)
%
% INPUTS
% 1. DeviceName
% 2. property to set
%
%  OUTPUTS
%  1.  attr_prop - property value
%
% EXAMPLES
% 1. tango_get_device_property('BEND','Url')
% 2. tango_get_device_property('LT1/AE/Q.1','Url')
%
% See also tango_get_attribute_property, tango_set_device_property

%
% Written by Laurent S. Nadolski

DoubleFlag = 0;

% Input parser
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Double')
        DoubleFlag = 1;
        varargin(i) = [];
    end
end

if length(varargin) < 2
    error('Not enough arguments')
else
    FamilyName = varargin{1};
    property = varargin{2}; 

    if isfamily(FamilyName)
        name = family2tango(FamilyName);
        [attr devlist] = getattribute(name);
    else %not a family name
        devlist = FamilyName;
        if ~iscell(devlist)
            devlist = {devlist};
        end
    end
    
end

attr_prop = cell('');
for k = 1:length(devlist)
    attr_config = tango_get_property2(devlist{k,:},property);    
    if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        fprintf(1,'TracyServer Error %s\n',devlist{k,:})
        return;
    end
    if isempty(attr_config.value)
        warning('Property %s not defined \n',property);
        attr_prop = [];
        return;
    else
        if size(attr_config.value,2) > 1  % no scalar
            attr_prop{k} = attr_config.value;
        else
            attr_prop(k) = attr_config.value;
        end
    end
end

attr_prop = attr_prop(:);

if DoubleFlag 
    attr_prop = str2num(char(attr_prop));
end
