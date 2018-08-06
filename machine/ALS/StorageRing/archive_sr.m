function Output = archive_sr(DropTableFlag)
%ARCHIVE_SR - Archive storage ring data to the mysql database
%
%  archive_sr(DropTableFlag)
%  DropTableFlag - Drop the table before creating it
%
%  Special cases:
%  1. DataBaseInfo     = archive_sr('History')
%  2. Present_Table    = archive_sr('Table')
%  3. Present_DataBase = archive_sr('DataBase')
%
%  See also archive_size, getmysqldata, buildsrdatabase, plotmysqlorbit

%  Written by Greg Portmann


if nargin == 0
    DropTableFlag = 0;
end
Output = [];

% This is for the compiled version
checkforao;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                 Table History                                       %
% Table Name        Create_time        Last Update_time              Notes            %
% SRLOG2007     2007-05-03 17:36:09   2007-05-14 14:34:07                             %
% SRLOG2007b    2007-07-09 14:48:56   2007-09-28 15:18:32                             %
% SRLOG2007c    2007-09-28 16:06:24   2008-04-00 17:00:00     Added vacuum pressures  %
% SRLOG2008     2008-04-00 17:00:01          Now              Added pBPM              %
%
if ischar(DropTableFlag)
    DataBaseInfo(1).Table = 'SRLOG2007';
    DataBaseInfo(1).CreateDate = '2007-05-03 17:36:09';
    DataBaseInfo(1).LastUpdate = '2007-05-14 14:34:07';
    DataBaseInfo(1).DataBase = 'physlogs';

    DataBaseInfo(2).Table = 'SRLOG2007b';
    DataBaseInfo(2).CreateDate = '2007-07-09 14:48:56';
    DataBaseInfo(2).LastUpdate = '2007-09-28 15:18:32';
    DataBaseInfo(2).DataBase = 'physlogs';

    DataBaseInfo(3).Table = 'SRLOG2007c';
    DataBaseInfo(3).CreateDate = '2007-09-28 16:06:24';
    DataBaseInfo(3).LastUpdate = '2008-01-04 16:47:27';
    DataBaseInfo(3).DataBase = 'physlogs';

    DataBaseInfo(4).Table = 'SRLOG2008';
    DataBaseInfo(4).CreateDate = '2008-01-04 16:47:28';
    DataBaseInfo(4).LastUpdate = datestr(now, 31);
    DataBaseInfo(4).DataBase = 'physlogs';


    if strcmpi(DropTableFlag, 'History')
        Output = DataBaseInfo;
    elseif strcmpi(DropTableFlag, 'Table')
        Output = DataBaseInfo(end).Table;
    elseif strcmpi(DropTableFlag, 'DataBase')
        Output = DataBaseInfo(end).DataBase;
    end
    return;
end


%TableName = 'SRLOG2007c';
TableName = archive_sr('Table');
DataBase = archive_sr('DataBase');


% Sampling period in seconds
T = 10;  

% Archive all BPMs (even bad ones)
switch2allbpms('Display');


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
PassWord = 'gregp';  %'gp80_12!op';
%[User, PassWord] = logindlg('MySQL Connection', User);
if ~isempty(User)
    OpenResult = mym('open', Host, User, PassWord);
else
    return
end
clear PassWord


%%%%%%%%%%%%%%%%%%%%%
% Select a database %
%%%%%%%%%%%%%%%%%%%%%
%mym('use physlogs');
mym(sprintf('use %s',DataBase));

 
%%%%%%%%%%%%%%%
% SRLOG TABLE %
%%%%%%%%%%%%%%%

if DropTableFlag
    % Drop the table and create a new one
    ButtonName = questdlg({sprintf('Are you sure you want to drop the %s',TableName),'database before creating a new one?'}, TableName, 'Yes', 'No', 'No');
    if strcmp(ButtonName, 'Yes')
        mym(sprintf('drop table if exists %s',TableName));
    end
end


% Create the table
ColumnNamesWithTypes = [
    'Time datetime not null PRIMARY KEY', ...
    ', TimeSec double', ...
    ', DCCT float', ...
    ', Energy float', ...
    ', UserBeam int', ...
    ', LCW float'];

ChanNames = family2channel('DCCT');
ChanNames = strvcat(ChanNames, 'cmm:sr_energy');
ChanNames = strvcat(ChanNames, 'sr:user_beam');
ChanNames = strvcat(ChanNames, 'SR03S___LCWTMP_AM00');

