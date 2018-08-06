function cc_bts
% CC_BTS - "Compiles" all the BTS applications to run standalone

DirStart = pwd;
gotocompile('BTS');
cc_standalone('btscontrol');
cc_standalone('machineconfig');
cc_standalone('plotfamily');
cc_standalone('viewfamily');
cd(DirStart);
