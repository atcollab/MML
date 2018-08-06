function gotocompile(SubMachine)


if nargin == 0
    SubMachine = getfamilydata('SubMachine');
    if strcmpi(SubMachine, 'StorageRing')
        fprintf('   Run cc_storagering to compile all the storage ring applications.\n');
    end
end


if strcmpi(SubMachine, 'StorageRing')
    SubMachineDir = 'SR';
elseif strcmpi(SubMachine, 'Booster')
    SubMachineDir = 'BR';
elseif strcmpi(SubMachine, 'BTS')
    SubMachineDir = 'BTS';
elseif strcmpi(SubMachine, 'GTB')
    SubMachineDir = 'GTB';
elseif strcmpi(SubMachine, 'Common')
    SubMachineDir = 'Common';
end


%if strcmpi(computer,'PCWIN')
%   %cd \\Als-filer\physbase\machine\ALS\StorageRing\compile\StandAlone
%   cd N:\machine\ALS\StorageRing\Compile\StandAlone
%end


ComputerString = lower(computer);
if strcmpi(ComputerString, 'pcwin')
    ComputerString = 'win32';
elseif strcmpi(ComputerString, 'pcwin64')
    ComputerString = 'win64';
end

% if isunix
%     DirString = fullfile(filesep, 'home', 'als', 'physbase', 'machine', 'ALS', 'Common', 'Compile', 'StandAloneRelease', ComputerString, SubMachineDir);
% else
%     DirString = fullfile('n:', 'machine', 'ALS', 'Common', 'Compile', 'StandAloneRelease', ComputerString, SubMachineDir);
% end
DirString = fullfile(getmmlroot, 'machine', 'ALS', 'Common', 'Compile', 'StandAloneRelease', ComputerString, SubMachineDir);
%cd(DirString);
[DirStringActual, ErrorFlag] = gotodirectory(DirString);

if ErrorFlag
    error('Could not cd to the proper directory.');
    fprintf('Compiling to %s \ninstead of the desired location\n%s\n', DirStringActual, DirString);
end
