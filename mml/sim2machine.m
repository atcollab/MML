function sim2machine
%SIM2MACHINE - Sets the AT configuration to the online machine
%
%  Equivalent to:
%  ConfigSetpoint = getmachineconfig('Simulator');
%  setmachineconfig(ConfigSetpoint, 'Online');
%
%  See also machine2sim, golden2sim

%  Written by Greg Portmann 


% Get from the simulator
ConfigSetpoint = getmachineconfig('Simulator');


tmp = questdlg({ ...
        'sim2machine was change all the lattice magnet setpoints', ...
        ' ', ...
        'Are you sure you want to do this?'}, ...
    'SIM2MACHINE','YES','NO','NO');

if strcmpi(tmp,'YES')
    % Set from the online machine
    setmachineconfig(ConfigSetpoint, 'Online');
else
    fprintf('   No change made to the lattice.\n');
    return
end

