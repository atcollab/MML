function Out = bpm_adc2xy(ADC, Setup, ENV) 
% Out = nsls_xy(ADC, Setup, ENV)
%
% Setup.HarmOrbit - nsls_xy uses the RMS as computed by each DFT bin in the HarmOrbit vector
%            1 is DC
%            Full range 2 to 39
%            21 is aliased 500MHz line (RF - 4*Fs = 30.4658 MHz)

FastFlag   =  1;
SaveAllPSD =  0;
DebugFlag  =  0;
PlotTurns  =  0;
FontSize   = 12;

if SaveAllPSD
    FastFlag = 0;
end

PTArms =[];
PTBrms =[];
PTCrms =[];
PTDrms =[];
PTx = []; 
PTy = [];
xcal = [];
ycal = [];


% Arc BPM gain factors on a curved section Bergoz card are X: 0.1613 V/% and Y: 0.1629 V/%
Kx = ENV.DFE.Kx;  % 16.13;  % Arc
Ky = ENV.DFE.Ky;  % 16.29;  % Arc


if nargin == 0
    % Prompt for a file???
    [Filename, Pathname] = uigetfile('*.mat', 'Pick a file');
    load([Pathname Filename]);
else
    if ischar(ADC)
        load(ADC);
        if ~exist('ADC','var') && exist('cha','var')
            ADC.A = cha;
            ADC.B = chb;
            ADC.C = chc;
            ADC.D = chd;
        end
    end
end

% Old variable format
if isfield(ADC, 'cha')
    ADC.A = ADC.cha;
    ADC.B = ADC.chb;
    ADC.C = ADC.chc;
    ADC.D = ADC.chd;
end

PilotTone = 0;
if isfield(Setup, 'PT')
    PilotTone = ENV.PT.State;
    if strcmpi(ENV.PT.FrequencyCode, '+1/2')
        nHarmPT = 21 + .5;
    elseif strcmpi(ENV.PT.FrequencyCode, '-1/2')
        nHarmPT = 21 - .5;
    elseif strcmpi(ENV.PT.FrequencyCode, '+1/4')
        nHarmPT = 21 + .25;
    elseif strcmpi(ENV.PT.FrequencyCode, '-1/4')
        nHarmPT = 21 - .25;
    elseif strcmpi(ENV.PT.FrequencyCode, '+3.5')
        nHarmPT = 21 + 3.5;
    else
        PilotTone = 0;
    end
end
ENV.PT.State = PilotTone;

if isfield(Setup.xy, 'nHarmOrbit')
    nHarmOrbit = Setup.xy.nHarmOrbit;
else
    % RF index
    %RF_Alias = RF0*1e6 - 4*Fs;  % ALS
    %[tmp, nRF]=min(abs(RF_Alias-f));
    nHarmOrbit = 21;
end

if isfield(Setup.xy, 'FigNum')
    FigNum = Setup.xy.FigNum;
else
    if nargout == 0
        FigNum = 1;
    else
        FigNum = 0;
    end
end
FigNum = floor(FigNum);

if isfield(Setup.xy, 'Shift')
    Shift = Setup.xy.Shift;
else
    Shift = [];
end

if isfield(Setup.xy, 'NTurnsPerFFT')
    NTurnsPerFFT = Setup.xy.NTurnsPerFFT;
else
    % # of turns used in the FFT
    NTurnsPerFFT = 1;
end

if isfield(Setup.xy, 'NAvg')
    NAvg = Setup.xy.NAvg;
else
    % # of FFTs to average
    NAvg = 1;
end

if isfield(Setup.xy, 'NAdvance')
    NAdvance = Setup.xy.NAdvance;
else
    % Percent overlap
    NAdvance = 77;
end

if isfield(Setup.xy, 'NPoints')
    NPoints = Setup.xy.NPoints;
else
    NPoints = [];
end


if 0
    % Old way
    %RF = 499.63945326e6;
    RF = ENV.Clock.RF*1e6;
    Fs =  77 * RF / 328;  % Sampling frequency [Hz]
else
    RF = ENV.Machine.Clock * 1e6;
    Fs = ENV.Clock.ADCRate * 1e6;  %77 * RF / 328;    % Sampling frequency [Hz]
end

T1 = 1/Fs;            % Sampling period [seconds]
Rev = 328/RF;         % Revolution period [seconds]  ~656e-9
N = round(Rev/T1);    % Samples per revolution (ALS: 77)

%T  = T1 * N;
%f0 = 1 / (N*T1);

Nfreq = ceil(N*NTurnsPerFFT/2); 
FreqVec = (0:Nfreq-1)*Fs/(N*NTurnsPerFFT)/1e6;

