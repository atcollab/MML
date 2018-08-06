function [Caen, FileName] = setcaen(varargin)
%SETCAEN
%
% setcaen(ActionString, BaseName)
%
%  Complete initialization of the the Caen power supplies:
%    setcaen('Init GTB')
%    setcaen('Init BTS')
%    setcaen('Init SR')
%    setcaen('Init SR60')
%
%  NOTE
%  1. the initialization part of this function will work in any MML mode.
%
%
%  See also caenparameters, checkcaen

% Written by Greg Portmann

% To do:
% *  Debug SR60
% *  Add a devicelist or 1 at a time


if nargin < 1
    error('One input needed.');
    %Caen.SN    = 39;       % Complete 36 37 38 39    27
    %Caen.Name  = sprintf('CAENA36XX:%d', 9);
    %Caen.Model = 'A3610';
end

Caen = [];
if length(varargin) >= 1 && isstruct(varargin{1})
    Caen =  varargin{1};
    varargin(1) = [];
end

Commands = {};
FileName = '';
Out = [];
FigNum = [];
FontSize = 12;
Iterations = 10;
DelaySec = 0;
SaveWaveforms = 1;

for i = length(varargin):-1:1
    if isstruct(varargin{i})
        % Ignor structures
    elseif iscell(varargin{i})
        % Ignor cells
    elseif strcmpi(varargin{i}, 'Struct')
        % Ignor, gets separated out later
    elseif strcmpi(varargin{i}, 'Numeric')
        %OutputStruct = 0;
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'Init GTB','InitGTB'}))
        Caen.Command = 'Init GTB';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'Init BTS','InitBTS'}))
        Caen.Command = 'Init BTS';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'Init SR','InitSR'}))
        Caen.Command = 'Init SR';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'Init SR60','InitSR60'}))
        Caen.Command = 'Init SR60';
        varargin(i) = [];
    elseif strcmpi(varargin{i}, 'Start Waveform')
        Caen.Command = 'Start Waveform';
        varargin(i) = [];
    elseif strcmpi(varargin{i}, 'Stop Waveform')
        Caen.Command = 'Stop Waveform';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'FigNum', 'Figure'}))
        FigNum = varargin{i+1};
        varargin(i:i+1) = [];
    elseif any(strcmpi(varargin{i}, {'Delay'}))
        DelaySec = varargin{i+1};
        varargin(i:i+1) = [];
    elseif any(strcmpi(varargin{i}, {'Iterations'}))
        Iterations = varargin{i+1};
        varargin(i:i+1) = [];
    elseif strcmpi(varargin{i}, 'On')
        Caen.Command = 'On';
        varargin(i) = [];
    elseif strcmpi(varargin{i}, 'Off')
        Caen.Command = 'Off';
        varargin(i) = [];
    elseif strcmpi(varargin{i}, 'Reset')
        Caen.Command = 'Reset';
        varargin(i) = [];
    elseif strcmpi(varargin{i}, 'Sine')
        Caen.Command = 'Sine';
        varargin(i) = [];
    elseif strcmpi(varargin{i}, 'Plot')
        Caen.Command = 'Plot';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'SY3634Init', 'SY3634 Initialize'}))
        Caen.Command = 'SY3634Init';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'SY3662Init', 'SY3662 Initialize'}))
        Caen.Command = 'SY3634Init';  % same init as SY3634 series
        varargin(i) = [];
        
    elseif any(strcmpi(varargin{i}, {'Step', 'Step Response','StepResponse'}))
        %Commands = [Commands varargin(i)];
        Caen.Command = 'Step Response';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'RMS', '0 Current RMS'}))
        Caen.Command = 'RMS';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'RMS Setup'}))
        Caen.Command = 'RMS Setup';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'Drift'}))
        Caen.Command = 'Drift';
        varargin(i) = [];
    elseif any(strcmpi(varargin{i}, {'BaseName','Name'}))
        Caen.Name = varargin{i+1};
        varargin(i:i+1) = [];
    elseif strcmpi(varargin{i},'FileName')
        if length(varargin) >= i+1 && ischar(varargin{i+1})
            FileName = varargin{i+1};
            varargin(i:i+1) = [];
        else
            varargin(i) = [];
        end
        if isempty(FileName) % && strcmpi(Caen.Command, 'Plot')
            if ispc
                DirectoryName = 'm:\PowerSupplies\CaenInjAcceptanceTests';
            else
                DirectoryName = '/home/physdata/PowerSupplies/CaenInjAcceptanceTests';
            end
            %  [FileName, DirectoryName] = uiputfile('*.mat', 'Caen data output file', DirectoryName);
            [FileName, DirectoryName] = uigetfile('*.mat', 'Caen data output file', DirectoryName);
            if FileName == 0
                FileName = '';
                return;
            end
            FileName = [DirectoryName FileName];
        end
    end
end

