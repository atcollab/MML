function [GR, ScopeTypeCell] = als_waveforms_setup(ScopeType)
%ALS_WAVEFORM_SETUP - Setup function for Ztec scopes and other waveforms
%

% Ztec Info
% 1. Max Sample Rates - 500 MHz for the ZT4210 series
%                       400 MHz for the ZT4440 series
% 2. ZT4441 has 14-bit ADC
%    8 range settings per impedance selection. 
%    1 MOhm -> 50 Vpp, 25 Vpp, 10 Vpp, 5 Vpp, 2 Vpp, 1 Vpp, 400 mVpp, 200 mVpp
%              These ranges are the full 14-bit resolution. 
%              Below that the instrument digitally scales the data to 
%              support lower ranges but that results in 1 less bit per 
%              range step down. 
%              100 mVpp has 13-bits
%               50m Vpp has 12-bits 
%               25 mVpp has 11-bits
%               12.5mVpp has 10-bits 
%     50 Ohm -> Lowest 14-bit range is 40 mVpp with magnified ranges at 
%               20mVpp and 10mVpp. 
%
% 3. AC coupling cutoff frequency greatly changes with input impedance
%

NewTimingSystemFlag = 0;
% BR RF, ICT, Wall current monitor, TWE still need to be timed up


ScopeTypeCell = {
    'LI10  Scope (MUX): Subharmonic Buncher'
    
    {'Wall Current or TWE', {
    'Wall Current Monitor'
    'Traveling Wave Electrode (TWE)'
    }}
            
    % li21scope:
    % 	li21_ch1:
    % 	  0 KLY1 INPUT DRIVE
    % 		KLY1 PH DET OUT
    % 		KLY1 PH Dztec9ET IN
    % 		KLY1 REVERSE PWR
    % 		KLY2 FORWARD PWR
    % 		KLY2 FAST PH
    % 		SBUN REVERSE PWR
    % 		AS1 REVERSE PWR
    % 		AS1 LOAD FWD PWR
    % 		AS2 FORWARD PWR
    % 	 10 TIM GUN GATE
    % 	li21_ch2:
    % 	  0	KLY1 FORWARD PWR
    % 		KLY1 FAST PH
    % 		KLY2 INPUT DRIVE
    % 		KLY2 PH DET OUT
    % 		KLY2 PH DET IN
    % 		KLY2 REVERSE PWR
    % 		SBUN FORWARD PWR
    % 		AS1 FORWARD PWR
    %           empty?????
    % 		AS2 LOAD FWD PWR
    % 	 10	TIM 3GHz RF TRGR
    % 	li21_trig:
    % 	 0	3GHz RF
    % 		GUN ON
    %                                                            MUX value
    {
    'LI 21 MUX: Linac', {
    'LI21  MUX: Linac Klystron Input Drive'                    % 0 2 - Klystron 1 & 2
    'LI21  MUX: Linac Klystron Phase Detect Out'               % 1 3 - Klystron 1 & 2
    'LI21  MUX: Linac Klystron Phase Detect In'                % 2 4 - Klystron 1 & 2
    'LI21  MUX: Linac Klystron Reverse Power'                  % 3 5 - Klystron 1 & 2
    'LI21  MUX: Linac Klystron Forward Power'                  % 4 0 - Klystron 1 & 2
    'LI21  MUX: Linac Klystron Fast Phase'                     % 5 1 - Klystron 1 & 2
    'LI21  MUX: Linac S-Band Buncher'                          % 6 6 - Forward and Reverse Power
    'LI21  MUX: Linac AS Load Forward Power "The Modulators"'  % 8 9 AS 1 & 2
    'LI21  MUX: Linac AS Forward Power'                        % 9 7 AS 1 & 2
    'LI21  MUX: Linac AS1 Forward & Reverse Power'             % 7 7
    'LI21  MUX: Linac Timing'                                  % 10 10 - RF Trigger and Gun Gate
    }}
    
    {'ICT', {
    'LTB ICT'
    'Booster ICT'
    'BTS ICTs'
    }}
    
    'B0404 MUX: DCCT & BPM'
    'Booster RF'
    
    'Booster Injection Kicker'
   %'Booster Bumps'
    'Booster Extraction Kicker'
    'Booster SEN/SEK'
    'SR Bumps'
    'SR SEN/SEK'
    %'BTS BPM'
    %'BR BPM'
    %'SR Cam-Kicker'
    %'SR Bunch Current Monitor'
    'Gauss Clock Triggers'       % 'Spare Scope: 4212'
   %'Caen Power Supply Tesing'   % 'Spare Scope: 4441'
   %'BR QD'
    'ztec16 (4212 - LN Test Scope)'
   %'ztec18 (4442 - Test Scope)'
   %'ztec19 (4611 - LN Test Scope)'
    };



if nargin < 1 || isempty(ScopeType)
    ScopeList = {
        'Wall Current Monitor'
        'Traveling Wave Electrode (TWE)'
        'LI10  Scope (MUX): Subharmonic Buncher'
        'LI21  MUX: Linac Klystron Input Drive'                    % 0 2 - Klystron 1 & 2r
        'LI21  MUX: Linac Klystron Phase Detect Out'               % 1 3 - Klystron 1 & 2
        'LI21  MUX: Linac Klystron Phase Detect In'                % 2 4 - Klystron 1 & 2
        'LI21  MUX: Linac Klystron Reverse Power'                  % 3 5 - Klystron 1 & 2
        'LI21  MUX: Linac Klystron Forward Power'                  % 4 0 - Klystron 1 & 2r
        'LI21  MUX: Linac Klystron Fast Phase'                     % 5 1 - Klystron 1 & 2
        'LI21  MUX: Linac S-Band Buncher'                          % 6 6 - Forward and Reverse Power
        'LI21  MUX: Linac AS Load Forward Power "The Modulators"'  % 8 9 AS 1 & 2 (Default)
        'LI21  MUX: Linac AS Forward Power'                        % 9 7 AS 1 & 2r
        'LI21  MUX: Linac AS1 Forward & Reverse Power'             % 7 7
        'LI21  MUX: Linac Timing'                                  % 10 10 - RF Trigger and Gun Gate
        'LTB ICT'
        'Booster ICT'
        'BTS ICTs'
        'B0404 MUX: DCCT & BPM'
        'Booster RF'
        'Booster Injection Kicker'
       %'Booster Bumps'
        'Booster Extraction Kicker'
        'Booster SEN/SEK'
        'SR Bumps'
        'SR SEN/SEK'
       %'BTS BPM'
       %'SR Cam-Kicker'
       %'BR BPM'
       %'SR Bunch Current Monitor'
        'Gauss Clock Triggers'       % 'Spare Scope: 4212'
       %'Caen Power Supply Tesing'   % 'Spare Scope: 4441'
       %'BR QD'
        'ztec16 (4212 - LN Test Scope)'
       %'ztec18 (4442 - Test Scope)'
       %'ztec19 (4611 - LN Test Scope)'
        };
    [ScopeTypeChoice, OKFlag] = listdlg('Name','Scopes','PromptString',{'Waveform choices?'}, 'SelectionMode','single', 'ListString', ScopeList, 'ListSize', [435 350], 'InitialValue', 1);
    if OKFlag ~= 1
        %ScopeTypeChoice = 1;  % Default
        GR = [];
        ScopeList = [];
        return;
    end
    ScopeType = ScopeList{ScopeTypeChoice};
end


% Note: 
% Old Pulse potentent, getpv('GTL_____TIMING_BC01')
% LI11<EVG1-SoftSeq:0>Enable-Cmd  LI11<EVG1-SoftSeq:0>Disable-Cmd LI11<EVG1-SoftSeq:0>Enable-RB

GR.Figure  = [];
GR.GraphIt = [];
GR.Device  = [];  % Ztec data structure added at the end
GR.Extra   = [];

% Just to make command line launches easier
i = findstr(ScopeType, '_');
ScopeType(i) = ' ';

