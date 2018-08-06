function [S, FileName] = getrespmat(varargin)
%GETRESPMAT - Get response matrix data from a file
%  For Family, DeviceList inputs:
%  [S, FileName] = getrespmat(MonitorFamily, MonitorDeviceList, ActuatorFamily, ActuatorDeviceList, FileName, GeV)
%
%  For structure inputs:
%  [S, FileName] = getrespmat(MonitorStruct, ActuatorStruct, FileName, GeV)
%
%  INPUTS
%  1. MonitorFamily  (or substitute MonitorStruct  for MonitorFamily  and MonitorDeviceList)
%  2. MonitorDeviceList  {Default: return everything in the file}
%  3. ActuatorFamily (or substitute ActuatorStruct for ActuatorFamily and ActuatorDeviceList)
%  4. ActuatorDeviceList  {Default: return everything in the file}
%     (Inputs 1-4 can be cell arrays)
%  5. FileName - File name for response matrix (or cell array of file names) {Default: use AD.OpsData.RespFiles}
%                [] or '' - prompt the user to choose a response matrix file
%  6. GeV is the energy that the response matrix will be used at {Default or []: getenergy}.
%     It's not always desirable to scale by the energy, so the following keywords can be used.
%     'EnergyScaling' - Scale the response matrix by energy (getenergy / measured energy) {Default}
%     'NoEnergyScaling' - Don't scale with energy
%  7. 'Struct'  will return the response matrix structure {default for data structure inputs}
%     'Numeric' will return a numeric matrix {default for non-data structure inputs}
%
%  OUTPUTS
%  1. S - the response matrix, empty if not found
%  2. FileName - filename where the response matrix was found
%
%  NOTES
%  1. If the DeviceList is empty, [], or not present, all the device in that response matrix will be returned.
%     This is different from most functions that return everything in family (family2dev).
%  2. For Chromacity:  MonitorFamily = 'Chromaticity' and DeviceList = [1 1;1 2]
%  3. For Tune:  MonitorFamily = 'TUNE' and DeviceList = [1 1;1 2]
%  4. AccObj objects are converted to cell arrays.
%
%  EXAMPLES
%  1. Get a BPM response matrix 
%     S = getrespmat('BPMx', [1 1;1 2; 1 3], 'HCM', [1 1;2 1;2 3;4 1]);
%
%  2. Get a BPM response matrix but return as a structure 
%     S = getrespmat('BPMx', [1 1;1 2; 1 3], 'HCM', [1 1;2 1;2 3;4 1],'struct');
%
%  3. Get a 2x2 response matrix, form the coupled response matrix, and plot
%     S = getrespmat({'BPMx','BPMy'}, {'HCM','VCM'});
%     mesh(S);
%
%  4. Structure inputs:
%     Ymon = gety([1 1;1 2; 1 3],'struct'); 
%     Yact = getsp('VCM', [1 1;2 1;2 2;4 1],'struct');
%     S = getrespmat(Ymon, Yact);
%     Returns the same matrix as in Example 1.
%
%  See also getbpmresp, gettuneresp, getchroresp, getdata

%  Written by Greg Portmann


if length(varargin) < 2
    error('getrespmat must have at least a Monitor input and a Actuator input');
end


% Defaults
StructOutputFlag = 0;
NumericOutputFlag = 0;
EnergyScalingFlag = 1;
ChangeUnitsFlag = '';
MonitorDeviceList = [];
ActuatorDeviceList = [];
GeVGoal = [];

