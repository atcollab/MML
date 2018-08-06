function [FamilyName, DeviceList, ErrorFlag] = common2family(varargin)
%COMMON2FAMILY - Convert a common name to a family name
%  [Family, DeviceList, ErrorFlag] = common2family(CommonNames)
%
%  INPUTS
%  1. CommonNames - List of common names (string, matrix, cell array)
%
%  OUTPUTS
%  1. Family - Family Name
%              If the common name cannot be found a blank string is returned 
%  2. DeviceList - Device list
%  3. ErrorFlag - Number of errors found
%
%  See also common2dev, common2channel

%  Written by Greg Portmann


[DeviceList, FamilyName, ErrorFlag] = common2dev(varargin{:});
