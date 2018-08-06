
% How long does it take to remove a paddle?
% How long to change the bias?
%    Do I need to change the bias ahead of the sequencer doing it???
%    Same with InjFieldGroupDelay???


%Prefix = getfamilydata('BPM','BaseName');


% lcaNewMonitorValue(pvs)
% lcaNewMonitorWait(pvs)
% lcaSetMonitor(pvs, nmax, type)
% lcaClear(pvs);

%TimeFormat = 'HH:MM:SS.FFF';


GunBunchToGunBias         = getpv('GunBunchToGunBias')
GunBunchToInjFieldTrigger = getpv('GunBunchToInjFieldTrigger')

GaussClockInjectionFieldTrigger  = getpv('GaussClockInjectionFieldTrigger')
GaussClockExtractionFieldTrigger = getpv('GaussClockExtractionFieldTrigger')

TimSeqState

%GunBunchToInjFieldTrigger
%TimExtrFieldSyncDelay
% TimExtrFieldSyncDelay
% TimInjFieldSyncDelay
% TimTargetBucketDelay


% Need to control paddles per mode!!!


%%

%setpvonline('LI11<EVG1-SoftSeq:1>EvtCode-SP',   EvtCode_SP);
%setpvonline('LI11<EVG1-SoftSeq:1>Timestamp-SP', Timestamp_SP);

%% TimInjReq Waveform
% 1. Storage ring bucket number (1 to 328)
% 
% 2. Number of gun bunches (1, 2, 3, 4, … 16)
%     Gun bias waveform (GunBunchToGunBias) - 16 elements which has the desired gun bias setpoint for each number of bunches. 
%     Gun Bias PV:  EG______BIAS___AC01 EG______BIAS___AM01  (16-bit IRM001 DAC1)
%                   It takes about .5 seconds for the Bias to change.
% 
%     Injection field trigger waveform - 16 elements which has the desired injection field trigger setpoint for each number of bunches.
% 

%     What PV is this using?

% 3. Injection Mode Number:  Setup, Injection, and Tuning Modes
%     0 ->  Prepare for a storage ring injection
%     1 ->  Storage ring injection
% 
% 4. Gun Inhibit (override option on the gun trigger enable)
%     0 -> Gun trigger state determined by the mode number (3)
%     1 -> Disable the gun trigger 
% 5. Future use
% 6. Future use
% 7. Sequence Number

Req = getpv('TimInjReq')
Req(7) = Req(7) + 1; if Req(7)>20000; Req(7) = 1; end
setpv('TimInjReq', Req);


%%
EvtCode_SP   = getpvonline('LI11:EVG1-SoftSeq:0:EvtCode-SP',   'Waveform');
Timestamp_SP = getpvonline('LI11:EVG1-SoftSeq:0:Timestamp-SP', 'Waveform');

EvtCode_SP(1:20)
Timestamp_SP(1:20)

for i = 1:1000
EvtCode_RB   = getpvonline('LI11:EVG1-SoftSeq:0:EvtCode-RB', 'Waveform');
Timestamp_RB = getpvonline('LI11:EVG1-SoftSeq:0:Timestamp-RB', 'Waveform');
EvtCode_RB(1:20)
%Timestamp_RB(1:20) 
pause(1);
end

%%
t0 = gettime;
for i = 1:50
    [Evt10, t, Ts10] = getpvonline('LI11:EVR1:Evt10Cnt-I', 'double');
    [InjState, t, Ts] = getpvonline('TimSeqState');
    Ts10 = linktime2datenum(Ts10);
    Ts = linktime2datenum(Ts);
    fprintf('%6.2f  %s  %22s  %d   %s\n', gettime-t0, datestr(Ts, 'HH:MM:SS.FFF'), InjState, Evt10, datestr(Ts10, 'HH:MM:SS.FFF'));
    pause(.05);
end

%%

% LI11:EVR1:1hzCnt-I
% LI11:EVR1:BRThickSeptumEvtCnt-I
% LI11:EVR1:BRThinSeptumEvtCnt-I
% LI11:EVR1:BumpFieldEvtCnt-I
% LI11:EVR1:BuncherScopeEvtCnt-I
% LI11:EVR1:Evt10Cnt-I
% LI11:EVR1:Evt12Cnt-I
% LI11:EVR1:Evt20Cnt-I
% LI11:EVR1:Evt22Cnt-I
% LI11:EVR1:Evt26Cnt-I
% LI11:EVR1:Evt36Cnt-I
% LI11:EVR1:Evt37Cnt-I
% LI11:EVR1:Evt38Cnt-I
% LI11:EVR1:Evt40Cnt-I
% LI11:EVR1:Evt42Cnt-I
% LI11:EVR1:Evt52Cnt-I
% LI11:EVR1:Evt54Cnt-I
% LI11:EVR1:ExtrFieldEvtCnt-I
% LI11:EVR1:FIFOCap-I
% LI11:EVR1:GunOffEvtCnt-I
% LI11:EVR1:GunOnEvtCnt-I
% LI11:EVR1:InjFieldEvtCnt-I
% LI11:EVR1:LNModScopeEvtCnt-I
% LI11:EVR1:Link:ClkErr-I
% LI11:EVR1:Link:ClkPeriod-I
% LI11:EVR1:Rate:FIFOEvt-I
% LI11:EVR1:Rate:FIFOLoop-I
% LI11:EVR1:Rate:IRQ-I
% LI11:EVR1:StartEvtCnt-I
% LI11:EVR1:TWEScopeEvtCnt-I

