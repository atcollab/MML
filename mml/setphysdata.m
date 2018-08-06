function setphysdata(varargin)
%SETPHYSDATA - Set physics data
%  For vector inputs:
%  setphysdata(Family, Field, Data, DeviceList)
%  setphysdata(Family, Field, Data)
%
%  For structure inputs:
%  setphysdata(DataStruct, Field)   % Family, Data, and DeviceList are in DataStruct
%  setphysdata(Family, DataStruct)  % DataStruct is the entire family structure
%  setphysdata(DataStruct)          % DataStruct is the entire Physics Data Structure
%
%  INPUTS
%  1. Family = Family name (or first field name in the physdata structure)
%  2. Field  = Field  name ('Offset', 'Gain', 'Golden', etc)
%  3. Data = New data values
%  4. DeviceList = Device list for that family
%         or 
%  1. DataStruct = .FamilyName, .DeviceList, and .Data fields are used if they exist
%                  or DataStruct is saved according to the Field/Family
%  2. Field = Field name ('Offset', 'Gain', 'Golden', etc)
%
%  NOTE
%  1. If Data is a cell array, then Family, Field, and DeviceList must also be a cell arrays.
%  2. If the family or field does not exist, then it will be created!
%     When a new field is created a message will be printed to the screen.
%
%  EXAMPLES
%  1. To set the offset orbit for BPM(3,2) to 1.234
%     setphysdata('BPMx', 'Offset', 1.234, [3 2]);
%
%  NOTE: MML creators are phasing out the use of physdata.
%
%  Written by Greg Portmann


% ArchiveFlag is a backup to DataRoot\PhysData
ArchiveFlag = 1;    

% Look for keywords on the input line
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'NoArchive')
        ArchiveFlag = 0;    
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Archive')
        ArchiveFlag = 1;    
        varargin(i) = [];
    end
end

% setphysdata(Family, Field, Data, DeviceList)
if length(varargin) == 0
    error('At least one input required');
end
if length(varargin) >= 1
    Family = varargin{1};
end
if length(varargin) >= 2
    Field = varargin{2};
end
if length(varargin) >= 3
    Data = varargin{3};
end
if length(varargin) >= 4
    DeviceList = varargin{4};
else
    DeviceList = [];
end

%%%%%%%%%%%%%%%%%%%%
% Cell array input %
%%%%%%%%%%%%%%%%%%%%
if iscell(Family)
    if length(varargin) < 2
        error('For cell array inputs, Data and Family must exist');
    end
    if ~iscell(Family)
        error('If Data is a cell array, then Family must be a cell array.');
    end        
    if length(Family) ~= length(Data)
        error('Data and Family must be the same size cell arrays');
    end
    if length(varargin) >= 3
        if ~iscell(Field)
            error('If Data is a cell array, then Field must be a cell array.');
        end        
        if length(Family) ~= length(Field)
            error('Data and Field must be the same size cell arrays');
        end
    end    
    if length(varargin) >= 4
        if ~iscell(DeviceList)
            error('If Data is a cell array, then DeviceList must be a cell array.');
        end        
        if length(Family) ~= length(DeviceList)
            error('Data and DeviceList must be the same size cell arrays');
        end
    end    
    for i = 1:length(Data)
        if length(varargin) == 2
            setphysdata(Family{i}, Field{i});
        elseif length(varargin) == 3
            setphysdata(Family{i}, Field{i}, Data{i});
        else
            setphysdata(Family{i}, Field{i}, Data{i}, DeviceList{i});
        end
    end
    return    
end  % End cell inputs


%%%%%%%%%%%%%%%%
% Set the data %
%%%%%%%%%%%%%%%%

if length(varargin) == 1
    if isstruct(Family)
        PhysData = Family;
        fprintf('   WARNING: The entire Physics Data Structure will be written over!');
        savephysdatalocal(PhysData, ArchiveFlag);
    else
        error('For 1 input, the Data input must be the entire Physics Data Structure');
    end
    return;
end


% Get the entire structure
PhysData = getphysdata;


if isstruct(Family)
    if isfield(Family, 'FamilyName')
        % setphysdata(DataStruct, Field)
        DeviceList = Family.DeviceList;
        Data = Family.Data;
        Family = Family.FamilyName;
    else
        error('When using setphysdata(DataStruct, Field), DataStruct must have .FamilyName, .Data, .DeviceList fields');
    end
elseif isstruct(Field)
    % setphysdata(Family, Data)
    % The data is in the field input
    if ~isfield(PhysData, Family)
        fprintf('   %s family will be created in the Physics Data Structure', Family);
    end
    PhysData.(Family) = Field;  
    savephysdatalocal(PhysData, ArchiveFlag);
    return
else
    if length(varargin) == 2
        error('The Physics Data Structure for a family should be a structure');
    end
    if length(varargin) == 3
        DeviceList = [];
    end
end
if isempty(DeviceList)
    try
        DeviceList = getlist(Family, 0);
    catch
        % Not a family.  Set the entire field
        if length(varargin) ~= 3
            error('When not using a family the number of inputs must be 3 (Family, Field, Data)');
        end
        DataOld = PhysData.(Family).(Field);
        if any(size(DataOld) ~= size(Data))
            fprintf('\n   WARNING:  Data is not part of a family and length of old data does not match the length of the new data.\n');
            fprintf('             If that is not ok, hopefully you saved a backup file\n\n');
        end
        PhysData.(Family).(Field) = Data;
        savephysdatalocal(PhysData, ArchiveFlag);
        return
    end
end


