function archive_size
%ARCHIVE_SIZE - Get the archive storage space
%
%  See also archive_sr, getmysqldata

%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%%%%%
% Open a connection %
%%%%%%%%%%%%%%%%%%%%%
Host = 'ps3.als.lbl.gov';
User = 'physdata'; 
PassWord = 'jjDeP9821&';
%User = 'croper'; 
%PassWord = 'matlab';
if ~isempty(User)
    OpenResult = mym('open', Host, User, PassWord);
else
    return
end
clear PassWord


TableName = archive_sr('Table');
DataBase = archive_sr('DataBase');


%%%%%%%%%%%%%%%%%%%%%
% Select a database %
%%%%%%%%%%%%%%%%%%%%%
mym(sprintf('use %s',DataBase));


%%%%%%%%%%%%%%%
% SRLOG TABLE %
%%%%%%%%%%%%%%%

% Print table info
mym(sprintf('show table status from %s;', DataBase));

TableInfo = mym(sprintf('show table status from %s;', DataBase));

for i = 1:length(TableInfo.Name)
    if strcmp(TableInfo.Name{i}, TableName)
        break
    end
end

fprintf('   The present archive table %s was created %s and the last update was %s\n', TableInfo.Name{i}, TableInfo.Create_time{i}, TableInfo.Update_time{i});
fprintf('   It is presently %f GBytes with %d rows\n', TableInfo.Data_length(i)/2^30, TableInfo.Rows(i));


%%%%%%%%%%%%%%%%%%%%%%
% Close the database %
%%%%%%%%%%%%%%%%%%%%%%
mym('close');
