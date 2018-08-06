checkforao;

liberainit([3 5],0);
setpv('LIBERA_0AB3:ENV:ENV_GAIN_SP',-33);
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
    while getpv('GTL_____TIMING_BC00')==0
        pause(0.05);
    end

    [am,sp,name]=getlibera('DD3',[3 5],1);
    pause(1.45);
    
    timevec=654e-9*(1:length(am.DD_SUM_MONITOR));
    
    figure(f1);
    subplot(3,1,1);
    plot(timevec,am.DD_SUM_MONITOR);
    hold on;
    plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR(1:85)) mean(am.DD_SUM_MONITOR(1:85))],'g');
    plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR(90:260)) mean(am.DD_SUM_MONITOR(90:260))],'r');
    plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR((end-5000):end)) mean(am.DD_SUM_MONITOR((end-5000):end))],'m');
    hold off;
    xaxis([0 0.001]);   
%    yaxis([0 1e8]);
    xlabel('t [s] (after SEK trigger)');
    ylabel('SUM signal (ADC counts)');
    title(name);
    subplot(3,1,2);
    plot(timevec,am.DD_X_MONITOR/1e6);
    xlabel('t [s] (after SEK trigger)');
    ylabel('x [mm]');
    xaxis([0 0.001]);
%    yaxis([-5 5]);
    subplot(3,1,3);
    plot(timevec,am.DD_Y_MONITOR/1e6)
    xlabel('t [s] (after SEK trigger)');
    ylabel('y [mm]');
    xaxis([0 0.001]);
%    yaxis([-5 5]);

    figure(f2);
    subplot(3,1,1);
    plot(timevec,am.DD_SUM_MONITOR);
    hold on;
    plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR(1:85)) mean(am.DD_SUM_MONITOR(1:85))],'g');
    plot([min(timevec) max(timevec)],[mean(am.DD_SUM_MONITOR(90:260)) mean(am.DD_SUM_MONITOR(90:260))],'r');
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

    nux=abs(calcnaff(am.DD_X_MONITOR(100:400)-mean(am.DD_X_MONITOR(100:400)),am.DD_X_MONITOR(100:400)-mean(am.DD_X_MONITOR(100:400)),1)/2/pi);
    nuy=abs(calcnaff(am.DD_Y_MONITOR(100:400)-mean(am.DD_Y_MONITOR(100:400)),am.DD_Y_MONITOR(100:400)-mean(am.DD_Y_MONITOR(100:400)),1)/2/pi);
    
    tmpnux=[];
    if length(nux)>1
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
    if length(nuy)>1
        for loop=1:length(nuy)
            if (nuy(loop)>0.18) & (nuy(loop)<0.22)
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

    fprintf('dI (DCCT) = %.2f mA, eff (DCCT/ICT) = %.2f; dI (libera/DCCT) = %g mA, capture ratio (libera) = %.2f\n', ...
        getpv('BTS_To_SR_Injection_Rate'), getpv('BTS_To_SR_Injection_Efficiency'), ...
        (mean(am.DD_SUM_MONITOR((end-5000):end))-mean(am.DD_SUM_MONITOR(1:85)))/mean(am.DD_SUM_MONITOR(1:85))*getdcct, ...
        (mean(am.DD_SUM_MONITOR((end-5000):end))-mean(am.DD_SUM_MONITOR(1:85)))/(mean(am.DD_SUM_MONITOR(90:260))-mean(am.DD_SUM_MONITOR(1:85))));
    fprintf('nux = %.4f, nuy = %.4f\n', 14+nux,9+nuy);
    setpv('Physics5',14+nux);
    setpv('Physics6',9+nuy);
    
    pause(1);

end
