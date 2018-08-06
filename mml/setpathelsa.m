function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathelsa(LinkFlag)
%SETPATHELSA - Initializes the Matlab Middle Layer (MML) for ELSA
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathelsa(OnlineLinkMethod)
%

%  Written by Greg Portmann


Machine = 'ELSA';


% Input parsing
if nargin < 1
    LinkFlag = '';
end
if isempty(LinkFlag)
    LinkFlag = 'labca';
end

[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);