ColumnNames = 'Time, TimeSec, DCCT, Energy, UserBeam, LCW';

FamilyCell = {'BPMx', 'BPMy', 'HCM', 'VCM', 'QF', 'QD', 'QFA', 'QDA', 'SQSF', 'SQSD', 'SF', 'SD', 'BEND', 'ID', 'EPU','RF','HCMCHICANE','HCMCHICANEM','IonGauge','IonPump','pBPM'};
%FamilyCell = {'BPMx', 'BPMy', 'HCM', 'VCM', 'QF', 'QD', 'QFA', 'QDA', 'SQSF', 'SQSD', 'SF', 'SD', 'BEND', 'ID', 'EPU','RF','HCMCHICANE','HCMCHICANEM'};
[ColumnNamesWithTypes, ColumnNames, ChanNames] = CreateTableString(ColumnNamesWithTypes, ColumnNames, ChanNames, FamilyCell);


CommandString = ['create table if not exists ', TableName, ' (', ColumnNamesWithTypes, ');'];


if DropTableFlag
    % Create the SQL table 
    mym(CommandString);
else
    % Print table info
    %mym('show table status from physlogs;');
    mym(sprintf('show table status from %s;', DataBase));
    DataBaseInfo = mym(sprintf('show table status from %s;', DataBase));
    for i = 1:length(DataBaseInfo.Name)
        if strcmp(DataBaseInfo.Name{i}, TableName)
            break
        end
    end
    fprintf('   %s was created %s and the last update was %s\n', DataBaseInfo.Name{i}, DataBaseInfo.Create_time{i}, DataBaseInfo.Update_time{i});
    fprintf('   It is presently %f GBytes with %d rows\n', DataBaseInfo.Data_length(i)/2^30, DataBaseInfo.Rows(i));
end
 

% Connect to all the channels
try
    % Start a connection
    Data = getpv(ChanNames);
catch
    fprintf('%s\n',lasterr);
    mym('close');
    return;
end


% Add a NULL whenever starting (so plots see the breaks)
if ~DropTableFlag
    [MatlabTime, MatlabClock] = gettime;
    DataString = ['insert into ', TableName, ' (', ColumnNames, ') values (', sprintf('"%s", %f', datestr(MatlabClock,31), MatlabTime)];
    for i = 1:size(ChanNames,1)
        DataString = [DataString , ', NULL'];
    end
    DataString = [DataString , ');'];
    mym(DataString);
    pause(2);  % So that the next data point is separated in time
end



