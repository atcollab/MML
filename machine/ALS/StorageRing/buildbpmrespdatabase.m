function buildbpmrespdatabase
%BUILDBPMRESPDATABASE - Put response matrix data to the mysql database
%
%  See also buildsrdatabase, showdatabases, getmysqldata

%  Written by Greg Portmann


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
% Select a Database %
%%%%%%%%%%%%%%%%%%%%%
%UseResult = mym('use controls');
UseResult = mym('use StorageRing');


%%%%%%%%%%%%%%%%%%%%
% BPMRESPMAT TABLE %
%%%%%%%%%%%%%%%%%%%%

% Drop the table and create a new one
mym('drop table if exists BPMRESPMAT');


% Create a new table
CommandString = [
    'create table if not exists BPMRESPMAT (', ...
    'TableIndex INT AUTO_INCREMENT PRIMARY KEY, BPMChanName char(25)'];


% Create the table
Family = {'HCM', 'VCM'};
ChanNames = [];
for j = 1:length(Family)
    DevList = family2dev(Family{j});
    ChannelNames = family2channel(Family{j}, 'Setpoint', DevList);
    for i = 1:size(ChannelNames,1)
        CommandString = [CommandString, sprintf(', %s float', deblank(ChannelNames(i,:)))];
    end
    ChanNames = strvcat(ChanNames, ChannelNames);
end

fprintf('   %d columns created in the BPMRESPMAT table in the StorageRing database.\n',size(ChanNames,1)+1);

CommandString = [CommandString, ');'];


% Create the SQL table
mym(CommandString);


M = getbpmresp('Struct','NoEnergyScaling');


% Get data
n = 0;
for i = 1:2
    for j = 1:size(M(i,1).Data,1)
        n = n + 1;
        DataString = ['insert into BPMRESPMAT values (', sprintf('%d, "%s"', n, family2channel(M(i,1).Monitor.FamilyName,M(i,1).Monitor.DeviceList(j,:))), sprintf(', %f', M(i,1).Data(j,:)), sprintf(', %f', M(i,2).Data(j,:)),');'];
        mym(DataString);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print some output to the screen %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mym('explain BPMRESPMAT;');

fprintf('   Database: StorageRing\n')
mym('show table status from StorageRing;');


%%%%%%%%%%%%%%%%%%%%%%
% Close the database %
%%%%%%%%%%%%%%%%%%%%%%
mym('close');



