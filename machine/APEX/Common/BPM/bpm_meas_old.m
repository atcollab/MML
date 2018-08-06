
clear

% Quick PT set
% Max On
%tcp_write_reg(2, 1);
%tcp_write_reg(34, 0);
% Off
%tcp_write_reg(2, 0);
%tcp_write_reg(34, 127);


T = 1*30;            % Time between reads
N = 1; %2*60*10;

Prefix = 'bpmTest:001:';

if 0
    RFAttn = 31;
    FileNamePrefix = sprintf('TestBPM%d_50ohmInputCap_Attn%d', str2num(Prefix(9:11)), RFAttn);
elseif 0
    % Modified (2 Amp) BPM appears to be 8db less (not the expected 14)???
    RFAttn = 14;  % + 8;  % +8 for BPM1
    FileNamePrefix = sprintf('TestBPM%d_500mA_SplitCombine_Attn%d', str2num(Prefix(9:11)), RFAttn);
elseif 1
    % Modified (2 Amp) BPM appears to be 8db less (not the expected 14)???
    % 1 button split
    RFAttn = 7;
    if str2num(Prefix(9:11)) == 1
        RFAttn = RFAttn + 9;  %  +8 for BPM1
    end
    FileNamePrefix = sprintf('TestBPM%d_500mA_Split_Attn%d', str2num(Prefix(9:11)), RFAttn);
end


setappdata(0, 'EPICS_BPM_PREFIX', Prefix);

bpm_setenv(Prefix, RFAttn);


% Pilot tone attenuation .25 dB / unit step  (0-127 -> 0 to 30 dB)
ENV.PT.State = 0;           % Pilot tone on (1) or off (0)
ENV.PT.FrequencyCode = '';
PTAttn =  20;            %  40 for 500mA, Multbunch
PT_Pause = 2;


% The attenuator is different, it takes a while for the change to happen
pause(2);

TurnsPerFFT = 160;


PToff    = 1;
PTminus1 = 0;
PTminus2 = 0;
PTplus1  = 0;
PTplus2  = 0;
PTonRF   = 0;

