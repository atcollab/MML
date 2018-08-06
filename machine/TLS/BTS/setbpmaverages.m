function setbpmaverages(N)
%SETBPMAVERAGES - Sets the BPM sampling period [second]
%  setbpmaverages(T)
%  T = Data collection period of the BPMs in seconds
%
%  In Simlutor mode, nothing is set


Mode = getfamilydata('BPMx','Monitor','Mode');
if ~strcmpi(Mode,'Simulator')
    error('setbpmaverages.m must be modified for online use.');
end