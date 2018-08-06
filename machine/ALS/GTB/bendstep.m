% BEND Step
DeltaAmps = 24;
CMFamily = 'BEND';
CMDevList = [1 1];
t = 0:.2:50;

AM0 = getam(CMFamily, CMDevList);


t0 = gettime;


stepsp(CMFamily, DeltaAmps, CMDevList, 0);
[am, tout] = getam(CMFamily, CMDevList, t);

% Reset
%stepsp(CMFamily,-DeltaAmps, CMDevList, 0);



% Display
clf reset
plot(tout, am, '.-b'); 
grid on;
title(sprintf('BTS BEND: %.2f Ampere Step Response', DeltaAmps));
ylabel(sprintf('%s(%d,%d) [Amps]', CMFamily, CMDevList));
xlabel('Time [Seconds]');
grid on;

orient tall

figure(gcf);