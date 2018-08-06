function [Dx, Dy, FileName] = measdisp(varargin)
%MEASDISP - Measures the dispersion function
%  [Dx, Dy, FileName] = measdisp(DeltaRF, BPMxFamily, BPMxList, BPMyFamily, BPMyList, WaitFlag, ModulationMethod)
%
%  Examples:
%  [Dx, Dy] = measdisp(DeltaRF, BPMxList, BPMyList)
%  [Dx, Dy] = measdisp('BPMx', [], 'BPMy')
%  [Dx, Dy] = measdisp(DeltaRF, 'Physics', mcf)
%  [Dx, Dy] = measdisp(DeltaRF, 'Physics')
%  [Dx, Dy] = measdisp
%  [Dx, Dy] = measdisp('Archive')
%  [Dx, Dy] = measdisp('Struct')
%
%  INPUTS
%  1. DeltaRF is the change in RF frequency {Default: .2% energy change}
%     Units match the units the RF family is in (or the override units)
%  2. BPMxFamily and BPMyFamily are the family names of the BPM's, {Default: gethbpmfamily, getvbpmfamily}
%  3. BPMxList and BPMyList are the device list of BPM's, {Default or []: the entire list}
%  4. WaitFlag >= 0, wait WaitFlag seconds before measuring the tune (sec)
%               = -1, wait until the magnets are done ramping
%               = -2, wait until the magnets are done ramping + BPM processing delay {Default} 
%               = -4, wait until keyboard input
%  5. Modulation method for changing the RF frequency
%     'bipolar'  changes the RF by +/- DeltaRF/2 {Default}
%     'unipolar' changes the RF from 0 to DeltaRF
%  6. 'Physics' - For actual dispersion units (m/(dp/p)) add 'Physics' with an optional input 
%     of the momentum compaction factor.  If empty, the mcf will be found from the getmcf 
%     function.  That mean the model must be correct for the dispersion to be scaled properly.  For
%     instance, when measuring the disperison of the injection lattice the model lattice
%     would have to reflect the injection lattice too.  If not, override mcf on the input line.
%     'Hardware' in the input line forces hardware units, usually mm/MHz.  The actual units will
%     depend on the units for the BPM and RF families.
%  7. 'Struct'  will return data structures instead of vectors {Default for data structure inputs}
%     'Numeric' will return vector outputs {Default for non-data structure inputs}
%  8. Optional override of the mode
%     'Online'    - Set/Get data online  
%     'Simulator' - Set/Get data on the simulated accelerator using AT (ie, same commands as 'Online')
%     'Model'     - (same as Simulator, use modeldisp to get the model dispersion with no BPM errors)
%     'Manual'    - Set/Get data manually
%  9. Optional display
%     'Display'   - Plot the dispersion {Default if no outputs exist}
%     'NoDisplay' - Dispersion will not be plotted {Default if outputs exist}
%  10.'NoArchive' - No file archive {Default}
%     'Archive'   - Save a dispersion data structure to \<Directory.DispData>\<DispArchiveFile><Date><Time>.mat
%                   To change the filename, included the filename after the 'Archive', '' to browse
%
%  OUTPUTS
%  For hardware units:
%  Dx = Delta BPMx / Delta RF and Dy = Delta BPMy / Delta RF
%       hence Dx and Dy are not quite the definition of dispersion
%
%               x2(RF0+DeltaRF/2) - x1(RF0-DeltaRF/2) 
%           D = -------------------------------------
%                              DeltaRF
%           
%           where RF0 = is the present RF frequency
%
%  For physics units:
%  DeltaRF is converted to change in energy, dp/p 
%
%  The units for orbit change depend on what the hardware or physics units are.  
%  Typical units are mm for hardware and meters for physics.
%
%  Structure outputs have the following fields:
%                  Data: [double] - orbit shift with RF or energy shift
%            FamilyName: 'DispersionX' or 'DispersionY'
%              Actuator: [1x1 struct] - RF structure with starting frequency
%         ActuatorDelta: Change in RF in hardware units
%               Monitor: [1x1 struct] - BPM structure with starting orbit
%                   GeV: Storage ring energy
%             TimeStamp: Clock (for example, [2003 7 9 0 21 36.2620])
%                  DCCT: Beam current
%      ModulationMethod: 'bipolar' or 'unipolar'
%              WaitFlag: BPM wait flag (usually -2)
%            ExtraDelay: 0
%        DataDescriptor: 'Dispersion'
%             CreatedBy: 'measdisp'
%                   MCF: momentum compaction factor
%                 Units: 'Hardware' or 'Physics'
%           UnitsString: typically 'mm/MHz' or meters/(dp/p)
%                    dp: change in moment
%                 Orbit: [2 column vectors]  (orbit at RF0+DeltaRF/2 and RF0-DeltaRF/2)
%                    RF: [RF0+DeltaRF/2 RF0-DeltaRF/2] 
%
%  If no output exists, the dispersion function will be plotted to the screen.
%
%  NOTES
%  1. 'Hardware', 'Physics', 'Eta', 'Archive', 'Numeric', and 'Struct' are not case sensitive
%  2. 'Eta' can be used instead of 'Physics'
%  3.  Get and set the RF frequency are done with getrf and setrf
%  4.  RF frequency is changed by +/-(DeltaRF/2)
%  5.  All inputs are optional
%  6.  Units for DeltaRF depend on the 'Physics' or 'Hardware' flags
%
%  See also plotdisp, modeldisp, measchro

