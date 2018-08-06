function ErrorFlag = setpvonline(ChannelNames, NewSP, DataType)
%SETPVONLINE - Sets the online value
%  ErrorFlag = setpvonline(ChannelNames, NewSP, DataType)

%  Written by Greg Portmann  

if nargin < 2
    error('Must have at least two inputs');
end

ErrorFlag = 0;


% Vectorized put

% There can be multiple channel names due to "ganged" power supplies
[ChannelNames, i] = unique(ChannelNames, 'rows');

% if size(ChannelNames,1) == size(NewSP,1)
%     % ChannelNames equals the number of power supplies
% else
NewSP = NewSP(i,:);
% end


%if size(ChannelNames,1) ~= size(NewSP,1)
%    error('Size of NewSP must be equal to the DeviceList, a scalar, or the number of unique channelnames in the family');
%end


% Remove ' ' and fill with NaN latter (' ' should always be the first row)
if isempty(deblank(ChannelNames(1,:)))
    ChannelNames(1,:) = [];
    NewSP(1,:) = [];
end


% Build the MCA-handle array
for k = size(ChannelNames,1):-1:1
    ChanName = deblank(ChannelNames(k,:));
    % Get handle and/or open connection
    hh = mcaisopen(ChanName);
    h(k,1) = hh(1);
    if ~h(k,1)
        h(k,1) = mcaopen(ChanName);
    end

    if h(k) == 0
        error(sprintf('mcaopen error on channel name %s', ChanName));
    end
end


% Put data
mcaput(h, NewSP);
    
