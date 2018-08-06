checkforao;

retry = 200;
fprintf('   Setting LabCA retry count to %i\n', retry);
lcaSetRetryCount(retry);

liberainit([3 5],0);
if strfind(getpvonline('SR_mode'),'Two-Bunch')>0
    setpv('LIBERA_0AB3:ENV:ENV_GAIN_SP',-33);
else    
    setpv('LIBERA_0AB3:ENV:ENV_GAIN_SP',-33);   % libera is now connected through splitter, i.e. smaller signal
    % setpv('LIBERA_0AB3:ENV:ENV_GAIN_SP',-27);
end
setpv('LIBERA_0AB3:ENV:ENV_AGC_SP',1);
setpv('LIBERA_0AB3:ENV:ENV_DSC_SP',2);
setpv('LIBERA_0AB3:ENV:ENV_SWITCHES_SP',255);
%
pause(0.1);
%
% setpvonline('LIBERA_0A7E:DD3:DD_REQUEST_CMD',1)
% % setpvonline('LIBERA_0A7E:DD3:DD_ON_NEXT_TRIG_CMD',1);
%
% datax=getpvonline('LIBERA_0A7E:DD3:DD_X_MONITOR','Waveform');
% datay=getpvonline('LIBERA_0A7E:DD3:DD_Y_MONITOR','Waveform');
% sum=getpvonline('LIBERA_0A7E:DD3:DD_SUM_MONITOR','Waveform');

f1=figure;
f2=figure;

while 1
    while (getpv('GTL_____TIMING_BC00')==0) || (getpv('SR01S___BUMP1__BC21')==0)
        pause(0.05);
    end

    [am,sp,name]=getlibera('DD3',[3 5],1);
    pause(1.45);
    
    if mean(getpv('QFA',[1 1])>530)
        intx=16;
    else
        intx=14;
    end
        
    timevec=654e-9*(1:length(am.DD_SUM_MONITOR));
    
    figure(f1);
    subplot(3,1,1);
    plot(timevec,am.DD_SUM_MONITOR);
    hold on;
    plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR(1:85)) mean(am.DD_SUM_MONITOR(1:85))],'g');
    plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR(90:200)) mean(am.DD_SUM_MONITOR(90:200))],'r');
    plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR((end-5000):end)) mean(am.DD_SUM_MONITOR((end-5000):end))],'m');
    hold off;
    xaxis([0 0.005]);   
%   yaxis([0 1e8]);
    xlabel('t [s] (after SEK trigger)');
    ylabel('SUM signal (ADC counts)');
    title(name);
    subplot(3,1,2);
    plot(timevec,am.DD_X_MONITOR/1e6);
    xlabel('t [s] (after SEK trigger)');
    ylabel('x [mm]');
    xaxis([0 0.005]);
%    yaxis([-5 5]);
    subplot(3,1,3);
    plot(timevec,am.DD_Y_MONITOR/1e6)
    xlabel('t [s] (after SEK trigger)');
    ylabel('y [mm]');
    xaxis([0 0.005]);
%    yaxis([-5 5]);

    figure(f2);
    subplot(3,1,1);
    plot(timevec,am.DD_SUM_MONITOR);
    hold on;
    plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR(1:85)) mean(am.DD_SUM_MONITOR(1:85))],'g');
    plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR(90:200)) mean(am.DD_SUM_MONITOR(90:200))],'r');
    plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR((end-5000):end)) mean(am.DD_SUM_MONITOR((end-5000):end))],'m');
    hold off;
%    xaxis([0 0.005]);   
%    yaxis([0 1e8]);
    xlabel('t [s] (after SEK trigger)');
    ylabel('SUM signal (ADC counts)');
    title(name);
    subplot(3,1,2);
    plot(timevec,am.DD_X_MONITOR/1e6);
    xlabel('t [s] (after SEK trigger)');
    ylabel('x [mm]');
%    xaxis([0 0.005]);
%    yaxis([-5 5]);
    subplot(3,1,3);
    plot(timevec,am.DD_Y_MONITOR/1e6)
    xlabel('t [s] (after SEK trigger)');
    ylabel('y [mm]');
%    xaxis([0 0.005]);
%    yaxis([-5 5]);

    pause(1);

    px=polyfit(88:300,am.DD_X_MONITOR(88:300),3);
    py=polyfit(88:800,am.DD_Y_MONITOR(88:800),3);
    nux=abs(calcnaff(am.DD_X_MONITOR(91:302)-polyval(px,91:302),am.DD_X_MONITOR(90:301)-polyval(px,90:301),1)/2/pi);
    nuy=abs(calcnaff(am.DD_Y_MONITOR(91:302)-polyval(py,91:302),am.DD_Y_MONITOR(90:301)-polyval(py,90:301),1)/2/pi);
    
    tmpnux=[];
    if length(nux)>=1
        for loop=1:length(nux)
            if (nux(loop)>0.1) & (nux(loop)<0.32)
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
            if (nuy(loop)>0.17) & (nuy(loop)<0.3) & abs(nux-nuy(loop))>0.005
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
    
    fprintf('dI (DCCT) = %.2f mA, eff (DCCT/ICT) = %.2f; dI (libera/DCCT) = %g mA, capture ratio (libera) = %.2f\n', ...
        getpv('BTS_To_SR_Injection_Rate'), getpv('BTS_To_SR_Injection_Efficiency'), ...
        (mean(am.DD_SUM_MONITOR((end-5000):end))-mean(am.DD_SUM_MONITOR(1:85)))/mean(am.DD_SUM_MONITOR(1:85))*getdcct, ...
        (mean(am.DD_SUM_MONITOR((end-5000):end))-mean(am.DD_SUM_MONITOR(1:85)))/(mean(am.DD_SUM_MONITOR(90:200))-mean(am.DD_SUM_MONITOR(1:85))));
    fprintf('nux = %.4f (%.4f from TFB), nuy = %.4f (%.4f from TFB)\n', intx+nux,intx+nux2,9+nuy, 9+nuy2);
%     setpv('Physics5',intx+nux);
    setpv('Topoff_nux_AM',intx+nux);
%     setpv('Physics6',9+nuy);
    setpv('Topoff_nuy_AM',9+nuy);
    
    pause(1);

end
