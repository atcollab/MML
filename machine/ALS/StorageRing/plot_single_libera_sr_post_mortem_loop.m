function plot_single_libera_sr_post_mortem_loop
% plot_single_libera_sr_post_mortem_loop
%
% Christoph Steier, 2010

checkforao;
gotodata;

shutter_status = getpv('sr:user_beam');
topoff_status = getpv('SRBeam_Beam_I_IntrlkA');
beam_current = getpv('cmm:beam_current');

setpvonline('LIBERA_0AB3:PM:PM_ON_NEXT_TRIG_CMD',1)
% setpvonline('LIBERA_0AAD:PM:PM_ON_NEXT_TRIG_CMD',1)
% setpvonline('LIBERA_0AAC:PM:PM_ON_NEXT_TRIG_CMD',1)
 
while 1
    pause(5);
    disp(['plot_libera_sr_post_mortem_loop: remains in armed state ', datestr(now)]);
%    if (shutter_status == 1) & (topoff_status == 1) & (beam_current > 17) ...
    if (beam_current > 17) ...
            &  (getpv('cmm:beam_current')<17)
        
%        data=getlibera('PM',[3 5;6 5;9 5]);
        data=getlibera('PM',[3 5]);
                
        figure(200);
        subplot(3,1,1);
        plot(cat(1,data.PM_SUM_MONITOR)');
        ylabel('Sum Data');
        title(datestr(now));
        subplot(3,1,2);
        plot(cat(1,data.PM_X_MONITOR)'/1e6);
        yaxis([-5 5]);
        ylabel('x [mm]');
        subplot(3,1,3)
        plot(cat(1,data.PM_Y_MONITOR)'/1e6)
        yaxis([-3 3])
        xlabel('turn #');
        ylabel('y [mm]');
                
        ind=min(find(data(1).PM_SUM_MONITOR<1e6));
%        ind2=min(find(data(2).PM_SUM_MONITOR<1e6));
%        ind3=min(find(data(3).PM_SUM_MONITOR<1e6));
        
%        ind=max([ind ind2 ind3]);
        
        if isempty(ind)
            ind=length(data(1).PM_SUM_MONITOR);
        end

        figure(201);
        subplot(3,1,1);
        plot(cat(1,data.PM_SUM_MONITOR)');
        xaxis([ind-1500 ind+500]);
        ylabel('Sum Data');
        title(datestr(now));
        subplot(3,1,2);
        plot(cat(1,data.PM_X_MONITOR)'/1e6);
        xaxis([ind-1500 ind+500]);
        yaxis([-5 5]);
        ylabel('x [mm]');
        subplot(3,1,3)
        plot(cat(1,data.PM_Y_MONITOR)'/1e6)
        yaxis([-3 3])
        xlabel('turn #');
        ylabel('y [mm]');
        xaxis([ind-1500 ind+500]);

        fftsum=abs(fft(data(1).PM_SUM_MONITOR(1:ind)-mean(data(1).PM_SUM_MONITOR(1:ind))));
        fftx=abs(fft(data(1).PM_X_MONITOR(1:ind)-mean(data(1).PM_X_MONITOR(1:ind))));
        ffty=abs(fft(data(1).PM_Y_MONITOR(1:ind)-mean(data(1).PM_Y_MONITOR(1:ind))));
        
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
        title(datestr(now));
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
        
        print(200,'-dpng',sprintf('libera_pm_fig200_%s',datestr(now,30)))
        print(201,'-dpng',sprintf('libera_pm_fig201_%s',datestr(now,30)))
        print(202,'-dpng',sprintf('libera_pm_fig202_%s',datestr(now,30)))


        filename=sprintf('libera_pm_data_%s',datestr(now,30));
        save(filename,'data');
        
        shutter_status = getpv('sr:user_beam');
        topoff_status = getpv('SRBeam_Beam_I_IntrlkA');
        beam_current = getpv('cmm:beam_current');

        setpvonline('LIBERA_0AB3:PM:PM_ON_NEXT_TRIG_CMD',1)
        % setpvonline('LIBERA_0AAD:PM:PM_ON_NEXT_TRIG_CMD',1)
        % setpvonline('LIBERA_0AAC:PM:PM_ON_NEXT_TRIG_CMD',1)

    else
        setpvonline('LIBERA_0AB3:PM:PM_ON_NEXT_TRIG_CMD',1)
        shutter_status = getpv('sr:user_beam');
        topoff_status = getpv('SRBeam_Beam_I_IntrlkA');
        beam_current = getpv('cmm:beam_current');
    end
end