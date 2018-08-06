function Directory = cdopsdata
%CDOPSDATA - Change to the MML operational data directory
%  Directory = cdopsdata

Directory = getfamilydata('Directory', 'OpsData'); 
cd(Directory);

