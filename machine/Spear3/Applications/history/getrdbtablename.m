function [HistoryName, TableName, sourceName] = getrdbtablename(PVname, sourceName)
%  [HistoryName, TableName, DatabaseName] = getrdbtablename(PVname, DatabaseName)

HistoryName = ''; 
TableName = ''; 

% Input checking
if nargin < 1
    error('1 inputs required.');
end
if nargin < 2
    sourceName = '';
end


% Database parameters
jdbcDriver = 'oracle.jdbc.driver.OracleDriver';
dbUrl = 'jdbc:oracle:thin:@spear2:1521:';
usr = 'SPEAR_DBREAD';
passwd = 'READONLY';
if isempty(sourceName)
    %sourceName = 'spear_history2002_db_oci';  % SPEAR2
    sourceName = 'spear_history_db_oci';       % SPEAR3
end



% Get history data
try
 
    % Establish timeout
    timeout = logintimeout(jdbcDriver, 5);
    
    % connect to database
    conn = database(sourceName, usr, passwd, jdbcDriver, dbUrl);
    if ~isconnection(conn)
        fprintf('\n   Error with database connection call: %s\n', get(conn, 'message'));
        fprintf('   Check that the database file name,%s, is correct\n', sourceName);
        TableName = [];
        return
    end
          
    % send sql command to database and open a cursor object
    dbCursor = exec(conn,sprintf('select columnname, tablename from spear_index where pvname = ''%s''', deblank(PVname)));
       
    
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
        HistoryName = ' ';
        TableName = ' ';
    else        
        HistoryName = dbCursor.Data{1};
        TableName = dbCursor.Data{2};
    end
    
    % terminate transaction
    exec(conn, 'rollback;');
    
    % close cursors
    close(dbCursor);
    
    % close connection
    close(conn);
    
catch
    fprintf('\n   Error with database call.\n');
    try
        exec(conn, 'rollback;');    
    catch
    end
    
    HistoryName = ' ';
    TableName = ' ';
end

