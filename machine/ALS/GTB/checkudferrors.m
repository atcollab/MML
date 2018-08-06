function checkudferrors

Families = {'HCM','VCM','Q','BEND','SOL'};
Fields = {'Setpoint', 'OnControl', 'Monitor'};  % , 'RampRate', 'TimeConstant', 'Ready', 'Reset'

for i = 1:length(Families)
    for j = 1:length(Fields)
        UDF_Local(Families{i}, Fields{j});
    end
end

UDF_Local('AS', 'Setpoint');
UDF_Local('AS', 'LoopControl');
UDF_Local('TV', 'Setpoint');
UDF_Local('TV', 'Monitor');
UDF_Local('ExtraMachineConfig','Setpoint');
UDF_Local('ExtraControls','Setpoint');



function UDF_Local(Family, Field)
try
    ChanName = family2channel(Family, Field);
    for i = 1:size(ChanName, 1)
        if ~isempty(deblank(ChanName(i,:)))
            UDFString(i,:) = '.UDF';
        else
            UDFString(i,:) = '    ';
        end
    end
    ChanName = [ChanName, UDFString];

    UDF = getpv(ChanName);
    N = sum(UDF);
    if N > 0
        fprintf('  %s.%s has %d UDF errors.\n', Family, Field, N);
    else
        fprintf('  %s.%s OK.\n', Family, Field);
    end
catch
    fprintf('  Error getting the UDF field for %s.%s\n', Family, Field);
end
