function [Rmat, OutputFileName] = measphotresp(varargin)
%MeasPhotResp - Measures the BPM and Photon response matrix in the horizontal and vertical planes
%
%  For family name, device list inputs:
%  S = measphotresp(BPMxFamily, eBPMxList, BPMyFamily, BPMyList, SumFamily, SumList, ErrFamily, ErrList, VCMFamily, VCMList, VCMKicks, ModulationMethod, WaitFlag, FileName, DirectoryName, ExtraDelay)
%
%  For data structure inputs: 
%  S = measphotresp(BPMxStruct, BPMyStruct, SumStruct, ErrStruct, VCMStruct, VCMKicks, ModulationMethod, WaitFlag, FileName, DirectoryName, ExtraDelay)
%
%  INPUTS
%  1. BPMxFamily       - BPMx family name
%     BPMxDeviceList   - BPMx device list (Default: all devices with good status)
%     or 
%     BPMxStruct can replace BPMxFamily and BPMxList
%
%  2. BPMyFamily       - BPMy family name
%     BPMyDeviceList   - BPMy device list (Default: all devices with good status)
%     or 
%     BPMyStruct can replace BPMyFamily and BPMyList
%
%  3. SumFamily       - Sum family name
%     SumDeviceList   - Sum device list (Default: all devices with good status)
%     or 
%     SumStruct can replace SumFamily and SumList
%
%  4. ErrFamily       - Err family name
%     ErrDeviceList   - Err device list (Default: all devices with good status)
%     or 
%     ErrStruct can replace ErrFamily and SumList
%
%
%  5. VCMFamily       - VCM family name
%     VCMDeviceList   - VCM device list (Default: all devices with good status)
%     or 
%     VCMStruct can replace VCMFamily and VCMList
%
%  6. VCMKicks - Change in VCM correctors {Default: getfamilydata(VCMFamily,'Setpoint','DeltaRespMat',VCMDeviceList), then .05mrad}
%
%  7. ModulationMethod - Method for changing the ActuatorFamily
%                       'bipolar' changes the ActuatorFamily by +/- ActuatorDelta/2 on each step {Default}
%                       'unipolar' changes the ActuatorFamily from 0 to ActuatorDelta on each step
%
%  8. WaitFlag - (see setpv for WaitFlag definitions) {Default: []}
%                WaitFlag = -5 will override gets to manual mode
%
%  9.Optional input to change the default filename and directory
%     FileName - Filename for the response matrix data
%                (No input or empty means data will be saved to a default file)  
%     DirectoryName - Directory name to store the response matrix data file 
%     Note: a. FileName can include the path if DirectoryName is not used
%           b. For model response matrices, FileName must exist for a file save
%           c. When using the default FileName, a dialog box will prompt for changes
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
%  15. 'Archive'   - Automatically save the response matrix structure to disk {Default unless mode='Model'}
%      'NoArchive' - Do not automatically save the response matrix structure
%
%  16. Optional inputs when computing model response matrices:
%      'FixedPathLength' {Default} or 'FixedMomentum' - hold the path length or momentum fixed
%      'Full' {Default} or 'Linear' - use full nonlinear model or linear approximation (faster)
%      Note: ModulationMethod is also taken into account for the model calculation
%
%  OUTPUTS
%  1. Rmat = Orbit response matrix (delta(Electron BPM, Photon BPM)/delta(Kick))
%
%     Numeric Output:
%       Rmat = [xy
%               yy 
%               sum 
%               err]
%
%     Stucture Output:
%     Rmat(BPM Plane, Corrector Plane) - 2x2 struct array
%     Rmat(1,1).Data=xy;  % Kick y, look BPMx
%     Rmat(2,1).Data=yy;  % Kick y, look BPMy
%     Rmat(3,1).Data=sy;  % Kick y, look Sum
%     Rmat(4,1).Data=ey;  % Kick y, look Err
%           
%     Rmat(Monitor, Actuator).Data - Response matrix
%                            .Monitor  - data structure (starting orbit)
%                            .Monitor1 - matrix (first  data point)
%                            .Monitor2 - matrix (second data point)
%                            .Actuator - Corrector data structure
%                            .ActuatorDelta - Corrector kick vector
%                            .GeV - Electron beam energy
%                            .ModulationMethod - 'unipolar' or 'bipolar'
%                            .WaitFlag - Wait flag used when acquiring data
%                            .ExtraDelay - Extra time delay 
%                            .TimeStamp
%                            .CreatedBy
%                            .DCCT
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
%        R = measphotresp('SF', 'SD', 'QF', 'QD', 'Model', 'Physics');
%        is the response matrix from the quadrupoles to orbit at the sextupoles.
%        The units when using nonstandard families for BPMs and correctors is always
%        'physics', meter/radian.  If default kick for non-standard "correctors" is 
%        1 microradian.  To change this 'Physics' must be on the input line.
%  3. Cell inputs are not allowed.
%  4. This function measures response matrices from 2 BPM families to 2 corrector families.  
%     If only one family is needed then use measrespmat.
%
%  EXAMPLES
%  1. Default:
%       R = measphotresp;
%       is the same as,
%       R = measphotresp('BPMx', 'BPMy', 'BLSum', 'BLErr', 'VCM', 'Online', 'Bipolar', 'Numeric', 'Archive');
%
%  Modified from Greg Portmann's 'measbpmresp' by Jeff Corbett