for i = 1:N
    t1 = clock;
  
    if PToff
        %%%%%%%%%%%
        % Zero PT %
        ENV = bpm_getenv;     
        ENV.Clock.RF  = getrf;                     % RF frequency [MHz],       like 499.6432
       %ENV.Clock.Fs =  77 * ENV.Clock.RF0 / 328;  % Sampling frequency [MHz], like 117.2931
        
        % Set the pilot tone
        %PTtmp = Setup.PT;
        ENV.PT.State = 0;           % Pilot tone on (1) or off (0)
        ENV.PT.Attn = 127;
        ENV.PT.FrequencyCode = '+3.5';  % '-1/2';
        %setpilottone(ENV.PT);
        %pause(PT_Pause);
        
        bpm_softtrigger;
        
        ADC = bpm_getadc(Prefix);
        TBT = bpm_gettbt(Prefix);
        FA  = bpm_getfa(Prefix);        
        BCM = getbcm('all');
        %BCM.DCCT = [];
        %BCM.DCCT_TimeStamp = now;
        
        FileName = sprintf('%s_PTOff_Set%d', FileNamePrefix, i);
        clear tmp ans
        
        % Measure setup
        Setup.DCCT = BCM.DCCT;
        Setup.LocalTime = now;
        
        % PSD setup
        Setup.PSD.Nfft = 77 * TurnsPerFFT;
        Setup.PSD.NaveMax = 350;
        Setup.PSD.WindowFlag = 0;
        Setup.PSD.Shift = 0;
        Setup.PSD.FigNum = 7001;
        Setup.FileName = FileName;
        
        % x,y calculation setup
        %Setup.xy.nHarmOrbit = 15:26;
        Setup.xy.nHarmOrbit = 21;
        Setup.xy.NTurnsPerFFT = TurnsPerFFT;
        Setup.xy.NAvg = 1;
        Setup.xy.NPoints = 77 * 100000;  % *11 *7
        Setup.xy.NAdvance = 10*77;  % 7 11 77;   % in ADC counts
        Setup.xy.FigNum = Setup.PSD.FigNum + 3;
        Setup.xy.Shift = 0;

        save(FileName, 'Setup', 'ENV', 'ADC', 'TBT', 'FA', 'BCM');
        fprintf('%d.  %s   %s \n\n', i, datestr(ADC.Ts(1)), FileName);
        
        % Plot PDF
        if 1 % i == 0
            PSD = bpm_adc2psd(ADC, Setup, ENV);
            %Orbit = bpm_adc2xy(ADC, Setup, ENV);
        end
    end
        
    if PTminus1
        %%%%%%%%%%%%%%%%%
        % Minus Side PT %
        %%%%%%%%%%%%%%%%%
        
        % Set the pilot tone
        Setup.PT.State = 1;           % Pilot tone on (1) or off (0)
        Setup.PT.Attn = PTAttn;
        Setup.PT.FrequencyCode = '-1/2';
        setpilottone(Setup.PT);
        pause(PT_Pause);
        
        % Get temperatures, etc
        ENV = bpm_getenv;
        ENV.Clock = clock;
        ENV.RF0   = getrf;                % RF frequency [MHz],       like 499.6432
        ENV.Fs    =  77 * ENV.RF0 / 328;  % Sampling frequency [MHz], like 117.2931
        [ENV.DCCT, tmp, ENV.DataTime] = getdcct;
        ENV.DCCT = ENV.DCCT - DCCT0;
        
        ADC = bpm_getadc;
        TBT = [];  %tcp_read_tbtdata(Setup.NTBT);
        BCM = [];  %getbcm('all');
        
        FileName = sprintf('%s_PTOn_A1_Set%d', FileNamePrefix, i);
        clear tmp ans
        save(FileName, 'Setup', 'ENV', 'ADC', 'TBT', 'BCM');
        fprintf('%d. %s  %s \n\n', i, datestr(ENV.Clock), FileName);
        
        % Plot PDF
        if i == 1
            % PSD setup
            TurnsPerFFT = 160;
            Setup.PSD.Nfft = 77 * TurnsPerFFT;  % 77*150
            Setup.PSD.NaveMax = 350;
            Setup.PSD.WindowFlag = 0;
            Setup.PSD.Shift = 0;
            Setup.PSD.FigNum = 1001;
            Setup.FileName = FileName;
            
            PSD = bpm_adc2psd(ADC, Setup, ENV);
        end
    end
    
    if PTplus1
        %%%%%%%%%%%%%%%%
        % Plus Side PT %
        %%%%%%%%%%%%%%%%
        
        % Set the pilot tone
        Setup.PT.State = 1;           % Pilot tone on (1) or off (0)
        Setup.PT.Attn = PTAttn;
        %Setup.PT.FrequencyCode = '+3.5';
        Setup.PT.FrequencyCode = '+1/2';
        setpilottone(Setup.PT);
        pause(PT_Pause);
        
        % Get temperatures, etc
        ENV = bpm_getenv;
        ENV.Clock = clock;
        ENV.RF0   = getrf;                % RF frequency [MHz],       like 499.6432
        ENV.Fs    =  77 * ENV.RF0 / 328;  % Sampling frequency [MHz], like 117.2931
        [ENV.DCCT, tmp, ENV.DataTime] = getdcct;
        ENV.DCCT = ENV.DCCT - DCCT0;
        
        ADC = bpm_getadc;
        TBT = [];  %tcp_read_tbtdata(Setup.NTBT);
        BCM = [];  %getbcm('all');
        
        FileName = sprintf('%s_PTOn_B1_Set%d', FileNamePrefix, i);
        clear tmp ans
        save(FileName, 'Setup', 'ENV', 'ADC', 'TBT', 'BCM');
        fprintf('%d. %s  %s \n\n', i, datestr(ENV.Clock), FileName);
        
        % Plot PDF
        if i == 1
            % PSD setup
            TurnsPerFFT = 160;
            Setup.PSD.Nfft = 77 * TurnsPerFFT;  % 77*150
            Setup.PSD.NaveMax = 350;
            Setup.PSD.WindowFlag = 0;
            Setup.PSD.Shift = 0;
            Setup.PSD.FigNum = 1001;
            Setup.FileName = FileName;
            
            PSD = bpm_adc2psd(ADC, Setup, ENV);
        end
    end
    
    if PTminus2
        %%%%%%%%%%%%%%%%%
        % Minus Side PT %
        %%%%%%%%%%%%%%%%%
        
        % Set the pilot tone
        Setup.PT.State = 1;           % Pilot tone on (1) or off (0)
        Setup.PT.Attn = PTAttn;
        Setup.PT.FrequencyCode = '-1/4';
        setpilottone(Setup.PT);
        pause(PT_Pause);
        
        % Get temperatures, etc
        ENV = bpm_getenv;
        ENV.Clock = clock;
        ENV.RF0   = getrf;                % RF frequency [MHz],       like 499.6432
        ENV.Fs    =  77 * ENV.RF0 / 328;  % Sampling frequency [MHz], like 117.2931
        [ENV.DCCT, tmp, ENV.DataTime] = getdcct;
        ENV.DCCT = ENV.DCCT - DCCT0;
        
        ADC = bpm_getadc;
        TBT = [];  %tcp_read_tbtdata(Setup.NTBT);
        BCM = [];  %getbcm('all');
        
        FileName = sprintf('%s_PTOn_A2_Set%d', FileNamePrefix, i);
        clear tmp ans
        save(FileName, 'Setup', 'ENV', 'ADC', 'TBT', 'BCM');
        fprintf('%d. %s  %s \n\n', i, datestr(ENV.Clock), FileName);
        
        % Plot PDF
        if i == 1
            % PSD setup
            TurnsPerFFT = 160;
            Setup.PSD.Nfft = 77 * TurnsPerFFT;  % 77*150
            Setup.PSD.NaveMax = 350;
            Setup.PSD.WindowFlag = 0;
            Setup.PSD.Shift = 0;
            Setup.PSD.FigNum = 1001;
            Setup.FileName = FileName;
            
            PSD = bpm_adc2psd(ADC, Setup, ENV);
        end
    end
    
    
    if PTplus2
        %%%%%%%%%%%%%%%%
        % Plus Side PT %
        %%%%%%%%%%%%%%%%
        
        % Set the pilot tone
        Setup.PT.State = 1;           % Pilot tone on (1) or off (0)
        Setup.PT.Attn = PTAttn;
        Setup.PT.FrequencyCode = '+1/4';
        setpilottone(Setup.PT);
        pause(PT_Pause);
        
        % Get temperatures, etc
        ENV = bpm_getenv;
        ENV.Clock = clock;
        ENV.RF0   = getrf;                % RF frequency [MHz],       like 499.6432
        ENV.Fs    =  77 * ENV.RF0 / 328;  % Sampling frequency [MHz], like 117.2931
        [ENV.DCCT, tmp, ENV.DataTime] = getdcct;
        ENV.DCCT = ENV.DCCT - DCCT0;
        
        ADC = bpm_getadc;
        TBT = [];  %tcp_read_tbtdata(Setup.NTBT);
        BCM = [];  %getbcm('all');
        
        FileName = sprintf('%s_PTOn_B2_Set%d', FileNamePrefix, i);
        clear tmp ans
        save(FileName, 'Setup', 'ENV', 'ADC', 'TBT', 'BCM');
        fprintf('%d. %s  %s \n\n', i, datestr(ENV.Clock), FileName);
        
        % Plot PDF
        if i == 1
            % PSD setup
            TurnsPerFFT = 160;
            Setup.PSD.Nfft = 77 * TurnsPerFFT;  % 77*150
            Setup.PSD.NaveMax = 350;
            Setup.PSD.WindowFlag = 0;
            Setup.PSD.Shift = 0;
            Setup.PSD.FigNum = 1001;
            Setup.FileName = FileName;
            
            PSD = bpm_adc2psd(ADC, Setup, ENV);
        end
    end
    
    
    if PTonRF
        %%%%%%%%%%%%%%%%
        % Plus Side PT %
        %%%%%%%%%%%%%%%%
        
        % R&S - SMA100
        if 0
            RF0 = getrf;
            setpvonline('sma100:1:SetPowerLevel', -15);
            pause(.1);
            setpvonline('sma100:1:SetOutputOnOff', 'On');
            setpvonline('sma100:1:SetMainFrequency', 10e6 * RF0);
            pause(.1);
            RF1 = getrf;
            
            % Pilot tone
            Setup.PT.State = 0;           % Pilot tone on (1) or off (0)
            Setup.PT.Attn = 127;
            Setup.PT.FrequencyCode = '+3.5';
        else
            % Pilot tone
            Setup.PT.State = 1;           % Pilot tone on (1) or off (0)
            Setup.PT.Attn = PTAttn;
            Setup.PT.FrequencyCode = '0.0';
        end
        
        % Pilot tone setup
        setpilottone(Setup.PT);
        pause(PT_Pause);
        
        % Get temperatures, etc
        ENV = bpm_getenv;
        ENV.Clock = clock;
        ENV.RF0   = getrf;                % RF frequency [MHz],       like 499.6432
        ENV.Fs    =  77 * ENV.RF0 / 328;  % Sampling frequency [MHz], like 117.2931
        [ENV.DCCT, tmp, ENV.DataTime] = getdcct;
        ENV.DCCT = ENV.DCCT - DCCT0;
        
        ADC = bpm_getadc;
        TBT = [];  %tcp_read_tbtdata(Setup.NTBT);
        BCM = [];  %getbcm('all');
        
        FileName = sprintf('%s_PTOnRF_Set%d', FileNamePrefix, i);
        clear tmp ans
        save(FileName, 'Setup', 'ENV', 'ADC', 'TBT');
        fprintf('%d. %s  %s \n\n', i, datestr(ENV.Clock), FileName);
        
        % Plot PDF
        if i == 1
            % PSD setup
            TurnsPerFFT = 150;
            Setup.PSD.Nfft = 77 * TurnsPerFFT;  % 77*150
            Setup.PSD.NaveMax = 350;
            Setup.PSD.WindowFlag = 0;
            Setup.PSD.Shift = 0;
            Setup.PSD.FigNum = 1001;
            Setup.FileName = FileName;
            
            PSD = bpm_adc2psd(ADC, Setup, ENV);
        end
    end
    
    
    %     fprintf('\n   Temperatures\n');
    %     fprintf('   DFE0 = %.2f C\n', ENV.DFE_TEMP0);
    %     fprintf('   DFE1 = %.2f C\n', ENV.DFE_TEMP1);
    %     fprintf('   DFE2 = %.2f C\n', ENV.DFE_TEMP2);
    %     fprintf('   DFE3 = %.2f C\n', ENV.DFE_TEMP3);
    %     fprintf('   AFE0 = %.2f C\n', ENV.AFE_TEMP0);
    %     fprintf('   AFE1 = %.2f C\n', ENV.AFE_TEMP1);
    
    if i ~= N
        TPause = round(T-etime(clock,t1));
        fprintf('Pausing %.1f seconds\n', TPause);
        pause(TPause);
    end
