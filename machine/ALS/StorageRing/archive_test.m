function archive_sr(DropTableFlag)
%ARCHIVE_SR - Archive storage ring data to the mysql database
%
%  archive_sr(DropTableFlag)
%
%  See also archive_size, getmysqldata, buildsrdatabase
%
%  Written by Greg Portmann


% Connect as localhost/root at the command line:
% shell> mysql -u root -p

% To change a password
% mysql> update user set Password=password('new_password') where User='mysql';
%  or
% shell> mysql -u root mysql
% mysql> SET PASSWORD FOR root@localhost=PASSWORD('new_password');


% To create a user account with full privilege using password 'pw'
% GRANT ALL PRIVILEGES ON *.* TO 'physdata'@'localhost' IDENTIFIED BY 'pw' WITH GRANT OPTION;
% GRANT ALL PRIVILEGES ON *.* TO 'physdata'@'%' IDENTIFIED BY 'pw' WITH GRANT OPTION;
% FLUSH PRIVILEGES;

% To creat a new database???
% shell> mysql -h host -u user -p physlogs
% Enter password: ********
%
% To creat a new database and table
% CREATE DATABASE physlogs;


% This is for the compiled version
checkforao;


% Sampling period in seconds
T = 10;  


global StopMySQLDataLogger
StopMySQLDataLogger = 0;


if nargin == 0
    DropTableFlag = 0;
end


%%%%%%%%%%%%%%%%%%%%%
% Open a connection %
%%%%%%%%%%%%%%%%%%%%%
Host = 'ps3.als.lbl.gov';  
User = 'portmann';
[User, PassWord] = logindlg('MySQL Connection', User);
if ~isempty(User)
    OpenResult = mym('open', Host, User, PassWord);
else
    return
end
clear PassWord


%%%%%%%%%%%%%%%%%%%%%
% Select a database %
%%%%%%%%%%%%%%%%%%%%%
mym('use physlogs');

    
%%%%%%%%%%%%%%
% TEST TABLE %
%%%%%%%%%%%%%%

if DropTableFlag
    % Drop the table and create a new one
    mym('drop table if exists TEST');
end


% Create the table
% CommandString = [
%     'create table if not exists TEST (', ...
%     'Time datetime not null PRIMARY KEY', ...
%     ', TimeSec double', ...
%     ', x1 float', ...
%     ', x2 float', ...
%     ', x3 float', ...
%     ', x4 float', ...
%     ', x5 float);'];

CommandString = [
    'create table if not exists TEST (', ...
    'Time1 datetime, ', ...
    'x1 float, ', ...
    'Time2 datetime, ', ...
    'x2 float, ', ...
    'Time3 datetime, ', ...
    'x3 float, ', ...
    'Time4 datetime, ', ...
    'x4 float, ', ...
    'Time5 time, ', ...
    'x5 float);'];

%mym('alter table TEST add x6 double;')

% Create the SQL table
mym(CommandString);

% Print table info
%mym('show table status from physlogs;');

TableInfo = mym('show table status from physlogs;');

for i = 1:length(TableInfo.Name)
    if strcmp(TableInfo.Name{i}, 'TEST')
        break
    end
end

fprintf('   %s was created %s and the last update was %s\n', TableInfo.Name{i}, TableInfo.Create_time{i}, TableInfo.Update_time{i});
fprintf('   It is presently %f GBytes with %d rows\n', TableInfo.Data_length(i)/2^30, TableInfo.Rows(i));



% Get data
for i = 1:2 
    [MatlabTime, MatlabClock] = gettime;
    Data = randn(1,1);
    DataString = ['insert into TEST (Time5, x5) values (', sprintf('"%s.12335"', datestr(MatlabClock,31)), sprintf(', %f',Data),');'];
    
    
    %Data = randn(6,1);
    %DataString = ['insert into TEST values (', sprintf('"%s", %f', datestr(MatlabClock,31), MatlabTime), sprintf(', %f',Data),');'];

    %Data = randn(3,1);
    %DataString = ['insert into TEST (Time, TimeSec, x1, x2, x6) values (', sprintf('"%s", %f', datestr(MatlabClock,31), MatlabTime), sprintf(', %f',Data),');'];
    %DataString = ['insert into TEST (x1, x2, x3) values (1, 2, 3);'];
    
    
    mym(DataString);
    pause(1.1);
end


SQLcommand = ['select Time5, x5 from TEST order by Time5;'];
%SQLcommand = ['select x5 from TEST order by Time5;'];
d = mym(SQLcommand);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print some output to the screen %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%mym('explain TEST;');



%%%%%%%%%%%%%%%%%%%%%%
% Close the database %
%%%%%%%%%%%%%%%%%%%%%%
mym('close');
