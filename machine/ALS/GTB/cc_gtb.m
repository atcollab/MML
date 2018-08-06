function cc_gtb
% CC_GTB - "Compiles" all the GTB applications to run standalone

DirStart = pwd;
gotocompile('GTB');
cc_standalone('gtbcontrol');
cc_standalone('machineconfig');
cc_standalone('als_waveforms');
cc_standalone('plotfamily');
cc_standalone('viewfamily');
cd(DirStart);
