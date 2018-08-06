function [Rmat, OutputFileName] = measbpmresp(varargin)
%MEASBPMRESP - Measures the BPM response matrix in the horizontal and vertical planes
%
%  For family name, device list inputs:
%  [R, FileName] = measbpmresp(BPMxFamily, BPMxList, BPMyFamily, BPMyList, HCMFamily, HCMList, VCMFamily, VCMList, HCMKicks, VCMKicks, ModulationMethod, WaitFlag, FileName, DirectoryName, ExtraDelay)
%
%  For data structure inputs: 
%  [R, FileName] = measbpmresp(BPMxStruct, BPMyStruct, HCMStruct, VCMStruct, HCMKicks, VCMKicks, ModulationMethod, WaitFlag, FileName, DirectoryName, ExtraDelay)
%
%  INPUTS
%  1. BPMxFamily       - BPMx family name {Default: gethbpmfamily}
%     BPMxDeviceList   - BPMx device list {Default: all devices with good status}
%     or 
%     BPMxStruct can replace BPMxFamily and BPMxList
%
%  2. BPMyFamily       - BPMy family name {Default: getvbpmfamily}
%     BPMyDeviceList   - BPMy device list {Default: all devices with good status}
%     or 
%     BPMyStruct can replace BPMyFamily and BPMyList
%
%  3. HCMFamily       - HCM family name {Default: gethcmfamily}
%     HCMDeviceList   - HCM device list {Default: all devices with good status}
%     or 
%     HCMStruct can replace HCMFamily and HCMList
%
%  4. VCMFamily       - VCM family name {Default: getvcmfamily}
%     VCMDeviceList   - VCM device list {Default: all devices with good status}
%     or 
%     VCMStruct can replace VCMFamily and VCMList
%
%  5. HCMKicks - Change in HCM correctors {Default: getfamilydata(HCMFamily,'Setpoint','DeltaRespMat',HCMDeviceList), then .05 mrad}
%  6. VCMKicks - Change in VCM correctors {Default: getfamilydata(VCMFamily,'Setpoint','DeltaRespMat',VCMDeviceList), then .05 mrad}
%
%  7. ModulationMethod - Method for changing the ActuatorFamily
%                       'bipolar' changes the ActuatorFamily by +/- ActuatorDelta/2 on each step {Default}
%                       'unipolar' changes the ActuatorFamily from 0 to ActuatorDelta on each step
%
%  8. WaitFlag - (see setpv for WaitFlag definitions) {Default: -2}
%                WaitFlag = -5 will override gets to manual mode
%
%  9. Optional input to change the default filename and directory
%     FileName - Filename for the response matrix data
%                (Empty prompts for a filename)  
%     DirectoryName - Directory name to store the response matrix data file 
%     Note: a. FileName can include the path if DirectoryName is not used
%           b. For model response matrices, FileName must exist for a file save
%           c. The 'Achive' flag is another way to input the filename
%
%  10. ExtraDelay - extra time delay [seconds] after a setpoint change
%
%  11. 'Struct'  - Output will be a response matrix structure {Default for     data structure inputs}
%      'Numeric' - Output will be a numeric matrix            {Default for non-data structure inputs}
%
%  12. Optional override of the units:
%      'Physics'  - Use physics  units
%      'Hardware' - Use hardware units
%
%  13. Optional override of the mode:
%      'Online'    - Set/Get data online  
%      'Model'     - Set/Get data directly from AT (uses locoresponsematrix)
%      'Simulator' - Set/Get data on the simulated accelerator using AT (ie, same commands as 'Online')
%      'Manual'    - Set/Get data manually
%
%  14. 'Display'   - Prints status information to the command window {Default}
%      'NoDisplay' - Nothing is printed to the command window
%
%  15. 'NoArchive' - No file archive
%      'Archive'   - Save the response matrix data to \<Directory.BPMResponse>\<BPMRespFile><Date><Time>.mat
%                    To change the filename, included the filename after the 'Archive', '' to browse
%
%  16. 'MinimumBeamCurrent' - Minimum beam current before prompting for a refill
%                             The current (as returned by getdcct) must follow the flag. 
%                             measbpmresp('MinimumBeamCurrent', 32.1) 
%                             will pause at a beam current of 32.1 and prompt for a refill.
%
%  17. Optional inputs when computing model response matrices:
%      'FixedPathLength' or 'FixedMomentum' - hold the path length or momentum fixed  {Default: 'FixedPathLength'}
%      'Full' or 'Linear' - use full nonlinear model or linear approximation (faster) {Default: 'Linear'}
%      Note: The ModulationMethod input (7) is also used for the model calculation.
%
%  OUTPUTS
%  1. R = Orbit response matrix (delta(orbit)/delta(Kick))
%
%     Numeric Output:
%       R = [xx xy
%            yx yy]
%
%     Stucture Output:
%     R(BPM Plane, Corrector Plane) - 2x2 struct array
%     R(1,1).Data=xx;  % Kick x, look x
%     R(2,1).Data=yx;  % Kick x, look y
%     R(1,2).Data=xy;  % Kick y, look x
%     R(2,2).Data=yy;  % Kick y, look y
%           
%     R(Monitor, Actuator).Data - Response matrix
%                         .Monitor  - BPM data structure (starting orbit)
%                         .Monitor1 - BPM matrix (first  data point)
%                         .Monitor2 - BPM matrix (second data point)
%                         .Actuator - Corrector data structure
%                         .ActuatorDelta - Corrector kick vector
%                         .GeV - Electron beam energy
%                         .ModulationMethod - 'unipolar' or 'bipolar'
%                         .WaitFlag - Wait flag used when acquiring data
%                         .ExtraDelay - Extra time delay 
%                         .TimeStamp
%                         .CreatedBy
%                         .DCCT
%
%  2. FileName = File name (including directory) where the data was saved (if applicable)
%                (a machine configuration structure is saved in the data file as well)
%
%  NOTES
%  1. [] can be used on any input to obtain the default setting.
%     However, most inputs can be left out altogether to get the default.
%  2. For Mode = 'Model':
%     a. AT family names (or 'All') can be used and DeviceList is ignored
%     b. There is a lot of flexibility for getting response matrices, for instance,
%        R = measbpmresp('QF', 'QD', 'HCM', 'VCM', 'Model', 'Physics');
%        is the response matrix from the correctors to orbit at the sextupoles.
%        The units when using nonstandard families for BPMs is always 'physics', meter/radian.  
%  3. Cell inputs are not allowed.
%  4. BPM roll and crunch and corrector magnet roll errors are included only if they are 
%     in the AT model (field .GCR for BPMs and .Roll for correctors). 
%     BPM and corrector magnet gains are included in hardware units (not physics units). 
%  5. This function measures response matrices from 2 BPM families to 2 corrector families.  
%     If only one family is needed then use measrespmat.
%
%  EXAMPLES
%  1. Default:
%       R = measbpmresp;
%       is the same as,
%       R = measbpmresp(gethbpmfamily, getvbpmfamily, gethcmfamily, getvcmfamily, 'Online', 'Bipolar', 'Numeric', 'Archive');
%
%  2. Default using the model:
%       R = measbpmresp('Model');
%       is the same as,
%       R = measbpmresp(gethbpmfamily, getvbpmfamily, gethcmfamily, getvcmfamily, 'Model', 'Bipolar', 'Numeric', 'NoArchive', 'FixedPathLength', 'Linear');
%
%  3. Compare measured (or Default) and model BPM response
%     Rmeas  = getbpmresp;
%     Rmodel = measbpmresp('Model');
%     subplot(2,1,1);
%     surf(Rmeas);  title('Default BPM Response'); xlabel('BPM #'); ylabel('CM #'); zlabel('[mm/amp]');
%     subplot(2,1,2);
%     surf(Rmeas-Rmodel);  title('Default - Model BPM Response'); xlabel('BPM #'); ylabel('CM #'); zlabel('[mm/amp]');
%
%  See also getbpmresp, measrespmat, meastuneresp, measchroresp

