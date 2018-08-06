

t0 = gettime;
while 1
    fprintf('   Correcting the orbit at %s \n', datestr(clock));
    orbcorh(1e-4, 1, [10 4;12 5], 'NoDisplay');
    pause(2);
    orbcorv(1e-4, 1, [10 4;12 5], 'NoDisplay');
    pause(2);
    
    DCCT = getdcct;    
    if DCCT < 10
        sound(cos(1:10000));
        fprintf('\n\n   Current to low.  Refill and hit return (Ctrl-C to stop).\n');
        pause;
        fprintf(' \n');
    end
    
    plotorbit;
end
