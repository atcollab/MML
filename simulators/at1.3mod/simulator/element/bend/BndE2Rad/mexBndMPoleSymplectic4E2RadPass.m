function mexBndMPoleSymplectic4E2RadPass(varargin)
%mexBndMPoleSymplectic4E2RadPass builds pass-method mex-files from C files
%

disp('Compiling atlalib.c and atphyslib.c');
mex -c atlalib.c
mex -c atphyslib.c


PLATFORMOPTION = ['-D',computer,' '];

% Additional platform-specific options for mex
% Note: atroot is function
switch computer
    case 'SOL2'
        PLATFORMOPTION = [PLATFORMOPTION,'LDFLAGS=''-shared -W1,-M,',atroot,'/simulator/element/mexFunctionSOL2.map''',' '];
        MEXSTRING = ['mex ',PLATFORMOPTION, 'BndMPoleSymplectic4E2RadPass.c atlalib.o atphyslib.o'];
    case 'SOL64'
        % Just take the defaults, with the shared library flag
       %PLATFORMOPTION = [PLATFORMOPTION,'LDFLAGS=''-G'' '];
        PLATFORMOPTION = [PLATFORMOPTION,'LDFLAGS=''-G -m64'' '];  %  -xarch=sparvis
        MEXSTRING = ['mex ',PLATFORMOPTION, 'BndMPoleSymplectic4E2RadPass.c atlalib.o atphyslib.o'];
    case 'GLNX86'
        PLATFORMOPTION = [PLATFORMOPTION,'LDFLAGS=''-pthread -shared -m32 -Wl,--version-script,',atroot,'/simulator/element/mexFunctionGLNX86.map''',' '];
        MEXSTRING = ['mex ',PLATFORMOPTION, 'BndMPoleSymplectic4E2RadPass.c atlalib.o atphyslib.o'];
    case 'GLNXA64'
        PLATFORMOPTION = [PLATFORMOPTION,'LDFLAGS=''-pthread -shared -m64 -Wl,--version-script,',atroot,'/simulator/element/user/mexFunctionGLNXA64.map''',' '];
        MEXSTRING = ['mex ',PLATFORMOPTION, 'BndMPoleSymplectic4E2RadPass.c atlalib.o atphyslib.o'];
	case 'MACI64'
		PLATFORMOPTION = [PLATFORMOPTION,'LDFLAGS=''-pthread -shared -m64 -Wl,--version-script,',atroot,'/simulator/element/mexFunctionMACI64.map''',' '];   
		MEXSTRING = ['mex ',PLATFORMOPTION, 'BndMPoleSymplectic4E2RadPass.c atlalib.o atphyslib.o'];
    otherwise
        if ispc
            MEXSTRING = ['mex ',PLATFORMOPTION, 'BndMPoleSymplectic4E2RadPass.c atlalib.obj atphyslib.obj'];
        else
            error('Compile not setup for this computer type');
        end
end

disp(MEXSTRING);
evalin('base',MEXSTRING);


% switch computer
%     case 'GLNX86'
%         mex -ldl -DGLNX86  BndMPoleSymplectic4E2RadPass.c atlalib.o atphyslib.o
%     case 'GLNXA64'
%         mex -ldl -DGLNXA64  BndMPoleSymplectic4E2RadPass.c atlalib.o atphyslib.o
%     otherwise
%         mex -l atlalib.obj atphyslib.obj BndMPoleSymplectic4E2RadPass.c
% end


% Copy to a directory in the AT path
%copyfile(['BndMPoleSymplectic4E2RadPass.',mexext],['..\..\BndMPoleSymplectic4E2RadPass.',mexext],'f');


