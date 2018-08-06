%=============================================================
function [varargout] = SPEARCorCheck
%=============================================================
%checks for invalid corrector entries
%create COR.status vector with valid indices

mode=getfamilydata('HCM','Monitor','Mode');
if strcmpi(mode,'ONLINE')          %...system is ONLINE - look for bad correctors readings
xstat=find(getfamilydata('HCM','Status'));
elseif strcmpi(mode,'SIMULATOR')
xstat=find(getfamilydata('HCM','Status'));
end  %end of mode condition

mode=getfamilydata('VCM','Monitor','Mode');
if strcmpi(mode,'ONLINE')          %...system is ONLINE - look for bad correctors readings
ystat=find(getfamilydata('VCM','Status'));
elseif strcmpi(mode,'SIMULATOR')
ystat=find(getfamilydata('VCM','Status'));
end  %end of mode condition

varargout{1}=xstat;
varargout{2}=ystat;
