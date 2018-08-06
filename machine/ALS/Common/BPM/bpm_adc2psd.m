function [PSD, Setup] = bpm_adc2psd(ADC, ENV, Setup)
%
%
% EXAMPLES
% 1. Check all BPM power spectrums
%     bpm_trigger;
%     ADC = bpm_getadc;
%     ENV = bpm_getenv;
%     for i = 1:length(ADC); bpm_adc2psd(ADCC{i}, ENVC{i}, 101); pause; end

% ADC waveform limit 2^21 = 2097152
%

%  Written by Greg Portmann

Delay0Offset = NaN;
HoldFlag = 0;

% PSD setup
SetupDefault.PSD.NaveMax = 350;
SetupDefault.PSD.WindowFlag = 0;
SetupDefault.PSD.FigNum = 6001;
SetupDefault.FileName = '';
% SetupDefault.DCCT = NaN;
% SetupDefault.LocalTime = now;

% Backward compatibility
if ~isfield(ADC, 'Min')
    ADC.A = ADC.cha;
    ADC.B = ADC.chb;
    ADC.C = ADC.chc;
    ADC.D = ADC.chd;
    ADC.Min = [min(ADC.A) min(ADC.B) min(ADC.C) min(ADC.D)];
    ADC.Max = [max(ADC.A) max(ADC.B) max(ADC.C) max(ADC.D)];
    ADC.TsStr = datestr(ENV.DataTime, 31);
end
if ~isfield(ENV, 'Machine')
    ENV.Machine.Type = 'SR';
    ENV.Calc.N = 77;
    ENV.Machine.Clock = ENV.RF0;  %499.6436499;
    ENV.Calc.Type = 'Ring';
    ENV.ADC.OrbitClockLSB = 0;
    ENV.AFE.Attenuation = NaN;
    ENV.Machine.DCCT = ENV.DCCT;
end
if strcmpi(ENV.Machine.Type, 'TransportLine')
    % Transport line
    TurnsPerFFT = 1;
    %TurnsPerFFT = 160;   % For calibrating with a PT
    %fprintf('   Using %d turns per FFT eventhough it''s a TL BPM for calibration reasons (bpm_adc2psd).\n',TurnsPerFFT);
    SetupDefault.PSD.Shift = 0;
elseif strcmpi(ENV.Machine.Type, 'BR')
    % Booster
    TurnsPerFFT = 400;
   %SetupDefault.PSD.Shift = 29*100;  %3870;  % 3870 if you need to shift to injection
   %SetupDefault.PSD.Shift = 1e5;  % If injection triggered
    SetupDefault.PSD.Shift = 1e4;  % If self triggered
elseif strcmpi(ENV.Machine.Type, 'SR')
    % Storage ring
    TurnsPerFFT = 160;
    SetupDefault.PSD.Shift = 0;
end

SetupDefault.PSD.Nfft = ENV.Calc.N * TurnsPerFFT;

    
if nargin == 0
    % Prompt for a file or just get the data ???
    error('Need an input file');
else
    if ischar(ADC)
        load(ADC);
    end
end
if nargin < 3 || isempty(Setup)
    % Measure setup
    Setup = SetupDefault;
elseif isstruct(Setup)
    % Ok
elseif isscalar(Setup)
    FigNum = Setup;
    Setup = SetupDefault;
    Setup.PSD.FigNum = FigNum;
end


% Old variable format
if isfield(ADC, 'cha')
    ADC.A = ADC.cha;
    ADC.B = ADC.chb;
    ADC.C = ADC.chc;
    ADC.D = ADC.chd;
end

N          = Setup.PSD.Nfft;
NaveMax    = Setup.PSD.NaveMax;
WindowFlag = Setup.PSD.WindowFlag;
Shift      = Setup.PSD.Shift;
FigNum     = Setup.PSD.FigNum;
FontSize   = 12;

%RF = 499.63945326e6;
%RF = ENV.Machine.Clock * 1e6;
%RF = ENV.Machine.ADCRate*328/77 * 1e6;
RF = ADC.ADCfs*328/77  * 1e6;