% Harmonic index 
nHarm = 1:ceil(N/2);
%nHarmOrbit = nHarm(low:high);

%  Just for testing -> should include an extra noise floor harmonic line
% Test point should be an input
nHarmTP = nHarmOrbit - .75;

% Expend to multiple turns
nHarm = (nHarm-1) * NTurnsPerFFT + 1;
nHarmOrbit = (nHarmOrbit-1) .* NTurnsPerFFT + 1;

nHarmTP = round((nHarmTP-1) .* NTurnsPerFFT + 1);

%low   =  ( low-1) * NTurnsPerFFT + 1;
%high  =  (high-1) * NTurnsPerFFT + 1;

if PilotTone && rem(NTurnsPerFFT,2)==0
    nHarmPT = (nHarmPT-1) * NTurnsPerFFT + 1;
elseif PilotTone
    fprintf('Warning: Number of turns per FFT must be even when using the pilot tone.');
    PilotTone = 0;
    nHarmPT = -1;
end

if ~PilotTone
    nHarmPT = -1;
end

if FigNum
    fprintf('   RF  =  %f MHz (RF-4*Fs = %f MHz)\n', RF/1e6, (RF-4*Fs)/1e6);
    fprintf('   Fs  =  %f MHz (%f nsec)\n', Fs/1e6, 1e9/Fs);
    fprintf('   Rev =  %f nsec\n', Rev*1e9);
    fprintf('   FFT frequency bin =  %f Hz (%d turns per FFT, %d averages)\n', FreqVec(2)*1e6, NTurnsPerFFT, NAvg);
    fprintf('   %d harmonics within [%f %f] MHz\n', length(nHarmOrbit), FreqVec(nHarmOrbit(1)), FreqVec(nHarmOrbit(end)));
end

if isempty(Shift)
    % Find the offset in the time series
    % chAint = detrend(cumsum(abs(ADC.A)));
    % if chAint(1) > 0
    %     i = find(chAint(2:end)<0);
    %     i = i(1)+1;
    % else
    %     i = find(chAint(2:end)>0);
    %     i = i(1)+1;
    % end
    % Shift = i(1) - 0;
    % if Shift < 1
    %     Shift = Shift + N;
    % end
    Shift = 0;
end

if PilotTone && rem(NTurnsPerFFT,2)
    % Need an even number of turns for the pilot tone
    PilotTone = 0;
end

NTurnsPerADCBuffer = floor((length(ADC.A)-Shift)/N);

% Reduce by the number of extra turns used in the FFT
%NTurnsPerADCBuffer = NTurnsPerADCBuffer - (NTurnsPerFFT-1);

if isempty(NPoints)
    NPoints = NTurnsPerADCBuffer;
    %if NTurnsPerADCBuffer > 13000
    %    NTurnsPerADCBuffer = 13000;
    %end
    %NTurnsPerADCBuffer = 3*150
end


% Compute the Fourier vectors
%   For length N input vector x, the DFT is a length N vector X,
%   with elements
%              N
%      X(k) = sum  x(n)*exp(-j*2*pi*(k-1)*(n-1)/N)  where 1 <= k <= N.
%             n=1
%   c are row vectors, so FFT = c * data(:) is a column vector
NFFT = NTurnsPerFFT*N;
j = sqrt(-1);
h = 0;
for n = nHarmOrbit(:)'
    h = h + 1;
    for k = 1:NFFT
        c(h,k) = exp(-j*2*pi*(k-1)*(n-1)/NFFT);
    end
    
    %A21 = sum(a_w .* c);
    %Paa21 = A21.*conj(A21)/N;
    %Paa21 = 2*Paa21/U;
end
if ENV.PT.State
    h = 0;
    for n = nHarmPT(:)'
        for k = 1:NFFT
            cPT(1,k) = exp(-j*2*pi*(k-1)*(n-1)/NFFT);
        end
    end
end
h = 0;
for n = nHarmTP(:)'
    h = h + 1;
    for k = 1:NFFT
        cTP(h,k) = exp(-j*2*pi*(k-1)*(n-1)/NFFT);
    end
end


% Windowing?
w = 1;
U = 1;


% PSD
i1 = 0;
for i = 1:NPoints
    
