% function plotsofb

%% Get data

% Orbit glitches

% 2006-04-13 - Owl shift - 93 subnet automatically reset
%StartTime = [2006 4 13 6 0 0];
%EndTime   = [2006 4 13 8 0 0];

% 2006-04-12 - Swing shift 
%StartTime = [2006 4 12 20 45 0];
%EndTime   = [2006 4 12 21 30 0];

%StartTime = [2006 4 16 16 30 0];
%EndTime   = [2006 4 16 18 0 0];

EndTime = clock;
StartTime = EndTime  - [0 0 0 12 0 0];



[DCCT, t, StartTime, EndTime] = getmysqldata('DCCT', StartTime, EndTime);
if isempty(t)
    return;
end

[IDGap, t, StartTime, EndTime] = getmysqldata([family2archive('ID','Monitor');family2archive('EPU','Monitor')], StartTime, EndTime);

[HCMtrim, t, StartTime, EndTime] = getmysqldata(family2archive('HCM','Trim',getcmlist('1 2 7 8')), StartTime, EndTime);
[VCMtrim, t, StartTime, EndTime] = getmysqldata(family2archive('VCM','Trim',getcmlist('1 2 7 8')), StartTime, EndTime);

[HCMam1278, t, StartTime, EndTime] = getmysqldata(family2archive('HCM','Monitor',getcmlist('1 2 7 8')), StartTime, EndTime);
for i = size(HCMam1278,2):-1:1
    HCMam1278(:,i) = HCMam1278(:,i) - HCMam1278(:,1) + HCMtrim(:,1);
end

[HCMam10, t, StartTime, EndTime] = getmysqldata(family2archive('HCM','Monitor',getcmlist('10')), StartTime, EndTime);
HCMam10 = HCMam10 / 20;  % This these are 20 time weaker magnets
for i = size(HCMam10,2):-1:1
    HCMam10(:,i) = HCMam10(:,i) - HCMam10(:,1);
end

[HCMam3456, t, StartTime, EndTime] = getmysqldata(family2archive('HCM','Monitor',getcmlist('3 4 5 6')), StartTime, EndTime);
for i = size(HCMam3456,2):-1:1
    HCMam3456(:,i) = HCMam3456(:,i) - HCMam3456(:,1);
end

[VCMam1278, t, StartTime, EndTime] = getmysqldata(family2archive('VCM','Monitor',getcmlist('1 2 7 8')), StartTime, EndTime);
for i = size(VCMam1278,2):-1:1
    VCMam1278(:,i) = VCMam1278(:,i) - VCMam1278(:,1) + VCMtrim(:,1);
end


[VCMam10, t, StartTime, EndTime] = getmysqldata(family2archive('VCM','Monitor',getcmlist('10')), StartTime, EndTime);
VCMam10 = VCMam10 / 5.5;  % This these are 5.5 time weaker magnets
for i = size(VCMam10,2):-1:1
    VCMam10(:,i) = VCMam10(:,i) - VCMam10(:,1);
end

[VCMam45, t, StartTime, EndTime] = getmysqldata(family2archive('VCM','Monitor',getcmlist('4 5')), StartTime, EndTime);
for i = size(VCMam45,2):-1:1
    VCMam45(:,i) = VCMam45(:,i) - VCMam45(:,1);
end

[BPMx, t, StartTime, EndTime] = getmysqldata(family2archive('BPMx','Monitor',getbpmlist('Bergoz')), StartTime, EndTime);
Golden = getgolden('BPMx', getbpmlist('Bergoz'));
for i = 1:size(BPMx,2)
    BPMx(:,i) = BPMx(:,i) - Golden;
end

[BPMy, t, StartTime, EndTime] = getmysqldata(family2archive('BPMy','Monitor',getbpmlist('Bergoz')), StartTime, EndTime);
Golden = getgolden('BPMy', getbpmlist('Bergoz'));
for i = 1:size(BPMy,2)
    BPMy(:,i) = BPMy(:,i) - Golden;
end


%% Plot 
figure(1);
clf reset
subplot(3,1,1)
plot(24*(t-floor(t(1))), HCMtrim); 
axis tight
ylabel('HCM.Trim [Amps]');
set(gca,'XTickLabel','');
drawnow;


subplot(3,1,2)
plot(24*(t-floor(t(1))), [HCMam1278; HCMam10]); 
axis tight
ylabel('Straight \DeltaHCM.Monitor [Amps]');
set(gca,'XTickLabel','');
drawnow;


subplot(3,1,3)
plot(24*(t-floor(t(1))), HCMam3456); 
axis tight
ylabel('Arc \DeltaHCM.Monitor [Amps]');
drawnow;

xlabel(sprintf('Time in Hours Starting at %s', StartTime(1:10)));
drawnow;


yaxesposition(1.25);
orient tall

addlabel(1,0, 'FF1 & FF1 not included.  Chicane correctors scaled to HCM/VCM magnitude.')


figure(2)
clf reset
subplot(3,1,1)
plot(24*(t-floor(t(1))), VCMtrim); 
axis tight
ylabel('VCM.Trim [Amps]');
set(gca,'XTickLabel','');
drawnow;


subplot(3,1,2)
plot(24*(t-floor(t(1))), [VCMam1278; VCMam10]); 
axis tight
ylabel('Straight \DeltaVCM.Monitor [Amps]');
set(gca,'XTickLabel','');
drawnow;


subplot(3,1,3)
plot(24*(t-floor(t(1))), VCMam45); 
axis tight
ylabel('Arc \DeltaVCM.Monitor [Amps]');
drawnow;

xlabel(sprintf('Time in Hours Starting at %s', StartTime(1:10)));
drawnow;


yaxesposition(1.25);
orient tall

addlabel(1,0, 'FF1 & FF1 not included.  Chicane correctors scaled to HCM/VCM magnitude.')



figure(3);
clf reset
subplot(4,1,1)
plot(24*(t-floor(t(1))), DCCT);
axis tight
ylabel('DCCT [mA]');
set(gca,'XTickLabel','');
drawnow;


subplot(4,1,2)
plot(24*(t-floor(t(1))), BPMx);
axis tight
ylabel('\DeltaBPMx [mm]');
set(gca,'XTickLabel','');
drawnow;


subplot(4,1,3)
plot(24*(t-floor(t(1))), BPMy);
axis tight
ylabel('\DeltaBPMy [mm]');
set(gca,'XTickLabel','');
drawnow;


subplot(4,1,4)
plot(24*(t-floor(t(1))), IDGap); 
axis tight
ylabel('ID Gap [mm]');
xlabel(sprintf('Time in Hours Starting at %s', StartTime(1:10)));
drawnow;


yaxesposition(1.25);
orient tall




%plot(t, HCMtrim); 
%datetick('x');
