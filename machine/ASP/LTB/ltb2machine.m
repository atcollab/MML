%% ltb2machine
% This script will use SETSP to set the LTB quadrupoles on the
% machine to the values in the model.
%
% Eugene Tan  2006-08-21

%% initialise the lattice variables
global THERING LTB

if isempty(THERING) || isempty(THERING)
    error('global variable THERING or LTB not loaded. Please run asboosterinit again');
end

q_ind = getfamilydata('LTB_Q','AT','ATIndex');
q_vals = getcellstruct(LTB,'K',q_ind);
setsp('LTB_Q',q_vals,'Physics');

clear q_ind q_vals;