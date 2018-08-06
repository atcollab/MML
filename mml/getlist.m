function DeviceList = getlist(varargin)  
%GETLIST - Returns Device List for a Family
%  getlist(FamilyName)
%  (Same as family2dev)
% 
%  INPUTS
%  1. FamilyNames
%
%  OUTPUTS
%  1. Device list for families specified in input
%  2. StatusFlag = 0 return all devices
%                 1 return only devices with good status {Default}
%
%  EXAMPLES
%  1. getlist('BPMx') 
%  2. getlist('HCOR',0)
%
%  See also family2dev

%  Written by Greg Portmann


DeviceList = family2dev(varargin{:});

