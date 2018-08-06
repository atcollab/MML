function Out = bpm_adc2xy_2bunch(ADC, Setup, ENV) 
% Out = bpm_adc2xy_2bunch(ADC, Setup, ENV)
%

% Setup.HarmOrbit - uses RMS
%            1 is DC
%            Full range 2 to 39
%            21 is aliased 500MHz line (RF - 4*Fs = 30.4658 MHz)

if isempty(Setup)
    %
    Setup.TransportLine = 0;
    
    % PSD setup
    TurnsPerFFT = .5;
    Setup.PSD.Nfft = 77 * TurnsPerFFT;  % 77*150
    Setup.PSD.NaveMax = 100;
    Setup.PSD.WindowFlag = 0;
    Setup.PSD.Shift = 0;
    Setup.PSD.FigNum = 1;
    
    % x,y calculation setup
    Setup.xy.nHarmOrbit = 15:26;
    %Setup.xy.nHarmOrbit = 21;
    Setup.xy.NTurnsPerFFT = TurnsPerFFT;  % 150;
    Setup.xy.NAvg = 1;
    Setup.xy.NPoints = 77 * 100000;  % *11 *7
    Setup.xy.NAdvance = 1*77;  % 7 11 77;   % in ADC counts
    Setup.xy.Shift = 20;
    Setup.xy.FigNum = Setup.PSD.FigNum + 3;
    Setup.FileName = 'TwoAsymBunches_CTS_Set2';
end

DebugFlag  =  0;
PlotTurns  =  0;
FontSize   = 12;

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
end

PilotTone = 0;
ENV.PT.State = PilotTone;

nHarmOrbit   = Setup.xy.nHarmOrbit; 
FigNum       = Setup.xy.FigNum;
Shift        = Setup.xy.Shift;
NTurnsPerFFT = Setup.xy.NTurnsPerFFT;
NPoints      = Setup.xy.NPoints;
NAdvance     = Setup.xy.NAdvance;

RF = ENV.Machine.Clock * 1e6;
Fs = ENV.Clock.ADCRate * 1e6;  %77 * RF / 328;    % Sampling frequency [Hz]


T1 = 1/Fs;            % Sampling period [seconds]
Rev = 328/RF;         % Revolution period [seconds]  ~656e-9
N = round(Rev/T1);    % Samples per revolution (ALS: 77)

%T  = T1 * N;
%f0 = 1 / (N*T1);

Nfreq = ceil(N*NTurnsPerFFT/2); 
FreqVec = (0:Nfreq-1)*Fs/(N*NTurnsPerFFT)/1e6;

% % Harmonic index 
% nHarm = 1:ceil(N/2);
% %nHarmOrbit = nHarm(low:high);
% 
% %  Just for testing -> should include an extra noise floor harmonic line
% % Test point should be an input
% nHarmTP = nHarmOrbit - .75;
% 
% % Expend to multiple turns
% nHarm = (nHarm-1) * NTurnsPerFFT + 1;
% nHarmOrbit = (nHarmOrbit-1) .* NTurnsPerFFT + 1;
% 
% nHarmTP = round((nHarmTP-1) .* NTurnsPerFFT + 1);
% 
% %low   =  ( low-1) * NTurnsPerFFT + 1;
% %high  =  (high-1) * NTurnsPerFFT + 1;
% 
% if PilotTone && rem(NTurnsPerFFT,2)==0
%     nHarmPT = (nHarmPT-1) * NTurnsPerFFT + 1;
% elseif PilotTone
%     fprintf('Warning: Number of turns per FFT must be even when using the pilot tone.');
%     PilotTone = 0;
%     nHarmPT = -1;
% end
% 
% if ~PilotTone
%     nHarmPT = -1;
% end

if FigNum
    fprintf('   RF  =  %f MHz (RF-4*Fs = %f MHz)\n', RF/1e6, (RF-4*Fs)/1e6);
    fprintf('   Fs  =  %f MHz (%f nsec)\n', Fs/1e6, 1e9/Fs);
    fprintf('   Rev =  %f nsec\n', Rev*1e9);
end


i1 = 0;
for i = 1:NPoints
    
    if i == 1
        i1 = 1 + Shift;
    else
        i1 = i1 + N;
    end
    
    i2 = i1 - 1 + N;
    
    if i2 > length(ADC.A)
        NPoints = i - 1;
        break
    end
    
    Arms = sqrt(sum(ADC.A(i1:i1+38).^2));
    Brms = sqrt(sum(ADC.B(i1:i1+38).^2));
    Crms = sqrt(sum(ADC.C(i1:i1+38).^2));
    Drms = sqrt(sum(ADC.D(i1:i1+38).^2));
    x1(1,i) = Kx * (Arms-Brms-Crms+Drms) / (Arms+Brms+Crms+Drms); % mm
    y1(1,i) = Ky * (Arms+Brms-Crms-Drms) / (Arms+Brms+Crms+Drms); % mm
    Arms1(1,i) = Arms;
    Brms1(1,i) = Brms;
    Crms1(1,i) = Crms;
    Drms1(1,i) = Drms;
    
    Arms   = sqrt(sum(ADC.A(i2-37:i2).^2));
    Brms   = sqrt(sum(ADC.B(i2-37:i2).^2));
    Crms   = sqrt(sum(ADC.C(i2-37:i2).^2));
    Drms   = sqrt(sum(ADC.D(i2-37:i2).^2));
    x2(1,i) = Kx * (Arms-Brms-Crms+Drms) / (Arms+Brms+Crms+Drms); % mm
    y2(1,i) = Ky * (Arms+Brms-Crms-Drms) / (Arms+Brms+Crms+Drms); % mm
    Arms2(1,i) = Arms;
    Brms2(1,i) = Brms;
    Crms2(1,i) = Crms;
    Drms2(1,i) = Drms;
    
    TurnNumber(1,i) = (i1-1)/77;

 
%     if DebugFlag == 1 && i == 1
%         figure(1000);
%         clf reset
%         semilogy(FreqVec, Paa);
%         hold on
%         semilogy(FreqVec(nHarmOrbit), Paa(nHarmOrbit), 'o');
%         
%         if PilotTone
%             semilogy(FreqVec(nHarmPT), Paa(nHarmPT), 'x');
%         end
%         hold off
%         drawnow;
%     end
end

% Build the output 
Out.x1 = x1;
Out.y1 = y1;
Out.x2 = x2;
Out.y2 = y2;

Out.Arms1 = Arms1;
Out.Brms1 = Brms1;
Out.Crms1 = Crms1;
Out.Drms1 = Drms1;

Out.Arms2 = Arms2;
Out.Brms2 = Brms2;
Out.Crms2 = Crms2;
Out.Drms2 = Drms2;

Out.TurnNumber = TurnNumber;


% if FigNum && SaveAllPSD==0
%     bpm_xy_plot(Out, Setup, ENV);
% end
