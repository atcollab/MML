function cav10s11impedancejun17
% function cav10s11impedancejun17
% implementation of matlab database toolbox with spear oracle rdb database using jdbc
%  logtime is type DATE
%  s02O1$dv1, r02s2k1$am1, r02s1c1g5$am1 are type REAL
%  highres is type TINYINT
% classes111.zip from the oracle web site for oracle 8.1.5 is accessed by
%  matlab since its location on the local machine was entered in
%   d:\matlab6p1\toolbox\local\classpath.txt
%  as the first path to check after the current directory

% establish database connection via jdbc
%  see help database or search for the database command for syntax reference

% database parameters
jdbcDriver = 'oracle.jdbc.driver.OracleDriver';
dbUrl = 'jdbc:oracle:thin:@spear2:1521:';
sourceName = 'spear_history2002_db_oci';
testSourceName = 'oci_history';
usr = 'SPEAR_DBREAD';
passwd = 'READONLY';

% establish timeout
timeout = logintimeout(jdbcDriver, 5);

% connect to database
conn = database(sourceName, usr, passwd, jdbcDriver, dbUrl );
% verify connection was established
if ( get( conn, 'Handle' ) == 0 ),
    disp( get( conn, 'Message' ) );
    error( ['unable to establish connection to ', sourceName] );
end % if ( get( conn, 'Handle' ) == 0 ),


% fields in database table
%  in spear table
%   SPEARCURRENT      s02O1$dv1
%  in rf table
%   RF10S11BMVLTG     r02s2k1$am4
%   RF10S11TOTALGAPV  r02s2k1$am1
%   RF10S11WGPRES     r02s2k1$am8
%   RF10S11WGTEMP     r02s1c1g5$am1
%   RF8S9BMVLTG       r02s1k1$am4
%   RF8S9TOTALGAPV    r02s1k1$am1
%   RF8S9WGPRES       r02s1k1$am8
%   RF8S9WGTEMP       r02s2c1g5$am1

startTime = '2002-06-17 13:15:00.00';
endTime   = '2002-06-17 13:36:00.00';
% send sql command to database and open a cursor object
dbCursRf = exec( conn, ['select logtime,r02s2k1$am1,r02s2k1$am8,r02s1c1g5$am1,highres ', ...
		'from rf where ', ...
		'logtime between cast(''', startTime, ''' as timestamp) ', ...
		'and cast(''', endTime, ''' as timestamp) order by logtime;']);
% verify cursor was obtained
if ( get( dbCursRf, 'Cursor' ) == 0 ),
    disp( get( dbCursRf, 'Message' ) );
    exec(conn, 'rollback;');
    close( conn );
    error( 'unable to obtain cursor for dbCursRf' );
end % if ( get( dbCursRf, 'Cursor' ) == 0 ),
% retrieve data to that cursor object
dbCursRf = fetch(dbCursRf);
% verify fetch was successful
if ( get( dbCursRf, 'Fetch' ) == 0 ),
    disp( get( dbCursRf, 'Message' ) );
    exec(conn, 'rollback;');
    close( dbCursRf );
    close( conn );
    error( 'unable to fetch using dbCursRf' );
end % if ( get( dbCursRf, 'Fetch' ) == 0 ),


% send sql command to database and open a cursor object
dbCursSp = exec( conn, ['select s02O1$dv1 ', ...
		'from spear where ', ...
		'logtime between cast(''', startTime, ''' as timestamp) ', ...
		'and cast(''', endTime, ''' as timestamp) order by logtime;']);
% verify cursor was obtained
if ( get( dbCursSp, 'Cursor' ) == 0 ),
    disp( get( dbCursSp, 'Message' ) );
    exec(conn, 'rollback;');
    close( dbCursRf );
    close( conn );
    error( 'unable to obtain cursor for dbCursSp' );
end % if ( get( dbCursSp, 'Cursor' ) == 0 ),
% retrieve data to that cursor object
dbCursSp = fetch(dbCursSp);
% verify fetch was successful
if ( get( dbCursSp, 'Fetch' ) == 0 ),
    disp( get( dbCursSp, 'Message' ) );
    exec(conn, 'rollback;');
    close( dbCursRf );
    close( dbCursSp );
    close( conn );
    error( 'unable to fetch using dbCursRf' );
end % if ( get( dbCursRf, 'Fetch' ) == 0 ),


% columnnames displays the names of the columns of data retrieved
namesRf = columnnames( dbCursRf );
% namesRf = 'LOGTIME','R02S1K1$AM1','R02S1K1$AM8','R02S2C1G5$AM1','HIGHRES'
% data in first row of cell structure
dbCursRf.Data(1,:);
% ans = '2001-12-01 12:00:00.0'    [0.05568362000000]    [13.13123000000000]    [0]
namesSp = columnnames( dbCursSp );
% namesSp = 'S02O1$DV1'

% terminate transaction
exec(conn, 'rollback;');


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
vGap10s11 = dbCursRf.data{:,2};
pWG10s11 = dbCursRf.data{:,3};
t10s11 = dbCursRf.data{:,4};

figInd=0;
figInd=figInd+1; figure(figInd); clf;
%subplot(2,1,1);
plot( pWG10s11, 1e4*vGap10s11./current )
%v = axis; axis([ pWg8s9(1) logTime(length(logTime)) v(3:4) ]);
%tAxis = get( gca, 'XTick' );
%set( gca, 'XTickLabel', datestr( tAxis, 13 ) );
title( ['10S11 impedance on ', datestr( logTime(1), 0 ), '  <I> = ', ...
        num2str(iAve), 'mA' ] );
xlabel( 'wg10s11 pressure' );
ylabel( 'fundamental impedance' );
%subplot(2,1,2);
%plot( logTime, current )
%v = axis; axis([ logTime(1) logTime(length(logTime)) v(3:4) ]);
%tAxis = get( gca, 'XTick' );
%set( gca, 'XTickLabel', datestr( tAxis, 13 ) );
%title( ['beam current on ', datestr( logTime(1), 1 ) ] );

% close cursors
close(dbCursRf);
close(dbCursSp);

% close connection
close(conn);
return
