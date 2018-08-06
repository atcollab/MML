% Single Bunch Measurement Setup

% 0. BPM in splitter mode?  
%    Pilot tone removed for TBT!!!
% 1. Turn off table and target one bucket (like 1 or 308)
% 2. RMS and/or I-Q mode
% 3. Single or four bunch injection?
% 4. Turn off automatic tune measurment using SR06C:BPM7  [6 8]
% 5. Turn off other programs the use the BPM recorders

asdgfasdfgasdg

% Switching bucket loading from table mode to direct bucket control
fprintf('Bucket loading is controlled directly by this program\n');
setpv('SR01C___TIMING_AC11',0);
setpv('SR01C___TIMING_AC13',0);

BucketNumber = 308;
fprintf('Filling bucket %d\n',BucketNumber);
setpv('SR01C___TIMING_AC08', BucketNumber);

gunwidth = 12;  %  12 or 36           % gunwidth for 1 or 44 gun bunches in ns
fprintf('Setting gun width to %d ns\n',gunwidth);
setpv('GTL_____TIMING_AC02',gunwidth+1);
pause(2);
setpv('GTL_____TIMING_AC02',gunwidth);

% Bias???


%%
bpm_trigger('armextraction');
pause(2);

Prefix = getfamilydata('BPM','BaseName');
BCM = getbcm('Struct');
TBT = bpm_gettbt;

for i = 1:length(TBT); 
    DelR(i,1) = real(TBT{i}.TsA(1))-real(TBT{1}.TsA(1));
    DelI(i,1) = imag(TBT{i}.TsA(1))-imag(TBT{1}.TsA(1));
    fprintf('%s   %s   delR=%d   delI=%d\n',TBT{i}.PVPrefix ,TBT{i}.TsStr(1,:), real(TBT{i}.TsA(1))-real(TBT{1}.TsA(1)), imag(TBT{i}.TsA(1))-imag(TBT{1}.TsA(1)) );
end


%%
%save SingleBunch_Injection_Set2 TBT DelR DelI BCM Prefix
save MultiBunch_Injection_Set2 TBT DelR DelI BCM Prefix



%%
figure(1);
clf reset

for i = 1:length(Prefix)
    plot(TBT{i}.X - TBT{i}.X(1), '.-', 'Color', nxtcolor);
    hold on
    
    % SingleBunch_BumpsOn_Set1
    axis(1.0e+05 *[ 0.2685    0.2686   -0.0785    2.9481]);
    
    %i
    %pause;
end

%%

Delay0 = [
    65
    65
    68
    68
    69
    1
    2
    3
    20
    20
    20
    22
    16
    14
    17
    18
    20
    22
    22
    24
    8
    8
    9
    10
    24
    24
    26
    27
    42
    43
    42
    45
    48
    48
    49
    50
    74
    73
    74
    75
    71
    71
    72];

%load SingleBunch_Injection_Set1

figure(1);
clf reset

t = 1:length(TBT{1}.S);
for i = 1:length(Prefix)
    if any(i == [1:34 36])
        fprintf('No Shift:  ');
        plot(t, TBT{i}.S, '.-', 'Color', nxtcolor);
    else
        fprintf('Shift -1:  ');
        plot(t-1, TBT{i}.S, '.-', 'Color', nxtcolor);
    end
    hold on
    
    % SingleBunch_Injection_Set1
     axis(1.0e+05 *[ 0.26839    0.26844   0    3]);

    % SingleBunch_Injection_Set2
    %axis(1.0e+05 *[ 0.2685    0.2687   -0.0785    2.9481]);
    
    fprintf('  %3d.  %4d  %4d  %4d  %4d  %4d   DelTS=%4d\n', i, imag(TBT{i}.TsA(1)), DelI(i), 8*Delay0(i), DelI(i)+8*Delay0(i), DelI(i)-8*Delay0(i), DelI2(i)-DelI1(i));
    pause;
end

%%
figure(14);
clf reset

load Master_Delta_TimeStamp

