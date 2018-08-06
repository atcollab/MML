% LI11<EVR1>EvtACnt-I  -  Evt 10  -> Start of sequence counter
% LI11<EVR1>EvtBCnt-I  -  Evt 11  -> Pre injection event counter
% LI11<EVR1>EvtCCnt-I  -  Evt 12  -> Pre extraction event counter
% LI11<EVR1>EvtDCnt-I  -  Evt 13  -> Post extraction event counter
% LI11<EVR1>EvtECnt-I  -  Evt 14  -> End of sequence counter
% 
% camonitor -tsI 'LI11<EVR1>EvtACnt-I'


Prefix = getfamilydata('BPM','BaseName');


% lcaNewMonitorValue(pvs)
% lcaNewMonitorWait(pvs)
% lcaSetMonitor(pvs, nmax, type)
% lcaClear(pvs);

TimeFormat = 'HH:MM:SS.FFF';
 
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
