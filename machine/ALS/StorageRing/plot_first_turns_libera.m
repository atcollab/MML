checkforao;
liberainit([3 5],0);

f1=figure;

while 1
    while getpv('GTL_____TIMING_BC00')==0
        pause(0.05);
    end

    if getdcct < 510 %  used to be 100, but now that libera is connected with splitter on same button as Bergoz, signal level is small
        setpv('LIBERA_0AB3:ENV:ENV_GAIN_SP',-33);
    elseif getdcct < 250
        setpv('LIBERA_0AB3:ENV:ENV_GAIN_SP',-30);
    else
        setpv('LIBERA_0AB3:ENV:ENV_GAIN_SP',-27);
    end

    [am,sp,name]=getlibera('DD3',[3 5],1);
    
    timevec=654e-9*(1:length(am.DD_SUM_MONITOR));
    
    figure(f1);
%    subplot(3,1,1);
    plot(timevec,am.DD_SUM_MONITOR);
    if max(am.DD_SUM_MONITOR) < 2e6
         yaxis([0 2e6]);
    else
        axis auto
    end

    xaxis([0 5e-4]);

%    ind = find(am.DD_SUM_MONITOR<2e5);
%    am.DD_X_MONITOR(ind)=NaN;
%    am.DD_Y_MONITOR(ind)=NaN;

%     subplot(3,1,2);
%     plot(am.DD_X_MONITOR/1e6);
%     axis([85 130 -10 10]);
% 
%     subplot(3,1,3);
%     plot(am.DD_Y_MONITOR/1e6);
%     axis([85 130 -10 10]);

    pause(0.2);

end



