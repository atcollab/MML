function cc_beamviewer
% CC_BEAMVIEWER - "Compiles" the beamviewer application to run standalone

% Starting directory
DirStart = pwd;

gotocompile('Gun');

% Compile application
cc_standalone('beamviewer');

cd(DirStart);
