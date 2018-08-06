function d = devicelist(MLObj)
%DEVICELIST - Get the DeviceList field
%
%  Written by Greg Portmann


DataStruct = struct(MLObj);

FieldCell = fieldnames(MLObj);

if isempty(FieldCell)
    d = [];
else
    d = MLObj.(FieldCell{1}).DeviceList;
end

