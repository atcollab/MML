function cc
%CC - Compile NAFF functions
%


disp(['Compiling NAFF routines on ', computer,'.'])


% Object files
disp(['Compiling: modnaff.c']);

if ispc
    %mex -I/home/als/alsbase/matlab6/extern/include -O -c modnaff.c
    mex -O -c modnaff.c
    mex -O calcnaff.c modnaff.obj
else
    %mex -I/home/als/alsbase/matlab6/extern/include -O -c modnaff.c
    mex -I/home/als/alsbase/matlab72/extern/include -O -c modnaff.c
    
    
    disp(['Compiling: calcnaff.c']);
    cc_local('calcnaff.c modnaff.o');
end



function cc_local(fn)


disp(['Compiling: ',fn]);

cmdstr = [ 'mex -I/home/als/alsbase/matlab72/extern/include -O ', fn ];
disp(cmdstr);
eval(cmdstr);




