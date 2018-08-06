% set_topoff_interlock_ramprates
%
% This routine sets all ramprates of power supplies interlocked for topoff to fast, to allow for interlock testing (step response).
%
% Christoph Steier, 2008

% Interlocked magnets are Storage Ring Bend, 3 Superbends, 
% all 4 SR QFAs, SR SF+SD, as well as the booster bend (however, 
% the booster bend is not set below, since it has a completely
% different control and is not tested in the same way.

disp('Setting SR BEND magnet ramprate to 10000 A/s');
setpv('SR01C___B______AC03.DRVH',10000);
setpv('SR01C___B______AC03',10000);

disp('Setting SR01 QFA magnet ramprate to 10000 A/s');
setpv('SR01C___QFA____AC03.DRVH',10000);
setpv('SR01C___QFA____AC03',10000);

disp('Setting SR04 QFA magnet ramprate to 10000 A/s');
setpv('SR04C___QFA____AC03.DRVH',10000);
setpv('SR04C___QFA____AC03',10000);

disp('Setting SR08 QFA magnet ramprate to 10000 A/s');
setpv('SR08C___QFA____AC03.DRVH',10000);
setpv('SR08C___QFA____AC03',10000);

disp('Setting SR12 QFA magnet ramprate to 10000 A/s');
setpv('SR12C___QFA____AC03.DRVH',10000);
setpv('SR12C___QFA____AC03',10000);

disp('Setting SR01 SF magnet ramprate to 10000 A/s');
setpv('SR01C___SF_____AC30.DRVH',10000);
setpv('SR01C___SF_____AC30',10000);

disp('Setting SR01 SD magnet ramprate to 10000 A/s');
setpv('SR01C___SD_____AC30.DRVH',10000);
setpv('SR01C___SD_____AC30',10000);

disp('Setting SR04/08/12 Superbend Ramprate to 0.8 A/s');
setpv('BSC','RampRate',0.8);

disp(' ');