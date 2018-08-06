function sweepkickerdelay(Delay, N)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/sweepkickerdelay.m 1.2 2007/03/02 09:17:33CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%SWEEPKICKERDELAY - Sweeps the kicker delay 
%
%  sweepkickerdelay(Delay, N)  
% 
%  Delay in nanoseconds
%  N = number of steps {default: 30}
% ----------------------------------------------------------------------------------------------

k = getkickerdelay;

if ~length(Delay) == 1
    error('Delay must be a scalar');
end
if nargin < 2
    N = 30;
end

k = getkickerdelay;

%setkickerdelay(k-Delay/2);
%N = 100;

for i = 1:N
    setkickerdelay(k - i * Delay ); 
    pause(1.5);
end

setkickerdelay(k);

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/sweepkickerdelay.m  $
% Revision 1.2 2007/03/02 09:17:33CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
