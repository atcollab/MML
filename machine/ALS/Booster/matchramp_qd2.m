% Check the power supply BW
% Compensation TF should be applied on QF not QF/BEND
% Test what the delay should be?  Sample rate or BW reasoning?
% Test the tolerance to parameter uncertainty (TF high poles)
% Timing should not independent of BEND setpoint!
% Check the timing of a point in the middle of the sequence


% QD .540 to .555

clear

Fig1 = 10;
Fig2 = 11;
Fig3 = 12;
Fig4 = 13;


% Power supply TF
w = 2 * pi * 7.8;
sys = tf(1,[1/w 1]);
%bode(H)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compensation Transfer Function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Gain = 1;

% The inverse system
Fc = 2 * pi * 30;      % High frequency poles for the compensation (avoid phase delay!!!)
sysinv = tf([1/w 1], conv([1/Fc 1],[1/Fc 1]));
sysinv1 = sysinv;

% Add a pole (sample rate & compensation)
%wc = 2 * pi * 10;
%sysinv = sysinv * tf(1, [1/wc 1]);

figure(20);
step(sysinv);
%bode(sysinv1, sysinv);


QF   = getpv('QF',   'DVM'); 
QD   = getpv('QD',   'DVM');
BEND = getpv('BEND', 'DVM');

QF = QF(:);
QD = QD(:);
BEND = BEND(:);


fs = 8000;
t = (0:(length(QF)-1)) / fs;


% Filter the BEND but don't add phase delay
BENDRaw = BEND;
[b,a] = fir1(10, .2);
BEND = filtfilt(b, a, BENDRaw);

freqz(b,a,1024,'whole',8000);

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
i = find(BEND < 10);
%i = find(t < .025);
QFerr(i) = 0;
QDerr(i) = 0;


% Slowly zero the error after the top of the ramp
i = find((t > .36) & (t < 0.7));
QFerr(i) = linspace(QFerr(i(1)),0,length(i));
QDerr(i) = linspace(QDerr(i(1)),0,length(i));
i = find(t >= 0.7);
QFerr(i) = 0;
QDerr(i) = 0;


% % Smooth the error signal without adding phase lag
% [b,a] = fir1(20, .02);
% QFerrRaw = QFerr;
% QFerr = filtfilt(b, a, QFerrRaw);
% 
% QDerrRaw = QDerr;
% QDerr = filtfilt(b, a, QDerrRaw);


% figure(Fig4);
% subplot(2,1,1);
% plot(t, [QFerr(:) QFerrRaw(:)]);
% ylabel('QF Error [Amps]');
% title('Filtered Error Signal')
% subplot(2,1,2);
% plot(t, [QDerr(:) QDerrRaw(:)]);
% ylabel('QD Error [Amps]');
% xlabel('Time [seconds]');



% Put the waveform to track through the inverse system
[dQFcommand, tinv, xinv] = lsim(sysinv, QFerr, t);
[dQDcommand, tinv, xinv] = lsim(sysinv, QDerr, t);


% Slowly zero the error after the top of the ramp
i = find(t > .36);
dQFcommand(i) = linspace(dQFcommand(i(1)),0,length(i));
dQDcommand(i) = linspace(dQDcommand(i(1)),0,length(i));


if 0

    [dQFcommand, tinv, xinv] = lsim(sysinv, QFerr, t);
    [dQDcommand, tinv, xinv] = lsim(sysinv, QDerr, t);

    % Slide the table 1 point???
    %dQFcommand(1) = [];
    %dQDcommand(1) = [];

    %dQFcommand(end) = [];
    %dQDcommand(end) = [];

elseif 1
    
    % Or be brain dead
    %T = .0075;
    %NT = round(T/(t(2)-t(1)))
    %dQFcommand = QFerr(NT);
    %dQDcommand = QDerr(NT);
     
    dQFcommand = QFerr;
    dQDcommand = QDerr;
 
else

    % Low pass the command and resample but don't add phase delay
    %[b,a] = butter(5,.2);
    %[b,a] = butter(5,.08);
    [b,a] = fir1(50, .01);
    dQFcommand1 = filtfilt(b, a, dQFcommand);
    dQDcommand1 = filtfilt(b, a, dQDcommand);

    %figure(Fig4);
    %subplot(2,1,1);
    %plot(t, [dQFcommand(:) dQFcommand1(:)], t,10*(QFratio-.520), 'k', t,QFerr,'m', t,QFerrRaw,'m');

    %subplot(2,1,2);
    %plot(t, [dQDcommand(:) dQDcommand1(:)], t,10*(QDratio-.540), 'k', t,QDerr,'m');
    %xlabel('Time [seconds]');
end


% Gain
dQFcommand = Gain * dQFcommand;
dQDcommand = Gain * dQDcommand;


% Simulate the result
[dQFsim, t1, x1] = lsim(sys, dQFcommand, t);
[dQDsim, t1, x1] = lsim(sys, dQDcommand, t);


% for i = 1:length(t_)
%     j = max(find(t < t_(i)));
%     QFtable(i) = BEND(j) .* QFcommand(j);
%     QDtable(i) = BEND(j) .* QDcommand(j);
% end



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
ylabel('QF/BEND (Goal .520)');
axis tight;
yaxis([.45 .6]);
grid on;

subplot(4,1,3);
plot(t,[(QFratio-.495) dQFcommand./BEND dQFsim./BEND (QFratio-.495)+dQFsim./BEND]);
ylabel('QF/BEND Error');
legend('QF/BEND-.495', '\DeltaQFcommand/BEND', '\DeltaQFsim/BEND', 'QF/BEND-.520+\DeltaQFsim/BEND', 0); %'Location', 'SouthWest');
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
plot(t,[(QDratio-.555) dQDcommand./BEND dQDsim./BEND (QDratio-.555)+dQDsim./BEND]);
ylabel('QD/BEND Error');
legend('QD/BEND-.555', '\DeltaQDcommand/BEND', '\DeltaQDsim/BEND', 'QD/BEND-.555+\DeltaQDsim/BEND', 0); %'Location', 'SouthWest');
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



%%%%%%%%%%%%%%%%%%
% Set the  table %
%%%%%%%%%%%%%%%%%%


dT = 0.9 - t(end);
NN = round(fs * dT);

Npts = 34000;
dQDc = [dQDcommand; zeros(NN,1)];
dQD = resample(dQDc, Npts, length(dQDc), 25);

figure(5);
subplot(2,1,1);
plot(dQDcommand);
axis tight
subplot(2,1,2);
plot(dQD);
axis tight


%save NewDeltaQD dQD

% QF_Last = 0;
% QD_Last = 0;
% 
% QF = QF_Last + dQFcommand';
% QD = QD_Last + dQDcommand';