Fs = 77 * RF / 328;    % Sampling frequency [Hz]
%Fs =  ENV.Clock.ADCRate * 1e6;  %77 * RF / 328;    % Sampling frequency [Hz]
T1 = 1/Fs;              % Sampling period [seconds]
Rev = 328/RF;           % Revolution period [seconds]  ~656e-9
Nturn = round(Rev/T1);  % Samples per revolution (ALS: 77)

T  = T1 * N;
f0 = 1 / (N*T1);

Nfreq = ceil(N/2);
f = (0:Nfreq-1)*Fs/N;

%fprintf('   RF   =  %f MHz (RF-4*Fs = %f MHz)\n', RF/1e6, (RF-4*Fs)/1e6);
%fprintf('   Fs   =  %f MHz (%f nsec)\n', Fs/1e6, 1e9/Fs);
%if exist('DCCT','var')
%    fprintf('   DCCT =  %f mA\n', DCCT);
%end

ADC.A = ADC.A((1+Shift):end);
ADC.B = ADC.B((1+Shift):end);
ADC.C = ADC.C((1+Shift):end);
ADC.D = ADC.D((1+Shift):end);


if FigNum    
    if ~isfield(ADC, 'Prefix')
        ADC.Prefix = '';
    end

    if strcmpi(ENV.Calc.Type, 'Transport')
        N_plot = ENV.Calc.N;
    else
        N_plot = ENV.Calc.N * 2;
    end
    if length(ADC.A) < N_plot
        N_plot = length(ADC.A);
    end
    
    if ENV.ADC.OrbitClockLSB
        % The orbit clock info in embedded in the LSB of the ADC data
        b = zeros(N_plot,4);
        for i = 1:N_plot  %length(ADC.A)
            a = dec2bin(abs(ADC.A(i)));
            if a(end) == '1'
                b(i,1) = 1;
            end
            a = dec2bin(abs(ADC.B(i)));
            if a(end) == '1'
                b(i,2) = 1;
            end
            a = dec2bin(abs(ADC.C(i)));
            if a(end) == '1'
                b(i,3) = 1;
            end
            a = dec2bin(abs(ADC.D(i)));
            if a(end) == '1'
                b(i,4) = 1;
            end
            %a(end) = '0';
            %ADC.A(i) = bin2dec(a);
        end
        %iMarker = min(find(b(1:N_plot,2)>0))
    end
    
    
    %FigNum = FigNum + 1;
    figure(FigNum);
    clf reset
    %subplot(2,1,1);
    
    plot((1:N_plot), ADC.A(1:N_plot), 'b');
    hold on
    plot((1:N_plot), ADC.B(1:N_plot), 'g');
    plot((1:N_plot), ADC.C(1:N_plot), 'r');
    plot((1:N_plot), ADC.D(1:N_plot), 'c');
    a = axis;
    axis([0 N_plot a(3:4)]);
    xlabel('ADC Sample Number [~8.526 nsec/sample]', 'FontSize', FontSize);
    ylabel('ADC [Counts]', 'FontSize', FontSize);
    title(sprintf('%s ADC Data  (min=%d, max=%d, Attn=%d, %.2f mA)', ADC.Prefix, ADC.Min, ADC.Max, ENV.AFE.Attenuation, ENV.Machine.DCCT(1)), 'interpreter',' none', 'FontSize', FontSize);

    if ENV.ADC.OrbitClockLSB
        % A is Use This Sample
        % B is Latch Line
        % C is Load Line
        plot(1:N_plot, .9*a(4)*b(1:N_plot,1:3),'.-k');
        
        i = find(b(1:N_plot,2) > .5);
        aa = abs(ADC.A(i(1):i(2)+1));
        aa = aa(1:end-1) + aa(2:end);
        [ADCmin, imin] = min(aa);
        T = imin+i(1)-1 - i(1);
        Delay0Offset = T;
        addlabel(1,0,sprintf('   %d samples (%.1f nsec) from orbit clock to min ADC\n', T, 1000*T/ENV.Clock.ADCRate));
    end

    addlabel(0,0,sprintf('%s  ',ADC.TsStr(1,:)));

    %subplot(2,1,2);
    %plot((length(ADC.A)-N_plot:length(ADC.A)), ADC.A(length(ADC.A)-N_plot:length(ADC.A)), 'b');
    %hold on
    %plot((length(ADC.B)-N_plot:length(ADC.B)), ADC.B(length(ADC.B)-N_plot:length(ADC.B)), 'g');
    %plot((length(ADC.C)-N_plot:length(ADC.C)), ADC.C(length(ADC.C)-N_plot:length(ADC.C)), 'r');
    %plot((length(ADC.D)-N_plot:length(ADC.D)), ADC.D(length(ADC.D)-N_plot:length(ADC.D)), 'c');
    %a = axis;
    %axis([length(ADC.A)-N_plot length(ADC.A) a(3:4)]);
    %xlabel('ADC Sample Number [~8.526 nsec/sample]', 'FontSize', FontSize);
    %ylabel('ADC [Counts]', 'FontSize', FontSize);
    %title('ADC Data', 'interpreter',' none', 'FontSize', FontSize);

    