%  Written by Greg Portmann


% Initialize defaults
BPMxFamily = gethbpmfamily; 
BPMxList = [];

BPMyFamily = getvbpmfamily;
BPMyList = [];

HCMFamily = gethcmfamily;
HCMList = [];
HCMKicks = [];
Default2HCMKick = .05e-3;  % Radians, if getfamilydata(HCMFamily,'Setpoint','DeltaRespMat') is empty

VCMFamily = getvcmfamily;
VCMList = [];
VCMKicks = [];
Default2VCMKick = .05e-3;  % Radians, if getfamilydata(VCMFamily,'Setpoint','DeltaRespMat') is empty
ModulationMethod = 'bipolar';

% Map MML to LOCO naming
if strcmpi(ModulationMethod, 'bipolar')
    LOCORespFlags.ResponseMatrixMeasurement = 'Bidirectional';   % 'oneway'' or ''bidirectional'
else
    LOCORespFlags.DispersionMeasurement     = 'Bidirectional';
end
if isstoragering
    LOCORespFlags.ResponseMatrixCalculator  = 'Linear';
    LOCORespFlags.ClosedOrbitType           = 'fixedpathlength';
    LOCORespFlags.MachineType               = 'StorageRing';
else
    % Full is usually as fast as Linear for transport lines
    LOCORespFlags.ResponseMatrixCalculator  = 'full';
    LOCORespFlags.ClosedOrbitType           = 'fixedmomentum';
    LOCORespFlags.MachineType               = 'Transport';
end

WaitFlag = -2;
ExtraDelay = 0; 
StructOutputFlag = 0;
NumericOutputFlag = 0;
DisplayFlag = -1;
ArchiveFlag = -1;
FileName = -1;
DirectoryName = '';
ModeFlag = '';  % model, online, manual, or '' for default mode
UnitsFlag = ''; % hardware, physics, or '' for default units

InputFlags = {};
DCCTFlag = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Struct')
        StructOutputFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Numeric')
        StructOutputFlag = 0;
        NumericOutputFlag = 1;
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
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        InputFlags = [InputFlags varargin(i)];
        varargin(i) = [];

    elseif strcmpi(varargin{i},'unipolar') || strcmpi(varargin{i},'oneway')
        ModulationMethod = 'unipolar';
        LOCORespFlags.ResponseMatrixMeasurement = 'oneway';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'bipolar') || strcmpi(varargin{i},'bidirectional')
        ModulationMethod = 'bipolar';
        LOCORespFlags.ResponseMatrixMeasurement = 'bidirectional';
        varargin(i) = [];

    elseif strcmpi(varargin{i},'FixedPathLength')
        LOCORespFlags.ClosedOrbitType = 'FixedPathLength';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'FixedMomentum')
        LOCORespFlags.ClosedOrbitType = 'FixedMomentum';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Linear')
        LOCORespFlags.ResponseMatrixCalculator = 'Linear';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Full')
        LOCORespFlags.ResponseMatrixCalculator = 'Full';
        varargin(i) = [];

    elseif strcmpi(varargin{i},'MinimumBeamCurrent')
        DCCTFlag = [varargin(i) varargin(i+1)];
        varargin(i+1) = [];
        varargin(i)   = [];
    end
end

%%%%%%%%%%%%%%%%
% Parse Inputs %
%%%%%%%%%%%%%%%%

% Look for BPMx family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        BPMxFamily = varargin{1}.FamilyName;
        BPMxList = varargin{1}.DeviceList;

        % For structure inputs, units are determined by the first input
        if isempty(UnitsFlag)
            UnitsFlag = varargin{1}.Units;
        end

        varargin(1) = [];
        
        % Only change StructOutputFlag if 'Numeric' is not on the input line
        if ~NumericOutputFlag
            StructOutputFlag = 1;
        end
    elseif ischar(varargin{1})
        BPMxFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                BPMxList = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        BPMxList = varargin{1};
        varargin(1) = [];
    end
end
if isempty(BPMxList)
    BPMxList = family2dev(BPMxFamily, 1);
end

