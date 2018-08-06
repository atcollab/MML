function [data, t, ColumnNames] = getrdbdata(StartTime, EndTime, HistoryName, Table, sourceName, ConvertTimeFlag)
%  [Data, t, ColumnNames] = getrdbdata(StartTime, EndTime, HistoryBufferName, Table,  DatabaseName)
%
%  INPUTS
%  1-2. StartTime and EndTime can be a string in the Oracle format,
%           yyyy-mm-dd hh:mm:ss.ss like 2002-06-18 16:56:00.00
%           or something that datastr recognized, like a date serial 
%           number (see help datenum) or a vector with [y m d h m s] format.
%  3-4. HistoryBufferName and Table are the Oracle database name and table name
%           These inputs can be a matrix of strings or a cell array.  The Table 
%           can be a single row vector if all the history buffer names come from 
%           the same table or it must equal the number of rows in HistoryBufferName.
%  5. DatabaseName - database name, like {default: the most current file, like 'spear_history2002_db_oci'}
%  6. ConvertTimeFlag - 0  do not change the time format
%                     else convert to Matlab serial data format {Default}
%                       
%
%  OUTPUTS
%  1. Data is a matrix of history data where each column is a different point in time. 
%  2. t is in Matlab's serial date format.  Convert to other formats using
%           datestr or datevec.  datetick converts a plot axis to more reasonable text.
%  3. ColumnNames is a matrix of strings where each row is the database column name. 
%
%  NOTES
%  1. If HistoryBufferName is a cell array, then Data and ColumnNames outputs are cell arrays.
%  2. HistoryBufferName can be a cell array without Table being a cell array.
%  3. The input times can not be a cell array.
%  4. If no data is found, empty matrices are returned.
%  5. This function will only make one database call per table.
%  6. getrdbdata does not need the middle layer to work.  If you add the middle layer 
%     to the path then family2history converts middle layer family names to history
%     buffer names and gethist calls family2history and getrdbdata just to save some 
%     typing.  help gethist shows some examples.
%
%  EXAMPES  
%  1. Get and plot one hour and six minutes of beam current data on June 18, 2002
%     [d,t,col] = getrdbdata('2002-06-18 16:50:00.00', '2002-06-18 17:56:00.00', 's02O1$dv1', 'spear');
%                     or
%     [d,t,col] = getrdbdata([2002 6 18 16 50 00], [2002 6 18 17 56 00], 's02O1$dv1', 'spear');
%     plot(t,d); datetick x
%
%  2. Two history names, same table   
%     One hour and six minutes of bend magnet field and bend magnet current on June 18, 2002
%     [d,t,col] = getrdbdata('2002-06-18 16:50:00.00', '2002-06-18 17:56:00.00', ['M02Q1$AM1';'M02Q1$DV1'], 'mains');
%
%  3. Two history names, different table   
%     One hour and six minutes of beam current and bend magnet current on June 18, 2002
%     [d,t,col] = getrdbdata('2002-06-18 16:50:00.00', '2002-06-18 17:56:00.00', ['s02O1$dv1';'M02Q1$AM1'], ['spear';'mains']);
%
%  4. Two history names using cells   
%     One hour and six minutes of beam current and bend magnet current on June 18, 2002
%     [d,t,col] = getrdbdata('2002-06-18 16:50:00.00', '2002-06-18 17:56:00.00', {'s02O1$dv1','M02Q1$AM1'}, {'spear','mains'});
%
%  Written by Greg Portmann using Jim Sebek's Oracle (rdb) to Matlab database connection method


% Notes to Jim
%
% Names = ['s02O1$dv1    ';'r02s1k1$am1  ';'r02s1k1$am8  ';'r02s2c1g5$am1';'highres      '];
% Table = ['spear';'rf   ';'rf   ';'rf   ';'rf   '];
% [d,t,col] = getrdbdata('2002-06-18 16:50:00.00', '2002-06-18 17:56:00.00', Names, Table);
%   or you can split things up into cells any way you wish 
% [d,t,col] = getrdbdata('2002-06-18 16:50:00.00', '2002-06-18 17:56:00.00', {'s02O1$dv1', ['r02s1k1$am1';'r02s1k1$am8'],'r02s2c1g5$am1','highres'}, {'spear','rf','rf','rf','rf'});
% No matter how you do it, there will only be one database call per table.


   
ColumnNames = [];

% Input checking
if nargin < 4
    error('4 inputs required.');
end
if iscell(StartTime) | iscell(EndTime)
    error('The start and end times cannot be cell arrays.');
end
if nargin < 5
    sourceName = '';
end
if nargin < 6
    ConvertTimeFlag = 1;
end

% Database parameters
if isempty(sourceName)
    %sourceName = 'spear_history2002_db_oci';  % SPEAR2
    sourceName = 'spear_history_db_oci';       % SPEAR3
end


