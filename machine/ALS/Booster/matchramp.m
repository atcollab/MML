% To do:
% Get repeatibility of bend ramp AM
% Remove ILC linearity
% Try waveform correction
% Time range of correction?
% Is there a better BEND waveform to start with?
% Store the set waveforms to disk since you cann't get them.



clear

% High frequency poles for the compensation
Fc = 1000;


%FileName = uigetfile('*.mat', 'Pick a ramp file', '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070109/');

if ispc
    %i = 69;
    %FileName = sprintf('C:\\greg\\Matlab\\machine\\ALS\\BoosterData\\123INJ\\PowerSupplies\\BQFQD_ramping_20070109\\coordinated_ramp_B_QF_QD_20070109_4kHz_%d.txt', i);

    i = 2;
    FileName = sprintf('C:\\greg\\Matlab\\machine\\ALS\\BoosterData\\123INJ\\PowerSupplies\\BQFQD_ramping_20070111\\coordinated_ramp_B_QF_QD_20070111_4kHz_%d.txt', i);
    %\\Als-filer\physdata\matlab\srdata\powersupplies\BQFQD_ramping_20070109
else
    %i = 69;
    %FileName = sprintf('/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070109/coordinated_ramp_B_QF_QD_20070109_4kHz_%d.txt', i);

%    i = 1;
%    FileName = sprintf('/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070119/coordinated_ramp_B_QF_QD_20070119_4kHz_%d.txt', i);

%    i = 8;
%    FileName = sprintf('/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_current/test%d.txt', i)
%    Directory = '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_current/';
 
Directory = '/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20070124/';
d = dir(Directory);
FileName = [Directory d(end).name]
end

LineType = 'g';

fid = fopen(FileName,'r');
if fid == -1
    fprintf('   File open error.\n');
    return;
end
f = fscanf(fid, '%f\n', 1);
N = fscanf(fid, '%f\n', 1);
Data = fscanf(fid, '%f %f %f', [3 inf]);
fclose(fid);

Data = Data';
Data(:,1) =  60 * Data(:,1);  %  60->New Quad, 48->Old Quad
Data(:,2) =  60 * Data(:,2);  %  60->New Quad, 48->Old Quad  
Data(:,3) = 125 * Data(:,3);  % 125->New BEND, 80->Old BEND

%80*newbqfqd12.data(end/2:end,3),
%60*newbqfqd12.data(end/2:end,2)./(80*newbqfqd12.data(end/2:end,3))
%60*newbqfqd12.data(end/2:end,1)./(80*newbqfqd12.data(end/2:end,3))


% Cut the Data
%Data = Data(2000:end,:);



fs = 4000;
t = (0:(size(Data,1)-1)) / fs;


% Goal 
QFratio = Data(:,1)./Data(:,3); 
QDratio = Data(:,2)./Data(:,3);


if 1
    TimeFlag = 1;
    x = t;
    xLabelString = 'Time [Seconds]';
else
    TimeFlag = 0;
    x = Data(:,3);
    xLabelString = 'BEND Current [Amps]';
end


figure(1);
%clf reset
subplot(4,1,1);
plot(x, Data);
legend('QF', 'QD', 'BEND', 'Location', 'NorthWest');
axis tight;
grid on;
ylabel('[Amps]');
title('New Bend, QF Compensation');

subplot(4,1,2);
plot(x, QFratio, LineType);
hold on;
plot([min(x) max(x)],[.520 .520],'r');
hold off;
ylabel('QF/BEND (Goal .520)');
axis tight;
yaxis([.45 .6]);
grid on;

orient tall


figure(2);
%clf reset
subplot(4,1,1);
plot(x, Data);
legend('QF', 'QD', 'BEND', 'Location', 'NorthWest');
axis tight;
grid on;
title('New Bend, QD Compensation');

subplot(4,1,2);
plot(x, QDratio, LineType);
hold on;
plot([min(x) max(x)],[.535 .535],'r');
hold off;
ylabel('QD/BEND (Goal .535)');
axis tight;
yaxis([.45 .6]);
grid on;

orient tall


% Power supply TF
w = 2 * pi * 10;
sys = tf(1,[1/w 1]);
%bode(H)


%t = (0:0.00001:.25)';


% Track the following system
%QFratio = sin(2*pi*5*t);
%QFratio = sin(2*pi*5*t) + .25*square(2*pi*5*t) - .25;
%QFratio = step(sys, t);
%randn('state',0);
%QFratio = randn(length(t));
%QFratio = QFratio(:);


% The inverse system
sysinv = tf([1/w 1],conv([1/Fc 1],[1/Fc 1]));


% Put the error waveform through the inverse system
QFErr = QFratio - .520;
QDErr = QDratio - .535;

% Zero the error until the system can be controlled (old bend)
i = find(t < .01);
QFErr(i) = 0;
QDErr(i) = 0;

% Slowly zero the error after the top of the ramp
i = find(t > .85);
QFErr(i) = linspace(QFErr(i(1)),0,length(i));
QDErr(i) = linspace(QDErr(i(1)),0,length(i));

[QFcommand, tinv, xinv] = lsim(sysinv, -QFErr, t);
[QDcommand, tinv, xinv] = lsim(sysinv, -QDErr, t);


% Simulate the result
[QFsim, t1, x1] = lsim(sys, QFcommand, t);
[QDsim, t1, x1] = lsim(sys, QDcommand, t);


% % Put the offset back on
% QFcommand = QFcommand + .520;
% QDcommand = QDcommand + .520;
% QFsim = QFsim + .535;
% QDsim = QDsim + .535;


figure(1);
subplot(4,1,3);
plot(x,[QFratio-.520 QFcommand QFsim QFratio-.535+QFsim]);
ylabel('QF/BEND Error');
legend('QF/BEND-.520', '\DeltaQFcommand', '\DeltaQFsim', 'QF/BEND-.535+\DeltaQFsim', 'Location', 'SouthWest');
axis tight;
%yaxis([-.1 .1]);
grid on;

subplot(4,1,4);
plot(x, Data(:,3) .* QFcommand);
ylabel('\DeltaQF [Amps]');
xlabel(xLabelString);
axis tight;
%yaxis([-20 20]);
grid on;


figure(2);
subplot(4,1,3);
%plot(x, [QDratio QDcommand QDsim QDratio+QDsim]);
plot(x, [QDratio-.535 QDcommand QDsim QDratio-.535+QDsim]);
ylabel('QD/BEND Error');
legend('QD/BEND-.535', '\DeltaQDcommand', '\DeltaQDsim', 'QD/BEND-.535+\DeltaQDsim', 'Location', 'SouthWest');
axis tight;
%yaxis([-.1 .1]);
grid on;

subplot(4,1,4);
plot(x, Data(:,3) .* QDcommand);
ylabel('\DeltaQD [Amps]');
xlabel(xLabelString);
axis tight;
%yaxis([-20 20]);
grid on;

% ysim = 0;
% clf
% for i = 1:10
%     Err = QFratio - ysim;
%     [yr, tr, xr] = lsim(sysr, Err, t);
% 
%     unew = unew + yr;
%     [ysim, t1, x] = lsim(sys,unew,t);
% 
%     plot(t,[unew(:) yr(:) ysim(:) QFratio(:)]);
% 
%     legend('unew','yr','ysim','QFratio');
%     
%     %[ysim, t1, x] = lsim(sys,unew,t);
%     %plot(t,[unew(:) ysim(:) QFratio(:)]);
%     %unew = unew + (QFratio-ysim(:)');
%     
%     i; %pause;
% end



