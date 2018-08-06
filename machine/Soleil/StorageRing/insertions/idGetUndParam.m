function param = idGetUndParam(idName, attrName)

param = 0;
DServName = '';
StandByStr = ''; %String to search in the return of "Status" command of DServer

[DServName, StandByStr] = idGetUndDServer(idName);

if strcmp(DServName, '') ~= 0
    fprintf('Device Server name can not be found\n');
    param = -1; return;
end

attr_name_list = {attrName};
attr_val_list = tango_read_attributes(DServName, attr_name_list);
if (tango_error == -1) %handle error 
    tango_print_error_stack; param = -1; return;
end
param = attr_val_list(1).value(1); %check why (1)
