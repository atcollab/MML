%% ltb2machine
% This script will use SETSP to set the LTB quadrupoles on the
% machine to the values in the model.
%
% Eugene Tan  2006-08-21

%% initialise the lattice variables
% Change the THERING to the BTS
getam('LTB_BEND','Model');

global THERING

q_ind = getfamilydata('LTB_Q','AT','ATIndex');
q_vals = getcellstruct(THERING,'K',q_ind);
setsp('LTB_Q',q_vals,'Physics');

clear q_ind q_vals;