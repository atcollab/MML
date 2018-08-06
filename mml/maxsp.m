function [Data, ErrorFlag] = maxsp(varargin)
%MAXSP - Maximum value of the setpoint
%
%  FamilyName/DeviceList Method
%  SPmax = maxsp(Family, DeviceList)
%  SPmax = maxsp(DataStructure)
%
%  ChannelName Method
%  SPmax = maxsp(ChannelNames)
%
%  CommonName Method
%  SPmax = maxsp(Family, CommonName)
%
%  INPUTS
%  1. Family - Family Name 
%              Data Structure
%              Accelerator Object
%  2. DeviceList - [Sector Device #] or [element #] list {default or empty list: whole family}
%
%  OUTPUTS
%  1. SPmax - Maximum setpoint of the device
%
%  NOTES
%  1. If Family is a cell array, then DeviceList and Field can also be a cell arrays
%
%  See also minsp, maxpv

%  Written by Greg Portmann

[Data, ErrorFlag] = maxpv(varargin{:});