function  saveao(FileName)
%SAVEAO - Saves the AO and AD to a .mat file
%  saveao(FileName)
%  saveao('')       - to browse for a file name
%  saveao('Golden') - to save to the operations directory with file name GoldenMMLSetup.mat
%
%  See also loadao, loadmml, savemml

%  Written by Greg Portmann


if nargin < 1
    FileName = '';
end

if ischar(FileName)
    if isempty(FileName)
        [FileName, DirectoryName, FilterIndex] = uiputfile('*.mat','Save the AO or AD to ...', getfamilydata('Directory','DataRoot'));
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


save(FileName, 'AO', 'AD');



