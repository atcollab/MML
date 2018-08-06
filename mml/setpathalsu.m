function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathalsu(varargin)
%SETPATHALSU - Initializes the Matlab Middle Layer (MML) for ALS-U
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathalsu(SubMachineName, OnlineLinkMethod)
%
%  INPUTS
%  1. SubMachineName - 'SR', 'AR', 'Booster', 'BTS', 'GTB', 'GTFC'
%  2. OnlineLinkMethod - 'MCA', 'LabCA' {Default}, 'SCA'

%  Written by Greg Portmann


Machine = 'ALSU';


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
    %SubMachineName = 'SR';
    SubMachineName = '';
end

if isempty(SubMachineName)
    SubMachineNameCell = {'Storage Ring (SR)', 'Accumulator Ring (AR)', 'Storage-to-Accumulator Ring (STA)', 'Accumulator-to-Storage Ring (ATS)', 'Booster-to-Accumulator Ring (BTA)', 'Booster', 'Gun-to-Booster (GTB)'};
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
if any(strcmpi(SubMachineName, {'Storage Ring (SR)','Storage Ring','Ring','SR'}))
    SubMachineName = 'SR';
end

if any(strcmpi(SubMachineName, {'Accumulator Ring (AR)','Accumulator Ring','AR'}))
    SubMachineName = 'AR';
end

if any(strcmpi(SubMachineName, {'Booster Ring','BR'}))
    SubMachineName = 'BR';
end

if any(strcmpi(SubMachineName, {'Gun-to-Booster (GTB)','Gun-to-Booster'}))
    SubMachineName = 'GTB';
end

if any(strcmpi(SubMachineName, {'Booster-to-Accumulator Ring (BTA)','Booster-to-Accumulator Ring'}))
    SubMachineName = 'BTA';
end

if any(strcmpi(SubMachineName, {'Accumulator-to-Storage Ring (ATS)','Accumulator-to-Storage Ring'}))
    SubMachineName = 'ATS';
end

if strcmpi(SubMachineName, 'SR')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'SR',   'StorageRing', LinkFlag);
elseif strcmpi(SubMachineName, 'AR')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'AR',   'StorageRing', LinkFlag);
elseif strcmpi(SubMachineName, 'BR')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'BR',   'Booster',     LinkFlag);
elseif strcmpi(SubMachineName, 'GTB')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'GTB',  'Transport',   LinkFlag);
elseif strcmpi(SubMachineName, 'BTA')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'BTA',  'Transport',   LinkFlag);
elseif strcmpi(SubMachineName, 'ATS')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'ATS',  'Transport',   LinkFlag);
elseif strcmpi(SubMachineName, 'STA')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'STA',  'Transport',   LinkFlag);
elseif strcmpi(SubMachineName, 'Gun-to-Faraday Cup')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'GTFC', 'Transport',   LinkFlag);
end