% Look for input flags
InputFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif isa(varargin{i},'AccObj')
        AccObj1 = struct(varargin{i});
        Families = fieldnames(AccObj1);
        j = 0;
        for k = 1:length(Families)
            if ~isempty(AccObj1.(Families{k}))
                j = j + 1;
                tmpcell{j} = AccObj1.(Families{k});
            end
        end
        %if length(tmpcell) == 1
        %    varargin{i} = tmpcell{1};
        %else
            varargin{i} = tmpcell;
        %end
        
        if ~StructOutputFlag
            NumericOutputFlag = 1;
        end
    elseif strcmpi(varargin{i},'Struct')
        StructOutputFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Numeric')
        NumericOutputFlag = 1;
        StructOutputFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Simulator')
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Model')
        fprintf('WARNING: ''Model'' input ignored use measbpmresp(''Model'') (getrespmat)');
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Physics')
        ChangeUnitsFlag = 'Physics';
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Hardware')
        ChangeUnitsFlag = 'Hardware';
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'EnergyScaling')
        EnergyScalingFlag = 1;
        GeVGoal = [];
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoEnergyScaling')
        EnergyScalingFlag = 0;
        GeVGoal = 'NoEnergyScaling';
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    end
end


% Cell array inputs
if iscell(varargin{1})
    % All remaining inputs except filename must be a cell array
    if ~iscell(varargin{2})
        error('Input 2 must also be a cell or an AccObj');
    end
    
    Ncell = 0;
    for i = 1:length(varargin)
        if iscell(varargin{i})
            Ncell = Ncell + 1;
        end
    end
    
    MonitorCell = varargin{1};
    MonitorDeviceListCell = [];
    ActuatorDeviceCell = [];
    if Ncell == 2
        ActuatorCell = varargin{2};
    elseif Ncell >= 3
        MonitorDeviceListCell = varargin{2};
        ActuatorCell = varargin{3};
    end
    if Ncell >= 4
        ActuatorDeviceCell = varargin{4};
    end
    
    % Remove the cell inputs from varargin
    for i = 1:Ncell
        varargin(1) = [];
    end 
    
    if isempty(MonitorDeviceListCell)
        for i = 1:length(MonitorCell)
            MonitorDeviceListCell{i} = [];
        end
    end
    if isempty(ActuatorDeviceCell)
        for i = 1:length(ActuatorCell)
            ActuatorDeviceCell{i} = [];
        end
    end
    
    % Force column for monitors and rows for actuators
    MonitorCell = MonitorCell(:);
    MonitorDeviceListCell = MonitorDeviceListCell(:);
    ActuatorCell = ActuatorCell(:)';
    ActuatorDeviceCell = ActuatorDeviceCell(:)';
    
    if isstruct(MonitorCell{1})
        if ~NumericOutputFlag
            StructOutputFlag = 1; % Only change StructOutputFlag if 'Numeric' is not on the input line
        end
    end
    
    % Main cell array loop
    for i = 1:length(MonitorCell)
        for j = 1:length(ActuatorCell)
            if isempty(MonitorDeviceListCell{i})
                [Smat, FileName] = getrespmat(MonitorCell{i}, ActuatorCell{j}, ActuatorDeviceCell{j}, 'Struct', InputFlags{:}, varargin{:});
            elseif isempty(MonitorDeviceListCell{i}) && isempty(ActuatorDeviceCell{i})
                [Smat, FileName] = getrespmat(MonitorCell{i}, ActuatorCell{j}, 'Struct', InputFlags{:}, varargin{:});
            elseif isempty(ActuatorDeviceCell{j})
                [Smat, FileName] = getrespmat(MonitorCell{i}, MonitorDeviceListCell{i}, ActuatorCell{j}, 'Struct', InputFlags{:}, varargin{:});
            else
                [Smat, FileName] = getrespmat(MonitorCell{i}, MonitorDeviceListCell{i}, ActuatorCell{j}, ActuatorDeviceCell{j}, 'Struct', InputFlags{:}, varargin{:});
            end
            if isempty(Smat)
                S = [];
                return;
            else
                S(i,j) = Smat;
            end
        end    
    end    
    
    if ~StructOutputFlag
        Smat = [];
        for i = 1:length(MonitorCell)
            SmatRow = [];
            for j = 1:length(ActuatorCell)
                SmatRow = [SmatRow S(i,j).Data];
            end
            Smat = [Smat; SmatRow];
        end
        S = Smat;
    end
    
    return
end % Cell Input


