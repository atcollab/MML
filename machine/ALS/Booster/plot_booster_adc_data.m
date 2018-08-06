% setpvonline('LIBERA_0A7E:ENV:ENV_DSC_SP',0);
% setpvonline('LIBERA_0A7E:ENV:ENV_SWITCHES_SP',0);
%
% pause(0.1);
%
% setpvonline('LIBERA_0A7E:DD3:DD_REQUEST_CMD',1)
% % setpvonline('LIBERA_0A7E:DD3:DD_ON_NEXT_TRIG_CMD',1);
%
% datax=getpvonline('LIBERA_0A7E:DD3:DD_X_MONITOR','Waveform');
% datay=getpvonline('LIBERA_0A7E:DD3:DD_Y_MONITOR','Waveform');
% sum=getpvonline('LIBERA_0A7E:DD3:DD_SUM_MONITOR','Waveform');

f1 = figure(1);

for ii = 1:1
    while getpv('GTL_____TIMING_BC00')==0
        pause(0.01);
    end

    [am,sp,name] = getlibera('ADC',[1 1],1);

    
%     timevec=250e-9*(1:length(am.DD_SUM_MONITOR));
%     ind = find(am.DD_SUM_MONITOR>3e5);
% 
%     if length(ind)>0
%         am.DD_X_MONITOR(1:(ind(1)))=NaN;
%         am.DD_Y_MONITOR(1:(ind(1)))=NaN;
%     end
%     
%     figure(f1);
%     subplot(3,1,1);
%     plot(timevec,am.DD_SUM_MONITOR);
%     yaxis([0 1e8]);
%     xlabel('t [s] (after booster BPM diag trigger)');
%     ylabel('SUM signal (ADC counts)');
%     title(name);
%     subplot(3,1,2);
%     plot(timevec,am.DD_X_MONITOR/0.6e6);
%     xlabel('t [s] (after booster BPM diag trigger)');
%     ylabel('x [mm]');
%     yaxis([-5 5]);
%     subplot(3,1,3);
%     plot(timevec,am.DD_Y_MONITOR/0.6e6)
%     xlabel('t [s] (after booster BPM diag trigger)');
%     ylabel('y [mm]');
%     yaxis([-5 5]);
%     addlabel(am.DD_FINISHED_MONITOR_TIMESTAMP);
end
