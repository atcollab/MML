function [Dx, Dy, Sx, Sy, h] = modeldisp(varargin)
%MODELDISP - Returns the dispersion function of the model
%  [Dx, Dy, Sx, Sy, h] = modeldisp(DeltaRF, Family1, DeviceList1, Family2, DeviceList2, ModulationMethod)
%  [Dx, Dy, Sx, Sy, h] = modeldisp(DeltaRF, Family1, DeviceList1)   % Uses the same information for both planes
%  [Dx, Dy, Sx, Sy, h] = modeldisp(DeltaRF, Family1, Family2)       % Assumes DeviceList1 and DeviceList2 are []
%  [Dx, Dy, Sx, Sy, h] = modeldisp(Family1, Family2)                % Assumes DeviceList1 and DeviceList2 are []
%  [Dx, Dy, Sx, Sy, h] = modeldisp(DeltaRF, Family1)                % Family2 = Family1
%  [Dx, Dy, Sx, Sy, h] = modeldisp                                  % DeltaRF, Family, DeviceList are all optional
%
%  INPUTS
%  1. DeltaRF is the change in RF frequency {Default: .2% energy change}
%  2. Family1 and Family2 are the family names for where to measure the horizontal/vertical dispersion
%     A family name can be a middlelayer family, an AT family (FamName), or 'All' for all AT elements
%     plus the end of the ring.  However, if using a non-middlelayer family, 'Physics' units must be used.
%     {Default or []: 'All'}
%  3. DeviceList1 and DeviceList2 are the device list corresponding to Family2 and Family2.
%     Or a subindex array of the AT family.
%     {Default or []: the entire list}
%  4. ModulationMethod - Method for changing the ActuatorFamily
%                       'bipolar' changes the RF by +/- DeltaRF/2 {Default}
%                       'unipolar' changes the RF from 0 to DeltaRF
%  5. Units - {Default: 'Physics'}
%     'Physics' - Forces dispersion units of meters/(dp/p) add 'Physics' with an optional input of the 
%                 momentum compaction factor (mcf will be found from the AT function mcf if empty).  
%     'Hardware' - Forces dispersion units of (Hardware BPM Units)/(Hardware RF units)
%  6. 'Struct'  will return data structures instead of vectors
%     'Numeric' will return vector outputs {Default}
%  7. Optional display and archiving inputs
%     'Display'   - Plot the dispersion {Default if no outputs exist}
%     'NoDisplay' - Dispersion will not be plotted {Default if outputs exist}
%     'DrawLattice' - Flag to include the lattice on the plot
%     'Archive'   - Save a dispersion data structure to \<Directory.DispData>\<DispArchiveFile><Date><Time>.mat
%                   To change the filename, included the filename after the 'Archive', '' to browse
%     'NoArchive' - No file archive {Default}
%
%  OUTPUTS
%  1. Dx and Dy - Horizontal and vertical dispersion function
%                 Note: it does not matter what the input families are
%                       Dx is always horizontal and Dy vertical 
%  2. Sx and Sy are longitudinal locations in the ring [meters].
%
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
%  For physics units: DeltaRF is converted to change in energy, dp/p,
%  hence dispersion is has units of [meters/(dp/p)]
%   
%  3. h - handles to the sub-figures if a plot was made
%
%  NOTE
%  1. This function uses the model coordinate system, ie, no BPM rolls.  If hardware
%     units are used, only a gain change will be applied. 
%  2. This function only call the AT model. 
%  3. If no output exist, the dispersion function will be plotted to the screen.
%  4. Family2 and DeviceList1 can be any family.  For instance, if Family2='VCM'
%     and DeviceList1=[], then Dx is the horizontal dispersion function at the 
%     vertical corrector magnets (similarly for Family2 and DeviceList2).
%
%  See also modelbeta, plottwiss, plotdisp

%  Written by Greg Portmann


global THERING
if isempty(THERING)
    error('Simulator variable is not setup properly');
end

