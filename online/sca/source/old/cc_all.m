function cc_all

disp(['Compiling matlab-channel access link on ', computer,'.'])


% Object files
% disp(['Compiling: mexfunc.c']);
% mex -I/home/als/alsbase/matlab7/extern/include -c mexfunc.c


if strncmp(computer,'PC',2)

    disp(['Compiling: gpfunc.c']);
    mex -I/home/als/alsbase/matlab7/extern/include -c gpfunc.c

    % Main Database Calls
    cc('scaget.c N:\matlab2004\acceleratorlink\sca\bin\win32-x86\gpfunc.o');

elseif strncmp(computer, 'GLNX', 4)

    if 1
        disp(['Compiling: gpfunc.c']);
        mex -I/home/als/alsbase/matlab7/extern/include -c gpfunc.c

        % Main Database Calls
        cc('scaget.c gpfunc.o');
    else
        % Main Database Calls
        cc('scaget.c /home/als/physbase/matlab2004/acceleratorlink/sca/bin/linux-x86/gpfunc.o');
    end

elseif strncmp(computer, 'SOL', 3)

    %disp(['Compiling: gpfunc.c']);
    %mex -I/home/als/alsbase/matlab/extern/include -c gpfunc.c
    

    % Main Database Calls
    cc('scaget.c /home/als/physbase/matlab2004/acceleratorlink/sca/bin/solaris-sparc-gnu/gpfunc.o');
    
else
    
    error('Unknown computer type');
    
end





% cc('scagetstring.c mexfunc.o');
% cc('scaputstring.c mexfunc.o');
% cc('sca_sleep.c mexfunc.o');


