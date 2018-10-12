function [N, T] = getbpmaverages(varargin)
%GETBPMAVERAGES - Gets the BPM averages
% [N, T] = getbpmaverages
%  N = Number of averages
%  T = Sampling period after averaging [seconds]
%
%  In Simlutor mode, N = 1 and T = 0
%
% This is used by MML to determine the delays required for fresh BPM data.

Mode = getfamilydata('BPMx','Monitor','Mode');
if strcmpi(Mode,'Simulator')
    
    N = 1;
    T = 0;
    
else
    
    % Libera update period, T, should be around 0.1 s but for added
    % security we'll use something larger. This value is important as the
    % use of WaitFlags = -2 will use this time period to wait for the BPMs
    % to update with new data.
    % changed to 0.1 from 0.3 ET 02-11-2009
    % Changed back from 0.1 to 0.3 ET 03/02/2017
    T = 0.3;
    % N is supposed to signify how many samples are averaged over to get
    % the resulting BPM position. With Liberas this is not so clear cut so
    % for now will use 5000.
    % 27-07-2006 Eugene
    N = 5000;
    
end
