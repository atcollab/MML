function TBT = bpm_gettbt(Prefix, N, FigNum)

% Turns to remove?  Base on the sum signal
Noffset = 0;


if nargin < 1 || isempty(Prefix)
    %Prefix = 'SR01C:BPM4';
    Prefix = [];
end
if nargin < 2
    N = [];
end
if nargin < 3
    FigNum = 0;
end

if ischar(Prefix)
    for i = 1:size(Prefix,1)
        TBT{i} = bpm_gettbt1(deblank(Prefix(i,:)), N, Noffset, FigNum);
    end
elseif iscell(Prefix)
    for i = 1:length(Prefix)
        TBT{i,1} = bpm_gettbt1(Prefix{i}, N, Noffset, FigNum);
    end
else
    % DeviceList input
    DeviceList = Prefix;
    Prefix =  getfamilydata('BPM','BaseName', DeviceList);
    for i = 1:length(Prefix)
        TBT{i,1} = bpm_gettbt1(Prefix{i}, N, Noffset, FigNum);
    end
end

% Remove cell for single BPMs???
if iscell(TBT) && length(TBT)==1
    TBT = TBT{1};
end


function TBT = bpm_gettbt1(Prefix, N, Noffset, FigNum)

% Comes from a where for the different geometrys
% Kx = 16*1e6;
% Ky = 16*1e6;
% Kq = 1e6;
[Kx, Ky, Kq] = bpm_getgain(Prefix);
Kx = 1e6 * Kx;
Ky = 1e6 * Ky;
Kq = 1e6 * Kq;


