function ChanName = getname_ler(Family, DeviceList, ChanType)

ChanName = [];
for i = 1:size(DeviceList,1)
    ChanName = strvcat(ChanName, ' ');
end