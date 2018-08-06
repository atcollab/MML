% The following programs must be running:
% y:\opstat\win\Hiroshi\release\BRQLinCor.exe
% y:\opstat\win\Hiroshi\release\BRQLinCorServer.exe


% To DO:
% Measure the start and end time of the ILC table (base indexing on time or current?  Line ~120)
% Line ~184 controls what "filter" is used.
% Measure the power supply BW and delay
% Test the tolerance to parameter uncertainty (TF high poles)
% Check the timing of a point in the middle of the sequence


clear

Gain = 1;
QFgoal = .492; %.520;
QDgoal = .550;


% Power supply TF???
w = 2 * pi * 7.8;
sys = tf(1,[1/w 1]);
%bode(H)


h_fig = 1;
FigFilt = 100;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compensation Transfer Function %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The inverse system
% The problem with the inverse is phase lag can get introduces
Fc = 2 * pi * 20;      % High frequency poles for the compensation avoid phase lag but adds overshoot
                       % Try having a high freq. compensation TF, but filtfilt the final command to avoid phase lag???         
                       % I didn't implement this yet (GP 7/11/2007)
sysinv = tf([1/w 1], conv([1/Fc 1],[1/Fc 1]));
sysinv1 = sysinv;

% Add a pole (sample rate & compensation)
%wc = 2 * pi * 10;
%sysinv = sysinv * tf(1, [1/wc 1]);

%figure(FigFilt);
%step(sysinv);
%bode(sysinv1, sysinv);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get the Monitor Data and Compute the Goal Trajectory %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
QF   = getpv('QF',   'DVM'); 
QD   = getpv('QD',   'DVM');
BEND = getpv('BEND', 'DVM');

QF = QF(:);
QD = QD(:);
BEND = BEND(:);


fs = 4000;
t = (0:(length(QF)-1)) / fs;


% Filter the monitor but don't add phase delay
BENDRaw = BEND;
[b,a] = fir1(10, .2);
BEND = filtfilt(b, a, BENDRaw);

%figure(FigFilt);
%freqz(b,a,1024,'whole',4000);

QFRaw = QF;
QF = filtfilt(b, a, QFRaw);

QDRaw = QD;
QD = filtfilt(b, a, QDRaw);

figure(FigFilt);
subplot(3,1,1);
plot(t, [BEND(:) BENDRaw(:)]);
title('Raw and Filtered Data');
subplot(3,1,2);
plot(t, [QF(:) QFRaw(:)]);
subplot(3,1,3);
plot(t, [QD(:) QDRaw(:)]);


% Goal 
QFratio = QF./BEND; 
QDratio = QD./BEND; 


% Error
QFerr = BEND.*(QFgoal-QFratio);
QDerr = BEND.*(QDgoal-QDratio);


if 1
    TimeFlag = 1;
    x = t;
    xLabelString = 'Time [Seconds]';
else
    TimeFlag = 0;
    x = BEND;
    xLabelString = 'BEND Current [Amps]';
end


B2 = 18;
B100 = 309;
dB = (B100-B2)/98;

% 100 point bend table (last point gets dropped later)
B = linspace(B2,B100+dB,100);

if 0
    % Base on current
    ii2   = max(find(BEND < B2))
    ii100 = max(find(BEND < B100))

    % % Find the time step for the ILC linearity correction
    % for i = 1:length(B)
    %     Index(i) = max(find(BEND < B(i)));
    % end
    % dIndex = median(diff(Index));
    % Index = dIndex*(0:length(Index)-1)+Index(1);
else
    % Base on time
    [tmp, i2]   = max(find(t < .0177));
    [tmp, i100] = max(find(t < .4135));
end

Index = linspace(i2,i100,100);
%dIndex = Index(2)-Index(1);
dIndex = round(median(diff(Index)));
Index = dIndex*(0:length(Index)-1)+Index(1);

    
% Zero the error until the system can be controlled
if 1
    i = find(t < t(Index(1)));
    %t_minus_1 = t(Index(1))-(t(Index(2))-t(Index(1)));
    %i = find(t < t_minus_1);
    %i = find(t < .0225-.004);
    %i = find(t < .0225);
    QFerr(i) = 0;
    QDerr(i) = 0;
else
    % Slowly zero the error after the top of the ramp
    i = find(t > .85);
    QFerr(i) = linspace(QFerr(i(1)),0,length(i));
    QDerr(i) = linspace(QDerr(i(1)),0,length(i));
end


% Smooth the error signal without adding phase lag
[b,a] = fir1(20, .02);
QFerrRaw = QFerr;
QFerr = filtfilt(b, a, QFerrRaw);

QDerrRaw = QDerr;
QDerr = filtfilt(b, a, QDerrRaw);

