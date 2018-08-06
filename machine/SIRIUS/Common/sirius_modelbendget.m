function AMPS = sirius_modelbendget(THERING, varargin)
%  SIRIUS_MODELBENDGET - Get the model dipole value
%  AMPS = sirius_modelbendget(THERING, Family, DeviceList)
%  AMPS = sirius_modelbendget(THERING, Family)
%
%  INPUTS
%  1. THERING 
%  2. Family - Family Name
%  3. DeviceList ([Sector Device #]) {Default: whole family}
%
%  OUTPUTS
%  1. AMPS - Model value in hardware units

Family = varargin{1};
varargin(1) = [];
DeviceList = [];
if ~isempty(varargin)
    if ischar(varargin{1})
        % Ignor field name
        varargin(1) = [];
    end
end
if ~isempty(varargin)
    if ismatrix(varargin{1})
        DeviceList = varargin{1};
    end
end

if isempty(DeviceList)
    DeviceList = family2dev(Family);
end
    
ATIndex = family2atindex(Family, DeviceList);
BendingAngle = zeros(size(ATIndex, 1), 1);
for i = 1:size(ATIndex, 1)
    for j = 1:size(ATIndex, 2)
        BendingAngle(i) = BendingAngle(i) + THERING{ATIndex(i,j)}.BendingAngle + THERING{ATIndex(i,j)}.PolynomB(1)*THERING{ATIndex(i,j)}.Length;
    end
end

Brho      = getbrho('Model');
ExcData   = getfamilydata(Family, 'ExcitationCurves');
ElemATIndex = dev2elem(Family, DeviceList);

IntegratedField = - BendingAngle*Brho;
AMPS = zeros(size(ElemATIndex,1),1);
for i=1:size(ElemATIndex,1)
    idx = ElemATIndex(i);
    AMPS(i) = interp1(ExcData.data{idx}(:,2), ExcData.data{idx}(:,1), IntegratedField(i), 'linear', 'extrap');
end

end