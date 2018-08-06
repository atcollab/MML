function sethcmslow(nstep)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/sethcmslow.m 1.2 2007/03/02 09:17:48CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
%sethcmslow(nstep)
% ----------------------------------------------------------------------------------------------

hcm = getdata('HCM');

if nargin < 1
    nstep = 15;
end


HCM0 = getsp('HCM');

for k=1:nstep
    setsp('HCM', HCM0 + k/nstep * (hcm-HCM0), [], -1);
    pause(0.2);
end

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/sethcmslow.m  $
% Revision 1.2 2007/03/02 09:17:48CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
