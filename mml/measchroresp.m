function [Rmat, OutputFileName] = measchroresp(varargin)
%MEASCHRORESP - measures the response from sextupoles to chromaticity
%  [R, FileName] = measchroresp(ActuatorFamily, ActuatorDeviceList, ActuatorDelta, DeltaRF, WaitFlag, FileName, DirectoryName, ExtraDelay)
%
%  INPUTS 
%  1. ActuatorFamily = Family name or cell array of family nams {default: {'SF','SD'}}
%
%  2. ActuatorDeviceList = Device list {Default: [], the entire family}
%                          (Note: all devices in DeviceList are changed at the same time)
%
%  3. ActuatorDelta = Change in magnet strength {Default: getfamilydata(ActuatorFamily, 'Setpoint', 'DeltaRespMat')}
%
%  4. DeltaRF = Change in RF frequency to measure the chromaticity {Default:  measchro default}
%
%  5. If WaitFlag >= 0, then WaitFlag is the delay before measuring the tune (sec)
%                  = -3, then a delay of 2.2*getfamilydata('TuneDelay') is used {Default} 
%                  = -4, then pause until keyboard input
%                  = -5, then input the tune measurement manually by keyboard input
%
%  6. Optional input to change the default filename and directory
%     FileName - Filename for the response matrix data
%                (No input or empty means data will be saved to the default file)  
%     DirectoryName - Directory name to store the response matrix data file 
%     Note: a. FileName can include the path if DirectoryName is not used
%           b. For model response matrices, FileName must exist for a file save
%           c. When using the default FileName, a dialog box will prompt for changes
%
%  7. ExtraDelay - extra time delay [seconds] after a setpoint change
%
%  8. 'Struct'  - Return a response matrix structure
%     'Numeric' - Returns numeric output (cell array if more than one sextupole family) {Default}
%     'Matrix'  - Return a matrix output {Default}
%
%                 Note: 'Matrix' is only a valid flag for Numeric outputs
%                 Often use with the model input.  For example, to compare the model
%                 chromaticity response matrix to the default matrix,
%                 Mmodel = measchroresp('Model','Matrix');
%                 Mmeas  = getchroresp;
%
%  10. Optional override of the units:
%      'Physics'  - Use physics  units
%      'Hardware' - Use hardware units
%
%  11. Optional override of the mode:
%      'Online'    - Set/Get data online  
%      'Model'     - Get the model chromaticity directly from AT (uses modelchro)
%      'Simulator' - Set/Get data on the simulated accelerator using AT (ie, same commands as 'Online')
%      'Manual'    - Set/Get data manually
%
%  12. 'Display'   - Prints status information to the command window {Default}
%      'NoDisplay' - Nothing is printed to the command window
%
%  13. 'Archive'   - Save the response matrix structure {Default, unless mode='Model'}
%      'NoArchive' - Save the response matrix structure
%
%  Note: the 'ModulationMethod' is always 'Unipolar' (since hysteresis is usually an issue)
% 
%  OUTPUTS
%  R = Response matrix from delta sextupole to delta chromaticity
%
%         If more than one sextupole family is input, the R is a cell array indexed by 
%         sextupole family (ie, the number of families in ActuatorFamily).  The default
%         is to make R{1} SF and R{2} SD.  R{1} or R.Data for structure output
%         is a 2x(number of sextupoles in family) array.  The first row is horizontal 
%         chromaticity and the second is vertical.
%
%         Units: delta(Chromaticity) / delta(Sextupole) is set by the .Units field for the 
%                setpoints (ie, the sextupole family).  
%                Typically,  Hardware units:  (1/MHz)/Amp;
%                            Physics  units:  (1/(dp/p))/K;
%
%  See also measchro, stepchro

%  Written by Greg Portmann


% Initialize
ActuatorFamily = findmemberof('Chromaticity Corrector')';
if isempty(ActuatorFamily)
    error('MemberOf ''Chromaticity Corrector'' was not found');
end

