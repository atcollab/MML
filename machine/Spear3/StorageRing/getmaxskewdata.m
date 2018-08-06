function getmaxskewdata

FileNameArchive = appendtimestamp(['MaxData']);
FileName = ['R:\Controls\matlab\spear3data\User\SkewQuad\', FileNameArchive];


setmachineconfig('Golden');

SkewSP = getsp('SkewQuad');

figure(1)
clf reset

fprintf('   Starting skew quadrupole scan at %s\n', datestr(clock));

j = 0;
i = 1;
Delta = [1 .8 .6 .4 .2 0];
for y = Delta
    j = j + 1;
    
    setsp('SkewQuad', y *SkewSP);
    setorbitdefault;
    pause(1);
    
    
    % Lifetime measurement
    LifeTime(i,j) = measlifetime(40*1e-3);  % Base on current drop
    DCCT(i,j) = getdcct;
    BPMx(:,j) = raw2real('BPMx', getx);
    BPMy(:,j) = raw2real('BPMy', gety);
    IonGauge(:,j) = getam('IonGauge');
    
    fprintf('  %2d.  Fraction of SkewQuad = %3.2f mm,  Lifetime=%5.3f hours %s\n', j, y, LifeTime(i,j), datestr(clock,0)); 
    
    figure(1)
    plot(y, LifeTime(i,j),'.-b');
    hold on;
    drawnow;
    
    save(FileName);
    
end

hold off

setmachineconfig('Golden');
