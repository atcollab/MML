function [Data, t, StartTime, EndTime] = getmysqldata(ColumnNames, StartTime, EndTime, Table, User, DataBaseName)
%GETMYSQLDA - Returns data from a mysql database
%  [Data, t, StartTime, EndTime] = getmysqldata(ColumnNames, StartTime, EndTime, Table, User, DataBaseName)
%
%  INPUTS
%  1.   ColumnNames
%  2-3. StartTime and EndTime can be a string in the Oracle format,
%       yyyy-mm-dd hh:mm:ss like 2002-06-18 16:56:00
%       or something that datastr recognized, like a date serial 
%       number (see help datenum) or a vector with [y m d h m s] format.
%  4-5. User and Table are the database name and table name
%                       
%
%  OUTPUTS
%  1. Data is a matrix of history data where each column is a different point in time. 
%  2. t is in Matlab's serial date format [days].  Convert to other formats using
%     datestr or datevec.  datetick converts a plot axis to more reasonable text.
%
%
%  EXAMPES  
%  1. Get and plot one hour and six minutes of beam current data on Feb. 12, 2006
%     [d, t, StartTime, EndTime] = getmysqldata(family2channel('BPMx'), '2006-02-12 16:50:00', '2006-02-12 17:50:06');
%                     or
%     [d, t, StartTime, EndTime] = getmysqldata(family2channel('BPMx'), [2006 2 12 16 50 00], [2006 2 12 17 56 00]);
%     [d, t, StartTime, EndTime] = getmysqldata(family2channel('BPMx'), [2006 2 12 16 50 00], [2006 2 12 17 56 00]);
%
%     plot(t,d); datetick('x');
%        or
%     plot(24*(t-floor(t(1))), d); xlabel(sprintf('Time in Hours Starting at %s', StartTime));
%
%  2. Get all the BPMx and DCCT data in the table
%     Note: if the start and end time is not included in the second call 
%           the data and time vectors may not match.
%     [d, t, StartTime, EndTime] = getmysqldata(family2channel('BPMx'));
%     [d, t] = getmysqldata('DCCT', StartTime, EndTime);
%
%  3. For data valid only during user beam  
%     [i,t] = getmysqldata('UserBeam', StartTime, EndTime);
%     d(:,find(i==0)) = NaN;
%
%  See also archive_sr archive_size
%
%  Written by Greg Portmann



% Input checking
if nargin < 1
    Family = 'DCCT';
end
if nargin < 2
    StartTime = ''; % '2006-02-10 10:56:53';
end
if nargin < 3
    EndTime   = ''; % '2006-02-10 10:56:58';
end
if nargin < 4
    Table = 'SRLOG';
end
if nargin < 5
    %User = 'crdev';
    %User = 'cgsrv';
    %User = 'croper';
    %User = 'crdev';
    %User = 'physdata';
    if strcmpi(getenv('LOGNAME'), 'alsoper')
        User = 'physdata';
    else
        User = 'root';
    end
end
if nargin < 6
    %mysql('use Hiroshi');
    %mysql('use controls');
    %mysql('use phys');
    DataBaseName = 'physlogs';
end


% Fix start/end time formats
if ~isempty(StartTime) %~isstr(StartTime)
    try
        StartTime = datestr(StartTime,31);
    catch
    end
end
if ~isempty(EndTime) %~isstr(EndTime)
    try
        EndTime = datestr(EndTime,31);
    catch
    end
end




%%%%%%%%%%%%%%%%%%%%%
% Open a connection %
%%%%%%%%%%%%%%%%%%%%%

Host = 'thor.als.lbl.gov';  
%User = 'physdata';


if strcmp(User, 'physdata')
    PassWord = 'EightBall';
elseif strcmp(User, 'root')
    PassWord = 'EightBall';
    %PassWord = '';
else
    [User, PassWord] = logindlg('MySQL Connection', User);
end

if ~isempty(User)
    OpenResult = mysql('open', Host, User, PassWord);
else
    fprintf
    return
end
clear PassWord



%%%%%%%%%%%%%%%%%%%%%
% Select a database %
%%%%%%%%%%%%%%%%%%%%%

mysql(['use ', DataBaseName]);


% ID    = mysql('select ID from rampdb');
% Name  = mysql('select Name from rampdb');
% Count = mysql('select Count from rampdb');
Data  = mysql('select Data from rampdb');


% Time is in days
%[t, data(:,i)] = mysql('select Time,  from rampdb');
%StartTime = datestr(t(1),31);
%EndTime   = datestr(t(end),31);


%%%%%%%%%%%%%%%%%%%%%%
% Close the database %
%%%%%%%%%%%%%%%%%%%%%%
mysql('close');


% % Arrange time by columns (like getpv) 
% t = t';
% data = data';



