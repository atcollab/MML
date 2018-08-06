function [N, T] = getbpmaverages(DeviceList)
%GETBPMAVERAGES - Gets the BPM averages
% [N, T] = getbpmaverages
%  N = Number of averages
%  T = Sampling period after averaging [seconds]
%
%  In Simlutor mode, N = 1 and T = 0


Mode = getfamilydata(gethbpmfamily, 'Monitor', 'Mode'); 


if strcmpi(Mode,'Simulator')
    N = 1;
    T = 0;
else
    AD = getad;
    N = AD.SIRIUSParams.bpm_nr_points_average;
    T = AD.SIRIUSParams.control_system_update_period;
end

