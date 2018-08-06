choice = menu('Quad FF channels','Enable','Disable');

if choice == 1
    flag = 1;
    disp('  Enabling QD and QF FF channels (setting multipliers to 1)');
elseif  choice == 2
    flag = 0;
    disp('  Disabling QD and QF FF channels (setting multipliers to 0)');
end

for Sector = 1:12
    setpv(sprintf('SR%02dC___QD1M___AC00',Sector),flag);
    setpv(sprintf('SR%02dC___QD2M___AC01',Sector),flag);
    setpv(sprintf('SR%02dC___QF1M___AC02',Sector),flag);
    setpv(sprintf('SR%02dC___QF2M___AC03',Sector),flag);
end

pause(1)

if choice == 1
    disp('  Enabled QD and QF FF channels (set multipliers to 1)');
elseif  choice == 2
    disp('  Disabled QD and QF FF channels (set multipliers to 0)');
end
