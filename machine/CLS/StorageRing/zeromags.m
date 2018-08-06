function zeromags
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/zeromags.m 1.2 2007/03/02 09:17:22CST matiase Exp  $
% ----------------------------------------------------------------------------------------------

setpv('QFA','Setpoint',0);
setpv('QFB','Setpoint',0);
setpv('QFC','Setpoint',0);
setpv('BEND','Setpoint',0);

zerocorrectors;

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/zeromags.m  $
% Revision 1.2 2007/03/02 09:17:22CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
