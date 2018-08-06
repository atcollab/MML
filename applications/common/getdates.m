function [varargout] = getdates(startdate, enddate, varargin)

% 'GETDATES' RETURNS THE DAYS BETWEEN TWO DATES USING THE GREGORIAN 
% CALENDAR SYSTEM AND CAN FILTER RESULTS BASED ON DAY AND DATE INCLUSION OR
% EXCLUSION CRITERIA.
%
% VARARGOUT = getdates(STARTDATE, ENDDATE, VARARGIN)
%
% STARTDATE input may be a string of format 'YYYYMMDD' or a numeric scalar
% of format YYYYMMDD.
%
% ENDDATE input may be a string of format 'YYYYMMDD' or a numeric scalar of
% format YYYYMMDD.
%
% VARARGIN optional input may be used to specify output formats as well as
% filtering criteria (see description below).
%
% -------------------------------------------------------------------------
% OUTPUTS MAY BE SPECIFIED IN ONE OF TWO WAYS:
%
% 1.) OUTPUT SINGLE STRUCTURE (default)
%
% [OUTPUT] = getdates(STARTDATE, ENDDATE, VARARGIN)
%
% OUTPUT.dates -- 
% Contains the dates from STARTDATE up to and including ENDDATE. Each entry
% in this field may be in {'YYYYMMDD'} (cell string), 'YYYYMMDD' (character
% array), or YYYYMMDD (numeric) format depending on the formatting
% specified through VARARGIN optional input. If format is not specified,
% the default for this field is numeric YYYYMMDD.
% 
% OUTPUT.days --
% Contains the days for each date. Possible formats are cell string,
% character array, or numeric depending on the formatting specified through
% VARARGIN. If format is not specified, the default for this field is
% numeric. (See VARARGIN description below.)
%
% 2.) OUTPUT SEPARATE ARRAYS
%
% [DATES, DAYS] = getdates(STARTDATE, ENDDATE, VARARGIN)
% 
% DATES will be a column array containing the dates from STARTDATE up to
% and including ENDDATE. Each entry in DATES may be formatted {'YYYYMMDD'}
% (cell string), 'YYYYMMDD' (character array), or YYYYMMDD (numeric array)
% format depending on VARARGIN optional input. DATES may be ascending or
% descending depending on the order that STARTDATE and ENDDATE are
% specified. If format is not specified, the default is numeric YYYYMMDD.
%
% DAYS will be a column array containing the days for each date. DAYS may
% be a cell array of strings, a character array, or a numeric array,
% depending on the formatting specified through VARARGIN. If format is not
% specified, the default is numeric (see table below).
%
% -------------------------------------------------------------------------
% VARARGIN SETTINGS
%
% Output formatting and day/date filtering criteria may be specified
% through VARARGIN optional input. VARARGIN settings should be specified
% using Property/Value pairs. Properties should always be specified as
% strings. Values may be specified as strings, matrices, or cells depending
% on the property being set.
%
% -------------------------------------------------------------------------
% 'DATEFORMAT' property determines the formatting for output dates. It may
% be set to one of the following strings:
%
% 'cellstring'  -- Output dates will be a cell array of strings with format
%                   {'YYYYMMDD'}.
% 'char'        -- Output dates will be a character array with format
%                   ['YYYYMMDD'].
% 'numeric'     -- Output dates will be a numeric array with format
%                   [YYYYMMDD] (default).
%
% -------------------------------------------------------------------------
% 'DAYFORMAT' property determines the formatting for output days. It may be
% set to one of the following strings:
%
% 'cellstring'  -- Output days will be returned as a cell array of strings
%                   {'mon'}
%                   {'tue'}
%                   {'wed'}
%                   {'thu'}
%                   {'fri'}
%                   {'sat'}
%                   {'sun'}
%
% 'char'        -- Output days will be returned as a character array
%                   ['mon']
%                   ['tue']
%                   ['wed']
%                   ['thu']
%                   ['fri']
%                   ['sat']
%                   ['sun']
%
% 'numeric'     -- Output days will be returned as a numeric array
%                   [1] = Mon
%                   [2] = Tue
%                   [3] = Wed
%                   [4] = Thu
%                   [5] = Fri
%                   [6] = Sat
%                   [7] = Sun
%                   (default)
%
% -------------------------------------------------------------------------
% 'INCLUDEDAYS' property may be used to specify which days will be returned
% by the output, excluding all other dates which do not fall on the
% specified day(s). This property must be set using a numeric vector.
%
% Example:
% If 'includedays' is set to [2 6 7], only the dates which fall on a
% Tuesday, Saturday, and Sunday will be included in the output. All other
% dates will be omitted. (Refer to numeric table in the 'DAYFORMAT'
% property above.)
%
% -------------------------------------------------------------------------
% 'EXCLUDEDAYS' property may be used to specify which days will be excluded
% from the output, returning all other dates which do not fall on the
% specified day(s). This property must be set using a numeric vector.
%
% Example:
% If 'excludedays' is set to [4 6], all dates that fall on a Thursday or
% Saturday will be excluded from the output. The output will only contain
% dates that fall on the remaining days (Monday, Tuesday, Wednesday,
% Friday, Sunday). (Refer to numeric table in the 'DAYFORMAT' property
% above.)
%
% -------------------------------------------------------------------------
% NOTE: THE 'INCLUDEDAYS' AND 'EXCLUDEDAYS' PROPERTIES ARE MUTUALLY
% EXCLUSIVE. IF USED, YOU MUST SPECIFY ONE *OR* THE OTHER, BUT NOT BOTH.
% ATTEMPTING TO SET BOTH PROPERTIES AT THE SAME TIME WILL RESULT IN AN
% ERROR.
% 
% -------------------------------------------------------------------------
% 'BLACKOUTDATES' property may be used to specify which dates will be
% excluded from the output. This property may be specified using a cell
% array of strings of format {'YYYYMMDD'}, a character array of format
% ['YYYYMMDD'], a numeric array of format [YYYYMMDD], or a numeric cell
% array of format {YYYYMMDD}. Multiple "blackout" dates may be specified
% and are applied IN ADDITION TO the 'INCLUDEDAYS' or 'EXCLUDEDAYS'
% filters.
%
% Example:
% If 'blackoutdates' is set to: [20070821, 20080119, 20080229] -- after the
% 'INCLUDEDAYS' or 'EXCLUDEDAYS' criteria have been applied, these dates,
% if still present, will be purged from the output.
%
% -------------------------------------------------------------------------
% USAGE EXAMPLES:
%
% 1.) Return a date/day structure from August 15, 2007 through February 6, 
%       2008 using default settings:
%
%       [mystruct] = getdates('20070815','20080206');
%
% 2.) Return dates and days from August 15, 2007 through February 6, 2008 
%       that fall on a Monday through Friday:
%
%       [dates,days] = getdates(20070815,20080206,'includedays',[1:5]);
%
% 3.) Return dates and days from August 15, 2007 through April 28, 2010,
%       excluding any days that fall on a Wednesday or Sunday:
%
%       [dates,days] = getdates('20070815',20100428,'excludedays',[3 7]);
%
% 4.) Return dates and days from January 1, 2007 through January 6, 2008.
%       Display day names as characters. Exclude the following dates:
%       2007-05-20, 2007-11-04, 2008-01-01. Only include dates that fall on
%       a Tuesday, Thursday, Friday, and Sunday:
%
%       [dates,days] = getdates(20070101,'20080106','dayformat','char',...
%                       'blackoutdates',[20070520 20071104 20080101],...
%                       'includedays',[2 4 5 7]);
%
%                                                             Adrian Abordo
%                                                        Revised 2008-02-25