% Get data
for i = 1:Inf
    try
        [MatlabTime, MatlabClock] = gettime;
        tic;
        Data = getpv(ChanNames);
        DataTime = toc;
        tic;
        DataString = ['insert into ', TableName, ' (', ColumnNames, ') values (', sprintf('"%s", %f', datestr(MatlabClock,31), MatlabTime), sprintf(', %g',Data),');'];
        mym(DataString);
        SQLTime = toc;
        fprintf('%d.  %s  %f seconds to get data   %f seconds for MYSQL write\n', i, datestr(MatlabClock,31), DataTime, SQLTime);
        fprintf('This is G. Portmann''s storage ring archive.  If it fails let me know (x4105). \n\n');
        
        sleep(T-(gettime-MatlabTime));
    catch
        fprintf('%s\n',lasterr);
        %mym('close');
        fprintf('This is G. Portmann''s storage ring archive.  It appears to be failing.  \nPlease called me (x5924) or kill it (ctrl-c) and try to restart (archive_sr). \n\n');
        sleep(T-(gettime-MatlabTime));
        %return;
    end
    
    if StopMySQLDataLogger
        fprintf('   Stop request came from global variable StopMySQLDataLogger.\n');
        break;
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print some output to the screen %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%mym(sprintf('explain %s;', TableName);



%%%%%%%%%%%%%%%%%%%%%%
% Close the database %
%%%%%%%%%%%%%%%%%%%%%%
mym('close');



function [ColumnNamesWithTypes, ColumnNames, ChanNames] = CreateTableString(ColumnNamesWithTypes, ColumnNames, ChanNames, Family)


for j = 1:length(Family)
    DevList = family2dev(Family{j}, 1, 1);
    
    % Monitors
    ChannelNames = family2channel(Family{j}, 'Monitor', DevList);
    if ~isempty(ChannelNames)
        ArchiveNames = family2archive(Family{j}, 'Monitor', DevList);
        for i = 1:size(ChannelNames,1)
            ColumnNamesWithTypes = [ColumnNamesWithTypes, sprintf(', %s float', deblank(ArchiveNames(i,:)))];
            ColumnNames          = [ColumnNames         , sprintf(', %s',       deblank(ArchiveNames(i,:)))];
        end
        ChanNames = strvcat(ChanNames, ChannelNames);
    end

    % Setpoints
    ChannelNames = family2channel(Family{j}, 'Setpoint', DevList);
    if ~isempty(ChannelNames)
        ArchiveNames = family2archive(Family{j}, 'Setpoint', DevList);
        for i = 1:size(ChannelNames,1)
            ColumnNamesWithTypes = [ColumnNamesWithTypes, sprintf(', %s float', deblank(ArchiveNames(i,:)))];
            ColumnNames          = [ColumnNames         , sprintf(', %s',       deblank(ArchiveNames(i,:)))];
        end
        ChanNames = strvcat(ChanNames, ChannelNames);
    end
    
    if strcmp(Family{j}, 'HCM') || strcmp(Family{j}, 'VCM')
        % Trim channels for correctors
        ChannelNames = unique(family2channel(Family{j}, 'Trim', DevList),'rows');
        ArchiveNames = unique(family2archive(Family{j}, 'Trim', DevList),'rows');
        if ChannelNames(1,1) == ' '
            ChannelNames(1,:) = [];
            ArchiveNames(1,:) = [];
        end
        for i = 1:size(ChannelNames,1)
            ColumnNamesWithTypes = [ColumnNamesWithTypes, sprintf(', %s float', deblank(ArchiveNames(i,:)))];
            ColumnNames          = [ColumnNames         , sprintf(', %s',       deblank(ArchiveNames(i,:)))];
        end
        ChanNames = strvcat(ChanNames, ChannelNames);

        % FF1 and FF2 channels for correctors
        ChannelNames = unique(family2channel(Family{j}, 'FF1', DevList),'rows');
        ArchiveNames = unique(family2archive(Family{j}, 'FF1', DevList),'rows');
        if ChannelNames(1,1) == ' '
            ChannelNames(1,:) = [];
            ArchiveNames(1,:) = [];
        end
        for i = 1:size(ChannelNames,1)
            ColumnNamesWithTypes = [ColumnNamesWithTypes, sprintf(', %s float', deblank(ArchiveNames(i,:)))];
            ColumnNames          = [ColumnNames         , sprintf(', %s',       deblank(ArchiveNames(i,:)))];
        end
        ChanNames = strvcat(ChanNames, ChannelNames);
       
        ChannelNames = unique(family2channel(Family{j}, 'FF2', DevList),'rows');
        ArchiveNames = unique(family2archive(Family{j}, 'FF2', DevList),'rows');
        if ChannelNames(1,1) == ' '
            ChannelNames(1,:) = [];
            ArchiveNames(1,:) = [];
        end
        for i = 1:size(ChannelNames,1)
            ColumnNamesWithTypes = [ColumnNamesWithTypes, sprintf(', %s float', deblank(ArchiveNames(i,:)))];
            ColumnNames          = [ColumnNames         , sprintf(', %s',       deblank(ArchiveNames(i,:)))];
        end
        ChanNames = strvcat(ChanNames, ChannelNames);
    end
    if strcmp(Family{j}, 'QF') || strcmp(Family{j}, 'QD')
        % FF channels
        ChannelNames = unique(family2channel(Family{j}, 'FF', DevList),'rows');
        ArchiveNames = unique(family2archive(Family{j}, 'FF', DevList),'rows');
        if ChannelNames(1,1) == ' '
            ChannelNames(1,:) = [];
            ArchiveNames(1,:) = [];
        end
        for i = 1:size(ChannelNames,1)
            ColumnNamesWithTypes = [ColumnNamesWithTypes, sprintf(', %s float', deblank(ArchiveNames(i,:)))];
            ColumnNames          = [ColumnNames         , sprintf(', %s',       deblank(ArchiveNames(i,:)))];
        end
        ChanNames = strvcat(ChanNames, ChannelNames);
    end
end

fprintf('   %d channels to be logged.\n',size(ChanNames,1)+2);