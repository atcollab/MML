function gotocompile(SubMachine)


if nargin == 0
    SubMachine = getfamilydata('Gun');
    if strcmpi(SubMachine, 'Gun')
        fprintf('   Run cc_gun to compile all the gun applications.\n');
    end
end

if strcmpi(SubMachine, 'Gun')
    SubMachineDir = 'gun';
else
    SubMachineDir = lower(SubMachine);
end


ComputerString = lower(computer);
if strcmpi(ComputerString, 'pcwin')
    ComputerString = 'win32';
elseif strcmpi(ComputerString, 'pcwin64')
    ComputerString = 'win64';
end

% if isunix
%     DirString = ['/remote/apex/hlc/matlab/standalone/release/', ComputerString, '/', SubMachineDir);
% elseif ispc
%     error('Compiling on PC not setup.');
%     %DirString = '\\als-filer\...';
% end

DirString = fullfile(getmmlroot, 'standalone', 'release', ComputerString, SubMachineDir);

%cd(DirString);
[DirStringActual, ErrorFlag] = gotodirectory(DirString);

if ErrorFlag
    error('Could not cd to the proper directory.');
    %fprintf('Compiling to %s \ninstead of the desired location\n%s\n', DirStringActual, DirString);
end


