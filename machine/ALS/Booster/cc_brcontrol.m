function cc_brcontrol
% CC_BRCONTROL - "Compiles" the brcontrol application to run standalone

DirStart = pwd;
gotocompile('Booster');
cc_standalone('brcontrol');
cd(DirStart);