% -------------------------------------------------------------------------
% Begin core algorithm:
if ischar(startdate) == 1,
    sy = str2double(startdate(1:4));
    sm = str2double(startdate(5:6));
    sd = str2double(startdate(7:8));
    century = str2double(startdate(1:2));
    year = str2double(startdate(3:4));
    startdate = str2double(startdate);
else
    startdate = num2str(startdate);
    sy = str2double(startdate(1:4));
    sm = str2double(startdate(5:6));
    sd = str2double(startdate(7:8));
    century = str2double(startdate(1:2));
    year = str2double(startdate(3:4));
    startdate = str2double(startdate);
end
if ischar(enddate) == 1,
    enddate = str2double(enddate);
end

switch sm,
    case 1,
        if isleap(sy) == 0,
            mc = 0;
        else
            mc = 6;
        end
    case 2,
        if isleap(sy) == 0,
            mc = 3;
        else
            mc = 2;
        end
    case 3,
        mc = 3;
    case 4,
        mc = 6;
    case 5,
        mc = 1;
    case 6,
        mc = 4;
    case 7,
        mc = 6;
    case 8,
        mc = 2;
    case 9,
        mc = 5;
    case 10,
        mc = 0;
    case 11,
        mc = 3;
    case 12,
        mc = 5;