ActuatorDeviceList = [];
ActuatorDelta = [];
DeltaRF = []; 
WaitFlag = -3;
DirectoryName = [];
ExtraDelay = 0; 
ModulationMethod = 'unipolar';
StructOutputFlag = 0;
MatrixFlag = 1;
DisplayFlag = -1;
ArchiveFlag = -1;
FileName = -1;
ModeFlag = '';          % model, online, manual, or '' for default mode
UnitsFlag = 'Physics';  % hardware, physics, or '' for default units

InputFlags = {};
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Struct')
        StructOutputFlag = 1;
        MatrixFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Numeric')
        StructOutputFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Matrix')
        MatrixFlag = 1;
        StructOutputFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'unipolar')
        % Ignor
        %ModulationMethod = 'unipolar';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'bipolar')
        % Ignor
        %ModulationMethod = 'bipolar';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model') || strcmpi(varargin{i},'online') || strcmpi(varargin{i},'manual')
        ModeFlag = varargin{i};
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Physics')
        UnitsFlag = varargin{i};
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Hardware')
        UnitsFlag = varargin{i};
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Archive')
        ArchiveFlag = 1;
        if length(varargin) > i
            % Look for a filename as the next input
            if ischar(varargin{i+1})
                FileName = varargin{i+1};
                varargin(i+1) = [];
            end
        end
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoArchive')
        ArchiveFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    end
end

TimeStamp = clock;


if length(varargin) >= 1
    ActuatorFamily = varargin{1};  
end

if length(varargin) >= 2
    ActuatorDeviceList = varargin{2};  
end

if length(varargin) >= 3
    ActuatorDelta = varargin{3};  
end


% Force to be a cells
if ~iscell(ActuatorFamily)
    ActuatorFamily = {ActuatorFamily};
end

if isempty(ActuatorDeviceList)
    for i = 1:length(ActuatorFamily)
        ActuatorDeviceList{i} = [];
    end
else
    if ~iscell(ActuatorDeviceList)
        ActuatorDeviceList = {ActuatorDeviceList};
    end
end

if isempty(ActuatorDelta)
    for i = 1:length(ActuatorFamily)
        ActuatorDelta{i} = [];
    end
else
    if ~iscell(ActuatorDelta)
        ActuatorDelta = {ActuatorDelta};
    end
end


if length(varargin) >= 4
    DeltaRF = varargin{4};  
end

% WaitFlag input
if length(varargin) >= 5
    WaitFlag = varargin{5};
end
if isempty(WaitFlag) || WaitFlag == -3
    WaitFlag = 2.2 * getfamilydata('TuneDelay');
end
if isempty(WaitFlag)
    WaitFlag = input('   Delay for Tune Measurement (Seconds, Keyboard Pause = -4, or Manual Tune Input = -5) = ');
end

if length(varargin) >= 6
    FileName = varargin{6};  
end
if length(varargin) >= 7
    if isempty(varargin{7})
        % Use default
        DirectoryName = getfamilydata('Directory', 'ChroResponse');
    elseif ischar(varargin{7})
        DirectoryName = varargin{7};
    else
        % Empty DirectoryName mean it will only be used if FileName is empty
        DirectoryName = [];
    end
end

% Look for ExtraDelay
if length(varargin) >= 8
    if isempty(varargin{8})
        % Use default
    end
    if isnumeric(varargin{8})
        ExtraDelay = varargin{8};
    end
end


% Check units (default units is based on the actuator)
if isempty(UnitsFlag)
    UnitsFlag = getfamilydata(ActuatorFamily{1},'Setpoint','Units');
end
if isempty(UnitsFlag)
    error('Unknown Units');
end

% Check mode
% if isempty(ModeFlag)
%     ModeFlag = getfamilydata(ActuatorFamily{1},'Setpoint','Mode');
% end


% Change defaults for the model (note: simulator mode mimics online)
if strcmpi(ModeFlag,'Model')
    % Only archive data if ArchiveFlag==1 or FileName~=[]
    if ischar(FileName) || ArchiveFlag == 1
        ArchiveFlag = 1;    
    else
        ArchiveFlag = 0;            
    end
    
    % Only display is it was turned on at the command line
    if DisplayFlag == 1
        % Keep DisplayFlag = 1
    else
        DisplayFlag = 0;
    end
