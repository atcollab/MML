
%% blminit will initialize most of the BLM PVs
%blminit;


%% Example to arm the waveform recorder, wait for a trigger, and plot

% ALSLauncher -> "BCM & BLM" button to get to the engineering screens
% Look at the counter striptool on the edm screen to watch injections

NextTriggerFlag = 1;
[tbt, adc, Ts] = getblmtbt(NextTriggerFlag);


figure(1);
subplot(2,1,1);
plot(1e9*(0:2047)/125e6/656, adc, '.-');
title('Sector 2 BLM');
ylabel('ADC Data [Counts]');
xlabel('Time [Turns]');
grid on

subplot(2,1,2);
plot(0:1023, tbt);
ylabel('Turn-By-Turn [Counts]');
xlabel('Time [Turns]');
grid on
xaxis([0 150]);
legend('A', 'B', 'C', 'D');


title('Sector 2 BLM:  Blue = 4 Gun Bunches,  Red = 1 Gun Bunch');
ylabel('ADC Data [Counts]');
xlabel('Time [4 nanosecond steps]');

% Record the SA data
% PVs = [
% 'sr02blm:signals:sa.A     '
% 'sr02blm:signals:sa.B     '
% 'sr02blm:signals:sa.C     '
% 'sr02blm:signals:sa.D     '
% 'sr02blm:signals:counter.A'
% 'sr02blm:signals:counter.B'
% 'sr02blm:signals:counter.C'
% 'sr02blm:signals:counter.D'
% 'cmm:beam_current         '
% ];
% 
% [a,t,d] = getpv(PVs, 0:.05:15*60);