end
c = (3 - mod(century,4)) * 2;
y = year + floor(year/4);
daysum = c + y + mc + sd;
sdcode = mod(daysum,7);

dates = spandates(startdate,enddate);
daycodes = ones(size(dates))*NaN;
for k = 1:7,    
    daycodes(k:7:end) = sdcode;
    if startdate <= enddate,
        if sdcode < 6,
            sdcode = sdcode + 1;
        else
            sdcode = 0;
        end
    else
        if sdcode > 0,
            sdcode = sdcode - 1;
        else
            sdcode = 6;
        end        
    end
end
daycodes(daycodes == 0) = 7;
% End core algorithm
% -------------------------------------------------------------------------

dateformat = 'numeric';
dayformat = 'numeric';
if isempty(varargin) == 0,        
    varargin_property_names = cell(1,3);
    varargin_property_values = cell(1,3);
    matchindex = 0;
    for k = 1:length(varargin),
        if ischar(varargin{k}) == 1,
            varargin{k} = lower(varargin{k});
            % Check for VARARGIN filtering criteria first
            I = strmatch(varargin{k},{'includedays' 'excludedays'...
                'blackoutdates'});
            if isempty(I) == 0,
                matchindex = matchindex + 1;
                varargin_property_names{matchindex} = varargin{k};
                varargin_property_values{matchindex} = varargin{k + 1};
            end
            % Check for VARARGIN formatting criteria next
            if strcmp(varargin{k},'dateformat') == 1,
                dateformat = lower(varargin{k+1});
            elseif strcmp(varargin{k},'dayformat') == 1,
                dayformat = lower(varargin{k+1});
            end
        end
    end
    varargin_property_names = {varargin_property_names{1:matchindex}};
    varargin_property_values = {varargin_property_values{1:matchindex}};
    
    % check for filtering conflicts
    I1 = strmatch('includedays',varargin_property_names);
    I2 = strmatch('excludedays',varargin_property_names);
    if isempty(I1) == 0 && isempty(I2) == 0,
        error(['VARARGIN ''includedays'' and ''excludedays'' settings '...
            'cannot both be specified at the same time. Choose one or '...
            'the other.'])
    end
    
    % Remove blackoutdates first:
    I = strmatch('blackoutdates',varargin_property_names);
    if isempty(I) == 0,
        blackoutdates = varargin_property_values{I};
        if iscell(blackoutdates) == 1 && iscellstr(blackoutdates) == 0,
            blackoutdates = cell2mat(blackoutdates);
        end
        if iscellstr(blackoutdates) == 1,
            blackoutdates = char(blackoutdates);
        end
        if ischar(blackoutdates) == 1,
            blackoutdates = str2num(blackoutdates);
        end       
        for k = 1:length(blackoutdates),
           dates(dates == blackoutdates(k)) = 0; 
        end
        daycodes = daycodes(dates ~= 0);
        dates = dates(dates ~= 0);
    end
    
    % Satisfy includedays (if specified)
    I = strmatch('includedays',varargin_property_names);
    if isempty(I) == 0,
        includedays = varargin_property_values{I};
        excludedays = setdiff(1:7,includedays);
        for k = 1:length(excludedays),
           daycodes(daycodes == excludedays(k)) = 0;
        end
        dates = dates(daycodes ~= 0);
        daycodes = daycodes(daycodes ~= 0);
    end
    
    % Satisfy excludedays (if specified)
    I = strmatch('excludedays',varargin_property_names);
    if isempty(I) == 0,
        excludedays = varargin_property_values{I};
        for k = 1:length(excludedays),
           daycodes(daycodes == excludedays(k)) = 0;
        end
        dates = dates(daycodes ~= 0);
        daycodes = daycodes(daycodes ~= 0);
    end    
end

% Assign day names (which may be needed later)
daynames = zeros(length(dates),3);
mon = find(daycodes == 1);
tue = find(daycodes == 2);
wed = find(daycodes == 3);
thu = find(daycodes == 4);
fri = find(daycodes == 5);
sat = find(daycodes == 6);
sun = find(daycodes == 7);
daynames(mon,:) = repmat('mon',length(mon),1);
daynames(tue,:) = repmat('tue',length(tue),1);
daynames(wed,:) = repmat('wed',length(wed),1);
daynames(thu,:) = repmat('thu',length(thu),1);
daynames(fri,:) = repmat('fri',length(fri),1);
daynames(sat,:) = repmat('sat',length(sat),1);
daynames(sun,:) = repmat('sun',length(sun),1);
daynames = char(daynames);

