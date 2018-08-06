% Check the power supply BW
% Test what the delay should be?  Sample rate or BW reasoning?
% Timing should not independent of BEND setpoint!
% Check the timing of a point in the middle of the sequence

% QD .540 to .555

clear

Fig1 = 10;
Fig2 = 11;
Fig3 = 12;
Fig4 = 13;

Gain = 1;

Data = get_dpsc_current_waveforms; 

% [b,a]=butter(1,0.1);NewData=[];
% NewData.Data(:,1)=(Data.Data(4,1)+filter(b,a,Data.Data(4:end,1)-Data.Data(4,1)));
% NewData.Data(:,2)=(Data.Data(4,3)+filter(b,a,Data.Data(4:end,3)-Data.Data(4,3)));
% NewData.Data(:,3)=(Data.Data(4,2)+filter(b,a,Data.Data(4:end,2)-Data.Data(4,2)));
% NewData.TimeStep = Data.TimeStep;
% DirData.date=datestr(now);

QF   = Data.Data(:,2); 
QD   = Data.Data(:,3); 
BEND = Data.Data(:,1); 

QF = QF(:);
QD = QD(:);
BEND = BEND(:);


fs = 1/Data.TimeStep;
t = (0:(length(QF)-1)) / fs;


% Filter the BEND but don't add phase delay
BENDRaw = BEND;
[b,a] = fir1(10, .01);
BEND = filtfilt(b, a, BENDRaw);

QFRaw = QF;
QF = filtfilt(b, a, QFRaw);

QDRaw = QD;
QD = filtfilt(b, a, QDRaw);

figure(Fig3);
subplot(3,1,1);
plot(t, [BEND(:) BENDRaw(:)]);
ylabel('BEND [Amps]');
title('Filtered Signals')
subplot(3,1,2);
plot(t, [QF(:) QFRaw(:)]);
ylabel('QF [Amps]');
subplot(3,1,3);
plot(t, [QD(:) QDRaw(:)]);
ylabel('QD [Amps]');
xlabel('Time [seconds]');

% Goal 
QFratio = QF./BEND; 
QDratio = QD./BEND; 


% Error
QFerr = BEND.*(.495-QFratio);
QDerr = BEND.*(.555-QDratio);


% Zero the error in the begining
i = find(BEND < 3.5);
%i = find(t < .025);
QFerr(i) = 0;
QDerr(i) = 0;


% Slowly zero the error after the top of the ramp
i = find((t > .3) & (t < 0.47));
QFerr(i) = linspace(QFerr(i(1)),0,length(i));
QDerr(i) = linspace(QDerr(i(1)),0,length(i));
i = find(t >= 0.47);
QFerr(i) = 0;
QDerr(i) = 0;



     
    dQFcommand = QFerr;
    dQDcommand = QDerr;
 
% Gain
dQFcommand = Gain * dQFcommand;
dQDcommand = Gain * dQDcommand;



figure(Fig1);
clf reset
subplot(4,1,1);
plot(t, [QF(:) QD(:) BEND(:)]);
legend('QF', 'QD', 'BEND', 'Location', 'NorthWest');
axis tight;

subplot(4,1,2);
plot(t, QFratio);
hold on;
plot([min(t) max(t)],[.495 .495],'r');
hold off;
ylabel('QF/BEND (Goal .495)');
axis tight;
yaxis([.45 .6]);
grid on;

subplot(4,1,3);
plot(t,[(QFratio-.495) dQFcommand./BEND]);
ylabel('QF/BEND Error');
legend('QF/BEND-.495', '\DeltaQFcommand/BEND', 0); %'Location', 'SouthWest');
axis tight;
%yaxis([-.1 .1]);
grid on;

subplot(4,1,4);
plot(t, dQFcommand);
ylabel('\DeltaQF [Amps]');
xlabel('Time [Seconds]');
axis tight;
%yaxis([-20 20]);
grid on;

orient tall



figure(Fig2);
clf reset
subplot(4,1,1);
plot(t, [QF(:) QD(:) BEND(:)]);
legend('QF', 'QD', 'BEND', 0);
axis tight;

subplot(4,1,2);
plot(t, QDratio);
hold on;
plot([min(t) max(t)],[.555 .555],'r');
hold off;
ylabel('QD/BEND (Goal .555)');
axis tight;
yaxis([.45 .6]);
grid on;


subplot(4,1,3);
plot(t,[(QDratio-.555) dQDcommand./BEND]);
ylabel('QD/BEND Error');
legend('QD/BEND-.555', '\DeltaQDcommand/BEND', 0); %'Location', 'SouthWest');
axis tight;
%yaxis([-.1 .1]);
grid on;

subplot(4,1,4);
plot(t, dQDcommand);
ylabel('\DeltaQD [Amps]');
xlabel('Time [Seconds]');
axis tight;
%yaxis([-20 20]);
grid on;

orient tall

[b,a]=butter(2,0.01);
dQF=filtfilt(b,a,dQFcommand);
dQD=filtfilt(b,a,dQDcommand);

%%%%%%%%%%%%%%%%%%
% Set the  table %
%%%%%%%%%%%%%%%%%%



figure(5);
subplot(2,1,1);
plot(dQF);
axis tight
subplot(2,1,2);
plot(dQD);
axis tight


