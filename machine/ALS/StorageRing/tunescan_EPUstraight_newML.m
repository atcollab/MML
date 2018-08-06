tune=[];offsetmeas=[];
epushift=getepu([4 1;4 2;6 2;7 2;11 1;11 2]);
epugap=getid([4 1;4 2;6 2;7 2;11 1;11 2]);
epumode = [scaget('SR04U___ODS1M__DC00');scaget('SR04U___ODS2M__DC00');scaget('SR06U___ODS2M__DC00');scaget('SR07U___ODS2M__DC00');scaget('SR11U___ODS1M__DC00');scaget('SR11U___ODS2M__DC00')];

SectorIn = menu(str2mat('EPU orbit bump test','Feed forward must be off!',' ','Which insertion device?'),'EPU 4.1','EPU 4.2','EPU 6.2','EPU 7.2','EPU 11.1','EPU 11.2','Cancel');   

   if SectorIn == 1
      Sector = 4;
   elseif SectorIn == 2
      Sector = 4;
   elseif SectorIn == 3
      Sector = 6;
   elseif SectorIn == 4
      Sector = 7;
   elseif SectorIn == 5
      Sector = 11;
   elseif SectorIn == 6
      Sector = 11;
   elseif SectorIn == 5
      disp('  tunescan.  No changes to correctors or insertion device.');
     	return
   end

% "short" bump
CMIncrementList = [-3 -1 1 3];
NIter = 5;

meastime = now;

loop=1;

x0 = getgolden('BPMx',[Sector-1 10;Sector 1]);
offset = -1.0:0.5:1.0;

for loop = 1:length(offset)
    if loop == 1 
        setorbitbump('BPMx', [Sector-1 10;Sector 1], [offset(loop);offset(loop)], 'HCM', CMIncrementList, 'Display');
    else
        setorbitbump('BPMx', [Sector-1 10;Sector 1], [offset(loop)-offset(loop-1);offset(loop)-offset(loop-1)], 'HCM',CMIncrementList);
    end
   offset(loop)
   pause(10);
   tune(:,loop)=gettune;
   offsetmeas(:,loop)=getam('BPMx',[Sector-1 10;Sector 1])-x0;
   loop=loop+1;
end

filename=sprintf('epu_orbitscan_tune_sector%d_%s.mat',Sector,datestr(now,30));
save(filename,'tune','offsetmeas','epushift','epugap','epumode','x0');

setorbitbump('BPMx', [Sector-1 10;Sector 1], [-offset(end);-offset(end)], 'HCM',CMIncrementList);




   