function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathvuv
%SETPATHVUV - Initializes the Matlab Middle Layer (MML) for the VUV ring at NSLS
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathvuv

%  Written by Greg Portmann


[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml('VUV', '800MeV', 'StorageRing', 'UCODE');