end


fprintf('\nMeasurement Complete (%s)\n\n', datestr(now));


%     %figure(1);
%     %plot([ADC.cha(1:77*2) ADC.chb(1:77*2) ADC.chc(1:77*2) ADC.chd(1:77*2)]);
%     %ylabel('ADC');

%x = Setup.Xgain * (chaTBT-chbTBT-chcTBT+chdTBT) ./ (chaTBT+chbTBT+chcTBT+chdTBT); % mm
%y = Setup.Ygain * (chaTBT+chbTBT-chcTBT-chdTBT) ./ (chaTBT+chbTBT+chcTBT+chdTBT); % mm


% Get the slow data
%analyze_sa_data_v1;


return;



%% Plot

clear

%FileName = 'SRBPM1_5_InputsTerminatedto50ohms_LidsOff_Attn0_PTOff_Set2', FigNum = 601;

%FileName = 'SRBPM1_5_Split_PTOff_Set2', FigNum = 3001;
FileName = 'Test_PTOff_Set1', FigNum = 1;


load(FileName);
ENV
Setup.Xgain = 16.13;
Setup.Ygain = 16.13;


% PSD setup
TurnsPerFFT = 1;
Setup.PSD.Nfft = 77 * TurnsPerFFT;  % 77*150
Setup.PSD.NaveMax = 100;
Setup.PSD.WindowFlag = 0;
Setup.PSD.Shift = 36;
Setup.PSD.FigNum = FigNum;