figure(FigFilt+1);
subplot(2,1,1);
plot(t, [QFerr(:) QFerrRaw(:)]);
ylabel('QF Error [Amps]');
title('Error and Filtered Error');
subplot(2,1,2);
plot(t, [QDerr(:) QDerrRaw(:)]);
ylabel('QD Error [Amps]');
xlabel('Time [Seconds]');


% Put the waveform to track through the inverse system (4096 points)
[dQFcommand, tinv, xinv] = lsim(sysinv, QFerr, t);
[dQDcommand, tinv, xinv] = lsim(sysinv, QDerr, t);


if 1
    % This could be adding a phase lag problem
    [dQFcommandILC, tinv, xinv] = lsim(sysinv, QFerr(Index), t(Index));
    [dQDcommandILC, tinv, xinv] = lsim(sysinv, QDerr(Index), t(Index));

    % Remove a point (100th point gets added later) 
    if 1
        % Slide the table 1 point (first point is zero)  ???
        dQFcommandILC(1) = [];
        dQDcommandILC(1) = [];
        Index(end) = [];
    else
        dQFcommandILC(end) = [];
        dQDcommandILC(end) = [];
        Index(end) = [];
    end
    
elseif 0
    % Or be brain dead
    T = .0075;  % Start the command a little early?
    NT = round(T/(t(2)-t(1)));
    dQFcommandILC = QFerr(Index+NT);

    dQDcommandILC = QDerr(Index+NT);
    
else
    % Low pass the command and resample but don't add phase delay
    %[b,a] = butter(5,.2);
    %[b,a] = butter(5,.08);
    [b,a] = fir1(50, .01);
    dQFcommand1 = filtfilt(b, a, dQFcommand);
    dQFcommandILC = dQFcommand1(Index);

    dQDcommand1 = filtfilt(b, a, dQDcommand);
    dQDcommandILC = dQDcommand1(Index);

    figure(FigFilt);
    subplot(2,1,1);
    %plot(t, [dQFcommand(:) dQFcommand1(:)], t(Index), dQFcommandILC,'.r', t,10*(QFratio-QFgoal),'k');
    plot(t, [dQFcommand(:) dQFcommand1(:)], t(Index), dQFcommandILC,'.r', t,10*(QFratio-QFgoal), 'k', t,QFerr,'m', t,QFerrRaw,'m');

    subplot(2,1,2);
    plot(t, [dQDcommand(:) dQDcommand1(:)], t(Index), dQDcommandILC,'.r', t,10*(QDratio-QDgoal), 'k', t,QDerr,'m');
    xlabel('Time [seconds]');
end


% Gain
dQFcommandILC = Gain * dQFcommandILC;
dQDcommandILC = Gain * dQDcommandILC;


% Simulate on 4096 point wave form
dQFcommand = dQFcommand * 0;
dQDcommand = dQDcommand * 0;
for i = 0:dIndex-1
    dQFcommand(Index+i) = dQFcommandILC;
    dQDcommand(Index+i) = dQDcommandILC;
end


% Simulate the result
[dQFsim, t1, x1] = lsim(sys, dQFcommand, t);
[dQDsim, t1, x1] = lsim(sys, dQDcommand, t);


% for i = 1:length(t_ILC)
%     j = max(find(t < t_ILC(i)));
%     QFtable(i) = BEND(j) .* QFcommand(j);
%     QDtable(i) = BEND(j) .* QDcommand(j);
% end



figure(h_fig);
clf reset
subplot(2,1,1);
plot(x, [QF(:) QD(:) BEND(:)]);
legend('QF', 'QD', 'BEND', 'Location', 'NorthWest');
axis tight;

subplot(2,1,2);
plot(x, QFratio, 'b');
hold on;
plot(x, QDratio, 'g');

plot(x(Index), QFratio(Index),'.b');
plot([min(x) max(x)],[QFgoal QFgoal],'b');
if ~TimeFlag
    plot([B2   B2],  [-10 10],'b');
    plot([B100 B100],[-10 10],'b');
end

plot(x(Index), QDratio(Index),'.g');
plot([min(x) max(x)],[QDgoal QDgoal],'g');
if ~TimeFlag
    plot([B2   B2],  [-10 10],'g');
    plot([B100 B100],[-10 10],'g');
end

hold off;
ylabel('Ratio: Quad/Bend');
legend(sprintf('QF/BEND (Goal %.3f)', QFgoal), sprintf('QD/BEND (Goal %.3f)',QDgoal),0);
axis tight;
yaxis([.45 .6]);
grid on;


figure(h_fig+1);
subplot(2,1,1);
plot(x,[(QFratio-QFgoal) dQFcommand./BEND dQFsim./BEND (QFratio-QFgoal)+dQFsim./BEND]);
ylabel('QF/BEND Error');
legend(sprintf('QF/BEND-%.3f',QFgoal), '\DeltaQFcommand/BEND', '\DeltaQFsim/BEND', sprintf('QF/BEND-%.3f+\\DeltaQFsim/BEND',QFgoal), 0); %'Location', 'SouthWest');
axis tight;
%yaxis([-.1 .1]);
grid on;