else
    % Online or Simulator: Archive unless ArchiveFlag was forced to zero
    if ArchiveFlag ~= 0
        ArchiveFlag = 1;  
        if FileName == -1
            FileName = '';
        end
    end    
end


if strcmpi(ModeFlag,'Model') || strcmpi(ModeFlag,'Simulator')
    % No need for delays with the model
    WaitFlag = 0;
    ExtraDelay = 0; 
end

% % Print setup information
% if DisplayFlag
%     if ~strcmpi(ModeFlag,'Model')
%         fprintf('\n');
%         fprintf('   MEASCHRORESP measures the chromaticity response to the sextupole magnet families.\n');
%         fprintf('   The storage ring lattice and hardware should be setup for properly.\n');
%         fprintf('   Make sure the following information is correct:\n');
%         fprintf('   1.  Proper magnet lattice (including skew quadrupoles)\n');
%         fprintf('   2.  Proper electron beam energy\n');
%         fprintf('   3.  Proper electron bunch pattern\n');
%         fprintf('   4.  Tune is functioning or in manual mode\n');
%         fprintf('   5.  The injection bump magnets off\n\n');
%         drawnow;
%     end
% end


% Browse for filename and directory if using default FileName
if ArchiveFlag
    if isempty(FileName)
        FileName = appendtimestamp(getfamilydata('Default', 'ChroRespFile'));
        DirectoryName = getfamilydata('Directory', 'ChroResponse');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'Response', filesep, 'Chromaticity', filesep];
        else
            % Make sure default directory exists
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
        end
        [FileName, DirectoryName] = uiputfile('*.mat', 'Select a Chromaticity Response File', [DirectoryName FileName]);
        drawnow;
        if FileName == 0 
            ArchiveFlag = 0;
            disp('   Chromaticity response measurement canceled.');
            Rmat = []; OutputFileName='';
            return
        end
        FileName = [DirectoryName, FileName];
    elseif FileName == -1
        FileName = appendtimestamp(getfamilydata('Default', 'ChroRespFile'));
        DirectoryName = getfamilydata('Directory', 'ChroResponse');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'Response', filesep, 'Chromaticity', filesep];
        end
        FileName = [DirectoryName, FileName];
    end
    
    % Acquire initial data
    MachineConfig = getmachineconfig(InputFlags{:});
end


% % Query to begin measurement
% if DisplayFlag
%     tmp = questdlg('Begin response matrix measurement?','MEASCHRORESP','YES','NO','YES');
%     if strcmp(tmp,'NO')
%         fprintf('   Response matrix measurement aborted\n');
%         Rmat = [];
%         return
%     end
% end


