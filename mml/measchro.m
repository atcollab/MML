function [Chromaticity, FileName] = measchro(varargin)
%MEASCHRO -  measures the chromaticity function emperically
%  Chrom         = measchro(DeltaRF, WaitFlag);
%  ChromHardware = measchro(DeltaRF, WaitFlag, 'Hardware'); 
%  ChromPhysics  = measchro(DeltaRF, WaitFlag, 'Physics');
%  ChromStruct   = measchro(DeltaRF, WaitFlag, 'Struct');
%
%  INPUTS
%  1. DeltaRF - Vector of master oscillator values to scan over
%               {Default:  [-.4% -.2% 0 .2% .4%] energy change}
%  2. WaitFlag >= 0, WaitFlag seconds before measuring the tune (sec)
%               = -1, wait until the magnets are done ramping
%               = -3, wait until the magnets are done ramping + a delay of 2.2*getfamilydata('TuneDelay') {default} 
%               = -4, wait until keyboard input
%               = -5, input the tune measurement manually by keyboard input
%  4. 'Hardware' - Returns chromaticity in hardware units (typically, Tune/MHz or Tune/MHz)
%     'Physics'  - Returns chromaticity in physics  units (Tune/(dp/p))  {Default}
%  5. 'Struct'  - Will return a two element dispersion data structure array {Default, unless Mode='Model'}
%     'Numeric' - Will return vector outputs
%  6. Optional override of the mode:
%     'Online'    - Set/Get data online  
%     'Simulator' - Set/Get data on the simulated accelerator (ie, same commands as 'Online')
%     'Model'     - Get the model chromaticity directly from the model (uses modelchro, DeltaRF is ignored)
%     'Manual'    - Set/Get data manually
%  7. 'Archive'   - Save a chromaticity data structure to \<Directory.ChroData>\Chromaticity\
%                   with filename <ChroArchiveFile><Date><Time>.mat  {Default, unless Mode='Model'}
%                   To change the filename, included the filename after the 'Archive', '' to browse
%     'NoArchive' - No file archive {Default}
%  8. 'Display'   - Prints status information to the command window {Default, unless Mode='Model'}
%     'NoDisplay' - Nothing is printed to the command window
%
%  
%  OUTPUT
%                  | Horizontal Chromaticity |
%  ChromHardware = |                         |  [Delta Tune / Delta Frequency]
%                  | Vertical Chromaticity   |       (Hardware Units)
%
%  
%                 | Horizontal Chromaticity |
%  ChromPhysics = |                         |  [Delta Tune / Delta Energy]
%                 | Vertical Chromaticity   |       (Physics Units)
%
%  When computing physics units the momentum compaction factor is required.  The default MCF is
%  found using getmcf.  To override the default enter the new value after the 'Physics' input.
%  For example,  ChromPhysics = measchro(DeltaRF, WaitFlag, 'Physics', .0011);
%
%  Tune vs RF frequency or momentum are plotted to the screen
%
%  Fields for structure outputs:
%            Data: [2x1] Chromaticity vector
%      FamilyName: 'Chromaticity'
%         Monitor: Tune structure
%        Actuator: RF frequency structure
%   DeltaActuator: Vector of frequency shifts in Hz
%       TimeStamp: Timestamp
%  DataDescriptor: 'Chromacity'
%       CreatedBy: 'measchro'
%             MCF: Momentum compaction factor/linear
%              RF: Vector of frequency settings in Hz
%               X: Reference orbit
%               Y: Reference orbit
%           Tune0: Initial tune
%            Tune: Tune change with RF frequency, 2 row vectors
%              dp: Vector of normalized momentum shifts
%         PolyFit: Polynomial fit of chromaticity in terms of rf shift or momentum
%
%  NOTE
%  1. 'Hardware', 'Physics', 'Eta', 'Archive', 'Numeric', and 'Struct' are not case sensitive
%  2. 'Zeta' can be used instead of 'Physics'
%  3.  All inputs are optional
%  4.  One reason FamilyName is added to the output structure so that getrespmat can be 
%      used to locate archived dispersion measurements.
%  5.  Units for DeltaRF depend on the 'Physics' or 'Hardware' flags
%  6. Beware of what units you are working in.  The default units for chromaticity
%     are physics units.  This is an exception to the normal middle layer convention.
%     Hardware units for "chromaticity" is in tune change per change in RF frequency.  
%     Since this is an unusual unit to work with, the default units for chromaticity
%     is physics units.  Note that goal chromaticity is also stored in physics units.
%     plotchro can switch between 'Hardware' and 'Physics' after the measurement is taken.
%     As an example of the difference between the units, at Spear3 1 unit of chromaticity
%     in physics units corresponds to roughly -1.8 units in hardware units.  
%
%  See also plotchro, measdisp

