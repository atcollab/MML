function [varargout] = soleilcorcheck
%SOLEILCORCHECK - Checks for invalid corrector entries
% [varargout] = soleilcorcheck
% create COR.status vector with valid indices

%
% Written by Laurent S. Nadolski, Soleil, April 2004

mode = getfamilydata('HCOR','Monitor','Mode');
if strcmpi(mode,'ONLINE')          %...system is ONLINE - look for bad correctors readings
    xstat = find(getfamilydata('HCOR','Status'));
elseif strcmpi(mode,'SIMULATOR')
    xstat = find(getfamilydata('HCOR','Status'));
end  %end of mode condition

mode = getfamilydata('VCOR','Monitor','Mode');
if strcmpi(mode,'ONLINE')          %...system is ONLINE - look for bad correctors readings
    zstat = find(getfamilydata('VCOR','Status'));
elseif strcmpi(mode,'SIMULATOR')
    zstat = find(getfamilydata('VCOR','Status'));
end  %end of mode condition

varargout{1} = xstat;
varargout{2} = zstat;
