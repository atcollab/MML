function cc_waveforms
% CC_WAVEFORMS - "Compiles" the waveform applications to run standalone
%


DirStart = pwd;
gotocompile('StorageRing');
cc_standalone('als_waveforms');
%cc_standalone('brscopesnew');
cd(DirStart);
