
%% Get adc data

Prefix = {
    'SR01C{BPM:2}'
  %  'SR01C{BPM:4}'    
    'SR01C{BPM:7}'
    'SR01C{BPM:8}'
    'SR02C{BPM:2}'
    'SR02C{BPM:7}'
    'SR03C{BPM:2}'
    'SR03C{BPM:7}'
    'SR03C{BPM:8}'
    'SR04C{BPM:1}'
    'SR04C{BPM:2}'
    'SR04C{BPM:7}'
    'SR04C{BPM:8}'
    'SR05C{BPM:1}'
    'SR05C{BPM:2}'
    'SR05C{BPM:7}'
    'SR05C{BPM:8}'
    'SR06C{BPM:1}'
    'SR06C{BPM:2}'
    'SR06C{BPM:7}'
    'SR06C{BPM:8}'
    'SR07C{BPM:1}'
    'SR07C{BPM:2}'
    'SR07C{BPM:7}'
    'SR07C{BPM:8}'
    'SR08C{BPM:1}'
    'SR08C{BPM:2}'
    'SR08C{BPM:7}'
    'SR08C{BPM:8}'
    'SR09C{BPM:1}'
    'SR09C{BPM:2}'
    'SR09C{BPM:7}'
    'SR09C{BPM:8}'
    'SR10C{BPM:1}'
    'SR10C{BPM:2}'
    'SR10C{BPM:7}'
    'SR10C{BPM:8}'
    'SR11C{BPM:1}'
    'SR11C{BPM:2}'
    'SR11C{BPM:7}'
    'SR11C{BPM:8}'
    'SR12C{BPM:1}'
    'SR12C{BPM:2}'
    'SR12C{BPM:7}'
    };

for i = 1:length(Prefix)    
    % Manual trigger
    setpvonline([Prefix{i},'Trig:Strig-SP'], 1);
end
pause(4);

TurnsPerFFT = 160;
FigNum = 1;


for i = 1:length(Prefix)
    setappdata(0, 'EPICS_BPM_PREFIX', Prefix{i});
    fprintf('  %3d.  Gettting data for %s\n', i, Prefix{i});
        
    
    BCM = getbcm('all');
    ENV = bpm_getenv;
    
    ENV.RF0   = getrf;                % RF frequency [MHz],       like 499.6432
    ENV.Fs    = 77 * ENV.RF0 / 328;  % Sampling frequency [MHz], like 117.2931
    [ENV.DCCT, tmp, ENV.DataTime] = getdcct;
    ENV.Clock = clock;
    ENV.Fs    =  77 * ENV.RF0 / 328;       % Sampling frequency [MHz], like 117.2931
    
   
    % Get the ADC buffer
        TP = Inf;
        nget =  0;
        while TP > .01
            nget = nget + 1;
            if nget > 1
                fprintf('Getting ADC again (%d).  It looks unlocked or an un-continguous waveform.\n', nget);
                drawnow;
            end
            ADC = bpm_getadc(Prefix{i},'ManualTrigger');
            
            %setpvonline([Prefix{i},'DDR:WfmSel-SP'], 1);
            %setpvonline([Prefix{i},'Trig:Strig-SP'], 1);
            %pause(4);
            %TBT = bpm_gettbt(Prefix{i},'ManualTrigger');
            %
            %setpvonline([Prefix{i},'DDR:WfmSel-SP'], 2);
            %setpvonline([Prefix{i},'Trig:Strig-SP'], 1);
            %pause(4);
            %FA  = bpm_getfa(Prefix{i},'ManualTrigger');
            
            % PSD input setup
            Setup.Attn = ENV.afe.attn;
            Setup.Xgain = 16.13;  % Arc BPM
            Setup.Ygain = 16.29;  % Arc BPM
            Setup.PSD.Nfft = 77 * TurnsPerFFT;  % 77*150
            Setup.PSD.NaveMax = 200                                    ;
            Setup.PSD.WindowFlag = 0;
            Setup.PSD.Shift = 36;
            Setup.PSD.FigNum = FigNum;
            
            Setup.PT.State = 0;           % Pilot tone on (1) or off (0)
            Setup.PT.Attn = 127;
            Setup.PT.FrequencyCode = '0.0';

            PSD = bpm_adc2psd(ADC, Setup, ENV);  % PSD
            
            % Test point
            TP = sqrt(PSD.Paa(PSD.nHarmTP) * PSD.T1);

            RF = sqrt(PSD.Paa(PSD.nHarmOrbit) * PSD.T1);
        end
    
    
    %FileName = appendtimestamp(Prefix{i},TimeStampStart);
    FileName = Prefix{i};
    FileName(strfind(FileName,'{')) = [];
    FileName(strfind(FileName,'}')) = [];
    FileName(strfind(FileName,':')) = [];
   %FileName = sprintf('%s_ADC_Set%d', FileName, 3);
   %FileName = sprintf('%s_ADC_4Bunch_Set%d', FileName, 1);
    FileName = sprintf('%s_ADC_1Bunch_11mA_Set%d', FileName, 1);
    save(FileName);
    
end


fprintf('   Done.\n');



return




%% Get data 1
BCM = getbcm('all');

ENV = bpm_getenv;
ADC = bpm_getadc('','ManualTrigger');

ENV.RF0   = getrf;                % RF frequency [MHz],       like 499.6432
ENV.Fs    = 77 * ENV.RF0 / 328;  % Sampling frequency [MHz], like 117.2931
[ENV.DCCT, tmp, ENV.DataTime] = getdcct;
%ENV.DCCT = 1.2345;  %ENV.DCCT - DCCT0;

%FileName = sprintf('BPM6p2_ADC_Set%d',i);
%save(FileName);


%% plot data 
%FileName = 'BPM6p2_ADC_Set29';
%load(FileName);

FigNum = 101;

TurnsPerFFT = 1;

Setup.PSD.Nfft = 77 * TurnsPerFFT;  % 77*150
Setup.PSD.NaveMax = 100;
Setup.PSD.WindowFlag = 0;
Setup.PSD.Shift = 0;
Setup.PSD.FigNum = FigNum;

% x,y calculation setup
%Setup.xy.nHarmOrbit = 15:26;
Setup.xy.nHarmOrbit = 21;
Setup.xy.NTurnsPerFFT = TurnsPerFFT; 
Setup.xy.NAvg = 1;
Setup.xy.NPoints = 10000; %77 * 100000;  % *11 *7
Setup.xy.NAdvance = 77;  %1*77;  % 7 11 77;   % in ADC counts
Setup.xy.Shift = 0;
Setup.xy.FigNum = Setup.PSD.FigNum + 3;

Setup.Attn = ENV.afe.attn;
%Setup.Attn = 0;
Setup.Xgain = 16.13;  % Arc   ENV.setup.kx
Setup.Ygain = 16.29;  % Arc   ENV.setup.ky

Setup.PT.State = 0;           % Pilot tone on (1) or off (0)
Setup.PT.Attn = 127;
Setup.PT.FrequencyCode = '';

%Setup.FileName = FileName;


PSD   = bpm_adc2psd(ADC, Setup, ENV);  % PSD
Orbit = bpm_adc2xy( ADC, Setup, ENV);  % Orbit
drawnow

%end

