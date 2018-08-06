function rampto1p5
%rampto1p5 - Ramp to 1.5 GeV and Load the Production Lattice


if ~strcmpi(getfamilydata('OperationalMode'), '1.9 GeV, TopOff')
    fprintf('\n   This function only works from the TopOff operational mode.\n   Run setoperationalmode(1), then rampto1p5.\n\n');
    return
end

% I'm assuming the lattice probably has the 1.9 GeV injection lattice

% Load the production lattice before ramping
if getenergy > 1.8
    fprintf('   Loading the 1.9 GeV production lattice before ramping\n');
    setmachineconfig('Golden','NoDisplay');
end

% Ramp to 1.522 GeV
fprintf('   Ramping to 1.522 GeV\n');
srramp(1.522);

% Load 1.5 GeV Production lattice
fprintf('   Loading the 1.5 GeV production lattice\n');
setmachineconfig('/home/als/physbase/machine/ALS/StorageRingOpsData/1_5HighTune/GoldenConfig_15HighTune.mat','NoDisplay');

fprintf('   Lattice is ready for 1.5 GeV operations.\n');
