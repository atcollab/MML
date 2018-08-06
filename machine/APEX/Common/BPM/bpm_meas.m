
clear

% Measurements
PToff    = 1;
PTminus1 = 1;
PTminus2 = 1;
PTplus1  = 1;
PTplus2  = 1;
PTonRF   = 0;


T = 1*30;            % Time between reads
N = 1000;  %2*60*10;

Prefix = 'SR01C:BPM4';
FileNamePrefix = 'SR01C_BPM4_Spliter';





% Make sure the tigger is enabled
setpvonline([Prefix, ':wfr:ADC:triggerMask'], 1);
setpvonline([Prefix, ':wfr:TBT:triggerMask'], 1);
setpvonline([Prefix, ':wfr:FA:triggerMask'],  1);


% BPM Setup
%bpm_setenv(Prefix, RFAttn);
%pause(2);  % It takes a while for the attenuator to change

ENV = bpm_getenv(Prefix);


% Pilot tone attenuation .25 dB / unit step  (0-127 -> 0 to 30 dB)
% * Modified (2 Amp) BPM appears to be 8db less (not the expected 14)???
% * 40 for 500mA, Multibunch?
PTAttn   = 0;
PT_Pause = 5;  % 1 or 2 is probably fine


% PSD setup
TurnsPerFFT = 160;
Setup.PSD.Nfft = 77 * TurnsPerFFT;
Setup.PSD.NaveMax = 350;
Setup.PSD.WindowFlag = 0;
Setup.PSD.Shift = 0;
Setup.PSD.FigNum = 1;
Setup.FileName = '';

% x,y calculation setup
%Setup.xy.nHarmOrbit = 15:26;
Setup.xy.nHarmOrbit = 21;
Setup.xy.NTurnsPerFFT = TurnsPerFFT;
Setup.xy.NAvg = 1;
Setup.xy.NPoints = 77 * 100000; 
Setup.xy.NAdvance = 10*77;  % 7 11 77;   % in ADC counts
Setup.xy.Shift = 0;
Setup.xy.FigNum = Setup.PSD.FigNum + 3;



