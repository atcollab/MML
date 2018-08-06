function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathndiamond(varargin)
%SETPATHDIAMOND - Initializes the Matlab Middle Layer (MML) for DIAMOND
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathdiamond(SubMachineName, OnlineLinkMethod)
%
%  INPUTS
%  1. SubMachineName
%  2. OnlineLinkMethod - 'MCA', 'LabCA', 'SCA'

%  Written by Greg Portmann


Machine = 'Diamond';


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
        LinkFlag = 'MCA';
    elseif isunix
        LinkFlag = 'MCA';
    else
        LinkFlag = 'MCA';
    end
end


% Get the submachine name
if length(varargin) >= 1
    SubMachineName = varargin{1};
else
    SubMachineName = '';
end

if isempty(SubMachineName)
    SubMachineNameCell = {'Storage Ring', 'Booster', 'LTB', 'BTS'};
    [i, ok] = listdlg('PromptString', 'Select an accelerator:',...
        'SelectionMode', 'Single',...
        'Name', 'DIAMOND', ...
        'ListString', SubMachineNameCell);
    if ok
        SubMachineName = SubMachineNameCell{i};
    else
        fprintf('Initialization cancelled (no path change).\n');
        return;
    end
end


if any(strcmpi(SubMachineName, {'SR', 'StorageRing', 'Storage Ring','Ring'}))
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'SR', 'StorageRing', LinkFlag);
elseif any(strcmpi(SubMachineName, {'BTS', 'BS'}))
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'BS', 'Transport',   LinkFlag);
elseif any(strcmpi(SubMachineName, {'BR', 'Booster', 'BoosterRing'}))
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'BR', 'Booster',     LinkFlag);
elseif any(strcmpi(SubMachineName, {'LTB', 'LB'}))
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'LB', 'Transport',   LinkFlag);
else
    printf('   %s is an unknown submachine name.\n', SubMachineName);
end


