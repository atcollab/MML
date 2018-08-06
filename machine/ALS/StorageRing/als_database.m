function als_database
%ALS_DATABASE - Get some info on the ALS channel database
%
%  See also archive_sr, getmysqldata

%  Written by Greg Portmann


%%%%%%%%%%%%%%%%%%%%%
% Open a connection %
%%%%%%%%%%%%%%%%%%%%%
Host = 'ps2.als.lbl.gov';
User = 'croper'; 
PassWord = 'cro@als';
if ~isempty(User)
    OpenResult = mym('open', Host, User, PassWord);
else
    return
end
clear PassWord


DataBase = 'controls';
TableName = 'ac';  % ac am at bc bm device di do pv


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
