function [Rmat, OutputFileName] = meastuneresp(varargin)
%MEASTUNERESP - Measures the response from quadrupole to tune
%  [R, FileName] = meastuneresp(ActuatorFamily, ActuatorDeviceList, ActuatorDelta, ModulationMethod, WaitFlag, FileName, DirectoryName, ExtraDelay)
%
%  INPUTS 
%  1. ActuatorFamily = Family name or cell array of family nams {Default: {'QF','QD'}}
%  2. ActuatorDeviceList = Device list {Default: [], the entire family}
%                          (Note: all devices in DeviceList are changed at the same time)
%  3. ActuatorDelta = Change in magnet strength {Default: getfamilydata('ActuatorFamily','Setpoint','DeltaRespMat')}
%  4. ModulationMethod - 'Unipolar' is the default since hysteresis is usually an issue (see help measrespmat)
%  5. If WaitFlag >= 0, then WaitFlag is the delay before measuring the tune (sec)
%                 = -3, then a delay of getfamilydata('TuneDelay') is used {Default} 
%                 = -4, then pause until keyboard input
%                 = -5, then input the tune measurement manually by keyboard input
%  6. Optional input to change the default filename and directory
%     FileName - Filename for the response matrix data
%                (No input or empty means data will be saved to the default file (except for model response matrices))  
%     DirectoryName - Directory name to store the response matrix data file 
%     Note: a. FileName can include the path if DirectoryName is not used
%           b. For model response matrices, FileName must exist for a file save
%           c. When using the default FileName, a dialog box will prompt for changes
%
%  7. ExtraDelay - extra time delay [seconds] after a setpoint change
%
%  8. 'Struct' will return a response matrix structure
%     'Numeric' will return a matrix output {Default}
%     'Matrix'  - Return a matrix output {Default}
%          
%                 Note: 'Matrix' is only a valid flag for Numeric outputs
%                 Often use with the model input.  For example, to compare the model
%                 tune response matrix to the default matrix,
%                 Mmodel = meastuneresp('Model','Matrix');
%                 Mmeas  = gettuneresp;
%
%  9. Optional override of the units:
%     'Physics'  - Use physics  units
%     'Hardware' - Use hardware units
%
%  10. Optional override of the mode:
%      'Online'    - Set/Get data online  
%      'Model'     - Get the model chromaticity directly from AT (uses modeltune)
%      'Simulator' - Set/Get data on the simulated accelerator using AT (ie, same commands as 'Online')
%      'Manual'    - Set/Get data manually
%
%  11. 'Display'    - Prints status information to the command window {Default}
%      'NoDisplay'  - Nothing is printed to the command window
%
%  12. 'Archive' - Save the response matrix structure {Default, unless Mode='Model'}
%      'NoArchive' - Save the response matrix structure
% 
%  OUTPUTS
%  R = Response matrix from delta quadrupole to delta tune
%
%      If more than one quadrupole family is input, the R is a cell array indexed by 
%      quadrupole family (ie, the number of families in ActuatorFamily).  The default
%      is to make R{1} QF and R{2} QD.  R{1} or R.Data for structure output
%      is a 2x(number of quadrupole in family) array.  The first row is horizontal 
%      tuen and the second is vertical.
%
%      Units: delta(Tune) / delta(Quadrupole) is set by the .Units field for the quadrupole family
%             Typically:  Hardware units:  fractional tune / Amp;
%                         Physics  units:  fractional tune / K;
%
%  See also steptune

%  Written by Greg Portmann and Jeff Corbett


% Initialize
ActuatorFamily = findmemberof('Tune Corrector')';
if isempty(ActuatorFamily)
    error('MemberOf ''Tune Corrector'' was not found');
end

ModulationMethod = 'unipolar';
DirectoryName = [];
WaitFlag = -3;
ExtraDelay = 0; 
StructOutputFlag = 0;
MatrixFlag = 1;
DisplayFlag = -1;
ArchiveFlag = -1;
FileName = -1;
ModeFlag = '';  % model, online, manual, or '' for default mode
UnitsFlag = ''; % hardware, physics, or '' for default units
TimeStamp = clock;

InputFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Struct')
        StructOutputFlag = 1;
        MatrixFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Numeric')
        StructOutputFlag = 0;
        NumericOutputFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Matrix')
        MatrixFlag = 1;
        StructOutputFlag = 0;
        NumericOutputFlag = 1;
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
    elseif strcmpi(varargin{i},'unipolar')
        ModulationMethod = 'unipolar';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'bipolar')
        ModulationMethod = 'bipolar';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Model')
        ModeFlag = varargin{i};
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Simulator')
        ModeFlag = varargin{i};
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Online')
        ModeFlag = varargin{i};
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Manual')
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
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    end
end

