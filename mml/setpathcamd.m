function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathcamd(LinkFlag)
%SETPATHCAMD - Initializes the Matlab Middle Layer (MML) for CAMD
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathcamd(OnlineLinkMethod)
%
%  INPUTS
%  1. OnlineLinkMethod - 'MCA', 'LabCA', SCA

%  Written by Greg Portmann


Machine = 'CAMD';


% Input parsing
if nargin < 1
    LinkFlag = '';
end
if isempty(LinkFlag)
    if strncmp(computer,'PC',2)
        LinkFlag = 'labca';
        %LinkFlag = 'mca';
    elseif isunix
        LinkFlag = 'labca';
        %LinkFlag = 'mca';
    else
        LinkFlag = 'labca';
        %LinkFlag = 'mca';
    end
end

[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);



