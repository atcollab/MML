% check_bend_current_loop
%
% Routine used for topoff testing to find the peak current of the booster bend magnet

checkforao;
gotodata;
cd BR_supply_trips

f1=figure;
f2=figure;

[b,a]=butter(2,0.005);

while 1
    % bendI=get_dpsc_current_waveforms_cond;
    bendI=get_dpsc_current_waveforms;
    
    figure(f1);
    subplot(2,1,1);
    plot(bendI.Timevec,bendI.Data);
    xlabel('t [s]');
    ylabel('I [A]');
    legend('Bend','QF','QD');
    subplot(2,1,2);
    plot(bendI.Timevec,bendI.Data);
    xlabel('t [s]');
    ylabel('I [A]');
    axis([0.475 0.5 ceil(max(bendI.Data(:,1)))-8 ceil(max(bendI.Data(:,1)))+2]);

    diff_filt = filter(b,a,diff(bendI.Data(:,1)));
    
    if (min(diff_filt)<(-0.05)) | (max(diff_filt)>(0.03))
        print(f1,'-dpng',sprintf('booster_bend_waveforms_%s',datestr(now,30)))        
    end
    
    fprintf('peak current of booster bend magnet is %.1f A\n',max(bendI.Data(:,1)));
    
    legendstr=sprintf('max(I_{Bend}) = %.1f A',max(bendI.Data(:,1)));
    legend(legendstr,'Location','Best');
    
    
    sizedat=size(bendI.Data);
    numspecs=floor(sizedat(1)/2048);
    [x,y]=meshgrid(bendI.Timevec(1:2048:end),(0:1/2047:1)./bendI.TimeStep);
    datax2=reshape(bendI.Data(1:2048*numspecs,1),2048,numspecs);
    figure(f2);
    fftx=abs(fft(detrend(datax2)));
    mesh(x,y,log(1+fftx));
    fprintf('total 2 kHz ripple = %g, 4 kHz ripple = %g\n',sum(fftx(43,:)),sum(fftx(85,:)));
    setpvonline('Physics5',sum(fftx(43,:)));
    setpvonline('Physics6',sum(fftx(85,:)));
    view(2);
    axis([0 max(max(x)) 0 max(max(y))/2]);
    %        caxis([14 18]);
    title('Power Supply Spectrum');
    xlabel('t [s]');
    ylabel('f [Hz]');
    
    pause(1.4);
end
