%print corrector values to screen

x=getsp('HCM','struct');
y=getsp('VCM','struct');

xindx=dev2elem('HCM',x.DeviceList);  %subset
yindx=dev2elem('VCM',y.DeviceList);  %subset

total=getfamilydata('HCM','DeviceList');

    fprintf('%s \n','devicelist     horizontal     vertical');
for k=1:size(total,1)  
    %horizontal
    row=findrowindex(total(k,:),x.DeviceList);
    if ~isempty(row)
        xdata=x.Data(row);
    else
        xdata=NaN;
    end
    
    row=findrowindex(total(k,:),y.DeviceList);
    if ~isempty(row)
        ydata=y.Data(row);
    else
        ydata=NaN;
    end
    fprintf('%s %d %s %d %s  %12.3f %12.3f\n','[',total(k,1),' ,',total(k,2),']',xdata, ydata);
end

figure
subplot(2,1,1)
bar(x.Data);
title('horizontal correctors');
ylabel('amp')

subplot(2,1,2)
bar(y.Data);
title('vertical correctors');
ylabel('amp')