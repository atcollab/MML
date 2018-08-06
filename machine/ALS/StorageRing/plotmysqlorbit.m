function plotmysqlorbit
%PLOTMYSQLORBIT - Plot orbit data from the Mysql archiver
%
%  EXAMPLES
%  1. Get all the BPMx and DCCT data in the table
%     Note: if the start and end time is not included in the second call 
%           the data and time vectors may not match.
%     [d, t, StartTime, EndTime] = getmysqldata(family2channel('BPMx'));
%     subplot(2,1,1);
%     plot(24*(t-floor(t(1))), d); xlabel(sprintf('Time in Hours Starting at %s', StartTime));
%     [d, t] = getmysqldata('DCCT', StartTime, EndTime);
%     subplot(2,1,2);
%     plot(24*(t-floor(t(1))), d); xlabel(sprintf('Time in Hours Starting at %s', StartTime));
%
%  2. For data valid only during user beam  
%     [i,t] = getmysqldata('UserBeam', StartTime, EndTime);
%     d(:,find(i==0)) = NaN;
%     plot(24*(t-floor(t(1))), d); xlabel(sprintf('Time in Hours Starting at %s', StartTime));
%
%  See also archive_sr, archive_size, getmysqldata



%%%%%%%%%%%%%%%%%%
% Famous Moments %
%%%%%%%%%%%%%%%%%%

% Orbit Feedback glitch (note: this data was lost in a hard drive crash)
% StartTime = [2007 3 7 14 00 00];
% EndTime   = [2007 3 7 15 45 00];
% StartTime = [2007 3 7 15 02 00];
% EndTime   = [2007 3 7 15 12 00];
% StartTime = [2007 3 7 17 37 00]; % Top of the fill
% EndTime   = [2007 3 7 17 42 00];


%StartTime = [2007 8 3  0 0 0];
%EndTime   = [2007 8 4  0 0 0];

% IVID closing
%StartTime = [2007 10 17 8 00 0];
%EndTime   = [2007 10 17 12 0 0];

%StartTime = [2007 10 22 11 00 0];
%EndTime   = [2007 10 22 23 59 0];

%StartTime = [2007 12  3  0  0  0];
%EndTime   = [2007 12  3  8  0  0];

%StartTime = [2007 12 16  2  0  0];
%EndTime   = [2007 12 16  4  0  0];
%StartTime = [2007 8 3  0 0 0];
%EndTime   = [2007 8 4  0 0 0];

%StartTime = datevec(datenum(now)-1); % 1 day back
%EndTime   = now;

StartTime = datevec(datenum(now)-2/24); % hours back
EndTime   = now;

StartTime = datevec(datenum(now)-20/24/60); %minutes back
EndTime   = now;


[DCCT, t, StartTime, EndTime] = getmysqldata(family2archive('DCCT'), StartTime, EndTime);
if isempty(DCCT)
    return;
end

[UserBeam, t, StartTime, EndTime] = getmysqldata('UserBeam', StartTime, EndTime);


[x, t, StartTime, EndTime] = getmysqldata(family2archive('BPMx', getbpmlist('Bergoz')), StartTime, EndTime);
x = rmgolden('BPMx', x, getbpmlist('Bergoz'));

[y, t, StartTime, EndTime] = getmysqldata(family2archive('BPMy', getbpmlist('Bergoz')), StartTime, EndTime);
y = rmgolden('BPMy', y, getbpmlist('Bergoz'));

[RFam, t, StartTime, EndTime] = getmysqldata(family2archive('RF','Monitor'),  StartTime, EndTime);
[RFsp, t, StartTime, EndTime] = getmysqldata(family2archive('RF','Setpoint'), StartTime, EndTime);



DevList = family2dev('HCM','Trim',1,1);
[HCMtrim, t, StartTime, EndTime] = getmysqldata(family2archive('HCM', 'Trim', DevList), StartTime, EndTime);

[HCMsp, t, StartTime, EndTime] = getmysqldata(family2archive('HCM', 'Setpoint'), StartTime, EndTime);
[HCMam, t, StartTime, EndTime] = getmysqldata(family2archive('HCM', 'Monitor'),  StartTime, EndTime);
for i = 1:size(HCMam,1)
    HCMsp(i,:) = HCMsp(i,:) - HCMsp(i,1);
    HCMam(i,:) = HCMam(i,:) - HCMam(i,1);
