function ENV = bpm_getenv(Prefix)

if nargin < 1 || isempty(Prefix)
    Prefix = [];  %'SR01C:BPM4';
end

if ischar(Prefix)
    ENV = bpm_getenv1(Prefix);
elseif iscell(Prefix)
    for i = 1:length(Prefix)
        ENV{i,1} = bpm_getenv1(Prefix{i});
    end
else
    % DeviceList input
    DeviceList = Prefix;
    Prefix =  getfamilydata('BPM','BaseName', DeviceList);
    for i = 1:length(Prefix)
        ENV{i,1} = bpm_getenv1(Prefix{i});
    end
end

% Remove cell for single BPMs???
if iscell(ENV) && length(ENV)==1
    ENV = ENV{1};
end



function ENV = bpm_getenv1(Prefix)

% Comes from a where for the different geometrys
% Kx = 16*1e6;
% Ky = 16*1e6;
% Kq = 1e6;
[ENV.DFE.Kx , ENV.DFE.Ky, ENV.DFE.Kq] = bpm_getgain(Prefix);

% PT setup with change in the future
%ENV.PT.Select = getpvonline([Prefix,':pilotToneSelect'], 'char');

%  I-Q synchronous demodulation (single line of discrete Fourier transform).
ENV.Calc.Method = getpvonline([Prefix,':buttonDSP']);  % 0->I-Q  1->RMS

if~isempty(strfind(Prefix,'Test')) || ~isempty(strfind(Prefix,'SR')) || ~isempty(strfind(Prefix,'bpmTest'))
    ENV.Machine.Type = 'SR';
    ENV.Calc.Type = 'Ring';
    ENV.Calc.SelfTrigger = 0;
    ENV.Calc.N = 77;   % Number of points in an orbit calculation
    
    %ENV.PT.Attn = 127;
    %ENV.PT.FrequencyCode = '+3.5';  % '-1/2';
    ENV.PT.AutoTrimEnable    = getpvonline([Prefix,':autotrim:enable']);
    ENV.PT.AutoTrimStatus    = getpvonline([Prefix,':autotrim:status']);
    ENV.PT.AutoTrimThreshold = getpvonline([Prefix,':autotrim:threshold']);
    ENV.PT.State = getpvonline([Prefix,':autotrim:status'], 'double');  % For backward compatibility
    if getpvonline([Prefix,':ADC0:ptLoMag']) > ENV.PT.AutoTrimThreshold
        ENV.PT.StateLow = 1;
    else
        ENV.PT.StateLow = 0;
    end
    if getpvonline([Prefix,':ADC0:ptLoMag']) > ENV.PT.AutoTrimThreshold
        ENV.PT.StateHigh = 1;
    else
        ENV.PT.StateHigh = 0;
    end
    
elseif ~isempty(strfind(Prefix,'BR'))
    ENV.Machine.Type = 'BR';
    ENV.Calc.Type = 'Ring';
    ENV.Calc.SelfTrigger = 0;
    ENV.Calc.N = 29;   % Number of points in an orbit calculation
    ENV.PT = [];
    
elseif ~isempty(strfind(Prefix,'ALS')) || ~isempty(strfind(Prefix,'BPM')) || ~isempty(strfind(Prefix,'GTL')) || ~isempty(strfind(Prefix,'LN')) || ~isempty(strfind(Prefix,'LTB')) || ~isempty(strfind(Prefix,'LTB')) || ~isempty(strfind(Prefix,'BTS'))
    ENV.Machine.Type = 'TransportLine';
    ENV.Calc.Type = 'Transport';
    ENV.Calc.SelfTrigger = 1;
    ENV.Calc.N = 300;  %77;  %100;   % ???  Number of points in an orbit calculation  Actually 77 with an offset from the trigger
    ENV.PT = [];
else
    error(sprintf('%s is an unknown accelerator type (edit bpm_getenv to add)!!!', Prefix));
end

ENV.Calc.SelfTriggerLevel = getpvonline([Prefix,':selfTrigger:level']);

% Orbit clock add to the LSB of the ADC waveform
ENV.ADC.OrbitClockLSB = getpvonline([Prefix,':wfr:ADC:DataMode'], 'double');

ENV.ADC.Gain = getpvonline([Prefix,':adcGain']);  % 0->1  1->1.5

ENV.ADC.GainTrim(1,1) = getpvonline([Prefix,':ADC0:gainTrim']);
ENV.ADC.GainTrim(2,1) = getpvonline([Prefix,':ADC1:gainTrim']);
ENV.ADC.GainTrim(3,1) = getpvonline([Prefix,':ADC2:gainTrim']);
ENV.ADC.GainTrim(4,1) = getpvonline([Prefix,':ADC3:gainTrim']);

ENV.ADC.GainTrim(1,1) = getpvonline([Prefix,':ADC0:gainFactor']);
ENV.ADC.GainTrim(2,1) = getpvonline([Prefix,':ADC1:gainFactor']);
ENV.ADC.GainTrim(3,1) = getpvonline([Prefix,':ADC2:gainFactor']);
ENV.ADC.GainTrim(4,1) = getpvonline([Prefix,':ADC3:gainFactor']);

ENV.ADC.Clip(1,1) = getpvonline([Prefix,':ADC0:clip'], 'double');
ENV.ADC.Clip(2,1) = getpvonline([Prefix,':ADC1:clip'], 'double');
ENV.ADC.Clip(3,1) = getpvonline([Prefix,':ADC2:clip'], 'double');
ENV.ADC.Clip(4,1) = getpvonline([Prefix,':ADC3:clip'], 'double');

ENV.AFE.Attenuation = getpvonline([Prefix,':attenuation']);  % dB

