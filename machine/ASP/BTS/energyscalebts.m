% scale the septa in the BTS

%% open the setpoint channels
h_sei_sp = mcaopen('PS-SEI-3:CURRENT_SP');
h_sep_sp = mcaopen('PS-SEP-3:CURRENT_SP');
h_sei_mon = mcaopen('PS-SEI-3:CURRENT_MONITOR');
h_sep_mon = mcaopen('PS-SEP-3:CURRENT_MONITOR');

%% scale and set the septa
sep_angle = 5; 
sei_angle = 7.1; 

sep_length = 1.2;
sei_length = 1.58;

sep_over_sei = (sep_angle/sei_angle)*(sei_length/sep_length);
fprintf('SEP/SEI ratio %g\n', sep_over_sei);

%set the currents
setpoint = 8000;
sep_sp = sep_over_sei * setpoint;
sei_sp = setpoint;

fprintf('setting SEP to %g\n', sep_sp);
mcaput(h_sep_sp,sep_sp);

fprintf('setting SEI to %g\n', sei_sp);
mcaput(h_sei_sp,sei_sp);

% read back the monitor value


%% close the setpoint channels
mcaclose(h1);
mcaclose(h2);