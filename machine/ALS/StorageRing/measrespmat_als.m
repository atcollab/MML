function S = measrespmat(varargin)
%MEASRESPMAT - Measure a response matrix
%
%  For family name, device list inputs:
%  S = measrespmat(MonitorFamily, MonitorDeviceList, ActuatorFamily, ActuatorDeviceList, ActuatorDelta, ModulationMethod, WaitFlag, ExtraDelay)
%
%  For data structure inputs: 
%  S = measrespmat(MonitorStruct, ActuatorStruct, ActuatorDelta, ModulationMethod, WaitFlag, ExtraDelay)
%
%  INPUTS
%  1. MonitorFamily       - AcceleratorObjects family name for monitors
%     MonitorDeviceList   - AcceleratorObjects device list for monitors (element or device)
%                           (MonitorFamily and MonitorDeviceList can be cell arrays)
%     or 
%     MonitorStruct can replace MonitorFamily and MonitorDeviceList
%
%  2. ActuatorFamily      - AcceleratorObjects family name for actuators
%     ActuatorDeviceList  - AcceleratorObjects device list for actuators (element or device)
%     or 
%     ActuatorStruct can replace ActuatorFamily and ActuatorDeviceList
%
%  3. ActuatorDelta    - Change in actuator {Default: getfamilydata('ActuatorFamily','Setpoint','DeltaRespMat')}
%  4. ModulationMethod - Method for changing the ActuatorFamily
%                       'bipolar' changes the ActuatorFamily by +/- ActuatorDelta/2 on each step {Default}
%                       'unipolar' changes the ActuatorFamily from 0 to ActuatorDelta on each step
%  5. WaitFlag - (see setpv for WaitFlag definitions) {Default: []}
%                WaitFlag = -5 will override gets to manual mode
%
%  6. ExtraDelay - Extra time delay [seconds] after a setpoint change
%
%  7. 'Struct'  - Output will be a response matrix structure {Default for data structure inputs}
%     'Numeric' - Output will be a numeric matrix            {Default for non-data structure inputs}
%
%  8. Optional override of the units:
%     'Physics'  - Use physics  units
%     'Hardware' - Use hardware units
%
%  9. Optional override of the mode:
%     'Online' - Set/Get data online  
%     'Model'  - Set/Get data on the model (same as 'Simulator')
%     'Manual' - Set/Get data manually
%
%  10. 'Display'    - Prints status information to the command window {Default}
%      'NoDisplay'  - Nothing is printed to the command window
%
%  OUTPUTS
%  1. S = Response matrix
%
%     For stucture outputs:
%     S(Monitor, Actuator).Data - Response matrix
%                         .Monitor - Monitor data structure (starting orbit)
%                         .Monitor1 - First  data point matrix
%                         .Monitor2 - Second data point matrix
%                         .Actuator - Corrector data structure
%                         .ActuatorDelta - Corrector kick vector
%                         .GeV - Electron beam energy
%                         .ModulationMethod - 'unipolar' or 'bipolar'
%                         .WaitFlag - Wait flag used when acquiring data
%                         .ExtraDelay - Extra time delay 
%                         .TimeStamp - Matlab clock at the start of each actuator family
%                         .CreatedBy
%                         .DCCT
%
%  NOTES
%  1. If MonitorFamily and MonitorDeviceList are cell arrrays, then S is a cell array of response matrices.
%  2. ActuatorFamily, ActuatorDeviceList, ActuatorDelta, ModulationMethod, WaitFlag are not cell arrrays.
%  3. If ActuatorDeviceList is empty, then the entire family is change together.
%  4. Bipolar mode changes the actuator by +/- ActuatorDelta/2
%  5. Unipolar mode changes the actuator by ActuatorDelta
%  6. Return values are MonitorChange/ActuatorDelta (normalized)
%  7. When using cell array inputs don't mix structure data inputs with non-structure data
%
%  EXAMPLES
%  1. 2x2 tune response matrix for QF and QD families:
%     TuneRmatrix = [measrespmat('TUNE',[1;2],'QF',[],.5,'unipolar') ... 
%                    measrespmat('TUNE',[1;2],'QD',[],.5,'unipolar')];
%
%  2. Orbit response matrix for all the horizontal correctors (+/-1 kick amplitude):
%     Smat = measrespmat({'BPMx','BPMy'}, {getlist('BPMx'),getlist('BPMy')}, 'HCM', ...
%                                          getlist('HCM'),1,'bipolar',-2);
%     The output is stored in a cell array.  Smat{1} is the horizontal plane and Smat{2} is the vertical cross plane.
%
%  3. Orbit response matrix for all the horizontal correctors (Default kick amplitude):
%     Smat = measrespmat(getx('Struct'), getsp('HCM','struct'));
%
%  Written by Greg Portmann


% Experimenting with orbit correction


% Initialize
CorrectOrbitFlag = 1;


% Initialize
ActuatorDelta = [];
ActuatorDeviceList = [];
ModulationMethod = 'bipolar';
WaitFlag = [];
WaitFlagMonitor = 0;
ExtraDelay = 0; 
StructOutputFlag = 0;
NumericOutputFlag = 0;
DisplayFlag = 1;
ModeFlagCell = {};
UnitsFlagCell = {};

InputFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Struct')
        StructOutputFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Numeric')
        NumericOutputFlag = 1;
        StructOutputFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Simulator') | strcmpi(varargin{i},'Model')
        ModeFlagCell = varargin(i);
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        ModeFlagCell = varargin(i);
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Manual')
        ModeFlagCell = varargin(i);
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Physics')
        UnitsFlagCell = varargin(i);
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Hardware')
        UnitsFlagCell = varargin(i);
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    end
end


if length(varargin) < 2
    error('Not enough inputs')
end



% Find out if the inputs are data structures
StructInputFlag = 0;
if isstruct(varargin{1})
    StructInputFlag = 1;
elseif iscell(varargin{1})
    if isstruct(varargin{1}{1})
        StructInputFlag = 1;
    end
end


if StructInputFlag
    % S = measrespmat(MonitorStruct, ActuatorStruct, ActuatorDelta, ModulationMethod, WaitFlag, ExtraDelay)
    if length(varargin) < 2
        error('At least 2 inputs required in structure mode.');
    end
    
    % Only change StructOutputFlag if 'numeric' is not on the input line
    if ~NumericOutputFlag
        StructOutputFlag = 1;
    end
    
    MonitorStruct = varargin{1};
    ActuatorStruct = varargin{2};
    if ~isstruct(ActuatorStruct)
        error('If monitors are data structures, then the actuator must also be a data structure.');
    end
    
    if iscell(varargin{1})
        for j = 1:length(MonitorStruct)
            if ~isstruct(MonitorStruct{j})
                error('All monitors in the cell must be data structures or not (mixing methods not allowed).');
            end
            
            MonitorFamily{j} = MonitorStruct{j}.FamilyName;
            MonitorDeviceList{j} = MonitorStruct{j}.DeviceList;
        end
    else
        MonitorFamily = MonitorStruct.FamilyName;
        MonitorDeviceList = MonitorStruct.DeviceList;
    end
    ActuatorFamily = ActuatorStruct.FamilyName;
    ActuatorDeviceList = ActuatorStruct.DeviceList;
    if length(varargin) >= 3
        ActuatorDelta = varargin{3};
    end
    if length(varargin) >= 4
        ModulationMethod = varargin{4};
    end
    if length(varargin) >= 5
        WaitFlag = varargin{5};
    end
    if length(varargin) >= 6
        ExtraDelay = varargin{6};
    end
else
    % S = measrespmat(MonitorFamily, MonitorDeviceList, ActuatorFamily, ActuatorDeviceList, ActuatorDelta, ModulationMethod, WaitFlag, ExtraDelay)
    if length(varargin) < 3
        error('At least 3 inputs required ');
    end
    MonitorFamily = varargin{1};
    MonitorDeviceList = varargin{2};
    ActuatorFamily = varargin{3};
    if length(varargin) >= 4
        ActuatorDeviceList = varargin{4};
    end
    if length(varargin) >= 5
        ActuatorDelta = varargin{5};
    end
    if length(varargin) >= 6
        ModulationMethod = varargin{6};
    end
    if length(varargin) >= 7
        WaitFlag = varargin{7};
    end
    if length(varargin) >= 8
        ExtraDelay = varargin{8};
    end
end

% Remove extra delay for model
if any(strcmpi('Model', ModeFlagCell)) | any(strcmpi('Simulator', ModeFlagCell))
    ExtraDelay = 0;
end

if isempty(ModulationMethod)
    ModulationMethod = 'bipolar';
elseif ~strcmp(lower(ModulationMethod), 'unipolar') & ~strcmp(lower(ModulationMethod), 'bipolar')
    error('ModulationMethod must be ''unipolar'' or ''bipolar''');
end


% Force to be a cells of equal length
if ~iscell(MonitorFamily)
    MonitorFamily = {MonitorFamily};
end
if ~iscell(MonitorDeviceList)
    MonitorDeviceList = {MonitorDeviceList};
end
if ~iscell(ActuatorFamily)
    ActuatorFamily = {ActuatorFamily};
end
if isempty(ActuatorDeviceList)
    for i = 1:length(ActuatorFamily)
        ActuatorDeviceList{i} = [];
    end
elseif ~iscell(ActuatorDeviceList)
    ActuatorDeviceList = {ActuatorDeviceList};
end
if isempty(ActuatorDelta)
    for i = 1:length(ActuatorFamily)
        ActuatorDelta{i} = [];
    end
elseif ~iscell(ActuatorDelta)
    ActuatorDelta = {ActuatorDelta};
end


% Force column for monitors and rows for actuators
MonitorFamily = MonitorFamily(:);
MonitorDeviceList = MonitorDeviceList(:);
ActuatorFamily = ActuatorFamily(:)';
ActuatorDeviceList = ActuatorDeviceList(:)';
ActuatorDelta = ActuatorDelta(:)';


% Check length of cell inputs
if length(MonitorFamily) ~= length(MonitorDeviceList)
    error('The length of MonitorFamily (cell) must equal the length of MonitorDeviceList (cell)');