%%%%%%%%%%%%%%%%%%%%%%%%%
% Parse Non-cell Inputs %
%%%%%%%%%%%%%%%%%%%%%%%%%

% Look for Monitor family info (string or structure)
if length(varargin) >= 1
    if isstruct(varargin{1})
        MonitorFamilyString = varargin{1}.FamilyName;
        MonitorDeviceList = varargin{1}.DeviceList;

        % For structure inputs, units are determined the BPM input (unless there was an override)
        if isempty(ChangeUnitsFlag)
            ChangeUnitsFlag = varargin{1}.Units;
        end

        % Only change StructOutputFlag if 'Numeric' is not on the input line
        if ~NumericOutputFlag
            StructOutputFlag = 1;
        end
        varargin(1) = [];
    elseif ischar(varargin{1})
        MonitorFamilyString = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                MonitorDeviceList = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        MonitorDeviceList = varargin{1};
        varargin(1) = [];
    end
end

% Look for Actuator family info (string or structure)
if length(varargin) >= 1
    if isstruct(varargin{1})
        ActuatorFamilyString = varargin{1}.FamilyName;
        ActuatorDeviceList = varargin{1}.DeviceList;

        % For structure inputs, units are determined the first input
        if isempty(ChangeUnitsFlag)
            ChangeUnitsFlag = varargin{1}.Units;
        end

        if ~NumericOutputFlag
            StructOutputFlag = 1; % Only change StructOutputFlag if 'Numeric' is not on the input line
        end
        varargin(1) = [];
    elseif ischar(varargin{1})
        ActuatorFamilyString = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                ActuatorDeviceList = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        ActuatorDeviceList = varargin{1};
        varargin(1) = [];
    end
end

if isempty(MonitorFamilyString) || isempty(ActuatorFamilyString)
    S = [];
    return
end

if length(varargin) >= 1 && ischar(varargin{1})
        FileName = varargin{1};
        varargin(1) = [];
else
    FileName = getfamilydata('OpsData','RespFiles');
end
if length(varargin) >= 1
    GeVGoal = varargin{1};
end

if isempty(FileName)
    FileName = getfamilydata('OpsData', 'RespFiles');
    FilePromptFlag = 1;
else    
    FilePromptFlag = 0;
end


% Force ResponseMatrixFiles to be a cell
if iscell(FileName)
    ResponseMatrixFiles = FileName;
else
    ResponseMatrixFiles = {FileName};
end

