function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathasp(varargin)
%SETPATHASP - Initializes the Matlab Middle Layer (MML) for ASP
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathasp(SubMachineName, OnlineLinkMethod)
%
%  INPUTS
%  1. SubMachineName - 'StorageRing', 'Booster', 'BTS', 'LTB', 'Injector'
%  2. OnlineLinkMethod - 'MCA', 'LabCA', 'SCA'

%  Written by Greg Portmann


Machine = 'ASP';


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

if isempty(LinkFlag)
    if strncmp(computer,'PC',2)
        LinkFlag = 'LabCA';
    elseif strncmp(computer,'GLNX86',6)
        LinkFlag = 'LabCA';
    elseif strncmp(computer,'GLNXA64',6)
        LinkFlag = 'LabCA';
    else
        LinkFlag = 'LabCA';
    end
end


% Get the submachine name
if length(varargin) >= 1
    SubMachineName = varargin{1};
else
    SubMachineName = '';
end

if isempty(SubMachineName)
    SubMachineNameCell = {'Storage Ring', 'Booster', 'LTB', 'BTS', 'Injector'};
    [i, ok] = listdlg('PromptString', 'Select an accelerator:',...
        'SelectionMode', 'Single',...
        'Name', 'ASP', ...
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
if any(strcmpi(SubMachineName, {'Booster Ring','BoosterRing'}))
    SubMachineName = 'BoosterRing';
end

if strcmpi(SubMachineName,'StorageRing')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);
elseif strcmpi(SubMachineName,'Booster')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'Booster',     'Booster',     LinkFlag);
elseif strcmpi(SubMachineName,'LTB')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'LTB',         'Transport',   LinkFlag);
elseif strcmpi(SubMachineName,'BTS')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'BTS',         'Transport',   LinkFlag);
elseif strcmpi(SubMachineName,'Injector')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'Injector',    'Booster',     LinkFlag);
end