function Directory = cdmachine
%CDMACHINE - Change directory to the sub-machine directory 
%  Directory = cdmachine

Directory = fullfile(getmmlroot, 'machine', filesep, getfamilydata('Machine'), getfamilydata('SubMachine'), filesep);
cd(Directory);


