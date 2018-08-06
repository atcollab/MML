function unusual_linac_pulse_watchdog_2ztec(varargin)
% function unusual_linac_pulse_watchdog_2ztec(varargin)
%
% Routine that checks for unusual linac pulses (mistriggered linac, gun pulse too long, ...)

last_waveform_cnt = 0;
f1=figure;

gotodata;

load 'modulator_reference_waveforms_3.mat'

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

timevec16=zeros(size(getpv('ztec16:InpScaledTime')));
kly2cathv=zeros(size(timevec16));
ionpump=zeros(size(timevec16));
kly2fwd=zeros(size(timevec16));
ln2fwd=zeros(size(timevec16));

fprintf('\nMonitoring LN modulators for unusual traces...\n');

while 1
    new_waveform_cnt=getpv('ztec4:Inp1WaveCount');
    if  new_waveform_cnt>last_waveform_cnt
        pause(0.2);
        last_waveform_cnt=new_waveform_cnt;
        try
            mod1=getpv('ztec4:Inp1ScaledWave');
            mod2=getpv('ztec4:Inp2ScaledWave');
            timevec=getpv('ztec4:InpScaledTime');
            kly2cathv=getpv('ztec16:Inp1ScaledWave');
            ionpump=getpv('ztec16:Inp2ScaledWave');
            kly2fwd=getpv('ztec16:Inp3ScaledWave');
            ln2fwd=getpv('ztec16:Inp4ScaledWave');
            timevec16=getpv('ztec16:InpScaledTime');
        catch
            disp('Failed to read one of the scope waveforms ... Continuing ...');
        end
        indvec=find(timevec>0);
        indvec2=find(timevec16>0);
        figure(f1)
        subplot(3,1,1);
        plot( ...
            timevecnom(indvec),mod1nom(indvec),'c-',timevecnom(indvec),mod2nom(indvec),'m-', ...
            timevec(indvec),mod1(indvec),'b-',timevec(indvec),mod2(indvec),'r-');
        xaxis([min(timevec(indvec)) max(timevec(indvec))]);
        xlabel('t [s]');
        ylabel('Modulator Output');
        legend('Mod 1 reference','Mod 2 reference','Mod 1 actual','Mod 2 actual')
        title(datestr(now));
        subplot(3,1,2);
        plot( ...
            timevec16(indvec2),kly2cathv(indvec2)/20,'c-',timevec16(indvec2),ionpump(indvec2)/20,'m-', ...
            timevec16(indvec2),kly2fwd(indvec2),'b-',timevec16(indvec2),ln2fwd(indvec2),'r-');
        xaxis([min(timevec(indvec)) max(timevec(indvec))]);
        xlabel('t [s]');
        ylabel('Kly 2 / LN 2');
        legend('Kly 2 Cath Volt/20','Ion Pump/20','Kly 2 Fwrd Pwr','LN 2 Fwrd Pwr')
        subplot(3,1,3);
        plot( ...
            timevec16(indvec2),kly2cathv(indvec2)/20,'c-',timevec16(indvec2),ionpump(indvec2)/20,'m-', ...
            timevec16(indvec2),kly2fwd(indvec2),'b-',timevec16(indvec2),ln2fwd(indvec2),'r-');
        xaxis([min(timevec16(indvec2)) max(timevec16(indvec2))]);
        xlabel('t [s]');
        ylabel('Kly 2 / LN 2');
        legend('Kly 2 Cath Volt/20','Ion Pump/20','Kly 2 Fwrd Pwr','LN 2 Fwrd Pwr')
%        fprintf('norm1 = %.4f, norm2 = %.4f \n',norm(mod1nom(index_range)-mod1(index_range)),norm(mod2nom(index_range)-mod2(index_range)));
%        if max(mod1(index_range))>0.1 && ((norm(mod1(index_range)-mod1nom(index_range))>0.35) || (norm(mod2(index_range)-mod2nom(index_range))>0.3)) && getpv('EG______HV_____BC23')

        % if modulator 1 is on and is deviating from its reference waveform
        % or modulator 2 is on and is deviating from its reference waveform
        % and the electron gun is on
        if (((max(mod1(index_range))>0.1) && (norm(mod1(index_range)-mod1nom(index_range))>0.4) && (getpv('LN______MD1HV__BM03'))) ...
                || ((max(mod2(index_range))>0.1) && (norm(mod2(index_range)-mod2nom(index_range))>0.35) && (getpv('LN______MD2HV__BM03')))) ...
                    && getpv('EG______HV_____BC23')
                    
            fprintf('Abnormal Modulator trace detected: %s\n',datestr(now));
            soundtada;
            event_timevec = [event_timevec now];
            save 'unusual_linac_pulse_log.mat' event_timevec
            filenamestr=sprintf('linac_modulator_waveforms_%s.mat',datestr(now,30));
            save(filenamestr,'timevec','mod1','mod2','event_timevec','timevec16','kly2fwd','kly2cathv','ionpump','ln2fwd');
            f1=figure;
        end
    end
    pause(0.2);
end
    