% Look for BPMy family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        BPMyFamily = varargin{1}.FamilyName;
        BPMyList = varargin{1}.DeviceList;
        varargin(1) = [];
        if ~NumericOutputFlag
            StructOutputFlag = 1; % Only change StructOutputFlag if 'Numeric' is not on the input line
        end
    elseif ischar(varargin{1})
        BPMyFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                BPMyList = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        BPMyList = varargin{1};
        varargin(1) = [];
    end
end
if isempty(BPMyList)
    BPMyList = family2dev(BPMyFamily, 1);
end

% Look for HCM family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        HCMFamily = varargin{1}.FamilyName;
        HCMList = varargin{1}.DeviceList;
        varargin(1) = [];
        if ~NumericOutputFlag
            StructOutputFlag = 1; % Only change StructOutputFlag if 'Numeric' is not on the input line
        end
    elseif ischar(varargin{1})
        HCMFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                HCMList = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        HCMList = varargin{1};
        varargin(1) = [];
    end
end
if isempty(HCMList)
    HCMList = family2dev(HCMFamily, 1);
end

% Look for VCM family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        VCMFamily = varargin{1}.FamilyName;
        VCMList = varargin{1}.DeviceList;
        varargin(1) = [];
        if ~NumericOutputFlag
            StructOutputFlag = 1; % Only change StructOutputFlag if 'Numeric' is not on the input line
        end
    elseif ischar(varargin{1})
        VCMFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                VCMList = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        VCMList = varargin{1};
        varargin(1) = [];
    end
end
if isempty(VCMList)
    VCMList = family2dev(VCMFamily, 1);
end

% Look for HCMKicks
if length(varargin) >= 1
    if isempty(varargin{1})
        % Use default
        varargin(1) = [];
    elseif isnumeric(varargin{1})
        HCMKicks = varargin{1};
        varargin(1) = [];
    end
end

% Look for VCMKicks
if length(varargin) >= 1
    if isempty(varargin{1})
        % Use default
        varargin(1) = [];
    elseif isnumeric(varargin{1})
        VCMKicks = varargin{1};
        varargin(1) = [];
    end
end

% ModulationMethod has already been searched for
% % Look for ModulationMethod 
% if length(varargin) >= 1
%     if isempty(varargin{1})
%         % Use default
%         varargin(1) = [];
%     end
%     if ischar(varargin{1})
%         ModulationMethod = varargin{1};
%         varargin(1) = [];
%     end
% end
if ~strcmpi(ModulationMethod, 'unipolar') && ~strcmpi(ModulationMethod, 'bipolar')
    error('ModulationMethod must be ''unipolar'' or ''bipolar''');
end


% Look for WaitFlag
if length(varargin) >= 1
    if isempty(varargin{1})
        % Use default
        varargin(1) = [];
    end
    if isnumeric(varargin{1})
        WaitFlag = varargin{1};
        varargin(1) = [];
    end
end

% FileName and DirectoryName
if length(varargin) >= 1
    if isempty(varargin{1})
        % Use default
        FileName = '';
        varargin(1) = [];
    end
    if ischar(varargin{1})
        FileName = varargin{1};
        varargin(1) = [];
    end
end
if length(varargin) >= 1
    if isempty(varargin{1})
        % Use default
        DirectoryName = getfamilydata('Directory', 'BPMResponse');
        FileName = [DirectoryName, FileName];
        varargin(1) = [];
    elseif ischar(varargin{1})
        DirectoryName = varargin{1};
        if strcmp(DirectoryName, filesep)
            FileName = [DirectoryName, FileName];
        else
            FileName = [DirectoryName, filesep, FileName];
        end
        varargin(1) = [];
    end
end

% Look for ExtraDelay
if length(varargin) >= 1
    if isempty(varargin{1})
        % Use default
        varargin(1) = [];
    end
    if isnumeric(varargin{1})
        ExtraDelay = varargin{1};
        varargin(1) = [];
    end
end

% Check units
if isempty(UnitsFlag)
    if strcmpi(getfamilydata(BPMxFamily,'Monitor','Units'), getfamilydata(BPMyFamily,'Monitor','Units'))
        UnitsFlag = getfamilydata(BPMxFamily,'Monitor','Units');
    else
        error('Mixed Units for orbits');
    end
end
if isempty(UnitsFlag)
    error('Unknown Units');
end

% Check mode
if isempty(ModeFlag)
    if strcmpi(getfamilydata(BPMxFamily,'Monitor','Mode'), getfamilydata(BPMyFamily,'Monitor','Mode'))
        %ModeFlag = getfamilydata(BPMxFamily,'Monitor','Mode');
    else
        error('Mixed Mode for orbits');
    end
    if strcmpi(getfamilydata(HCMFamily,'Monitor','Mode'), getfamilydata(VCMFamily,'Monitor','Mode'))
        ModeFlag = getfamilydata(HCMFamily,'Monitor','Mode');
    else
        error('Mixed Mode for correctors');
    end
end
if isempty(ModeFlag)
    error('Unknown Mode');
end
% Input parsing complete


% Starting time
TimeStart = gettime;


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

% % Print setup information
% if DisplayFlag
%     if ~strcmpi(ModeFlag,'Model')
%         fprintf('\n');
%         fprintf('   MEASBPMRESP measures the BPM response matrix for both HCM & VCM corrector families.\n');
%         fprintf('   The storage ring lattice and hardware should be setup for accurate orbit measurements.\n');
%         fprintf('   Make sure the following information is correct:\n');
%         fprintf('   1.  Proper magnet lattice\n');
%         fprintf('   2.  Proper electron beam energy\n');
%         fprintf('   3.  Proper electron bunch pattern\n');
%         fprintf('   4.  BPMs are functioning properly (calibrated, sample rate, etc.)\n');
%         fprintf('   5.  Corrector magnets are working\n');
%         fprintf('   6.  The injection bump magnets off\n');
%         fprintf('   7.  Corrector Settle Time WaitFlag=%f, Extra BPM Delay=%f\n', WaitFlag, ExtraDelay);
%         fprintf('   9.  Modulation Method: %s\n', ModulationMethod);
%     end
% end


