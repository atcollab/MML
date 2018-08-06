function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathtps(LinkFlag)
%SETPATHTPS - Initializes the Matlab Middle Layer (MML) for Taiwan Photon Source (TPS)
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathtps(OnlineLinkMethod)
%
%  INPUTS
%  1. OnlineLinkMethod - 'MCA', 'LabCA' {Default}, SCA

%  Written by Greg Portmann


Machine = 'TPS';


% Input parsing
if nargin < 1
    LinkFlag = '';
end
if isempty(LinkFlag)
    if strncmp(computer,'PC',2)
        LinkFlag = 'labca';
    elseif isunix
        LinkFlag = 'labca';
    else
        LinkFlag = 'labca';
    end
end

[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);

