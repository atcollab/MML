function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathals_booster(varargin)
%SETPATHALS_BOOSTER - Initializes the Matlab Middle Layer (MML) for ALS Booster 
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathals_booster(OnlineLinkMethod)
%
%  INPUTS
%  1. OnlineLinkMethod - 'MCA', 'LabCA', 'SCA'
% 
%  NOTES
%  1. To initialize the booster with a clean path:
%     run /home/als/physbase/machine/ALS/Booster/setpathals_booster;

%  Written by Greg Portmann


Machine = 'ALS';


% Add mmlroot to the path
pathstr = fileparts(which('setpathals_booster.m'));
i = findstr(pathstr, filesep);
addpath(fullfile(pathstr(1:i(end-2)), 'mml'), '-begin');


%%%%%%%%%%%%%%%%%
% Input Parsing %
%%%%%%%%%%%%%%%%%

% First strip-out the link method
LinkFlag = '';
for i = length(varargin):-1:1
    if ~ischar(varargin{i})
        % Ignor input
    elseif strcmpi(varargin{i},'LabCA')
        LinkFlag = 'LabCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'MCA')
        LinkFlag = 'MCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'SCA')
        LinkFlag = 'SCA';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'SLC')
        LinkFlag = 'SLC';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'Tango')
        LinkFlag = 'Tango';
        varargin(i) = [];
    elseif strcmpi(varargin{i},'UCODE')
        LinkFlag = 'UCODE';
        varargin(i) = [];
    end
end


MatlabVersion = ver('Matlab');
MatlabVersion = str2num(MatlabVersion.Version);

if isempty(LinkFlag)
    if strncmp(computer,'PC',2)
        LinkFlag = 'LABCA';
        %LinkFlag = 'MCA';
    elseif isunix
        if strncmp(computer,'GLNX',4) || MatlabVersion >= 7.4
            %LinkFlag = 'SCA';
            LinkFlag = 'LABCA';
        else
            LinkFlag = 'SCA';
            %LinkFlag = 'LABCA';
        end
    else
        LinkFlag = 'LABCA';
    end
end


% Get the submachine name
if length(varargin) >= 1
    SubMachineName = varargin{1};
else
    SubMachineName = 'Booster';
end

if isempty(SubMachineName)
    SubMachineNameCell = {'Storage Ring', 'Booster', 'LTB', 'BTS'};
    [i, ok] = listdlg('PromptString', 'Select an accelerator:',...
        'SelectionMode', 'Single',...
        'Name', 'ALS', ...
        'ListString', SubMachineNameCell);
    if ok
        SubMachineName = SubMachineNameCell{i};
    else
        fprintf('Initialization cancelled (no path change).\n');
        return;
    end
end

if any(strcmpi(SubMachineName, {'Storage Ring','Ring'}))
    SubMachineName = 'StorageRing';
end


if strcmpi(SubMachineName,'StorageRing')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);
elseif strcmpi(SubMachineName,'Booster')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'Booster',     'Booster',     LinkFlag);
elseif strcmpi(SubMachineName,'LTB')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'LTB',         'Transport',   LinkFlag);
elseif strcmpi(SubMachineName,'BTS')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'BTS',         'Transport',   LinkFlag);
end