%     if NPoints > 5000
%         if i == 1
%             fprintf('\n   Starting a run in bpm_adc2xx\n');
%             fprintf('    0%% done at %s\n', datestr(now));
%         elseif i == round(NPoints/4)
%             fprintf('   25%% done at %s\n', datestr(now));
%         elseif i == round(NPoints/2)
%             fprintf('   50%% done at %s\n', datestr(now));
%         elseif i == round(3*NPoints/4)
%             fprintf('   75%% done at %s\n', datestr(now));
%         end
%     end
    
    if i == 1
        i1 = 1 + Shift;
    else
        i1 = i1 + NAdvance;
    end
    
    i2 = i1 - 1 + NTurnsPerFFT*N;
    NN = i2 - i1 + 1;
    i2 = i2 + (NAvg-1)*NN;
    %N + (NAvg-1)*round(PercentOverLap*N/100)
    
    if i2 > length(ADC.A)
        NPoints = i - 1;
        break
    end
    
    if FastFlag
        PaaAvg = 0;
        PaaPTAvg = 0;
        PaaTPAvg = 0;
        PbbAvg = 0;
        PbbPTAvg = 0;
        PbbTPAvg = 0;
        PccAvg = 0;
        PccPTAvg = 0;
        PccTPAvg = 0;
        PddAvg = 0;
        PddPTAvg = 0;
        PddTPAvg = 0;
        
        %for i = 1:NAvg
            Paa = c * ADC.A(i1:i2);
            Paa = Paa.*conj(Paa)/NFFT;
            Paa = 2*Paa/U;
            PaaAvg = PaaAvg + Paa/NAvg;
            
            Pbb = c * ADC.B(i1:i2);
            Pbb = Pbb.*conj(Pbb)/NFFT;
            Pbb = 2*Pbb/U;
            PbbAvg = PbbAvg + Pbb/NAvg;
            
            Pcc = c * ADC.C(i1:i2);
            Pcc = Pcc.*conj(Pcc)/NFFT;
            Pcc = 2*Pcc/U;
            PccAvg = PccAvg + Pcc/NAvg;
            
            Pdd = c * ADC.D(i1:i2);
            Pdd = Pdd.*conj(Pdd)/NFFT;
            Pdd = 2*Pdd/U;
            PddAvg = PddAvg + Pdd/NAvg;
            
            % Test point
            PaaTP = cTP * ADC.A(i1:i2);
            PaaTP = PaaTP.*conj(PaaTP)/NFFT;
            PaaTP = 2*PaaTP/U;
            PaaTPAvg = PaaTPAvg + PaaTP/NAvg;
            
            PbbTP = cTP * ADC.B(i1:i2);
            PbbTP = PbbTP.*conj(PbbTP)/NFFT;
            PbbTP = 2*PbbTP/U;
            PbbTPAvg = PbbTPAvg + PbbTP/NAvg;
            
            PccTP = cTP * ADC.C(i1:i2);
            PccTP = PccTP.*conj(PccTP)/NFFT;
            PccTP = 2*PccTP/U;
            PccTPAvg = PccTPAvg + PccTP/NAvg;
            
            PddTP = cTP * ADC.D(i1:i2);
            PddTP = PddTP.*conj(PddTP)/NFFT;
            PddTP = 2*PddTP/U;
            PddTPAvg = PddTPAvg + PddTP/NAvg;
            
            if ENV.PT.State
                PaaPT = cPT * ADC.A(i1:i2);
                PaaPT = PaaPT.*conj(PaaPT)/NFFT;
                PaaPT = 2*PaaPT/U;
                PaaPTAvg = PaaPTAvg + PaaPT/NAvg;
                
                PbbPT = cPT * ADC.B(i1:i2);
                PbbPT = PbbPT.*conj(PbbPT)/NFFT;
                PbbPT = 2*PbbPT/U;
                PbbPTAvg = PbbPTAvg + PbbPT/NAvg;
                
                PccPT = cPT * ADC.C(i1:i2);
                PccPT = PccPT.*conj(PccPT)/NFFT;
                PccPT = 2*PccPT/U;
                PccPTAvg = PccPTAvg + PccPT/NAvg;
                
                PddPT = cPT * ADC.D(i1:i2);
                PddPT = PddPT.*conj(PddPT)/NFFT;
                PddPT = 2*PddPT/U;
                PddPTAvg = PddPTAvg + PddPT/NAvg;
            else
                PaaPTAvg = NaN;
                PbbPTAvg = NaN;
                PccPTAvg = NaN;
                PddPTAvg = NaN;
            end
         %end
         
         Arms(1,i)   = sqrt(sum(PaaAvg)/NFFT);
         TPArms(1,i) = sqrt(sum(PaaTPAvg)/NFFT);
         PTArms(1,i) = sqrt(sum(PaaPTAvg)/NFFT);
         
         Brms(1,i)   = sqrt(sum(PbbAvg)/NFFT);
         TPBrms(1,i) = sqrt(sum(PbbTPAvg)/NFFT);
         PTBrms(1,i) = sqrt(sum(PbbPTAvg)/NFFT);
         
         Crms(1,i)   = sqrt(sum(PccAvg)/NFFT);
         TPCrms(1,i) = sqrt(sum(PccTPAvg)/NFFT);
         PTCrms(1,i) = sqrt(sum(PccPTAvg)/NFFT);
         
         Drms(1,i)   = sqrt(sum(PddAvg)/NFFT);
         TPDrms(1,i) = sqrt(sum(PddTPAvg)/NFFT);
         PTDrms(1,i) = sqrt(sum(PddPTAvg)/NFFT);
         % Data_RMS = sqrt(sum((Data-mean(Data)).^2)/length(Data))
         % a_RMS = sqrt(sum((a-mean(a)).^2)/length(a))
         % Paa_RMS_Total = sqrt(sum(Paa)/NFFT)
         
         %Phase = atan2(imag(A(1:ceil(N/2))), real(A(1:ceil(N/2))));

         % Testing
         %[Paa1(:,i), Arms1(1,i), PhaseA1(:,i), PTArms1(1,i)] = nsls_psd(ADC.A(i1:i2), nHarmOrbit, nHarmPT, NAvg);
         %[Pbb1(:,i), Brms1(1,i), PhaseB1(:,i), PTBrms1(1,i)] = nsls_psd(ADC.B(i1:i2), nHarmOrbit, nHarmPT, NAvg);
         %[Pcc1(:,i), Crms1(1,i), PhaseC1(:,i), PTCrms1(1,i)] = nsls_psd(ADC.C(i1:i2), nHarmOrbit, nHarmPT, NAvg);
         %[Pdd1(:,i), Drms1(1,i), PhaseD1(:,i), PTDrms1(1,i)] = nsls_psd(ADC.D(i1:i2), nHarmOrbit, nHarmPT, NAvg);

    else
        
        if SaveAllPSD
            % 1 turn per FFT
            %[Paa(:,i), Arms(1,i), PhaseA(:,i)] = nsls_psd(ADC.A((i-1)*N+1+Shift:i*N+Shift), nHarmOrbit);
            %[Pbb(:,i), Brms(1,i), PhaseB(:,i)] = nsls_psd(ADC.B((i-1)*N+1+Shift:i*N+Shift), nHarmOrbit);
            %[Pcc(:,i), Crms(1,i), PhaseC(:,i)] = nsls_psd(ADC.C((i-1)*N+1+Shift:i*N+Shift), nHarmOrbit);
            %[Pdd(:,i), Drms(1,i), PhaseD(:,i)] = nsls_psd(ADC.D((i-1)*N+1+Shift:i*N+Shift), nHarmOrbit);
            
            [Paa(:,i), Arms(1,i), PhaseA(:,i), PTArms(1,i)] = nsls_psd(ADC.A(i1:i2), nHarmOrbit, nHarmPT, NAvg);
            [Pbb(:,i), Brms(1,i), PhaseB(:,i), PTBrms(1,i)] = nsls_psd(ADC.B(i1:i2), nHarmOrbit, nHarmPT, NAvg);
            [Pcc(:,i), Crms(1,i), PhaseC(:,i), PTCrms(1,i)] = nsls_psd(ADC.C(i1:i2), nHarmOrbit, nHarmPT, NAvg);
            [Pdd(:,i), Drms(1,i), PhaseD(:,i), PTDrms(1,i)] = nsls_psd(ADC.D(i1:i2), nHarmOrbit, nHarmPT, NAvg);
        else
            [Paa, Arms(1,i), PhaseA(:,i), PTArms(1,i)] = nsls_psd(ADC.A(i1:i2), nHarmOrbit, nHarmPT, NAvg);
            [Pbb, Brms(1,i), PhaseB(:,i), PTBrms(1,i)] = nsls_psd(ADC.B(i1:i2), nHarmOrbit, nHarmPT, NAvg);
            [Pcc, Crms(1,i), PhaseC(:,i), PTCrms(1,i)] = nsls_psd(ADC.C(i1:i2), nHarmOrbit, nHarmPT, NAvg);
            [Pdd, Drms(1,i), PhaseD(:,i), PTDrms(1,i)] = nsls_psd(ADC.D(i1:i2), nHarmOrbit, nHarmPT, NAvg);
        end
    end
    
    if Setup.TransportLine
        x(1,i) = Kx * 2 * (-Brms(1,i) + Drms(1,i)) / (Arms(1,i)+Brms(1,i)+Crms(1,i)+Drms(1,i)); % mm
        y(1,i) = Ky * 2 * ( Arms(1,i) - Crms(1,i)) / (Arms(1,i)+Brms(1,i)+Crms(1,i)+Drms(1,i)); % mm
    else
        x(1,i) = Kx * (Arms(1,i)-Brms(1,i)-Crms(1,i)+Drms(1,i)) / (Arms(1,i)+Brms(1,i)+Crms(1,i)+Drms(1,i)); % mm
        y(1,i) = Ky * (Arms(1,i)+Brms(1,i)-Crms(1,i)-Drms(1,i)) / (Arms(1,i)+Brms(1,i)+Crms(1,i)+Drms(1,i)); % mm
    end
        
    TurnNumber(1,i) = (i1-1)/77;

    if PilotTone
        % Just for fun
        if Setup.TransportLine
            PTx(1,i) = Kx * 2 * (-PTBrms(1,i) + PTDrms(1,i)) / (PTArms(1,i)+PTBrms(1,i)+PTCrms(1,i)+PTDrms(1,i)); % mm
            PTy(1,i) = Ky * 2 * ( PTArms(1,i) - PTCrms(1,i)) / (PTArms(1,i)+PTBrms(1,i)+PTCrms(1,i)+PTDrms(1,i)); % mm
        else
            PTx(1,i) = Kx * (PTArms(1,i)-PTBrms(1,i)-PTCrms(1,i)+PTDrms(1,i)) / (PTArms(1,i)+PTBrms(1,i)+PTCrms(1,i)+PTDrms(1,i)); % mm
            PTy(1,i) = Ky * (PTArms(1,i)+PTBrms(1,i)-PTCrms(1,i)-PTDrms(1,i)) / (PTArms(1,i)+PTBrms(1,i)+PTCrms(1,i)+PTDrms(1,i)); % mm
        end
        
        % PT calibration by turn is questionable
        A = Arms(1,i) ;
        B = Brms(1,i) * PTArms(1,i) / PTBrms(1,i);
        C = Crms(1,i) * PTArms(1,i) / PTCrms(1,i);
        D = Drms(1,i) * PTArms(1,i) / PTDrms(1,i);
        
        xcal(1,i) = Kx * (A-B-C+D) / (A+B+C+D); % mm
        ycal(1,i) = Ky * (A+B-C-D) / (A+B+C+D); % mm
    end

    if DebugFlag == 1 && i == 1
        figure(1000);
        clf reset
        semilogy(FreqVec, Paa);
        hold on
        semilogy(FreqVec(nHarmOrbit), Paa(nHarmOrbit), 'o');
        
        if PilotTone
            semilogy(FreqVec(nHarmPT), Paa(nHarmPT), 'x');
        end
        hold off
        drawnow;
    end
