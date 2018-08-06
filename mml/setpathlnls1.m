function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathlnls1(LinkFlag)
%SETPATHLNLS1 - Initializes the Matlab Middle Layer (MML) for Brazilian Source (LNLS1)
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathlnls1(OnlineLinkMethod)
%
%  INPUTS
%  1. OnlineLinkMethod - 'LNLSLINK' {Default}

%  Written by Greg Portmann


Machine = 'LNLS1';


% Input parsing
if nargin < 1
    LinkFlag = '';
end
if isempty(LinkFlag)
    LinkFlag = 'lnlslink';
end

[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);