if nargout == 1 || nargout == 0,
    % pre-allocation
    outstruct(length(dates)).dates = NaN;
    outstruct(length(dates)).days = NaN;
    for k = 1:length(dates),
        switch dateformat            
            case 'cellstring'
                outstruct(k).dates = cellstr(num2str(dates(k)));           
            case 'char'
                outstruct(k).dates = num2str(dates(k));
            case 'numeric'
                outstruct(k).dates = dates(k);
            otherwise
                error('Invalid ''dateformat'' specified.')  
        end
        switch dayformat            
            case 'cellstring'
                outstruct(k).days = cellstr(daynames(k,:));           
            case 'char'
                outstruct(k).days = daynames(k,:);
            case 'numeric'
                outstruct(k).days = daycodes(k);
            otherwise
                error('Invalid ''dayformat'' specified.')  
        end
    end
    varargout = {outstruct};
elseif nargout == 2,
    switch dateformat
        case 'cellstring'
            dates = cellstr(num2str(dates));
        case 'char'
            dates = num2str(dates);
        case 'numeric'
            % no need to do anything
        otherwise
            error('Invalid ''dateformat'' specified.')
    end
    varargout{1} = dates;
    switch dayformat
        case 'cellstring'
            varargout{2} = cellstr(daynames);
        case 'char'
            varargout{2} = daynames;
        case 'numeric'
            varargout{2} = daycodes;
        otherwise
            error('Invalid ''dayformat'' specified.')
    end
elseif nargout > 2,
    error('Too many outputs specified.')
end


function [dates] = spandates(startdate,enddate,varargin)

% 'SPANDATES' RETURNS THE CALENDAR DATES FROM STARTDATE TO ENDDATE.
%
% STARTDATE input may be a string of format 'YYYYMMDD' or a numeric scalar
% of format YYYYMMDD.
%
% ENDDATE input may be a string of format 'YYYYMMDD' or a numeric scalar
% of format YYYYMMDD.
%
% VARARGIN optional input may be used to specify the date format. If
% specified, it must be a string and may be one of three possible entries:
% 'cellstring' -- DATES output will be a vertical cell array of strings.
% 'char'       -- DATES output will be a vertical character array.
% 'numeric'    -- DATES output will be a vertical numeric vector (default).
%
% If VARARGIN is omitted, 'numeric' is assumed.
%
% DATES output will be a vertical array containing the dates from STARTDATE
% up to and including ENDDATE. Each entry in DATES will be formatted
% {'YYYYMMDD'}, 'YYYYMMDD', or YYYYMMDD depending on VARARGIN optional
% input. DATES will be a vertical array and may be ascending or descending
% depending on the order that STARTDATE and ENDDATE are specified.

if ischar(startdate) == 1,
    cy = str2double(startdate(1:4));
    sm = str2double(startdate(5:6));
    sd = str2double(startdate(7:8));
    startdate = str2double(startdate);
else
    chardate = num2str(startdate);
    cy = str2double(chardate(1:4));
    sm = str2double(chardate(5:6));
    sd = str2double(chardate(7:8));
end

if ischar(enddate) == 1,
    enddate = str2double(enddate);
end

if enddate < startdate,
    dates = spandates(enddate,startdate);
    dates = flipud(dates);
    return    
end
      
numdays = daysbetweendates(startdate,enddate);

% pre-allocation
dates = cell(numdays+1,1);

k = 1;
while true
    if isleap(cy) == 0,
        days_per_month = [31 28 31 30 31 30 31 31 30 31 30 31];
    else
        days_per_month = [31 29 31 30 31 30 31 31 30 31 30 31];
    end   
    for cm = sm:12,        
        for cd = sd:days_per_month(cm),
            dates{k} = [sprintf('%04d',cy) sprintf('%02d',cm)...
                sprintf('%02d',cd)];
            if str2double(dates{k}) < enddate,
                k = k + 1;
            else
                if isempty(varargin) == 0,
                    dateformat = varargin{1};
                    switch lower(dateformat)
                        case 'cellstring'
                            return
                        case 'char'
                            dates = char(dates);
                            return
                        case 'numeric'
                            dates = char(dates);
                            dates = str2num(dates);
                            return
                        otherwise
                            error(['Invalid VARARGIN date format '...
                                'specified.'])
                    end
                else
                    dates = char(dates);
                    dates = str2num(dates);
                    return
                end
            end
        end
        sd = 1;
    end    
    sm = 1;
    cy = cy + 1;
