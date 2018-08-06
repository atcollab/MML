function [data, t, StartTime, EndTime, TableName, DataBaseName] = getmysqldata(ColumnNames, StartTime, EndTime, TableName, DataBaseName, PassWord)
%GETMYSQLDA - Returns data from a mysql database
%  [Data, t, StartTime, EndTime, TableName, DataBaseName] = getmysqldata(ColumnNames, StartTime, EndTime, TableName, DataBaseName, PassWord)
%
%  INPUTS
%  1.   ColumnNames
%  2-3. StartTime and EndTime can be a string in the Oracle format,
%       yyyy-mm-dd hh:mm:ss like 2002-06-18 16:56:00
%       or something that datastr recognized, like a date serial 
%       number (see help datenum) or a vector with [y m d h m s] format.
%  4.   TableName (like, 'SRLOG2008')
%  5.   DataBaseName (usually 'physlogs')
%  6.   PassWord
%
%  OUTPUTS
%  1. Data is a matrix of history data where each column is a different point in time. 
%  2. t is time as returned by datenum (days).  Convert to other formats using datestr or datevec.
%     datetick converts a plot axis to more reasonable text.
%  3-6.  Same as inputs
%
%  EXAMPES  
%  1. Get and plot one hour and six minutes of beam current data on Feb. 12, 2006
%     [d, t, StartTime, EndTime] = getmysqldata(family2archive('BPMx'), '2006-03-07 16:50:00', '2006-03-08 17:50:06');
%                     or
%     [d, t, StartTime, EndTime] = getmysqldata(family2archive('BPMx'), [2006 2 12 16 50 00], [2006 2 12 17 56 00]);
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
%  See also archive_sr, archive_size, plotmysqlorbit, showdatabases

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
    TableName = '';
end
if nargin < 5
    User = 'physdata';
    %if strcmpi(getenv('LOGNAME'), 'alsoper')
    %    User = 'physdata';
    %else
    %    User = 'root';
    %end
end
if nargin < 6
    DataBaseName = 'physlogs';
end
if nargin < 7
    PassWord = 'jjDeP9821&';
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

% Fine the table name
if isempty(TableName)
    DataBaseInfo = archive_sr('History');
    for i = 1:length(DataBaseInfo)
        if datenum(StartTime,'yyyy-mm-dd HH:MM:SS') >= datenum(DataBaseInfo(i).CreateDate,'yyyy-mm-dd HH:MM:SS') && datenum(EndTime,'yyyy-mm-dd HH:MM:SS') <= datenum(DataBaseInfo(i).LastUpdate,'yyyy-mm-dd HH:MM:SS')
            TableName = DataBaseInfo(i).Table;
            DataBaseName = DataBaseInfo(i).DataBase;
            break;
        end
        if i == length(DataBaseInfo)
            % StartTime & EndTime are not within a table, so try just the end time
            for j = 1:length(DataBaseInfo)
                if datenum(EndTime,'yyyy-mm-dd HH:MM:SS') <= datenum(DataBaseInfo(j).LastUpdate,'yyyy-mm-dd HH:MM:SS')
                    TableName = DataBaseInfo(j).Table;
                    DataBaseName = DataBaseInfo(j).DataBase;
                    break;
                end
                if j == length(DataBaseInfo)
                    archive_size;
                    error('Data table not found.');
                end
            end
        end
    end
    %if datenum(StartTime,'yyyy-mm-dd HH:MM:SS') <= datenum([2007 9 28 15 23 49]) && datenum(EndTime,'yyyy-mm-dd HH:MM:SS') <= datenum([2007 9 28 15 23 49])
    %    TableName = 'SRLOG2007b';
    %elseif datenum(StartTime,'yyyy-mm-dd HH:MM:SS') > datenum([2007 9 28 15 23 49]) && datenum(EndTime,'yyyy-mm-dd HH:MM:SS') > datenum([2007 9 28 15 23 49])
    %    TableName = 'SRLOG2007c';
    %else
    %    error('Data crosses a table.  Crossing tables is not programmed yet.  Sorry!');
    %end
end



%%%%%%%%%%%%%%%%%%%%%
% Open a connection %
%%%%%%%%%%%%%%%%%%%%%
Host = 'ps3.als.lbl.gov';
if ~isempty(User)
    OpenResult = mym('open', Host, User, PassWord);
else
    fprintf
    return
end
clear PassWord



%%%%%%%%%%%%%%%%%%%%%
% Select a database %
%%%%%%%%%%%%%%%%%%%%%

UseResult = mym(['use ', DataBaseName]);


% There can only be one table
TableName = deblank(TableName(1,:));


% % Build a common separated list of names 
% NameList = [];
% for i = 1:size(ColumnNames,1)
%     NameList = [NameList, ',', deblank(ColumnNames(i,:))];
% end

% SQLcommand = [
%     'select Time', NameList, ...
%     ' from ', TableName, ...
%     ' where Time between cast("', StartTime, '" as timestamp)', ...
%     ' and cast("', EndTime, '" as timestamp) order by TableIndex;'];


NameList = '';
for i = 1:size(ColumnNames,1)
    NameList = [NameList, deblank(ColumnNames(i,:)), ', '];
end
NameList(end-1:end) = [];

if isempty(StartTime)
    SQLcommand = ['select Time, ', NameList, ' from ', TableName, ' order by Time;'];
else
    if isempty(EndTime)
        % No end time
        SQLcommand = ['select Time, ', NameList, ' from ', TableName, ...
            ' where Time >= "', StartTime, '" order by Time;'];
    else
        % Both start and end time is input
        SQLcommand = ['select Time, ', NameList, ' from ', TableName, ...
            ' where Time between "', StartTime, '"', ...
            ' and "', EndTime, '" order by Time;'];
    end
end


% Get all the data at once
d = mym(SQLcommand);


%%%%%%%%%%%%%%%%%%%%%%
% Close the database %
%%%%%%%%%%%%%%%%%%%%%%
mym('close');


if isempty(d.Time)
    fprintf('   No data found.\n');
    data = [];
    StartTime = '';
    EndTime   = '';
    t = [];
    return;
end


% d.Time is a string
StartTime = d.Time{1};
EndTime   = d.Time{end};
t = datenum(d.Time,'yyyy-mm-dd HH:MM:SS');


% Build the output in columns
data = [];
for i = 1:size(ColumnNames,1)
    data = [data;  d.(deblank(ColumnNames(i,:)))'];
end



