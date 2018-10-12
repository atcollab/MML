function varargout = getliberafadata(varargin)
%
% fadata = GETLIBERAFADATA(end_date,[keyword_pairs])
%
% END_DATE = end of the data acquisition
%
% The default without any other parameters is to return 10,000 samples of
% 10kHz data up undil the END_DATE
%
% NOTE: the date format can be the Matlab numeric format (i.e. output of
% the function 'datenum')
%
% KEYWORD_PAIRS:
%
%   'decimation' = 'F' -> 10 kHz
%                  'd' -> 10058/64 decimated
%                  'D' -> 10058/16384 decimated
%   'start'   = start date 'dd/mm/yyyy HH:MM:SS' format
%
% E.g.
%
% fadata = getliberafadata('4/2/2013 09:00:00');
% fadata = getliberafadata(now);
% getliberafadata('4/2/2013 09:00:00')
%
% 4/2/2013 Eugene. Beta release.
%
%
% if length of first parameter is equal to 1 and is numeric
%  retreive data using the first parameter as offset in seconds till now
% else if length of first parameter is equal to 1 and is a character array
%  retrieve data using the frist parameter as a date till now
% else if length of first parameter is equal to 2 and is numeric
%  retrieve data using the two numbers as datenum in Matlab formatl.
% else if length of first parameter is equal to 2 and is a character array
%  retrive data using the two character strings as date in Matlab format
% else
%  don't know what you want
% end

[reg, prop] = parseparams(varargin);
sec2day = inline('x/(24*60*60)');

if nargin > 0
    if isempty(reg)
        reg{1} = prop{1};
        prop = {prop{2:end}};
    end
    
    if ischar(reg{1})
        enddate = datenum(reg{1},'dd/mm/yyyy HH:MM:SS');
    else
        enddate = reg{1};
    end
    
    if abs(now - enddate) < sec2day(5)
        % If the enddate is too close to the current time period it can
        % cause problems with the archiver, so wait 5 seconds.
        pause(5);
    end
    
else
    disp('Need an end date.');
    return
end

% defaults
decimation = 'F';
startdate = [];
for i=1:length(prop)/2
    ind = (i-1)*2+1;
    switch lower(prop{ind})
        case 'decimation'
            decimation = prop{ind+1};
        case 'start'
            if ischar(prop{ind+1})
                startdate = datenum(prop{ind+1},'dd/mm/yyyy HH:MM:SS');
            else
                startdate = prop{ind+1};
            end
    end
end

% dt = time period per sample
switch decimation
    case 'F'
        dt = 1/10058;
    case 'd'
        dt = 64/10058;
    case 'D'
        dt = 64/10058;
end
        
if isempty(startdate)
    % Default 10000 samples grab a bit more so we don't accidentally have
    % less than 10000.
    startdate = datenum(enddate) - sec2day(10100*dt);
    
    defaultsused = 1;
else
    defaultsused = 0;
end

temp = fa_load([startdate enddate],[1:98],decimation,'10.17.100.25');
% temp = fa_load([startdate enddate],[18],decimation,'10.17.100.25');

if strcmpi(decimation,'F')
    if defaultsused
        % Just return everything so dont' truncate to 10000 Eugene
        % 24/10/2016
%         temp.data = temp.data(:,:,1:10000);
%         temp.t = temp.t(1:10000);
    end
    temp.x = squeeze(temp.data(1,:,:));
    temp.y = squeeze(temp.data(2,:,:));
    temp = rmfield(temp,'data');
    temp.DeviceList = elem2dev('BPMx',temp.ids);
    temp.timestamp = datestr(temp.timestamp);
else
    if defaultsused
        % Just return everything so dont' truncate to 10000 Eugene
        % 24/10/2016
%         temp.data = temp.data(:,:,:,1:10000);
%         temp.t = temp.t(1:10000);
    end
    
    n = size(temp.data,3);
    
    temp.x     = squeeze(temp.data(1,1,:,:));
    temp.xmin  = squeeze(temp.data(1,2,:,:));
    temp.xmax  = squeeze(temp.data(1,3,:,:));
    temp.xstd  = squeeze(temp.data(1,4,:,:));
    
    temp.y     = squeeze(temp.data(2,1,:,:));
    temp.ymin  = squeeze(temp.data(2,2,:,:));
    temp.ymax  = squeeze(temp.data(2,3,:,:));
    temp.ystd  = squeeze(temp.data(2,4,:,:));
    
    temp = rmfield(temp,'data');
    temp.DeviceList = elem2dev('BPMx',temp.ids);
    temp.timestamp = datestr(temp.timestamp);
end
varargout{1} = orderfields(temp);