EvtPVs = {
'LI11:EVR1:Evt10Cnt-I'
'LI11:EVR1:Evt38Cnt-I'
'LI11:EVR1:Evt54Cnt-I'};

for i = 1:10
    [Evt, t, Ts] = getpvonline(EvtPVs, 'double');
    Ts = linktime2datenum(Ts);
    Evt
    datestr(Ts, 'HH:MM:SS.FFF')
    disp(' ');
    pause(1.4);
end



%%

PV_TimSeq_Start    = 'LI11<EVR1>EvtACnt-I';
PV_TimSeq_PreInj   = 'LI11<EVR1>EvtBCnt-I';
PV_TimSeq_PreExtr  = 'LI11<EVR1>EvtCCnt-I';
PV_TimSeq_PostExtr = 'LI11<EVR1>EvtDCnt-I';
PV_TimSeq_End      = 'LI11<EVR1>EvtECnt-I';


% Start monitor
%lcaSetMonitor(PV_TimSeq_Start);
lcaSetMonitor(PV_TimSeq_PostExtr);

[d, tb, PostExtr_TS] = getpv(PV_TimSeq_PostExtr);

DCCT0 = getdcct;
setpvonline('BR3:BPM4:wfr:ADC:arm', 1);
setpvonline('BR3:BPM4:wfr:TBT:arm', 1);
setpvonline('BR3:BPM4:wfr:FA:arm', 1);

t0 = clock;
for i = 1:3000
    
    %aFlag = lcaNewMonitorValue(PV_TimSeq_Start);
    dFlag = lcaNewMonitorValue(PV_TimSeq_PostExtr);
    if dFlag
        
        [a, ta, Start_TS]    = getpv(PV_TimSeq_Start);
        [b, tb, PreInj_TS]   = getpv(PV_TimSeq_PreInj);
        [c, tb, PreExtr_TS]  = getpv(PV_TimSeq_PreExtr);
        [d, tb, PostExtr_TS] = getpv(PV_TimSeq_PostExtr);
        [e, tb, End_TS]      = getpv(PV_TimSeq_End);
        
        DCCT1 = getdcct;
        
        fprintf('%3d.   %.3f  %s    %s  %s  %s  %s  %s   %.3f  %d  %.2f\n', i, etime(clock, t0), datestr(now, TimeFormat), datestr(Start_TS, TimeFormat), datestr(PreInj_TS, TimeFormat), datestr(PreExtr_TS, TimeFormat), datestr(PostExtr_TS, TimeFormat), datestr(End_TS, TimeFormat), 24*3600*(End_TS-Start_TS), d, DCCT1);
        
        %fprintf('%3d.   %.3f  %s    %d  %s   %d  %s   %.3f  %d %d \n', i, etime(clock, t0), datestr(now, TimeFormat), a, datestr(Start_TS, TimeFormat), b, datestr(PostExtr_TS, TimeFormat), 24*3600*(PostExtr_TS-Start_TS), ma, mb);

        pause(.1);
        if DCCT1 - DCCT0 > .2
            break
        else
            % rearm
            setpvonline('BR3:BPM4:wfr:ADC:arm', 1);
            setpvonline('BR3:BPM4:wfr:TBT:arm', 1);
            setpvonline('BR3:BPM4:wfr:FA:arm', 1);
            
            for i = 1:length(Prefix)
                setpvonline([Prefix{i},':wfr:ADC:arm'], 1);
                setpvonline([Prefix{i},':wfr:TBT:arm'], 1);
                setpvonline([Prefix{i},':wfr:FA:arm'],  1);
            end
            
            DCCT0 = DCCT1;
        end
    
    else
        pause(.01);
    end
end

% Clear monitor
%lcaClear(PV_TimSeq_Start);
lcaClear(PV_TimSeq_PostExtr);


% t0 = clock;
% for i = 1:30
%     
%     %ma = lcaNewMonitorValue(PV_TimSeq_Start);
%     %mb = lcaNewMonitorValue(PV_TimSeq_PostExtr);
%     ma = 0; mb = 0;
%     
%     [a, ta, Start_TS]    = getpv(PV_TimSeq_Start);
%     [b, tb, PreInj_TS]   = getpv(PV_TimSeq_PreInj);
%     [c, tb, PreExtr_TS]  = getpv(PV_TimSeq_PreExtr);
%     [d, tb, PostExtr_TS] = getpv(PV_TimSeq_PostExtr);
%     [e, tb, End_TS]      = getpv(PV_TimSeq_End);
%     
%     fprintf('%3d.   %.3f  %s    %s  %s  %s  %s  %s   %.3f\n', i, etime(clock, t0), datestr(now, TimeFormat), datestr(Start_TS, TimeFormat), datestr(PreInj_TS, TimeFormat), datestr(PreExtr_TS, TimeFormat), datestr(PostExtr_TS, TimeFormat), datestr(End_TS, TimeFormat), 24*3600*(End_TS-Start_TS));
% 
%     %fprintf('%3d.   %.3f  %s    %d  %s   %d  %s   %.3f  %d %d \n', i, etime(clock, t0), datestr(now, TimeFormat), a, datestr(Start_TS, TimeFormat), b, datestr(PostExtr_TS, TimeFormat), 24*3600*(PostExtr_TS-Start_TS), ma, mb);
%     pause(.01);
% end
