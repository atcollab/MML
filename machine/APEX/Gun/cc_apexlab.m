function cc_apexmain
% CC_GUN - "Compiles" all the gun applications to run standalone

% Starting directory
DirStart = pwd;

gotocompile('Gun');

% Compile application
cc_standalone('apexlab');

%cc_standalone('llrf');


%cc_standalone('machineconfig');
%cc_standalone('plotfamily');
%cc_standalone('viewfamily');
%cc_standalone('mmlviewer');
%cc_standalone('locogui');


cd(DirStart);
