function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathsirius(varargin)
%SETPATHSIRIUS - Initializes the Matlab Middle Layer (MML) for Brazilian Sources (LNLS1 or SIRIUS)
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathlnls(OnlineLinkMethod)
%
%  INPUTS
%  1. Machine - 'SIRIUS' {Default}
%  1. OnlineLinkMethod - 'lnls1Link' {Default}

%  Written by Greg Portmann
%             Ximenes.

Machine  = 'SIRIUS';
LinkFlag = 'sirius_link';
SubMachineName = '';
MachineType = '';

% Input parsing
if nargin>0
    Machine = varargin{1};
end;
if nargin>1
    SubMachine = varargin{2}; 
end;
if nargin>2
    LinkFlag = varargin{3}; 
end;


if isempty(SubMachineName)
    SubMachineNameCell = {'SI', 'BO', 'TB', 'TS', 'LI'};
    [i, ok] = listdlg('PromptString', 'Select an accelerator:',...
        'SelectionMode', 'Single',...
        'Name', 'Sirius', ...
        'ListString', SubMachineNameCell);
    if ok
        SubMachineName = SubMachineNameCell{i};
    else
        fprintf('Initialization cancelled (no path change).\n');
        return;
    end
end

if any(strcmpi(SubMachineName, {'Storage Ring','Ring'}))
    SubMachineName = 'SR';
end

if strcmpi(SubMachineName,'SI')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'SI', 'StorageRing', LinkFlag);
elseif strcmpi(SubMachineName,'BO')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'BO',     'Booster',     LinkFlag);
elseif strcmpi(SubMachineName,'TS')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'TS',         'Transport',   LinkFlag);
elseif strcmpi(SubMachineName,'TB')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'TB',         'Transport',   LinkFlag);
elseif strcmpi(SubMachineName,'LI')
    [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'LI',    'Booster',     LinkFlag);
end
