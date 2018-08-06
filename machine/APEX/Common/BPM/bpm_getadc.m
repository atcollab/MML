function ADC = bpm_getadc(Prefix, N, FigNum)

if nargin < 1 || isempty(Prefix)
    Prefix = 'SR01C:BPM4';
end
if nargin < 2
    N = [];
end
if nargin < 3
    FigNum = 0;
end

% if nargin < 4
%     TriggerMode = '';
%     if strcmpi(Prefix, 'Software')
%         TriggerMode = 'Software';
%         Prefix = getappdata(0, 'EPICS_BPM_PREFIX');
%     end
% end
% 
% if strcmpi(TriggerMode, 'Software')
%     bpm_softtrigger(Prefix);
% end

if ischar(Prefix)
    for i = 1:size(Prefix,1)
        ADC{i} = bpm_getadc1(deblank(Prefix(i,:)), N, FigNum);
    end
elseif iscell(Prefix)
    for i = 1:length(Prefix)
        ADC{i,1} = bpm_getadc1(Prefix{i}, N, FigNum);
    end
else
    % DeviceList input
    DeviceList = Prefix;
    Prefix =  getfamilydata('BPM','BaseName', DeviceList);
    for i = 1:length(Prefix)
        ADC{i,1} = bpm_getadc1(Prefix{i}, N, FigNum);
    end
end

% Remove cell for single BPMs???
if iscell(ADC) && length(ADC)==1
    ADC = ADC{1};
end


function ADC = bpm_getadc1(Prefix, N, FigNum)

% Comes from a where for the different geometrys
% Kx = 16*1e6;
% Ky = 16*1e6;
% Kq = 1e6;
[Kx, Ky, Kq] = bpm_getgain(Prefix);
Kx = 1e6 * Kx;
Ky = 1e6 * Ky;
Kq = 1e6 * Kq;



% Maximum number of point in waveform  (or check the .NORD field)
if nargin < 2 || isempty(N)
    ADC.N = getpvonline([Prefix,':wfr:ADC:acqCount']);   % 1048576
else
    ADC.N = N;
end

% Timestamp is at the trigger
ADC.PreTriggerCount = getpvonline([Prefix,':wfr:ADC:pretrigCount']);

% A=c3  B=c1  C=c2  D=c0
[ADC.A, t, ADC.TsA] = getpvonline([Prefix,':wfr:ADC:A'],'waveform', ADC.N);
[ADC.B, t, ADC.TsB] = getpvonline([Prefix,':wfr:ADC:B'],'waveform', ADC.N);
[ADC.C, t, ADC.TsC] = getpvonline([Prefix,':wfr:ADC:C'],'waveform', ADC.N);
[ADC.D, t, ADC.TsD] = getpvonline([Prefix,':wfr:ADC:D'],'waveform', ADC.N);
ADC.Ts = linktime2datenum([ADC.TsA; ADC.TsB; ADC.TsC; ADC.TsD]);


ADC.TsStr  = datestr(ADC.Ts, 'yyyy-mm-dd HH:MM:SS.FFF');
ADC.A = ADC.A';
ADC.B = ADC.B';
ADC.C = ADC.C';
ADC.D = ADC.D';

ADC.Max = max([max(ADC.A) max(ADC.B) max(ADC.C) max(ADC.D)]);
ADC.Min = min([min(ADC.A) min(ADC.B) min(ADC.C) min(ADC.D)]);


% Extra
ADC.Prefix = Prefix;
ADC.ADCfs = getpvonline([Prefix,':AFE:adcRate'], 'double');

N_plot =77 * 4;
if length(ADC.A) < N_plot
    N_plot = length(ADC.A);
end

% Orbit clock add to the LSB of the ADC waveform
if strcmpi(Prefix, 'BR3:BPM4') || strcmpi(Prefix, 'BTS:BPM6') % remove after full upgrade
    OrbitClockLSB = getpvonline([Prefix,':wfr:ADC:DataMode'], 'double');
    
    if OrbitClockLSB
        % The orbit clock info in embedded in the LSB of the ADC data
        b = zeros(N_plot,1);
        for i = 1:N_plot  %length(ADC.A)
            a = dec2bin(abs(ADC.B(i)));
            if a(end) == '1'
                b(i,2) = 1;
            end
        end
        ADC.MarkerIndex = min(find(b>0));
    end
end


if FigNum
    n = (length(ADC.A)-N_plot+1):length(ADC.A);
    
    figure(1);
    clf reset
    plot([ADC.A(n) ADC.B(n) ADC.C(n) ADC.D(n)]);
    %axis tight;
    a = axis;
    
    figure(2);
    clf reset
    subplot(2,2,1);
    plot(ADC.A(n));
    ylabel('ADC A');
    axis(a);
    
    subplot(2,2,2);
    plot(ADC.B(n));
    ylabel('ADC B');
    axis(a);
    
    subplot(2,2,3);
    plot(ADC.C(n));
    ylabel('ADC C');
    axis(a);
    
    subplot(2,2,4);
    plot(ADC.D(n));
    ylabel('ADC D');
    axis(a);
    
    
    %figure(3);
    %clf reset
    % subplot(2,1,1);
    %plot([ADC.A(n)-cha0(n)']');
    %ylabel('cha - cha0');
    %
    % subplot(2,1,2);
    % plot([ADC.A(n)-cha(n)]');
    % ylabel('cha2 - cha1');
end
