function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathssrf(LinkFlag)
%SETPATHSSRF - Initializes the Matlab Middle Layer (MML) for SSRF
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathssrf(OnlineLinkMethod)
%
%  INPUTS
%  1. OnlineLinkMethod - 'MCA', 'LabCA', SCA

%  Written by Greg Portmann


Machine = 'SSRF';


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



