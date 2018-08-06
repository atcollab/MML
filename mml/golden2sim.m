function golden2sim(ZeroCMFlag)
%GOLDEN2SIM - loads online machine configuration to AT configuration
%  golden2sim(ZeroCMFlag)
%
%  ZeroCMFlag = 0 set the machine corrector setting to the simulator
%               1 zero the correctors in the simulator {Default}
%
%  NOTES
%  1. The RF frequency of the simulator is not changed
%  2. Use ZeroCMFlag = 1 when you think the corrector magnets on the 
%     online machine are restoring the orbit to the design orbit (or close)
%
%  See also machine2sim, sim2machine

%  Written by Greg Portmann 


if nargin < 1
    ZeroCMFlag = 1;
end


% Get from the golden config
FileName = getfamilydata('OpsData', 'LatticeFile');
DirectoryName = getfamilydata('Directory', 'OpsData');
load([DirectoryName FileName]);


% Set to the simulator (don't change the simulator RF)
RFsim = getam('RF','Simulator');
setmachineconfig(ConfigSetpoint, 'Simulator');
setsp('RF', RFsim, 'Simulator');

if ZeroCMFlag
    setsp(gethcmfamily, 0, 'Simulator');
    setsp(getvcmfamily, 0, 'Simulator');
end

