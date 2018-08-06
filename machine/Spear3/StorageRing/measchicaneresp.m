function [Rmat, OutputFileName] = measchicaneresp(varargin)
%MEASCHICANERESP - Measures the BPM response matrix in the chicane magnets in SPEAR
%
%  This function is just an alias to measbpmresp with chicane magnet familes.
%
%  Written by Greg Portmann
%   modified for SPEAR by Corbett


ModulationMethod = 'unipolar';
WaitFlag = [];
HCMKicks = [];
VCMKicks = [];
DirectoryName = getfamilydata('Directory', 'ChicaneResponse');
FileName = getfamilydata('Default','ChicaneRespFile');
FileName = appendtimestamp(FileName, clock);

[R, FileName] = measbpmresp(...
    'BPMx', [], 'BPMy', [], ...
    'CD', [], 'CD', [], ...
    HCMKicks, VCMKicks, ModulationMethod, WaitFlag, FileName, DirectoryName, varargin{:});


