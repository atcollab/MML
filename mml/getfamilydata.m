function [Data, ErrorFlag] = getfamilydata(Family, Field1, Field2, DeviceList)
%GETFAMILYDATA - Gets data associated with the accelerator control 
%
%  When getting data from the accelerator object (AO):
%  [Data, ErrorFlag] = getfamilydata(Family, Field1, Field2, DeviceList)
%  [Data, ErrorFlag] = getfamilydata(Family, Field1, DeviceList)
%  [Data, ErrorFlag] = getfamilydata(Family, Field1)
%  [Data, ErrorFlag] = getfamilydata(Family)
%  [Data, ErrorFlag] = getfamilydata
%
%  When getting data from the accelerator data stucture (AD):
%  [Data, ErrorFlag] = getfamilydata(Field1)
%  [Data, ErrorFlag] = getfamilydata(Field1, Field2)
%  [Data, ErrorFlag] = getfamilydata(Field1, Field2, Field3)
%  [Data, ErrorFlag] = getfamilydata(Field1, Field2, Field3, Field4)
%
%  INPUTS
%  1. Family = Family Name
%              Data Structure (only the FamilyName is used)
%              Field
%              Accelerator Object
%  2. Field1 = Field name (string)
%  3. Field2 = Field name (string)
%  4. DeviceList = Device list for that family
%
%  OUTPUT
%  1. Data = AO.Field1.Field2  or  AD.Field1.Field2.Field3.Field4
%     Looks for Family in the accelerator data structure and returns the appropriate data. 
%
%     If DeviceList is not an input, then the exact contents of the field is returned
%     If DeviceList exists, then Data is indexed according to DeviceList
%     If DeviceList is empty, [], then the entire DeviceList is returned
%     If DeviceList is empty, [], and the field is one row (or cell) then Data is expanded
%                                 to the size of the entire DeviceList
%                     
%     Returns [] if the data could not be found
%
%  2. ErrorFlag = 1 if the data could not be found
%
%  NOTE
%  1. If the inputs are cell arrays, then the output is a cell array
%  2. If Family is a cell array, then DeviceList must also be a cell array,
%     however, Field1 or Field2 can either be a cell array array or a string.
%
%  EXAMPLES
%  1. getfamilydata('BPMx')
%  2. getfamilydata('BPMx','Monitor')
%  3. getfamilydata('BPMx','Monitor','Units')
%  4. getfamilydata('HCOR', 'Status')
%
%  See also setfamilydata

%  Written by Greg Portmann


if nargin == 0
    Data = getappdata(0, 'AcceleratorObjects');
    return
end

% Cell array input
if iscell(Family)
    if nargin >= 2
        if iscell(Field1)
            if length(Family) ~= length(Field1)
                error('If Field1 is a cell array, then it must be the same size as Family.');
            end
        end
    end
    if nargin >= 3
        if iscell(Field2)
            if length(Family) ~= length(Field2)
                error('If Field2 is a cell array, then it must be the same size as Family.');
            end
        end
    end
    if nargin >= 4
        if ~iscell(DeviceList)
            error('If family is a cell array, then DeviceList must be a cell array.');
        end
        if length(Family) ~= length(DeviceList)
            error('Family and DeviceList must be the same size cell arrays.');
        end
    end
    
    for i = 1:length(Family)
        if nargin == 1
            [Data{i}, ErrorFlag{i}] = getfamilydata(Family{i});
        elseif nargin == 2
            if iscell(Field1)
                [Data{i}, ErrorFlag{i}] = getfamilydata(Family{i}, Field1{i});
            else
                [Data{i}, ErrorFlag{i}] = getfamilydata(Family{i}, Field1);
            end
        elseif nargin == 3
            if iscell(Field1)
                if iscell(Field2)
                    [Data{i}, ErrorFlag{i}] = getfamilydata(Family{i}, Field1{i}, Field2{i});
                else
                    [Data{i}, ErrorFlag{i}] = getfamilydata(Family{i}, Field1{i}, Field2);
                end                
            else
                if iscell(Field2)
                    [Data{i}, ErrorFlag{i}] = getfamilydata(Family{i}, Field1, Field2{i});
                else
                    [Data{i}, ErrorFlag{i}] = getfamilydata(Family{i}, Field1, Field2);
                end                
            end
        else
            if iscell(Field1)
                if iscell(Field2)
                    [Data{i}, ErrorFlag{i}] = getfamilydata(Family{i}, Field1{i}, Field2{i}, DeviceList{i});
                else
                    [Data{i}, ErrorFlag{i}] = getfamilydata(Family{i}, Field1{i}, Field2, DeviceList{i});
                end                
            else
                if iscell(Field2)
                    [Data{i}, ErrorFlag{i}] = getfamilydata(Family{i}, Field1, Field2{i}, DeviceList{i});
                else
                    [Data{i}, ErrorFlag{i}] = getfamilydata(Family{i}, Field1, Field2, DeviceList{i});
                end                
            end
        end
    end
    return    
end  % End cell inputs


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Non-cell getfamilydata %
%%%%%%%%%%%%%%%%%%%%%%%%%%
ErrorFlag = 0;

[FamilyIndex, AO] = isfamily(Family);
if FamilyIndex
    if nargin == 1
        Data = AO;
        return
    end
