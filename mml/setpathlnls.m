function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathlnls(varargin)
%SETPATHLNLS - Initializes the Matlab Middle Layer (MML) for Brazilian Sources (LNLS1 or SIRIUS)
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathlnls(OnlineLinkMethod)
%
%  INPUTS
%  1. Machine - 'LNLS1' {Default}
%  1. OnlineLinkMethod - 'lnls1Link' {Default}

%  Written by Greg Portmann

Machine  = 'LNLS1';
LinkFlag = 'lnls1_link';

% Input parsing
if nargin>0
    Machine = varargin{1};
end;
if nargin>1, 
    SubMachine = varargin{2}; 
end;
if nargin>2, 
    LinkFlag = varargin{3}; 
end;

if strcmpi(SubMachine, 'StorageRing')
    MachineType = 'StorageRing';
elseif strcmpi(SubMachine, 'Booster')
    MachineType = 'Booster';
end

%[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);
[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, SubMachine, MachineType, LinkFlag);

