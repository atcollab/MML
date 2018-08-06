function cc_apex
% CC_APEX - "Compiles" all the APEX applications to run standalone

% Starting directory
DirStart = pwd;

gotocompile('Gun');

% Compile application
%cc_standalone('apexlab');

%!rm llrf
%pause(.5);

%cc_standalone('llrf');
%cc_standalone('llrf_buncher');
cc_standalone('llrf_linac');
cc_standalone('beamviewer');
cc_standalone('imageviewer');

%cc_standalone('llrf_reflect_trip');
%cc_standalone('LbandPhaseShAttnControlWindow');

%cc_standalone('machineconfig');
%cc_standalone('plotfamily');
%cc_standalone('viewfamily');
%cc_standalone('mmlviewer');

cd(DirStart);
