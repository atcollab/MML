function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathelettra(varargin)
%SETPATHELETTRA - Initializes the Matlab Middle Layer (MML) for Elettra
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathelettra(SubMachineName, OnlineLinkMethod)
%
%  INPUTS
%  1. SubMachineName - 'StorageRing', 'Booster', 'BTS', 'PTB'
%  2. OnlineLinkMethod - 'Tango'

%  Written by Greg Portmann


Machine = 'Elettra';


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
MatlabVersion = str2num(MatlabVersion(1).Version);

if isempty(LinkFlag)
    LinkFlag = 'Tango';
end


% Get the submachine name
if length(varargin) >= 1
    SubMachineName = varargin{1};
else
    %SubMachineName = 'StorageRing';
    %SubMachineName = 'PTB';
    SubMachineName = '';
end

if isempty(SubMachineName)
    %SubMachineName = 'StorageRing';
    %SubMachineName = 'PTB';
    %SubMachineNameCell = {'Storage Ring', 'Booster-to-Storage Ring (BTS)', 'Booster', 'Preinjector-to-Booster (PTB)'};
    SubMachineNameCell = {'Storage Ring', 'Preinjector-to-Booster (PTB)'};
    [i, ok] = listdlg('PromptString', 'Select an accelerator:',...
       'SelectionMode', 'Single',...
       'Name', 'Elettra', ...
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

if any(strcmpi(SubMachineName, {'Storage Ring','Ring'}))
    SubMachineName = 'StorageRing';
end


if strcmpi(SubMachineName, 'StorageRing')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);
elseif strcmpi(SubMachineName, 'Booster')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'Booster',     'Booster',     LinkFlag);
elseif strcmpi(SubMachineName, 'Preinjector-to-Booster (PTB)') || strcmpi(SubMachineName, 'PTB')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'PTB',         'Transport',   LinkFlag);
elseif strcmpi(SubMachineName, 'Booster-to-Storage Ring (BTS)') || strcmpi(SubMachineName, 'BTS')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'BTS',         'Transport',   LinkFlag);
end

