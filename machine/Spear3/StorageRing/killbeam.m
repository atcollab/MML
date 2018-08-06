function killbeam

% Kills beam with increasing kicker bump

disp('Kicker Trigger must be on !!!!')

kick0(1)=getsp('02S-K1:VoltSetpt');
kick0(2)=getsp('03S-K2:VoltSetpt');
kick0(3)=getsp('04S-K3:VoltSetpt');

setsp('04S-K3:VoltSetpt',0);
setsp('02S-K1:VoltSetpt',0);
setsp('03S-K2:VoltSetpt',0);

pause(1)

setsp('04S-K3:VoltSetpt',22000);

maxstep=0;
while getdcct > 0.1 & maxstep<10
    maxstep=maxstep+1;
    pause(1)
end

setsp('02S-K1:VoltSetpt',kick0(1));
setsp('03S-K2:VoltSetpt',kick0(2));
setsp('04S-K3:VoltSetpt',kick0(3));