end
if length(ActuatorFamily) ~= length(ActuatorDeviceList)
    error('The length of ActuatorFamily (cell) must equal the length of ActuatorDeviceList (cell)');
end
if length(ActuatorFamily) ~= length(ActuatorDelta)
    error('The length of ActuatorFamily (cell) must equal the length of ActuatorDelta (cell)');
end


% Manual mode for monitors
WaitFlagMonitor = WaitFlag;
if WaitFlag == -5
    WaitFlag = 0;
end


% First get all defaults and do some error checking 
for iActFam = 1:length(ActuatorFamily)
    % Convert element list to a device list if necessary
    if size(ActuatorDeviceList{iActFam},2) == 1
        ActuatorDeviceList{iActFam} = elem2dev(ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam});
    end
    
    % Get ActuatorDelta if empty
    if isempty(ActuatorDelta{iActFam})
        % Find the delta from the AO (.DeltaRespMat is always hardware!!!)
        ActuatorDelta{iActFam} = getfamilydata(ActuatorFamily{iActFam}, 'Setpoint', 'DeltaRespMat', ActuatorDeviceList{iActFam});
        if isempty(ActuatorDelta{iActFam})
            error(sprintf('%s.Setpoint.DeltaRespMat field must be set properly',ActuatorFamily{iActFam}));
        end
        
        % Check if ActuatorDelta needs a units conversion
        if strcmpi(UnitsFlagCell,{'Physics'})
            % Check over-ride
            ActuatorDelta{iActFam} = hw2physics(ActuatorFamily{iActFam}, 'Setpoint', ActuatorDelta{iActFam}, ActuatorDeviceList{iActFam}, ModeFlagCell{:});
        else
            % Check family
            Units = getfamilydata(ActuatorFamily{iActFam}, 'Setpoint', 'Units');
            if strcmpi(Units, 'Physics')
                ActuatorDelta{iActFam} = hw2physics(ActuatorFamily{iActFam}, 'Setpoint', ActuatorDelta{iActFam}, ActuatorDeviceList{iActFam}, ModeFlagCell{:});
            end
        end
        %if strcmpi(UnitsFlagCell,{'Hardware'}) & strcmpi(Units, 'Physics')
        %    ActuatorDelta{iActFam} = physics2hw(ActuatorFamily{iActFam}, 'Setpoint', ActuatorDelta{iActFam}, ActuatorDeviceList{iActFam}, ModeFlagCell{:});        
        %end
    end
    if isempty(ActuatorDelta{iActFam})
        error('ActuatorDelta is empty.  Must be an input or in the family structure (.DeltaRespMat in hardware units)');
    end
    if ~isnumeric(ActuatorDelta{iActFam})
        error('ActuatorDelta must be numeric.');
    end
    
    % Force ActuatorDelta to be a column vector
    ActuatorDelta{iActFam} = ActuatorDelta{iActFam}(:);
    
    % Check for entire family
    if isempty(ActuatorDeviceList{iActFam})
        % Set the entire family at once
        iActDeviceTotal{iActFam} = 1;
        
        % Expand a scalar to all devices
        if length(ActuatorDelta{iActFam}) == 1
            % OK
        elseif length(ActuatorDelta{iActFam}) == length(getlist(ActuatorFamily{iActFam}))
            % OK
        else
            error('ActuatorDelta must be a scalar or equal in length to the number of devices');
        end
    else
        iActDeviceTotal{iActFam} = size(ActuatorDeviceList{iActFam},1);
        
        % Expand a scalar to all devices if scalar
        if length(ActuatorDelta{iActFam}) == 1
            ActuatorDelta{iActFam} = ActuatorDelta{iActFam} * ones(iActDeviceTotal{iActFam},1);
        end
        % Size of ActuatorDelta must equal total number of devices 
        if length(ActuatorDelta{iActFam}) ~= iActDeviceTotal{iActFam}
            error('ActuatorDelta must be a scalar or equal in length to the number of devices');
        end
    end
    
    % Check for zeros
    if any(ActuatorDelta{iActFam} == 0)
        error('At least one the actuator deltas is zero.');
    end

    % Get initial actuator values
    ActuatorStart{iActFam} = getsp(ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam}, 'Struct', InputFlags{:});
    InitActuator = ActuatorStart{iActFam}.Data;
    
    % Check actuator limits 
    if strcmpi(ModulationMethod, 'unipolar')
        % unipolar measurement
        [LimitFlag, LimitList] = checklimits(ActuatorFamily{iActFam}, InitActuator+ActuatorDelta{iActFam}, ActuatorDeviceList{iActFam}, UnitsFlagCell{:});
        if LimitFlag
            MagnetString = sprintf('%s(%d,%d)=%f, Delta=%f', ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam}(LimitList(1),:), InitActuator(LimitList(1)), ActuatorDelta{iActFam}(LimitList(1)));
            error(['Actuator limit would be exceeded (Setpoint+Delta) (', MagnetString, ')']);
        end
    elseif strcmpi(ModulationMethod, 'bipolar')
        % bipolar measurement
        [LimitFlag, LimitList] = checklimits(ActuatorFamily{iActFam}, InitActuator-ActuatorDelta{iActFam}/2, ActuatorDeviceList{iActFam}, UnitsFlagCell{:});
        if LimitFlag
            MagnetString = sprintf('%s(%d,%d)=%f, Delta=%f', ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam}(LimitList(1),:), InitActuator(LimitList(1)), ActuatorDelta{iActFam}(LimitList(1)));
            error(['Actuator limit would be exceeded (Setpoint-Delta/2) (', MagnetString, ')']);
        end
        [LimitFlag, LimitList] = checklimits(ActuatorFamily{iActFam}, InitActuator+ActuatorDelta{iActFam}/2, ActuatorDeviceList{iActFam}, UnitsFlagCell{:});
        if LimitFlag
            MagnetString = sprintf('%s(%d,%d)=%f, Delta=%f', ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam}(LimitList(1),:), InitActuator(LimitList(1)), ActuatorDelta{iActFam}(LimitList(1)));
            error(['Actuator limit would be exceeded (Setpoint+Delta/2) (', MagnetString, ')']);
        end
    end
