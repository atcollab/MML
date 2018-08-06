function [AttributeNames, DeviceNames] =  getattribute(varargin)
%GETATTRIBUTE - Decomposes a full attributename into device and attribute names 
%  [AttributeNames, DeviceNames] =  getattribute(varargin)
%
% INPUTS
% 1. varargin = vector full attribute names
%
% OUTPUTS
% 1. AttributeNames = names of the attributes
% 2. DeviceNames    = names of the corresponding devices
%
% EXAMPLES
% 1. [AttributeNames, DeviceNames] =  getattribute('ANS-C01/DG/BPM.1/X')

%
% Written by Laurent S. Nadolski

if (length(varargin) == 0)
  error('No TangoName provided');
end

% get list of full tango attribute names
TangoNames = varargin{:};

% Regular expression and tokens
% first parenthesis gets device names
% second parenthesis gets device names
if ischar(TangoNames)
    TangoNames = cellstr(TangoNames);
end

t = regexp(TangoNames,'(.*)/(\w*)','tokens');

taille = length(t);

a = cell(taille,2);

for k=1:taille
    a(k,:) = cellstr(t{k}{:});
end

DeviceNames    = a(:,1);
AttributeNames = a(:,2);

% separator = regexpi(cellstr(TangoNames),'/'); 
% 
% if iscell(separator)
%    separator = cell2mat(separator);
% end

% separator = separator(:,3);
% AttributeNames = TangoNames(:,separator+1:end);
% DeviceNames    = TangoNames(:,1:separator-1);
