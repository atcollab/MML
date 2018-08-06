function curve = getcyclecurve(varargin)
%GETCYCLECURVE - Get curve for cycling magnet
%
%  INPUTS
%  1. Family or Tango sequencer device name
%  OPTIONAL
%  2. DEviceListe
%
%  OUTPUTS
%  1. curve read from Dserver
%
%  EXAMPLES
%  1. getcyclecurve('LT1/tests/currentCH.2');
%  2. getcyclecurve('CycleQP');
%  3. getcyclecurve('CycleQP',[1 3]);
%
%  NOTES:
%  1. Tango specific
%
%  See Also setcyclingcurve, plotcyclingcurve, LT1cycling

% TODO: This just a first shot routine 

DeviceList = [];

if isempty(varargin)
    error('At least provide a Family');
end

Family = varargin{1};

if nargin > 1
    DeviceList = varargin{2};
end

[FamilyFlag AO] = isFamily(Family);

if FamilyFlag
    if isempty(DeviceList)
        DeviceList = family2dev(Family);
    end
    DeviceName = family2tangodev(Family, DeviceList);
    for k = 1:size(DeviceName,1)
        val = tango_read_attribute2(DeviceName{k},'sequenceValues');
        curve{k}.Data(:,1) = val.value;
        val = tango_read_attribute2(DeviceName{k},'waitingTimes');
        curve{k}.Data(:,2) = val.value;
        curve{k}.DeviceName = DeviceName{k};
    end
else
    val = tango_read_attribute2(Family,'sequenceValues');
    curve(:,1) = val.value;
    val = tango_read_attribute2(Family,'waitingTimes');
    curve(:,2) = val.value;
end