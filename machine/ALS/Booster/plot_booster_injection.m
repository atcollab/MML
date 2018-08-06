function plot_booster_injection(varargin)
% function plot_booster_injection(varargin)

checkforao

liberainit

f1=figure;

    [FINISHED_MONITOR_0, FINISHED_MONITOR_TIMESTAMP] = lcaGet('LIBERA_0A7E:DD1:DD_FINISHED_MONITOR');
    FINISHED_MONITOR_1 = FINISHED_MONITOR_0;
    lcaPut('LIBERA_0A7E:DD1:DD_ON_NEXT_TRIG_CMD', 1, 'double');

while 1
    while getpv('GTL_____TIMING_BC00')==0
        pause(0.05);
    end
    
    % Wait for new data
    t0 = clock; 
%     while (FINISHED_MONITOR_1 == FINISHED_MONITOR_0) && (etime(clock, t0) < 5)
%         pause(0.05);
%         [FINISHED_MONITOR_1, FINISHED_MONITOR_TIMESTAMP] = lcaGet('LIBERA_0A7E:DD1:DD_FINISHED_MONITOR');
%         FINISHED_MONITOR_TIMESTAMP = convertime_local(FINISHED_MONITOR_TIMESTAMP);
%     end
   
    FINISHED_MONITOR_0= FINISHED_MONITOR_1;

    am.DD_X_MONITOR=getpvonline('LIBERA_0A7E:DD1:DD_X_MONITOR');
    am.DD_Y_MONITOR=getpvonline('LIBERA_0A7E:DD1:DD_Y_MONITOR');
    am.DD_SUM_MONITOR=getpvonline('LIBERA_0A7E:DD1:DD_SUM_MONITOR');

    lcaPut('LIBERA_0A7E:DD1:DD_ON_NEXT_TRIG_CMD', 1, 'double');

    timevec=250e-9*(1:length(am.DD_SUM_MONITOR));
    ind = find(am.DD_SUM_MONITOR>3e5);
    
%     figure(f1);
%     plot(timevec,am.DD_SUM_MONITOR);
%     pause(0.1);
       
    
    if ~isempty(ind)
        am.DD_X_MONITOR(1:(ind(1)))=NaN;
        am.DD_Y_MONITOR(1:(ind(1)))=NaN;
        
        figure(f1);
        clf;
        if exist('textlabel','var')
            delete(textlabel);
        end
        subplot(3,1,1);
        plot(timevec((ind(1)-5):(ind(1)+1000)),am.DD_SUM_MONITOR((ind(1)-5):(ind(1)+1000)),'.-');
        axis tight;
        yaxis([0 1e8]);
        xlabel('t [s] (after booster BPM diag trigger)');
        ylabel('SUM signal (ADC counts)');
        title('Booster libera turn-by-turn monitor (LIBERA_0A7E)');
        subplot(3,1,2);
        plot(timevec((ind(1)-5):(ind(1)+1000)),am.DD_X_MONITOR((ind(1)-5):(ind(1)+1000))/0.6e6);
        xlabel('t [s] (after booster BPM diag trigger)');
        ylabel('x [mm]');
        axis tight;
        yaxis([-5 5]);
        subplot(3,1,3);
        plot(timevec((ind(1)-5):(ind(1)+1000)),am.DD_Y_MONITOR((ind(1)-5):(ind(1)+1000))/0.6e6)
        xlabel('t [s] (after booster BPM diag trigger)');
        ylabel('y [mm]');
        axis tight;
        yaxis([-5 5]);
        textlabel=addlabel(datestr(FINISHED_MONITOR_TIMESTAMP));
        drawnow;
    end
    pause(0.1);
    
end


function DataTime = convertime_local(DataTime)
% Input DataTime is the time on computer taking the data (EPICS) using LabCA complex formating
% Output is referenced w.r.t. the time zone where Matlab is running in Matlab's date number format
t0 = clock;
DateNumber1970 = 719529;  %datenum('1-Jan-1970');
days = datenum(t0(1:3)) - DateNumber1970;
t0_sec = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + t0(6);
TimeZoneDiff = round((t0_sec - real(DataTime(1,1)))/60/60);
DataTime = (real(DataTime)/60/60 + TimeZoneDiff)/24 + DateNumber1970 + imag(DataTime)/(1e9 * 60 * 60 * 24);
