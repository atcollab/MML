function setbpmaverages(N)
%SETBPMAVERAGES - Sets the number of BPM averages
%  setbpmaverages(N)
%  N = Number of the BPMs in averages
%      The Micro does averaging in increments of 16, so 
%      N must also be a multiple of 16.  If N is not a 
%      multiple of 16, the next high multiple will be used.


Mode = getfamilydata('BPMx','Monitor','Mode');
if ~strcmpi(Mode,'Simulator')
    % MICRO does 16 averages
    Nmicro = ceil(N / 16);
    if mod(N, 16) ~= 0 
        fprintf('   Micro does averaging in increments of 16\n');
        fprintf('   Input averaging has been changed to %d\n', Nmicro * 16);
    end
    setam('uorbitav:sp', Nmicro);
end