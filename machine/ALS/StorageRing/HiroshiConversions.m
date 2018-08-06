function HiroshiConversions

% Order Number
% Element Number (Ie, for BPMs: 12/Sector or 12*12 total slots)
% Position
% Channel name
% Family(Sector, Element)


DirectoryName = getfamilydata('Directory','DataRoot');
DirectoryName = [DirectoryName, 'Database', filesep];
DirStart = pwd;
[DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
if ErrorFlag
    fprintf('   Problem creating target directory.  Function failed.\n');
    return;
end
cd(DirStart);



% Setpoint and monitor
fid = fopen([DirectoryName, 'SRMagnets.txt'], 'w');
Family = {'HCM', 'VCM', 'QF', 'QD', 'QDA', 'SQSF', 'SQSD', 'SF', 'SD', 'BEND', 'ID', 'EPU'};
for j = 1:length(Family)
    Dev = family2dev(Family{j}, 0);
    Elem = dev2elem(Family{j}, Dev);
    Pos = getspos(Family{j}, Dev);
    SetChanName = family2channel(Family{j}, 'Setpoint', Dev);
    MonChanName = family2channel(Family{j}, 'Monitor', Dev);
    %Num = (1:length(Elem))';

    for i = 1:length(Elem)
        fprintf(fid, '%2d %2d %7.3f %s %s %s(%d,%d)\n', i, Elem(i), Pos(i), SetChanName(i,:), MonChanName(i,:), Family{j}, Dev(i,:));
        %fprintf(fid, '%2d %7.3f %s %s %s(%d,%d)\n', Elem(i), Pos(i), SetChanName(i,:), MonChanName(i,:), Family{j}, Dev(i,:));
    end
    fprintf(fid, '\n');
end
fclose(fid);
fprintf('   Data written to %s\n',[DirectoryName, 'SRMagnets.txt']);


% Monitor Only
fid = fopen([DirectoryName, 'SRBPM.txt'], 'w');
Family = {'BPMx', 'BPMy'};   
for j = 1:length(Family)
    Dev = family2dev(Family{j}, 0);
    Elem = dev2elem(Family{j}, Dev);
    Pos = getspos(Family{j}, Dev);
    MonChanName = family2channel(Family{j}, 'Monitor', Dev);
    %Num = (1:length(Elem))';

    for i = 1:length(Elem)
        fprintf(fid, '%2d %2d %7.3f %s %s(%d,%d)\n', i, Elem(i), Pos(i), MonChanName(i,:), Family{j}, Dev(i,:));
        %fprintf(fid, '%2d %7.3f %s %s(%d,%d)\n', i, Pos(i), MonChanName(i,:), Family{j}, Dev(i,:));
    end
    fprintf(fid, '\n');
end
fclose(fid);
fprintf('   Data written to %s\n',[DirectoryName, 'SRBPM.txt']);
