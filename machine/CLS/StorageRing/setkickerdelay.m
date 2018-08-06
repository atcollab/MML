function setkickerdelay(Delay)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/setkickerdelay.m 1.2 2007/03/02 09:17:37CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%SETKICKERDELAY - Sets the kicker delay for the 4 injection magnets (absolute) 
%
%  setkickerdelay(Delay)  
% 
%  Delay is a scalar or 4 element vector of delays in nanoseconds
% ----------------------------------------------------------------------------------------------

if length(Delay) == 1
    Delay = ones(4,1)*Delay;
elseif  length(Delay) == 4
    % Input ok
else
    error('Delay must be a vector with 1 or 4 elements');
end

setpv('K1412-01:delay:ns', Delay(1));
setpv('K1401-01:delay:ns', Delay(2));
setpv('K1401-02:delay:ns', Delay(3));
setpv('K1402-01:delay:ns', Delay(4));

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/setkickerdelay.m  $
% Revision 1.2 2007/03/02 09:17:37CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
