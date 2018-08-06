%% Init
% bpminit;



%% Info
Prefix = getfamilydata('BPM','BaseName');
NBPM = length(Prefix);


% Initialize BPMs for injection triggering of FA mode
for loop=1:NBPM
    setpvonline([Prefix{loop} ':wfr:FA:arm'],0);
%     setpvonline([Prefix{loop} ':wfr:FA:triggerMask'],bin2dec('10000000'));
%     setpvonline([Prefix{loop} ':EVR:event36trig'],bin2dec('10000000'));
    setpvonline([Prefix{loop} ':wfr:FA:triggerMask'],bin2dec('10000000'));
    setpvonline([Prefix{loop} ':wfr:FA:pretrigCount'],0);
    setpvonline([Prefix{loop} ':EVR:event36trig'],bin2dec('10000000'));
    setpvonline([Prefix{loop} ':wfr:FA:acqCount'],6000);
    % setpvonline([Prefix{loop} ':buttonDSP'],1);
    setpvonline([Prefix{loop} ':attenuation'],0);
end

pause(1)
    % Wait for next Injection
    
    % The lines below do not work with the new timing system
%     while (getpv('GTL_____TIMING_BC00')==0) || (getpv('SR01S___BUMP1P_BC22')==0)
%         pause(0.05);
%     end

% the following might actually not be fast enough to sync to the right shot
%     err=(-1);
%     while (err<0)
%         [count,time,err]=synctoevt(16);
%     end

% another attempt to sync to an imminent shot of the new timing system
TimInjReqStart = getpvonline('TimInjReq');
Startnum = TimInjReqStart(7);
Currentnum = Startnum;

while Currentnum == Startnum
    TimInjReqCurrent = getpvonline('TimInjReq');
    Currentnum = TimInjReqCurrent(7);
    pause(0.1);
end
    


%% Trigger and wait for a shot
for loop=1:NBPM
    setpvonline([Prefix{loop} ':wfr:FA:arm'],1);
end

pause(1)

    % Check, whether BPM data acquisition has finished
    while getpv([Prefix{1} ':wfr:FA:armed'])
        pause(0.2);
    end
    
    % Wait for data acquisition to definitively be complete
    pause(1);


%% Get data
    FA  = bpm_getfa;
    
%    bpm_plotfa(FA{1}, 201);

[maxsum,injind] = max(FA{1}.S);

figure
subplot(3,1,1)
plot(getcellstruct(FA,'X',1:NBPM,injind+5))
subplot(3,1,2)
plot(getcellstruct(FA,'Y',1:NBPM,injind+5))
subplot(3,1,3)
plot(getcellstruct(FA,'S',1:NBPM,injind+5))


beamind = find(FA{1}.S>1e4);

FA2=cell2mat(FA);

timevec = (1:length(cat(2,FA2.S)))./10000;

figure;
subplot(3,1,1);
plot(timevec,cat(2,FA2.S));
xaxis([min(beamind)./1e4 max(beamind)./1e4]);
xlabel('t [s]');
ylabel('BPM sum signal');
title('Booster BPM FA data');
subplot(3,1,2);
plot(timevec,cat(2,FA2.X));
axis([min(beamind)./1e4 max(beamind)./1e4 -5 5]);
xlabel('t [s]');
ylabel('BPM x [mm]');
subplot(3,1,3);
plot(timevec,cat(2,FA2.Y));
axis([min(beamind)./1e4 max(beamind)./1e4 -5 5]);
xlabel('t [s]');
ylabel('BPM y [mm]');
    













