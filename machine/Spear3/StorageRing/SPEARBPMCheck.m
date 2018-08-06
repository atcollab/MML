%=============================================================
function [varargout] = SPEARBPMCheck
%=============================================================
%checks for bad bpm entries
%create BPM.status vector with valid indices contained in total bpm vector itbpm




mode=getfamilydata('BPMx','Monitor','Mode');
if strcmpi(mode,'ONLINE')          %...system is ONLINE - look for bad BPM readings
xstat=find(getfamilydata('BPMx','Status'));
ystat=find(getfamilydata('BPMy','Status'));
% xlim=30;
% ylim=10;
% x=getx;
% y=gety;
% xstat = find(abs(x)<xlim);     %status of bad bpms set to zero
% ystat = find(abs(y)<ylim);     %status of bad bpms set to zero

elseif strcmpi(mode,'SIMULATOR')
xstat=find(getfamilydata('BPMx','Status'));
ystat=find(getfamilydata('BPMy','Status'));

end  %end of mode condition

varargout{1}=xstat;
varargout{2}=ystat;
