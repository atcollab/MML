function mov2sim

% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/mov2sim.m 1.2 2007/03/02 09:03:11CST matiase Exp  $
% ----------------------------------------------------------------------------------------------


HCMsp = getsp('HCM');
setsp('HCM',HCMsp,'Simulator');

QFAsp = getsp('QFA');
setsp('QFA',QFAsp,'Simulator');


QFBsp = getsp('QFB');
setsp('QFB',QFBsp,'Simulator');

QFCsp = getsp('QFC');
setsp('QFC',QFCsp,'Simulator');

VCMsp = getsp('VCM');
setsp('VCM',VCMsp,'Simulator');

BENDsp = getsp('BEND');
setsp('BEND',BENDsp,'Simulator');


fprintf('Completed \n')

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/mov2sim.m  $
% Revision 1.2 2007/03/02 09:03:11CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
