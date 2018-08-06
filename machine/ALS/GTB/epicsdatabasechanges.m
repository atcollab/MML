function epicsdatabasechanges
% epicsdatabasechanges

SetFlag = 1;

% ZSV - Zero Severity
% OSV - One  Severity
% ZNAM - Zero String
% ONAM - One  String


fprintf('\n   Modifying the GTB online EPICS database (the "dot" fields) (epicsdatabasechanges.m)\n');


%%%%%%%%%%%%%%%%%%%%%%
% By Channel Changes %
%%%%%%%%%%%%%%%%%%%%%%

% NOTES
% 1. Typical alarm strings: NO_ALARM, MINOR, MAJOR

ChannelCell = {
'GTL_____TIMING_BM01.ZSV', 'MAJOR'
'GTL_____TIMING_BM01.OSV', 'NO_ALARM'
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


% The OnControl has an extra " " on the .ZNAM and .ONAM
Family = {'SOL'};
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
        ZNAM = 'NRDY';
        ONAM = 'RDY';
        local_epicsdbchange(Family{i}, Field{j}, ZSV, OSV, ZNAM, ONAM);
    end
end

% The OnControl has an extra " " on the .ZNAM and .ONAM
Family = {'MOD'};
Field  = {'OnControl', 'Trigger', 'Start'};
for i = 1:length(Family)
    for j = 1:length(Field)
        ZSV = 2;
        OSV = 0; 
        ZNAM = 'OFF';
        ONAM = 'ON';
        local_epicsdbchange(Family{i}, Field{j}, ZSV, OSV, ZNAM, ONAM);
    end
end

% The OnControl has an extra " " on the .ZNAM and .ONAM
Family = {'MOD'};
Field  = {'Test', 'Reset'};
for i = 1:length(Family)
    for j = 1:length(Field)
        ZSV = 0;  % No Alarm
        OSV = 0; 
        ZNAM = 'OFF';
        ONAM = 'ON';
        local_epicsdbchange(Family{i}, Field{j}, ZSV, OSV, ZNAM, ONAM);
    end
end


% Modulator channel changes
% Normally on
ChannelNames = {
    'LN______MD1____BM09'  % MD1 DOORS
    'LN______MD1____BM08'  % MD1 AIR
    'LN______MD1____BM07'  % PFN TUBE FIL T/O
    'LN______MD1____BM06'  % KY1 FIL. TIMEOUT
    'LN______MD1____BM05'  % KY1 FOCUS
    'LN______MD1____BM10'  % MD1 GROUND STICK
    'LN______MD1____BM11'  % MD1 LIDS
    'LN______MD1____BM16'  % KY1 OIL LEVEL
    'LN______MD1____BM15'  % MD1 H2O FLOW
    'LN______MD1____BM12'  % START/STOP MON.
    'LN______MD1____BM13'  % START/STOP RDY
    'LN______MD1____BM19'  % EMERGENCY OFF
    'LN______MD1____BM14'  % MD1 H2O TEMP
    'LN______MD1____BM17'  % KY1 ION PUMP
    'LN______MD1_RF_BM04'  % RF TEST READY
    'LN______MD1HV__BM03'  % MD1HV ON MONITOR
    'LN______MD1HV__BM04'  % MD1HV READY
    'LN______MD1INT_BM11'  % LNAS1 WATER TEMP
    'LN______MD1INT_BM09'  % KY1 REV POWER OK
    'LN______MD1INT_BM08'  % LN VVR1 OPEN
    'LN______MD1INT_BM07'  % LN SOLS OK
    'LN______MD1INT_BM10'  % LNAS1 WATER FLOW
    'LN______MD1INT_BM15'  % RADIATION CHAIN
    'LN______MD1INT_BM18'  % MD1HV PERMISSIVE
    'LN______MD1INT_BM14'  % WG BYPASS VALVE
    'LN______MD1INT_BM12'  % LN AS1 VACUUM OK
    'LN______MD1INT_BM06'  % TRIGGER READY
    'LN______MD1INT_BM13'  % WG VACUUM OK
    'LN______MD1INT_BM17'  % P.SAFETY CHAIN B
    'LN______MD1INT_BM19'  % P.SAFETY CHAIN A
    'LN______MD1TRG_BM02'  % TRIGGER ON
    'LN______MD1TRG_BM18'  % TRIGGER READY
    
    'LN______MD2____BM17'  % KY2 ION PUMP
    'LN______MD2____BM12'  % START/STOP MON.
    'LN______MD2____BM13'  % START/STOP RDY
    'LN______MD2____BM19'  % EMERGENCY OFF
    'LN______MD2____BM15'  % MD2 H2O FLOW
    'LN______MD2____BM16'  % KY2 OIL LEVEL
    'LN______MD2____BM10'  % MD2 GROUND STICK
    'LN______MD2____BM14'  % MD2 H2O TEMP
    'LN______MD2____BM06'  % KY2 FIL. TIMEOUT
    'LN______MD2____BM05'  % KY2 FOCUS
    'LN______MD2____BM08'  % MD2 AIR
    'LN______MD2____BM07'  % PFN TUBE FIL T/O
    'LN______MD2____BM11'  % MD2 LIDS
    'LN______MD2____BM09'  % MD2 DOORS
    'LN______MD2_RF_BM04'  % RF TEST READY
    'LN______MD2HV__BM03'  % MD2HV ON MONITOR
    'LN______MD2HV__BM04'  % MD2HV READY
    'LN______MD2INT_BM10'  % LNAS1 WATER FLOW
    'LN______MD2INT_BM12'  % LN AS2 VACUUM OK
    'LN______MD2INT_BM15'  % RADIATION CHAIN
    'LN______MD2INT_BM13'  % START/STOP RDY
    'LN______MD2INT_BM17'  % P. SAFTEY B MON.
    'LN______MD2INT_BM14'  % WG BYPASS VALVE
    'LN______MD2INT_BM19'  % P. SAFETY A MON.
    'LN______MD2INT_BM11'  % LNAS2 WATER TEMP
    'LN______MD2INT_BM09'  % KY2 REV PWR OK
    'LN______MD2INT_BM18'  % MD2HV PERMISSIVE
    'LN______MD2INT_BM08'  % LN VVR1 OPEN
    'LN______MD2INT_BM07'  % LN SOLS OK
    'LN______MD2INT_BM06'  % MOD #2 TRIG RDY
    'LN______MD2TRG_BM02'  % TRIGGER ON
    'LN______MD2TRG_BM18'  % TRIGGER READY
    
    'EG______HV_____BM15'  %HV_RDY_BM1
    'EG______HV_____BM14'  %EG HV ON/OFF MON
    'EG______HV_____BM09'  %GUN_OPERATNL_BM2
    'EG______HV_____BM08'  %HTR_ON_BM2
    'EG______HV_____BM07'  %GTL_VVR1_OPEN_BM
    'EG______HV_____BM06'  %GTL(IP1C+IG1)BM2
    'EG______HV_____BM05'  %HV_ENCLOSURE_BM
    'EG______HV_____BM04'  %P_SAFETY_1_BM
    'EG______HV_____BM03'  %P_SAFETY_2_BM
    
    'EG______AUX____BM13'   %RF Test
    };


ZSV = 2;
OSV = 0;
for k = 1:size(ChannelNames,1)
    Name = deblank(ChannelNames{k});
    try
        ZSVnow  = getpvonline([Name,'.ZSV'] , 'float');
        OSVnow  = getpvonline([Name,'.OSV'] , 'float');
        %ZNAMnow = getpvonline([Name,'.ZNAM']);
        %ONAMnow = getpvonline([Name,'.ONAM']);
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
        %         if ~strcmpi(ZNAMnow, ZNAM)
        %             fprintf('   %s is "%s" should be "%s"\n', [Name,'.ZNAM'], ZNAMnow, ZNAM);
        %             if SetFlag
        %                 setpvonline([Name,'.ZNAM'], ZNAM);
        %             end
        %         end
        %         if ~strcmpi(ONAMnow, ONAM)
        %             fprintf('   %s is "%s" should be "%s"\n', [Name,'.ONAM'], ONAMnow, ONAM);
        %             if SetFlag
        %                 setpvonline([Name,'.ONAM'], ONAM);
        %             end
        %         end
    catch
        fprintf('   %s\n', lasterr);
        fprintf('   Problem configuring the %s dot fields\n', Name);
        %break
    end
end



% Modulator channel changes
% Normally off
ChannelNames = {
    'LN______MD1_RF_BM03'  % bi         OFF            RF TEST MODE
    'LN______MD1_RF_BM02'  % bi         OFF            RF TEST ON
    'LN______MD1FLT_BM00'  % bi         OFF            HV FAULT
    'LN______MD1INT_BM16'  % bi         OFF            E.GUN IN TEST
    'LN______MD1RST_BM05'  % bi         OFF            RESET FAULT    
    'LN______MD2_RF_BM03'  % bi         OFF            RF TEST MODE
    'LN______MD2_RF_BM02'  % bi         OFF            RF TEST ON
    'LN______MD2FLT_BM00'  % bi         OFF            HV FAULT
    'LN______MD2INT_BM16'  % bi         OFF            E.GUN IN TEST
    'LN______MD2RST_BM05'  % bi         OFF            RESET FAULT
    'LN______KY1ARC_BM01'  % KLYSTRON1 ARC MON
    'LN______KY2ARC_BM01'  % KLYSTRON2 ARC MON
    'EG______HV_____BM02'  %HV_LOC_CNTL_BM
    'EG______HV_____BM10'  %GTL_IP1(B)_BM2
    'EG______HV_____BM11'  %GTL_VVR1_CLSD_BM
    'EG______HV_____BM12'  %HTR_OFF_BM
    'EG______HV_____BM13'  %EG HV TEST MON
    };
ZSV = 0;
OSV = 2;
for k = 1:size(ChannelNames,1)
    Name = deblank(ChannelNames{k});
    try
        ZSVnow  = getpvonline([Name,'.ZSV'] , 'float');
        OSVnow  = getpvonline([Name,'.OSV'] , 'float');
        %ZNAMnow = getpvonline([Name,'.ZNAM']);
        %ONAMnow = getpvonline([Name,'.ONAM']);
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
        %         if ~strcmpi(ZNAMnow, ZNAM)
        %             fprintf('   %s is "%s" should be "%s"\n', [Name,'.ZNAM'], ZNAMnow, ZNAM);
        %             if SetFlag
        %                 setpvonline([Name,'.ZNAM'], ZNAM);
        %             end
        %         end
        %         if ~strcmpi(ONAMnow, ONAM)
        %             fprintf('   %s is "%s" should be "%s"\n', [Name,'.ONAM'], ONAMnow, ONAM);
        %             if SetFlag
        %                 setpvonline([Name,'.ONAM'], ONAM);
        %             end
        %         end
    catch
        fprintf('   %s\n', lasterr);
        fprintf('   Problem configuring the %s dot fields\n', Name);
        %break
    end
end



fprintf('   EPICS database changes for the GTB complete\n\n');



function local_epicsdbchange(Family, Field, ZSV, OSV, ZNAM, ONAM)

SetFlag = 1;

% fprintf('   %s.%s.ZSV should be %d\n', Family, Field, ZSV);
% fprintf('   %s.%s.ZNAM should be %s\n', Family, Field, ZNAM);
% fprintf('   %s.%s.ONAM should be %s\n',  Family, Field, ONAM);

ChannelNames = family2channel(Family, Field);

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

