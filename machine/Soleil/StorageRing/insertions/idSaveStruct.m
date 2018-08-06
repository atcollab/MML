function res = idSaveStruct(structToSave, fileNameCore, idName, dispData)
% Before saving, this calls functions written by L.N. and performing the
% file name decorations 

res = '';
% If the filename contains a directory then make sure it exists

% Save the structure into a file, if necessary
if strcmp(fileNameCore, '') ~= 0
    % Claim error
    printf('File name is not specified');
end

FileName = appendtimestamp(fileNameCore);
%DirectoryName = getfamilydata('Directory','HU80_TEMPO');
DirectoryName = getfamilydata('Directory',idName);
DirStart = pwd;
[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);

if ErrorFlag == 0
    save(FileName,'-struct', 'structToSave');
    res = FileName;
else
    % Claim error
    errStr = strcat('Can not locate the directory ', DirectoryName);
    printf(errStr);
end
cd(DirStart);

if dispData ~= 0
	fprintf('Sauvegarde:  %s\n', FileName);
end


