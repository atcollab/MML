function  savethering(FileName)
%SAVETHERING - Saves the THERING to a .mat file
%  savethering(FileName)
%  savethering('Golden') to save the THERING to the operations directory (THERING.mat)
%
%  See also loadthering

%  Written by Greg Portmann


global THERING

if nargin < 1
    FileName = '';
end

if ischar(FileName)
    if isempty(FileName)
        [FileName, DirectoryName, FilterIndex] = uiputfile('*.mat','Save THERING to ...', getfamilydata('Directory','DataRoot'));
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


save(FileName, 'THERING');



