function Directory = gotobase
%GOTOBASE - Change directory to the sub-machine directory 
%  Directory = gotobase

Directory = fullfile(getmmlroot, 'machine', filesep, getfamilydata('Machine'), getfamilydata('SubMachine'), filesep);
cd(Directory);


