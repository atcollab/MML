function cc_epbi
% CC_EPBI - "Compiles" the EPBI applications to run standalone

DirStart = pwd;
gotocompile;

cc_standalone('epbitest2');
cc_standalone('epbitest3');

cd(DirStart);


