checkforao;

BPMname = getname('BPMx',[5 8]);
BPMname = BPMname(1:10);

% retry = 200;
% fprintf('   Setting LabCA retry count to %i\n', retry);
% lcaSetRetryCount(retry);

% liberainit([3 5],0);
% if strfind(getpvonline('SR_mode'),'Two-Bunch')>0
%     setpv('LIBERA_0AB3:ENV:ENV_GAIN_SP',-33);
% else
%     setpv('LIBERA_0AB3:ENV:ENV_GAIN_SP',-33);   % libera is now connected through splitter, i.e. smaller signal
%     % setpv('LIBERA_0AB3:ENV:ENV_GAIN_SP',-27);
% end
% setpv('LIBERA_0AB3:ENV:ENV_AGC_SP',1);
% setpv('LIBERA_0AB3:ENV:ENV_DSC_SP',2);
% setpv('LIBERA_0AB3:ENV:ENV_SWITCHES_SP',255);
% %
% pause(0.1);

% 2017-04-17 - change event12trig to event66trig
% 2017-08-31 - updated event66trig -> event48trig (SCL)

setpvonline([BPMname ':wfr:TBT:arm'],0);
setpvonline([BPMname ':wfr:TBT:triggerMask'],bin2dec('01000000'));
setpvonline([BPMname ':EVR:event48trig'],bin2dec('01000000'));
setpvonline([BPMname ':EVR:event48trig'],bin2dec('01000000'));
setpvonline([BPMname ':wfr:TBT:acqCount'],100000);

f1=figure;
f2=figure;

while 1
    
    if getdcct>10
        if (getpv([BPMname ':ADC0:peak'])>25000 || getpv([BPMname ':ADC1:peak'])>25000 || getpv([BPMname ':ADC2:peak'])>25000 || getpv([BPMname ':ADC3:peak'])>25000) && (getpvonline([BPMname ':attenuation'])<31)
            setpvonline([BPMname ':attenuation'],getpvonline([BPMname ':attenuation'])+2)
        end
        
        if (getpv([BPMname ':ADC0:peak'])<5000 && getpv([BPMname ':ADC1:peak'])<5000 && getpv([BPMname ':ADC2:peak'])<5000 && getpv([BPMname ':ADC3:peak'])<5000) && (getpvonline([BPMname ':attenuation'])>1)
            setpvonline([BPMname ':attenuation'],getpvonline([BPMname ':attenuation'])-2)
        end
    end
    
    if (getpvonline([BPMname ':wfr:TBT:triggerMask'])~=bin2dec('01000000')) ...
            || (getpvonline([BPMname ':EVR:event48trig'])~=bin2dec('01000000')) ...
            || (getpvonline([BPMname ':wfr:TBT:acqCount'])~=100000)
        
        setpvonline([BPMname ':wfr:TBT:arm'],0);
        setpvonline([BPMname ':wfr:TBT:triggerMask'],bin2dec('01000000'));
        setpvonline([BPMname ':EVR:event48trig'],bin2dec('01000000'));
        setpvonline([BPMname ':wfr:TBT:acqCount'],100000);
    end

        
        
