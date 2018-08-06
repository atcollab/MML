%ATMEXALL builds all AT platform deendent mex-files from C-sources
% On UNIX platform, the GNU gcc compiler must be installed and properly configured.
% On Windows, Microsoft Visual C++ is required (Oct. 2009 compile used 2008 Express)


StartDir = pwd;
ATROOT = atroot;
disp(['ATROOT Directory: ',ATROOT]);


% Navigate to the directory that contains pass-methods 
cd(ATROOT)
cd simulator
cd element
PASSMETHODDIR = pwd;
disp(['Current directory: ',PASSMETHODDIR]);
mexpassmethod('all');


% Navigate to the directory that contains tracking functions
cd(ATROOT)
cd simulator
cd track
disp(['Current directory:', pwd]);
switch computer
    case 'GLNXA64'
        MEXCOMMAND = 'mex -DGLNXA64 atpass.c -ldl';
    case 'GLNX86'
        MEXCOMMAND = 'mex -DGLNX86 atpass.c';
    case 'PCWIN64'
        % The 32-bit switch seems to work fine
        MEXCOMMAND = ['mex -DPCWIN atpass.c'];
	case 'MAXI64'
		% EW EW
		MEXCOMMAND = 'mex -DMAXI64 atpass.c';
    otherwise
        MEXCOMMAND = ['mex -D',computer,' atpass.c'];
end
disp(MEXCOMMAND);
eval(MEXCOMMAND);


% Navigate to the directory that contains some accelerator physics functions
cd(ATROOT)
cd atphysics
disp(['Current directory:', pwd]);

% findmpoleraddiffmatrix.c
disp('mex findmpoleraddiffmatrix.c')
eval(['mex findmpoleraddiffmatrix.c -I''',PASSMETHODDIR,'''']);


% User passmethods
cd(ATROOT)
cd simulator
cd element
cd user
disp(['Current directory: ', pwd]);
mexuserpassmethod('all');


% Xiaobiao's Bend function
cd(ATROOT)
cd simulator
cd element
cd bend
cd BndE2
disp(['Current directory: ', pwd]);
mexBndMPoleSymplectic4E2Pass;

cd ..
cd BndE2Rad
disp(['Current directory: ', pwd]);
mexBndMPoleSymplectic4E2RadPass;



disp('ALL mex-files created successfully')
clear ATROOT PASSMETHODDIR WARNMSG PLATFORMOPTION MEXCOMMAND

cd(StartDir);


