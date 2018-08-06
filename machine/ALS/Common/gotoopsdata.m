function Directory = gotoopsdata
%GOTOOPSDATA - Change directory to the Low Emittance Ops directory 
%  Directory = gotoopsdata

% Directory = fullfile(getmmlroot, 'machine', filesep, getfamilydata('Machine'), [getfamilydata('SubMachine') 'OpsData'], filesep, 'LowEmittance', filesep);
Directory = getfamilydata('Directory','OpsData');
cd(Directory);


