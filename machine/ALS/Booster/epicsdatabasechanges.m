function epicsdatabasechanges
% epicsdatabasechanges for the booster ring


% ZSV - Zero Severity
% OSV - One  Severity
% ZNAM - Zero String
% ONAM - One  String


fprintf('\n   Modifying the BR online EPICS database (the "dot" fields) (epicsdatabasechanges.m)\n');


%%%%%%%%%%%%%%%%%%%%%%
% By Channel Changes %
%%%%%%%%%%%%%%%%%%%%%%

% NOTES
% 1. Typical alarm strings: NO_ALARM, MINOR, MAJOR

ChannelCell = {
'BR1_____B_IE___AM00.LOLO', 0.05
'BR1_____B_IE___AM00.LLSV', 'MAJOR'

'R1902.ZRSV', 'MAJOR'

'BR1_____B__PSGNAC00.LOLO', 0.3
'BR1_____B__PSGNAC00.LLSV', 'MAJOR'

'BR1_____QD_PSGNAC00.LOLO', 0.3
'BR1_____QD_PSGNAC00.LLSV', 'MAJOR'

'BR1_____QF_PSGNAC00.LOLO', 0.3
'BR1_____QF_PSGNAC00.LLSV', 'MAJOR'

'BR4_____CLDFLW_AM01.LOW',   0.00  %Girder water flow SR01
'BR4_____CLDFLW_AM01.LOLO',  16.00
'BR4_____CLDFLW_AM01.LSV',  'MINOR'
'BR4_____CLDFLW_AM01.LLSV','MAJOR'
'BR4_____CLDFLW_AM01.HIGH',  24.5
'BR4_____CLDFLW_AM01.HIHI',  25.5
'BR4_____CLDFLW_AM01.HSV',  'MINOR'
'BR4_____CLDFLW_AM01.HHSV', 'MAJOR'
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


fprintf('   EPICS database changes for the booster ring complete\n\n');



function local_epicsdbchange(Family, Field, ZSV, ZNAM, OSV, ONAM)


SetFlag = 1;

% fprintf('   %s.%s.ZSV should be %d\n', Family, Field, ZSV);
% fprintf('   %s.%s.ZNAM should be %s\n', Family, Field, ZNAM);
% fprintf('   %s.%s.ONAM should be %s\n',  Family, Field, ONAM);

if isfamily(Family)
    ChannelNames = family2channel(Family, Field);
else
    ONAM = OSV;
    OSV = ZNAM;
    ZNAM = ZSV;
    ZSV = Field;
    ChannelNames = Family;
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
            
            if ZSVnow ~= ZSV
                fprintf('   %s is %d should be %d\n', [Name,'.ZSV'], ZSVnow, ZSV);
                if SetFlag
                    setpvonline([Name,'.ZSV'], ZSV);
                end
            end
            if OSVnow ~= OSV
                fprintf('   %s is %d should be %d\n', [Name,'.OSV'], OSVnow, OSV);
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
