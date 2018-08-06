tune=[];offsetmeas=[];
epushift=getepu([4 1;11 1;11 2]);
epugap=getid([4 1;11 1;11 2]);
epumode = [scaget('SR04U___ODS1M__DC00');scaget('SR11U___ODS1M__DC00');scaget('SR11U___ODS2M__DC00')];

SectorIn = menu(str2mat('EPU orbit bump test','Feed forward must be off!',' ','Which insertion device?'),'EPU 4.1','EPU 11.1','EPU 11.2','Cancel');   

   if SectorIn == 1
      Sector = 4;
   elseif SectorIn == 2
      Sector = 11;
   elseif SectorIn == 3
      Sector = 11;
   elseif SectorIn == 4
      disp('  tunescan.  No changes to correctors or insertion device.');
     	return
   end

% "short" bump
CMIncrementList = [-3 -1 1 3];
NIter = 5;

meastime = now;

loop=1;

x0 = getgolden('BPMx',[Sector-1 10;Sector 1]);

for offset = -5.5:0.5:4.0
    HCMsp0 = getsp('HCM');
    setorbitbump('BPMx', [Sector-1 10;Sector 1], [offset; offset], 'HCM', CMIncrementList, NIter);
    offset
    pause(10);
    tune(:,loop)=gettune;
    offsetmeas(:,loop)=getam('BPMx',[Sector-1 10;Sector 1])-x0;
    setsp('HCM',HCMsp0,[],-2);
    loop=loop+1;
end

filename=sprintf('epu_orbitscan_tune_sector%d_%s.mat',Sector,datestr(now,30));
save(filename,'tune','offsetmeas','epushift','epugap','epumode','x0');

%setorbitbump('BPMx', [Sector-1 10;Sector 1], [0;0], 'HCM', CMIncrementList, NIter);




   