function Data = getgolden(varargin)
%GETGOLDEN - Returns the golden values for a family
%  Golden = getgolden(Family, Field, DeviceList)
%  Golden = getgolden(Family, DeviceList)
%  Golden = getgolden(Family)
%
%  INPUTS
%  1. Family - Family Name
%              Data Structure
%              Accelerator Object
%  2. Field - Accelerator Object field name ('Monitor', 'Setpoint', etc) {Default: 'Monitor' for BPM, 'Setpoint' for magnet}
%  3. DeviceList ([Sector Device #] or [element #]) {Default: whole family}
%  4. 'Physics'  - Use physics  units (optional override of units)
%     'Hardware' - Use hardware units (optional override of units)
%  5. 'Struct'  - Return a data structure
%     'Numeric' - Return numeric outputs  {Default}
%     'Object'  - Return a accelerator object (AccObj)
%
%  OUTPUTS
%  1. Golden - Golden value for the family {Default: []}
%              For magnets, then production lattice configuration is returned.
%
%  NOTES
%  1. If Family is a cell array, then DeviceList can also be a cell arrays
%  2. The golden orbit must be stored in hardware units.
%
%  See also getfamilydata, getoffset

%  Written by Greg Portmann



%%%%%%%%%%%%%%%%%
% Input Parsing %
%%%%%%%%%%%%%%%%%
UnitsFlagCell = {};
StructOutputFlag = 0;
ObjectOutputFlag = 0;
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        StructOutputFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        StructOutputFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model') || strcmpi(varargin{i},'Online') || strcmpi(varargin{i},'Manual')
        % Remove and ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'physics')
        UnitsFlagCell = {'Physics'};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlagCell = {'Hardware'};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Object')
        ObjectOutputFlag = 1;
        StructOutputFlag = 1;
        varargin(i) = [];
    end
end

if isempty(varargin)
    error('Must have at least a family name input');
end


%%%%%%%%%%%%%%
% Cell input %
%%%%%%%%%%%%%%
if iscell(varargin{1})
    for i = 1:length(varargin{1})
        if length(varargin) < 2
            Data{i} = getgolden(varargin{1}{i}, UnitsFlagCell{:});
        elseif length(varargin) < 3
            if iscell(varargin{2})
                Data{i} = getgolden(varargin{1}{i}, varargin{2}{i}, UnitsFlagCell{:});
            else
                Data{i} = getgolden(varargin{1}{i}, varargin{2}, UnitsFlagCell{:});
            end
        else
            if iscell(varargin{3})
                Data{i} = getgolden(varargin{1}{i}, varargin{2}{i}, varargin{3}{i}, UnitsFlagCell{:});
            else
                Data{i} = getgolden(varargin{1}{i}, varargin{2}{i}, varargin{3}, UnitsFlagCell{:});
            end
        end
    end
    return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parse Family, Field, DeviceList %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Family, Field, DeviceList, UnitsFlag] = inputparsingffd(varargin{:});


% Units flag
if isempty(UnitsFlagCell)
    % For structure inputs, use the units in the structure (from inputparsingffd)
    % Else, get the default family value
    if isempty(UnitsFlag)
        UnitsFlag = getunits(Family);
    end
else
    % Input override has priority
    UnitsFlag = UnitsFlagCell{1};
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Chromaticity Exception %
%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(Family, 'CHRO') || strcmpi(Family, 'Chromaticity')
    if isempty(DeviceList)
        DeviceList = [1 1;1 2];
    end

    % 1. Try the AO and AD
    Data = getfamilydata('Chromaticity', 'Golden');
    if isempty(Data)
        Data = getfamilydata('CHRO', 'Golden');
    end
    if isempty(Data)
        Data = getfamilydata('Chromaticity', Field, 'Golden');
    end
    if isempty(Data)
        Data = getfamilydata('CHRO', Field, 'Golden');
    end

    % 2. Then look in PhysData
    if isempty(Data)
        try
            Data = getphysdata('CHRO', 'Golden');
        catch
            try
                Data = getphysdata('Chromaticity', 'Golden');
            catch
                Data = [];
            end
        end
    end

    i = findrowindex(DeviceList, [1 1;1 2]);
    Data = Data(i);

    % Change to hardware units if requested
    if strcmpi(UnitsFlag,'Hardware')
        Data = -1 * Data / getrf / getmcf;
    end
    return
end


% Default device list
if isempty(DeviceList)
    DeviceList = family2dev(Family);
end

% Convert element list to a device list
if (size(DeviceList,2) == 1)
    DeviceList = elem2dev(Family, DeviceList);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check DeviceList or Family is a common name list %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Family, DeviceList] = checkforcommonnames(Family, DeviceList);


