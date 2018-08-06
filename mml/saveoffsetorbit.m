function saveoffsetorbit(FileName)
%SAVEOFFSETORBIT - Save the offset orbit to a file
%  saveoffsetorbit(FileName)
%
%  See also savegoldenorbit, getoffset, plotoffsetorbit

%  Written by Greg Portmann


Xoffset = getoffset(gethbpmfamily, 'Struct');
Yoffset = getoffset(getvbpmfamily, 'Struct');


if nargin < 1
    FileName = '';
end

if isempty(FileName)
    FileName = appendtimestamp([getfamilydata('Default', 'BPMArchiveFile'), '_Offset'], clock);
    DirectoryName = getfamilydata('Directory', 'BPMData');
    if isempty(DirectoryName)
        DirectoryName = [getfamilydata('Directory','DataRoot') 'BPM', filesep];
    end

    % Make sure default directory exists
    DirStart = pwd;
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    cd(DirStart);

    [FileName, DirectoryName] = uiputfile('*.mat', 'Save Offset BPM File to ...', [DirectoryName FileName]);
    if FileName == 0
        FileName = '';
        return
    end
    FileName = [DirectoryName, FileName];
end

save(FileName, 'Xoffset', 'Yoffset');