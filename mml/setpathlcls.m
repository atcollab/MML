function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathlcls(LinkFlag)
%SETPATHLCLS - Initializes the Matlab Middle Layer (MML) for LCLS
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathlcls(OnlineLinkMethod)
%
%  INPUTS
%  1. OnlineLinkMethod - 'LabCA'

%  Written by Greg Portmann


Machine = 'LCLS';


% Input parsing
if nargin < 1
    LinkFlag = '';
end
if isempty(LinkFlag)
    LinkFlag = 'labca';
end

[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'Linac', 'Transport', LinkFlag);
