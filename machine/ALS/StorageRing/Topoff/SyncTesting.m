
%%

clear

PV = [
    'LI11:EVR1:Evt10Cnt-I '
    'B0215:EVR1:Evt48Cnt-I'
    'LI11:EVR1:Evt68Cnt-I '
    'LI11:EVR1:Evt70Cnt-I '
    'LI11:EVR2:Evt100Cnt-I'
    ];

for i = 1:500
    [dcct(:,i), ~, tsdcct(:,i)] = getpvonline('cmm:beam_current');
    
    [a(:,i), ~, ts(:,i)] = getpv(PV);
   
    [bcm.BunchCurrent(i,:), ~, DataTime(1,i)] = getpvonline('SR1:BCM:BunchQ_WF');  % [mA]
    
    t(i) = now;
    pause(.05);
end

bcm.Ts = labca2datenum(DataTime);
tsdcct = labca2datenum(tsdcct);

bcm.BunchCurrent = bcm.BunchCurrent';


%%

% i = find(diff(a(1,:)))
% 
% t1 = 24*60*60*(ts(1,i(2))-ts(1,i(1)))


%%

c = 24*60*60;
t0 = ts(1,1);

figure(1);
clf reset

i = 1;

h = subplot(3,1,1);
plot(c*(ts(i,:)-t0), a(i,:)-a(i,1), 'b');
hold on
plot(c*(t-t0),       a(i,:)-a(i,1), 'b');
i = 2;
plot(c*(ts(i,:)-t0), a(i,:)-a(i,1), 'g');
plot(c*(t-t0),       a(i,:)-a(i,1), 'g');

h(2) = subplot(3,1,2);
plot(c*(t-t0),      bcm.BunchCurrent-bcm.BunchCurrent(:,1), 'b');
hold on
plot(c*(bcm.Ts-t0), bcm.BunchCurrent-bcm.BunchCurrent(:,1));


h(3) = subplot(3,1,3);
plot(c*(tsdcct-t0), dcct, 'b');
hold on
plot(c*(t-t0),      dcct, 'g');


linkaxes(h, 'x');

% dt = diff(ts);
% 
% plot(dt(1,:))




