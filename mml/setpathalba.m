function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathalba(LinkFlag)
%SETPATHALBA - Initializes the Matlab Middle Layer (MML) for ALBA
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathalba

%  Written by Greg Portmann


[MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathmml('ALBA', 'StorageRing', 'StorageRing', 'Tango');
