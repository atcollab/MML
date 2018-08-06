function [MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathtls(LinkFlag)
%SETPATHTLS - Initializes the Matlab Middle Layer (MML) for Taiwan Light Source (TLS)
%  [MachineName, SubMachineName, OnlineLinkMethod, MMLROOT] = setpathtls(OnlineLinkMethod)
%
%  INPUTS
%  1. OnlineLinkMethod - 'TLS_CTL' {Default}

%  Written by Greg Portmann


Machine = 'TLS';


% Input parsing
if nargin < 1
    LinkFlag = '';
end
if isempty(LinkFlag)
    LinkFlag = 'TLS_CTL';
end

[MachineName, SubMachineName, LinkFlag, MMLROOT] = setpathmml(Machine, 'StorageRing', 'StorageRing', LinkFlag);

