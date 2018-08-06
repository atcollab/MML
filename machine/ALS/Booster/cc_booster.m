function cc_booster
% CC_BOOSTER - "Compiles" all the booster ring applications to run standalone

DirStart = pwd;
gotocompile('Booster');
cc_standalone('plot_booster_injection_newbpm');
cc_standalone('brcontrol');
cc_standalone('brwaveforms');
cc_standalone('machineconfig');
cc_standalone('plotfamily');
cc_standalone('viewfamily');
cd(DirStart);
