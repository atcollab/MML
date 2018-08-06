
%% Measure

clear


% Family = 'Q';  % 'HCM' 'VCM' 'BEND' 'Q'
% 
% 
% 
% SP = [];
% SP0 = getpv(Family, 'Setpoint', 'Struct');
% AM0 = getpv(Family, 'Monitor', 'Struct');
% Name = family2channel(Family);
% Max = maxsp(Family);
% Min = minsp(Family);
% 
% setpv(Family, 'Setpoint', 0);
% [AM, t, Ts] = getpv(Family, 'Monitor', [], 0:.1:39);
% 
% 
% save(['BTS_', Family,'_RampRate']);


%% Plot

Family = 'Q';  % 'HCM' 'VCM' 'BEND' 'Q'
load(['BTS_', Family,'_RampRate']);

for i = 1:11
    figure(i);
    clf reset
    plot(t, AM(i,:));
    
    i1 = 10;
    i2 = min(find(AM(i,:)<1));
    rr(i,1) = abs((AM(i,i2)-AM(i,i1))/(t(i2)-t(i1)));
    
    title(sprintf('%s  %.2f amps/sec',Name(i,:),rr(i)),'Interpret','None');
end