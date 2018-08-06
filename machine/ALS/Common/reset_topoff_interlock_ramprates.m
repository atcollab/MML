% reset_topoff_interlock_ramprates
%
% This routine sets all ramprates of power supplies interlocked 
% for topoff back to normal operations.
%
% Christoph Steier, 2008

% Interlocked magnets are Storage Ring Bend, 3 Superbends, 
% all 4 SR QFAs, SR SF+SD, as well as the booster bend (however, 
% the booster bend is not set below, since it has a completely
% different control and is not tested in the same way.

disp('Setting SR BEND magnet ramprate to 10.5 A/s');
setpv('SR01C___B______AC03.DRVH',10.5);
setpv('SR01C___B______AC03',10.5);

disp('Setting SR01 QFA magnet ramprate to 5.9 A/s');
setpv('SR01C___QFA____AC03.DRVH',22.5);
setpv('SR01C___QFA____AC03',5.9);

disp('Setting SR04 QFA magnet ramprate to 5.9 A/s');
setpv('SR04C___QFA____AC03.DRVH',22.5);
setpv('SR04C___QFA____AC03',5.9);

disp('Setting SR08 QFA magnet ramprate to 5.9 A/s');
setpv('SR08C___QFA____AC03.DRVH',22.5);
setpv('SR08C___QFA____AC03',5.9);

disp('Setting SR12 QFA magnet ramprate to 5.9 A/s');
setpv('SR12C___QFA____AC03.DRVH',22.5);
setpv('SR12C___QFA____AC03',5.9);

disp('Setting SR01 SF magnet ramprate to 2.0 A/s');
setpv('SR01C___SF_____AC30.DRVH',1000);
setpv('SR01C___SF_____AC30',2.0);

disp('Setting SR01 SD magnet ramprate to 2.0 A/s');
setpv('SR01C___SD_____AC30.DRVH',1000);
setpv('SR01C___SD_____AC30',2.0);

disp('Setting SR04/08/12 Superbend Ramprate to 0.4 A/s');
setpv('BSC','RampRate',0.4);

disp(' ');
