%% bts2machine
% This script will use SETSP to set the BTS quadrupoles on the
% machine to the values in the model.
%
% Eugene Tan  2006-08-21

%% initialise the lattice variables
global THERING

% Switch THERING to the BTS
getam('BTS_BEND','Model');

q_ind = getfamilydata('BTS_Q','AT','ATIndex');
q_vals = getcellstruct(THERING,'K',q_ind);
setsp('BTS_Q',q_vals,'Physics');

clear q_ind q_vals;