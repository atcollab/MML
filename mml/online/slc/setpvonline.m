function ErrorFlag = setpvonline(ChannelNames, NewSP, DataType)
%SETPVONLINE - Sets the online value
% ErrorFlag = setpvonline(ChannelNames, NewSP, DataType)


if nargin < 2
    error('Must have at least two inputs');
end
if nargin < 3
    DataType = 'double';
end

ErrorFlag = 0;

if iscell(ChannelNames)

    % Put data
    lcaPut(ChannelNames, NewSP, DataType);

    % Not so good, but it's faster
    %lcaPutNoWait(ChannelNames, NewSP, DataType); 

else

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

    % Build the cell array
    ChanNameCell = cell(size(ChannelNames,1),1);
    for k = size(ChannelNames,1):-1:1      
        ChanName = deblank(ChannelNames(k,:));
        if isempty(ChanName)
            NewSP(k,:) = [];
            ChanNameCell(k) = [];
        else
            ChanNameCell{k} = ChanName;
        end
    end
    
    % Put data
    lcaPut(ChanNameCell, NewSP, DataType); 
    
    % Not so good, but it's faster
    %lcaPutNoWait(ChanNameCell, NewSP, DataType); 
    
end