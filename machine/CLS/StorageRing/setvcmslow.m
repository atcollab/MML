function setvcmslow(nstep)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/setvcmslow.m 1.2 2007/03/02 09:17:44CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%setvcmslow(nstep)

vcm = getdata('VCM');

if nargin < 1
    nstep = 15;
end


VCM0 = getsp('VCM');

for k=1:nstep
    setsp('VCM', VCM0 + k/nstep * (vcm-VCM0), [], -1);
    pause(0.2);
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/setvcmslow.m  $
% Revision 1.2 2007/03/02 09:17:44CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
