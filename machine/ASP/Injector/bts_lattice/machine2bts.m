%% machine2bts
% This script will use getmachineconfig to retreave the setpoints from
% the machine and apply it to the BTS model. This of course only applies to
% the quadrupoles.
%
% Mark Boland 2006-08-14
% Eugene Tan  2006-08-21: Modified to incorporate changed to asboosterinit
%                         and to use getmachineconfig.

%% initialise the lattice variables
global THERING BTS

if isempty(THERING) || isempty(BTS)
    error('global variable THERING or BTS not loaded. Please run asboosterinit again');
end

machinesp = getmachineconfig('BTS_Q','Physics');
q_ind = getfamilydata('BTS_Q','AT','ATIndex');
BTS = setcellstruct(BTS,'PolynomB',q_ind,machinesp.BTS_Q.Setpoint.Data,2);
BTS = setcellstruct(BTS,'K',q_ind,machinesp.BTS_Q.Setpoint.Data);

clear machinesp q_ind;