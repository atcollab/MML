function cc_imageviewer
% CC_IMAGEVIEWER - "Compiles" the gtbcontrol application to run standalone

DirStart = pwd;
gotocompile('Common');
cc_standalone('imageviewer');
cd(DirStart);

