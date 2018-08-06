checkforao;
liberainit([3 5],0);
liberainit([6 5],0);
liberainit([9 5],0);

f1=figure;

while 1
    while getpv('GTL_____TIMING_BC00')==0
        pause(0.05);
    end

    [am,sp,name]=getlibera('DD3',[3 5;6 5;9 5],1);
    
    timevec=654e-9*(1:length(am(1).DD_SUM_MONITOR));
    
    figure(f1);
    subplot(3,1,1);
    plot(cat(1,am.DD_SUM_MONITOR)');
    axis([85 130 0 1.2e6]);

    ind = find(am(1).DD_SUM_MONITOR<2e5);
    for loop=1:3
        am(loop).DD_X_MONITOR(ind)=NaN;
        am(loop).DD_Y_MONITOR(ind)=NaN;
    end

    subplot(3,1,2);
    plot(cat(1,am.DD_X_MONITOR)'/1e6);
    axis([85 130 -10 10]);

    subplot(3,1,3);
    plot(cat(1,am.DD_Y_MONITOR)'/1e6);
    axis([85 130 -10 10]);

    pause(0.2);

end