%     FigNum = FigNum + 1;
%     figure(FigNum);
%     clf reset
%     %BinNum = -100:1:100;
%     %BinNum =  1000;
%     BinNum = -2^15:1:2^15;
% 
%     subplot(2,2,1);
%     hist(ADC.A, BinNum);
%     xlabel('Channel A [Counts]', 'FontSize', FontSize);
%    % xaxis([-50 50]+mean(ADC.A));
%     
%     subplot(2,2,2);
%     hist(ADC.B, BinNum);
%     xlabel('Channel B [Counts]', 'FontSize', FontSize);
%    % xaxis([-50 50]+mean(ADC.B));
%     
%     subplot(2,2,3);
%     hist(ADC.C, BinNum);
%     xlabel('Channel C [Counts]', 'FontSize', FontSize);
%    % xaxis([-50 50]+mean(ADC.C));
%     
%     subplot(2,2,4);
%     hist(ADC.D, BinNum);
%     xlabel('Channel D [Counts]', 'FontSize', FontSize);
%    % xaxis([-50 50]+mean(ADC.D));
%        
%     addlabel(.5, 1, 'ADC Histogram', FontSize+2);
    
    drawnow;
end


% a  = fft(Data(1:10000,2)-Data(1,2));
% loglog(10000*(1:10000)/10000,abs(a));

Navg = floor(length(ADC.A)/N);

if Navg > NaveMax
    Navg = NaveMax;
elseif Navg == 0
    error(sprintf('The number of ADC samples (%d) is less than the orbit calculation length (%d) for the %s.', length(ADC.A), N, ENV.Machine.Type));
end

P11Avg = 0;
P22Avg = 0;
P33Avg = 0;
P44Avg = 0;
PssAvg = 0;

% Window function
if WindowFlag
    w = hanning(N);           % hanning window
    w = w(:);
else
    w = ones(N,1);            % no window
end

U = sum(w.^2)/N;              % approximately .375 for hanning
%U2 = ((norm(w)/sum(w))^2);   % used to normalize plots (p. 1-68, matlab DSP toolbox)


