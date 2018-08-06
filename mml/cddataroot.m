function Directory = cddataroot
%CDDATAROOT - Change to the MML data directory
%  Directory = cddataroot

Directory = getfamilydata('Directory', 'DataRoot'); 
cd(Directory);

