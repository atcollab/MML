function machine2sim(ZeroCMFlag)
%MACHINE2SIM - loads online machine configuration to AT configuration
%  machine2sim(ZeroCMFlag)
%
%  ZeroCMFlag = 0 set the machine corrector setting to the simulator
%               1 zero the correctors in the simulator {Default}
%
%  NOTES
%  1. The RF frequency of the simulator is not changed
%  2. Use ZeroCMFlag = 1 when you think the corrector magnets on the 
%     online machine are restoring the orbit to the design orbit (or close)
%
%  See also sim2machine, golden2sim

%  Written by Greg Portmann 


if nargin < 1
    ZeroCMFlag = 1;
end


% Get from the online machine
ConfigSetpoint = getmachineconfig('Online');


% Set to the simulator (don't change the simulator RF)
if isfamily('RF')
    RFsim = getam('RF', 'Simulator');
end
if isfamily('RF')
    setmachineconfig(ConfigSetpoint, 'Simulator');
    setsp('RF', RFsim, 'Simulator');
end

if ZeroCMFlag
    setsp(gethcmfamily, 0, 'Simulator');
    setsp(getvcmfamily, 0, 'Simulator');
end