for i = 1:Navg
    ii = (1:N)+(i-1)*N;
    
    if 0
        chA = detrend(ADC.A(ii));
        chB = detrend(ADC.B(ii));
        chC = detrend(ADC.C(ii));
        chD = detrend(ADC.D(ii));
        chS = detrend(ADC.A(ii)+ADC.B(ii)+ADC.C(ii)+ADC.D(ii));
    else
        chA = ADC.A(ii);
        chB = ADC.B(ii);
        chC = ADC.C(ii);
        chD = ADC.D(ii);
        chS = ADC.A(ii)+ADC.B(ii)+ADC.C(ii)+ADC.D(ii);
    end
    
    % POWER SPECTRUM    
    a_w = chA .* w;
    A = fft(a_w);
    P11 = A.*conj(A)/N;
    P11 = P11 / U;
    P11(ceil(N/2)+1:N) = [];
    P11(2:ceil(N/2)) = 2*P11(2:ceil(N/2));
    P11(1) = 0;   % Remove DC
    
    a_w = chB .* w;
    A = fft(a_w);
    P22 = A.*conj(A)/N;
    P22 = P22/U;
    P22(ceil(N/2)+1:N) = [];
    P22(2:ceil(N/2)) = 2*P22(2:ceil(N/2));
    P22(1) = 0;   % Remove DC
    
    a_w = chC .* w;
    A = fft(a_w);
    P33 = A.*conj(A)/N;
    P33 = P33/U;
    P33(ceil(N/2)+1:N) = [];
    P33(2:ceil(N/2)) = 2*P33(2:ceil(N/2));
    P33(1) = 0;   % Remove DC
    
    a_w = chD .* w;
    A = fft(a_w);
    P44 = A.*conj(A)/N;
    P44 = P44/U;
    P44(ceil(N/2)+1:N) = [];
    P44(2:ceil(N/2)) = 2*P44(2:ceil(N/2));
    P44(1) = 0;   % Remove DC
    
    a_w = chS .* w;
    A = fft(a_w);
    Pss = A.*conj(A)/N;
    Pss = Pss/U;
    Pss(ceil(N/2)+1:N) = [];
    Pss(2:ceil(N/2)) = 2*Pss(2:ceil(N/2));
    Pss(1) = 0;   % Remove DC
    
    % PSD using matlab functions (NOTE: matlab function detrend by default)
    % PaaS = spectrum(a,N,0,w,f0);
    % PaaS = 2*PaaS(:,1);
    % PaaS(1)=PaaS(1)/2;
    % PaaPSD=2*psd(a,N);
    % PddPSD(1)=PddPSD(1)/2;
    % Pdd(1) = 0;   % not sure if the DC term is correct
    % Pdd1 = Pdd;
    % m = 3;        % not sure if the first couple terms are good
    % for i=1:m
    %    Pdd(i) = 0;
    % end
    
    RMS_11 = sqrt(sum((chA-mean(chA)).^2)/length(chA));
    RMS_22 = sqrt(sum((chB-mean(chB)).^2)/length(chB));
    RMS_33 = sqrt(sum((chC-mean(chC)).^2)/length(chC));
    RMS_44 = sqrt(sum((chD-mean(chD)).^2)/length(chD));
    RMS_ss = sqrt(sum((chS-mean(chS)).^2)/length(chS));
    
    %P11_int = cumsum(P11(end:-1:1))/N;
    %P11_int = P11_int(length(P11_int):-1:1);
    P11_int = cumsum(P11)/N;
    P22_int = cumsum(P22)/N;
    P33_int = cumsum(P33)/N;
    P44_int = cumsum(P44)/N;
    Pss_int = cumsum(Pss)/N;
    
%     fprintf('   chA RMS: %g counts (Time series data)\n', RMS_11);
%     fprintf('   chA RMS: %g counts (PSD, Parseval''s Thm)\n', sqrt(P11_int(end)));
      
%     fprintf('   chB RMS: %g counts (Time series data)\n', RMS_22);
%     fprintf('   chB RMS: %g counts (PSD, Parseval''s Thm)\n\n', sqrt(P22_int(end)));
%     
%     fprintf('   chC RMS: %g counts (Time series data)\n', RMS_33);
%     fprintf('   chC RMS: %g counts (PSD, Parseval''s Thm)\n\n', sqrt(P33_int(end)));
%     
%     fprintf('   chD RMS: %g counts (Time series data)\n', RMS_44);
%     fprintf('   chD RMS: %g counts (PSD, Parseval''s Thm)\n\n', sqrt(P44_int(end)));
%     
%     fprintf('   Sum RMS: %g counts (Time series data)\n', RMS_ss);
%     fprintf('   Sum RMS: %g counts (PSD, Parseval''s Thm)\n\n', sqrt(Pss_int(end)));
    
    P11Avg = P11Avg + P11/Navg;
    P22Avg = P22Avg + P22/Navg;
    P33Avg = P33Avg + P33/Navg;
    P44Avg = P44Avg + P44/Navg;
    PssAvg = PssAvg + Pss/Navg;
end

%fprintf('\n   %d Averaged Power Spectrums\n', Navg);

P11 = P11Avg;
P11_int = cumsum(P11)/N;
%P11_int = cumsum(P11(end:-1:1))/N;
%P11_int = P11_int(length(P11_int):-1:1);
%fprintf('   RMS chA: %g counts (PSD, Parseval''s Thm)\n', sqrt(P11_int(end)));

