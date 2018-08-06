function cc_imageviewer
% CC_IMAGEVIEWER - "Compiles" the imageviewer application to run standalone

DirStart = pwd;
gotocompile('Common');
cc_standalone('imageviewer');
%cc_standalone('bl31image');
cd(DirStart);

