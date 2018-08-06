function [N, T] = getbpmaverages(DeviceList)
%GETBPMAVERAGES - Gets the BPM averages and sampling period
% [N, T] = getbpmaverages
%  N = Number of averages
%  T = Sampling period after averaging [seconds]
%
%  In Simlutor mode, N = 1 and T = 0

%  Written by Greg Portmann

Mode = getfamilydata(gethbpmfamily, 'Monitor', 'Mode'); 

if strcmpi(Mode,'Simulator')
    
    N = 1;
    T = 0;
    
else
    
	% 1 Hertz injector, no averaging
    N = 1;
    T = 0;
    
end

