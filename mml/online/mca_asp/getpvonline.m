function [AM, tout, DataTime, ErrorFlag] = getpvonline(ChannelNames, varargin)
%GETPVONLINE - Gets the online value
%
%  For DateType = 'Double' or 'Scalar'
%  [AM, tout, DataTime, ErrorFlag] = getpvonline(ChannelNames, t)
%
%  For DateType = 'String', 'Vector', 'Matrix'
%  [AM, tout, DataTime, ErrorFlag] = getpvonline(ChannelNames, DataType, N)
%
%  In general:
%  [AM, tout, DataTime, ErrorFlag] = getpvonline(ChannelNames, DataType, N, t)
%
%  INPUTS
%  1. ChannelNames
%  2. DataType - 'Double', 'String', 'Vector' or 'Waveform', 'Matrix' {Default: 'Double'}
%                Matlab works in Strings and Doubles (for the most part), so EPICS data types
%                like SCA_SHORT, SCA_FLOAT, SCA_SHORT, SCA_LONG all map to a double.
%                'Vector', 'Waveform', and 'Matrix' return a vector or matrix of doubles.
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
%  See also setpvonline, getpv, setpv, getepicscaaddrlist

%  Written by Greg Portmann


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

    % Build MCA handle
    for ii = 1:size(ChannelNames,1)
        ChanName = deblank(ChannelNames(ii,:));

        % Get handle and/or open connection
        hh = mcaisopen(ChanName);
        h(ii,1) = hh(1);
        if ~h(ii,1)
            h(ii,1) = mcaopen(ChanName);
        end

        if h(ii,1) == 0
            error(sprintf('mcaopen error on channel name %s', ChanName));
        end
    end
    

    if strcmpi(DataType, 'String')
        
        error('MCA does not return strings at the moment.');
        
        if length(t) > 1
            fprintf('   t vector must be scalar for ''String'' inputs, hence ignored.\n');
        end

        % Only the first sample delay is recognized
        T = t(1) - etime(clock, t0);
        if T > 0
            pause(T);
        end

        % Get the data
        AM = [];
        for k = 1:size(h, 1)
            tmp = mcaget(h(k));

            % MCA timestamps are a separate call
            if nargout >= 3
                DateNumber = 726834;  %datenum('1-Jan-1990');
                for k = 1:length(h)
                    result{1} = mca(60,h(k));
                    day = result{1}(1,1);   % Days in seconds
                    nsec = result{1}(1,2);  % nanoseconds

                    % The EPICS epoch is 1-Jan-1990
                    DataTime(k,1) = 24*3600*DateNumber + day + sqrt(-1)*nsec;
                end
            end
            AM = strvcat(AM, tmp);
        end
        tout = etime(clock, t0);
        

        % Expand the blank channel names
        if ~isempty(iblank)
            AM = strvcat(' ', AM);
            if nargout >= 3
                DataTime = [NaN+NaN*sqrt(-1); DataTime(iblank:end)];
            end
        end
                       
        % Expand multiple channelnames back to multiple devices
        AM = AM(j,:);
        if nargout >= 3
            DataTime = DataTime(j,:);
        end

        return;
        
    elseif strcmpi(DataType, 'Vector')

        % Get data
        AM = mcaget(h);
        AM = AM(:);
        if N > 0
            AM = AM(1:N);
        end
        tout = etime(clock, t0);

        % MCA timestamps are a separate call
        if nargout >= 3
            DateNumber = 726834;  %datenum('1-Jan-1990');
            result{1} = mca(60,h);
            day = result{1}(1,1);   % Days in seconds
            nsec = result{1}(1,2);  % nanoseconds

            % The EPICS epoch is 1-Jan-1990
            DataTime = 24*3600*DateNumber + day + sqrt(-1)*nsec;
        end

    elseif any(strcmpi(DataType, {'Matrix','Waveform'}))
        
        % Get data
        for k = 1:size(ChannelNames,1)
            tmp = mcaget(h);
            if N > 0
                tmp = tmp(1:N);
            end

            AM(k,:) = tmp(:)';

            % MCA timestamps are a separate call
            if nargout >= 3
                DateNumber = 726834;  %datenum('1-Jan-1990');
                result{1} = mca(60,h(k));
                day = result{1}(1,1);   % Days in seconds
                nsec = result{1}(1,2);  % nanoseconds

                % The EPICS epoch is 1-Jan-1990
                DataTime(k,1) = 24*3600*DateNumber + day + sqrt(-1)*nsec;
            end
        end
        tout = etime(clock, t0);

    else

        % Get data
        AM = [];
        ExtraTimeDelay = etime(clock, t0);
        t = t - ExtraTimeDelay;
        for itime = 1:length(t)
            T = t(itime)-etime(clock, t0);
            if T > 0
                pause(T);
            end

            % Get data
            tmp = mcaget(h);
            if N > 0
                tmp = tmp(:,1:N);
            end
            AM = [AM tmp];
            tout(1,itime) = etime(clock, t0);

            % MCA timestamps are a separate call
            if nargout >= 3
                DateNumber = 726834;  %datenum('1-Jan-1990');
                for k = 1:length(h)
                    result{1} = mca(60,h(k));
                    day = result{1}(1,1);   % Days in seconds
                    nsec = result{1}(1,2);  % nanoseconds

                    % The EPICS epoch is 1-Jan-1990
                    DataTime(k,1) = 24*3600*DateNumber + day + sqrt(-1)*nsec;
                end
            end
        end
        
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

