function bpm_checkforstaledata

switch2notbergoz;
T = 1;


[x1, toutX, DataTimeX1] = getx;
[y1, toutY, DataTimeY1] = gety;
pause(T);

for i = 1:1e6
    [x2, toutX, DataTimeX2] = getx;
    [y2, toutY, DataTimeY2] = gety;
    
    if any((x2 - x1) == 0)
        fprintf('   %d. Stale horizontal \n', i);
        save(sprintf('Horizontal_StaleData_%d', i));
    end
    if any((y2 - y1) == 0)
        fprintf('   %d. Stale vertical \n', i);
        save(sprintf('Vertical_StaleData_%d', i));
    end
    x1 = x2;
    y1 = y2;
    DataTimeX1 = DataTimeX2;
    DataTimeY1 = DataTimeY2;
    pause(T);
end