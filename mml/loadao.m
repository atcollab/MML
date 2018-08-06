function  FileName = loadao(FileName)
%LOADMML - Loads the MML data structures ("AD" & "AD") from a .mat file
%  FileName = loadao(FileName)
%  FileName = loadao('')       - to browse for a file name
%  FileName = loadao('Golden') - to load the golden MML setup file from the operations directory (GoldenMMLSetup.mat)
%
%  See also saveao, savemml, loadmml

%  Written by Greg Portmann


if nargin < 1
    FileName = '';
end

if ischar(FileName)
    if isempty(FileName)
        [FileName, DirectoryName, FilterIndex] = uigetfile('*.mat','Select an MML setup file');
        if FilterIndex == 0
            return;
        end
        FileName = [DirectoryName, FileName];
    elseif strcmpi(FileName, 'Golden')
        FileName = [getfamilydata('Directory','OpsData'), 'GoldenMMLSetup.mat'];
    end
else
    error('Filename input must be a string');
end

load(FileName);

setao(AO);
setad(AD);