%  Written by Greg Portmann and Jeff Corbett


NRFSteps = 1;                % Must be an integer
WaitFlag = -3;               % Power supply + tune measurement delay
MCF = [];
BPMxFamily = gethbpmfamily;  % Just an extra monitor
BPMyFamily = getvbpmfamily;  % Just an extra monitor
StructOutputFlag = 0;
FileName = -1;
ArchiveFlag = -1;
DisplayFlag = -1;
ModeFlag  = '';              % model, online, manual, or '' for default mode
UnitsFlag = 'Physics';       % hardware, physics, or '' for default units


% Look if 'struct' or 'numeric' in on the input line
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Struct')
        StructOutputFlag = 1;
        varargin(i) = [];
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i},'Numeric')
        StructOutputFlag = 0;
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
    elseif strcmpi(varargin{i},'Zeta') || strcmpi(varargin{i},'Physics')
        UnitsFlag = 'Physics';
        varargin(i) = [];
        if length(varargin) >= i
            if isnumeric(varargin{i})
                MCF = varargin{i};
                varargin(i) = [];
                if any(size(MCF)>1)
                    error('Input MCF must be a scalar');
                end
            end
        end
    elseif strcmpi(varargin{i},'Hardware')
        UnitsFlag = 'Hardware';
        varargin(i) = [];
        if length(varargin) >= i
            if isnumeric(varargin{i})
                MCF = varargin{i};
                varargin(i) = [];
                if any(size(MCF)>1)
                    error('Input MCF must be a scalar');
                end
            end
        end
    elseif strcmpi(varargin{i},'Simulator') || strcmpi(varargin{i},'Model') || strcmpi(varargin{i},'Online') || strcmpi(varargin{i},'Manual')
        ModeFlag = varargin{i};
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    end
end

% Default for Model is no display, no archive
if DisplayFlag == -1 && strcmpi(ModeFlag,'Model')
    DisplayFlag = 0;
end
if ArchiveFlag == -1 && strcmpi(ModeFlag,'Model')
    ArchiveFlag = 0;
end


% DeltaRF input
if length(varargin) >= 1
    if isnumeric(varargin{1})
        DeltaRF = varargin{1}; 
    else
        DeltaRF = [];
    end
else
    DeltaRF = [];
end

% WaitFlag input
if length(varargin) >= 2
    WaitFlag = varargin{2};
end
if isempty(WaitFlag) || WaitFlag == -3
    WaitFlag = 2.2 * getfamilydata('TuneDelay');
end
if isempty(WaitFlag)
    WaitFlag = input('   Delay for Tune Measurement (Seconds, Keyboard Pause = -4, or Manual Tune Input = -5) = ');
end


% Archive data structure
if ArchiveFlag
    if isempty(FileName)
        FileName = appendtimestamp(getfamilydata('Default', 'ChroArchiveFile'));
        DirectoryName = getfamilydata('Directory','ChroData');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'Chromaticity', filesep];
        else
            % Make sure default directory exists
            DirStart = pwd;
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            cd(DirStart);
        end
        [FileName, DirectoryName] = uiputfile('*.mat', 'Select Chromaticity File', [DirectoryName FileName]);
        if FileName == 0 
            ArchiveFlag = 0;
            disp('   Chromaticity measurement canceled.');
            Chromaticity=[]; FileName='';
            return
        end
        FileName = [DirectoryName, FileName];
    elseif FileName == -1
        FileName = appendtimestamp(getfamilydata('Default', 'ChroArchiveFile'));
        DirectoryName = getfamilydata('Directory','ChroData');
        if isempty(DirectoryName)
            DirectoryName = [getfamilydata('Directory','DataRoot') 'Chromaticity', filesep];
        end
        FileName = [DirectoryName, FileName];
    end
