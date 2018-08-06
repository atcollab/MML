function NewRing = sirius_add_multipoles_errors(OldRing, varargin)
%SIRIUS_SET_MULTIPOLES_ERRORS - Set the multipoles errors from excitation curve in PolynomA and PolynomB 
%
%  INPUTS
%  1. THERING
%  2. Family - Family name 
%  3. Field  - Field {Default: 'Setpoint'}
%  4. NewHardwareValue - New setpoint value in hardware units
%  5. DeviceList - [Sector Device #] {Default: whole family}
%
%  OUTPUTS
%  1. THERING 
%
%2015-09-03

Family = '';
Field = '';
NewHardwareValue = [];
DeviceList = [];
if length(varargin) >= 1 && ischar(varargin{1})
    Family = varargin{1};
    varargin(1) = [];
end
if length(varargin) >= 1 && ischar(varargin{1})
    Field = varargin{1};
    varargin(1) = [];
end
if length(varargin) >= 1
    NewHardwareValue = varargin{1};
    varargin(1) = [];
end
if length(varargin) >= 1
    DeviceList = varargin{1};
end
if isempty(Field)
    Field = 'Setpoint';
end
if isempty(DeviceList)
    DeviceList = family2dev(Family);
end

if size(NewHardwareValue,1) ~= size(DeviceList,1)
    
    if size(NewHardwareValue,1) == 1 && size(NewHardwareValue,2) == 1
        NewHardwareValue = ones(size(DeviceList,1),1) * NewHardwareValue;
    
    elseif size(NewHardwareValue,1) == 1 && size(NewHardwareValue,2) == size(DeviceList,1)
        NewHardwareValue = NewHardwareValue.';
    
    else
        error('Setpoint size must equal the device list size or be a scalar.');
    end
end

NewRing = OldRing;
PrevHardwareValue = getpvmodel(Family, Field, DeviceList, 'Hardware');

ExcData        = getfamilydata(Family, 'ExcitationCurves');
MultipolesData = ExcData.multipoles_data;
MainHarmonic   = ExcData.main_harmonic;
Harmonics      = ExcData.harmonics;
Skew           = ExcData.skew; 
Energy         = getenergy;
Brho           = getbrho(Energy);
ElementsIndex  = dev2elem(Family,DeviceList);
ATIndex        = family2atindex(Family, DeviceList);
EffLength      = getleff(Family, DeviceList);
ProfileA       = getfamilydata(Family, 'AT', 'FieldProfileA');
ProfileB       = getfamilydata(Family, 'AT', 'FieldProfileB');

if any(EffLength(:) == 0)
    warning('Multipoles errors not set for %s\n', Family);
else   
    for i=1:size( ElementsIndex, 1)
        idx = ElementsIndex(i);
        Index = ATIndex(i,:);
        
        PrevIntegratedFields  = interp1(MultipolesData{idx}(:,1), MultipolesData{idx}(:, 2:end), PrevHardwareValue(i));
        NewIntegratedFields   = interp1(MultipolesData{idx}(:,1), MultipolesData{idx}(:, 2:end), NewHardwareValue(i));
        DeltaIntegratedFields = NewIntegratedFields - PrevIntegratedFields;
   
        NewRing = set_errors(NewRing, DeltaIntegratedFields, Index, Brho, ProfileA, ProfileB, Harmonics{idx}, MainHarmonic{idx}, Skew{idx});       
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