%  Written by Greg Portmann and Jeff Corbett


BPMxFamily = gethbpmfamily;
BPMyFamily = getvbpmfamily;
BPMxList = [];
BPMyList = [];
WaitFlag = -2;
ExtraDelay = 1;
ModulationMethod = 'bipolar';
StructOutputFlag = 0;
NumericOutputFlag = 0; 
ArchiveFlag = 0;
FileName = -1;
if nargout == 0
    DisplayFlag = 1;
else
    DisplayFlag = 0;
end
ModeFlag = {};  % model, online, manual, or '' for default mode
UnitsFlag = 'Physics'; % hardware, physics, or '' for default units
MCF = [];


InputFlags = {};
for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'struct')
        StructOutputFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'numeric')
        NumericOutputFlag = 1;
        StructOutputFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'archive')
        ArchiveFlag = 1;
        if length(varargin) > i
            % Look for a filename as the next input
            if ischar(varargin{i+1})
                FileName = varargin{i+1};
                varargin(i+1) = [];
            end
        end
        varargin(i) = [];
    elseif strcmpi(varargin{i},'noarchive')
        ArchiveFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'bipolar')
        ModulationMethod = 'bipolar';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'unipolar')
        ModulationMethod = 'unipolar';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'eta') || strcmpi(varargin{i},'physics')
        UnitsFlag = 'Physics';
        varargin(i) = [];
        if length(varargin) >= i
            if isnumeric(varargin{i})
                MCF = varargin{i};
                varargin(i) = [];
            end
        end
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = varargin{i};
        varargin(i) = [];
        if length(varargin) >= i
            if isnumeric(varargin{i})
                MCF = varargin{i};
                varargin(i) = [];
            end
        end
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
        ModeFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'online')
        ModeFlag = varargin(i);
        varargin(i) = [];
    elseif strcmpi(varargin{i},'manual')
        ModeFlag = varargin(i);
        varargin(i) = [];
    end        
end


% Look for DeltaRF input
if length(varargin) >= 1
    if isnumeric(varargin{1})
        DeltaRF = varargin{1}; 
        varargin(1) = [];
    else
        DeltaRF = [];
    end
else
    DeltaRF = [];
end

% Look for BPMx family info
if length(varargin) >= 1
    if ischar(varargin{1})
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
    elseif isstruct(varargin{1})
        BPMxFamily = varargin{1}.FamilyName;
        BPMxList = varargin{1}.DeviceList;
        if isempty(UnitsFlag)
            UnitsFlag = varargin{1}.Units;
        end
        if ~NumericOutputFlag
            % Only change StructOutputFlag if 'numeric' is not on the input line
            StructOutputFlag = 1;
        end
        varargin(1) = [];      
    end
end

% Look for BPMy family info
if length(varargin) >= 1
    if ischar(varargin{1})
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
    elseif isstruct(varargin{1})
        BPMyFamily = varargin{1}.FamilyName;
        BPMyList = varargin{1}.DeviceList;
        if isempty(UnitsFlag)
            UnitsFlag = varargin{1}.Units;
        end
        if ~NumericOutputFlag
            % Only change StructOutputFlag if 'numeric' is not on the input line
            StructOutputFlag = 1;
        end
        varargin(1) = [];      
    end
end

% Look for WaitFlag input
if length(varargin) >= 1
    if isnumeric(varargin{1}) && ~isempty(varargin{1})
        WaitFlag = varargin{1}; 
        varargin(1) = [];
    end
end
% End of input parsing


