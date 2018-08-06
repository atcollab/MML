function [Dx, Dy, FileName] = measdisp(varargin);
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/measdispcls.m 1.1 2007/07/06 10:42:35CST Tasha Summers (summert) Exp  $
% ----------------------------------------------------------------------------------------------
%MEASDISP - Measures the dispersion function
%  [Dx, Dy, FileName] = measdisp(DeltaRF, BPMxFamily, BPMxList, BPMyFamily, BPMyList, WaitFlag)
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
%  1. DeltaRF is the change in RF frequency {Default: 1000 Hz or .001 MHz depending on the RF Units}
%  2. BPMxFamily and BPMyFamily are the family names of the BPM's, {Default or []: the entire list}
%  3. BPMxList and BPMyList are the device list of BPM's, {Default or []: the entire list}5
%  4. WaitFlag >= 0, wait WaitFlag seconds before measuring the tune (sec)
%               = -1, wait until the magnets are done ramping
%               = -2, wait until the magnets are done ramping + BPM processig delay {default} 
%               = -4, wait until keyboard input
%  5. Modulation method for changing the RF frequency
%     'bipolar'  changes the RF by +/- DeltaRF/2 {Default}
%     'unipolar' changes the RF from 0 to DeltaRF
%  6. 'Physics' - For actual dispersion units add 'Physics' with an optional input 
%     of the momentum compaction factor (mcf will be found from getmcf if empty).  
%     The units of the output Dx, Dy will likely be m/(dp/p) (physics units).  The units 
%     are kept track of in the data structure.  When using vector outputs 
%     be careful to remember the units. 
%     'Hardware' in the input line forces hardware units, usually mm/MHz.
%     The default units goes with the units of the BPM's and RF frequency.
%  7. 'Struct'  will return data structures instead of vectors {Default for data structure inputs}
%     'Numeric' will return vector outputs {Default for non-data structure inputs}
%  8. Optional override of the mode
%     'Online'    - Set/Get data online  
%     'Model'     - Get the model dispersion directly from AT (uses modeldisp)
%     'Simulator' - Set/Get data on the simulated accelerator using AT (ie, same commands as 'Online')
%     'Manual'    - Set/Get data manually
%  9. Optional display
%     'Display'   - Plot the dispersion {Default if no outputs exist}
%     'NoDisplay' - Dispersion will not be plotted {Default if outputs exist}
%  10.'Archive' will save a dispersion data structure to \<DispData Directory>\<DispArchiveFile><Date><Time>.mat
%     'NoArchive' {Default}
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
%         ActuatorDelta: Change in RF in MHz
%               Monitor: [1x1 struct] - BPM structure with starting orbit
%                   GeV: Storage ring energy
%             TimeStamp: Clock (for example, [2003 7 9 0 21 36.2620])
%                  DCCT: 941.8832
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
%
%  Written by Greg Portmann and Jeff Corbett
% ----------------------------------------------------------------------------------------------


Delay = getfamilydata('BPMDelay');
DeltaRFDefault = 500;  %Hz  
BPMxFamily = 'BPMx';
BPMyFamily = 'BPMy';
BPMxList = [];
BPMyList = [];
WaitFlag = -2;
ExtraDelay = 1;
ModulationMethod = 'bipolar';
StructOutputFlag = 0;
NumericOutputFlag = 0; 
ArchiveFlag = 0;
if nargout == 0
    DisplayFlag = 1;
else
    DisplayFlag = 0;
end
ModeFlag = '';  % model, online, manual, or '' for default mode
UnitsFlag = ''; % hardware, physics, or '' for default units
%MCF = [];
MCF = inputdlg('Momentum compaction?',1,0.0038);

