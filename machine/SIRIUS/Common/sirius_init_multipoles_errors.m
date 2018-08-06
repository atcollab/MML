function sirius_init_multipoles_errors
%SIRIUS_INIT_MULTIPOLES_ERRORS - Set initial values of the multipoles errors in AT model 
%
%2015-09-03

global THERING;

sirius_set_field_profile;
setfamilydata(1, 'SetMultipolesErrors');
Families = findmemberof('Magnet');

ModeFlag = getmode(deblank(Families{1}));
if strcmpi(ModeFlag, 'Simulator') || strcmpi(ModeFlag,'Model')   
else
    fprintf('\n   WARNING: Multipole errors functions should be used in simulator mode.\n');
    fprintf('   No change made in the model!\n');
    return
end

fprintf('   Setting initial values of multipoles errors.\n');

for l=1:size(Families, 1)
    Family = deblank(Families{l});
    HardwareValue = getpvmodel(Family, 'Hardware');

    ExcData        = getfamilydata(Family, 'ExcitationCurves');
    MultipolesData = ExcData.multipoles_data;
    MainHarmonic   = ExcData.main_harmonic;
    Harmonics      = ExcData.harmonics;
    Skew           = ExcData.skew; 
    Energy         = getenergy;
    Brho           = getbrho(Energy);
    ElementsIndex  = dev2elem(Family);
    ATIndex        = family2atindex(Family);
    EffLength      = getleff(Family);
    ProfileA       = getfamilydata(Family, 'AT', 'FieldProfileA');
    ProfileB       = getfamilydata(Family, 'AT', 'FieldProfileB');

    if any(EffLength(:) == 0)
        warning('Multipoles errors not set for %s\n', Family);
    else
        for i=1:size(ATIndex, 1)
            idx = ElementsIndex(i);
            Index = ATIndex(i,:);
            THERING = delete_errors(THERING, Index, MainHarmonic{idx}, Skew{idx});
            IntegratedFields  = interp1(MultipolesData{idx}(:,1), MultipolesData{idx}(:,2:end), HardwareValue(i));          
            THERING = set_errors(THERING, IntegratedFields, Index, Brho, ProfileA, ProfileB, Harmonics{idx}, MainHarmonic{idx}, Skew{idx});
        end          
    end
end

end


function Ring = delete_errors(Ring, Index, MainHarmonic, Skew)

for i=1:length(Index)
    if isfield(Ring{Index(i)}, 'PolynomA') && isfield(Ring{Index(i)}, 'PolynomB')
        NewPolynomA = zeros(size(Ring{Index(i)}.PolynomA));
        NewPolynomB = zeros(size(Ring{Index(i)}.PolynomB));
        if Skew
            NewPolynomA(MainHarmonic+1) = Ring{Index(i)}.PolynomA(MainHarmonic+1);
        else
            NewPolynomB(MainHarmonic+1) = Ring{Index(i)}.PolynomB(MainHarmonic+1);
        end
        Ring{Index(i)}.PolynomB = NewPolynomB;
        Ring{Index(i)}.PolynomA = NewPolynomA;
    end
    
    if isfield(Ring{Index(i)}, 'CH')
        Ring{Index(i)}.PolynomB(1) = Ring{Index(i)}.CH;
    end
    if isfield(Ring{Index(i)}, 'CV')
        Ring{Index(i)}.PolynomA(1) = Ring{Index(i)}.CV;
    end

    if isfield(Ring{Index(i)}, 'SX')
        Ring{Index(i)}.PolynomB(3) = Ring{Index(i)}.SX;
    end
    
    if isfield(Ring{Index(i)}, 'QS')
        Ring{Index(i)}.PolynomA(2) = Ring{Index(i)}.QS;
    end
    
    if isfield(Ring{Index(i)}, 'K')
        Ring{Index(i)}.K = Ring{Index(i)}.PolynomB(2);
    end
    
end

end


function Ring = set_errors(Ring, IntegratedFields, Index, Brho, ProfileA, ProfileB, Harmonics, MainHarmonic, Skew)

Index = squeeze(Index);
Nsplit = length(Index);
nr_harmonics = Harmonics(end);

IntegratedFieldB = zeros(1, nr_harmonics + 1);
IntegratedFieldA = zeros(1, nr_harmonics + 1);
m = 1;
for k=1:length(Harmonics)
    n = Harmonics(k);
    IntegratedFieldB(n+1) = IntegratedFields(m);
    IntegratedFieldA(n+1) = IntegratedFields(m+1);
    m = m+2;
end               

for j=1:Nsplit
    % resize PolynomB and PolynomA 
    LenA = length(IntegratedFieldA) - length(Ring{Index(j)}.PolynomA);
    LenB = length(IntegratedFieldB) - length(Ring{Index(j)}.PolynomB);
    Ring{Index(j)}.PolynomA = [Ring{Index(j)}.PolynomA, zeros(1,LenA)];
    Ring{Index(j)}.PolynomB = [Ring{Index(j)}.PolynomB, zeros(1,LenB)];     
end 

for j=1:Nsplit
    DeltaPolynomB = ProfileB(j,:).*(-IntegratedFieldB)/(Ring{Index(j)}.Length * Brho);
    DeltaPolynomA = ProfileA(j,:).*(-IntegratedFieldA)/(Ring{Index(j)}.Length * Brho);

    % Don't change the main harmonic value, set only the errors in PolynomA and PolynomB
    if Skew
        DeltaPolynomA(MainHarmonic+1) = 0;
    else
        DeltaPolynomB(MainHarmonic+1) = 0;
    end

    LenA = length(Ring{Index(j)}.PolynomA) - length(DeltaPolynomA); 
    LenB = length(Ring{Index(j)}.PolynomB) - length(DeltaPolynomB);        
    Ring{Index(j)}.PolynomA = Ring{Index(j)}.PolynomA + [DeltaPolynomA, zeros(1,LenA)];   
    Ring{Index(j)}.PolynomB = Ring{Index(j)}.PolynomB + [DeltaPolynomB, zeros(1,LenB)];                      

    LenDiff = length(Ring{Index(j)}.PolynomA) - length(Ring{Index(j)}.PolynomB);
    if LenDiff ~= 0
        Ring{Index(j)}.PolynomA = [Ring{Index(j)}.PolynomA, zeros(1,-LenDiff)];
        Ring{Index(j)}.PolynomB = [Ring{Index(j)}.PolynomB, zeros(1, LenDiff)];
    end

    if isfield(Ring{Index(j)}, 'MaxOrder')
        Ring{Index(j)}.MaxOrder = length(Ring{Index(j)}.PolynomB) - 1;
    end

    if isfield(Ring{Index(j)}, 'K')
        Ring{Index(j)}.K = Ring{Index(j)}.PolynomB(2);
    end
end  

end