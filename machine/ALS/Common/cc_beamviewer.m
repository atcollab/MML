function cc_beamviewer
% CC_BEAMVIEWER - "Compiles" the beamviewer application to run standalone

DirStart = pwd;
gotocompile('Common');
cc_standalone('beamviewer');
cc_standalone('imageviewer');
cc_standalone('bl31image');
cd(DirStart);