% For cell inputs
if iscell(HistoryName)
    if ~iscell(Table)
            error('If HistoryBufferName is a cell, than Table must be a cell.');
    end
    % Multiple calls (test if this is really slower???)
    %for i = 1:length(HistoryName)
    %    [data{i}, t{i}, ColumnNames{i}] = getrdbdata(StartTime, EndTime, HistoryName{i}, Table{i}, sourceName);
    %end
    
    % Pack the history name into one matrix and make one call to getrdbdata
    HistoryName_Total = [];
    Table_Total = [];
    for i = 1:length(HistoryName)
        HistoryName_Total = strvcat(HistoryName_Total, HistoryName{i});
        
        % Check the number of rows in Table 
        if size(Table{i},1) > 1
            if size(Table{i},1) ~= size(HistoryName{i},1)
                error('Table can be a row vector or equal to the number of rows in HistoryBufferName.');
            end    
        else
            % Table must have the same number of rows as HistoryName for this to work
            for j = 1:size(HistoryName{i},1)-1
                Table{i} = strvcat(Table{i}, Table{i}(1,:));
            end
        end
        
        Table_Total = strvcat(Table_Total, Table{i});
        iArray(i) = size(HistoryName{i},1); 
    end
    
    [data_total, t, ColumnNames_total] = getrdbdata(StartTime, EndTime, HistoryName_Total, Table_Total, sourceName);
    
    % Re-sort into cells
    for i = 1:length(HistoryName)
        data{i} = data_total(1:iArray(i),:);
        %ColumnNames{i} = ColumnNames_total(1:iArray(i),:);
        
        data_total(1:iArray(i),:) = [];
        %ColumnNames_total(1:iArray(i),:) = [];
    end
    return
else
    if iscell(Table)
        error('If Table is a cell, than HistoryBufferName must be a cell.');
    end
end
% End cell inputs


% Check the number of rows in Table 
if size(Table,1) > 1
    if size(Table,1) ~= size(HistoryName,1)
        error('Table can be a row vector or equal to the number of rows in HistoryBufferName.');
    end    
end


% Separate database calls for each table
[Table_Short, i, j] = unique(Table, 'rows');
if size(Table_Short,1) > 1
    % Separate the data by table
    % Assume that the time vectors are the same for each table???
    
    % Get data from the first table
    k=1;
    m = find(j==k);                                   % Rows unique to the first table
    [data_tmp, t, ColumnNames] = getrdbdata_local(StartTime, EndTime, HistoryName(m,:), Table_Short(k,:), sourceName);
    data = NaN*ones(size(HistoryName,1), length(t));  % Create the full output data matrix
    if size(data_tmp,1) ~= length(m)
        fprintf('   Not all the data exists for this time period\n');
    else
        data(m,:) = data_tmp;                             % Fill with the data from the first table
    end

    % Get the rest of the data for each table
    for k = 2:size(Table_Short)
        m = find(j==k);                 % Rows unique to the table
        [data_tmp, t_tmp, ColumnNames] = getrdbdata(StartTime, EndTime, HistoryName(m,:), Table_Short(k,:), sourceName, 0);

        if size(data_tmp,1) ~= length(m)
            fprintf('   Not all the data exists for this time period\n');
        else
            data(m,:) = data_tmp;           % Fill with the data from the table
        end
    end
else
    % Only one table
    [data, t, ColumnNames] = getrdbdata_local(StartTime, EndTime, HistoryName, Table_Short, sourceName);
end


% Convert time format (unfortunately, this is time consuming)
if ConvertTimeFlag & ~isempty(t)
    % Some gymnastics to convert logtime to internal date format
    
    % Example database time 2002-06-18 16:56:00.0
    % indices of date locations
    tic
    iYear  = 1:4;
    iMonth = 6:7;
    iDay   = 9:10;
    iMin = 5;
    iHourMinSec = 12:19;  % plus the space
    iMonthDayYear = 1:10;
    
    % Change format from 'yyyy-mm-dd hh:mm:ss.s' to 'mm/dd/yyyy hh:mm:ss'
    % Note: datestr(t,31) converts back to Oracle time 
    % Note: for plotting use datetick with input 'x', 'y', or 'z'
    t = str2mat(t{:,1});
    t = [t(:,iMonth) t(:,5) t(:,iDay) t(:,5) t(:,iYear) t(:,11) t(:,iHourMinSec)];
    %t = datenum(t(:,iMonthDayYear)) + datenum(t(:,iHourMinSec));     % Serial date number
    t = datenum(t)';     % Serial date number
    fprintf('   Time vector conversion time = %.1f seconds.\n', toc);
end



function [data, t, ColumnNames] = getrdbdata_local(StartTime, EndTime, HistoryName, Table, sourceName)
% Get the Oracle database data for a given table

% Database parameters
jdbcDriver = 'oracle.jdbc.driver.OracleDriver';
dbUrl = 'jdbc:oracle:thin:@spear2:1521:';
usr = 'SPEAR_DBREAD';
passwd = 'READONLY';

