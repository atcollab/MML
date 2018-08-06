function setQk
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/setQk.m 1.2 2007/03/02 09:17:58CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
x=hw2physics('QFA', 'Setpoint', getsp('QFA'));
x1=mean(x)*ones(24,1)
x=physics2hw('QFA','Setpoint',x1)
setpv('QFA','Setpoint',x)

x=hw2physics('QFB', 'Setpoint', getsp('QFB'));
x1=mean(x)*ones(24,1)
x=physics2hw('QFB','Setpoint',x1)
setpv('QFB','Setpoint',x)

x=hw2physics('QFC', 'Setpoint', getsp('QFC'));
x1=mean(x)*ones(24,1)
x=physics2hw('QFC','Setpoint',x1)
setpv('QFC','Setpoint',x)

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/setQk.m  $
% Revision 1.2 2007/03/02 09:17:58CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
