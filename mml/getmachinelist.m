function [MachineList, SubMachineList] = getmachinelist(varargin)
%GETMACHINELIST - Returns a cell array list of accelerators available to the Matlab MiddleLayer (MML)
%  [MachineList, SubMachineList] = getmachinelist

%  Written by Greg Portmann


% Collect all sub-directories of machine
MMLROOT = [getmmlroot('IgnoreTheAD'), 'machine'];
DirStart = pwd;
cd(MMLROOT)
DirStruct = dir;
MachineList = {};
N = 0;
for i = 3:length(DirStruct)
    if DirStruct(i).isdir
        N = N + 1;
        MachineList{N,1} = DirStruct(i).name;
    end
end


% Find the submachines
SubMachineList = {};
for i = 1:length(MachineList)
    cd(MachineList{i});
    DirStruct = dir;
    k = 0;
    for j = 3:length(DirStruct)
        % Don't add names that are not submachines.  It's a moving target -- not a great way to do it.
        if ~DirStruct(j).isdir
        elseif length(DirStruct(j).name) >=  7 && strcmpi(DirStruct(j).name(end-6:end),  'OpsData')
        elseif length(DirStruct(j).name) >=  4 && strcmpi(DirStruct(j).name(end-3:end),  'Data')
        elseif strcmpi(DirStruct(j).name, 'Application')
        elseif strcmpi(DirStruct(j).name, 'Applications')
        elseif length(DirStruct(j).name)>= 6 && strcmpi(DirStruct(j).name(1:6), 'common')
        elseif strcmpi(DirStruct(j).name, 'doc_html')
        elseif strcmpi(DirStruct(j).name, 'docs')
        elseif strcmpi(DirStruct(j).name, 'doc')
        elseif strcmpi(DirStruct(j).name, 'Sussix')
        elseif strcmpi(DirStruct(j).name, 'AT_Modified')
        elseif strcmpi(DirStruct(j).name, 'CVS')
        elseif strcmpi(DirStruct(j).name, 'old')
        elseif strcmpi(DirStruct(j).name, 'rip')
        else
            k = k + 1;
            SubMachineList{i}{k} = DirStruct(j).name;
        end
    end
    cd ..
end


% Remove machines that do not have a SubMachine list
for i = length(MachineList):-1:1
    if isempty(SubMachineList{i})
        MachineList(i) = [];
        SubMachineList(i) = [];
    end
end


% Return to the starting directory
cd(DirStart);

