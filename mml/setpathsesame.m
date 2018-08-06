function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathsesame(varargin)
%SETPATHSESAME - Initializes the Matlab Middle Layer (MML) for the Jordan light source (SESAME)
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathals(SubMachineName, OnlineLinkMethod)
%
%  INPUTS
%  1. SubMachineName - 'StorageRing', 'Booster', 'BTS', 'GTB'
%  2. OnlineLinkMethod - 'MCA', 'LabCA' {Default}, 'SCA'

%  Written by Greg Portmann


Machine = 'SESAME';


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
    end
end

if isempty(LinkFlag)
    LinkFlag = 'LABCA';
end


% Get the submachine name
if length(varargin) >= 1
    SubMachineName = varargin{1};
else
    %SubMachineName = 'StorageRing';
    SubMachineName = '';
end


if isempty(SubMachineName)
    %SubMachineNameCell = {'Storage Ring', 'Booster-to-Storage Ring (BTS)', 'Booster', 'Gun-to-Booster (GTB)'};
    SubMachineNameCell = {'Storage Ring', 'Booster'};
    [i, ok] = listdlg('PromptString', 'Select an accelerator:',...
        'SelectionMode', 'Single',...
        'Name', 'SESAME', ...
        'ListString', SubMachineNameCell, ...
        'ListSize', [195 100]);
    drawnow;
    if ok
        SubMachineName = SubMachineNameCell{i};
    else
        fprintf('Initialization cancelled (no path change).\n');
        return;
    end
end


% Name changes
if any(strcmpi(SubMachineName, {'Storage Ring','Ring','SR'}))
    SubMachineName = 'StorageRing';
end

if any(strcmpi(SubMachineName, {'Booster Ring','BR'}))
    SubMachineName = 'Booster';
end

if any(strcmpi(SubMachineName, {'Gun-to-Booster (GTB)','Gun-to-Booster'}))
    SubMachineName = 'GTB';
end

if any(strcmpi(SubMachineName, {'Booster-to-Storage Ring (BTS)','Booster-to-Storage Ring'}))
    SubMachineName = 'BTS';
end


if strcmpi(SubMachineName, 'StorageRing')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);
elseif strcmpi(SubMachineName, 'Booster')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'Booster',     'Booster',     LinkFlag);
elseif strcmpi(SubMachineName, 'GTB')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'GTB',         'Transport',   LinkFlag);
elseif strcmpi(SubMachineName, 'BTS')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'BTS',         'Transport',   LinkFlag);
end

