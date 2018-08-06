function Setup = bpm_calcsetup(Setup, TurnsPerFFT, FigNum)

if nargin  < 2 || isempty(TurnsPerFFT)
    TurnsPerFFT = 160;
end
if nargin  < 3
    FigNum = [];
end

% PSD setup
Shift = 48;

Setup.PSD.Nfft = 77 * TurnsPerFFT;  % 77*150
Setup.PSD.NaveMax = 100;
Setup.PSD.WindowFlag = 0;
Setup.PSD.Shift = Shift;
Setup.PSD.FigNum = FigNum;

% x,y calculation setup
%Setup.xy.nHarmOrbit = 15:26;
Setup.xy.nHarmOrbit = 21;
Setup.xy.NTurnsPerFFT = TurnsPerFFT; 
Setup.xy.NAvg = 1;
Setup.xy.NPoints = 10000; %77 * 100000;  % *11 *7
Setup.xy.NAdvance = 77;  %1*77;  % 7 11 77;   % in ADC counts
Setup.xy.Shift = Shift;
Setup.xy.FigNum = Setup.PSD.FigNum + 3;