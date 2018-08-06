function Out = bpm_adc2xy_pt(ADC, ENV, Setup) 
% Out = bpm_adc2xy_pt(ADC, ENV, Setup)


% Setup.HarmOrbit - nsls_xy uses the RMS as computed by each DFT bin in the HarmOrbit vector
%            1 is DC
%            Full range 2 to 39
%            21 is aliased 500MHz line (RF - 4*Fs = 30.4658 MHz)

FastFlag   =  1;
SaveAllPSD =  1;
DebugFlag  =  1;

if SaveAllPSD
    FastFlag = 0;
end


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
    end
end


%ENV.PTH.AutoTrimControl %  'Dual PTH'
%ENV.PTH.AutoTrimStatus  %'Double Sided'

%Setup.xy.nHarmOrbit = 15:26;
%Setup.xy.nHarmOrbit = 21;
nHarmOrbit = Setup.xy.nHarmOrbit;
nHarmPTH   = 21 + .5;
nHarmPTL   = 21 - .5;


Shift        = Setup.xy.Shift;
NAvg         = Setup.xy.NAvg;
NAdvance     = Setup.xy.NAdvance;  % Percent overlap
NPoints      = Setup.xy.NPoints;
NTurnsPerFFT = Setup.xy.NTurnsPerFFT;

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

if ~(rem(NTurnsPerFFT,2)==0)
    error('Number of turns per FFT must be 1 or an even number when using the pilot tone.');
end


RF = ENV.Machine.Clock * 1e6;
Fs = ENV.Clock.ADCRate * 1e6;  %77 * RF / 328;    % Sampling frequency [Hz]
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

% Expand to multiple turns
nHarm = (nHarm-1) * NTurnsPerFFT + 1;
nHarmOrbit = (nHarmOrbit - 1) .* NTurnsPerFFT + 1;
nHarmPTH   = (nHarmPTH   - 1) .* NTurnsPerFFT + 1;
nHarmPTL   = (nHarmPTL   - 1) .* NTurnsPerFFT + 1;

%low   =  ( low-1) * NTurnsPerFFT + 1;
%high  =  (high-1) * NTurnsPerFFT + 1;


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


for n = nHarmPTH(:)'
    for k = 1:NFFT
        cPTH(1,k) = exp(-j*2*pi*(k-1)*(n-1)/NFFT);
    end
end

