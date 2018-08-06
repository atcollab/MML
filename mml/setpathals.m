function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathals(varargin)
%SETPATHALS - Initializes the Matlab Middle Layer (MML) for ALS
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathals(SubMachineName, OnlineLinkMethod)
%
%  INPUTS
%  1. SubMachineName - 'StorageRing', 'Booster', 'BTS', 'GTB', 'GTFC'
%  2. OnlineLinkMethod - 'MCA', 'LabCA' {Default}, 'SCA'

%  Written by Greg Portmann


Machine = 'ALS';


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
    elseif strcmpi(varargin{i},'MCA_ASP')
        LinkFlag = 'MCA_ASP';
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
    if strncmp(computer,'PC',2)
        LinkFlag = 'LABCA';
        %LinkFlag = 'MCA_ASP';
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
    %SubMachineName = 'StorageRing';
    SubMachineName = '';
end

if isempty(SubMachineName)
    SubMachineNameCell = {'Storage Ring', 'Booster-to-Storage Ring (BTS)', 'Booster', 'Gun-to-Booster (GTB)'};
    %SubMachineNameCell = {'Storage Ring', 'Booster-to-Storage Ring (BTS)', 'Booster', 'Gun-to-Booster (GTB)', 'Gun-to-Faraday Cup'};
    [i, ok] = listdlg('PromptString', 'Select an accelerator:',...
        'SelectionMode', 'Single',...
        'Name', 'ALS', ...
        'ListString', SubMachineNameCell, ...
        'ListSize', [195 100]);
    drawnow;
    if ok
        SubMachineName = SubMachineNameCell{i};
    else
        fprintf('   Initialization cancelled (no path change).\n');
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
elseif strcmpi(SubMachineName, 'Gun-to-Faraday Cup')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'GTFC',        'Transport',   LinkFlag);
end

