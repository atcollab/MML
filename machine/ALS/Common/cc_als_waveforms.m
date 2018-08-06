function cc_als_waveforms
% CC_ALS_WAVEFORMS - "Compiles" the ALS waveform applications to run standalone
%

if strcmpi(getfamilydata('SubMachine'), 'GTB')
    DirStart = pwd;
    %gotocompile('StorageRing');
    gotocompile('GTB');
    cc_standalone('als_waveforms');
    %cc_standalone('brscopesnew');
    cd(DirStart);
    
else
    fprintf('   Please run cc_als_waveforms with the MML configured to GTB (setpathals(''GTB'')).\n');
    fprintf('   It will start a lot faster!!!\n');
end
