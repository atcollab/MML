function res = idSetUndParamSync(idName, attrName, attrValue, attrAbsTol)

res = 0;
DServName = '';
StandByStr = ''; %String to search in the return of "Status" command of DServer
ActStatusStr = '';
attr_name_list = {''};

numLoopsWaitRes = 300;
sleepTime = 3; %[s]
attrNameIsRecognized = 0;

[DServName, StandByStr] = idGetUndDServer(idName);

if strcmp(idName, 'HU80_TEMPO')
    %DServName = 'ANS-C08/EI/M-HU80.2'; %Name of Level 2 DServer
    %StandByStr = 'ANS-C08/EI/M-HU80.2_MotorsControl : STANDBY'; 
    
    %if strcmp(attrName, 'gap')
    %    attrNameIsRecognized = 1;
    %elseif strcmp(attrName, 'phase')
    %    attrNameIsRecognized = 1;
    %end
    %if attrNameIsRecognized == 0
    %    fprintf('Undulator Parameter / Device Server Attribute name is not recognized\n');
    %    res = -1; return;
    %end
     
	if strcmp(attrName, 'mode')
       attrValue = int16(attrValue);
	end
    
    %Debug
    %    attr_val_list = tango_read_attributes(DServName, attr_name_list);
    %    if (tango_error == -1) %handle error 
    %        tango_print_error_stack; return;
    %    end
    %End Debug
end

if strcmp(DServName, '') ~= 0
    fprintf('Device Server name is not specified\n');
    res = -1; return;
end

attr_name_val_list(1).name = attrName; attr_name_val_list(1).value = attrValue;
attr_name_list = {attr_name_val_list(1).name};

tango_write_attributes(DServName, attr_name_val_list);
if (tango_error == -1) %handle error 
    tango_print_error_stack;
    
    pause(sleepTime);
    fprintf('Trying to repeat writing attributes after pause...\n');
    tango_write_attributes(DServName, attr_name_val_list);
    if (tango_error == -1) %handle error 
        tango_print_error_stack;
        fprintf('Failed again. Returning from the function abnormally.\n');
        %res = -1; %hoping that it could still recover
        return;
    else
        fprintf('Succeeded writing attributes from 2nd attempt. Continuing execution of the function.\n');
    end
end

%Waiting until the parameter is actually set
for i = 1:numLoopsWaitRes
    attr_val_list = tango_read_attributes(DServName, attr_name_list);
    if (tango_error == -1) %handle error 
        tango_print_error_stack; 
        
        pause(sleepTime);
        fprintf('Trying to repeat reading attributes after pause...\n');
        attr_val_list = tango_read_attributes(DServName, attr_name_list);
        if (tango_error == -1) %handle error 
            tango_print_error_stack;
            fprintf('Failed again. Returning from the function abnormally.\n');
            %res = -1; %hoping that it could still recover
            return;
        else
            fprintf('Succeeded reading attributes from 2nd attempt. Continuing execution of the function.\n');
        end
    end

    valRequested = attr_name_val_list(1).value;
    valSet = attr_val_list(1).value(1); %check why (1)
    if(abs(valRequested - valSet) <= attrAbsTol)
        
        if strcmp(StandByStr, '') == 0
            attr_val_list_status = tango_read_attributes(DServName, {'Status'});
            if (tango_error == -1) %handle error 
                tango_print_error_stack; 
                
                pause(sleepTime);
                fprintf('Trying to repeat reading attributes after pause...\n');
                attr_val_list_status = tango_read_attributes(DServName, {'Status'});
                if (tango_error == -1) %handle error 
                    tango_print_error_stack;
                    fprintf('Failed again. Returning from the function abnormally.\n');
                    %res = -1; %hoping that it could still recover
                    return;
                else
                    fprintf('Succeeded reading attributes from 2nd attempt. Continuing execution of the function.\n');
                end
            end
            ActStatusStr = attr_val_list_status.value;
            if strncmp(ActStatusStr, StandByStr, length(StandByStr))
                pause(sleepTime);
                return; %Normal exit
            end
        else
            pause(sleepTime);
            return; %Normal exit
        end
    end
    pause(sleepTime);
end

res = -1;
fprintf('Failed to set requested Undulator Parameter value\n');
