dipval = [];

for i=1:240*5
    dipval(i) = getam('BEND',[1,1]);
    pause(0.2);
end