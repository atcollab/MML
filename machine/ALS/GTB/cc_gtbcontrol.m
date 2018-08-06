function cc_gtbcontrol
% CC_GTBCONTROL - "Compiles" the gtbcontrol application to run standalone

DirStart = pwd;
gotocompile('GTB');
cc_standalone('gtbcontrol');
cd(DirStart);