% Default Field
if isempty(Field)
    if ismemberof(Family,'BPM') || ismemberof(Family,'TUNE') || strcmpi(Family, 'TUNE')
        Field = 'Monitor';
    else
        Field = 'Setpoint';
    end
end




%%%%%%%%%%%%
% Get data %
%%%%%%%%%%%%

% 1. Try the AO and AD
Data = getfamilydata(Family, Field, 'Golden', DeviceList);
if isempty(Data) && (strcmp(Field, 'Monitor') || strcmp(Field, 'Setpoint'))
    Data = getfamilydata(Family, 'Golden', DeviceList);
end


% 2. Look in the MachineConfig if the Family is a member of 'MachineConfig' (ie, golden magnet settings)
if isempty(Data)
    try
        if ismemberof(Family, 'Save/Restore') || ismemberof(Family, Field, 'Save/Restore') || ismemberof(Family, 'Save') || ismemberof(Family, Field, 'Save') || ismemberof(Family, 'MachineConfig') || ismemberof(Family, Field, 'MachineConfig')
            % Get the production file name (full path)
            % AD.OpsData.LatticeFile could have the full path else default to AD.Directory.OpsData
            %FileName = getfamilydata('OpsData','LatticeFile');
            %[DirectoryName, FileName, Ext, VerNumber] = fileparts(FileName);
            %if isempty(DirectoryName)
            %    DirectoryName = getfamilydata('Directory', 'OpsData');
            %end
            %FileName = fullfile(DirectoryName,[FileName, '.mat']);
            %load(FileName);
            [ConfigSetpoint, ConfigMonitor, FileName] = getproductionlattice;
            
            % Look in ConfigSetpoint
            NotFound = 1;
            if isfield(ConfigSetpoint, Family)
                if isfield(ConfigSetpoint.(Family), 'Data')
                    % Old style machine config file
                    Data = ConfigSetpoint.(Family);
                    NotFound = 0;
                else
                    % New style machine config file
                    if isfield(ConfigSetpoint.(Family), Field)
                        if isfield(ConfigSetpoint.(Family).(Field), 'Data')
                            Data = ConfigSetpoint.(Family).(Field);
                            NotFound = 0;
                        end
                    end
                end
            end

            % Look in ConfigMonitor
            if NotFound
                if isfield(ConfigMonitor, Family)
                    if isfield(ConfigMonitor.(Family), 'Data')
                        % Old style machine config file
                        Data = ConfigMonitor.(Family);
                        NotFound = 0;
                    else
                        % New style machine config file
                        if isfield(ConfigMonitor.(Family), Field)
                            if isfield(ConfigMonitor.(Family).(Field), 'Data')
                                Data = ConfigMonitor.(Family).(Field);
                                NotFound = 0;
                                %else
                                %   error(sprintf('%s.%s.Data not found in machineconfig',Family, Field));
                            end
                            %else
                            %   error(sprintf('%s.%s family not found in machineconfig',Family, Field));
                        end
                    end
                    %else
                    %   error(sprintf('%s family not found in machineconfig',Family));
                end
            end

            if ~NotFound
                [i, iNotFound] = findrowindex(DeviceList, Data.DeviceList);
                Data.Data = Data.Data(i);
                for i = 1:length(iNotFound)
                    Data.Data   = [Data.Data(1:iNotFound(i)-1); NaN;  Data.Data(iNotFound(i):end)];
                    Data.Status = [Data.Status(1:iNotFound(i)-1); 0;  Data.Status(iNotFound(i):end)];
                end
                Data.DeviceList = DeviceList;
            end
        end
    catch
    end
end


% 3. Look in PhysData
if isempty(Data)
    try
        Data = getphysdata(Family, Field, 'Golden', DeviceList);
    catch
    end
end
if isempty(Data) && (strcmp(Field, 'Monitor') || strcmp(Field, 'Setpoint'))
    try
        Data = getphysdata(Family, 'Golden', DeviceList);
    catch
    end
end



% Default golden
if isempty(Data)
    Data = NaN * zeros(size(DeviceList,1),1);
end


% Needs to be numeric at this point
if isstruct(Data)
    Data = Data.Data;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change to physics units if requested %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(UnitsFlag,'Physics')
    Data = hw2physics(Family, Field, Data, DeviceList);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Return a data structure if requested %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if StructOutputFlag
    DataNumeric = Data;
    if isempty(UnitsFlag)
        Data = family2datastruct(Family, Field, DeviceList);
    else
        Data = family2datastruct(Family, Field, DeviceList, UnitsFlag);
    end
    Data.Data = DataNumeric;
    Data.DataDescriptor = sprintf('%s.%s Golden', Family, Field);
    Data.CreatedBy = 'getgolden';

    % Make the output an AccObj object
    if ObjectOutputFlag
        Data = AccObj(Data);
    end
end