% Maximum number of point in waveform  (or check the .NORD field)   (TBT max 50k (~5 second)
if nargin < 2 || isempty(N)
    TBT.N = getpvonline([Prefix,':wfr:TBT:acqCount']);
else
    TBT.N = N;
end

% Timestamp is at the trigger
TBT.PreTriggerCount = getpvonline([Prefix,':wfr:TBT:pretrigCount']);

% A=c3  B=c1  C=c2  D=c0
% [TBT.A, t, TsA] = getpvonline([Prefix,':wfr:TBT:c3'],'waveform', TBT.N + Noffset);
% [TBT.B, t, TsB] = getpvonline([Prefix,':wfr:TBT:c1'],'waveform', TBT.N + Noffset);
% [TBT.C, t, TsC] = getpvonline([Prefix,':wfr:TBT:c2'],'waveform', TBT.N + Noffset);
% [TBT.D, t, TsD] = getpvonline([Prefix,':wfr:TBT:c0'],'waveform', TBT.N + Noffset);

[TBT.X, t, TBT.TsA] = getpvonline([Prefix,':wfr:TBT:X'],'waveform', TBT.N + Noffset);
[TBT.Y, t, TBT.TsB] = getpvonline([Prefix,':wfr:TBT:Y'],'waveform', TBT.N + Noffset);
[TBT.Q, t, TBT.TsC] = getpvonline([Prefix,':wfr:TBT:Q'],'waveform', TBT.N + Noffset);
[TBT.S, t, TBT.TsD] = getpvonline([Prefix,':wfr:TBT:S'],'waveform', TBT.N + Noffset);
TBT.Ts = linktime2datenum([TBT.TsA; TBT.TsB; TBT.TsC; TBT.TsD]);
TBT.TsStr  = datestr(TBT.Ts, 'yyyy-mm-dd HH:MM:SS.FFF');

TBT.X = TBT.X';
TBT.Y = TBT.Y';
TBT.Q = TBT.Q';
TBT.S = TBT.S';

TBT.A = (+TBT.X/Kx+TBT.Y/Ky+TBT.Q/Kq+1).*TBT.S/4;
TBT.B = (-TBT.X/Kx+TBT.Y/Ky-TBT.Q/Kq+1).*TBT.S/4;
TBT.C = (-TBT.X/Kx-TBT.Y/Ky+TBT.Q/Kq+1).*TBT.S/4;
TBT.D = (+TBT.X/Kx-TBT.Y/Ky-TBT.Q/Kq+1).*TBT.S/4;


% Scale x, y to mm
TBT.X = TBT.X(Noffset+1:end) / 1e6;
TBT.Y = TBT.Y(Noffset+1:end) / 1e6;
%TBT.Q = TBT.Q / 1e6;

TBT.Q = TBT.Q(Noffset+1:end);
TBT.S = TBT.S(Noffset+1:end);

TBT.A = TBT.A(Noffset+1:end);
TBT.B = TBT.B(Noffset+1:end);
TBT.C = TBT.C(Noffset+1:end);
TBT.D = TBT.D(Noffset+1:end);

% Extra
TBT.Prefix = Prefix;
TBT.ADCfs = getpvonline([Prefix,':AFE:adcRate'], 'double');

 %fprintf('   %2d.  (%s)  (%s)  (%s)  (%s)   local %s\n', i, datestr(TBT.Ts(1),31), datestr(TBT.Ts(2),31), datestr(TBT.Ts(3),31), datestr(TBT.Ts(4),31), datestr(now,31));

% Arc BPM gain factors on a curved section Bergoz card are X: 0.1613 V/% and Y: 0.1629 V/%
% Xgain = 16.13;  % Setup.Xgain;  % 16.13;  % Arc
% Ygain = 16.29;  % Setup.Ygain;  % 16.29;  % Arc
%
% TBT.s = TBT.A + TBT.B + TBT.C + TBT.D;
% TBT.X = Xgain * (TBT.A - TBT.B - TBT.C + TBT.D ) ./ TBT.s;  % mm
% TBT.Y = Ygain * (TBT.A + TBT.B - TBT.C - TBT.D ) ./ TBT.s;  % mm

if ~isempty(FigNum) && FigNum
    FontSize = 12;

    %n = (length(TBT.A)-2*77):length(TBT.A);
    n = 1:length(TBT.A);

    figure(FigNum+0);
    clf reset
    h = subplot(3,1,1);
    plot(TBT.X(n));
    ylabel('Horizontal [mm]', 'FontSize', FontSize);
    title(sprintf('%s  std=%.3f \\mum   peak-to-peak = %.3f \\mum',TBT.Prefix, 1000*std(TBT.X),1000*(max(TBT.X)-min(TBT.X))), 'FontSize', FontSize);
    axis tight
    
    h(2) = subplot(3,1,2);
    plot(TBT.Y(n));
    ylabel('Vertical [mm]', 'FontSize', FontSize);
    title(sprintf('std=%.3f \\mum   peak-to-peak = %.3f \\mum',1000*std(TBT.Y),1000*(max(TBT.Y)-min(TBT.Y))), 'FontSize', FontSize);
    axis tight
    
    h(3) = subplot(3,1,3);
    plot(TBT.S(n));
    ylabel('SUM', 'FontSize', FontSize);
    %title(sprintf('std=%.3f \\mum   peak-to-peak = %.3f \\mum',1000*std(TBT.Y),1000*(max(TBT.Y)-min(TBT.Y))), 'FontSize', FontSize);
    axis tight

    
    figure(FigNum+1);
    clf reset
    %plot([TBT.A(n)  TBT.B(n)  TBT.C(n)  TBT.D(n)]);
    plot([TBT.A(n)-mean(TBT.A(n))  TBT.B(n)-mean(TBT.B(n))  TBT.C(n)-mean(TBT.C(n))   TBT.D(n)-mean(TBT.D(n))]);
    hold on
    plot(TBT.C(n)-mean(TBT.C(n)), 'r');
    %axis tight;
    a = axis;
    % A=c3  B=c1  C=c2  D=c0
    legend(sprintf('A = c3  m=%10.0f  s=%.0f',mean(TBT.A(n)),std(TBT.A(n))), sprintf('B = c1  m=%10.0f  s=%.0f',mean(TBT.B(n)),std(TBT.B(n))), sprintf('C = c2  m=%10.0f  s=%.0f',mean(TBT.C(n)),std(TBT.C(n))),  sprintf('D = c0  m=%10.0f  s=%.0f',mean(TBT.D(n)),std(TBT.D(n))));
    title([Prefix,':wfr:TBT'], 'FontSize', FontSize);
    
    figure(FigNum+2);
    clf reset
    subplot(2,2,1);
    plot(TBT.A(n));
    ylabel('TBT A', 'FontSize', FontSize);
    %axis(a);
    
    subplot(2,2,2);
    plot(TBT.B(n));
    ylabel('TBT B', 'FontSize', FontSize);
    %axis(a);
    
    subplot(2,2,3);
    plot(TBT.C(n));
    ylabel('TBT C', 'FontSize', FontSize);
    %axis(a);
    
    subplot(2,2,4);
    plot(TBT.D(n));
    ylabel('TBT D', 'FontSize', FontSize);
    %axis(a);
    
    linkaxes(h, 'x');
end
