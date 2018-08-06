function [varargout] = soleilbpmcheck
%SOLEILBPMCHECK - Checks for bad bpm entries
%create BPM.status vector with valid indices contained in total bpm vector itbpm

%
% Modified by Laurent Nadolski

mode = getfamilydata('BPMx','Monitor','Mode');

if strcmpi(mode,'ONLINE') %...system is ONLINE - look for bad BPM readings
    xstat = find(getfamilydata('BPMx','Status'));
    ystat = find(getfamilydata('BPMy','Status'));   
elseif strcmpi(mode,'SIMULATOR')
    xstat = find(getfamilydata('BPMx','Status'));
    ystat = find(getfamilydata('BPMy','Status'));
elseif strcmpi(mode,'Special')
    xstat = find(getfamilydata('BPMx','Status'));
    ystat = find(getfamilydata('BPMy','Status'));    
end  %end of mode condition

varargout{1} = xstat;
varargout{2} = ystat;