end

if NPoints == 0
    error('Not enough points in the ADC for the requiested FFT length and averages.');
end

% if PilotTone
%     PTx = Kx * (PTArms(1,:)-PTBrms(1,:)-PTCrms(1,:)+PTDrms(1,:)) ./ (PTArms(1,:)+PTBrms(1,:)+PTCrms(1,:)+PTDrms(1,:)); % mm
%     PTy = Ky * (PTArms(1,:)+PTBrms(1,:)-PTCrms(1,:)-PTDrms(1,:)) ./ (PTArms(1,:)+PTBrms(1,:)+PTCrms(1,:)+PTDrms(1,:)); % mm
% end


% Build the output 
Out.x = x;
Out.y = y;

Out.xcal = xcal;
Out.ycal = ycal;

Out.Arms = Arms;
Out.Brms = Brms;
Out.Crms = Crms;
Out.Drms = Drms;

Out.Paa = Paa;
Out.Pbb = Pbb;
Out.Pcc = Pcc;
Out.Pdd = Pdd;

Out.f   = FreqVec;

Out.nHarm      = nHarm;
Out.nHarmOrbit = nHarmOrbit;
Out.nHarmPT    = nHarmPT;
Out.nHarmTP    = nHarmTP;

Out.PilotTone = PilotTone;
Out.PTx = PTx;
Out.PTy = PTy;
Out.PTArms = PTArms;
Out.PTBrms = PTBrms;
Out.PTCrms = PTCrms;
Out.PTDrms = PTDrms;

if FastFlag
    Out.TPArms = TPArms;
    Out.TPBrms = TPBrms;
    Out.TPCrms = TPCrms;
    Out.TPDrms = TPDrms;
end
    
Out.TurnNumber = TurnNumber;


if FigNum && SaveAllPSD==0
    bpm_xy_plot(Out, Setup, ENV);
end
