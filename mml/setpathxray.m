function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathxray
%SETPATHXRAY - Initializes the Matlab Middle Layer (MML) for the X-Ray ring at NSLS
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathxray

%  Written by Greg Portmann



[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml('XRay', 'StorageRing', 'StorageRing', 'UCODE');
