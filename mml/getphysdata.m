function [Data, iNotFound] = getphysdata(Family, Field, DeviceList)
%GETPHYSDATA - Gets physics data
%  Data = getphysdata(Family, Field, DeviceList)
%  Data = getphysdata(Family, Field)
%  Data = getphysdata(DataStruct, Field)
%  Data = getphysdata(Family)
%  Data = getphysdata
%
%  INPUTS
%  1. Family = Family name
%  2. Field  = Field  name ('Offset', 'Gain', etc)
%  3. DeviceList = Device list for that family
%         or 
%  1. DataStruct = Data structure (.FamilyName and .DeviceList fields are used, 
%                                  unless DeviceList is an input)
%  2. Field = Field name ('Offset', 'Gain', etc)
%
%  OUTPUT
%  1. Data = Physics data
%
%  NOTES
%  1. If the inputs are cell arrays, then the output is a cell array
%  2. If Family is a cell array, then DeviceList must also be a cell array,
%     however, Field can either be a cell array array or a string.
%  3. If DeviceList is not an input, then the exact contents of the field is returned
%     If DeviceList exists, then Data is indexed according to DeviceList (vector output)
%     If DeviceList is empty, [], then the entire DeviceList is returned
%  4. MML creators are phasing out the use of physdata.
%
%
%  EXAMPLES
%  1. getphysdata: return full structure
%  2. getphysdata('BPMx')
%  3. getphysdata('BPMx','golden')
%  4. getphysdata(getx('Struct'),'Golden') returns a structure 
%
%  See also setphysdata

%  Written by Greg Portmann



if nargin == 0
    Data = getphysdatalocal;
    return
end


%%%%%%%%%%%%%%%%%%%%
% Cell array input %
%%%%%%%%%%%%%%%%%%%%
if iscell(Family)
    if nargin >= 2
        if iscell(Field)
            if length(Family) ~= length(Field)
                error('If Field is a cell array, then it must be the same size as Family.');
            end
        end
    end    
    for i = 1:length(Family)
        if nargin == 1
            Data{i} = getphysdata(Family{i});
        elseif nargin == 2
            if iscell(Field)
                Data{i} = getphysdata(Family{i}, Field{i});
            else
                Data{i} = getphysdata(Family{i}, Field);
            end
        else
            if iscell(Field)
                if iscell(DeviceList)
                    Data{i} = getphysdata(Family{i}, Field{i}, DeviceList{i});
                else
                    Data{i} = getphysdata(Family{i}, Field{i}, DeviceList);
                end                
            else
                if iscell(DeviceList)
                    Data{i} = getphysdata(Family{i}, Field, DeviceList{i});
                else
                    Data{i} = getphysdata(Family{i}, Field, DeviceList);
                end                
            end
        end
    end
    return    
end  % End cell inputs


%%%%%%%%%%%%%%%%
% Get the data %
%%%%%%%%%%%%%%%%

% Load a full PhysData structure
DataStruct = getphysdatalocal;

if nargin == 1
    if isstruct(Family)
        Family = Family.FamilyName;
    end
    if isfield(DataStruct, Family)
        Data = DataStruct.(Family);
    else
        error(sprintf('%s family not found in the Physics Data Structure', Family));
    end
    return
end

if isstruct(Family)
    % Structure case 
    if nargin < 3
        % Only override the DeviceList if it is not input
        if isfield(Family, 'DeviceList')
            DeviceList = Family.DeviceList;
        else
            DeviceList = Family.Monitor.DeviceList;
        end
    end
    Family = Family.FamilyName;
    StructFlag = 1;
else
    if nargin < 3
        DeviceList = [];
    end
    StructFlag = 0;
end
if isempty(DeviceList)
    try
        DeviceList = getlist(Family);
    catch
        % Not a family.  Return whatever is there.
    end
end

Data = DataStruct.(Family);

if isfield(DataStruct.(Family), Field)
    Data = DataStruct.(Family).(Field);  
    
    if isstruct(Data)
        % Data structure is in the data field of PhysData
        if nargin < 3 && StructFlag==1
            % Return the entire structure
            [i, iNotFound] = findrowindex(DeviceList, Data.DeviceList);  
            Data.Data = Data.Data(i);
            Data.DeviceList = Data.DeviceList(i);
            if isfield(Data,'Status')
                if size(Data.Status,1) == size(Data.DeviceList,1)
                    Data.Status = Data.Status(i);
                end
            end
            return
        else
            % Return the indexed data
            if isfield(Data, 'DeviceList')
                % Data structure
                DeviceListTotal = Data.DeviceList;
                Data = Data.Data;
            elseif isfield(Data, 'Monitor')
                if isfield(Data.Monitor, 'DeviceList')
                    % Response matrix structure (or dispersion)
                    DeviceListTotal = Data.Monitor.DeviceList;
                    Data = Data.Data;
                else
                    error('Not sure how to index the data structure');
                end
            else
                error('Not sure how to index the data structure');
            end
        end
        
    elseif isempty(DeviceList)
        return
    else
        % All data must be stored including bad devices or as a structure
        DeviceListTotal = family2dev(Family,0);
    end
    
    % Data vector was saved
    if length(Data) == 1
        % Repeat the one row Data vector as many times as in the rows of DeviceListTotal 
        Data = ones(size(DeviceList,1),1) * Data;
    else
        [i, iNotFound] = findrowindex(DeviceList, DeviceListTotal);  
        Data = Data(i,:);

        if ~isempty(iNotFound)
            for i = 1:length(iNotFound)
                fprintf('   Can''t find %s.%s(%d,%d) in the family DeviceList.\n', Family, Field, DeviceList(iNotFound(i),1), DeviceList(iNotFound(i),2));
            end
            %error(sprintf('%d Devices not found', length(iNotFound)));
            fprintf('   Missing data replaced with NaN.\n');
            for j = 1:length(iNotFound)
                if iNotFound(j) == 1
                    Data = [NaN*ones(1,size(Data,2)); Data(1:end,:)];
                else
                    Data = [Data(1:iNotFound(j)-1,:); NaN*ones(1,size(Data,2)); Data(iNotFound(j):end,:)];
                end
            end
        end

    end
else
    error(sprintf('%s family, %s field not found in the Physics Data Structure', Family, Field));
end



%%%%%%%%%%%%%%%
% Subfunction %
%%%%%%%%%%%%%%%

function Data = getphysdatalocal

% Physics data is saved in this file
FileName = getfamilydata('OpsData','PhysDataFile');

%FileName = [getfamilydata('Directory','OpsData') getfamilydata('OpsData','PhysDataFile')];

%Machine = lower(getfamilydata('Machine'));
%FileName = which([Machine, 'physdata','.mat']);

%tmp = load([DirectoryName FileName]);
tmp = load(FileName);

fname = fieldnames(tmp);
if length(fname) == 1
    Data = tmp.(fname{1});
else
    try
        Data = tmp.('PhysData');
    catch
        error('More than 2 variables exist in the calibration file %s, and PhysData is not one of them', FileName);
    end
end