if length(varargin) >= 1
    ActuatorFamily = varargin{1};  
end

if length(varargin) >= 2
    ActuatorDeviceList = varargin{2};
else
    if iscell(ActuatorFamily)
        for i = 1:length(ActuatorFamily)
            ActuatorDeviceList{i} = [];
        end
    else
        ActuatorDeviceList = [];
    end
end

if length(varargin) >= 3
    ActuatorDelta = varargin{3};  
else
    if iscell(ActuatorFamily)
        for i = 1:length(ActuatorFamily)
            ActuatorDelta{i} = [];
        end
    else
        ActuatorDelta = [];
    end
end

% Force to be a cells
if ~iscell(ActuatorFamily)
    ActuatorFamily = {ActuatorFamily};
end
if ~iscell(ActuatorDeviceList)
    ActuatorDeviceList = {ActuatorDeviceList};
end
if ~iscell(ActuatorDelta)
    ActuatorDelta = {ActuatorDelta};
end

if length(varargin) >= 4
    ModulationMethod = varargin{4};  
end

% WaitFlag input
if length(varargin) >= 5
    WaitFlag = varargin{5};
end
if isempty(WaitFlag) || WaitFlag == -3
    WaitFlag = 2.2*getfamilydata('TuneDelay');
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
        DirectoryName = getfamilydata('Directory', 'TuneResponse');
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


% % Check units (default units is based on the actuator)
% if isempty(UnitsFlag)
%     UnitsFlag = getfamilydata(ActuatorFamily{1},'Setpoint','Units');
% end
% if isempty(UnitsFlag)
%     error('Unknown Units');
% end

% % Check mode
% if isempty(ModeFlag)
%     ModeFlag = getfamilydata(ActuatorFamily{1},'Setpoint','Mode');
% end
% if isempty(ModeFlag)
%     error('Unknown Mode');
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


% Print setup information
% if DisplayFlag
%     if ~strcmpi(ModeFlag,'Model')
%         fprintf('\n');
%         fprintf('   MEASTUNERESP measures the tune response to the quadrupole magnet families.\n');
%         fprintf('   The storage ring lattice and hardware should be setup for properly.\n');
%         fprintf('   Make sure the following information is correct:\n');
%         fprintf('   1.  Proper magnet lattice (including skew quadrupoles)\n');
%         fprintf('   2.  Proper electron beam energy\n');
%         fprintf('   3.  Proper electron bunch pattern\n');
%         fprintf('   4.  Tune is functioning or in manual mode\n');
%         fprintf('   5.  The injection bump magnets off\n\n');
%     end
% end    


% Browse for filename and directory if using default FileName
if ArchiveFlag
    if isempty(FileName)
        FileName = appendtimestamp(getfamilydata('Default', 'TuneRespFile'));
        DirectoryName = getfamilydata('Directory', 'TuneResponse');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'Response', filesep, 'Dispersion', filesep];
        else
            % Make sure default directory exists
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
        end
        [FileName, DirectoryName] = uiputfile('*.mat', 'Select a Dispersion Response File', [DirectoryName FileName]);
        if FileName == 0 
            ArchiveFlag = 0;
            disp('   Dispersion response measurement canceled.');
            Rmat = []; OutputFileName='';
            return
        end
        FileName = [DirectoryName, FileName];
    elseif FileName == -1
        FileName = appendtimestamp(getfamilydata('Default', 'TuneRespFile'));
        DirectoryName = getfamilydata('Directory', 'TuneResponse');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'Response', filesep, 'Dispersion', filesep];
        end
        FileName = [DirectoryName, FileName];
    end
    
    % Acquire initial data
    MachineConfig = getmachineconfig(InputFlags{:});
end


% % Query to begin measurement
% if DisplayFlag
%     tmp = questdlg('Begin response matrix measurement?','MEASTUNERESP','YES','NO','YES');
%     if strcmp(tmp,'NO')
%         fprintf('   Response matrix measurement aborted\n');
%         Rmat = [];
%         return
%     end
% end


% Acquire initial data
if StructOutputFlag || ArchiveFlag               
    X = getx('struct', InputFlags{:});
    Y = gety('struct', InputFlags{:});
