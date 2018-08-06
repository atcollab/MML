function zerocorrectors
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/zerocorrectors.m 1.2 2007/03/02 09:18:05CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
 for j=1:48
     setpv('HCM','Setpoint',0, j);
 end
 for j=1:48
     setpv('VCM','Setpoint',0, j);
 end
 
 fprintf('SR correctors zero''d Completed \n');

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/zerocorrectors.m  $
% Revision 1.2 2007/03/02 09:18:05CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