end


if DisplayFlag
    fprintf('   Measuring response using a %s actuator method\n', lower(ModulationMethod));
end

% Begin main loop over actuators
for iActFam = 1:length(ActuatorFamily)
    t0 = clock;
    clear R;
        
    % Get initial monitor values
    if StructOutputFlag
        if WaitFlagMonitor == -5
            MonitorStart = getam(MonitorFamily, MonitorDeviceList, 'Struct', 'Manual', UnitsFlagCell{:});
        else
            MonitorStart = getam(MonitorFamily, MonitorDeviceList, 'Struct', InputFlags{:});
        end
        DCCTStart = getdcct(ModeFlagCell{:});
    end
    
    % Get initial actuator values
    InitActuator = ActuatorStart{iActFam}.Data;
    
    % Just to display common names (empty if not using common names)
    CommonNameList = family2common(ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam});

    % Iterate on each actuator in the device list
    if DisplayFlag % & ~isempty(ActuatorDeviceList{iActFam})  %iActDeviceTotal{iActFam} > 1
        fprintf('\n   %s family response matrix\n', ActuatorFamily{iActFam});
    end
    
    % Individual actuator loop
    for iActDevice = 1:iActDeviceTotal{iActFam}
        if CorrectOrbitFlag
            OrbitStart = getam(MonitorFamily, MonitorDeviceList, 'Struct', InputFlags{:});
        end
        
        if ~isempty(CommonNameList)
            CommonName = [deblank(CommonNameList(iActDevice,:)), ' '];
            if strcmpi(deblank(CommonName), ActuatorFamily{iActFam})
                CommonName = '';
            end
        end

        % Remove the CommonName for now
        CommonName = '';

        % Step actuator down for bipolar
        try
            if strcmp(lower(ModulationMethod), 'bipolar')
                if isempty(ActuatorDeviceList{iActFam})
                    if DisplayFlag
                        fprintf('   %s family nominal value is %f [%s]\n', ActuatorFamily{iActFam}, InitActuator(1), ActuatorStart{iActFam}.UnitsString);
                        fprintf('   Changing family by %+f [%s] from nominal\n', -ActuatorDelta{iActFam}(1)/2, ActuatorStart{iActFam}.UnitsString);
                        drawnow;
                    end
                    DeltaActuator =                InitActuator-ActuatorDelta{iActFam}/2;
                    setsp(ActuatorFamily{iActFam}, InitActuator-ActuatorDelta{iActFam}/2, ActuatorDeviceList{iActFam}, WaitFlag, InputFlags{:});
                else
                    if DisplayFlag
                        fprintf('   %d. %s%s(%d,%d) nominal value is %f [%s]\n', iActDevice, CommonName, ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam}(iActDevice,:), InitActuator(iActDevice), ActuatorStart{iActFam}.UnitsString);
                        fprintf('   %d. Changing actuator by %+f [%s] from nominal\n', iActDevice, -ActuatorDelta{iActFam}(iActDevice)/2, ActuatorStart{iActFam}.UnitsString);
                        drawnow;
                    end
                    DeltaActuator =                InitActuator(iActDevice)-ActuatorDelta{iActFam}(iActDevice)/2;
                    setsp(ActuatorFamily{iActFam}, InitActuator(iActDevice)-ActuatorDelta{iActFam}(iActDevice)/2, ActuatorDeviceList{iActFam}(iActDevice,:), WaitFlag, InputFlags{:});
                end
            elseif strcmp(lower(ModulationMethod), 'unipolar')
                if isempty(ActuatorDeviceList{iActFam})
                    DeltaActuator = InitActuator(1);
                else
                    DeltaActuator = InitActuator(iActDevice);
                end
                if DisplayFlag
                    if isempty(ActuatorDeviceList{iActFam})
                        fprintf('   %s family nominal value is %f [%s]\n', ActuatorFamily{iActFam}, InitActuator(1), ActuatorStart{iActFam}.UnitsString);
                        %fprintf('   No change to actuator\n');
                        drawnow;
                    else
                        fprintf('   %d. %s%s(%d,%d) nominal value is %f [%s]\n', iActDevice, CommonName, ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam}(iActDevice,:), InitActuator(iActDevice), ActuatorStart{iActFam}.UnitsString);
                        %fprintf('   %d. No change to actuator\n', iActDevice);
                        drawnow;
                    end
                end
            end
            
        catch
            fprintf('   %s\n', lasterr);
            if isempty(ActuatorDeviceList{iActFam})
                FamilyMessage = sprintf('An error occurred setting %s to %f [%s].\n', ActuatorFamily{iActFam}, InitActuator(iActDevice), DeltaActuator, ActuatorStart{iActFam}.UnitsString);
            else
                FamilyMessage = sprintf('An error occurred setting %s(%d,%d) to %f [%s].\n', ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam}(iActDevice,:), DeltaActuator, ActuatorStart{iActFam}.UnitsString);
            end
            CommandInput = questdlg( ...
                strvcat(FamilyMessage, ...
                strvcat('Either manually varify that the magnet is at the proper setpoint', ...
                strvcat('and continue measuring the response matrix or stop','the response matrix measurement?'))), ...
                'MEASRESPMAT', ...
                'Continue', ...
                'Stop', ...
                'Continue');
            switch CommandInput
                case 'Stop'
                    error('Response matrix measurement stopped.');
                    S = {}
                    return;
                case 'Continue'
                    %keyboard
            end
        end

        % Wait for signal processing if requested
        sleep(ExtraDelay);

        %if DisplayFlag
        %    fprintf('   Recording data point #1\n'); drawnow;
        %end

        % Acquire data
        if WaitFlagMonitor == -5
            Xm = getam(MonitorFamily, MonitorDeviceList, 'Manual', UnitsFlagCell{:});
        else
            Xm = getam(MonitorFamily, MonitorDeviceList, InputFlags{:});
        end

        % Step actuator up
        try
            if strcmp(lower(ModulationMethod), 'bipolar')
                if isempty(ActuatorDeviceList{iActFam})
                    if DisplayFlag
                        fprintf('   Changing family by %+f [%s] from nominal\n', ActuatorDelta{iActFam}(1)/2, ActuatorStart{iActFam}.UnitsString);
                        drawnow;
                    end
                    DeltaActuator =                InitActuator+ActuatorDelta{iActFam}/2;
                    setsp(ActuatorFamily{iActFam}, InitActuator+ActuatorDelta{iActFam}/2, ActuatorDeviceList{iActFam}, WaitFlag, InputFlags{:});
                else
                    if DisplayFlag
                        fprintf('   %d. Changing actuator by %+f [%s] from nominal\n', iActDevice, ActuatorDelta{iActFam}(iActDevice)/2, ActuatorStart{iActFam}.UnitsString);
                        drawnow;
                    end
                    DeltaActuator =                InitActuator(iActDevice)+ActuatorDelta{iActFam}(iActDevice)/2;
                    setsp(ActuatorFamily{iActFam}, InitActuator(iActDevice)+ActuatorDelta{iActFam}(iActDevice)/2, ActuatorDeviceList{iActFam}(iActDevice,:), WaitFlag, InputFlags{:});
                end
            elseif strcmp(lower(ModulationMethod), 'unipolar')
                if isempty(ActuatorDeviceList{iActFam})
                    if DisplayFlag
                        fprintf('   Changing family by %+f [%s] from nominal\n', ActuatorDelta{iActFam}(1), ActuatorStart{iActFam}.UnitsString);
                        drawnow;
                    end
                    DeltaActuator =                InitActuator+ActuatorDelta{iActFam};
                    setsp(ActuatorFamily{iActFam}, InitActuator+ActuatorDelta{iActFam}, ActuatorDeviceList{iActFam}, WaitFlag, InputFlags{:});
                else
                    if DisplayFlag
                        fprintf('   %d. Changing actuator by %+f [%s] from nominal\n', iActDevice, ActuatorDelta{iActFam}(iActDevice), ActuatorStart{iActFam}.UnitsString);
                        drawnow;
                    end
                    DeltaActuator =                InitActuator(iActDevice)+ActuatorDelta{iActFam}(iActDevice);
                    setsp(ActuatorFamily{iActFam}, InitActuator(iActDevice)+ActuatorDelta{iActFam}(iActDevice), ActuatorDeviceList{iActFam}(iActDevice,:), WaitFlag, InputFlags{:});
                end
            end
        catch
            fprintf('   %s\n', lasterr);
            if isempty(ActuatorDeviceList{iActFam})
                FamilyMessage = sprintf('An error occurred setting %s to %f [%s].\n', ActuatorFamily{iActFam}, InitActuator(iActDevice), DeltaActuator, ActuatorStart{iActFam}.UnitsString);
            else
                FamilyMessage = sprintf('An error occurred setting %s(%d,%d) to %f [%s].\n', ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam}(iActDevice,:), DeltaActuator, ActuatorStart{iActFam}.UnitsString);
            end
            CommandInput = questdlg( ...
                strvcat(FamilyMessage, ...
                strvcat('Either manually varify that the magnet is at the proper setpoint', ...
                strvcat('and continue measuring the response matrix or stop','the response matrix measurement?'))), ...
                'MEASRESPMAT', ...
                'Continue', ...
                'Stop', ...
                'Continue');
            switch CommandInput
                case 'Stop'
                    error('Response matrix measurement stopped.');
                    S = {}
                    return;
                case 'Continue'
                    %keyboard
            end
        end

        % Wait for signal processing if requested
        sleep(ExtraDelay);

        if DisplayFlag
            %fprintf('   Recording data point #2\n'); drawnow;
        end

        % Acquire data
        if WaitFlagMonitor == -5
            Xp = getam(MonitorFamily, MonitorDeviceList, 'Manual', UnitsFlagCell{:});
        else
            Xp = getam(MonitorFamily, MonitorDeviceList, InputFlags{:});
        end

        % Restore actuators
        try
            if isempty(ActuatorDeviceList{iActFam})
                DeltaActuator = InitActuator;
                setsp(ActuatorFamily{iActFam}, InitActuator, ActuatorDeviceList{iActFam}, WaitFlag, InputFlags{:});
                if DisplayFlag
                    if strcmpi(ActuatorStart{iActFam}.Mode, 'Manual')
                        fprintf('   %s family reset\n', ActuatorFamily{iActFam});
                    else
                        FinalSP = getsp(ActuatorFamily{iActFam}, InputFlags{:});
                        fprintf('   %s family reset to %f [%s]\n', ActuatorFamily{iActFam}, FinalSP(1), ActuatorStart{iActFam}.UnitsString);
                    end
                end
            else
                DeltaActuator = InitActuator(iActDevice);
                setsp(ActuatorFamily{iActFam}, InitActuator(iActDevice), ActuatorDeviceList{iActFam}(iActDevice,:), WaitFlag, InputFlags{:});
                if DisplayFlag
                    if strcmpi(ActuatorStart{iActFam}.Mode,'Manual')
                        fprintf('   %d. %s%s(%d,%d) reset\n', iActDevice, CommonName, ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam}(iActDevice,:));
                    else
                        fprintf('   %d. %s%s(%d,%d) reset to %f [%s]\n', iActDevice, CommonName, ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam}(iActDevice,:), getsp(ActuatorFamily{iActFam},ActuatorDeviceList{iActFam}(iActDevice,:)), ActuatorStart{iActFam}.UnitsString);
                    end
                end
            end
            drawnow;
        catch
            fprintf('   %s\n', lasterr);
            if isempty(ActuatorDeviceList{iActFam})
                FamilyMessage = sprintf('An error occurred setting %s to %f [%s].\n', ActuatorFamily{iActFam}, InitActuator(iActDevice), DeltaActuator, ActuatorStart{iActFam}.UnitsString);
            else
                FamilyMessage = sprintf('An error occurred setting %s(%d,%d) to %f [%s].\n', ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam}(iActDevice,:), DeltaActuator, ActuatorStart{iActFam}.UnitsString);
            end
            CommandInput = questdlg( ...
                strvcat(FamilyMessage, ...
                strvcat('Either manually varify that the magnet is at the proper setpoint', ...
                strvcat('and continue measuring the response matrix or stop','the response matrix measurement?'))), ...
                'MEASRESPMAT', ...
                'Continue', ...
                'Stop', ...
                'Continue');
            switch CommandInput
                case 'Stop'
                    error('Response matrix measurement stopped.');
                    S = {}
                    return;
                case 'Continue'
                    %keyboard
            end
        end


        if CorrectOrbitFlag
            %OrbitCorrectionLocal(OrbitStart{iActFam}.Data, OrbitStart{iActFam}.FamilyName, OrbitStart{iActFam}.DeviceList, ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam}(iActDevice,:));
            OrbitCorrectionLocal(OrbitStart, ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam}(iActDevice,:));
        end


        if DisplayFlag & (iActDevice < iActDeviceTotal{iActFam})
            fprintf('\n');
        end


        % Compute differences
        for iMonFam = 1:length(MonitorFamily)
            if isempty(ActuatorDeviceList{iActFam})
                % Compute response matrix columns
                % For each magnet:  1. Divide by the change in amperes, like [Tune / Ampere]
                %                   2. Scale each magnet by its fractional contribution in physics units (should use K*L, not just K)
                if strcmpi(family2units(ActuatorFamily{iActFam},'Setpoint'),'Hardware')
                    DeltaPhysics = hw2physics(ActuatorFamily{iActFam}, 'Setpoint', InitActuator+ActuatorDelta{iActFam}, ActuatorDeviceList{iActFam}, ModeFlagCell{:}) - hw2physics(ActuatorFamily{iActFam}, 'Setpoint', InitActuator, ActuatorDeviceList{iActFam}, ModeFlagCell{:});
                else
                    DeltaPhysics = ActuatorDelta{iActFam};
                end
                
                % DeltaPhysics should be K*Leff (not just "K")
                Leff = getleff(ActuatorFamily{iActFam}, ActuatorDeviceList{iActFam});
                DeltaPhysics = DeltaPhysics .* Leff;
                
                % In order to backout the response at each magnet, assume that
                % the response at each magnet is equal in physics units.  
                DeltaMonitorPerPhysicsUnit = (Xp{iMonFam}-Xm{iMonFam}) / sum(DeltaPhysics);
                
                % Expand to each magnet
                R{iMonFam} = DeltaMonitorPerPhysicsUnit * ones(1,length(DeltaPhysics));
                
                % When in hardware unit convert to delta monitor / ampere
                if strcmpi(family2units(ActuatorFamily{iActFam},'Setpoint'),'Hardware')
                    PhysicsUnitPerAmp = DeltaPhysics ./ ActuatorDelta{iActFam};
                    for n = 1:length(DeltaPhysics)
                        R{iMonFam}(:,n) = PhysicsUnitPerAmp(n) * R{iMonFam}(:,n);
                    end
                end
                
            else
                % Just divide the monitor value by the actuator value
                R{iMonFam}(:,iActDevice) = (Xp{iMonFam}-Xm{iMonFam}) / ActuatorDelta{iActFam}(iActDevice); 
            end
            
            % Save the measurements
            Monitor1{iMonFam}(:,iActDevice) = Xm{iMonFam}; 
            Monitor2{iMonFam}(:,iActDevice) = Xp{iMonFam}; 

        end % iMonFam
    end % iActDevice
    
    for iMonFam = 1:length(MonitorFamily)
        if StructOutputFlag
            S{iMonFam,iActFam}.Data = R{iMonFam};
            
            S{iMonFam,iActFam}.Monitor = MonitorStart{iMonFam};
            S{iMonFam,iActFam}.Actuator = ActuatorStart{iActFam};
            S{iMonFam,iActFam}.ActuatorDelta = ActuatorDelta{iActFam};
            
            S{iMonFam,iActFam}.Monitor1 = Monitor1{iMonFam};
            S{iMonFam,iActFam}.Monitor2 = Monitor2{iMonFam};
            
            if ~strcmpi(MonitorStart{iMonFam}.Units, ActuatorStart{iActFam}.Units)
                S{iMonFam,iActFam}.Units =  [MonitorStart{iMonFam}.Units, '/', ActuatorStart{iActFam}.Units];
                fprintf('   Warning: Units are in a mixed mode');
            else
                S{iMonFam,iActFam}.Units = MonitorStart{iMonFam}.Units;
            end
            %S{iMonFam,iActFam}.UnitsString = ['[',MonitorStart{iMonFam}.UnitsString,']', '/', '[',ActuatorStart{iActFam}.UnitsString,']'];
            S{iMonFam,iActFam}.UnitsString = [MonitorStart{iMonFam}.UnitsString, '/', ActuatorStart{iActFam}.UnitsString];

            S{iMonFam,iActFam}.GeV = getenergy(ModeFlagCell{:}); 
            S{iMonFam,iActFam}.TimeStamp = t0;
            S{iMonFam,iActFam}.DCCT = DCCTStart;
            S{iMonFam,iActFam}.ModulationMethod = ModulationMethod;
            S{iMonFam,iActFam}.WaitFlag = WaitFlagMonitor;
            S{iMonFam,iActFam}.ExtraDelay = ExtraDelay;
            S{iMonFam,iActFam}.DataDescriptor = 'Response Matrix';
            S{iMonFam,iActFam}.CreatedBy = 'measrespmat';    
            S{iMonFam,iActFam}.OperationalMode = getfamilydata('OperationalMode');
        else
            S{iMonFam,iActFam} = R{iMonFam};
        end
    end

    % If the beam current is too low, prompt for a refill
    % if (getdcct-NextDCCTPrompt) < 0
    %     DCCT = getdcct;
    %     fprintf(' \n'); 
    %     fprintf('   The present storage ring current is  ', num2str(getdcct), ' mAmps.  If necessary, refill the storage\n'); 
    %     fprintf('   ring now.  If not, you will prompted after another ', num2str(DeltaDCCT), ' mAmps\n');
    %     fprintf('   has dropped.  Hit return when ready to continue.\n\n'); 
    %     pause;
    %     NextDCCTPrompt = getdcct - DeltaDCCT;
    %     fprintf('   The next prompt for a fill will be at ', num2str(NextDCCTPrompt), ' mAmps.\n\n'); 
    % end
    