for i = 1:N
    t1 = clock;
  
    if PToff        
        % Set the pilot tone
        ENV.PT.State = 0;       % Pilot tone on (1) or off (0)
        ENV.PT.Attn = 127;
        ENV.PT.FrequencyCode = '+3.5';
        setpilottone(ENV.PT);
        pause(PT_Pause);
        
        % Trigger
        bpm_softtrigger(Prefix);
        
        ADC = bpm_getadc(Prefix);
        %TBT = bpm_gettbt(Prefix);
        %FA  = bpm_getfa(Prefix);        
        %BCM = getbcm('all');
        
        FileName = sprintf('%s_PTOff_Set%d', FileNamePrefix, i);     
        Setup.PSD.FigNum = 101;
        Setup.xy.FigNum = Setup.PSD.FigNum + 3;       
        save(FileName, 'Setup', 'ENV', 'ADC');  % , 'TBT', 'FA', 'BCM'
        fprintf('%d.  %s   %s \n\n', i, datestr(ADC.Ts(1)), FileName);
        
        % Plot PDF
        if i == 1
            PSD = bpm_adc2psd(ADC, ENV, Setup);
        end
    end
        
    
    if PTminus1
        % Set the pilot tone
        ENV.PT.State = 1;       % Pilot tone on (1) or off (0)
        ENV.PT.Attn = PTAttn;
        ENV.PT.FrequencyCode = '-1/2';
        setpilottone(ENV.PT);
        pause(PT_Pause);
        
        % Trigger
        bpm_softtrigger(Prefix);
        
        ADC = bpm_getadc(Prefix);
        %TBT = bpm_gettbt(Prefix);
        %FA  = bpm_getfa(Prefix);        
        %BCM = getbcm('all');
        
        FileName = sprintf('%s_PTOn_A1_Set%d', FileNamePrefix, i);
        Setup.PSD.FigNum = 201;
        Setup.xy.FigNum = Setup.PSD.FigNum + 3;       
        save(FileName, 'Setup', 'ENV', 'ADC');  % , 'TBT', 'FA', 'BCM'
        fprintf('%d.  %s   %s \n\n', i, datestr(ADC.Ts(1)), FileName);
        
        % Plot PDF
        if i == 1
            PSD = bpm_adc2psd(ADC, ENV, Setup);
        end
    end
    
    
    if PTplus1
        % Set the pilot tone
        ENV.PT.State = 1;       % Pilot tone on (1) or off (0)
        ENV.PT.Attn = PTAttn;
        ENV.PT.FrequencyCode = '+1/2';
        setpilottone(ENV.PT);
        pause(PT_Pause);
        
        % Trigger
        bpm_softtrigger(Prefix);
        
        ADC = bpm_getadc(Prefix);
        %TBT = bpm_gettbt(Prefix);
        %FA  = bpm_getfa(Prefix);        
        %BCM = getbcm('all');
        
        FileName = sprintf('%s_PTOn_B1_Set%d', FileNamePrefix, i);
        Setup.PSD.FigNum = 301;
        Setup.xy.FigNum = Setup.PSD.FigNum + 3;       
        save(FileName, 'Setup', 'ENV', 'ADC');  % , 'TBT', 'FA', 'BCM'
        fprintf('%d.  %s   %s \n\n', i, datestr(ADC.Ts(1)), FileName);
        
        % Plot PDF
        if i == 1
            PSD = bpm_adc2psd(ADC, ENV, Setup);
        end
    end
    
    
    if PTminus2
        % Set the pilot tone
        ENV.PT.State = 1;       % Pilot tone on (1) or off (0)
        ENV.PT.Attn = PTAttn;
        ENV.PT.FrequencyCode = '-1/4';
        setpilottone(ENV.PT);
        pause(PT_Pause);
        
        % Trigger
        bpm_softtrigger(Prefix);
        
        ADC = bpm_getadc(Prefix);
        %TBT = bpm_gettbt(Prefix);
        %FA  = bpm_getfa(Prefix);        
        %BCM = getbcm('all');
        
        FileName = sprintf('%s_PTOn_A2_Set%d', FileNamePrefix, i);
        Setup.PSD.FigNum = 401;
        Setup.xy.FigNum = Setup.PSD.FigNum + 3;       
        save(FileName, 'Setup', 'ENV', 'ADC');  % , 'TBT', 'FA', 'BCM'
        fprintf('%d.  %s   %s \n\n', i, datestr(ADC.Ts(1)), FileName);
        
        % Plot PDF
        if i == 1
            PSD = bpm_adc2psd(ADC, ENV, Setup);
        end
    end
    
    
    if PTplus2
        % Set the pilot tone
        ENV.PT.State = 1;       % Pilot tone on (1) or off (0)
        ENV.PT.Attn = PTAttn;
        ENV.PT.FrequencyCode = '+1/4';
        setpilottone(ENV.PT);
        pause(PT_Pause);
        
        % Trigger
        bpm_softtrigger(Prefix);
        
        ADC = bpm_getadc(Prefix);
        %TBT = bpm_gettbt(Prefix);
        %FA  = bpm_getfa(Prefix);        
        %BCM = getbcm('all');
        
        FileName = sprintf('%s_PTOn_B2_Set%d', FileNamePrefix, i);
        Setup.PSD.FigNum = 501;
        Setup.xy.FigNum = Setup.PSD.FigNum + 3;       
        save(FileName, 'Setup', 'ENV', 'ADC');  % , 'TBT', 'FA', 'BCM'
        fprintf('%d.  %s   %s \n\n', i, datestr(ADC.Ts(1)), FileName);
        
        % Plot PDF
        if i == 1
            PSD = bpm_adc2psd(ADC, ENV, Setup);
        end
    end
    
      
    
    if PTonRF
        % Set the pilot tone
        ENV.PT.State = 1;       % Pilot tone on (1) or off (0)
        ENV.PT.Attn = PTAttn;
        ENV.PT.FrequencyCode = '0.0';
        setpilottone(ENV.PT);
        pause(PT_Pause);
        
        % Trigger
        bpm_softtrigger(Prefix);
        
        ADC = bpm_getadc(Prefix);
        %TBT = bpm_gettbt(Prefix);
        %FA  = bpm_getfa(Prefix);        
        %BCM = getbcm('all');
        
        FileName = sprintf('%s_PTOnRF_Set%d', FileNamePrefix, i);
        Setup.PSD.FigNum = 601;
        Setup.xy.FigNum = Setup.PSD.FigNum + 3;       
        save(FileName, 'Setup', 'ENV', 'ADC');  % , 'TBT', 'FA', 'BCM'
        fprintf('%d.  %s   %s \n\n', i, datestr(ADC.Ts(1)), FileName);
        
        % Plot PDF
        if i == 1
            PSD = bpm_adc2psd(ADC, ENV, Setup);
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

% R&S - SMA100
% RF0 = getrf;
% setpvonline('sma100:1:SetPowerLevel', -15);
% pause(.1);
% setpvonline('sma100:1:SetOutputOnOff', 'On');
% setpvonline('sma100:1:SetMainFrequency', 10e6 * RF0);
% pause(.1);

% figure(1);
% plot([ADC.cha(1:77*2) ADC.chb(1:77*2) ADC.chc(1:77*2) ADC.chd(1:77*2)]);
% ylabel('ADC');

% x = Setup.Xgain * (chaTBT-chbTBT-chcTBT+chdTBT) ./ (chaTBT+chbTBT+chcTBT+chdTBT); % mm
% y = Setup.Ygain * (chaTBT+chbTBT-chcTBT-chdTBT) ./ (chaTBT+chbTBT+chcTBT+chdTBT); % mm


return;


%% PT test

% Quick PT set
% Max On
%tcp_write_reg(2, 1);
%tcp_write_reg(34, 0);
% Off
%tcp_write_reg(2, 0);
%tcp_write_reg(34, 127);



%% Plot

clear

FileName{1} = 'SR01C_BPM4_Spliter_PTOn_A1_Set1';
FileName{2} = 'SR01C_BPM4_Spliter_PTOn_A2_Set1';
FileName{3} = 'SR01C_BPM4_Spliter_PTOff_Set1';
FileName{4} = 'SR01C_BPM4_Spliter_PTOn_B2_Set1';
FileName{5} = 'SR01C_BPM4_Spliter_PTOn_B1_Set1';

for i = 1:5
    load(FileName{i});
    PSD   = bpm_adc2psd(ADC, ENV, 100*i+1);  % PSD
    %Orbit = bpm_adc2xy( ADC, ENV, Setup);  % Orbit
end



%% 
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

PSD   = bpm_adc2psd(ADC, ENV, Setup);  % PSD
Orbit = bpm_adc2xy( ADC, ENV, Setup);  % Orbit

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