% Change from defaults
switch ScopeType
    
        case  'ztec16 (4212 - LN Test Scope)'  %'Spare Scope: 4212'   131.243.93.226 (DHCP)
        % fprintf('  ztec16\n');
        
        Device = ztec_4channel_defaults;
        Device.Name = 'ztec16';
        
        SampleRate = 500e6;  % Hz

        % Peak detect?
        %Device.Setup.setAcqType = 'PDET';     % Peak detect will return the max or min of 10 samples / time
        %Device.Setup.setEnvView = 'MAX';      % Max/Min

        Device.Setup.setHorzPoints = 30000;   % 200k max
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        
        Device.Setup.setHorzOffset = 10e-6;
        Device.Setup.setTrigHoldoff = 0;

        
        Device.Setup.setInp1Range = 50;
        Device.Setup.setInp2Range = 500;
        Device.Setup.setInp2Offset = 100;
        Device.Setup.setInp3Range = 1;
        Device.Setup.setInp4Range = 5;
        
        %Device.Setup.setTrigLevExt = -.02;       % -.318 on EM scope
        % Trigger Slope: 'POS' SRF fanout or 'NEG'kicker trigger
        % 50 for SRS fanout, 1e6 trigger from kicker
        
        Device.Setup.setInp1Imped    = 1e6;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setInp3Imped    = 50;
        Device.Setup.setInp4Imped    = 50;
        Device.Setup.setTrigImpedExt = 1e6;
       
        Device.Setup.setTrigSource  = 'EXT';    % Trigger channel: INP1, INP2, or EXT
        Device.Setup.setTrigLevInp1 = 1;
        Device.Setup.setTrigLevInp2 = 1;
        Device.Setup.setTrigLevInp3 = .2;
        Device.Setup.setTrigLevInp4 = -.02;     % -.318 on EM scope
        Device.Setup.setTrigLevExt  = .4;
        Device.Setup.setTrigSlope   = 'POS';     % Trigger Slope: 'POS' or 'NEG'
        %Device.Setup.setTrigSlope   = 'NEG';     % Trigger Slope: 'POS' or 'NEG'        
        
        LineLabel = {
            {'Chan1', 'Chan2'}
            {'Chan3', 'Chan4'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp2ScaledWave']}
            {[Device.Name,':Inp3ScaledWave'],[Device.Name,':Inp4ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);

        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Data.Gain{1} = -1/23;
        GraphIt_GR{1}.Data.Gain{2} = -1/200;
        GraphIt_GR{2}.Data.Gain{1} = -1/.488;
        GraphIt_GR{2}.Data.Gain{2} =  1/1.42;
        
        %GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.XLim = [-10 200]*1e-6;
        %GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-1600 1600];
        %GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Injection Time Relative to the Waveform Trigger'};
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14} Linac RF Testing (ztec16)'};
        
        %GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [milliseconds]'};
        %GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [milliseconds]'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};

        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling, TimeScaling};

        %GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Chan 1 & 2 [Volts]'};
        %GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}Chan 3 & 4 [Volts]'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Kly 2 Cathode & Ion Pump'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}Fwd Pwr: Kly 2 & Linac 2'};
        
        
    case 'ztec10'
        % fprintf('   Booster Bumps (ztec10)\n');
        
        Device = ztec_4channel_defaults;
        Device.Name = 'ztec10';
        
        SampleRate = .15e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = -.466 + .014  + 12.5e-3;  % Trigger is -12.5e-3
        
        % Peak detect?
        %Device.Setup.setAcqType = 'PDET';     % Peak detect will return the max or min of 10 samples / time
        %Device.Setup.setEnvView = 'MAX';      % Max/Min

        Device.Setup.setInp1Range = 10;
        Device.Setup.setInp2Range = 10;
        Device.Setup.setInp3Range = 10;
        Device.Setup.setInp4Range = 10;
        
        Device.Setup.setTrigSlope   = 'POS';     % Trigger Slope: 'POS' or 'NEG'

        if 1
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = 1;
            Device.Setup.setTrigLevInp4 = .25;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = 1;
        end
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setInp3Imped    = 50;
        Device.Setup.setInp4Imped    = 50;
        Device.Setup.setTrigImpedExt = 50;
        
        Device.Setup.setTrigHoldoff = .75;
                
        LineLabel = {
            {'BR Bumps 1', 'BR Bumps 2'}
            {'Chan3', 'Chan4'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp2ScaledWave']}
            {[Device.Name,':Inp3ScaledWave'],[Device.Name,':Inp4ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);

        TimeScaling = 1e3;
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-200 250];
        GraphIt_GR{1}.Axes.YLim = [-175 175];
        
        
       % GraphIt_GR{1}.Data.Gain = {100, 100};

        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14} booster bumps and triggers'};
        
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [milliseconds]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [milliseconds]'};

        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling, TimeScaling};

        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Chan 1 & 2 [Volts]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}Chan 3 & 4 [Volts]'};

        
    case  'Gauss Clock Triggers'  %'Spare Scope: 4212'   131.243.93.227 (DHCP)
        % fprintf('  Gauss Clock Triggers\n');
        
        Device = ztec_4channel_defaults;
        Device.Name = 'ztec16';
        
        SampleRate = 5e6;  % Hz  was 20 for injection, 10 for Extraction
        %SampleRate = .01e6;  % Hz

        % Peak detect?
        Device.Setup.setAcqType = 'PDET';     % Peak detect will return the max or min of 10 samples / time
        Device.Setup.setEnvView = 'MAX';      % Max/Min

        % Waveform trigger
        %     0.0   sec -> 1.5v to 0v
        %  (-)0.482 sec -> 0v to 1.5v
        %  (-).0144 sec -> Injection  trigger
        %  (-)      sec -> Extraction trigger

        Device.Setup.setHorzPoints = 100000;   % .417 to .421 seconds
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        
        Device.Setup.setTrigHoldoff = 0;  %.75;  zero is now fine

        % For injection
        %Offset = .0144 + (getpv('BR1_____TIMING_AM00') - 4835) * 9 / 6.4;  % scaling????
       %Offset = 14.4e-3;  % with DG654
        %Offset = 14.4e-3 + .46780;  % Extraction
        %Offset = -1 * (Offset - Device.Setup.setHorzTime/2);
        %Offset = -.4775;  %Bump -.4734   EXT -.4785 20kpoint
        %Offset = -1*(.4775-.009);  %Bump -.4734   EXT -.4785 200kpoints
        Offset = -1*(.4775-.009)-.0035;  % 100kpoints
        Device.Setup.setHorzOffset = Offset;

        %Device.Setup.setHorzOffset = -.0143;  %*Device.Setup.setHorzTime; 

       %Device.Setup.setHorzOffset = Offset - .4;
       %Device.Setup.setHorzOffset = -.3;
       
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setInp3Imped    = 50;
        Device.Setup.setInp4Imped    = 1e6;
        Device.Setup.setTrigImpedExt = 1e6;  % ???
       
        Device.Setup.setTrigSource  = 'EXT';    % Trigger channel: INP1, INP2, or EXT
        Device.Setup.setTrigLevInp2 = .5;
        Device.Setup.setTrigLevExt  = 2.0;
        Device.Setup.setTrigSlope   = 'NEG';     % Trigger Slope: 'POS' or 'NEG'

        %Device.Setup.setOutExtEnable = 1;
        %Device.Setup.setOutExtSource = 'CLOC';
        %Device.Setup.setOutExtPulsePer = .001;
        
        LineLabel = {
            {'Chan1', 'Chan3'}
            {'Chan2', 'Chan4'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp2ScaledWave']}
            {[Device.Name,':Inp3ScaledWave'],[Device.Name,':Inp4ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);

        TimeScaling = 1e3;
        
        %GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.XLim = [-200 500];
        %GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-1600 1600];
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Injection Time Relative to the Waveform Trigger'};
      %  GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14} Chan 1 & 2'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [milliseconds]'};
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
       % GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14} Waveform Trigger'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [milliseconds]'};
        GraphIt_GR{2}.Data.XGain = {TimeScaling, TimeScaling};

        
        
        
    case  'Caen Power Supply Tesing'  %'Spare Scope: 4441'  131.243.93.244 131.243.89.208
        % fprintf('   Caen tesing\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec17';
        
        SampleRate = 400e6;  %20e3;  % Hz  (20kHz appears to be the lowest sample rate)
        
        Device.Setup.setHorzPoints = 100000;
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = 0; %0*Device.Setup.setHorzTime;

        % Kp = .118   -> s/n 32 ,check if correct!!!!!
        % Ki = 2.55e-5 
        % .1 time constant
        % Ramprate = 2A
        
        %                              Note: From Input 2 open?!?
        %                                 5.0 -> +/- 10.0 mV peak-to-peak noise
        Device.Setup.setInp1Range = 10 %.05;  % 1.0 -> +/-  2.0 mV peak-to-peak noise
        Device.Setup.setInp2Range = 5;  % 0.1 -> +/-  0.8 mV peak-to-peak noise 

        Device.Setup.setInp1Offset = 0;    % Input offset [volts]
        Device.Setup.setInp2Offset = 0;    % Input offset [volts]
        
        Device.Setup.setInp1Couple = 1;  % 1 -> DC Coupled, 0 AC Coupled 
        Device.Setup.setInp2Couple = 1;  % 1 -> DC Coupled, 0 AC Coupled 
         
        Device.Setup.setInp1Filter = 1;    % Enable/disable 20 MHz input filter
        Device.Setup.setInp2Filter = 1;    % Enable/disable 20 MHz input filter

        % Disable channel for interleaved samples (note: 1 & 3 or 2 & 4 can be doubled)
        Device.Setup.setInp1Enable = 1;
        Device.Setup.setInp2Enable = 1;

        Device.Setup.setInp1Imped    = 1e6;  % Danfysik input must be 1e6
        Device.Setup.setInp2Imped    = 1e6;
        Device.Setup.setTrigImpedExt = 50;
       
        Device.Setup.setTrigSource  = 'MAN';    % Trigger channel: INP1, INP2, EXT, or MAN
       %Device.Setup.setTrigSource  = 'INP1';    % Trigger channel: INP1, INP2, EXT, or MAN
        Device.Setup.setTrigLevInp1 = .67;
        Device.Setup.setTrigLevInp2 = 1;
        Device.Setup.setTrigLevExt  = 1;
        Device.Setup.setTrigSlope   = 'POS';     % Trigger Slope: 'POS' or 'NEG'

        Device.Setup.setOutExtEnable   = 1;
        Device.Setup.setOutExtSource   = 'CLOC';
        Device.Setup.setOutExtPulsePer = 1e-5;   % Min 2.6667e-08?
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, {{'Channel 1','tmp'},{'tmp','Channel 2'}}, {{[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp2ScaledWave']},{[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp2ScaledWave']}});
        
        GraphIt_GR{1}.Data.Gain = {1,4};  % 4 A/Volt / 4 turns?
        GraphIt_GR{2}.Data.Gain = {1,4};

        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Chan 1 [Amps]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}Chan 2 [Volts]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [Seconds]'};
        
    case 'LTB ICT'
        % fprintf('   LTB ICT');
        
        % 4441 - 14 bits
        % INP1: BTS ICT1
        % INP2: BTS ICT2
        % EXT:  BPM Trigger
        
        Device = ztec_2channel_defaults;
                
        Device.Name = 'ztec9';
        SampleRate = 2*400e6;  % 2*400 MHz is max for the ZT4440 series
        
        Device.Setup.setHorzPoints = 1000;
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = 500e-9;
        
        Device.Setup.setInp1Range = 5;
        Device.Setup.setInp2Range = 2;
        
        Device.Setup.setInp1Offset = -.75;    % Input offset [volts]
        %Device.Setup.setInp2Offset = 2;      % Input offset [volts]
        
        % Disable channel for interleaved samples (note: 1 & 3 or 2 & 4 can be doubled)
        Device.Setup.setInp1Enable = 1;
        Device.Setup.setInp2Enable = 0;
        
        Device.Setup.setTrigSource = 'INP1';    % Trigger channel: INP1, INP2, or EXT
        Device.Setup.setTrigLevInp1 = -.1;
        Device.Setup.setTrigLevInp2 = -.25;
        Device.Setup.setTrigLevExt  = 1;
        Device.Setup.setTrigSlope   = 'NEG';     % Trigger Slope: 'POS' or 'NEG'
        
        Device.Setup.setInp1Imped    = 1e6;
        Device.Setup.setInp2Imped    = 1e6;
        Device.Setup.setTrigImpedExt = 1e6;   % User timing chassis liked 50 if on Inp1, not sure why 1e6 on EXT
        
        Device.Setup.setTrigHoldoff = 0;  %.75;  zero is now fine
        
        LineLabel = {
            {'ICT', 'Ingration Area'}
           %{'Chan1', 'Chan2'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp1ScaledWave']}
           % {[Device.Name,':Inp2ScaledWave'],[Device.Name,':Inp4ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e9;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = [-200 500];
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-1600 1600];
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}LTB ICT'};
        GraphIt_GR{1}.Data.Gain = {1, 1};
        %GraphIt_GR{1}.Data.Gain{1} = 1e9/1.25;  % % ICT Calibration 1.25 V*s/C is hardcoded in als_waveform
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}[Volts]'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
    case 'BTS ICTs'
        % fprintf('   BTS ICTs');
        
        % 4441 - 14 bits (broken)
        % 4442 - 14 bits
        % INP1: BTS ICT1
        % INP3: BTS ICT2
        % EXT:  BPM Trigger
        
        % 2017-05-23 S/N 22424 broke, replaced with S/N 23845
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec13';      
        
        SampleRate = 2*400e6;  % 2*400 MHz is max for the ZT4440 series
      
        Device.Setup.setHorzPoints = 1000;   % 10k Max
        Device.Setup.setHorzTime = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = 500e-9;
        
        Device.Setup.setInp1Range = 4;
        Device.Setup.setInp2Range = 4;
        Device.Setup.setInp3Range = 10;
        Device.Setup.setInp4Range = 10;
        
        Device.Setup.setInp1Offset = -.75;      % Input offset [volts]
        Device.Setup.setInp2Offset = -.75;      % Input offset [volts]
        
        Device.Setup.setInp1Filter = 0;    % Enable/disable 20 MHz input filter
        Device.Setup.setInp3Filter = 0;    % Enable/disable 20 MHz input filter


        % Disable channel for interleaved samples
        Device.Setup.setInp1Enable = 1;
        Device.Setup.setInp2Enable = 0;
        Device.Setup.setInp3Enable = 1;
        Device.Setup.setInp4Enable = 0;
        
        Device.Setup.setTrigSource = 'INP1';    % Trigger channel: INP1, INP2, or EXT
        Device.Setup.setTrigLevInp1 = -.03;      % -.1 and -.15 ok
        Device.Setup.setTrigLevInp2 = -.15;
        Device.Setup.setTrigLevInp3 = -.15;
        Device.Setup.setTrigLevInp4 = .5;
        Device.Setup.setTrigLevExt = 1;
        Device.Setup.setTrigSlope  = 'NEG';     % Trigger Slope: 'POS' or 'NEG'
        
        Device.Setup.setInp1Imped    = 1e6;
        Device.Setup.setInp2Imped    = 1e6;
        Device.Setup.setInp3Imped    = 1e6;
        Device.Setup.setInp4Imped    = 50;
        Device.Setup.setTrigImpedExt = 1e6;   % Presently connected to the BPM trigger
                                              % User timing chassis liked 50 if on Inp1, not sure why 1e6 on EXT
        
        % BPM Gate trigger setup
        % * Every 1.4 seconds
        % * 0 to 2.5 Volts
        %Device.Setup.setTrigSource = 'INP4';    % Trigger channel: INP1, INP2, or EXT
        %Device.Setup.setTrigSlope  = 'POS';     % Trigger Slope: 'POS' or 'NEG'
        %Device.Setup.setTrigImpedExt = 1e6;   % User timing chassis liked 50 if on Inp1, not sure why 1e6 on EXT

        Device.Setup.setTrigHoldoff = 0;  %.75;  zero is now fine
        
        LineLabel = {
            {'BTS1', 'Ingration Area'}
            {'BTS2', 'Ingration Area'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp1ScaledWave']}
            {[Device.Name,':Inp3ScaledWave'],[Device.Name,':Inp3ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        TimeScaling = 1e9;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = [-200 500];
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-1600 1600];
        
        GraphIt_GR{2}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.XLim = [-200 500];
        GraphIt_GR{2}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{2}.Axes.YLim = [-2000 3000];
        
        GraphIt_GR{1}.Data.Gain = {1, 1};
        GraphIt_GR{2}.Data.Gain = {1, 1};
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}BTS ICTs'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}[Volts]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}[Volts]'};
                
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling, TimeScaling};
        
        
    case 'BR QD'
        % fprintf('   BR QD');
        
        % 4441 - 14 bits (broken)
        % 4442 - 14 bits
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec13';
        
        SampleRate = 5e3;  % 20k min and 2*400 MHz max for the ZT4440 series
      
        Device.Setup.setHorzPoints = 26000;   % 40k Max
        Device.Setup.setHorzTime = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = 0;  %500e-9;
        
        Device.Setup.setInp1Range = 20;
        Device.Setup.setInp2Range = 20;
        Device.Setup.setInp3Range = 20;
        Device.Setup.setInp4Range = 20;
        
        Device.Setup.setInp1Offset = 0;      % Input offset [volts]
        Device.Setup.setInp2Offset = 0;      % Input offset [volts]
        Device.Setup.setInp3Offset = 0;      % Input offset [volts]
        Device.Setup.setInp4Offset = 0;      % Input offset [volts]
        
        Device.Setup.setInp1Filter = 1;    % Enable/disable 20 MHz input filter
        Device.Setup.setInp2Filter = 1;    % Enable/disable 20 MHz input filter
        Device.Setup.setInp3Filter = 1;    % Enable/disable 20 MHz input filter
        Device.Setup.setInp4Filter = 1;    % Enable/disable 20 MHz input filter

        % Disable channel for interleaved samples
        Device.Setup.setInp1Enable = 1;
        Device.Setup.setInp2Enable = 1;
        Device.Setup.setInp3Enable = 1;
        Device.Setup.setInp4Enable = 1;
        
        Device.Setup.setTrigSource = 'EXT';    % Trigger channel: INP1, INP2, or EXT
        Device.Setup.setTrigLevInp1 = -.03;    % -.1 and -.15 ok
        Device.Setup.setTrigLevInp2 = -.15;
        Device.Setup.setTrigLevInp3 = -.15;
        Device.Setup.setTrigLevInp4 = .5;
        Device.Setup.setTrigLevExt = 1;
        Device.Setup.setTrigSlope  = 'POS';    % Trigger Slope: 'POS' or 'NEG'
        
        Device.Setup.setInp1Imped    = 1e6;
        Device.Setup.setInp2Imped    = 1e6;
        Device.Setup.setInp3Imped    = 1e6;
        Device.Setup.setInp4Imped    = 1e6;
        Device.Setup.setTrigImpedExt = 50;     % Presently connected to the BPM trigger
                                               % User timing chassis liked 50 if on Inp1, not sure why 1e6 on EXT
      
        Device.Setup.setTrigHoldoff = 0;
                                              
        LineLabel = {
            {'Chan1', 'Chan3'}
            {'Chan2', 'Chan4'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp3ScaledWave']}
            {[Device.Name,':Inp2ScaledWave'],[Device.Name,':Inp4ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        %TimeScaling = 1e9;
        %TimeScaling = 1e6;
        TimeScaling = 1;
                
        GraphIt_GR{1}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-1600 1600];
        
        GraphIt_GR{2}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{2}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{2}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{2}.Axes.YLim = [-2000 3000];
        
        GraphIt_GR{1}.Data.Gain = {1, 3};
        GraphIt_GR{2}.Data.Gain = {1, -1};
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}4442'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}[Volts]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}[Volts]'};
        
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [seconds]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [seconds]'};        
        %GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        %GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        %GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        %GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling, TimeScaling};
        
        
    case 'Booster ICT Testing'
        % fprintf('   Setup for the Booster ICT (test mode)\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec2';
        
        Device.Setup.setAcqType = 'PDET';        % Peak detect will return the max or min of 10 samples / time
        Device.Setup.setEnvView = 'MIN';         % Max/Min

        Device.Setup.setHorzPoints = 25000;
        Device.Setup.setHorzTime   = .001;
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setTrigImpedExt = 50;   % 50 ohms (or it will bounce)
        
        if 1
            % Trigger on ICT
            Device.Setup.setTrigSource  = 'INP1';    % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = -.1;    % -.025;
            Device.Setup.setHorzOffset = .02;
            Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'  ????
           %Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
        else
            % External trigger
            % 1. Presently connected to the waveform trigger (same as the mini-IOCs and power supply controllers).
            % 2. The BPM gate trigger (like the Libera) is about 15 ms delayed from the waveform trigger.
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = 1;

            %Device.Setup.setTrigLevInp2 = .5;
            %Device.Setup.setTrigSource = 'INP2';    % Trigger channel: INP1, INP2, or EXT
            %Device.Setup.setTrigLevInp1 = 1;
            
            Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
            
            Device.Setup.setHorzOffset = 0;
        end
        
        Device.Setup.setInp1Range = 2;          
        Device.Setup.setInp1Filter = 1;          % Enable/disable 20 MHz input filter        
        Device.Setup.setTrigHoldoff = .5;       
        Device.Special.DownSampleNumber = 20;

        LineLabel = {
            {'Booster ICT [Volts]'}
            };
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e3;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-.01 .5];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Booster ICT'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Booster ICT [Volts]'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [milliseconds]'};
        
        
        if 1
            
            %setpv('ztec2:setTrigLevInp1',-.1);getpv('ztec2:getTrigLevInp1')
            %-0.1000 ok, -.11 not
            
            % First turns setup
            Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setTrigLevInp1 = -.05;
            
            SampleRate = 50e6;
            Device.Setup.setHorzTime = Device.Setup.setHorzPoints/SampleRate;

            Device.Setup.setHorzTime   = 1e-9;
            Device.Setup.setHorzOffset = 500e-9; %-1*Device.Setup.setHorzTime;
            
            %Device.Setup.setInp1Imped    = 50;
            
            %Device.Setup.setAcqType = 'PDET';        % Peak detect will return the max or min of 10 samples / time
            Device.Setup.setAcqType = 'NORM';        % Peak detect will return the max or min of 10 samples / time
            Device.Special.DownSampleNumber = 1;
            Device.Setup.setInp1Filter = 0;          % Enable/disable 20 MHz input filter
            
            GraphIt_GR{1}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
            GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
            GraphIt_GR{1}.Axes = rmfield(GraphIt_GR{1}.Axes, 'XLim');
            GraphIt_GR{1}.Axes = rmfield(GraphIt_GR{1}.Axes, 'YLim');
            GraphIt_GR{1}.Data.Gain{1} = 1;

            TimeScaling = 1e9;
            GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        end

        GraphIt_GR{1}.Data.Gain{1} = 1;
        GraphIt_GR{1}.Data.XGain = {TimeScaling};


    case 'Booster ICT'
        % fprintf('   Setup for the Booster ICT\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec2';
        
        Device.Setup.setAcqType = 'PDET';        % Peak detect will return the max or min of 10 samples / time
        
        Device.Setup.setHorzPoints = 25000;
        Device.Setup.setHorzTime   = .5;
        
        Device.Setup.setInp1Imped    = 1e6;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setTrigImpedExt = 50;   % 50 ohms (or it will bounce)
        
        if 1
            % Trigger on ICT
            Device.Setup.setTrigSource  = 'INP1';    % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = -.1;    % -.025;
            Device.Setup.setHorzOffset = .02;
            Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'  ????
           %Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
        else
            % External trigger
            % 1. Presently connected to the waveform trigger (same as the mini-IOCs and power supply controllers).
            % 2. The BPM gate trigger (like the Libera) is about 15 ms delayed from the waveform trigger.
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = 1;
            Device.Setup.setTrigLevInp2 = .5;
            
            %Device.Setup.setTrigSource = 'INP2';    % Trigger channel: INP1, INP2, or EXT
            %Device.Setup.setTrigLevInp1 = 1;
            
            Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
            
            Device.Setup.setHorzOffset = 0;
        end
        
        Device.Setup.setInp1Range = 2;           % Was 1     
        Device.Setup.setInp1Filter = 1;          % Enable/disable 20 MHz input filter        
        Device.Setup.setTrigHoldoff = .1;       
        Device.Special.DownSampleNumber = 20;

        LineLabel = {
            {'Booster ICT [Volts]'}
            };
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e3;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-.01 .7];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Booster ICT'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Booster ICT [Volts]'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [milliseconds]'};
        
        GraphIt_GR{1}.Data.Gain{1} = -1;
        GraphIt_GR{1}.Data.XGain = {TimeScaling};
        
        if 0
            % First turns setup
            Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setTrigLevInp1 = -.7;
            
            %Device.Setup.setInp1Imped    = 50;
            Device.Setup.setHorzTime   = .01;
            Device.Setup.setHorzOffset = .001;
            %Device.Setup.setAcqType = 'PDET';        % Peak detect will return the max or min of 10 samples / time
            Device.Setup.setAcqType = 'NORM';        % Peak detect will return the max or min of 10 samples / time
            Device.Special.DownSampleNumber = 1;
            Device.Setup.setInp1Filter = 0;          % Enable/disable 20 MHz input filter
            
            GraphIt_GR{1}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
            GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
            GraphIt_GR{1}.Axes = rmfield(GraphIt_GR{1}.Axes, 'XLim');
            GraphIt_GR{1}.Axes = rmfield(GraphIt_GR{1}.Axes, 'YLim');
            GraphIt_GR{1}.Data.Gain{1} = 1;
        end


    case 'BR BPM'
        Device.Type = 'Libera';
        Device.Name = 'LIBERA_0A7E';     % 0-d0-50-31-a-7e.dhcp.lbl.gov
        
        LineLabel = {
            {'x'}
            {'y'}
            {'Sum'}
            };
        
        ChannelNames = {
            {['DD_X_MONITOR']}
            {['DD_Y_MONITOR']}
            {['DD_SUM_MONITOR']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(3, LineLabel, ChannelNames);
        
        TimeScaling = 1e9;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-2 2];
        
        GraphIt_GR{2}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{2}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{2}.Axes.YLim = [-2 2];
        
        GraphIt_GR{3}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        GraphIt_GR{3}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        
        %GraphIt_GR{1}.Data.Gain = {200, 1000};
        %GraphIt_GR{2}.Data.Gain = {500, 500};
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Booster Libera'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}[mm]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}[mm]'};
        GraphIt_GR{3}.Axes.YLabel.String = {'\fontsize{14}'};
        
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Turns'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Turns'};
        GraphIt_GR{3}.Axes.XLabel.String = {'\fontsize{14}Turns'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling};
        GraphIt_GR{3}.Data.XGain = {TimeScaling};
        
        
    case 'ztec18 (4442 - Test Scope)'
        % fprintf('   4442 - Test Scope');
        
        Device = ztec_4channel_defaults;
        Device.Name = 'ztec18';

        SampleRate = 2*400e6;  % 2*400 MHz is max for the ZT4440 series
        Device.Setup.setHorzPoints = 200000;

        % Timing system testing
        %SampleRate = 50e3;  % 2*400 MHz is max for the ZT4440 series
        %Device.Setup.setHorzPoints = 200000;

        % Bergoz testing
        %SampleRate = 20e3;  % Min for the ZT4440 series?
        %Device.Setup.setHorzPoints = 50000;

        Device.Setup.setInp1Filter = 0;          % Enable/disable 20 MHz input filter
        Device.Setup.setInp2Filter = 0;          % Enable/disable 20 MHz input filter
        Device.Setup.setInp3Filter = 0;          % Enable/disable 20 MHz input filter
        Device.Setup.setInp4Filter = 0;          % Enable/disable 20 MHz input filter

        
        Device.Setup.setHorzTime = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .05*Device.Setup.setHorzTime;
  
                
        % Disable channel for interleaved samples
        Device.Setup.setInp1Enable = 1;
        Device.Setup.setInp2Enable = 0;  % was 0 for BTS BPM
        Device.Setup.setInp3Enable = 1;
        Device.Setup.setInp4Enable = 0;  % was 0 for BTS BPM
        
        if 1
            if 1
                Device.Setup.setInp1Range = 5;
                Device.Setup.setInp2Range = 2;
                Device.Setup.setInp3Range = 5;
                Device.Setup.setInp4Range = 2;
                
                Device.Setup.setInp1Offset = 0;      % Input offset [volts]
                Device.Setup.setInp3Offset = 0;      % Input offset [volts]
                
                % BTS BPM
                Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
                Device.Setup.setTrigLevInp1 = 1;
                Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
            else
                % Timing system testing setup
                Device.Setup.setInp1Range = 10;
                Device.Setup.setInp2Range = 10;
                Device.Setup.setInp3Range = 10;
                Device.Setup.setInp4Range = 10;
                
                Device.Setup.setInp1Offset = 0;      % Input offset [volts]
                Device.Setup.setInp3Offset = 0;      % Input offset [volts]
                
                Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
                Device.Setup.setTrigLevExt = 1;
                Device.Setup.setTrigLevInp1 = .5;        % .002 for BTS BPM, .05 with beam, .5 with kicker on
                Device.Setup.setTrigLevInp2 = .5;
                Device.Setup.setTrigLevInp3 =-.5;
                Device.Setup.setTrigLevInp4 = .5;
                Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
                
                Device.Setup.setAcqType = 'PDET';        % Peak detect will return the max or min of 10 samples / time
                %Device.Setup.setAcqType = 'NORM';       % Peak detect will return the max or min of 10 samples / time
                Device.Setup.setInp1Filter = 1;          % Enable/disable 20 MHz input filter
                Device.Setup.setInp2Filter = 1;          % Enable/disable 20 MHz input filter
                Device.Setup.setInp3Filter = 1;          % Enable/disable 20 MHz input filter
                Device.Setup.setInp4Filter = 1;          % Enable/disable 20 MHz input filter

                % Fixed at 3.1 volts???
                %Device.Setup.setTrigSource = 'INP1';
                %Device.Setup.setTrigLevInp1 = .5;
                Device.Setup.setOutExtEnable = 0;
                %Device.Setup.setOutExtSource = 'CLOC';
                %Device.Setup.setOutExtPulsePer = .000005;
            end
        else
            Device.Setup.setInp1Range = 2;
            Device.Setup.setInp2Range = 2;
            Device.Setup.setInp3Range = 2;
            Device.Setup.setInp4Range = 2;
            
            Device.Setup.setInp1Offset = 0;      % Input offset [volts]
            Device.Setup.setInp2Offset = 0;      % Input offset [volts]
            Device.Setup.setInp3Offset = 0;      % Input offset [volts]
            Device.Setup.setInp4Offset = 0;      % Input offset [volts]
            
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .04;
            %Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
        end
        
        Device.Setup.setInp1Imped    = 1e6;
        Device.Setup.setInp2Imped    = 1e6;
        Device.Setup.setInp3Imped    = 1e6;
        Device.Setup.setInp4Imped    = 1e6;
        Device.Setup.setTrigImpedExt = 1e6;   % User timing chassis liked 50 if on Inp1, not sure why 1e6 on EXT
        
        Device.Setup.setTrigHoldoff = .1;  %.75;  zero is now fine
        
        LineLabel = {
            {'Chan1', 'Chan3'}
            {'Chan2', 'Chan4'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp3ScaledWave']}
            {[Device.Name,':Inp2ScaledWave'],[Device.Name,':Inp4ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        %   TimeScaling = 1e9;
        TimeScaling = 1;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-1600 1600];
        
        GraphIt_GR{2}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{2}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{2}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{2}.Axes.YLim = [-2000 3000];
        
        GraphIt_GR{1}.Data.Gain = {1, 1};
        GraphIt_GR{2}.Data.Gain = {1, 1};
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}4442'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}[Volts]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}[Volts]'};
        
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [Seconds]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [Seconds]'};

        %GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        %GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        %GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        %GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling, TimeScaling};
        
        
    case 'BTS BPM'
        % fprintf('   4442 - BTS BPM');
        
        Device = ztec_4channel_defaults;
        Device.Name = 'ztec???';
        
        SampleRate = 400e6;  % 400 MHz is max for the ZT4440 series
        
        Device.Setup.setHorzPoints = 10000;
        Device.Setup.setHorzTime = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = .2;  % Note: .08, .2 are allowed, not .1
        Device.Setup.setInp2Range = .2;
        Device.Setup.setInp3Range = .2;
        Device.Setup.setInp4Range = .2;
        
        %Device.Setup.setInp1Offset = 0;      % Input offset [volts]
        %Device.Setup.setInp2Offset = 0;      % Input offset [volts]
        
        % Disable channel for interleaved samples
        Device.Setup.setInp1Enable = 1;
        Device.Setup.setInp2Enable = 1;
        Device.Setup.setInp3Enable = 1;
        Device.Setup.setInp4Enable = 1;
        
        % BTS BPM
        Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
        Device.Setup.setTrigLevInp1 = .007;
        Device.Setup.setTrigLevInp2 = .01;
        Device.Setup.setTrigLevInp3 = .01;
        Device.Setup.setTrigLevInp4 = .01;
        Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
        
        %Device.Setup.setTrigLevExt = 1;
        %Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
        
        % Fixed at 3.1 volts???
        %Device.Setup.setTrigSource = 'INP1';
        %Device.Setup.setTrigLevInp1 = .5;
        Device.Setup.setOutExtEnable = 0;
        %Device.Setup.setOutExtSource = 'CLOC';
        %Device.Setup.setOutExtPulsePer = .000005;
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setInp3Imped    = 50;
        Device.Setup.setInp4Imped    = 50;
        Device.Setup.setTrigImpedExt = 50;   % User timing chassis liked 50 if on Inp1, not sure why 1e6 on EXT
        
        Device.Setup.setTrigHoldoff = .2;  %.75;  zero is now fine
        
        LineLabel = {
            {'Chan1', 'Chan3'}
            {'Chan2', 'Chan4'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp3ScaledWave']}
            {[Device.Name,':Inp2ScaledWave'],[Device.Name,':Inp4ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        TimeScaling = 1e9;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-1600 1600];
        
        GraphIt_GR{2}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{2}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{2}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{2}.Axes.YLim = [-2000 3000];
        
        GraphIt_GR{1}.Data.Gain = {1, 1};
        GraphIt_GR{2}.Data.Gain = {1, 1};
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}4442'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}[Volts]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}[Volts]'};
        
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling, TimeScaling};
        
        
    case 'SR Cam-Kicker'
        
        % fprintf('   Setup for the SR Cam-Kicker\n');
               
        Device = ztec_2channel_defaults;
        
        Device.Name                  = 'ztec15';  % 131.243.93.185
        SampleRate                   = 500e6;  % ? max for the ZT4200 series
        Device.Setup.setHorzPoints   = 1000;
        Device.Setup.setHorzTime     = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset   = .1*Device.Setup.setHorzTime;
        
        Device.Setup.setTrigSource   = 'INP1';  % Trigger channel: INP1, INP2, or EXT
        Device.Setup.setTrigLevExt   = .5;
        Device.Setup.setTrigLevInp1  = .25;
        Device.Setup.setTrigLevInp2  = -.25;
        Device.Setup.setTrigSlope    = 'POS';      % Trigger Slope: 'POS' or 'NEG'
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setTrigImpedExt = 50;
        
        Device.Setup.setInp1Range    = 2;
        Device.Setup.setInp2Range    = 5;
        
        Device.Setup.setInp1Offset   = .5;      % Input offset [volts]
        Device.Setup.setInp2Offset   = -1.5;      % Input offset [volts]
        
        %Device.Setup.setInp2Enable  = 0;      % Disable channel 2 for interleaved samples
        
        Device.Setup.setTrigHoldoff  = 1;
        
        LineLabel = {
            {'Upper'}
            {'Lower'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave']}
            {[Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        TimeScaling = 1e9;

        GraphIt_GR{1}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'

        %GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.XLim = [475 650];
        %GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-.1 1];
        
        %GraphIt_GR{2}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{2}.Axes.XLim = GraphIt_GR{1}.Axes.XLim;
        %GraphIt_GR{2}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{2}.Axes.YLim = [-1 .1];
                
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Cam Kicker'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14} Upper [Volts]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14} Lower [Volts]'};
        
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling};
        
        
    case 'SR Bunch Current Monitor'
        % fprintf('   Setup for the SR Bunch Current Monitor\n');
        
        % INP1: Stripline in sector 2
        % EXT: SROC
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec15';
        
        Device.Setup.setHorzPoints = 100000;
        Device.Setup.setHorzTime = Device.Setup.setHorzPoints/2.5e9;  % 2.5 for the test scope,  N/4e9 -> 4GS/s
        %Device.Setup.setHorzOffset = 439e-9;   % Should be can input variable
        Device.Setup.setHorzOffset = 416.7e-9;  % Should be can input variable
        
        Device.Setup.setTrigSource = 'EXT';  % Trigger channel: INP1, INP2, or EXT
        Device.Setup.setTrigLevInp2 = .5;
        Device.Setup.setTrigLevExt  = 1;
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setTrigImpedExt = 50;
        
        Device.Setup.setInp1Range = 5;  %.2;
        Device.Setup.setInp2Range = 2;
        
        %Device.Setup.OpInitiate = 0;        % Single shot
        Device.Setup.setInp2Enable = 0;      % Disable channel 2 for interleaved samples
        
        Device.Setup.setTrigHoldoff = 2;  %1.25;
        
        %Device.Setup.setAcqType = 'ETIM';
        %tec.Setup.setAcqCount = 64;       % Power of 2
        %Device.Setup.setTrigHoldoff = 0;
        %Device.Setup.setInp2Enable = 0;      % Disable channel 2 for interleaved samples
        
        LineLabel = {
            {'Sum Signal','Filtered Sum Signal','Marker Max','Marker Min'}
            {'Bunch current from positive slope','Bunch current from negative slope'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'],'','',''}
            {'',''}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}BPM Sum Signal [Volts]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}Bunch Current Estimate [mA]'};
        
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [nsec]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Bunch Number'};
        
        GraphIt_GR{1}.Line.Marker{3} = 'x';
        GraphIt_GR{1}.Line.Marker{4} = 'x';
        GraphIt_GR{1}.Line.MarkerSize{3} = 12;
        GraphIt_GR{1}.Line.MarkerSize{4} = 12;
        
        %GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-.1 .1];
        
        GraphIt_GR{2}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.XLim = [1 328];
        GraphIt_GR{2}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.YLim = [-.25 4];
        
        GraphIt_GR{2}.Line.Marker{1} = '.';
        GraphIt_GR{2}.Line.Marker{2} = '.';
        
        
    case 'SR SEN/SEK'
        % fprintf('   SR SEN/SEK\n');
        
        Device = ztec_4channel_defaults;
        Device.Name = 'ztec11';
        
        SampleRate = 10e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .2*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 10;
        Device.Setup.setInp2Range = 10;
        Device.Setup.setInp3Range = 10;
        Device.Setup.setInp4Range = 10;
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setInp3Imped    = 50;
        Device.Setup.setInp4Imped    = 50;
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = .75;
        
        LineLabel = {
            {'SEN Voltage', 'SEK Voltage'}
            {'SEN Current', 'SEK Current'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp3ScaledWave']}
            {[Device.Name,':Inp2ScaledWave'],[Device.Name,':Inp4ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        if NewTimingSystemFlag
            % New timing system
            PostTriggerDelay = 0e-6;
            
            Device.Setup.setTrigSource = 'EXT';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigImpedExt = 50;
            Device.Setup.setTrigLevExt = 1.5;
            Device.Setup.setTrigSlope = 'POS';      % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setHorzOffset = -1 * PostTriggerDelay;  % -1 is post trigger offset in scope
            
            GraphIt_GR{1}.Axes.XLim = TimeScaling * [0e-6 325e-6];  % EXT trigger
            
            setpvonline('TimSRSeptaScopeDelay', 622000);
            
        elseif 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .01;
            GraphIt_GR{1}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
            
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .5;
            %Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
            GraphIt_GR{1}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        end
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-1600 1600];
        
        GraphIt_GR{2}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{2}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.YLim = [-2000 3000];
        
        GraphIt_GR{1}.Data.Gain = {200, 1000};
        GraphIt_GR{2}.Data.Gain = {500, 500};
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Storage Ring Thin and Thick Septum'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}SR SEN & SEK Voltage [Volts]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}SR SEN & SEK Current [Amps]'};
        
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling, TimeScaling};
        
        
    case 'SR Bumps'
        % fprintf('   SR Bumps\n');
        
        Device = ztec_4channel_defaults;
        Device.Name = 'ztec12';
        
        SampleRate = 400e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = 0*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 1;
        Device.Setup.setInp2Range = 1;
        Device.Setup.setInp3Range = 1;
        Device.Setup.setInp4Range = 1;
        %Device.Setup.setInp1Range = 10;
        %Device.Setup.setInp2Range = 10;
        %Device.Setup.setInp3Range = 10;
        %Device.Setup.setInp4Range = 10;
        
        Device.Setup.setInp1Offset = -.5;
        Device.Setup.setInp2Offset = -.5;
        Device.Setup.setInp3Offset = -.5;
        Device.Setup.setInp4Offset = -.5;
        
                
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setInp3Imped    = 50;
        Device.Setup.setInp4Imped    = 50;
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff  = .75;
        
        LineLabel = {
            {'SR Bump 1', 'SR Bump 2', 'SR Bump 3', 'SR Bump 4'}
            };
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'], [Device.Name,':Inp2ScaledWave'], [Device.Name,':Inp3ScaledWave'], [Device.Name,':Inp4ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;

        if NewTimingSystemFlag
            % New timing system
            PostTriggerDelay = 0e-6;
            
            Device.Setup.setTrigSource = 'EXT';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigImpedExt = 50;
            Device.Setup.setTrigLevExt = 1.5;
            Device.Setup.setTrigSlope = 'POS';      % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setHorzOffset = -1 * PostTriggerDelay;  % -1 is post trigger offset in scope
            
            GraphIt_GR{1}.Axes.XLim = TimeScaling * [0e-6 9e-6];  % EXT trigger
            
            setpvonline('TimSRBumpScopeDelay', 631025);

        elseif 0
            Device.Setup.setTrigSource  = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = -.3;
            Device.Setup.setTrigSlope   = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
            GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .5;
            %Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
            GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        end
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-90 10];
        GraphIt_GR{1}.Data.Gain = {100, 100, 100, 100};
        %GraphIt_GR{1}.Data.Offset = {0, 2, 4, 6};
        %GraphIt_GR{1}.Axes.YLim = [-5000 5000];
        %GraphIt_GR{1}.Data.Gain = {1000, 1000, -1000, -1000};
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Storage Ring Injection Bumps'};
        
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}SR Injection Bumps [Amps]'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}SR Injection Bumps [Amps]'};
        %GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}SR Injection Bumps [Volts]'};
        %GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}SR Injection Bumps [Volts]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling, TimeScaling, TimeScaling};
        
                
    case  'Booster Injection Kicker'
        % fprintf('   Booster Injection Kicker\n');

        NewTimingSystemFlag = 1;

        Device = ztec_2channel_defaults;
        Device.Name = 'ztec3';
        
        SampleRate = 500e6;  %500e6;  % Hz
        
        Device.Setup.setHorzPoints = 2000;
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        
        Device.Setup.setInp1Range = 5;
        Device.Setup.setInp2Range = 5;
        
        TimeScaling = 1e6;
        
        Device.Setup.setTrigHoldoff  = .75;
        
        LineLabel = {
            {'BR Injection Kicker 1', 'BR Injection Kicker 2'}
            };
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'], [Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setTrigImpedExt = 50;       % 50 for SRS fanout, 1e6 trigger from kicker
        
        % Self-Trigger
        SelfTrigger = 0;
        if SelfTrigger
            Device.Setup.setHorzOffset = 2e-6;  %-.0145;  -.014466
            
            Device.Setup.setTrigSource = 'INP2';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp2 = .75;
            Device.Setup.setTrigSlope = 'POS';       % Trigger Slope: 'POS' or 'NEG'
            
            GraphIt_GR{1}.Axes.XLim = TimeScaling * [-.2e-6 .6e-6];  % EXT trigger

        elseif NewTimingSystemFlag
            % Needs to follow the GaussClockInjectionFieldTrigger
            % Better to put that delay in the scope trigger!!!
            
            %SampleRate = 500e6;  %500e6;  % Hz
            %Device.Setup.setHorzPoints = 4000;
            
            % Peak detect?
            %Device.Setup.setAcqType = 'PDET';     % Peak detect will return the max or min of 10 samples / time
            %Device.Setup.setEnvView = 'MAX';      % Max/Min
            
            %InjFieldTrigger_SetupDay = 1840821;  % EvtClkTicks
            %HorzOffset_SetupDay      =  937e-6 + 5.0e-6;  % Seconds
            %InjFieldTrigger = getpv('GaussClockInjectionFieldTrigger');
            %Offset = (InjFieldTrigger - InjFieldTrigger_SetupDay) * 8 / 1e9; % sec
            %PostTriggerDelay = HorzOffset_SetupDay + Offset;
            PostTriggerDelay = 0;
            
            %  KI individual delay should be 27130 
            %  Booster individual delay should be 631555
            Device.Setup.setHorzOffset = -1 * PostTriggerDelay;  % -1 is post trigger offset in scope
                        
            Device.Setup.setTrigSource = 'EXT';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = 1.5;
            Device.Setup.setTrigSlope = 'POS';       % Trigger Slope: 'POS' or 'NEG'
            
           %GraphIt_GR{1}.Axes.XLim = TimeScaling * [1.6e-6 2.6e-6];  % EXT trigger
            GraphIt_GR{1}.Axes.XLim = TimeScaling * [.7e-6 1.4e-6];  % EXT trigger

            %setpvonline('TimInjKickerScopeDelay', 27130);
            
        else
            %Device.Setup.setHorzOffset = .016;
            Device.Setup.setHorzOffset = .2*Device.Setup.setHorzTime;
            
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = -.02;       % -.318 on EM scope
            Device.Setup.setTrigSlope = 'NEG';       % Trigger Slope: 'POS' or 'NEG'
            
            Device.Setup.setTrigImpedExt = 1e6;       % 50 for SRS fanout, 1e6 trigger from kicker
            
            %GraphIt_GR{1}.Axes.XLim = TimeScaling * [0 1.5e-6];  % EXT trigger
            GraphIt_GR{1}.Axes.XLim = TimeScaling * [.4e-6 1.0e-6];  % EXT trigger
            %GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];  % Channel 1 trigger
        end
       
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';              % 'Auto' or 'Manual'

        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-2.25 2.25];
        
        %GraphIt_GR{1}.Data.Gain = {1000, 1000};
        
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}BR Injection Kicker [Volts]'};
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Booster Injection Kicker (KI-1 & KI-2 B-Dot Monitor)'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
        
    case 'Booster Bumps'
        % fprintf('   Booster Bumps\n');
        
        Device = ztec_4channel_defaults;
        Device.Name = 'ztec10';
        
        SampleRate = .15e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime = Device.Setup.setHorzPoints/SampleRate;
        
        Device.Setup.setInp1Range = 5;
        Device.Setup.setInp2Range = 5;
        Device.Setup.setInp3Range = 5;
        Device.Setup.setInp4Range = 5;
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setInp3Imped    = 50;
        Device.Setup.setInp4Imped    = 50;
        
        Device.Setup.setTrigHoldoff = .75;
        
        TimeScaling = 1e3;
        LineLabel = {
            {'BR Bumps 1', 'BR Bumps 2', 'BR Bumps 3'}
            };
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'], [Device.Name,':Inp2ScaledWave'], [Device.Name,':Inp3ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);

        if NewTimingSystemFlag
            % New timing system
            PostTriggerDelay = -5e-3;
                        
            Device.Setup.setTrigSource = 'EXT';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigImpedExt = 50;
            Device.Setup.setTrigLevExt = 1.5;
            Device.Setup.setTrigSlope = 'POS';      % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setHorzOffset = -1 * PostTriggerDelay;  % -1 is post trigger offset in scope
            
            GraphIt_GR{1}.Axes.XLim = TimeScaling * [-2e-3 25e-3];  % EXT trigger
            
            setpvonline('TimBRBumpScopeDelay', 0);

        elseif 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .25;
            Device.Setup.setHorzOffset = .05*Device.Setup.setHorzTime;
            Device.Setup.setTrigImpedExt = 1e6;
            
            GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
            
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = 1;
            Device.Setup.setHorzOffset = .05*Device.Setup.setHorzTime;
            %Device.Setup.setHorzOffset = -12.5e-3 + 2e-3;  % Trigger is -12.5e-3
            Device.Setup.setTrigImpedExt = 1e6;
            
            GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        end
        
        
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-200 250];
        GraphIt_GR{1}.Axes.YLim = [-175 175];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Booster Bumps'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}BR Bumps [Amps]'};
        %GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}BR Bumps [Volts]'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [milliseconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling, TimeScaling};
        GraphIt_GR{1}.Data.Gain = {100, 100, 100};
        
        
    case 'Booster Extraction Kicker'
        % fprintf('   Booster Extraction Kicker\n');
        
        Device = ztec_4channel_defaults;
        Device.Name = 'ztec7';
        
        SampleRate = 500e6;  % Hz
        
        Device.Setup.setHorzPoints = 1000;
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        
        Device.Setup.setInp1Range = 5;
        Device.Setup.setInp2Range = 5;
        Device.Setup.setInp3Range = 5;
        Device.Setup.setInp4Range = 5;
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setInp3Imped    = 50;
        Device.Setup.setInp4Imped    = 50;
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff  = .75;
        
        LineLabel = {
            {'BR Extraction Kicker KE1', 'BR Extraction Kicker KE2', 'BR Extraction Kicker KE3', 'BR Extraction Kicker KE4'}
            };
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'], [Device.Name,':Inp2ScaledWave'], [Device.Name,':Inp3ScaledWave'], [Device.Name,':Inp4ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e9;
        
        if NewTimingSystemFlag
            % New timing system
            PostTriggerDelay = 0e-6;
            
            Device.Setup.setTrigSource = 'EXT';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigImpedExt = 50;
            Device.Setup.setTrigLevExt = 1.5;
            Device.Setup.setTrigSlope = 'POS';      % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setHorzOffset = -1 * PostTriggerDelay;  % -1 is post trigger offset in scope
            
            GraphIt_GR{1}.Axes.XLim = TimeScaling * [100 700] * 1e-9;
            
            setpvonline('TimExtrKickerScopeDelay', 631555);

        elseif 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .3;
            Device.Setup.setHorzOffset = .2*Device.Setup.setHorzTime;
            GraphIt_GR{1}.Axes.XLim = TimeScaling * [500 1200] * 1e-9;
        
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = -.1;    % was -.02
            Device.Setup.setTrigSlope = 'NEG';       % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setHorzOffset = -400e-9;
            GraphIt_GR{1}.Axes.XLim = TimeScaling * [500 1200] * 1e-9;
        end
        
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-2.5 2.5];
        
        %GraphIt_GR{1}.Data.Gain = {1000, 1000, 1000, 1000};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Booster Extraction Kicker'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Booster Extraction Kicker (B-Dot Monitor)'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling, TimeScaling, TimeScaling};
        
        
    case 'Booster SEN/SEK'
        % fprintf('   Booster SEN/SEK\n');
        
        Device = ztec_4channel_defaults;
        Device.Name = 'ztec8';
        
        SampleRate = 10e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime = Device.Setup.setHorzPoints/SampleRate;
        
        Device.Setup.setInp1Range = 10;
        Device.Setup.setInp2Range = 10;
        Device.Setup.setInp3Range = 10;
        Device.Setup.setInp4Range = 10;
        
        % Note: Old scopes used 1e6 on all four inputs???
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setInp3Imped    = 50;
        Device.Setup.setInp4Imped    = 50;
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = .75;
                
        LineLabel = {
            {'SEN Voltage', 'SEK Voltage'}
            {'SEN Current', 'SEK Current'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp3ScaledWave']}
            {[Device.Name,':Inp2ScaledWave'],[Device.Name,':Inp4ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;

        if NewTimingSystemFlag
            % New timing system
            PostTriggerDelay = 0e-6;
            
            Device.Setup.setTrigSource = 'EXT';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigImpedExt = 50;
            Device.Setup.setTrigLevExt = 1.5;
            Device.Setup.setTrigSlope = 'POS';      % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setHorzOffset = -1 * PostTriggerDelay;  % -1 is post trigger offset in scope
            
            GraphIt_GR{1}.Axes.XLim = TimeScaling * [100 700] * 1e-9;
            
            setpvonline('TimBRSeptaScopeDelay', 620000);

        elseif 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .5;
            %Device.Setup.setTrigSource = 'INP2';    % Trigger channel: INP1, INP2, or EXT
            %Device.Setup.setTrigLevInp2 = .1;
            
            Device.Setup.setHorzOffset = .25*Device.Setup.setHorzTime;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .5;
            %Device.Setup.setTrigSlope = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
            
            Device.Setup.setHorzOffset = .05*Device.Setup.setHorzTime;
        end
        
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-2000 2000];
        
        GraphIt_GR{2}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{2}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.YLim = [-4200 4200];
        
        GraphIt_GR{1}.Data.Gain = { 500, 1000};
        GraphIt_GR{2}.Data.Gain = {1000, 1000};
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Booster Thin and Thick Septum'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Voltage [Volts]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}Current [Amps]'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}BR SEN & SEK Voltage [Volts]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}BR SEN & SEK Current [Amps]'};
        
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling, TimeScaling};
        
        
    case 'LI10  Scope (MUX): Subharmonic Buncher'
        % fprintf('   LI10  Scope (MUX): Subharmonic Buncher\n');
        NewTimingSystemFlag = 0;  % Needs evt 20 in default mode

        Device = ztec_2channel_defaults;
        Device.Name = 'ztec5';
        
        % Mux setup
        Device.MUX.Ch1.Name = 'li10_ch1';
        Device.MUX.Ch1.Value = 2;
        Device.MUX.Ch2.Name = 'li10_ch2';
        Device.MUX.Ch2.Value = 2;
        Device.MUX.Trig.Name = 'li10_trig';
        Device.MUX.Trig.Value = 0;
        
        SampleRate = 100e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 1;
        Device.Setup.setInp2Range = 1;
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;      % was 1e6 for some reason
        Device.Setup.setTrigImpedExt = 50;
        
        Device.Setup.setTrigHoldoff = .75;
        
        if NewTimingSystemFlag
            % New timing system
            Device.Setup.setTrigSource = 'EXT';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .10;       % 3.0v full step @ 50ohm,  200us wide
            Device.Setup.setTrigSlope = 'POS';      % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setHorzOffset = -200e-6;
        elseif 1
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp2 = .15;
            Device.Setup.setTrigSlope = 'POS';      % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setHorzOffset = Device.Setup.setHorzOffset + 0e-6;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .8;
        end
        
        
        LineLabel = {
            {'GTL Subharmonic Buncher #1', 'GTL Subharmonic Buncher #2'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-.05 .4];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}GTL Subharmonic Buncher 1 & 2'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}GTL Subharmonic Buncher 1 & 2'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
    case 'LI21  MUX: Linac Klystron Input Drive'
        % fprintf('   LI21  MUX: Linac Klystron Input Drive\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec4';
        
        % Mux setup
        Device.MUX.Ch1.Name = 'li21_ch1';
        Device.MUX.Ch1.Value = 0;
        Device.MUX.Ch2.Name = 'li21_ch2';
        Device.MUX.Ch2.Value = 2;
        Device.MUX.Trig.Name = 'li21_trig';
        Device.MUX.Trig.Value = 0;
        
        
        SampleRate = 200e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = 0;  % .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 5;
        Device.Setup.setInp2Range = 5;
        
        if 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .1;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .4;
        end
        
        Device.Setup.setInp1Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setInp2Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = .75;
        
        LineLabel = {
            {'Klystron 1 Input Drive', 'Klystron 2 Input Drive'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'], [Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [0 12e-6];
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-2 .2];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Linac Klystron Input Drive'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Input Drive [Volts]'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
        
    case 'LI21  MUX: Linac Klystron Phase Detect Out'
        % fprintf('   LI21  MUX: Linac Klystron Phase Detect Out\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec4';
        
        % Mux setup
        Device.MUX.Ch1.Name = 'li21_ch1';
        Device.MUX.Ch1.Value = 1;
        Device.MUX.Ch2.Name = 'li21_ch2';
        Device.MUX.Ch2.Value = 3;
        Device.MUX.Trig.Name = 'li21_trig';
        Device.MUX.Trig.Value = 0;
        
        
        SampleRate = 500e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = -2e-6;  % .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 1;
        Device.Setup.setInp2Range = 1;
        
        if 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .1;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .4;
        end
        
        Device.Setup.setInp1Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setInp2Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = .75;
        
        LineLabel = {
            {'Klystron 1 Phase Detect Out', 'Klystron 2 Phase Detect Out'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'], [Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-.1 .5];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Linac Klystron Phase Detect Output'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Phase Detect Output'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
    case 'LI21  MUX: Linac Klystron Phase Detect In'
        % fprintf('LI21  MUX: Linac Klystron Phase Detect In"\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec4';
        
        
        % Mux setup
        Device.MUX.Ch1.Name = 'li21_ch1';
        Device.MUX.Ch1.Value = 2;
        Device.MUX.Ch2.Name = 'li21_ch2';
        Device.MUX.Ch2.Value = 4;
        Device.MUX.Trig.Name = 'li21_trig';
        Device.MUX.Trig.Value = 0;
        
        SampleRate = 500e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = -2e-6;  % .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 1;
        Device.Setup.setInp2Range = 1;
        
        if 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .1;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .4;
        end
        
        Device.Setup.setInp1Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setInp2Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = .75;
        
        LineLabel = {
            {'Klystron 1 Phase Detect In', 'Klystron 2 Phase Detect In'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'], [Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-.2 .5];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Linac Klystron Phase Detect In'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14} Phase Detect In'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
    case 'LI21  MUX: Linac Klystron Reverse Power'
        % fprintf('LI21  MUX: Linac Klystron Reverse Power\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec4';
        
        
        % Mux setup
        Device.MUX.Ch1.Name = 'li21_ch1';
        Device.MUX.Ch1.Value = 3;
        Device.MUX.Ch2.Name = 'li21_ch2';
        Device.MUX.Ch2.Value = 5;
        Device.MUX.Trig.Name = 'li21_trig';
        Device.MUX.Trig.Value = 0;
        
        SampleRate = 500e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = -2e-6;  % .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = .5;
        Device.Setup.setInp2Range = .5;
        
        if 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .1;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .4;
        end
        
        Device.Setup.setInp1Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setInp2Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = .75;
        
        LineLabel = {
            {'Klystron 1 Reverse Power', 'Klystron 2 Reverse Power'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'], [Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.XLim = [3 9];
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-.15 .05];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}LI21  MUX: Linac Klystron Reverse Power'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Linac Klystron Reverse Power'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
    case 'LI21  MUX: Linac Klystron Forward Power'
        % fprintf('LI21  MUX: Linac Klystron Forward Power\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec4';
        
        
        % Mux setup
        Device.MUX.Ch1.Name = 'li21_ch1';
        Device.MUX.Ch1.Value = 4;
        Device.MUX.Ch2.Name = 'li21_ch2';
        Device.MUX.Ch2.Value = 0;
        Device.MUX.Trig.Name = 'li21_trig';
        Device.MUX.Trig.Value = 0;
        
        SampleRate = 500e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = -2e-6;  % .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 1;
        Device.Setup.setInp2Range = 1;
        
        if 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .1;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .4;
        end
        
        Device.Setup.setInp1Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setInp2Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = .75;
        
        LineLabel = {
            {'Klystron 2 Forward Power', 'Klystron 1 Forward Power'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'], [Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.XLim = [3 9];
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-.5 .05];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}LI21  MUX: Linac Klystron Forward Power'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Linac Klystron Forward Power'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
    case 'LI21  MUX: Linac Klystron Fast Phase'
        % fprintf('LI21  MUX: Linac Klystron Fast Phase\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec4';
        
        
        % Mux setup
        Device.MUX.Ch1.Name = 'li21_ch1';
        Device.MUX.Ch1.Value = 5;
        Device.MUX.Ch2.Name = 'li21_ch2';
        Device.MUX.Ch2.Value = 1;
        Device.MUX.Trig.Name = 'li21_trig';
        Device.MUX.Trig.Value = 0;
        
        SampleRate = 500e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 2;
        Device.Setup.setInp2Range = 2;
        
        if 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .1;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .4;
        end
        
        Device.Setup.setInp1Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setInp2Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = .75;
        
        LineLabel = {
            {'Klystron 2 Fast Phase', 'Klystron 1 Fast Phase'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'], [Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-.7 .1];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Linac Klystron Fast Phase'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Linac Klystron Fast Phase'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
        
    case 'LI21  MUX: Linac S-Band Buncher'
        % fprintf('LI21  MUX: Linac S-Band Buncher\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec4';
        
        % Mux setup
        Device.MUX.Ch1.Name = 'li21_ch1';
        Device.MUX.Ch1.Value = 6;
        Device.MUX.Ch2.Name = 'li21_ch2';
        Device.MUX.Ch2.Value = 6;
        Device.MUX.Trig.Name = 'li21_trig';
        Device.MUX.Trig.Value = 0;
        
        SampleRate = 500e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = -2e-6;  % .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 5;
        Device.Setup.setInp2Range = .1;
        
        if 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .1;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .4;
        end
        
        Device.Setup.setInp1Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setInp2Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = .75;
        
        LineLabel = {
            {'SBUN REVERSE PWR'}
            {'SBUN FORWARD PWR'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave']}
            {[Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-.05 2.5];
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}LI21  MUX: Linac S-Band Buncher'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Reverse Power'};
        %GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
        GraphIt_GR{2}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{2}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.YLim = [-.05 .05];
        %GraphIt_GR{2}.Axes.Title.String  = {'\fontsize{14}LI21  MUX: Linac S-Band Buncher'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}Forward Power'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        GraphIt_GR{2}.Data.XGain = {TimeScaling, TimeScaling};
        
        
    case 'LI21  MUX: Linac AS Load Forward Power "The Modulators"'
        % fprintf('   LI21  MUX: Linac AS Load Forward Power "The Modulators"\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec4';
        
        
        % Mux setup
        Device.MUX.Ch1.Name = 'li21_ch1';
        Device.MUX.Ch1.Value = 8;
        Device.MUX.Ch2.Name = 'li21_ch2';
        Device.MUX.Ch2.Value = 9;
        Device.MUX.Trig.Name = 'li21_trig';
        Device.MUX.Trig.Value = 0;
        
        SampleRate = 500e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = -2e-6;  % .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 2;
        Device.Setup.setInp2Range = 2;
        
        if 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .1;
            Device.Setup.setHorzOffset = 2e-6;  % .1*Device.Setup.setHorzTime;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .4;
        end
        
        Device.Setup.setInp1Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setInp2Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = .75;
        
        LineLabel = {
            {'LN Modulator 1', 'LN Modulator 2'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'], [Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.XLim = [3 9];
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-.05 1.1];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Linac Modulators 1 & 2: AS Load Forward Power'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}AS Load Forward Power'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
        
    case 'LI21  MUX: Linac AS Forward Power'
        % fprintf('LI21  MUX: Linac AS Forward Power\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec4';
        
        % Mux setup
        Device.MUX.Ch1.Name = 'li21_ch1';
        Device.MUX.Ch1.Value = 9;
        Device.MUX.Ch2.Name = 'li21_ch2';
        Device.MUX.Ch2.Value = 7;
        Device.MUX.Trig.Name = 'li21_trig';
        Device.MUX.Trig.Value = 0;
        
        SampleRate = 200e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = -3e-6;  % .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 4;
        Device.Setup.setInp2Range = 4;
        
        if 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .1;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .4;
        end
        
        Device.Setup.setInp1Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setInp2Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = .75;
        
        LineLabel = {
            {'AS1 Forward Power', 'AS2 Forward Power'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp2ScaledWave'], [Device.Name,':Inp1ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-.1 1.7];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}LI21  MUX: Linac AS Forward Power'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Linac AS Forward Power'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
        
    case 'LI21  MUX: Linac AS1 Forward & Reverse Power'
        % fprintf('LI21  MUX: Linac AS1 Forward & Reverse Power\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec4';
        
        % Mux setup
        Device.MUX.Ch1.Name = 'li21_ch1';
        Device.MUX.Ch1.Value = 7;
        Device.MUX.Ch2.Name = 'li21_ch2';
        Device.MUX.Ch2.Value = 7;
        Device.MUX.Trig.Name = 'li21_trig';
        Device.MUX.Trig.Value = 0;
        
        SampleRate = 200e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset =  -3e-6;  % .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 2;
        Device.Setup.setInp2Range = 4;
        
        if 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .1;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .4;
        end
        
        Device.Setup.setInp1Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setInp2Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = .75;
        
        LineLabel = {
            {'AS1 Forward Power', 'AS1 Reverse Power'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp2ScaledWave'], [Device.Name,':Inp1ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-.1 1.7];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Linac AS1 Forward & Reverse Power'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}AS1 Forward & Reverse Power'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
        
    case 'LI21  MUX: Linac Timing'
        % fprintf('LI21  MUX: Linac Timing\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec4';
        
        
        % Mux setup
        Device.MUX.Ch1.Name = 'li21_ch1';
        Device.MUX.Ch1.Value = 10;
        Device.MUX.Ch2.Name = 'li21_ch2';
        Device.MUX.Ch2.Value = 10;
        Device.MUX.Trig.Name = 'li21_trig';
        Device.MUX.Trig.Value = 0;
        
        SampleRate = 500e6;  % Hz
        
        Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 1;
        Device.Setup.setInp2Range = 10;
        
        if 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .1;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .4;
        end
        
        Device.Setup.setInp1Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setInp2Imped    = 1e6;  % Since T'ed off the Textronics scope
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = .75;
        
        LineLabel = {
            {'Timing Gun Gate', 'TIM 3GHz RF Trigger'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'], [Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-2 5];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}LI21  MUX: Linac Timing'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Linac Timing'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
        
        
    case 'Booster RF'
        % fprintf('   Booster RF\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec6';
        
        SampleRate = 10000;  % Min 10 kHz  Max 500 MHz (1 GHz interleaved)
        Device.Setup.setHorzPoints = 10000;
        Device.Setup.setHorzTime = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 10;
        Device.Setup.setInp2Range = 2;
        
        Device.Setup.setInp1Offset = 5;      % Input offset [volts]
        Device.Setup.setInp2Offset = 0;      % Input offset [volts]
        
        Device.Setup.setInp1Filter = 1;      % Enable/disable 20 MHz input filter
        Device.Setup.setInp2Filter = 1;      % Enable/disable 20 MHz input filter
        
        if NewTimingSystemFlag
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = 1.5;
            Device.Setup.setTrigSlope = 'POS';       % Trigger Slope: 'POS' or 'NEG'
        elseif 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = 3;
            Device.Setup.setTrigSlope = 'POS';       % Trigger Slope: 'POS' or 'NEG'
            
            % When trigger connected to inp2
            %Device.Setup.setTrigSource = 'INP2';     % Trigger channel: INP1, INP2, or EXT
            %Device.Setup.setTrigSlope = 'POS';       % Trigger Slope: 'POS' or 'NEG'
            %Device.Setup.setTrigLevInp2  = 1;        % Trigger level for Inp2 (Offset +/- Range/2 [Volts])
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = 1;
            Device.Setup.setTrigSlope = 'POS';       % Trigger Slope: 'POS' or 'NEG'
        end
        
        Device.Setup.setInp1Imped    = 1e6;
        Device.Setup.setInp2Imped    = 1e6;
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = 0;
        
        LineLabel = {
            {'BRF Drive'}
            {'BRF Cavity'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave']}
            {[Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        TimeScaling = 1;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        
        GraphIt_GR{2}.Axes.XLimMode = GraphIt_GR{1}.Axes.XLimMode;
        GraphIt_GR{2}.Axes.XLim     = GraphIt_GR{1}.Axes.XLim;
        
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [.9 7.2];
        
        GraphIt_GR{2}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.YLim = [0 .5];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Booster RF'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}BRF Drive'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [Seconds]'};
        
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}BRF Cavity'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [Seconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling};
        
        
        
    case 'B0404 MUX: DCCT & BPM'
        % fprintf('   B0404 MUX: DCCT & BPM\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec1';
        
        %SampleRate = 1e6;  % Hz
        Device.Setup.setHorzPoints = 6000;
        Device.Setup.setHorzTime = 1;       % Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .075;   % .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 5;
        Device.Setup.setInp2Range = 5;
        
        if 0
            Device.Setup.setTrigSource = 'INP2';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = -.1;
            %Device.Setup.setTrigSlope = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = -.03;
            Device.Setup.setTrigSlope = 'NEG';       % Trigger Slope: 'POS' or 'NEG'
        end
        
        Device.Setup.setInp1Imped    = 1e6;
        Device.Setup.setInp2Imped    = 1e6;
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff = .75;
        
        LineLabel = {
            {'BR3 BPM'}
            {'BR3 DCCT'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave']}
            {[Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        TimeScaling = 1;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset .525];
        
        GraphIt_GR{2}.Axes.XLimMode = GraphIt_GR{1}.Axes.XLimMode;
        GraphIt_GR{2}.Axes.XLim     = GraphIt_GR{1}.Axes.XLim;
        
        %GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-.05 .4];
        
        GraphIt_GR{2}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.YLim = [-1 .2];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}B0404 Scope'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}BR3 BPM'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [Seconds]'};
        
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}BR3 DCCT'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [Seconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling};
        
        
    case 'Wall Current Monitor'
        % ZT4611 or ZT4441
        ZT4611 = 1;

        % Note: GTL wall current monitor and booster TWE are mutually exclusive
        % fprintf('   Wall Current Monitor (Gun-to-Linac)\n');
        fprintf('   Self-trigger so the external trigger can be used for the TWE.\n');
        
        Device = ztec_2channel_defaults;
        if ZT4611
            Device.Name = 'ztec14';
            SampleRate = 2*2e9;   % 2 GHz scope, 4 GHz interleaved
        else
            Device.Name = 'ztec17';
            SampleRate = 2*800e6;   % 800 MHz scope, 1.6? GHz interleaved
        end
        
        % Disable channel for interleaved samples
        Device.Setup.setInp1Enable = 1;
        Device.Setup.setInp2Enable = 0;
        
        Device.Setup.setHorzPoints = 500;
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 2.0;    % This might be a little tight
        Device.Setup.setInp2Range = -.4;    % Not used
        
        Device.Setup.setInp1Offset = -.5;    % Input offset [volts]
        Device.Setup.setInp2Offset = 0;      % Input offset [volts]

                
        Device.Setup.setInp1Imped = 50;
        Device.Setup.setInp2Imped = 50;
        
        Device.Setup.setTrigHoldoff  = .5;
      
        if 1
            % Self trigger
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = -.18;      % -.1 was getting some false triggers
            Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setTrigImpedExt = 1e6;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .5;
            Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setTrigImpedExt = 1e6;
        end
        
        LineLabel = {
            {'Wall Current Monitor'}
            };
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e9;
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.XLim = [-15 80];
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-.2 1.5];
        %GraphIt_GR{1}.Axes.YLim = [-1.5 .2];
        GraphIt_GR{1}.Data.Gain = {-1};
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Wall Current Monitor (GTL)'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Wall Current Monitor [Volts]'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        GraphIt_GR{1}.Data.XGain = {TimeScaling};
        
        
    case 'Traveling Wave Electrode (TWE)'
        % ZT4611 or ZT4441
        ZT4611 = 1;

        % Option for changing which booster turn is plotted???

        % Note: Lince wall current monitor and booster TWE are mutually exclusive
        fprintf('   Traveling Wave Electrode (TWE) (Booster)\n');
        
        Device = ztec_2channel_defaults;
        if ZT4611
            Device.Name = 'ztec14';
            SampleRate = 2*2e9;   % 2 GHz scope, 4 GHz interleaved
        else
            Device.Name = 'ztec17';
            SampleRate = 2*800e6;   % 800 MHz scope, 1.6? GHz interleaved
        end
        
        % Disable channel for interleaved samples
        Device.Setup.setInp1Enable = 0;
        Device.Setup.setInp2Enable = 1;
        
        Device.Setup.setHorzPoints = 2000;
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 5;
        Device.Setup.setInp2Range = 2;
        
        TriggerFlag = 1;
        NewTimingSystemFlag = 0;  % Not ready yet
        if NewTimingSystemFlag
            % The timing evt needs to only occur if there is beam in the booster
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = 1.5;       % -.1 was getting some false triggers
            Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setTrigImpedExt = 50;
            Device.Setup.setHorzOffset = -50e-6;     % ??? -200e-9; for the first turn
        elseif TriggerFlag
            Device.Setup.setTrigSource = 'INP2';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp2 = -.03;
            Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setHorzOffset = -5e-3;      % 0 the first turn 
        else
            % BPM connected to the external trigger
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = -.04;
            Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
            Device.Setup.setHorzOffset = -5e-3;      % -200e-9; for the first turn
        end
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff  = .5;
        
        LineLabel = {
            {'Traveling Wave Electrode (TWE)'}
            };
        ChannelNames = {
            {[Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e3;
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        if TriggerFlag
          % GraphIt_GR{1}.Axes.XLim = -1*Device.Setup.setHorzOffset*[1 (1.0001)]*1000;
            GraphIt_GR{1}.Axes.XLim = [5 5.0001];
        else
            GraphIt_GR{1}.Axes.XLim = [0 70]+45;
            GraphIt_GR{1}.Data.XOffset = {-1*TimeScaling*Device.Setup.setHorzOffset};
        end
        GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLim = [-.601 .601];
        GraphIt_GR{1}.Data.Gain = {1};
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Traveling Wave Electrode (TWE)'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Traveling Wave Electrode [Volts]'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [Milliseconds]'};
        GraphIt_GR{1}.Data.XGain = {TimeScaling};

    
    case 'Test 2'
        fprintf('   Setup to test a 2-channel scope\n');
        
        % Error -330, self test failed
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec15';
        
        Device.Setup.setTrigSource  = 'EXT';     % Trigger channel: INP1, INP2, or EXT
        Device.Setup.setTrigLevInp1 = 1.;
        Device.Setup.setTrigLevInp2 = .1;
        Device.Setup.setTrigLevExt  = .5;
        
        Device.Setup.setHorzPoints = 10000;  % ztec2->2500   ztec9->4096;
        Device.Setup.setHorzTime   = 5*656e-9;
        Device.Setup.setHorzOffset = .02;
        
        Device.Setup.setInp1Range = 10;
        Device.Setup.setInp2Range = 10;
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 1e6;
        Device.Setup.setTrigImpedExt = 50;
        
        %Device.Setup.setHorzTime = Device.Setup.setHorzPoints/1000;
        %Device.Setup.setHorzTime = Device.Setup.setHorzPoints/2e9;   % 5e-5;
        %Device.Setup.setHorzTime = Device.Setup.setHorzPoints/5e7;
        %Device.Setup.setHorzOffset = 2e-5;
        
        Device.Setup.setOutExtEnable = 1;
        Device.Setup.setOutExtSource = 'CLOC';
        Device.Setup.setOutExtPulsePer = .001;
        
        %Device.Setup.OpInitiate = 0;         % Single shot
        
        Device.Setup.setTrigHoldoff = 0;
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, {{'Channel 1'},{'Channel 2'}}, {{[Device.Name,':Inp1ScaledWave']},{[Device.Name,':Inp2ScaledWave']}});
        
        GraphIt_GR{1}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
                
        
    case 'ztec19 (4611 - LN Test Scope)'  
        %'ZT4611 TEST'
        % ZT4611
        fprintf('   Setup for the ZT4611 test scope in LI11\n');
          
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec19';
        
        SampleRate = 4e9;   % 2 GHz scope, 4 GHz interleaved
        
        % Disable channel for interleaved samples
        Device.Setup.setInp1Enable = 0;
        Device.Setup.setInp2Enable = 1;
        
        Device.Setup.setHorzPoints = 1000;
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .1 *Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = .5;  
        Device.Setup.setInp2Range = 5;  
        
        Device.Setup.setInp1Offset = 0;    % Input offset [volts]
        Device.Setup.setInp2Offset = 0;    % Input offset [volts]

        if 1
            Device.Setup.setTrigSource = 'INP2';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = -.1;      % -.1 was getting some false triggers
            Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .5;
            Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
        end
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setTrigImpedExt = 1e6;
        
        Device.Setup.setTrigHoldoff  = .5;
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, {{'LN ICT'},{'LN BPM2'}}, {{[Device.Name,':Inp1ScaledWave']},{[Device.Name,':Inp2ScaledWave']}});
        
        TimeScaling = 1e9;
        %GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        %GraphIt_GR{1}.Axes.XLim = [-15 80];
        %GraphIt_GR{1}.Axes.YLimMode = 'Manual';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-.2 1.5];
        %GraphIt_GR{1}.Axes.YLim = [-1.5 .2];
        %GraphIt_GR{1}.Data.Gain = {-1};
        
        GraphIt_GR{1}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        
    otherwise
        fprintf('   ScopeType = "%s"\n', ScopeType);
        error('ScopeType is not a known type.');
end

Device.ScopeType = ScopeType;

GR.Figure  = GraphIt_Fig;
GR.GraphIt = GraphIt_GR;
GR.Extra   = GraphIt_Extra;
GR.Device  = Device;



function Device = ztec_2channel_defaults
% Setup for a 2-channel scope


% Default scope prefix names
Device.Type = 'ztec';
Device.ScopeType = 'ZTEC Scope';
Device.Name = '';
Device.MUX = [];


%%%%%%%%%%%%%%%
% Utility PVs %
%%%%%%%%%%%%%%%

% Coerce must be the first thing done
Device.Setup.setOutCoerce = 0;       % Changing to 0 so order hopefully doesn't matter (GJP -> 2016-07-21)

Device.Setup.setRestoreState = 0;    % 0 restores to the reset condition

%%%%%%%%%%%%%
% Input PVs %
%%%%%%%%%%%%%

% Setup channel #1
Device.Setup.setInp1Enable = 1;        % Enables/disable channel
Device.Setup.setInp1Couple = 'DC';     % Coupling to AC or DC
Device.Setup.setInp1Imped  = 1e6;      % Input impedance to 50 or 1e6 ohms
Device.Setup.setInp1Range  = 10;       % Input range  [volts]
Device.Setup.setInp1Offset = 0;        % Input offset [volts]
Device.Setup.setInp1Filter = 0;        % Enable/disable 20 MHz input filter

% Setup channel #2
Device.Setup.setInp2Enable = 1;        % Enables/disable channel
Device.Setup.setInp2Couple = 'DC';     % Coupling to AC or DC
Device.Setup.setInp2Imped  = 1e6;      % Input impedance to 50 or 1e6 ohms
Device.Setup.setInp2Range  = 10;       % Input range [volts]
Device.Setup.setInp2Offset = 0;        % Input offset [volts]
Device.Setup.setInp2Filter = 0;        % Enable/disable 20 MHz input filter

% Measurement setup
Device.Setup.setMeas1Source = 'INP1';  % Channel 1
Device.Setup.setMeas1Type   = 'FREQ';  %
Device.Setup.setMeas2Source = 'INP2';  % Channel 2
Device.Setup.setMeas2Type   = 'FREQ';  %


%%%%%%%%%%%%%%%%%%
% Horizontal PVs %
%%%%%%%%%%%%%%%%%%

% Number of points in the waveform and the total time covered by the N points in the waveform
% N = 100,000  Tmax = 5.0
% N =  10,000  Tmax = 0.5
Device.Setup.setHorzPoints = 4000;  % 4096 some time only returns 4000        % 1000 10000 25000 25000/20 100000/90
Device.Setup.setHorzOffset = 0;           % Time to start acquire +Pretrigger -Posttrigger [seconds]
%Device.Setup.setHorzTime = 5e-5;         % 500 MHz @ 100k
Device.Setup.setHorzTime = 5e-4;          % 50 MHz @ 100k


%%%%%%%%%%%%%%%%%%%
% Acquisition PVs %
%%%%%%%%%%%%%%%%%%%

% NORM, AVER, ENV, PDET, HRES, FAST, ETIM
% PDET - minimum or maximum for peak detection mode (10 point)
Device.Setup.setAcqType = 'NORM';
Device.Setup.setAcqCount = 2;          % Must be a power of 2, used with ETIM

Device.Setup.setEnvView = 'MIN';


%%%%%%%%%%%%%%%
% Trigger PVs %
%%%%%%%%%%%%%%%
Device.Setup.setTrigMode     = 'NORM'; % Trigger mode ('AUTO' or 'NORM')
Device.Setup.setTrigSlope    = 'POS';  % sets the trigger slope - POS NEG
Device.Setup.setTrigType     = 'EDGE'; % sets the trigger type
Device.Setup.setTrigSource   = 'EXT';  % Trigger channel: INP1, INP2, or EXT
Device.Setup.setTrigLevInp1  = .1;     % Trigger level for Inp1 (Offset +/- Range/2 [Volts])
Device.Setup.setTrigLevInp2  = .1;     % Trigger level for Inp2 (Offset +/- Range/2 [Volts])
Device.Setup.setTrigLevExt   = .1;     % Trigger level for EXT  (-2 to 2 [Volts])
Device.Setup.setTrigImpedExt = 1e6;    % Input impedance to 50 or 1e6 ohms

% This is a bad way to avoid a waveform from being overwritten by
% the scope while reading it in EPICS, but it's all we have for now.
% Set to zero when using ETIM.
Device.Setup.setTrigHoldoff = .65;


%%%%%%%%%%%%%%
% Output PVs %
%%%%%%%%%%%%%%
% Fixed at 3.1 volts???
Device.Setup.setOutExtEnable = 0;
Device.Setup.setOutExtSource = 'CLOC';
Device.Setup.setOutExtPulsePer = .001;


%%%%%%%%%%%%%%%%
% Waveform PVs %
%%%%%%%%%%%%%%%%

% Waveform updates
% 0 = 'NONE' - Don't update
% 1 = 'SCAL' - Update Float Scaled Waves
% 2 = 'CODE' - Update Integer Code Waves
%getpv('ztec1:WaveAutoUpdate','char');
Device.Setup.WaveAutoUpdate = 1;

% To reset all the xxxWaveCount PVs (note: they wrap at 65535)
%Device.Setup.WaveCountReset = 1;     % Set to 1 to reset


%%%%%%%%%%%%%%%
% Operate PVs %
%%%%%%%%%%%%%%%

%getpv('ztec1:getOpComplete')
Device.Setup.OpCompleteEnable = 1;  % ???

% Initiate waveform acquisition.
% 0 - SING = single capture
% 1 - CONT = continuous capture
% 2 - REP = repeated capture
Device.Setup.OpInitiate = 2;


%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab post-processing %
%%%%%%%%%%%%%%%%%%%%%%%%%%
Device.Special.DownSampleNumber = 1;



function Device = ztec_4channel_defaults
% Setup for a 4-channel scope

% Start with the 2-channel defaults
Device = ztec_2channel_defaults;

% Setup channel #3
Device.Setup.setInp3Enable = 1;        % Enables/disable channel
Device.Setup.setInp3Couple = 'DC';     % Coupling to AC or DC
Device.Setup.setInp3Imped  = 1e6;      % Input impedance to 50 or 1e6 ohms
Device.Setup.setInp3Range  = 10;       % Input range [volts]
Device.Setup.setInp3Offset = 0;        % Input offset [volts]
Device.Setup.setInp3Filter = 0;        % Enable/disable input filter

% Setup channel #4
Device.Setup.setInp4Enable = 1;        % Enables/disable channel
Device.Setup.setInp4Couple = 'DC';     % Coupling to AC or DC
Device.Setup.setInp4Imped  = 1e6;      % Input impedance to 50 or 1e6 ohms
Device.Setup.setInp4Range  = 10;       % Input range [volts]
Device.Setup.setInp4Offset = 0;        % Input offset [volts]
Device.Setup.setInp4Filter = 0;        % Enable/disable input filter



function [GR, Fig, Extra] = graphit_setup(NumberOfAxes, LineLabelCellCell, ChannelNameCellCell)
%GRAPHIT_SETUP - Build the structures used by ztec/graphit
%

if nargin == 0 || isempty(NumberOfAxes)
    NumberOfAxes = 2;
end
if nargin < 2 || isempty(LineLabelCellCell)
    LineLabelCellCell = {{''},{''}};
end
if nargin < 3 || isempty(ChannelNameCellCell)
    for i = 1:length(LineLabelCellCell)
        LineLabelCell = LineLabelCellCell{i};
        for j = 1:length(LineLabelCell)
            ChannelNameCellCell{i}{j} = '';
        end
    end
end

if NumberOfAxes == 1
    AxesPosition = {
        [.1 .1 .87 .8]
        };
elseif NumberOfAxes == 2
    AxesPosition = {
        [.1 0.584 .87 0.3412]
        [.1 0.110 .87 0.3412]
        };
elseif NumberOfAxes == 3
    AxesPosition = {
        [.1 0.709 .87 0.22]
        [.1 0.409 .87 0.22]
        [.1 0.110 .87 0.22]
        };
elseif NumberOfAxes == 4
    AxesPosition = {
        [.1 0.7683 .87 0.1567]
        [.1 0.5492 .87 0.1567]
        [.1 0.3301 .87 0.1567]
        [.1 0.1110 .87 0.1567]
        };
end

% Figure properties
Fig.Name = 'ZTEC Scope';
Fig.Color = [0.8 0.8 0.8];
Fig.Units = 'Inches';
Fig.Position = [2 2 7 6.25];
% position is set in the als_waveform
% Fig.Units = 'Normalized';
% Fig.Position = [.1 .3 .4 .5];
Fig.NumberTitle = 'Off';

for i = 1:NumberOfAxes
    LineLabelCell = LineLabelCellCell{i};
    GR{i} = getdefaultaxes(LineLabelCell);
    
    ChannelNameCell = ChannelNameCellCell{i};
    GR{i}.ChannelNames = ChannelNameCell;
    
    GR{i}.Axes.Color = [.953 .871 .733];
    GR{i}.Axes.Units = 'Normalized';
    GR{i}.Axes.Position = AxesPosition{i};
    GR{i}.Axes.XLimMode = 'Auto';  % 'Auto' or 'Manual'
    GR{i}.Axes.YLimMode = 'Auto';  % 'Auto' or 'Manual'
    
    if length(LineLabelCell) == 1
        GR{i}.Axes.YLabel.String = LineLabelCell{1};
    else
        GR{i}.Axes.YLabel.String = {''};
    end
    
    % Default line
    GR{i}.Data.DisplayString = LineLabelCell;
    
    GR{i}.AssociateWith = [];
    %     GR{i}.LinkAxes = {'x'};
end


% Define here Full path to directory for WEB Page
%         Extra.ImageDir.pc =  Fig.\\Als-filer\alswebdata\mainpage\';
%         Extra.ImageDir.fs =  '/home/als2/www/htdoc/dynamic_pages/incoming/mainpage/';
if ispc
    Extra.Image.Filename = '\\Als-filer\alswebdata\mainpage\Scope1';
else
    Extra.Image.Filename = '/home/als2/www/htdoc/dynamic_pages/incoming/mainpage/Scope1';
end
Extra.Image.Write = 'Off';   % On or Off






function GR = getdefaultaxes(LineLabelCell)

colorOrder = [
    0            0            .8      %  1 BLUE
    0            .8           0       %  2 GREEN (dark .5)
    1            0            0       %  3 RED
    0            1            1       %  4 CYAN
    1            0            1       %  5 MAGENTA (pale)
    1            1            0       %  6 YELLOW (pale)
    0            0            0       %  7 BLACK
    0            0.75         0.75    %  8 TURQUOISE
    0            1.0          0       %  9 GREEN (pale)
    0.75         0.75         0       % 10 YELLOW (dark)
    1            0.50         0.25    % 11 ORANGE
    0.75         0            0.75    % 12 MAGENTA (dark)
    0.7          0.7          0.7     % 13 GREY
    0.8          0.7          0.6     % 14 BROWN (pale)
    0.6          0.5          0.4 ];  % 15 BROWN (dark)

%StyleOrder = {'-','-.','--',':'};

for i = 1:length(LineLabelCell)
    GR.Style = 'axes';
    
    GR.Data.DisplayString{i,1} = LineLabelCell{i};
    GR.Data.Gain{i,1} = 1;
    GR.Data.Offset{i,1} = 0;
    GR.Data.XGain{i,1} = 1;  % Usually time scaling of x-axes {Default: 1 -> seconds}
    GR.Data.XOffset{i,1} = 0;
    
    GR.Line.Color{i,1} = colorOrder(rem(i-1,15)+1,:);
    GR.Line.LineStyle{i,1} = '-';   % Matlab default: '-'
    GR.Line.LineWidth{i,1} = 2;    % Matlab default: .5
    GR.Line.Marker{i,1} = 'None';   % Matlab default: 'None'
    GR.Line.MarkerSize{i,1} = 6;    % Matlab default: 6
end
%GR.Axes.DrawMode = 'fast';
GR.Axes.Box = 'On';
GR.Axes.Units = 'Normalized';
%GR.Axes.XTickLabel = [];
GR.Axes.XGrid = 'On';
GR.Axes.YGrid = 'On';

%GR.Axes.HandleVisibility = 'Off';   % Zoom doesn't work if off???

GR.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
%GR.Axes.XLabel.Units = 'Normalized';   % This doesn't draw properly for some reason

GR.Axes.YLimMode = 'Auto';     % 'Auto' or 'Manual'
if length(LineLabelCell) == 1
    GR.Axes.YLabel.String = LineLabelCell{1};
else
    GR.Axes.YLabel.String = '';
end
GR.Axes.YLabel.Units = 'Normalized';

GR.Axes.YLabel.Color = [0 0 1];
GR.Axes.TickDir = 'In';  % In or Out

GR.AssociateWith = [];