if length(varargin) >= 1 && isstruct(varargin{1})
    Caen = varargin{1};
end


% if (~strcmpi(Caen.Command,'Plot') || ~strcmpi(Caen.Command,'Init All')) && isempty(Caen.Name)
%     error('Input the power supply base name (see help setcaen)');
% end

if ~isfield(Caen, 'Command')
    error('Unknown input command (setcaen).');
end

switch Caen.Command
    
    case 'Init GTB'
        if length(varargin) >= 1 % && (ischar(varargin{1}) || isempty(varargin{1}))
            DevName = varargin{1};
            varargin(i) = [];
            Caen = caenparameters('GTB', DevName);
            if isempty(Caen)
                fprintf('   No magnet selected.\n');
                return
            end
        else
            Caen = caenparameters('GTB');
        end
        
        for i = 1:length(Caen)
            setcaen(Caen(i), [Caen(i).Model 'Init']);
        end
        
        
    case 'Init BTS'
        if length(varargin) >= 1 % && (ischar(varargin{1}) || isempty(varargin{1}))
            DevName = varargin{1};
            varargin(i) = [];
            Caen = caenparameters('BTS', DevName);
            if isempty(Caen)
                fprintf('   No magnet selected.\n');
                return
            end
        else
            Caen = caenparameters('BTS');
        end
        
        for i = 1:length(Caen)
            setcaen(Caen(i), [Caen(i).Model 'Init']);
        end
        
        
    case 'Init SR'
        
        if length(varargin) >= 1 % && (ischar(varargin{1}) || isempty(varargin{1}))
            DevName = varargin{1};
            varargin(i) = [];
            Caen = caenparameters('SR', DevName);
            if isempty(Caen)
                fprintf('   No magnet selected.\n');
                return
            end
        else
            Caen = caenparameters('SR');
        end
        
        for i = 1:length(Caen)
            setcaen(Caen(i), [Caen(i).Model 'Init']);
        end
        
        
    case 'Init SR60'
        % SY3662 Units
        
        if length(varargin) >= 1 % && (ischar(varargin{1}) || isempty(varargin{1}))
            DevName = varargin{1};
            varargin(i) = [];
            Caen = caenparameters('SR60', DevName);
            if isempty(Caen)
                fprintf('   No magnet selected.\n');
                return
            end
        else
            Caen = caenparameters('SR60');
        end
        
        for i = 1:length(Caen)
            setcaen(Caen(i), [Caen(i).Model 'Init']);
        end
        
        
    case 'SY3662Init'
        fprintf('   Initializing power supply %s\n', Caen.Name);
        error('60A init uses SY3624');
        
        
    case 'SY3634Init'
        % Actually works for SY3634 ro SY3662 style supplies
        
        fprintf('   Initializing power supply %s, model %s\n', Caen.Name, Caen.Model);
        
        %  First check if a change is needed
        [Caen, ChangesNeeded] = checkcaen(Caen, 'Display', 'Off');
        
        Caen.Version = getpv([Caen.Name,':Version'], 'char');

        
        if ChangesNeeded == 0
            fprintf('   No EEPROM changes made to power supply %s, model %s (%s)\n', Caen.Name, Caen.Model, Caen.Version);
            
        else            
            fprintf('   Turning off power supply %s, model %s for %d EEPROM changes (%s)\n', Caen.Name, Caen.Model, ChangesNeeded, Caen.Version);

            %%%%%%%%%%%%%%
            % Initialize %
            %%%%%%%%%%%%%%
            
            % Setup requiring a passwd
            
            % Newton Raphson Iterations * 5
            % Diagnostic Routine Iterations * 4
            % Min DC-Link allarm [V] * 11
            % Max MOSFET Temperature * 55
            % Max SHUNT Temperature *  55
            % Ripple - check time [s] ** 1
            % Fan minimum speed [#] ** 25
            
            % Turn off supply first
            setcaen(Caen, 'Off');
            pause(.1);
            
            % Set passwd
            setpvonline([Caen.Name,':Password'], 'PS-ADMIN');
            pause(.1);
            
            % Interlocks
            % InterlockEnable  0 -> None
            %                  1 -> First   interlock
            %                  3 -> First 2 interlocks
            %                  7 -> First 3 interlocks
            %                 15 -> First 4 interlocks
            % InterlockTime [msec]
            if strcmpi(Caen.Name, 'LTB:B3')
                setpv_local_interlock([Caen.Name,':EEP_Intlk1Name'], 'OVERTEMP');
                setpv_local_interlock([Caen.Name,':EEP_Intlk2Name'], 'WATERFLOW');
                setpv_local_interlock([Caen.Name,':EEP_Intlk3Name'], 'CRASHOFF');
                InterlockEnable = 3;  % was 7, but issues with the crashoff
                InterlockTime = 1000;

            elseif length(Caen.Name)>=10 && strcmpi(Caen.Name(7:10), 'SQSH')
                % SR 60A skew quads
                setpv_local_interlock([Caen.Name,':EEP_Intlk1Name'], 'O/T & WFLW');
                setpv_local_interlock([Caen.Name,':EEP_Intlk2Name'], 'INTLK2');
                setpv_local_interlock([Caen.Name,':EEP_Intlk3Name'], 'INTLK3');
                InterlockEnable = 1;
                InterlockTime = 500;

            elseif length(Caen.Name)>=9 && strcmpi(Caen.Name(7:9), 'SQS')
                % SR 20A skew quads
                setpv_local_interlock([Caen.Name,':EEP_Intlk1Name'], 'MAGNET');
                setpv_local_interlock([Caen.Name,':EEP_Intlk2Name'], 'INTLK2');
                setpv_local_interlock([Caen.Name,':EEP_Intlk3Name'], 'INTLK3');
                InterlockEnable = 1;
                InterlockTime = 500;
            else
                setpv_local_interlock([Caen.Name,':EEP_Intlk1Name'], 'INTLK1');
                setpv_local_interlock([Caen.Name,':EEP_Intlk2Name'], 'INTLK2');
                setpv_local_interlock([Caen.Name,':EEP_Intlk3Name'], 'INTLK3');
                InterlockEnable = 0;
                InterlockTime = 1000;
            end
            setpv_local_interlock([Caen.Name,':EEP_Intlk4Name'], 'INTLK4');
            setpv_local_interlock([Caen.Name,':EEP_Intlk5Name'], 'INTLK5');
            setpv_local_interlock([Caen.Name,':EEP_Intlk6Name'], 'INTLK6');
            setpv_local_interlock([Caen.Name,':EEP_Intlk7Name'], 'INTLK7');
            setpv_local_interlock([Caen.Name,':EEP_Intlk8Name'], 'INTLK8');
            
            % Add check for interlock state
            % What's the PV type???
            % EEP_IntlkEnable  0x1  what is EEP_IntlkEnableOC???
            % EEP_IntlkState   0x0
            % Interlock time  1000 ms?
            setpv_local([Caen.Name,':EEP_IntlkEnable'], InterlockEnable);
            setpv_local([Caen.Name,':EEP_IntlkState'], 0);
            setpv_local([Caen.Name,':EEP_Intlk1Time'], InterlockTime);
            setpv_local([Caen.Name,':EEP_Intlk2Time'], InterlockTime);
            setpv_local([Caen.Name,':EEP_Intlk3Time'], InterlockTime);
            setpv_local([Caen.Name,':EEP_Intlk4Time'], InterlockTime);
            
            % PID
            setpv_local([Caen.Name,':ControllerKp'], Caen.Kp);
            setpv_local([Caen.Name,':ControllerKi'], Caen.Ki);
            setpv_local([Caen.Name,':ControllerKd'], Caen.Kd);
            
            % Current limit
            setpv_local([Caen.Name,':EEP_Imax'], Caen.Limit + .1);
            
            % Regulation maximum threshold [A]:  (Default: .2 A)
            % Regulation out of range threshold [#] **  150000
            if any(strcmpi(Caen.Model, {'SY3662'}))
                setpv_local([Caen.Name,':EEP_IregLim'], .4);
            else
                setpv_local([Caen.Name,':EEP_IregLim'], 20);  % ?? Removing to allow for steps with long time constants
            end
            
            % Ripple maximum current threshold [A] * .1
            %      Default: 1% of max current -> Caen said?
            %               appears to be .15 for A3620
            % Ripple  out of range threshold [#] ** 100
            % Ripple - wait before check [s] ** 5
            if any(strcmpi(Caen.Model, {'SY3662'}))
                setpv_local([Caen.Name,':EEP_IrippleLim'], .4);
            else
                setpv_local([Caen.Name,':EEP_IrippleLim'], 20);   % was 1, .4 didn't work, Default: .15
            end
            
            % Ground fault
            if any(strcmpi(Caen.Model, {'SY3662'}))
                setpv_local([Caen.Name,':EEP_IgroundLim'], .05);  % the 60A have a must better ground fault curcuit
            else
                setpv_local([Caen.Name,':EEP_IgroundLim'], 1);   % was .2 Seems high, but some of the LN magnets need at least .1
            end
            
            % Un-set passwd
            pause(.5);
            setpvonline([Caen.Name,':Password'], ' ');
            
            % Reset
            setcaen(Caen, 'Reset');
            
            pause(.1);
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Setup Without PassWD (no screen info) %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Slew rate
        setpvonline([Caen.Name,':SlewRate'], Caen.SlewRate);
        
        %
        if 1
            % Turn on slew control
            setpvonline([Caen.Name,':SlewControl'], 1);
            
            % EPICS slew rate (0->Inf/Off)
            setpvonline([Caen.Name,':Setpoint.OROC'], 0);
        else
            % Turn off slew control
            setpvonline([Caen.Name,':SlewControl'], 0);
            
            % EPICS slew rate
            setpvonline([Caen.Name,':Setpoint.OROC'], .1);
        end
        
        % Change some names (really minor)
        try
            % This will turn the power off!!!
   %         setpvonline([Caen.Name,':BulkEnable.ZNAM'], 'Disable');
   %         setpvonline([Caen.Name,':BulkEnable.ONAM'], 'Enable');
   %         setpvonline([Caen.Name,':BulkStatus.ZNAM'], 'Off');
   %         setpvonline([Caen.Name,':BulkStatus.ONAM'], 'On');
        catch
        end
        
        
        fprintf('   Initializing %s complete.\n\n', Caen.Name);
        
        
    case 'On'
        if getpv([Caen.Name,':SupplyOn']) == 0
            % Zero the setpoint
            setpvonline([Caen.Name,':Setpoint'], 0);
            
            % Check for faults
            if getpv([Caen.Name,':GenericFault'], 'double')
                fprintf('   Power supply faulted:  Trying a reset\n');
                setpvonline([Caen.Name,':Reset'], 1);
                pause(2);
                if getpv([Caen.Name,':GenericFault'], 'double')
                    error('Power supply did not reset');
                end
            end
            
            % Turn on
            setpvonline([Caen.Name,':BulkEnable'], 1);
            setpvonline([Caen.Name,':Enable'],     1);
            pause(1);
        end
        if getpv([Caen.Name,':SupplyOn']) == 0
            error('Power supply failed to turn on.');
        end
        
    case 'Off'
        if getpv([Caen.Name,':Enable']) == 1
            % Turn off
            setpvonline([Caen.Name,':Setpoint'], 0);
            
            % Wait on ramp down???
            pause(1);
            
            setpvonline([Caen.Name,':Enable'],     0);
            setpvonline([Caen.Name,':BulkEnable'], 0);
        else
            setpvonline([Caen.Name,':Setpoint'],   0);
            setpvonline([Caen.Name,':Enable'],     0);
            setpvonline([Caen.Name,':BulkEnable'], 0);
        end
        pause(.1);
        
    case 'Reset'
        setcaen(Caen, 'Off');
        setpvonline([Caen.Name,':Reset'], 1);
        pause(.5);
        
        
    case 'Stop Waveform'
        setpvonline([Caen.Name,':WaveformStop'], 0, 'float', 1);
        
        
    case 'Start Waveform'
        setpvonline([Caen.Name,':WaveformStart.PROC'], 1, 'float', 1);
        
        
    case 'Step Response'
        % SETUP
        
        fprintf('   Step response test for power supply %s\n', Caen.Name);
        
        Caen.Command = 'Step Response';
        
        if ~isfield(Caen, 'Amp')
            Caen.Amp = 1.0;
        end
        
        if isempty(FileName)
            FileName = sprintf('Caen%s_SN%03d_Step_Set2', Caen.Model, Caen.SN);
        end
        
        % Check if exists
        %if exist(FileName, 'file')
        %    FileName(end)
        %end
        
        % Waveform
        % Waveform -> CAENA36XX:1:SetpointWF         10,000 points over 10 seconds
        % start    -> CAENA36XX:1:WaveformStart.PROC
        % stop     -> CAENA36XX:1:WaveformStop
        % active   -> CAENA36XX:1:WaveformActive      Monitor
        % counter  -> CAENA36XX:1:WaveformCount       Not working
        
        % Waveform - Step
        setpvonline('ztec17:setInp1Range',  10.0);  % .0125 steps
        setpvonline('ztec17:setInp1Offset',  0.0);
        
        setpvonline('ztec17:setInp2Range',  10.0);  % .0125 steps
        setpvonline('ztec17:setInp2Offset',  0.0);
        
        setpvonline('ztec17:setHorzOffset',  1.0);
        
        setpvonline('ztec17:setInp1Filter',  1);
        setpvonline('ztec17:setInp2Filter',  1);
        
        setpvonline('ztec17:setInp1Couple',  1);   % 1 -> DC Coupled
        setpvonline('ztec17:setInp2Couple',  1);   % 0 -> AC Coupled
        
        SampleRate = 20e3;  % Hz  (20kHz appears to be the lowest sample rate)
        HorzTime = getpvonline('ztec17:getHorzPoints') / SampleRate;
        setpvonline('ztec17:setHorzTime',   HorzTime);
        setpvonline('ztec17:setTrigSource', 'INP1');
        setpvonline('ztec17:setTrigSlope',  'NEG');    % Trigger Slope: 'POS' or 'NEG'
        setpvonline('ztec17:setTrigLevInp1', -.67);
        
        % Zero current and stop waveform
        setpvonline([Caen.Name,':Setpoint'], 0);
        setpvonline([Caen.Name,':WaveformStop'], 0, 'float', 1);
        
        setpvonline([Caen.Name,':Setpoint'], 0);
        
        % Make sure PS is on
        setcaen(Caen, 'On');
        
        % Waveform
        a = [zeros(1,100) ones(1,1500) -1*ones(1,2000) zeros(1,500) zeros(1,5900)];
        setpvonline([Caen.Name,':SetpointWF'], Caen.Amp*a, 'float', 1);
        
        setpvonline([Caen.Name,':BulkEnable'], 1);
        setpvonline([Caen.Name,':Enable'],     1);
        
        % Start waveform
        setpvonline([Caen.Name,':WaveformStart.PROC'], 1, 'float', 1);
        pause(.1);
        
        
        % MEASURE
        Caen = getcaen_local(Caen);
        Caen.Scope = getztec17(Iterations, DelaySec, SaveWaveforms, Caen);
        
        save(FileName, 'Caen');
        %save CaenA3610_SN027_Step1p5 Ztec Caen
        fprintf('   Data saved to %s\n', FileName)
        
        % Stop wavefrom
        setpvonline([Caen.Name,':WaveformStop'], 0, 'float', 1);
        
        
        % PLOT
        setcaen(Caen, 'Plot', 'FileName', FileName, 'FigNum', FigNum);
        
        fprintf('   Step response test complete.\n\n');
        
        
    case 'Sine'
        % SETUP
        
        fprintf('   Sine wave test for power supply %s\n', Caen.Name);
        
        Caen.Command = 'Sine';
        
        if ~isfield(Caen, 'Amp')
            Caen.Amp = .01;
        end
        
        if isempty(FileName)
            FileName = sprintf('Caen%s_SN%03d_Sine_Set1', Caen.Model, Caen.SN);
        end
        
        % Waveform
        % Waveform -> CAENA36XX:1:SetpointWF         10,000 points over 10 seconds
        % start    -> CAENA36XX:1:WaveformStart.PROC
        % stop     -> CAENA36XX:1:WaveformStop
        % active   -> CAENA36XX:1:WaveformActive      Monitor
        % counter  -> CAENA36XX:1:WaveformCount       Not working
        
        % SETUP
        WaveFormFlag = getpv([Caen.Name,':WaveformActive']);
        
        % Zero current and stop waveform
        %     setpvonline([Caen.Name,':Setpoint'], 0);
        setpvonline([Caen.Name,':WaveformStop'], 0, 'float', 1);
        
        % Make sure PS is on
        setcaen(Caen, 'On');
        
        
        % Scope setup
        %SampleRate = 25e3;  % Hz  (20kHz appears to be the lowest sample rate)
        %         setpvonline('ztec17:setInp1Range',  0.05);  % .0125 steps
        %         setpvonline('ztec17:setInp1Offset', 0.0);
        %
        %         setpvonline('ztec17:setInp2Range',  0.05);  % .0125 steps
        %         setpvonline('ztec17:setInp2Offset', 0.0);
        %
        %         %setpvonline('ztec17:setInp1Offset', 1.0);
        %         setpvonline('ztec17:setHorzOffset', 0.0);
        %
        %         setpvonline('ztec17:setInp1Filter', 1);
        %         setpvonline('ztec17:setInp2Filter', 1);
        %
        %         setpvonline('ztec17:setInp1Couple', 1);   % 1 -> DC Coupled
        %         setpvonline('ztec17:setInp2Couple', 1);   % 0 -> AC Coupled
        %
        %         HorzTime = getpvonline('ztec17:getHorzPoints') / SampleRate;
        %         setpvonline('ztec17:setHorzTime', HorzTime);
        %         setpvonline('ztec17:setTrigSource', 'MAN');
        
        
        % Zero current and stop waveform
        %        setpvonline([Caen.Name,':Setpoint'], 0);
        if getpvonline([Caen.Name,':WaveformStop'],'double') == 1
            setpvonline([Caen.Name,':WaveformStop'], 0, 'float', 1);
        end
        
        % Make sure PS is on
        setcaen(Caen, 'On');
        
        % Waveform (10000 points)
        T = 10/10000;   % Waveform
        t = T*(0:9999);
        f = 20;  % Hz
        a = sin(2*pi*f*t);
        figure(101);
        plot(t,a);
        
        setpvonline([Caen.Name,':SetpointWF'], Caen.Amp*a, 'float', 1);
        %        setpvonline([Caen.Name,':BulkEnable'], 1, 'float', 1);
        %        setpvonline([Caen.Name,':Enable'], 1, 'float', 1);
        
        % Start waveform
        pause(.25);
        setpvonline([Caen.Name,':WaveformStart.PROC'], 1, 'float', 1);
        pause(.1);
        
        
        % MEASURE
        %         Caen = getcaen_local(Caen);
        %         [Scope, Caen] = getztec17(Iterations, DelaySec, SaveWaveforms, Caen);
        %         Caen.Scope = Scope;
        %         Caen.Waveform = 'On';
        %         Caen.Freq = f;
        %
        %        %FileName = sprintf('Test1');
        %        save(FileName, 'Caen');
        %        %save CaenA3610_SN027_Step1p5 Ztec Caen
        %        fprintf('   Data saved to %s\n', FileName)
        
        % Stop wavefrom
        %        setpvonline([Caen.Name,':WaveformStop'], 0, 'float', 1);
        
        
        % PLOT
        %        setcaen(Caen, 'Plot', 'FileName', FileName, 'FigNum', FigNum);
        
        %        fprintf('   Sine test complete.\n\n');
        
        
    case 'RMS Setup'
        
        % SETUP
        SampleRate = 250e3;  %250e3;  % Hz  (20kHz appears to be the lowest sample rate)
        WaveFormFlag = getpv([Caen.Name,':WaveformActive']);
        
        % Stop waveform
        setpvonline([Caen.Name,':WaveformStop'], 0, 'float', 1);
        
        % Make sure PS is on
        setcaen(Caen, 'On');
        
        % Set the rate limit on
        setpvonline([Caen.Name,':SlewControl'], 1);
        
        % Set the current
        if getpvonline([Caen.Name,':Setpoint']) ~= Caen.Amp
            setpvonline([Caen.Name,':Setpoint'], Caen.Amp);
            fprintf('   Pauing 60 seconds for PS steady state\n');
            pause(60)
        end
        
        % Scope setup
        setpvonline('ztec17:setInp1Range',  0.2);  % .2 is lowest gain before scaling the 14-bits (.0125 steps)
        setpvonline('ztec17:setInp1Offset', 0.0);
        
        setpvonline('ztec17:setInp2Range',  0.2);  % .0125 steps
        setpvonline('ztec17:setInp2Offset', 0.0);
        
        %setpvonline('ztec17:setInp1Offset', 1.0);
        setpvonline('ztec17:setHorzOffset', 0.0);
        
        setpvonline('ztec17:setInp1Filter', 1);
        setpvonline('ztec17:setInp2Filter', 1);
        
        if abs(Caen.Amp) > .015   %  .1/(15/4) = 0.0267
            setpvonline('ztec17:setInp1Couple', 0);   % 1 -> DC Coupled
            setpvonline('ztec17:setInp2Couple', 0);   % 0 -> AC Coupled
        else
            setpvonline('ztec17:setInp1Couple', 1);   % 1 -> DC Coupled
            setpvonline('ztec17:setInp2Couple', 1);   % 0 -> AC Coupled
        end
        
        HorzTime = getpvonline('ztec17:getHorzPoints') / SampleRate;
        setpvonline('ztec17:setHorzTime', HorzTime);
        setpvonline('ztec17:setTrigSource', 'MAN');
        
        if WaveFormFlag
            pause(10);
        else
            pause(1);
        end
        
    case 'RMS'
        fprintf('   RMS test for power supply %s\n', Caen.Name);
        
        if isempty(FileName)
            FileName = sprintf('Caen%s_SN%03d_%dp%.0fA_Set1', Caen.Model, Caen.SN, floor(Caen.Amp), abs(10*rem(Caen.Amp,1)));
        end
        %FileName = sprintf('Danfysik_PowerSupplyDisconnected_250kHz_15Turns_Highpass', Caen.SN);
        %FileName = sprintf('CaenA36XX_SN%03d_0A_100k_Set1', Caen.SN);
        %FileName = sprintf('CaenA36XX_SN%03d_0A_Set1', Caen.SN);
        
        % SETUP
        setcaen(Caen, 'RMS Setup');
        
        % MEASURE
        Caen = getcaen_local(Caen);
        [Scope, Caen] = getztec17(Iterations, DelaySec, SaveWaveforms, Caen);
        Caen.Scope = Scope;
        
        save(FileName, 'Caen');
        fprintf('   Data saved to %s\n', FileName)
        
        % PLOT
        setcaen(Caen, 'Plot', 'FileName', FileName, 'FigNum', FigNum);
        
        fprintf('   RMS test complete.\n\n');
        
        
    case 'Drift'
        fprintf('   Drift test for power supply %s\n', Caen.Name);
        
        if isempty(FileName)
            FileName = sprintf('Caen%s_SN%03d_DriftTest_Set1', Caen.Model, Caen.SN);
        end
        
        % SETUP
        SaveWaveforms = 0;
        setcaen(Caen, 'RMS Setup');
        
        % 4 A/Volt / # turns
        if isfield(Caen, 'DanTurns');
            Caen.Cal = 4 / Caen.DanTurns;
        else
            Caen.Cal = 1;
        end
        
        % Make sure DC coupled
        % 1 -> DC Coupled
        % 0 -> AC Coupled
        setpvonline('ztec17:setInp1Couple', 1);
        setpvonline('ztec17:setInp2Couple', 1);
        
        % MEASURE
        Caen = getcaen_local(Caen);
        [Scope, Caen] = getztec17(Iterations, DelaySec, SaveWaveforms, Caen);
        Caen.Scope = Scope;
        
        save(FileName, 'Caen');
        fprintf('   Data saved to %s\n', FileName)
        
        % PLOT
        setcaen(Caen, 'Plot', 'FileName', FileName, 'FigNum', FigNum);
        
        fprintf('   Drift test complete.\n\n');
        
        
    case 'Plot'
        
        if ~isempty(FileName)
            load(FileName);
        end
        
        % 4 A/Volt / # turns  (Connector labelled as 40A max)
        if isfield(Caen, 'DanTurns');
            Cal = 4 / Caen.DanTurns;
        else
            Cal = 1;
        end
        
        if strcmpi(Caen.Command, 'Step Response')
            
            t = Caen.Scope.t;
            y = Cal * Caen.Scope.Inp1.Data;
            
            if isempty(FigNum)
                FigNum = 1;
            end
            
            figure(FigNum);
            clf reset
            
            h = subplot(2,1,1);
            plot(t, y);
            %hold on
            y = mean(y,1);
            %plot(t, y, 'k');
            %hold off
            title(sprintf('Caen A3610 SN %d', Caen.SN), 'FontSize', FontSize);
            ylabel('Current [Amps]', 'FontSize', FontSize);
            grid on
            axis tight
            %yaxis([-1.1 1.1]);
            
            n = 100;
            tt = t(1:100000-25);
            Rate = zeros(1,100000-n-100);
            for i = 1:length(Rate)
                %tt(i) = t(i);
                Rate(i) = Caen.L * (y(i+n)-y(i))/(t(i+n)-t(i));
            end
            
            h(2) = subplot(2,1,2);
            plot(tt(1:length(Rate)), Rate);
            xlabel('Time [Seconds]',    'FontSize', FontSize);
            ylabel('L * di/dt [Volts]', 'FontSize', FontSize);
            %axis tight
            grid on
            
            linkaxes(h, 'x');
            addlabel(1, 0, 'Current measured with a Danfysik DCCT and Ztec scope');
            
        elseif any(strcmpi(Caen.Command, {'RMS','Sine'}))
            % Filter -> Mike's 25khz filter installed
            
            % Danfysik + scope noise floor
            %load Danfysik_PowerSupplyDisconnected_250kHz
            
            % Scope noise floor
            %load ZtecInp1_50ohmTerminated_250kHz
            
            Ztec = Caen.Scope;
            
            if isempty(FigNum)
                FigNum = 2;
            end
            
            figure(FigNum);
            clf reset
            plot(Ztec.t, Cal * Ztec.Inp1.Data(1,:));
            title(sprintf('Offset=%.3f mA  RMS=%.3f mA', mean(1000*Cal*Ztec.Inp1.Data(1,:)), std(1000*Cal*Ztec.Inp1.Data(1,:))));
            grid on
            
            FigNum = FigNum +1;
            figure(FigNum);
            clf reset
            
            % Noise floor
            [Paa_Scope, Paa_Int_Scope, f_Scope, SampleRate_Scope] = ztecnoisefloor;
            subplot(2,1,1);
            T1 = 1/SampleRate_Scope;
            loglog(f_Scope, 1e6*T1*Paa_Scope, 'k');
            hold on
            subplot(2,1,2);
            semilogx(f_Scope, 1e6*Paa_Int_Scope, 'k');
            hold on
            
            [Paa, Paa_Int, f] = plot_psd_local(Cal*Ztec.Inp1.Data, 1/Ztec.SampleRate, FigNum);
            RMS = 1000*sqrt(Paa_Int(end));
            
            i = find(f>1000);
            if ~isempty(i)
                RMS1k = 1000*sqrt(Paa_Int(i(1)));
            else
                RMS1k = [];
            end
            
            i = find(f>10000);
            if ~isempty(i)
                RMS10k = 1000*sqrt(Paa_Int(i(1)));
            else
                RMS10k = [];
            end
            
            i = find(f>100000);
            if ~isempty(i)
                RMS100k = 1000*sqrt(Paa_Int(i(1)));
            else
                RMS100k = [];
            end
            
            
            subplot(2,1,1);
            title(sprintf('Caen A3610: Power Spectral Density (%.3f Amps)',Caen.Amp), 'FontSize', FontSize);
            %%axis([3 25000 1e-6 1e-0]);
            subplot(2,1,2);
            legend('Danfysik Noise Floor', sprintf('Caen A3610 SN%d', Caen.SN), 'Location', 'NorthWest');
            %hold on
            
            title(sprintf('\\fontsize{12}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS = %.2f, %.2f, %.2f mAmps @1k, 10k, 100k Hz)', RMS1k, RMS10k, RMS100k), 'FontSize', FontSize);
            %axis([3 40000 0 RMS40k^2]);
            
        elseif strcmpi(Caen.Command, 'Drift')
            
            Ztec = Caen.Scope;
            
            if isempty(FigNum)
                FigNum = 4;
            end
            
            e1 = datenum(2013, 1, 21, 17,11,0);  % Jan 21 17:11
            e2 = Ztec.ts(end);
            Ztec.ts = Ztec.ts - (e2 - e1);
            
            figure(FigNum);
            clf reset
            h = subplot(2,1,1);
            plot(Ztec.ts, Cal * 1000 * Ztec.Inp1.Mean);
            title(sprintf('Caen A3610 SN %d', Caen.SN), 'FontSize', FontSize);
            ylabel('Mean [mAmps]', 'FontSize', FontSize);
            grid on
            axis tight
            datetick x
            
            h(2) = subplot(2,1,2);
            plot(Ztec.ts, Cal * [Ztec.Inp1.RMS1k Ztec.Inp1.RMS10k Ztec.Inp1.RMS100k]);
            ylabel('Std [mAmps]', 'FontSize', FontSize);
            grid on
            axis tight
            datetick x
            legend('0 - 1kHz RMS', '0 - 10kHz RMS', '0 - 100kHz RMS');
            
            addlabel(1, 0, 'Current measured with a Danfysik DCCT and Ztec scope');
            
            figure(FigNum+1);
            clf reset
            h(3) = subplot(2,1,1);
            plot(Ztec.ts, Cal * 1000 * Ztec.Inp2.Mean);
            title(sprintf('Ztec channel 2 with the 50 ohm load'), 'FontSize', FontSize);
            ylabel('Mean ["mAmps"]', 'FontSize', FontSize);
            grid on
            axis tight
            datetick x
            
            h(4) = subplot(2,1,2);
            %plot(Ztec.ts, Cal * 1000 * Ztec.Inp2.Std);
            plot(Ztec.ts, Cal * [Ztec.Inp2.RMS1k Ztec.Inp2.RMS10k Ztec.Inp2.RMS100k]);
            ylabel('Std ["mAmps"]', 'FontSize', FontSize);
            grid on
            axis tight
            datetick x
            legend('0 - 1kHz RMS', '0 - 10kHz RMS', '0 - 100kHz RMS');
            
            figure(FigNum+3);
            clf reset
            h(5) = subplot(2,1,1);
            plot(Ztec.ts, Caen.RegulatorTemp);
            title(sprintf('FET'), 'FontSize', FontSize);
            ylabel('[C]', 'FontSize', FontSize);
            grid on
            axis tight
            datetick x
            
            h(6) = subplot(2,1,2);
            plot(Ztec.ts, Caen.ShuntTemp);
            ylabel('[C]', 'FontSize', FontSize);
            grid on
            axis tight
            datetick x
            
            if length(Ztec.ts) == length(Caen.Current)
                figure(FigNum+4);
                clf reset
                h(7) = subplot(1,1,1);
                plot(Ztec.ts, Caen.Current);
                title(sprintf('Caen Current Monitor'), 'FontSize', FontSize);
                ylabel('[Amp]', 'FontSize', FontSize);
                xlabel('Time', 'FontSize', FontSize);
                grid on
                axis tight
                datetick x
            end
            
            linkaxes(h, 'x');
        end
        
    otherwise
        fprintf('   Unknown command:  %s', Caen.Command);
        
end



% % Force a trigger
% WaveCounter = getpvonline('ztec17:Inp1WaveCount')
% setpvonline('ztec17:OpForceCap',1);
% WaveCounter = getpvonline('ztec17:Inp1WaveCount')


function C = getcaen_local(Caen)

C = getcaen(Caen.Name);

FieldNames = fieldnames(Caen);
for i = 1:length(FieldNames)
    C.(FieldNames{i}) = Caen.(FieldNames{i});
end



function setpv_local_interlock(PV, Val)

a = getpv([PV, 'RBV'], 'char');

if strcmp(a, Val)
    % No change
    %fprintf('   No change to %s (presently %s)\n', PV, a);
else
    % Set PV
    fprintf('   Changing %s to %s (presently %s)\n', PV, Val, a);
    setpvonline(PV, Val);
end


function setpv_local(PV, Val)

if ischar(Val)
    
    a = getpv(PV, 'char');
    
    if strcmp(a, Val)
        % No change
        %fprintf('   No change to %s (presently %s)\n', PV, a);
    else
        % Set PV
        fprintf('   Changing %s to %s (presently %s)\n', PV, Val, a);
        setpvonline(PV, Val);
    end
    
else
    a = getpvonline(PV, 'double');
    
    if abs(a - Val) < 10*eps
        % No change
        %fprintf('   No change to %s (presently %f)\n', PV, a);
    else
        % Set PV
        fprintf('   Changing %s to %f (presently %f)\n', PV, Val, a);
        setpvonline(PV, Val);
    end
end





