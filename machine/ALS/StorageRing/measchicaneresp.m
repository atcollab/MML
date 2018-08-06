function [Rmat, OutputFileName] = measchicaneresp(varargin)
%MEASCHICANERESP - Measures the BPM response matrix in the chicane magnets at the ALS
%
%  This function is just an alias to measbpmresp with chicane magnet familes.
%
%  Written by Greg Portmann


ModulationMethod = 'bipolar';
WaitFlag = [];
HCMKicks = [];
VCMKicks = [];
DirectoryName = getfamilydata('Directory', 'BPMResponse');
FileName = getfamilydata('Default','ChicaneRespFile');
FileName = appendtimestamp(FileName, clock);

[R, FileName] = measbpmresp(...
    'BPMx', [], 'BPMy', [], ...
    'HCMCHICANE', [], 'VCMCHICANE', [], ...
    HCMKicks, VCMKicks, ModulationMethod, WaitFlag, FileName, DirectoryName, varargin{:});