ENV.AFE.Temperature(1,1) = getpvonline([Prefix,':AFE:0:temperature']);
ENV.AFE.Temperature(2,1) = getpvonline([Prefix,':AFE:1:temperature']);
ENV.AFE.Temperature(3,1) = getpvonline([Prefix,':AFE:2:temperature']);
ENV.AFE.Temperature(4,1) = getpvonline([Prefix,':AFE:3:temperature']);
ENV.AFE.Temperature(5,1) = getpvonline([Prefix,':AFE:4:temperature']);
ENV.AFE.Temperature(6,1) = getpvonline([Prefix,':AFE:5:temperature']);
ENV.AFE.Temperature(7,1) = getpvonline([Prefix,':AFE:6:temperature']);
ENV.AFE.Temperature(8,1) = getpvonline([Prefix,':AFE:7:temperature']);

ENV.DFE.Temperature(1,1) = getpvonline([Prefix,':DFE:0:temperature']);
ENV.DFE.Temperature(2,1) = getpvonline([Prefix,':DFE:1:temperature']);
ENV.DFE.Temperature(3,1) = getpvonline([Prefix,':DFE:2:temperature']);
ENV.DFE.Temperature(4,1) = getpvonline([Prefix,':DFE:3:temperature']);

ENV.DFE.FPGA             = getpvonline([Prefix,':FPGA:temperature']);
ENV.DFE.FanSpeed         = getpvonline([Prefix,':DFE:fanRPM']);
ENV.DFE.Voltage.Board    = getpvonline([Prefix,':DFE:boardV']);
ENV.DFE.Voltage.FPGACore = getpvonline([Prefix,':FPGA:coreV']);
ENV.DFE.Voltage.FPGAAux  = getpvonline([Prefix,':FPGA:auxV']);

ENV.AFE.Voltage(1,1) = getpvonline([Prefix,':AFE:supply:V0']);
ENV.AFE.Voltage(2,1) = getpvonline([Prefix,':AFE:supply:V1']);
ENV.AFE.Voltage(3,1) = getpvonline([Prefix,':AFE:supply:V2']);

ENV.AFE.Current(1,1) = getpvonline([Prefix,':AFE:supply:I0']);
ENV.AFE.Current(2,1) = getpvonline([Prefix,':AFE:supply:I1']);
ENV.AFE.Current(3,1) = getpvonline([Prefix,':AFE:supply:I2']);

ENV.SFP.Temperature(1,1) = getpvonline([Prefix,':SFP0:temperature']);
ENV.SFP.Temperature(2,1) = getpvonline([Prefix,':SFP1:temperature']);
ENV.SFP.Temperature(3,1) = getpvonline([Prefix,':SFP2:temperature']);

ENV.SFP.Power(1,1) = getpvonline([Prefix,':SFP0:rxPower']);
ENV.SFP.Power(2,1) = getpvonline([Prefix,':SFP1:rxPower']);
ENV.SFP.Power(3,1) = getpvonline([Prefix,':SFP2:rxPower']);

ENV.Clock.ADCClkDelay = getpvonline([Prefix,':AFE:adcClkDelay']);  % ???
ENV.Clock.ADCRate     = getpvonline([Prefix,':AFE:adcRate']);
ENV.Clock.AFERef      = getpvonline([Prefix,':EVR:AFEref:sync']);
ENV.Clock.PLLStatus   = getpvonline([Prefix,':AFE:pllStatus']);
ENV.Clock.FASync      = getpvonline([Prefix,':EVR:FA:sync']);
ENV.Clock.SASync      = getpvonline([Prefix,':EVR:SA:sync']);
ENV.Clock.LOSync      = getpvonline([Prefix,':EVR:LO:sync']);


% Not the BPM but very convenient to put here (doesn't work in bldg 46)
ENV.Machine.Clock  = getrf;  % BROC???               % RF frequency [MHz],       like 499.6432
%%ENV.Machine.ADCRate =  77 * ENV.Machine.Clock / 328;    % Sampling frequency [MHz], like 117.2931
ENV.Machine.DCCT = getdcct;
%ENV.wfr.softTrigger = getpvonline([Prefix,':wfr:softTrigger']);

ENV.ADC.LossOfBeamThreshold = getpvonline([Prefix,':lossOfBeamThreshold']);

ENV.ADC.N = getpvonline([Prefix,':wfr:ADC:acqCount']);
ENV.TBT.N = getpvonline([Prefix,':wfr:TBT:acqCount']);
ENV.FA.N  = getpvonline([Prefix,':wfr:FA:acqCount']);

ENV.ADC.PreTriggerCount = getpvonline([Prefix,':wfr:ADC:pretrigCount']);
ENV.TBT.PreTriggerCount = getpvonline([Prefix,':wfr:TBT:pretrigCount']);
ENV.FA.PreTriggerCount  = getpvonline([Prefix,':wfr:FA:pretrigCount']);

ENV.EVR.Delay0 = getpvonline([Prefix,':EVR:delay0']);   % ADC delay for from heart beat EVT ???
ENV.EVR.Delay0 = getpvonline([Prefix,':EVR:delay1']);   % ADC delay for self-trigger
ENV.EVR.Delay4 = getpvonline([Prefix,':EVR:delay4']);
ENV.EVR.Delay5 = getpvonline([Prefix,':EVR:delay5']);
ENV.EVR.Delay6 = getpvonline([Prefix,':EVR:delay6']);
ENV.EVR.Delay7 = getpvonline([Prefix,':EVR:delay7']);

% Version info
ENV.Rev.Firmware = getpvonline([Prefix,':firmwareRev']);
ENV.Rev.Software = getpvonline([Prefix,':softwareRev']);

% Extra
ENV.Prefix = Prefix;


