function cc_bcmdisplay
% CC_BCMDISPLAY - "Compiles" the bunch current monitor application to run standalone

DirStart = pwd;
gotocompile('StorageRing');
cc_standalone('bcmdisplay');
cd(DirStart);

