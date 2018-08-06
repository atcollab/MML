function aoinit(SubMachineName)
%AOINIT - Initialization function for the Matlab Middle Layer (MML)
 

% Include all the MML paths for machine types
MMLROOT = getmmlroot;

% orbit
addpath(fullfile(MMLROOT, 'applications', 'orbit'), '-begin');
addpath(fullfile(MMLROOT, 'applications', 'orbit', 'aspbooster'), '-begin');
addpath(fullfile(MMLROOT, 'applications', 'orbit', 'lib'), '-begin');


% Add the paths for the LTB and BTS tools and lattices
DirectoryName = fileparts(mfilename('fullpath'));
addpath(fullfile(DirectoryName,'ltb_lattice'),'-begin');
addpath(fullfile(DirectoryName,'bts_lattice'),'-begin');

% Make Injector first on the path
addpath(DirectoryName,'-begin');


injectorinit;