DeltaRFDefault = .1;  % Hz
Family1 = 'ALL';
Family2 = 'ALL';
%Family1 = 'BPMx';
%Family2 = 'BPMy';
DeviceList1 = [];   
DeviceList2 = [];   
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
UnitsFlag = '';  % hardware, physics, or '' for default units
MCF = [];
DrawLatticeFlag = 1;
h = [];

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
        UnitsFlag = 'Hardware';
        varargin(i) = [];
        if length(varargin) >= i
            if isnumeric(varargin{i})
                MCF = varargin{i};
                varargin(i) = [];
            end
        end
    elseif strcmpi(varargin{i},'simulator') || strcmpi(varargin{i},'model')
        % Ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'online')
        % Ignor
        varargin(i) = [];
    elseif strcmpi(varargin{i},'manual')
        % Ignor
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'DrawLattice','Draw Lattice'}))
        DrawLatticeFlag = 1;
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
        Family1 = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                DeviceList1 = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        DeviceList1 = varargin{1};
        varargin(1) = [];
    elseif isstruct(varargin{1})
        Family1 = varargin{1}.FamilyName;
        DeviceList1 = varargin{1}.DeviceList;
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
        Family2 = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            if isnumeric(varargin{1})
                DeviceList2 = varargin{1};
                varargin(1) = [];
            end
        end
    elseif isnumeric(varargin{1})
        DeviceList2 = varargin{1};
        varargin(1) = [];
    elseif isstruct(varargin{1})
        Family2 = varargin{1}.FamilyName;
        DeviceList2 = varargin{1}.DeviceList;
        if isempty(UnitsFlag)
            UnitsFlag = varargin{1}.Units;
        end
        if ~NumericOutputFlag
            % Only change StructOutputFlag if 'numeric' is not on the input line
            StructOutputFlag = 1;
        end
        varargin(1) = [];      
    end
else
    Family2 = Family1;
    DeviceList2 = DeviceList1;
end

% Get the input units
if isempty(UnitsFlag)
    UnitsFlag = 'Physics';
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



% Transport lines use a different algorithm (twissline)
if istransport
    if strcmpi(UnitsFlag, 'Hardware')
        fprintf('   Dispersion in hardware units is not available for transport lines.\n');
    end
    if ~isempty(DeltaRF)
        fprintf('   Delta RF frequency input is ignored for transport lines.\n');
    end
    if ArchiveFlag
        fprintf('   Archiving dispersion for transport lines is not programmed yet.\n');
    end
    if StructOutputFlag
        fprintf('   Structure outputs for transport lines is not programmed yet.\n');
    end

    if nargout == 0
        if DrawLatticeFlag
            modeltwiss('Eta', Family1, DeviceList1, Family2, DeviceList2, 'DrawLattice');
        else
            modeltwiss('Eta', Family1, DeviceList1, Family2, DeviceList2);
        end
    else
        if DrawLatticeFlag
            [Dx, Dy, Sx, Sy] = modeltwiss('Eta', Family1, DeviceList1, Family2, DeviceList2, 'DrawLattice');
        else
            [Dx, Dy, Sx, Sy] = modeltwiss('Eta', Family1, DeviceList1, Family2, DeviceList2);
        end
    end

    % Add archiving and structure outputs here
    return
end


% Make sure DeltaRF is in hardware units
if isempty(DeltaRF) || ~isnumeric(DeltaRF)
    % Get the default from the AD is in Hardware units
    DeltaRF = getfamilydata('DeltaRFDisp');
    
    % If the default is not in the AD
    if isempty(DeltaRF)
        % Here is the second level default
        DeltaRF = getrf('Model','Hardware') * modelmcf * .002;  % .2% energy change
    end

else
    if strcmpi(UnitsFlag, 'Physics')
        % Change to hardware
        DeltaRF = physics2hw('RF', 'Setpoint', DeltaRF, [1 1]);
    end
end


% DeltaRF are in hardware units at this point
% Change to AT units
DeltaRF = hw2physics('RF', 'Setpoint', DeltaRF, [1 1]);


% Check DeltaRF for resonable values
if DeltaRF > 15000;  % Hz
    tmp = questdlg(sprintf('%f Hz is a large RF change.  Do you want to continue?', DeltaRF),'Dispersion Measurement','YES','NO','YES');
    if strcmp(tmp,'NO')
        Dx=[];  Dy=[];
        return
    end
end

if isempty(MCF)
    MCF = modelmcf;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the model dispersion %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Find which orbit method to use
[CavityState, PassMethod, iCavity] = getcavity;
if isempty(CavityState)
    % No cavity in AT model
    if isradiationon
        fprintf('   Turning radiation off since there is no RF cavity.\n');
        setradiation off;
    end
    ATMethod = 'findorbit4';
