function ffread(DeviceList)
%  ffread(DeviceList)
%
%  This function forces a table read on the feed forward compensation
%  the next time feed forward is turned on.  Sector is the insertion device 
%  list.
%


% Check input
if nargin < 1 || isempty(DeviceList)
    DeviceList = family2dev('ID');
end

DeviceListTotal = [
     4     1
     4     2
     5     1
     6     1
     7     1
     8     1
     9     1
    10     1
    11     1
    11     2
    12     1];
    
ChannelNames = {
    'sr04u:FFRead:bo'
    'sr04u2:FFRead:bo'
    'sr05w:FFRead:bo'
    'sr06u:FFRead:bo'
    'sr07u:FFRead:bo'
    'sr08u:FFRead:bo'
    'sr09u:FFRead:bo'
    'sr10u:FFRead:bo'
    'sr11u1:FFRead:bo'
    'sr11u2:FFRead:bo'
    'sr12u:FFRead:bo'
    };

i = findrowindex(DeviceList, DeviceListTotal);

setpvonline(ChannelNames(i), ones(length(i),1));
