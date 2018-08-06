function plot_linac_watchdog_data(filename)
% function plot_linac_watchdog_data(filename)
%
% Routine that checks for unusual linac pulses (mistriggered linac, gun pulse too long, ...)

if nargin ~= 1
    error('need to specify a filename of data file to plot');
end

f1=figure;

load 'modulator_reference_waveforms.mat'

mod1nom=mod1;mod2nom=mod2;timevecnom=timevec;
index_range = 1600:2400;

load(filename)

indvec=find(timevec>0);

plot( ...
    timevecnom(indvec),mod1nom(indvec),'c-',timevecnom(indvec),mod2nom(indvec),'m-', ...
    timevec(indvec),mod1(indvec),'b-',timevec(indvec),mod2(indvec),'r-');
xlabel('t [s]');
ylabel('Modulator Output');
legend('Mod 1 reference','Mod 2 reference','Mod 1 actual','Mod 2 actual')
title(datestr(event_timevec(end)));

return
    