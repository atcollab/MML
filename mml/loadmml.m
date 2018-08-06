function  FileName = loadmml(FileName)
%LOADMML - Loads the MML data structures ("AD" & "AD") and the model from a .mat file
%  FileName = loadmml(FileName)
%  FileName = loadmml('')       - to browse for a file name
%  FileName = loadmml('Golden') - to load the golden MML setup file from the operations directory (GoldenMMLSetup.mat)
%
%  See also savemml, saveao, loadao

%  Written by Greg Portmann


global THERING

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
        % Note: getfamilydata('Directory','OpsData') could be empty if standalone.  Options:
        %       1. Force this file on the standalone path with "-a FileName" at compile
        %       2. Hardcode the directory path in aoinit
        FileName = [getfamilydata('Directory','OpsData'), 'GoldenMMLSetup.mat'];
    end
else
    error('Filename input must be a string');
end

fprintf('   MML and AT loaded from %s\n', FileName);
load(FileName);

if exist('AO','var')
    setao(AO);
else
    fprintf('   The MML AO setup variable was not in %s\n', FileName);
end
if exist('AD','var')
    setad(AD);
else
    fprintf('   The MML AD setup variable was not in %s\n', FileName);
end
if exist('THEMODEL','var')
    THERING = THEMODEL;
else
    fprintf('   The accelerator model was not in %s\n', FileName);
end