end


% Get units from the RF frequency
if isempty(UnitsFlag)
    UnitsFlag = getfamilydata('RF','Setpoint','Units');
end


% if isempty(ModeFlag)
%     if strcmpi(getfamilydata('RF','Setpoint','Mode'), getfamilydata(BPMxFamily,'Monitor','Mode'))
%         ModeFlag = getfamilydata(BPMxFamily,'Monitor','Mode');
%     else
%         error('Mix Mode for RF and orbits');
%     end
% end



if strcmpi(UnitsFlag,'Hardware')
    RFUnitsString = getfamilydata('RF','Setpoint','HWUnits');
elseif strcmpi(UnitsFlag,'Physics')
    RFUnitsString = getfamilydata('RF','Setpoint','PhysicsUnits');
else
    error('RF units unknown.  Inputs DeltaRF directly.');
end

% DeltaRF default 
if isempty(DeltaRF)
    % Get the default from the AD is in Hardware units
    DeltaRF = getfamilydata('DeltaRFChro');
    
    % If the default is not in the AD
    if isempty(DeltaRF)
        DeltaRF = getrf('Hardware') * getmcf * [-.004 -.002 0 .002 .004] ;  % .2% energy change per step

        %DeltaRF = [-2000 -1000 0 1000 2000];  % Hz
        %if strcmpi(RFUnitsString, 'Hz')
        %    % Default units OK
        %elseif strcmpi(RFUnitsString, 'kHz')
        %    % Change to kHz
        %    DeltaRF = DeltaRF / 1e3;
        %elseif strcmpi(RFUnitsString, 'MHz')
        %    % Change to MHz
        %    DeltaRF = DeltaRF / 1e6;
        %else
        %    error('RF units unknown.  Input DeltaRF directly or put the default in AD.DeltaRFChro.');
        %end
    else
        if strcmpi(UnitsFlag,'Physics')
            % Since the default from the AO must be in hardware units, change to physics units
            DeltaRF = hw2physics('RF', 'Setpoint', DeltaRF, [1 1], ModeFlag);
        end
    end    
end


% Check DeltaRF for resonable values
if strcmpi(RFUnitsString, 'MHz')
    if abs(max(DeltaRF)-min(DeltaRF)) > .020;  % .020 MHz
        tmp = questdlg(sprintf('%f MHz is a large RF change.  Do you want to continue?', abs(max(DeltaRF)-min(DeltaRF))),'Dispersion Measurement','YES','NO','YES');
        if strcmp(tmp,'NO')
            Chromaticity=[];
            return
        end
    end
elseif strcmpi(RFUnitsString, 'kHz')
    if abs(max(DeltaRF)-min(DeltaRF)) > 20;  % kHz
        tmp = questdlg(sprintf('%f kHz is a large RF change.  Do you want to continue?', abs(max(DeltaRF)-min(DeltaRF))),'Dispersion Measurement','YES','NO','YES');
        if strcmp(tmp,'NO')
            Chromaticity=[];
            return
        end
    end
elseif strcmpi(RFUnitsString, 'Hz')
    if abs(max(DeltaRF)-min(DeltaRF)) > 20000;  % Hz
        tmp = questdlg(sprintf('%f Hz is a large RF change.  Do you want to continue?', abs(max(DeltaRF)-min(DeltaRF))),'Dispersion Measurement','YES','NO','YES');
        if strcmp(tmp,'NO')
            Chromaticity=[];
            return
        end
    end
else
    % Don't who how to check, hence no check made
end

% DeltaRF must be in "RFUnitsString" units at this point


RFsp = getrf('Struct', UnitsFlag, ModeFlag);

if isempty(MCF)
    MCF = getmcf(ModeFlag);
end


