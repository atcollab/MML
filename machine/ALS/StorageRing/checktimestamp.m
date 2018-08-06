function checktimestamp

BENDList = [1 1;4 2;8 2;12 2];
QFAList  = [1 1;4 2;8 2;12 2];
BPMList = getbpmlist('Bergoz');

tic
t0 = now;
[am, t, BEND_ts] = getam('BEND', BENDList);
[am, t, SF_ts]   = getam('SF', [1 1]);
[am, t, SD_ts]   = getam('SD', [1 1]);
[am, t, QFA_ts]  = getam('QFA', QFAList);
[am, t, QDA_ts]  = getam('QDA');
[am, t, QF_ts]   = getam('QF');
[am, t, QD_ts]   = getam('QD');
[am, t, HCM_ts]  = getam('HCM', family2dev('HCM', 1 , 1));
[am, t, VCM_ts]  = getam('VCM', family2dev('VCM', 1 , 1));
[am, t, BPMx_ts] = getam('BPMx', BPMList);
[am, t, BPMy_ts] = getam('BPMy', BPMList);
t1 = now;
toc

DateFormat = 'yyyy-mm-dd HH:MM:SS.FFF';

fprintf('EPICS Timestamp    ChannelName   Diff from Local Time [Seconds]\n');


Family = 'BEND';
DevList = family2dev(Family, 1 , 1);
fprintf('%s Timestamps\n', Family);
for i = 1:size(DevList);
    T = 24*60*60*(BEND_ts(i) - t0);
    fprintf('%s  %s  %7.3f\n', datestr(BEND_ts(i), DateFormat), family2channel(Family, DevList(i,:)), T);
end
fprintf('\n\n');


fprintf('Sextupoloe Timestamps\n');
T = 24*60*60*(SF_ts - t0);
fprintf('%s  %s  %7.3f\n', datestr(SF_ts, DateFormat), family2channel('SF',[1 1]), T);
T = 24*60*60*(SF_ts - t0);
fprintf('%s  %s  %7.3f\n', datestr(SD_ts, DateFormat), family2channel('SD',[1 1]), T);
fprintf('\n\n');


Family = 'QFA';
DevList = family2dev(Family, 1 , 1);
fprintf('%s Timestamps\n', Family);
for i = 1:size(DevList);
    T = 24*60*60*(QFA_ts(i) - t0);
    fprintf('%s  %s  %7.3f\n', datestr(QFA_ts(i), DateFormat), family2channel(Family, DevList(i,:)), T);
end
fprintf('\n\n');


Family = 'QDA';
DevList = family2dev(Family, 1 , 1);
fprintf('%s Timestamps\n', Family);
for i = 1:size(DevList);
    T = 24*60*60*(QDA_ts(i) - t0);
    fprintf('%s  %s  %7.3f\n', datestr(QDA_ts(i), DateFormat), family2channel(Family, DevList(i,:)), T);
end
fprintf('\n\n');


Family = 'QF';
DevList = family2dev(Family, 1 , 1);
fprintf('%s Timestamps\n', Family);
for i = 1:size(DevList);
    T = 24*60*60*(QF_ts(i) - t0);
    fprintf('%s  %s  %7.3f\n', datestr(QF_ts(i), DateFormat), family2channel(Family, DevList(i,:)), T);
end
fprintf('\n\n');


Family = 'QD';
DevList = family2dev(Family, 1 , 1);
fprintf('%s Timestamps\n', Family);
for i = 1:size(DevList);
    T = 24*60*60*(QD_ts(i) - t0);
    fprintf('%s  %s  %7.3f\n', datestr(QD_ts(i), DateFormat), family2channel(Family, DevList(i,:)), T);
end
fprintf('\n\n');


Family = 'HCM';
DevList = family2dev(Family, 1 , 1);
fprintf('%s Timestamps\n', Family);
for i = 1:size(DevList);
    T = 24*60*60*(HCM_ts(i) - t0);
    fprintf('%s  %s  %7.3f\n', datestr(HCM_ts(i), DateFormat), family2channel(Family, DevList(i,:)), T);
end
fprintf('\n\n');


Family = 'VCM';
DevList = family2dev(Family, 1 , 1);
fprintf('%s Timestamps\n', Family);
for i = 1:size(DevList);
    T = 24*60*60*(VCM_ts(i) - t0);
    fprintf('%s  %s  %7.3f\n', datestr(VCM_ts(i), DateFormat), family2channel(Family, DevList(i,:)), T);
end
fprintf('\n\n');


Family = 'BPMx';
DevList = BPMList;
fprintf('%s Timestamps\n', Family);
for i = 1:size(DevList);
    T = 24*60*60*(BPMx_ts(i) - t0);
    fprintf('%s  %s  %7.3f\n', datestr(BPMx_ts(i), DateFormat), family2channel(Family, DevList(i,:)), T);
end
fprintf('\n\n');


Family = 'BPMy';
DevList = BPMList;
fprintf('%s Timestamps\n', Family);
for i = 1:size(DevList);
    T = 24*60*60*(BPMy_ts(i) - t0);
    fprintf('%s  %s  %7.3f\n', datestr(BPMy_ts(i), DateFormat), family2channel(Family, DevList(i,:)), T);
end
fprintf('\n\n');


fprintf('Measurement time %.3f\n', (t1-t0)*24*60*60);