% Initialize defaults
BPMxFamily = 'BPMx';
BPMxList = [];
BPMyFamily = 'BPMy';
BPMyList = [];
SumFamily  = 'BLSum';
SumList  = [];
ErrFamily  = 'BLErr';
ErrList  = [];
VCMFamily= 'VCM';
VCMList  = [];
VCMKicks = [];
Default2VCMKick = 1.0e-5;  % Radians, if getfamilydata(HCMFamily,'Setpoint','PhotResp') is empty
ModulationMethod = 'bipolar';
FileName = [];
DirectoryName = [];
WaitFlag = -2;
ExtraDelay = 0; 
StructOutputFlag = 0;
NumericOutputFlag = 0;
DisplayFlag = -1;
ArchiveFlag = -1;
ModeFlag = '';  % model, online, manual, or '' for default mode
UnitsFlag = ''; % hardware, physics, or '' for default units

InputFlags = {};
ModelResponeMatrixFlags = {};
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
    elseif strcmpi(varargin{i},'unipolar')
        ModulationMethod = 'unipolar';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'bipolar')
        ModulationMethod = 'bipolar';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Model')
        ModeFlag = varargin{i};
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
    elseif strcmpi(varargin{i},'FixedPathLength')
        ModelResponeMatrixFlags = [ModelResponeMatrixFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'FixedMomentum')
        ModelResponeMatrixFlags = [ModelResponeMatrixFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Linear')
        ModelResponeMatrixFlags = [ModelResponeMatrixFlags varargin(i)];
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Full')
        ModelResponeMatrixFlags = [ModelResponeMatrixFlags varargin(i)];
        varargin(i) = [];
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
        varargin(1) = [];
        if ~NumericOutputFlag
            StructOutputFlag = 1; % Only change StructOutputFlag if 'Numeric' is not on the input line
        end
    elseif isstr(varargin{1})
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
    BPMxList = getlist(BPMxFamily, 1);
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
    elseif isstr(varargin{1})
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
    BPMyList = getlist(BPMyFamily, 1);
end

% Look for BLSum family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        SumFamily = varargin{1}.FamilyName;
        SumList = varargin{1}.DeviceList;
        varargin(1) = [];
        if ~NumericOutputFlag
            StructOutputFlag = 1; % Only change StructOutputFlag if 'Numeric' is not on the input line
        end
    elseif isstr(varargin{1})
        SumFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                SumList = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        SumList = varargin{1};
        varargin(1) = [];
    end
end
if isempty(SumList)
    SumList = getlist(SumFamily, 1);
end

% Look for BLErr family info
if length(varargin) >= 1
    if isstruct(varargin{1})
        ErrFamily = varargin{1}.FamilyName;
        ErrList = varargin{1}.DeviceList;
        varargin(1) = [];
        if ~NumericOutputFlag
            StructOutputFlag = 1; % Only change StructOutputFlag if 'Numeric' is not on the input line
        end
    elseif isstr(varargin{1})
        ErrFamily = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                ErrList = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        ErrList = varargin{1};
        varargin(1) = [];
    end
end
if isempty(ErrList)
    ErrList = getlist(ErrFamily, 1);
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
    elseif isstr(varargin{1})
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
    VCMList = getlist(VCMFamily, 1);
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
if ~strcmpi(ModulationMethod, 'unipolar') & ~strcmpi(ModulationMethod, 'bipolar')
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
        FileName = [];
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
        DirectoryName = getfamilydata('Directory', 'BLResponse');
        varargin(1) = [];
    elseif ischar(varargin{1})
        DirectoryName = varargin{1};
        varargin(1) = [];
    else
        % Empty DirectoryName mean it will only be used if FileName is empty
        DirectoryName = [];
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
    if strcmpi(getfamilydata(SumFamily,'Monitor','Units'), getfamilydata(ErrFamily,'Monitor','Units'))
        UnitsFlag = getfamilydata(ErrFamily,'Monitor','Units');
    else
        error('Mixed Units for BL error and sum');
    end
    if strcmpi(getfamilydata(BPMxFamily,'Monitor','Units'), getfamilydata(ErrFamily,'Monitor','Units'))
        UnitsFlag = getfamilydata(ErrFamily,'Monitor','Units');
    else
        error('Mixed Units for electron and photon BPMs');
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
    if strcmpi(getfamilydata(SumFamily,'Monitor','Mode'), getfamilydata(ErrFamily,'Monitor','Mode'))
        %ModeFlag = getfamilydata(BPMxFamily,'Monitor','Mode');
    else
        error('Mixed Mode for BL error and sum');
    end
    if strcmpi(getfamilydata(BPMxFamily,'Monitor','Mode'), getfamilydata(ErrFamily,'Monitor','Mode'))
        ModeFlag = getfamilydata(ErrFamily,'Monitor','Mode');
    else
        error('Mixed Mode for electron and photon BPMs');
    end
end
if isempty(ModeFlag)
    error('Unknown Mode');
end
% Input parsing complete


% Starting time
TimeStart = gettime;


% Acquire initial data
MachineConfig = getmachineconfig;   % Mode and Units ???


if strcmpi(ModeFlag,'Model')
    % Only archive data if ArchiveFlag==1 or FileName~=[]
    if ischar(FileName) | ArchiveFlag == 1
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
end

% Print setup information
if DisplayFlag
    if strcmpi(ModeFlag,'Model')
        fprintf('\n');
        fprintf('   MeasPhotResp measures the electron and photon BPM response matrix for VCM correctors.\n');
        fprintf('   When using the ''Model'' the AT lattice needs to be setup properly.  The units are\n');
        fprintf('   determined by the ''Physics'' or ''Hardware'' mode.\n\n');
    else
        fprintf('\n');
        fprintf('   MeasPhotResp measures the electron and photon BPM response matrix for VCM correctors.\n');
        fprintf('   The storage ring lattice and hardware should be setup for accurate orbit measurements.\n');
        fprintf('   Magnet changes are determined by ''physics'' or ''hardware'' mode.\n\n');
        fprintf('   Make sure the following information is correct:\n');
        fprintf('   1.  Proper magnet lattice (including skew quadrupoles)\n');
        fprintf('   2.  Proper electron beam energy\n');
        fprintf('   3.  Proper electron bunch pattern\n');
        fprintf('   4.  BPMs are functioning properly (calibrated, sample rate, etc.)\n');
        fprintf('   5.  Corrector magnets are working\n');
        fprintf('   6.  The injection bump magnets off\n');
        fprintf('   7.  Corrector Settle Time WaitFlag=%f, Extra BPM Delay=%f\n', WaitFlag, ExtraDelay);
        fprintf('   9.  Modulation Method: %s\n', ModulationMethod);
    end
end

% Check for empty Filename and DirectoryName
if ~ischar(FileName) & ArchiveFlag
    ArchiveFlag = 1;
    if ~ischar(FileName)
        if isempty(DirectoryName)
            DirectoryName = getfamilydata('Directory', 'BLResponse');
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
        end
        FileName = getfamilydata('Default', 'BLRespFile');
        FileName = appendtimestamp(FileName);
        [FileName, DirectoryName] = uiputfile('*.mat', 'Select Beamline Response Matrix File (Cancel to not save to a file)', [DirectoryName FileName]);
        if FileName == 0 
            ArchiveFlag = 0;
            if nargout == 0
                disp('   No output or file to save to, hence no response matrix measurement performed.');
                Rmat = [];
                return
            end
        end
    end
end


% Measure the response matrices

% Model response matrix not implemented - see measbpmresp for example code
    
% Online response matrix
    
    % Default kicks 
    if isempty(VCMKicks)
        VCMKicks = getfamilydata(VCMFamily, 'Setpoint', 'PhotResp', VCMList);
        KickUnits = getfamilydata(VCMFamily, 'Setpoint', 'Units');
        if isempty(VCMKicks)
            CMData.VCMKicks = Default2VCMKick;
            KickUnits = 'Physics';
        end
        if isempty(KickUnits)
            error('Units for the kick strength are unknown.  Try inputing units directly.');
        end
        if strcmpi(UnitsFlag, 'Physics') & strcmpi(KickUnits, 'Hardware') 
            VCMsp = getsp(VCMFamily, VCMList, 'Numeric', ModeFlag, 'Hardware');
            VCMKicks = hw2physics(VCMFamily, 'Setpoint', VCMsp+VCMKicks, VCMList) - hw2physics(VCMFamily, 'Setpoint', VCMsp, VCMList);
        elseif strcmpi(UnitsFlag, 'Hardware') & strcmpi(KickUnits, 'Physics') 
            VCMsp = getsp(VCMFamily, VCMList, 'Numeric', ModeFlag, 'Physics');
            VCMKicks = physics2hw(VCMFamily, 'Setpoint', VCMsp+VCMKicks, VCMList) - physics2hw(VCMFamily, 'Setpoint', VCMsp, VCMList);
        end
    end
    
    % Mask elements for status
    BPMxStatus = getfamilydata('BPMx','Status', BPMxList);
    BPMxGoodIndex = find(BPMxStatus);
    BPMxList = BPMxList(BPMxGoodIndex,:);
    
    BPMyStatus = getfamilydata('BPMy','Status', BPMyList);
    BPMyGoodIndex = find(BPMyStatus);
    BPMyList = BPMyList(BPMyGoodIndex,:);
      
    SumStatus = getfamilydata('BLSum','Status', SumList);
    SumGoodIndex = find(SumStatus);
    SumList = SumList(SumGoodIndex,:);

    ErrStatus = getfamilydata('BLErr','Status', ErrList);
    ErrGoodIndex = find(ErrStatus);
    ErrList = ErrList(ErrGoodIndex,:);
        
    VCMStatus = getfamilydata('VCM','Status', VCMList);
    VCMGoodIndex = find(VCMStatus);
    VCMList = VCMList(VCMGoodIndex,:);
    VCMKicks = VCMKicks(VCMGoodIndex);

    
    % Query to begin measurement
    if DisplayFlag
        tmp = questdlg('Begin response matrix measurement?','Response Matrix Measurement','Yes','No','No');
        if strcmpi(tmp,'No')
            fprintf('   Response matrix measurement aborted\n');
            Rmat = [];
            return
        end
    elseif DisplayFlag
        fprintf('   Begin Vertical plane measurement...\n'); 
    end
    
    mat = measrespmat('Struct', {BPMxFamily, BPMyFamily, SumFamily, ErrFamily}, {BPMxList, BPMyList, SumList, ErrList}, VCMFamily, VCMList, VCMKicks, ModulationMethod, WaitFlag, ExtraDelay, InputFlags{:});
    
    Rmat(1,1)=mat{1};  % Kick y, look x
    Rmat(2,1)=mat{2};  % Kick y, look y
    Rmat(3,1)=mat{3};  % Kick y, look sum
    Rmat(4,1)=mat{4};  % Kick y, look err
    
    %report occlusions
    sum0=Rmat(3,1).Monitor.Data;
    sum1=Rmat(3,1).Monitor1;
    sum2=Rmat(3,1).Monitor2;
    for k=1:size(VCMList,1)
         fprintf('%s\n',' ')
         fprintf([family2common('VCM',VCMList(k,:)) '    occlusion up    occlusion  down   (percentage)\n']);
         for bl=1:size(SumList,1)
          fprintf('%s %f  %f \n',['   ' family2common('BLSum',SumList(bl,:)) '      '],100*(sum1(bl,k)-sum0(bl))/sum0(bl),100*(sum2(bl,k)-sum0(bl))/sum0(bl));
         end
    end

%     IMPORTANT: change family names of BPMx and BPMy to BPMxPhot and BPMyPhot so they are not accidentally
%     loaded into other response applications looking for BPMx and BPMy in getrespmat
      Rmat(1,1).Monitor.FamilyName='BPMxPhot';
      Rmat(2,1).Monitor.FamilyName='BPMyPhot';
    
        
    if DisplayFlag
        fprintf('   Vertical coorrector to photon BPM measurement complete.\n\n');     
    end


% Save data in the proper directory
if ArchiveFlag | ischar(FileName)
    DirStart = pwd;
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    if ErrorFlag
        fprintf('\n   There was a problem getting to the proper directory!\n\n');
    end
    save(FileName, 'Rmat','MachineConfig');
    cd(DirStart);
    
    if DisplayFlag
        fprintf('   BPM response matrix data structure ''Rmat'' saved to disk\n');
        fprintf('   Filename: %s\n', [DirectoryName FileName]);
        fprintf('   The total response matrix measurement time: %.2f minutes.\n\n', (gettime-TimeStart)/60);
    end
    
    OutputFileName = [DirectoryName FileName];
end


if ~StructOutputFlag
    Rmat = [Rmat(1,1).Data;
            Rmat(2,1).Data;
            Rmat(3,1).Data;
            Rmat(4,1).Data];
end