% Fill the chromaticity structure (response matrix structure + some fields)
c.Data = [];
c.FamilyName = 'Chromaticity';
if isfamily('TUNE')
    c.Monitor = family2datastruct('TUNE','Monitor',[1 1;1 2]);
else
    c.Monitor = gettune('Struct', 'Model');  % Just to fill the structure
    c.Monitor.Data = NaN * c.Monitor.Data;
end
c.Actuator = RFsp;
c.ActuatorDelta = DeltaRF;
c.GeV = getenergy(ModeFlag);
c.DCCT = getam('DCCT', ModeFlag);
c.ModulationMethod = 'Unipolar';
c.WaitFlag = WaitFlag;
c.TimeStamp = clock;
c.Mode = ModeFlag;
c.Units = UnitsFlag;
c.UnitsString = [];
c.DataDescriptor = 'Chromaticity';
c.CreatedBy = 'measchro';
c.OperationalMode = getfamilydata('OperationalMode');

% Nonstandard response matrix fields
if strcmpi(ModeFlag,'Manual')
    c.X = NaN;
    c.Y = NaN;
else
    c.X = getx('Struct', UnitsFlag, ModeFlag);
    c.Y = gety('Struct', UnitsFlag, ModeFlag);
end
c.MCF = MCF;
RF0 = RFsp.Data(1);
c.dp = -DeltaRF / (RF0*MCF);


if strcmpi(ModeFlag,'Model') || strcmpi(ModeFlag,'Simulator')
    % No need for delays with the model
    WaitFlag = 0;
    ExtraDelay = 0; 
end


if strcmpi(ModeFlag,'Model')
    c.Data = modelchro('Physics');
    
    if strcmpi(UnitsFlag,'Physics')
        TuneUnitsString = getfamilydata('TUNE','Monitor','PhysicsUnits');
        if isempty(TuneUnitsString)
            TuneUnitsString = 'Fractional Tune';
        end
        c.UnitsString = [TuneUnitsString, '/(dp/p)'];
    else
        % Tune Shift vs. RF Frequency 
        c.Data(1,1) = c.Data(1,1) / (-RF0 * MCF);
        c.Data(2,1) = c.Data(2,1) / (-RF0 * MCF);       
        TuneUnitsString = getfamilydata('TUNE','Monitor','HWUnits');
        if isempty(TuneUnitsString)
            TuneUnitsString = 'Fractional Tune';
        end
        c.UnitsString = [TuneUnitsString, '/',getfamilydata('RF','Setpoint','HWUnits')];
    end
    
