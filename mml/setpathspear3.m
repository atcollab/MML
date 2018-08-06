function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathspear3(LinkFlag)
%SETPATHSPEAR3 - Initializes the Matlab Middle Layer (MML) for Spear3
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathspear3(OnlineLinkMethod)
%
%  INPUTS
%  1. OnlineLinkMethod - 'MCA', 'LabCA', 'SCA'

%  Written by Greg Portmann


Machine = 'Spear3';


% Input parsing
if nargin < 1
    LinkFlag = '';
end
if isempty(LinkFlag)
    if strncmp(computer,'PC',2)
        LinkFlag = 'mca';
    elseif isunix
        LinkFlag = 'labca';
    else
        LinkFlag = 'mca';
    end
end

[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);