if ArchiveFlag
    if isempty(FileName)
        FileName = appendtimestamp(getfamilydata('Default', 'BPMRespFile'));
        DirectoryName = getfamilydata('Directory', 'BPMResponse');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot'), 'Response', filesep, 'BPM', filesep];
        else
            % Make sure default directory exists
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
        end
        [FileName, DirectoryName] = uiputfile('*.mat', 'Select a BPM Response File ("Save" starts measurement)', [DirectoryName FileName]);
        drawnow;
        if FileName == 0 
            ArchiveFlag = 0;
            disp('   BPM response measurement canceled.');
            Rmat = []; OutputFileName='';
            return
        end
        FileName = [DirectoryName, FileName];
    elseif FileName == -1
        FileName = appendtimestamp(getfamilydata('Default', 'BPMRespFile'));
        DirectoryName = getfamilydata('Directory', 'BPMResponse');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot'), 'Response', filesep, 'BPM', filesep];
        end
        FileName = [DirectoryName, FileName];
    end
    
    % Acquire initial data
    MachineConfig = getmachineconfig(InputFlags{:}); 
end


% Get the response matrices
if strcmpi(ModeFlag,'Model')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Model Response Matrix - Use LOCO Method %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Just to make sure the proper AT model is the currrent model, do a get on one of the correctors
    % (This is needed because locoresponsematrix does not check the .AT.ATModel field)
    if isfamily(HCMFamily)
        tmp = getsp(HCMFamily, HCMList, 'Model');
    end


    % % Mask bpms and correctors for status
    % BPMxStatus = getfamilydata(BPMxFamily,'Status', BPMxList);
    % BPMxGoodIndex = find(BPMxStatus);
    % BPMxList = BPMxList(BPMxGoodIndex,:);
    % 
    % BPMyStatus = getfamilydata(BPMyFamily,'Status', BPMyList);
    % BPMyGoodIndex = find(BPMyStatus);
    % BPMyList = BPMyList(BPMyGoodIndex,:);
    % 
    % HCMStatus = getfamilydata(HCMFamily,'Status', HCMList);
    % HCMGoodIndex = find(HCMStatus);
    % HCMList = HCMList(HCMGoodIndex,:);
    % HCMKicks = HCMKicks(HCMGoodIndex);
    % 
    % VCMStatus = getfamilydata(VCMFamily,'Status', VCMList);
    % VCMGoodIndex = find(VCMStatus);
    % VCMList = VCMList(VCMGoodIndex,:);
    % VCMKicks = VCMKicks(VCMGoodIndex);
    
    % Use AT (LOCO method)
    
    % 1. AT MODEL
    global THERING
    %setcavity off;
    RINGData.Lattice = THERING;
    iCavity = findcells(THERING, 'Frequency');
    if isempty(iCavity)
        if isstoragering
            RINGData.CavityFrequency  = getrf('Model', 'Physics');
            RINGData.CavityHarmNumber = getfamilydata('HarmonicNumber');
        else
            RINGData.CavityFrequency  = [];
            RINGData.CavityHarmNumber = [];
        end
    else
        RINGData.CavityFrequency  = THERING{iCavity(1)}.Frequency;
        RINGData.CavityHarmNumber = THERING{iCavity(1)}.HarmNumber;
    end
    
    
    % 2. BPM STRUCTURE
    % FamName and BPMIndex tells the findorbitrespm function which BPMs are needed in the response matrix 
    % HBPMIndex/VBPMIndex is the sub-index of BPMIndex which correspond to the measured response matrix
    if strcmpi(BPMxFamily,'All') 
        BPMxATIndex = 1:length(THERING);
    elseif isfamily(BPMxFamily)
        BPMxATIndex = family2atindex(BPMxFamily, BPMxList);
    else
        BPMxATIndex = findcells(THERING, 'FamName', BPMxFamily);
    end
    if isempty(BPMxATIndex)
        error(sprintf('BPMxFamily=%s could not be found in the AO or AT deck', BPMxFamily));
    else
        BPMxATIndex = BPMxATIndex(:)';    % Row vector
    end
    
    if strcmpi(BPMyFamily,'All') 
        BPMyATIndex = 1:length(THERING);
    elseif isfamily(BPMyFamily)
        BPMyATIndex = family2atindex(BPMyFamily, BPMyList);
    else
        BPMyATIndex = findcells(THERING, 'FamName', BPMyFamily);
    end
    if isempty(BPMyATIndex)
        error(sprintf('BPMyFamily=%s could not be found in the AO or AT deck', BPMyFamily));
    else
        BPMyATIndex = BPMyATIndex(:)';    % Row vector
    end
    
    BPMData.BPMIndex = unique([BPMxATIndex BPMyATIndex]);
    BPMData.HBPMIndex = findrowindex(BPMxATIndex', BPMData.BPMIndex');  % Only used after locoresponsematrix is called
    BPMData.VBPMIndex = findrowindex(BPMyATIndex', BPMData.BPMIndex');  % Only used after locoresponsematrix is called
        
    
    % 3. CORRECTOR MAGNET STRUCTURE
    % FamName and HCMIndex/VCMIndex tells the findorbitrespm function which corrector magnets are in the response matrix
    % CMData.HCMKicks = starting value for the horizontal kicks in milliradian
    % CMData.VCMKicks = starting value for the vertical   kicks in milliradian
    % CMData.HCMCoupling = starting value for the horizontal coupling (default: zeros)
    % CMData.VCMCoupling = starting value for the vertical   coupling (default: zeros)
    % Note:  The kick strength should match the measured response matrix as best as possible
    % Note:  The kicks and Coupling are used all the time (fit or not!)
    
    % Note the different units between AT and LOCO
    if strcmpi(HCMFamily,'All') 
        ATIndex = 1:length(THERING);
    elseif isfamily(HCMFamily)
        ATIndex = family2atindex(HCMFamily, HCMList);
    else
        ATIndex = findcells(THERING, 'FamName', HCMFamily);
    end
    if isempty(ATIndex)
        error(sprintf('HCMFamily=%s could not be found in the middle layer or AT model', HCMFamily));
    else
        ATIndex = ATIndex(:)';    % Row vector
    end
    CMData.HCMIndex = ATIndex;
    
    if strcmpi(VCMFamily,'All') 
        ATIndex = 1:length(THERING);
    elseif isfamily(VCMFamily)
        ATIndex = family2atindex(VCMFamily, VCMList);
    else
        ATIndex = findcells(THERING, 'FamName', VCMFamily);
    end
    if isempty(ATIndex)
        error(sprintf('VCMFamily=%s could not be found in the middle layer or AT model', VCMFamily));
    else
        ATIndex = ATIndex(:)';    % Row vector
    end
    CMData.VCMIndex = ATIndex;
    
    % Kicks must be in Physics units
    
    % Default kicks 
    if ismemberof(HCMFamily,'COR')
        if isempty(HCMKicks)
            HCMKicks = getfamilydata(HCMFamily, 'Setpoint', 'DeltaRespMat', HCMList);
            if isempty(HCMKicks)
                CMData.HCMKicks = Default2HCMKick;
            else
                %if strcmpi(getfamilydata(HCMFamily, 'Setpoint', 'Units'), 'Hardware') 
                    HCMsp = getsp(HCMFamily, HCMList, 'Numeric', ModeFlag, 'Hardware');
                    CMData.HCMKicks = hw2physics(HCMFamily, 'Setpoint', HCMsp+HCMKicks, HCMList) - hw2physics(HCMFamily, 'Setpoint', HCMsp, HCMList);
                %else
                %    CMData.HCMKicks = HCMKicks;
                %end
            end
        else
            if strcmpi(UnitsFlag, 'Hardware')
                % Change to AT units [radian]
                HCMsp = getsp(HCMFamily, HCMList, 'Numeric', ModeFlag, 'Hardware');
                CMData.HCMKicks = hw2physics(HCMFamily, 'Setpoint', HCMsp+HCMKicks, HCMList) - hw2physics(HCMFamily, 'Setpoint', HCMsp, HCMList);
            else
                CMData.HCMKicks = HCMKicks;
            end
        end
    else
        % Not a corrector magnet location
        if isempty(HCMKicks)
            CMData.HCMKicks = Default2HCMKick; 
        else
            % The kick must be in physics units
            if strcmpi(UnitsFlag, 'Hardware')
                fprintf('\n   You are using a non-corrector magnet actuator type and using hardware units.\n');
                fprintf('   Unknown conversion method from hardware to physics.\n\n');
                fprintf('   Change to a physics units input scheme.\n');
                error('Hardware to physics conversion error');
            else
                CMData.HCMKicks = HCMKicks;    
            end
        end
    end
    
    if ismemberof(VCMFamily,'COR')
        if isempty(VCMKicks)
            VCMKicks = getfamilydata(VCMFamily, 'Setpoint', 'DeltaRespMat', VCMList);
            if isempty(VCMKicks)
                CMData.VCMKicks = Default2VCMKick;
            else
                %if strcmpi(getfamilydata(VCMFamily, 'Setpoint', 'Units'), 'Hardware') 
                    VCMsp = getsp(VCMFamily, VCMList, 'Numeric', ModeFlag, 'Hardware');
                    CMData.VCMKicks = hw2physics(VCMFamily, 'Setpoint', VCMsp+VCMKicks, VCMList) - hw2physics(VCMFamily, 'Setpoint', VCMsp, VCMList);
                %else
                %    CMData.VCMKicks = VCMKicks;
                %end
            end
        else
            if strcmpi(UnitsFlag, 'Hardware')
                % Change to AT units [radian]
                VCMsp = getsp(VCMFamily, VCMList, 'Numeric', ModeFlag, 'Hardware');
                CMData.VCMKicks = hw2physics(VCMFamily, 'Setpoint', VCMsp+VCMKicks, VCMList) - hw2physics(VCMFamily, 'Setpoint', VCMsp, VCMList);
            else
                CMData.VCMKicks = VCMKicks;
            end
        end
    else
        % Not a corrector magnet location
        if isempty(VCMKicks)
            CMData.VCMKicks = Default2VCMKick;
        else
            % The kick must be in physics units
            if strcmpi(UnitsFlag, 'Hardware')
                fprintf('\n   You are using a non-corrector magnet actuator type and using hardware units.\n');
                fprintf('   Unknown conversion method from hardware to physics!\n\n');
                fprintf('   Change to a physics units input scheme.\n');
                error('Hardware to physics conversion error');
            else
                CMData.VCMKicks = VCMKicks;    
            end
        end
    end
    
    CMData.HCMKicks = CMData.HCMKicks(:);
    if length(CMData.HCMKicks) == 1
        CMData.HCMKicks = CMData.HCMKicks * ones(length(CMData.HCMIndex),1); 
    end
    CMData.VCMKicks = CMData.VCMKicks(:);
    if length(CMData.VCMKicks) == 1
        CMData.VCMKicks = CMData.VCMKicks * ones(length(CMData.VCMIndex),1); 
    end
    
    % Corrector gain error have been taken into account by hw2physics
    % If the model has corrector rolls, adjust the kicks now.
    
    for i = 1:length(CMData.HCMIndex)
        if isfield(THERING{CMData.HCMIndex(i)}, 'Roll')            
            Roll = THERING{CMData.HCMIndex(i)}.Roll;
        else
            Roll = [0 0];  % [Rollx Rolly]
        end
        HCMRoll(i,1) = Roll(1); 
    end
    %HCMRoll = getroll(HCMFamily, HCMList);
    
    for i = 1:length(CMData.VCMIndex)
        if isfield(THERING{CMData.VCMIndex(i)}, 'Roll')            
            Roll = THERING{CMData.VCMIndex(i)}.Roll;
        else
            Roll = [0 0];  % [Rollx Rolly]
        end
        VCMRoll(i,1) = Roll(2); 
    end
    %VCMRoll = getroll(VCMFamily, VCMList);

    % The kicks need to be adjusted for roll (model coordinates)
    HCMKicks = CMData.HCMKicks;
    VCMKicks = CMData.VCMKicks;
    CMData.HCMKicks = CMData.HCMKicks .* cos(HCMRoll);
    CMData.VCMKicks = CMData.VCMKicks .* cos(VCMRoll);
    
    
    % Coupling term (convert from ML to LOCO coordinates)
    % The ./cos term is needed because LOCO coupling is scaling the unrolled kick 
    CMData.HCMCoupling =  sin(HCMRoll) ./ cos(HCMRoll);
    CMData.VCMCoupling = -sin(VCMRoll) ./ cos(VCMRoll);
    

    % Generate a response matrix ('FixedPathLength' or 'FixedMomentum', 'Linear' or 'Full')
    % Flags is empty then the locoresponsematrix defaults are used (which was fix path length, linear the last time I checked)
    R0 = locoresponsematrix(RINGData, BPMData, CMData, LOCORespFlags);

    
    % Coupling correction    
    % Convert the ML gain/rolls to LOCO gain/coupling
    % for i = 1:length(BPMData.BPMIndex)
    %     if isfield(THERING{BPMData.BPMIndex(i)}, 'GCR')            
    %         GCR = THERING{BPMData.BPMIndex(i)}.GCR;
    %     else
    %         GCR = [1 1 0 0];  % [Gx Gy Crunch Roll]
    %     end
    %     
    %     M = gcr2loco(GCR(1), GCR(2), GCR(3), GCR(4));
    %     BPMxGainLOCO(i,1)     = M(1,1);
    %     BPMxCouplingLOCO(i,1) = M(1,2);
    %     BPMyGainLOCO(i,1)     = M(2,2);
    %     BPMyCouplingLOCO(i,1) = M(2,1);
    % end
    % 
    % 
    % % Build a rotation matrix 
    % C = [diag(BPMxGainLOCO)      diag(BPMxCouplingLOCO)
    %      diag(BPMyCouplingLOCO)  diag(BPMyGainLOCO)];

    
    % BPM coupling correction (only roll, crunch correction, gain is done in physics2hw (via real2raw))   
    % Still in physics units, just rotate and crunch.
    NBPM = length(BPMData.BPMIndex);
    for i = 1:NBPM
        if isfield(THERING{BPMData.BPMIndex(i)}, 'GCR')            
            GCR = THERING{BPMData.BPMIndex(i)}.GCR;
        else
            GCR = [1 1 0 0];  % [Gx Gy Crunch Roll]
        end
        %Gx = GCR(1);  % Not used 
        %Gy = GCR(2);  % Not used 
        Crunch = GCR(3);
        Roll = GCR(4);
        
        a(i,1) = ( Crunch * sin(Roll) + cos(Roll)) / sqrt(1 - Crunch^2);
        b(i,1) = (-Crunch * cos(Roll) + sin(Roll)) / sqrt(1 - Crunch^2);
        c(i,1) = (-Crunch * cos(Roll) - sin(Roll)) / sqrt(1 - Crunch^2);
        d(i,1) = (-Crunch * sin(Roll) + cos(Roll)) / sqrt(1 - Crunch^2);

        % Same as:
        %%m = gcr2loco(GCR(1), GCR(2), GCR(3), GCR(4));
        %m = gcr2loco(1, 1, GCR(3), GCR(4));
        %a(i,1)= m(1,1);
        %b(i,1)= m(1,2);
        %c(i,1)= m(2,1);
        %d(i,1)= m(2,2);
    end
  
    % Build a rotation matrix 
    C = [diag(a)  diag(b)
         diag(c)  diag(d)];

    % Rotate & crunch the AT model response matrix
    R0 = C * R0;
    

    % Split up R0 into an array
    Rmat(1,1).Data = R0(                         BPMData.HBPMIndex , 1:length(CMData.HCMIndex));
    Rmat(2,1).Data = R0(length(BPMData.BPMIndex)+BPMData.VBPMIndex , 1:length(CMData.HCMIndex));
    Rmat(1,2).Data = R0(                         BPMData.HBPMIndex , length(CMData.HCMIndex)+(1:length(CMData.VCMIndex)));
    Rmat(2,2).Data = R0(length(BPMData.BPMIndex)+BPMData.VBPMIndex , length(CMData.HCMIndex)+(1:length(CMData.VCMIndex)));
    
    
    % Convert to meters/radian (don't use the rolled kick strength)
    for i = 1:length(CMData.HCMKicks)
        Rmat(1,1).Data(:,i) = Rmat(1,1).Data(:,i) / HCMKicks(i);
        Rmat(2,1).Data(:,i) = Rmat(2,1).Data(:,i) / HCMKicks(i);
    end
    
    for i = 1:length(CMData.VCMKicks)
        Rmat(1,2).Data(:,i) = Rmat(1,2).Data(:,i) / VCMKicks(i);
        Rmat(2,2).Data(:,i) = Rmat(2,2).Data(:,i) / VCMKicks(i);
    end
    
    
    % Build the rest of the response matrix structure in 'Physics' units
    
    if ismemberof(BPMxFamily,'BPM') && ismemberof(BPMyFamily,'BPM')
        % getpvmodel is better because crunch and roll are included
        Xat = getam(BPMxFamily, BPMxList, 'Physics', 'Model');
        Yat = getam(BPMyFamily, BPMyList, 'Physics', 'Model');
    else
        % The orbit does not have to be at the BPMs so use modeltwiss  
        [Xat, Yat, Sx, Sy] = modeltwiss('ClosedOrbit', BPMxFamily, BPMxList, BPMyFamily, BPMyList);
    end
    X.Data = Xat(:);
    Y.Data = Yat(:);
    X.FamilyName = BPMxFamily;
    Y.FamilyName = BPMyFamily;
    X.Field = 'Monitor';
    Y.Field = 'Monitor';
    X.DeviceList = BPMxList;
    Y.DeviceList = BPMyList;
    X.Status = ones(length(Xat),1);
    Y.Status = ones(length(Yat),1);
    X.Mode = 'Model';
    Y.Mode = 'Model';
    X.t = 0;
    Y.t = 0;
    X.tout = 0;
    Y.tout = 0;
    X.TimeStamp = clock;
    Y.TimeStamp = X.TimeStamp;
    X.Units = 'Physics';
    Y.Units = 'Physics';
    X.UnitsString = 'm';
    Y.UnitsString = 'm';
    X.DataDescriptor = 'Horizontal Orbit';
    Y.DataDescriptor = 'Vertical Orbit';
    X.CreatedBy = 'getpv';
    Y.CreatedBy = 'getpv';
    
    HCMsp = getsp(HCMFamily, HCMList, 'Struct', 'Model', 'Physics');
    VCMsp = getsp(VCMFamily, VCMList, 'Struct', 'Model', 'Physics');
    Rmat(1,1).Monitor = X;
    Rmat(1,1).Actuator = HCMsp;
    Rmat(1,2).Monitor = X;
    Rmat(1,2).Actuator = VCMsp;
    Rmat(2,1).Monitor = Y;
    Rmat(2,1).Actuator = HCMsp;
    Rmat(2,2).Monitor = Y;
    Rmat(2,2).Actuator = VCMsp;
    
    Rmat(1,1).ActuatorDelta = HCMKicks;  %CMData.HCMKicks;
    Rmat(2,1).ActuatorDelta = HCMKicks;  %CMData.HCMKicks;
    Rmat(1,2).ActuatorDelta = VCMKicks;  %CMData.VCMKicks;
    Rmat(2,2).ActuatorDelta = VCMKicks;  %CMData.VCMKicks;
    
    for i = 1:2
        for j = 1:2
            Rmat(i,j).GeV = getenergymodel;
            Rmat(i,j).TimeStamp = X.TimeStamp;
            Rmat(i,j).DCCT = [];
            Rmat(i,j).ModulationMethod = ModulationMethod;
            Rmat(i,j).WaitFlag = WaitFlag;
            Rmat(i,j).ExtraDelay = ExtraDelay;
            Rmat(i,j).Units = 'Physics';
            Rmat(i,j).UnitsString = [Rmat(1,1).Monitor.UnitsString, '/', Rmat(1,1).Actuator.UnitsString];
            Rmat(i,j).DataDescriptor = 'Response Matrix';
            Rmat(i,j).CreatedBy = 'measbpmresp';
            Rmat(i,j).OperationalMode = getfamilydata('OperationalMode');
        end
    end
            
    if strcmpi(UnitsFlag, 'Hardware')
        % Change to hardware units [mm/amp]
        if ismemberof(BPMxFamily,'BPM') && ismemberof(BPMyFamily,'BPM') && ismemberof(HCMFamily,'COR') && ismemberof(VCMFamily,'COR')
            Rmat = physics2hw(Rmat, getenergymodel);
        else
            fprintf('\n   You are asking for hardware units, but a nonstandard monitor and/or\n');
            fprintf('   actuator was used.  The response matrix will stay in physics units!\n\n');
        end
    end

else
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Online or Simulated Response Matrix %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Default kicks 
    if isempty(HCMKicks)
        HCMKicks = getfamilydata(HCMFamily, 'Setpoint', 'DeltaRespMat', HCMList);
        KickUnits = 'Hardware'; %getfamilydata(HCMFamily, 'Setpoint', 'Units');
        if isempty(HCMKicks)
            HCMKicks = Default2HCMKick;
            KickUnits = 'Physics';
        end
        if isempty(KickUnits)
            error('Units for the kick strength are unknown.  Try inputing units directly.');
        end
        if strcmpi(UnitsFlag, 'Physics') && strcmpi(KickUnits, 'Hardware') 
            HCMsp = getsp(HCMFamily, HCMList, 'Numeric', ModeFlag, 'Hardware');
            HCMKicks = hw2physics(HCMFamily, 'Setpoint', HCMsp+HCMKicks, HCMList) - hw2physics(HCMFamily, 'Setpoint', HCMsp, HCMList);
        elseif strcmpi(UnitsFlag, 'Hardware') && strcmpi(KickUnits, 'Physics') 
            HCMsp = getsp(HCMFamily, HCMList, 'Numeric', ModeFlag, 'Physics');
            HCMKicks = physics2hw(HCMFamily, 'Setpoint', HCMsp+HCMKicks, HCMList) - physics2hw(HCMFamily, 'Setpoint', HCMsp, HCMList);
        end
    end
    if isempty(VCMKicks)
        VCMKicks = getfamilydata(VCMFamily, 'Setpoint', 'DeltaRespMat', VCMList);
        KickUnits = 'Hardware'; %getfamilydata(VCMFamily, 'Setpoint', 'Units');
        if isempty(VCMKicks)
            VCMKicks = Default2VCMKick;
            KickUnits = 'Physics';
        end
        if isempty(KickUnits)
            error('Units for the kick strength are unknown.  Try inputing units directly.');
        end
        if strcmpi(UnitsFlag, 'Physics') && strcmpi(KickUnits, 'Hardware') 
            VCMsp = getsp(VCMFamily, VCMList, 'Numeric', ModeFlag, 'Hardware');
            VCMKicks = hw2physics(VCMFamily, 'Setpoint', VCMsp+VCMKicks, VCMList) - hw2physics(VCMFamily, 'Setpoint', VCMsp, VCMList);
        elseif strcmpi(UnitsFlag, 'Hardware') && strcmpi(KickUnits, 'Physics') 
            VCMsp = getsp(VCMFamily, VCMList, 'Numeric', ModeFlag, 'Physics');
            VCMKicks = physics2hw(VCMFamily, 'Setpoint', VCMsp+VCMKicks, VCMList) - physics2hw(VCMFamily, 'Setpoint', VCMsp, VCMList);
        end
    end
    
    %% Query to begin measurement
    %if DisplayFlag
    %    tmp = questdlg('Begin response matrix measurement?','Response Matrix Measurement','Yes','No','No');
    %    if strcmpi(tmp,'No')
    %        fprintf('   Response matrix measurement aborted\n');
    %        Rmat = [];
    %        return
    %    end
    %end
    
    % Mask bpms and correctors for status
    BPMxStatus = getfamilydata(BPMxFamily, 'Status', BPMxList);
    BPMxGoodIndex = find(BPMxStatus);
    BPMxList = BPMxList(BPMxGoodIndex,:);
    
    BPMyStatus = getfamilydata(BPMyFamily, 'Status', BPMyList);
    BPMyGoodIndex = find(BPMyStatus);
    BPMyList = BPMyList(BPMyGoodIndex,:);
    
    HCMStatus = getfamilydata(HCMFamily, 'Status', HCMList);
    HCMGoodIndex = find(HCMStatus);
    HCMList = HCMList(HCMGoodIndex,:);
    if length(HCMKicks) == 1
        HCMKicks = HCMKicks * ones(length(HCMGoodIndex),1);
    else
        HCMKicks = HCMKicks(HCMGoodIndex);
    end

    VCMStatus = getfamilydata(VCMFamily, 'Status', VCMList);
    VCMGoodIndex = find(VCMStatus);
    VCMList = VCMList(VCMGoodIndex,:);
    if length(VCMKicks) == 1
        VCMKicks = VCMKicks * ones(length(VCMGoodIndex),1);
    else
        VCMKicks = VCMKicks(VCMGoodIndex);
    end
    
    % Measure response matrix of all planes at once
    % (One advantage of this is the limits of all planes get checked before the measurement starts)
    if DisplayFlag
        fprintf('   Begin BPM response matrix measurement\n');
    end
    
    %if strcmpi(getfamilydata('Machine'), 'ALS')
    %    fprintf('   Using measrespmat_als (with orbit correction)\n');
    %    Rcell = measrespmat_als({BPMxFamily,BPMyFamily}, {BPMxList,BPMyList}, {HCMFamily,VCMFamily}, {HCMList,VCMList}, {HCMKicks,VCMKicks}, 'Struct', ModulationMethod, WaitFlag, ExtraDelay, InputFlags{:}, DCCTFlag{:});
    %else
        Rcell = measrespmat({BPMxFamily,BPMyFamily}, {BPMxList,BPMyList}, {HCMFamily,VCMFamily}, {HCMList,VCMList}, {HCMKicks,VCMKicks}, 'Struct', ModulationMethod, WaitFlag, ExtraDelay, InputFlags{:}, DCCTFlag{:});
        %BPMFamilies = findmemberof({'measbpmresp'},'Monitor');
        %BPMDevLists = family2dev(BPMFamilies);
        %Rcell = measrespmat(BPMFamilies, BPMDevLists, {HCMFamily,VCMFamily}, {HCMList,VCMList}, {HCMKicks,VCMKicks}, 'Struct', ModulationMethod, WaitFlag, ExtraDelay, InputFlags{:}, DCCTFlag{:});
    %end
    if DisplayFlag
        fprintf('   Measurement complete.\n\n');
    end

    % Convert cell array to a struct array
    % (We only did this because struct arrays were more familiar to people)
    % Rmat(1,1) = Rcell{1,1};  % Kick x, look x
    % Rmat(2,1) = Rcell{2,1};  % Kick x, look y
    % Rmat(2,2) = Rcell{2,2};  % Kick y, look y
    % Rmat(1,2) = Rcell{1,2};  % Kick y, look x
    for i = 1:size(Rcell,1)
        for j = 1:size(Rcell,2)
            if istransport
                % For transport line zero the BPM noise for upstream BPMs
                for k = 1:size(Rcell{i,j}.Data,2)
                    CMpos = getspos(Rcell{i,j}.Actuator.FamilyName, Rcell{i,j}.Actuator.DeviceList(k,:));
                    BPMpos = getspos(Rcell{i,j}.Monitor);
                    iUpStream = find(BPMpos < CMpos);
                    if ~isempty(iUpStream)
                        Rcell{i,j}.Data(iUpStream,k) = 0;
                    end
                end
            end
            Rmat(i,j) = Rcell{i,j};
        end
    end
    
    
    % % Horizontal corrector plane
    % if DisplayFlag
    %     fprintf('   Begin Horizontal plane measurement ...\n');
    % end
    % mat = measrespmat('Struct', {BPMxFamily, BPMyFamily}, {BPMxList, BPMyList}, HCMFamily, HCMList, HCMKicks, ModulationMethod, WaitFlag, ExtraDelay, InputFlags{:});
    % if DisplayFlag
    %     fprintf('   Horizontal plane complete.\n\n'); 
    % end    
    % 
    % % Make a response matrix array 
    % Rmat(1,1) = mat{1};  % Kick x, look x
    % Rmat(2,1) = mat{2};  % Kick x, look y
    % 
    % 
    % % Vertical corrector plane
    % if DisplayFlag
    %     fprintf('   Begin Vertical plane measurement...\n'); 
    % end
    % mat = measrespmat('Struct', {BPMxFamily, BPMyFamily}, {BPMxList, BPMyList}, VCMFamily, VCMList, VCMKicks, ModulationMethod, WaitFlag, ExtraDelay, InputFlags{:});
    % if DisplayFlag
    %     fprintf('   Vertical plane complete.\n\n');     
    % end
    % 
    % Rmat(2,2) = mat{2};  % Kick y, look y
    % Rmat(1,2) = mat{1};  % Kick y, look x
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
        fprintf('   BPM response matrix data structure ''Rmat'' saved to disk\n');
        fprintf('   Filename: %s\n', OutputFileName);
        fprintf('   The total response matrix measurement time was %.2f minutes.\n', (gettime-TimeStart)/60);
    end
else
    OutputFileName = '';
end


if ~StructOutputFlag
    % Return a matrix
    % Rmat = [Rmat(1,1).Data Rmat(1,2).Data;
    %         Rmat(2,1).Data Rmat(2,2).Data];
    RmatData = [];
    for i = 1:size(Rmat,1)
        Rrow = [];
        for j = 1:size(Rmat,2)
            Rrow = [Rrow Rmat(i,j).Data];
        end
        RmatData = [RmatData; Rrow];
    end
    
    Rmat = RmatData;
end