else
    % Online or Simulator
    % Start measurement
    if DisplayFlag
        fprintf('   Begin chromaticity measurement\n');
    end    
    for i = 1:length(DeltaRF)
        %setrf(RF0 + DeltaRF(i), UnitsFlag, ModeFlag);
        if (isempty(ModeFlag) && strcmpi(getfamilydata('RF','Setpoint','Mode'),'Manual')) || strcmpi(ModeFlag,'Manual')
            % One shot setting of RF
            setrf(RF0 + DeltaRF(i), UnitsFlag, ModeFlag);
        else
            % Slow setting of RF
            rf = getrf(UnitsFlag, ModeFlag);
            for k = 1:NRFSteps
                setsp('RF', rf + k/NRFSteps * (RF0+DeltaRF(i)-rf), [], -1, UnitsFlag, ModeFlag);
                pause(0.1);
            end
        end
        
        RF(:,i) = getrf(UnitsFlag, ModeFlag);
        if DisplayFlag
            fprintf('   %d. RF frequency is %.5f\n', i, RF(:,i));
        end

        % Wait for tune monitor to have fresh data
        if WaitFlag >= 0
            if DisplayFlag && ~strcmpi(ModeFlag,'Manual')
                fprintf('      Pausing %f seconds for the tune measurement\n', WaitFlag); 
                pause(0);
            end
            sleep(WaitFlag);
            Tune(:,i) = gettune(ModeFlag);
        elseif WaitFlag == -4
            tmp = input('      Hit return when the tune measurement is ready. ');
            Tune(:,i) = gettune(ModeFlag);
        elseif WaitFlag == -5
            Tune(1,i) = input('      Input the horizontal tune = ');
            Tune(2,i) = input('      Input the  vertical  tune = ');
        else
            error('Tune delay method unknown');
        end 
        
        %if any(isnan(Tune))
        %    fprintf('   Chromaticity measurement failed.  RF frequency reset.\n');
        %    setrf(RF0, UnitsFlag, ModeFlag);
        %    Chromaticity = [NaN; NaN];
        %    return;
        %end
    end
    
    
    % Reset RF
    %setrf(RF0, UnitsFlag, ModeFlag);
    if isempty(ModeFlag) && strcmpi(getfamilydata('RF','Setpoint','Mode'),'Manual')
        % One shot setting of RF
        setrf(RF0, UnitsFlag, ModeFlag);
    else
        % Slow setting of RF
        rf = getrf(UnitsFlag, ModeFlag);
        for k = 1:NRFSteps
            setsp('RF', rf + k/NRFSteps * (RF0-rf), [], -1, UnitsFlag, ModeFlag);
            pause(0.1);
        end
        setrf(RF0, UnitsFlag, ModeFlag); %for some reason the prior loop doesn't get back to the starting point, even though the frequency it is trying to set is the correct one?!?
    end
    
    
    % Load Tune measurements into the chromaticy structure
    c.Tune = Tune;
    
    if strcmpi(UnitsFlag,'Physics')
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Tune Shift vs. Momentum %  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Horizontal tune vs. momentum
        p = polyfit(c.dp, Tune(1,:), 2);              %2nd order polynomial fit to data    
        c.PolyFit(1,:) = p;
        c.Data(1,1) = p(2);
        
        % Vertical  tune vs. rf frequency
        p = polyfit(c.dp, Tune(2,:), 2);
        c.PolyFit(2,:) = p;
        c.Data(2,1) = p(2);
        
        TuneUnitsString = getfamilydata('TUNE','Monitor','PhysicsUnits');
        if isempty(TuneUnitsString)
            c.UnitsString = ['Fractional Tune/(dp/p)'];
        else
            c.UnitsString = [TuneUnitsString,'/(dp/p)'];
        end
        
        %fprintf('\n   Horizontal Chromaticity (Un-normalized) = %f \n', c.Data(1));
        %fprintf('   Vertical   Chromaticity (Un-normalized) = %f \n'  , c.Data(2));
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Tune Shift vs. RF Frequency %  
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Horizontal tune vs. rf frequency
        p = polyfit(DeltaRF, Tune(1,:), 2);      % 2nd order polynomial fit to data
        c.PolyFit(1,:) = p;
        c.Data(1,1) = p(2);
        
        % Vertical  tune vs. rf frequency
        p = polyfit(DeltaRF, Tune(2,:), 2);
        c.PolyFit(2,:) = p;
        c.Data(2,1) = p(2);
        
        TuneUnitsString = getfamilydata('TUNE','Monitor','HWUnits');
        if isempty(TuneUnitsString)
            c.UnitsString = ['Fractional Tune/',getfamilydata('RF','Setpoint','HWUnits')];
        else
            c.UnitsString = [TuneUnitsString,'/',getfamilydata('RF','Setpoint','HWUnits')];
        end
    end
end

if DisplayFlag
    fprintf('   Chromaticity = %f [%s]\n', c.Data(1), c.UnitsString);
    fprintf('   Chromaticity = %f [%s]\n', c.Data(2), c.UnitsString);
end

if DisplayFlag && ~strcmpi(ModeFlag,'Model')
    %figure;
    plotchro(c);
end


% Archive data structure
if ArchiveFlag
    % If the filename contains a directory then make sure it exists
    [DirectoryName, FileName, Ext] = fileparts(FileName);
    DirStart = pwd;
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    Chromaticity = c;
    save(FileName, 'Chromaticity');
    if DisplayFlag
        fprintf('   Chromaticity data saved to %s.mat\n', [DirectoryName FileName]);
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


% Load output data
if StructOutputFlag
    Chromaticity = c;
else
    Chromaticity = c.Data;
end


if DisplayFlag
    fprintf('   Chromaticity measurement is complete.\n');
end


