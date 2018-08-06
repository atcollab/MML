function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathindus2(varargin)
%SETPATHINDUS2 - Initializes the Matlab Middle Layer (MML) for the Indus2 (light source)
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathindus2(OnlineLinkMethod)
%
%  INPUTS
%  1. Machine - 'Indus2' {Default}
%  1. OnlineLinkMethod - '????' {Default}

%  Written by Greg Portmann

Machine  = 'Indus2';
LinkFlag = '';

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

[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, SubMachine, MachineType, LinkFlag);

