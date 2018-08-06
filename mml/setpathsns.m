function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathsns(LinkFlag)
%SETPATHSNS - Initializes the Matlab Middle Layer (MML) for SNS
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathsns(OnlineLinkMethod)
%
%  INPUTS
%  1. OnlineLinkMethod - 'MCA', 'LabCA', 'SCA'

%  Written by Greg Portmann


Machine = 'SNS';


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

[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'Ring', 'StorageRing', LinkFlag);

