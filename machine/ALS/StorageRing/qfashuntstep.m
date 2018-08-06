% HCM Step
DeltaAmps = 1;
BPMxFamily = 'BPMx';
BPMxDevList = [1 2;2 2];
BPMyFamily = 'BPMy';
BPMyDevList = [1 2;2 2];
QuadFamily = 'QFA';
QuadDevList = [6 1];
t = 0:.1:3;


AM0 = getam(QuadFamily, QuadDevList);
BPMx0 = getx(BPMxDevList);
BPMy0 = gety(BPMxDevList);


t0 = gettime;


tic;
setqfashunt(1, 1, QuadDevList, 0);
setqfashunt(2, 1, QuadDevList, 0);
T0 = toc;
[am, tout] = getam({BPMxFamily, BPMyFamily, QuadFamily}, {BPMxDevList, BPMyDevList, QuadDevList}, t);
setqfashunt(1, 0, QuadDevList, -2);
setqfashunt(2, 0, QuadDevList, -2);
pause(1);


% stepsp WaitFlag=-2 test
tic;
setqfashunt(1, 1, QuadDevList, -2);
setqfashunt(2, 1, QuadDevList, -2);
T2 = toc;
setqfashunt(1, 0, QuadDevList, -2);
setqfashunt(2, 0, QuadDevList, -2);
pause(1);


fprintf('\n');
fprintf('   T(stepsp w/ waitonsp =  0) = %.3f seconds.\n', T0);
fprintf('   T(stepsp w/ waitonsp = -2) = %.3f seconds.\n', T2);
fprintf('\n');



% Display
figure;

x = am{1};
y = am{2};
cm = am{3};

clf reset
subplot(2,1,1);
for i = 1:size(BPMxDevList,1)
    x(i,:) = x(i,:) - x(i,1);
end
for i = 1:size(BPMyDevList,1)
    y(i,:) = y(i,:) - y(i,1);
end


plot(tout,x,'.-b');
grid on;
if size(BPMxDevList,1) > 1
    ylabel(sprintf('BPM Data [mm]'));
    for i = 1:size(BPMxDevList,1)
        LabelCell{i} = sprintf('%s(%d,%d)', BPMxFamily, BPMxDevList(i,:));
    end
else
    ylabel(sprintf('%s(%d,%d) [mm]', BPMxFamily, BPMxDevList));
end

hold on
plot(tout,y,'.-r');
hold off;
if size(BPMyDevList,1) > 1
    ylabel(sprintf('BPM Data [mm]'));
    for i = 1:size(BPMyDevList,1)
        LabelCell{i+size(BPMxDevList,1)} = sprintf('%s(%d,%d)', BPMyFamily, BPMyDevList(i,:));
    end
    legend(LabelCell,1);
else
    ylabel(sprintf('%s(%d,%d) [mm]', BPMyFamily, BPMyDevList));
end

xlabel('Time [Seconds]');
title(sprintf('%s(%d,%d):  Delta Amps = %.1f, Time for set: WaitFlag 0 = %.2f, -2 = %.2f', QuadFamily, QuadDevList, DeltaAmps, T0, T2));
grid on;

subplot(2,1,2);
plot(tout,cm,'.-b'); 
grid on;
ylabel(sprintf('%s(%d,%d) [Amps]', QuadFamily, QuadDevList));
xlabel('Time [Seconds]');
grid on;

orient tall