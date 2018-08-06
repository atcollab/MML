function setbpmaverages(N)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/setbpmaverages.m 1.2 2007/03/02 09:18:04CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%SETBPMAVERAGES - Sets the BPM sampling period [second]
%  setbpmaverages(T)
%  T = Data collection period of the BPMs in seconds
%
%  In Simlutor mode, nothing is set
% ----------------------------------------------------------------------------------------------


Mode = getfamilydata('BPMx','Monitor','Mode');
if ~strcmpi(Mode,'Simulator')
    error('setbpmaverages.m must be modified for online use.');
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/setbpmaverages.m  $
% Revision 1.2 2007/03/02 09:18:04CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
