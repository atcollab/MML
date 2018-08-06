

%% Beam dump plot example

clear

% Beam dumps are recorded using bpm_beamdump_save

% These are older files that might run with prefectly with this script
% 10-19-2014 at about  1:00 pm -> Power Dip
%                                 FileName = 'BeamDump_2014-10-19';
% 10-20-2014 at about  4:00 am -> End of the run RF trip to remove the beam
%                                 FileName = 'BeamDump_2014-10-20';
% 10-25-2014 at about 11:45 am -> TDK sextupole power supply turn off
% 10-28-2014 at about  1:07 am -> SR04 frontend vacuum
% 10-29-2014 at about  4:08 am -> Unknow (note: SR11C:BPM2 trigger earlier)
%                                 FileName = 'BeamDump_2014-10-29_04-08-54';
% 11-10-2014 at about  8:15 am -> End of the run RF trip to remove the beam  /home/physdata/BeamDump/BeamDump_2014-11-10_08-15-47

BeamDumpDir  = '/home/physdata/BeamDump/';


if 0
    % 01-26-2015 at about  7:44 pm -> Physics shift, manually turned off the RF to remove the 500mA beam (note: 6 BPM triggered early, not sure why???)
    FileName = 'BeamDump_2015-01-26_19-44-26';  % RF turned off by an operator
    nTurns = 9700:10075;
elseif 0
    % 2015-02-05 at about 12:07 pm -> Pcube, RF did not fault (some BPM triggered eariler, PSB maybe?)
    FileName = 'BeamDump_2015-02-05_12-07-24';
    nTurns = 1:140;
elseif 0
    % 2015-02-08 at about  8:57 am ->  (all BPM triggered together)
    FileName = 'BeamDump_2015-02-06_08-56-50_Reduced';
    nTurns = 1:140;
elseif 0
    % 2015-02-10 at about  4:23 pm -> RF HV Trip (all BPM triggered together)
    FileName = 'BeamDump_2015-02-10_16-23-45';
    nTurns = 1:130;
elseif 0
    % 2015-02-11 17:06:01.38 -> (all BPM triggered together)
    FileName = 'BeamDump_2015-02-11_17-06-01';
    nTurns = 1:1135;
elseif 0
    % RF HV (all BPM triggered together)
    FileName = 'BeamDump_2015-02-22_00-26-46';
    nTurns = 1:1135;
elseif 0
    % Bumped beam for physics by turning off the RF (all BPM triggered together)
    FileName = 'BeamDump_2015-02-23_10-31-26';
    nTurns = 1:1135;
elseif 0
    %  (all BPM triggered together)
    FileName = 'BeamDump_2015-02-28_10-57-01';
    nTurns = 1:1135;
elseif 0
    % Dumped the beam for cPCI issue (all BPM triggered together)
    FileName = 'BeamDump_2015-02-28_18-56-44';
    nTurns = 1:1300;
