% function plot_single_newbpm_sr_post_mortem_loop
% plot_single_newbpm_sr_post_mortem_loop
%
% Christoph Steier, 2015

checkforao;
gotodata;

% Names of all new NSLS-2 style BPMS
BPMnames ={
    'SR01C:BPM2:SA:X'
    'SR01C:BPM7:SA:X'
    'SR01C:BPM8:SA:X'
    'SR02C:BPM2:SA:X'
    'SR02C:BPM7:SA:X'
    'SR03C:BPM2:SA:X'
    'SR03C:BPM7:SA:X'
    'SR03C:BPM8:SA:X'
    'SR04C:BPM1:SA:X'
    'SR04C:BPM2:SA:X'
    'SR04C:BPM7:SA:X'
    'SR04C:BPM8:SA:X'
    'SR05C:BPM1:SA:X'
    'SR05C:BPM2:SA:X'
    'SR05C:BPM7:SA:X'
    'SR05C:BPM8:SA:X'
    'SR06C:BPM1:SA:X'
    'SR06C:BPM2:SA:X'
    'SR06C:BPM7:SA:X'
    'SR06C:BPM8:SA:X'
    'SR07C:BPM1:SA:X'
    'SR07C:BPM2:SA:X'
    'SR07C:BPM7:SA:X'
    'SR07C:BPM8:SA:X'
    'SR08C:BPM1:SA:X'
    'SR08C:BPM2:SA:X'
    'SR08C:BPM7:SA:X'
    'SR08C:BPM8:SA:X'
    'SR09C:BPM1:SA:X'
    'SR09C:BPM2:SA:X'
    'SR09C:BPM7:SA:X'
    'SR09C:BPM8:SA:X'
    'SR10C:BPM1:SA:X'
    'SR10C:BPM2:SA:X'
    'SR10C:BPM7:SA:X'
    'SR10C:BPM8:SA:X'
    'SR11C:BPM1:SA:X'
    'SR11C:BPM2:SA:X'
    'SR11C:BPM7:SA:X'
    'SR11C:BPM8:SA:X'
    'SR12C:BPM1:SA:X'
    'SR12C:BPM2:SA:X'
    'SR12C:BPM7:SA:X'
    };

cd BPM
cd newbpm_postmortem

% shutter_status = getpv('sr:user_beam');
% topoff_status = getpv('SRBeam_Beam_I_IntrlkA');
beam_current = getpv('cmm:beam_current');

loop = 13;

setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:arm'],0);
setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:triggerMask'],bin2dec('00000010'));
%    setpvonline([BPMnames{loop}(1:end-4) 'EVR:event12trig'],bin2dec('01000000'));
setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:acqCount'],100000);
setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:pretrigCount'],1040);
%    setpvonline([BPMnames{loop}(1:end-4) 'buttonDSP'],1);

%     if getdcct2 < 15
%         setpvonline([BPMnames{loop}(1:end-4) 'attenuation'],0);
%     end

pause(2);

setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:arm'],1);

while 1
    
    if getdcct>10
        if (getpv([BPMnames{loop}(1:end-4) 'ADC0:peak'])>25000 || getpv([BPMnames{loop}(1:end-4) 'ADC1:peak'])>25000 || ...
                getpv([BPMnames{loop}(1:end-4) 'ADC2:peak'])>25000 || getpv([BPMnames{loop}(1:end-4) 'ADC3:peak'])>25000) & ...
                (getpvonline([BPMnames{loop}(1:end-4) 'attenuation'])<31)
            setpvonline([BPMnames{loop}(1:end-4) 'attenuation'],getpvonline([BPMnames{loop}(1:end-4) 'attenuation'])+1);
            pause(1);
        end
        
        if (getpv([BPMnames{loop}(1:end-4) 'ADC0:peak'])<5000 && getpv([BPMnames{loop}(1:end-4) 'ADC1:peak'])<5000 && ...
                getpv([BPMnames{loop}(1:end-4) 'ADC2:peak'])<5000 && getpv([BPMnames{loop}(1:end-4) 'ADC3:peak'])<5000) & ...
                (getpvonline([BPMnames{loop}(1:end-4) 'attenuation'])>1)
            setpvonline([BPMnames{loop}(1:end-4) 'attenuation'],getpvonline([BPMnames{loop}(1:end-4) 'attenuation'])-1);
            pause(1);
        end
    end