t = 1:length(TBT{1}.S);
for i = 1:length(Prefix)
    if 0
        if DelTS_Master(i) - DelI(i) > 656/2
            fprintf('Shift -1:  ');
            plot(t-1, TBT{i}.X - TBT{i}.X(1), '.-', 'Color', nxtcolor);
        elseif DelTS_Master(i) - DelI(i) < -656/2
            fprintf('Shift +1:  ');
            plot(t+1, TBT{i}.X - TBT{i}.X(1), '.-', 'Color', nxtcolor);
        else
            fprintf('No Shift:  ');
            plot(t, TBT{i}.X - TBT{i}.X(1), '.-', 'Color', nxtcolor);
        end
    elseif 1
        if DelTS_Master(i) - DelI(i) > 656/2
            fprintf('Shift -1:  ');
            plot(t-1, TBT{i}.Y - TBT{i}.Y(1), '.-', 'Color', nxtcolor);
        elseif DelTS_Master(i) - DelI(i) < -656/2
            fprintf('Shift +1:  ');
            plot(t+1, TBT{i}.Y - TBT{i}.Y(1), '.-', 'Color', nxtcolor);
        else
            fprintf('No Shift:  ');
            plot(t, TBT{i}.Y - TBT{i}.Y(1), '.-', 'Color', nxtcolor);
        end
    else
        if DelTS_Master(i) - DelI(i) > 656/2
            fprintf('Shift -1:  ');
            plot(t-1, TBT{i}.S, '.-', 'Color', nxtcolor);
        elseif DelTS_Master(i) - DelI(i) < -656/2
            fprintf('Shift +1:  ');
            plot(t+1, TBT{i}.S, '.-', 'Color', nxtcolor);
        else
            fprintf('No Shift:  ');
            plot(t, TBT{i}.S, '.-', 'Color', nxtcolor);
        end
    end
    hold on
    
    % SingleBunch_Injection_Set1
    % axis(1.0e+05 *[ 0.26839    0.26844   0    3]);

    % SingleBunch_Injection_Set2
    %axis(1.0e+05 *[ 0.2685    0.2687   -0.0785    2.9481]);
    
    %fprintf('  %3d.  %4d  %4d  %4d  %4d  %4d   DelTS=%4d\n', i, imag(TBT{i}.TsA(1)), DelI(i), 8*Delay0(i), DelI(i)+8*Delay0(i), DelI(i)-8*Delay0(i), DelTS_Master(i) - DelI(i));
    fprintf('  %3d.  %4d   %4d   DelTS=%4d\n', i, imag(TBT{i}.TsA(1)), DelI(i), DelTS_Master(i) - DelI(i));
   % pause;
end


%%
for i = 1:length(Prefix)
    if any(i == [1:34 36])
        fprintf('No Shift:  ');
        plot(t, TBT{i}.S, '.-', 'Color', nxtcolor);
    else
        fprintf('Shift -1:  ');
        plot(t-1, TBT{i}.S, '.-', 'Color', nxtcolor);
    end
    hold on
    
    % SingleBunch_Injection_Set1
     axis(1.0e+05 *[ 0.26839    0.26844   0    3]);

    % SingleBunch_Injection_Set2
    %axis(1.0e+05 *[ 0.2685    0.2687   -0.0785    2.9481]);
    
    fprintf('  %3d.  %4d  %4d  %4d  %4d  %4d \n', i, imag(TBT{i}.TsA(1)), DelI(i), 8*Delay0(i), DelI(i)+8*Delay0(i), DelI(i)-8*Delay0(i));
    pause;
end



%% ADC PSD

% Make sure it's triggered first (bpm_trigger)

% Get data
ADC = bpm_getadc;
ENV = bpm_getenv;

% PSD setup
TurnsPerFFT = 160;
Setup.PSD.Nfft = 77 * TurnsPerFFT;
Setup.PSD.NaveMax = 350;
Setup.PSD.WindowFlag = 0;
Setup.PSD.Shift = 0;
Setup.PSD.FigNum = 101;

for i = 1:length(ADC)
    PSD{i,1} = bpm_adc2psd(ADC{i}, ENV{i}, Setup);
    pause
end



%% FA

% Make sure it's triggered first
% bpm_trigger

% Get data
FA = bpm_getfa;
DevList = family2dev('BPM');

for i = 1:length(FA)
    bpm_plotfa(FA{i}, 201);
    pause
end


%% More FA