end


% For one family inputs, there is no need for a cell output
if all(size(S) == [1 1])
    S = S{1};
end




% OrbitCorrectionLocal(GoalOrbit, BPMFamily, BPMDevList, CMFamily, CMDevList, Iter)
function OrbitCorrectionLocal(GoalOrbit, CMFamily, CMDevList, Iter)

fprintf('       Correcting the orbit\n');


WaitFlag = -2;


if nargin < 3
    error('3 inputs needed in OrbitCorrectionLocal');
end
if nargin < 4
    Iter = 2;
end

BPMxFamily  = GoalOrbit{1}.FamilyName;
BPMxDevList = GoalOrbit{1}.DeviceList;

BPMyFamily  = GoalOrbit{2}.FamilyName;
BPMyDevList = GoalOrbit{2}.DeviceList;

HCMDevList = CMDevList;
VCMDevList = CMDevList;

Sx = getrespmat(BPMxFamily, BPMxDevList, 'HCM', HCMDevList);
Sy = getrespmat(BPMyFamily, BPMyDevList, 'VCM', VCMDevList);

if any(any(isnan(Sy)))
    % ALS cluge to find 3 VCMs next to the missing VCM
    if CMDevList(1,2)==3
        VCMDevListTotal = family2dev('VCM');
        VCMDevList = [VCMDevList(1,1) VCMDevList(1,2)-1];
        i = findrowindex(VCMDevList, VCMDevListTotal);
        if i == 1
            i = 2;
        end
        VCMDevList = VCMDevListTotal([i-1; i; i+1],:);
        Sy = getrespmat(BPMyFamily, BPMyDevList, 'VCM', VCMDevList);
    elseif CMDevList(1,2)==6
        VCMDevListTotal = family2dev('VCM');
        VCMDevList = [VCMDevList(1,1) VCMDevList(1,2)+1];
        i = findrowindex(VCMDevList, VCMDevListTotal);
        if i == size(VCMDevListTotal,1)
            i = size(VCMDevListTotal,1)-1;
        end
        VCMDevList = VCMDevListTotal([i-1; i; i+1],:);
        Sy = getrespmat(BPMyFamily, BPMyDevList, 'VCM', VCMDevList);
    else
        error('Response matrix has a NaN');
    end
