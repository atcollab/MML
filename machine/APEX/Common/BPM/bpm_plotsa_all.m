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
load SA_All_Set22
N = size(SA.Data,2);


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


NBPM       = length(Prefix_All);
iDCCT      = (NBPM * PVsPerBPM) + 1;
iRF        = (NBPM * PVsPerBPM) + 2;
iRFCounter = (NBPM * PVsPerBPM) + 3;
iBergoz    = (NBPM * PVsPerBPM) + 4;
nBergoz = size(d,1);
iID = iBergoz + 2*nBergoz;

tout = SA.t;


%%


XLabel = 'Time [Hours]';
TimeScale = 60*60;  % Hours
tout(1,1:N) = tout(1,1:N)/TimeScale;


h = [];

NFig = 2001; 


% 38 - SR10C:BPM7

%for iBPM = 41 %17 %1:NBPM
for iBPM = 1:NBPM
    
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
    h(length(h)+1) = subplot(1,1,1);
    plot(tout(1:N), 1000*(SA.Data(1+i,1:N) - SA.Data(1+i,1)), 'b', tout(1:N), 1000*(SA.Data(2+i,1:N) - SA.Data(2+i,1)), 'g')
    xlabel(XLabel);
    ylabel('Orbit [\mum]');
    title(Prefix_All{iBPM});
    legend('Horizontal','Vertical','Location','Best');
    yaxis([-60 60]);
    %axis tight;
    
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
        plot(tout(1:N), SA.Data(13+i,1:N), 'b');
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
        % Clean up
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
    end
    
    linkaxes(h, 'x');
    % xaxis([0 3]);
    
    pause;
end


return



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

for iBPM = 1:NBPM
   fprintf('%d %s\n', iBPM, Prefix_All{iBPM});
end

for i = 1:length(Prefix_All)    
    SoftwareVersion = getpvonline([Prefix_All{i},':softwareRev'], 'char');
    FirmwareVersion = getpvonline([Prefix_All{i},':firmwareRev'], 'char');
    
    fprintf('  %3d.  %s Software Ver %s  Firmare Ver %s\n', i, Prefix_All{i}, SoftwareVersion, FirmwareVersion);
end



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

figure(101);
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


figure(102);
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

nBergoz = size(d,1);

figure(103);
clf reset

    
for i = 1:nBergoz
    LineColor = nxtcolor;
    %h(length(h)+1) =
    subplot(2,1,1);
    plot(tout(1:N), 1000*(SA.Data(iBergoz+i-1,1:N)-SA.Data(iBergoz+i-1,1111)), 'Color', LineColor);
    yaxis([-75 75]);
    if i == 1
        ylabel('Horizontal [\mum]');
        title(sprintf('Bergoz BPM(%d,%d)', d(i,:)));
        hold on;
    end
    
    subplot(2,1,2);
    plot(tout(1:N), 1000*(SA.Data(iBergoz+nBergoz+i-1,1:N)-SA.Data(iBergoz+nBergoz+i-1,1111)), 'Color', LineColor);
    if i == 1
        yaxis([-75 75]);
        ylabel('Vertical [\mum]');
        hold on;
    end
    
    %pause;
end

subplot(2,1,1);
title('Bergoz  BPMs');


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