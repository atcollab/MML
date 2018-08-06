function rsp = response2rsp(datastruct,rsp,plane)
%RESPONSE2RSP - Loads middlelayer response matrix data format into orbit program response structure
% 
% INPUTS
% 1. rsp = model orbit program response structure
% 2. datastruct = middlelayer response matrix data format
%
% OUTPUTS
% rsp = modified orbit program response structure

%
% Written by William J. Corbett
% Modified by Laurent S. Nadolski

% BPMFamily = {'BPMx', 'BPMz'};
% CORFamily = {'HCOR' , 'VCOR' };
global BPM COR

[BPMFamily{1}, BPMFamily{2}] = BPM.AOFamily;
[CORFamily{1}, CORFamily{2}] = COR.AOFamily;

temp = datastruct;

if iscell(temp)
    temp = temp{1}
end

if ~exist('plane','var') % treat both planes
  for ip = 1:2
   rsp(ip).ib            = dev2elem(BPMFamily{ip},temp(ip,ip).Monitor.DeviceList);   %BPM index list
   rsp(ip).ic            = dev2elem(CORFamily{ip},temp(ip,ip).Actuator.DeviceList);  %corrector index list
   rsp(ip).Data          = temp(ip,ip).Data;                                         %response matrix INCLUDING NaN ENTRIES
   rsp(ip).ActuatorDelta = temp(ip,ip).ActuatorDelta;                                %corrector currents
  end
else % treat one single plane
   ip                  = plane;
   rsp.ib              = dev2elem(BPMFamily{ip},temp.Monitor.DeviceList);  %BPM index list
   rsp.ic              = dev2elem(CORFamily{ip},temp.Actuator.DeviceList); %corrector index list
   rsp.Data            = temp.Data;                                        %response matrix INCLUDING NaN ENTRIES
   rsp.ActuatorDelta   = temp.ActuatorDelta;                               %corrector currents
end