elseif 0
    % "Magnet Failure" (BPM SR06C:BPM7 triggered earilier since it's used for tune feedback)
    FileName = 'BeamDump_2015-03-05_21-29-06';
    nTurns = 1:1520;
elseif 0
    % ?Magnet power supply failure" (all BPM triggered together)
    FileName = 'BeamDump_2015-03-08_20-57-23';
    nTurns = 500:1075;
elseif 0
    %  
    FileName = 'BeamDump_2015-02-28_10-57-01';
    nTurns = 1:1135;
elseif 0
    % 2-Bunch - Sector 6 QD & QF breaker 318A-15 tripped (BPM SR06C:BPM7 triggered earilier since it's used for tune feedback)
    FileName = 'BeamDump_2015-04-02_07-41-37';
    nTurns = 1:1500;
elseif 0
    % End of the run beam dump (I assume it was done by turning the RF off)
    % Need to remove SR01C:BPM4 & SR06C:BPM7
    FileName = 'BeamDump_2015-05-04_06-50-34';
    nTurns = 1:1135;
elseif 0
    % ?Magnet power supply failure" (all BPM triggered together)
    FileName = 'BeamDump_2015-05-11_12-26-39';
    nTurns = 500:1075;
elseif 0
    % 2015-06-06 at about 1:05 pm -> Voltage Sag
    FileName = 'BeamDump_2015-06-06_13-05-15';
    nTurns = 1:1135;
elseif 1
    % 2015-06-07 at about 4:48 pm -> RF Circulator Temperature tripped due to bad TC
    FileName = 'BeamDump_2015-06-07_16-47-40';
    nTurns = 1:1135;
end

load([BeamDumpDir, FileName, '.mat']);


FontSize = 14;


nFig = 201;
iBPM = 20;

for i = 1:length(TBT)
    if isfield(TBT{i}, 'PVPrefix')
        Prefix{i} = TBT{i}.PVPrefix;
    else
        Prefix{i} = TBT{i}.Prefix;
    end
    s = str2num(Prefix{i}(3:4));
    d = str2num(Prefix{i}(10))+1;
    DevList(i,:) = [s d];
    
    Ts(i,1) = TBT{i}.Ts(1);
    fprintf('%s   %s  %s\n', Prefix{i}, ADC{i}.TsStr(1,:), TBT{i}.TsStr(1,:));
end

s = getspos('BPMx', DevList);
s(iBPM)
% Plot 1 BPM FA
if ~isempty(FA)
    t = 1000*((1:length(FA{iBPM}.X))-1) / 10000;
    figure(nFig);
    clf reset
    h = subplot(2,1,1);
    plot(t, FA{iBPM}.X);
    title(sprintf('BPM(%d,%d) FA Data', DevList(iBPM,:)), 'FontSize', FontSize+1);
    ylabel('Horizontal Orbit [mm]', 'FontSize', FontSize+1);
    yaxis([FA{iBPM}.X(1)-1 FA{iBPM}.X(1)+.5]);
    
    h(2) = subplot(2,1,2);
    plot(t, FA{iBPM}.Y);
    ylabel('Vertical Orbit [mm]', 'FontSize', FontSize+1);
    xlabel('Time [Milliseconds]', 'FontSize', FontSize+1);
    yaxis([FA{iBPM}.Y(1)-1 FA{iBPM}.Y(1)+.5]);
    addlabel(1,0, FA{iBPM}.TsStr(1,:));
    linkaxes(h, 'x');
end


% Plot 1 BPM TBT
figure(nFig+1);
clf reset
h = subplot(3,1,1);
plot(TBT{iBPM}.X);
title(sprintf('Turn-By-Turn Orbit Data at BPM(%d,%d)', DevList(iBPM,:)), 'FontSize', FontSize+1);
ylabel('Horizontal Orbit [mm]', 'FontSize', FontSize);
xaxis([nTurns(1) nTurns(end)])
yaxis([TBT{iBPM}.Y(1)-4 TBT{iBPM}.Y(1)+.5]); 

h(2) = subplot(3,1,2);
plot(TBT{iBPM}.Y);
ylabel('Vertical Orbit [mm]', 'FontSize', FontSize);
yaxis([TBT{iBPM}.Y(1)-3 TBT{iBPM}.Y(1)+.5]); 
xaxis([nTurns(1) nTurns(end)])

h(3) = subplot(3,1,3);
plot(TBT{iBPM}.S);
ylabel('Sum', 'FontSize', FontSize);
xlabel('Turn Number', 'FontSize', FontSize);
xaxis([nTurns(1) nTurns(end)])
%yaxis([TBT{i}.Y(1)-3 TBT{i}.Y(1)+.5]); 

addlabel(1,0, TBT{iBPM}.TsStr(1,:));
linkaxes(h, 'x');

% Plot 1 BPM ADC
figure(nFig+2);
clf reset
subplot(2,1,1);
plot([ADC{iBPM}.A ADC{iBPM}.B ADC{iBPM}.C ADC{iBPM}.D]);
title(sprintf('BPM(%d,%d) ADC Data', DevList(iBPM,:)), 'FontSize', FontSize+1);
ylabel('ADC [Counts]', 'FontSize', FontSize);
xlabel('ADC Sample Number [~8.526 nsec/sample]', 'FontSize', FontSize);
%yaxis([FA{iBPM}.Y(1)-1 FA{iBPM}.Y(1)+.5]); 
addlabel(1,0, ADC{iBPM}.TsStr(1,:));

subplot(2,1,2);
plot([TBT{iBPM}.S]);
title(sprintf('BPM(%d,%d) TBT Sum', DevList(iBPM,:)), 'FontSize', FontSize+1);
ylabel('SUM', 'FontSize', FontSize);
xlabel('Turn Number', 'FontSize', FontSize);
xaxis([nTurns(1) nTurns(end)])


x = []; xx = [];
y = []; yy = [];
for ii = 1:length(TBT)
    x(ii,:) = TBT{ii}.X';
    y(ii,:) = TBT{ii}.Y';
end

 for i = 1:length(TBT)
     xx(i,:) = x(i,nTurns) - x(i,nTurns(1));
     yy(i,:) = y(i,nTurns) - y(i,nTurns(1));
 end

% Plot All BPM TBT
figure(nFig+3);
clf reset
h = subplot(2,1,1);
plot(s, xx);
title(sprintf('Turn-By-Turn Orbit Data  (%d BPMs)',size(xx,1)), 'FontSize', FontSize+1);
ylabel('Horizontal Difference Orbits [mm]', 'FontSize', FontSize);
xlabel('BPM Position [meters]', 'FontSize', FontSize);
%yaxis([TBT{i}.Y(1)-4 TBT{i}.Y(1)+.5]); 

h(2) = subplot(2,1,2);
plot(s, yy);
ylabel('Vertical Difference Orbits [mm]', 'FontSize', FontSize);
xlabel('BPM Position [meters]', 'FontSize', FontSize);
%yaxis([TBT{i}.Y(1)-3 TBT{i}.Y(1)+.5]); 
addlabel(1,0, TBT{i}.TsStr(1,:));
linkaxes(h, 'x');


%figure(nFig+4);
%clf reset
%[ss, nn] = meshgrid(s, 1:size(xx,2));
%surf(ss, nn, xx);
 


% Plot 1 BPM ADC
figure(nFig+4);
clf reset
subplot(3,1,1);
plot([ADC{iBPM}.A ADC{iBPM}.B ADC{iBPM}.C ADC{iBPM}.D]);
title(sprintf('BPM(%d,%d) ADC Data - Before the Beam Dump', DevList(iBPM,:)), 'FontSize', FontSize+1);
ylabel('ADC [Counts]', 'FontSize', FontSize);
xaxis([0 3*77]+0);
yaxis([-2.5e4 2.5e4]);

subplot(3,1,2);
plot([ADC{iBPM}.A ADC{iBPM}.B ADC{iBPM}.C ADC{iBPM}.D]);
title(sprintf('BPM(%d,%d) ADC Data - Mid Beam Dump', DevList(iBPM,:)), 'FontSize', FontSize+1);
ylabel('ADC [Counts]', 'FontSize', FontSize);
xaxis([0 3*77]+77*70);
yaxis([-2.5e4 2.5e4]);

subplot(3,1,3);
plot([ADC{iBPM}.A ADC{iBPM}.B ADC{iBPM}.C ADC{iBPM}.D]);
title(sprintf('BPM(%d,%d) ADC Data - End of the Beam Dump', DevList(iBPM,:)), 'FontSize', FontSize+1);
ylabel('ADC [Counts]', 'FontSize', FontSize);
xaxis([0 3*77]+77*110);
yaxis([-1e4 1e4]);

xlabel('ADC Sample Number [~8.526 nsec/sample]', 'FontSize', FontSize);

%addlabel(1,0, ADC{iBPM}.TsStr(1,:));




return



%% Reduce the file size
% 
% clear
% 
% BeamDumpDir  = '/home/physdata/BeamDump/';
% FileName = 'BeamDump_2015-02-06_08-56-50';
% load([BeamDumpDir, FileName, '.mat']);
% nTurns = 1:140;
% nADC = 1:14000;
% 
% for i = 1:length(TBT)
%     TBT{i}.X = TBT{i}.X(nTurns);
%     TBT{i}.Y = TBT{i}.Y(nTurns);
%     TBT{i}.Q = TBT{i}.Q(nTurns);
%     TBT{i}.S = TBT{i}.S(nTurns);
%     TBT{i}.A = TBT{i}.A(nTurns);
%     TBT{i}.B = TBT{i}.B(nTurns);
%     TBT{i}.C = TBT{i}.C(nTurns);
%     TBT{i}.D = TBT{i}.D(nTurns);
% 
%     ADC{i}.A = ADC{i}.A(nADC);
%     ADC{i}.B = ADC{i}.B(nADC);
%     ADC{i}.C = ADC{i}.C(nADC);
%     ADC{i}.D = ADC{i}.D(nADC);
% end
% FA = {};
% 
% save([BeamDumpDir, FileName, '_Reduced.mat']);




