function THERING = sirius_modelbendset(THERING, varargin)
%  SIRIUS_MODELBENDSET - Sets the model dipole
%  THERING = sirius_modelbendset(THERING, Family, NewSP_HW, DeviceList)
%  THERING = sirius_modelbendset(THERING, Family, NewSP_HW)
%
%  INPUTS
%  1. THERING 
%  2. Family   - Family Name
%  3. NewSP_HW - Desired values in hardware units 
%  4. DeviceList ([Sector Device #]) {Default: whole family}
%
%  OUTPUTS
%  1. THERING 

Family = varargin{1};
varargin(1) = [];
DeviceList = [];
if ischar(varargin{1})
    % Ignor field name
    varargin(1) = [];
end
if length(varargin) >= 1
    NewSP_HW = varargin{1};
end
if length(varargin) >= 2
    DeviceList = varargin{2};
end

if isempty(DeviceList)
    DeviceList = family2dev(Family);
end

if size(NewSP_HW,1) ~= size(DeviceList,1)
    if size(NewSP_HW,1) == 1 && size(NewSP_HW,2) == 1
        NewSP_HW = ones(size(DeviceList,1),1) * NewSP_HW;
    elseif size(NewSP_HW,1) == 1 && size(NewSP_HW,2) == size(DeviceList,1)
        NewSP_HW = NewSP_HW.';  
    else
        error('Setpoint size must equal the device list size or be a scalar.');
    end
end

ATIndex = family2atindex(Family, DeviceList);
Angle   = zeros(size(ATIndex, 1),1); 
f = zeros(size(ATIndex, 1), size(ATIndex, 2));
for i = 1:size(ATIndex, 1)
    for j = 1:size(ATIndex, 2)
        f(i,j) = THERING{ATIndex(i,j)}.BendingAngle + THERING{ATIndex(i,j)}.PolynomB(1)*THERING{ATIndex(i,j)}.Length;
        Angle(i) = Angle(i) + THERING{ATIndex(i,j)}.BendingAngle;
    end
    f(i,:) = f(i,:)/sum(f(i,:));
end

Brho            = getbrho('Model');
ExcData         = getfamilydata(Family, 'ExcitationCurves');
ElemIndex       = dev2elem(Family, DeviceList);
IntegratedField = zeros(size(ElemIndex,1),1);
for i=1:size(ElemIndex)
    idx = ElemIndex(i);
    IntegratedField(i) = interp1(ExcData.data{idx}(:,1), ExcData.data{idx}(:,2), NewSP_HW(i), 'linear', 'extrap');
end

for i = 1:size(ATIndex, 1)
    for j = 1:size(ATIndex, 2)
        THERING{ATIndex(i,j)}.PolynomB(1) = f(i,j)*((-IntegratedField(i)/Brho) - Angle(i))/THERING{ATIndex(i,j)}.Length;
    end
end

end