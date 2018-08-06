function [DCCT, ErrorFlag] = getDCCTxray(varargin)
% DCCT = getDCCTxray [mA] with resolution of 0.0001 mA
%   written by S. Kramer 9/29/2004

ErrorFlag = 0;

if nargin < 2
    Field = 'Monitor';
else
    Field = varargin{2};
end

% For xray current[mA]= Integer part of xrcurr [mA], lo [Hz/10]

if strcmp(Field, 'Monitor')
    f = getpv(['xrcurr:am'; 'xcurrfraction:am']);
else
    f = getpv(['xrcurr:sp'; 'xcurrfraction:sp']);
end
icurr= int16(f(1)) ;  % truncate mA
DCCT = double(icurr) + f(2)./1.0e4;  % xcurrfraction is in fraction of ma *10^4
