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
    
    % Libera update period, T, should be around 0.1 s but for added
    % security we'll use something larger. This value is important as the
    % use of WaitFlags = -2 will use this time period to wait for the BPMs
    % to update with new data.
    T = 0.2;
    % N is supposed to signify how many samples are averaged over to get
    % the resulting BPM position. With Liberas this is not so clear cut so
    % for now will use 5000.
    % 27-07-2006 Eugene
    N = 5000;
    
end
