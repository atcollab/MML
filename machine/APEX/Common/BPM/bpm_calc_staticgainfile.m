%% Plot

%clear

FigNum = 101;

cd /home/physdata/BPM/AttnCalibration
%FileName = 'SN043_ADC_Calibration4';
FileName = 'SN037_ADC_Calibration2';

load(FileName);

i = 31;



% PSD setup
TurnsPerFFT = 160;
Setup.Attn = ENV{i}.afe.attn;
Setup.PSD.Nfft = 77 * TurnsPerFFT;  % 77*150
Setup.PSD.NaveMax = 350;
Setup.PSD.WindowFlag = 0;
Setup.PSD.Shift = 0;
Setup.PSD.FigNum = FigNum;
Setup.FileName = FileName;

PSD = bpm_adc2psd(ADC{i}, Setup, ENV{i});


% x,y calculation setup
%Setup.xy.nHarmOrbit = 15:26;
Setup.xy.nHarmOrbit = 21;
Setup.xy.NTurnsPerFFT = TurnsPerFFT;  % 150;
Setup.xy.NAvg = 1;
Setup.xy.NPoints = 77 * 100000;  % *11 *7
Setup.xy.NAdvance = 1*77;  % 7 11 77;   % in ADC counts
Setup.xy.FigNum = Setup.PSD.FigNum + 3;
Setup.xy.Shift = 0;

Orbit = bpm_adc2xy(ADC{i}, Setup, ENV{i});


%  x/y PSD
Orbit = bpm_xy2psd(Orbit, Setup, ENV{i});

%save([FileName, '_OrbitCalc'], 'Orbit', 'PSD', 'Setup', 'ENV');

