function savegoldenorbit(FileName)
%SAVEGOLDENORBIT - Save the golden orbit to a file
%  savegoldenorbit(FileName)
%
%  See also saveoffsetorbit, getgolden, plotgoldenorbit

%  Written by Greg Portmann


Xgolden = getgolden(gethbpmfamily, 'Struct');
Ygolden = getgolden(getvbpmfamily, 'Struct');


if nargin < 1
    FileName = '';
end

if isempty(FileName)
    FileName = appendtimestamp([getfamilydata('Default', 'BPMArchiveFile'), '_Golden'], clock);
    DirectoryName = getfamilydata('Directory', 'BPMData');
    if isempty(DirectoryName)
        DirectoryName = [getfamilydata('Directory','DataRoot') 'BPM', filesep];
    end

    % Make sure default directory exists
    DirStart = pwd;
    [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
    cd(DirStart);

    [FileName, DirectoryName] = uiputfile('*.mat', 'Save Golden BPM File to ...', [DirectoryName FileName]);
    if FileName == 0
        FileName = '';
        return
    end
    FileName = [DirectoryName, FileName];
end

save(FileName, 'Xgolden', 'Ygolden');