for n = nHarmPTL(:)'
    for k = 1:NFFT
        cPTL(1,k) = exp(-j*2*pi*(k-1)*(n-1)/NFFT);
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
        PaaPTHAvg = 0;
        PaaPTLAvg = 0;
        PbbAvg = 0;
        PbbPTHAvg = 0;
        PbbPTLAvg = 0;
        PccAvg = 0;
        PccPTHAvg = 0;
        PccPTLAvg = 0;
        PddAvg = 0;
        PddPTHAvg = 0;
        PddPTLAvg = 0;
        
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
            PaaPTL = cPTL * ADC.A(i1:i2);
            PaaPTL = PaaPTL.*conj(PaaPTL)/NFFT;
            PaaPTL = 2*PaaPTL/U;
            PaaPTLAvg = PaaPTLAvg + PaaPTL/NAvg;
            
            PbbPTL = cPTL * ADC.B(i1:i2);
            PbbPTL = PbbPTL.*conj(PbbPTL)/NFFT;
            PbbPTL = 2*PbbPTL/U;
            PbbPTLAvg = PbbPTLAvg + PbbPTL/NAvg;
            
            PccPTL = cPTL * ADC.C(i1:i2);
            PccPTL = PccPTL.*conj(PccPTL)/NFFT;
            PccPTL = 2*PccPTL/U;
            PccPTLAvg = PccPTLAvg + PccPTL/NAvg;
            
            PddPTL = cPTL * ADC.D(i1:i2);
            PddPTL = PddPTL.*conj(PddPTL)/NFFT;
            PddPTL = 2*PddPTL/U;
            PddPTLAvg = PddPTLAvg + PddPTL/NAvg;
            
            PaaPTH = cPTH * ADC.A(i1:i2);
            PaaPTH = PaaPTH.*conj(PaaPTH)/NFFT;
            PaaPTH = 2*PaaPTH/U;
            PaaPTHAvg = PaaPTHAvg + PaaPTH/NAvg;
            
            PbbPTH = cPTH * ADC.B(i1:i2);
            PbbPTH = PbbPTH.*conj(PbbPTH)/NFFT;
            PbbPTH = 2*PbbPTH/U;
            PbbPTHAvg = PbbPTHAvg + PbbPTH/NAvg;
            
            PccPTH = cPTH * ADC.C(i1:i2);
            PccPTH = PccPTH.*conj(PccPTH)/NFFT;
            PccPTH = 2*PccPTH/U;
            PccPTHAvg = PccPTHAvg + PccPTH/NAvg;
            
            PddPTH = cPTH * ADC.D(i1:i2);
            PddPTH = PddPTH.*conj(PddPTH)/NFFT;
            PddPTH = 2*PddPTH/U;
            PddPTHAvg = PddPTHAvg + PddPTH/NAvg;
         %end
         
         Arms(1,i)   = sqrt(sum(PaaAvg)/NFFT);
         PTLArms(1,i) = sqrt(sum(PaaPTLAvg)/NFFT);
         PTHArms(1,i) = sqrt(sum(PaaPTHAvg)/NFFT);
         
         Brms(1,i)   = sqrt(sum(PbbAvg)/NFFT);
         PTLBrms(1,i) = sqrt(sum(PbbPTLAvg)/NFFT);
         PTHBrms(1,i) = sqrt(sum(PbbPTHAvg)/NFFT);
         
         Crms(1,i)   = sqrt(sum(PccAvg)/NFFT);
         PTLCrms(1,i) = sqrt(sum(PccPTLAvg)/NFFT);
         PTHCrms(1,i) = sqrt(sum(PccPTHAvg)/NFFT);
         
         Drms(1,i)   = sqrt(sum(PddAvg)/NFFT);
         PTLDrms(1,i) = sqrt(sum(PddPTLAvg)/NFFT);
         PTHDrms(1,i) = sqrt(sum(PddPTHAvg)/NFFT);
         % Data_RMS = sqrt(sum((Data-mean(Data)).^2)/length(Data))
         % a_RMS = sqrt(sum((a-mean(a)).^2)/length(a))
         % Paa_RMS_Total = sqrt(sum(Paa)/NFFT)
         
         %Phase = atan2(imag(A(1:ceil(N/2))), real(A(1:ceil(N/2))));

         % Testing
         %[Paa1(:,i), Arms1(1,i), PhaseA1(:,i), PTHArms1(1,i)] = nsls_psd(ADC.A(i1:i2), nHarmOrbit, nHarmPTH, NAvg);
         %[Pbb1(:,i), Brms1(1,i), PhaseB1(:,i), PTHBrms1(1,i)] = nsls_psd(ADC.B(i1:i2), nHarmOrbit, nHarmPTH, NAvg);
         %[Pcc1(:,i), Crms1(1,i), PhaseC1(:,i), PTHCrms1(1,i)] = nsls_psd(ADC.C(i1:i2), nHarmOrbit, nHarmPTH, NAvg);
         %[Pdd1(:,i), Drms1(1,i), PhaseD1(:,i), PTHDrms1(1,i)] = nsls_psd(ADC.D(i1:i2), nHarmOrbit, nHarmPTH, NAvg);

    else
        if SaveAllPSD
            % 1 turn per FFT
            %[Paa(:,i), Arms(1,i), PhaseA(:,i)] = nsls_psd(ADC.A((i-1)*N+1+Shift:i*N+Shift), nHarmOrbit);
            %[Pbb(:,i), Brms(1,i), PhaseB(:,i)] = nsls_psd(ADC.B((i-1)*N+1+Shift:i*N+Shift), nHarmOrbit);
            %[Pcc(:,i), Crms(1,i), PhaseC(:,i)] = nsls_psd(ADC.C((i-1)*N+1+Shift:i*N+Shift), nHarmOrbit);
            %[Pdd(:,i), Drms(1,i), PhaseD(:,i)] = nsls_psd(ADC.D((i-1)*N+1+Shift:i*N+Shift), nHarmOrbit);
            
            [Paa(:,i), Arms(1,i), PhaseA(:,i), PTHArms(1,i)] = nsls_psd(ADC.A(i1:i2), nHarmOrbit, nHarmPTH, NAvg);
            [Pbb(:,i), Brms(1,i), PhaseB(:,i), PTHBrms(1,i)] = nsls_psd(ADC.B(i1:i2), nHarmOrbit, nHarmPTH, NAvg);
            [Pcc(:,i), Crms(1,i), PhaseC(:,i), PTHCrms(1,i)] = nsls_psd(ADC.C(i1:i2), nHarmOrbit, nHarmPTH, NAvg);
            [Pdd(:,i), Drms(1,i), PhaseD(:,i), PTHDrms(1,i)] = nsls_psd(ADC.D(i1:i2), nHarmOrbit, nHarmPTH, NAvg);
        else
            [Paa, Arms(1,i), PhaseA(:,i), PTHArms(1,i)] = nsls_psd(ADC.A(i1:i2), nHarmOrbit, nHarmPTH, NAvg);
            [Pbb, Brms(1,i), PhaseB(:,i), PTHBrms(1,i)] = nsls_psd(ADC.B(i1:i2), nHarmOrbit, nHarmPTH, NAvg);
            [Pcc, Crms(1,i), PhaseC(:,i), PTHCrms(1,i)] = nsls_psd(ADC.C(i1:i2), nHarmOrbit, nHarmPTH, NAvg);
            [Pdd, Drms(1,i), PhaseD(:,i), PTHDrms(1,i)] = nsls_psd(ADC.D(i1:i2), nHarmOrbit, nHarmPTH, NAvg);
        end
    end
        
    % Orbit
    x(1,i) = Kx * (Arms(1,i)-Brms(1,i)-Crms(1,i)+Drms(1,i)) / (Arms(1,i)+Brms(1,i)+Crms(1,i)+Drms(1,i)); % mm
    y(1,i) = Ky * (Arms(1,i)+Brms(1,i)-Crms(1,i)-Drms(1,i)) / (Arms(1,i)+Brms(1,i)+Crms(1,i)+Drms(1,i)); % mm
    
    % PT orbits
    PTHx(1,i) = Kx * (PTHArms(1,i)-PTHBrms(1,i)-PTHCrms(1,i)+PTHDrms(1,i)) / (PTHArms(1,i)+PTHBrms(1,i)+PTHCrms(1,i)+PTHDrms(1,i)); % mm
    PTHy(1,i) = Ky * (PTHArms(1,i)+PTHBrms(1,i)-PTHCrms(1,i)-PTHDrms(1,i)) / (PTHArms(1,i)+PTHBrms(1,i)+PTHCrms(1,i)+PTHDrms(1,i)); % mm
    
    PTLx(1,i) = Kx * (PTLArms(1,i)-PTLBrms(1,i)-PTLCrms(1,i)+PTLDrms(1,i)) / (PTLArms(1,i)+PTLBrms(1,i)+PTLCrms(1,i)+PTLDrms(1,i)); % mm
    PTLy(1,i) = Ky * (PTLArms(1,i)+PTLBrms(1,i)-PTLCrms(1,i)-PTLDrms(1,i)) / (PTLArms(1,i)+PTLBrms(1,i)+PTLCrms(1,i)+PTLDrms(1,i)); % mm
    
    % TransportLine
    % x(1,i) = Kx * 2 * (-Brms(1,i) + Drms(1,i)) / (Arms(1,i)+Brms(1,i)+Crms(1,i)+Drms(1,i)); % mm
    % y(1,i) = Ky * 2 * ( Arms(1,i) - Crms(1,i)) / (Arms(1,i)+Brms(1,i)+Crms(1,i)+Drms(1,i)); % mm

    TurnNumber(1,i) = (i1-1)/77;
    

    % PT calibration by turn is questionable
    A = Arms(1,i) ;
    B = Brms(1,i) * PTHArms(1,i) / PTHBrms(1,i);
    C = Crms(1,i) * PTHArms(1,i) / PTHCrms(1,i);
    D = Drms(1,i) * PTHArms(1,i) / PTHDrms(1,i);
    
    xcal(1,i) = Kx * (A-B-C+D) / (A+B+C+D); % mm
    ycal(1,i) = Ky * (A+B-C-D) / (A+B+C+D); % mm
    
    if DebugFlag == 1 && i == 1
        figure(1000);
        clf reset
        semilogy(FreqVec, Paa);
        hold on
        semilogy(FreqVec(nHarmOrbit), Paa(nHarmOrbit), 'o');
        semilogy(FreqVec(nHarmPTH), Paa(nHarmPTH), 'x');
        hold off
        drawnow;
    end
