function cav8s9impedancejun17
% function cav8s9impedancejun17
% implementation of matlab database toolbox with spear oracle rdb database using jdbc
%  logtime is type DATE
%  s02O1$dv1, r02s2k1$am1, r02s1c1g5$am1 are type REAL
%  another type, TINYINT, is for highres
% classes111.zip from the oracle web site for oracle 8.1.5 is accessed by
%  matlab since its location on the local machine was entered in
%   d:\matlab6p5\toolbox\local\classpath.txt
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
%   RF10S11BMVLTG     r02s2k1$am4
%   RF10S11TOTALGAPV  r02s2k1$am1
%   RF10S11WGPRES     r02s2k1$am8
%   RF10S11WGTEMP     r02s1c1g5$am1
%   RF8S9BMVLTG       r02s1k1$am4
%   RF8S9TOTALGAPV    r02s1k1$am1
%   RF8S9WGPRES       r02s1k1$am8
%   RF8S9WGTEMP       r02s2c1g5$am1

startTime = '2002-06-18 16:56:00.00';
endTime   = '2002-06-18 17:06:00.00';
% send sql command to database and open a cursor object
dbCursRf = exec( conn, ['select logtime,r02s1k1$am1,r02s1k1$am8,r02s2c1g5$am1,highres ', ...
		'from rf where ', ...
		'logtime between cast(''', startTime, ''' as timestamp) ', ...
		'and cast(''', endTime, ''' as timestamp) order by logtime;']);
% retrieve data to that cursor object
dbCursRf = fetch(dbCursRf);


% send sql command to database and open a cursor object
dbCursSp = exec( conn, ['select s02O1$dv1 ', ...
		'from spear where ', ...
		'logtime between cast(''', startTime, ''' as timestamp) ', ...
		'and cast(''', endTime, ''' as timestamp) order by logtime;']);
% retrieve data to that cursor object
dbCursSp = fetch(dbCursSp);


% columnnames displays the names of the columns of data retrieved
namesRf = columnnames( dbCursRf );
% namesRf = 'LOGTIME','R02S1K1$AM1','R02S1K1$AM8','R02S2C1G5$AM1','HIGHRES'
% data in first row of cell structure
dbCursRf.Data(1,:);
% ans = '2002-06-18 16:56:00.0'    [0.37631044000000]    [8.73115540000000]
%       [23.29686400000000]    [0]
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

% close cursors
close(dbCursRf);
close(dbCursSp);

% close connection
close(conn);
return
