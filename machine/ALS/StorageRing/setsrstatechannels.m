function setsrstatechannels


if strcmpi(getmode(gethbpmfamily), 'Online')

    OpsDirectory = getfamilydata('Directory', 'OpsData');

    %Update database channels
    %setpv('SR_LATTICE_FILE','','String');    % Don't change here (srload)
    %setpv('SR_STATE',0);                     % Don't change here (srcontrolfn)

    setpv('SR_ENERGY',           getfamilydata('Energy'));
    setpv('SR_ENERGY_INJECTION', getfamilydata('InjectionEnergy'));
    % setpv('SR_PRODUCTION_FILE', [OpsDirectory, getfamilydata('OpsData', 'LatticeFile')], 'String');
    % setpv('SR_INJECTION_FILE',  [OpsDirectory, getfamilydata('OpsData', 'InjectionFile')], 'String');
    % setpv('SR_RAMP_UP_FILE',    [OpsDirectory,'alsrampup'], 'String');
    % setpv('SR_RAMP_DOWN_FILE',  [OpsDirectory,'alsrampdown'], 'String');
    % setpv('SR_MASTER_RAMP_FILE', 'rampmastup.txt', 'String');
    % setpv('SR_GOLDEN_PAGE_FILE',[OpsDirectory,'GoldenPage'], 'String');
    % setpv('SR_DATA_DIRECTORY',  [OpsDirectory], 'String');

    % setpv above doesn't work for strings yet, but below is limited to 39 characters

    % scaputstring('SR_PRODUCTION_FILE', [OpsDirectory, getfamilydata('OpsData', 'LatticeFile')]);
    % scaputstring('SR_INJECTION_FILE',  [OpsDirectory, getfamilydata('OpsData', 'InjectionFile')]);
    % scaputstring('SR_RAMP_UP_FILE',    [OpsDirectory,'alsrampup']);
    % scaputstring('SR_RAMP_DOWN_FILE',  [OpsDirectory,'alsrampdown']);
    % scaputstring('SR_MASTER_RAMP_FILE', 'rampmastup.txt');
    % scaputstring('SR_GOLDEN_PAGE_FILE',[OpsDirectory,'GoldenPage']);
    % scaputstring('SR_DATA_DIRECTORY',  [OpsDirectory]);

    GoldenTune = getgolden('TUNE');
    setpv('SR_GOLDEN_TUNE_X',GoldenTune(1));
    setpv('SR_GOLDEN_TUNE_Y',GoldenTune(2));

    GoldenChromaticity = getgolden('Chromaticity');
    setpv('SR_GOLDEN_CHROMATICITY_X',GoldenChromaticity(1));
    setpv('SR_GOLDEN_CHROMATICITY_Y',GoldenChromaticity(2));


    % Obsolete
    %setpv('SR_MODE_FILE',GLOBAL_SR_MODE_FILE, 'String'); e
    %setpv('SR_SMATRIX_FILE',     GLOBAL_SR_SMATRIX_FILE, 'String');
end
