function epicsdatabasechanges
% epicsdatabasechanges


% ZSV - Zero Severity
% OSV - One  Severity
% ZNAM - Zero String
% ONAM - One  String


fprintf('\n   Modifying the BTS online EPICS database (the "dot" fields) (epicsdatabasechanges.m)\n');


%%%%%%%%%%%%%%%%%%%%%%
% By Channel Changes %
%%%%%%%%%%%%%%%%%%%%%%

% NOTES
% 1. Typical alarm strings: NO_ALARM, MINOR, MAJOR

ChannelCell = {
};

for i = 1:size(ChannelCell,1)
    if ischar(ChannelCell{i,2})
        % Set a string
        ValueNow = getpvonline(ChannelCell{i,1}, 'char');
        if ~strcmpi(ValueNow,ChannelCell{i,2})
            fprintf('   %s is %s setting to %s\n', ChannelCell{i,1}, ValueNow, ChannelCell{i,2});
            setpvonline(ChannelCell{i,1}, ChannelCell{i,2}, 'char');
        end
    else
        % Set a number
        ValueNow = getpvonline(ChannelCell{i,1});
        if ValueNow ~= ChannelCell{i,2}
            fprintf('   %s is %f setting to %f\n', ChannelCell{i,1}, ValueNow, ChannelCell{i,2});
            setpvonline(ChannelCell{i,1}, ChannelCell{i,2});
        end
    end
end



%%%%%%%%%%%%%%%%%%%%%% 
% By Family Channels %
%%%%%%%%%%%%%%%%%%%%%%

Family = {'BEND','Q', 'HCM', 'VCM'};

Field  = {'On'};
for i = 1:length(Family)
    for j = 1:length(Field)
        ZSV = 2;
        OSV = 0;
        ZNAM = 'OFF';
        ONAM = 'ON';
        local_epicsdbchange(Family{i}, Field{j}, ZSV, OSV, ZNAM, ONAM);
    end
end


Field  = {'Ready'};
for i = 1:length(Family)
    for j = 1:length(Field)
        ZSV = 2;
        OSV = 0;
        ZNAM = 'NRDY';  %'OFF';
        ONAM = 'RDY';   %'ON';
        local_epicsdbchange(Family{i}, Field{j}, ZSV, OSV, ZNAM, ONAM);
    end
end


Field  = {'Reset'};
for i = 1:length(Family)
    for j = 1:length(Field)
        ZSV = 0;  % No alarm
        OSV = 0;
        ZNAM = 'OFF';
        ONAM = 'ON';
        local_epicsdbchange(Family{i}, Field{j}, ZSV, OSV, ZNAM, ONAM);
    end
end


% The OnControl has an extra " " on the .ZNAM and .ONAM
Field  = {'OnControl'};
for i = 1:length(Family)
    for j = 1:length(Field)
        ZSV = 0;  % No alarm
        OSV = 0;
        ZNAM = 'OFF';
        ONAM = 'ON';
        local_epicsdbchange(Family{i}, Field{j}, ZSV, OSV, ZNAM, ONAM);
    end
end


fprintf('   EPICS database changes for BTS complete\n\n');



function local_epicsdbchange(Family, Field, ZSV, OSV, ZNAM, ONAM)

SetFlag = 1;

% fprintf('   %s.%s.ZSV should be %d\n', Family, Field, ZSV);
% fprintf('   %s.%s.ZNAM should be %s\n', Family, Field, ZNAM);
% fprintf('   %s.%s.ONAM should be %s\n',  Family, Field, ONAM);

try
    ChannelNames = family2channel(Family, Field);
catch
    fprintf('   Problem in family2channel(%s,%s)\n', Family, Field);
end

for k = 1:size(ChannelNames,1)
    if iscell(ChannelNames)
        Name = deblank(ChannelNames{k});
    else
        Name = deblank(ChannelNames(k,:));
    end
    
    try
        if ~isempty(Name)
            ZSVnow  = getpvonline([Name,'.ZSV'] , 'float');
            OSVnow  = getpvonline([Name,'.OSV'] , 'float');
            ZNAMnow = getpvonline([Name,'.ZNAM']);
            ONAMnow = getpvonline([Name,'.ONAM']);
            %ZNAMnow = getpvonline([Name,'.ZNAM'], 'char');
            %ONAMnow = getpvonline([Name,'.ONAM'], 'char');
            %fprintf('   %s is %d (ZSVnow=%d, OSVnow=%d)\n',   Name,  getpvonline(Name, 'float'), ZSVnow, OSVnow);
            
            if ZSVnow ~= ZSV
                fprintf('   %s is %d should be %d\n',   [Name,'.ZSV'],  ZSVnow,  ZSV);
                if SetFlag
                    setpvonline([Name,'.ZSV'], ZSV);
                end
            end
            if OSVnow ~= OSV
                fprintf('   %s is %d should be %d\n',   [Name,'.OSV'],  OSVnow,  OSV);
                if SetFlag
                    setpvonline([Name,'.OSV'], OSV);
                end
            end
            if ~strcmpi(ZNAMnow, ZNAM)
                fprintf('   %s is "%s" should be "%s"\n', [Name,'.ZNAM'], ZNAMnow, ZNAM);
                if SetFlag
                    setpvonline([Name,'.ZNAM'], ZNAM);
                end
            end
            if ~strcmpi(ONAMnow, ONAM)
                fprintf('   %s is "%s" should be "%s"\n', [Name,'.ONAM'], ONAMnow, ONAM);
                if SetFlag
                    setpvonline([Name,'.ONAM'], ONAM);
                end
            end
        end
    catch
        fprintf('   Problem configuring the %s.%s dot fields\n', Family, Field);
        break
    end
end
%fprintf('\n');









% NAME:	sr04u:GapEnable:bi
% DESC	PS_READY_MON
% STAT	0	FRESH	Alarm Status
% SEVR	0	FRESH	Alarm Severity
% ACKS	0	FRESH	Acknowledged Severity
% ASG
% UDF	0	FRESH	Undefined Flag
% ZSV	0	FRESH	Zero Severity
% OSV	0	FRESH	One Severity
% COSV	0	FRESH	Severity on Change
% ZNAM	Denied
% ONAM	Granted


% NAME:	SRBeam_Beam_I_IntrlkA
% DESC
% STAT	0	FRESH	Alarm Status
% SEVR	0	FRESH	Alarm Severity
% ACKS	2	FRESH	Acknowledged Severity
% ASG
% UDF	0	FRESH	Undefined Flag
% ZSV	2	FRESH	Zero Severity
% OSV	0	FRESH	One Severity
% COSV	0	FRESH	Severity on Change
% ZNAM	0
% ONAM	1

