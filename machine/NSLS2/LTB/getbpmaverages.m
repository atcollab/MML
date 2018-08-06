function [N, T] = getbpmaverages(DeviceList)
%GETBPMAVERAGES - Gets the BPM averages
% [N, T] = getbpmaverages
%  N = Number of averages
%  T = Sampling period after averaging [seconds]
%
%  In Simlutor mode, N = 1 and T = 0


Mode = getfamilydata('BPMx','Monitor','Mode');

if strcmpi(Mode,'Simulator')
    
    N = 1;
    T = 0;
    
else
    
    fprintf('   Edit getbpmaverages to set the averaging properly when online!!!!\n');
    N = 1;
    T = 2;  % BPM update period [seconds]
    
end

