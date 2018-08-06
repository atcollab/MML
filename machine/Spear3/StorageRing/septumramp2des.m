function septumramp2des
%SEPTUMRAMP2DES ramp septum to DES value from current value;
%  Wait to complete

% Disable SOFB
setpv('SPEAR:SOFBSetDisable',1);
disp('SOFB disabled');

SeptumDes = getpv('BTS-B9V:CurrSetptDes');
SeptumCur = getpv('BTS-B9V:CurrSetpt');
NUMSTEPS = 20;
DELAY = 1; % s
SeptumRampValues = SeptumCur+(SeptumDes-SeptumCur)*(1:NUMSTEPS)/NUMSTEPS;
h = figure;
plot(SeptumRampValues,'o-');
hold on

for i = 1:NUMSTEPS
    title(['Ramping Septum to ',num2str(SeptumRampValues(i))]);
    setpv('BTS-B9V:CurrSetpt',SeptumRampValues(i));
    pause(DELAY);
    bar(i,SeptumRampValues(i));
    title('Correcting Orbit');
    pause(DELAY);
    setorbitdefault('fitRF');
end

title('Done Ramping');
setpv('SPEAR:SOFBSetDisable',0);
disp('SOFB enabled');
