function [AM, tout, DataTime, ErrorFlag] = getpvonline(TangoNames, Field, varargin);
%GETPVONLINE - Get the online value
%  [AM, DataTime, ErrorFlag] = getpvonline(TangoNames, N, DataType);
%
%  INPUTS
%  1. TangoNames
%  2. Field - 'Monitor' or 'Setpoint'
%  3. N - Number of data points to return {Default: 1}
%    (only used for 'Vector', 'Waveform', and 'Matrix' DataTypes)
%  4. DataType - 'double' or 'string'
%  5. t - time vector of when to start a read [seconds]
%  6. NAverage - Number of averages per data point {Default: 1}
%  7. AvgSamplePeriod - Sample period when averaging [seconds] {Default: .1}
%
%  OUTPUTS
%  1. AM - Value
%  2. tout - Local computer time on finish of data read
%  3. DataTime = time (in seconds) since 00:00:00, Jan 1, 1970
%                 (seconds + nanoseconds * i)
%  4. ErrorFlag (Presently not functional.  All errors will cause a Matlab error.)
%
%  EXAMPLES
%  1. get one data  with a 3 second delay
%     getpvonline('ANS-C01/AEsim/S1-CH/current',3)
%  2. 5 averages witha periode of 1 second 
%    getpvonline('ANS-C01/AEsim/S1-CH/current','Setpoint','Double',1,0,5,1)
%    getpvonline('ANS-C01/AEsim/S1-CH/current','Setpoint',0,5,1)
% See also setpvonline

%
%  Written for by Laurent S. Nadolski

%% TODO groups

% Function start time
t0 = clock;

if nargin < 1
    error('Must have at least a TangoName input');
end

if ~exist('Field','var')
    field = 'Monitor';
else
    field = Field;
end
                                                                                                                                
DataType = 'Double';
N = 0;
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

ErrorFlag = 0;

ExtraTimedelay = etime(clock,t0);
[AM, tout, DataTime, ErrorFlag] = readattribute(TangoNames, field, t - ExtraTimedelay);
tout = tout + ExtraTimedelay;

% Averaging
if NAvg > 1
    toutall = tout;
    AMavg = AM;
    for k = 2:NAvg,        
        % Warning do no take into account time for getting the date
        tdelay = AvgPeriod-tout
        [AM, tout, DataTime, ErrorFlag] = readattribute(TangoNames, field, tdelay);
        toutall = toutall + tout        
        tout = tout - tdelay;
        AMavg = AMavg + AM;
    end
    AM = AMavg / NAvg;
    tout = toutall;
end

% format to a column vector
AM = AM(:);
