%% bpm_getsa_all plots

%load SA_Data_Set3.mat    % from turn on 10-19-2014
% SA from off

%load SA_DataAll_2014-10-24_50mA.mat    % Startup 10-24-2014, static 50mA
 

% SA from off
% Missed turning off SR03C:BPM7, SR08C:BPM8, SR09C:BPM8, SR10C:BPM7, ...
% SR01C:BPM6 had a 1 point dropout???
% cd /home/physdata/BPM/AFE5Proto_ALSDFE
% load SA_DataAll_2014-11-07
% PVsPerBPM = 29; ???

% cd /home/physdata/BPM/AFE6


% 2015-05-04
% All BPMs, Physics shift, beam decay, SOFB & FOFB On, All BPMs off, BPM(1,4) PT On/no correction
%load SA_All_Set1
%PVsPerBPM = 29+4;
%N = size(SA.Data,2);
%d = [];

% All BPMs, User Ops, topoff, BPM(1,4) off, BPM(1,4) PT Off, 30 minutes
% load SA_All_Set2
% PVsPerBPM = 29+4;

% All BPMs, User Ops, topoff, BPM(1,4) off, BPM(1,4) PT On/Correction Off, 30 minutes
%clear
%load SA_All_Set4
%PVsPerBPM = 29+4;

% All BPMs, User Ops, topoff, BPM(1,4) off, BPM(1,4) PT On/Correction On, 30 minutes
%clear
%load SA_All_Set5
%PVsPerBPM = 29+4;

% All BPMs, User Ops, topoff, BPM(1,4) off, BPM(1,4) PT On/Correction On, 3 hours
% clebpm_getsa_allar
% load SA_All_Set6
% PVsPerBPM = 29+4;

% All BPMs, User Ops, topoff, BPM(1,4) 
% 3 min PT On, Correction On
% 3 min PT On, Correction Off
% 3 min PT Off, Amp off
% load SA_All_Set7
% PVsPerBPM = 29+4;

% 2 BPMs, User Ops, topoff, BPM(1,4) PT On, Correction On at 10:31pm, 24 hours
% Prefix_All =   {'SR01C:BPM2'; 'SR01C:BPM4' };
% ran bpminit (nonsync for a moment) at 11:06pm
% load SA_All_Set8
% PVsPerBPM = 29+4;

% 2 BPMs, User Ops, topoff, BPM(1,4) PT On, Correction On at 10:31pm, 24 hours
% Prefix_All =   {'SR01C:BPM2'; 'SR01C:BPM4' };
% 2 minutes, PT correction On-Off_on -> no gliches
% load SA_All_Set9
% PVsPerBPM = 29+4;

% 2 BPMs, User Ops, topoff, BPM(1,4) PT On, Correction On, 48 hours
% Prefix_All =   {'SR01C:BPM2'; 'SR01C:BPM4' };
% clear
% load SA_All_Set10
% PVsPerBPM = 29+4+8=41;  In the file

% All BPMs, Physics Shift
% Decay mode, fill at 450mA, Orbit feedback by accident
%load SA_All_Set11
% PVsPerBPM = 29+4;

% User ops, 
% BPM noise measurement with PT on SR01C:BPM5 (3) & BPM6 (4)
%load SA_All_15
%PVsPerBPM = 33;
%N = size(SA.Data,2);

% 2015-08-05 -> SR06C:BPM1 & SR10C:BPM7 replaced with AFE2 Rev4

% 2-Buch user ops
%load SA_All_2Bunch_Set1
%PVsPerBPM = 33;
%N =279020;

% 2-Buch user ops (1 hour)
% 2015-08-11 10:21pm - start with BPM5 and BPM6 PT Enabled
% 
%load SA_All_2Bunch_Set2
%PVsPerBPM = 33;
%N = size(SA.Data,2);
%N = 285950;

% Physcis shift ~7 hours, 2-Buch user ops ~5 hours
% BPM5 and BPM6 PT Enabled
%load SA_All_2Bunch_Set6
%N = size(SA.Data,2);

% Physcis shift ~6.5 hours, 500mA decay mode
% SR01C:BPM2 PT Enabled
%load SA_All_Set16
%N = size(SA.Data,2);

% User ops
% SR01C:BPM2 PT Enabled
%load SA_All_Set17
%N = size(SA.Data,2);
   
% Physic shift ~7 hours, 2-Bunch, ~5 hours
% 5 AFE2 Rev4 [1 2; 6 1; 10 7; 12 1; 12 2]
%load SA_All_2Bunch_Set10
%N = size(SA.Data,2);

% 2015-08-30 -> SR01C:BPM7, SR01C:BPM8, SR02C:BPM2 replaced with AFE2 Rev4

% Physcis shift ~2.5 hours, 500mA decay mode, SR01C:BPM2 with PT on
% Static machine -> no orbit feedback
%load SA_All_Set19
%N = size(SA.Data,2);


% User ops
%load SA_All_Set22
%N = size(SA.Data,2);


% Physcis shift ~2.5 hours, 500mA decay mode, PT on ???
% Static machine -> no orbit feedback
%load SA_All_Set25
%N = size(SA.Data,2);

% Changing the RF frequency (2016-04-04)
% load  SA_All_1Bunch_Sector1_RFChange_Set1
%N = size(SA.Data,2);

% 450-450mA decay mode, Sector 1 with PT on (2016-04-04)
% No Bergoz in the measurement
% load  SA_All_Set30
%N = 240000;

% Two-bunch user ops, 6 hours, PT on, PT correction on
% Beam dump at the end of the run
%load SA_All_2Bunch_Sector1_Set3
%N = 160000

% Two-bunch user ops, 5 hours, PT on, no correction
% Beam dump at the end of the run
%load SA_All_2Bunch_Sector1_Set5
%N = 160000


%load SA_All_2Bunch_Sector1_Set7
%N = 100000;  %size(SA.Data,2);


%load SA_All_NoBeam_Sector1_Set1
%N = size(SA.Data,2);