else
    if strcmpi(deblank(CavityState(1,:)), 'On') || isradiationon
        % findorbit6 recommended when cavity or radiation is on
        if strcmpi(deblank(CavityState(1,:)), 'Off')
            % Turn off cavity in AT model
            fprintf('   Turning the RF cavity on, since radiation is on.\n');
            setcavity('On');
        end
        ATMethod = 'findorbit6';
    else
        % Cavity is off in AT model
        ATMethod = 'findsyncorbit';
    end
end


if strcmpi(ATMethod, 'findsyncorbit')      
    C = 2.99792458e8;
    CavityFrequency  = THERING{iCavity(1)}.Frequency;
    CavityHarmNumber = THERING{iCavity(1)}.HarmNumber;
    L = findspos(THERING,length(THERING)+1)';  % getfamilydata('Circumference')
    f0 = C * CavityHarmNumber / L;
    RFChange = CavityFrequency - f0;   % To account for all the changes made to the RF [Hz]
    
    if strcmpi(ModulationMethod, 'bipolar')
        ORBITPLUS = findsyncorbit(THERING, (-C*( DeltaRF+RFChange)*CavityHarmNumber/CavityFrequency^2)/2, 1:length(THERING)+1);
        ORBIT0    = findsyncorbit(THERING, (-C*(-DeltaRF+RFChange)*CavityHarmNumber/CavityFrequency^2)/2, 1:length(THERING)+1);
    else
        ORBITPLUS = findsyncorbit(THERING, -C*(DeltaRF+RFChange)*CavityHarmNumber/CavityFrequency^2, 1:length(THERING)+1);
        ORBIT0    = findsyncorbit(THERING, -C*(        RFChange)*CavityHarmNumber/CavityFrequency^2, 1:length(THERING)+1);
    end    
elseif strcmpi(ATMethod, 'findorbit4')
    % Use findorbit4
    % CavityFrequency is needed to for convert DeltaRF to dP
    % Since on cavity is in the model, use the frequency calculated from the harmonic number
    C = 2.99792458e8;
    CavityHarmNumber = getfamilydata('HarmonicNumber');
    if isempty(CavityHarmNumber)
        error('Add HarmonicNumber to the ML so that the RF can be inferred when no cavity is in the model');
    end
    L = findspos(THERING,length(THERING)+1)';  % getfamilydata('Circumference')
    CavityFrequency = C * CavityHarmNumber / L;
    dP = DeltaRF / MCF/ CavityFrequency;
    %DeltaRF = CavityFrequency * MCF * dP;
    if strcmpi(ModulationMethod, 'bipolar')
        ORBITPLUS = findorbit4(THERING, -dP/2, 1:length(THERING)+1);
        ORBIT0    = findorbit4(THERING,  dP/2, 1:length(THERING)+1);
    else
        ORBITPLUS = findorbit4(THERING, -dP, 1:length(THERING)+1);
        ORBIT0    = findorbit4(THERING,   0, 1:length(THERING)+1);
    end    
    
elseif strcmpi(ATMethod, 'findorbit6')
    % Use findorbit6
    CavityFrequency = THERING{iCavity(1)}.Frequency;
    if strcmpi(ModulationMethod, 'bipolar')
        for kk = 1:length(iCavity)
            THERING{iCavity(kk)}.Frequency = CavityFrequency + DeltaRF/2;
        end               
        ORBITPLUS = findorbit6(THERING, 1:length(THERING)+1);
    else
        for kk = 1:length(iCavity)
            THERING{iCavity(kk)}.Frequency = CavityFrequency + DeltaRF;
        end               
        ORBITPLUS = findorbit6(THERING, 1:length(THERING)+1);
    end    
    if strcmpi(ModulationMethod, 'bipolar')
        for kk = 1:length(iCavity)
            THERING{iCavity(kk)}.Frequency = CavityFrequency - DeltaRF/2;
        end               
        ORBIT0 = findorbit6(THERING, 1:length(THERING)+1);
        for kk = 1:length(iCavity)
            THERING{iCavity(kk)}.Frequency = CavityFrequency;
        end               
    else
        for kk = 1:length(iCavity)
            THERING{iCavity(kk)}.Frequency = CavityFrequency;
        end               
        ORBIT0 = findorbit6(THERING, 1:length(THERING)+1);
    end    
end


% Horizontal plane
if strcmpi(Family1,'All')
    Index1 = 1:length(THERING)+1;
    if ~isempty(DeviceList1)
        Index1 = Index1(DeviceList1);
    end
elseif isfamily(Family1)
    Index1 = family2atindex(Family1, DeviceList1);
