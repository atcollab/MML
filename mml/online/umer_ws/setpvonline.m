function ErrorFlag = setpvonline(ChannelNames, NewSP, DataType, varargin)
%SETPVONLINE - Sets the online value
%  ErrorFlag = setpvonline(ChannelNames, NewSP, DataType)
%
%  Note: labca handles all EPICS data types.
%
%  See also getpvonline, getpv, setpv

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

if nargin < 4
    NoWaitFlag = 0;
end


if iscell(ChannelNames)

    % Put data
    lcaPut(ChannelNames, NewSP, DataType);

else

    % Vectorized put

    % There can be multiple channel names due to "ganged" power supplies
    [ChannelNames, i] = unique(ChannelNames, 'rows');

    % if size(ChannelNames,1) == size(NewSP,1)
    %     % ChannelNames equals the number of power supplies
    % else
    NewSP = NewSP(i,:);
    % end

    % Remove ' ' and fill with NaN latter (' ' should always be the first row)
    if isempty(deblank(ChannelNames(1,:)))
        ChannelNames(1,:) = [];
        NewSP(1,:) = [];
    end

    if ~isempty(ChannelNames)

        % Build the cell array and look for blanks
        ChanNameCell = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));

        %ChanNameCell = cell(size(ChannelNames,1),1);
        %for k = size(ChannelNames,1):-1:1
        %    ChanName = deblank(ChannelNames(k,:));
        %    if isempty(ChanName)
        %        NewSP(k,:) = [];
        %        ChanNameCell(k) = [];
        %    else
        %        ChanNameCell{k} = ChanName;
        %    end
        %end

        % Put data
        lcaPut(ChanNameCell, NewSP, DataType);
    end
end