end


x = getam(BPMxFamily, BPMxDevList) - GoalOrbit{1}.Data;
y = getam(BPMyFamily, BPMyDevList) - GoalOrbit{2}.Data;
fprintf('       Residual orbit change dx =%6.3f   dy =%6.3f microns (Before Correction)\n', 1000*std(x), 1000*std(y));

for i = 1:Iter
    x = getam(BPMxFamily, BPMxDevList) - GoalOrbit{1}.Data;
    y = getam(BPMyFamily, BPMyDevList) - GoalOrbit{2}.Data;

    %     % Check limits
    %     MinSP = minsp(CMFamily, CMDevList);
    %     MaxSP = maxsp(CMFamily, CMDevList);
    %     if any(getsp(CMFamily,CMDevList)+CorrectorSP > MaxSP)
    %         fprintf('   Orbit not corrected because a maximum power supply limit would have been exceeded!\n');
    %         return;
    %     end
    %     if any(getsp(CMFamily,CMDevList)+CorrectorSP < MinSP)
    %         fprintf('   Orbit not corrected because a minimum power supply limit would have been exceeded!\n');
    %         return;
    %     end
    
    % Get the HCMs moving
    if ~(any(any(isnan(Sx))))
        dHCM = -(Sx\x);
        hcm = getsp('HCM', HCMDevList);
        setsp('HCM', hcm+dHCM, HCMDevList, 0);
    end

    % Set with Waitflag
    if ~(any(any(isnan(Sy))))
        dVCM = -(Sy\y);
        stepsp('VCM', dVCM, VCMDevList, WaitFlag);
    end
    if ~(any(any(isnan(Sx))))
        setsp('HCM', hcm+dHCM, HCMDevList, WaitFlag);
    end
    %x = getam(BPMFamily, BPMDevList) - GoalOrbit
