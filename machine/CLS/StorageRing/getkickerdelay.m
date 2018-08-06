function k = getkickerdelay
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/getkickerdelay.m 1.2 2007/03/02 09:03:07CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%GETKICKERDELAY - Returns the 4 injection kicker delays  
% ----------------------------------------------------------------------------------------------
%  k = getkickerdelay 

k(1,1) = getpv('K1412-01:delay:ns');
k(2,1) = getpv('K1401-01:delay:ns');
k(3,1) = getpv('K1401-02:delay:ns');
k(4,1) = getpv('K1402-01:delay:ns');


% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/getkickerdelay.m  $
% Revision 1.2 2007/03/02 09:03:07CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
