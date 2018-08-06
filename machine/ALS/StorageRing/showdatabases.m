function showdatabases(CommandStr, Input1)
%SHOWDATABASE - Show info on the various databases
%
%  See also archive_size, archive_sr, getmysqldata, buildsrdatabase

%  Written by Greg Portmann

if nargin < 1
    CommandStr = '';
end


%%%%%%%%%%%%%%%%%%%%%
% Open a connection %
%%%%%%%%%%%%%%%%%%%%%
% Note:  Use mysql install in /usr/local/mysql-5.1.45 the default mysql is pointing to /usr/local/mysql
Host = 'ps3.als.lbl.gov';    % Control database is ps2, ps3 is the same as pdb (physics database)
%User = 'portmann';
%PassWord = 'gregp'; %'gp80_12!op';
%[User, PassWord] = logindlg('MySQL Connection', User);

%User = 'root';
%PassWord = 'als2010$';

User = 'croper'; 
PassWord = 'cro@als';

% create a connection to the database
DataBase = 'controls';
%TableName = 'ac';  % ac am at bc bm device di do pv

%DataBase = 'StorageRing';

try
    conn = database(DataBase, User, PassWord, 'Vendor', 'MySQL', 'Server', Host);
catch ME
    fprintf('Connection error %s', ME.message);
    if(~isempty(conn))
        fprintf('Connection Message %s \n',conn.Message);
        fprintf('Connection paraeters %s \n',conn);
    end
end
clear PassWord    
    
% Check if connected ok
if(~isopen(conn)) 
    conn.Message
    clear conn;
    return;
end


stinfo = sprintf(sprintf('show table status from %s;', DataBase));
curs = exec(conn, stinfo);
curs = fetch(curs);
close(curs);
TableInfo = curs.Data;

fprintf('   DataBase = %s\n', DataBase);
for i = 1:length(TableInfo.TABLE_NAME)
   fprintf('   %s  (%d rows)\n', TableInfo.TABLE_NAME{i}, TableInfo.TABLE_ROWS(i));
end

% fprintf('   The present archive table %s was created %s and the last update was %s\n', TableInfo.Name{i}, TableInfo.Create_time{i}, TableInfo.Update_time{i});
% fprintf('   It is presently %f GBytes with %d rows\n', TableInfo.Data_length(i)/2^30, TableInfo.Rows(i));


%%%%%%%%%%%%%%%%%%%%%%
% Close the database %
%%%%%%%%%%%%%%%%%%%%%%
close(conn);