end


x = getam(BPMxFamily, BPMxDevList) - GoalOrbit{1}.Data;
y = getam(BPMyFamily, BPMyDevList) - GoalOrbit{2}.Data;
fprintf('       Residual orbit change dx =%6.3f   dy =%6.3f microns (After Correction)\n', 1000*std(x), 1000*std(y));



% function OrbitCorrectionLocal(GoalOrbit, BPMFamily, BPMDevList, CMFamily, CMDevList, Iter)
%
% WaitFlag = -2;
%
%
% if nargin < 5
%     error('5 inputs needed in OrbitCorrectionLocal');
% end
% if nargin < 6
%     Iter = 2;
% end
% 
% s = getrespmat(BPMFamily, BPMDevList, CMFamily, CMDevList);
% if any(any(isnan(s)))
%     error('Response matrix has a NaN');
% end
% 
% for i = 1:Iter
%     x = getam(BPMFamily, BPMDevList) - GoalOrbit;
%     
%     CorrectorSP = -(s\x);
%     
%     % Check limits
%     MinSP = minsp(CMFamily, CMDevList);
%     MaxSP = maxsp(CMFamily, CMDevList);
%     if any(getsp(CMFamily,CMDevList)+CorrectorSP > MaxSP) 
%         fprintf('   Orbit not corrected because a maximum power supply limit would have been exceeded!\n');
%         return;
%     end
%     if any(getsp(CMFamily,CMDevList)+CorrectorSP < MinSP) 
%         fprintf('   Orbit not corrected because a minimum power supply limit would have been exceeded!\n');
%         return;
%     end
%     
%     stepsp(CMFamily, CorrectorSP, CMDevList, WaitFlag);
%     
%     %x = getam(BPMFamily, BPMDevList) - GoalOrbit
% end