end    


% Begin main loop over actuators
TimeStart = gettime;
% TUNE must be a family for this to work
if DisplayFlag
    Rmat = measrespmat('TUNE', [1;2], ActuatorFamily, ActuatorDeviceList, ActuatorDelta, ModulationMethod, WaitFlag, ExtraDelay, 'Struct', 'Display', InputFlags{:});
else
    Rmat = measrespmat('TUNE', [1;2], ActuatorFamily, ActuatorDeviceList, ActuatorDelta, ModulationMethod, WaitFlag, ExtraDelay, 'Struct', 'NoDisplay', InputFlags{:});
end
if StructOutputFlag   
    for i = 1:size(Rmat,1)
        for j = 1:size(Rmat,2)
            if iscell(Rmat)
                Rmat{i,j}.DataDescriptor = 'Tune Response Matrix';
                Rmat{i,j}.CreatedBy = 'meastuneresp';
                
                Rmat{i,j}.X = X;
                Rmat{i,j}.Y = Y;
            else
                Rmat(i,j).DataDescriptor = 'Tune Response Matrix';
                Rmat(i,j).CreatedBy = 'meastuneresp';
                
                Rmat(i,j).X = X;
                Rmat(i,j).Y = Y;
            end
        end
    end
end


% For one family inputs, there is no need for a cell output (probably already done in measrespmat)
if length(Rmat) == 1 && iscell(Rmat)
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
        fprintf('   Tune response matrix data (''Rmat'') saved to disk\n');
        fprintf('   Filename: %s\n', OutputFileName);
        fprintf('   The total response matrix measurement time: %.2f minutes.\n', (gettime-TimeStart)/60);
    end
end


% Put the data part in Rmat
if ~StructOutputFlag
    if length(ActuatorFamily) == 1
        Rmat = Rmat.Data;
    else
        for i = 1:size(Rmat,1)
            for j = 1:size(Rmat,2)
                Rmat{i,j} = Rmat{i,j}.Data;
            end
        end
    end
end

if MatrixFlag && StructOutputFlag
    error('Cannot ask for a matrix and a structure output.');
end


if MatrixFlag
    if length(ActuatorFamily) == 1
        R = sum(Rmat,2);
    else
        if size(Rmat,1) == 1
            for j = 1:size(Rmat,2)
                R(:,j) = sum(Rmat{1,j},2);
            end
        else
            error('Tune response matrix cell array has more than one row (which is very odd)');
        end
    end
    Rmat = R;
end





