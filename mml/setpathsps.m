function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathsps(LinkFlag)
%SETPATHSPS - Initializes the Matlab Middle Layer (MML) for SPS
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathsps(OnlineLinkMethod)
%
%  INPUTS
%  1. OnlineLinkMethod - 'MCA', 'LabCA', SCA

%  Written by Greg Portmann


Machine = 'SPS';


% Input parsing
if nargin < 1
    LinkFlag = 'OPC';
end


[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);


