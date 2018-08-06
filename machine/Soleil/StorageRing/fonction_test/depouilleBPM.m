fileName = '/home/matlabML/measdata/Ringdata/BPM/BPMData_30tours.mat';
load(fileName);

[dummy idx] = max(AM.Data.Sum');
num = 7; % numero du tour 1
dummyfix = AM.Data.Sum(:,num);

xpos=1:120;
ishift=0;
DisplayFlag = 1;

idx2 = sub2ind(size(AM.Data.Sum), xpos, idx+ishift);

if DisplayFlag
    figure(101)
    
    posvect = getspos('BPMx',AM.DeviceList);

    h1 = subplot(7,1,[1 3]);
    plot(posvect, AM.Data.X(idx2),'r.-');
    hold on
    plot(posvect, AM.Data.X(:,num),'k.-'); % tour fixe
    hold on
    plot(posvect, AM.Data.X(:,num+1),'b.-'); % tour fixe +1
    hold off
    grid on
    xlabel('s(m)')
    ylabel('X(mm)')
    axis([0 getcircumference -10 10]);
    legend('somme max','tour fixe n°7', 'tour fixe n°8')
    title('First turn orbit')

    h2 = subplot(7,1,4);
    drawlattice;

    h3  = subplot(7,1,[5 7]);
    plot(posvect, AM.Data.Z(idx2),'r.-');
    hold on
    plot(posvect, AM.Data.Z(:,num),'k.-'); % tour fixe
    hold on
    plot(posvect, AM.Data.Z(:,num+1),'b.-'); % tour fixe +1
    hold off
    grid on
    xlabel('s(m)')
    ylabel('Z(mm)')
    axis([0 getcircumference -5 5]);

    linkaxes([h1,h2,h3],'x');

    addlabel(1,0,datestr(AM.TimeStamp,21));
end