% Archive data structure
if ArchiveFlag
    if isempty(FileName)
        FileName = appendtimestamp(getfamilydata('Default', 'DispArchiveFile'));
        DirectoryName = getfamilydata('Directory','DispData');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'Dispersion', filesep];
        else
            % Make sure default directory exists
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
        end
        [FileName, DirectoryName] = uiputfile('*.mat', 'Select Dispersion File', [DirectoryName FileName]);
        drawnow;
        if FileName == 0
            ArchiveFlag = 0;
            disp('   Dispersion measurement canceled.');
            Dx=[]; Dy=[]; FileName='';
            return
        end
        FileName = [DirectoryName, FileName];
    elseif FileName == -1
        FileName = appendtimestamp(getfamilydata('Default', 'DispArchiveFile'));
        DirectoryName = getfamilydata('Directory','DispData');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'Dispersion', filesep];
        end
        FileName = [DirectoryName, FileName];
    end
end


% Get the input units
if isempty(UnitsFlag)
    RFUnitsInput = getfamilydata('RF','Setpoint','Units');
    UnitsFlag = RFUnitsInput;
else
    RFUnitsInput = UnitsFlag;
end


% Get DeltaRF in Hardware units
RFHWUnits = getfamilydata('RF','Setpoint','HWUnits');


% Make sure DeltaRF is in hardware units
if isempty(DeltaRF) || ~isnumeric(DeltaRF)
    % Get the default from the AD is in Hardware units
    DeltaRF = getfamilydata('DeltaRFDisp');
    
    % If the default is not in the AD
    if isempty(DeltaRF)
        % Here is the second level default
        DeltaRF = getrf('Hardware', ModeFlag{:}) * getmcf * .002;  % .2% energy change
    end

else
    if strcmpi(UnitsFlag, 'Physics')
        % Change to hardware
        RFUnitsInput = UnitsFlag;
        DeltaRF = physics2hw('RF', 'Setpoint', DeltaRF, []);
    end
end

% DeltaRF must be in hardware units at this point