P22 = P22Avg;
P22_int = cumsum(P22)/N;
%P22_int = cumsum(P22(end:-1:1))/N;
%P22_int = P22_int(length(P22_int):-1:1);
%fprintf('   RMS chB: %g counts (PSD, Parseval''s Thm)\n', sqrt(P22_int(end)));

P33 = P33Avg;
P33_int = cumsum(P33)/N;
%fprintf('   RMS chC: %g counts (PSD, Parseval''s Thm)\n', sqrt(P33_int(end)));

P44 = P44Avg;
P44_int = cumsum(P44)/N;
%fprintf('   RMS chD: %g counts (PSD, Parseval''s Thm)\n', sqrt(P44_int(end)));

Pss = PssAvg;
Pss_int = cumsum(Pss)/N;
%fprintf('   RMS Sum: %g counts (PSD, Parseval''s Thm)\n', sqrt(Pss_int(end)));


% RF index
if exist('RF0','var')
    RF_Alias = RF0*1e6 - 4*Fs;  % ALS
    [tmp, nRF]=min(abs(RF_Alias-f));
else
    RF_Alias = [];
    nRF = [];
end


nHarmRF = 21;

if ~isfield(ENV, 'PT') || isempty(ENV.PT)
    nHarmPT = 21 - .5;
elseif isfield(ENV.PT, 'Select')
    % Old files
    if strcmpi(ENV.PT.Select, 'Low')
        nHarmPT = 21 - .5;
    else
        nHarmPT = 21 + .5;
    end
else
    if ENV.PT.StateHigh
        nHarmPT = 21 + .5;
    else
        nHarmPT = 21 - .5;
    end
end
% if strcmpi(ENV.PT.FrequencyCode, '+1/2')
%     nHarmPT = 21 + .5;
% elseif strcmpi(ENV.PT.FrequencyCode, '-1/2')
%     nHarmPT = 21 - .5;
% elseif strcmpi(ENV.PT.FrequencyCode, '+1/4')
%     nHarmPT = 21 + .25;
% elseif strcmpi(ENV.PT.FrequencyCode, '-1/4')
%     nHarmPT = 21 - .25;
% elseif strcmpi(ENV.PT.FrequencyCode, '+3.5')
%     nHarmPT = 21 + 3.5;
% else
%     nHarmPT = [];
% end


% Test point should be an input
nHarmTP = nHarmRF - 2.75;

nHarm = [];
%if rem(N,Nturn) == 0
    % For equal number of turns, it's a easy to compute
    nHarm = 1:ceil(Nturn/2);
    nHarm = (nHarm-1) .* (N/Nturn) + 1;
    nHarmRF = (nHarmRF-1)*(N/Nturn) + 1;
    nHarmTP = round((nHarmTP-1)*(N/Nturn) + 1);
    
    if rem(N/Nturn,2) == 0
        % even number of turn
        nHarmPT = (nHarmPT-1)*(N/Nturn) + 1;  % 21.5 = 206 for 10 turns, 616 for 30 turns
    else
        nHarmPT = [];
        fprintf('Warning: need a even number of turns for pilot tone index calc.\n');
    end
%end


if FigNum > 0
    % Button voltages
    % Plotting T1*Paa makes the PSD the same units as on the HP Control System Analyzer
    % Ie, you can integrate it visually and get counts^2
    FigNum = FigNum + 1;
    figure(FigNum);
    if ~HoldFlag
        clf reset
    end
    h = subplot(2,1,1);
    if HoldFlag
        hold on
    end

    semilogy(f(2:end)/1e6, T1*[P11(2:end) P22(2:end) P33(2:end) P44(2:end)]);
    xlabel('Frequency [MHz]', 'FontSize', FontSize);
    ylabel('[ADC Counts{^2}/Hz]', 'FontSize', FontSize);
    title(sprintf('%s ADC Power Spectral Density', ADC.Prefix), 'FontSize', FontSize);
    axis tight
    grid on
    %axis([1 5000 1e-6 1e0]);
    
    % ???
