
%Prefix = getfamilydata('BPM','BaseName');


% lcaNewMonitorValue(pvs)
% lcaNewMonitorWait(pvs)
% lcaSetMonitor(pvs, nmax, type)
% lcaClear(pvs);

TimeFormat = 'HH:MM:SS.FFF';
 
%%
EvtCode_SP   = getpvonline('LI11:EVG1-SoftSeq:0:EvtCode-SP',   'Waveform');
Timestamp_SP = getpvonline('LI11:EVG1-SoftSeq:0:Timestamp-SP', 'Waveform');

EvtCode_SP(1:20)
Timestamp_SP(1:20)

for i = 1:1000
EvtCode_RB   = getpvonline('LI11:EVG1-SoftSeq:0:EvtCode-RB', 'Waveform');
Timestamp_RB = getpvonline('LI11:EVG1-SoftSeq:0:Timestamp-RB', 'Waveform');
EvtCode_RB(1:31)
%Timestamp_RB(1:20) 
pause(1);
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
