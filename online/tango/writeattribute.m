function ErrorFlag = writeattribute(tangolist,val,varargin)
%WRITEATTRIBUTE - Writes a list of TANGO attributes
% writeattribute(tangolist,val,type)
%
% INPUTS
% 1. tangolist - list of tango attributes eg 'ANS-C01/DGsim/BPM.1/X'
% 2. val - vector of tango setpoint values
%
% OPTIONAL
% 3. type - datatype {double by default}, int16
% 4. 'QueryDB' - Look for attribute typ in DB before writing attribute
%
% OUTPUTS
% 1. ErrorFlag
%
% See also readattribute

%
% Written by Laurent S. Nadolski


QueryFlag = 0; % query attribute type  in DB

for i = length(varargin):-1:1
    if strcmpi(varargin{i},'QueryDB')
        QueryFlag = 1;
        varargin(i) = [];
    end
end

[attribute device]  = getattribute(tangolist);

for k = 1:size(attribute,1)

    if QueryFlag == 0

        if nargin < 3
            tango_write_attribute(device{k},attribute{k},val(k));
        else
            switch lower(varargin{1})
                case 'int16'
                    tango_write_attribute(device{k},attribute{k},int16(val(k)));
                case 'int32'
                    tango_write_attribute(device{k},attribute{k},int32(val(k)));
                case 'double'
                    tango_write_attribute(device{k},attribute{k},val(k,:));
                case 'string'
                    % Type char
                    tango_write_attribute(device{k},attribute{k},char(val(k,:)));
                    % OK pour mode
                    %              tango_write_attribute(device{k},attribute{k},val{k});
                case {'1-by-1 uint16','uint8'} %DEV_BOOLEAN
                    tango_write_attribute(device{k},attribute{k},uint8(val(k,:)));
                otherwise
                    error('wrong format')
            end
        end

    else % Look for attribute type in Tango DB

        AttrDesc = tango_attribute_query(device{k},attribute{k});

        switch AttrDesc.data_type_str
            case '1-by-1 double'
                tango_write_attribute(device{k},attribute{k}, str2double(val(k,:)));
            case '1-by-n char'  % DEV_DOUBLE DEV_STRING
                tango_write_attribute(device{k},attribute{k},char(val(k,:)));
            case '1-by-1 int32' % DEV_LONG
                tango_write_attribute(device{k},attribute{k},int32(str2double(val(k,:))));
            case '1-by-1 int16' % DEV_SHORT
                tango_write_attribute(device{k},attribute{k},int16(val(k)));
            case '1-by-1 uint16' % DEV_BOOLEAN
                tango_write_attribute(device{k},attribute{k},uint8(val(k)));
            otherwise
                disp('Do Nothing')
        end
    end

    if (tango_error == -1)
        %- handle error
        tango_print_error_stack;
        error('writeattribute for device');
        return;
    end
end