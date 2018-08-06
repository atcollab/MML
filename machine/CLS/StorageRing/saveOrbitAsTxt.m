function [Xorbit,Yorbit] = saveOrbitAsTxt
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/saveOrbitAsTxt.m 1.2 2007/03/02 09:17:40CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%this script will grab the current verticalorbit and write it out to the
%specified disk file in text format
% ----------------------------------------------------------------------------------------------

Xorbit = getx;
Yorbit = gety;

FileName = getfamilydata('Default','BPMArchiveFile');
DirectoryName = getfamilydata('Directory','BPMData');
FileName = appendtimestamp(FileName, clock);
[FileName, DirectoryName] = uiputfile('*.txt','Create orbit text File', [DirectoryName FileName]);

if FileName == 0 
    fprintf('   File not saved (saveOrbitAsTxt)\n');
    return;
end
[DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);
filename = [];
filename = sprintf('%s.txt',FileName);
fid = fopen(filename,'w');
%get current orbit
fprintf(fid,'Horizontal\t\t\tVertical\n');
if(fid > 0)
	for i=1:length(Xorbit)
        fprintf(fid,'%f\t\t\t%f\n',Xorbit(i),Yorbit(i));
	end
    fprintf('orbit stored to > %s%s \n',DirectoryName,filename);
    fclose(fid);
else
    fprintf('Unable to open the specified output file> %s \n',filename);
end    

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/saveOrbitAsTxt.m  $
% Revision 1.2 2007/03/02 09:17:40CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