% Owl shift: 500 - 400 mA decay mode, no orbit feedback, 1 beam dump
% No IDBPMs
%load SA_All_Set36
%N = size(SA.Data,2);
%N = 120000;

% Owl shift: 500 - 400 mA decay mode, no orbit feedback
% Includes IDBPMs
%load SA_All_Set37
%N = size(SA.Data,2);


% Owl shift: 500 mA topoff during a startup & part of owl user ops
% orbit feedback?
% IDBPMs and IDs
%load SA_All_Set38
%N = size(SA.Data,2);
% plot(tout(1:N), SA.Data(iBergoz+77-1,1:N));


% Owl shift: half 500 mA topoff, half decay 
% Orbit feedback off, ID fixed, No RF changes
% Sector 1 PT on, but gain correction disabled
% load SA_All_Set39
% nBergoz = 77;
% iBergoz = PVsPerBPM * length(Prefix_All) + 3 + 1;
% N = size(SA.Data,2);


% Swing shift user beam July 12, 2016
% Secor 1 PT on, 2 sides correction enabled
%load SA_All_Set40
%N = size(SA.Data,2);

% Swing shift user beam July 27, 2016
% Sector 1 PT on, 2 sides correction enabled
%load SA_All_Set41
%N = size(SA.Data,2);

% Swing shift user beam July 27, 2016
% Sector 1 PT on, 2 sides correction enabled
%load SA_All_2Bunch_Set11
%N = size(SA.Data,2);

% User beam August 31, 2016, 1 hour
% Sector 1 PT on, 2 sides correction enabled
% Looking for an issue with [6 1]
%load SA_All_Set43
%N = size(SA.Data,2);

% Owl shift user beam Oct 24, 2016
% Sector 1 and & PT on, 2 sides correction enabled
%load SA_All_Set45
%N = 2702  %size(SA.Data,2);

% Owl shift user beam July 18, 2017
% PT on, 2 sides correction enabled
% SR01C:BPM1 -> Lorch, split
% SR01C:BPM3 -> Mini-curcuits, split
% SR01C:BPM5 -> CTS, split

% 46
% Owl
N = size(SA.Data,2);

% SA_All_2Bunch_Sector1_10Min_Set1
% SR12S___IBPM1X_AM00
% SR12S___IBPM2X_AM02
% SR12C:BPM1:SA:X    
% SR12C:BPM2:SA:X    
% SR12C___BPM3XT_AM00
% SR12C___BPM4XT_AM00
% SR12C___BPM5XT_AM02
% SR12C___BPM6XT_AM00
% SR12C:BPM7:SA:X    
% SR01S___IBPM1X_AM00

% 2-Bunch
% /home/physdata/BPM/TwoBunch/2017-07-07/SA_All_2Bunch_Set1.mat  
%


NBPM       = length(Prefix_All);
iDCCT      = (NBPM * PVsPerBPM) + 1;
iRF        = (NBPM * PVsPerBPM) + 2;
iRFCounter = (NBPM * PVsPerBPM) + 3;
iBergoz    = (NBPM * PVsPerBPM) + 4;
nBergoz = size(d,1);
iID = iBergoz + 2*nBergoz;


% ENV = bpm_getenv('SR01C:BPM1');
% ADC = bpm_getadc('SR01C:BPM1');
% TBT = bpm_gettbt('SR01C:BPM1');
% FA  = bpm_getfa('SR01C:BPM1');
% bpm_adc2psd(ADC, ENV, 101);



%%


tout = SA.t;

XLabel = 'Time [Hours]';
TimeScale = 60*60;  % Hours
tout(1,1:N) = tout(1,1:N)/TimeScale;


figure(1001)
%plot(tout(1:N), SA.Data(iBergoz+77-1,1:N));
plot(tout(1:N), SA.Data(iBergoz+77,1:N));
title(RFPV(iBergoz+77,:));
xlabel(XLabel);
ylabel('Vertical [mm]');


h = [];

NFig = 1001; 



% 22 - SR06C:BPM1
% 38 - SR10C:BPM7
% 46 - SR12C:BPM1