fprintf('   Getting data from table %s: %s', Table, datestr(now,14)); tic;

% There can only be one table
Table = deblank(Table(1,:));


% Fix start/end time formats
if ~isstr(StartTime)
    StartTime = datestr(StartTime,31);
    StartTime = [StartTime '.00'];
end
if ~isstr(EndTime)
    EndTime = datestr(EndTime,31);
    EndTime = [EndTime '.00'];
end


% Build a common separated list of names
NameList = [];
for i = 1:size(HistoryName,1)
    NameList = [NameList, ',', deblank(HistoryName(i,:))];
end


% Get history data
try
    % This function uses Jim Sebek's method to get data from the database 
    % He uses the Matlab database toolbox with spear oracle rdb database using jdbc
    
    % establish timeout
    timeout = logintimeout(jdbcDriver, 5);
    
    % connect to database
    conn = database(sourceName, usr, passwd, jdbcDriver, dbUrl);
    if ~isconnection(conn)
        fprintf('\n   Error with database connection call: %s\n', get(conn, 'message'));
        fprintf('   Check that the database file name,%s, is correct\n', sourceName);
        data = [];
        t = [];
        ColumnNames = [];
        return
    end
    
    %dbmeta = dmd(conn)
    %t = supports(dbmeta) 
        
    % send sql command to database and open a cursor object
    dbCursor = exec( conn, [ ...
            'select logtime', NameList, ...
            ' from ', Table, ...
            ' where logtime between cast(''', StartTime, ''' as timestamp)', ...
            ' and cast(''', EndTime, ''' as timestamp) order by logtime;']);
   
    if ( get( dbCursor, 'Cursor' ) == 0 )
        fprintf('\n   %s\n', get(dbCursor, 'Message'));
        exec(conn, 'rollback;');
        %close( dbCursor );
        close( conn );
        fprintf('   Unable to obtain cursor for dbCursor.\n');
        error(' ');
    end
    
    % retrieve data to that cursor object
    dbCursor = fetch(dbCursor);
    if ( get( dbCursor, 'Fetch' ) == 0 )
        fprintf('\n   %s\n', get(dbCursor, 'Message'));
        exec(conn, 'rollback;');
        close( dbCursor );
        close( conn );
        fprintf('   Unable to fetch using dbCursor.\n');
        error(' ');
    end


    if strcmp(lower(dbCursor.Data{1,1}),'no data')
        data = [];
        t = [];
        ColumnNames = [];
    else        
        % logtime is type DATE
        t = dbCursor.Data(:,1);
        
        % Convert data to a matrix
        data = dbCursor.Data;
        data = cell2mat(dbCursor.Data(:,2:end))';
        
        % columnnames displays the names of the columns of data retrieved
        ColumnNames = columnnames( dbCursor );
        if strcmp(lower(ColumnNames(2:8)),'logtime')
            ColumnNames = ColumnNames(11:end);
        end
        
        % Convert ColumnNames to string matrix
        i = find(ColumnNames == ',');
        if ~isempty(i)
            tmp = ColumnNames(1:i(1)-1);
            for j = 1:length(i)-1
                tmp = strvcat(tmp, ColumnNames(i(j)+1:i(j+1)-1));
            end
            ColumnNames = strvcat(tmp, ColumnNames(i(end)+1:end));
        end
    end
    
    % terminate transaction
    exec(conn, 'rollback;');
    
    % close cursors
    close(dbCursor);
    
    % close connection
    close(conn);
    
    fprintf(' /%s (%.1f seconds)\n', datestr(now,14), toc);
catch
    fprintf('\n   Error in database call:  %s\n', lasterr);
    %exec(conn, 'rollback;');    
    
    data = [];
    t = [];
    ColumnNames = [];
end



% % Convert time format
% if ~isempty(t)
%     tic
%     % Some gymnastics to convert logtime to internal date format
%     
%     % Example database time 2002-06-18 16:56:00.0
%     % indices of date locations
%     iYear  = 1:4;
%     iMonth = 6:7;
%     iDay   = 9:10;
%     iMin = 5;
%     iHourMinSec = 12:19;  % plus the space
%     iMonthDayYear = 1:10;
%     
%     % Change format from 'yyyy-mm-dd hh:mm:ss.s' to 'mm/dd/yyyy hh:mm:ss'
%     % Note: datestr(t,31) converts back to Oracle time
%     % Note: for plotting use datetick with input 'x', 'y', or 'z'
%     t = str2mat(t{:,1});
%     t = [t(:,iMonth) t(:,5) t(:,iDay) t(:,5) t(:,iYear) t(:,11) t(:,iHourMinSec)];
%     %t = datenum(t(:,iMonthDayYear)) + datenum(t(:,iHourMinSec));     % Serial date number
%     t = datenum(t);     % Serial date number
%     fprintf('   Time vector conversion time = %.1f seconds.\n', toc);
% end