Found = 0;
for i = 1:length(ResponseMatrixFiles)
    %   try
    % FileStruct is a structure of all the variable inside ResponseMatrixFiles
    
    if exist([ResponseMatrixFiles{i}],'file') || exist([ResponseMatrixFiles{i} '.mat'],'file')
        FileStruct = load(ResponseMatrixFiles{i});
        
        % VarCell is a cell array of the field names of FileStruct
        VarCell = fieldnames(FileStruct);   % who('-file', ResponseMatrixFiles{i});
        
        for j = 1:length(VarCell)
            % OneField is one of the fields of FileStruct
            OneField = FileStruct.(VarCell{j});
            
            % Look through all the variable to find a structure with Monitor, Actuator, and Data fields
            for ii = 1:size(OneField,1)
                for jj = 1:size(OneField,2)
                    
                    if iscell(OneField)
                        
                        % If OneField is a cell
                        OneCell = OneField{ii,jj};
                        for mm = 1:size(OneCell,1)
                            for nn = 1:size(OneCell,2)
                                % If OneCell is an array, look through OneCell to find a structure with Monitor, Actuator, and Data 
                                if isfield(OneCell(mm,nn),'Monitor') && isfield(OneCell(mm,nn),'Actuator') && isfield(OneCell(mm,nn),'Data')
                                    if isfield(OneCell(mm,nn).Monitor,'FamilyName') && isfield(OneCell(mm,nn).Actuator,'FamilyName')
                                        % Look for Monitor.FamilyName == MonitorFamilyString
                                        if strcmp(OneCell(mm,nn).Monitor.FamilyName, MonitorFamilyString)
                                            % Look for Actuator.FamilyName == ActuatorFamilyString
                                            if strcmp(OneCell(mm,nn).Actuator.FamilyName, ActuatorFamilyString)
                                                S = OneCell(mm,nn);
                                                %S = OneCell(mm,nn).Data;
                                                
                                                if isfield(OneCell(mm,nn).Monitor,'DeviceList')
                                                    % Monitor field could be a data structure
                                                    MonitorDeviceListTotal  = OneCell(mm,nn).Monitor.DeviceList;
                                                else
                                                    % Monitor field could be another response matrix structure (like chromaticity)
                                                    MonitorDeviceListTotal  = OneCell(mm,nn).Monitor.Monitor.DeviceList;
                                                end
                                                
                                                ActuatorDeviceListTotal = OneCell(mm,nn).Actuator.DeviceList;
                                                Found = 1;
                                                if FilePromptFlag
                                                    % Ask if found file is OK to use
                                                    if strcmpi(ResponseMatrixFiles{i}(end-3:end),'.mat')
                                                        [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat', 'Select a Response Matrix File', [ResponseMatrixFiles{i}]);
                                                    else
                                                        [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat', 'Select a Response Matrix File', [ResponseMatrixFiles{i} '.mat']);
                                                    end
                                                    if FilterIndex == 0
                                                        fprintf('   Warning: No response matrix loaded\n');
                                                        S=[]; FileName=[];
                                                        return
                                                    end
                                                    if StructOutputFlag
                                                        [S, FileName] = getrespmat(MonitorFamilyString, MonitorDeviceList, ActuatorFamilyString, ActuatorDeviceList, [DirectoryName FileName], GeVGoal, 'struct');
                                                    else
                                                        [S, FileName] = getrespmat(MonitorFamilyString, MonitorDeviceList, ActuatorFamilyString, ActuatorDeviceList, [DirectoryName FileName], GeVGoal);
                                                    end
                                                    return    
                                                end
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        
                    else
                        
                        % If OneField is an array, look through OneField to find a structure with Monitor, Actuator, and Data 
                        if isfield(OneField(ii,jj),'Monitor') && isfield(OneField(ii,jj),'Actuator') && isfield(OneField(ii,jj),'Data')
                            % Look for Monitor.FamilyName == MonitorFamilyString
                            if isfield(OneField(ii,jj).Monitor,'FamilyName') && isfield(OneField(ii,jj).Actuator,'FamilyName')
                                if strcmp(OneField(ii,jj).Monitor.FamilyName, MonitorFamilyString)
                                    % Look for Actuator.FamilyName == ActuatorFamilyString
                                    if strcmp(OneField(ii,jj).Actuator.FamilyName, ActuatorFamilyString)
                                        S = OneField(ii,jj);
                                        %S = OneField(ii,jj).Data;
                                        
                                        if isfield(OneField(ii,jj).Monitor,'DeviceList')
                                            % Monitor field could be a data structure
                                            MonitorDeviceListTotal = OneField(ii,jj).Monitor.DeviceList;
                                        else
                                            % Monitor field could be another response matrix structure (like chromaticity)
                                            MonitorDeviceListTotal = OneField(ii,jj).Monitor.Monitor.DeviceList;
                                        end
                                        
                                        ActuatorDeviceListTotal = OneField(ii,jj).Actuator.DeviceList;
                                        Found = 1;
                                        if FilePromptFlag
                                            % Ask if found file is OK to use
                                            if strcmpi(ResponseMatrixFiles{i}(end-3:end),'.mat')
                                                [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat', 'Select a Response Matrix File', [ResponseMatrixFiles{i}]);
                                            else
                                                [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat', 'Select a Response Matrix File', [ResponseMatrixFiles{i} '.mat']);
                                            end
                                            if FilterIndex == 0
                                                fprintf('   Warning: No response matrix loaded\n');
                                                S=[]; FileName=[];
                                                return
                                            end
                                            if StructOutputFlag
                                                [S, FileName] = getrespmat(MonitorFamilyString, MonitorDeviceList, ActuatorFamilyString, ActuatorDeviceList, [DirectoryName FileName], GeVGoal, 'struct');
                                            else
                                                [S, FileName] = getrespmat(MonitorFamilyString, MonitorDeviceList, ActuatorFamilyString, ActuatorDeviceList, [DirectoryName FileName], GeVGoal);
                                            end
                                            return    
                                        end                                        
                                        break
                                    end
                                end
                            end
                        end
                        
                    end
                    
                end
                if Found
                    break;
                end
            end
            if Found
                break;
            end
            
        end
        %     catch
        %         fprintf('   Warning: Response matrix file could not be found\n');
        %         S=[]; FileName=[];
        %         return
        %     end
        if Found
            break;
        end
    end
    if Found
        break;
    end
end

if ~Found
    if FilePromptFlag
        % Ask if found file is OK to use
        [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat', 'Select a Response Matrix File');
        if FilterIndex == 0
            fprintf('   Warning: No response matrix loaded\n');
            S=[]; FileName=[];
            return
        end
        if StructOutputFlag
            [S, FileName] = getrespmat(MonitorFamilyString, MonitorDeviceList, ActuatorFamilyString, ActuatorDeviceList, [DirectoryName FileName], GeVGoal, 'struct');
        else
            [S, FileName] = getrespmat(MonitorFamilyString, MonitorDeviceList, ActuatorFamilyString, ActuatorDeviceList, [DirectoryName FileName], GeVGoal);
        end
        return
    else
        error('Could not find the proper response matrix');
    end
end


FileName = ResponseMatrixFiles{i};
%fprintf('   %s response matrix file was created on %s.\n', FileName, datestr(datenum(S.TimeStamp)));


% Scale the response matrix to the present energy (If it's in Hardware units.  Physics units don't get scaled.)
if EnergyScalingFlag
    if isfield(S, 'Units')
        if strcmpi(S.Units,'Hardware')
            if isempty(GeVGoal)
                try
                    GeVGoal = getenergy;  % bend2gev
                catch
                    GeVGoal = getfamilydata('Energy');
                    fprintf('   Error in getrespmat using getenergy, using getfamilydata(''Energy'') = %f in it''s place.\n', GeVGoal);
                end
            end
            if abs(S.GeV-GeVGoal)>1e-3 && ~isnan(S.GeV) && ~isnan(GeVGoal)
                if ~strcmpi(ChangeUnitsFlag,'Physics')
                    % Don't scale if in physics units
                    %S.Data = S.GeV * S.Data / GeVGoal;
                    %S.GeV = GeVGoal;
                    %fprintf('   Response matrix scaled to %.3f GeV using R(%.3f) = %.3f * R(%.3f) / %.3f\n', GeVGoal, GeVGoal, S.GeV, S.GeV, GeVGoal);
                    
                    % Convert to physics (no energy change) only to convert back with an energy change
                    % These will account of nonlinearities in the magnetics fields (hysteresis)
                    S = hw2physics(S);
                    S = physics2hw(S, GeVGoal);
                    %fprintf('   Response matrix scaled from %.3f GeV to %.3f GeV\n', GeVGoal, S.GeV);
                end
            end
        end
    end
else
    GeVGoal = S.GeV;
end


if strcmpi(ChangeUnitsFlag,'Physics')
    S = hw2physics(S, GeVGoal);
elseif strcmpi(ChangeUnitsFlag,'Hardware')
    S = physics2hw(S, GeVGoal);
else
    % Check for default units
    if strcmpi(getunits(S.Monitor.FamilyName),'Hardware') && strcmpi(S.Units,'Physics')
        S = physics2hw(S, GeVGoal);
    elseif strcmpi(getunits(S.Monitor.FamilyName),'Physics') && strcmpi(S.Units,'Hardware')
        S = hw2physics(S, GeVGoal);
    end
end


% Index the response matrix
if isempty(ActuatorDeviceList)
    % Return what is in the response matrix file
    ActuatorDeviceList = S.Actuator.DeviceList;
    
    % Return all good status
    %ActuatorDeviceList = family2dev(S.Actuator.FamilyName);
elseif size(ActuatorDeviceList,2) == 1
    % Convert element list to a device list
    ActuatorDeviceList = elem2dev(S.Actuator.FamilyName, ActuatorDeviceList);
end

if isempty(MonitorDeviceList)
    % Return what is in the response matrix file
    MonitorDeviceList = S.Monitor.DeviceList;
    
    % Return all good status
    MonitorDeviceList = family2dev(S.Monitor.FamilyName);
elseif size(MonitorDeviceList,2) == 1
    % Convert element list to a device list 
    MonitorDeviceList = elem2dev(S.Monitor.FamilyName, MonitorDeviceList);
end

[MonitorIndex, iNotFound, iMonitor] = findrowindex(MonitorDeviceList,  MonitorDeviceListTotal);

if ~isempty(iNotFound)
    % Error if a monitor is not found
    %for i = iNotFound(:)'
    %    fprintf('   %s(%d,%d) not found\n', S.Monitor.FamilyName, MonitorDeviceList(i,1), MonitorDeviceList(i,2));
    %end
    %error('Monitor not found');
    
    % Fill the missing data with NaN
    Data = NaN * ones(size(MonitorDeviceList,1), size(S.Data,2));
    Data(iMonitor,:) = S.Data(MonitorIndex,:);
    S.Data = Data;
    
    % Fill the missing .Monitor with NaN
    Data = NaN * ones(size(MonitorDeviceList,1),1);
    Data(iMonitor) = S.Monitor.Data(MonitorIndex);
    S.Monitor.Data = Data;
    S.Monitor.DeviceList = MonitorDeviceList;

    % Fill the missing .Status with zeros
    if isfield(S.Monitor, 'Status')
        Data = zeros(size(MonitorDeviceList,1),1);
        Data(iMonitor) = S.Monitor.Status(MonitorIndex);
        S.Monitor.Status = Data;
    end
    
    % Fill the missing .Monitor.DataTime with NaN
    if isfield(S.Monitor, 'DataTime')
        Data = NaN * zeros(size(MonitorDeviceList,1),1);
        Data(iMonitor) = S.Monitor.DataTime(MonitorIndex);
        S.Monitor.DataTime = Data;
    end

    % Fill the missing .Monitor1 with NaN
    if isfield(S, 'Monitor1')
        Data = NaN * ones(size(MonitorDeviceList,1),size(S.Monitor1,2));
        Data(iMonitor,:) = S.Monitor1(MonitorIndex,:);
        S.Monitor1 = Data;
    end
    
    % Fill the missing .Monitor2 with NaN
    if isfield(S, 'Monitor2')
        Data = NaN * ones(size(MonitorDeviceList,1),size(S.Monitor2,2));
        Data(iMonitor,:) = S.Monitor2(MonitorIndex,:);
        S.Monitor2 = Data;
    end
else    
    % Index down the monitors if necessary
    S.Data = S.Data(MonitorIndex, :);
    S.Monitor.Data = S.Monitor.Data(MonitorIndex, :);
    S.Monitor.DeviceList = MonitorDeviceList;
    if isfield(S.Monitor, 'Status') && length(S.Monitor.Status) > 1
        S.Monitor.Status = S.Monitor.Status(MonitorIndex, :);
    end
    if isfield(S.Monitor, 'DataTime') && length(S.Monitor.DataTime) > 1
        S.Monitor.DataTime = S.Monitor.DataTime(MonitorIndex);
    end
    if isfield(S, 'Monitor1') && size(S.Monitor1,1) > 1
        S.Monitor1 = S.Monitor1(MonitorIndex, :);
    end
    if isfield(S, 'Monitor2') && size(S.Monitor2,1) > 1
        S.Monitor2 = S.Monitor2(MonitorIndex, :);
    end
end

[ActuatorIndex, iNotFound, iActuator] = findrowindex(ActuatorDeviceList, ActuatorDeviceListTotal);


% First fill in the missing data, then index
if ~isempty(iNotFound)
    % Error if a Actuator is not found
    %for i = iNotFound(:)'
    %    fprintf('   %s(%d,%d) not found\n', S.Actuator.FamilyName, ActuatorDeviceList(i,1), ActuatorDeviceList(i,2));
    %end
    %error('Actuator not found');
    
    % Fill the missing .Data with NaN
    Data = NaN * ones(size(MonitorDeviceList,1), size(ActuatorDeviceList,1));
    Data(:, iActuator) = S.Data(:,ActuatorIndex);
    S.Data = Data;
    
    % Fill the missing .Actuator with NaN
    Data = NaN * ones(size(ActuatorDeviceList,1),1);
    Data(iActuator) = S.Actuator.Data(ActuatorIndex);
    S.Actuator.Data = Data;
    S.Actuator.DeviceList = ActuatorDeviceList;

    % Fill the missing .ActuatorDelta with NaN
    if isfield(S, 'ActuatorDelta')
        Data = NaN * zeros(size(ActuatorDeviceList,1),1);
        Data(iActuator) = S.ActuatorDelta(ActuatorIndex);
        S.ActuatorDelta = Data;
    end

    % Fill the missing .Status with zeros
    if isfield(S.Actuator, 'Status')
        Data = zeros(size(ActuatorDeviceList,1),1);
        Data(iActuator) = S.Actuator.Status(ActuatorIndex);
        S.Actuator.Status = Data;
    end

    % Fill the missing .Actuator.DataTime with NaN
    if isfield(S.Actuator, 'DataTime')
        Data = NaN * zeros(size(ActuatorDeviceList,1),1);
        Data(iActuator) = S.Actuator.DataTime(ActuatorIndex);
        S.Actuator.DataTime = Data;
    end

    % Fill the missing .Monitor1 with NaN
    if isfield(S, 'Monitor1')
        Data = NaN * ones(size(MonitorDeviceList,1), size(ActuatorDeviceList,1));
        Data(:, iActuator) = S.Monitor1(:,ActuatorIndex);
        S.Monitor1 = Data;
    end

    % Fill the missing .Monitor2 with NaN
    if isfield(S, 'Monitor2')
        Data = NaN * ones(size(MonitorDeviceList,1), size(ActuatorDeviceList,1));
        Data(:, iActuator) = S.Monitor2(:,ActuatorIndex);
        S.Monitor2 = Data;
    end
else
    % Index down the actuator index if necessary
    S.Data = S.Data(:, ActuatorIndex);
    S.Actuator.Data = S.Actuator.Data(ActuatorIndex);
    S.Actuator.DeviceList = ActuatorDeviceList;
    if isfield(S, 'ActuatorDelta') && length(S.ActuatorDelta) > 1
        S.ActuatorDelta = S.ActuatorDelta(ActuatorIndex);
    end
    if isfield(S.Actuator, 'Status') && length(S.Actuator.Status) > 1
        S.Actuator.Status = S.Actuator.Status(ActuatorIndex);
    end    
    if isfield(S.Actuator, 'DataTime') && length(S.Actuator.DataTime) > 1
        S.Actuator.DataTime = S.Actuator.DataTime(ActuatorIndex);
    end
    try
        if isfield(S, 'Monitor1') && size(S.Monitor1,2) > 1
            S.Monitor1 = S.Monitor1(:, ActuatorIndex);
        end
        if isfield(S, 'Monitor2') && size(S.Monitor2,2) > 1
            S.Monitor2 = S.Monitor2(:, ActuatorIndex);
        end
    catch
        % Monitor1 & Monitor1 are the wrong size, probably due to summing (like to tunes)
        fprintf('   Response matrix Monitor1 or Monitor2 are the wrong size.\n');
    end
end


if StructOutputFlag    
    S.FileName = FileName;
else
    S = S.Data;
end




