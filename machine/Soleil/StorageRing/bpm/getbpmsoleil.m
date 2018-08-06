function [BPM, Error] = getbpmsoleil(varargin)
%GETBPMSOLEIL - Returns ??? 
%[BPM, Error] = getbpmsoleil(MeasType, DeviceList)
%
% INPUTS
% 1. MeasType - 'horizontal'
%               'vertical'   
% 2. DeviceList - list of bpms
%
% OUTPUTS
% 1. BPM - Values read in BPMs
% 2. Error - 0 if OK
%
% TODO
% 1. To be rewrite

%
% Written by Laurent S. Nadolski

Error = 0;
MeasType = 'Horizontal';

for k = length(varargin):-1:1,
    if strcmpi(varargin{k}, 'Horizontal')
        MeasType = 'Horizontal';
        varargin(k) = [];
    elseif strcmpi(varargin{1}, 'Vertical')
        MeasType = 'Vertical';
        varargin(k) = [];
    end
end
    
if isempty(varargin)
    DeviceList = family2dev('BPMx');
else
    DeviceList = varargin{1}
end
    
[BPM(:,1) BPM(:,2)] = soleilbpms(DeviceList);

BPM = BPM';

if strcmpi(MeasType, 'Horizontal')
    BPM = BPM(1,:);  
elseif strcmpi(MeasType, 'Vertical')
    BPM = BPM(2,:);
% case 'sum'
%     BPM = BPM(3,:);
% case 'q'
%     BPM = BPM(4,:);
%     %case 'A'
%    % BPM = BPM(4,:).*BPM(4,:);
else
    error('BPM measurement unknown');
end

BPM = BPM(:);
