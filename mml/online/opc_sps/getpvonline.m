function [AM, tout, DataTime, ErrorFlag] = getpvonline(ChannelNames, varargin)
%GETPVONLINE - Get the online value via OPC control
%
%  [AM, tout, DataTime, ErrorFlag] = getpvonline(ChannelNames, DataType, N, t)
%
%  INPUTS
%  1. ChannelNames
%  2. DataType - 'Double', 'String', 'Vector' or 'Waveform', 'Matrix' {Default: 'Double'}
%  3. N - Number of data points to return {Default: 1}
%         (only used for 'Vector', 'Waveform', and 'Matrix' DataTypes)
%  4. t - time vector of when to start a read [seconds]
%
%  OUTPUTS
%  1. AM - Value
%  2. tout - Local computer time on finish of data read
%  3. DataTime = time (in seconds) since 00:00:00, Jan 1, 1970
%                (seconds + nanoseconds * i)
%  4. ErrorFlag (Presently not functional.  All errors will cause a Matlab error.)
%
%  See also getopc, setpvonline



% To do
% 1. NAvg, AvgPeriod


ErrorFlag = 0;


% Function start time
t0 = clock;


if nargin < 1
    error('Must have at least a channel name input');
end


% Input parsing
DataType = 'Double';
N = 0;
t = 0;
NAvg = 1;
AvgPeriod = 0;
if length(varargin) >= 1
    if ischar(varargin{1})
        DataType = varargin{1};
        varargin(1) = [];
        if length(varargin) >= 1
            N = varargin{1};
            varargin(1) = [];
        end
    end
    if length(varargin) >= 1
        t = varargin{1};
        if length(varargin) >= 2
            NAvg = varargin{2};
            if length(varargin) >= 3
                AvgPeriod = varargin{3};
                if length(varargin) >= 4
                    FreshDataFlag = varargin{4};
                end
            end
        end
    end
end

% Scalars
N = N(1);
NAvg = NAvg(1);
AvgPeriod = AvgPeriod(1);

% t must be a row vector
t = t(:)';


% Vectorized Get
% There can be multiple channel names due to "ganged" power supplies (or redundent user input)
[ChannelNames, i, j] = unique(ChannelNames, 'rows');


% Remove ' ' and fill with NaN latter (' ' should always be the first row)
if isempty(deblank(ChannelNames(1,:)))
    iblank = 1;
    ChannelNames(1,:) = [];
else
    iblank = [];
end


if size(ChannelNames,1) > 0

    if strcmpi(DataType, 'String')
        
        error('SPS does not return strings at the moment.');
         
    elseif strcmpi(DataType, 'Vector')

        % Get data
        AM = double(getopc(ChannelNames));
        AM = AM(:);
        if N > 0
            AM = AM(1:N);
        end
        tout = etime(clock, t0);

    elseif strcmpi(DataType, 'Matrix') || strcmpi(DataType, 'Waveform')

        % Get data
        for k = 1:size(ChannelNames,1)
            tmp = double(getopc(deblank(ChannelNames(i,:))));
            AM(k,:) = tmp(:)';
        end
        tout = etime(clock, t0);

    else

        % Get data
        ExtraTimeDelay = etime(clock, t0);
        t = t - ExtraTimeDelay;
        for itime = 1:length(t)
            T = t(itime)-etime(clock, t0);
            if T > 0
                pause(T);
            end

            % Get data
            AM(:, itime) = double(getopc(ChannelNames));
            tout(1,itime) = etime(clock, t0);
        end    
        
    end
    
    
    % DataTime
    if nargout >= 3
        days = datenum(t0(1:3)) - 719529;  %datenum('1-Jan-1970');
        tt = 24*60*60*days + 60*60*t0(4) + 60*t0(5) + (t0(6) + tout - ExtraTimeDelay);
        DataTime = ones(size(AM,1),1) * (fix(tt) + rem(tt,1)*1e9*sqrt(-1));
    end

else

    t1 = clock;
    tout = etime(t1, t0);
    days = datenum(t1(1:3)) - 719529;  %datenum('1-Jan-1970');
    tt = 24*60*60*days + 60*60*t1(4) + 60*t1(5) + t1(6);
    DataTime = fix(tt) + rem(tt,1)*1e9*sqrt(-1);

    % Expand multiple channelnames back to multiple devices
    AM = NaN;
    AM = AM(j,:);
    return
    
end


% Expand the blank channel names
if ~isempty(iblank)
    AM = [NaN*ones(1,size(AM,2)); AM(iblank:end,:)];
    if nargout >= 3
        DataTime = [(NaN+NaN*sqrt(-1))*ones(1,size(DataTime,2)); DataTime(iblank:end,:)];
    end
end


% Expand multiple channelnames back to multiple devices
AM = AM(j,:);
if nargout >= 3
    DataTime = DataTime(j,:);
end

