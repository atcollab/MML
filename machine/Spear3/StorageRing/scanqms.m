%shunt quads around ring and record rms values

xdata=[];
ydata=[];

qmsinit;
QMSData = getappdata(0,'QMSData');
names = QMSData.FamilyDeviceChannelTbl(:,1);

 index = sort([find(strcmp(names,'QF')); find(strcmp(names,'QFC'));...
               find(strcmp(names,'QDX'));find(strcmp(names,'QFY'));find(strcmp(names,'QFZ'));...
               find(strcmp(names,'Q9S'))]);


%index=index([1:24]);    
%measure initial orbit
xref=getam('BPMx');
yref=getam('BPMy');

%loop through quad shunts

ExtraDelay=0.1;
QuadDelta=8;
NumQuads = length(index);

stdvectx=zeros(NumQuads,1);
stdvecty=zeros(NumQuads,1);

devlist=getlist('BPMx');
for k=1:NumQuads
    setorbitdefault('Fitrf');
    disp(['   shunting quadrupole number ' num2str(k) ' of ' num2str(NumQuads)]);
    %extract quad data
    iqms=index(k);
    QMS.QuadFamily=QMSData.FamilyDeviceChannelTbl{iqms,1};
    QMS.QuadDev=QMSData.FamilyDeviceChannelTbl{iqms,2};
    
    %shunt quad
    setqms(QMS.QuadFamily, QuadDelta, QMS.QuadDev);
    sleep(ExtraDelay);
    
    %measure orbit shift
    x=getam('BPMx');
    y=getam('BPMy');
    setqms(QMS.QuadFamily, 0, QMS.QuadDev);

    %remove bad bpms
    %eliminate bad bpms [10 4] and [12 4]
    indx=(1:size(devlist,1))';
    [iFound,iNotFound]=findrowindex([10 4; 12 4],devlist);
    indx(iFound)=[];

    deltax=x-xref;
    deltax=deltax(indx);
    deltay=y-yref;
    deltay=deltay(indx);
    
    stdx=1000*std(deltax);
    stdy=1000*std(deltay);
    maxx=1000*max(abs(deltax));
    maxy=1000*max(abs(deltay));
    
    %display rms value
    disp('   Warning: STD computed without BPMs [10 4], [12 4]')
    disp(['  Quadrupole: ' QMS.QuadFamily ' [' num2str(QMS.QuadDev(1)) ' ' num2str(QMS.QuadDev(2)) ']'...
         '   Horizontal rms: ' num2str(stdx) '   Vertical rms: ' num2str(stdy)]);
    disp(' ');
    
    QMS.QuadFamily=char(QMS.QuadFamily,'abc');
    xdata.quad(k,:)=QMS.QuadFamily(1,:);
    xdata.devlist(k,:)=QMS.QuadDev;
    xdata.std(k)=stdx;
    xdata.max(k)=maxx;

    ydata.quad(k,:)=QMS.QuadFamily(1,:);
    ydata.devlist(k,:)=QMS.QuadDev;
    ydata.std(k)=stdy;
    ydata.max(k)=maxy;
end

figure
subplot(2,1,1)
stem(xdata.std)
title('horizontal std due to shunts: BPM [10 4] and [12 4] excluded')
xlabel('Quadrupole index')
ylabel('std orbit shift (micron)')
subplot(2,1,2)
stem(ydata.std)
title('vertical std due to shunts: BPM [10 4] and [12 4] excluded')
xlabel('Quadrupole index')
ylabel('std orbit shift (micron)')