function cc_graphit
% CC_GRAPHIT - "Compiles" the graphit applications to run standalone

DirStart = pwd;
gotocompile;

% For testing
%cd ..
%cd test

cc_standalone('graphit');
cc_standalone('graphit_bpm');
cc_standalone('graphit_aa');
cc_standalone('graphit_bpm_aa');

cd(DirStart);


