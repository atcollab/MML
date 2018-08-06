function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathapex(varargin)
%SETPATHAPEX - Initializes the Matlab Middle Layer (MML) for APEX
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathapex(SubMachineName, OnlineLinkMethod)
%
%  INPUTS
%  1. SubMachineName - 'Gun'
%  2. OnlineLinkMethod - 'MCA', 'LabCA' {Default}

%  Written by Greg Portmann


Machine = 'APEX';


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
MatlabVersion = str2num(MatlabVersion.Version);

if isempty(LinkFlag)
    if strncmp(computer,'PC',2)
        LinkFlag = 'LABCA';
        %LinkFlag = 'MCA_ASP';
    elseif isunix
        LinkFlag = 'LABCA';
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
    SubMachineName = 'Gun';
    % SubMachineNameCell = {'Gun', ''};
    % [i, ok] = listdlg('PromptString', 'Select an accelerator:',...
    %     'SelectionMode', 'Single',...
    %     'Name', 'ALS', ...
    %     'ListString', SubMachineNameCell, ...
    %     'ListSize', [195 100]);
    % drawnow;
    % if ok
    %     SubMachineName = SubMachineNameCell{i};
    % else
    %     fprintf('Initialization cancelled (no path change).\n');
    %     return;
    % end
end


% Name changes
% if any(strcmpi(SubMachineName, {'Storage Ring','Ring','SR'}))
%     SubMachineName = 'StorageRing';
% end


if strcmpi(SubMachineName, 'Gun')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'Gun', 'Transport', LinkFlag);
else
    error('Machine type unknown');
end

