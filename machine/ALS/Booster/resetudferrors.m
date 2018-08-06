function resetudferrors


% Clear RF ramp UDF errors
setpv('li14-40:ENABLE_RAMP.UDF', 0);
setpv('li14-40:SET_TABLE_LEN.UDF', 0);
setpv('li14-40:SET_TABLE_DELAY.UDF', 0);
setpv('li14-40:SWAP_TABLE.UDF', 0);


% SF & SD
setpv('BR1_____SF___REBC00.UDF', 0);
setpv('BR1_____SF___REBM00.UDF', 0);
setpv('BR1_____SF___GNAC00.UDF', 0);

setpv('BR2_____SF___REBC00.UDF', 0);
setpv('BR2_____SF___REBM00.UDF', 0);
setpv('BR2_____SF___GNAC00.UDF', 0);

setpv('BR3_____SF___REBC00.UDF', 0);
setpv('BR3_____SF___REBM00.UDF', 0);
setpv('BR3_____SF___GNAC00.UDF', 0);

setpv('BR4_____SF___REBC00.UDF', 0);
setpv('BR4_____SF___REBM00.UDF', 0);
setpv('BR4_____SF___GNAC00.UDF', 0);

setpv('BR1_____SD___REBC01.UDF', 0);
setpv('BR1_____SD___REBM01.UDF', 0);
setpv('BR1_____SD___GNAC01.UDF', 0);

setpv('BR2_____SD___REBC01.UDF', 0);
setpv('BR2_____SD___REBM01.UDF', 0);
setpv('BR2_____SD___GNAC01.UDF', 0);

setpv('BR3_____SD___REBC01.UDF', 0);
setpv('BR3_____SD___REBM01.UDF', 0);
setpv('BR3_____SD___GNAC01.UDF', 0);

setpv('BR4_____SD___REBC01.UDF', 0);
setpv('BR4_____SD___REBM01.UDF', 0);
setpv('BR4_____SD___GNAC01.UDF', 0);

setpv('B0102-5:ENABLE_RAMP.UDF', 0);
setpv('B0202-5:ENABLE_RAMP.UDF', 0);
setpv('B0302-5:ENABLE_RAMP.UDF', 0);
setpv('B0402-5:ENABLE_RAMP.UDF', 0);

setpv('B0102-5:SET_TABLE_LEN.UDF', 0);
setpv('B0202-5:SET_TABLE_LEN.UDF', 0);
setpv('B0302-5:SET_TABLE_LEN.UDF', 0);
setpv('B0402-5:SET_TABLE_LEN.UDF', 0);

setpv('B0102-5:SET_TABLE_DELAY.UDF', 0);
setpv('B0202-5:SET_TABLE_DELAY.UDF', 0);
setpv('B0302-5:SET_TABLE_DELAY.UDF', 0);
setpv('B0402-5:SET_TABLE_DELAY.UDF', 0);

setpv('B0102-5:SWAP_TABLE.UDF', 0);
setpv('B0202-5:SWAP_TABLE.UDF', 0);
setpv('B0302-5:SWAP_TABLE.UDF', 0);
setpv('B0402-5:SWAP_TABLE.UDF', 0);



%Families = {'HCM', 'VCM', 'BEND', 'SF', 'SD', 'QF','QD'};
Families = {'HCM', 'VCM', 'SF', 'SD', 'QF', 'QD', 'BEND'};

setpv(family2channel('HCM',  'Setpoint'), 'UDF', 0);
setpv(family2channel('VCM',  'Setpoint'), 'UDF', 0);
setpv(family2channel('QF',   'Setpoint'), 'UDF', 0);
%setpv(family2channel('QD',   'Setpoint'), 'UDF', 0);
setpv(family2channel('SF',   'Setpoint'), 'UDF', 0);
setpv(family2channel('SD',   'Setpoint'), 'UDF', 0);
setpv(family2channel('BEND', 'Setpoint'), 'UDF', 0);

setpv(family2channel('HCM',  'OnControl'), 'UDF', 0);
setpv(family2channel('VCM',  'OnControl'), 'UDF', 0);
setpv(family2channel('QF',   'OnControl'), 'UDF', 0);
setpv(family2channel('QD',   'OnControl'), 'UDF', 0);
setpv(family2channel('SF',   'OnControl'), 'UDF', 0);
setpv(family2channel('SD',   'OnControl'), 'UDF', 0);
setpv(family2channel('BEND', 'OnControl'), 'UDF', 0);

% for i = 1:length(Families)
%     %setpv(family2channel(Families{i}, 'Setpoint'),     'UDF', 0);
%     %setpv(family2channel(Families{i}, 'Monitor'),      'UDF', 0);
%     %setpv(family2channel(Families{i}, 'Enable'),     'UDF', 0);
%     %setpv(family2channel(Families{i}, 'TimeConstant'), 'UDF', 0);
%     setpv(family2channel(Families{i}, 'OnControl'),    'UDF', 0);
%     %setpv(family2channel(Families{i}, 'Ready'),        'UDF', 0);
% end

%setpv(family2channel('BPMx', 'Monitor'), 'UDF', 0);
%setpv(family2channel('BPMy', 'Monitor'), 'UDF', 0);


ClearUDFerror('RF');
%setpv(family2channel('RF', 'Setpoint'), 'UDF', 0);
%setpv(family2channel('RF', 'Monitor'), 'UDF', 0);
%setpv(family2channel('RF', 'CavityTemperatureControl'), 'UDF', 0);


UDF_Local('BRTiming', 'Setpoint');


% setpv('Physics1.UDF',  0);
% setpv('Physics2.UDF',  0);
% setpv('Physics3.UDF',  0);
% setpv('Physics4.UDF',  0);
% setpv('Physics5.UDF',  0);
% setpv('Physics6.UDF',  0);
% setpv('Physics7.UDF',  0);
% setpv('Physics8.UDF',  0);
% setpv('Physics9.UDF',  0);
% setpv('Physics10.UDF', 0);


function ClearUDFerror(Family)

AO = getao;

FieldCell = fieldnames(AO.(Family));
for j = 1:length(FieldCell)
    Names = family2channel(Family, FieldCell{j});
    if ~isempty(deblank(Names)) && ~any(strfind(Names(:)','.'))
        try
            setpv(Names, 'UDF', 0);
        catch
            for k = 1:size(Names, 1)
                try
                    Name = deblank(Names(k,:));
                    if ~isempty(Name)
                        setpv(Name, 'UDF', 0);
                    end
                catch
                    fprintf('   Could not set %s.UDF\n', Name);
                end
            end
        end
    end
end


function UDF_Local(Family, Field)
try
    ChanName = family2channel(Family, Field);
    if isempty(ChanName);
        return;
    end
    
    for i = 1:size(ChanName, 1)
        if ~isempty(deblank(ChanName(i,:)))
            UDFString(i,:) = '.UDF';
        else
            UDFString(i,:) = '    ';
        end
    end
    ChanName = [ChanName, UDFString];

    setpv(ChanName, 0);
catch
    fprintf('  Error getting the UDF field for %s.%s\n', Family, Field);
end
