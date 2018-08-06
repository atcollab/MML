% QUAD Step
BPMxFamily = 'BPMx';
BPMxDevList = getbpmlist('BPMx'); %[2 1;2 2;2 3;2 4;2 5];
BPMyFamily = 'BPMy';
BPMyDevList = BPMxDevList;        %[2 1;2 2;2 3;2 4;2 5];


DeltaAmps = 1.0; 
CMFamily = 'QF';
CMDevList = [1 1];
t = 0:.05:3;


SP0 = getsp(CMFamily, CMDevList);
AM0 = getam(CMFamily, CMDevList);
BPMx0 = getx(BPMxDevList);
BPMy0 = gety(BPMxDevList);


% Ramprate
RampRateStart = getpv(CMFamily, 'RampRate', CMDevList);
setpv(CMFamily, 'RampRate', .5, CMDevList, 0);
pause(.1);  % No good reason


t0 = gettime;

tic;
stepsp(CMFamily, DeltaAmps, CMDevList, 0);
T0 = toc;
[am, tout] = getam({BPMxFamily, BPMyFamily, CMFamily}, {BPMxDevList, BPMyDevList, CMDevList}, t);


% Return the current
pause(1);
stepsp(CMFamily,-DeltaAmps, CMDevList, -1);

% Restore the quad ramprate
setpv(CMFamily, 'RampRate', RampRateStart, CMDevList, 0);



x = am{1};
y = am{2};
cm = am{3};

for i = 1:size(BPMxDevList,1)
    x(i,:) = x(i,:) - x(i,1);
end
for i = 1:size(BPMyDevList,1)
    y(i,:) = y(i,:) - y(i,1);
end


% Display
clf reset
subplot(3,1,1);

plot(tout,x,'.-b');
grid on;
if size(BPMxDevList,1) == 1
    ylabel(sprintf('%s(%d,%d) [mm]', BPMxFamily, BPMxDevList));
elseif size(BPMxDevList,1) < 10
    ylabel(sprintf('BPM Data [mm]'));
    for i = 1:size(BPMxDevList,1)
        LabelCell{i} = sprintf('%s(%d,%d)', BPMxFamily, BPMxDevList(i,:));
    end
else
    ylabel(sprintf('BPMx Data [mm]'));
end

subplot(3,1,2);
%hold on
plot(tout,y,'.-b');
%hold off;
if size(BPMyDevList,1) == 1
    ylabel(sprintf('%s(%d,%d) [mm]', BPMyFamily, BPMyDevList));
elseif size(BPMyDevList,1) < 10
    ylabel(sprintf('BPM Data [mm]'));
    for i = 1:size(BPMyDevList,1)
        LabelCell{i+size(BPMxDevList,1)} = sprintf('%s(%d,%d)', BPMyFamily, BPMyDevList(i,:));
    end
    legend(LabelCell,1);
else
    ylabel(sprintf('BPMy Data [mm]'));
end

xlabel('Time [Seconds]');
title(sprintf('%s(%d,%d):  Delta Amps = %.3f', CMFamily, CMDevList, DeltaAmps));
grid on;

subplot(3,1,3);
plot(tout,cm,'.-b'); 
grid on;
ylabel(sprintf('%s(%d,%d) [Amps]', CMFamily, CMDevList));
xlabel('Time [Seconds]');
grid on;

orient tall