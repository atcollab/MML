function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathlnls2(LinkFlag)
%SETPATHLNLS2 - Initializes the Matlab Middle Layer (MML) for new Brazilian Source (LNLS2)
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathlnls2(OnlineLinkMethod)
%
%  INPUTS
%  1. OnlineLinkMethod - 'LNLSLINK' {Default}

%  Written by Greg Portmann


Machine = 'LNLS2';


% Input parsing
if nargin < 1
    LinkFlag = '';
end
if isempty(LinkFlag)
    LinkFlag = 'lnlslink';
end

[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);

