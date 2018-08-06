function unusual_booster_pulse_watchdog(varargin)
% function unusual_booster_pulse_watchdog(varargin)
%
% Routine that checks for unusual booster pulses (IE power supply regulation glitches/IGBT trips)

f1=figure;

gotodata;

if exist('unusual_booster_pulse_log.mat','file')
    load 'unusual_booster_pulse_log.mat'
else
    event_timevec = [];
end

if ~exist('event_timevec')
    event_timevec = [];
end

Dataref=get_dpsc_current_waveforms_cond;

fprintf('\nMonitoring Booster power supplies for unusual traces...\n');

while 1
    Datanew=get_dpsc_current_waveforms_cond;
    
    if  real(Datanew.TimeStamp(1))>real(Dataref.TimeStamp(1))

        figure(f1)
        subplot(2,1,1)
            plot(Datanew.Timevec,Datanew.Data)
            xlabel('Time [Seconds]')
            ylabel('Current [Amps]')
            legend('BEND','QF', 'QD')
            title(['BR Waveforms' datestr(now)])
        subplot(2,1,2)
            plot(Datanew.Timevec,Dataref.Data-Datanew.Data)
            xlabel('Time [Seconds]')
            ylabel('\DeltaI [Amps]')
            legend('\DeltaBEND','\DeltaQF', '\DeltaQD')

        if ((std(Datanew.Data(:,1)-Dataref.Data(:,1))>1) && (real(Datanew.TimeStamp(1))>real(Dataref.TimeStamp(1)))) ...
                || ((std(Datanew.Data(:,2)-Dataref.Data(:,2))>1) && (real(Datanew.TimeStamp(2))>real(Dataref.TimeStamp(2)))) ...
                || ((std(Datanew.Data(:,3)-Dataref.Data(:,3))>1) && (real(Datanew.TimeStamp(3))>real(Dataref.TimeStamp(3))))
                    
            fprintf('Abnormal Booster trace detected: %s\n',datestr(now));
            soundtada;
            event_timevec = [event_timevec now];
            save 'unusual_booster_pulse_log.mat' event_timevec
            filenamestr=sprintf('booster_waveforms_%s.mat',datestr(now,30));
            save(filenamestr,'Datanew');
            f1=figure;
        end
        Dataref=Datanew;
    end
    pause(1);
end
    