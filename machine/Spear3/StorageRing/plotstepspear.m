function plotstepspear(CMFamily, CMDeviceList)
%PLOTSTEPSPEAR
%  plotstepspear(CMFamily, CMDeviceList)


if nargin < 1
    CMFamily = 'HCM';
end
if nargin < 2
    CMDeviceList = getlist(CMFamily);
end

clf reset

for ii = 1:size(CMDeviceList,1)
    load(sprintf('%s%d_%d', CMFamily, CMDeviceList(ii,:)));
    plot((1:2000)/2000, CMam-CMam(1));
    drawnow
    hold on;

    %ylabel(sprintf('%s(%d,%d)', CMFamily, CMDeviceList(ii,:)));
    %CMDeviceList(ii,:)
    %pause
end

title('Step Response')
xlabel('Time [Seconds]');

if size(CMDeviceList,1) == 1
    ylabel(sprintf('%s(%d,%d)', CMFamily, CMDeviceList));
else
    ylabel(sprintf('%s', CMFamily));
end