end

[HCM10sp, t, StartTime, EndTime] = getmysqldata(family2archive('HCM', 'Setpoint', [3 10; 5 10; 10 10]), StartTime, EndTime);
[HCM10am, t, StartTime, EndTime] = getmysqldata(family2archive('HCM', 'Monitor',  [3 10; 5 10; 10 10]),  StartTime, EndTime);
for i = 1:size(HCM10am,1)
    HCM10sp(i,:) = HCM10sp(i,:) - HCM10sp(i,1);
    HCM10am(i,:) = HCM10am(i,:) - HCM10am(i,1);
end


DevList = family2dev('HCM','FF1',1,1);
[HCMff1, t, StartTime, EndTime] = getmysqldata(family2archive('HCM', 'FF1', DevList), StartTime, EndTime);

DevList = family2dev('HCM','FF2',1,1);
[HCMff2, t, StartTime, EndTime] = getmysqldata(family2archive('HCM', 'FF2', DevList), StartTime, EndTime);


[QFsp, t, StartTime, EndTime] = getmysqldata(family2archive('QF', 'Setpoint'), StartTime, EndTime);
[QFam, t, StartTime, EndTime] = getmysqldata(family2archive('QF', 'Monitor'),  StartTime, EndTime);
for i = 1:size(QFam,1)
    QFsp(i,:) = QFsp(i,:) - QFsp(i,1);
    QFam(i,:) = QFam(i,:) - QFam(i,1);
end


[ID,  t, StartTime, EndTime] = getmysqldata(family2archive('ID',  'Monitor'), StartTime, EndTime);
[EPU, t, StartTime, EndTime] = getmysqldata(family2archive('EPU', 'Monitor'), StartTime, EndTime);
[HCMCHICANEM, t, StartTime, EndTime] = getmysqldata(family2archive('HCMCHICANEM', 'Monitor'),  StartTime, EndTime);
for i = 1:size(HCMCHICANEM,1)
    HCMCHICANEM(i,:) = HCMCHICANEM(i,:) - HCMCHICANEM(i,1);
end


% Convert t to hours
t = 24*(t-floor(t(1)));

if 0
    % Only plot during user time
    i = find(UserBeam==0);
    HCMCHICANEM(:,i) = NaN;
    HCMff2(:,i) = NaN;
    ID(:,i) = NaN;
    RFam(:,i) = NaN;
    x(:,i) = NaN;
    HCM10am(:,i) = NaN;
    HCMam(:,i) = NaN;
    HCMsp(:,i) = NaN;
    QFam(:,i) = NaN;
    RFsp(:,i) = NaN;
    y(:,i) = NaN;
    EPU(:,i) = NaN;
    HCM10sp(:,i) = NaN;
    HCMff1(:,i) = NaN;
    HCMtrim(:,i) = NaN;
    QFsp(:,i) = NaN;
end



FigNum = 1;
h = [];

figure(FigNum);
FigNum = FigNum + 1;
clf reset

h(end+1,1) = subplot(2,1,1);
plot(t, x); 
%datetick('x');
ylabel('Horizontal [mm]');
title('Orbit Difference from the Golden Orbit');

h(end+1,1) = subplot(2,1,2);
plot(t, y); 
%datetick('x');
ylabel('Vertical [mm]');
xlabel(sprintf('Time in Hours Starting at %s', StartTime));
orient tall



figure(FigNum);
FigNum = FigNum + 1;
clf reset

h(end+1,1) = subplot(3,1,1);
plot(t, HCMsp); 
%datetick('x');
ylabel('\DeltaHCM.Setpoint [Amps]');
title('Horzontal Correctors');

h(end+1,1) = subplot(3,1,2);
plot(t, HCMtrim); 
%datetick('x');
ylabel('HCM.Trim [Amps]');

h(end+1,1) = subplot(3,1,3);
plot(t, HCMam); 
%datetick('x');
ylabel('\DeltaHCM.Monitor [Amps]');
xlabel(sprintf('Time in Hours Starting at %s', StartTime));
orient tall



figure(FigNum);
FigNum = FigNum + 1;
clf reset

h(end+1,1) = subplot(2,1,1);
plot(t, HCM10sp); 
%datetick('x');
ylabel('\DeltaHCM10.Setpoint [Amps]');
title('Horzontal Correctors');

