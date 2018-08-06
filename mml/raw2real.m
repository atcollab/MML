function DataOut = raw2real(varargin)
%RAW2REAL - Converts raw control system data to calibrated values
%  RealData = raw2real(Family, Field, RawData, DeviceList)
%  RealData = raw2real(DataStruct)
%
%  INPUTS
%  1. Family - Family Name
%     DataStruct - Data Structure  (.FamilyName, .Field, and .DeviceList fields are used if not input)
%  2. RawData - Raw control system data
%  3. DeviceList - Device list for that family
%  4. Flag
%     'Absolute' - Include the offset  {Default (unless it's a response matrix)}
%     'Incremental' - Gain only        {Response matrices are incremental only}
%     'Numeric' - forces numeric output for structure inputs      
%
%  OUTPUTS
%  1. RealData - Calibrated data
%     RealData = Gain .* (RawData - Offset)
% 
%  ALGORITHM
%     RawData  = (RealData ./ Gain) + Offset
%     RealData = Gain .* (RawData - Offset)
%
%  NOTES
%  1. If the input is a structure, then the output will be a structure
%  2. If the inputs are cell arrays, then the output is a cell array
%  3. If Family is a cell array, then all other inputs must be cell arrays
%  4. The Offset is always in hardware units.
%
%  See also real2raw, physics2hw, hw2physics, getoffset, getgain, getgolden

%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%
% Input parsing %
%%%%%%%%%%%%%%%%%
UnitsFlag = '';
NumericFlag = [];
IncrementalFlag = {};
InputFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        NumericFlag = 0;
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        NumericFlag = 1;
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Incremental')
        IncrementalFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Absolute')
        IncrementalFlag = varargin(i);
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model') || strcmpi(varargin{i},'Online') || strcmpi(varargin{i},'Manual')
        % Remove and ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'physics')
        fprintf('   WARNING: ''Physics'' flag ignored by raw2real\n');
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        fprintf('   WARNING: ''Hardware'' flag ignored by raw2real\n');
        varargin(i) = [];
    end
end


if isempty(varargin)
    error('Must have at least 1 input for structures and 3 for non-structures.');
else
    Family = varargin{1};
    if length(varargin) >= 2
        Field = varargin{2};
    end
    if length(varargin) >= 3
        DataIn = varargin{3};
    end
    if length(varargin) >= 4
        DeviceList = varargin{4};
    end
end


%%%%%%%%%%%%%%%%%%%%
% Cell Array Input %
%%%%%%%%%%%%%%%%%%%%
if iscell(Family)
    if length(varargin) >= 2
        if ~iscell(DataIn)
            error('If Family is a cell array, then RawData must be a cell array.');
        end        
        if length(Family) ~= length(DataIn)
            error('RawData and Family must be the same size cell arrays');
        end
    end
    if length(varargin) >= 3
        if ~iscell(DeviceList)
            error('If Family is a cell array, then DeviceList must be a cell array.');
        end        
        if length(Family) ~= length(DeviceList)
            error('Family and DeviceList must be the same size cell arrays');
        end
    end 
    for i = 1:length(Family)
        if length(varargin) == 1
            DataOut{i} = raw2real(Family{i}, InputFlags{:});
        elseif length(varargin) == 2
            DataOut{i} = raw2real(Family{i}, Field{i}, InputFlags{:});
        elseif length(varargin) == 3
            DataOut{i} = raw2real(Family{i}, Field{i}, DataIn{i}, InputFlags{:});
        else
            DataOut{i} = raw2real(Family{i}, Field{i}, DataIn{i}, DeviceList{i}, InputFlags{:});
        end
    end
    return    
end  
% End cell inputs



%%%%%%%%%%%%%%%%%%%%
% Structure Inputs %
%%%%%%%%%%%%%%%%%%%%
if isstruct(Family)
    % Convert entire data structure
    DataOut = Family;
        
    for j = 1:size(DataOut,1)
        for k = 1:size(DataOut,2)
            
            if isfield(DataOut(j,k),'Monitor') && isfield(DataOut(j,k),'Actuator')
                % Response matrix structure
                
                if strcmpi(IncrementalFlag, 'Absolute') && j==1 && k==1
                    fprintf('   WARNING:  ''Absolute'' flag passed to raw2real for a response matrix.  Flag ignored!');
                end
                
                % Incrementally scale rows by Monitor and Columns by Actuators
                DataOut(j,k).Data = raw2real(DataOut(j,k).Monitor.FamilyName, DataOut(j,k).Monitor.Field, DataOut(j,k).Data, DataOut(j,k).Monitor.DeviceList, 'Incremental');
                DataOut(j,k).Data = raw2real(DataOut(j,k).Actuator.FamilyName, DataOut(j,k).Actuator.Field, DataOut(j,k).Data', DataOut(j,k).Actuator.DeviceList, 'Incremental')';
                
                DataOut(j,k).Monitor  = raw2real(DataOut(j,k).Monitor,  'Absolute'); 
                DataOut(j,k).Actuator = raw2real(DataOut(j,k).Actuator, 'Absolute');
                if isfield(DataOut(j,k), 'ActuatorDelta')
                    DataOut(j,k).ActuatorDelta = raw2real(DataOut(j,k).Actuator.FamilyName, DataOut(j,k).Actuator.Field, DataOut(j,k).ActuatorDelta, [1 1], 'Incremental');
                end
                                
            elseif isfield(DataOut(j,k),'FamilyName') && isfield(DataOut(j,k),'Field')
                % Data structure
                DataOut(j,k).Data = raw2real(DataOut(j,k).FamilyName, DataOut(j,k).Field, DataOut(j,k).Data, DataOut(j,k).DeviceList, IncrementalFlag{:});
                
            else
                error('Unknown data structure type');
            end
            
            if isfield(DataOut(j,k), 'CreatedBy')
                DataOut(j,k).CreatedBy = ['raw2real,', DataOut(j,k).CreatedBy];
            end
        end
    end
    
    % Make numeric if requested 
    if ~isempty(NumericFlag) && NumericFlag == 1
        DataOutNew = [];
        for j = 1:size(DataOut,1)
            OutCol = [];
            for k = 1:size(DataOut,2)
                OutCol = [OutCol DataOut(j,k).Data];
            end
            DataOutNew = [DataOutNew; OutCol];
        end
        DataOut = DataOutNew;
    end
    
    return;
end


%%%%%%%%%%%%%%%%%
% Main Function %
%%%%%%%%%%%%%%%%%

% Family string input
FamilyName = Family;
if length(varargin) < 3
    error('No RawData input');
end
if length(varargin) < 4
    DeviceList = [];
end
if isempty(IncrementalFlag)
    IncrementalFlag = 'Absolute';
end


% Defaults
if isempty(Field)
    if ismember(FamilyName,'BPM')
        Field = 'Monitor';
    else
        Field = 'Setpoint';
    end
end
if isempty(DeviceList)
    DeviceList = family2dev(FamilyName);
end
if (size(DeviceList,2) == 1) 
    DeviceList = elem2dev(FamilyName, DeviceList);
end


%%%%%%%%%%%%%%%%%%%%
% Convert the data %
%%%%%%%%%%%%%%%%%%%%

% First look for a special function to do the conversion
FunctionHandle = getfamilydata(Family, Field, 'Raw2RealFcn');
if ~isempty(FunctionHandle)
    DataOut = feval(FunctionHandle, Family, Field, DataIn, DeviceList);
else
    % Use the Gain/Offset conversion
    Gain = getgain(FamilyName, Field, DeviceList);
    if strcmpi(IncrementalFlag, 'Incremental')
        Offset = 0;
    else
        Offset = getoffset(FamilyName, Field, DeviceList, 'Hardware');
    end


    for i = 1:size(DataIn,2)
        DataOut(:,i) = Gain .* (DataIn(:,i) - Offset);
    end

    %raw2real:  DataOut(:,i) = Gain .* (DataIn(:,i) - Offset);
    %real2raw:  DataOut(:,i) = (DataIn(:,i) ./ Gain) + Offset;
end


