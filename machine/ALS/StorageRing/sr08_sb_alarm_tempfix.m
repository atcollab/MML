disp('Resetting all SR08 Superbend alarms such that they work similar to other sectors with miscalibration');

for loop = 1:8
    if (loop == 1) || (loop == 5) || (loop == 3)
        delta = 10;
    elseif (loop == 3)
        delta = 0.4;
    else
        delta = 0.2;
    end
    channame = sprintf('SR08C___BSC_T%01d_AM0%01d',loop,loop-1);
    channamehi = sprintf('SR08C___BSC_T%01d_AM0%01d.HIGH',loop,loop-1);
    channamehihi = sprintf('SR08C___BSC_T%01d_AM0%01d.HIHI',loop,loop-1);
    channamelo = sprintf('SR08C___BSC_T%01d_AM0%01d.LOW',loop,loop-1);
    channamelolo = sprintf('SR08C___BSC_T%01d_AM0%01d.LOLO',loop,loop-1);
    
    setpv(channamehi,getpv(channame)+delta);
    setpv(channamehihi,getpv(channame)+2*delta);
    setpv(channamelo,getpv(channame)-delta);
    setpv(channamelolo,getpv(channame)-2*delta);
end
