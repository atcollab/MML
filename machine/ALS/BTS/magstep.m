% HCM Step
DeltaAmps = 1e-5;
BPMxFamily = 'BPMx';
BPMxDevList = [1 5;1 6];
BPMyFamily = 'BPMy';
BPMyDevList = BPMxDevList;
CMFamily = 'HCM';
CMDevList = [1 5];
t = 0:.1:1;



AM0 = getam(CMFamily, CMDevList);
BPMx0 = getx(BPMxDevList);
BPMy0 = gety(BPMxDevList);


t0 = gettime;


tic;
stepsp(CMFamily, DeltaAmps, CMDevList, 0);
T0 = toc;
[am, tout] = getam({BPMxFamily, BPMyFamily, CMFamily}, {BPMxDevList, BPMyDevList, CMDevList}, t);
stepsp(CMFamily,-DeltaAmps, CMDevList, -1);
pause(1);


tic;
stepsp(CMFamily, DeltaAmps, CMDevList, -1);
T1 = toc;
stepsp(CMFamily,-DeltaAmps, CMDevList, -1);
pause(1);


% stepsp WaitFlag=-2 test
tic;
stepsp(CMFamily, DeltaAmps, CMDevList, -2);
T2 = toc;
stepsp(CMFamily,-DeltaAmps, CMDevList, -1);
pause(1);


% setsp WaitFlag=-2 test
SP = getsp(CMFamily, CMDevList);
tic;
setsp(CMFamily, SP+DeltaAmps, CMDevList, -2);
T3 = toc;
setsp(CMFamily, SP, CMDevList, -1);


fprintf('\n');
fprintf('   T(stepsp w/ waitonsp =  0) = %.3f seconds.\n', T0);
fprintf('   T(stepsp w/ waitonsp = -1) = %.3f seconds.\n', T1);
fprintf('   T(stepsp w/ waitonsp = -2) = %.3f seconds.\n', T2);
fprintf('   T(setsp  w/ waitonsp = -2) = %.3f seconds.\n', T3);
fprintf('\n');



% Display

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
if size(BPMxDevList,1) == 1
    ylabel(sprintf('%s(%d,%d) [mm]', BPMxFamily, BPMxDevList));
elseif size(BPMxDevList,1) < 10
    clear LabelCell
    ylabel(sprintf('BPM Data [mm]'));
    for i = 1:size(BPMxDevList,1)
        LabelCell{i} = sprintf('%s(%d,%d)', BPMxFamily, BPMxDevList(i,:));
    end
end

hold on
plot(tout,y,'.-r');
hold off;
if size(BPMyDevList,1) == 1
    ylabel(sprintf('%s(%d,%d) [mm]', BPMyFamily, BPMyDevList));
elseif size(BPMxDevList,1) < 10
    ylabel(sprintf('BPM Data [mm]'));
    for i = 1:size(BPMyDevList,1)
        LabelCell{i+size(BPMxDevList,1)} = sprintf('%s(%d,%d)', BPMyFamily, BPMyDevList(i,:));
    end
    legend(LabelCell,1);
end

xlabel('Time [Seconds]');
title(sprintf('%s(%d,%d):  Delta Amps = %.1f, Time for set: WaitFlag 0 = %.2f, -1 = %.2f, -2 = %.2f', CMFamily, CMDevList, DeltaAmps, T0, T1, T2));
grid on;

subplot(2,1,2);
plot(tout,cm,'.-b'); 
grid on;
ylabel(sprintf('%s(%d,%d) [Amps]', CMFamily, CMDevList));
xlabel('Time [Seconds]');
grid on;

orient tall