end


function [days] = daysbetweendates(startdate,enddate)

% 'DAYSBETWEENDATES' CALCULATES THE NUMBER OF DAYS BETWEEN TWO DATES.
%
% 'STARTDATE' input may be a string of format 'YYYYMMDD' or a numeric
% scalar of format YYYYMMDD.
%
% 'ENDDATE' input may be a string of format 'YYYYMMDD' or a numeric
% scalar of format YYYYMMDD.
%
% DAYS output will be a numeric scalar specifying the number of days
% elapsed from STARTDATE 00:00 hour up to ENDDATE 00:00 hour.
%
% This function uses the Gregorian calendar system.

if ischar(startdate) == 1,
    sy = startdate(1:4);
    startdate = str2double(startdate);
else
    chardate = num2str(startdate);
    sy = chardate(1:4);   
end
if ischar(enddate) == 1,
    ey = enddate(1:4);
    enddate = str2double(enddate);   
else
    chardate = num2str(enddate);
    ey = chardate(1:4);        
end
if enddate < startdate,
    days = daysbetweendates(enddate,startdate);
    days = -days;
    return
end

days = daysbetweenyears(sy,ey) + dayswithinyear(enddate) - ...
    dayswithinyear(startdate);


function [days] = daysbetweenyears(startyear,endyear)

% 'DAYSBETWEENYEARS' CALCULATES THE NUMBER OF DAYS BETWEEN STARTYEAR AND
% ENDYEAR.
%
% STARTYEAR input must be a string or numeric scalar.
% ENDYEAR input must be a string or numeric scalar.
%
% DAYS output will be a scalar specifying the number of days elapsed from
% STARTYEAR January 1 00:00 hour to ENDYEAR January 1 00:00 hour.
%
% This function uses the Gregorian calendar system.

if ischar(startyear) == 1,
    startyear = str2double(startyear);
end

if ischar(endyear) == 1,
    endyear = str2double(endyear);
end

years = startyear:endyear-1;

if isempty(years) == 0,
    leap = isleap(years);
    leap(leap == 0) = 365;
    leap(leap == 1) = 366;
    days = sum(leap);
else
    days = 0;
end


function [days] = dayswithinyear(inputdate)

% 'DAYSWITHINYEAR' CALCULATES THE NUMBER OF DAYS ELAPSED FROM THE START OF
% THE INPUT YEAR UP TO THE SPECIFIED INPUT DATE.
%
% INPUTDATE may be a string of format 'YYYYMMDD' or a numeric scalar of
% format YYYYMMDD.
%
% DAYS output will be a scalar specifying the number of days elapsed from
% January 1 00:00 hour of the input year up to the start (00:00 hour) of
% the specified input date.
%
% This function uses the Gregorian calendar system.

if ischar(inputdate) == 1,
    y = str2double(inputdate(1:4));
    m = str2double(inputdate(5:6));
    d = str2double(inputdate(7:8));
else
    inputdate = num2str(inputdate);
    days = dayswithinyear(inputdate);
    return
end

if isleap(y) == 0,
    days_per_month = [31 28 31 30 31 30 31 31 30 31 30 31];
else
    days_per_month = [31 29 31 30 31 30 31 31 30 31 30 31];
end

if d > days_per_month(m),
    error('Specified date exceeds number of days for specified month.')
end

days = sum(days_per_month(1:m-1)) + d - 1;


function [leap] = isleap(year)

% 'ISLEAP' FUNCTION DETERMINES WHETHER AN INPUT YEAR IS A LEAP YEAR.
%
% This function uses the Gregorian calendar system.
%
% YEAR input may be a string 'YYYY' or a number. It may also be a vector.
%
% LEAP output = 1 if YEAR is a leap year.
% LEAP output = 0 if YEAR is NOT a leap year.
%
% If YEAR is a vector, LEAP output will be a vector of the same shape, and
% LEAP(K) = 1 where YEAR(K) is a leap year, and LEAP(K) = 0 where YEAR(K)
% is NOT a leap year.

if ischar(year) == 1,
    year = str2num(year);
end

leap = zeros(size(year));

mod4 = mod(year,4);
mod100 = mod(year,100);
mod400 = mod(year,400);
mod4000 = mod(year,4000);

leap(mod4 == 0) = 1;
leap(mod100 == 0) = 0;
leap(mod400 == 0) = 1;
leap(mod4000 == 0) = 0;