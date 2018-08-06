function [GR, ScopeTypeCell] = apex_waveforms_setup(ScopeType)
%APEX_WAVEFORM_SETUP - Setup function for Ztec scopes and other waveforms
%

% Note
% 1. Max Sample Rates - 500 MHz for the ZT4210 series
%                       400 MHz for the ZT4440 series

ScopeTypeCell = {
    'Photo Diode'
  %  'Ztec Scope #1'
  %  'Ztec Scope #2'
  %  'Ztec 4611'
  %  'Ztec 4441'
    };


if nargin < 1 || isempty(ScopeType)
    ScopeList = {
        'Photo Diode'
  %      'Ztec Scope #2'
  %      'Ztec 4611'
  %      'Ztec 4441'
        };
    %[ScopeTypeChoice, OKFlag] = listdlg('Name','Scopes','PromptString',{'Waveform choices?'}, 'SelectionMode','single', 'ListString', ScopeList, 'ListSize', [435 350], 'InitialValue', 1);
    %if OKFlag ~= 1
    %    %ScopeTypeChoice = 1;  % Default
    %    GR = [];
    %    ScopeList = [];
    %    return;
    %end
    ScopeTypeChoice = 1;
    ScopeType = ScopeList{ScopeTypeChoice};
end


GR.Figure  = [];
GR.GraphIt = [];
GR.Device  = [];  % Ztec data structure added at the end
GR.Extra   = [];

% Just to make command line launches easier
i = findstr(ScopeType, '_');
ScopeType(i) = ' ';


