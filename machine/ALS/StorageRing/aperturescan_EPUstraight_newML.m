tune=[];offsetmeas=[];
epushift=getepu([4 1;4 2;11 1;11 2]);
epugap=getid([4 1;4 2;11 1;11 2]);
epumode = [scaget('SR04U___ODS1M__DC00');scaget('SR04U___ODS2M__DC00');scaget('SR11U___ODS1M__DC00');scaget('SR11U___ODS2M__DC00')];

SectorIn = menu(str2mat('EPU orbit bump test','Feed forward must be off!',' ','Which insertion device?'),'EPU 4.1','EPU 4.2','EPU 11.1','EPU 11.2','Cancel');

if SectorIn == 1
    Sector = 4;
elseif SectorIn == 2
    Sector = 4;
elseif SectorIn == 4
    Sector = 11;
elseif SectorIn == 4
    Sector = 11;
elseif SectorIn == 5
    disp('  aperturescan.  No changes to correctors or insertion device.');
    return
end

offsetmeas=[];
sigmaX=[];
sigmaY=[];
life=[];

% "short" bump
CMIncrementList = [-3 -2 2 3];
NIter = 5;

meastime = now;

x0 = getgolden('BPMy',[Sector-1 10;Sector 1]);
offset = -1:1:1;

for loop = 1:length(offset)
    if loop == 1
        setorbitbump('BPMy', [Sector-1 10;Sector 1], [offset(loop);offset(loop)], 'VCM', CMIncrementList, 'Display');
    else
        setorbitbump('BPMy', [Sector-1 10;Sector 1], [offset(loop)-offset(loop-1);offset(loop)-offset(loop-1)], 'VCM',CMIncrementList);
    end
    offset(loop)
    pause(10);
    offsetmeas(:,loop)=getam('BPMx',[Sector-1 10;Sector 1])-x0;
    sigmaX(loop)=getspiricon('Xrms');
    sigmaY(loop)=getspiricon('Yrms');
    life(loop)=measlifetime(0:.5:40);
    loop=loop+1;
end

filename=sprintf('epu_aperturescan_sector%d_%s.mat',Sector,datestr(now,30));
save(filename,'offset','offsetmeas','sigmaX','sigmaY','life','x0');

setorbitbump('BPMy', [Sector-1 10;Sector 1], [-offset(end);-offset(end)], 'VCM',CMIncrementList);

figure
plot(offset,life)