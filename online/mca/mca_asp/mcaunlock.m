function mcaunlock;
%MCAUNLOCK unlocks the MCAMAIN mex-file so that
% it can be cleared from memory with CLEAR
%
% MCAMAIN starts in a locked state 
% to protect from it from being 
% accidentally cleared and
% loosing channel access connections.
mca(0);
disp('mca mex-file is now UNLOCKED');