%     if getpv('SR05:CC:ptA:Frequency')
%         Setpv('SR05:CC:ptA:Frequency',0)
%     end
% 
%     if getpv('SR05:CC:ptB:Frequency')
%         Setpv('SR05:CC:ptB:Frequency',0)
%     end

    if (getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:triggerMask'])~=bin2dec('00000010')) ...
            || (getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:acqCount'])~=100000)
        
        setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:arm'],0);
        setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:triggerMask'],bin2dec('00000010'));
        %    setpvonline([BPMnames{loop}(1:end-4) 'EVR:event12trig'],bin2dec('01000000'));
        setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:acqCount'],100000);
        setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:pretrigCount'],90000);
        %    setpvonline([BPMnames{loop}(1:end-4) 'buttonDSP'],1);
    end
    
    
    pause(0.5);
    disp(['plot_newbpm_sr_post_mortem_loop: remains in armed state ', datestr(now)]);
    %    if (shutter_status == 1) & (topoff_status == 1) & (beam_current > 17) ...
    try
        new_current = getpv('cmm:beam_current');
    catch
        warning('Cannot read beam current!');
        new_current = beam_current;
    end
    
    if (beam_current > 17) ...
            &  (new_current<17)
        
        while getpv([BPMnames{loop}(1:end-4) 'wfr:TBT:armed'])
            pause(0.2);
        end
        
        % Wait for data acquisition to definitively be complete
        pause(1);
        
        % Read TBT data from BPMs
        [sum,tout,datatime]=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c3']);
        bpmx=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c0'])/1e6;
        bpmy=getpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:c1'])/1e6;
        
        figure(200);
        subplot(3,1,1);
        plot(cat(1,sum)');
        ylabel('Sum Data');
        title([datestr(now) ', EPICS timestamp:',datestr(1970*365.24314721+datatime/24/3600-7/24)]);
        subplot(3,1,2);
        plot(cat(1,bpmx)');
        yaxis([-5 5]);
        ylabel('x [mm]');
        subplot(3,1,3)
        plot(cat(1,bpmy)'/1e6)
        yaxis([-3 3])
        xlabel('turn #');
        ylabel('y [mm]');
        
        ind=min(find(sum<1e6));
        %        ind2=min(find(data(2).PM_SUM_MONITOR<1e6));
        %        ind3=min(find(data(3).PM_SUM_MONITOR<1e6));
        
        %        ind=max([ind ind2 ind3]);
        
        if isempty(ind)
            ind=min(find(sum<0.5*sum(1)));
        end
        
        if isempty(ind)
            ind=length(sum);
        end
        
        figure(201);
        subplot(3,1,1);
        plot(cat(1,sum)');
        xaxis([ind-1500 ind+500]);
        ylabel('Sum Data');
        title([datestr(now) ', EPICS timestamp:',datestr(1970*365.24314721+datatime/24/3600-7/24)]);
        subplot(3,1,2);
        plot(cat(1,bpmx)');
        xaxis([ind-1500 ind+500]);
        yaxis([-10 10]);
        ylabel('x [mm]');
        subplot(3,1,3)
        plot(cat(1,bpmy)')
        yaxis([-3 3])
        xlabel('turn #');
        ylabel('y [mm]');
        xaxis([ind-1500 ind+500]);
        
        fftsum=abs(fft(sum(1:ind)-mean(sum(1:ind))));
        fftx=abs(fft(bpmx(1:ind)-mean(bpmx(1:ind))));
        ffty=abs(fft(bpmy(1:ind)-mean(bpmy(1:ind))));
        
        %         fftsum2=abs(fft(data(2).PM_SUM_MONITOR(1:ind)-mean(data(2).PM_SUM_MONITOR(1:ind))));
        %         fftx2=abs(fft(data(2).PM_X_MONITOR(1:ind)-mean(data(2).PM_X_MONITOR(1:ind))));
        %         ffty2=abs(fft(data(2).PM_Y_MONITOR(1:ind)-mean(data(2).PM_Y_MONITOR(1:ind))));
        %
        %         fftsum3=abs(fft(data(3).PM_SUM_MONITOR(1:ind)-mean(data(3).PM_SUM_MONITOR(1:ind))));
        %         fftx3=abs(fft(data(3).PM_X_MONITOR(1:ind)-mean(data(3).PM_X_MONITOR(1:ind))));
        %         ffty3=abs(fft(data(3).PM_Y_MONITOR(1:ind)-mean(data(3).PM_Y_MONITOR(1:ind))));
        %
        %         fftsum=([fftsum;fftsum2;fftsum3]);
        %         fftx=([fftx;fftx2;fftx3]);
        %         ffty=([ffty;ffty2;ffty3]);
        
        freqvec=(1:ind)./ind;
        
        figure(202);
        subplot(3,1,1);
        plot(freqvec,fftsum);
        xaxis([0 1]);
        ylabel('fft(Sum Data)');
        title([datestr(now) ', EPICS timestamp:',datestr(1970*365.24314721+datatime/24/3600-7/24)]);
        subplot(3,1,2);
        plot(freqvec,fftx);
        xaxis([0 1]);
        ylabel('fft(x)');
        subplot(3,1,3)
        plot(freqvec,ffty)
        ylabel('fft(y)');
        xaxis([0 1]);
        xlabel('fractional tune');
        
        %         print -f200 -dwinc
        %         print -f201 -dwinc
        %         print -f202 -dwinc
        
        print(200,'-dpng',sprintf('newbpm_pm_fig200_%s',datestr(now,30)))
        print(201,'-dpng',sprintf('newbpm_pm_fig201_%s',datestr(now,30)))
        print(202,'-dpng',sprintf('newbpm_pm_fig202_%s',datestr(now,30)))
        
        
        filename=sprintf('newbpm_pm_data_%s',datestr(now,30));
        save(filename,'sum','bpmx','bpmy','datatime');
        
%         shutter_status = getpv('sr:user_beam');
%         topoff_status = getpv('SRBeam_Beam_I_IntrlkA');
        try
            beam_current = getpv('cmm:beam_current');
        catch
            warning('Cannot read beam current!');
            beam_current = new_current;
        end
        
        setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:arm'],1);
        
    else
        
        setpvonline([BPMnames{loop}(1:end-4) 'wfr:TBT:arm'],1);
%         shutter_status = getpv('sr:user_beam');
%         topoff_status = getpv('SRBeam_Beam_I_IntrlkA');
        try
            beam_current = getpv('cmm:beam_current');
        catch
            warning('Cannot read beam current!');
            beam_current = new_current;
        end        
    end
end