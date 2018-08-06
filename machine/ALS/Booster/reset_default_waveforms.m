% reset_default_waveforms
%
% This script is upposed to restore the default miniIOC waveforms
% for the main booster power supplies (IEPower QF, QD, BEND)
%
% Christoph Steier, 2009-01-09

disp('Changing to correct working directory');

cd('/home/als/physdata/matlab/srdata/powersupplies/BQFQD_ramping_20071031');

disp('Loading .mat file with all waveforms');
load('minioc_waveform_data_20081008.mat');

whos

disp('Setting Bend ramptable');
setboosterrampbend(1.17,bend_new2/0.9-0.0059);
pause(1);
setboosterrampbend(1.17,bend_new2/0.9-0.0059);
pause(1);

% Values below were used before bend jump on 2009-08-27
% setboosterrampbend(1.17,bend_new2/0.9-0.0004);
% pause(1);
% setboosterrampbend(1.17,bend_new2/0.9-0.0004);
% pause(1);

% Values below were used before booster work (addition of 1 muF) cap in parallel to grounding resistor
% setboosterrampbend(1.17,bend_new2/0.9+0.0013);
% pause(1);
% setboosterrampbend(1.17,bend_new2/0.9+0.0013);
% pause(1);
disp('Setting QF ramptable');
setboosterrampqf(1.17,qf_ramp_20081008_2047);
pause(1);
setboosterrampqf(1.17,qf_ramp_20081008_2047);
pause(1);

qd_ramp_SP=qd_ramp_20081008_1652;
ind_repl=find(qd_ramp_SP<0.027);
qd_ramp_SP(ind_repl)=0.027;
qd_ramp_SP(1:100)=linspace(0.027,0.416,100);

% disp('Setting QD ramptable');
% setboosterrampqd(1.17,qd_ramp_20081008_1652)
% pause(1);
% setboosterrampqd(1.17,qd_ramp_20081008_1652)

disp('Setting QD ramptable');
setboosterrampqd(1.17,qd_ramp_SP)
pause(1);
setboosterrampqd(1.17,qd_ramp_SP)
