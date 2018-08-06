%% machine2ltb
% This script will use getmachineconfig to retreave the setpoints from
% the machine and apply it to the LTB model. This of course only applies to
% the quadrupoles.
%
% Mark Boland 2006-08-14
% Eugene Tan  2006-08-21: Modified to incorporate changed to asboosterinit
%                         and to use getmachineconfig.

%% initialise the lattice variables
global THERING LTB

if isempty(THERING) || isempty(THERING)
    error('global variable THERING or LTB not loaded. Please run asboosterinit again');
end

machinesp = getmachineconfig('LTB_Q','Physics');
q_ind = getfamilydata('LTB_Q','AT','ATIndex');
LTB = setcellstruct(LTB,'PolynomB',q_ind,machinesp.LTB_Q.Setpoint.Data,2);
LTB = setcellstruct(LTB,'K',q_ind,machinesp.LTB_Q.Setpoint.Data);

clear machinesp q_ind;

%% plot the new lattice
% figure(113)
% clf
figure
plotltb