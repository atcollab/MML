function srinit
% This function sets up a bunch of storage ring parameters
%

BPMNumAverages = 16*16;


% Set the BPM averaging
setbpmavg(BPMNumAverages);
fprintf('  BPM averaging set to %d\n', BPMNumAverages);



% QD shunts off
%fprintf('  Switch QD shunts off...\n');
%setqfashunt(1, 0);

