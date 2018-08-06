function missed_extraction_watchdog(varargin)
% function missed_extraction_watchdog(varargin)
%
% Routine that checks for missed extractions from booster

event_timevec = [];
last_waveform_cnt = 0;
f1=figure;

while 1
    new_waveform_cnt=getpv('ztec2:Inp1WaveCount');
    if  new_waveform_cnt>last_waveform_cnt
        last_waveform_cnt=new_waveform_cnt;
        ict=getpv('ztec2:Inp1ScaledWave');
        timevec=getpv('ztec2:InpScaledTime');    
        ict2=reshape(ict(11:end),17,length(ict(11:end))/17);
        ict3=max(ict2)-min(ict2);
        timevec2=reshape(timevec(11:end),17,length(timevec(11:end))/17);
        timevec3=mean(timevec2);
        figure(f1)
        plot(timevec3,ict3);
        if ict3(end)>0.1
            fprintf('Detected missed booster extraction: %s\n',datestr(now));
            event_timevec = [event_timevec now];
            save 'booster_missed_extraction_log.mat' event_timevec
        end
    end
    pause(1);
end
    