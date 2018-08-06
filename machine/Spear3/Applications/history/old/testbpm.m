%function cav8s9impedancejun17
% function cav8s9impedancejun17
% implementation of matlab database toolbox with spear oracle rdb database using jdbc
%  logtime is type DATE


% establish database connection via jdbc
%  see help database or search for the database command for syntax reference

% database parameters
jdbcDriver = 'oracle.jdbc.driver.OracleDriver';
dbUrl = 'jdbc:oracle:thin:@spear2:1521:';
sourceName = 'spear_history_db_oci';
testSourceName = 'oci_history';
usr = 'SPEAR_DBREAD';
passwd = 'READONLY';

Family = 'BPMy';
list = getlist(Family);

NameList = [];
for i = 1:size(list,1) %[1:7 9:32] %size(list,1)
    Name = family2common(Family, list(i,:));
    Name = upper(deblank(Name));
    i=findstr('-',Name);
    if ~isempty(i)
        Name(i) = [];
    end
    if strcmp(Family,'BPMx')
        Name = sprintf('BPM_%s$X',Name);
    else
        Name = sprintf('BPM_%s$Y',Name);
    end
    NameList = [NameList, ',', Name];
end
NameList
%NameList = ',BPM_IRPM1$X' 

try
    % establish timeout
    timeout = logintimeout(jdbcDriver, 5);
    
    % connect to database
    conn = database(sourceName, usr, passwd, jdbcDriver, dbUrl );
    
    startTime = '2002-06-18 16:56:00.00';
    endTime   = '2002-06-18 17:06:00.00';
    
    % send sql command to database and open a cursor object ,T04C6$AM1
    dbCursor = exec( conn, ['select logtime',NameList,' ', ...
            'from SPEAR_BPM where ', ...
            'logtime between cast(''', startTime, ''' as timestamp) ', ...
            'and cast(''', endTime, ''' as timestamp) order by logtime;']);
    
    % retrieve data to that cursor object
    dbCursor = fetch(dbCursor);
    
    % columnnames displays the names of the columns of data retrieved
    ColumnNames = columnnames( dbCursor );
    
    
    % data in first row of cell structure
    fprintf('%s\n',dbCursor.Data{1,1});
    dbCursor.Data{1,2:end}
    
    % terminate transaction
    exec(conn, 'rollback;');
    
    % close cursors
    close(dbCursor);
    
    % close connection
    close(conn);
    
catch
    fprintf('   Error with database call.');
    exec(conn, 'rollback;');    
end

return

% work with the data
%  data in dbCursRf.data, dbCursSp.data

% some gymnastics to convert logtime to internal date format
% length of date vector
dateLen = 21;
% indices of date locations
indY = 1:4;
indMd = 6:10;
indMin = 5;
indHms = 12:19;
% change format from yyyy-mm-dd to mm/dd/yyyy
dArr = reshape( dbCursRf.data{:,1}, dateLen, [] )';
dMdy = dArr( :, [ indMd indMin indY ] );
dMdy( find( dMdy == '-' ) ) = '/';
logTime = datenum( dMdy ) + datenum( dArr( :, indHms ) );


% extract data
current = dbCursSp.data{:,1};
iAve = mean( current );
vGap8s9 = dbCursRf.data{:,2};
pWG8s9 = dbCursRf.data{:,3};
t8s9 = dbCursRf.data{:,4};

figInd=0;
figInd=figInd+1; figure(figInd); clf;
plot( pWG8s9, 1e4*vGap8s9./current )
title( ['8S9 impedance on ', datestr( logTime(1), 0 ), '  <I> = ', ...
        num2str(iAve), 'mA' ] );
xlabel( 'wg8s9 pressure' );
ylabel( 'fundamental impedance' );

