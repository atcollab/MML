function attr_prop = tango_get_attribute_property(varargin)
%TANGO_GET_ATTRIBUTE_PROPERTY - Get properties for an attribute property
%  attr_prop = tango_get_attribute_property(FamilyName, property)
%
%  INPUTS
%  1. FamilyName or cell array of devicenames
%  2. property of the attribute
%  3. Optional - 'Double' return a double array instead of a cell array
%                'Setpoint' {Default}, 'Monitor'   

%  OUTPUTS
%  1.  attr_prop - property value
%
%  EXAMPLES
%  1. tango_get_attribute_property('BEND','max_value')
%
%  See also tango_set_attribute_property, tango_set_device_property

%
% Written by Laurent S. Nadolski

DoubleFlag = 0;
Mode = 'Setpoint';

% Input parser
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Double')
        DoubleFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Setpoint')
        Mode = 'Setpoint';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Monitor')
        Mode = 'Monitor';
        varargin(i) = [];
    end
end

if length(varargin) < 2
    error('Not enough arguments')
else
    FamilyName = varargin{1};
    property = varargin{2}; 

    if isfamily(FamilyName)
        name = family2tango(FamilyName, Mode);
    else %not a family name
        name = FamilyName;
    end
    [attr devlist] = getattribute(name);
end

attr_prop = cell('');
for k = 1:length(devlist)
    attr_config = tango_get_attribute_config(devlist{k,:},attr{k,:});    
    if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        fprintf(1,'TracyServer Error %s\n',devlist{k,:})
        return;
    end
    attr_prop(k) = {attr_config.(property)}; 
end

attr_prop = attr_prop(:);

if DoubleFlag 
    attr_prop = str2num(char(attr_prop));
end