function FOFBmonitor

setpv('Physics1',0);
setpv('Physics1.HIGH',1);
setpv('Physics1.HIHI',1);
setpv('Physics1.HSV','MINOR');
setpv('Physics1.HHSV','MAJOR');

while 1
    if getpv('SR01____FFBON__BM00')==0 && getpv('SR01____FFBON__BC00')==1
        pause(1)
        if getpv('SR01____FFBON__BM00')==0 && getpv('SR01____FFBON__BC00')==1
            soundtada
            disp('***Fast Orbit Feedback has tripped off!');
            setpv('Physics1',1);
        end
    else
        a = clock; datestr1 = date;
        fprintf('FOFB is not tripped off as of %d:%d:%.0f %s\n', a(4), a(5), a(6), datestr1);
        setpv('Physics1',0);
    end
    pause(10)
end