else
    Index1 = findcells(THERING, 'FamName', Family1);
    if ~isempty(DeviceList1)
        Index1 = Index1(DeviceList1);
    end
end
if isempty(Index1)
    error(sprintf('Family1=%s could not be found in the AO or AT deck',Family1));
else
    Index1 = Index1(:)';    % Row vector
end

D = ORBITPLUS([1 3], Index1) - ORBIT0([1 3], Index1);
Sx = findspos(THERING, Index1);
Sx = Sx(:)';
Dx = D(1,:)' / DeltaRF;

% Vertical plane
if strcmpi(Family2,'All') 
    Index2 = 1:length(THERING)+1;
    if ~isempty(DeviceList2)
        Index2 = Index2(DeviceList2);
    end
elseif isfamily(Family2)
    Index2 = family2atindex(Family2, DeviceList2);
else
    Index2 = findcells(THERING, 'FamName', Family2);
    if ~isempty(DeviceList2)
        Index2 = Index2(DeviceList2);
    end
end
if isempty(Index2)
    error(sprintf('Family2=%s could not be found in the AO or AT deck',Family2));
else
    Index2 = Index2(:)';    % Row vector
end

D = ORBITPLUS([1 3], Index2) - ORBIT0([1 3], Index2);
Sy = findspos(THERING, Index2);
Sy = Sy(:)';
Dy = D(2,:)' / DeltaRF;

% All elements
D = ORBITPLUS([1 3], :) - ORBIT0([1 3], :);
DxAll = D(1,:)' / DeltaRF;
DyAll = D(2,:)' / DeltaRF;
SAll = findspos(THERING, 1:length(THERING)+1);


% Dispersion has units meters/Hz at this point
% Change to true physics units meters/(dp/p)
Dx = -CavityFrequency * MCF * Dx;
Dy = -CavityFrequency * MCF * Dy;
DxAll = -CavityFrequency * MCF * DxAll;
DyAll = -CavityFrequency * MCF * DyAll;

% Fill the dispersion structure (response matrix structure + some fields)
d(1).Data = Dx;
d(2).Data = Dy;
d(1).FamilyName = 'DispersionX';
d(2).FamilyName = 'DispersionY';

try
    d(1).Actuator = family2datastruct('RF', 'Physics');
catch
end
d(1).Actuator.Data = CavityFrequency;
d(2).Actuator = d(1).Actuator;
% d(1).Actuator.Data = CavityFrequency;
% d(2).Actuator.Data = CavityFrequency;
% d(1).Actuator.Units = 'Physics';
% d(2).Actuator.Units = 'Physics';
% d(1).Actuator.UnitsString = 'Hz';
% d(2).Actuator.UnitsString = 'Hz';
d(1).ActuatorDelta = DeltaRF;
d(2).ActuatorDelta = DeltaRF;

if isfamily(Family1) && ismemberof(Family1, 'BPM')
    d(1).Monitor = family2datastruct(Family1, 'Monitor', DeviceList1, 'Physics');
else
    d(1).Monitor.Data = ORBIT0(1, Index1)';
    d(1).Monitor.FamilyName = ['x@', Family1];
    d(1).Monitor.Field = 'Monitor';
    d(1).Monitor.DeviceList = DeviceList1;
    d(1).Monitor.Units = 'Physics';
    d(1).Monitor.UnitsString = 'meters';
    d(1).Monitor.TimeStamp = clock;
    d(1).Monitor.t = 0;
    d(1).Monitor.tout = 0;
end
if isfamily(Family2) && ismemberof(Family2, 'BPM')
    d(2).Monitor = family2datastruct(Family2, 'Monitor', DeviceList2, 'Physics');
else
    d(2).Monitor.Data = ORBIT0(2, Index2)';
    d(2).Monitor.FamilyName = ['y@', Family2];
    d(2).Monitor.Field = 'Monitor';
    d(2).Monitor.DeviceList = DeviceList2;
    d(2).Monitor.Units = 'Physics';
    d(2).Monitor.UnitsString = 'meters';
    d(2).Monitor.TimeStamp = clock;
    d(2).Monitor.t = 0;
    d(2).Monitor.tout = 0;
end

d(1).TimeStamp = clock;
d(2).TimeStamp = d(1).TimeStamp;

