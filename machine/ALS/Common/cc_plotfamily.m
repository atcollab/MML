function cc_plotfamily
% CC_PLOTFAMILY - "Compiles" the plotfamily application to run standalone

DirStart = pwd;
gotocompile;

% % For testing
% cd ..
% cd test

cc_standalone('plotfamily');
cd(DirStart);