else
    % Check the AD
    AD = getad;
    if isfield(AD, Family)
        Data = AD.(Family);
    else
        Data = [];
        ErrorFlag = 1;    
        return
    end  
    if nargin > 1
        if isfield(Data, Field1)
            Data = Data.(Field1);
        else
            Data = [];
            ErrorFlag = 1;    
        end
    end
    if nargin > 2
        if isfield(Data, Field2)
            Data = Data.(Field2);
        else
            Data = [];
            ErrorFlag = 1;    
        end
    end
    return
end


% Select field1
if isfield(AO, Field1)
    Data = AO.(Field1);
else
    Data = [];
    ErrorFlag = 1;
    return
end
if nargin == 2
    return
end

% Select field2 or field2 maybe a devicelist
if nargin == 3
    if ischar(Field2)
        if isfield(Data, Field2)
            Data = Data.(Field2); 
        else
            Data = [];
            ErrorFlag = 1;
        end
        return
    else
        DeviceList = Field2;
    end
end

% Select field2
if nargin >= 4
    if isfield(Data, Field2)
        Data = Data.(Field2); 
    else
        Data = [];
        ErrorFlag = 1;
        return
    end
end


% If you made it to here, DeviceList must exist
if isempty(DeviceList)
    DeviceList = family2dev(Family);
end
if (size(DeviceList,2) == 1) 
    DeviceList = elem2dev(Family, DeviceList);
end

if isfield(AO, Field1) && isfield(AO.(Field1), 'DeviceList')
    DeviceListTotal = AO.(Field1).DeviceList;
else
    DeviceListTotal = AO.DeviceList;
    %DeviceListTotal = family2dev(Family, 0);  % Speed or recursive?
end
        
if iscell(Data)
    if size(Data,1) == 1
        % For each cell array determine what rows needs to be altered
        for i = 1:size(Data,2)
            Data{i} = sortdatabydevicelist(Data{i}, DeviceList, DeviceListTotal);
        end
        return
    elseif size(Data,1) == size(DeviceListTotal,1)
        % Cell matrix is Ok (but not recommended)
    else
        error(sprintf('Number of rows in AO field must be 1 or equal to the number of rows in AO{}.DeviceList.'));
    end
elseif isstruct(Data)
    error('Structure AO fields can not be indexed by a DeviceList.');    
end

Data = sortdatabydevicelist(Data, DeviceList, DeviceListTotal);


function Data = sortdatabydevicelist(Data, DeviceList, DeviceListTotal)

% Data should be equal to the number of row in DeviceListTotal or be one row
if size(DeviceListTotal,1) ~= size(Data,1)
    if size(Data,1) == 1
        % All the rows of output data will be the same
        if iscell(Data)
            % This will make a cell matrix which we decided not a allow 
            fprintf('   When using a 1 row cell array, Instead of using a cell matrix, use a cell row.\n')
            error('Cell matrix error')
            
            % Repeat the 1 row Data cell array as many times as in the rows of DeviceListTotal 
            Data1 = Data;
            Data = cell(size(DeviceList,1), size(Data1,2));
            for i = 1:size(Data1,2)
                Data(:,i) = Data1(1,i);
            end            
        elseif ischar(Data)
            % Repeat the one row string as many times as in the rows of DeviceListTotal 
            DataStr = Data;
            Data = [];
            for i = 1:size(DeviceList,1)
                Data = [Data; DataStr];
            end 
        else
            % Repeat the one row Data vector as many times as in the rows of DeviceListTotal 
            Data = ones(size(DeviceList,1),1) * Data;
        end
    else
        error(sprintf('Number of rows in AO field must be 1 or equal to the number of rows in AO{}.DeviceList.'));
    end
    
    return
end


[DeviceIndex, iNotFound] = findrowindex(DeviceList, DeviceListTotal);
if ~isempty(iNotFound)
    ErrorFlag = 1;
    for i = 1:length(iNotFound)
        fprintf('   Can''t find (%d,%d) device in DeviceList.\n', DeviceList(iNotFound(i),1), DeviceList(iNotFound(i),2));
    end
    error(sprintf('%d Devices not found', length(iNotFound)));
end


Data = Data(DeviceIndex,:);






% % Intersect removes duplicate devices so first store index of how to unsort in j_unique 
% DeviceListOld = DeviceList;
% [DeviceList, i_unique, j_unique] = unique(DeviceList, 'rows');        
% 
% % Find the indexes in the full device list (reorder and remove duplicates)
% [DeviceList, ii, DeviceIndex] = intersect(DeviceList, DeviceListTotal, 'rows');
% if size(DeviceList,1) ~= size(DeviceListOld,1)
%     % All devices must exist (duplicate devices ok)
%     [DeviceListNotFound, iNotFound] = setdiff(DeviceListOld, DeviceListTotal, 'rows');
%     if length(iNotFound) > 0
%         % Device not found
%         for i = 1:length(iNotFound)
%             fprintf('   No devices to get for Family %s(%d,%d)\n', AO.FamilyName, DeviceListNotFound(i,1), DeviceListNotFound(i,2));
%         end
%         error(sprintf('%d Devices not found', length(iNotFound)));
%     end
% end
% 
% % DataType='vector' only has one FamilyName and handle for a multiple element DeviceList
% % Hence, Data could have one row for a many rowed DeviceList.  To deal with this only index 
% % by DeviceIndex if Data has more than one row.  
% if size(Data,1) > 1
%     Data = Data(DeviceIndex,:);     % Only data referenced to DeviceList
%     Data = Data(j_unique,:);        % Reorder and add multiple elements back
% end
