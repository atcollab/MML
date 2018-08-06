function tc = gettc(Sector, ChannelNumber, TRP)
%GETTC - Gets the storage ring thermocouples
%
%  For 1-Dim (typically middle layer output) 
%  TC = gettc(DeviceList, TRP)
%
%  For 2-Dim 
%  TC = gettc(Sector, ChannelNumber, TRP)  
%
%  TRP 2 and 4 only exist for sector 3 and 14


if nargin < 1
    Sector = [];
end
if nargin < 2
    ChannelNumber = [];
end
if nargin < 3
    TRP = [];
end

if size(Sector,2) == 2
    if nargin < 2
        TRP = [];
    else
        TRP = ChannelNumber;
    end
end

if isempty(Sector)
    Sector = 1:18;
end
if isempty(ChannelNumber)
    ChannelNumber = 1:15;
end
if isempty(TRP)
    TRP = 1;
end


% if length(Sector) == 1
%     Sector = Sector * ones(size(ChannelNumber));
% end
% if length(TRP) == 1
%     TRP = TRP * ones(size(ChannelNumber));
% end

if size(Sector,2) == 2
    ChanName = [];
    for j = 1:size(Sector,1)
        ChanName = strvcat(ChanName,sprintf('spr:TG%02dR%dC%d/AM1', Sector(j,1), TRP(1), Sector(j,2)));
    end
    tc = getpv(ChanName);
else
    for i = 1:length(ChannelNumber)
        ChanName = [];
        for j = 1:length(Sector)
            ChanName = strvcat(ChanName,sprintf('spr:TG%02dR%dC%d/AM1', Sector(j), TRP(1), ChannelNumber(i)));
        end
        tc(:,i) = getpv(ChanName);
    end
end


[i,j] = find(tc < 0); 
tc(i,j) = NaN;
