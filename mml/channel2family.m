function [FamilyName, Field, DeviceList, ErrorFlag] = channel2family(varargin)
%CHANNEL2FAMILY - Convert a channel name to a Family, Field, DeviceList
%  [Family, Field, DeviceList, ErrorFlag] = channel2family(ChannelNames, Family)
%
%  INPUTS
%  1. ChannelNames - List of channel names (string, matrix, or cell array)
%  2. Family - Family Names to to limit search (string or cell of strings)
%              Accelerator Object
%              '' search all families until 1 match is found {Default}
%
%  OUTPUTS
%  1. Family - Family name corresponding to the channel name
%              If the channel name cannot be found an empty strings 
%              (or a blank string for matrix inputs) is returned
%  2. Field - Field Name
%  3. DeviceList - DeviceList corresponding to the channel name
%                  If a channel name match is not found, an empty matrix is returned. 
%                  For a matrix input, if only some for channel names are not found, 
%                  [NaN NaN] will be inserted into the device list where they are not found.
%  4. ErrorFlag - number of errors found

%  Written by Greg Portmann


[DeviceList, FamilyName, Field, ErrorFlag] = channel2dev(varargin{:});

