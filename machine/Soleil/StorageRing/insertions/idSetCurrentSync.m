function res = idSetCurrentSync(idDevServ, currentToSet, currentAbsTol)

maxDelay_s = 20; %to edit
testTimePeriod_s = 1; %to edit
res = -1;

maxNumTests = round(maxDelay_s/testTimePeriod_s);

on_or_off = tango_command_inout2(idDevServ, 'State');
if(strcmp(on_or_off, 'ON') == 0)
    tango_command_inout2(idDevServ, 'On');
    for i = 1:maxNumTests
        on_or_off = tango_command_inout2(idDevServ, 'State');
        if(strcmp(on_or_off, 'ON'))
            break;
        end
        pause(testTimePeriod_s);
    end
    if(strcmp(on_or_off, 'ON') == 0)
        fprintf('Failed to set the device ON');
        return;
    end
end

attrCurrent = strcat(idDevServ, '/currentPM');
writeattribute(attrCurrent, currentToSet);
actCur = 0;
for i = 1:maxNumTests
	actCur = readattribute([idDevServ, '/current']);
    if(abs(currentToSet - actCur) <= currentAbsTol)
        res = 0;
        return;
    end
	pause(testTimePeriod_s);
end

if(abs(currentToSet - actCur) > currentAbsTol)
	res = -1;
	fprintf('Failed to set the requested current\n');
end