h(end+1,1) = subplot(2,1,2);
plot(t, HCM10am); 
%datetick('x');
ylabel('\DeltaHCM10.Monitor [Amps]');
xlabel(sprintf('Time in Hours Starting at %s', StartTime));
orient tall



figure(FigNum);
FigNum = FigNum + 1;
clf reset

h(end+1,1) = subplot(2,1,1);
plot(t,HCMff1); 
%datetick('x');
ylabel('HCM.FF1');
title('Horzontal Correctors');

h(end+1,1) = subplot(2,1,2);
plot(t, HCMff2); 
%datetick('x');
ylabel('HCM.FF2 [Amps]');
xlabel(sprintf('Time in Hours Starting at %s', StartTime));
orient tall



figure(FigNum);
FigNum = FigNum + 1;
clf reset

h(end+1,1) = subplot(2,1,1);
plot(t, QFsp); 
%datetick('x');
ylabel('\DeltaQF.Setpoint [Amps]');

h(end+1,1) = subplot(2,1,2);
plot(t, QFam); 
%datetick('x');
ylabel('\DeltaQF.Monitor [Amps]');
xlabel(sprintf('Time in Hours Starting at %s', StartTime));
orient tall



figure(FigNum);
FigNum = FigNum + 1;
clf reset

h(end+1,1) = subplot(2,1,1);
plot(t, ID); 
%datetick('x');
ylabel('ID.Monitor [mm]');

h(end+1,1) = subplot(2,1,2);
plot(t, EPU); 
%datetick('x');
ylabel('EPU.Monitor [mm]');
xlabel(sprintf('Time in Hours Starting at %s', StartTime));
orient tall



figure(FigNum);
FigNum = FigNum + 1;
clf reset

h(end+1,1) = subplot(3,1,1);
plot(t, DCCT); 
%datetick('x');
ylabel('DCCT [mA]');
a = axis;
a(3) = 0;
axis(a);

h(end+1,1) = subplot(3,1,2);
plot(t, RFsp); 
%datetick('x');
ylabel('RF Setpoint [MHz]');

h(end+1,1) = subplot(3,1,3);
plot(t, HCMCHICANEM); 
%datetick('x');
ylabel('\DeltaHCMCHICANEM.Monitor');
xlabel(sprintf('Time in Hours Starting at %s', StartTime));
orient tall



try
    [IonGauge, tt, StartTime, EndTime] = getmysqldata(family2archive('IonGauge', 'Monitor'),  StartTime, EndTime);
    IonGauge(find(IonGauge<=0))=NaN;
    IonGauge(find(IonGauge>=1))=NaN;

  
    [IonPump,  tt, StartTime, EndTime] = getmysqldata(family2archive('IonPump',  'Monitor'),  StartTime, EndTime);
    IonPump(find(IonPump<=0))=NaN;
    IonPump(find(IonPump>=1))=NaN;

    figure(FigNum);
    FigNum = FigNum + 1;
    clf reset

    h(end+1,1) = subplot(2,1,1);
    semilogy(t, IonGauge);
    %datetick('x');
    ylabel('Ion Gauge Pressure [Torr]');

    %hold on
    %fprintf('   Sector 6 ion gauges have thicker line width.\n');
    %semilogy(t, IonGauge([14 15],:),'LineWidth',3);
    %hold off
    
    h(end+1,1) = subplot(2,1,2);
    semilogy(t, IonPump);
    %datetick('x');
    ylabel('Ion Pump Pressure [Torr]');
    xlabel(sprintf('Time in Hours Starting at %s', StartTime));
    orient tall

    
    figure(FigNum);
    FigNum = FigNum + 1;
    clf reset

    [ID6,  tt, StartTime, EndTime] = getmysqldata(family2archive('ID',  'Monitor', [6 1]), StartTime, EndTime);
    h(end+1,1) = subplot(2,1,1);
    plot(t, ID6);
    %datetick('x');
    ylabel('IVID [mm]');

    h(end+1,1) = subplot(2,1,2);
    semilogy(t, IonGauge([14 15],:));
    %datetick('x');
    ylabel('Ion Gauge Pressure [Torr]');
    xlabel(sprintf('Time in Hours Starting at %s', StartTime));
    orient tall
catch
end


linkaxes(h, 'x');

