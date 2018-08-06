mach = machine_at; 

%% correctors
figure;
subplot(2,1,1);
ind = getfamilydata('HCM','AT','ATIndex'); 
vals = getsp('HCM','Physics')*1e3;
meanval = mean(vals);
stdval = std(vals);
plot(mach.spos(ind),vals,'x-'); 
axis tight; 
title(sprintf('HCM (mean = %7.3f mrad, std = %7.3f mrad)',meanval, stdval));
ylabel('mrad');
xlabel('s (m)');

subplot(2,1,2);
ind = getfamilydata('VCM','AT','ATIndex'); 
vals = getsp('VCM','Physics')*1e3;
meanval = mean(vals);
stdval = std(vals);
plot(mach.spos(ind),vals,'x-'); 
axis tight; 
title(sprintf('VCM (mean = %7.3f mrad, std = %7.3f mrad)',meanval, stdval));
ylabel('mrad');
xlabel('s (m)');

plotelementsat;

%% Quadrupoles
figure;
subplot(3,1,1);
ind = getfamilydata('QFA','AT','ATIndex'); 
vals = getsp('QFA','Physics');
meanval = mean(vals);
stdval = std(vals);
plot(mach.spos(ind),(vals-meanval)/meanval,'x-'); 
axis tight; 
title(sprintf('QFA (mean = %7.3f m^{-2}, std = %7.3f m^{-2})',meanval, stdval));
ylabel('Change from mean');
xlabel('s (m)');

subplot(3,1,2);
ind = getfamilydata('QDA','AT','ATIndex'); 
vals = getsp('QDA','Physics');
meanval = mean(vals);
stdval = std(vals);
plot(mach.spos(ind),(vals-meanval)/meanval,'x-'); 
axis tight; 
title(sprintf('QDA (mean = %7.3f m^{-2}, std = %7.3f m^{-2})',meanval, stdval));
ylabel('Change from mean');
xlabel('s (m)');

subplot(3,1,3);
ind = getfamilydata('QFB','AT','ATIndex'); 
vals = getsp('QFB','Physics');
meanval = mean(vals);
stdval = std(vals);
plot(mach.spos(ind),(vals-meanval)/meanval,'x-'); 
axis tight; 
title(sprintf('QFB (mean = %7.3f m^{-2}, std = %7.3f m^{-2})',meanval, stdval));
ylabel('Change from mean');
xlabel('s (m)');

plotelementsat;