% x,y calculation setup
%Setup.xy.nHarmOrbit = 15:26;
Setup.xy.nHarmOrbit = 21;
Setup.xy.NTurnsPerFFT = TurnsPerFFT;  % 150;
Setup.xy.NAvg = 1;
Setup.xy.NPoints = 77 * 100000;  % *11 *7
Setup.xy.NAdvance = 1*77;  % 7 11 77;   % in ADC counts
Setup.xy.Shift = 36;
Setup.xy.FigNum = Setup.PSD.FigNum + 3;
Setup.FileName = FileName;

PSD   = bpm_adc2psd(ADC, Setup, ENV);  % PSD
Orbit = bpm_adc2xy( ADC, Setup, ENV);  % Orbit

ADC.Max = max([max(ADC.cha) max(ADC.chb) max(ADC.chc) max(ADC.chd)]);
ADC.Min = min([min(ADC.cha) min(ADC.chb) min(ADC.chc) min(ADC.chd)]);

fprintf('   DCCT      min      max   Attn   Xrms  Yrms    Xmean    Ymean\n')
fprintf('   %.3f    %d   %d   %d     %.3f    %.3f    %.3f    %.3f\n', ENV.DCCT, ADC.Min, ADC.Max, Setup.Attn, 1000*std(Orbit.x), 1000*std(Orbit.y), 1000*mean(Orbit.x), 1000*mean(Orbit.y));

% Nfft = 77*150;
% NaveMax = 30;
% WindowFlag = 0;
% Shift = 0;
%
% [d, Paa, f, T1, nRF, nTone, nHarm, Paa_int] = nsls_adc_psd(ADC, Nfft, NaveMax, FigNum, WindowFlag, Shift);