% Look if 'struct' or 'numeric' in on the input line
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
    elseif strcmpi(varargin{i},'eta') | strcmpi(varargin{i},'physics')
        UnitsFlag = 'Physics';
        varargin(i) = [];
        if length(varargin) >= i
            if isnumeric(varargin{i})
                MCF = varargin{i};
                InputFlags = [InputFlags varargin(i)];
                varargin(i) = [];
            end
        end
    elseif strcmpi(varargin{i},'hardware')
        UnitsFlag = 'Hardware';
        varargin(i) = [];
        if length(varargin) >= i
            if isnumeric(varargin{i})
                MCF = varargin{i};
                varargin(i) = [];
            end
        end
    elseif strcmpi(varargin{i},'simulator') | strcmpi(varargin{i},'model')
        ModeFlag = varargin{i};
        %ModeFlag = 'Model';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'online')
        ModeFlag = 'Online';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'manual')
        ModeFlag = 'Manual';
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
    if isstr(varargin{1})
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
        varargin(1) = [];      
        
        % Only change StructOutputFlag if 'numeric' is not on the input line
        if ~NumericOutputFlag
            StructOutputFlag = 1;
        end
    end
end

% Look for BPMy family info
if length(varargin) >= 1
    if isstr(varargin{1})
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
        varargin(1) = [];      
    end
end

% Look for WaitFlag input
if length(varargin) >= 1
    if isnumeric(varargin{1}) & ~isempty(varargin{1})
        WaitFlag = varargin{1}; 
        varargin(1) = [];
    end
end
% End of input parsing


if isempty(UnitsFlag)
    UnitsFlag = getfamilydata('RF','Setpoint','Units');
end

% if isempty(ModeFlag)
%     if strcmpi(getfamilydata('RF','Setpoint','Mode'), getfamilydata(BPMxFamily,'Monitor','Mode'))
%         ModeFlag = getfamilydata(BPMxFamily,'Monitor','Mode');
%     elseif strcmpi(getfamilydata(BPMxFamily,'Monitor','Mode'),'Special')
%         ModeFlag = getfamilydata('RF','Setpoint','Mode');
%     else
%         error('Mixed Mode for RF and orbits');
%     end
% end
% 'Hardware' is default, MHz
if strcmpi(UnitsFlag,'Hardware')
    RFUnitsString = getfamilydata('RF','Setpoint','HWUnits');
elseif strcmpi(UnitsFlag,'Physics')
    RFUnitsString = getfamilydata('RF','Setpoint','PhysicsUnits');
else
    error('RF units unknown.');
end

% DeltaRF default 
if isempty(DeltaRF)
    if strcmpi(RFUnitsString, 'Hz')
        % Default units OK
        DeltaRF = DeltaRFDefault;
    elseif strcmpi(RFUnitsString, 'MHz')
        % Change to MHz
        DeltaRF = DeltaRFDefault / 1e6;
    else
        error('RF units unknown.  Inputs DeltaRF directly.');
    end
end

% Check DeltaRF for resonable values
if strcmpi(RFUnitsString, 'MHz')
    if DeltaRF > .015;  % 15,000 Hz
        tmp = questdlg(sprintf('%f MHz is a large RF change.  Do you want to continue?', DeltaRF),'Dispersion Measurement','YES','NO','YES');
        if strcmp(tmp,'NO')
            Dx=[];  Dy=[];
            return
        end
    end
elseif strcmpi(RFUnitsString, 'Hz')
    if DeltaRF > 15000;  % Hz
        tmp = questdlg(sprintf('%f Hz is a large RF change.  Do you want to continue?', DeltaRF),'Dispersion Measurement','YES','NO','YES');
        if strcmp(tmp,'NO')
            Dx=[];  Dy=[];
            return
        end
    end
else
    % Don't who how to check, hence no check made
end


