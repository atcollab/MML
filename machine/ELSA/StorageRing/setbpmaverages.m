function setbpmaverages(N)
%SETBPMAVERAGES - Sets the number of BPM averages
%  setbpmaverages(N)
%  N = Number of the BPMs in averages
%      The Micro does averaging in increments of 16, so 
%      N must also be a multiple of 16.  If N is not a 
%      multiple of 16, the next high multiple will be used.


Mode = getfamilydata('BPMx','Monitor','Mode');
if ~strcmpi(Mode,'Simulator')
    % ???
end