
Year  = 2004;
Month = 1;
Day = 1;
NumberOfDays = 31;


clf reset
for i = 1:NumberOfDays
    [d, t] = gethist([Year Month Day 0 0 0], [Year Month Day 0 0 0]+[0 0 i 0 0 0], 'IonGauge', 'Monitor');

    d(find(d < .5e-11)) = NaN;

    d = d(:,1:100:end);
    t = t(1:100:end);
    
    semilogy(t,d);
    ylabel('Vacuum Pressure [Torr]');
    datetick x
    drawnow;
    hold on
end


hold off