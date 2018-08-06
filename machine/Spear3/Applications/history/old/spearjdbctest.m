function spearjdbctest
% function spearjdbctest
% first test of matlab database toolbox with spear oracle rdb database using jdbc
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
sourceName = 'spear_history_db_oci';
testSourceName = 'oci_history';
usr = 'SPEAR_DBREAD';
passwd = 'READONLY';

% establish timeout
timeout = logintimeout(jdbcDriver, 5);

% connect to database
conn = database(sourceName, usr, passwd, jdbcDriver, dbUrl );


% fields in database table
%  in spear table
%   SPEARCURRENT      s02O1$dv1
%  in rf table
%   RF10S11TOTALGAPV  r02s2k1$am1
%   RF10S11WGTEMP     r02s1c1g5$am1

% send sql command to database and open a cursor object
dbCursRf = exec( conn, ['select logtime,r02s2k1$am1,r02s1c1g5$am1,highres ', ...
		'from rf where ', ...
		'logtime between cast(''2002-01-25 12:00:00.00'' as timestamp) ', ...
		'and cast(''2002-01-25 12:30:00.00'' as timestamp) order by logtime;']);
% retrieve data to that cursor object
dbCursRf = fetch(dbCursRf);


% send sql command to database and open a cursor object
dbCursSp = exec( conn, ['select s02O1$dv1 ', ...
		'from spear where ', ...
		'logtime between cast(''2002-01-25 12:00:00.00'' as timestamp) ', ...
		'and cast(''2002-01-25 12:30:00.00'' as timestamp) order by logtime;']);
% retrieve data to that cursor object
dbCursSp = fetch(dbCursSp);


% columnnames displays the names of the columns of data retrieved
namesRf = columnnames( dbCursRf );
% namesRf = 'LOGTIME','R02S2K1$AM1','R02S1C1G5$AM1','HIGHRES'
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
vGap10s11 = dbCursRf.data{:,2};
t10s11 = dbCursRf.data{:,3};

figure(1); clf;
subplot(2,1,1);
plot( logTime, 1e4*vGap10s11./current )
v = axis; axis([ logTime(1) logTime(length(logTime)) v(3:4) ]);
tAxis = get( gca, 'XTick' );
set( gca, 'XTickLabel', datestr( tAxis, 13 ) );
title( ['10S11 impedance on ', datestr( logTime(1), 1 ) ] );
subplot(2,1,2);
plot( logTime, current )
v = axis; axis([ logTime(1) logTime(length(logTime)) v(3:4) ]);
tAxis = get( gca, 'XTick' );
set( gca, 'XTickLabel', datestr( tAxis, 13 ) );
title( ['beam current on ', datestr( logTime(1), 1 ) ] );

% close cursors
close(dbCursRf);
close(dbCursSp);

% close connection
close(conn);
return
