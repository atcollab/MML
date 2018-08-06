function [T, Tvec] = getramptime(Family, SPnew, DeviceList)

if nargin < 2
    error('At least 2 input required.');
end
if nargin < 3
    DeviceList = [];
end

SP = getsp(Family, DeviceList);
Tvec = abs((SP-SPnew) ./ getramprate(Family, DeviceList));
T = max(Tvec);