% Use the AT model directly (measdisp or modeldisp)
if ~isempty(ModeFlag) && strcmpi(ModeFlag{1}, 'Model')
    % Measure in hardware and convert later
    if ~isempty(getcavity)
        % Simulator mode (just so that the BPM gain or rotation errors are in the dispersion)
        [HorDisp, VertDisp] = measdisp(DeltaRF, BPMxFamily, BPMxList, BPMyFamily, BPMyList, WaitFlag, ModulationMethod, 'Simulator', 'Struct', 'Hardware');
    else
        % Use the AT model directly (Note:  no BPM gain or rotation errors!!!) 
        [HorDisp, VertDisp] = modeldisp(DeltaRF, BPMxFamily, BPMxList, BPMyFamily, BPMyList, ModulationMethod, 'Struct', 'Hardware');
        HorDisp.Actuator  = getrf('Model', 'Struct', 'Hardware');
        VertDisp.Actuator = HorDisp.Actuator;
        
        % Add BPM roll/crunch ???
    end
    
    % This might not always work (it's only a problem if the first input family is in the vertical plane)
    if ~isempty(strfind(lower(BPMxFamily),'y')) || ~isempty(strfind(lower(BPMxFamily),'v'))
        d(1) = VertDisp;
        d(2) = HorDisp;
        d(1).Monitor = getam(BPMyFamily, BPMyList, 'Model', 'Struct', 'Hardware');
        d(2).Monitor = getam(BPMxFamily, BPMxList, 'Model', 'Struct', 'Hardware');
    else
        d(1) = HorDisp;
        d(2) = VertDisp;
        d(1).Monitor = getam(BPMxFamily, BPMxList, 'Model', 'Struct', 'Hardware');
        d(2).Monitor = getam(BPMyFamily, BPMyList, 'Model', 'Struct', 'Hardware');
    end
    
    if isempty(MCF)
        MCF = getmcf('Model');
    end
        
else
    % Online & Simulation Modes
        
    % Check DeltaRF for resonable values
    DeltaRFphysics = hw2physics('RF', 'Setpoint', DeltaRF, []);
    if DeltaRFphysics > 15000;  % Hz
        tmp = questdlg(sprintf('%f Hz is a large RF change.  Do you want to continue?', DeltaRFphysics),'Dispersion Measurement','YES','NO','YES');
        if strcmp(tmp,'NO')
            Dx=[];  Dy=[];
            return
        end
    end


    % Dispersion can be found using the response matrix generation program
    if DisplayFlag
        %DispRespMat = measrespmat({getam(BPMxFamily,BPMxList,'Struct','Hardware',ModeFlag), getam(BPMyFamily,BPMyList,'Struct',ModeFlag)}, getsp('RF','Struct',ModeFlag), DeltaRF, ModulationMethod, WaitFlag, ExtraDelay, 'Struct', 'Display', 'Hardware', ModeFlag{:});
        DispRespMat = measrespmat({BPMxFamily,BPMyFamily}, {BPMxList,BPMyList}, 'RF', [], DeltaRF, ModulationMethod, WaitFlag, ExtraDelay, 'Struct', 'Display', 'Hardware', ModeFlag{:});
    else
        %DispRespMat = measrespmat({getam(BPMxFamily,BPMxList,'Struct','Hardware',ModeFlag), getam(BPMyFamily,BPMyList,'Struct',ModeFlag)}, getsp('RF','Struct',ModeFlag), DeltaRF, ModulationMethod, WaitFlag, ExtraDelay, 'Struct', 'NoDisplay', 'Hardware', ModeFlag{:});
        DispRespMat = measrespmat({BPMxFamily,BPMyFamily}, {BPMxList,BPMyList}, 'RF', [], DeltaRF, ModulationMethod, WaitFlag, ExtraDelay, 'Struct', 'NoDisplay', 'Hardware', ModeFlag{:});
    end
    
    d(1) = DispRespMat{1};
    d(2) = DispRespMat{2};

    
    % For multiple RF cavities in the model it's possible to get multiple columns in the response matrix
    if size(d(1).Data,2) > 1
        % More Actuators means the RF was implemented as multiple cavities and not 1 RF frequency
        % This is really not recommended!!!
        d(1).Data = sum(d(1).Data,2);        
        d(1).Actuator.Data       = d(1).Actuator.Data(1);
        d(1).Actuator.DeviceList = d(1).Actuator.DeviceList(1);
        d(1).Actuator.Status     = d(1).Actuator.Status(1);
        d(1).Actuator.DataTime   = d(1).Actuator.DataTime(1);
        
        d(2).Data = sum(d(2).Data,2);
        d(2).Actuator.Data       = d(2).Actuator.Data(1);
        d(2).Actuator.DeviceList = d(2).Actuator.DeviceList(1);
        d(2).Actuator.Status     = d(2).Actuator.Status(1);
        d(2).Actuator.DataTime   = d(2).Actuator.DataTime(1);
        
        DeltaRFphysics = DeltaRFphysics(1);
    end


    % Get the momentum compaction factor in if was not on the input line
    if isempty(MCF)
        MCF = getmcf(ModeFlag);
    end
end


% Family name is not needed
%d(1).FamilyName = 'DispersionX';
%d(2).FamilyName = 'DispersionY';

d(1).GeV = getenergy(ModeFlag{:});
d(2).GeV = d(1).GeV;


for i = 1:2
    d(i).MCF = MCF;
    d(i).dp = -DeltaRF / (d(i).Actuator.Data * MCF);    % Control delta, not monitor!
    d(i).Mode = d(i).Actuator.Mode;
    d(i).Units = d(i).Actuator.Units;
    d(i).UnitsString = [d(i).Monitor.UnitsString,'/',d(i).Actuator.UnitsString];
    d(i).OperationalMode = getfamilydata('OperationalMode');
    d(i).DataDescriptor = 'Dispersion';
    d(i).CreatedBy = 'measdisp';
end


% Final units conversion
if strcmpi(RFUnitsInput, 'Physics')
    d = hw2physics(d);
end


% Plot if no output
if DisplayFlag
    %figure;
    plotdisp(d(1),d(2));
end


% Archive data structure
if ArchiveFlag
    % If the filename contains a directory then make sure it exists
    [DirectoryName, FileName, Ext] = fileparts(FileName);
    DirStart = pwd;
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    BPMxDisp = d(1);
    BPMyDisp = d(2);
    save(FileName, 'BPMxDisp', 'BPMyDisp');
    if DisplayFlag
        fprintf('   Dispersion data saved to %s.mat\n', [DirectoryName FileName]);
        if ErrorFlag
            fprintf('   Warning: %s was not the desired directory\n', DirectoryName);
        end
    end
    cd(DirStart);
    FileName = [DirectoryName, FileName, '.mat'];
end
if FileName == -1
    FileName = '';
end


% Output
if StructOutputFlag
    Dx = d(1);
    Dy = d(2);
else
    Dx = d(1).Data;
    Dy = d(2).Data;
end


if DisplayFlag
    fprintf('   Dispersion measurement complete\n');
end