%    while (getpv('GTL_____TIMING_BC00')==0) || (getpv('SR01S___BUMP1__BC21')==0)
%    while (getpv('GTL_____TIMING_BC00')==0)

    err=(-1);
    while (err<0)
        [count,time,err]=synctoevt(16);
    end
        
    setpvonline([BPMname ':wfr:TBT:arm'],1);
    
    while getpv([BPMname ':wfr:TBT:armed'])
        pause(0.2);
    end
    
    pause(1);
    
    am.DD_SUM_MONITOR=getpvonline([BPMname ':wfr:TBT:c3']);
    am.DD_X_MONITOR=getpvonline([BPMname ':wfr:TBT:c0']);
    am.DD_Y_MONITOR=getpvonline([BPMname ':wfr:TBT:c1']);
    
    if (max(am.DD_X_MONITOR)-min(am.DD_X_MONITOR))>0.1e6

        [dummy,ind] = max(am.DD_X_MONITOR);
        if isnan(ind) || isempty(ind) || (ind<100) || ((length(am.DD_SUM_MONITOR)-ind)<920)
            ind = 45000;
        end
        
        
        if mean(getpv('QFA',[1 1])>530)
            intx=16;
        else
            intx=14;
        end
        
        timevec=654e-9*(1:length(am.DD_SUM_MONITOR));
        
        figure(f1);
        subplot(3,1,1);
        plot(timevec,am.DD_SUM_MONITOR,'.-');
        hold on;
        plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR(ind-95:ind-10)) mean(am.DD_SUM_MONITOR(ind-95:ind-10))],'g');
        plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR(ind:ind+100)) mean(am.DD_SUM_MONITOR(ind:ind+100))],'r');
        plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR((end-5000):end)) mean(am.DD_SUM_MONITOR((end-5000):end))],'m');
        hold off;
        xaxis([timevec(ind)-0.0001 timevec(ind)+0.0002]);
        %   yaxis([0 1e8]);
        xlabel('t [s] (after pre extraction trigger)');
        ylabel('SUM signal (ADC counts)');
        title(BPMname);
        subplot(3,1,2);
        plot(timevec,am.DD_X_MONITOR/1e6,'.-');
        xlabel('t [s] (after pre extraction trigger)');
        ylabel('x [mm]');
        xaxis([timevec(ind)-0.0001 timevec(ind)+0.0002]);
        %    yaxis([-5 5]);
        subplot(3,1,3);
        plot(timevec,am.DD_Y_MONITOR/1e6,'.-')
        xlabel('t [s] (after pre extraction trigger)');
        ylabel('y [mm]');
        xaxis([timevec(ind)-0.0001 timevec(ind)+0.0002]);
        %    yaxis([-5 5]);
        
        figure(f2);
        subplot(3,1,1);
        plot(timevec,am.DD_SUM_MONITOR);
        hold on;
        plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR(ind-95:ind-10)) mean(am.DD_SUM_MONITOR(ind-95:ind-10))],'g');
        plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR(ind:ind+100)) mean(am.DD_SUM_MONITOR(ind:ind+100))],'r');
        plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR((end-5000):end)) mean(am.DD_SUM_MONITOR((end-5000):end))],'m');
        hold off;
        %    xaxis([0 0.005]);
        %    yaxis([0 1e8]);
        xlabel('t [s] (after pre extraction trigger)');
        ylabel('SUM signal (ADC counts)');
        title(BPMname);
        subplot(3,1,2);
        plot(timevec,am.DD_X_MONITOR/1e6);
        xlabel('t [s] (after pre extraction trigger)');
        ylabel('x [mm]');
        %    xaxis([0 0.005]);
        %    yaxis([-5 5]);
        subplot(3,1,3);
        plot(timevec,am.DD_Y_MONITOR/1e6)
        xlabel('t [s] (after pre extraction trigger)');
        ylabel('y [mm]');
        %    xaxis([0 0.005]);
        %    yaxis([-5 5]);
        
        pause(1);
        
        px=polyfit(3:215,am.DD_X_MONITOR(ind+3:ind+215),3);
        py=polyfit(3:715,am.DD_Y_MONITOR(ind+3:ind+715),3);
        nux=abs(calcnaff(am.DD_X_MONITOR(ind+6:ind+217)-polyval(px,6:217),am.DD_X_MONITOR(ind+5:ind+216)-polyval(px,5:216),1)/2/pi);