end

if NPoints == 0
    error('Not enough points in the ADC for the requiested FFT length and averages.');
end

%     PTHHx = Kx * (PTHHArms(1,:)-PTHHBrms(1,:)-PTHCrms(1,:)+PTHDrms(1,:)) ./ (PTHArms(1,:)+PTHBrms(1,:)+PTHCrms(1,:)+PTHDrms(1,:)); % mm
%     PTHy = Ky * (PTHArms(1,:)+PTHBrms(1,:)-PTHCrms(1,:)-PTHDrms(1,:)) ./ (PTHArms(1,:)+PTHBrms(1,:)+PTHCrms(1,:)+PTHDrms(1,:)); % mm


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
Out.nHarmPTH   = nHarmPTH;
Out.nHarmPTL   = nHarmPTL;

Out.PTHx = PTHx;
Out.PTHy = PTHy;
Out.PTHArms = PTHArms;
Out.PTHBrms = PTHBrms;
Out.PTHCrms = PTHCrms;
Out.PTHDrms = PTHDrms;

Out.PTLArms = PTLArms;
Out.PTLBrms = PTLBrms;
Out.PTLCrms = PTLCrms;
Out.PTLDrms = PTLDrms;

Out.PTLx = PTLx;
Out.PTLy = PTLy;
Out.PTLArms = PTLArms;
Out.PTLBrms = PTLBrms;
Out.PTLCrms = PTLCrms;
Out.PTLDrms = PTLDrms;

Out.PTLArms = PTLArms;
Out.PTLBrms = PTLBrms;
Out.PTLCrms = PTLCrms;
Out.PTLDrms = PTLDrms;

Out.TurnNumber = TurnNumber;


if FigNum && SaveAllPSD==0
    bpm_xy_pt_plot(Out, ENV, Setup);
end