%for iBPM = 41 %17 %1:NBPM
for iBPM = 1:NBPM
    
    if iBPM > 3
        yDelta = 300;
    else
        yDelta = 1;
    end
    
    %h = h(1:2);
    figure(NFig);
    clf reset
    h = subplot(2,1,1);
    plot(tout(1:N), SA.Data(iDCCT,1:N));
    xlabel(XLabel);
    ylabel('DCCT [mA]');
    %yaxis([-.03 .03]);
    axis tight;
    
    h(length(h)+1) = subplot(2,1,2);
    plot(tout(1:N), 1e6*(SA.Data(iRF,1:N)-SA.Data(iRF,1)));
    xlabel(XLabel);
    ylabel('\Delta RF [Hz]');
    %yaxis([-.03 .03]);
    axis tight;
    
    i = PVsPerBPM*(iBPM-1);
   % t_day = datestr(SA.Ts(1+i,1:4),  'yyyy-mm-dd HH:MM:SS.FFF')
    
    figure(NFig+1);
    clf reset
    if 0
        h(length(h)+1) = subplot(1,1,1);
        plot(tout(1:N), 1000*(SA.Data(1+i,1:N) - SA.Data(1+i,1)), 'b', tout(1:N), 1000*(SA.Data(2+i,1:N) - SA.Data(2+i,1)), 'g')
        xlabel(XLabel);
        ylabel('Orbit [\mum]');
        title(Prefix_All{iBPM});
        legend('Horizontal','Vertical','Location','Best');
        yaxis([-5 5]);
    else
        h(length(h)+1) = subplot(3,1,1);
        plot(tout(1:N), 1000*(SA.Data(1+i,1:N)));
       %plot(tout(1:N), 1000*(SA.Data(1+i,1:N) - SA.Data(1+i,1)));
        ylabel('Horizontal [\mum]');
        title(Prefix_All{iBPM});
        %yaxis([-yDelta yDelta]+mean(1000*(SA.Data(1+i,1:10))));
        axis tight;        

        
        h(length(h)+1) = subplot(3,1,2);
        plot(tout(1:N), 1000*(SA.Data(2+i,1:N)));
       %plot(tout(1:N), 1000*(SA.Data(2+i,1:N) - SA.Data(2+i,1)));
        ylabel('Vertical [\mum]');
        %yaxis([-yDelta yDelta]+mean(1000*(SA.Data(2+i,1:10))));
        axis tight;        

        h(length(h)+1) = subplot(3,1,3);
        plot(tout(1:N), SA.Data(4+i,1:N));
        ylabel('Sum');
        xlabel(XLabel);
        axis tight;        
    end
    
    figure(NFig+2);
    clf reset
    h(length(h)+1) = subplot(1,1,1);
    if 1
        plot(tout(1:N), SA.Data(5+i,1:N), 'b');
        hold on
        plot(tout(1:N), SA.Data(6+i,1:N), 'g');
        plot(tout(1:N), SA.Data(7+i,1:N), 'r');
        plot(tout(1:N), SA.Data(8+i,1:N), 'c');
        axis tight;
    else
        plot(tout(1:N), detrend(SA.Data(5+i,1:N)), 'b');
        hold on
        plot(tout(1:N), detrend(SA.Data(6+i,1:N)), 'g');
        plot(tout(1:N), detrend(SA.Data(7+i,1:N)), 'r');
        plot(tout(1:N), detrend(SA.Data(8+i,1:N)), 'c');
        axis tight
    end
    xlabel(XLabel);
    ylabel('RF Mag');
    title(Prefix_All{iBPM});
    
    figure(NFig+3);
    clf reset
    if 1
        h(length(h)+1) = subplot(4,1,1);
        plot(tout(1:N), SA.Data(5+i,1:N), 'b');
        axis tight;
        ylabel('A');
        title([Prefix_All{iBPM} '  --  RF Mag']);
        h(length(h)+1) = subplot(4,1,2);
        plot(tout(1:N), SA.Data(6+i,1:N), 'b');
        axis tight;
        ylabel('B');
        h(length(h)+1) = subplot(4,1,3);
        plot(tout(1:N), SA.Data(7+i,1:N), 'b');
        axis tight;
        ylabel('C');
        h(length(h)+1) = subplot(4,1,4);
        plot(tout(1:N), SA.Data(8+i,1:N), 'b');
        axis tight;
        ylabel('D');
        xlabel(XLabel);
    else
        h(length(h)+1) = subplot(1,1,1);
        %NN = 1;
        %NN = 72000;
        NN = size(SA.Data, 2);
        plot(tout(1:N), SA.Data(5+i,1:N) - SA.Data(5+i,NN) + SA.Data(5+i,NN), 'b');
        hold on
        plot(tout(1:N), SA.Data(6+i,1:N) - SA.Data(6+i,NN) + SA.Data(5+i,NN), 'g');
        plot(tout(1:N), SA.Data(7+i,1:N) - SA.Data(7+i,NN) + SA.Data(5+i,NN), 'r');
        plot(tout(1:N), SA.Data(8+i,1:N) - SA.Data(8+i,NN) + SA.Data(5+i,NN), 'c');
        yaxis([-70000 80000]+SA.Data(5+i,NN));
        axis tight
        xlabel(XLabel);
        ylabel('RF Mag');
        title(Prefix_All{iBPM});
    end
    
    if PVsPerBPM > 20
        figure(NFig+4);
        clf reset
        h(length(h)+1) = subplot(3,1,1);
        plot(tout(1:N), SA.Data((17+4:28)+i,1:N))
        axis tight
        ylabel('AFE [C]');
        title(['Temperatures  ', Prefix_All{iBPM}]);
        h(length(h)+1) = subplot(3,1,2);
        plot(tout(1:N), SA.Data((29:32)+i,1:N))
        axis tight
        ylabel('DFE [C]');
        h(length(h)+1) = subplot(3,1,3);
        plot(tout(1:N), SA.Data((33)+i,1:N))
        axis tight
        xlabel(XLabel);
        ylabel('FPGA [C]');
    end
    
    figure(NFig+5);
    clf reset
    if 1
        h(length(h)+1) = subplot(4,1,1);
        plot(tout(1:N), SA.Data( 9+i,1:N), 'b');
        axis tight;
        ylabel('A');
        title([Prefix_All{iBPM} '  --  PT Low Mag']);
        h(length(h)+1) = subplot(4,1,2);
        plot(tout(1:N), SA.Data(10+i,1:N), 'b');
        axis tight;
        ylabel('B');
        h(length(h)+1) = subplot(4,1,3);
        plot(tout(1:N), SA.Data(11+i,1:N), 'b');
        axis tight;
        ylabel('C');
        h(length(h)+1) = subplot(4,1,4);
        plot(tout(1:N), SA.Data(12+i,1:N), 'b');
        axis tight;
        ylabel('D');
        xlabel(XLabel);
    else
        h(length(h)+1) = subplot(1,1,1);
        plot(tout(1:N), SA.Data( 9+i,1:N), 'b');
        hold on
        plot(tout(1:N), SA.Data(10+i,1:N), 'g');
        plot(tout(1:N), SA.Data(11+i,1:N), 'r');
        plot(tout(1:N), SA.Data(12+i,1:N), 'c');
        axis tight;
        xlabel(XLabel);
        ylabel('PT Low Mag');
        title(Prefix_All{iBPM});
    end
    
    figure(NFig+6);
    clf reset
    if 1
        h(length(h)+1) = subplot(4,1,1);
        plot(tout(1:N), SA.Data(13+i,1:N), 'b');
        axis tight;
        ylabel('A');
        title([Prefix_All{iBPM} '  --  PT Hi Mag']);
        h(length(h)+1) = subplot(4,1,2);
        plot(tout(1:N), SA.Data(14+i,1:N), 'b');
        axis tight;
        ylabel('B');
        h(length(h)+1) = subplot(4,1,3);
        plot(tout(1:N), SA.Data(15+i,1:N), 'b');
        axis tight;
        ylabel('C');
        h(length(h)+1) = subplot(4,1,4);
        plot(tout(1:N), SA.Data(16+i,1:N), 'b');
        axis tight;
        ylabel('D');
        xlabel(XLabel);
    else
        h(length(h)+1) = subplot(1,1,1);
        plot(tout(1:N), SA.Data(13+i,1:N), 'b');
        hold on
        plot(tout(1:N), SA.Data(14+i,1:N), 'g');
        plot(tout(1:N), SA.Data(15+i,1:N), 'r');
        plot(tout(1:N), SA.Data(16+i,1:N), 'c');
        axis tight;
        xlabel(XLabel);
        ylabel('PT Hi Mag');
        title(Prefix_All{iBPM});
    end
    
    figure(NFig+7);
    clf reset
    if 1
        h(length(h)+1) = subplot(4,1,1);
        plot(tout(1:N), SA.Data(17+i,1:N), 'b');
        ylabel('A');
        title([Prefix_All{iBPM} 'PT Gain Factors']);
        h(length(h)+1) = subplot(4,1,2);
        plot(tout(1:N), SA.Data(18+i,1:N), 'b');
        ylabel('B');
        h(length(h)+1) = subplot(4,1,3);
        plot(tout(1:N), SA.Data(19+i,1:N), 'b');
        ylabel('C');
        h(length(h)+1) = subplot(4,1,4);
        plot(tout(1:N), SA.Data(20+i,1:N), 'b');
        ylabel('D');
        xlabel(XLabel);
    else
        h(length(h)+1) = subplot(1,1,1);
        plot(tout(1:N), SA.Data(17+i,1:N), 'b');
        hold on
        plot(tout(1:N), SA.Data(18+i,1:N), 'g');
        plot(tout(1:N), SA.Data(19+i,1:N), 'r');
        plot(tout(1:N), SA.Data(20+i,1:N), 'c');
        axis tight;
        xlabel(XLabel);
        ylabel('PT Gain Factors');
        title(Prefix_All{iBPM});
    end

    
    
    if 0
        % Attempt to remove the PT
        irm = [];
        for j = N:-1:1
            if any(SA.TsLabCA(5,j) ~= SA.TsLabCA([6:8 17:20],j))
                irm = [j irm];
            end
        end
        
        irm = [irm irm-1 irm+1 irm-2 irm+2];
        %irm = [irm irm-1 irm+1 irm-2 irm+2];
        irm = sort(irm);
        irm(find(irm<1)) = [];
        irm(find(irm>length(SA.tout))) = [];
  
        tt = SA.tout/TimeScale;
        tt(irm) = [];
        Data = SA.Data;
        Data(:,irm) = [];
        
        aa = Data(5+i,:) ./ Data(17+i,:);
        bb = Data(6+i,:) ./ Data(18+i,:);
        cc = Data(7+i,:) ./ Data(19+i,:);
        dd = Data(8+i,:) ./ Data(20+i,:);
        
        [Kx, Ky, Kq] = bpm_getgain(Prefix_All{iBPM});
        
        ss = aa + bb + cc + dd;
        xx = Kx * (aa - bb - cc + dd ) ./ ss;  % mm
        yy = Ky * (aa + bb - cc - dd ) ./ ss;  % mm

        % This filtering should not be needed
        idiff = sort([find(abs(diff(xx)) > .001) find(abs(diff(yy)) > .001)]);
        idiff = sort([idiff idiff+1]);
        tt(idiff) = [];
        Data(:,idiff) = [];
        xx(idiff) = [];
        yy(idiff) = [];
        ss(idiff) = [];

        figure(NFig+8);
        clf reset
        h(length(h)+1) = subplot(4,1,1);
        plot(tt(:), Data(5+i,:) ./ Data(17+i,:), 'b');
        ylabel('A');
        title([Prefix_All{iBPM} 'RFMag ./ PT Gain Factors']);
        h(length(h)+1) = subplot(4,1,2);
        plot(tt(:), Data(6+i,:) ./ Data(18+i,:), 'b');
        ylabel('B');
        h(length(h)+1) = subplot(4,1,3);
        plot(tt(:), Data(7+i,:) ./ Data(19+i,:), 'b');
        ylabel('C');
        h(length(h)+1) = subplot(4,1,4);
        plot(tt(:), Data(8+i,:) ./ Data(20+i,:), 'b');
        ylabel('D');
        xlabel(XLabel);
        
        figure(NFig+9);
        clf reset
        h(length(h)+1) = subplot(3,1,1);
        plot(tt(:), 1000*(xx-xx(1)), 'b');
        ylabel('Horiztonal [\mum]');
        title([Prefix_All{iBPM} 'RFMag ./ PT Gain Factors']);
        h(length(h)+1) = subplot(3,1,2);
        plot(tt(:), 1000*(yy-yy(1)), 'b');
        ylabel('Vertical [\mum]');
        h(length(h)+1) = subplot(3,1,3);
        plot(tt(:), ss, 'b');
        ylabel('Sum');
        xlabel(XLabel);

        figure(NFig+10);
        clf reset
        h(length(h)+1) = subplot(1,1,1);
        plot(tt, 1000*(xx-xx(1)), 'b', tt(:), 1000*(yy-yy(1)), 'g');
        xlabel(XLabel);
        ylabel('Orbit [\mum]');
        title(['Orbit With Pilot Tone Correction Removed  -  ', Prefix_All{iBPM}]);
        legend('Horizontal','Vertical','Location','Best');
        axis tight;
    
    else
        % If the PT correction was not on

        tt = SA.tout(1:N)/TimeScale;
        Data = SA.Data(:,1:N);
        
        if 1
            % Orbit from RFMag
            % Back out PT gain (just 1's if not used)
            aa = Data(5+i,:) ./ Data(17+i,:);
            bb = Data(6+i,:) ./ Data(18+i,:);
            cc = Data(7+i,:) ./ Data(19+i,:);
            dd = Data(8+i,:) ./ Data(20+i,:);
        elseif 0
            % Orbit from low PT
            aa = Data( 9+i,:);
            bb = Data(10+i,:);
            cc = Data(11+i,:);
            dd = Data(12+i,:);
        elseif 0
            % Orbit from high PT
            aa = Data(13+i,:);
            bb = Data(14+i,:);
            cc = Data(15+i,:);
            dd = Data(16+i,:);
        end
           
        m1 = Data(6+i,:)./Data(5+i,:);
        m2 = Data(7+i,:)./Data(5+i,:);
        m3 = Data(8+i,:)./Data(5+i,:);
 
        l1 = Data(10+i,:)./Data(9+i,:);
        l2 = Data(11+i,:)./Data(9+i,:);
        l3 = Data(12+i,:)./Data(9+i,:);
   
        h1 = Data(14+i,:)./Data(13+i,:);
        h2 = Data(15+i,:)./Data(13+i,:);
        h3 = Data(16+i,:)./Data(13+i,:);
        
        % Just for easy visual on plots
        if 1
            l1 = l1 / l1(1);
            l2 = l2 / l2(1);
            l3 = l3 / l3(1);
            h1 = h1 / h1(1);
            h2 = h2 / h2(1);
            h3 = h3 / h3(1);
        end
        
        clear gg
        if 1
            % Gain from Lo Hi average
            gg(1,:) = ones(1,length(l1));
            gg(2,:) = 1 ./ ((l1+h1)/2);
            gg(3,:) = 1 ./ ((l2+h2)/2);
            gg(4,:) = 1 ./ ((l3+h3)/2);
        elseif 0
            % Gain from low PT
            gg(1,:) = ones(1,length(l1));
            gg(2,:) = 1 ./ l1;
            gg(3,:) = 1 ./ l2;
            gg(4,:) = 1 ./ l3;
        elseif 0
            % Gain from high PT
            gg(1,:) = ones(1,length(h1));
            gg(2,:) = 1 ./ h1;
            gg(3,:) = 1 ./ h2;
            gg(4,:) = 1 ./ h3;
        end
        
        [Kx, Ky, Kq] = bpm_getgain(Prefix_All{iBPM});

        ss_noscaling = aa + bb + cc + dd;
        xx_noscaling = Kx * (aa - bb - cc + dd ) ./ ss_noscaling;  % mm
        yy_noscaling = Ky * (aa + bb - cc - dd ) ./ ss_noscaling;  % mm
       
        aa = aa .* gg(1,:);
        bb = bb .* gg(2,:);
        cc = cc .* gg(3,:);
        dd = dd .* gg(4,:);
%         aa = aa ./ gg(1,:);
%         bb = bb ./ gg(2,:);
%         cc = cc ./ gg(3,:);
%         dd = dd ./ gg(4,:);


        ss = aa + bb + cc + dd;
        xx = Kx * (aa - bb - cc + dd ) ./ ss;  % mm
        yy = Ky * (aa + bb - cc - dd ) ./ ss;  % mm
        
        
        figure(NFig+8);
        clf reset
        h(length(h)+1) = subplot(3,1,1);
        plot(tt(:), Data(6+i,:)./Data(5+i,:), 'b'); hold on;
        plot(tt(:), Data(7+i,:)./Data(5+i,:), 'g');
        plot(tt(:), Data(8+i,:)./Data(5+i,:), 'r');
        ylabel('RFMag');
        title([Prefix_All{iBPM} ' ']);
        
        h(length(h)+1) = subplot(3,1,2);
        plot(tt(:), Data(10+i,:)./Data(9+i,:), 'b'); hold on;
        plot(tt(:), Data(11+i,:)./Data(9+i,:), 'g');
        plot(tt(:), Data(12+i,:)./Data(9+i,:), 'r');      
        ylabel('LO PT');
        
        h(length(h)+1) = subplot(3,1,3);
        plot(tt(:), Data(14+i,:)./Data(13+i,:), 'b'); hold on;
        plot(tt(:), Data(15+i,:)./Data(13+i,:), 'g');
        plot(tt(:), Data(16+i,:)./Data(13+i,:), 'r');      
        ylabel('Hi PT');   
        xlabel(XLabel);
        
        figure(NFig+9);
        clf reset
        h(length(h)+1) = subplot(3,1,1);
        plot(tt(:), m1/m1(1), 'b'); hold on;
        plot(tt(:), m2/m2(1), 'g');
        plot(tt(:), m3/m3(1), 'r');
        ylabel('RFMag');
        title([Prefix_All{iBPM} ' ']);
        
        h(length(h)+1) = subplot(3,1,2);
        plot(tt(:), l1, 'b'); hold on;
        plot(tt(:), l2, 'g');
        plot(tt(:), l3, 'r');      
        ylabel('LO PT');
        
        h(length(h)+1) = subplot(3,1,3);
        plot(tt(:), h1, 'b'); hold on;
        plot(tt(:), h2, 'g');
        plot(tt(:), h3, 'r');      
        ylabel('Hi PT');
        xlabel(XLabel);

        figure(NFig+10);
        clf reset
        h(length(h)+1) = subplot(3,1,1);
        plot(tt(:), Data(5+i,:)./Data(5+i,1), 'b'); hold on;
        plot(tt(:), Data(6+i,:)./Data(6+i,1), 'g');
        plot(tt(:), Data(7+i,:)./Data(7+i,1), 'r');
        plot(tt(:), Data(8+i,:)./Data(8+i,1), 'k');
        ylabel('RFMag');
        title([Prefix_All{iBPM} ' ']);
        
        h(length(h)+1) = subplot(3,1,2);
        plot(tt(:), Data( 9+i,:)./Data( 9+i,1), 'b'); hold on;
        plot(tt(:), Data(10+i,:)./Data(10+i,1), 'g');
        plot(tt(:), Data(11+i,:)./Data(11+i,1), 'r');
        plot(tt(:), Data(12+i,:)./Data(12+i,1), 'k');      
        ylabel('LO PT');
        
        h(length(h)+1) = subplot(3,1,3);
        plot(tt(:), Data(13+i,:)./Data(13+i,1), 'b'); hold on;
        plot(tt(:), Data(14+i,:)./Data(14+i,1), 'g');
        plot(tt(:), Data(15+i,:)./Data(15+i,1), 'r');
        plot(tt(:), Data(16+i,:)./Data(16+i,1), 'k');      
        ylabel('Hi PT');
        xlabel(XLabel);
        
        figure(NFig+11);
        clf reset
        h(length(h)+1) = subplot(3,1,1);
        plot(tt(:), 1000*(xx-xx(1)), 'b');
        ylabel('Horiztonal [\mum]');
        title([Prefix_All{iBPM} ' (PT Scaling)']);
        %yaxis([-1 1]);
        axis tight;
        h(length(h)+1) = subplot(3,1,2);
        plot(tt(:), 1000*(yy-yy(1)), 'b');
        ylabel('Vertical [\mum]');
        %yaxis([-1 1]);
        axis tight;
        h(length(h)+1) = subplot(3,1,3);
        plot(tt(:), ss, 'b');
        ylabel('Sum');
        xlabel(XLabel);
        axis tight;

        figure(NFig+12);
        clf reset
        h(length(h)+1) = subplot(3,1,1);
        plot(tt(:), 1000*(xx_noscaling-xx_noscaling(1)), 'b');
        ylabel('Horiztonal [\mum]');
        %yaxis([-1 1]);
        axis tight;
        title([Prefix_All{iBPM} ' (No PT Scaling)']);
        h(length(h)+1) = subplot(3,1,2);
        plot(tt(:), 1000*(yy_noscaling-yy_noscaling(1)), 'b');
        ylabel('Vertical [\mum]');
        %yaxis([-1 1]);
        axis tight;
        h(length(h)+1) = subplot(3,1,3);
        plot(tt(:), ss_noscaling, 'b');
        ylabel('Sum');
        xlabel(XLabel);

%         figure(NFig+10);
%         clf reset
%         h(length(h)+1) = subplot(1,1,1);
%         plot(tt, 1000*(xx-xx(1)), 'b', tt(:), 1000*(yy-yy(1)), 'g');
%         xlabel(XLabel);
%         ylabel('Orbit [\mum]');
%         title(['Orbit With Pilot Tone Correction Removed  -  ', Prefix_All{iBPM}]);
%         legend('Horizontal','Vertical','Location','Best');
%         axis tight;
    end

    
    linkaxes(h, 'x');
    % xaxis([0 3]);
    xaxis([0 tout(N)]);
    
    pause;
end


return




%%
%h = h(1:2);
figure(100);
clf reset
h = subplot(2,1,1);
plot(tout(1:N), SA.Data(iDCCT,1:N));
xlabel(XLabel);
ylabel('DCCT [mA]');
%yaxis([-.03 .03]);
axis tight;

h(length(h)+1) = subplot(2,1,2);
plot(tout(1:N), 1e6*(SA.Data(iRF,1:N)-SA.Data(iRF,1)));
xlabel(XLabel);
ylabel('\Delta RF [Hz]');
%yaxis([-.03 .03]);
axis tight;
linkaxes(h, 'x');




%%

figure(101);
clf reset

h = subplot(2,1,1);
h(2) = subplot(2,1,2);

for iBPM = 1:3
    i = PVsPerBPM*(iBPM-1) + 1;
    
    LineColor = nxtcolor;
    %h(length(h)+1) =
    axes(h(1));
    plot(tout(1:N), 1000*(SA.Data(i,1:N)-SA.Data(i,1)), 'Color', LineColor);
    %yaxis([-75 75]);
    if i == 1
        ylabel('Horizontal [\mum]');
        xlabel(XLabel);
        hold on;
    end
    
    axes(h(2));
    plot(tout(1:N), 1000*(SA.Data(i+1,1:N)-SA.Data(i+1,1)), 'Color', LineColor);
    if i == 1
        ylabel('Vertical [\mum]');
        xlabel(XLabel);
        hold on;
    end
    
    %pause;
end

yaxiss([-.5 .5]);

subplot(2,1,1);
title('New  BPMs (Split signal)');
linkaxes(h, 'x');

legend('Lorch','Mini-Circuits','CTS');



%%

figure(102);
clf reset

h = subplot(2,1,1);
h(2) = subplot(2,1,2);

for iBPM = 1:NBPM
    i = PVsPerBPM*(iBPM-1) + 1;
    
    LineColor = nxtcolor;
    %h(length(h)+1) =
    axes(h(1));
    plot(tout(1:N), 1000*(SA.Data(i,1:N)-SA.Data(i,1)), 'Color', LineColor);
    %yaxis([-75 75]);
    if i == 1
        hold on;
    end
    
    axes(h(2));
    plot(tout(1:N), 1000*(SA.Data(i+1,1:N)-SA.Data(i+1,1)), 'Color', LineColor);
    if i == 1
        hold on;
    end
    
    %pause;
end

linkaxes(h, 'x');

subplot(2,1,1);
title('New  BPMs');
ylabel('Horizontal [\mum]');
xlabel(XLabel);
yaxis([-100 100]);
linkaxes(h, 'x');

subplot(2,1,2);
yaxis([-40 40]);
ylabel('Vertical [\mum]');
xlabel(XLabel);



%%

nBergoz = size(d,1);

figure(103);
clf reset

h = subplot(2,1,1);
h(2) = subplot(2,1,2);
  
for i = 1:nBergoz
    LineColor = nxtcolor;
    %h(length(h)+1) =
    axes(h(1));
    plot(tout(1:N), 1000*(SA.Data(iBergoz+i-1,1:N)-SA.Data(iBergoz+i-1,1)), 'Color', LineColor);
    %yaxis([-75 75]);
    if i == 1
        %title(sprintf('Bergoz BPM(%d,%d)', d(i,:)));
        hold on;
    end
    
    axes(h(2));
    plot(tout(1:N), 1000*(SA.Data(iBergoz+nBergoz+i-1,1:N)-SA.Data(iBergoz+nBergoz+i-1,1)), 'Color', LineColor);
    if i == 1
        hold on;
    end
    
    %pause;
end

subplot(2,1,1);
title('Bergoz  BPMs');
ylabel('Horizontal [\mum]');
xlabel(XLabel);
yaxis([-100 100]);
linkaxes(h, 'x');

subplot(2,1,2);
yaxis([-40 40]);
ylabel('Vertical [\mum]');
xlabel(XLabel);



%%

nBergoz = size(d,1);

figure(104);
clf reset

[bx2,by2] = modelbeta('BPMx',[1 2],'BPMy',[1 2])
[bx3,by3] = modelbeta('BPMx',[1 3],'BPMy',[1 3])

i = 1; %nBergoz
LineColor = nxtcolor;
%h(length(h)+1) =
subplot(2,1,1);
plot(tout(1:N), 1000*(SA.Data(iBergoz+i-1,1:N)-SA.Data(iBergoz+i-1,1))*sqrt(bx3/bx2), 'Color', LineColor);
%yaxis([-75 75]);
axis tight
ylabel('Horizontal [\mum]');
title(sprintf('Bergoz BPM(%d,%d)', d(i,:)));
hold on;

subplot(2,1,2);
plot(tout(1:N), 1000*(SA.Data(iBergoz+nBergoz+i-1,1:N)-SA.Data(iBergoz+nBergoz+i-1,1))*sqrt(by3/by2), 'Color', LineColor);
%yaxis([-75 75]);
axis tight
ylabel('Vertical [\mum]');
hold on;


  
%% 

load BergozWithPTCombiner

figure(105)
clf reset

subplot(2,1,1);
plot(t/60, 1000*(a(1,:)-a(1,1)),'b')
hold on
plot(t/60, 1000*(a(3,:)-a(3,1)),'g')
plot(t/60, 1000*(a(5,:)-a(5,1)),'r')
%yaxis([-75 75]);
axis tight
ylabel('Horizontal [\mum]');
title('Bergoz BPMs - BPM6 connected to button 4 which has a pilot tone combiner.');
legend(ChannelNames([1 3 5],:));

subplot(2,1,2);
plot(t/60, 1000*(a(2,:)-a(2,1)),'b')
hold on
plot(t/60, 1000*(a(4,:)-a(4,1)),'g')
plot(t/60, 1000*(a(6,:)-a(6,1)),'r')
%yaxis([-75 75]);
axis tight
ylabel('Vertical [\mum]');
xlabel('Time [Minutes]');
legend(ChannelNames([2 4 6],:));



%%
% Ethernet Address,00:19:24:00:06:3B
% IP Address,131.243.89.129
% IP Netmask,255.255.255.0
% IP Gateway,131.243.89.1
% PLL RF divisor,328
% PLL multiplier,77
% Single pass?,1
% Single pass event,0
% EVR clocks per fast acquisition,12464
% EVR clocks per slow acquisition,12464000
% ADC for button ABCD,3120
% X calibration (mm p.u.),16
% Y calibration (mm p.u.),16
% Q calibration (p.u.),10
% Button rotation (0 or 45),0

AFE2Rev4 = [1 17 35 41 42];
%AFE2Rev4 = [1 35 42];

figure(99);
clf reset
for iBPM = AFE2Rev4 %1:NBPM
    
    i = PVsPerBPM*(iBPM-1);
    
    LineColor = nxtcolor;
    
    hh = subplot(2,1,1);
    plot(tout(1:N), 1000*(SA.Data(1+i,1:N) - SA.Data(1+i,1111)), 'Color', LineColor);
    hold on;
    
    hh(2) = subplot(2,1,2);
    plot(tout(1:N), 1000*(SA.Data(2+i,1:N) - SA.Data(2+i,1111)), 'Color', LineColor);
    hold on;
    
%     pause
end

linkaxes(hh, 'x');

subplot(2,1,1);
ylabel('Horizontal [\mum]');
title('AFE2 Rev4');
subplot(2,1,2);
ylabel('Vertical [\mum]');
xlabel(XLabel);
legend(Prefix_All{AFE2Rev4});


figure(100);
clf reset

NN = 1:NBPM;
NN(AFE2Rev4) = [];
for iBPM = NN
    
    i = PVsPerBPM*(iBPM-1);
    
    LineColor = nxtcolor;
    
    subplot(2,1,1);
    plot(tout(1:N), 1000*(SA.Data(1+i,1:N) - SA.Data(1+i,1111)), 'Color', LineColor);
    hold on;
    
    subplot(2,1,2);
    plot(tout(1:N), 1000*(SA.Data(2+i,1:N) - SA.Data(2+i,1111)), 'Color', LineColor);
    hold on;
    
%     pause
end

subplot(2,1,1);
ylabel('Horizontal [\mum]');
title('Older AFE Rev');
subplot(2,1,2);
ylabel('Vertical [\mum]');
xlabel(XLabel);



%%

% Every 29 is a BPM  (A=c3  B=c1  C=c2  D=c0)
% 'SA:X -> 1
% 'SA:Y -> 2
% 'SA:Q -> 3
% 'SA:S -> 4
%
% 'ADC3:rfMag -> 5
% 'ADC1:rfMag -> 6
% 'ADC2:rfMag -> 7
% 'ADC0:rfMag -> 8
%
% 'ADC3:ptLoMag ->  9
% 'ADC1:ptLoMag -> 10
% 'ADC2:ptLoMag -> 11
% 'ADC0:ptLoMag -> 12
%
% 'ADC3:ptHiMag -> 13
% 'ADC1:ptHiMag -> 14
% 'ADC2:ptHiMag -> 15
% 'ADC0:ptHiMag -> 16
%
% 'AFE:0:temperature -> 17
% 'AFE:1:temperature -> 18
% 'AFE:2:temperature -> 19
% 'AFE:3:temperature -> 20
% 'AFE:4:temperature -> 21
% 'AFE:5:temperature -> 22
% 'AFE:6:temperature -> 23
% 'AFE:7:temperature -> 24
% 'DFE:0:temperature -> 25
% 'DFE:1:temperature -> 26
% 'DFE:2:temperature -> 27
% 'DFE:3:temperature -> 28
% 'FPGA:temperature  -> 29






%%

tout = SA.t;

XLabel = 'Time [Hours]';
TimeScale = 60*60;  % Hours
tout(1,1:N) = tout(1,1:N)/TimeScale;

figure(1001);
clf reset

for i = 1:77
    ii = iBergoz+77+i-1;
    %plot(tout(1:N), SA.Data(iBergoz+77-1,1:N));
    %plot(tout(1:N), SA.Data(ii,1:N));
    plot(SA.Data(ii,1:N));
    title(RFPV(ii,:));
    xlabel(XLabel);
    ylabel('Vertical [mm]');
pause
end


%%

figure(3001)
ii = iBergoz+77;
plot(SA.Data(ii:ii+76,2300) - SA.Data(ii:ii+76,2000));


d = getbpmlist;
s = getspos('BPMy', d);
for i = 1:length(d)
    ii = findrowindex(family2channel('BPMy',d(i,:)), RFPV);
    dy(i,1) = SA.Data(ii,2300) - SA.Data(ii,2000);
end
figure(3002)
plot(s, dy);



%%

% VCM
% 25 [5 1]
% 29 [5 7]
% 30 [5 8]
m = getbpmresp('struct');

figure(3001);
for i = 1:size(m(2,2).Data,2)
    i
    a = m(2,2).Data(:,i) / max(m(2,2).Data(:,i));
    plot(s, dy/max(dy), 'b.-', s, a, 'r.-', s, -1*a, 'g.-');
   pause
end



%%
switch2sim

global THERING
iat = family2atindex('BEND',[4 1])

y0 = gety;
THERING{iat}.PolynomA(1) = 1e-6;
y1 = gety;
a = y1 - y0;
a = a/max(a);

figure(3002);
plot(s, dy/max(dy), 'b.-', s, a, 'r.-', s, -1*a, 'g.-');

THERING{iat}.PolynomA(1) = 0;

%%

switch2sim

global THERING
iat = family2atindex('VCM',[5 1])
%iat = family2atindex('VCM',[5 7])
%iat = family2atindex('VCM',[5 8])

y0 = gety;
THERING{iat}.KickAngle(2) = 1e-6;
y1 = gety;
a = y1 - y0;
a = a/max(a);

figure(3003);
plot(s, dy/max(dy), 'b.-', s, a, 'r.-', s, -1*a, 'g.-');
plot(s, dy/max(dy), 'b.-', s, -1*a, 'r.-');

THERING{iat}.KickAngle(2) = 0;


%%
switch2sim

global THERING
%iat = family2atindex('QF',[5 1])
iat = family2atindex('QF',[5 2])
%iat = family2atindex('QD',[5 2])

y0 = gety;
THERING{iat}.PolynomA(1) = 1e-6;
y1 = gety;
a = y1 - y0;
a = a/max(a);

figure(3004);
plot(s, dy/max(dy), 'b.-', s, a, 'r.-');
xlabel('S-Position [m]');
ylabel('Vertical [mm]');
title('Orbit error vs Vertical Kick at QF(5,2)');

THERING{iat}.PolynomA(1) = 0;



%%

Prefix_All =   {'SR01C:BPM1'; 'SR01C:BPM3'; 'SR01C:BPM4'; 'SR01C:BPM5' };

for iBPM = 2%1:length(Prefix_All)
    for j = 0:3
        x = getpv(sprintf('%s:SA:X',             Prefix_All{iBPM}));
        y = getpv(sprintf('%s:SA:Y',             Prefix_All{iBPM}));
        g = getpv(sprintf('%s:ADC%d:gainFactor', Prefix_All{iBPM}, j));
        m = getpv(sprintf('%s:ADC%d:rfMag',      Prefix_All{iBPM}, j));
        l = getpv(sprintf('%s:ADC%d:ptLoMag',    Prefix_All{iBPM}, j));
        h = getpv(sprintf('%s:ADC%d:ptHiMag',    Prefix_All{iBPM}, j));
        fprintf('%s:ADC%d  g=%.6f   RFMag/g=%9.6f   RFMag=%.6f   g*LoMag=%9.6f   g*HiMag=%9.6f   x=%9.6f   y=%9.6f\n', Prefix_All{iBPM}, j, g, m/g, m, g*l, g*h, x, y);
    end
    fprintf('\n');
end



%%
% SR01C:BPM2  1
% SR06C:BPM1 17  DCCT dependency in 2-bunch?  Channel C still odd????,  [4 1]???
% SR10C:BPM7 35
% SR12C:BPM1 41 noisey in 2-bunch?  Old software!!!
% SR12C:BPM2 42
%
% SR01C:BPM7 2
% SR01C:BPM8 3
% SR02C:BPM2 4

for iBPM = 1:length(Prefix_All)
   fprintf('%d %s\n', iBPM, Prefix_All{iBPM});
end

for i = 1:length(Prefix_All)    
    SoftwareVersion = getpvonline([Prefix_All{i},':softwareRev'], 'char');
    FirmwareVersion = getpvonline([Prefix_All{i},':firmwareRev'], 'char');
    
    fprintf('  %3d.  %s Software Ver %s  Firmare Ver %s\n', i, Prefix_All{i}, SoftwareVersion, FirmwareVersion);
end




