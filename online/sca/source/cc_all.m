function cc_all


disp(['Compiling matlab-channel access link on ', computer,'.'])


if strncmp(computer,'PC',2)

    %disp(['Compiling: gpfunc.c']);
    %mex -c -IC:\Greg\matlab\links\sca\include\win-x86 C:\Greg\matlab\links\sca\lib\win32-x86\gpfunc.c
    %movefile('gpfunc.obj', 'C:\Greg\matlab\links\sca\lib\win32-x86\');

    % Main Database Calls
    %cc('scalink.c C:\Greg\matlab\links\sca\lib\win32-x86\gpfunc.obj');

    %mex -Iz:\include\controls\epics\r13 scalink.c N:\links\sca\bin\win32\gpfunc.obj z:\lib32\controls\epics\r13\release\sca3.lib

    %mex -IC:\Greg\matlab\links\sca\include\win-x86 scalink.c ...
    %    C:\Greg\matlab\links\sca\lib\win32-x86\gpfunc.obj C:\Greg\matlab\links\sca\lib\win32-x86\sca3.lib

    mex -In:\links\sca\include\win-x86 scalink.c ...
        n:\links\sca\lib\win32-x86\gpfunc.obj n:\links\sca\lib\win32-x86\sca3.lib

    % Andrei flags:  -DDB_TEXT_GLBLSOURCE -D_WIN32 -DEPICS_DLL_NO ...

elseif strncmp(computer, 'GLNX', 4)

    disp(['Compiling: gpfunc.c']);
    mex -c -I/home/als/physbase/links/sca/include/linux-x86 gpfunc.c
    movefile('gpfunc.o', '/home/als/physbase/links/sca/lib/linux-x86/');

    % Main Database Calls
    cc('scalink.c /home/als/physbase/links/sca/lib/linux-x86/gpfunc.o');

elseif strncmp(computer, 'SOL2', 4)

    disp(['Compiling: gpfunc.c']);
    mex -c -I/home/als/physbase/links/sca/include/solaris gpfunc.c
    movefile('gpfunc.o', '/home/als/physbase/links/sca/lib/solaris-sparc/');


    % Main Database Calls
    cc('scalink.c /home/als/physbase/links/sca/lib/solaris-sparc/gpfunc.o');

elseif strncmp(computer, 'SOL64', 5)

    disp(['Compiling: gpfunc.c']);
    mex -c -DSOL64 -I/home/als/physbase/links/sca/include/solaris gpfunc.c
    movefile('gpfunc.o', '/home/als/physbase/links/sca/lib/sol64/');


    % Main Database Calls
    cc('scalink.c /home/als/physbase/links/sca/lib/sol64/gpfunc.o');

else
    
    error('Unknown computer type');
    
end



function cc(fn)
% cc(filename)
%


disp(['Compiling: ',fn]);

if strncmp(computer,'PC',2)
    
%     cmdstr = [...
%         'mex', ...
%         ' -Iq:\Matlab_7\extern\include -Iz:\include\controls\epics\r13 -Iz:\include\controls\epics -Iz:\include\controls ', ...
%         ' z:\lib32\controls\epics\r13\release\sca3.lib ' , ...
%         fn];


%     cmdstr = [...
%         'mex', ...
%         ' -Iz:\include\controls\epics\r13 ', ...
%         fn, ...
%         ' z:\lib32\controls\epics\r13\release\sca3.lib '];

elseif strncmp(computer, 'GLNX', 4)

    cmdstr = [...
        'mex', ...
        ' -I/home/als/physbase/links/sca/include ', ...
        fn, ...
        ' -L/home/als/physbase/links/sca/lib/linux-x86', ...
        ' /home/als/physbase/links/sca/lib/linux-x86/libsca.so'];


elseif strncmp(computer, 'SOL2', 4)

    cmdstr = [...
        'mex', ...
        ' -I/home/als/physbase/links/sca/include ', ...
        fn, ...
        ' -L/home/als/physbase/links/sca/lib/solaris-sparc', ...
        ' /home/als/physbase/links/sca/lib/solaris-sparc/libsca.so'];

%     cmdstr = [...
%         'mex', ...
%         ' -I/home/als2/prod/scaIII/include ', ...
%         fn, ...
%         ' -L/home/als2/prod/scaIII/lib', ...
%         ' /home/als2/prod/scaIII/lib/libsca.so'];

elseif strncmp(computer, 'SOL64', 5)

    cmdstr = [...
        'mex', ...
        '  -DSOL64 -I/home/als/physbase/links/sca/include ', ...
        fn, ...
        ' -L/home/als/physbase/links/sca/lib/sol64', ...
        ' /home/als/physbase/links/sca/lib/sol64/libsca.so'];

else

    error('Unknown computer type');

end


disp(cmdstr);
eval(cmdstr);

