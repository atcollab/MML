clear


Family = 'Q';  % 'HCM' 'VCM' 'BEND' 'Q'
N = 41;


SP = [];
SP0 = getpv(Family, 'Struct');
Name = family2channel(Family);
Max = maxsp(Family);
Min = minsp(Family);
Delta = (Max-Min)/(N-1);
setsp(Family, Min, [], -1);
pause(5);

i = 1;
SP(:,i) = getsp(Family);
AM(:,i) = getam(Family);
for i = 2:N
    stepsp(Family, Delta, [], 0);
    pause(5);

    SP(:,i) = getsp(Family);
    AM(:,i) = getam(Family);
end
setpv(SP0);

clear i 
save(['BTS_', Family,'_Linearity']);


