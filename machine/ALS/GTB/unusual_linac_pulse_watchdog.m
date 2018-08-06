function unusual_linac_pulse_watchdog(varargin)
% function unusual_linac_pulse_watchdog(varargin)
%
% Routine that checks for unusual linac pulses (mistriggered linac, gun pulse too long, ...)

last_waveform_cnt = 0;
f1=figure;

gotodata

load 'modulator_reference_waveforms.mat'

if exist('unusual_linac_pulse_log.mat','file')
    load 'unusual_linac_pulse_log.mat'
else
    event_timevec = [];
end

if ~exist('event_timevec')
    event_timevec = [];
end

mod1nom=mod1;mod2nom=mod2;timevecnom=timevec;
index_range = 1600:2400;

while 1
    new_waveform_cnt=getpv('ztec4:Inp1WaveCount');
    if  new_waveform_cnt>last_waveform_cnt
        last_waveform_cnt=new_waveform_cnt;
        mod1=getpv('ztec4:Inp1ScaledWave');
        mod2=getpv('ztec4:Inp2ScaledWave');
        timevec=getpv('ztec4:InpScaledTime');
        indvec=find(timevec>0);
        figure(f1)
        plot( ...
            timevecnom(indvec),mod1nom(indvec),'c-',timevecnom(indvec),mod2nom(indvec),'m-', ...
            timevec(indvec),mod1(indvec),'b-',timevec(indvec),mod2(indvec),'r-');
        xlabel('t [s]');
        ylabel('Modulator Output');
        legend('Mod 1 reference','Mod 2 reference','Mod 1 actual','Mod 2 actual')
        title(datestr(now));
%        fprintf('norm1 = %.4f, norm2 = %.4f \n',norm(mod1nom(index_range)-mod1(index_range)),norm(mod2nom(index_range)-mod2(index_range)));
%        if max(mod1(index_range))>0.1 && ((norm(mod1(index_range)-mod1nom(index_range))>0.35) || (norm(mod2(index_range)-mod2nom(index_range))>0.3)) && getpv('EG______HV_____BC23')

        % if modulator 1 is on and is deviating from its reference waveform
        % or modulator 2 is on and is deviating from its reference waveform
        % and the electron gun is on
        if (((max(mod1(index_range))>0.1) && (norm(mod1(index_range)-mod1nom(index_range))>0.35) && (getpv('LN______MD1HV__BM03'))) ...
                || ((max(mod2(index_range))>0.1) && (norm(mod2(index_range)-mod2nom(index_range))>0.3) && (getpv('LN______MD2HV__BM03')))) ...
                    && getpv('EG______HV_____BC23')
                    
            fprintf('Abnormal Modulator trace detected: %s\n',datestr(now));
            soundtada;
            event_timevec = [event_timevec now];
            save 'unusual_linac_pulse_log.mat' event_timevec
            filenamestr=sprintf('linac_modulator_waveforms_%s.mat',datestr(now,30));
            save(filenamestr,'timevec','mod1','mod2','event_timevec');
            f1=figure;
        end
    end
    pause(0.2);
end
    