% Begin main loop over actuators
TimeStart = gettime;
for i = 1:length(ActuatorFamily)
    if DisplayFlag
        fprintf('   Beginning %s:\n', ActuatorFamily{i});
    end
    
    % Force to be a column vector
    ActuatorDelta{i} = ActuatorDelta{i}(:);

    % Default check
    % Find the delta from the AO (.DeltaRespMat is always hardware!!!)
    if isempty(ActuatorDelta{i})        
        ActuatorDelta{i} = getfamilydata(ActuatorFamily{i}, 'Setpoint', 'DeltaRespMat', ActuatorDeviceList{i});
        if isempty(ActuatorDelta{i})
            error(sprintf('%s.Setpoint.DeltaRespMat field must be set properly',ActuatorFamily{i}));
        elseif strcmpi(UnitsFlag, 'Physics') %& strcmpi(getfamilydata(ActuatorFamily{i}, 'Setpoint', 'Units'), 'Hardware') 
            SP = getsp(ActuatorFamily{i}, ActuatorDeviceList{i}, 'Numeric', ModeFlag, 'Hardware');
            ActuatorDelta{i} = hw2physics(ActuatorFamily{i}, 'Setpoint', SP+ActuatorDelta{i}, ActuatorDeviceList{i}, ModeFlag) - hw2physics(ActuatorFamily{i}, 'Setpoint', SP, ActuatorDeviceList{i}, ModeFlag);
        %elseif strcmpi(UnitsFlag, 'Hardware') & strcmpi(getfamilydata(ActuatorFamily{i}, 'Setpoint', 'Units'), 'Physics') 
        %    SP = getsp(ActuatorFamily{i}, ActuatorDeviceList{i}, 'Numeric', ModeFlag, 'Physics');
        %    ActuatorDelta{i} = physics2hw(ActuatorFamily{i}, 'Setpoint', SP+ActuatorDelta{i}, ActuatorDeviceList{i}, ModeFlag) - physics2hw(ActuatorFamily{i}, 'Setpoint', SP, ActuatorDeviceList{i}, ModeFlag);
        end
    end
    
    Rmat{i}.Data = [];
    Rmat{i}.Monitor.FamilyName = 'Chromaticity';
    Rmat{i}.Monitor.DeviceList = [1 1;1 2];
    Rmat{i}.Monitor.ElementList = [1; 2];
    Rmat{i}.Actuator = getsp(ActuatorFamily{i}, ActuatorDeviceList{i}, 'Struct', ModeFlag, UnitsFlag);
    Rmat{i}.ActuatorDelta = ActuatorDelta{i};
    Rmat{i}.GeV = bend2gev(ModeFlag);
    Rmat{i}.TimeStamp = TimeStamp;
    if strcmpi(UnitsFlag, 'Hardware')
        Rmat{i}.Units = 'Hardware';
        Rmat{i}.UnitsString = '(1/MHz)/Amp';
        Rmat{i}.Monitor.Units = 'Hardware';
    else
        Rmat{i}.Units = 'Physics';
        Rmat{i}.UnitsString = '(1/(dp/p))/K';
        Rmat{i}.Monitor.Units = 'Physics';
    end
    Rmat{i}.ModulationMethod = 'Unipolar';
    Rmat{i}.WaitFlag = WaitFlag;
    Rmat{i}.DataDescriptor = 'Chromaticity Response Matrix';
    Rmat{i}.CreatedBy = 'measchroresp';
    Rmat{i}.OperationalMode = getfamilydata('OperationalMode');
    Rmat{i}.Chromaticity1 = [];
    Rmat{i}.Chromaticity2 = [];
    
    InitActuator = Rmat{i}.Actuator.Data;
    
    % Acquire initial data
    if StructOutputFlag               
        Rmat{i}.X = getx('Struct', ModeFlag, UnitsFlag);
        Rmat{i}.Y = gety('Struct', ModeFlag, UnitsFlag);
        Rmat{i}.DCCT = getdcct(ModeFlag);
    end    
    
    % No actuator change for first point
    if DisplayFlag
        fprintf('   Initial actuator value for %s is %+f [%s]\n', Rmat{i}.Actuator.FamilyName, Rmat{i}.Actuator.Data(1), Rmat{i}.Actuator.Units);
        fprintf('   No change to actuator'); 
        drawnow;
    end    
            
    % Wait for signal processing if requested
    sleep(ExtraDelay);

    % Acquire data
    if DisplayFlag
        fprintf(', recording data point #1\n'); 
        drawnow;
    end
    Rmat{i}.Chromaticity1 = measchro(DeltaRF, WaitFlag, 'Struct', UnitsFlag, ModeFlag);
    Rmat{i}.Monitor = Rmat{i}.Chromaticity1;
    ChromaticityMinus = Rmat{i}.Chromaticity1.Data;  
    
    % Step actuator up
    if DisplayFlag
        fprintf('\n   Changing actuator by %+f', ActuatorDelta{i}(1));
        drawnow;
    end
    try
        setsp(ActuatorFamily{i}, InitActuator+ActuatorDelta{i}, ActuatorDeviceList{i}, WaitFlag, ModeFlag, UnitsFlag);
    catch
        fprintf('\n   %s\n', lasterr);
        FamilyMessage = sprintf('An error occurred setting %s\n', ActuatorFamily{i});
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
                fprintf('\n   Reseting actuator %s \n', ActuatorFamily{i});
                try
                    setsp(ActuatorFamily{i}, InitActuator, ActuatorDeviceList{i}, 0);
                catch
                    fprintf('   %s\n', lasterr);
                end
                fprintf('   Chromaticity response matrix measurement stopped.\n\n');
                OutputFileName = '';
                return;
            case 'Continue'
        end
    end

    % Wait for signal processing if requested
    sleep(ExtraDelay);

    % Acquire data
    if DisplayFlag
        fprintf(', recording data point #2\n'); 
        drawnow;
    end
    Rmat{i}.Chromaticity2 = measchro(DeltaRF, WaitFlag, 'Struct', UnitsFlag, ModeFlag);
    ChromaticityPlus = Rmat{i}.Chromaticity2.Data;
    
    % Restore actuators
    try
        setsp(ActuatorFamily{i}, InitActuator, ActuatorDeviceList{i}, WaitFlag, ModeFlag, UnitsFlag);
    catch
        fprintf('\n   %s\n', lasterr);
        FamilyMessage = sprintf('An error occurred setting %s\n', ActuatorFamily{i});
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
                fprintf('   Chromaticity response matrix measurement stopped.\n\n');
                OutputFileName = '';
                return;
            case 'Continue'
        end
    end

    if DisplayFlag
        fprintf('   Reset actuator %s \n\n', ActuatorFamily{i}); 
        drawnow;
    end
    
    % Compute response matrix columns
    % For each magnet:  1. Divide by the change in amperes [Chromaticity / Ampere]
    %                   2. Scale each magnet by its fractional contribution in physics units 
    if strcmpi(UnitsFlag, 'Hardware')
        DeltaPhysics = hw2physics(ActuatorFamily{i}, 'Setpoint', InitActuator+ActuatorDelta{i}, ActuatorDeviceList{i}, ModeFlag) - hw2physics(ActuatorFamily{i}, 'Setpoint', InitActuator, ActuatorDeviceList{i}, ModeFlag);
    else
        DeltaPhysics = ActuatorDelta{i};
    end
    
    % In order to backout the chromaticity response at each magnet, assume that
    % the chromaticity response at each magnet is equal in physics units.  
    DelChroPerK = (ChromaticityPlus-ChromaticityMinus) / sum(DeltaPhysics);
    
    % Expand to each magnet
    Rmat{i}.Data = DelChroPerK * ones(1,length(DeltaPhysics));
    
    % When in hardware unit convert to delta chromaticity / ampere
    if strcmpi(UnitsFlag, 'Hardware')
        KPerAmp = DeltaPhysics ./ ActuatorDelta{i};
        for j = 1:length(DeltaPhysics)
            Rmat{i}.Data(:,j) = KPerAmp(j) * Rmat{i}.Data(:,j);
        end
    end