subplot(2,1,2);
plot(x, dQFcommand);
ylabel('\DeltaQF [Amps]');
xlabel(xLabelString);
axis tight;
%yaxis([-20 20]);
grid on;

if TimeFlag
    hold on;
    plot(t(Index), dQFcommandILC, 'sr', 'MarkerSize',3);
    hold off;
end

orient tall


% figure(h_fig+2);
% subplot(2,1,1);
% plot(x,[(QDratio-QDgoal) dQDcommand./BEND dQDsim./BEND (QDratio-QDgoal)+dQDsim./BEND]);
% ylabel('QD/BEND Error');
% legend(sprintf('QD/BEND-%.3f',QDgoal), '\DeltaQDcommand/BEND', '\DeltaQDsim/BEND', sprintf('QD/BEND-%.3f+\\DeltaQDsim/BEND',QDgoal), 0); %'Location', 'SouthWest');
% axis tight;
% %yaxis([-.1 .1]);
% grid on;
% 
% subplot(2,1,2);
% plot(x, dQDcommand);
% ylabel('\DeltaQD [Amps]');
% xlabel(xLabelString);
% axis tight;
% %yaxis([-20 20]);
% grid on;
% 
% if TimeFlag
%     hold on;
%     plot(t(Index), dQDcommandILC, 'sr', 'MarkerSize',3);
%     hold off;
% end

orient tall



%%%%%%%%%%%%%%%%%%%%%
% Set the ILC table %
%%%%%%%%%%%%%%%%%%%%%

QF_ILC = getpv('QF', 'ILCTrim');
QD_ILC = getpv('QD', 'ILCTrim');

if length(dQFcommandILC) == 100
    QF_ILC = QF_ILC + dQFcommandILC';
    QD_ILC = QD_ILC + dQDcommandILC';
else
    % Don't change the first point (which is actually the last)
    QF_ILC(2:100) = QF_ILC(2:100) + dQFcommandILC';
    QD_ILC(2:100) = QD_ILC(2:100) + dQDcommandILC';
end


tmp = questdlg('Change the linearity correction?','matchramp_ild','Yes','No','No');
if ~strcmpi(tmp,'Yes')
    fprintf('  No change made QF or QD linearity correction table.\n');
    return
else
    %fprintf('  QF & QD linearity correction table updated.\n');
    fprintf('  QF linearity correction table updated.\n');
    setpv('QF', 'ILCTrim', QF_ILC, [1 1]);
    %setpv('QD', 'ILCTrim', QD_ILC, [1 1]);
end



%QFtable = [1.8 QFtable];
%QDtable = [1.8 QDtable];


% for i = 1:length(B)
%     j = max(find(BEND < B(i)));
%     QFtable(i) = BEND(j) .* QFcommand(j);
%     QDtable(i) = BEND(j) .* QDcommand(j);
% end
% 
% figure(h_fig);
% subplot(4,1,3);
% plot(x,[QFratio-QDgoal QFcommand QFsim QFratio-QDgoal+QFsim]);
% ylabel('QF/BEND Error');
% legend('QF/BEND-.520', '\DeltaQFcommand', '\DeltaQFsim', 'QF/BEND-.535+\DeltaQFsim', 'Location', 'SouthWest');
% axis tight;
% yaxis([-.1 .1]);
% 
% subplot(4,1,4);
% plot(x, BEND .* QFcommand);
% if ~TimeFlag
%     hold on;
%     plot(B, QFtable, 'sr', 'MarkerSize',3);
%     plot([B2   B2],  [-1000 1000],'r');
%     plot([B100 B100],[-1000 1000],'r');
%     hold off;
% end
% ylabel('\DeltaQF [Amps]');
% xlabel(xLabelString);
% axis tight;
% yaxis([-20 20]);
% grid on;
% 
% 
% figure(h_fig+1);
% subplot(4,1,3);
% %plot(x, [QDratio QDcommand QDsim QDratio+QDsim]);
% plot(x, [QDratio-QDgoal QDcommand QDsim QDratio-QDgoal+QDsim]);
% ylabel('QD/BEND Error');
% legend('QD/BEND-.535', '\DeltaQDcommand', '\DeltaQDsim', 'QD/BEND-.535+\DeltaQDsim', 'Location', 'SouthWest');
% axis tight;
% yaxis([-.1 .1]);
% 
% subplot(4,1,4);
% plot(x, BEND .* QDcommand);
% if ~TimeFlag
%     hold on;
%     plot(B, QDtable, 'sr', 'MarkerSize',3);
%     plot([B2   B2],  [-1000 1000],'r');
%     plot([B100 B100],[-1000 1000],'r');
%     hold off;
% end
% ylabel('\DeltaQD [Amps]');
% xlabel(xLabelString);
% axis tight;
% yaxis([-20 20]);
% grid on;

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



