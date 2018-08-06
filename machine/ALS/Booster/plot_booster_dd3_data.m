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

checkforao

f1=figure;
f2=figure;
f3=figure;
f4=figure;
f5=figure;

while 1
%     while getpv('GTL_____TIMING_BC00')==0
%         pause(0.05);
%     end

%     err=(-1);
%     while (err<0)
%         [count,time,err]=synctoevt(16);
%     end

    % another attempt to sync to an imminent shot of the new timing system
    TimInjReqStart = getpvonline('TimInjReq');
    Startnum = TimInjReqStart(7);
    Currentnum = Startnum;

    while (Currentnum == Startnum) || (TimInjReqCurrent(3)<20)
        TimInjReqCurrent = getpvonline('TimInjReq');
        Currentnum = TimInjReqCurrent(7);
        pause(0.1);
    end

    [am,sp,name]=getlibera('DD3',[1 1],1);

    timevec=250e-9*(1:length(am.DD_SUM_MONITOR));
    ind = find(am.DD_SUM_MONITOR>3e5);

    if length(ind)>0 & (length(ind)<length(am.DD_X_MONITOR))
        am.DD_X_MONITOR(1:(ind(1)))=NaN;
        am.DD_Y_MONITOR(1:(ind(1)))=NaN;
    end
    
    figure(f1);
    subplot(3,1,1);
    plot(timevec,am.DD_SUM_MONITOR);
    yaxis([0 1e8]);
    xlabel('t [s] (after booster BPM diag trigger)');
    ylabel('SUM signal (ADC counts)');
    title(name);
    subplot(3,1,2);
    plot(timevec,am.DD_X_MONITOR/0.6e6);
    xlabel('t [s] (after booster BPM diag trigger)');
    ylabel('x [mm]');
    yaxis([-10 10]);
    subplot(3,1,3);
    plot(timevec,am.DD_Y_MONITOR/0.6e6)
    xlabel('t [s] (after booster BPM diag trigger)');
    ylabel('y [mm]');
    yaxis([-5 5]);
    addlabel(am.DD_FINISHED_MONITOR_TIMESTAMP);

    if length(ind)>0
        figure(f5);
        subplot(3,1,1);
        plot(timevec((ind(1)-5):(ind(1)+1000)),am.DD_SUM_MONITOR((ind(1)-5):(ind(1)+1000)));
        axis tight;
        yaxis([0 1e8]);
        xlabel('t [s] (after booster BPM diag trigger)');
        ylabel('SUM signal (ADC counts)');
        title(name);
        subplot(3,1,2);
        plot(timevec((ind(1)-5):(ind(1)+1000)),am.DD_X_MONITOR((ind(1)-5):(ind(1)+1000))/0.6e6);
        xlabel('t [s] (after booster BPM diag trigger)');
        ylabel('x [mm]');
        axis tight;
        yaxis([-10 10]);
        subplot(3,1,3);
        plot(timevec((ind(1)-5):(ind(1)+1000)),am.DD_Y_MONITOR((ind(1)-5):(ind(1)+1000))/0.6e6)
        xlabel('t [s] (after booster BPM diag trigger)');
        ylabel('y [mm]');
        axis tight;
        yaxis([-5 5]);
        addlabel(am.DD_FINISHED_MONITOR_TIMESTAMP);
        
        
        ind(1)=[];
    end
    
    if length(ind)>10
        
        fftsum=abs(fft(am.DD_SUM_MONITOR(ind)-mean(am.DD_SUM_MONITOR(ind))));
        fftx=abs(fft(am.DD_X_MONITOR(ind)-mean(am.DD_X_MONITOR(ind))));
        ffty=abs(fft(am.DD_Y_MONITOR(ind)-mean(am.DD_Y_MONITOR(ind))));
        
        nuvec=(1:length(ind))/length(ind);
        
        figure(f2);
        subplot(3,1,1);
        semilogy(nuvec,fftsum);
        axis([0 0.5 1e5 1e10]);
        xlabel('frac tune');
        ylabel('fft(SUM signal)');
        title(name);
        subplot(3,1,2);
        semilogy(nuvec,fftx);
        axis([0 0.5 1e5 1e10]);
        xlabel('frac tune');
        ylabel('fft(x)');
        subplot(3,1,3);
        semilogy(nuvec,ffty);
        axis([0 0.5 1e5 1e10]);
        xlabel('frac tune');
        ylabel('fft(y)');
    end
    if length(ind)>2048
        
        sizedat=size(am.DD_X_MONITOR(ind));
        numspecs=floor(sizedat(2)/1024);
        [x,y]=meshgrid(timevec(min(ind))+(0:1024*250e-9:(numspecs-1)*1024*250e-9),0:1/1023:1);
        datax2=reshape(am.DD_X_MONITOR(ind(1:1024*numspecs)),1024,numspecs);
        figure(f3);
        mesh(x,y,log(1+abs(fft(datax2-ones(1024,1)*mean(datax2)))));
        view(2);
        axis([0 max(max(x)) 0 1]);
        caxis([14 18]);
        title('Horizontal beam spectrum');
        xlabel('t [s]');
        ylabel('\nu_x');
        
        sizedat=size(am.DD_Y_MONITOR(ind));
        numspecs=floor(sizedat(2)/1024);
        [x,y]=meshgrid(timevec(min(ind))+(0:1024*250e-9:(numspecs-1)*1024*250e-9),0:1/1023:1);
        datay2=reshape(am.DD_Y_MONITOR(ind(1:1024*numspecs)),1024,numspecs);
        figure(f4);
        mesh(x,y,log(1+abs(fft(datay2-ones(1024,1)*mean(datay2)))));
        view(2);
        axis([0 max(max(x)) 0 1]);
        caxis([14 18]);
        title('Vertical beam spectrum');
        xlabel('t [s]');
        ylabel('\nu_y');
        
        % %        dummy=calcnaff(zeros(600,1),zeros(600,1),1);
        %         nuxvec=abs(calcnaff(am.DD_X_MONITOR(500:800)-mean(am.DD_X_MONITOR(500:800)),am.DD_X_MONITOR(500:800)-mean(am.DD_X_MONITOR(500:800)),1)/2/pi);
        % %        dummy=calcnaff(zeros(600,1),zeros(600,1),1);
        %         nuyvec=abs(calcnaff(am.DD_Y_MONITOR(500:800)-mean(am.DD_Y_MONITOR(500:800)),am.DD_Y_MONITOR(500:800)-mean(am.DD_Y_MONITOR(500:800)),1)/2/pi);
        %
        %         nux=0;nuy=0;
        %
        %         if length(nuxvec)>1
        %             for loop=1:length(nuxvec)
        %                 if (nuxvec(loop)>0.06) & (nuxvec(loop)<0.44)
        %                     nux=nuxvec(loop);
        %                     break;
        %                 end
        %             end
        %         else
        %             nux=nuxvec;
        %         end
        %
        %         if length(nuyvec)>1
        %             for loop=1:length(nuyvec)
        %                 if (nuyvec(loop)>0.06) & (nuyvec(loop)<0.44)
        %                     nuy=nuyvec(loop);
        %                     break;
        %                 end
        %             end
        %         else
        %             nuy=nuyvec;
        %         end
        %
        %         if isnan(nux)
        %             nux=0;
        %         end
        %         if isnan(nuy)
        %             nuy=0;
        %         end
        
        [nux,nuy]=findfreq((am.DD_X_MONITOR(ind(1:1024))-mean(am.DD_X_MONITOR(ind(1:1024))))',(am.DD_Y_MONITOR(ind(1:1024))-mean(am.DD_Y_MONITOR(ind(1:1024))))');
        if isempty(nux) || isnan(nux)
            nux=0;
        end
        if isempty(nuy) || isnan(nuy)
            nuy=0;
        end

        [maxv,maxind]=max(am.DD_SUM_MONITOR);
        
        le=length(am.DD_SUM_MONITOR);le3=round(le/3);le2=round(le/2);
        
        fprintf('capture ratio (libera) = %.2f (%.2f)\n', ...
            mean(am.DD_SUM_MONITOR(le3:le2))/maxv,mean(am.DD_SUM_MONITOR(le3:le2))/mean(am.DD_SUM_MONITOR(maxind:maxind+5)));
        fprintf('nux = %.4f, nuy = %.4f\n', 6-nux,4-nuy);
        try
            setpv('Physics7',6-nux);
            setpv('Physics8',4-nuy);
        catch
            warning('Problem writing tune values to soft PVs - Physics7, Physics8 on beam soft IOC');
        end
        
    end

    pause(2);

end
