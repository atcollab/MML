function ErrorFlag = setpvonline(ChannelNames, NewSP, DataType)
%SETPVONLINE - Sets the online value
%  ErrorFlag = setpvonline(ChannelNames, NewSP, DataType)
%
%  See also getpvonline, getpv, setpv


%  Written by Greg Portmann


ErrorFlag = 0;

if nargin < 2
    error('Must have at least two inputs');
end
if nargin < 3
    DataType = '';
end
if isempty(DataType)
    if ischar(NewSP)
        DataType = 'char';
    else
        DataType = 'double';
    end
elseif ischar(DataType)
    if any(strcmpi(DataType, {'string','char'}))
        % Convert string to char
        DataType = 'char';
    end
end


if isempty(ChannelNames)
    return
end


% Convert to cell and look for blanks
if ~iscell(ChannelNames)
    ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
end


if any(strcmpi(DataType, {'waveform'}))
    
    error('waveforms needs work.');    
    status = ctl_mset_waveform(ChannelNames, NewSP);
        
else
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

    if ~isempty(ChannelNames)
        if length(ChannelNames) > 1
            status = ctl_mset(ChannelNames, NewSP);
        else
            status = ctl_set(ChannelNames, NewSP);
        end
    end
end

