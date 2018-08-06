function setbpmtimeconstant(BPMTimeConstant, DeviceList)
%SETBPMTIMECONSTANT - Sets the timeconstants for the Bergoz style BPMs.
% setbpmtimeconstant(BPMTimeConstant, DeviceList)
% 
%  INPUTS
%  1. BPMTimeConstant - Time constant [seconds]  {Default: .25}
%  2. DeviceList - BPM device list {Default: getbpmlist('Bergoz')}
%
%  See also: getbpmaverages, setbpmaverages, getbpmtimeconstant

%  Written by Tom Scarvie


%  NOTE
%  1. This function is called by all orbit correction routines.
%  2. The time constant channel for Bergoz style BPMs in the arcs live in the "ffbsecxx" Fast 
%     Feedback cPCI crates and are set via the corresponding SRxxS___IBPM___AC00 channels.
%	  The sector 4, 8, and 12 BPMs have separate crates and the  time constant channel
%     is set via the SRxxC___BPM__T_AC00 channels.


if nargin < 1
   BPMTimeConstant = 0.25;
end
if nargin < 2
    DeviceList = getbpmlist('Bergoz');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the Bergoz BPM Time Constant %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Can't set a non-Bergoz style time constant
[tmp1, tmp2, i] = findrowindex(DeviceList, getbpmlist('nonBergoz'));
if ~isempty(i)
    fprintf('   Removing non-Bergoz style BPMs.\n');
    DeviceList(i,:) = [];
    if length(BPMTimeConstant) > 1
        BPMTimeConstant(i) = [];
    end
end

setpv('BPMx', 'TimeConstant', BPMTimeConstant, DeviceList);