end


% For one family inputs, there is no need for a cell output (probably already done in measrespmat)
if length(Rmat) == 1
    Rmat = Rmat{1};
end


% Save data in the proper directory
if ArchiveFlag || ischar(FileName)
    [DirectoryName, FileName, Ext] = fileparts(FileName);
    DirStart = pwd;
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    if ErrorFlag
        fprintf('\n   There was a problem getting to the proper directory!\n\n');
    end
    save(FileName, 'Rmat','MachineConfig');
    cd(DirStart);
    OutputFileName = [DirectoryName, FileName, '.mat'];
    
    if DisplayFlag
        fprintf('   Chromaticity response matrix data (''Rmat'') saved to disk\n');
        fprintf('   Filename: %s\n', OutputFileName);
        fprintf('   The total response matrix measurement time: %.2f minutes.\n', (gettime-TimeStart)/60);
    end
end


if MatrixFlag && StructOutputFlag
    error('Cannot ask for a matrix and a structure output.');
end


% Return the data field of Rmat
if ~StructOutputFlag
    if length(ActuatorFamily) == 1
        Rmat = Rmat.Data;
    else
        for i = 1:length(ActuatorFamily)
            if MatrixFlag
                R(:,i) = sum(Rmat{i}.Data,2);
            else
                R{i} = Rmat{i}.Data;
            end
        end
        Rmat = R;
    end
end

