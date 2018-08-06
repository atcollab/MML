function [DCCT, tout, DataTime, ErrorFlag] = getdcct_als(varargin)
% [DCCT] = getdcct_als
%


tout = [];
DataTime = [];
ErrorFlag = 0;


% Slow (averaged) channel
[DCCT, tout, DataTime, ErrorFlag] = getpv('SR05W___DCCT2__AM01');
DCCT = 1000 * DCCT;


% Fast channel
%[DCCT, tout, DataTime, ErrorFlag] = getpv('cmm:beam_current');
