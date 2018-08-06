function [varargout] = soleilcorcheck
%SOLEILCORCHECK - Checks for invalid corrector entries
% [varargout] = soleilcorcheck
% create COR.status vector with valid indices

%
% Written by Laurent S. Nadolski, Soleil, April 2004

mode = getfamilydata('HCM','Monitor','Mode');
if strcmpi(mode,'ONLINE')          %...system is ONLINE - look for bad correctors readings
    xstat = find(getfamilydata('HCM','Status'));
elseif strcmpi(mode,'SIMULATOR')
    xstat = find(getfamilydata('HCM','Status'));
end  %end of mode condition

mode = getfamilydata('VCM','Monitor','Mode');
if strcmpi(mode,'ONLINE')          %...system is ONLINE - look for bad correctors readings
    zstat = find(getfamilydata('VCM','Status'));
elseif strcmpi(mode,'SIMULATOR')
    zstat = find(getfamilydata('VCM','Status'));
end  %end of mode condition

varargout{1} = xstat;
varargout{2} = zstat;