%         figure(3)
%         subplot(3,1,1)
%         plot(am.DD_Y_MONITOR(ind+6:ind+217)-polyval(py,6:217))
%         subplot(3,1,2)
%         plot(am.DD_Y_MONITOR(ind+5:ind+216)-polyval(py,5:216))
%         subplot(3,1,3)
%         plot((1:length(am.DD_Y_MONITOR(ind+6:ind+217)))/length(am.DD_Y_MONITOR(ind+6:ind+217)),abs(fft(am.DD_Y_MONITOR(ind+6:ind+217)-polyval(py,6:217))))

        nuy=abs(calcnaff(am.DD_Y_MONITOR(ind+6:ind+217)-polyval(py,6:217),am.DD_Y_MONITOR(ind+5:ind+216)-polyval(py,5:216),1)/2/pi);
        
        tmpnux=[];
        if length(nux)>=1
            for loop=1:length(nux)
                if (nux(loop)>0.1) && (nux(loop)<0.32)
                    tmpnux=nux(loop);
                    break;
                end
            end
        else
            nux=0;
        end
        if isempty(tmpnux)
            nux=0;
        else
            nux=tmpnux;
        end
        
        tmpnuy=[];
        if length(nuy)>=1
            for loop=1:length(nuy)
                if (nuy(loop)>0.17) && (nuy(loop)<0.3) && abs(nux-nuy(loop))>0.005 && (nux<nuy(loop))
                    tmpnuy=nuy(loop);
                    break;
                end
            end
        else
            nuy=0;
        end
        if isempty(tmpnuy)
            nuy=0;
        else
            nuy=tmpnuy;
        end
        
        try
            nux2=getpv('IGPF:TFBX:SRAM:PEAKFREQ2')/(getrf/328*1000);
            nuy2=getpv('IGPF:TFBY:SRAM:PEAKFREQ2')/(getrf/328*1000);
        catch
            nux2=0;nuy2=0;
        end
        
        if (nux == 0) & strcmp(getpvonline('SR_mode'),'1.9 GeV, Two-Bunch')
            [tmpnux,tmpnuy]=findfreq_tuneguess((am.DD_X_MONITOR(ind+6:ind+217)-polyval(px,6:217))',(am.DD_Y_MONITOR(ind+6:ind+217)-polyval(py,6:217))',0.165,0.25,0.04);
            if ~isnan(tmpnux) & (tmpnux>0.1) & (tmpnux<0.3)
                nux = tmpnux;
            end
        end
        
        if (nuy == 0) & strcmp(getpvonline('SR_mode'),'1.9 GeV, Two-Bunch')
            [tmpnux,tmpnuy]=findfreq_tuneguess((am.DD_X_MONITOR(ind+6:ind+217)-polyval(px,6:217))',(am.DD_Y_MONITOR(ind+6:ind+217)-polyval(py,6:217))',0.165,0.25,0.04);
            if ~isnan(tmpnuy) & (tmpnuy>0.1) & (tmpnuy<0.3)
                nuy = tmpnuy;
            end
        end
        
        fprintf('dI (DCCT) = %.2f mA, eff (DCCT/ICT) = %.2f; dI (libera/DCCT) = %g mA, capture ratio (libera) = %.2f\n', ...
            getpv('BTS_To_SR_Injection_Rate'), getpv('BTS_To_SR_Injection_Efficiency'), ...
            (mean(am.DD_SUM_MONITOR((end-5000):end))-mean(am.DD_SUM_MONITOR(ind-95:ind-10)))/mean(am.DD_SUM_MONITOR(ind-95:ind-10))*getdcct, ...
            (mean(am.DD_SUM_MONITOR((end-5000):end))-mean(am.DD_SUM_MONITOR(ind-95:ind-10)))/(mean(am.DD_SUM_MONITOR(ind:ind+100))-mean(am.DD_SUM_MONITOR(ind-95:ind-10))));
        fprintf('nux = %.4f (%.4f from TFB), nuy = %.4f (%.4f from TFB)\n', intx+nux,intx+nux2,9+nuy, 9+nuy2);
%            setpv('Physics5',intx+nux);
          setpv('Topoff_nux_AM',intx+nux);
%            setpv('Physics6',9+nuy);
          setpv('Topoff_nuy_AM',9+nuy);
        
    end
    
end
