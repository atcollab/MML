function  FileName = loadthering(FileName)
%LOADTHERING - Loads the THERING from a .mat file
%  [FileName, THERING] = loadthering
%  [FileName, THERING] = loadthering(FileName)
%  [FileName, THERING] = loadthering('Golden') to load the THERING from the operations directory (THERING.mat)
%
%  See also savethering

%  Written by Greg Portmann


global THERING

THERINGsave = THERING;

if nargin < 1
    FileName = '';
end

if ischar(FileName)
    if isempty(FileName)
        [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat','Select a file with THERING');
        if FilterIndex == 0
            return;
        end
        FileName = [DirectoryName, FileName];
    elseif strcmpi(FileName, 'Golden')
        FileName = [getfamilydata('Directory','OpsData'), 'THERING.mat'];
    end
else
    error('Filename input must be a string');
end

THERING = [];
load(FileName);

if isempty(THERING)
    THERING = THERINGsave;
    error('THERING was not found in file %s', FileName);
end

% Run updateatindex after the ring is changed is always wise
if exist('updateatindex.m', 'file')
    updateatindex;
end

