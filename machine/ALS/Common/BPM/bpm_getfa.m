function FA = bpm_getfa(Prefix, N, FigNum)

if nargin < 1 || isempty(Prefix)
    Prefix = getfamilydata('BPM','BaseName');
    %Prefix = Prefix{1};
end
if nargin < 2
    N = [];
end
if nargin < 3
    FigNum = 0;
end

if ischar(Prefix)
    for i = 1:size(Prefix,1)
        FA{i,1} = bpm_getfa1(deblank(Prefix(i,:)), N, FigNum);
    end
elseif iscell(Prefix)
    for i = 1:length(Prefix)
        FA{i,1} = bpm_getfa1(Prefix{i}, N, FigNum);
    end
else
    % DeviceList input
    DeviceList = Prefix;
    Prefix =  getfamilydata('BPM','BaseName', DeviceList);
    for i = 1:length(Prefix)
        FA{i,1} = bpm_getfa1(Prefix{i}, N, FigNum);
    end
end

% Remove cell for single BPMs???
if iscell(FA) && length(FA)==1
    FA = FA{1};
end


function FA = bpm_getfa1(Prefix, N, FigNum)

% Comes from a where for the different geometrys
% Kx = 16*1e6;
% Ky = 16*1e6;
% Kq = 1e6;
[Kx, Ky, Kq] = bpm_getgain(Prefix);
Kx = 1e6 * Kx;
Ky = 1e6 * Ky;
Kq = 1e6 * Kq;


