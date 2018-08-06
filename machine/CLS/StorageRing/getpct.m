function getpct

% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/getpct.m 1.1 2007/07/05 12:52:28CST Tasha Summers (summert) Exp  $
% ----------------------------------------------------------------------------------------------

[h numopen] = mcagethandle('PCT1402-01:mA:fbk');
if numopen == 0
     hPct = mcaopen('PCT1402-01:mA:fbk');
     if hPct == 0
         error(['Problem opening a channel to : PCT1402-01:mA:fbk']);
     end
 else
     hPct = h(1);
 end		

valPct=mcaget(hPct);
fprintf('%6.4f \n',valPct);

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/getpct.m  $
% Revision 1.1 2007/07/05 12:52:28CST Tasha Summers (summert) 
% Initial revision
% Member added to project e:/Projects/matlab/project.pj
% ----------------------------------------------------------------------------------------------