% Change from defaults
switch ScopeType
    
        case  'Photo Diode'
        fprintf('   Photo Diode\n');
        
        % Ztec 4432
        
        Use4Inputs = true;
        
        Device = ztec_4channel_defaults;
        Device.Name = 'ztec1';
        
        SampleRate = 8000e6;  % Hz
       %SampleRate = 50e3;  % Hz
        
        Device.Setup.setHorzPoints = 10000;
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 10;
        Device.Setup.setInp2Range = 10;
        Device.Setup.setInp3Range = 10;
        Device.Setup.setInp4Range = 10;
        
        %Device.Setup.setInp1Offset = 0;
        %Device.Setup.setInp2Offset = 0;
        %Device.Setup.setInp3Offset = 0;
        %Device.Setup.setInp4Offset = 0;
        
        Device.Setup.setInp1Enable = 1;        % Enables/disable channel
        Device.Setup.setInp2Enable = 0;        % Enables/disable channel
        Device.Setup.setInp3Enable = 1;        % Enables/disable channel
        Device.Setup.setInp4Enable = 0;        % Enables/disable channel
        
        Device.Setup.setInp1Filter = 0;          % Enable/disable 20 MHz input filter
        Device.Setup.setInp2Filter = 0;          % Enable/disable 20 MHz input filter
        Device.Setup.setInp3Filter = 0;          % Enable/disable 20 MHz input filter
        Device.Setup.setInp4Filter = 0;          % Enable/disable 20 MHz input filter
        
        % Output setup
        %Device.Setup.setOutExtEnable = 1;
        %Device.Setup.setOutExtSource = 'CLOC';
        %Device.Setup.setOutExtPulsePer = 1e-6;
        
        Device.Setup.setTrigSource = 'INP3';     % Trigger channel: INP1, INP2, or EXT
        Device.Setup.setTrigLevInp3 = -.3;
        Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setInp3Imped    = 50;
        Device.Setup.setInp4Imped    = 50;
        Device.Setup.setTrigImpedExt = 50;  %1e6;
        
        %Device.Setup.setTrigHoldoff = .5;
        
        
        LineLabel = {
            {'Input 1','Input 3'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp3ScaledWave']}
            };
        
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e9;
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}APEX'};

        GraphIt_GR{1}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-1600 1600];
        
        GraphIt_GR{1}.Data.Gain = {1, 1};
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};        

        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Ztec Scope (4432)'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Input 1 [Volts]'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        
        
        
    case  'Ztec Scope #1'
        fprintf('   Ztec Scope #1\n');
        
        % Ztec 4432
        
        Use4Inputs = true;
        
        Device = ztec_4channel_defaults;
        Device.Name = 'ztec1';
        
        SampleRate = 4000e6;  % Hz
       %SampleRate = 50e3;  % Hz
        
        Device.Setup.setHorzPoints = 10000;
        Device.Setup.setHorzTime   = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 5;
        Device.Setup.setInp2Range = .1;
        Device.Setup.setInp3Range = 10;
        Device.Setup.setInp4Range = 10;
        
        %Device.Setup.setInp1Offset = 0;
        %Device.Setup.setInp2Offset = 0;
        %Device.Setup.setInp3Offset = 0;
        %Device.Setup.setInp4Offset = 0;
        
        Device.Setup.setInp1Enable = 1;        % Enables/disable channel
        Device.Setup.setInp2Enable = 1;        % Enables/disable channel
        Device.Setup.setInp3Enable = 1;        % Enables/disable channel
        Device.Setup.setInp4Enable = 1;        % Enables/disable channel
        
        Device.Setup.setInp1Filter = 1;          % Enable/disable 20 MHz input filter
        Device.Setup.setInp2Filter = 0;          % Enable/disable 20 MHz input filter
        Device.Setup.setInp3Filter = 1;          % Enable/disable 20 MHz input filter
        Device.Setup.setInp4Filter = 1;          % Enable/disable 20 MHz input filter
        
        % Output setup
        Device.Setup.setOutExtEnable = 1;
        Device.Setup.setOutExtSource = 'CLOC';
        Device.Setup.setOutExtPulsePer = 1e-6;
        
        if 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = -.05;
            Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .5;
            Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
        end
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setInp3Imped    = 50;
        Device.Setup.setInp4Imped    = 50;
        Device.Setup.setTrigImpedExt = 50;  %1e6;
        
        %Device.Setup.setTrigHoldoff = .5;
        
        if Use4Inputs
            LineLabel = {
                {'Input 1', 'Input 3'}
                {'Input 2', 'Input 4'}
                };
            
            ChannelNames = {
                {[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp3ScaledWave']}
                {[Device.Name,':Inp2ScaledWave'],[Device.Name,':Inp4ScaledWave']}
                };
        else
            LineLabel = {
                {'Input 1'}
                {'Input 2'}
                };
            
            ChannelNames = {
                {[Device.Name,':Inp1ScaledWave']}
                {[Device.Name,':Inp2ScaledWave']}
                };
        end
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}APEX'};

        GraphIt_GR{1}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-1600 1600];
        
        GraphIt_GR{1}.Data.Gain = {1, 1};
        GraphIt_GR{2}.Data.Gain = {1, 1};
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Ztec Scope (4432)'};

        if Use4Inputs
            GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Input 1 & 3 [Volts]'};
            GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}Input 2 & 4 [Volts]'};
            GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
            GraphIt_GR{2}.Data.XGain = {TimeScaling, TimeScaling};
        else
            GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Input 1 [Volts]'};
            GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}Input 2 [Volts]'};
            GraphIt_GR{1}.Data.XGain = {TimeScaling};
            GraphIt_GR{2}.Data.XGain = {TimeScaling};
        end
        
        %GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        %GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        
    case  'Ztec Scope #2'
        fprintf('   Ztec Scope #2\n');
        
        % ZT4432 Starting up ...
        
        % Ztec 4611
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec';
        
        SampleRate = 2000e6;  % Hz
        
        Device.Setup.setHorzPoints = 1000000;
        Device.Setup.setHorzTime = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 1;
        Device.Setup.setInp2Range = 5;
        
        Device.Setup.setInp1Offset = .2;
        %Device.Setup.setInp2Offset = 0;
        
        Device.Setup.setInp1Enable = 1;        % Enables/disable channel
        Device.Setup.setInp2Enable = 1;        % Enables/disable channel
        
        Device.Setup.setInp1Filter = 1;          % Enable/disable 20 MHz input filter
        Device.Setup.setInp2Filter = 0;          % Enable/disable 20 MHz input filter
        
        % Output setup
        Device.Setup.setOutExtEnable = 1;
        Device.Setup.setOutExtSource = 'CLOC';
        Device.Setup.setOutExtPulsePer = 1e-6;
        
        if 1
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .1;
            Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .5;
            %Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
        end
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setTrigImpedExt = 1e6;
        
        %Device.Setup.setTrigHoldoff = .5;
        
        LineLabel = {
            {'Input 1'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-1600 1600];
        
        GraphIt_GR{1}.Data.Gain = {1};
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Ztec Scope'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Input 1 [Volts]'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        
    case  'Ztec 4441'
        
        fprintf('   Ztec 4441\n');
        
        % Ztec 4441
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec17';
        
        SampleRate = 4000e6;  % Hz
        
        Device.Setup.setHorzPoints = 1000;
        Device.Setup.setHorzTime = Device.Setup.setHorzPoints/SampleRate;
       %Device.Setup.setHorzOffset = 200e-9;  %-3.6e-6;  %.1*Device.Setup.setHorzTime;
        Device.Setup.setHorzOffset = -3.6e-6;  %.1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = .05;
        Device.Setup.setInp2Range = .06;
        
        Device.Setup.setInp1Offset = .0;
        Device.Setup.setInp2Offset = 0;
        
        Device.Setup.setInp1Enable = 1;        % Enables/disable channel
        Device.Setup.setInp2Enable = 1;        % Enables/disable channel
        
        Device.Setup.setInp1Filter = 1;          % Enable/disable 20 MHz input filter
        Device.Setup.setInp2Filter = 0;          % Enable/disable 20 MHz input filter
        
        % Output setup
        %Device.Setup.setOutExtEnable = 1;
        %Device.Setup.setOutExtSource = 'CLOC';
        %Device.Setup.setOutExtPulsePer = 1e-6;
        
        if 0
            Device.Setup.setTrigSource = 'INP2';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = -.07;
            Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = 1;
            Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
        end
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setTrigImpedExt = 50;
        
        %Device.Setup.setTrigHoldoff = .5;
        
        LineLabel = {
            {'Input 1'}
            {'Input 2'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave']}
            {[Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        TimeScaling = 1e9;
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}APEX'};

        GraphIt_GR{1}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-1600 1600];
        
        GraphIt_GR{1}.Data.Gain = {1};
        GraphIt_GR{2}.Data.Gain = {1};
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Ztec Scope'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Input 1 [Volts]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}Input 2 [Volts]'};
        
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling};
        
        
    case  'Ztec 4611'
        
        fprintf('   Ztec 4611\n');
        
        % Ztec 4611
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec';
        
        SampleRate = 4000e6;  % Hz
        
        Device.Setup.setHorzPoints = 1000;
        Device.Setup.setHorzTime = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = 200e-9;  %-3.6e-6;  %.1*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = .1;
        Device.Setup.setInp2Range = .5;
        
        Device.Setup.setInp1Offset = 0;
        Device.Setup.setInp2Offset = 0;
        
        Device.Setup.setInp1Enable = 1;        % Enables/disable channel
        Device.Setup.setInp2Enable = 1;        % Enables/disable channel
        
        Device.Setup.setInp1Filter = 0;          % Enable/disable 20 MHz input filter
        Device.Setup.setInp2Filter = 0;          % Enable/disable 20 MHz input filter
        
        % Output setup
        %Device.Setup.setOutExtEnable = 1;
        %Device.Setup.setOutExtSource = 'CLOC';
        %Device.Setup.setOutExtPulsePer = 1e-6;
        
        if 1
            Device.Setup.setTrigSource = 'INP2';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = -.07;
            Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = 1;
            Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
        end
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setTrigImpedExt = 50;
        
        %Device.Setup.setTrigHoldoff = .5;
        
        LineLabel = {
            {'Input 1'}
            {'Input 2'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave']}
            {[Device.Name,':Inp2ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        TimeScaling = 1e9;
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}APEX'};

        GraphIt_GR{1}.Axes.XLimMode = 'Auto';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-1600 1600];
        
        GraphIt_GR{1}.Data.Gain = {1};
        GraphIt_GR{2}.Data.Gain = {1};
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Ztec Scope'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Input 1 [Volts]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}Input 2 [Volts]'};
        
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [nanoseconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling};
        
    
    case  'Ztec Scope #1b'
        fprintf('   Ztec Scope #1\n');
        
        % Ztec 4432
        % Max sample rate: 250 MHz per channel, 500 MHz interleaved (ch 1 or 2 and 3 or 4)
        
        Device = ztec_4channel_defaults;
        Device.Name = 'ztec1';
        
        SampleRate = 2*250e6;  % Hz
        
        Device.Setup.setHorzPoints = 10000;
        Device.Setup.setHorzTime = Device.Setup.setHorzPoints/SampleRate;
        Device.Setup.setHorzOffset = .2*Device.Setup.setHorzTime;
        
        Device.Setup.setInp1Range = 5;
        Device.Setup.setInp2Range = .1;
        Device.Setup.setInp3Range = .1;
        Device.Setup.setInp4Range = .1;
        
        %Device.Setup.setInp1Offset = 0;
        %Device.Setup.setInp2Offset = 0;
        %Device.Setup.setInp3Offset = 0;
        %Device.Setup.setInp4Offset = 0;
        
        Device.Setup.setInp1Enable = 1;        % Enables/disable channel
        Device.Setup.setInp2Enable = 0;        % Enables/disable channel
        Device.Setup.setInp3Enable = 1;        % Enables/disable channel
        Device.Setup.setInp4Enable = 0;        % Enables/disable channel
        
        %Device.Setup.setInp1Filter = 1;          % Enable/disable 20 MHz input filter
        %Device.Setup.setInp2Filter = 1;          % Enable/disable 20 MHz input filter
        %Device.Setup.setInp3Filter = 1;          % Enable/disable 20 MHz input filter
        %Device.Setup.setInp4Filter = 1;          % Enable/disable 20 MHz input filter
        
        % Output setup
        Device.Setup.setOutExtEnable = 1;
        Device.Setup.setOutExtSource = 'CLOC';
        Device.Setup.setOutExtPulsePer = 1e-6;
        
        if 1
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .5;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .5;
            %Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
        end
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setInp3Imped    = 50;
        Device.Setup.setInp4Imped    = 50;
        Device.Setup.setTrigImpedExt = 1e6;
        
        %Device.Setup.setTrigHoldoff = .5;
        
        LineLabel = {
            {'Input 1', 'Input 3'}
            {'Input 2', 'Input 4'}
            };
        
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'],[Device.Name,':Inp3ScaledWave']}
            {[Device.Name,':Inp2ScaledWave'],[Device.Name,':Inp4ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(2, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{1}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{1}.Axes.YLim = [-1600 1600];
        
        GraphIt_GR{2}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{2}.Axes.XLim = TimeScaling*[-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
        GraphIt_GR{2}.Axes.YLimMode = 'Auto';   % 'Auto' or 'Manual'
        %GraphIt_GR{2}.Axes.YLim = [-2000 3000];
        
        GraphIt_GR{1}.Data.Gain = {1, 1};
        GraphIt_GR{2}.Data.Gain = {1, 1};
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Ztec Scope'};
        
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Input 1 & 3 [Volts]'};
        GraphIt_GR{2}.Axes.YLabel.String = {'\fontsize{14}Input 2 & 4 [Volts]'};
        
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        GraphIt_GR{2}.Axes.XLabel.String = {'\fontsize{14}Time [\museconds]'};
        
        GraphIt_GR{1}.Data.XGain = {TimeScaling, TimeScaling};
        GraphIt_GR{2}.Data.XGain = {TimeScaling, TimeScaling};
        
                
    case 'SR Bumps'
        fprintf('   SR Bumps\n');
        
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
        
        if 0
            Device.Setup.setTrigSource = 'INP1';     % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = .3;
        else
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = .5;
            %Device.Setup.setTrigSlope  = 'NEG';      % Trigger Slope: 'POS' or 'NEG'
        end
        
        Device.Setup.setInp1Imped    = 50;
        Device.Setup.setInp2Imped    = 50;
        Device.Setup.setInp3Imped    = 50;
        Device.Setup.setInp4Imped    = 50;
        Device.Setup.setTrigImpedExt = 1e6;
        
        %Device.Setup.setTrigHoldoff  = .5;
        
        LineLabel = {
            {'SR Bump 1', 'SR Bump 2', 'SR Bump 3', 'SR Bump 4'}
            };
        ChannelNames = {
            {[Device.Name,':Inp1ScaledWave'], [Device.Name,':Inp2ScaledWave'], [Device.Name,':Inp3ScaledWave'], [Device.Name,':Inp4ScaledWave']}
            };
        
        [GraphIt_GR, GraphIt_Fig, GraphIt_Extra] = graphit_setup(1, LineLabel, ChannelNames);
        
        TimeScaling = 1e6;
        GraphIt_GR{1}.Axes.XLimMode = 'Manual';   % 'Auto' or 'Manual'
        GraphIt_GR{1}.Axes.XLim = TimeScaling * [-1*Device.Setup.setHorzOffset Device.Setup.setHorzTime-Device.Setup.setHorzOffset];
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
        
        
    case 'Booster ICT'
        fprintf('   Setup for the Booster ICT\n');
        
        Device = ztec_2channel_defaults;
        Device.Name = 'ztec2';
        
        Device.Setup.setAcqType = 'PDET';        % Peak detect will return the max or min of 10 samples / time
        
        Device.Setup.setHorzPoints = 25000;
        Device.Setup.setHorzTime   = .5;
        
        Device.Setup.setInp1Imped    = 1e6;
        Device.Setup.setInp2Imped    = 1e6;
        Device.Setup.setTrigImpedExt = 1e6;
        
        if 1
            % Trigger on ICT
            Device.Setup.setTrigSource  = 'INP1';    % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevInp1 = -.025;
            Device.Setup.setHorzOffset = .02;
        else
            % External trigger
            % 1. Presently connected to the waveform trigger (same as the mini-IOCs and power supply controllers).
            % 2. The BPM gate trigger (like the Libera) is about 15 ms delayed from the waveform trigger.
            Device.Setup.setTrigSource = 'EXT';      % Trigger channel: INP1, INP2, or EXT
            Device.Setup.setTrigLevExt = 1;
            
            %Device.Setup.setTrigSource = 'INP2';    % Trigger channel: INP1, INP2, or EXT
            %Device.Setup.setTrigLevInp1 = 1;
            
            Device.Setup.setTrigSlope  = 'POS';      % Trigger Slope: 'POS' or 'NEG'
            
            Device.Setup.setHorzOffset = 0;
        end
        
        Device.Setup.setInp1Range = 1;
        
        Device.Setup.setInp1Filter = 1;          % Enable/disable 20 MHz input filter
        
        %Device.Setup.setTrigHoldoff = .5;
        
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
        GraphIt_GR{1}.Axes.YLim = [-.01 .4];
        
        GraphIt_GR{1}.Axes.Title.String  = {'\fontsize{14}Booster ICT'};
        GraphIt_GR{1}.Axes.YLabel.String = {'\fontsize{14}Booster ICT [Volts]'};
        GraphIt_GR{1}.Axes.XLabel.String = {'\fontsize{14}Time [milliseconds]'};
        
        GraphIt_GR{1}.Data.Gain{1} = -1;
        GraphIt_GR{1}.Data.XGain = {TimeScaling};
        
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
Device.Setup.setOutCoerce = 1;

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
Device.Setup.setTrigHoldoff = 0;  % Was .5


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
    
    GR.Line.Color{i,1} = colorOrder(rem(i-1,15)+1,:);
    GR.Line.LineStyle{i,1} = '-';   % Matlab default: '-'
    GR.Line.LineWidth{i,1} = 2;    % Matlab default: .5
    GR.Line.Marker{i,1} = 'None';   % Matlab default: 'None'
    GR.Line.MarkerSize{i,1} = 6;    % Matlab default: 6
end
GR.Axes.DrawMode = 'fast';
GR.Axes.Box = 'On';
GR.Axes.Units = 'Normalized';
%GR.Axes.XTickLabel = [];
GR.Axes.XGrid = 'On';
GR.Axes.YGrid = 'On';

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
