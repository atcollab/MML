function rampto1p9
%rampto1p9 - Ramp to 1.9 GeV and Load the Injection Lattice


if ~strcmpi(getfamilydata('OperationalMode'), '1.9 GeV, TopOff')
    fprintf('\n   This function only works from the TopOff operational mode.\n   Run setoperationalmode(1), then rampto1p5.\n\n');
    return
end


% Ramp to 1.9 GeV
fprintf('   Ramping to 1.9 GeV\n');
srramp(1.89086196873342);

% Load the 1.9 injection lattice
fprintf('   Loading the 1.9 GeV injection lattice\n');
setmachineconfig('Injection','NoDisplay');

fprintf('   Lattice is ready for injection at 1.9 GeV.\n');
