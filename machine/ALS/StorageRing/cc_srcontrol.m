function cc_srcontrol
% CC_SRCONTROL - "Compiles" the srcontrol application to run standalone

DirStart = pwd;
gotocompile('StorageRing');
cc_standalone('srcontrol');
cd(DirStart);

