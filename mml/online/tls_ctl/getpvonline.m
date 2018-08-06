function [AM, tout, DataTime, ErrorFlag] = getpvonline(ChannelNames, varargin)
%GETPVONLINE - Get the online value via EPICS channel access
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
%  2. DataType - 'Double', 'char' (or 'String'), 'Vector' or 'Waveform', 'Matrix' {Default: 'Double'}
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
%  See also setpvonline, getpv, setpv

%  Written by Greg Portmann

ErrorFlag = 0;

% Function start time
t0 = clock;

if nargin < 1
    error('Must have at least a channel name input');
end

% Input parsing
DataType = '';
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


if isempty(ChannelNames)
    return
end


% Convert to cell and look for blanks
if ~iscell(ChannelNames)
    ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
end


% Vectorized Get
% There can be multiple channel names due to "ganged" power supplies (or redundent user input)
[ChannelNames, i, j] = unique(ChannelNames);


% Remove ' ' and fill with NaN latter (' ' should always be the first row)
if isempty(deblank(ChannelNames(1,:)))
    iblank = 1;
    ChannelNames(1,:) = [];
else
    iblank = [];
end


if ~isempty(ChannelNames)    
    if any(strcmpi(DataType, {'string','char'}))
        error('char gets not available!');

    elseif any(strcmpi(DataType, {'Matrix','Waveform'}))
        error('Waveform gets not available!');

    else
        
        ExtraTimeDelay = etime(clock, t0);
        t = t-ExtraTimeDelay;

        % Get data
        AM = [];
        DataTime = [];
        t = t - ExtraTimeDelay;
        for itime = 1:length(t)
            T = t(itime)-etime(clock, t0);
            if T > 0
                pause(T);
            end

        % Get data Output or Input data
        if strcmpi(DataType, 'Output')
            if length(ChannelNames) > 1
                tmp = ctl_mreadout(ChannelNames);
            else
                tmp = ctl_readout(ChannelNames);
            end
        else % if strcmpi(DataType, 'Input')
            if length(ChannelNames) > 1
                tmp = ctl_mreadin(ChannelNames);
            else
                tmp = ctl_readin(ChannelNames);
            end
        end

            t1 = clock;
            days = datenum(t1(1:3)) - 719529;  %datenum('1-Jan-1970');
            tt = 24*60*60*days + 60*60*t1(4) + 60*t1(5) + t1(6);
            tmpTime = fix(tt) + rem(tt,1)*1e9*sqrt(-1);
            tmpTime = tmpTime * ones(size(tmp,1),1);

            if N > 0
                tmp = tmp(:,1:N);
            end

            AM = [AM tmp];
            DataTime = [DataTime tmpTime];
            tout(1,itime) = etime(clock, t0);
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
if ~isempty(AM)
    AM = AM(j,:);
    if nargout >= 3
        DataTime = DataTime(j,:);
    end
end


% For debug
% function AM = ctl_readin(ChannelNames)
% AM  = randn(size(ChannelNames));
% 
% function AM = ctl_mreadin(ChannelNames)
% AM  = randn(size(ChannelNames));
% 
% function AM = ctl_readout(ChannelNames)
% AM  = randn(size(ChannelNames));
% 
% function AM = ctl_mreadout(ChannelNames)
% AM  = randn(size(ChannelNames));
