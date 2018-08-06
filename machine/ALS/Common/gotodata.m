function Directory = gotodata
%GOTODATA - Change directory to the root of the data directory tree 
%  Directory = gotodata

Directory = getfamilydata('Directory','DataRoot');
cd(Directory);