for i=1:2
    d(i).Mode = 'Model';
    d(i).Units = 'Physics';
    d(i).UnitsString = 'm/(dp/p)';
    d(i).ModulationMethod = ModulationMethod;
    d(i).OperationalMode = getfamilydata('OperationalMode');
    d(i).DataDescriptor = 'Dispersion';
    d(i).CreatedBy = 'modeldisp';
    d(i).GeV = getenergy('Model');
    d(i).WaitFlag = -2;
    d(i).MCF = MCF;
    d(i).dp = -DeltaRF / (CavityFrequency*MCF);
end


% Final units conversion
if strcmpi(UnitsFlag, 'Hardware')
    if ~ismemberof(Family1, 'BPM') || ~ismemberof(Family2, 'BPM')
        error('Hardware units cannot be used when not using a BPM family');
    end
    d = physics2hw(d);
end


% Output
% Plot if no output
if DisplayFlag
    % Plot dispersion
    % plotdisp cannot handle a AT family name or 'All' so a new dispersion plot was written below
    % plotdisp(d);
    
    clf reset
    %set(gcf,'NumberTitle','on','Name','Model Dispersion');

    UnitsFlag = d(1).Units;
    UnitsString = d(1).UnitsString;

    if strcmpi(UnitsFlag, 'Hardware')
        TitleString = sprintf('Change in Orbit / Change in RF (Delta RF=%g %s)', d(1).ActuatorDelta, d(1).Actuator.UnitsString);
        % Change to hardware units
        DxAll = -1 * DxAll / d(1).Actuator.Data(1) / MCF;
        DyAll = -1 * DyAll / d(2).Actuator.Data(1) / MCF;
    else
        TitleString = sprintf('Dispersion Function: %s  (\\alpha=%.5f, f=%f Hz, \\Deltaf=%g Hz)', texlabel('-alpha f {Delta}Orbit / {Delta}f'), MCF, CavityFrequency, DeltaRF);
    end
    
    h(1,1) = subplot(2,1,1);
    plot(SAll, DxAll, '-b');
    if strcmpi(Family1,'All')
        %xlabel('Position [meters]');
    else
        hold on;
        plot(Sx, d(1).Data, '.b');
        hold off;
        if ~strcmpi(Family1, Family2)
            xlabel(sprintf('%s Position [meters]', Family1));
        end
    end
    ylabel(sprintf('Horizontal [%s]', UnitsString));
    title(TitleString);
    grid on;
    axis tight;
    
    h(2,1) = subplot(2,1,2);
    plot(SAll, DyAll, '-b');
    if strcmpi(Family2,'All')
        xlabel('Position [meters]');
    else
        hold on; 
        plot(Sy, d(2).Data, '.b');
        hold off;
        xlabel(sprintf('%s Position [meters]', Family2));
    end
    ylabel(sprintf('Vertical [%s]', UnitsString));
    grid on;
    axis tight;
    
    L = getfamilydata('Circumference');
    if ~isempty(L)
        xaxis([0 L], h);
    end

    if DrawLatticeFlag
        % Reduce the axes height a little but keep the axis
        a1 = axis(h(1));
        a2 = axis(h(2));
        yaxesposition(.95);
        axis(h(1), a1);
        axis(h(2), a2);
        
        h(3) = subplot(9,1,5);
        drawlattice(0,1);
        set(h(3),'YTick',[]);
        set(h(3),'XTickLabel','');
        set(h(3),'YTickLabel','');
        set(h(3),'Visible','Off');
        yaxis([-1.25 1.75]);

        %hold((h(1)),'on');
        %a = axis(h(1));
        %drawlattice(a(4)-.08*(a(4)-a(3)),.05*(a(4)-a(3)),h(1));
        %axis(h(1), a);
        %hold((h(1)),'off');
        %
        %hold((h(2)),'on');
        %a = axis(h(2));
        %drawlattice(a(4)-.08*(a(4)-a(3)),.05*(a(4)-a(3)),h(2));
        %axis(h(2), a);
        %hold((h(2)),'off');
    end

    % Link the x-axes
    linkaxes(h,'x');
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
    % If the filename contains a directory then make sure it exists
    [DirectoryName, FileName, Ext] = fileparts(FileName);
    DirStart = pwd;
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    BPMxDisp = d(1);
    BPMyDisp = d(2);
    save(FileName, 'BPMxDisp', 'BPMyDisp');
    if DisplayFlag
        fprintf('   Model dispersion data saved to %s.mat\n', [DirectoryName FileName]);
        if ErrorFlag
            fprintf('   Warning: %s was not the desired directory\n', DirectoryName);
        end
    end
    cd(DirStart);
    FileName = [DirectoryName FileName];
end
if FileName == -1
    FileName = '';
end


