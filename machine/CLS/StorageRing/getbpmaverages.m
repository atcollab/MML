function [N, T] = getbpmaverages
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/getbpmaverages.m 1.2 2007/03/02 09:02:39CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
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
    N = 1;
    T = 2;
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/getbpmaverages.m  $
% Revision 1.2 2007/03/02 09:02:39CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
