function [tau, t, DCCT] = measlifetimebuffer

% NN = getpv('SPEAR:DcctTrace.NORD');
% DCCTAVG = getpv('SPEAR:BeamCurrAvg');


N = 325;

t0 = getpv('SPEAR:DcctTrace.XVAL');
d0 = getpv('SPEAR:DcctTrace.RVAL');
t = t0;
d = d0;


% Flush the first buffer
while d(1) == d0(1) 
    t = getpv('SPEAR:DcctTrace.XVAL');
    d = getpv('SPEAR:DcctTrace.RVAL');
    pause(.5);
end


% Second buffer should be new data
d0 = d;
while d(1) == d0(1) 
    t = getpv('SPEAR:DcctTrace.XVAL');
    d = getpv('SPEAR:DcctTrace.RVAL');
    pause(.5);
end
while d(330) == 0 
    t = getpv('SPEAR:DcctTrace.XVAL');
    d = getpv('SPEAR:DcctTrace.RVAL');
    pause(.5);
end
[tau1, t, DCCT] = measlifetime(t(1:N),100*d(1:N));


% Average another data set
d0 = d;
while d(1) == d0(1) 
    t = getpv('SPEAR:DcctTrace.XVAL');
    d = getpv('SPEAR:DcctTrace.RVAL');
    pause(.5);
end
while d(N) == 0 
    t = getpv('SPEAR:DcctTrace.XVAL');
    d = getpv('SPEAR:DcctTrace.RVAL');
    pause(.5);
end
[tau2, t, DCCT] = measlifetime(t(1:N),100*d(1:N));


tau = (tau1 + tau2)/2;



% hold on
% plot(t,DCCT,'r');
% hold off
