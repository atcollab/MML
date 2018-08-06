function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathdsr(LinkFlag)
%SETPATHDSR - Initializes the Matlab Middle Layer (MML) for DSR
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathdsr(OnlineLinkMethod)
%
%  INPUTS
%  1. OnlineLinkMethod - 'MCA', 'LabCA', SCA

%  Written by Greg Portmann


Machine = 'DSR';


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
