

for i = 1:111
    if ~any(i==[22 30 52 64])
        [am,t,d]=getpv(sprintf('irm:%03d:ADC0',i));
        fprintf('IRM %03d  %s\n', i, datestr(d));
    end;
end