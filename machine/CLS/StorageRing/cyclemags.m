 function cyclemags
%CYCLEMAGS - cycle all of the BTS and SR magnets 
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/cyclemags.m 1.3 2007/03/05 07:58:21CST matiase Exp  $
% ----------------------------------------------------------------------------------------------
% Description:
%   This matlab function should not be used.  The correctors  and quads are
%   in banks and must be cycled, in sequence.  
% ----------------------------------------------------------------------------------------------
%
fprintf('Magnet cycling is not available within Matlab, use the EPICS function \n');

%set all correctors to zero
%setpv('HCM','Setpoint',0);
%setpv('VCM','Setpoint',0);

%fprintf('Setting main magnets to their MAX settings\n');
%set quads, dipoles and sextapoles to their max settings and wait
%setpv('QFA','Setpoint',4500000);
%setpv('QFB','Setpoint',8388607);
%setpv('QFC','Setpoint',8388607);
%setpv('BEND','Setpoint',5870146);

%setpv('HCM','Setpoint',7602176);
%setpv('VCM','Setpoint',7602176);

%pause(20);

%set quads, dipoles and sextapoles to their min settings and wait
%fprintf('Setting main magnets to their MIN settings\n');
%setpv('QFA','Setpoint',0);
%setpv('QFB','Setpoint',0);
%setpv('QFC','Setpoint',0);
%setpv('BEND','Setpoint',0);

%setpv('HCM','Setpoint',0);
%setpv('VCM','Setpoint',0);


%pause(20);

%fprintf('Setting main magnets to their MAX settings\n');
%set quads, dipoles and sextapoles to their max settings and wait
%setpv('QFA','Setpoint',4500000);
%setpv('QFB','Setpoint',8388607);
%setpv('QFC','Setpoint',8388607);
%setpv('BEND','Setpoint',5870146);

%setpv('HCM','Setpoint',7602176);
%setpv('VCM','Setpoint',7602176);

%pause(20);

%set quads, dipoles and sextapoles to their min settings and wait
%fprintf('Setting main magnets to their MIN settings\n');
%setpv('QFA','Setpoint',0);
%setpv('QFB','Setpoint',0);
%setpv('QFC','Setpoint',0);
%setpv('BEND','Setpoint',0);

%setpv('HCM','Setpoint',0);
%setpv('VCM','Setpoint',0);

fprintf('Cycle complete\n');

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/cyclemags.m  $
% Revision 1.3 2007/03/05 07:58:21CST matiase 
% Cycling magnets this way is not good for the power supply, commented out the code and
% added a message for the use running it.  Once the power supply upgrade is complete we
% can revisit.
% Revision 1.2 2007/03/02 09:03:09CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
