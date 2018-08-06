function cc_gun
% CC_GUN - "Compiles" all the gun applications to run standalone

% Starting directory
DirStart = pwd;

% Compile application
cc_standalone('apexmain');
%cc_standalone('machineconfig');
%cc_standalone('plotfamily');
%cc_standalone('viewfamily');
%cc_standalone('mmlviewer');
%cc_standalone('locogui');


cd(DirStart);
