function [Yresp] = getYclsresp
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/getrclsresp.m 1.2 2007/03/02 09:02:59CST matiase Exp  $
% ----------------------------------------------------------------------------------------------

tempY = [];
Yresp = [];
tempYmon = [];
initYCor = getsp('VCM');

for i=1:48
    fprintf('measuring Vertical element %d\n',i);
    tempYmon = gety;
    pause 1.0
    setpv('VCM','Setpoint',initYCor(i) + 500000,i);
    pause 2.0
    %get current Row only
    Yresp(i) = tempYmon - gety;
    %set corrector back to original setting
    setpv('VCM','Setpoint',initYCor(i),i);
    pause 2.0
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/getrclsresp.m  $
% Revision 1.2 2007/03/02 09:02:59CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
