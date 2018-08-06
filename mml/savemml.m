function  FileName = savemml(FileName)
%SAVEMML - Saves the MML data structures ("AD" & "AD") and the model to a .mat file
%  savemml(FileName)
%  savemml('')       - to browse for a file name
%  savemml('Golden') - to save to the operations directory with file name GoldenMMLSetup.mat
%
%  See also saveao, loadmml, loadao

%  Written by Greg Portmann


global THERING

if nargin < 1
    FileName = '';
end

if ischar(FileName)
    if isempty(FileName)
        [FileName, DirectoryName, FilterIndex] = uiputfile('*.mat','Save the MML setup to ...', getfamilydata('Directory','DataRoot'));
        if FilterIndex == 0
            return;
        end
        FileName = [DirectoryName, FileName];
    elseif strcmpi(FileName, 'Golden')
        FileName = [getfamilydata('Directory','OpsData'), 'GoldenMMLSetup'];
    end
else
    error('Filename input must be a string');
end


AO = getao;
AD = getad;
THEMODEL = THERING;

save(FileName, 'AO', 'AD', 'THEMODEL');



