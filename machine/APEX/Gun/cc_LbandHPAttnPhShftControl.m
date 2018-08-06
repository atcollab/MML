function cc_LbandHPAttnPhShftControl
% CC_APEX - "Compiles" all the APEX applications to run standalone

% Starting directory
DirStart = pwd;

gotocompile('Gun');

% Compile application
%cc_standalone('apexlab');

%!rm llrf
%pause(.5);

cc_standalone('LbandPhaseShAttnControlWindow');

%cc_standalone('machineconfig');
%cc_standalone('plotfamily');
%cc_standalone('viewfamily');
%cc_standalone('mmlviewer');

cd(DirStart);
