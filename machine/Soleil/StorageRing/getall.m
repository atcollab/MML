function getall
%GETALL - Creates proxy for all magnet (typically used once at initialization)
%

% 
% Written by Laurent S. Nadolski, April 2004
%
% TODO
% Where are stored the Proxies ? see with handles (location for storing w/ EPICS)

%getam(cellstr(liste(1:end-4,:)))

liste = cellstr(getfamilylist);

%% BPM
figure
subplot(2,1,1)
plot(getam(liste{1}));
title('BPM')
subplot(2,1,2)
plot(getam(liste{2}));

pause(0.2)
%% CORRECTOR
figure
subplot(2,1,1)
bar(getam(liste{3}));
title('Correctors')
subplot(2,1,2)
bar(getam(liste{4}));
pause(0.2)

%% FAST CORRECTOR
figure
subplot(2,1,1)
bar(getam(liste{5}));
title('Fast correctors')
subplot(2,1,2)
bar(getam(liste{6}));
pause(0.2)


figure
for k = 9:18 
    subplot(5,2,k-8)
    bar(getam(liste{k}))
end
suptitle('QUAD')
pause(0.2)

figure
for k = 19:28 
    subplot(5,2,k-18)
    bar(getam(liste{k}))
end
suptitle('SEXTU')
pause(0.2)