for i = 1:length(FA)
    Xrms(i,1) = std(FA{i}.X);
    Yrms(i,1) = std(FA{i}.Y);
    Xpp(i,1) = max(FA{i}.X) - min(FA{i}.X);
    Ypp(i,1) = max(FA{i}.Y) - min(FA{i}.Y);
end

s = getspos('BPMx', DevList);
L = getfamilydata('Circumference');

figure(210);
clf reset
h = subplot(2,1,1);
plot(s, [Xrms Xpp], '.-');
ylabel('Horizontal Orbit [mm]');
title('FA Buffer STD adn Peak-to-Peak');
yaxis([0 .05]);

h(2) = subplot(2,1,2);
plot(s, [Yrms Ypp], '.-');
ylabel('Vertical Orbit [mm]');
xlabel('BPM Position [meters]');
yaxis([0 .04]);

linkaxes(h, 'x');

xaxis([0 L]);

figure(210);
clf reset
modeldisp([],'BPMx', DevList);



%%
s = getspos('BPMx', DevList);

nFig = 11;

i = 3;

% Plot 1 BPM FA
t = ((1:length(FA{i}.X))-1) / 10000;
figure(nFig);
clf reset
h = subplot(2,1,1);
plot(t, FA{i}.X);
title(sprintf('BPM(%d,%d) FA Data', DevList(i,:)));
ylabel('Horizontal Orbit [mm]');
yaxis([FA{i}.X(1)-1 FA{i}.X(1)+.5]); 

h(2) = subplot(2,1,2);
plot(t, FA{i}.Y);
ylabel('Vertical Orbit [mm]');
xlabel('Time [Seconds]');
yaxis([FA{i}.Y(1)-1 FA{i}.Y(1)+.5]); 
addlabel(1,0, FA{i}.TsStr(1,:));
linkaxes(h, 'x');

% Plot 1 BPM TBT
figure(nFig+1);
clf reset
h = subplot(2,1,1);
plot(TBT{i}.X);
title(sprintf('BPM(%d,%d) TBT Data', DevList(i,:)));
ylabel('Horizontal Orbit [mm]');
yaxis([TBT{i}.Y(1)-4 TBT{i}.Y(1)+.5]); 

h(2) = subplot(2,1,2);
plot(TBT{i}.Y);
ylabel('Vertical Orbit [mm]');
xlabel('Turns');
yaxis([TBT{i}.Y(1)-3 TBT{i}.Y(1)+.5]); 
addlabel(1,0, TBT{i}.TsStr(1,:));
linkaxes(h, 'x');

% Plot 1 BPM ADC
figure(nFig);
clf reset
plot([ADC{i}.A ADC{i}.B ADC{i}.C ADC{i}.D]);
title(sprintf('BPM(%d,%d) ADC Data', DevList(i,:)));
ylabel('Horizontal Orbit [mm]');
xlabel('Time [Seconds]');
%yaxis([FA{i}.Y(1)-1 FA{i}.Y(1)+.5]); 
addlabel(1,0, ADC{i}.TsStr(1,:));


x = [];
for iBPM = 1:36
    x(iBPM,:) = TBT{iBPM}.X';
    y(iBPM,:) = TBT{iBPM}.Y';
end

 for i = 1:36; 
     xx(i,:) = x(i,9000:10065) - x(i,9000);
     yy(i,:) = y(i,9000:10065) - y(i,9000);
 end

% Plot All BPM TBT
figure(nFig+3);
clf reset
h = subplot(2,1,1);
plot(s, xx);
title('TBT Data (10 Sectors)');
ylabel('Horizontal Difference Orbits [mm]');
%yaxis([TBT{i}.Y(1)-4 TBT{i}.Y(1)+.5]); 

h(2) = subplot(2,1,2);
plot(s, yy);
ylabel('Vertical Difference Orbits [mm]');
xlabel('BPM Position [meters]');
%yaxis([TBT{i}.Y(1)-3 TBT{i}.Y(1)+.5]); 
addlabel(1,0, TBT{i}.TsStr(1,:));
linkaxes(h, 'x');


%figure(nFig+4);
%clf reset
%[ss, nn] = meshgrid(s, 1:size(xx,2));
%surf(ss, nn, xx);
 