% If Data is a structure, then use the Data and DeviceList field
if isstruct(Data)
    if length(varargin) >= 4
        fprintf('WARNING: Input DeviceList ignored.  Using the DeviceList in the data structure.');
    end
    if isfield(Data, 'DeviceList')
        DeviceList = Data.DeviceList;
    else
        DeviceList = Data.Monitor.DeviceList;
    end
    Data = Data.Data;
end

if ~isfield(PhysData, Family)
    fprintf('   %s family, %s field will be created in the Physics Data Structure', Family, Field);
    PhysData.(Family) = [];
else
    if ~isfield(PhysData.(Family), Field)
        fprintf('   %s field will be created in the %s family in the Physics Data Structure', Field, Family);
        PhysData.(Family).(Field) = [];
    end
end

if size(DeviceList,2) == 1
    DeviceList = elem2dev(Family, DeviceList);
end


DeviceListTotal = getlist(Family, 0);

[i, iNotFound] = findrowindex(DeviceList, DeviceListTotal);  
if ~isempty(iNotFound)
    error('Device not found in the family');
end

% Save data as a vector using the entire family (or change the device list in the structure?)
if isfield(PhysData.(Family).(Field), 'DeviceList')
    % A data structure was stored.  Convert it to an entire family list.
    j = findrowindex(PhysData.(Family).(Field).DeviceList, DeviceListTotal);  
    DataTotal = NaN * ones(size(DeviceListTotal,1), size(PhysData.(Family).(Field).Data,2));
    DataTotal(j,:) = PhysData.(Family).(Field).Data;
    
    % Fill the new data to the structure
    DataTotal(i,:) = Data;
    PhysData.(Family).(Field).Data = DataTotal;
    PhysData.(Family).(Field).DeviceList = DeviceListTotal;
    if isfield(PhysData.(Family).(Field),'Status')
        % Status isn't relevant
        PhysData.(Family).(Field) = rmfield(PhysData.(Family).(Field),'Status');
    end
elseif isfield(PhysData.(Family).(Field), 'Monitor')
    % A data structure was stored.  Convert it to an entire family list.
    j = findrowindex(PhysData.(Family).(Field).Monitor.DeviceList, DeviceListTotal);  
    DataTotal = NaN * ones(size(DeviceListTotal,1), size(PhysData.(Family).(Field).Data,2));
    DataTotal(j,:) = PhysData.(Family).(Field).Data;
    
    % Fill the new data to the structure
    DataTotal(i,:) = Data;
    PhysData.(Family).(Field).Data = DataTotal;
    PhysData.(Family).(Field).DeviceList = DeviceListTotal;
    if isfield(PhysData.(Family).(Field),'Status')
        % Status isn't relevant
        PhysData.(Family).(Field) = rmfield(PhysData.(Family).(Field),'Status');
    end
else
    % Fill the new data
    DataTotal = PhysData.(Family).(Field);
    DataTotal(i,:) = Data;
    PhysData.(Family).(Field) = DataTotal;
end    


% if length(i) == size(Data,1)
%     DataVec = getphysdata(Family, Field);
%     DataVec(i) = Data;
%     PhysData.(Family).(Field) = DataVec;  
% elseif length(Data) == 1
%     PhysData.(Family).(Field) = Data;  
% else
%     error('The number of elements in the input data vector does not match the DeviceList');
% end


savephysdatalocal(PhysData, ArchiveFlag);



function savephysdatalocal(PhysData, ArchiveFlag)

% Physics data is saved in this file
FileName = getfamilydata('OpsData','PhysDataFile');

%FileName = [getfamilydata('Directory','OpsData') getfamilydata('OpsData','PhysDataFile')];

%Machine = lower(getfamilydata('Machine'));
%FileName = which([Machine, 'physdata','.mat']);

if ArchiveFlag
    tmp = questdlg({...
            sprintf('%s', FileName), ...
            'is where many important parameters are saved to operate', ...
            'this machine.  A backup of this file will be made first.  However, ', ...
            'Are you sure you want to change the Physics Data Structure?'},...
        'SETPHYSDATA','YES','NO','NO');
else
    tmp = questdlg({...
            sprintf('%s', FileName), ...
            'is where many important parameters are saved to operate', ...
            'this machine.  You are about to change this file without a backup!', ...
            'Are you sure you want to change the Physics Data Structure?'},...
        'SETPHYSDATA','YES','NO','NO');
end
if ~strcmpi(tmp,'YES')
    fprintf('   No change made to the Physics Data Structure\n');
    return
end

if ArchiveFlag
    % Save a backup first
    DirStart = pwd;
    %DirectoryBackUp = getfamilydata('Directory','DataRoot'); 
    %DirectoryBackUp = fullfile(DirectoryBackUp,'PhysData');
    DirectoryBackUp = [getfamilydata('Directory','DataRoot'), 'Backup', filesep];

    %FileNameBackUp = appendtimestamp('Physdata');
    FileNameBackUp  = prependtimestamp('Physdata');

    [DirectoryBackUp, DirectoryErrorFlag] = gotodirectory(DirectoryBackUp);            
    save(FileNameBackUp, 'PhysData');
    fprintf('   Physics Data Structure backup to  %s\n', [pwd, filesep, FileNameBackUp]);
    cd(DirStart);
    if DirectoryErrorFlag
        fprintf('   WARNING: The PhysData file was saved, but it did not go the desired directory!\n            Look in %s\n', DirectoryBackUp);
    end
end

save(FileName, 'PhysData');    
fprintf('   Physics Data Structure updated in %s\n', FileName);