% % TUNE is not a family, then use gettune
% 
% % Force to be a column vector
% % ActuatorDelta = {getfamilydata('QF','Setpoint','DeltaRespMat'),getfamilydata('QD','Setpoint','DeltaRespMat')};
% ActuatorDelta{i} = ActuatorDelta{i}(:);
% 
% Rmat(i).Data = [];
% Rmat(i).Monitor.FamilyName = 'TUNE';
% Rmat(i).Actuator = getsp(ActuatorFamily{i}, ActuatorDeviceList{i}, 'struct');
% Rmat(i).ActuatorDelta = ActuatorDelta{i};
% Rmat(i).GeV = bend2gev(InputFlags{:});
% Rmat(i).TimeStamp = TimeStamp;
% if strcmp(lower(family2units(ActuatorFamily{i},'Setpoint')),'hardware')
%     Rmat(i).Units = 'Hardware';
%     Rmat(i).UnitsString = '1/Amp';
%     Rmat(i).Monitor.Units = 'Hardware';
% else
%     Rmat(i).Units = 'Physics';
%     Rmat(i).UnitsString = '1/K';
%     Rmat(i).Monitor.Units = 'Physics';
% end
% Rmat(i).ModulationMethod = 'Unipolar';
% Rmat(i).WaitFlag = WaitFlag;
% Rmat(i).DataDescriptor = 'Tune Response Matrix';
% Rmat(i).CreatedBy = 'meastuneresp';
% 
% InitActuator = Rmat(i).Actuator.Data;
% 
% % Acquire initial data
% if StructOutputFlag               
%     Rmat(i).X = getx('struct');
%     Rmat(i).Y = gety('struct');
%     Rmat(i).DCCT = getdcct;
% end    
% 
% % No actuator change for first point
% if DisplayFlag
%     fprintf('   Initial actuator value for %s is %+f\n', ActuatorFamily{i}, InitActuator(1));
%     fprintf('   No change to actuator'); 
%     drawnow;
% end
% 
% % Acquire data
% if DisplayFlag
%     fprintf(', recording data point #1\n'); 
%     drawnow;
% end
% 
% % Wait for tune monitor to have fresh data
% if WaitFlag >= 0
%     fprintf('   Pausing %f seconds for the tune measurement.\n', WaitFlag); 
%     sleep(WaitFlag);
%     Rmat(i).Monitor = gettune('struct');
% elseif WaitFlag == -4
%     tmp = input('   Hit return when the tune measurement is ready. ');
%     Rmat(i).Monitor = gettune('struct');
% elseif WaitFlag == -5
%     Rmat(i).Monitor.Data(1,1) = input('      Input the horizontal tune = ');
%     Rmat(i).Monitor.Data(2,1) = input('      Input the  vertical  tune = ');
%     Rmat(i).Monitor.DeviceList = [1 1;1 2];
%     Rmat(i).Monitor.ElementList = [1; 2];
%     Rmat(i).Monitor.Field = 'Monitor';
%     Rmat(i).Monitor.Status = [1;1];
%     Rmat(i).Monitor.Mode: 'Unknown';
%     Rmat(i).Monitor.t = 0;
%     Rmat(i).Monitor.tout = NaN;
%     Rmat(i).Monitor.TimeStamp = clock;
%     Rmat(i).Monitor.Units = 'Unknown';
%     Rmat(i).Monitor.UnitsString = 'Fractional Tune';
%     Rmat(i).Monitor.DataDescriptor = 'Tune';
%     CreatedBy = 'gettune';
% else
%     error('Tune delay method unknown');
% end 
% TuneMinus = Rmat(i).Monitor.Data;
% 
% % Step actuator up
% if DisplayFlag
%     fprintf('\n   Changing actuator by %+f', ActuatorDelta{i}(1)); 
%     drawnow;            
% end
% setsp(ActuatorFamily{i}, InitActuator+ActuatorDelta{i}, ActuatorDeviceList{i}, WaitFlag);
% 
% % Acquire data
% if DisplayFlag
%     fprintf(', recording data point #2\n'); 
%     drawnow;
% end
% 
% % Wait for tune monitor to have fresh data
% if WaitFlag >= 0
%     fprintf('   Pausing %f seconds for the tune measurement.\n', WaitFlag); 
%     sleep(WaitFlag);
%     TunePlus = gettune;
% elseif WaitFlag == -4
%     tmp = input('   Hit return when the tune measurement is ready. ');
%     TunePlus = gettune;
% elseif WaitFlag == -5
%     TunePlus(1,2) = input('      Input the horizontal tune = ');
%     TunePlus(2,2) = input('      Input the  vertical  tune = ');
% else
%     error('Tune delay method unknown');
% end 
% 
% % Restore actuators
% setsp(ActuatorFamily{i}, InitActuator, ActuatorDeviceList{i}, WaitFlag);
% if DisplayFlag
%     fprintf('   Reset actuator %s \n\n', ActuatorFamily{i}); 
%     drawnow;
% end
% 
% % Compute response matrix columns
% % For each magnet:  1. Divide by the change in amperes [Tune / Ampere]
% %                   2. Scale each magnet by its fractional contribution in physics units 
% if strcmp(lower(family2units(ActuatorFamily{i},'Setpoint')),'hardware')
%     DeltaPhysics = hw2physics(ActuatorFamily{i}, 'Setpoint', InitActuator+ActuatorDelta{i}, ActuatorDeviceList{i}) - hw2physics(ActuatorFamily{i}, 'Setpoint', InitActuator, ActuatorDeviceList{i});
% else
%     DeltaPhysics = ActuatorDelta{i};
% end
% 
% % In order to backout the tune response at each magnet, assume that
% % the tune response at each magnet is equal in physics units.  
% DelTunePerK = (TunePlus-TuneMinus) / sum(DeltaPhysics);
% 
% % Expand to each magnet
% Rmat(i).Data = DelTunePerK * ones(1,length(DeltaPhysics));
% 
% % When in hardware unit convert to delta tune / ampere
% if strcmp(lower(family2units(ActuatorFamily{i},'Setpoint')),'hardware')
%     KPerAmp = DeltaPhysics ./ ActuatorDelta{i};
%     for j = 1:length(DeltaPhysics)
%         Rmat(i).Data(:,j) = KPerAmp(j) * Rmat(i).Data(:,j);
%     end
% end