% Maximum number of point in waveform  (or check the .NORD field)   (FA max 50k (~5 second)
if nargin < 2 || isempty(N)
    FA.N = getpvonline([Prefix,':wfr:FA:acqCount']);
else
    FA.N = N;
end

% Timestamp is at the trigger
FA.PreTriggerCount  = getpvonline([Prefix,':wfr:FA:pretrigCount']);

if 1 % New Firmware    
    %PTSampleRateVec = [10 20 50 100 200 500 1000 2000 5000];
    %FA.PT.RateMBBO  = getpvonline([Prefix,':demodPtTurns'],'double');
    %FA.PT.Rate      = PTSampleRateVec(FA.PT.RateMBBO+1);
    %FA.PT.RfTurns   = getpvonline([Prefix,':demodRfTurns'],'double');
    %FA.PT.SumShift  = getpvonline([Prefix,':demodPtSumShift'],'double');

    FA.TbTSumShift = getpvonline([Prefix,':demodTbtSumShift'],'double');
    FA.MtSumShift  = getpvonline([Prefix,':demodMtSumShift'],'double');
    
    FA.PT.Lo.N = getpvonline([Prefix,':wfr:PL:acqCount']);
    FA.PT.Lo.PreTriggerCount = getpvonline([Prefix,':wfr:PL:pretrigCount']);
    [FA.PT.Lo.A, t, Ts] = getpvonline([Prefix,':wfr:PL:c3'],'waveform', FA.PT.Lo.N);
    [FA.PT.Lo.B, t, Ts] = getpvonline([Prefix,':wfr:PL:c1'],'waveform', FA.PT.Lo.N);
    [FA.PT.Lo.C, t, Ts] = getpvonline([Prefix,':wfr:PL:c2'],'waveform', FA.PT.Lo.N);
    [FA.PT.Lo.D, t, Ts] = getpvonline([Prefix,':wfr:PL:c0'],'waveform', FA.PT.Lo.N);
    
    FA.PT.Hi.N = getpvonline([Prefix,':wfr:PH:acqCount']);
    FA.PT.Hi.PreTriggerCount = getpvonline([Prefix,':wfr:PH:pretrigCount']);
    [FA.PT.Hi.A, t, Ts] = getpvonline([Prefix,':wfr:PH:c3'],'waveform', FA.PT.Hi.N);
    [FA.PT.Hi.B, t, Ts] = getpvonline([Prefix,':wfr:PH:c1'],'waveform', FA.PT.Hi.N);
    [FA.PT.Hi.C, t, Ts] = getpvonline([Prefix,':wfr:PH:c2'],'waveform', FA.PT.Hi.N);
    [FA.PT.Hi.D, t, Ts] = getpvonline([Prefix,':wfr:PH:c0'],'waveform', FA.PT.Hi.N);
    
end

% RF FA is in X, Y, S, Q
% A=c3  B=c1  C=c2  D=c0
%[FA.A, t, TsA] = getpvonline([Prefix,':wfr:FA:c3'],'waveform', FA.N);
%[FA.B, t, TsB] = getpvonline([Prefix,':wfr:FA:c1'],'waveform', FA.N);
%[FA.C, t, TsC] = getpvonline([Prefix,':wfr:FA:c2'],'waveform', FA.N);
%[FA.D, t, TsD] = getpvonline([Prefix,':wfr:FA:c0'],'waveform', FA.N);

[FA.X, t, TsA] = getpvonline([Prefix,':wfr:FA:X'],'waveform', FA.N);
[FA.Y, t, TsB] = getpvonline([Prefix,':wfr:FA:Y'],'waveform', FA.N);
[FA.Q, t, TsC] = getpvonline([Prefix,':wfr:FA:Q'],'waveform', FA.N);
[FA.S, t, TsD] = getpvonline([Prefix,':wfr:FA:S'],'waveform', FA.N);


FA.Ts = linktime2datenum([TsA; TsB; TsC; TsD]);
FA.TsStr = datestr(FA.Ts,  'yyyy-mm-dd HH:MM:SS.FFF');

FA.X = FA.X';
FA.Y = FA.Y';
FA.Q = FA.Q';
FA.S = FA.S';

FA.A = (+FA.X/Kx+FA.Y/Ky+FA.Q/Kq+1).*FA.S/4;
FA.B = (-FA.X/Kx+FA.Y/Ky-FA.Q/Kq+1).*FA.S/4;
FA.C = (-FA.X/Kx-FA.Y/Ky+FA.Q/Kq+1).*FA.S/4;
FA.D = (+FA.X/Kx-FA.Y/Ky-FA.Q/Kq+1).*FA.S/4;


% Scale x, y to mm
FA.X = FA.X / 1e6;
FA.Y = FA.Y / 1e6;
%FA.Q = FA.Q / 1e6;

% Extra
FA.Prefix = Prefix;
 
% The reference clock is 1/4 the ring RF frequency. The reference clock is divided by:
%    82 Storage ring and transport lines
%   125 Booster ring 
% to provide the reference for the AFE PLL which multiplies it by 
%    77 Storage ring or transport lines
%   116 Booster ring
% to produce the ADC sampling clock.  
%   12,464 (82    timing system clocks per turn × 152 turns) for the storage ring (approximately 10.0 kHz)
%   11,875 (31.25 timing system clocks per turn × 380 turns) for the booster ring (approximately 10.5 kHz)
% to produce the fast acquisition marker.

FA.ADCfs = getpvonline([Prefix,':AFE:adcRate'], 'double');
if ~isempty(strfind(Prefix,'BR'))
    FA.fs = FA.ADCfs*1e6 / 29 / 380;
else
    FA.fs = FA.ADCfs*1e6 / 77 / 152;
end


%fprintf('   %2d.  (%s)  (%s)  (%s)  (%s)   local %s\n', i, datestr(FA.Ts(1),31), datestr(FA.Ts(2),31), datestr(FA.Ts(3),31), datestr(FA.Ts(4),31), datestr(now,31));

% Arc BPM gain factors on a curved section Bergoz card are X: 0.1613 V/% and Y: 0.1629 V/%
% Xgain = 16.13;  % Setup.Xgain;  % 16.13;  % Arc
% Ygain = 16.29;  % Setup.Ygain;  % 16.29;  % Arc
%
% FA.s = FA.A + FA.B + FA.C + FA.D;
% FA.X = Xgain * (FA.A - FA.B - FA.C + FA.D ) ./ FA.s;  % mm
% FA.Y = Ygain * (FA.A + FA.B - FA.C - FA.D ) ./ FA.s;  % mm

if ~isempty(FigNum) && FigNum
    FontSize = 12;

    t = 1000*(0:length(FA.X)-1)/FA.fs;
    
    figure(FigNum+0);
    clf reset
    h = subplot(2,1,1);
    plot(t, FA.X);
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('Horizontal [mm]', 'FontSize', FontSize);
    title(sprintf('std=%.3f \\mum   peak-to-peak = %.3f \\mum', 1000*std(FA.X), 1000*(max(FA.X)-min(FA.X))), 'FontSize', FontSize);
    axis tight

    h(2) = subplot(2,1,2);
    plot(t, FA.Y);
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('Vertical [mm]', 'FontSize', FontSize);
    title(sprintf('std=%.3f \\mum   peak-to-peak = %.3f \\mum', 1000*std(FA.Y), 1000*(max(FA.Y)-min(FA.Y))), 'FontSize', FontSize);
    axis tight
    
    figure(FigNum+1);
    clf reset
    plot(t, [FA.A-mean(FA.A) FA.B-mean(FA.B) FA.C-mean(FA.C) FA.D-mean(FA.D)]);
    hold on
    plot(t, FA.C-mean(FA.C), 'r');
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    title([Prefix,':wfr:FA'], 'FontSize', FontSize);
    legend(sprintf('A = c3  m=%10.0f  s=%.0f', mean(FA.A),std(FA.A)), sprintf('B = c1  m=%10.0f  s=%.0f', mean(FA.B), std(FA.B)), sprintf('C = c2  m=%10.0f  s=%.0f', mean(FA.C), std(FA.C)), sprintf('D = c0  m=%10.0f  s=%.0f', mean(FA.D), std(FA.D)));
    %axis tight;
    a = axis;
    
    figure(FigNum+2);
    clf reset
    subplot(2,2,1);
    plot(t, FA.A);
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('FA A', 'FontSize', FontSize);
    %axis(a);
    
    subplot(2,2,2);
    plot(t, FA.B);
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('FA B', 'FontSize', FontSize);
    %axis(a);
    
    subplot(2,2,3);
    plot(t, FA.C);
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('FA C', 'FontSize', FontSize);
    %axis(a);
    
    subplot(2,2,4);
    plot(t, FA.D);
    xlabel('Time [milliseconds]', 'FontSize', FontSize);
    ylabel('FA D', 'FontSize', FontSize);
    %axis(a);
    
    %linkaxes(h, 'x');
end
