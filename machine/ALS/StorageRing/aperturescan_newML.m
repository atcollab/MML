SectorIn = menu(str2mat('Straight Section Vertical Aperture Scan','Which straight?'),'1','2','3','4','5','6','7','8','9','10','11','12','Cancel');

if SectorIn == 1
    Sector = 1;
elseif SectorIn == 2
    Sector = 2;
elseif SectorIn == 3
    Sector = 3;
elseif SectorIn == 4
    Sector = 4;
elseif SectorIn == 5
    Sector = 5;
elseif SectorIn == 6
    Sector = 6;
elseif SectorIn == 7
    Sector = 7;
elseif SectorIn == 8
    Sector = 8;
elseif SectorIn == 9
    Sector = 9;
elseif SectorIn == 10
    Sector = 10;
elseif SectorIn == 11
    Sector = 11;
elseif SectorIn == 12
    Sector = 12;
else
    disp('  aperturescan.  No changes to correctors or insertion device.');
    return
end

offsetmeas = [];
sigmaX = [];
sigmaY = [];
sigmaX31 = [];
sigmaY31 = [];
life = [];
DCCT = [];
DCCTstart = [];
DCCTend = [];

% "local" bump
CMIncrementList = [-2 -1 1 2]; %(gives high corrector values for straight sections)
% "short" bump
% CMIncrementList = [-3 -2 -1 1 2 3]; %(gives high corrector values for straight sections)
% "longer" bump
%CMIncrementList = [-4 -3 -2 2 3 4];

NIter = 3;

meastime = now;
DCCTstart = getdcct;

if Sector == 1
    x0_gold = getgolden('BPMy',[12 9;Sector 2]);
    x0 = getam('BPMy',[12 9;Sector 2]);
elseif Sector == 2
    x0_gold = getgolden('BPMy',[Sector-1 10;Sector 1]);
    x0 = getam('BPMy',[Sector-1 10;Sector 1]);
elseif Sector == 3
    x0_gold = getgolden('BPMy',[Sector-1 9;Sector 2]);
    x0 = getam('BPMy',[Sector-1 9;Sector 2]);
else
    x0_gold = getgolden('BPMy',[Sector-1 10;Sector 1]);
    x0 = getam('BPMy',[Sector-1 10;Sector 1]);
end

if Sector == 2
    offset = [-1.5:0.25:1.5]
elseif Sector == 6
    offset = [-1.5:0.25:1.5]
elseif  Sector == 7
    offset = [-1.8:0.25:1.8]
else
    offset = -2.0:0.5:2.0
end

for loop = 1:length(offset)
    if loop == 1
        if Sector == 1
            setorbitbump('BPMy', [12 9;Sector 2], [offset(loop);offset(loop)], 'VCM', CMIncrementList);
        elseif Sector == 2
            setorbitbump('BPMy', [Sector-1 10;Sector 1], [offset(loop);offset(loop)], 'VCM', CMIncrementList);
        elseif  Sector == 3
            setorbitbump('BPMy', [Sector-1 9;Sector 2], [offset(loop);offset(loop)], 'VCM', CMIncrementList);
        else
            setorbitbump('BPMy', [Sector-1 10;Sector 1], [offset(loop);offset(loop)], 'VCM', CMIncrementList);
        end
    else
        if Sector == 1
            setorbitbump('BPMy', [12 9;Sector 2], [offset(loop)-offset(loop-1);offset(loop)-offset(loop-1)], 'VCM', CMIncrementList);
        elseif Sector == 2
            setorbitbump('BPMy', [Sector-1 10;Sector 1], [offset(loop)-offset(loop-1);offset(loop)-offset(loop-1)], 'VCM', CMIncrementList);
        elseif Sector == 3
            setorbitbump('BPMy', [Sector-1 9;Sector 2], [offset(loop)-offset(loop-1);offset(loop)-offset(loop-1)], 'VCM', CMIncrementList);
        else
            setorbitbump('BPMy', [Sector-1 10;Sector 1], [offset(loop)-offset(loop-1);offset(loop)-offset(loop-1)], 'VCM',CMIncrementList);
        end
    end
    offset(loop)
    pause(2);
    if Sector == 1
        offsetmeas_gold(:,loop)=getam('BPMy',[12 9;Sector 2])-x0_gold;
        offsetmeas(:,loop)=getam('BPMy',[12 9;Sector 2])-x0;
    elseif Sector == 2
        offsetmeas_gold(:,loop)=getam('BPMy',[Sector-1 10;Sector 1])-x0_gold;
        offsetmeas(:,loop)=getam('BPMy',[Sector-1 10;Sector 1])-x0;
    elseif Sector == 3
        offsetmeas_gold(:,loop)=getam('BPMy',[Sector-1 9;Sector 2])-x0_gold;
        offsetmeas(:,loop)=getam('BPMy',[Sector-1 9;Sector 2])-x0;
    else
        offsetmeas_gold(:,loop)=getam('BPMy',[Sector-1 10;Sector 1])-x0_gold;
        offsetmeas(:,loop)=getam('BPMy',[Sector-1 10;Sector 1])-x0;
    end
    pause(5)
    DCCT(loop) = getdcct;
%     sigmaX(loop)=getspiricon('Xrms');
%     sigmaY(loop)=getspiricon('Yrms');
    sigmaX31(loop)=getpv('beamline31:XRMSAve');
    sigmaY31(loop)=getpv('beamline31:YRMSAve');
    life(loop)=getlife2(0.02);
    loop=loop+1;
end

DCCTend = getdcct;

filename=sprintf('aperturescan_sector%d_%s.mat',Sector,datestr(now,30));
save(filename,'offset','offsetmeas','offsetmeas_gold','sigmaX','sigmaY','sigmaX31','sigmaY31','life','x0','x0_gold','DCCTstart','DCCTend','DCCT');

if Sector == 1
    setorbitbump('BPMy', [12 9;Sector 2], [-offset(end);-offset(end)], 'VCM',CMIncrementList);
elseif Sector == 2
    setorbitbump('BPMy', [Sector-1 10;Sector 1], [-offset(end);-offset(end)], 'VCM',CMIncrementList);
elseif Sector == 3
    setorbitbump('BPMy', [Sector-1 9;Sector 2], [-offset(end);-offset(end)], 'VCM',CMIncrementList);
else
    setorbitbump('BPMy', [Sector-1 10;Sector 1], [-offset(end);-offset(end)], 'VCM',CMIncrementList);
end

figure
%plot(offsetmeas_gold,life.*DCCT./sigmaY,'bo-')
plot(offsetmeas_gold,life,'bo-')
hold on
title(sprintf('Straight %i Vertical Aperture Scan; DCCT = %.1f to %.1f mA',Sector,DCCTstart,DCCTend));
ylabel('Lifetime');
xlabel('Measured Vertical Offset Through Straight (relative to golden orbit)');
soundtada
