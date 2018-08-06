function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathsolaris(LinkFlag)
%SETPATHSOLARIS - Initializes the Matlab Middle Layer (MML) for Solaris in Poland
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathsolaris(OnlineLinkMethod)
%

%  Written by Greg Portmann


Machine = 'Solaris';


% Input parsing
if nargin < 1
    LinkFlag = '';
end
if isempty(LinkFlag)
    LinkFlag = 'labca';
end

[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);



