function plot_first_turns_newbpms(varargin)

checkforao;

f1=figure;

while 1
    while getpv('GTL_____TIMING_BC00')==0
        pause(0.05);
    end

    am=getnewbpms;
    
    timevec=654e-9*(1:length(am(1).DD_SUM_MONITOR));
    turnvec=(1:length(am(1).DD_SUM_MONITOR))-10750;
    
    figure(f1);
    subplot(3,1,1);
    plot(turnvec,cat(1,am.DD_SUM_MONITOR)');
    axis([0 100 0 1.2e6]);

    ind = find(am(1).DD_SUM_MONITOR<2e5);
    for loop=1:3
        am(loop).DD_X_MONITOR(ind)=NaN;
        am(loop).DD_Y_MONITOR(ind)=NaN;
    end

    subplot(3,1,2);
    plot(turnvec,cat(1,am.DD_X_MONITOR)'/1e6);
    axis([0 100 -10 10]);

    subplot(3,1,3);
    plot(turnvec,cat(1,am.DD_Y_MONITOR)'/1e6);
    axis([0 100 -10 10]);

    pause(0.2);

end

function am = getnewbpms(varargin)
    for loop = 1:12
        channame=sprintf('SR%02dC{BPM:8}TBT-S',loop);
        am(loop).DD_SUM_MONITOR=getpvonline(channame);
        channame=sprintf('SR%02dC{BPM:8}TBT-X',loop);
        am(loop).DD_X_MONITOR=getpvonline(channame);
        channame=sprintf('SR%02dC{BPM:8}TBT-Y',loop);
        am(loop).DD_Y_MONITOR=getpvonline(channame);
    end
return