% Use the AT model directly (modeldisp)
if strcmpi(ModeFlag, 'Model')
    % Use the AT Model
    if nargout == 0
        modeldisp(DeltaRF, BPMxFamily, BPMxList, BPMyFamily, BPMyList, ModulationMethod, UnitsFlag);
        return
    end
    
    [HorDisp, VertDisp] = modeldisp(DeltaRF, BPMxFamily, BPMxList, BPMyFamily, BPMyList, ModulationMethod, 'Struct', UnitsFlag);

    % This might not always work (it's only a problem if the first input family is in the vertical plane)
    if ~isempty(strfind(lower(BPMxFamily),'y')) | ~isempty(strfind(lower(BPMxFamily),'v'))
        Dx = VertDisp;
    else
        Dx = HorDisp;
    end
    if ~isempty(strfind(lower(BPMyFamily),'x')) | ~isempty(strfind(lower(BPMyFamily),'h'))
        Dy = HorDisp;
    else
        Dy = VertDisp;
    end

    if StructOutputFlag
        Dx.Actuator = getrf(Dx(1).Actuator.UnitsString, 'Model', 'Struct');
        Dy.Actuator = Dx.Actuator;
        Dx.Monitor = getam(BPMxFamily, BPMxList, 'Model', 'Struct');
        Dy.Monitor = getam(BPMyFamily, BPMyList, 'Model', 'Struct');
    else
        Dx = Dx.Data;
        Dy = Dy.Data;
    end
    
    return
end


% Dispersion can be found using the response matrix generation program
%DispRespMat = measrespmat({getam(BPMxFamily, BPMxList,'Struct', ModeFlag), getam(BPMyFamily,BPMyList,'Struct',ModeFlag)}, getsp('RF','Struct',ModeFlag), DeltaRF, 'bipolar', WaitFlag, ExtraDelay, 'Struct', 'NoDisplay', ModeFlag, UnitsFlag);
DispRespMat = measrespmat({getam(BPMxFamily, BPMxList,'Struct', ModeFlag), getam(BPMyFamily,BPMyList,'Struct',ModeFlag)}, getsp('RF','Struct',ModeFlag), DeltaRF, 'bipolar', WaitFlag, ExtraDelay, 'Struct', 'NoDisplay');

d(1) = DispRespMat{1};
d(2) = DispRespMat{2};
d(1).FamilyName = 'DispersionX';
d(2).FamilyName = 'DispersionY';
d(1).GeV = getenergy;
d(2).GeV = d(1).GeV;


% Get the momentum compaction factor in if was not on the input line
if isempty(MCF)
    %MCF = getmcf(ModeFlag);
    MCF=0.0038;
end

for i = 1:2
    d(i).Mode = d(i).Actuator.Mode;
    d(i).Units = d(i).Actuator.Units;
    if strcmpi(d(i).Actuator.Units, 'Physics')
        % Output units per energy shift, usually m/(dp/p)
        d(i).Data = -d(i).Actuator.Data * MCF * d(i).Data; 
        d(i).UnitsString = [d(i).Monitor.UnitsString,'/(dp/p)'];
    else
        % No energy conversion
        d(i).UnitsString = [d(i).Monitor.UnitsString,'/',d(i).Actuator.UnitsString];
    end
    d(i).DataDescriptor = 'Dispersion';
    d(i).CreatedBy = 'measdisp';
    d(i).MCF = MCF;
    d(i).dp = -DeltaRF / (d(i).Actuator.Data * MCF);
end
d(1).OperationalMode = getfamilydata('OperationalMode');
d(2).OperationalMode = d(1).OperationalMode;

% Plot if no output
if DisplayFlag
    %figure;
    plotdisp(d(1),d(2),'Physics');  % Added Physics flag June 2007 TS
end


% Output
if StructOutputFlag
    Dx = d(1);
    Dy = d(2);
else
    Dx = d(1).Data;
    Dy = d(2).Data;
end


% Archive data structure
if ArchiveFlag
    DirStart = pwd;
    FileName = appendtimestamp(getfamilydata('Default', 'DispArchiveFile'), d(1).TimeStamp);
    DirectoryName = getfamilydata('Directory','DispData');
    if isempty(DirectoryName)
        DirectoryName = [getfamilydata('Directory','DataRoot') 'Dispersion\'];
    end
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    BPMxDisp = d(1);
    BPMyDisp = d(2);
    save(FileName, 'BPMxDisp', 'BPMyDisp');
    fprintf('   Dispersion data structure saved to %s.mat\n', [DirectoryName FileName]);
    cd(DirStart);
    FileName = [DirectoryName FileName];
else
    FileName = '';
end

%disp('   Dispersion measurement complete');

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/measdispcls.m  $
% Revision 1.1 2007/07/06 10:42:35CST Tasha Summers (summert) 
% Initial revision
% Member added to project e:/Projects/matlab/project.pj
% Revision 1.2 2007/03/02 08:16:50CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