%     hold on
%     semilogy(f(nHarmRF)/1e6, T1*[P11(nHarmRF) P22(nHarmRF) P33(nHarmRF) P44(nHarmRF)], 'o');
%     if ~isempty(nHarmPT)
%         semilogy(f(nHarmPT)/1e6, T1*[P11(nHarmPT) P22(nHarmPT) P33(nHarmPT) P44(nHarmPT)], 'or');
%     end
%     semilogy(f(nHarmTP)/1e6, T1*[P11(nHarmTP) P22(nHarmTP) P33(nHarmTP) P44(nHarmTP)], 'ok');
       
    h(2) = subplot(2,1,2);
    if HoldFlag
        hold on
    end
    plot(f/1e6, [P11_int(1:end) P22_int(1:end) P33_int(1:end) P44_int(1:end)]);
    xlabel('Frequency [MHz]', 'FontSize',12);
    ylabel('[ADC Counts {^2}]', 'FontSize',12);
    title(sprintf('\\fontsize{12}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS: chA=%.1f chB=%.1f chC=%.1f chD=%.1f counts)', sqrt(P11_int(end)), sqrt(P22_int(end)), sqrt(P33_int(end)), sqrt(P44_int(end))));
    axis tight
    grid on
    %xaxis([1 5000]);
    
    addlabel(0,0,sprintf('Number of Averages = %d',Navg));
    addlabel(1,0,sprintf('%s  ',ADC.TsStr(1,:)));

    linkaxes(h, 'x');
    
    % Sum signal
    % figure(FigNum+2);
    % clf reset
    % h = subplot(2,1,1);
    % %hold on
    % semilogy(f/1e6, T1*[Pss]);
    % xlabel('Frequency [MHz]', 'FontSize',12);
    % ylabel('[Sum of ADC Counts{^2}/Hz]', 'FontSize',12);
    % title('Channel Sum Power Spectral Density', 'FontSize',12);
    % axis tight
    % grid on
    % %axis([1 5000 1e-6 1e0]);
    %
    % h(2) = subplot(2,1,2);
    % %hold on
    % plot(f/1e6, Pss_int);
    % xlabel('Frequency [MHz]', 'FontSize',12);
    % ylabel('[Sum ADC Counts {^2}]', 'FontSize',12);
    % title(sprintf('\\fontsize{12}Cumulative  \\fontsize{16}\\int \\fontsize{12}PSD df  (RMS = %.1f)', sqrt(Pss_int(end))));
    % axis tight
    % grid on
    % %xaxis([1 5000]);
    %
    % addlabel(1,0,sprintf('Number of Averages = %d  ',Navg));
    %
    % linkaxes(h, 'x');
end


% try
%     fprintf('\n');
%     fprintf('   RF          = %10.6f MHz\n', frf);
%     fprintf('   Fs          = %10.6f MHz\n', Fs /1e6);
%     fprintf('   RF - 4*Fs   = %10.6f MHz\n',(1e6*frf-4*Fs)/1e6);
%     fprintf('   Synch. Freq = %10.6f kHz\n', fsync);
%     fprintf('\n');
% end

PSD.Paa = P11;
PSD.Pbb = P22;
PSD.Pcc = P33;
PSD.Pdd = P44;
PSD.Pss = Pss;
PSD.Paa_int = P11_int;
PSD.Pbb_int = P22_int;
PSD.Pcc_int = P33_int;
PSD.Pdd_int = P44_int;
PSD.Pss_int = Pss_int;
PSD.SamplesPerTurn = Nturn;
PSD.Navg = Navg;
PSD.f = f;
PSD.f0 = f0;
PSD.Fs = Fs;
PSD.T1 = T1;
PSD.TRev = Rev;
PSD.nHarm   = nHarm;
PSD.nHarmOrbit = nHarmRF;
PSD.nHarmPT = nHarmPT;
PSD.nHarmTP = nHarmTP;


% Merit functions???
%sqrt(f0 * P11(nHarmRF) /  P11(nHarmTP))
%sqrt(f0 * P11(nHarmTP))
%sqrt(f0 * P11(nHarmRF))

Setup.Delay0Offset = Delay0Offset;

